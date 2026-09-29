# frozen_string_literal: true

# Compile ```tikz to static SVG at build time (pdflatex + pdf2svg).
# Readers (Chrome included) only see <img> — no client Wasm/IndexedDB.

require "digest"
require "fileutils"
require "open3"
require "tmpdir"

module TikzRender
  module_function

  FENCE_RE = /^```tikz\r?\n(.*?)^```[ \t]*\r?$/m.freeze

  def process(content, site)
    content.gsub(FENCE_RE) do
      source = tidy_source(Regexp.last_match(1))
      next "" if source.empty?

      hash = Digest::SHA256.hexdigest(source)[0, 16]
      rel_svg = "assets/tikz/#{hash}.svg"
      abs_svg = File.join(site.source, rel_svg)

      ensure_svg!(source, abs_svg, hash, site)
      register_static_svg!(site, hash)

      # Same as Obsidian TikZJax: no artificial scale — browser uses SVG
      # intrinsic size (pdf2svg width/height in pt → CSS px via 96dpi).
      base = site.baseurl.to_s.chomp("/")
      src = "#{base}/#{rel_svg}"
      %(<figure class="tikz-figure"><img src="#{src}" alt="TikZ diagram" loading="lazy"></figure>\n\n)
    end
  end

  def register_static_svg!(site, hash)
    dir = "assets/tikz"
    name = "#{hash}.svg"
    rel = "/#{dir}/#{name}"
    return if site.static_files.any? { |f| f.relative_path == rel }

    site.static_files << Jekyll::StaticFile.new(site, site.source, dir, name)
  end

  def tidy_source(source)
    source
      .gsub("\u00a0", "")
      .split("\n")
      .map(&:strip)
      .reject(&:empty?)
      .join("\n")
  end

  def ensure_svg!(source, abs_svg, hash, site)
    return if File.file?(abs_svg) && !File.zero?(abs_svg)

    pdflatex = which("pdflatex")
    pdf2svg = which("pdf2svg")
    unless pdflatex && pdf2svg
      raise Jekyll::Errors::FatalException,
            "TikZ build needs pdflatex and pdf2svg (apt install texlive-latex-extra pdf2svg)."
    end

    FileUtils.mkdir_p(File.dirname(abs_svg))
    tex = wrap_document(source)
    log_path = File.join(site.source, "assets/tikz/#{hash}.log")

    Dir.mktmpdir("jekyll-tikz-") do |tmpdir|
      tex_path = File.join(tmpdir, "diagram.tex")
      pdf_path = File.join(tmpdir, "diagram.pdf")
      File.write(tex_path, tex)

      out, err, status = Open3.capture3(
        pdflatex, "-interaction=nonstopmode", "-halt-on-error",
        "-output-directory", tmpdir, tex_path,
        chdir: tmpdir
      )

      unless status.success? && File.file?(pdf_path)
        File.write(log_path, [out, err].compact.join("\n"))
        raise Jekyll::Errors::FatalException,
              "TikZ compile failed (#{hash}). See #{log_path}"
      end

      svg_tmp = File.join(tmpdir, "diagram.svg")
      out2, err2, status2 = Open3.capture3(pdf2svg, pdf_path, svg_tmp)
      unless status2.success? && File.file?(svg_tmp)
        File.write(log_path, [out, err, out2, err2].compact.join("\n"))
        raise Jekyll::Errors::FatalException,
              "pdf2svg failed (#{hash}). See #{log_path}"
      end

      FileUtils.cp(svg_tmp, abs_svg)
      FileUtils.rm_f(log_path)
      Jekyll.logger.info "TikZ:", "compiled #{File.basename(abs_svg)}"
    end
  end

  def wrap_document(source)
    return source if source.match?(/\\documentclass\b/)

    "\\documentclass[tikz,border=2pt]{standalone}\n#{source}"
  end

  def which(cmd)
    ENV["PATH"].to_s.split(File::PATH_SEPARATOR).each do |dir|
      path = File.join(dir, cmd)
      return path if File.executable?(path)
    end
    nil
  end
end

Jekyll::Hooks.register [:documents, :pages], :pre_render do |item|
  next unless item.respond_to?(:content) && item.content

  ext = item.respond_to?(:extname) ? item.extname : File.extname(item.relative_path.to_s)
  next unless %w[.md .markdown].include?(ext)
  next unless item.content.include?("```tikz")

  item.content = TikzRender.process(item.content, item.site)
end

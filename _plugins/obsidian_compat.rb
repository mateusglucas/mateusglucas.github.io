# frozen_string_literal: true

# Obsidian → Jekyll compatibility (build-time only; notes stay Obsidian-native):
# - blank lines around $$ display math
# - Obsidian callouts >[!info]
# - protect $...$ / $$...$$ (and fences) so GFM does not turn | in sets into tables

module ObsidianCompat
  module_function

  PLACEHOLDER = "XXOBSMATH%dXX".freeze

  def process(content)
    content = convert_callouts(content)
    content = normalize_display_math(content)
    content = protect_math_and_code(content)
    content
  end

  def restore(html)
    return html if Thread.current[:obsidian_math_store].nil?

    store = Thread.current[:obsidian_math_store]
    store.each_with_index do |chunk, i|
      placeholder = format(PLACEHOLDER, i)
      escaped = html_escape_math(chunk)

      # Use block form of gsub: a String replacement treats \ specially and
      # would turn LaTeX \\ line breaks into single \ (breaking align/tags).
      if chunk.lstrip.start_with?("$$")
        html = html.gsub("<p>#{placeholder}</p>") do
          %(<div class="math-display">#{escaped}</div>)
        end
      end
      html = html.gsub(placeholder) { escaped }
    end
    Thread.current[:obsidian_math_store] = nil
    html
  end

  def convert_callouts(content)
    lines = content.split("\n", -1)
    out = []
    i = 0

    while i < lines.length
      if lines[i] =~ /\A>\s*\[!(\w+)\]\s*(.*)\z/
        type = Regexp.last_match(1).downcase
        title = Regexp.last_match(2).strip
        title = type.capitalize if title.empty?

        body_lines = []
        i += 1
        while i < lines.length && lines[i].start_with?(">")
          body_lines << lines[i].sub(/\A>\s?/, "")
          i += 1
        end

        out << ""
        out << %(<aside class="callout callout-#{type}" markdown="1">)
        out << %(<p class="callout-title">#{title}</p>)
        out << ""
        out.concat(body_lines)
        out << ""
        out << "</aside>"
        out << ""
      else
        out << lines[i]
        i += 1
      end
    end

    out.join("\n")
  end

  def normalize_display_math(content)
    lines = content.split("\n", -1)
    out = []
    i = 0
    in_fence = false
    fence_marker = nil

    while i < lines.length
      line = lines[i]
      stripped = line.strip

      if !in_fence && stripped.start_with?("```")
        in_fence = true
        fence_marker = stripped[/^`+/]
        out << line
        i += 1
        next
      elsif in_fence && fence_marker && stripped.start_with?(fence_marker)
        in_fence = false
        fence_marker = nil
        out << line
        i += 1
        next
      end

      if !in_fence && stripped == "$$"
        j = i + 1
        j += 1 while j < lines.length && lines[j].strip != "$$"

        out << "" unless out.empty? || out.last.strip.empty?
        out << lines[i]
        ((i + 1)...j).each { |k| out << lines[k] } if j > i + 1
        out << lines[j] if j < lines.length
        out << ""
        i = j < lines.length ? j + 1 : lines.length
        next
      end

      out << line
      i += 1
    end

    collapsed = []
    blank_run = 0
    out.each do |line|
      if line.strip.empty?
        blank_run += 1
        collapsed << line if blank_run <= 2
      else
        blank_run = 0
        collapsed << line
      end
    end
    collapsed.join("\n")
  end

  def protect_math_and_code(content)
    math_store = []
    code_store = []

    stash_math = lambda do |chunk|
      idx = math_store.length
      math_store << chunk
      format(PLACEHOLDER, idx)
    end

    # Temporarily hide fences so $...$ inside ```tikz is not touched,
    # then put them back so kramdown/TikZ still see real code blocks.
    content = content.gsub(/```[^\n]*\n.*?^```/m) do |m|
      code_store << m
      "XXOBSCODE#{code_store.length - 1}XX"
    end

    content = content.gsub(/\$\$.*?\$\$/m) { |m| stash_math.call(m) }
    content = content.gsub(/(?<!\$)\$(?!\$)(?:\\.|[^$\\])+?\$(?!\$)/) { |m| stash_math.call(m) }

    code_store.each_with_index do |chunk, i|
      content = content.gsub("XXOBSCODE#{i}XX", chunk)
    end

    Thread.current[:obsidian_math_store] = math_store
    content
  end

  def html_escape_math(tex)
    # Only escape HTML tag delimiters. Do NOT escape '&' — align/gather
    # column separators must remain literal '&' for MathJax.
    tex.gsub("<", "&lt;").gsub(">", "&gt;")
  end
end

Jekyll::Hooks.register [:documents, :pages], :pre_render do |item|
  next unless item.respond_to?(:content) && item.content

  ext = item.respond_to?(:extname) ? item.extname : File.extname(item.relative_path.to_s)
  next unless %w[.md .markdown].include?(ext)

  item.content = ObsidianCompat.process(item.content)
end

Jekyll::Hooks.register [:documents, :pages], :post_render do |item|
  next unless item.respond_to?(:output) && item.output

  item.output = ObsidianCompat.restore(item.output)
end

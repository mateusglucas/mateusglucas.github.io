# Needs: pdflatex + pdf2svg (for TikZ at build time)
#   sudo apt-get install -y texlive-latex-extra texlive-pictures pdf2svg

serve:
	bundle exec jekyll serve --port 4500 --host 127.0.0.1

build:
	bundle exec jekyll build

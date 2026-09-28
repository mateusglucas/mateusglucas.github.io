(function () {
  function tidyTikzSource(source) {
    return source
      .replace(/\u00a0/g, "")
      .split("\n")
      .map(function (line) {
        return line.trim();
      })
      .filter(Boolean)
      .join("\n");
  }

  function convertTikzBlocks(root) {
    var nodes = root.querySelectorAll(
      "div.language-tikz pre > code, pre.language-tikz > code, code.language-tikz"
    );

    nodes.forEach(function (code) {
      if (code.dataset.tikzConverted === "true") {
        return;
      }

      var source = tidyTikzSource(code.textContent || "");
      if (!source) {
        return;
      }

      var figure = document.createElement("div");
      figure.className = "tikz-figure";

      var script = document.createElement("script");
      script.type = "text/tikz";
      script.setAttribute("data-show-console", "true");
      script.text = source;

      figure.appendChild(script);

      var pre = code.closest("pre");
      var highlight = pre && pre.parentElement;
      var target =
        highlight && highlight.classList.contains("highlighter-rouge")
          ? highlight
          : pre || code;

      target.replaceWith(figure);
      code.dataset.tikzConverted = "true";
    });
  }

  function run() {
    convertTikzBlocks(document);
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", run);
  } else {
    run();
  }
})();

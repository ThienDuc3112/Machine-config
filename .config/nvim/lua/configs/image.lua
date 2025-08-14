return {
  enabled = true, -- << you must enable it
  formats = {
    "png",
    "jpg",
    "jpeg",
    "gif",
    "bmp",
    "webp",
    "tiff",
    "heic",
    "avif",
    "mp4",
    "mov",
    "avi",
    "mkv",
    "webm",
    "pdf",
  },
  force = false, -- try even if terminal isn’t advertised
  doc = {
    enabled = true,
    inline = true,
    float = true,
    max_width = 80,
    max_height = 40,
    conceal = function(lang, type)
      return type == "math"
    end,
  },
  img_dirs = { "img", "images", "assets", "static", "public", "media", "attachments" },
  wo = {
    wrap = false,
    number = false,
    relativenumber = false,
    cursorcolumn = false,
    signcolumn = "no",
    foldcolumn = "0",
    list = false,
    spell = false,
    statuscolumn = "",
  },
  cache = vim.fn.stdpath "cache" .. "/snacks/image",
  debug = { request = false, convert = false, placement = false },
  env = {},
  icons = { math = "󰪚 ", chart = "󰄧 ", image = " " },
  convert = {
    notify = true,
    magick = {
      default = { "{src}[0]", "-scale", "1920x1080>" },
      vector = { "-density", 192, "{src}[0]" },
      math = { "-density", 192, "{src}[0]", "-trim" },
      pdf = { "-density", 192, "{src}[0]", "-background", "white", "-alpha", "remove", "-trim" },
    },
    mermaid = function()
      local theme = vim.o.background == "light" and "neutral" or "dark"
      return { "-i", "{src}", "-o", "{file}", "-b", "transparent", "-t", theme, "-s", "{scale}" }
    end,
  },
  math = {
    enabled = true,
    typst = {
      tpl = [[
#set page(width: auto, height: auto, margin: (x: 2pt, y: 2pt))
#show math.equation.where(block: false): set text(top-edge: "bounds", bottom-edge: "bounds")
#set text(size: 12pt, fill: rgb("${color}"))
${header}
${content}]],
    },
    latex = {
      font_size = "Large",
      packages = { "amsmath", "amssymb", "amsfonts", "amscd", "mathtools" },
      tpl = [[
\documentclass[preview,border=0pt,varwidth,12pt]{standalone}
\usepackage{${packages}}
\begin{document}
${header}
{ \${font_size} \selectfont
  \color[HTML]{${color}}
${content}}
\end{document}]],
    },
  },
}

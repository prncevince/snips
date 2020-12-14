# adds script to `rmarkdown(output_format=...(lib_dir="path"))` directory
# in an html rmarkdown document & adds script tag to rmarkdown 
options(htmltools.dir.version = FALSE)
htmltools::tagList(
  htmltools::htmlDependency(
    src = "path/to", script = "script.js",
    version = "0.1.0", name = 'script'
  )
)

# writes `.js` files to `.html` files surrounded by script tags
# removes // & /* comments from js
# can then be added via `rmarkdown(output_format=...(lib_dir=list(after_body=list("path.html"))))`
# note: used inside GNU Make
library(htmltools)
s <- trimws(
  gsub('\\/\\*.*?\\*\\/|([^\\:]|^)\\/\\/.*$', '', readLines('$<', warn = F, skipNul = T))
)
s <- s[s != '']
write(as.character(tags$script(HTML(paste0(s, collapse = '\n')))), '$@')

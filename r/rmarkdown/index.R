library(htmltools)
library(magrittr)
library(rvest)
library(xml2)

# saves html page to relative directory
# manually sets 'libdir' to share widget dependencies with those of rmarkdown::html_document `lib_dir` (sets same path)
# required: file path of html page
# optional: title of HTML page, self contained, background color, library directory
createIndex <- function(file = 'index.html', title = NULL, selfcontained = FALSE, background = 'white', libdir = 'public/libs') {
  if (grepl("^#", background, perl = TRUE)) {
    bgcol <- grDevices::col2rgb(background, perl = TRUE)
    background <- sprintf(
      "rgba(%d,%d,%d,%f)", bgcol[1,1], bgcol[2,1], bgcol[3,1], bgcol[4,1]/255
    )
  }
  ###
  # here, you could create a fun page w/ css, js, etc.
  # like in widgets.R for the htmlwidget `htmlwidgets::toHTML` call
  ###
  node_doc <- minimal_html(title = title, html = tags$body())
  node_list <- listFiles('.', 'Rmd')
  node_doc %>% html_node('body') %>% xml_add_child(node_list)
  if (is.null(libdir)) {
    libdir <- paste(tools::file_path_sans_ext(basename(file)), '_files', sep = '')
  }
  write_html(node_doc, file = file)
}

listFiles <- function(path = '.', ext = c('Rmd', 'html')) {
  files <- unlist(lapply(strsplit(grep(paste0('\\.', ext), list.files(path), value = T), '\\.'), `[[`, 1))
  files <- paste0(files, '.html')
  node_doc <- read_html(as.character(tags$div(tags$ul())))
  for (i in files) {
    doc_li_node <- read_html(as.character(tags$li(tags$a(i, href = i))))
    li_node <- doc_li_node %>% html_node('li')
    node_doc %>% html_node('ul') %>% xml_add_child(li_node)
  }
  node_list <- node_doc %>% html_node('div')
  return(node_list)
}

createIndex('docs/index.html', title = '')

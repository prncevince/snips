# ```{r setup, echo=FALSE}
library(kableExtra)
library(knitr)

knitr::opts_chunk$set(
  results='hold', collapse = FALSE, max.print=8
)

print.me <- function(x, ...) {
  x %>% head(8) %>% kbl(escape = FALSE) %>%
    kable_styling(
      bootstrap_options = c("striped", "hover", "responsive", "condensed"),
      full_width = FALSE, font_size = 12, html_font = 'helvetica'
    ) %>%
    row_spec(row = 0, font_size = 12) %>%
    scroll_box(width = "100%", height = "350px", fixed_thead = TRUE) %>%
    asis_output()
}

registerS3method("knit_print", "data.frame", print.me)
# ````
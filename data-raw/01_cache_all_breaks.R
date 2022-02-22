library(fs)
library(httr2)
library(pins)
library(rvest)
library(glue)
library(tibble)
devtools::load_all()

enframe_country_spot <- function(html) {
  country <- html %>%
    html_elements(".rem") %>%
    html_text2()
  spot <- html %>%
    html_elements(".list_table a") %>%
    html_text2()

  url <- html %>%
    html_elements(".list_table") %>%
    html_elements("a") %>%
    html_attr("href")

  tibble(country, spot, url)
}

request_breaks_page <- function(req, n) {
  req %>%
    req_url_path_append("breaks") %>%
    req_url_query(page = n)
}

cache_breaks_page <- function(n) {
  breaks_req <- request(base_url()) %>%
    request_breaks_page(n = n) %>%
    req_user_agent("surfcast (https://github.com/maurolepore/surfcast)")

  breaks_resp <- breaks_req %>% req_perform()
  breaks_htlm <- breaks_resp %>% resp_body_html()
  breaks_data <- enframe_country_spot(breaks_htlm)
  is_valid_page <- !identical(nrow(breaks_data), 0L)

  board <- board_folder(fs::dir_create(data_raw("cache_pins")))

  if (is_valid_page) {
    pin_write(board, breaks_resp, glue("breaks_{n}"), type = "qs")
    pin_write(board, breaks_data, glue("country_spot_{n}"), type = "qs")
  }

  invisible(is_valid_page)
}

cache_all_breaks <- function() {
  is_valid <- TRUE
  i <- 1L
  while (is_valid) {
    is_valid <- cache_breaks_page(i)
    i <- i + 1L
  }
}

cache_all_breaks()

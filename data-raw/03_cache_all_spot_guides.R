library(progress)
library(httr2)
library(fs)
library(pins)
library(dplyr)
library(progress)
devtools::load_all()

cache_spot_guide <- function(url) {
  req_spot <- request(base_url()) %>%
    req_url_path_append(url) %>%
    req_user_agent("surfcast (https://github.com/maurolepore/surfcast)")

  resp_spot <- req_spot %>% req_perform()

  board <- board_folder(dir_create(data_raw("cache_pins")))
  path <- paste0("spot_guide_", path_file(url))
  board %>% pin_write(resp_spot, path, type = "qs")
}

cache_all_spot_guides <- function() {
  urls <- country_spot %>%
    filter(country %in% supported_countries()) %>%
    pull(url)

  pb <- progress_bar$new(total = length(urls))
  for (i in seq_along(urls)) {
    pb$tick()
    message(urls[[i]])
    try(cache_spot_guide(urls[[i]]))
  }
}

cache_all_spot_guides()

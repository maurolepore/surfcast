library(tidyr)
library(rvest)
library(tibble)
library(purrr)
library(dplyr)
library(janitor)
library(fs)
library(pins)
library(httr2)
devtools::load_all()

scrape_info <- function(html) {
  info <- html %>%
    html_elements("tbody") %>%
    html_elements("tr") %>%
    html_elements("td") %>%
    html_text2()

  tibble(type = info[[1]], rating = info[[2]], reliability = info[[3]])
}

scrape_best_surf <- function(html) {
  best_surf <- html %>%
    html_elements(".guide-header__best-surf") %>%
    html_text2()
  tibble(best_surf)
}

scrape_best_time <- function(html) {
  best_time <- html %>%
    html_elements(".guide-page__best-month") %>%
    html_text2()
  best_month <- gsub("(.*)(Best Season: )(.*)", "\\1", best_time)
  best_season <- gsub("(.*)(Best Season: )(.*)", "\\3", best_time)
  tibble(best_month, best_season)
}

scrape_best_stats <- function(html) {
  spot_stats <- html %>%
    html_elements(".guide-page__surfinfo") %>%
    html_text2() %>%
    strsplit("\n")

  condition <- spot_stats %>%
    map(1) %>%
    map_chr(janitor::make_clean_names)
  percent <- spot_stats %>%
    map(2) %>%
    map(~ gsub("%", "", .x)) %>%
    as.integer()

  tibble(condition, percent) %>%
    pivot_wider(names_from = condition, values_from = percent)
}

best_data <- function(resp_spot, .spot) {
  html_spot <- resp_body_html(resp_spot)

  bind_cols(
    scrape_best_stats(html_spot),
    scrape_best_time(html_spot),
    scrape_info(html_spot),
    scrape_best_surf(html_spot)
  ) %>%
    mutate(spot = .spot) %>%
    relocate(spot)
}

board <- board_folder(dir_create(data_raw("cache_pins")))
pin_names <- path_file(dir_ls(board$path, regexp = "spot_guide_"))
resp_spots <- map(pin_names, ~ pins::pin_read(board, .x))
# Or
# path <- data_raw("best_conditions_resp_spots.qs")
# qs::qsave(resp_spots, path)
# resp_spots <- qs::qread(path)

best_cond <- rlang::set_names(as.list(pin_names))
pb <- progress::progress_bar$new(total = length(best_cond))
for (i in seq_along(pin_names)) {
  pb$tick()
  message(pin_names[[i]])
  best_cond[[i]] <- best_data(
    resp_spots[[i]],
    gsub("spot_guide_", "", pin_names)[[i]]
  )
}
best_conditions <- map_df(best_cond, identity, .id = "id")

qs::qsave(best_conditions, data_raw("best_conditions.qs"))

supported_spots <- country_spot %>%
  sanitize_spot() %>%
  filter(country %in% supported_countries()) %>%
  mutate(id = path_file(url)) %>%
  select(-.data$url, -.data$page)

best_conditions <- best_conditions %>%
  mutate(id = gsub("spot_guide_", "", .data$id)) %>%
  select(-.data$spot)

best_conditions <- left_join(supported_spots, best_conditions, by = "id")

best_conditions <- best_conditions %>%
  mutate(best_swell = gsub(".* ([^ ]+) swell.*", "\\1", best_surf)) %>%
  mutate(best_wind = gsub(".* (.*)[.]", "\\1", best_surf)) %>%
  select(-best_surf)

best_conditions <- best_conditions %>%
  mutate(best_month = factor(best_month, levels = tolower(month.name))) %>%
  arrange(country, best_month, spot) %>%
  select(-spot) %>%
  relocate(
    id,
    country,
    best_month,
    best_swell,
    best_wind,
    rating,
    clean,
    blown_out,
    too_small,
    reliability,
    type
  )

# FIXME
best_conditions <- best_conditions %>% filter(!is.na(type))

best_conditions <- best_conditions %>%
  mutate(across(where(is.character), tolower)) %>%
  mutate(reliability = forcats::fct_reorder(reliability, clean, mean)) %>%
  mutate(reliability = factor(reliability, ordered = TRUE)) %>%
  mutate(best_month = factor(best_month, ordered = TRUE)) %>%
  mutate(rating = as.double(rating)) %>%
  select(-best_season)

best_conditions <- best_conditions %>%
  mutate(region = tolower(countrycode::countrycode(
    country, "country.name", "region"
  ))) %>%
  mutate(continent = tolower(countrycode::countrycode(
    country, "country.name", "continent"
  ))) %>%
  rename(spot = id)

usethis::use_data(best_conditions, overwrite = TRUE)

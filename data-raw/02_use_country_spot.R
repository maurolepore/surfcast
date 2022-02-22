library(fs)
library(pins)
library(purrr)
library(usethis)
devtools::load_all()

board <- board_folder(data_raw("cache_pins"))
pin_names <- path_file(dir_ls(board$path, regexp = "country_spot_"))

country_spot <- pin_names %>%
  map_df(~ pin_read(board, .x), .id = "page") %>%
  sanitize_spot()

use_data(country_spot, overwrite = TRUE)

show_supported_countries <- function() {
  p("Supported countries: ", paste(supported_countries(), collapse = ", "))
}

show_details_url <- function() {
  p("Details: ", surfcast_url())
}

supported_countries <- function() {
  out <- c(
    "Argentina",
    "Brazil",
    "Costa Rica",
    "Nicaragua",
    "Uruguay",
    "United States",
    "Portugal",
    "Australia",
    "Chile",
    "El Salvador",
    "Indonesia",
    "Ecuador",
    "Mexico",
    "Peru",
    "Spain",
    "France",
    "Puerto Rico",
    "Maldives",
    "Philippines",
    "Micronesia",
    "French Polynesia",
    "New Zealand",
    "Fiji",
    "Thailand",
    "Panama",
    "Colombia",
    "Italy",
    "Greece",
    "Croatia"
  )

  sort(out)
}

base_url <- function() {
  "https://www.surf-forecast.com"
}

data_raw <- function(...) {
  here::here("data-raw", ...)
}

sanitize_spot <- function(data) {
  data %>%
    dplyr::mutate(
      spot = gsub("\\(.*$", "", .data$spot),
      spot = trimws(.data$spot),
      spot = gsub(" ", "-", .data$spot)
    )
}

surfcast_url <- function() {
  a(
    "https://www.surf-forecast.com/breaks/",
    href = "https://www.surf-forecast.com/breaks/"
  )
}

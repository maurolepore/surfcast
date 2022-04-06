
<!-- README.md is generated from README.Rmd. Please edit that file -->

# surfcast

<!-- badges: start -->
<!-- badges: end -->

The surfcast package and
[app](https://maurolepore.shinyapps.io/surfcast/) make it easy to find
the best place to surf during a given season or month. The data comes
from <https://www.surf-forecast.com/>.

## Installation

You can install the development version of surfcast with:

``` r
# install.packages("devtools")
devtools::install_github("maurolepore/surfcast")
```

## Example

Use the database [online](https://maurolepore.shinyapps.io/surfcast/).
You may also access the data via a shiny app or directly in R.

``` r
library(surfcast)
library(dplyr, warn.conflicts = FALSE)
```

``` r
run_app()
```

``` r
best_conditions
#> # A tibble: 4,698 × 13
#>    country   spot  type  best_season best_month best_swell best_wind reliability
#>    <chr>     <chr> <chr> <chr>       <fct>      <chr>      <chr>     <chr>      
#>  1 Argentina Alfo… Beach winter      january    East       West      inconsiste…
#>  2 Argentina Biol… Point summer      january    Northeast  West-nor… very consi…
#>  3 Argentina Cabo… Beac… summer      january    North-nor… South-so… fairly con…
#>  4 Argentina La-P… Beach winter      january    East       West      fairly con…
#>  5 Argentina La-V… Beac… winter      january    Northwest  South     consistent 
#>  6 Argentina Yacht Point summer      january    Northeast  West-nor… consistent 
#>  7 Argentina Hori… Point autumn      february   South-sou… North-no… very consi…
#>  8 Argentina Maqu… Point autumn      february   South-sou… North-no… very consi…
#>  9 Argentina Mont… Beach autumn      march      South-sou… North     consistent 
#> 10 Argentina Queq… Beach autumn      april      South      North-no… fairly con…
#> # … with 4,688 more rows, and 5 more variables: rating <chr>, clean <int>,
#> #   blown_out <int>, too_small <int>, id <chr>
```

``` r
best_conditions %>% 
  distinct(country) %>% 
  pull()
#>  [1] "Argentina"        "Australia"        "Brazil"           "Chile"           
#>  [5] "Colombia"         "Costa Rica"       "Ecuador"          "El Salvador"     
#>  [9] "Fiji"             "France"           "French Polynesia" "Indonesia"       
#> [13] "Maldives"         "Mexico"           "Micronesia"       "New Zealand"     
#> [17] "Nicaragua"        "Panama"           "Peru"             "Philippines"     
#> [21] "Portugal"         "Puerto Rico"      "Thailand"         "United States"   
#> [25] "Uruguay"
```

### I’m in Argentina. Where should I go surfing today?

-   Today the swell is NE.
-   Today the wind is NW.

``` r
ne <- "north|east"
nw <- "north|west"
# Not
sw <- "south|west"
se <- "south|east"

best_conditions %>%
  filter(country == "Argentina") %>% 
  filter(grepl(ne, tolower(best_swell))) %>%
  filter(!grepl(sw, tolower(best_swell))) %>%
  filter(grepl(nw, tolower(best_wind))) %>% 
  filter(!grepl(se, tolower(best_wind))) %>% 
  select(spot, best_swell, best_wind, type, rating)
#> # A tibble: 9 × 5
#>   spot                  best_swell best_wind      type           rating
#>   <chr>                 <chr>      <chr>          <chr>          <chr> 
#> 1 Alfonsina             East       West           Beach          ""    
#> 2 Biologia              Northeast  West-northwest Point          "3.9" 
#> 3 La-Perla              East       West           Beach          "3.8" 
#> 4 Yacht                 Northeast  West-northwest Point          "3.2" 
#> 5 Pinamar               East       West-northwest Beach          "3.6" 
#> 6 Constitucion          East       West           Beach          ""    
#> 7 Mar-de-Ajó            East       West           Beach          "3.1" 
#> 8 Bajada-de-los-Palitos East       West-northwest Beach and reef ""    
#> 9 Rada-Tilly            East       West-northwest Beach          "3.4"
```

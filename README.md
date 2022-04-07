
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
#>    spot           country best_month best_swell best_wind rating clean blown_out
#>    <chr>          <chr>   <ord>      <chr>      <chr>      <dbl> <int>     <int>
#>  1 alfonsina      argent… january    east       west        NA       0         1
#>  2 biologia       argent… january    northeast  west-nor…    3.9    12        28
#>  3 cabo-raso      argent… january    north-nor… south-so…   NA      11        28
#>  4 la-perla-1-ma… argent… january    east       west         3.8     0         1
#>  5 la-virazon     argent… january    northwest  south       NA       0         1
#>  6 yacht          argent… january    northeast  west-nor…    3.2    12        28
#>  7 horizonte      argent… february   south-sou… north-no…    4.1    27        33
#>  8 maquinita      argent… february   south-sou… north-no…    4      27        33
#>  9 monte-hermoso… argent… march      south-sou… north        3.2    15        32
#> 10 quequen        argent… april      south      north-no…   NA      26        41
#> # … with 4,688 more rows, and 5 more variables: too_small <int>,
#> #   reliability <ord>, type <chr>, region <chr>, continent <chr>
```

``` r
best_conditions %>% 
  distinct(country) %>% 
  pull()
#>  [1] "argentina"        "australia"        "brazil"           "chile"           
#>  [5] "colombia"         "costa rica"       "ecuador"          "el salvador"     
#>  [9] "fiji"             "france"           "french polynesia" "indonesia"       
#> [13] "maldives"         "mexico"           "micronesia"       "new zealand"     
#> [17] "nicaragua"        "panama"           "peru"             "philippines"     
#> [21] "portugal"         "puerto rico"      "thailand"         "united states"   
#> [25] "uruguay"
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
  filter(country == "argentina") %>% 
  filter(grepl(ne, tolower(best_swell))) %>%
  filter(!grepl(sw, tolower(best_swell))) %>%
  filter(grepl(nw, tolower(best_wind))) %>% 
  filter(!grepl(se, tolower(best_wind))) %>% 
  select(spot, best_swell, best_wind, type, rating)
#> # A tibble: 9 × 5
#>   spot                     best_swell best_wind      type           rating
#>   <chr>                    <chr>      <chr>          <chr>           <dbl>
#> 1 alfonsina                east       west           beach            NA  
#> 2 biologia                 northeast  west-northwest point             3.9
#> 3 la-perla-1-mar-del-plata east       west           beach             3.8
#> 4 yacht                    northeast  west-northwest point             3.2
#> 5 pinamar                  east       west-northwest beach             3.6
#> 6 constitucion             east       west           beach            NA  
#> 7 mar-de-ajo               east       west           beach             3.1
#> 8 bajada-de-los-palitos    east       west-northwest beach and reef   NA  
#> 9 rada-tilly               east       west-northwest beach             3.4
```

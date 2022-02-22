
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
library(tibble)

if (interactive()) run_app()

unique(best_conditions$country)
#> [1] "Argentina"     "Brazil"        "Costa Rica"    "Nicaragua"    
#> [5] "Portugal"      "United States" "Uruguay"

best_conditions
#> # A tibble: 2,185 × 11
#>    country spot  type  best_season best_month reliability rating clean blown_out
#>    <chr>   <chr> <chr> <chr>       <fct>      <chr>       <chr>  <int>     <int>
#>  1 Argent… Alfo… Beach winter      january    inconsiste… ""         0         1
#>  2 Argent… Biol… Point summer      january    very consi… "3.9"     12        28
#>  3 Argent… Cabo… Beac… summer      january    fairly con… ""        11        28
#>  4 Argent… La-P… Beach winter      january    fairly con… "3.8"      0         1
#>  5 Argent… La-V… Beac… winter      january    consistent  ""         0         1
#>  6 Argent… Yacht Point summer      january    consistent  "3.2"     12        28
#>  7 Argent… Hori… Point autumn      february   very consi… "4.1"     27        33
#>  8 Argent… Maqu… Point autumn      february   very consi… "4.0"     27        33
#>  9 Argent… Mont… Beach autumn      march      consistent  "3.2"     15        32
#> 10 Argent… Queq… Beach autumn      april      fairly con… ""        26        41
#> # … with 2,175 more rows, and 2 more variables: too_small <int>, id <chr>
```


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
library(dplyr, warn.conflicts = FALSE)
library(glue)
library(surfcast)
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
  filter(!grepl(se, tolower(best_wind)))
#> # A tibble: 9 × 13
#>   spot  country best_month best_swell best_wind rating clean blown_out too_small
#>   <chr> <chr>   <ord>      <chr>      <chr>      <dbl> <int>     <int>     <int>
#> 1 alfo… argent… january    east       west        NA       0         1        99
#> 2 biol… argent… january    northeast  west-nor…    3.9    12        28        60
#> 3 la-p… argent… january    east       west         3.8     0         1        99
#> 4 yacht argent… january    northeast  west-nor…    3.2    12        28        60
#> 5 pina… argent… june       east       west-nor…    3.6    33        32        35
#> 6 cons… argent… july       east       west        NA       4         6        90
#> 7 mar-… argent… july       east       west         3.1    12        28        60
#> 8 baja… argent… september  east       west-nor…   NA      31        25        44
#> 9 rada… argent… september  east       west-nor…    3.4    31        25        44
#> # … with 4 more variables: reliability <ord>, type <chr>, region <chr>,
#> #   continent <chr>
```

### I’m going to Chile in July. Should I take my surfboard?

Most spots that work best in July are close to Santiago, one North near
Antofagasta, and one South near Pichilemu. With a 4.3 a 2-h session
should feel from okay (near Antofagasta) to uncomfortable but doable
(all other spots).

La Portada (near Antofagasta):

-   Average water temperature in July: [15.6
    C](https://www.seatemperature.org/south-america/chile/antofagasta-july.htm)
    on average.
-   Probability of clean conditions: 20%.

Punta de Lobos (near Pichilemu):

-   Average water temperature in july: [13.1
    C](https://www.seatemperature.org/south-america/chile/pichilemu.htm).
-   Probability of clean conditions: 30%.

Other spots (near Viña del Mar)

-   Average water temperature in July:
    [13.1](https://www.seatemperature.org/south-america/chile/pichilemu.htm)

-   Probability of clean conditions: 20%-70%

–

-   Which spots work best in July?

<!-- -->

    #> # A tibble: 5 × 3
    #>   spot            type           rating
    #>   <chr>           <chr>           <dbl>
    #> 1 la-boca-con-con beach             3.2
    #> 2 la-portada      point             3.7
    #> 3 playa-amarilla  beach             3.2
    #> 4 puntade-lobos   reef and point    3.9
    #> 5 renaca          beach             3.3

-   How do they rank?

(The top spot gives me maximum probability of having clean surf, that
isn’t too small)

    #> # A tibble: 5 × 4
    #>   spot            clean blown_out too_small
    #>   <chr>           <int>     <int>     <int>
    #> 1 la-boca-con-con    68        28         4
    #> 2 puntade-lobos      29        69         2
    #> 3 renaca             25        74         1
    #> 4 playa-amarilla     20        64        16
    #> 5 la-portada         19        81         0

For details see these pages:

<https://www.surf-forecast.com/breaks/la-boca-con-con>

<https://www.surf-forecast.com/breaks/la-portada>

<https://www.surf-forecast.com/breaks/playa-amarilla>

<https://www.surf-forecast.com/breaks/puntade-lobos>

<https://www.surf-forecast.com/breaks/renaca>

–

What spots work best in June and August? (Maybe they’re worth checking
too)

    #> # A tibble: 9 × 7
    #>   spot          best_month clean blown_out too_small type  rating
    #>   <chr>         <ord>      <int>     <int>     <int> <chr>  <dbl>
    #> 1 las-salinas_1 june          55        22        23 point    3.3
    #> 2 puertecillo   june          35        64         1 point   NA  
    #> 3 punta-aguila  august        24        76         0 point    3.5
    #> 4 choralillo    june          19        81         0 point    3.5
    #> 5 cordeles      june          18        82         0 beach    3.8
    #> 6 caleta-loa    june          14        86         0 beach    3.5
    #> 7 hornitos      june          12        57        31 beach    3.4
    #> 8 pozo-verde    june          12        57        31 point    3.3
    #> 9 ovahe         august         1         3        96 beach    3.5

# yield the expected snapshot

    Code
      best_conditions
    Output
      # A tibble: 4,698 x 13
         spot           country best_month best_swell best_wind rating clean blown_out
         <chr>          <chr>   <ord>      <chr>      <chr>      <dbl> <int>     <int>
       1 alfonsina      argent~ january    east       west        NA       0         1
       2 biologia       argent~ january    northeast  west-nor~    3.9    12        28
       3 cabo-raso      argent~ january    north-nor~ south-so~   NA      11        28
       4 la-perla-1-ma~ argent~ january    east       west         3.8     0         1
       5 la-virazon     argent~ january    northwest  south       NA       0         1
       6 yacht          argent~ january    northeast  west-nor~    3.2    12        28
       7 horizonte      argent~ february   south-sou~ north-no~    4.1    27        33
       8 maquinita      argent~ february   south-sou~ north-no~    4      27        33
       9 monte-hermoso~ argent~ march      south-sou~ north        3.2    15        32
      10 quequen        argent~ april      south      north-no~   NA      26        41
      # ... with 4,688 more rows, and 5 more variables: too_small <int>,
      #   reliability <ord>, type <chr>, region <chr>, continent <chr>


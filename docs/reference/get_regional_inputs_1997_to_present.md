# Return raw flu surveillance data for a specific WHO region

Load and return a tibble containing raw influenza surveillance data,
aggregated across all countries in the WHO region of interest. Data are
from [WHO FluNet](https://www.who.int/tools/flunet).

## Usage

``` r
get_regional_inputs_1997_to_present(region, max_year)
```

## Arguments

- region:

  name of WHO region. Run
  [`show_available_regions()`](https://cobeylab.github.io/imprinting/reference/show_available_regions.md)
  for a list of options.

- max_year:

  results will be output for all available years up to `max_year`.

## Value

A tibble with the following columns:

- `WHOREGION`: name of WHO region.

- `Year`: year of surveillance. Weeks are assigned to years following
  ISO 8601 week numbering.

- `n_H1N1`, `n_H2N2`, `n_H3N2`: number of influenza specimens that
  tested positive for each influenza A subtype.

- `n_A`: total specimens positive for influenza A (= `n_H1N1` +
  `n_H2N2` + `n_H3N2`).

- `n_BYam`, `n_BVic`: number of specimens positive for each lineage of
  influenza B: Victoria or Yamagata.

- `n_B`: total specimens positive for influenza B.

- `n_processed`: total specimens processed.

## Details

Regional totals include all countries and areas that WHO FluNet assigns
to the region. See
[`get_WHO_region()`](https://cobeylab.github.io/imprinting/reference/get_WHO_region.md)
for a note on Indonesia, whose reassignment to the Western Pacific
region changes the South-East Asia and Western Pacific totals from 2004
on relative to package versions before 0.2.0.

## Examples

``` r
get_regional_inputs_1997_to_present("americas", 2017)
#> # A tibble: 29 × 9
#>    WHOREGION            Year n_H1N1 n_H3N2   n_A n_BYam n_BVic   n_B n_processed
#>    <chr>               <dbl>  <dbl>  <dbl> <dbl>  <dbl>  <dbl> <dbl>       <dbl>
#>  1 Region of the Amer…  1997     16   1068  1084      0      0     0       21898
#>  2 Region of the Amer…  1998     19    670   689      0      0     0       43896
#>  3 Region of the Amer…  1999     93   5987  6080      0      0     0      138107
#>  4 Region of the Amer…  2000    862   1512  2374      0      0     0      119574
#>  5 Region of the Amer…  2001   1505   1125  2630      0      0     0      137455
#>  6 Region of the Amer…  2002    375   4364  4739      0      0     0      202359
#>  7 Region of the Amer…  2003   2565   7875 10440      0      0     0      279035
#>  8 Region of the Amer…  2004     88   3212  3300      0      0     0      180795
#>  9 Region of the Amer…  2005    202   7173  7375      0      0     0      231649
#> 10 Region of the Amer…  2006   1643   4241  5884      0      0     0      229234
#> # ℹ 19 more rows
```

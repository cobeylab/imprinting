# Return raw flu surveillance data for a specific country

Load and return a tibble containing raw influenza surveillance data for
the country of interest. Data are from [WHO
FluNet](https://www.who.int/tools/flunet).

## Usage

``` r
get_country_inputs_1997_to_present(country, max_year)
```

## Arguments

- country:

  name of country. Run
  [`show_available_countries()`](https://cobeylab.github.io/imprinting/reference/show_available_countries.md)
  for a list of options.

- max_year:

  results will be output for all available years up to `max_year`.

## Value

A tibble with the following columns:

- `Country`: name of country

- `Year`: year of surveillance. Weeks are assigned to years following
  ISO 8601 week numbering.

- `n_processed`: total specimens processed

## Examples

``` r
get_country_inputs_1997_to_present("Aruba", 1998)
#> # A tibble: 2 × 9
#>   Country  Year n_H1N1 n_H3N2   n_A n_BYam n_BVic   n_B n_processed
#>   <chr>   <dbl>  <dbl>  <dbl> <dbl>  <dbl>  <dbl> <dbl>       <dbl>
#> 1 Aruba    1997      0      0     0      0      0     0           0
#> 2 Aruba    1998      0      0     0      0      0     0           0
get_country_inputs_1997_to_present("Honduras", 2025)
#> # A tibble: 29 × 9
#>    Country   Year n_H1N1 n_H3N2   n_A n_BYam n_BVic   n_B n_processed
#>    <chr>    <dbl>  <dbl>  <dbl> <dbl>  <dbl>  <dbl> <dbl>       <dbl>
#>  1 Honduras  1997      0      0     0      0      0     0           0
#>  2 Honduras  1998      0      0     0      0      0     0           0
#>  3 Honduras  1999      0      0     0      0      0     0           0
#>  4 Honduras  2000      0      0     0      0      0     0           0
#>  5 Honduras  2001      0      0     0      0      0     0           0
#>  6 Honduras  2002      0      0     0      0      0     0           0
#>  7 Honduras  2003      0      0     0      0      0     0           0
#>  8 Honduras  2004      0      0     0      0      0     0           0
#>  9 Honduras  2005      0      0     0      0      0     0           0
#> 10 Honduras  2006      0      0     0      0      0     0           0
#> # ℹ 19 more rows
```

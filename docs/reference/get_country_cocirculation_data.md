# Get data on the relative circulation of each influenza A subtype

`get_country_cocirculation_data()` imports data on the fraction of
influenza A cases in a specific country and year that were caused by
each influenza A subtype (H1N1, H2N2, or H3N2), or group (group 1 or
group 2). Group 1 contains H1N1 and H2N2, and group 2 contains H2N2.

## Usage

``` r
get_country_cocirculation_data(
  country,
  max_year,
  min_samples = 30,
  output_format = "tibble"
)
```

## Arguments

- country:

  country of interest. Run
  [`show_available_countries()`](https://cobeylab.github.io/imprinting/reference/show_available_countries.md)
  for a list of valid inputs.

- max_year:

  last year of interest. Results will be generated from 1918:max_year.

- min_samples:

  if fewer than `min_samples` (default 30) are reported in the country
  and year of interest, the function will substitute data from the
  corresponding WHO region.

- output_format:

  can be 'tibble' (the default) or 'matrix' (used mainly for convenience
  within other functions)

## Value

A matrix with rows showing the calendar year, the fraction of influenza
A-positive specimens of each subtype (rows `A/H1N1`, `A/H2N2`, and
`A/H3N2`), and of each HA group (rows `group 1`, and `group 2`). Row `A`
should always be 1, as it shows the sum of subtype-specific fractions.
Row `B` is a placeholder whose values are all `NA`.

## Details

The data come from three sources:

- Historical assumptions: From 1918-1956, we assume only H1N1
  circulated. From 1957-1967, we assume only H2N2 circulated. From
  1968-1976, we assume only H3N2 circulated.

- [Thompson et al. JAMA,
  2003](https://jamanetwork.com/journals/jama/fullarticle/195750): From
  1977-1996 we pull data on the relative dominance of H1N1 and H3N2 from
  Table 1 of Thompson et al. 2003, which reports surveillance data
  collected in the United States.

- From 1997-present, we pull in country or region-specific data from
  [WHO FluNet](https://www.who.int/tools/flunet) on the fraction of
  specimens collected in routine influenza surveillance that test
  positive for each subtype. Country-specific data are the default.
  Regional data, then global data are used if the number of country or
  region-specific specimens is insufficient.
  [`get_template_data()`](https://cobeylab.github.io/imprinting/reference/get_template_data.md)
  imports the data for 1918-1996.
  [`get_country_inputs_1997_to_present()`](https://cobeylab.github.io/imprinting/reference/get_country_inputs_1997_to_present.md)
  and
  [`get_regional_inputs_1997_to_present()`](https://cobeylab.github.io/imprinting/reference/get_regional_inputs_1997_to_present.md)
  import the data for 1997 on.

## See also

[doi:10.1126/science.aag1322](https://doi.org/10.1126/science.aag1322)
Gostic et al. Science, (2016) for detailed methods.

## Examples

``` r
get_country_cocirculation_data("United States", "2019")
#> # A tibble: 108 × 9
#>     year `A/H1N1` `A/H2N2` `A/H3N2`     A B     group1 group2 data_from         
#>    <dbl>    <dbl>    <dbl>    <dbl> <dbl> <lgl>  <dbl>  <dbl> <chr>             
#>  1  1918        1        0        0     1 NA         1      0 Historical_assump…
#>  2  1919        1        0        0     1 NA         1      0 Historical_assump…
#>  3  1920        1        0        0     1 NA         1      0 Historical_assump…
#>  4  1921        1        0        0     1 NA         1      0 Historical_assump…
#>  5  1922        1        0        0     1 NA         1      0 Historical_assump…
#>  6  1923        1        0        0     1 NA         1      0 Historical_assump…
#>  7  1924        1        0        0     1 NA         1      0 Historical_assump…
#>  8  1925        1        0        0     1 NA         1      0 Historical_assump…
#>  9  1926        1        0        0     1 NA         1      0 Historical_assump…
#> 10  1927        1        0        0     1 NA         1      0 Historical_assump…
#> # ℹ 98 more rows
get_country_cocirculation_data("Laos", "2025", min_samples = 40)
#> # A tibble: 108 × 9
#>     year `A/H1N1` `A/H2N2` `A/H3N2`     A B     group1 group2 data_from         
#>    <dbl>    <dbl>    <dbl>    <dbl> <dbl> <lgl>  <dbl>  <dbl> <chr>             
#>  1  1918        1        0        0     1 NA         1      0 Historical_assump…
#>  2  1919        1        0        0     1 NA         1      0 Historical_assump…
#>  3  1920        1        0        0     1 NA         1      0 Historical_assump…
#>  4  1921        1        0        0     1 NA         1      0 Historical_assump…
#>  5  1922        1        0        0     1 NA         1      0 Historical_assump…
#>  6  1923        1        0        0     1 NA         1      0 Historical_assump…
#>  7  1924        1        0        0     1 NA         1      0 Historical_assump…
#>  8  1925        1        0        0     1 NA         1      0 Historical_assump…
#>  9  1926        1        0        0     1 NA         1      0 Historical_assump…
#> 10  1927        1        0        0     1 NA         1      0 Historical_assump…
#> # ℹ 98 more rows
```

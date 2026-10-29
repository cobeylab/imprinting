# Calculate imprinting probabilities

For each country and year of observation, calculate the probability that
cohorts born in each year from 1918 through the year of observation
imprinted to a specific influenza A virus subtype (H1N1, H2N2, or H3N2),
or group (group 1 contains H1N1 and H2N2; group 2 contains H3N2).

## Usage

``` r
get_imprinting_probabilities(
  observation_years,
  countries,
  annual_frequencies = NULL,
  df_format = "long"
)
```

## Arguments

- observation_years:

  year(s) of observation in which to output imprinting probabilities.
  The observation year, together with the birth year, determines the
  birth cohort's age when calculating imprinting probabilities. Cohorts
  \<=12 years old at the time of observation have some probability of
  being naive to influenza.

- countries:

  a vector of countries for which to calculate imprinting probabilities.
  Run
  [`show_available_countries()`](https://cobeylab.github.io/imprinting/reference/show_available_countries.md)
  for a list of valid inputs, and proper spellings.

- annual_frequencies:

  an optional input allowing users to specify custom circulation
  frequencies for arbitrary types of imprinting in order to study, e.g.
  imprinting to specific strains, clades, or imprinting by vaccination.
  If nothing is input, the default is to calculate subtype-specific
  probabilities (possible imprinting types are A/H1N1, A/H2N2, A/H3N2,
  or naive). See Details.

- df_format:

  must be either 'long' (default) or 'wide'. Controls whether the output
  data frame is in long format (with a single column for calculated
  probabilities and a second column for imprinting subtype), or wide
  format (with four columns, H1N1, H2N2, H3N2, and naive) showing the
  probability of each imprinting status.

## Value

- If `format=long` (the default), a long tibble with columns showing the
  imprinting subtype (H1N1, H2N2, H3N2, or naive), the year of
  observation, the country, the birth year, and the imprinting
  probability.

- If `format=wide`, a wide tibble with each row representing a country,
  observation year, and birth year, and with a column for each influenza
  A subtype (H1N1, H2N2, and H3N2), or the probability that someone born
  in that year remains naive to influenza and has not yet imprinted. For
  cohorts \>12 years old in the year of observation, the probability of
  remaining naive is 0, and the subtype-specific probabilities are
  normalized to sum to 1. For cohorts \<=12 years old in the year of
  observation, the probability of remaining naive is non-zero. For
  cohorts not yet born at the time of observation, all output
  probabilities are 0.

## Details

Imprinting probabilities are calculated following
[doi:10.1126/science.aag1322](https://doi.org/10.1126/science.aag1322)
Gostic et al. Science, (2016). Briefly, the model first calculates the
probability that an individual's first influenza infection occurs 0, 1,
2, ... 12 years after birth using a modified geometric waiting time
model. The annual circulation intensities output by
[`get_country_intensity_data()`](https://cobeylab.github.io/imprinting/reference/get_country_intensity_data.md)
scale the probability of primary infection in each calendar year.

Then, after calculating the probability of imprinting 0, 1, 2, ...
calendar years after birth, the model uses data on which subtypes
circulated in each calendar year (from
[`get_country_cocirculation_data()`](https://cobeylab.github.io/imprinting/reference/get_country_cocirculation_data.md))
to estimate that probability that a first infection was caused by each
subtype. See
[`get_country_cocirculation_data()`](https://cobeylab.github.io/imprinting/reference/get_country_cocirculation_data.md)
for details about the underlying data sources.

To calculate other kinds of imprinting probabilities (e.g. for specific
clades, strains, or to include pediatric vaccination), users can specify
custom circulation frequencies as a list, `annual_frequencies`. This
list must contain one named element for each country in the `countries`
input vector. Each list element must be a data frame or tibble whose
first column is named "year" and contains numeric years from
1918:max(`observation_years`). Columns 2:N of the data frame must
contain circulation frequencies that sum to 1 across each row, and each
column must have a unique name indicating the exposure kind. E.g. column
names could be "year", "H1N1", "H2N2", "H3N2", "vaccinated" to include
probabilities of imprinting by vaccine, or "year", "3C.3A", "not_3C.3A"
to calculate clade-specific probabilities. Do not include a naive
column. Any number of imprinting types is allowed, but the code is not
optimized to run efficiently when the number of categories is very
large. Frequencies within the column must be supplied by the user. See
[Vieira et al. 2021](https://www.nature.com/articles/s41467-021-24566-y)
for methods to estimate circulation frequencies from sequence databases
like [GISAID](https://gisaid.org/) or the [NCBI Sequence
Database](https://www.ncbi.nlm.nih.gov/genomes/FLU/Database/nph-select.cgi?go=database).

See
[`vignette("custom-imprinting-types")`](https://cobeylab.github.io/imprinting/articles/custom-imprinting-types.md)
for use of a custom `annual_frequencies` input.

## Examples

``` r
# ===========================================================
# Get imprinting probabilities for one country and year
get_imprinting_probabilities(2025, "United States")
#> # A tibble: 432 × 5
#>     year country       birth_year subtype imprinting_prob
#>    <dbl> <chr>              <dbl> <chr>             <dbl>
#>  1  2025 United States       2025 A/H1N1           0.0688
#>  2  2025 United States       2024 A/H1N1           0.0924
#>  3  2025 United States       2023 A/H1N1           0.109 
#>  4  2025 United States       2022 A/H1N1           0.110 
#>  5  2025 United States       2021 A/H1N1           0.109 
#>  6  2025 United States       2020 A/H1N1           0.176 
#>  7  2025 United States       2019 A/H1N1           0.245 
#>  8  2025 United States       2018 A/H1N1           0.252 
#>  9  2025 United States       2017 A/H1N1           0.209 
#> 10  2025 United States       2016 A/H1N1           0.282 
#> # ℹ 422 more rows
# ===========================================================
# Return the same outputs in wide format
get_imprinting_probabilities(2025,
  "United States",
  df_format = "wide"
)
#> # A tibble: 108 × 7
#>     year country       birth_year `A/H1N1` `A/H2N2` `A/H3N2`     naive
#>    <dbl> <chr>              <dbl>    <dbl>    <dbl>    <dbl>     <dbl>
#>  1  2025 United States       1918        1        0        0  2.22e-16
#>  2  2025 United States       1919        1        0        0  0       
#>  3  2025 United States       1920        1        0        0  1.11e-16
#>  4  2025 United States       1921        1        0        0  2.22e-16
#>  5  2025 United States       1922        1        0        0  2.22e-16
#>  6  2025 United States       1923        1        0        0 -2.22e-16
#>  7  2025 United States       1924        1        0        0  0       
#>  8  2025 United States       1925        1        0        0  0       
#>  9  2025 United States       1926        1        0        0  0       
#> 10  2025 United States       1927        1        0        0  1.11e-16
#> # ℹ 98 more rows
```

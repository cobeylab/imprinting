# Plot imprinting probabilities for up to five country-years

For each country and year, generate two plots:

- A stacked barplot, where each bar represents a birth cohort, and the
  colors within the bar show the probabilities that someone born in that
  cohort has a particular imprinting status, for the first observation
  year.

- A lineplot showing the age-specific probability of imprinting to H3N2
  in the first and last observation year. When the data contain more
  than one observation year, this plot shows how cohorts age over time.

## Usage

``` r
plot_many_country_years(imprinting_df)
```

## Arguments

- imprinting_df:

  A long data frame of imprinted probabilities output by
  [`get_imprinting_probabilities()`](https://cobeylab.github.io/imprinting/reference/get_imprinting_probabilities.md).
  Up to five countries and an arbitrary span of years can be plotted.

## Value

No return value. Opens a plot of the data frame.

## Examples

``` r
imprinting_df <- get_imprinting_probabilities(
  observation_years = c(1920, 1921),
  countries = c("Oman", "Indonesia")
)
plot_many_country_years(imprinting_df)
#> Warning: All aesthetics have length 1, but the data has 14 rows.
#> ℹ Please consider using `annotate()` or provide this layer with data containing
#>   a single row.
#> Warning: All aesthetics have length 1, but the data has 14 rows.
#> ℹ Please consider using `annotate()` or provide this layer with data containing
#>   a single row.
```

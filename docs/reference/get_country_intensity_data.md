# Get the relative intensity of influenza A circulation

`get_country_intensity data()` returns data on the annual intensity of
influenza circulation in each calendar year. Following
[doi:10.1126/science.aag1322](https://doi.org/10.1126/science.aag1322)
Gostic et al. Science, (2016), we define 1 as the average intensity.
Seasons with intensities greater than 1 have more flu A circulation than
average, and seasons with intensities less than 1 are mild.

## Usage

``` r
get_country_intensity_data(country, max_year, min_specimens = 50)
```

## Arguments

- country:

  country of interest. Run
  [`show_available_countries()`](https://cobeylab.github.io/imprinting/reference/show_available_countries.md)
  for valid inputs.

- max_year:

  last year of interest. Results will be generated from 1918:max_year.

- min_specimens:

  if fewer than `min_specimens` (default 50) were tested in the country
  and year of interest, the function will substitute data from the
  corresponding WHO region.

## Value

A tibble showing the year and intensity score.

## Details

For 1918-1996, we use annual intensities from Gostic et al., Science,
(2016). For 1997-present, we calculate country or region-specific
intensities using surveillance data from [WHO
FluNet](https://www.who.int/tools/flunet). Intensity is calculated as:
\[fraction of processed samples positive for flu A\]/\[mean fraction of
processed samples positive for flu A\]. Country-specific data are used
by default. Regional or global data are substituted when
country-specific data contain too few observations or fail quality
checks. Global data are only used in years when regional data are
insufficient.

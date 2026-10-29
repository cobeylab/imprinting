# Get country-independent flu circulation data for 1918-1996

`get_template_data()` returns a tibble showing the fraction of influenza
A cases caused by subtype H1N1, H2N2, or H3N2 in each year from
1918-1996. These data are country-independent. Country-specific data are
only available from 1997 on.

- For years 1918-1976 only one influenza A subtype circulated, so all
  fractions are 0 or 1.

- From 1977-1996 H1N1 and H3N2 both circulated. `get_template_data()`
  reports the fraction of influenza A-positive specimens of each subtype
  observed in US flu surveillance. See [Thompson et al. JAMA,
  2003](https://jamanetwork.com/journals/jama/fullarticle/195750), Table
  1.

- Country-specific data from [WHO
  FluNet](https://www.who.int/tools/flunet) will be appended to this
  template in later steps.

## Usage

``` r
get_template_data()
```

## Value

A tibble with the following columns:

- year

- `A/H1N1`, `A/H2N2`, and `A/H3N2` show the fraction of influenza cases
  caused by each subtype.

- `A` = `A/H1N1` + `A/H2N2` + `A/H3N2`

- `B` is a placeholder for future calculate of influenza B imprinting
  probabilities, which currently contains `NA`.

- `group1` and `group2` show the fraction of cases caused by group 1
  subtypes (H1N1 and H2N2), or group 2 (H3N2).

- `data_from` notes the data source.

## See also

[doi:10.1126/science.aag1322](https://doi.org/10.1126/science.aag1322)
Gostic et al. Science, (2016) for detailed methods.

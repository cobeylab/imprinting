# Look up a country's WHO region

Look up a country's WHO region

## Usage

``` r
get_WHO_region(this.country)
```

## Arguments

- this.country:

  name of the input country (a string)

## Value

Name of the corresponding WHO region

## Details

Region assignments follow WHO FluNet. Indonesia is assigned to the
Western Pacific region, following its move from the South-East Asia
region on 23 May 2025. FluNet applies this assignment to Indonesia's
full record (2004 on), so Indonesia's data count toward the Western
Pacific regional totals in all years. Package versions before 0.2.0
assigned Indonesia to South-East Asia.

## Examples

``` r
get_WHO_region("Germany")
#> [1] "europe"
get_WHO_region("China")
#> [1] "western_pacific"
```

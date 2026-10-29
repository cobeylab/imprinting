# Show a list of all available countries

Lists all available countries, with valid spelling and formatting. Each
country in the list matches or can be mapped to a country with data in
[WHO FluNet](https://www.who.int/tools/flunet). (Note: for convenience,
this package sometimes uses different country names or spellings than
FluNet.)

## Usage

``` r
show_available_countries()
```

## Value

A data frame of valid country names.

## Examples

``` r
show_available_countries()
#> # A tibble: 175 × 1
#>    country            
#>    <chr>              
#>  1 Afghanistan        
#>  2 Albania            
#>  3 Algeria            
#>  4 Angola             
#>  5 Anguilla           
#>  6 Antigua and Barbuda
#>  7 Argentina          
#>  8 Armenia            
#>  9 Aruba              
#> 10 Australia          
#> # ℹ 165 more rows
```

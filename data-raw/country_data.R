library(tidyverse)
options(dplyr.summarise.inform = FALSE)

source("data-raw/load_data.R")

## One row per country and year from MIN_YEAR to MAX_YEAR. Country-years with no
## reports (including countries absent from the export) are zero-filled, as in the
## legacy FluMart files, so that the regional fallback applies to them.
country_data <- lapply(COUNTRY_NAMES$flunet_country, function(flunet_country) {
  FLUNET %>%
    dplyr::filter(Country == flunet_country) %>%
    group_by(Country, Year) %>%
    summarise_counts() %>%
    right_join(tibble(Country = flunet_country, Year = as.numeric(MIN_YEAR:MAX_YEAR)), by = c("Country", "Year")) %>%
    mutate(across(starts_with("n_"), ~ replace_na(.x, 0))) %>%
    arrange(Year)
})

names(country_data) <- COUNTRY_NAMES$country

saveRDS(country_data, "inst/extdata/country_data.rds")

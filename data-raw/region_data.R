library(tidyverse)
options(dplyr.summarise.inform = FALSE)

source("data-raw/load_data.R")

## Regional totals include every country and area reported in the region,
## not only those in COUNTRY_NAMES.
region_data <- lapply(WHO_REGIONS$region, function(this_region) {
  FLUNET %>%
    dplyr::filter(region == this_region) %>%
    mutate(WHOREGION = region_name) %>%
    group_by(WHOREGION, Year) %>%
    summarise_counts() %>%
    arrange(Year)
})

names(region_data) <- WHO_REGIONS$region

saveRDS(region_data, "inst/extdata/region_data.rds")

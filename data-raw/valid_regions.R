source("data-raw/load_data.R")

valid_regions <- WHO_REGIONS$region
saveRDS(valid_regions, "inst/extdata/valid_regions.rds")

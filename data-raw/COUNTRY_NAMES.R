COUNTRY_NAMES <- read_csv("data-raw/processed-data/country_names_long_short.csv", show_col_types = FALSE)
saveRDS(COUNTRY_NAMES, "inst/extdata/COUNTRY_NAMES.rds")

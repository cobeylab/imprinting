COUNTRY_NAMES <- read_csv("data-raw/processed-data/country_names_long_short.csv", show_col_types = FALSE)
THOMPSON_DATA <- read_csv("data-raw/processed-data/Thompson_data.csv", show_col_types = FALSE)
INTENSITY_DATA <- readRDS("inst/extdata/INTENSITY_DATA.rds")

## Raw WHO FluNet export. See data-raw/README.md for source and download time.
FLUNET_FILE <- "data-raw/VIW_FNT_2026-10-29.csv"
MIN_YEAR <- 1997
MAX_YEAR <- 2025 ## Last complete calendar (ISO) year included in the release

## WHOREGION codes -> region names used in valid_regions.rds / region_data.rds,
## and the region strings stored in region_data.rds$WHOREGION (as in the legacy FluMart files).
## COUNTRY_NAMES$region uses the same names with spaces instead of underscores.
WHO_REGIONS <- tibble(
  code = c("AFR", "AMR", "EMR", "EUR", "SEAR", "WPR"),
  region = c("africa", "americas", "eastern_mediterranean", "europe", "southeast_asia", "western_pacific"),
  region_name = c(
    "African Region of WHO", "Region of the Americas of WHO", "Eastern Mediterranean Region of WHO",
    "European Region of WHO", "South-East Asia Region of WHO", "Western Pacific Region of WHO"
  )
)

## Areas reported separately in the FluNet export that are pooled into a single
## package country, matching the aggregation of the legacy FluMart files.
POOLED_AREAS <- c(
  "United Kingdom, England" = "United Kingdom of Great Britain and Northern Ireland",
  "United Kingdom, Scotland" = "United Kingdom of Great Britain and Northern Ireland",
  "United Kingdom, Wales" = "United Kingdom of Great Britain and Northern Ireland",
  "United Kingdom, Northern Ireland" = "United Kingdom of Great Britain and Northern Ireland",
  "China, Hong Kong SAR" = "China"
)

read_flunet <- function(path = FLUNET_FILE, min_year = MIN_YEAR, max_year = MAX_YEAR) {
  flunet <- read_csv(path, show_col_types = FALSE, guess_max = 1e6) %>%
    distinct() %>% ## The export contains some exact duplicate rows
    left_join(WHO_REGIONS, by = c("WHOREGION" = "code"))
  stopifnot(!any(is.na(flunet$region)))

  ## Years follow ISO weeks, as did the Year column of the legacy FluMart files
  ## Guard: the terminal year must be complete
  n_weeks_expected <- lubridate::isoweek(as.Date(sprintf("%i-12-28", max_year)))
  n_weeks_observed <- flunet %>%
    dplyr::filter(ISO_YEAR == max_year) %>%
    pull(ISO_WEEK) %>%
    n_distinct()
  if (n_weeks_observed < n_weeks_expected) {
    stop(sprintf(
      "%s contains %i of %i ISO weeks for %i. Set MAX_YEAR to the last complete year.",
      path, n_weeks_observed, n_weeks_expected, max_year
    ))
  }

  flunet %>%
    dplyr::filter(ISO_YEAR >= min_year, ISO_YEAR <= max_year) %>%
    mutate(
      Year = ISO_YEAR,
      Country = dplyr::recode(COUNTRY_AREA_TERRITORY, !!!POOLED_AREAS)
    )
}

## Summarize the number of positive samples of each subtype observed in each year.
## Sums over all ORIGIN_SOURCE streams (sentinel, non-sentinel, not defined).
summarise_counts <- function(df) {
  df %>%
    dplyr::summarise(
      n_H1N1 = sum(AH1, na.rm = T) + sum(AH1N12009, na.rm = T),
      n_H3N2 = sum(AH3, na.rm = T),
      n_A = n_H1N1 + n_H3N2,
      n_BYam = sum(BYAM, na.rm = T),
      n_BVic = sum(BVIC_2DEL, na.rm = T) + sum(BVIC_3DEL, na.rm = T) + sum(BVIC_NODEL, na.rm = T) + sum(BVIC_DELUNK, na.rm = T),
      n_B = n_BYam + n_BVic,
      n_processed = sum(SPEC_PROCESSED_NB, na.rm = T)
    ) %>%
    ungroup()
}

FLUNET <- read_flunet()

## Check that the package's country -> region mapping agrees with the export
region_check <- FLUNET %>%
  dplyr::distinct(Country, region) %>%
  inner_join(COUNTRY_NAMES, by = c("Country" = "flunet_country"), suffix = c("_flunet", "_package")) %>%
  dplyr::filter(region_flunet != gsub(" ", "_", region_package))
if (nrow(region_check) > 0) {
  print(region_check)
  stop("WHO region assignments in country_names_long_short.csv disagree with the FluNet export.")
}

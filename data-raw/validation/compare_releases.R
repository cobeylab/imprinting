## Compare imprinting probabilities between a baseline git ref and the working tree.
##
## Usage, from the repository root:
##   Rscript data-raw/validation/compare_releases.R [baseline_ref]
##
## baseline_ref defaults to v0.1.1, the last release built from the legacy
## FluMart data. The baseline package is extracted with `git archive` and each
## version is loaded in its own R process with pkgload::load_all(), so nothing
## needs to be installed. Plots are written to data-raw/validation/.

library(tidyverse)
options(dplyr.summarise.inform = FALSE)

args <- commandArgs(trailingOnly = TRUE)
baseline_ref <- if (length(args) >= 1) args[1] else "v0.1.1"
out_dir <- "data-raw/validation"
observation_years <- c(2000, 2010, 2019, 2021, 2022)
plot_year <- 2021 ## Observation year shown in the plots
focus_country <- "United States" ## Country shown on its own in plot 4

## Extract the baseline package ------------------------------------------------
baseline_dir <- file.path(tempdir(), "imprinting-baseline")
dir.create(baseline_dir, showWarnings = FALSE)
status <- system(sprintf("git archive %s | tar -x -C %s", shQuote(baseline_ref), shQuote(baseline_dir)))
stopifnot(status == 0)

## Snapshot each version -------------------------------------------------------
snapshot <- function(pkg_path, years) {
  callr::r(function(pkg_path, years) {
    suppressMessages(library(dplyr))
    pkgload::load_all(pkg_path, quiet = TRUE)
    countries <- show_available_countries()$country
    probs <- bind_rows(lapply(countries, function(cc) get_imprinting_probabilities(years, cc)))
    data_from <- bind_rows(lapply(countries, function(cc) {
      get_country_cocirculation_data(cc, max(years)) %>%
        dplyr::filter(year >= 1997) %>%
        transmute(country = cc, year, data_from)
    }))
    list(probs = probs, data_from = data_from)
  }, args = list(pkg_path = pkg_path, years = years))
}

before <- snapshot(baseline_dir, observation_years)
after <- snapshot(getwd(), observation_years)

## Differences -----------------------------------------------------------------
regions <- read_csv("data-raw/processed-data/country_names_long_short.csv", show_col_types = FALSE) %>%
  select(country, region) %>%
  mutate(region = str_to_title(region))

probs <- inner_join(before$probs, after$probs,
  by = c("subtype", "year", "country", "birth_year"), suffix = c("_before", "_after")
) %>%
  left_join(regions, by = "country") %>%
  mutate(abs_change = abs(imprinting_prob_after - imprinting_prob_before))
stopifnot(nrow(probs) == nrow(before$probs), nrow(probs) == nrow(after$probs))

country_year <- probs %>%
  group_by(region, country, year) %>%
  summarise(max_abs_change = max(abs_change)) %>%
  ungroup()

cat(sprintf("\nBaseline: %s. Per-country maximum absolute change in imprinting probability:\n", baseline_ref))
country_year %>%
  group_by(year) %>%
  summarise(
    countries = n(),
    `< 0.001` = sum(max_abs_change < 0.001),
    `< 0.01` = sum(max_abs_change < 0.01),
    `< 0.05` = sum(max_abs_change < 0.05),
    median = median(max_abs_change),
    max = max(max_abs_change)
  ) %>%
  print()

cat(sprintf("\nLargest changes, observation years before %i:\n", max(observation_years)))
country_year %>%
  dplyr::filter(year < max(observation_years)) %>%
  arrange(desc(max_abs_change)) %>%
  print(n = 15)

tier_changes <- inner_join(before$data_from, after$data_from, by = c("country", "year"), suffix = c("_before", "_after")) %>%
  dplyr::filter(year < max(observation_years), data_from_before != data_from_after) %>%
  mutate(from = sub(":.*", "", data_from_before), to = sub(":.*", "", data_from_after))
cat(sprintf(
  "\nData-source changes (country/region/global), 1997-%i: %i country-years in %i countries\n",
  max(observation_years) - 1, nrow(tier_changes), n_distinct(tier_changes$country)
))
tier_changes %>%
  count(from, to) %>%
  print()

## Plots -----------------------------------------------------------------------
ink <- "#0b0b0b"
ink2 <- "#52514e"
gridline <- "#e6e5e1"
blue <- "#2a78d6"
grey <- "#8a8984"
surface <- "#fcfcfb"
theme_validation <- theme_minimal(base_size = 11) +
  theme(
    plot.background = element_rect(fill = surface, colour = NA),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(colour = gridline, linewidth = 0.3),
    strip.text = element_text(colour = ink, face = "bold"),
    axis.text = element_text(colour = ink2),
    axis.title = element_text(colour = ink2),
    plot.title = element_text(colour = ink, face = "bold"),
    plot.subtitle = element_text(colour = ink2),
    plot.caption = element_text(colour = ink2, hjust = 0)
  )
label_before <- sprintf("Baseline (%s)", baseline_ref)
label_after <- "Working tree"

## 1. Before vs after, one point per country x birth year x subtype
p1 <- probs %>%
  dplyr::filter(year == plot_year) %>%
  ggplot(aes(imprinting_prob_before, imprinting_prob_after)) +
  geom_abline(slope = 1, intercept = 0, colour = ink2, linewidth = 0.3, linetype = "dashed") +
  geom_point(colour = blue, alpha = 0.25, size = 0.6, stroke = 0) +
  facet_grid(subtype ~ region) +
  coord_equal() +
  scale_x_continuous(breaks = c(0, 0.5, 1)) +
  scale_y_continuous(breaks = c(0, 0.5, 1)) +
  labs(
    title = "Imprinting probabilities, baseline vs working tree",
    subtitle = sprintf("Observation year %i; one point per country × birth year. Dashed line: no change.", plot_year),
    x = sprintf("Probability, %s", label_before), y = sprintf("Probability, %s", label_after),
    caption = "Regions as in the working tree."
  ) +
  theme_validation
ggsave(file.path(out_dir, "plot1_scatter.png"), p1, width = 13, height = 9, dpi = 150, bg = surface)

## 2. Shift by birth cohort: total variation distance between subtype distributions
cohort_shift <- probs %>%
  dplyr::filter(year == plot_year) %>%
  group_by(region, country, birth_year) %>%
  summarise(tv = 0.5 * sum(abs(imprinting_prob_after - imprinting_prob_before))) %>%
  ungroup()
top_countries <- cohort_shift %>%
  group_by(region, country) %>%
  summarise(max_tv = max(tv)) %>%
  slice_max(max_tv, n = 3) %>%
  ungroup()
top_shift <- cohort_shift %>% semi_join(top_countries, by = c("region", "country"))
top_labels <- top_shift %>%
  group_by(country) %>%
  slice_max(tv, n = 1, with_ties = FALSE)
p2 <- ggplot(cohort_shift, aes(birth_year, tv, group = country)) +
  geom_line(colour = "#b9b8b2", linewidth = 0.35, alpha = 0.8) +
  geom_line(data = top_shift, colour = blue, linewidth = 0.7) +
  ggrepel::geom_text_repel(
    data = top_labels, aes(label = country), colour = ink, size = 2.8, direction = "y",
    nudge_x = -12, hjust = 1, segment.colour = "#b9b8b2", segment.size = 0.3, min.segment.length = 0, seed = 1
  ) +
  facet_wrap(~region, nrow = 2) +
  scale_y_continuous(limits = c(0, NA), expand = expansion(mult = c(0, 0.12))) +
  labs(
    title = "Which birth cohorts move? Shift in imprinting distribution by birth year",
    subtitle = sprintf(
      "Observation year %i. Total variation distance between baseline and working-tree subtype distributions (0 = identical, 1 = disjoint).\nOne line per country; the three countries with the largest shift in each region in blue.",
      plot_year
    ),
    x = "Birth year", y = "Total variation distance"
  ) +
  theme_validation
ggsave(file.path(out_dir, "plot2_cohort_shift.png"), p2, width = 13, height = 7.5, dpi = 150, bg = surface)

## 3. European regional intensity, computed as in get_country_intensity_data()
europe_intensity <- function(region_data_path, label) {
  readRDS(region_data_path)$europe %>%
    dplyr::filter(Year <= plot_year, n_processed >= 50) %>%
    mutate(raw = n_A / n_processed, intensity = pmin(raw / mean(raw), 2.5), data = label)
}
intensity <- bind_rows(
  europe_intensity(file.path(baseline_dir, "inst/extdata/region_data.rds"), label_before),
  europe_intensity("inst/extdata/region_data.rds", label_after)
)
p3 <- ggplot(intensity, aes(Year, intensity, colour = data)) +
  geom_hline(yintercept = 1, colour = ink2, linewidth = 0.3, linetype = "dashed") +
  geom_line(linewidth = 0.7) +
  geom_point(size = 1.6) +
  scale_colour_manual(values = setNames(c(grey, blue), c(label_before, label_after)), name = NULL) +
  scale_x_continuous(breaks = seq(1997, plot_year, 4)) +
  labs(
    title = sprintf("European regional intensity, 1997–%i", plot_year),
    subtitle = sprintf("Intensity = (n_A / n_processed) relative to its 1997–%i mean, capped at 2.5. Dashed line: average intensity.", plot_year),
    x = NULL, y = "Relative intensity"
  ) +
  theme_validation +
  theme(legend.position = "top")
ggsave(file.path(out_dir, "plot3_europe_intensity.png"), p3, width = 10, height = 5, dpi = 150, bg = surface)

## 4. Before vs after for a single country
focus <- probs %>% dplyr::filter(year == plot_year, country == focus_country)
p4 <- ggplot(focus, aes(imprinting_prob_before, imprinting_prob_after)) +
  geom_abline(slope = 1, intercept = 0, colour = ink2, linewidth = 0.3, linetype = "dashed") +
  geom_point(colour = blue, alpha = 0.6, size = 1.8, stroke = 0) +
  facet_wrap(~subtype, nrow = 1) +
  coord_equal() +
  scale_x_continuous(breaks = c(0, 0.5, 1)) +
  scale_y_continuous(breaks = c(0, 0.5, 1)) +
  labs(
    title = sprintf("Imprinting probabilities, baseline vs working tree: %s", focus_country),
    subtitle = sprintf(
      "Observation year %i; one point per birth year. Dashed line: no change. Largest absolute change: %.1g.",
      plot_year, max(focus$abs_change)
    ),
    x = sprintf("Probability, %s", label_before), y = sprintf("Probability, %s", label_after)
  ) +
  theme_validation
ggsave(file.path(out_dir, "plot4_scatter_focus_country.png"), p4, width = 11, height = 3.8, dpi = 150, bg = surface)

cat(sprintf("\nPlots written to %s/\n", out_dir))

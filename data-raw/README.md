# data-raw

Scripts and raw inputs used to build the data files in `inst/extdata/`. Run `data_pipeline.R` from the repository root to rebuild them.

## WHO FluNet surveillance data

`VIW_FNT_2026-10-29.csv` is the WHO FluNet export used to build `country_data.rds`, `region_data.rds` and `valid_regions.rds`. The file has no header recording its origin, so its provenance is recorded here.

- **Source:** `https://xmart-api-public.who.int/FLUMART/VIW_FNT?$format=csv` (see also <https://www.who.int/tools/flunet>)
- **Downloaded:** 2026-10-29, 9:41 a.m. US Central Time (America/Chicago)
- **Coverage at download:** 1995 through ISO week 44 of 2026. The build uses 1997–2025 only.

### How the export is processed (`load_data.R`)

- **Years** are ISO years (`ISO_YEAR`), matching the `Year`/`Week` columns of the legacy FluMart files.
- **Year range** is `MIN_YEAR` (1997) to `MAX_YEAR` (2025). The build stops if `MAX_YEAR` has fewer weeks in the export than the ISO year contains, so a partial terminal year is never treated as complete. Update `MAX_YEAR` and `FLUNET_FILE` together when refreshing the data.
- **Surveillance streams:** counts are summed over all values of `ORIGIN_SOURCE` (`SENTINEL`, `NONSENTINEL`, `NOTDEFINED`). This matches the legacy files, which were downloaded for "All sites".
- **Duplicates:** exact duplicate rows in the export are dropped.
- **Counts:** `n_H1N1 = AH1 + AH1N12009`, `n_H3N2 = AH3`, `n_A = n_H1N1 + n_H3N2` (unsubtyped influenza A is not counted), `n_BVic = BVIC_2DEL + BVIC_3DEL + BVIC_NODEL + BVIC_DELUNK`, `n_BYam = BYAM`, `n_B = n_BVic + n_BYam`, `n_processed = SPEC_PROCESSED_NB`.
- **Pooled areas:** the four UK nations (`United Kingdom, England`, `... Scotland`, `... Wales`, `... Northern Ireland`) are pooled as `United Kingdom`, and `China, Hong Kong SAR` is pooled into `China`. This reproduces how the legacy FluMart files reported both.
- **Countries without reports:** every country in `processed-data/country_names_long_short.csv` gets one row per year, with zeros where FluNet has no data. Cabo Verde, Gambia and Guinea-Bissau have no rows in the export, so all their country rows are zero and their results come from regional data.
- **Regions** come from the `WHOREGION` column. The build stops if a country's region in `country_names_long_short.csv` disagrees with the export. Regional totals include every country and area in the region, including those not in the package's country list.
- **Indonesia** is in the Western Pacific region. WHO moved it from South-East Asia on 23 May 2025, and the export applies this to Indonesia's full record (2004 on).

### Legacy data

`legacy-flumart-2022-05/` (formerly `who/`) holds the WHO FluMart per-region exports used up to package version 0.1.1. Each file's preamble says it was generated on 10/05/2022 or 11/05/2022 UTC, which we read as 10–11 May 2022 because the data end at ISO week 19 of 2022 (9–15 May). Each preamble also records `Data from: All sites`. FluMart has been retired. The pipeline no longer reads these files; they are kept for reference and for comparing old and new data.

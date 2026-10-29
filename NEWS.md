# imprinting 0.2.0

## Data

* Surveillance data now run through 2025, from a WHO FluNet export downloaded on 2026-10-29. WHO has retired FluMart, the source of earlier versions. See `data-raw/README.md` for provenance and processing.
* Corrected 2022. Earlier versions included only ISO weeks 1–19 of 2022; 2022 now includes all 52 weeks. Results for 2022 change substantially. This is the intended fix, not a regression.
* Indonesia is now in the Western Pacific region, following WHO's reassignment on 23 May 2025. The FluNet export applies this to Indonesia's full record (2004 to present). Indonesia's results differ from earlier releases in every year where it relies on regional data, including 1997–2003, before its own records begin, because that data now comes from the Western Pacific. Both regional totals change from 2004 on, so results also differ, for those years, for other South-East Asian and Western Pacific countries that rely on regional data.
* WHO has revised historical records since the 2022 download. Among them, FluNet now has specimens-processed counts for France in 1997–2011, where the earlier files had none; this lowers Europe's early-year test positivity. Because intensities are defined relative to the mean over all years, intensities change in every year for European countries that use regional data, and so do their imprinting probabilities. Smaller revisions affect about 50 other countries.
* As before, counts are summed over all surveillance streams (sentinel, non-sentinel and undefined), and unsubtyped influenza A specimens are not counted.

## Documentation

* Source links now point to WHO FluNet (<https://www.who.int/tools/flunet>).
* Examples, vignettes and tests use 2025 as the most recent year.

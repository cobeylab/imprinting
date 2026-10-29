# custom-imprinting-types

## Generate probabilities of imprinting to custom subsets of influenza A viruses

By default,
[`get_imprinting_probabilities()`](https://cobeylab.github.io/imprinting/reference/get_imprinting_probabilities.md)
calculates subtype-specific probabilities of imprinting to influenza A
H1N1, H2N2, or H3N2. Researchers may want to calculate different kinds
of imprinting probabilities. E.g. perhaps we want to study imprinting to
specific influenza isolates, clades, [glycosylation
states](https://doi.org/10.1128/mBio.00204-19), or to a multivalent
vaccine.

To calculate imprinting to custom groups of influenza A viruses, use the
`annual_frequencies` option in
[`get_imprinting_probabilities()`](https://cobeylab.github.io/imprinting/reference/get_imprinting_probabilities.md).

The `annual_frequencies` input must be a list whose names match the
`countries` input. Each element of the list must be a data frame or
tibble with the following columns:

- `year` - containing numeric values from 1918-max(`observation_years`)
- any number of frequency columns whose names indicate the imprinting
  category, and whose values indicate the annual fraction of circulating
  influenza A exposures in that category. Within each year (row), these
  values must sum to one.

As an example, let’s imagine we want to calculate subtype-specific
imprinting probabilities, with some probability of imprinting by
vaccination in the United States and Germany. Note that the pediatric
influenza vaccination rates used in this example are PURELY
HYPOTEHTICAL, and not based on data or actual vaccine policies in these
countries.

Let’s start by making a data frame of circulation frequencies for the
United States.

[`library`](https://rdrr.io/r/base/library.html)`(`[`imprinting`](https://cobeylab.github.io/imprinting/)`)`` ``## Start with subtype-specific fractions for H1N1, H2N2, H3N2`` ``US_frequencies`` ``=`` `[`get_country_cocirculation_data`](https://cobeylab.github.io/imprinting/reference/get_country_cocirculation_data.md)`(``country ``=`` ``'United States'``, max_year ``=`` ``2025``)`` ``%>%`` `` ``select``(``1``:``4``)`` `[`head`](https://rdrr.io/r/utils/head.html)`(``US_frequencies``)`` ``#> ``# A tibble: 6 × 4`` ``` #> year `A/H1N1` `A/H2N2` `A/H3N2` ``` ``#> ``<dbl>`` ``<dbl>`` ``<dbl>`` ``<dbl>`` ``#> ``1`` ``1``918 1 0 0`` ``#> ``2`` ``1``919 1 0 0`` ``#> ``3`` ``1``920 1 0 0`` ``#> ``4`` ``1``921 1 0 0`` ``#> ``5`` ``1``922 1 0 0`` ``#> ``6`` ``1``923 1 0 0`

Now, add in a vaccination column. Not all countries vaccinate healthy
infants against influenza, and infant influenza vaccination has only
been widely practiced for the past few decades, even in countries where
coverage is now high. Hypothetically, let’s assume that 5% of US infants
were vaccinated against influenza starting in 1995, increasing steadily
to 75% coverage in 2020. (Again, this is purely hypothetical, and not
based on data.)

`## Add a vaccination column`` ``US_frequencies`` ``<-`` ``US_frequencies`` ``%>%`` `` ``mutate``(``vaccination ``=`` `[`c`](https://rdrr.io/r/base/c.html)`(`[`rep`](https://rdrr.io/r/base/rep.html)`(``0``, ``77``)``, `[`seq`](https://rdrr.io/r/base/seq.html)`(``.5``, ``.75``, length ``=`` ``26``)``, `[`rep`](https://rdrr.io/r/base/rep.html)`(``.75``, ``5``)``)``, ``# Add a vaccination column`` ```  `A/H1N1`  ```=`` ``` `A/H1N1` ```*``(``1``-``vaccination``)``, ``# Assume only non-vaccinated children have primary`` ```  `A/H2N2`  ```=`` ``` `A/H2N2` ```*``(``1``-``vaccination``)``, ``# infections; multiply the subtype-specific circulation`` ```  `A/H3N2`  ```=`` ``` `A/H3N2` ```*``(``1``-``vaccination``)``)`` ``# fractions by one minus the year's vaccination probability.`` `[`tail`](https://rdrr.io/r/utils/head.html)`(``US_frequencies``, n ``=`` ``30``)`` ``#> ``# A tibble: 30 × 5`` ``` #> year `A/H1N1` `A/H2N2` `A/H3N2` vaccination ``` ``#> ``<dbl>`` ``<dbl>`` ``<dbl>`` ``<dbl>`` ``<dbl>`` ``#> `` 1`` ``1``996 0.288 0 0.202 0.51`` ``#> `` 2`` ``1``997 0 0 0.48 0.52`` ``#> `` 3`` ``1``998 0.004``44`` 0 0.466 0.53`` ``#> `` 4`` ``1``999 0.003``72`` 0 0.456 0.54`` ``#> `` 5`` ``2``000 0.130 0 0.320 0.55`` ``#> `` 6`` ``2``001 0.335 0 0.105 0.56`` ``#> `` 7`` ``2``002 0.015``5`` 0 0.415 0.57`` ``#> `` 8`` ``2``003 0.100 0 0.320 0.58`` ``#> `` 9`` ``2``004 0.000``566`` 0 0.409 0.59`` ``#> ``10`` ``2``005 0.001``58`` 0 0.398 0.6 `` ``#> ``# ℹ 20 more rows`

Assume Germany adopted their infant vaccination policy 10 years later,
in 2005. Generate a Germany-specific table of frequencies:

`Germany_frequencies`` ``<-`` `[`get_country_cocirculation_data`](https://cobeylab.github.io/imprinting/reference/get_country_cocirculation_data.md)`(``country ``=`` ``'Germany'``,`` `` max_year ``=`` ``2025``)`` ``%>%`` `` ``select``(``1``:``4``)`` ``%>%`` `` ``mutate``(``vaccination ``=`` `[`c`](https://rdrr.io/r/base/c.html)`(`[`rep`](https://rdrr.io/r/base/rep.html)`(``0``, ``87``)``, `[`seq`](https://rdrr.io/r/base/seq.html)`(``.05``, ``.75``, length ``=`` ``16``)``, `[`rep`](https://rdrr.io/r/base/rep.html)`(``.75``, ``5``)``)``,`` ```  `A/H1N1`  ```=`` ``` `A/H1N1` ```*``(``1``-``vaccination``)``, ``# Assume only non-vaccinated children have primary`` ```  `A/H2N2`  ```=`` ``` `A/H2N2` ```*``(``1``-``vaccination``)``, ``# infections; multiply the subtype-specific circulation`` ```  `A/H3N2`  ```=`` ``` `A/H3N2` ```*``(``1``-``vaccination``)``)`` `[`tail`](https://rdrr.io/r/utils/head.html)`(``Germany_frequencies``, ``20``)`` ``#> ``# A tibble: 20 × 5`` ``` #> year `A/H1N1` `A/H2N2` `A/H3N2` vaccination ``` ``#> ``<dbl>`` ``<dbl>`` ``<dbl>`` ``<dbl>`` ``<dbl>`` ``#> `` 1`` ``2``005 0.190 0 0.713 0.096``7`` ``#> `` 2`` ``2``006 0.145 0 0.712 0.143 `` ``#> `` 3`` ``2``007 0.082``0`` 0 0.728 0.19 `` ``#> `` 4`` ``2``008 0.053``7`` 0 0.710 0.237 `` ``#> `` 5`` ``2``009 0.447 0 0.269 0.283 `` ``#> `` 6`` ``2``010 0.644 0 0.026``4`` 0.33 `` ``#> `` 7`` ``2``011 0.612 0 0.011``1`` 0.377 `` ``#> `` 8`` ``2``012 0.035``2`` 0 0.541 0.423 `` ``#> `` 9`` ``2``013 0.280 0 0.250 0.47 `` ``#> ``10`` ``2``014 0.149 0 0.335 0.517 `` ``#> ``11`` ``2``015 0.097``7`` 0 0.339 0.563 `` ``#> ``12`` ``2``016 0.296 0 0.094``5`` 0.61 `` ``#> ``13`` ``2``017 0.012``8`` 0 0.331 0.657 `` ``#> ``14`` ``2``018 0.255 0 0.041``5`` 0.703 `` ``#> ``15`` ``2``019 0.126 0 0.124 0.75 `` ``#> ``16`` ``2``020 0.121 0 0.129 0.75 `` ``#> ``17`` ``2``022 0.010``5`` 0 0.239 0.75 `` ``#> ``18`` ``2``023 0.198 0 0.051``7`` 0.75 `` ``#> ``19`` ``2``024 0.235 0 0.015``5`` 0.75 `` ``#> ``20`` ``2``025 0.174 0 0.076``3`` 0.75`

### Input the custom frequencies into `get_imprinting_probabilities()`

`## Check that all frequencies sum to 1`` `[`rowSums`](https://rdrr.io/r/base/colSums.html)`(``US_frequencies``[``,``2``:``5``]``)`` ``#> [1] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1`` ``#> [38] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1`` ``#> [75] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1`` `[`rowSums`](https://rdrr.io/r/base/colSums.html)`(``Germany_frequencies``[``,``2``:``5``]``)`` ``#> [1] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1`` ``#> [38] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1`` ``#> [75] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1`

`# Wrap the country-specific frequencies into a named list`` ``input_list`` ``=`` `[`list`](https://rdrr.io/r/base/list.html)`(``"United States"`` ``=`` ``US_frequencies``,`` `` ``"Germany"`` ``=`` ``Germany_frequencies``)`` `` ``## Calculate probabilities`` `[`get_imprinting_probabilities`](https://cobeylab.github.io/imprinting/reference/get_imprinting_probabilities.md)`(``observation_years ``=`` ``2025``, `` `` countries ``=`` `[`c`](https://rdrr.io/r/base/c.html)`(``"United States"``, ``"Germany"``)``, `` `` annual_frequencies ``=`` ``input_list``, `` `` df_format ``=`` ``"wide"``)`` ``#> ``# A tibble: 216 × 8`` ``` #> year country birth_year `A/H1N1` `A/H2N2` `A/H3N2` vaccination naive ``` ``#> ``<dbl>`` ``<chr>`` ``<dbl>`` ``<dbl>`` ``<dbl>`` ``<dbl>`` ``<dbl>`` ``<dbl>`` ``#> `` 1`` ``2``025 United Sta… ``1``918 1 0 0 0 2.22``e``-16`` ``#> `` 2`` ``2``025 United Sta… ``1``919 1 0 0 0 0 `` `` `` ``#> `` 3`` ``2``025 United Sta… ``1``920 1 0 0 0 1.11``e``-16`` ``#> `` 4`` ``2``025 United Sta… ``1``921 1 0 0 0 2.22``e``-16`` ``#> `` 5`` ``2``025 United Sta… ``1``922 1 0 0 0 2.22``e``-16`` ``#> `` 6`` ``2``025 United Sta… ``1``923 1 0 0 0 -``2.22``e``-16`` ``#> `` 7`` ``2``025 United Sta… ``1``924 1 0 0 0 0 `` `` `` ``#> `` 8`` ``2``025 United Sta… ``1``925 1 0 0 0 0 `` `` `` ``#> `` 9`` ``2``025 United Sta… ``1``926 1 0 0 0 0 `` `` `` ``#> ``10`` ``2``025 United Sta… ``1``927 1 0 0 0 1.11``e``-16`` ``#> ``# ℹ 206 more rows`

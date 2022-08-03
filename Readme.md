# imprinting

# Overview

imprinting is an R package to reconstruct birth year-specific probabilities of imprinting to each subtype of influenza A, H1N1, H2N2, H3N2. We may add the ability to reconstruct imprinting to influenza B in the future. Reconstructions are done following the methods of [(Gostic et al. 2016)](https://www.science.org/doi/10.1126/science.aag1322).

* `get_imprinting_probabilities()` returns a data frame containing birth year-specific probabilities of imprinting to H1N1, H2N2, or H3N2 for an individual in each input country and year of observation.
* `show_available_countries()` lists the available countries (those with data in [WHO Flu Mart](https://apps.who.int/flumart/Default?ReportNo=12)), with valid spellings.
* `plot_one_country_year()` and `plot_many_country_years()` generates plots using the outputs of `get_imprinting_probabilites()`.

The generated probabilities may be modified, plotted, and used in independent research. Please cite [(Gostic et al. 2016)](https://www.science.org/doi/10.1126/science.aag1322), and this package (`citation("imprinting")`).

# Installation

imprinting is not yet available on CRAN, but the development version can be installed from github, using the devtools package:

```
# Install devtools
install.packages("devtools")
# Use devtools to install impritning from github
devtools::install_github("cobeylab/imprinting") 
# Load the imprinting package
library(impriting)
```

# Usage

# Data

There are two main kinds of data used to reconstruct birth year-specific imprinting probailities:

## 1. Cocirculation data

Cocirculation data describes the relative dominance of each influenza A subtype (H1N1, H2N2, H3N2) in circulation each year. It is informed by the following data:

* **1918-1976** Based on the available historical data, we assume only one subtype circulated each year:

  * 1918-1956: H1N1
  * 1957-1967: H2N2
  * 1968-1976: H3N2

* **1977-1996** Two subtypes, H1N1 and H3N2, co-circulated globally, but country-specific influenza surveillance data are not publicly available for this time period. We use data on the number of influenza specimens that tested positive for each influenza subtype in US surveillance (Table 1 of [Thompson et al. JAMA, 2003](https://jamanetwork.com/journals/jama/fullarticle/195750)) to calculate the fraction of circulation caused by each subtype. 

* **1996-present** Two subtypes, H1N1 and H3N2, continue to co-circulate globally. We pull country-specific data from WHO Flu Mart() to estimate the fraction of specimens that tested positive for subtype H1N1 or H3N2. If a country reported fewer than `min_samples` (default 30) influenza A-positive specimens in a given year, we substitute data from the country's WHO Region to ensure a sufficient sample size.

## 2. Intensity data

Children are more likely to imprint in years with high levels of influenza A circulation. We define an annual intensity score to characterize annual circulation intensity, and to scale the annual probability of primary infection. By definition, a circulation intensity of 1 indicates average levels of influenza ciruclation. We use three kinds of data to characterize annual circulation intensity:

* **For 1918-1996**, we calculate annual intensity using the methods of [Gostic et al. 2016](https://www.science.org/doi/10.1126/science.aag1322). From 1918-1976, intensity scores are informed by Pneumonia and Influenza excess mortaltity estimates [Housworth et al. 1974](https://academic.oup.com/aje/article-abstract/100/1/40/226436), and from 1976-1977, intensity scores are informed by the influenza A test-positive fraction reported in Table 1 of [Thompson et al. JAMA, 2003](https://jamanetwork.com/journals/jama/fullarticle/195750).


* For **1997-present**, we calculate country or region-specific intensities using surveillance data from WHO Flu Mart. Intensity is calculated as: [fraction of processed samples positive for flu A]/[mean fraction of processed samples positive for flu A]. Country-specific data are used by default. Regional data are substituted when there are an insufficient number of country-specific specimens.

# Bugs

To report bugs, please file an issue with a reproducible example at [github.com/cobeylab/imprinting](https://github.com/cobeylab/imprinting).

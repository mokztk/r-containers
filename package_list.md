There are 310 packages.

``` r
library(tidyverse)

.packages(all.available = TRUE) %>%
    sessioninfo::package_info(pkgs = ., include_base = TRUE) %>%
    as_tibble() %>%
    select(package, ondiskversion, date, source, is_base) %>%
    mutate(
      source = if_else(source == "local" & is_base == TRUE, "(Base)", source)
    ) %>%
    select(-is_base) %>% 
    knitr::kable()
```

| package           | ondiskversion | date       | source         |
|:------------------|:--------------|:-----------|:---------------|
| abind             | 1.4-8         | 2024-09-12 | RSPM           |
| askpass           | 1.2.1         | 2024-10-04 | RSPM           |
| backports         | 1.5.0         | 2024-05-23 | RSPM           |
| base              | 4.5.2         | 2026-03-05 | (Base)         |
| base64enc         | 0.1-6         | 2026-02-02 | RSPM           |
| basepenguins      | 0.1.0         | 2025-04-08 | RSPM           |
| beeswarm          | 0.4.0         | 2021-06-01 | RSPM           |
| bigD              | 0.3.1         | 2025-04-03 | RSPM           |
| BiocManager       | 1.30.27       | 2025-11-14 | RSPM           |
| bit               | 4.6.0         | 2025-03-06 | RSPM           |
| bit64             | 4.6.0-1       | 2025-01-16 | RSPM           |
| bitops            | 1.0-9         | 2024-10-03 | RSPM           |
| blob              | 1.3.0         | 2026-01-14 | RSPM           |
| boot              | 1.3-32        | 2025-08-29 | CRAN (R 4.5.2) |
| brew              | 1.0-10        | 2023-12-16 | RSPM           |
| brio              | 1.1.5         | 2024-04-24 | RSPM           |
| broom             | 1.0.12        | 2026-01-27 | RSPM           |
| bslib             | 0.10.0        | 2026-01-26 | RSPM           |
| cachem            | 1.1.0         | 2024-05-16 | RSPM           |
| Cairo             | 1.7-0         | 2025-10-29 | RSPM           |
| callr             | 3.7.6         | 2024-03-25 | RSPM           |
| car               | 3.1-5         | 2026-02-03 | RSPM           |
| carData           | 3.0-6         | 2026-01-30 | RSPM           |
| cards             | 0.7.1         | 2025-12-02 | RSPM           |
| cardx             | 0.3.2         | 2026-02-05 | RSPM           |
| cellranger        | 1.1.0         | 2016-07-27 | RSPM           |
| checkmate         | 2.3.4         | 2026-02-03 | RSPM           |
| class             | 7.3-23        | 2025-01-01 | CRAN (R 4.5.2) |
| cli               | 3.6.5         | 2025-04-23 | RSPM           |
| clipr             | 0.8.0         | 2022-02-22 | RSPM           |
| clisymbols        | 1.2.0         | 2017-05-21 | RSPM           |
| cluster           | 2.1.8.2       | 2026-02-05 | RSPM (R 4.5.0) |
| cmprsk            | 2.2-12        | 2024-05-19 | RSPM           |
| codetools         | 0.2-20        | 2024-03-31 | CRAN (R 4.5.2) |
| colorspace        | 2.1-2         | 2025-09-22 | RSPM           |
| commonmark        | 2.0.0         | 2025-07-07 | RSPM           |
| compiler          | 4.5.2         | 2026-03-05 | (Base)         |
| conflicted        | 1.2.0         | 2023-02-01 | RSPM           |
| corrplot          | 0.95          | 2024-10-14 | RSPM           |
| cowplot           | 1.2.0         | 2025-07-07 | RSPM           |
| cpp11             | 0.5.3         | 2026-01-20 | RSPM           |
| crayon            | 1.5.3         | 2024-06-20 | RSPM           |
| credentials       | 2.0.3         | 2025-09-12 | RSPM           |
| curl              | 7.0.0         | 2025-08-19 | RSPM           |
| data.table        | 1.18.2.1      | 2026-01-27 | RSPM           |
| datasets          | 4.5.2         | 2026-03-05 | (Base)         |
| datawizard        | 1.3.0         | 2025-10-11 | RSPM           |
| DBI               | 1.3.0         | 2026-02-25 | RSPM           |
| dbplyr            | 2.5.2         | 2026-02-13 | RSPM           |
| Deriv             | 4.2.0         | 2025-06-20 | RSPM           |
| desc              | 1.4.3         | 2023-12-10 | RSPM           |
| devEMF            | 4.5-1         | 2025-03-24 | RSPM           |
| devtools          | 2.4.6         | 2025-10-03 | RSPM           |
| DiagrammeR        | 1.0.11        | 2024-02-02 | RSPM           |
| diffobj           | 0.3.6         | 2025-04-21 | RSPM           |
| digest            | 0.6.39        | 2025-11-19 | RSPM           |
| doBy              | 4.7.1         | 2025-12-02 | RSPM           |
| docopt            | 0.7.2         | 2025-03-25 | RSPM (R 4.5.2) |
| downlit           | 0.4.5         | 2025-11-14 | RSPM           |
| dplyr             | 1.2.0         | 2026-02-03 | RSPM           |
| dtplyr            | 1.3.3         | 2026-02-11 | RSPM           |
| ellipsis          | 0.3.2         | 2021-04-29 | RSPM           |
| evaluate          | 1.0.5         | 2025-08-27 | RSPM           |
| exactRankTests    | 0.8-36        | 2026-03-09 | RSPM           |
| export            | 0.3.2         | 2025-08-18 | RSPM           |
| fansi             | 1.0.7         | 2025-11-19 | RSPM           |
| farver            | 2.1.2         | 2024-05-13 | RSPM           |
| fastmap           | 1.2.0         | 2024-05-15 | RSPM           |
| flextable         | 0.9.11        | 2026-02-13 | RSPM           |
| fontawesome       | 0.5.3         | 2024-11-16 | RSPM           |
| fontBitstreamVera | 0.1.1         | 2017-02-01 | RSPM           |
| fontLiberation    | 0.1.0         | 2016-10-15 | RSPM           |
| fontquiver        | 0.2.1         | 2017-02-01 | RSPM           |
| forcats           | 1.0.1         | 2025-09-25 | RSPM           |
| foreach           | 1.5.2         | 2022-02-02 | RSPM           |
| forecast          | 9.0.1         | 2026-02-14 | RSPM           |
| foreign           | 0.8-91        | 2026-01-29 | RSPM (R 4.5.0) |
| formatR           | 1.14          | 2023-01-17 | RSPM           |
| formattable       | 0.2.1         | 2021-01-07 | RSPM           |
| Formula           | 1.2-5         | 2023-02-24 | RSPM           |
| fracdiff          | 1.5-3         | 2024-02-01 | RSPM           |
| fs                | 1.6.7         | 2026-03-06 | RSPM           |
| fst               | 0.9.8         | 2022-02-08 | RSPM           |
| fstcore           | 0.10.0        | 2025-02-10 | RSPM           |
| ftExtra           | 0.6.4         | 2024-05-10 | RSPM           |
| furrr             | 0.3.1         | 2022-08-15 | RSPM           |
| future            | 1.69.0        | 2026-01-16 | RSPM           |
| gargle            | 1.6.1         | 2026-01-29 | RSPM           |
| gdtools           | 0.5.0         | 2026-02-09 | RSPM           |
| generics          | 0.1.4         | 2025-05-09 | RSPM           |
| gert              | 2.3.1         | 2026-01-11 | RSPM           |
| GGally            | 2.4.0         | 2025-08-23 | RSPM           |
| ggbeeswarm        | 0.7.3         | 2025-11-29 | RSPM           |
| ggeffects         | 2.3.2         | 2025-12-16 | RSPM           |
| ggfortify         | 0.4.19        | 2025-07-27 | RSPM           |
| gghighlight       | 0.5.0         | 2025-06-14 | RSPM           |
| ggmice            | 0.1.1         | 2025-07-30 | RSPM           |
| ggplot2           | 4.0.2         | 2026-02-03 | RSPM           |
| ggpubr            | 0.6.3         | 2026-02-24 | RSPM           |
| ggrastr           | 1.0.2         | 2023-06-01 | RSPM           |
| ggrepel           | 0.9.7         | 2026-02-25 | RSPM           |
| ggsci             | 4.2.0         | 2025-12-17 | RSPM           |
| ggsignif          | 0.6.4         | 2022-10-13 | RSPM           |
| ggstats           | 0.13.0        | 2026-03-06 | RSPM           |
| ggsurvfit         | 1.2.0         | 2025-09-13 | RSPM           |
| ggtext            | 0.1.2         | 2022-09-16 | RSPM           |
| gh                | 1.5.0         | 2025-05-26 | RSPM           |
| gitcreds          | 0.1.2         | 2022-09-08 | RSPM           |
| glmmTMB           | 1.1.14        | 2026-01-15 | RSPM           |
| glmnet            | 4.1-10        | 2025-07-17 | RSPM           |
| glmnetUtils       | 1.1.9         | 2023-09-10 | RSPM           |
| globals           | 0.19.0        | 2026-02-02 | RSPM           |
| glue              | 1.8.0         | 2024-09-30 | RSPM           |
| googledrive       | 2.1.2         | 2025-09-10 | RSPM           |
| googlesheets4     | 1.1.2         | 2025-09-03 | RSPM           |
| graphics          | 4.5.2         | 2026-03-05 | (Base)         |
| grDevices         | 4.5.2         | 2026-03-05 | (Base)         |
| grid              | 4.5.2         | 2026-03-05 | (Base)         |
| gridExtra         | 2.3           | 2017-09-09 | RSPM           |
| gridtext          | 0.1.6         | 2026-02-19 | RSPM           |
| gt                | 1.3.0         | 2026-01-22 | RSPM           |
| gtable            | 0.3.6         | 2024-10-25 | RSPM           |
| gtsummary         | 2.5.0         | 2025-12-05 | RSPM           |
| haven             | 2.5.5         | 2025-05-30 | RSPM           |
| here              | 1.0.2         | 2025-09-15 | RSPM           |
| hexbin            | 1.28.5        | 2024-11-13 | RSPM           |
| highr             | 0.12          | 2026-03-06 | RSPM           |
| Hmisc             | 5.2-5         | 2026-01-09 | RSPM           |
| hms               | 1.1.4         | 2025-10-17 | RSPM           |
| htmlTable         | 2.4.3         | 2024-07-21 | RSPM           |
| htmltools         | 0.5.9         | 2025-12-04 | RSPM           |
| htmlwidgets       | 1.6.4         | 2023-12-06 | RSPM           |
| httpuv            | 1.6.16        | 2025-04-16 | RSPM           |
| httr              | 1.4.8         | 2026-02-13 | RSPM           |
| httr2             | 1.2.2         | 2025-12-08 | RSPM           |
| ids               | 1.0.1         | 2017-05-31 | RSPM           |
| igraph            | 2.2.2         | 2026-02-12 | RSPM           |
| ini               | 0.3.1         | 2018-05-20 | RSPM           |
| insight           | 1.4.6         | 2026-02-04 | RSPM           |
| isoband           | 0.3.0         | 2025-12-07 | RSPM           |
| iterators         | 1.0.14        | 2022-02-05 | RSPM           |
| jomo              | 2.7-6         | 2023-04-15 | RSPM           |
| jpeg              | 0.1-11        | 2025-03-21 | RSPM           |
| jquerylib         | 0.1.4         | 2021-04-26 | RSPM           |
| jsonlite          | 2.0.0         | 2025-03-27 | RSPM           |
| juicyjuice        | 0.1.0         | 2022-11-10 | RSPM           |
| katex             | 1.5.0         | 2024-09-29 | RSPM           |
| KernSmooth        | 2.23-26       | 2025-01-01 | CRAN (R 4.5.2) |
| knitr             | 1.51          | 2025-12-20 | RSPM           |
| labeling          | 0.4.3         | 2023-08-29 | RSPM           |
| later             | 1.4.8         | 2026-03-05 | RSPM           |
| lattice           | 0.22-9        | 2026-02-09 | RSPM (R 4.5.0) |
| lifecycle         | 1.0.5         | 2026-01-08 | RSPM           |
| listenv           | 0.10.0        | 2025-11-02 | RSPM           |
| litedown          | 0.9           | 2025-12-18 | RSPM           |
| littler           | 0.3.22        | 2026-02-04 | RSPM (R 4.5.2) |
| lme4              | 2.0-1         | 2026-03-05 | RSPM           |
| lmtest            | 0.9-40        | 2022-03-21 | RSPM           |
| lubridate         | 1.9.5         | 2026-02-04 | RSPM           |
| magrittr          | 2.0.4         | 2025-09-12 | RSPM           |
| markdown          | 2.0           | 2025-03-23 | RSPM           |
| MASS              | 7.3-65        | 2025-02-28 | CRAN (R 4.5.2) |
| Matrix            | 1.7-4         | 2025-08-28 | CRAN (R 4.5.2) |
| MatrixModels      | 0.5-4         | 2025-03-26 | RSPM           |
| maxstat           | 0.7-26        | 2025-05-02 | RSPM           |
| memoise           | 2.0.1         | 2021-11-26 | RSPM           |
| methods           | 4.5.2         | 2026-03-05 | (Base)         |
| mgcv              | 1.9-4         | 2025-11-07 | RSPM (R 4.5.0) |
| mice              | 3.19.0        | 2025-12-10 | RSPM           |
| microbenchmark    | 1.5.0         | 2024-09-04 | RSPM           |
| mime              | 0.13          | 2025-03-17 | RSPM           |
| minidown          | 0.4.0         | 2022-02-08 | RSPM           |
| miniUI            | 0.1.2         | 2025-04-17 | RSPM           |
| minqa             | 1.2.8         | 2024-08-17 | RSPM           |
| mitml             | 0.4-5         | 2023-03-08 | RSPM           |
| modelr            | 0.1.11        | 2023-03-22 | RSPM           |
| mvtnorm           | 1.3-3         | 2025-01-10 | RSPM           |
| nlme              | 3.1-168       | 2025-03-31 | CRAN (R 4.5.2) |
| nloptr            | 2.2.1         | 2025-03-17 | RSPM           |
| nnet              | 7.3-20        | 2025-01-01 | CRAN (R 4.5.2) |
| numDeriv          | 2016.8-1.1    | 2019-06-06 | RSPM           |
| officer           | 0.7.3         | 2026-01-16 | RSPM           |
| openssl           | 2.3.5         | 2026-02-26 | RSPM           |
| openxlsx          | 4.2.8.1       | 2025-10-31 | RSPM           |
| ordinal           | 2025.12-29    | 2026-01-10 | RSPM           |
| otel              | 0.2.0         | 2025-08-29 | RSPM           |
| pacman            | 0.5.1         | 2019-03-11 | RSPM           |
| pak               | 0.9.2         | 2025-12-22 | RSPM (R 4.5.0) |
| palmerpenguins    | 0.1.1         | 2022-08-15 | RSPM           |
| pan               | 1.9           | 2023-12-07 | RSPM           |
| parallel          | 4.5.2         | 2026-03-05 | (Base)         |
| parallelly        | 1.46.1        | 2026-01-08 | RSPM           |
| patchwork         | 1.3.2         | 2025-08-25 | RSPM           |
| pbkrtest          | 0.5.5         | 2025-07-18 | RSPM           |
| pillar            | 1.11.1        | 2025-09-17 | RSPM           |
| pkgbuild          | 1.4.8         | 2025-05-26 | RSPM           |
| pkgconfig         | 2.0.3         | 2019-09-22 | RSPM           |
| pkgdown           | 2.2.0         | 2025-11-06 | RSPM           |
| pkgload           | 1.5.0         | 2026-02-03 | RSPM           |
| png               | 0.1-8         | 2022-11-29 | RSPM           |
| polynom           | 1.4-1         | 2022-04-11 | RSPM           |
| praise            | 1.0.0         | 2015-08-11 | RSPM           |
| prettyunits       | 1.2.0         | 2023-09-24 | RSPM           |
| pROC              | 1.19.0.1      | 2025-07-31 | RSPM           |
| processx          | 3.8.6         | 2025-02-21 | RSPM           |
| profvis           | 0.4.0         | 2024-09-20 | RSPM           |
| progress          | 1.2.3         | 2023-12-06 | RSPM           |
| promises          | 1.5.0         | 2025-11-01 | RSPM           |
| ps                | 1.9.1         | 2025-04-12 | RSPM           |
| purrr             | 1.2.1         | 2026-01-09 | RSPM           |
| quantreg          | 6.1           | 2025-03-10 | RSPM           |
| quarto            | 1.5.1         | 2025-09-04 | RSPM           |
| R.cache           | 0.17.0        | 2025-05-02 | RSPM           |
| R.methodsS3       | 1.8.2         | 2022-06-13 | RSPM           |
| R.oo              | 1.27.1        | 2025-05-02 | RSPM           |
| R.utils           | 2.13.0        | 2025-02-24 | RSPM           |
| R6                | 2.6.1         | 2025-02-15 | RSPM           |
| ragg              | 1.5.1         | 2026-03-06 | RSPM           |
| rappdirs          | 0.3.4         | 2026-01-17 | RSPM           |
| rbibutils         | 2.4.1         | 2026-01-21 | RSPM           |
| rcmdcheck         | 1.4.0         | 2021-09-27 | RSPM           |
| RColorBrewer      | 1.1-3         | 2022-04-03 | RSPM           |
| Rcpp              | 1.1.1         | 2026-01-10 | RSPM           |
| RcppArmadillo     | 15.2.3-1      | 2025-12-17 | RSPM           |
| RcppEigen         | 0.3.4.0.2     | 2024-08-24 | RSPM           |
| RcppTOML          | 0.2.3         | 2025-03-08 | RSPM           |
| Rdpack            | 2.6.6         | 2026-02-08 | RSPM           |
| reactable         | 0.4.5         | 2025-12-01 | RSPM           |
| reactR            | 0.6.1         | 2024-09-14 | RSPM           |
| readr             | 2.2.0         | 2026-02-19 | RSPM           |
| readxl            | 1.4.5         | 2025-03-07 | RSPM           |
| reformulas        | 0.4.4         | 2026-02-02 | RSPM           |
| rematch           | 2.0.0         | 2023-08-30 | RSPM           |
| rematch2          | 2.1.2         | 2020-05-01 | RSPM           |
| remotes           | 2.5.0         | 2024-03-17 | RSPM           |
| reprex            | 2.1.1         | 2024-07-06 | RSPM           |
| reticulate        | 1.45.0        | 2026-02-13 | RSPM           |
| rlang             | 1.1.7         | 2026-01-09 | RSPM           |
| rmarkdown         | 2.30          | 2025-09-28 | RSPM           |
| roxygen2          | 7.3.3         | 2025-09-03 | RSPM           |
| rpart             | 4.1.24        | 2025-01-07 | CRAN (R 4.5.2) |
| rprojroot         | 2.1.1         | 2025-08-26 | RSPM           |
| RSQLite           | 2.4.6         | 2026-02-06 | RSPM           |
| rstatix           | 0.7.3         | 2025-10-18 | RSPM           |
| rstudioapi        | 0.18.0        | 2026-01-16 | RSPM           |
| rversions         | 3.0.0         | 2025-10-09 | RSPM           |
| rvest             | 1.0.5         | 2025-08-29 | RSPM           |
| rvg               | 0.4.1         | 2026-02-16 | RSPM           |
| S7                | 0.2.1         | 2025-11-14 | RSPM           |
| sandwich          | 3.1-1         | 2024-09-15 | RSPM           |
| sass              | 0.4.10        | 2025-04-11 | RSPM           |
| scales            | 1.4.0         | 2025-04-24 | RSPM           |
| selectr           | 0.5-1         | 2025-12-17 | RSPM           |
| sessioninfo       | 1.2.3         | 2025-02-05 | RSPM           |
| shape             | 1.4.6.1       | 2024-02-23 | RSPM           |
| shiny             | 1.13.0        | 2026-02-20 | RSPM           |
| sourcetools       | 0.1.7-1       | 2023-02-01 | RSPM           |
| SparseM           | 1.84-2        | 2024-07-17 | RSPM           |
| spatial           | 7.3-18        | 2025-01-01 | CRAN (R 4.5.2) |
| splines           | 4.5.2         | 2026-03-05 | (Base)         |
| stargazer         | 5.2.3         | 2022-03-04 | RSPM           |
| stats             | 4.5.2         | 2026-03-05 | (Base)         |
| stats4            | 4.5.2         | 2026-03-05 | (Base)         |
| stringi           | 1.8.7         | 2025-03-27 | RSPM           |
| stringr           | 1.6.0         | 2025-11-04 | RSPM           |
| styler            | 1.11.0        | 2025-10-13 | RSPM           |
| survival          | 3.8-6         | 2026-01-16 | RSPM (R 4.5.0) |
| survminer         | 0.5.2         | 2026-02-25 | RSPM           |
| svglite           | 2.2.2         | 2025-10-21 | RSPM           |
| sys               | 3.4.3         | 2024-10-04 | RSPM           |
| systemfonts       | 1.3.2         | 2026-03-05 | RSPM           |
| tcltk             | 4.5.2         | 2026-03-05 | (Base)         |
| testthat          | 3.3.2         | 2026-01-11 | RSPM           |
| textshaping       | 1.0.5         | 2026-03-06 | RSPM           |
| tibble            | 3.3.1         | 2026-01-11 | RSPM           |
| tidylog           | 1.1.0         | 2024-05-08 | RSPM           |
| tidyplots         | 0.4.0         | 2026-01-08 | RSPM           |
| tidyr             | 1.3.2         | 2025-12-19 | RSPM           |
| tidyselect        | 1.2.1         | 2024-03-11 | RSPM           |
| tidyverse         | 2.0.0         | 2023-02-22 | RSPM           |
| timechange        | 0.4.0         | 2026-01-29 | RSPM           |
| timeDate          | 4052.112      | 2026-01-28 | RSPM           |
| tinytable         | 0.16.0        | 2026-02-11 | RSPM           |
| tinytex           | 0.58          | 2025-11-19 | RSPM           |
| TMB               | 1.9.19        | 2025-12-15 | RSPM           |
| tools             | 4.5.2         | 2026-03-05 | (Base)         |
| tzdb              | 0.5.0         | 2025-03-15 | RSPM           |
| ucminf            | 1.2.2         | 2024-06-24 | RSPM           |
| urca              | 1.3-4         | 2024-05-27 | RSPM           |
| urlchecker        | 1.0.1         | 2021-11-30 | RSPM           |
| usethis           | 3.2.1         | 2025-09-06 | RSPM           |
| utf8              | 1.2.6         | 2025-06-08 | RSPM           |
| utils             | 4.5.2         | 2026-03-05 | (Base)         |
| uuid              | 1.2-2         | 2026-01-23 | RSPM           |
| V8                | 8.0.1         | 2025-10-10 | RSPM           |
| vctrs             | 0.7.1         | 2026-01-23 | RSPM           |
| vipor             | 0.4.7         | 2023-12-18 | RSPM           |
| viridisLite       | 0.4.3         | 2026-02-04 | RSPM           |
| visNetwork        | 2.1.4         | 2025-09-04 | RSPM           |
| vroom             | 1.7.0         | 2026-01-27 | RSPM           |
| waldo             | 0.6.2         | 2025-07-11 | RSPM           |
| whisker           | 0.4.1         | 2022-12-05 | RSPM           |
| withr             | 3.0.2         | 2024-10-28 | RSPM           |
| xfun              | 0.56          | 2026-01-18 | RSPM           |
| xml2              | 1.5.2         | 2026-01-17 | RSPM           |
| xopen             | 1.0.1         | 2024-04-25 | RSPM           |
| xtable            | 1.8-8         | 2026-02-22 | RSPM           |
| yaml              | 2.3.12        | 2025-12-10 | RSPM           |
| zip               | 2.3.3         | 2025-05-13 | RSPM           |
| zoo               | 1.8-15        | 2025-12-15 | RSPM           |

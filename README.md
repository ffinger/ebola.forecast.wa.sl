
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Assessing the performance of real-time epidemic forecasts: A case study of the 2013–16 Ebola epidemic

This repository contains the data and code for our preprint:

> Sebastian Funk, Anton Camacho, Adam J. Kucharski, Rachel Lowe,
> Rosalind M. Eggo and W. John Edmunds. Assessing the performance of
> real-time epidemic forecasts: A case study of the 2013-16 Ebola
> epidemic. bioRxiv 177451. Online at \<<https://doi.org/10.1101/177451>
> \>.

### How to download or install

You can install the code and data as an R package,
`ebola.forecast.wa.sl`, from GitHub with:

``` r
devtools::install_github("sbfnk/ebola.forecast.wa.sl")
```

### Included data sets

The package includes five data sets. One of them contains the data of
Ebola cases from Western Area that was used for the analysis. It can be
loaded with

``` r
data(ebola_wa)
```

The other four data sets contain Monte-Carlo samples from the
semi-mechanistic model used for forecasts, as well as the three null
models. The data sets are called `samples_semi_mechanistic`,
`samples_bsts`, `samples_deterministic` and `samples_deterministic`, and
they can be loaded with

``` r
data(samples)
```

The data sets from the null models can be re-created using

``` r
samples_bsts <- null_model_bsts()
samples_deterministic <- null_model_deterministic()
samples_unfocused <- null_model_unfocused()
```

### Table and figures

The table and figures in the manuscript can be re-created using

``` r
t1 <- table1()
print(t1)
t2 <- table2()
print(t2)

library('cowplot')
p1 <- figure1()
save_plot("figure1.pdf", p1, base_aspect_ratio=3, base_height = 2.5)
p2 <- figure2()
save_plot("figure2.pdf", p2, base_aspect_ratio=3, base_height = 3)
p3 <- figure3()
save_plot("figure3.pdf", p3, base_width = 9, base_height=4.5)
p4 <- figure4()
save_plot("figure4.pdf", p4, base_aspect_ratio=1.71)
```

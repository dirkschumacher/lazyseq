
<!-- README.md is generated from README.Rmd. Please edit that file -->

# lazyseq

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The package `lazyseq` implements a lazy version of `base::list`. All
elements are only evaluated when they are needed. E.g. when you convert
the `lazy_list` to a normal `list` or when you access a single element.

All very experimental.

## Installation

``` r
remotes::install_github("dirkschumacher/lazyseq")
```

## Example

This is a basic example:

``` r
library(lazyseq)
content <- 42
ll <- lazy_list(
  (function() {print("eval"); 1})(), 
  (function() !!content)(), 
  stop("will never be executed")
)
ll
#> <lazy_list[3]>
ll[[1]]
#> [1] "eval"
#> [1] 1
ll[[2]]
#> [1] 42
as.list(ll[-3])
#> [1] "eval"
#> [[1]]
#> [1] 1
#> 
#> [[2]]
#> [1] 42
```

## Contribute

Feel free to contribute. Ideally post an issue first or ping me on
Twitter, but all contributions are welcome.

## Code of Conduct

Please note that the lazyseq project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

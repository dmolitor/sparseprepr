
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sparseprepr

<!-- badges: start -->

[![R-CMD-check](https://github.com/dmolitor/sparseprepr/workflows/R-CMD-check/badge.svg)](https://github.com/dmolitor/sparseprepr/actions)
[![Codecov test
coverage](https://codecov.io/gh/dmolitor/sparseprepr/branch/main/graph/badge.svg?token=PCAC1RA7GE)](https://codecov.io/gh/dmolitor/sparseprepr?branch=main)
[![pkgdown](https://github.com/dmolitor/sparseprepr/workflows/pkgdown/badge.svg)](https://github.com/dmolitor/sparseprepr/actions)
<!-- badges: end -->

The goal of sparseprepr is to enable common pre-processing actions for
sparse matrices and provide a more memory-efficient workflow for
modeling at scale.

## Installation

Install from [Github](https://github.com) with:

    # install.packages(devtools)
    devtools::install_github("dmolitor/sparseprepr")

## Core Functionality

The following toy example shows a number of the pre-processing features
that sparseprepr provides. The matrix is shown below:

``` r
library(sparseprepr)
#> 
#> Attaching package: 'sparseprepr'
#> The following object is masked from 'package:stats':
#> 
#>     cor

x
#> 10 x 8 sparse Matrix of class "dgCMatrix"
#>           x1    x2     x3 cor_with_x3 const_col const_col2 dup_x2 sparse_col
#>  [1,]  0.770  0.47  1.100       1.100         1          .   0.47          .
#>  [2,] -0.720  0.90  .           .             1          .   0.90          .
#>  [3,] -1.100  0.55  0.450       0.450         1          .   0.55          .
#>  [4,] -1.900  0.20  .           .             1          .   0.20          .
#>  [5,]  .      .     0.091       0.091         1          .   .             .
#>  [6,]  0.047  .    -0.100      -0.100         1          .   .             .
#>  [7,]  .      .     .           .             1          .   .             .
#>  [8,] -1.000  .     0.220       0.220         1          .   .             .
#>  [9,]  .     -0.97  .           .             1          .  -0.97          .
#> [10,]  0.180  .     0.640       0.540         1          .   .             1
```

This matrix has a number of contrived features; column `cor_with_x3` is
highly correlated with column `x3`, `const_col` and `const_col2` are
zero-variance columns, `dup_x2` is identical to `x2`, and `sparse_col`
is a highly sparse column.

-   Dropping highly correlated columns

    ``` r
    remove_correlated(x, threshold = 0.99)
    #> Warning: Column(s) 5, 6 have a standard deviation of 0
    #> 10 x 6 sparse Matrix of class "dgCMatrix"
    #>           x1    x2     x3 const_col const_col2 sparse_col
    #>  [1,]  0.770  0.47  1.100         1          .          .
    #>  [2,] -0.720  0.90  .             1          .          .
    #>  [3,] -1.100  0.55  0.450         1          .          .
    #>  [4,] -1.900  0.20  .             1          .          .
    #>  [5,]  .      .     0.091         1          .          .
    #>  [6,]  0.047  .    -0.100         1          .          .
    #>  [7,]  .      .     .             1          .          .
    #>  [8,] -1.000  .     0.220         1          .          .
    #>  [9,]  .     -0.97  .             1          .          .
    #> [10,]  0.180  .     0.640         1          .          1
    ```

-   Dropping constant columns

    ``` r
    remove_constant(x)
    #> 10 x 6 sparse Matrix of class "dgCMatrix"
    #>           x1    x2     x3 cor_with_x3 dup_x2 sparse_col
    #>  [1,]  0.770  0.47  1.100       1.100   0.47          .
    #>  [2,] -0.720  0.90  .           .       0.90          .
    #>  [3,] -1.100  0.55  0.450       0.450   0.55          .
    #>  [4,] -1.900  0.20  .           .       0.20          .
    #>  [5,]  .      .     0.091       0.091   .             .
    #>  [6,]  0.047  .    -0.100      -0.100   .             .
    #>  [7,]  .      .     .           .       .             .
    #>  [8,] -1.000  .     0.220       0.220   .             .
    #>  [9,]  .     -0.97  .           .      -0.97          .
    #> [10,]  0.180  .     0.640       0.540   .             1
    ```

-   Dropping duplicated columns

    ``` r
    remove_duplicate(x)
    #> 10 x 7 sparse Matrix of class "dgCMatrix"
    #>           x1    x2     x3 cor_with_x3 const_col const_col2 sparse_col
    #>  [1,]  0.770  0.47  1.100       1.100         1          .          .
    #>  [2,] -0.720  0.90  .           .             1          .          .
    #>  [3,] -1.100  0.55  0.450       0.450         1          .          .
    #>  [4,] -1.900  0.20  .           .             1          .          .
    #>  [5,]  .      .     0.091       0.091         1          .          .
    #>  [6,]  0.047  .    -0.100      -0.100         1          .          .
    #>  [7,]  .      .     .           .             1          .          .
    #>  [8,] -1.000  .     0.220       0.220         1          .          .
    #>  [9,]  .     -0.97  .           .             1          .          .
    #> [10,]  0.180  .     0.640       0.540         1          .          1
    ```

-   Dropping highly sparse columns

    ``` r
    remove_sparse(x, threshold = 0.9)
    #> 10 x 6 sparse Matrix of class "dgCMatrix"
    #>           x1    x2     x3 cor_with_x3 const_col dup_x2
    #>  [1,]  0.770  0.47  1.100       1.100         1   0.47
    #>  [2,] -0.720  0.90  .           .             1   0.90
    #>  [3,] -1.100  0.55  0.450       0.450         1   0.55
    #>  [4,] -1.900  0.20  .           .             1   0.20
    #>  [5,]  .      .     0.091       0.091         1   .   
    #>  [6,]  0.047  .    -0.100      -0.100         1   .   
    #>  [7,]  .      .     .           .             1   .   
    #>  [8,] -1.000  .     0.220       0.220         1   .   
    #>  [9,]  .     -0.97  .           .             1  -0.97
    #> [10,]  0.180  .     0.640       0.540         1   .
    ```

-   Append higher order terms:

    ``` r
    # Squared terms
    transform_cols(
      x[, 1:3], 
      fun = function(i) i^2, 
      which = paste0("x", 1:3), 
      name.sep = "squared"
    )
    #> 10 x 6 sparse Matrix of class "dgCMatrix"
    #>           x1    x2     x3 x1_squared x2_squared x3_squared
    #>  [1,]  0.770  0.47  1.100   0.592900     0.2209   1.210000
    #>  [2,] -0.720  0.90  .       0.518400     0.8100   .       
    #>  [3,] -1.100  0.55  0.450   1.210000     0.3025   0.202500
    #>  [4,] -1.900  0.20  .       3.610000     0.0400   .       
    #>  [5,]  .      .     0.091   .            .        0.008281
    #>  [6,]  0.047  .    -0.100   0.002209     .        0.010000
    #>  [7,]  .      .     .       .            .        .       
    #>  [8,] -1.000  .     0.220   1.000000     .        0.048400
    #>  [9,]  .     -0.97  .       .            0.9409   .       
    #> [10,]  0.180  .     0.640   0.032400     .        0.409600

    # Cubed terms
    transform_cols(
      x[, 1:3], 
      fun = function(i) i^3, 
      which = paste0("x", 1:3), 
      name.sep = "cubed"
    )
    #> 10 x 6 sparse Matrix of class "dgCMatrix"
    #>           x1    x2     x3     x1_cubed  x2_cubed     x3_cubed
    #>  [1,]  0.770  0.47  1.100  0.456533000  0.103823  1.331000000
    #>  [2,] -0.720  0.90  .     -0.373248000  0.729000  .          
    #>  [3,] -1.100  0.55  0.450 -1.331000000  0.166375  0.091125000
    #>  [4,] -1.900  0.20  .     -6.859000000  0.008000  .          
    #>  [5,]  .      .     0.091  .            .         0.000753571
    #>  [6,]  0.047  .    -0.100  0.000103823  .        -0.001000000
    #>  [7,]  .      .     .      .            .         .          
    #>  [8,] -1.000  .     0.220 -1.000000000  .         0.010648000
    #>  [9,]  .     -0.97  .      .           -0.912673  .          
    #> [10,]  0.180  .     0.640  0.005832000  .         0.262144000
    ```

## Piping Workflow

These same pre-processing steps can be utilized in a pipeline with the
magrittr `%>%`.

``` r
library(magrittr)

x %>%
  remove_constant() %>%
  remove_correlated(threshold = 0.99) %>%
  remove_duplicate() %>%
  remove_sparse(threshold = 0.9) %>%
  transform_cols(
    fun = function(i) i ^ 2,
    which = paste0("x", 1:3),
    name.sep = "squared"
  ) %>%
  transform_cols(
    fun = function(i) i ^ 3,
    which = paste0("x", 1:3),
    name.sep = "cubed"
  )
#> 10 x 9 sparse Matrix of class "dgCMatrix"
#>           x1    x2     x3 x1_squared x2_squared x3_squared     x1_cubed
#>  [1,]  0.770  0.47  1.100   0.592900     0.2209   1.210000  0.456533000
#>  [2,] -0.720  0.90  .       0.518400     0.8100   .        -0.373248000
#>  [3,] -1.100  0.55  0.450   1.210000     0.3025   0.202500 -1.331000000
#>  [4,] -1.900  0.20  .       3.610000     0.0400   .        -6.859000000
#>  [5,]  .      .     0.091   .            .        0.008281  .          
#>  [6,]  0.047  .    -0.100   0.002209     .        0.010000  0.000103823
#>  [7,]  .      .     .       .            .        .         .          
#>  [8,] -1.000  .     0.220   1.000000     .        0.048400 -1.000000000
#>  [9,]  .     -0.97  .       .            0.9409   .         .          
#> [10,]  0.180  .     0.640   0.032400     .        0.409600  0.005832000
#>        x2_cubed     x3_cubed
#>  [1,]  0.103823  1.331000000
#>  [2,]  0.729000  .          
#>  [3,]  0.166375  0.091125000
#>  [4,]  0.008000  .          
#>  [5,]  .         0.000753571
#>  [6,]  .        -0.001000000
#>  [7,]  .         .          
#>  [8,]  .         0.010648000
#>  [9,] -0.912673  .          
#> [10,]  .         0.262144000
```

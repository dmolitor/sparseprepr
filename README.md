
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sparseprepr

<!-- badges: start -->

[![R-CMD-check](https://github.com/dmolitor/sparseprepr/workflows/R-CMD-check/badge.svg)](https://github.com/dmolitor/sparseprepr/actions)
[![Codecov test
coverage](https://codecov.io/gh/dmolitor/sparseprepr/branch/main/graph/badge.svg?token=PCAC1RA7GE)](https://codecov.io/gh/dmolitor/sparseprepr?branch=main)
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
#>          x1    x2     x3 cor_with_x3 const_col const_col2 dup_x2 sparse_col
#>  [1,]  .    -0.54 -0.540      -0.540         1          .  -0.54          .
#>  [2,]  .     .     .           .             1          .   .             .
#>  [3,] -0.34  1.10  1.700       1.700         1          .   1.10          .
#>  [4,] -0.17 -1.70 -2.000      -2.000         1          .  -1.70          .
#>  [5,] -1.10  .     .           .             1          .   .             .
#>  [6,]  .     .    -0.640      -0.640         1          .   .             .
#>  [7,] -0.86 -0.58 -0.180      -0.180         1          .  -0.58          .
#>  [8,]  .     0.45 -0.097      -0.097         1          .   0.45          .
#>  [9,]  1.40 -0.97 -0.063      -0.063         1          .  -0.97          .
#> [10,]  .     .     0.100       .             1          .   .             1
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
    #>          x1    x2     x3 const_col const_col2 sparse_col
    #>  [1,]  .    -0.54 -0.540         1          .          .
    #>  [2,]  .     .     .             1          .          .
    #>  [3,] -0.34  1.10  1.700         1          .          .
    #>  [4,] -0.17 -1.70 -2.000         1          .          .
    #>  [5,] -1.10  .     .             1          .          .
    #>  [6,]  .     .    -0.640         1          .          .
    #>  [7,] -0.86 -0.58 -0.180         1          .          .
    #>  [8,]  .     0.45 -0.097         1          .          .
    #>  [9,]  1.40 -0.97 -0.063         1          .          .
    #> [10,]  .     .     0.100         1          .          1
    ```

-   Dropping constant columns

    ``` r
    remove_constant(x)
    #> 10 x 6 sparse Matrix of class "dgCMatrix"
    #>          x1    x2     x3 cor_with_x3 dup_x2 sparse_col
    #>  [1,]  .    -0.54 -0.540      -0.540  -0.54          .
    #>  [2,]  .     .     .           .       .             .
    #>  [3,] -0.34  1.10  1.700       1.700   1.10          .
    #>  [4,] -0.17 -1.70 -2.000      -2.000  -1.70          .
    #>  [5,] -1.10  .     .           .       .             .
    #>  [6,]  .     .    -0.640      -0.640   .             .
    #>  [7,] -0.86 -0.58 -0.180      -0.180  -0.58          .
    #>  [8,]  .     0.45 -0.097      -0.097   0.45          .
    #>  [9,]  1.40 -0.97 -0.063      -0.063  -0.97          .
    #> [10,]  .     .     0.100       .       .             1
    ```

-   Dropping duplicated columns

    ``` r
    remove_duplicate(x)
    #> 10 x 7 sparse Matrix of class "dgCMatrix"
    #>          x1    x2     x3 cor_with_x3 const_col const_col2 sparse_col
    #>  [1,]  .    -0.54 -0.540      -0.540         1          .          .
    #>  [2,]  .     .     .           .             1          .          .
    #>  [3,] -0.34  1.10  1.700       1.700         1          .          .
    #>  [4,] -0.17 -1.70 -2.000      -2.000         1          .          .
    #>  [5,] -1.10  .     .           .             1          .          .
    #>  [6,]  .     .    -0.640      -0.640         1          .          .
    #>  [7,] -0.86 -0.58 -0.180      -0.180         1          .          .
    #>  [8,]  .     0.45 -0.097      -0.097         1          .          .
    #>  [9,]  1.40 -0.97 -0.063      -0.063         1          .          .
    #> [10,]  .     .     0.100       .             1          .          1
    ```

-   Dropping highly sparse columns

    ``` r
    remove_sparse(x, threshold = 0.9)
    #> 10 x 6 sparse Matrix of class "dgCMatrix"
    #>          x1    x2     x3 cor_with_x3 const_col dup_x2
    #>  [1,]  .    -0.54 -0.540      -0.540         1  -0.54
    #>  [2,]  .     .     .           .             1   .   
    #>  [3,] -0.34  1.10  1.700       1.700         1   1.10
    #>  [4,] -0.17 -1.70 -2.000      -2.000         1  -1.70
    #>  [5,] -1.10  .     .           .             1   .   
    #>  [6,]  .     .    -0.640      -0.640         1   .   
    #>  [7,] -0.86 -0.58 -0.180      -0.180         1  -0.58
    #>  [8,]  .     0.45 -0.097      -0.097         1   0.45
    #>  [9,]  1.40 -0.97 -0.063      -0.063         1  -0.97
    #> [10,]  .     .     0.100       .             1   .
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
    #>          x1    x2     x3 x1_squared x2_squared x3_squared
    #>  [1,]  .    -0.54 -0.540     .          0.2916   0.291600
    #>  [2,]  .     .     .         .          .        .       
    #>  [3,] -0.34  1.10  1.700     0.1156     1.2100   2.890000
    #>  [4,] -0.17 -1.70 -2.000     0.0289     2.8900   4.000000
    #>  [5,] -1.10  .     .         1.2100     .        .       
    #>  [6,]  .     .    -0.640     .          .        0.409600
    #>  [7,] -0.86 -0.58 -0.180     0.7396     0.3364   0.032400
    #>  [8,]  .     0.45 -0.097     .          0.2025   0.009409
    #>  [9,]  1.40 -0.97 -0.063     1.9600     0.9409   0.003969
    #> [10,]  .     .     0.100     .          .        0.010000

    # Cubed terms
    transform_cols(
      x[, 1:3], 
      fun = function(i) i^3, 
      which = paste0("x", 1:3), 
      name.sep = "cubed"
    )
    #> 10 x 6 sparse Matrix of class "dgCMatrix"
    #>          x1    x2     x3  x1_cubed  x2_cubed     x3_cubed
    #>  [1,]  .    -0.54 -0.540  .        -0.157464 -0.157464000
    #>  [2,]  .     .     .      .         .         .          
    #>  [3,] -0.34  1.10  1.700 -0.039304  1.331000  4.913000000
    #>  [4,] -0.17 -1.70 -2.000 -0.004913 -4.913000 -8.000000000
    #>  [5,] -1.10  .     .     -1.331000  .         .          
    #>  [6,]  .     .    -0.640  .         .        -0.262144000
    #>  [7,] -0.86 -0.58 -0.180 -0.636056 -0.195112 -0.005832000
    #>  [8,]  .     0.45 -0.097  .         0.091125 -0.000912673
    #>  [9,]  1.40 -0.97 -0.063  2.744000 -0.912673 -0.000250047
    #> [10,]  .     .     0.100  .         .         0.001000000
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
#>          x1    x2     x3 x1_squared x2_squared x3_squared  x1_cubed  x2_cubed
#>  [1,]  .    -0.54 -0.540     .          0.2916   0.291600  .        -0.157464
#>  [2,]  .     .     .         .          .        .         .         .       
#>  [3,] -0.34  1.10  1.700     0.1156     1.2100   2.890000 -0.039304  1.331000
#>  [4,] -0.17 -1.70 -2.000     0.0289     2.8900   4.000000 -0.004913 -4.913000
#>  [5,] -1.10  .     .         1.2100     .        .        -1.331000  .       
#>  [6,]  .     .    -0.640     .          .        0.409600  .         .       
#>  [7,] -0.86 -0.58 -0.180     0.7396     0.3364   0.032400 -0.636056 -0.195112
#>  [8,]  .     0.45 -0.097     .          0.2025   0.009409  .         0.091125
#>  [9,]  1.40 -0.97 -0.063     1.9600     0.9409   0.003969  2.744000 -0.912673
#> [10,]  .     .     0.100     .          .        0.010000  .         .       
#>           x3_cubed
#>  [1,] -0.157464000
#>  [2,]  .          
#>  [3,]  4.913000000
#>  [4,] -8.000000000
#>  [5,]  .          
#>  [6,] -0.262144000
#>  [7,] -0.005832000
#>  [8,] -0.000912673
#>  [9,] -0.000250047
#> [10,]  0.001000000
```

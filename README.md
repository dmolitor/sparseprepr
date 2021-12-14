
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
that sparseprepr provides.

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
#>  [1,]  .     0.66 -0.400      -0.400         1          .   0.66          .
#>  [2,]  .     .     .           .             1          .   .             .
#>  [3,] -0.56 -1.10  0.500       0.500         1          .  -1.10          .
#>  [4,] -0.27 -0.46  0.096       0.096         1          .  -0.46          .
#>  [5,] -0.94  .     .           .             1          .   .             .
#>  [6,]  0.68 -1.90 -0.110      -0.110         1          .  -1.90          .
#>  [7,]  1.20  1.60  .           .             1          .   1.60          .
#>  [8,]  .     2.80  .           .             1          .   2.80          .
#>  [9,]  .     1.50  .           .             1          .   1.50          .
#> [10,] -0.19  0.11  0.100       .             1          .   0.11          1
```

The matrix shown above has a number of contrived features; column
`cor_with_x3` is highly correlated with column `x3`, `const_col` and
`const_col2` are zero-variance columns, `dup_x2` is identical to `x2`,
and `sparse_col` is a highly sparse column. Common pre-processing steps
provided by sparseprepr include:

-   Dropping highly correlated columns

    ``` r
    remove_correlated(x, threshold = 0.99)
    #> Warning: Column(s) 5, 6 have a standard deviation of 0
    #> 10 x 7 sparse Matrix of class "dgCMatrix"
    #>          x1    x2     x3 cor_with_x3 const_col const_col2 sparse_col
    #>  [1,]  .     0.66 -0.400      -0.400         1          .          .
    #>  [2,]  .     .     .           .             1          .          .
    #>  [3,] -0.56 -1.10  0.500       0.500         1          .          .
    #>  [4,] -0.27 -0.46  0.096       0.096         1          .          .
    #>  [5,] -0.94  .     .           .             1          .          .
    #>  [6,]  0.68 -1.90 -0.110      -0.110         1          .          .
    #>  [7,]  1.20  1.60  .           .             1          .          .
    #>  [8,]  .     2.80  .           .             1          .          .
    #>  [9,]  .     1.50  .           .             1          .          .
    #> [10,] -0.19  0.11  0.100       .             1          .          1
    ```

-   Dropping empty columns

    ``` r
    remove_empty(x)
    #> 10 x 7 sparse Matrix of class "dgCMatrix"
    #>          x1    x2     x3 cor_with_x3 const_col dup_x2 sparse_col
    #>  [1,]  .     0.66 -0.400      -0.400         1   0.66          .
    #>  [2,]  .     .     .           .             1   .             .
    #>  [3,] -0.56 -1.10  0.500       0.500         1  -1.10          .
    #>  [4,] -0.27 -0.46  0.096       0.096         1  -0.46          .
    #>  [5,] -0.94  .     .           .             1   .             .
    #>  [6,]  0.68 -1.90 -0.110      -0.110         1  -1.90          .
    #>  [7,]  1.20  1.60  .           .             1   1.60          .
    #>  [8,]  .     2.80  .           .             1   2.80          .
    #>  [9,]  .     1.50  .           .             1   1.50          .
    #> [10,] -0.19  0.11  0.100       .             1   0.11          1
    ```

-   Dropping constant columns

    ``` r
    remove_constant(x)
    #> 10 x 6 sparse Matrix of class "dgCMatrix"
    #>          x1    x2     x3 cor_with_x3 dup_x2 sparse_col
    #>  [1,]  .     0.66 -0.400      -0.400   0.66          .
    #>  [2,]  .     .     .           .       .             .
    #>  [3,] -0.56 -1.10  0.500       0.500  -1.10          .
    #>  [4,] -0.27 -0.46  0.096       0.096  -0.46          .
    #>  [5,] -0.94  .     .           .       .             .
    #>  [6,]  0.68 -1.90 -0.110      -0.110  -1.90          .
    #>  [7,]  1.20  1.60  .           .       1.60          .
    #>  [8,]  .     2.80  .           .       2.80          .
    #>  [9,]  .     1.50  .           .       1.50          .
    #> [10,] -0.19  0.11  0.100       .       0.11          1
    ```

-   Dropping duplicated columns

    ``` r
    remove_duplicate(x)
    #> 10 x 7 sparse Matrix of class "dgCMatrix"
    #>          x1    x2     x3 cor_with_x3 const_col const_col2 sparse_col
    #>  [1,]  .     0.66 -0.400      -0.400         1          .          .
    #>  [2,]  .     .     .           .             1          .          .
    #>  [3,] -0.56 -1.10  0.500       0.500         1          .          .
    #>  [4,] -0.27 -0.46  0.096       0.096         1          .          .
    #>  [5,] -0.94  .     .           .             1          .          .
    #>  [6,]  0.68 -1.90 -0.110      -0.110         1          .          .
    #>  [7,]  1.20  1.60  .           .             1          .          .
    #>  [8,]  .     2.80  .           .             1          .          .
    #>  [9,]  .     1.50  .           .             1          .          .
    #> [10,] -0.19  0.11  0.100       .             1          .          1
    ```

-   Dropping highly sparse columns

    ``` r
    remove_sparse(x, threshold = 0.9)
    #> 10 x 6 sparse Matrix of class "dgCMatrix"
    #>          x1    x2     x3 cor_with_x3 const_col dup_x2
    #>  [1,]  .     0.66 -0.400      -0.400         1   0.66
    #>  [2,]  .     .     .           .             1   .   
    #>  [3,] -0.56 -1.10  0.500       0.500         1  -1.10
    #>  [4,] -0.27 -0.46  0.096       0.096         1  -0.46
    #>  [5,] -0.94  .     .           .             1   .   
    #>  [6,]  0.68 -1.90 -0.110      -0.110         1  -1.90
    #>  [7,]  1.20  1.60  .           .             1   1.60
    #>  [8,]  .     2.80  .           .             1   2.80
    #>  [9,]  .     1.50  .           .             1   1.50
    #> [10,] -0.19  0.11  0.100       .             1   0.11
    ```

-   Transforming matrix columns:

    ``` r
    # Append squared terms
    transform_cols(
      x[, 1:3], 
      fun = function(i) i^2, 
      which = paste0("x", 2:3), 
      name.sep = "squared"
    )
    #> 10 x 5 sparse Matrix of class "dgCMatrix"
    #>          x1    x2     x3 x2_squared x3_squared
    #>  [1,]  .     0.66 -0.400     0.4356   0.160000
    #>  [2,]  .     .     .         .        .       
    #>  [3,] -0.56 -1.10  0.500     1.2100   0.250000
    #>  [4,] -0.27 -0.46  0.096     0.2116   0.009216
    #>  [5,] -0.94  .     .         .        .       
    #>  [6,]  0.68 -1.90 -0.110     3.6100   0.012100
    #>  [7,]  1.20  1.60  .         2.5600   .       
    #>  [8,]  .     2.80  .         7.8400   .       
    #>  [9,]  .     1.50  .         2.2500   .       
    #> [10,] -0.19  0.11  0.100     0.0121   0.010000

    # Append cubed terms
    transform_cols(
      x[, 1:3], 
      fun = function(i) i^3, 
      which = paste0("x", 2:3), 
      name.sep = "cubed"
    )
    #> 10 x 5 sparse Matrix of class "dgCMatrix"
    #>          x1    x2     x3  x2_cubed     x3_cubed
    #>  [1,]  .     0.66 -0.400  0.287496 -0.064000000
    #>  [2,]  .     .     .      .         .          
    #>  [3,] -0.56 -1.10  0.500 -1.331000  0.125000000
    #>  [4,] -0.27 -0.46  0.096 -0.097336  0.000884736
    #>  [5,] -0.94  .     .      .         .          
    #>  [6,]  0.68 -1.90 -0.110 -6.859000 -0.001331000
    #>  [7,]  1.20  1.60  .      4.096000  .          
    #>  [8,]  .     2.80  .     21.952000  .          
    #>  [9,]  .     1.50  .      3.375000  .          
    #> [10,] -0.19  0.11  0.100  0.001331  0.001000000
    ```

## Piping Workflow

These same pre-processing steps can be utilized in a more user-friendly
manner via the magrittr pipe (`%>%`) or the base pipe (`|>` - R 4.1 or
greater).

``` r
x |>
  remove_constant() |>
  remove_correlated(threshold = 0.99) |>
  remove_duplicate() |>
  remove_sparse(threshold = 0.9) |>
  transform_cols(
    fun = function(i) i ^ 2,
    which = paste0("x", 2:3),
    name.sep = "squared"
  ) |>
  transform_cols(
    fun = function(i) i ^ 3,
    which = paste0("x", 2:3),
    name.sep = "cubed"
  )
#> 10 x 8 sparse Matrix of class "dgCMatrix"
#>          x1    x2     x3 cor_with_x3 x2_squared x3_squared  x2_cubed
#>  [1,]  .     0.66 -0.400      -0.400     0.4356   0.160000  0.287496
#>  [2,]  .     .     .           .         .        .         .       
#>  [3,] -0.56 -1.10  0.500       0.500     1.2100   0.250000 -1.331000
#>  [4,] -0.27 -0.46  0.096       0.096     0.2116   0.009216 -0.097336
#>  [5,] -0.94  .     .           .         .        .         .       
#>  [6,]  0.68 -1.90 -0.110      -0.110     3.6100   0.012100 -6.859000
#>  [7,]  1.20  1.60  .           .         2.5600   .         4.096000
#>  [8,]  .     2.80  .           .         7.8400   .        21.952000
#>  [9,]  .     1.50  .           .         2.2500   .         3.375000
#> [10,] -0.19  0.11  0.100       .         0.0121   0.010000  0.001331
#>           x3_cubed
#>  [1,] -0.064000000
#>  [2,]  .          
#>  [3,]  0.125000000
#>  [4,]  0.000884736
#>  [5,]  .          
#>  [6,] -0.001331000
#>  [7,]  .          
#>  [8,]  .          
#>  [9,]  .          
#> [10,]  0.001000000
```

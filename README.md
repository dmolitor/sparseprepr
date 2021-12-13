
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
#>           x1     x2    x3 cor_with_x3 const_col const_col2 dup_x2 sparse_col
#>  [1,] -0.370  .      .           .            1          .  .              .
#>  [2,]  .      .      2.00        2.00         1          .  .              .
#>  [3,]  0.600  1.500  .           .            1          .  1.500          .
#>  [4,]  .     -0.100 -0.74       -0.74         1          . -0.100          .
#>  [5,]  .      0.360  1.30        1.30         1          .  0.360          .
#>  [6,] -0.086  .      0.63        0.63         1          .  .              .
#>  [7,] -1.300 -1.300 -1.30       -1.30         1          . -1.300          .
#>  [8,]  .      0.140 -0.38       -0.38         1          .  0.140          .
#>  [9,]  .      1.400  .           .            1          .  1.400          .
#> [10,]  .      0.071 -1.70       -1.80         1          .  0.071          1
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
    #>           x1     x2    x3 const_col const_col2 sparse_col
    #>  [1,] -0.370  .      .            1          .          .
    #>  [2,]  .      .      2.00         1          .          .
    #>  [3,]  0.600  1.500  .            1          .          .
    #>  [4,]  .     -0.100 -0.74         1          .          .
    #>  [5,]  .      0.360  1.30         1          .          .
    #>  [6,] -0.086  .      0.63         1          .          .
    #>  [7,] -1.300 -1.300 -1.30         1          .          .
    #>  [8,]  .      0.140 -0.38         1          .          .
    #>  [9,]  .      1.400  .            1          .          .
    #> [10,]  .      0.071 -1.70         1          .          1
    ```

-   Dropping constant columns

    ``` r
    remove_constant(x)
    #> 10 x 6 sparse Matrix of class "dgCMatrix"
    #>           x1     x2    x3 cor_with_x3 dup_x2 sparse_col
    #>  [1,] -0.370  .      .           .     .              .
    #>  [2,]  .      .      2.00        2.00  .              .
    #>  [3,]  0.600  1.500  .           .     1.500          .
    #>  [4,]  .     -0.100 -0.74       -0.74 -0.100          .
    #>  [5,]  .      0.360  1.30        1.30  0.360          .
    #>  [6,] -0.086  .      0.63        0.63  .              .
    #>  [7,] -1.300 -1.300 -1.30       -1.30 -1.300          .
    #>  [8,]  .      0.140 -0.38       -0.38  0.140          .
    #>  [9,]  .      1.400  .           .     1.400          .
    #> [10,]  .      0.071 -1.70       -1.80  0.071          1
    ```

-   Dropping duplicated columns

    ``` r
    remove_duplicate(x)
    #> 10 x 7 sparse Matrix of class "dgCMatrix"
    #>           x1     x2    x3 cor_with_x3 const_col const_col2 sparse_col
    #>  [1,] -0.370  .      .           .            1          .          .
    #>  [2,]  .      .      2.00        2.00         1          .          .
    #>  [3,]  0.600  1.500  .           .            1          .          .
    #>  [4,]  .     -0.100 -0.74       -0.74         1          .          .
    #>  [5,]  .      0.360  1.30        1.30         1          .          .
    #>  [6,] -0.086  .      0.63        0.63         1          .          .
    #>  [7,] -1.300 -1.300 -1.30       -1.30         1          .          .
    #>  [8,]  .      0.140 -0.38       -0.38         1          .          .
    #>  [9,]  .      1.400  .           .            1          .          .
    #> [10,]  .      0.071 -1.70       -1.80         1          .          1
    ```

-   Dropping highly sparse columns

    ``` r
    remove_sparse(x, threshold = 0.9)
    #> 10 x 6 sparse Matrix of class "dgCMatrix"
    #>           x1     x2    x3 cor_with_x3 const_col dup_x2
    #>  [1,] -0.370  .      .           .            1  .    
    #>  [2,]  .      .      2.00        2.00         1  .    
    #>  [3,]  0.600  1.500  .           .            1  1.500
    #>  [4,]  .     -0.100 -0.74       -0.74         1 -0.100
    #>  [5,]  .      0.360  1.30        1.30         1  0.360
    #>  [6,] -0.086  .      0.63        0.63         1  .    
    #>  [7,] -1.300 -1.300 -1.30       -1.30         1 -1.300
    #>  [8,]  .      0.140 -0.38       -0.38         1  0.140
    #>  [9,]  .      1.400  .           .            1  1.400
    #> [10,]  .      0.071 -1.70       -1.80         1  0.071
    ```

-   Append higher order terms:

    ``` r
    # Squared terms
    transform_cols(
      x[, 1:3], 
      fun = function(i) i^2, 
      which = paste0("x", 2:3), 
      name.sep = "squared"
    )
    #> 10 x 5 sparse Matrix of class "dgCMatrix"
    #>           x1     x2    x3 x2_squared x3_squared
    #>  [1,] -0.370  .      .      .            .     
    #>  [2,]  .      .      2.00   .            4.0000
    #>  [3,]  0.600  1.500  .      2.250000     .     
    #>  [4,]  .     -0.100 -0.74   0.010000     0.5476
    #>  [5,]  .      0.360  1.30   0.129600     1.6900
    #>  [6,] -0.086  .      0.63   .            0.3969
    #>  [7,] -1.300 -1.300 -1.30   1.690000     1.6900
    #>  [8,]  .      0.140 -0.38   0.019600     0.1444
    #>  [9,]  .      1.400  .      1.960000     .     
    #> [10,]  .      0.071 -1.70   0.005041     2.8900

    # Cubed terms
    transform_cols(
      x[, 1:3], 
      fun = function(i) i^3, 
      which = paste0("x", 2:3), 
      name.sep = "cubed"
    )
    #> 10 x 5 sparse Matrix of class "dgCMatrix"
    #>           x1     x2    x3     x2_cubed  x3_cubed
    #>  [1,] -0.370  .      .     .            .       
    #>  [2,]  .      .      2.00  .            8.000000
    #>  [3,]  0.600  1.500  .     3.375000000  .       
    #>  [4,]  .     -0.100 -0.74 -0.001000000 -0.405224
    #>  [5,]  .      0.360  1.30  0.046656000  2.197000
    #>  [6,] -0.086  .      0.63  .            0.250047
    #>  [7,] -1.300 -1.300 -1.30 -2.197000000 -2.197000
    #>  [8,]  .      0.140 -0.38  0.002744000 -0.054872
    #>  [9,]  .      1.400  .     2.744000000  .       
    #> [10,]  .      0.071 -1.70  0.000357911 -4.913000
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
    which = paste0("x", 2:3),
    name.sep = "squared"
  ) %>%
  transform_cols(
    fun = function(i) i ^ 3,
    which = paste0("x", 2:3),
    name.sep = "cubed"
  )
#> 10 x 7 sparse Matrix of class "dgCMatrix"
#>           x1     x2    x3 x2_squared x3_squared     x2_cubed  x3_cubed
#>  [1,] -0.370  .      .      .            .       .            .       
#>  [2,]  .      .      2.00   .            4.0000  .            8.000000
#>  [3,]  0.600  1.500  .      2.250000     .       3.375000000  .       
#>  [4,]  .     -0.100 -0.74   0.010000     0.5476 -0.001000000 -0.405224
#>  [5,]  .      0.360  1.30   0.129600     1.6900  0.046656000  2.197000
#>  [6,] -0.086  .      0.63   .            0.3969  .            0.250047
#>  [7,] -1.300 -1.300 -1.30   1.690000     1.6900 -2.197000000 -2.197000
#>  [8,]  .      0.140 -0.38   0.019600     0.1444  0.002744000 -0.054872
#>  [9,]  .      1.400  .      1.960000     .       2.744000000  .       
#> [10,]  .      0.071 -1.70   0.005041     2.8900  0.000357911 -4.913000
```

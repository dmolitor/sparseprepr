
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
#>          x1    x2    x3 cor_with_x3 const_col const_col2 dup_x2 sparse_col
#>  [1,]  0.53  .     .           .            1          .   .             .
#>  [2,] -0.38  .     .           .            1          .   .             .
#>  [3,]  0.13  0.56  0.75        0.75         1          .   0.56          .
#>  [4,]  .    -0.74  2.50        2.50         1          .  -0.74          .
#>  [5,]  .     .     0.16        0.16         1          .   .             .
#>  [6,] -0.79  0.31  .           .            1          .   0.31          .
#>  [7,] -0.73 -0.30  .           .            1          .  -0.30          .
#>  [8,]  .     .     1.20        1.20         1          .   .             .
#>  [9,]  .    -0.25  1.20        1.20         1          .  -0.25          .
#> [10,]  0.17  0.17 -0.26       -0.36         1          .   0.17          1
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
    #> 10 x 6 sparse Matrix of class "dgCMatrix"
    #>          x1    x2    x3 const_col const_col2 sparse_col
    #>  [1,]  0.53  .     .            1          .          .
    #>  [2,] -0.38  .     .            1          .          .
    #>  [3,]  0.13  0.56  0.75         1          .          .
    #>  [4,]  .    -0.74  2.50         1          .          .
    #>  [5,]  .     .     0.16         1          .          .
    #>  [6,] -0.79  0.31  .            1          .          .
    #>  [7,] -0.73 -0.30  .            1          .          .
    #>  [8,]  .     .     1.20         1          .          .
    #>  [9,]  .    -0.25  1.20         1          .          .
    #> [10,]  0.17  0.17 -0.26         1          .          1
    ```

-   Dropping empty columns

    ``` r
    remove_empty(x)
    #> 10 x 7 sparse Matrix of class "dgCMatrix"
    #>          x1    x2    x3 cor_with_x3 const_col dup_x2 sparse_col
    #>  [1,]  0.53  .     .           .            1   .             .
    #>  [2,] -0.38  .     .           .            1   .             .
    #>  [3,]  0.13  0.56  0.75        0.75         1   0.56          .
    #>  [4,]  .    -0.74  2.50        2.50         1  -0.74          .
    #>  [5,]  .     .     0.16        0.16         1   .             .
    #>  [6,] -0.79  0.31  .           .            1   0.31          .
    #>  [7,] -0.73 -0.30  .           .            1  -0.30          .
    #>  [8,]  .     .     1.20        1.20         1   .             .
    #>  [9,]  .    -0.25  1.20        1.20         1  -0.25          .
    #> [10,]  0.17  0.17 -0.26       -0.36         1   0.17          1
    ```

-   Dropping constant columns

    ``` r
    remove_constant(x)
    #> 10 x 6 sparse Matrix of class "dgCMatrix"
    #>          x1    x2    x3 cor_with_x3 dup_x2 sparse_col
    #>  [1,]  0.53  .     .           .      .             .
    #>  [2,] -0.38  .     .           .      .             .
    #>  [3,]  0.13  0.56  0.75        0.75   0.56          .
    #>  [4,]  .    -0.74  2.50        2.50  -0.74          .
    #>  [5,]  .     .     0.16        0.16   .             .
    #>  [6,] -0.79  0.31  .           .      0.31          .
    #>  [7,] -0.73 -0.30  .           .     -0.30          .
    #>  [8,]  .     .     1.20        1.20   .             .
    #>  [9,]  .    -0.25  1.20        1.20  -0.25          .
    #> [10,]  0.17  0.17 -0.26       -0.36   0.17          1
    ```

-   Dropping duplicated columns

    ``` r
    remove_duplicate(x)
    #> 10 x 7 sparse Matrix of class "dgCMatrix"
    #>          x1    x2    x3 cor_with_x3 const_col const_col2 sparse_col
    #>  [1,]  0.53  .     .           .            1          .          .
    #>  [2,] -0.38  .     .           .            1          .          .
    #>  [3,]  0.13  0.56  0.75        0.75         1          .          .
    #>  [4,]  .    -0.74  2.50        2.50         1          .          .
    #>  [5,]  .     .     0.16        0.16         1          .          .
    #>  [6,] -0.79  0.31  .           .            1          .          .
    #>  [7,] -0.73 -0.30  .           .            1          .          .
    #>  [8,]  .     .     1.20        1.20         1          .          .
    #>  [9,]  .    -0.25  1.20        1.20         1          .          .
    #> [10,]  0.17  0.17 -0.26       -0.36         1          .          1
    ```

-   Dropping highly sparse columns

    ``` r
    remove_sparse(x, threshold = 0.9)
    #> 10 x 6 sparse Matrix of class "dgCMatrix"
    #>          x1    x2    x3 cor_with_x3 const_col dup_x2
    #>  [1,]  0.53  .     .           .            1   .   
    #>  [2,] -0.38  .     .           .            1   .   
    #>  [3,]  0.13  0.56  0.75        0.75         1   0.56
    #>  [4,]  .    -0.74  2.50        2.50         1  -0.74
    #>  [5,]  .     .     0.16        0.16         1   .   
    #>  [6,] -0.79  0.31  .           .            1   0.31
    #>  [7,] -0.73 -0.30  .           .            1  -0.30
    #>  [8,]  .     .     1.20        1.20         1   .   
    #>  [9,]  .    -0.25  1.20        1.20         1  -0.25
    #> [10,]  0.17  0.17 -0.26       -0.36         1   0.17
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
    #>          x1    x2    x3 x2_squared x3_squared
    #>  [1,]  0.53  .     .        .          .     
    #>  [2,] -0.38  .     .        .          .     
    #>  [3,]  0.13  0.56  0.75     0.3136     0.5625
    #>  [4,]  .    -0.74  2.50     0.5476     6.2500
    #>  [5,]  .     .     0.16     .          0.0256
    #>  [6,] -0.79  0.31  .        0.0961     .     
    #>  [7,] -0.73 -0.30  .        0.0900     .     
    #>  [8,]  .     .     1.20     .          1.4400
    #>  [9,]  .    -0.25  1.20     0.0625     1.4400
    #> [10,]  0.17  0.17 -0.26     0.0289     0.0676

    # Cubed terms
    transform_cols(
      x[, 1:3], 
      fun = function(i) i^3, 
      which = paste0("x", 2:3), 
      name.sep = "cubed"
    )
    #> 10 x 5 sparse Matrix of class "dgCMatrix"
    #>          x1    x2    x3  x2_cubed  x3_cubed
    #>  [1,]  0.53  .     .     .         .       
    #>  [2,] -0.38  .     .     .         .       
    #>  [3,]  0.13  0.56  0.75  0.175616  0.421875
    #>  [4,]  .    -0.74  2.50 -0.405224 15.625000
    #>  [5,]  .     .     0.16  .         0.004096
    #>  [6,] -0.79  0.31  .     0.029791  .       
    #>  [7,] -0.73 -0.30  .    -0.027000  .       
    #>  [8,]  .     .     1.20  .         1.728000
    #>  [9,]  .    -0.25  1.20 -0.015625  1.728000
    #> [10,]  0.17  0.17 -0.26  0.004913 -0.017576
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
#> 10 x 7 sparse Matrix of class "dgCMatrix"
#>          x1    x2    x3 x2_squared x3_squared  x2_cubed  x3_cubed
#>  [1,]  0.53  .     .        .          .       .         .       
#>  [2,] -0.38  .     .        .          .       .         .       
#>  [3,]  0.13  0.56  0.75     0.3136     0.5625  0.175616  0.421875
#>  [4,]  .    -0.74  2.50     0.5476     6.2500 -0.405224 15.625000
#>  [5,]  .     .     0.16     .          0.0256  .         0.004096
#>  [6,] -0.79  0.31  .        0.0961     .       0.029791  .       
#>  [7,] -0.73 -0.30  .        0.0900     .      -0.027000  .       
#>  [8,]  .     .     1.20     .          1.4400  .         1.728000
#>  [9,]  .    -0.25  1.20     0.0625     1.4400 -0.015625  1.728000
#> [10,]  0.17  0.17 -0.26     0.0289     0.0676  0.004913 -0.017576
```

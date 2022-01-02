
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

## Scope

sparseprepr functionality only supports sparse matrices coded in sorted
compressed column-oriented form, formally of class `CsparseMatrix`.
Although the `Matrix` package also defines sorted compressed
row-oriented form (`RsparseMatrix`) and triplet form (`TsparseMatrix`)
sparse matrices, it makes clear that “most operations with sparse
matrices are performed using the compressed, column-oriented or
CsparseMatrix representation,” and that even when matrices are created
in the `TsparseMatrix` or `RsparseMatrix` forms for convenience, “once
it is created, however, the matrix is generally coerced to a
CsparseMatrix for further operations.”

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
#>          x1     x2     x3 cor_with_x3 const_col const_col2 dup_x2 sparse_col
#>  [1,] -1.40  .     -1.100       -1.10         1          .  .              .
#>  [2,] -1.20 -0.560 -0.300       -0.30         1          . -0.560          .
#>  [3,]  0.35 -1.400 -0.390       -0.39         1          . -1.400          .
#>  [4,]  1.10 -0.130 -0.780       -0.78         1          . -0.130          .
#>  [5,] -2.10 -0.200 -0.170       -0.17         1          . -0.200          .
#>  [6,] -1.80 -0.360  0.950        0.95         1          . -0.360          .
#>  [7,]  2.20  0.092  .            .            1          .  0.092          .
#>  [8,]  0.76  .     -0.380       -0.38         1          .  .              .
#>  [9,]  1.30 -0.780 -0.810       -0.81         1          . -0.780          .
#> [10,]  0.81 -0.056 -0.809       -0.81         1          . -0.056          1
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
    #>          x1     x2     x3 const_col const_col2 sparse_col
    #>  [1,] -1.40  .     -1.100         1          .          .
    #>  [2,] -1.20 -0.560 -0.300         1          .          .
    #>  [3,]  0.35 -1.400 -0.390         1          .          .
    #>  [4,]  1.10 -0.130 -0.780         1          .          .
    #>  [5,] -2.10 -0.200 -0.170         1          .          .
    #>  [6,] -1.80 -0.360  0.950         1          .          .
    #>  [7,]  2.20  0.092  .             1          .          .
    #>  [8,]  0.76  .     -0.380         1          .          .
    #>  [9,]  1.30 -0.780 -0.810         1          .          .
    #> [10,]  0.81 -0.056 -0.809         1          .          1
    ```

-   Dropping empty columns

    ``` r
    remove_empty(x)
    #> 10 x 7 sparse Matrix of class "dgCMatrix"
    #>          x1     x2     x3 cor_with_x3 const_col dup_x2 sparse_col
    #>  [1,] -1.40  .     -1.100       -1.10         1  .              .
    #>  [2,] -1.20 -0.560 -0.300       -0.30         1 -0.560          .
    #>  [3,]  0.35 -1.400 -0.390       -0.39         1 -1.400          .
    #>  [4,]  1.10 -0.130 -0.780       -0.78         1 -0.130          .
    #>  [5,] -2.10 -0.200 -0.170       -0.17         1 -0.200          .
    #>  [6,] -1.80 -0.360  0.950        0.95         1 -0.360          .
    #>  [7,]  2.20  0.092  .            .            1  0.092          .
    #>  [8,]  0.76  .     -0.380       -0.38         1  .              .
    #>  [9,]  1.30 -0.780 -0.810       -0.81         1 -0.780          .
    #> [10,]  0.81 -0.056 -0.809       -0.81         1 -0.056          1
    ```

-   Dropping constant columns

    ``` r
    remove_constant(x)
    #> 10 x 6 sparse Matrix of class "dgCMatrix"
    #>          x1     x2     x3 cor_with_x3 dup_x2 sparse_col
    #>  [1,] -1.40  .     -1.100       -1.10  .              .
    #>  [2,] -1.20 -0.560 -0.300       -0.30 -0.560          .
    #>  [3,]  0.35 -1.400 -0.390       -0.39 -1.400          .
    #>  [4,]  1.10 -0.130 -0.780       -0.78 -0.130          .
    #>  [5,] -2.10 -0.200 -0.170       -0.17 -0.200          .
    #>  [6,] -1.80 -0.360  0.950        0.95 -0.360          .
    #>  [7,]  2.20  0.092  .            .     0.092          .
    #>  [8,]  0.76  .     -0.380       -0.38  .              .
    #>  [9,]  1.30 -0.780 -0.810       -0.81 -0.780          .
    #> [10,]  0.81 -0.056 -0.809       -0.81 -0.056          1
    ```

-   Dropping duplicated columns

    ``` r
    remove_duplicate(x)
    #> 10 x 7 sparse Matrix of class "dgCMatrix"
    #>          x1     x2     x3 cor_with_x3 const_col const_col2 sparse_col
    #>  [1,] -1.40  .     -1.100       -1.10         1          .          .
    #>  [2,] -1.20 -0.560 -0.300       -0.30         1          .          .
    #>  [3,]  0.35 -1.400 -0.390       -0.39         1          .          .
    #>  [4,]  1.10 -0.130 -0.780       -0.78         1          .          .
    #>  [5,] -2.10 -0.200 -0.170       -0.17         1          .          .
    #>  [6,] -1.80 -0.360  0.950        0.95         1          .          .
    #>  [7,]  2.20  0.092  .            .            1          .          .
    #>  [8,]  0.76  .     -0.380       -0.38         1          .          .
    #>  [9,]  1.30 -0.780 -0.810       -0.81         1          .          .
    #> [10,]  0.81 -0.056 -0.809       -0.81         1          .          1
    ```

-   Dropping highly sparse columns

    ``` r
    remove_sparse(x, threshold = 0.9)
    #> 10 x 6 sparse Matrix of class "dgCMatrix"
    #>          x1     x2     x3 cor_with_x3 const_col dup_x2
    #>  [1,] -1.40  .     -1.100       -1.10         1  .    
    #>  [2,] -1.20 -0.560 -0.300       -0.30         1 -0.560
    #>  [3,]  0.35 -1.400 -0.390       -0.39         1 -1.400
    #>  [4,]  1.10 -0.130 -0.780       -0.78         1 -0.130
    #>  [5,] -2.10 -0.200 -0.170       -0.17         1 -0.200
    #>  [6,] -1.80 -0.360  0.950        0.95         1 -0.360
    #>  [7,]  2.20  0.092  .            .            1  0.092
    #>  [8,]  0.76  .     -0.380       -0.38         1  .    
    #>  [9,]  1.30 -0.780 -0.810       -0.81         1 -0.780
    #> [10,]  0.81 -0.056 -0.809       -0.81         1 -0.056
    ```

-   Transforming matrix columns:

    ``` r
    # Append squared and cubed terms
    transform_cols(
      x[, 1:3], 
      fns = list(function(i) i^2, function(i) i^3), 
      which.cols = paste0("x", 2:3), 
      name.sep = list("squared", "cubed")
    )
    #> 10 x 7 sparse Matrix of class "dgCMatrix"
    #>          x1     x2     x3 x2_squared x3_squared     x2_cubed   x3_cubed
    #>  [1,] -1.40  .     -1.100   .          1.210000  .           -1.3310000
    #>  [2,] -1.20 -0.560 -0.300   0.313600   0.090000 -0.175616000 -0.0270000
    #>  [3,]  0.35 -1.400 -0.390   1.960000   0.152100 -2.744000000 -0.0593190
    #>  [4,]  1.10 -0.130 -0.780   0.016900   0.608400 -0.002197000 -0.4745520
    #>  [5,] -2.10 -0.200 -0.170   0.040000   0.028900 -0.008000000 -0.0049130
    #>  [6,] -1.80 -0.360  0.950   0.129600   0.902500 -0.046656000  0.8573750
    #>  [7,]  2.20  0.092  .       0.008464   .         0.000778688  .        
    #>  [8,]  0.76  .     -0.380   .          0.144400  .           -0.0548720
    #>  [9,]  1.30 -0.780 -0.810   0.608400   0.656100 -0.474552000 -0.5314410
    #> [10,]  0.81 -0.056 -0.809   0.003136   0.654481 -0.000175616 -0.5294751
    ```

## Pipe Workflow

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
    fns = list(function(i) i^2, function(i) i^3),
    which.cols = paste0("x", 2:3),
    name.sep = list("squared", "cubed")
  )
#> 10 x 7 sparse Matrix of class "dgCMatrix"
#>          x1     x2     x3 x2_squared x3_squared     x2_cubed   x3_cubed
#>  [1,] -1.40  .     -1.100   .          1.210000  .           -1.3310000
#>  [2,] -1.20 -0.560 -0.300   0.313600   0.090000 -0.175616000 -0.0270000
#>  [3,]  0.35 -1.400 -0.390   1.960000   0.152100 -2.744000000 -0.0593190
#>  [4,]  1.10 -0.130 -0.780   0.016900   0.608400 -0.002197000 -0.4745520
#>  [5,] -2.10 -0.200 -0.170   0.040000   0.028900 -0.008000000 -0.0049130
#>  [6,] -1.80 -0.360  0.950   0.129600   0.902500 -0.046656000  0.8573750
#>  [7,]  2.20  0.092  .       0.008464   .         0.000778688  .        
#>  [8,]  0.76  .     -0.380   .          0.144400  .           -0.0548720
#>  [9,]  1.30 -0.780 -0.810   0.608400   0.656100 -0.474552000 -0.5314410
#> [10,]  0.81 -0.056 -0.809   0.003136   0.654481 -0.000175616 -0.5294751
```

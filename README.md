
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
#>  [1,]  0.42  .      0.110        0.11         1          .  .              .
#>  [2,] -0.65 -0.360  0.530        0.53         1          . -0.360          .
#>  [3,]  1.70 -0.540 -0.380       -0.38         1          . -0.540          .
#>  [4,]  0.89  0.085 -0.650       -0.65         1          .  0.085          .
#>  [5,] -0.95 -0.350 -0.480       -0.48         1          . -0.350          .
#>  [6,] -1.40 -0.680  0.190        0.19         1          . -0.680          .
#>  [7,]  1.20  0.510 -2.900       -2.90         1          .  0.510          .
#>  [8,] -0.89 -0.160  .            .            1          . -0.160          .
#>  [9,]  .     0.750  0.150        0.15         1          .  0.750          .
#> [10,]  0.99  1.100 -0.709       -0.71         1          .  1.100          1
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
    #>  [1,]  0.42  .      0.110         1          .          .
    #>  [2,] -0.65 -0.360  0.530         1          .          .
    #>  [3,]  1.70 -0.540 -0.380         1          .          .
    #>  [4,]  0.89  0.085 -0.650         1          .          .
    #>  [5,] -0.95 -0.350 -0.480         1          .          .
    #>  [6,] -1.40 -0.680  0.190         1          .          .
    #>  [7,]  1.20  0.510 -2.900         1          .          .
    #>  [8,] -0.89 -0.160  .             1          .          .
    #>  [9,]  .     0.750  0.150         1          .          .
    #> [10,]  0.99  1.100 -0.709         1          .          1
    ```

-   Dropping empty columns

    ``` r
    remove_empty(x)
    #> 10 x 7 sparse Matrix of class "dgCMatrix"
    #>          x1     x2     x3 cor_with_x3 const_col dup_x2 sparse_col
    #>  [1,]  0.42  .      0.110        0.11         1  .              .
    #>  [2,] -0.65 -0.360  0.530        0.53         1 -0.360          .
    #>  [3,]  1.70 -0.540 -0.380       -0.38         1 -0.540          .
    #>  [4,]  0.89  0.085 -0.650       -0.65         1  0.085          .
    #>  [5,] -0.95 -0.350 -0.480       -0.48         1 -0.350          .
    #>  [6,] -1.40 -0.680  0.190        0.19         1 -0.680          .
    #>  [7,]  1.20  0.510 -2.900       -2.90         1  0.510          .
    #>  [8,] -0.89 -0.160  .            .            1 -0.160          .
    #>  [9,]  .     0.750  0.150        0.15         1  0.750          .
    #> [10,]  0.99  1.100 -0.709       -0.71         1  1.100          1
    ```

-   Dropping constant columns

    ``` r
    remove_constant(x)
    #> 10 x 6 sparse Matrix of class "dgCMatrix"
    #>          x1     x2     x3 cor_with_x3 dup_x2 sparse_col
    #>  [1,]  0.42  .      0.110        0.11  .              .
    #>  [2,] -0.65 -0.360  0.530        0.53 -0.360          .
    #>  [3,]  1.70 -0.540 -0.380       -0.38 -0.540          .
    #>  [4,]  0.89  0.085 -0.650       -0.65  0.085          .
    #>  [5,] -0.95 -0.350 -0.480       -0.48 -0.350          .
    #>  [6,] -1.40 -0.680  0.190        0.19 -0.680          .
    #>  [7,]  1.20  0.510 -2.900       -2.90  0.510          .
    #>  [8,] -0.89 -0.160  .            .    -0.160          .
    #>  [9,]  .     0.750  0.150        0.15  0.750          .
    #> [10,]  0.99  1.100 -0.709       -0.71  1.100          1
    ```

-   Dropping duplicated columns

    ``` r
    remove_duplicate(x)
    #> 10 x 7 sparse Matrix of class "dgCMatrix"
    #>          x1     x2     x3 cor_with_x3 const_col const_col2 sparse_col
    #>  [1,]  0.42  .      0.110        0.11         1          .          .
    #>  [2,] -0.65 -0.360  0.530        0.53         1          .          .
    #>  [3,]  1.70 -0.540 -0.380       -0.38         1          .          .
    #>  [4,]  0.89  0.085 -0.650       -0.65         1          .          .
    #>  [5,] -0.95 -0.350 -0.480       -0.48         1          .          .
    #>  [6,] -1.40 -0.680  0.190        0.19         1          .          .
    #>  [7,]  1.20  0.510 -2.900       -2.90         1          .          .
    #>  [8,] -0.89 -0.160  .            .            1          .          .
    #>  [9,]  .     0.750  0.150        0.15         1          .          .
    #> [10,]  0.99  1.100 -0.709       -0.71         1          .          1
    ```

-   Dropping highly sparse columns

    ``` r
    remove_sparse(x, threshold = 0.9)
    #> 10 x 6 sparse Matrix of class "dgCMatrix"
    #>          x1     x2     x3 cor_with_x3 const_col dup_x2
    #>  [1,]  0.42  .      0.110        0.11         1  .    
    #>  [2,] -0.65 -0.360  0.530        0.53         1 -0.360
    #>  [3,]  1.70 -0.540 -0.380       -0.38         1 -0.540
    #>  [4,]  0.89  0.085 -0.650       -0.65         1  0.085
    #>  [5,] -0.95 -0.350 -0.480       -0.48         1 -0.350
    #>  [6,] -1.40 -0.680  0.190        0.19         1 -0.680
    #>  [7,]  1.20  0.510 -2.900       -2.90         1  0.510
    #>  [8,] -0.89 -0.160  .            .            1 -0.160
    #>  [9,]  .     0.750  0.150        0.15         1  0.750
    #> [10,]  0.99  1.100 -0.709       -0.71         1  1.100
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
    #>          x1     x2     x3 x2_squared x3_squared
    #>  [1,]  0.42  .      0.110   .          0.012100
    #>  [2,] -0.65 -0.360  0.530   0.129600   0.280900
    #>  [3,]  1.70 -0.540 -0.380   0.291600   0.144400
    #>  [4,]  0.89  0.085 -0.650   0.007225   0.422500
    #>  [5,] -0.95 -0.350 -0.480   0.122500   0.230400
    #>  [6,] -1.40 -0.680  0.190   0.462400   0.036100
    #>  [7,]  1.20  0.510 -2.900   0.260100   8.410000
    #>  [8,] -0.89 -0.160  .       0.025600   .       
    #>  [9,]  .     0.750  0.150   0.562500   0.022500
    #> [10,]  0.99  1.100 -0.709   1.210000   0.502681

    # Append cubed terms
    transform_cols(
      x[, 1:3], 
      fun = function(i) i^3, 
      which = paste0("x", 2:3), 
      name.sep = "cubed"
    )
    #> 10 x 5 sparse Matrix of class "dgCMatrix"
    #>          x1     x2     x3     x2_cubed    x3_cubed
    #>  [1,]  0.42  .      0.110  .             0.0013310
    #>  [2,] -0.65 -0.360  0.530 -0.046656000   0.1488770
    #>  [3,]  1.70 -0.540 -0.380 -0.157464000  -0.0548720
    #>  [4,]  0.89  0.085 -0.650  0.000614125  -0.2746250
    #>  [5,] -0.95 -0.350 -0.480 -0.042875000  -0.1105920
    #>  [6,] -1.40 -0.680  0.190 -0.314432000   0.0068590
    #>  [7,]  1.20  0.510 -2.900  0.132651000 -24.3890000
    #>  [8,] -0.89 -0.160  .     -0.004096000   .        
    #>  [9,]  .     0.750  0.150  0.421875000   0.0033750
    #> [10,]  0.99  1.100 -0.709  1.331000000  -0.3564008
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
#>          x1     x2     x3 x2_squared x3_squared     x2_cubed    x3_cubed
#>  [1,]  0.42  .      0.110   .          0.012100  .             0.0013310
#>  [2,] -0.65 -0.360  0.530   0.129600   0.280900 -0.046656000   0.1488770
#>  [3,]  1.70 -0.540 -0.380   0.291600   0.144400 -0.157464000  -0.0548720
#>  [4,]  0.89  0.085 -0.650   0.007225   0.422500  0.000614125  -0.2746250
#>  [5,] -0.95 -0.350 -0.480   0.122500   0.230400 -0.042875000  -0.1105920
#>  [6,] -1.40 -0.680  0.190   0.462400   0.036100 -0.314432000   0.0068590
#>  [7,]  1.20  0.510 -2.900   0.260100   8.410000  0.132651000 -24.3890000
#>  [8,] -0.89 -0.160  .       0.025600   .        -0.004096000   .        
#>  [9,]  .     0.750  0.150   0.562500   0.022500  0.421875000   0.0033750
#> [10,]  0.99  1.100 -0.709   1.210000   0.502681  1.331000000  -0.3564008
```

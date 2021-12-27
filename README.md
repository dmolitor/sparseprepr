
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

## Core Functionality/Scope

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
#>           x1     x2     x3 cor_with_x3 const_col const_col2 dup_x2 sparse_col
#>  [1,]  1.200  0.330  1.300        1.30         1          .  0.330          .
#>  [2,]  0.021  0.580  1.100        1.10         1          .  0.580          .
#>  [3,]  1.400  .     -1.000       -1.00         1          .  .              .
#>  [4,] -0.580 -0.041 -1.600       -1.60         1          . -0.041          .
#>  [5,] -0.800  1.100  1.000        1.00         1          .  1.100          .
#>  [6,]  .      .      0.140        0.14         1          .  .              .
#>  [7,]  0.410  0.180 -0.340       -0.34         1          .  0.180          .
#>  [8,] -0.200 -0.630  2.400        2.40         1          . -0.630          .
#>  [9,]  0.160  1.100  0.970        0.97         1          .  1.100          .
#> [10,]  1.200  0.480  0.121        0.12         1          .  0.480          1
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
    #>           x1     x2     x3 const_col const_col2 sparse_col
    #>  [1,]  1.200  0.330  1.300         1          .          .
    #>  [2,]  0.021  0.580  1.100         1          .          .
    #>  [3,]  1.400  .     -1.000         1          .          .
    #>  [4,] -0.580 -0.041 -1.600         1          .          .
    #>  [5,] -0.800  1.100  1.000         1          .          .
    #>  [6,]  .      .      0.140         1          .          .
    #>  [7,]  0.410  0.180 -0.340         1          .          .
    #>  [8,] -0.200 -0.630  2.400         1          .          .
    #>  [9,]  0.160  1.100  0.970         1          .          .
    #> [10,]  1.200  0.480  0.121         1          .          1
    ```

-   Dropping empty columns

    ``` r
    remove_empty(x)
    #> 10 x 7 sparse Matrix of class "dgCMatrix"
    #>           x1     x2     x3 cor_with_x3 const_col dup_x2 sparse_col
    #>  [1,]  1.200  0.330  1.300        1.30         1  0.330          .
    #>  [2,]  0.021  0.580  1.100        1.10         1  0.580          .
    #>  [3,]  1.400  .     -1.000       -1.00         1  .              .
    #>  [4,] -0.580 -0.041 -1.600       -1.60         1 -0.041          .
    #>  [5,] -0.800  1.100  1.000        1.00         1  1.100          .
    #>  [6,]  .      .      0.140        0.14         1  .              .
    #>  [7,]  0.410  0.180 -0.340       -0.34         1  0.180          .
    #>  [8,] -0.200 -0.630  2.400        2.40         1 -0.630          .
    #>  [9,]  0.160  1.100  0.970        0.97         1  1.100          .
    #> [10,]  1.200  0.480  0.121        0.12         1  0.480          1
    ```

-   Dropping constant columns

    ``` r
    remove_constant(x)
    #> 10 x 6 sparse Matrix of class "dgCMatrix"
    #>           x1     x2     x3 cor_with_x3 dup_x2 sparse_col
    #>  [1,]  1.200  0.330  1.300        1.30  0.330          .
    #>  [2,]  0.021  0.580  1.100        1.10  0.580          .
    #>  [3,]  1.400  .     -1.000       -1.00  .              .
    #>  [4,] -0.580 -0.041 -1.600       -1.60 -0.041          .
    #>  [5,] -0.800  1.100  1.000        1.00  1.100          .
    #>  [6,]  .      .      0.140        0.14  .              .
    #>  [7,]  0.410  0.180 -0.340       -0.34  0.180          .
    #>  [8,] -0.200 -0.630  2.400        2.40 -0.630          .
    #>  [9,]  0.160  1.100  0.970        0.97  1.100          .
    #> [10,]  1.200  0.480  0.121        0.12  0.480          1
    ```

-   Dropping duplicated columns

    ``` r
    remove_duplicate(x)
    #> 10 x 7 sparse Matrix of class "dgCMatrix"
    #>           x1     x2     x3 cor_with_x3 const_col const_col2 sparse_col
    #>  [1,]  1.200  0.330  1.300        1.30         1          .          .
    #>  [2,]  0.021  0.580  1.100        1.10         1          .          .
    #>  [3,]  1.400  .     -1.000       -1.00         1          .          .
    #>  [4,] -0.580 -0.041 -1.600       -1.60         1          .          .
    #>  [5,] -0.800  1.100  1.000        1.00         1          .          .
    #>  [6,]  .      .      0.140        0.14         1          .          .
    #>  [7,]  0.410  0.180 -0.340       -0.34         1          .          .
    #>  [8,] -0.200 -0.630  2.400        2.40         1          .          .
    #>  [9,]  0.160  1.100  0.970        0.97         1          .          .
    #> [10,]  1.200  0.480  0.121        0.12         1          .          1
    ```

-   Dropping highly sparse columns

    ``` r
    remove_sparse(x, threshold = 0.9)
    #> 10 x 6 sparse Matrix of class "dgCMatrix"
    #>           x1     x2     x3 cor_with_x3 const_col dup_x2
    #>  [1,]  1.200  0.330  1.300        1.30         1  0.330
    #>  [2,]  0.021  0.580  1.100        1.10         1  0.580
    #>  [3,]  1.400  .     -1.000       -1.00         1  .    
    #>  [4,] -0.580 -0.041 -1.600       -1.60         1 -0.041
    #>  [5,] -0.800  1.100  1.000        1.00         1  1.100
    #>  [6,]  .      .      0.140        0.14         1  .    
    #>  [7,]  0.410  0.180 -0.340       -0.34         1  0.180
    #>  [8,] -0.200 -0.630  2.400        2.40         1 -0.630
    #>  [9,]  0.160  1.100  0.970        0.97         1  1.100
    #> [10,]  1.200  0.480  0.121        0.12         1  0.480
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
    #>           x1     x2     x3 x2_squared x3_squared
    #>  [1,]  1.200  0.330  1.300   0.108900   1.690000
    #>  [2,]  0.021  0.580  1.100   0.336400   1.210000
    #>  [3,]  1.400  .     -1.000   .          1.000000
    #>  [4,] -0.580 -0.041 -1.600   0.001681   2.560000
    #>  [5,] -0.800  1.100  1.000   1.210000   1.000000
    #>  [6,]  .      .      0.140   .          0.019600
    #>  [7,]  0.410  0.180 -0.340   0.032400   0.115600
    #>  [8,] -0.200 -0.630  2.400   0.396900   5.760000
    #>  [9,]  0.160  1.100  0.970   1.210000   0.940900
    #> [10,]  1.200  0.480  0.121   0.230400   0.014641

    # Append cubed terms
    transform_cols(
      x[, 1:3], 
      fun = function(i) i^3, 
      which = paste0("x", 2:3), 
      name.sep = "cubed"
    )
    #> 10 x 5 sparse Matrix of class "dgCMatrix"
    #>           x1     x2     x3     x2_cubed     x3_cubed
    #>  [1,]  1.200  0.330  1.300  0.035937000  2.197000000
    #>  [2,]  0.021  0.580  1.100  0.195112000  1.331000000
    #>  [3,]  1.400  .     -1.000  .           -1.000000000
    #>  [4,] -0.580 -0.041 -1.600 -0.000068921 -4.096000000
    #>  [5,] -0.800  1.100  1.000  1.331000000  1.000000000
    #>  [6,]  .      .      0.140  .            0.002744000
    #>  [7,]  0.410  0.180 -0.340  0.005832000 -0.039304000
    #>  [8,] -0.200 -0.630  2.400 -0.250047000 13.824000000
    #>  [9,]  0.160  1.100  0.970  1.331000000  0.912673000
    #> [10,]  1.200  0.480  0.121  0.110592000  0.001771561
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
#>           x1     x2     x3 x2_squared x3_squared     x2_cubed     x3_cubed
#>  [1,]  1.200  0.330  1.300   0.108900   1.690000  0.035937000  2.197000000
#>  [2,]  0.021  0.580  1.100   0.336400   1.210000  0.195112000  1.331000000
#>  [3,]  1.400  .     -1.000   .          1.000000  .           -1.000000000
#>  [4,] -0.580 -0.041 -1.600   0.001681   2.560000 -0.000068921 -4.096000000
#>  [5,] -0.800  1.100  1.000   1.210000   1.000000  1.331000000  1.000000000
#>  [6,]  .      .      0.140   .          0.019600  .            0.002744000
#>  [7,]  0.410  0.180 -0.340   0.032400   0.115600  0.005832000 -0.039304000
#>  [8,] -0.200 -0.630  2.400   0.396900   5.760000 -0.250047000 13.824000000
#>  [9,]  0.160  1.100  0.970   1.210000   0.940900  1.331000000  0.912673000
#> [10,]  1.200  0.480  0.121   0.230400   0.014641  0.110592000  0.001771561
```

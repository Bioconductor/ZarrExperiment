---
title: "Working with Zarr archives"
author: 
- name: Martin Morgan
  affiliation: Roswell Park Comprehensive Cancer Center, Buffalo, NY
date: "2019-12-03"
output:
    BiocStyle::html_document:
        toc: true
        toc_float: true
package: ZarrExperiment
vignette: >
  %\VignetteIndexEntry{Working with Zarr archives}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEndcoding{UTF-8}
---



# Introduction

The ZarrExperiment package is currently under construction.  The
purpose of the package is to build an interface between
zarr(https://zarr.readthedocs.io/en/stable/) and the Bioconductor
`SummarizedExperiment` family.

# Installation

Install the package with

```
R -e "BiocManager::install('Bioconductor/ZarrExperiment')"
```

The `ZarrExperiment` package uses the zarr module from
python. Configuring python currently requires a git clone.

```
git clone https://github.com/Bioconductor/ZarrExperiment
```

We suggest using a python virtual environment to configure
python. There are different ways of establishing virtual environments.

## `venv`

## `virtualenv`

`virtualenv` is a distinct program. Do these from the command line.

1) Install `python3` and `virtualenv`

2) Create the virtual environment.

   ```
   virtualenv -p python3 ~/.virtualenvs/Bioconductor
   ``` 

3) Activate this virtual environment.

   ```
   source ~/.virtualenvs/Bioconductor/bin/activate
   ```

4) Install the required python packages from the file
   `python-requirements.txt` in the package's base directory using
   pip.

   ```
   pip install -r python-requirements.txt
   ```

   When done, deactivate the virtual environment.

   ```
   deactivate
   ```

6) Set the enviroment `RETICULATE_PYTHON` variable to use the `Bioconductor`
   virtual environment.

   ```
   export RETICULATE_PYTHON=~/.virtualenvs/Bioconductor/bin/python
   ```

7) Test that `zarr` can be imported with reticulate.

   ```
   R -e "reticulate::import('zarr')"
   ```

## basilisk

# Use

Load libraries used in this vignette


```r
library(SummarizedExperiment)
library(tibble)
library(ZarrExperiment)
```

Point to a sample archive. Archives are folders with a collection of files.


```r
fl <- system.file(
    package="ZarrExperiment", "extdata",
    "stahl-2016-science-olfactory-bulb.matrix.zarr"
)
dir(fl, recursive = TRUE, all.files = TRUE)
##  [1] ".zattrs"           ".zgroup"           "gene_name/.zarray"
##  [4] "gene_name/.zattrs" "gene_name/0"       "gene_name/1"      
##  [7] "gene_name/2"       "gene_name/3"       "matrix/.zarray"   
## [10] "matrix/.zattrs"    "matrix/0.0"        "matrix/0.1"       
## [13] "matrix/0.10"       "matrix/0.11"       "matrix/0.12"      
## [16] "matrix/0.13"       "matrix/0.14"       "matrix/0.15"      
## [19] "matrix/0.16"       "matrix/0.2"        "matrix/0.3"       
## [22] "matrix/0.4"        "matrix/0.5"        "matrix/0.6"       
## [25] "matrix/0.7"        "matrix/0.8"        "matrix/0.9"       
## [28] "region_id/.zarray" "region_id/.zattrs" "region_id/0"      
## [31] "x_region/.zarray"  "x_region/.zattrs"  "x_region/0"       
## [34] "y_region/.zarray"  "y_region/.zattrs"  "y_region/0"
```

Load the archive and view, via the `show()` or `tree()` method, the
available groups (datasets) in the archive. These groups are analogous
to hdf5 datasets.


```r
arr <- ZarrArchive(fl)
arr
## class: ZarrArchive
## resource: /Users/ma38727/Librar.../stahl-2016-science-olfactory-bulb.matrix.zarr
## /
##  ├── gene_name (16573,) <U14
##  ├── matrix (267, 16573) int64
##  ├── region_id (267,) int64
##  ├── x_region (267,) float64
##  └── y_region (267,) float64
```

The archive allows `$` subsetting, including tab completion. Access
the `matrix` group member and coerce it to an _R_ (dense) matrix.


```r
m <- t(as(arr$matrix, "matrix"))
m[1:5, 1:5]
##      [,1] [,2] [,3] [,4] [,5]
## [1,]    1    0    1    0    0
## [2,]    5    1    0    0    0
## [3,]    4    2    0    2    1
## [4,]    2    2    1    0    0
## [5,]    2    4    2    0    4
```

The components of this archive (archive format is completely general,
so it is not possible to write a 'smart' import function) can be
accessed...


```r
rowData <- tibble(
    gene_name = as(arr$gene_name, "matrix")
)
rowData
## # A tibble: 16,573 x 1
##    gene_name
##    <chr>    
##  1 Nop58    
##  2 Arl6ip4  
##  3 Lix1     
##  4 Chrm1    
##  5 Nap1l1   
##  6 Kat6a    
##  7 Fam134c  
##  8 Lrpprc   
##  9 Srgap3   
## 10 Slc1a3   
## # … with 16,563 more rows

colData <- tibble(
    region_id = as(arr$region_id, "matrix"),
    x_region = as(arr$x_region, "matrix"),
    y_region = as(arr$y_region, "matrix")
)
colData
## # A tibble: 267 x 3
##    region_id x_region y_region
##        <dbl>    <dbl>    <dbl>
##  1         0    4637.    2333.
##  2         1    4894.    2334.
##  3         2    5463.    2333.
##  4         3    5187.    2330.
##  5         4    5769.    2896.
##  6         5    5774.    2604.
##  7         6    5767.    3475.
##  8         7    5766.    3190.
##  9         8    5189.    2620.
## 10         9    5477.    2626.
## # … with 257 more rows
```

Form a `SummarizedExperiment` from these components:


```r
se <- SummarizedExperiment(
    assays = list(count = m),
    rowData = rowData,
    colData = colData
)
se
## class: SummarizedExperiment 
## dim: 16573 267 
## metadata(0):
## assays(1): count
## rownames: NULL
## rowData names(1): gene_name
## colnames: NULL
## colData names(3): region_id x_region y_region
```

The `SummarizedExperiment` object can then be used in standard _R_ /
_Bioconductor_ single-cell and other work flows.

# Acknowledgements


```r
sessionInfo()
## R Under development (unstable) (2019-12-01 r77489)
## Platform: x86_64-apple-darwin17.7.0 (64-bit)
## Running under: macOS High Sierra 10.13.6
## 
## Matrix products: default
## BLAS:   /Users/ma38727/bin/R-devel/lib/libRblas.dylib
## LAPACK: /Users/ma38727/bin/R-devel/lib/libRlapack.dylib
## 
## locale:
## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
## 
## attached base packages:
## [1] stats4    parallel  stats     graphics  grDevices utils     datasets 
## [8] methods   base     
## 
## other attached packages:
##  [1] ZarrExperiment_0.0.6        tibble_2.1.3               
##  [3] SummarizedExperiment_1.17.0 DelayedArray_0.13.0        
##  [5] BiocParallel_1.21.0         matrixStats_0.55.0         
##  [7] Biobase_2.47.1              GenomicRanges_1.39.1       
##  [9] GenomeInfoDb_1.23.0         IRanges_2.21.2             
## [11] S4Vectors_0.25.1            BiocGenerics_0.33.0        
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_1.0.3                 compiler_4.0.0            
##  [3] pillar_1.4.2               XVector_0.27.0            
##  [5] bitops_1.0-6               tools_4.0.0               
##  [7] zlibbioc_1.33.0            SingleCellExperiment_1.9.0
##  [9] digest_0.6.23              jsonlite_1.6              
## [11] evaluate_0.14              lattice_0.20-38           
## [13] pkgconfig_2.0.3            rlang_0.4.2               
## [15] Matrix_1.2-18              xfun_0.11                 
## [17] GenomeInfoDbData_1.2.2     rtracklayer_1.47.0        
## [19] stringr_1.4.0              knitr_1.26                
## [21] Biostrings_2.55.2          grid_4.0.0                
## [23] reticulate_1.13.0-9005     XML_3.98-1.20             
## [25] magrittr_1.5               codetools_0.2-16          
## [27] Rsamtools_2.3.2            GenomicAlignments_1.23.1  
## [29] stringi_1.4.3              RCurl_1.95-4.12           
## [31] crayon_1.3.4
```

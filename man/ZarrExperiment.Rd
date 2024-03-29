% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ZarrExperiment-class.R
\name{ZarrExperiment}
\alias{ZarrExperiment}
\title{ZarrExperiment constructor function}
\usage{
ZarrExperiment(zarrchive, ...)
}
\arguments{
\item{zarrchive}{Either a \linkS4class{ZarrArchive} class or path to the
top level of a Zarr archive.}

\item{...}{Additional arguments passed to the `SingleCellExperiment`
constructor function}
}
\description{
The `ZarrExperiment` class is a matrix-like container where rows represent
features and columns samples, similar to the
\linkS4class{SummarizedExperiment} container.
}
\examples{

fl <- system.file(
    package="ZarrExperiment", "extdata",
    "stahl-2016-science-olfactory-bulb.matrix.zarr"
)

ZarrExperiment(fl)

ZarrExperiment(
    ZarrArchive(fl)
)

}

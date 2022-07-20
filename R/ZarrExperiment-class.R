#' @importFrom SingleCellExperiment SingleCellExperiment
.ZarrExperiment <- setClass('ZarrExperiment',
    contains=c('SingleCellExperiment')
)

.valid.ZarrExperiment <- function(object) {
    NULL
}

setValidity('ZarrExperiment', .valid.ZarrExperiment)


#' ZarrExperiment constructor function
#'
#' The `ZarrExperiment` class is a matrix-like container where rows represent
#' features and columns samples, similar to the
#' \linkS4class{SummarizedExperiment} container.
#'
#' @param zarrchive Either a \linkS4class{ZarrArchive} class or path to the
#' top level of a Zarr archive.
#'
#' @param ... Additional arguments passed to the `SingleCellExperiment`
#'   constructor function
#'
#' @examples
#'
#' fl <- system.file(
#'     package="ZarrExperiment", "extdata",
#'     "stahl-2016-science-olfactory-bulb.matrix.zarr"
#' )
#'
#' ZarrExperiment(fl)
#'
#' ZarrExperiment(
#'     ZarrArchive(fl)
#' )
#'
#' @export
ZarrExperiment <- function(zarrchive, ...) {
    if (!is(zarrchive, "ZarrArchive"))
        zarrchive <- ZarrArchive(zarrchive)

    sce <- SingleCellExperiment(
        assays = list(counts = t(as(zarrchive$matrix, "matrix"))),
        colData = colData(zarrchive),
        ...
    )

    .ZarrExperiment(sce)
}

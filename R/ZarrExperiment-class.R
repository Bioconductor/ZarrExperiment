
#' @importFrom SingleCellExperiment SingleCellExperiment
.ZarrExperiment <- setClass('ZarrExperiment',
    contains=c('SingleCellExperiment')
)

.valid.ZarrExperiment <- function(object) {
    NULL
}

setValidity('ZarrExperiment', .valid.ZarrExperiment)



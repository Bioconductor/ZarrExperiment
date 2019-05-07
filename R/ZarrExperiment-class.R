
.ZarrExperiment <- setClass('ZarrExperiment',
    contains=c('SummarizedExperiment')
)

.valid.ZarrExperiment <- function(x) {
    NULL
}

setValidity2('ZarrExperiment', .valid.ZarrExperiment)



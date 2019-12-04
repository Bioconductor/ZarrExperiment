#' @importFrom reticulate import py_eval
#' @importFrom basilisk basiliskStart basiliskStop
#' @export
.zarr <- local({
    .zarr <- NULL
    function() {
        if (is.null(.zarr)) {
            proc = basiliskStart("bczarrenv", pkgname="ZarrExperiment")
            on.exit(basiliskStop(proc))
            .zarr <<- import("zarr")
            }
        .zarr
    }
})

#' @export
.numpy <- local({
    .numpy <- NULL
    function() {
        if (is.null(.numpy)) {
            proc = basiliskStart("bczarrenv", pkgname="ZarrExperiment")
            on.exit(basiliskStop(proc))
            .numpy <<- import("numpy")
            }
        .numpy
    }
})
    

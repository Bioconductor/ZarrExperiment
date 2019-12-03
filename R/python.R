#' @importFrom reticulate import py_eval
#' @export
.zarr <- local({
    .zarr <- NULL
    function() {
        if (is.null(.zarr))
            .zarr <<- import("zarr")
        .zarr
    }
})

#' @export
.numpy <- local({
    .numpy <- NULL
    function() {
        if (is.null(.numpy))
            .numpy <<- import("numpy")
        .numpy
    }
})
    

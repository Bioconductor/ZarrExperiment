#' @importFrom reticulate py_eval
#' @export
.zarr <- local({
    .zarr <- NULL
    function() {
        if (is.null(.zarr))
            .zarr <<- reticulate::import("zarr")
        .zarr
    }
})

#' @export
.numpy <- local({
    .numpy <- NULL
    function() {
        if (is.null(.numpy))
            .numpy <<- reticulate::import("numpy")
        .numpy
    }
})

#' @export
.s3fs <- local({
    .s3fs <- NULL
    function() {
        if (is.null(.s3fs))
            .s3fs <<- reticulate::import("s3fs")
        .s3fs
    }
})

#' @import methods
#' @importClassesFrom BiocIO BiocFile
#' @importFrom BiocIO resource
.ZarrArchive <-
    setClass(
        "ZarrArchive",
        contains = "BiocFile"
    )

#' @rdname ZarrArchive-class
#'
#' @title Mange and import Zarr archives
#'
#' @description `ZarrArchive()` creates and _R_ object representing a
#'     Zarr archive.
#'
#' @param path `character(1)` file path to the top level of the Zarr
#'     archive.
#'
#' @return `ZarrArchive()` returns an object representing the Zarr
#'     archive. The object can be queried for component parts, and the
#'     parts imported into _R_.
#'
#' @examples
#' fl <- system.file(
#'     package="ZarrExperiment", "extdata",
#'     "stahl-2016-science-olfactory-bulb.matrix.zarr"
#' )
#' arr <- ZarrArchive(fl)
#' arr
#'
#' @export
ZarrArchive <-
    function(path)
{
    stopifnot(dir.exists(path))

    path <- normalizePath(path)
    .ZarrArchive(resource = path)
}

#' @rdname ZarrArchive-class
#'
#' @aliases tree,ZarrArchive-method
#'
#' @description `tree()` is invoked for the side effect of displaying
#'     the hierarchical groups represented in the archive.
#'
#' @param x a `ZarrArchive()` instance.
#'
#' @return `tree()` returns the original object, invisibly.
#'
#' @export
setGeneric("tree", function(x) standardGeneric("tree"))

setMethod(
    "tree", "ZarrArchive",
    function(x)
{
    arr <- resource(x)
    print(.zarr()$open(arr, mode="r")$tree())
    invisible(x)
})

#' @rdname ZarrArchive-class
#'
#' @aliases datasets,ZarrArchive-method
#'
#' @description `datasets()` returns an alphabetically sorted vector of
#'     groups subtending the archive represented by `x`.
#'
#' @return `datasets()` returns a `character()` vector of group names.
#'
#' @examples
#' datasets(arr)
#'
#' @export
setGeneric("datasets", function(x) standardGeneric("datasets"))

setMethod(
    "datasets", "ZarrArchive",
    function(x)
{
    arr <- resource(x)
    py_eval("sorted")(.zarr()$open(arr, mode = "r")$keys())
})

#' @rdname ZarrArchive-class
#'
#' @aliases dataset,ZarrArchive-method
#'
#' @description `dataset()` accesses the dataset `name` from the object `x`.
#'
#' @param name `character(1)` name of dataset, satisfying `name %in%
#'     datasets(x)`.
#'
#' @return `dataset()` returns a python reference to the named dataset.
#'
#' @examples
#' dataset(arr, "matrix")
#'
#' @export
setGeneric(
    "dataset",
    function(x, name) standardGeneric("dataset"),
    signature = "x"
)

#' @importFrom S4Vectors isSingleString
setMethod(
    "dataset", "ZarrArchive",
    function(x, name)
{
    stopifnot(
        isSingleString(name),
        name %in% datasets(x)
    )
    arr <- resource(x)
    .zarr()$open(arr, mode = "r")[name]
})

#' @rdname ZarrArchive-class
#'
#' @description `$` provides access to named groups (datasets) in the
#'     archive. Tab completion is available.
#'
#' @return `$` returns a python representation of the dataset, or if
#'     pressed with `<tab>` possible completions matching the current
#'     prefix.
#'
#' @examples
#' arr$matrix
#'
#' @export
setMethod(
    "$", "ZarrArchive",
    function(x, name)
{
    stopifnot(name %in% datasets(x))
    dataset(x, name)
})

#' @importFrom utils .DollarNames
#'
#' @export
.DollarNames.ZarrArchive <-
    function(x, pattern)
{
    grep(pattern, datasets(x), value = TRUE)
}

#' @rdname ZarrArchive-class
#'
#' @name zarr.core.Array-class
#'
#' @exportClass zarr.core.Array
setOldClass(c("zarr.core.Array", "python.builtin.object"))

#' @rdname ZarrArchive-class
#'
#' @name coerce,ZarrArchive,matrix-method
#'
#' @aliases coerce,zarr.core.Array,matrix-method
#'
#' @description `as()` coerces the python object to it's _R_
#'     representation.
#'
#' @return `as(from, "matrix")` returns a dense _R_ matrix
#'     representation of the python data.
#'
#' @examples
#' m <- as(arr$matrix, "matrix")
#' dim(m)
#' m[1:5, 1:5]
#'
#' colData <- tibble::tibble(
#'     region_id = as(arr$region_id, "matrix"),
#'     x_region = as(arr$x_region, "matrix"),
#'     y_region = as(arr$y_region, "matrix")
#' )
#' colData
#'
#' @exportMethod coerce
setAs(
    "zarr.core.Array", "matrix",
    function(from)
{
    .numpy()$array(from)
})

#' @rdname ZarrArchive-class
#'
#' @aliases show,ZarrArchive-method
#'
#' @param object A `ZarrArchive` instance.
#'
#' @description `show()` displays the resource (archive) path and tree
#'     of datasets (groups).
#'
#' @export
setMethod(
    "show", "ZarrArchive",
    function(object)
{
    cat(
        "class: ", class(object), "\n",
        pretty_path("resource", resource(object)),
        sep = ""
    )
    tree(object)
})

#' @importFrom SummarizedExperiment colData
#' @export
setMethod("colData", "ZarrArchive", function(x, ...) {
    S4Vectors::DataFrame(
        region_id = as(x$region_id, "matrix"),
        x_region = as(x$x_region, "matrix"),
        y_region = as(x$y_region, "matrix")
    )
})

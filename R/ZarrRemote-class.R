.ZarrRemote <-
    setClass(
        "ZarrRemote",
        contains = "ZarrArchive",
        slots = c(endpoint = "character", bucket = "character")
    )

#' @examples
#'
#' url <- "https://mghp.osn.xsede.org/bir190004-bucket01/index.html#TMA11/zarr/"
#'
#' zr <- ZarrRemote(
#'     endpoint = "https://mghp.osn.xsede.org/",
#'     bucket = "bir190004-bucket01/TMA11/zarr/"
#' )
#'
#' \dontrun{
#'   zarray <- import(zr, filename = "5.zarr")
#'
#'   dim(zarray)
#'   ## [1] 64 3007 3007
#'
#'   format(object.size(zarray), units = "GB", standard = "SI")
#'   ## [1] "2.3 GB"
#' }
#'
#' @export
ZarrRemote <-
    function(endpoint, bucket, ...)
{
    url <- paste0(endpoint, bucket)
    .ZarrRemote(resource = url, endpoint = endpoint, bucket = bucket, ...)
}

# store <- .s3fs()$S3Map(root='bir190004-bucket01/TMA11/zarr', s3=fs, check=FALSE)
# root <- .zarr()$group(store = store)

#' @export
setMethod(
    "tree", "ZarrRemote",
    function(x)
{
    fs <- .s3fs()$S3FileSystem(
        anon = TRUE, key = "dummy", secret="dummy",
        client_kwargs = reticulate::dict(endpoint_url = x@endpoint)
    )
    files <- fs$ls(x@bucket)
    afiles <- BiocBaseUtils::selectSome(basename(files))
    fnames <- c(
        "",
        paste(
            "├──", head(afiles, -1L), "\n"
        ),
        paste("└──", tail(afiles, 1L), "\n")
    )
    cat(fnames)
    invisible(x)
})

#' @importFrom BiocIO import
#' @importFrom BiocBaseUtils isScalarCharacter
#'
#' @exportMethod import
setMethod("import", "ZarrRemote", function(con, format, text, ...) {
    dots <- list(...)
    file <- dots[["filename"]]
    if (is.null(file) || !isScalarCharacter(file))
        stop("Provide a 'filename' input found in the bucket")
    fs <- .s3fs()$S3FileSystem(anon = TRUE, key = "dummy", secret="dummy",
        client_kwargs = reticulate::dict(endpoint_url = con@endpoint))
    files <- fs$ls(con@bucket)
    if (!file %in% basename(files))
        stop("'filename': ", file, " not found")
    mapper <- fs$get_mapper(paste0(con@bucket, file))
    .zarr()$load(mapper)
})

#' @export
setMethod(
    "show", "ZarrRemote",
    function(object)
{
    cat(
        "class: ", class(object), "\n",
        pretty_path("endpoint", object@endpoint),
        pretty_path("bucket", object@bucket),
        sep = ""
    )
    tree(object)
})


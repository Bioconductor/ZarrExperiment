.ZarrRemote <-
    setClass(
        "ZarrRemote",
        contains = "ZarrArchive",
        slots = c(endpoint = "character", bucket = "character")
    )

.getBaseURL <- function(url) {
    res <- urltools::url_parse(url)
    res["path"] <- res["fragment"] <- NA_character_
    urltools::url_compose(res)
}

.getBucketURL <- function(url, endpoint) {
    gsub(endpoint, "", url)
}

#' @rdname ZarrRemote-class
#'
#' @title A remote representation for Zarr folders
#'
#' @description The `ZarrRemote` class allows one to display and import Zarr
#'   files on the web that are accessible via the `S3Fs` python module
#'   <https://s3fs.readthedocs.io/en/latest/>.
#'
#' @param endpoint character(1) The base URL of the remote Zarr folders
#'
#' @param bucket character(1) The bucket location portion of the full URL
#'
#' @param resource character(1) Optional. The full URL composed of both the
#' `endpoint` and the `bucket` components.
#'
#' @details The `endpoint` component consists of both the `scheme` and the
#'   `domain`. The complete URL is the combination of the `endpoint` and
#'   `bucket` components. A complete URL can also be provided via the `resource`
#'   argument.
#'
#' @examples
#'
#'
#' zr <- ZarrRemote(
#'     endpoint = "https://mghp.osn.xsede.org/",
#'     bucket = "bir190004-bucket01/TMA11/zarr/"
#' )
#'
#' zr <- ZarrRemote(
#'     resource = "https://mghp.osn.xsede.org/bir190004-bucket01/TMA11/zarr/"
#' )
#'
#' zr
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
    function(endpoint, bucket, resource, ...)
{
    if (missing(resource))
        resource <- paste0(endpoint, bucket)
    else {
        endpoint <- .getBaseURL(resource)
        bucket <- .getBucketURL(resource, endpoint)
    }
    .ZarrRemote(resource = resource, endpoint = endpoint, bucket = bucket, ...)
}

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


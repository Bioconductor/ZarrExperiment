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
#' ZarrRemote(
#'     endpoint = "https://mghp.osn.xsede.org/",
#'     bucket = "bir190004-bucket01/TMA11/zarr/"
#' )
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
    fs <- .s3fs()$S3FileSystem(anon = TRUE, key = "dummy", secret="dummy",
        client_kwargs = reticulate::dict(endpoint_url = x@endpoint))
    print(BiocBaseUtils::selectSome(fs$ls(x@bucket)))
    invisible(x)
})

#' @importFrom BiocIO import
#'
#' @exportMethod import
setMethod("import", "ZarrRemote", function(con, format, text, ...) {
    files <- basename(tree(con))
    if (!format %in% files)
        stop("'format' file: ", format, " not found")
    mapper <- fs$get_mapper(paste0(con@bucket, format))
    .zarr()$load(mapper)
})

#' @export
setMethod(
    "show", "ZarrRemote",
    function(object)
{
    cat(
        "class: ", class(object), "\n",
        pretty_path("resource", resource(object)),
        sep = ""
    )
    tree(object)
})


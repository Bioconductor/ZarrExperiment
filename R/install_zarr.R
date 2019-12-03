## This installation code is from Nitesh Turaga's BiocNimfa package

.install_zarr <-
    function(envname)
{
    pkgs <- readLines("python_requirements.txt")
    virtualenv_create(envname)
    virtualenv_install(envname, pkgs)
}

#' @rdname install_zarr
#'
#' @title Helper function to install the `zarr` python module
#'
#' @param envname `character(1)` virtual environment in which to
#'     install the python zarr module.
#'
#' @return Reference to the python module, invisibly.
#' 
#' @export
install_zarr <-
    function(envname = "ZarrExperiment")
{
    stopifnot(isSingleString(envname))
    is_windows <- identical(.Platform$OS.type, "windows")
    is_osx <- Sys.info()["sysname"] == "Darwin"
    is_linux <- identical(tolower(Sys.info()[["sysname"]]), "linux")
    if (!is_windows && !is_osx && !is_linux) {
        stop(
            "Unable to install 'Zarr' on this platform. ",
            "Binary installation is available for Windows, macOS, and Linux"
        )
    }

    if (!envname %in% virtualenv_list()) {
        .install_zarr(envname)
    }
    use_virtualenv(virtualenv=envname)

    invisible(.zarr())
}

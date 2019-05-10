## This installation code was largely gleaned from Nitesh Turaga's BiocNimfa package

.install_zarr <- function(envname) {

    pkgs <- readLines("python_requirements.txt")
    virtualenv_create(envname)
    virtualenv_install(envname, pkgs)
}

#' @export
install_zarr <-
    function(envname = "ZarrExperiment")
{
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

        .install_nimfa(envname)
    }
    use_virtualenv(virtualenv=envname)

    ## import
    import("zarr")
}

#' @export
zarr <-
    function()
{
    import("zarr")
}

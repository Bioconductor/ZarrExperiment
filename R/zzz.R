.onLoad <- function(libname, pkgname) {
    basilisk::setupVirtualEnv("bczarrenv", c("zarr==2.3.2"), pkgname=pkgname)
}


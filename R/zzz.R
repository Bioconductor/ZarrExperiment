.onLoad <- function(libname, pkgname) {
    basilisk::setupVirtualEnv("bczarrenv", c("zarr==2.3.2", "asciitree==0.3.3", "fasteners==0.15"), pkgname=pkgname)
}


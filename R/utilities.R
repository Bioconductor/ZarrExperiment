pretty_path <-
    function(tag, filepath)
{
    wd <- options('width')[[1]] - nchar(tag) - 6
    if(is.na(filepath))
        return(sprintf("%s: %s\n", tag, NA_character_))
    if (0L == length(filepath) || nchar(filepath) < wd)
        return(sprintf("%s: %s\n", tag, filepath))
    bname <- basename(filepath)
    wd1 <- wd - nchar(bname)
    dname <- substr(dirname(filepath), 1, wd1)
    sprintf("%s: %s...%s%s\n", tag, dname, .Platform$file.sep, bname)
}

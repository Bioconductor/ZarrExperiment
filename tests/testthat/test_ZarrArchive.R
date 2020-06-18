test_that("'ZarrArchive' contructor works", {
    expect_error(ZarrArchive(), 'argument "path" is missing, with no default')

    path <- system.file(
        package = "ZarrExperiment", "extdata",
        "stahl-2016-science-olfactory-bulb.matrix.zarr"
    )

    expect_true(validObject(ZarrArchive(path)))
})

test_that("'ZarrArchive' accessors work", {
    path <- system.file(
        package = "ZarrExperiment", "extdata",
        "stahl-2016-science-olfactory-bulb.matrix.zarr"
    )
    arr <- ZarrArchive(path)

    expect_identical(path(arr), path)
    expect_identical(
        datasets(arr),
        c("gene_name", "matrix", "region_id", "x_region", "y_region")
    )
    expect_s3_class(
        dataset(arr, "matrix"),
        c("zarr.core.Array", "python.builtin.object")
    )
})

test_that("'as()' works", {
    path <- system.file(
        package = "ZarrExperiment", "extdata",
        "stahl-2016-science-olfactory-bulb.matrix.zarr"
    )
    arr <- ZarrArchive(path)

    m <- as(dataset(arr, "matrix"), "matrix")
    expect_s3_class(m, c("matrix", "array"))
    expect_identical(dim(m), c(267L, 16573L))
    expect_identical(typeof(m), "double")

    m <- as(dataset(arr, "gene_name"), "matrix")
    expect_identical(class(m), "array")
    expect_identical(dim(m), 16573L)
    expect_identical(typeof(m), "character")
})

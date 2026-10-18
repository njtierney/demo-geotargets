## Load your packages, e.g. library(targets).
source("packages.R")
tar_source("R")

geotargets_option_set(gdal_raster_driver = "COG")
tar_assign({
  tif_file <- system.file("ex/elev.tif", package = "terra") |> tar_file()

  elev <- rast(tif_file) |> tar_terra_rast()

  elev_m <- set_units(elev, unit = "m") |> tar_terra_rast()

  vect_file <- system.file("ex", "lux.shp", package = "terra") |> tar_file()

  terra_vect <- vect(vect_file) |> tar_terra_vect()

  vect_proj <- project(terra_vect, "EPSG:2196") |> tar_terra_vect()
})

## Load your packages, e.g. library(targets).
source("packages.R")
tar_source("R")

geotargets_option_set(gdal_raster_driver = "COG")

# set number of workers - set up parallel computation
# my_controller <- crew::crew_controller_local(
#   workers = 6,
#   name = "example"
# )

tar_option_set(
  memory = "transient"
  # controller = my_controller
)

## ??terraoptions to explore from Payal:
# terraOptions(tempdir= temp_dir, todisk=FALSE, progress=1, verbose = TRUE, steps = 60)
# Or specifying memfrac for instance (not in the above example).
# from class notes: using terraOptions

terraOptions(
  parallel = TRUE
)

tar_assign({
  tif_file <- system.file("ex/elev.tif", package = "terra") |> tar_file()

  # no longer tar_target()
  # for *rast* objects:
  # tar_terra_rast()
  elev <- rast(tif_file) |> tar_terra_rast()

  elev_m <- set_units(elev, unit = "m") |> tar_terra_rast()

  disagg_rast <- disagg(elev_m, fact = 20) |> tar_terra_rast()

  # this is not in-memory - so we must set to memory = "transient"
  rast_big <- c(
    disagg_rast,
    disagg_rast + 100,
    disagg_rast * 10,
    disagg_rast / 2
  ) |>
    tar_terra_rast(
      memory = "transient"
    )

  # split-apply-combine
  # split raster into tiles
  tiles <- rast_big |>
    tar_terra_tiles(
      tile_fun = tile_blocksize
      # tile_fun = function(x) tile_grid(x, nrow = 3, ncol = 3)
      # tile_fun = \(x) tile_grid(x, nrow = 3, ncol = 3)
    )

  # so, not using dynamic branching
  tiles_mean_big <- app(rast_big, \(x) mean(x, na.rm = TRUE)) |>
    tar_terra_rast()

  # apply - computationally intensive task on each tile
  tiles_mean <- app(tiles, \(x) mean(x, na.rm = TRUE)) |>
    # we operate on a list of things - so we map() across those
    # this is called dynamic branching
    tar_terra_rast(
      pattern = map(tiles)
    )

  # combine - merge tiles into a single SpatRaster
  merged_mean <- tiles_mean |> sprc() |> merge() |> tar_terra_rast()

  # vector ----
  vect_file <- system.file("ex", "lux.shp", package = "terra") |> tar_file()

  terra_vect <- vect(vect_file) |> tar_terra_vect()

  vect_proj <- project(terra_vect, "EPSG:2196") |> tar_terra_vect()
})

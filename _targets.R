## Load your packages, e.g. library(targets).
source("./packages.R")

## Load your R files
lapply(list.files("./R", full.names = TRUE), source)

my_controller <- crew::crew_controller_local(
  name = "bananas",
  workers = 3
)
tar_option_set(
  controller = my_controller
)

tar_assign({
  example_rast <- get_example_rast() |> tar_terra_rast()

  example_shapefile <- get_example_shapefile() |> tar_terra_vect()

  country_codes <- country_codes(query = "Australia")

  example_gadm <- get_gadm_country(country_codes$ISO3) |> tar_terra_vect()

  example_gadm_multiple <- get_gadm_country(c("Australia", "New Zealand")) |>
    tar_terra_vect()

  # alternative approach to using gadm for boundaries
  example_cgaz_country <- cgaz_country("Australia") |> tar_terra_vect()

  example_cgaz_countries <- cgaz_country(c("Australia", "New Zealand")) |>
    tar_terra_vect()

  # example of using the spatvector from one target into another
  example_sds_raster_oz <- sds_gebco(
    country_vect = example_cgaz_country,
    resolution = 1
  ) |>
    tar_terra_rast()

  ## demonstration using many countries and multiple workers
  some_countries <- countrycode::codelist$iso3c[1:6] |> tar_target()

  country_shapes <- cgaz_country(some_countries) |>
    tar_terra_vect(pattern = map(some_countries))

  my_file <- system.file("ex/elev.tif", package = "terra") |>
    tar_target(format = "file")

  my_map <- terra::rast(my_file) |> tar_terra_rast()

  rast_split <- tar_terra_tiles(
    raster = my_map,
    ncol = 2,
    nrow = 2
  )
})

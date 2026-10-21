# example SpatRaster
library(geotargets)
library(targets)
library(terra)
f <- system.file("ex/elev.tif", package = "terra")
r <- rast(f)
r
plot(r)
r_ext <- ext(r)
r_ext

rect_extent <- function(x, ...) {
  rect(x[1], x[3], x[2], x[4], ...)
}
plot_extents <- function(x, ...) {
  invisible(lapply(x, rect_extent, border = "hotpink", lwd = 2))
}

extend(r, 5) |> plot()
lines(r_ext, col = "hotpink", lty = 2)
points(r_ext, col = "hotpink", pch = 16)

## returning extents
## ?? Can we add tile/extent size based upon memory?
## Tile size would be defined by the maximum size provided
# tile_memory()
# tile_size(memory_mb = 2)
# Can we look into ?terraOptions() to use memory
# tile_n - how many tiles?
# tile_grid - how many rows and columns?
# tile_blocksize -

# tile n ----
r_tile_4 <- tile_n(r, 4)
r_tile_4

plot(r)
plot_extents(r_tile_4)

plot(r)
tile_n(r, 6) |> plot_extents()

# tile grid ----
r_grid_3x1 <- tile_grid(r, ncol = 3, nrow = 1)
r_grid_3x1
plot(r)
plot_extents(r_grid_3x1)

plot(r)
tile_grid(r, ncol = 2, nrow = 3) |> plot_extents()

# tile blocksize ----
fileBlocksize(r)

tile_blocksize(r)

# as as:
r_block_size_1x1 <- tile_blocksize(r, n_blocks_row = 1, n_blocks_col = 1)
r_block_size_1x1
plot(r)
plot_extents(r_block_size_1x1)

r_block_size_2x1 <- tile_blocksize(r, n_blocks_row = 2, n_blocks_col = 1)
r_block_size_2x1
plot(r)
plot_extents(r_block_size_2x1)

# only works for spatRasters on file, not in memory
sources(r)
# force into memory
r2 <- r + 0
sources(r2)
# this now errors
tile_blocksize(r2)

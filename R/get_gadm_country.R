#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param country
#' @return
#' @author njtierney
#' @export
get_gadm_country <- function(country = "Australia") {
  dir.create("data/shapefiles", recursive = TRUE, showWarnings = FALSE)
  geodata::gadm(
    country = country,
    level = 0,
    path = "data/shapefiles",
    version = "4.1",
    # low res
    resolution = 2
  )
}

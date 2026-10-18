#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param elev
#' @param unit
#' @return
#' @author njtierney
#' @export
set_units <- function(elev, unit = "m") {
  units(elev) <- unit
  elev
}

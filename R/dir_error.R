#' Check that directory exists
#'
#' Checks if directory exists and errors if it doesnt.
#'
#' @param dir_check Directory.
#' @return Error if directory does not exist.
#' @examples
#' \dontrun{
#' dir_error("C:/User/Project/")
#' }
#' @noRd

dir_error <- function(dir_check) {
  if (!dir.exists(dir_check)) {
    stop(paste("Directory does not exist:", dir_check))
  }
}

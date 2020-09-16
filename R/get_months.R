#' Get months all data files used in yaml rules
#'
#' This function looks into the yaml rules find if month is an input.
#' If so, the month values are collected
#'
#' @param yaml_path Full path of yaml file.
#' @return A list with vectors for each rule.
#' @examples
#' \dontrun{
#' get_months("C:/User/Docs/test.yaml")
#' }
#' @noRd


get_months <- function(yaml_path) {

  # read all in_file in single yaml file
  fl_i <- yaml::yaml.load_file(yaml_path)

  # create list with any month input
  ls_mon = list()
  for (j in seq_len(length(fl_i$rules))) {
    rule_j <- fl_i$rules[[j]]

    if ( any(names(rule_j) %in% "month") ) {

      if (!(is.integer(rule_j$month)) | any(rule_j$month > 12)) {
        stop("yaml input for month must be an integer between 1 and 12")
      }

      ls_mon[[j]] <- rule_j$month
    } else {
      ls_mon[[j]] <- NA
    }
  }

  return(ls_mon)
}

#' Get all data files used in yaml rules
#'
#' This function looks into the yaml rules to gets all RiverWare output
#' files necessary based on the `in_file` listed in the yaml rules.
#'
#' @param yaml_files A vector of yaml files.
#' @param yaml_dir Directory where yaml files are located.
#' @return A vector of data files.
#' @examples
#' \dontrun{
#' get_datafiles(c('check_lb_res.yaml', 'check_ub_outflow.yaml'), yaml_dir)
#' }
#' @noRd

get_datafiles <- function(yaml_files, yaml_dir) {

  data_files <- NULL
  for (yaml_i in yaml_files) { # multiple yaml files possible as an input

    # get file with path
    yaml_path_i <- file.path(yaml_dir, yaml_i)

    # check that input file name is a yaml file
    if (tools::file_ext(yaml_path_i) != "yaml") {
      stop("input must be a yaml rule file")
    }

    # check if yaml_dir exists
    dir_error(yaml_dir)

    # read all in_file in single yaml file
    fl_i <- yaml::yaml.load_file(yaml_path_i)
    for (j in seq_len(length(fl_i$rules))) {

      # check that yaml file has correct rule structure
      rule_j <- fl_i$rules[[j]]
      if (!(all(c("expr", "name", "in_file") %in% names(rule_j)))) {
        stop(paste(yaml_i, "- yaml file rules must define: expr, name, in_file"))
      }

      data_files <- c(data_files, rule_j$in_file)
    }
  }

  # remove duplicate file names
  data_files <- unique(data_files)

  return(data_files)
}

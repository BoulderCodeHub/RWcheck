#' Get all data files used in yaml rules
#'
#' Add a description of the function here.
#'
#' @param yaml_files A vector of yaml files.
#' @return A vector of data files.
#' @examples
#' get_datafiles(c('check_lb_res.yaml', 'check_ub_outflow.yaml'))
#'
#' dontrun{
#' get_datafiles(c('badyaml.txt'))
#' }

get_datafiles <- function(yaml_files) {

  data_files <- NULL
  for (yaml_i in yaml_files) { # multiple yaml files possible as an input

    # check that input file name is a yaml file
    if (tools::file_ext(yaml_i) != "yaml") {
      stop("input must be a yaml rule file")
    }

    # read all in_file in single yaml file
    fl_i <- yaml::yaml.load_file(yaml_i)
    for (j in seq_len(length(fl_i$rules))) {

      # check that yaml file has correct rule structure
      rule_j = fl_i$rules[[j]]
      if ( !(all(c('expr', "name", "in_file") %in% names(rule_j))) ) {
        stop("yaml file rules must define: expr, name, in_file")
      }

      data_files <- c(data_files, rule_j$in_file)
    }
  }

  # remove duplicate file names
  data_files <- unique(data_files)

  return(data_files)
}

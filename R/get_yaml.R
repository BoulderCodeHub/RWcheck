#' Get all data files used in yaml rules
#'
#' Add a description of the function here.
#'
#' @param yaml_files A vector of yaml files.
#' @return A vector of data files.
#' @examples
#' get_datafiles(c('check_lb_res.yaml'))
#'
#' dontshow{
#' get_datafiles('check_lb_res.yaml')
#' }
#'
#' dontrun{
#' get_datafiles(c('badyaml.txt'))
#' }

get_datafiles <- function(yaml_files) {

  data_files <- NULL
  for (yaml_i in yaml_files) { # multiple yaml files possible as an input

    # how should I specify where these files are e.g. wd????

    # check that input file name is a yaml file
    if (tools::file_ext(yaml_i) != "yaml") {
      stop("input must end in .yaml")
    }

    # read all in_file in single yaml file
    fl_i <- yaml::yaml.load_file(yaml_i)
    for (j in seq_len(fl_i$rules)) {
      data_files <- c(data_files, fl_i$rules[[j]]$in_file)
    }
  }

  # remove duplicate file names
  data_files <- unique(data_files)

  return(data_files)
}

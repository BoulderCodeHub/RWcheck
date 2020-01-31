#' Read and append all data_files based on file type
#'
#' The function reads RiverWare data files based on file type.
#'
#' @param data_files A vector of data files produced by get_datafiles().
#' @return A dataframe containg RW output with columns as slots and rows
#'   with timestep and trace number combination.
#' @examples
#' read_scenario(c('ReservoirOutput.csv', UBRes.rdf))
#'
#' dontrun{
#' read_scenario(c('badtype.txt'))
#' }
#'

read_scenario <- function(data_files) {

  df <- NULL
  for (data_j in unique(data_files)) {

    fl_type_j <- tools::file_ext(data_j)

    # reads based on file type
    if (fl_type_j == "rdf") {
      df_j <- RWDataPlyr::rdf_to_rwtbl2(data_j)
    } else if (fl_type_j == "csv") {
      df_j <- RWDataPlyr::read_rw_csv(data_j)
    } else {
      stop("data must be in a csv or rdf file.")
    }

    df <- rbind(df, df_j)
  }

  # select important columns and spread data
  df <- dplyr::select(df, Timestep, TraceNumber, ObjectSlot, Value)
  df <- tidyr::spread(df, ObjectSlot, Value)

  return(df)
}

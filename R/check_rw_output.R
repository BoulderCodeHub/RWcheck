#' Checks slots with yaml rules
#'
#' `check_rw_output()` takes RiverWare output (csv or rdf) and uses logic
#' written in yaml rule(s) to check the RiverWare output for errors.
#' This function was created to be run within RiverWare using the
#' Rplugin event with the available predefined arguments.
#'
#' The function needs the base directory of the scenarios,
#' which is normally automatically output when running RiverWare models in
#' RiverSMART. The \code{scenario_dir} contains subdirectories,
#' each representing an individual scenario. These individual scenario
#' directories are input to this function as a character vector,
#' \code{scenarios}. The other directories necessary in this function are the
#' location of the yaml file(s) \code{yaml_dir}, and desired output
#' directory, \code{output_dir}.
#'
#' @param scenarios A character vector of folder names inside the scenario_dir,
#'   which stores the scenario output.
#' @param yaml_rule_files A vector of yaml files.
#' @param out_fl_nm The name of the output files, default to
#'   verification_output.
#' @param scenario_dir Directory where scenarios are stored.
#' @param output_dir Directory where summary and log files are saved.
#' @param yaml_dir Directory where yaml files are stored.
#'
#' @return Writes passes and fails to summary verification file and outputs
#'   details to log_file.txt.
#'
#' @examples
#' scenarios <- c("MRM_Avg,ModelBase,RulesBase,Run-2019-10",
#'   "MRM_Avg,ModelBase,RulesBase,Run-2019-11")
#' yaml_rule_files <- c("check_lb_res.yaml", "check_ub_outflow.yaml")
#' scenario_dir <- "C:/User/Project/Scenario/"
#' output_dir <- "C:/User/Project/ScenarioSet/allScenarios/basicChecks"
#' yaml_dir <- "C:/User/Project/Code/"
#'
#' \dontrun{
#' check_rw_output(scenarios, yaml_rule_files, scenario_dir, output_dir, yaml_dir)
#' }
#'
#' @export


## -- Function
check_rw_output <- function(scenarios,
                        yaml_rule_files,
                        scenario_dir,
                        output_dir,
                        yaml_dir,
                        out_fl_nm = "verification_output") {

  # check directories exist
  dir_error(scenario_dir); dir_error(output_dir); dir_error(yaml_dir)

  # log file info
  log_nm <- file.path(output_dir, "log_file.txt")
  log_fl_towrite = c()

  # read yamls to check for data files to read
  data_files <- get_datafiles(yaml_rule_files, yaml_dir)

  # loop through scenarios and process with yaml rules
  out_summ <- summ_err <- NULL
  for (scenario_i in scenarios) {
    log_fl_towrite = c(log_fl_towrite,
                           paste("\nScenario -", scenario_i))

    # read and append all data_files based on file type
    data_files_path <- file.path(scenario_dir, scenario_i, data_files)
    df <- read_scenario(data_files_path)

    # loop through yaml rule files and collect summary output
    for (yaml_i in yaml_rule_files) {
       yaml_path_i <- file.path(yaml_dir, yaml_i)

      # process yaml rule with scenario output
      rules_j <- validate::validator(.file = yaml_path_i)

      # process rules individually so extra timesteps are not added
      vv_sum <- NULL
      for (rule_n in seq_len(length(rules_j))) {
        slot_j <- validate::variables(rules_j[rule_n])

        df_n <- dplyr::filter(df, ObjectSlot == slot_j)
        df_n <- dplyr::select(df_n, -ObjectSlot)
        colnames(df_n)[3] <- slot_j

        vv <- validate::confront(as.data.frame(df_n), rules_j[rule_n])
        vv_sum_n <- validate::summary(vv)
        vv_sum <- rbind.data.frame(vv_sum, vv_sum_n)
      }

      # print fails or passes
      if (max(vv_sum$fails) > 0) {

        n_fail <- which(vv_sum$fails > 0)
        n_passOnly <- seq(nrow(vv_sum))[-n_fail]

        log_fl_towrite =
          c(log_fl_towrite,
                paste(" ", yaml_i, "... resulted in", length(n_passOnly),
                      "/", nrow(vv_sum), "passes"))
        log_fl_towrite =
          c(log_fl_towrite,
                paste("    ***   Fail:", vv_sum[n_fail, 1], "failed in",
                      vv_sum[n_fail, 4], "timesteps"))

      } else {
        log_fl_towrite = c(log_fl_towrite,
                               paste(" ", yaml_i, "... all passes"))
      }

      # print error
      if (length(validate::errors(vv)) > 0) {

        log_fl_towrite = c(
          log_fl_towrite,
          paste("    ***   Error:", unlist(validate::errors(vv))))
      }

      # collect summary of rule output
      out_summ_i <- dplyr::select(
        vv_sum, name, passes, fails, error, warning, expression)
      out_summ <- rbind(out_summ, cbind(scenario_i, yaml_i, out_summ_i))
    }
  }

  # write output to text file
  utils::write.table(out_summ, file.path(output_dir, paste0(out_fl_nm, ".txt")),
              sep = "\t", row.names = FALSE)

  # add summary to beginning of log file
  nscen <- length(unique(out_summ$scenario_i))
  nfail_all <- out_summ[which(out_summ$fails > 0), ]
  nfails <- length(unique(nfail_all$scenario_i))
  npass <- nscen - nfails

  log_fl_towrite =
    c(paste("Summary of results by scenario and yaml file:\n----------------------------------------------\n",
                npass, "/", nscen, "scenarios passed all tests\n",
                nfails, "/", nscen, "scenarios failed tests\n----------------------------------------------"),
          log_fl_towrite) #, sep = "\n", collapse = T)

  # open and write to log file
  log_fl <- file(log_nm, open = "w")
  writeLines(log_fl_towrite, con = log_fl)
  on.exit(close(log_fl))

  # return invisible of out_summ
  invisible(out_summ)
}

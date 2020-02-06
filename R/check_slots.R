#' Checks slots with yaml rules
#'
#' `check_slots()` takes RiverWare output (csv or rdf) and uses logic
#' written in yaml rule(s) to check the RiverWare output for errors.
#' This function was created to be run within RiverWare using the
#' Rplugin event with the available predefined arguments.
#'
#' The function needs the base directory of the scenarios, \code{scenario_dir},
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
#' check_slots(scenarios, yaml_rule_files, scenario_dir, output_dir, yaml_dir)
#'
#' @export


## -- Function
check_slots <- function(scenarios,
                        yaml_rule_files,
                        scenario_dir,
                        output_dir,
                        yaml_dir,
                        out_fl_nm = "verification_output") {

  # check directories exist
  dir_error(scenario_dir); dir_error(output_dir); dir_error(yaml_dir)

  # open log file
  log_nm <- paste0(output_dir, "\\log_file.txt")
  log_fl <- file(log_nm, open = "w")

  # read yamls to check for data files to read
  data_files <- RWcheck:::get_datafiles(yaml_rule_files, yaml_dir)

  # loop through scenarios and process with yaml rules
  out_summ <- summ_err <- NULL
  for (scenario_i in scenarios) {
    cat(paste("Scenario -", scenario_i), file = log_fl, sep = "\n")

    # read and append all data_files based on file type
    data_files_path <- paste0(scenario_dir, "/", scenario_i, "/", data_files)
    df <- RWcheck:::read_scenario(data_files_path)

    # loop through yaml rule files and collect summary output
    scen_err <- NULL
    for (yaml_i in yaml_rule_files) {
      yaml_i <- paste0(yaml_dir, "/", yaml_i)

      # process yaml rule with scenario output
      rules_j <- validate::validator(.file = yaml_i)
      vv <- validate::confront(as.data.frame(df), rules_j)
      vv_sum <- validate::summary(vv)

      # print errors/fails or passes
      yaml_rules <- dplyr::last(unlist(strsplit(yaml_i, "/", fixed = TRUE)))
      if (length(validate::errors(vv)) > 0) {
        cat(paste("  ... errors in", yaml_rules), file = log_fl, sep = "\n")
        cat(validate::errors(vv), file = log_fl, sep = "\n")
        scen_err <- c(scen_err, 1)
      } else if (max(vv_sum$fails) > 0) {
        # check for fails
        n_fail <- which(vv_sum$fails > 0)
        n_fail <- vv_sum[n_fail, c(1, 4)]
        cat(paste("  ... fails in", yaml_rules), file = log_fl, sep = "\n")
        cat(paste("  ***     ", n_fail[1], "failed in", n_fail[2],
                  "timesteps      ***"), file = log_fl, sep = "\n")
        scen_err <- c(scen_err, 1)
      } else {
        cat(paste("  ... all passes in", yaml_rules), file = log_fl, sep = "\n")
        scen_err <- c(scen_err, 0)
      }

      # collect summary of rule output
      out_summ_i <- dplyr::select(vv_sum,
                                   name, passes, fails, error, warning, expression)
      out_summ <- rbind(out_summ, cbind(scenario_i, out_summ_i))

      # out_summ_i <- rbind(out_summ_i, vv_sum)
    }

    # add scenario name and combine
    out_summ_i2 <- dplyr::select(out_summ_i,
                                name, passes, fails, error, warning, expression)
    out_summ <- rbind(out_summ, cbind(scenario_i, out_summ_i))

    # check if scenario produced errors
    if (sum(scen_err) > 0) {
      summ_err <- c(summ_err, 1)
      } else {
      summ_err <- c(summ_err, 0)
    }
  }

  # write output to text file
  write.table(out_summ, paste0(output_dir, "\\", out_fl_nm, ".txt"),
              sep = "\t", row.names = FALSE)
  close(log_fl)

  # add summary to beginning of log file
  nscen <- length(summ_err)
  npass <- nscen - sum(summ_err)
  fConn <- file(log_nm, "r+")
  Lines <- readLines(fConn)
  writeLines(c(paste(npass, "/", nscen,
                     "scenarios passed all tests\n"), Lines), con = fConn)
  close(fConn)
}

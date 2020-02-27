context("check that check_rw_output() works as intended")

# Set up function inputs
base_dir <- dirname(getwd())
scenario_dir <- file.path(base_dir, "Scenarios")
output_dir <- file.path(base_dir, "out_dir")
yaml_dir <- file.path(base_dir, "yaml_files")
scenarios <- c("RS_scenario1", "RS_scenario2")
yaml_rule_files <- c("check_complex_rdf.yaml", "check_lb_res.yaml",
                     "check_ub_outflow.yaml")


test_that("Check function runs correctly", {
  expect_error(check_rw_output(scenarios,
                           yaml_rule_files,
                           scenario_dir,
                           output_dir,
                           yaml_dir),
               NA)

  # read log file and check
  log_nm <- file.path(output_dir, "log_file.txt")
  fConn <- file(log_nm, "r")
  log_lines <- readLines(fConn)
  close(fConn)

  # first line of log file contains summary of passes/fails
  expect_equal(grep("scenarios passed all tests", log_lines), 3)
  # check that errors were produced
  expect_length(grep("Error", log_lines), 2)
  # check length of log file
  expect_length(log_lines, 20)

  # read verification output file
  summ <- read.table(file.path(output_dir, "verification_output.txt"),
                     header = T)
  expect_length(summ, 8)
  expect_equal(sum(as.numeric(as.character(summ[seq(nrow(summ)), 5]))), 18944)
  expect_equal(length(unique(summ[seq(nrow(summ)),1])), 2)

})


test_that("errors from bad wd", {
  expect_error(check_rw_output(scenarios,
                           yaml_rule_files,
                           scenario_dir,
                           "C:/User/Bad",
                           yaml_dir))
})





#what happens with NA in files
# yaml_rule_files <- "check_complex_rdf.yaml"
# yaml_rule_files <- c("check_complex_rdf.yaml","check_lb_res.yaml", "check_ub_outflow.yaml")
# yaml_rule_files <- "check_complex_rdf.yaml"
# RWcheck:::check_rw_output(scenarios,
#                       yaml_rule_files,
#                       scenario_dir,
#                       output_dir,
#                       yaml_dir)


context("check that check_slots() works as intended")

# Set up function inputs
base_dir <- dirname(getwd())
scenario_dir <- paste0(base_dir, "/Scenarios")
output_dir <- paste0(base_dir, "/out_dir")
yaml_dir <- paste0(base_dir, "/yaml_files")
scenarios <- c("RS_scenario1", "RS_scenario2")
yaml_rule_files <- c("check_lb_res.yaml", "check_ub_outflow.yaml")


test_that("no errors and function runs correctly", {
  expect_error(RWcheck:::check_slots(scenarios,
                                     yaml_rule_files,
                                     scenario_dir,
                                     output_dir,
                                     yaml_dir),
               NA)

  # read log file and check
  log_nm <- paste0(output_dir, "\\log_file.txt")
  fConn <- file(log_nm, "r")
  log_lines <- readLines(fConn)

  # first line of log file contains summary of passes/fails
  expect_equal(grep("scenarios passed all tests", log_lines), 1)
  # check length is 10
  expect_length(log_lines, 10)

  # read verification output file
  summ <- read.table(paste0(output_dir, "/verification_output.txt"))
  expect_length(summ, 7)
  expect_equal(sum(as.numeric(as.character(summ[2:21,4]))), 256)
  expect_equal(length(unique(summ[2:21,1])), 2)

})


test_that("errors from bad wd", {
  expect_error(RWcheck:::check_slots(scenarios,
                                     yaml_rule_files,
                                     scenario_dir,
                                     "C:/User/Bad",
                                     yaml_dir))
})

#what happens with NA in files

# RWcheck:::check_slots(scenarios,
#                       yaml_rule_files,
#                       scenario_dir,
#                       output_dir,
#                       yaml_dir)
#

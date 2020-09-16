context("check that get_months() works as intended")

yaml_dir <- file.path(dirname(getwd()), "yaml_files")

test_that("error occurs if bad input to yaml month input", {
  yaml_rule_files <- c("check_monBad.yaml")
  yaml_path <- paste0(yaml_dir, "/", yaml_rule_files)

  expect_error(RWcheck:::get_months(yaml_path))
})

test_that("function reads yaml months correctly", {
  yaml_rule_files <- c("check_monGood.yaml")
  yaml_path <- paste0(yaml_dir, "/", yaml_rule_files)

  ls_out <- RWcheck:::get_months(yaml_path)

  expect_length(ls_out, 2)
  expect_type(ls_out, "list")
  expect_equal(ls_out[[2]], NA)
  expect_type(ls_out[[1]], "integer")
})


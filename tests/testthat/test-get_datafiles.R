context("check that get_datafiles() works as intended")

yaml_dir <- paste0(dirname(getwd()), "/yaml_files")

test_that("error occurs if not yaml file", {
  expect_error(RWcheck:::get_datafiles("noData.txt",
                                       yaml_dir))
})

test_that("error occurs if yaml with wrong structure", {
  expect_error(RWcheck:::get_datafiles("check_ub_outflowBad.yaml",
                                       yaml_dir = "C:/User/Bad"))
})

test_that("error occurs if yaml_dir does not exist", {
  expect_error(RWcheck:::get_datafiles("check_ub_outflowBad.yaml",
                                       yaml_dir))
})

test_that("yaml reads two files names", {
  yam_ls <- RWcheck:::get_datafiles(c("check_lb_res.yaml",
                                      "check_ub_outflow.yaml"),
                                    yaml_dir)

  expect_length(yam_ls, 2)
})

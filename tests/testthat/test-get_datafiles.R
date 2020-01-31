context("check that get_datafiles() works as intended")

test_that("error occurs if not yaml file", {
  expect_error(RWcheck:::get_datafiles("../noData.txt"))
})

test_that("error occurs if yaml with wrong structure", {
  expect_error(RWcheck:::get_datafiles("../check_ub_outflowBad.yaml"))
})

test_that("yaml reads two files names", {
  yam_ls <- RWcheck:::get_datafiles(c("../check_lb_res.yaml",
                                      "../check_ub_outflow.yaml"))

  expect_length(yam_ls, 2)
})

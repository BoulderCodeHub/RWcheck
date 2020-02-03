context("check that dir_errors() works as intended")

test_that("error occurs if directory does not exist", {
  expect_error(RWcheck:::dir_error("C:/User/Bad"))
})

test_that("no error with existing directory", {
  expect_error(RWcheck:::dir_error(getwd()), NA)
})

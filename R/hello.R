# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Reload package/files       'Ctrl + Shift + L'
#   create func documentaiton       'Ctrl + Shift + D'
#   Install Package:           'Ctrl + Shift + B' ****
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'


#  check code formatting          lintr::lint_package()
#  update package documentation   devtools::document()


hello <- function() {
  print("Hello, world!")
}

#

# always access packages ::
#' devtools::document()
#' usethis::use_testthat() # setup testing (only once)
#' devtools::test()        # runs all tests
#' usethis::use_test()     # set indiv testing file for function
#' test/testthat create testing files
#'
#' assertthat::assert_that() - test user input, character, lenght...
#'
#' devtools::check - checks everything once package is stable
# readme.md - add for git

#' continuous integration - ask alan later

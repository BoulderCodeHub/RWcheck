# Notes of Package Development
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


# devtools::document()
# usethis::use_test()     # setup testing (only once per func)
# devtools::test()        # runs all tests
# usethis::use_test()     # set indiv testing file for function
# test/testthat create testing files
#
# assertthat::assert_that() - test user input, character, length...
#
# always access packages ::
#
# devtools::check - checks everything once package is stable
# readme.md - add for git

# continuous integration - ask alan later

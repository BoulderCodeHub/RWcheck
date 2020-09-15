context("check that read_scenario() works as intended")

# test data
base_dir <- file.path(dirname(getwd()), "Scenarios/RS_scenario1/")
df_rdf <- RWcheck:::read_scenario(file.path(base_dir, "UBRes.rdf"))
df_csv <- RWcheck:::read_scenario(file.path(base_dir, "ReservoirOutput.csv"))


test_that("error occurs if not csv or rdf files", {
  expect_error(read_scenario(file.path(base_dir, "noData.txt")))
})

test_that("check colnames and number", {
  expect_length(df_rdf, 4)
  expect_true(any(colnames(df_rdf) %in% c("Timestep", "TraceNumber")))

  expect_length(df_csv, 4)
  expect_true(any(colnames(df_csv) %in% c("Timestep", "TraceNumber")))
})

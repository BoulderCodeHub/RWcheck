context("check that read_scenario() works as intended")

# test data
base_dir <- paste0(dirname(getwd()), "/Scenarios/RS_scenario1/")
df_rdf <- RWcheck:::read_scenario(paste0(base_dir, "UBRes.rdf"))
df_csv <- RWcheck:::read_scenario(paste0(base_dir, "ReservoirOutput.csv"))


test_that("error occurs if not csv or rdf files", {
  expect_error(read_scenario(paste0(base_dir, "noData.txt")))
})

test_that("check colnames and number", {
  expect_length(df_rdf, 84)
  expect_true(any(colnames(df_rdf) %in% c("Timestep", "TraceNumber")))

  expect_length(df_csv, 62)
  expect_true(any(colnames(df_csv) %in% c("Timestep", "TraceNumber")))
})

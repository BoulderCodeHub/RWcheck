RWcheck
=================
<!-- badges: start -->
[![R build status](https://github.com/BoulderCodeHub/RWcheck/workflows/R-CMD-check/badge.svg)](https://github.com/BoulderCodeHub/RWcheck/actions)
[![Codecov test coverage](https://codecov.io/gh/BoulderCodeHub/RWcheck/branch/master/graph/badge.svg)](https://codecov.io/gh/BoulderCodeHub/RWcheck?branch=master)
<!-- badges: end -->

The RWcheck package is used to check RiverWare simulation output with rules written in yaml files.

## Installation

RWcheck can be installed from GitHub:

```{r, eval=FALSE}
# install.packages("devtools")
devtools::install_github("BoulderCodeHub/RWcheck")
```

## Yaml Specifications and Example

The RWcheck relies on rules written in yaml files, which are interpreted by the `validate` R package. Yaml is a human-readable programming language that can be used for defining a nested file structure. Yaml file specifications: 
* When defining rules, you must first add `rules:`, followed by a new line with a dash. Each rule starts with a dash. Indentations must be two spaces, not tabs. Make sure the file does not end in a dash since the function expects there to be another rule which won't exist. 
* The file should end with a blank newline.
* The rules must contain inputs for `expr`, `name` and `in_file`, but can contain other information (see example below). 
* The `expr` line must contain a logical expression. If a logical expression begins with `!`, it must be surrounded in quotes. 
* If the RiverWare slot contains spaces in the `Object.Slot`, they need to be removed in the `expr` logic. This doesn't need to be done in the `name`. 
* The yaml rules check slots in the `in_file`, which can be an `.rdf` or `.csv` file. 
* The rules may contain an argument `month`, which specifies month(s) to run the test. The months must be input as numbers, e.g. `[1, 2, 3]`. This is an optional input.

Below is an example of a yaml file that would check if slots are greater than zero or if they are `NA`.


```
# Example yaml rules - saved as "check_RWslots_ex.yaml"
rules:
-
  expr: Mead.Outflow >= 0
  name: Mead.Outflow
  label: Mead Outflow
  description: |
    Mead Outflow should never be negative.
  in_file: ReservoirOutput.csv
-
  expr: Mead.PoolElevation > 0
  name: Mead.Pool Elevation
  label: Mead PE
  description: |
    Mead PE should never be NA
  in_file: ReservoirOutput.csv
-
  expr: '!is.na(SummaryOutputData.EqualizationAbove823)'
  month: [12]
  name: EqualizationAbove823
  label: Equalization Above 823
  description: |
    Equalization ABove 823 should never be NA
  in_file: UBRes.rdf
  
```

After creating a yaml file with as many rules as you need to verify the model ran correctly, perform the tests by using `check_rw_output()`. The arguments to this function specify the scenarios that will be checked, the top level directory of the scenarios, the yaml file and its location, as well as the desired location of the output which is saved in log/text files.

```{r}
scenarios <- c("MRM_Avg,ModelBase,RulesBase,Run-2019-10",
  "MRM_Avg,ModelBase,RulesBase,Run-2019-11")
# assuming the previous example is stored as check_lb_res.yaml and there is an
# additional file called check_ub_outputlow.yaml
yaml_rule_files <- c("check_lb_res.yaml", "check_ub_outflow.yaml")
scenario_dir <- "C:/User/Project/Scenario/"
output_dir <- "C:/User/Project/ScenarioSet/allScenarios/basicChecks"
yaml_dir <- "C:/User/Project/Code/"

x <- check_rw_output(
  scenarios, yaml_rule_files, scenario_dir, output_dir, yaml_dir
)
```

`check_rw_output()` creates two files: one specified by the optional `out_fl_nm` and a log_file.txt. The log file includes a summary of all pass/fails at the top and then details for each scenario. the `out_fl_nm` is a table summarizing the pass/fails for each test and each scenario. It has (number of scenarios * number of tests) rows. This information is also invisibly returned as a `data.frame`.

Example from the log file:

```
Summary of results by scenario and yaml file:
----------------------------------------------
 0 / 1 scenarios passed all tests
 0 / 1 scenarios produced errors
----------------------------------------------

Scenario - Apr2020_2021,ISM1988_2018,2007Dems,IG_DCP,MTOM_most
  crss_checks.yaml ... resulted in 2 / 3 passes
    ***   Fail: EqualizationAbove823 failed in 10571 timesteps
```

## Integrating with RiverSMART

RWcheck is designed to be integrated with RiverSMART to quickly and semi-automatically perform the specified tests on all scenarios in a RiverSMART study. To use RWcheck with RiverSMART:

1. Ensure that R (Rscript) is in the user Path environment variable, e.g., C:/Program Files/R/bin
2. Add an R event to the study
3. Create a "Scenario Set" with all of the scenarios that need the tests run on them
4. Create an R file that includes a function that calls `check_rw_output()`. This function can be as simple as a function that essentially passes the same arguments on to `check_rw_output()` (see below).
5. Configure the R event to pass in the required arguments. Many can be "pre-specified", as this is information RiverSMART knows. Particularly, the scenarios argument. 
  - if any paths are "hard coded", they need to use `/` or escape the back slashes `\\`. 
6. Configure the R event to process by "Scenario Set"
7. Run the R event: Scenarios -> Process R Events -> "R Event Name"
8. Wait
9. The output and log file will be saved to $CRSS_DIR/ScenarioSet/[Scenario Set Name]/[R Event Name]
  - There is also a RiverSMART based log file saved at $CRSS_DIR/Working/[R Event Name]/[Scenario Set Name], which can be useful for determining if the function call(s) worked properly.

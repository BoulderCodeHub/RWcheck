## RWcheck
The RWcheck package is used to check RiverWare simulation output with rules written in yaml files.

## Installation

RWcheck can be installed from GitHub:

```{r, eval=FALSE}
# install.packages("devtools")
devtools::install_github("BoulderCodeHub/RWcheck")
```

## Example

The RWcheck relies on rules written in yaml files. Below is an example of a yaml file that would check if slot outputs are greater than zero or if they are NA. The yaml rules checks at slots in the `in_file`, which can be an `.rdf` or `.csv` file. The `expr` line must contain a logical expression. If the RiverWare slot contains spaces in the Object.Slot name, they need to be removed. If a logical expression begins with `!`, it must be surrounded in single quotes. 

```
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
  name: Mead.PoolElevation
  label: Mead PE
  description: |
    Mead PE should never be NA
  in_file: ReservoirOutput.csv
-
  expr: '!isNA(SummaryOutputData.EqualizationAbove823)'
  name: EqualizationAbove823
  label: Equalization Above 823
  description: |
    Equalization ABove 823 should never be NA
  in_file: UBRes.rdf
```

## Notes

Code relies on [RWDataPlyr](https://github.com/BoulderCodeHub/RWDataPlyr)
and the following packages available on CRAN:
* devtools
* dplyr
* validate
* tools
* yaml
* tidyr
* utils
* stringr

Ensure the above packages are installed on the computer. RWDataPlyr can be installed as follows:
```
library(devtools)
devtools::install_github('BoulderCodeHub/RWDataPlyr')
```



# brainbaser
## Introduction
[Brainbase Web](brainbase.imp.ac.at) is an interactive website containing
information about neurons in the Drosophila (fruit fly) nervous system. It
includes brain expression patterns of a large collection of genetic driver
lines, the Vienna Tiles (VT) collection. brainbaser enables programmatic queries
of expression levels for different neuropil domains, download of image data and
other utility functions.

## Quick Start

For the impatient ...

```r
# install
if (!require("devtools")) install.packages("devtools")
devtools::install_github("jefferis/brainbaser")

# use
library(brainbaser)

# run examples
example("neuropil_overlaps")

# get overview help for package
?brainbaser
# help for functions
?neuropil_overlaps

# run tests
library(testthat)
test_package("brainbaser")
```

## Installation
Currently there isn't a released version on [CRAN](http://cran.r-project.org/).

### Development version
You can use the **devtools** package to install the development version:

```r
if (!require("devtools")) install.packages("devtools")
devtools::install_github("jefferis/brainbaser")
```

Note: Windows users need [Rtools](http://www.murdoch-sutherland.com/Rtools/) and [devtools](http://CRAN.R-project.org/package=devtools) to install this way.

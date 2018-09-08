# BLT
## read_blt
Package created to read .blt files from OpenSTV / OpaVote into R and parse them as tibbles with one row per ballot, and columns indicating preference order from left to right. Each column stored as a factor with candidate names.

Originally created for Green Party of England and Wales internal elections - if you have examples of .blt files which do not work with this package, please send them on.

## Installation/Example:
devtools::install_github("jackgovier/BLT")
library(blt)

df <- read_blt("./deputy-leader.blt")

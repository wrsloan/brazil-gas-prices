# Brazil Fuel Prices
## Synopsis
First, I construct an interactive exploratory data analysis highlighting fuel, region, and state-specific price discrepancies using R Shiny.  Following this, I model fuel prices using a bootstrapped linear regression in addition to a generalized linear model with maximum penalized likelihood (via glmnet package). Of all fuel types, I find ethanol prices fluctuate most significantly, being heavily affected by domestic supply shortages along with multiple shocks to demand.  With ethanol serving as a substitute to gasoline in Brazil's fuel industry, it's price is subject to demand shocks of both fuels.  Furthermore, price dynamics vary geographically due to relative number of highways, fuel transport costs, poverty levels, and state-specific legislature.  

### Instructions
R is required to run the code in bgp_analysis.Rmd.  First, install the required packages as listed below.  The file is in R Markdown format, but uses R Shiny to include interactive features.  Next, download the primary and secondary datasets, in addition to bgp_analysis.Rmd.  Ensure the files are located in the same directory, with R set to this directory.  Lastly, open bgp_analysis.Rmd in R and run the document.  Note runtime may take a few minutes.

### Required Packages
tidyverse, gridExtra, viridis, lubridate, date, scales, data.table, fastDummies
caret, glmnet, tools, knitr, DT, shiny

### Primary Dataset
brazil_gas_prices.tsv is the primary dataset used, and is provided by The National Agency of Petroleum, Natural Gas, and Bio Fuels (ANP).

### Price Modeling: Secondary Datasets
brent_prices.csv and wti_prices.csv are international oil prices, and were gathered from FRED.

brazil_gdp.csv and china_gdp.csv were gathered from FRED as well.

(international) sugar_prices.csv and PBR.csv (Petrobras stock prices) were obtained from Macrotrends and
Yahoo! Finance, respectively.  Petrobras is Brazil's largest petroleum producing firm.

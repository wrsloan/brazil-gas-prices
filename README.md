# Brazil Fuel Prices
## Synopsis
In this study, I examine the behavior of Brazil's fuel prices ranging from May 9, 2004 - June 1, 2019.  First, I construct an interactive exploratory data analysis highlighting fuel, region, and state-specific price discrepancies using R Shiny.  The analysis is separated into three sections; ethanol supply shortages, the 2014-2016 economic crisis, and the post-fuel tax period.  Following this, I model fuel prices using a bootstrapped linear regression in addition to a generalized linear model with maximum penalized likelihood. Of all fuel types, I find ethanol prices fluctuate most significantly, being heavily affected by domestic supply shortages along with multiple shocks to demand.  With ethanol serving as a substitute to gasoline in Brazil's fuel industry, its price is subject to demand shocks of both fuels.  Hence, ethanol prices rarely remain stable.  Furthermore, price dynamics vary geographically due to relative number of highways, fuel transport costs, poverty levels, and state-specific legislature.  Lastly, I find the bootstrapped linear regression model to be both a better fit on the training data and more accurate in predicting on the test set.  

### Instructions
R is required to run the code in bgp_analysis.Rmd.  First, install the required packages as listed below.  The file is in R Markdown format, but uses R Shiny to include interactive features.  Next, download the primary and secondary datasets (as specified below), in addition to bgp_analysis.Rmd.  Ensure the files are located in the same directory, with R set to this directory.  Lastly, open bgp_analysis.Rmd in R and run the document.  Note runtime may take a few minutes.

### Required Packages
tidyverse, gridExtra, viridis, lubridate, date, scales, data.table, fastDummies,
caret, glmnet, tools, knitr, DT, shiny

### Primary Dataset
brazil_gas_prices.tsv is the primary dataset used, and is provided by The National Agency of Petroleum, Natural Gas, and Bio Fuels (ANP).

### Price Modeling: Secondary Datasets
brent_prices.csv and wti_prices.csv are two separate measures of oil prices, and were gathered from FRED.

brazil_gdp.csv and china_gdp.csv were gathered from FRED as well.

(international) sugar_prices.csv and PBR.csv (Petrobras stock prices) were obtained from Macrotrends and
Yahoo! Finance, respectively.  Petrobras is Brazil's largest petroleum producing firm.

### Remaining Files
The following files separate the code used in bgp_analysis.Rmd by functionality.

In bgp_wrangling.R, I import, clean, and merge the datasets.  bgp_plotFunc.R includes the three plotting functions I created to visualize price dynamics, also being utilized in the interactive portion of the project.  bgp_Shiny.R specifies the input and output objects created for the interactive portion, separated by corresponding section.  bgp_DTs.R includes the data tables used in examining state-specific price fluctuations.  These tables correspond to the three sections analyzed in the exploratory data analysis.  Lastly, bgp_model provides the code used in creating both models and assessing their relative accuracy.

server.R and ui.R are still being modified.  I am in the process of making this report available as a Shiny App to allow for better accessibility.  Users will then be able to run the report in one line of code, being `shiny::runGitHub('brazil-gas-prices', 'wrsloan')`.

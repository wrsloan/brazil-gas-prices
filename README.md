# Brazil Fuel Prices
## R Markdown (Shiny) Document
See bgp_analysis.Rmd for a detailed examination of Brazil's historical fuel price dynamics.

First, I construct an interactive exploratory data analysis highlighting region- and state-specific
price discrepancies using R Shiny.

Following this, I model fuel prices using a bootstrapped linear regression in addition to a generalized
linear model with maximum penalized likelihood (via glmnet package).

Note bgp_analysis.Rmd may take a few minutes to run.

### Primary Dataset
brazil_gas_prices.tsv is the primary dataset used, and is provided by The National Agency of Petroleum, 
Natural Gas, and Bio Fuels (ANP).

### Price Modeling: Secondary Datasets
brent_prices.csv and wti_prices.csv are international oil prices, and were gathered from FRED.

brazil_gdp.csv and china_gdp.csv were gathered from FRED as well.

(international) sugar_prices.csv and PBR.csv (Petrobras stock prices) were obtained from Macrotrends and
Yahoo! Finance, respectively.  Petrobras is Brazil's largest petroleum producing firm.



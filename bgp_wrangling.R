library(tidyverse)
library(gridExtra)
library(viridis)
library(lubridate)
library(date)
library(scales)
library(data.table)
library(fastDummies)
library(caret)
library(glmnet)
library(tools)
library(knitr)
library(DT)
#-----------------------------------------------------------------------------------------------

# Read in dataframe
df <- read.table('brazil_gas_prices.tsv', sep = '\t', header = TRUE)

# Translate column labels
df <- df %>%
  rename(
    'initial_date'    = DATA.INICIAL,
    'final_date'      = DATA.FINAL,
    'region'          = REGIÃO,
    'state'           = ESTADO,
    'product'         = PRODUTO,
    'n_stations'      = NÚMERO.DE.POSTOS.PESQUISADOS,
    'measurement'     = UNIDADE.DE.MEDIDA,
    'mean_price'      = PREÇO.MÉDIO.REVENDA,
    'month'           = MÊS,
    'year'            = ANO
  )

# Translate region/fuel type
df <- df %>%
  select(initial_date, final_date, region, state, product, measurement,
         mean_price, month, year) %>%
  mutate(region = fct_recode(region,
                             'Central-West'   = 'CENTRO OESTE',
                             'Northeast' = 'NORDESTE',
                             'North'     = 'NORTE',
                             'Southeast' = 'SUDESTE',
                             'South'     = 'SUL')) %>%
  mutate(product = fct_recode(product,
                              'Common Gas'  = 'GASOLINA COMUM',
                              'Diesel'      = 'ÓLEO DIESEL',
                              'Ethanol'     = 'ETANOL HIDRATADO',
                              'Diesel S10'  = 'ÓLEO DIESEL S10')) %>%
  # Analysis will focus on common gas, diesel, diesel s10, and ethanol
  mutate(final_date = as.Date(final_date)) %>%
  filter(product != 'GNV', product != 'GLP', final_date <= '2019-06-01' )

# Convert states from all caps to title case
df$state <- tolower(df$state)
df$state <- toTitleCase(df$state)

# Explicit fuel price NAs
sum(is.na(df$mean_price))

checkNAs <- df %>%
  select(final_date, year, month, mean_price, product, region, state) %>%
  group_by(product, region, state) %>%
  spread(product, mean_price) %>%
  rename('Common_Gas' = 'Common Gas', 'Diesel_S10'= 'Diesel S10')

# Implicit ethanol NAs
sum(is.na(checkNAs$Ethanol))
# Implicit common gas NAs
sum(is.na(checkNAs$Common_Gas))
# Implicit diesel NAs
sum(is.na(checkNAs$Diesel))

post_2013 <- checkNAs %>%
  filter(year >= 2013)
# Implicit diesel S10 NAs
sum(is.na(post_2013$Diesel_S10))

# Ethanol NAs
eth_NAs <- checkNAs %>%
  select(final_date, region, state, Ethanol) %>%
  arrange(!is.na(Ethanol)) %>%
  rename('Date' = 'final_date', 'Region' = 'region', 'State' = 'state', 'Ethanol Price' = 'Ethanol')
datatable(head(eth_NAs, 100))

# Diesel s10 NAs (introduced Jan 2013)
post_2013 <- post_2013 %>%
  select(final_date, region, state, Diesel_S10) %>%
  arrange(!is.na(Diesel_S10)) %>%
  rename('Date' = 'final_date', 'Region' = 'region', 'State' = 'state', 'Diesel S10 Price' = 'Diesel_S10')
datatable(head(post_2013, 100))

# Import/merge remaining data
# Crude oil prices
# WTI
wti <- read.csv('wti_prices.csv', header = TRUE)
wti <- wti %>%
  rename('date' = DATE, 'wti_price' = DCOILWTICO) %>%
  filter(wti_price != '.') %>%
  mutate(date = as.Date(date, format = '%Y-%m-%d'), week = floor_date(date, 'week'),
         wti_price = as.numeric(as.character(wti_price)))
# Mean prices by week
wti <- aggregate(wti_price ~ week, FUN = mean, data = wti)
wti <- wti %>%
  rename('final_date' = 'week') %>%
  # Change date from beg to end of week
  mutate(final_date = as.Date(final_date, format = '%Y-%m-%d'), final_date = final_date + 6)

# Brent
brent <- read.csv('brent_prices.csv', header = TRUE)
brent <- brent %>%
  rename('date' = DATE, 'brent_price' = DCOILBRENTEU) %>%
  filter(brent_price != '.') %>%
  mutate(date = as.Date(date, format = '%Y-%m-%d'), week = floor_date(date, 'week'),
         brent_price = as.numeric(as.character(brent_price)))
# Mean prices by week
brent <- aggregate(brent_price ~ week, FUN = mean, data = brent)
brent <- brent %>%
  rename('final_date' = 'week') %>%
  # Change date from beg to end of week
  mutate(final_date = as.Date(final_date, format = '%Y-%m-%d'), final_date = final_date + 6)

# Import sugar prices
sugar <- read.csv('sugar_prices.csv', header = TRUE)
sugar <- sugar %>%
  rename('daily_price' = 'value') %>%
  filter(as.Date(date) >= '2004-05-10' & as.Date(date) <= '2019-06-01') %>%
  mutate(date = as.Date(date, format = '%Y-%m-%d'), week = floor_date(date, 'week'))
# Mean prices by week
sugar <-  aggregate(daily_price ~ week, FUN = mean, data = sugar)
sugar <- sugar %>%
  rename('final_date' = 'week', 'sugar_price' = 'daily_price') %>%
  # Change date from beg to end of week
  mutate(final_date = as.Date(final_date, format = '%Y-%m-%d'), final_date = final_date + 6)

# Import Petrobras stock prices
petrobras <- read.csv('PBR.csv', header = TRUE)
petrobras <- petrobras %>%
  select(Date, Open) %>%
  rename('date' = Date, 'stock_price' = Open) %>%
  filter(as.Date(date) >= '2004-05-10' & as.Date(date) <= '2019-06-01') %>%
  mutate(date = as.Date(date, format = '%Y-%m-%d'), week = floor_date(date, 'week'),
         stock_price = as.numeric(as.character(stock_price)))
# Mean prices by week
petrobras <- aggregate(stock_price ~ week, FUN = mean, data = petrobras)
petrobras <- petrobras %>%
  rename('final_date' = 'week') %>%
  # Change date from beg to end of week
  mutate(final_date = as.Date(final_date, format = '%Y-%m-%d'), final_date = final_date + 6)

# Import Brazil GDP
b_gdp <- read.csv('brazil_gdp.csv', header = TRUE)
b_gdp <- b_gdp %>%
  rename('date' = DATE, 'b_gdp' = BRALORSGPNOSTSAM) %>%
  mutate(date = as.Date(date, format = '%Y-%m-%d')) %>%
  filter(date >= '2004-05-01' & date <= '2019-05-01')

# Import China GDP
c_gdp <- read.csv('china_gdp.csv', header = TRUE)
c_gdp <- c_gdp %>%
  rename('date' = DATE, 'c_gdp' = CHNLORSGPNOSTSAM) %>%
  mutate(date = as.Date(date, format = '%Y-%m-%d')) %>%
  filter(date >= '2004-05-01' & date <= '2019-05-01')

# Merge dataframes by dates for stock/oil prices, by month for gdp
df$ym_date <- make_date(year = df$year, month = df$month)
df$final_date <- as.Date(df$final_date, format = '%Y-%m-%d')

df <- df %>%
  left_join(b_gdp, by = c('ym_date' = 'date')) %>%
  left_join(c_gdp, by = c('ym_date' = 'date')) %>%
  left_join(petrobras, by = 'final_date') %>%
  left_join(wti, by = 'final_date') %>%
  left_join(brent, by = 'final_date') %>%
  left_join(sugar, by = 'final_date')

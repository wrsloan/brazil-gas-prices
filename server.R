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
library(shiny)

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

# By region
plot_byReg <- function(fuel_type, beg_yr, end_yr) {
  df %>%
    select(final_date, year, month, mean_price, product,
           region, state, measurement) %>%
    group_by(final_date, region) %>%
    filter(product == fuel_type, between(year, beg_yr, end_yr)) %>%
    mutate(price = mean(mean_price)) %>%
    ggplot(aes(as.Date(final_date), price, color = price)) +
    geom_line() +
    scale_color_viridis(option = 'inferno') +
    ggtitle(fuel_type) + xlab(NULL) + 
    ylab(paste0('Price ', '(',df$measurement[df$product == fuel_type],')')) +
    theme(legend.position = 'none') +
    facet_wrap(~region)
}

# % change by state
plot_pctInc <- function(date1, date2, fuel_type, area) {
  df %>%
    select(final_date, year, month, mean_price, product, region, state) %>%
    group_by(product, region, state) %>%
    filter(final_date == date1 | final_date == date2,
           product == fuel_type, region == area) %>%
    summarize(beg = mean_price[final_date == date1],
              end = mean_price[final_date == date2],
              pct_inc = (end - beg) / beg) %>%
    ggplot(aes(reorder(state, pct_inc), pct_inc, fill = state)) +
    geom_bar(color = 'black', stat = 'identity') +
    scale_fill_viridis(option = 'inferno', discrete = TRUE) +
    ggtitle(fuel_type) +
    scale_x_discrete(name = NULL, labels = NULL) +
    scale_y_continuous(name = '% Increase', labels = percent)
}

# Define server
function(input, output) {
  output$plotA3 <- renderPlot(plot_pctInc('2009-01-10', '2014-01-04', 'Ethanol', input$RegionA3) +
                                labs(fill = 'State', caption = paste0(' % Increase in Prices: 1/10/09 - 1/4/14')))
  output$plotB2 <- renderPlot(plot_byReg(input$FuelB2, 2014, 2016))
  
  output$plotB3 <- renderPlot(plot_pctInc('2014-01-11', '2016-12-31', input$FuelB3, input$RegionB3) +
                                labs(fill = 'State', caption = paste0(' % Increase in Prices: 1/11/14 - 12/31/16')))
  output$plotC2 <- renderPlot(plot_byReg(input$FuelC2, 2017, 2019))
  
  output$plotC3 <- renderPlot(plot_pctInc('2017-07-22', '2019-06-01', input$FuelC3, input$RegionC3) +
                                labs(fill = 'State', caption = paste0(' % Increase in Prices: 7/22/17 - 6/1/19')))
}


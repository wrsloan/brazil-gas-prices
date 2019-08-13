library(shiny)

# Define UI for plots
fluidPage(
  titlePanel('Ethanol Supply Shortage'),
  fluidRow(
    selectInput('RegionA3', 'Select Region:',
                  list('North' = 'North', 'Northeast' = 'Northeast',
                     'Central-West' = 'Central-West', 'South' = 'South',
                     'Southeast' = 'Southeast')),
    plotOutput('plotA3')),
  titlePanel('Recession: By Region'),
  fluidRow(
    selectInput('FuelB2', 'Select Fuel Type:',
                list('Common Gas' = 'Common Gas', 'Ethanol' = 'Ethanol',
                     'Diesel' = 'Diesel', 'Diesel S10' = 'Diesel S10')),
    plotOutput('plotB2')
  ),
  titlePanel('Recession: By State'),
  fluidRow(
    selectInput('FuelB3', 'Select Fuel Type:',
                list('Common Gas' = 'Common Gas', 'Ethanol' = 'Ethanol',
                     'Diesel' = 'Diesel', 'Diesel S10' = 'Diesel S10')),
    selectInput('RegionB3', 'Select Region:',
                list('North' = 'North', 'Northeast' = 'Northeast',
                     'Central-West' = 'Central-West', 'South' = 'South',
                     'Southeast' = 'Southeast')),
    plotOutput('plotB3')
  ),
  titlePanel('Fuel Tax Increase: By Region'),
  fluidRow(
    selectInput('FuelC2', 'Select Fuel Type:',
                list('Common Gas' = 'Common Gas', 'Ethanol' = 'Ethanol',
                     'Diesel' = 'Diesel', 'Diesel S10' = 'Diesel S10')),
    plotOutput('plotC2')
  ),
  titlePanel('Fuel Tax Increase: By State'),
  fluidRow(
    selectInput('FuelC3', 'Select Fuel Type:',
                list('Common Gas' = 'Common Gas', 'Ethanol' = 'Ethanol',
                     'Diesel' = 'Diesel', 'Diesel S10' = 'Diesel S10')),
    selectInput('RegionC3', 'Select Region:',
                list('North' = 'North', 'Northeast' = 'Northeast',
                     'Central-West' = 'Central-West', 'South' = 'South',
                     'Southeast' = 'Southeast')),
    plotOutput('plotC3')
  )
)
  
  

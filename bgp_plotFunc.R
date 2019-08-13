# By fuel
plot_byFuel <- function(fuel_type, beg_yr, end_yr) {
  df %>%
    select(final_date, year, month, mean_price, product, region, measurement) %>%
    group_by(final_date, product, measurement) %>%
    filter(product == fuel_type, between(year, beg_yr, end_yr)) %>%
    mutate(price = mean(mean_price)) %>%
    ggplot(aes(as.Date(final_date), price, color = price)) +
    geom_line() +
    scale_color_viridis(option = 'inferno') +
    ggtitle(fuel_type) + xlab(NULL) + 
    ylab(paste0('Price ', '(',df$measurement[df$product == fuel_type],')')) +
    theme(legend.position = 'none')
}

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
# Ethanol supply shortage table
ess <- df %>%
  select(final_date, year, month, mean_price, product, region, state) %>%
  group_by(region, state) %>%
  filter(final_date == '2009-01-10' | final_date == '2014-01-04',
         product == 'Ethanol') %>%
  mutate(beg = mean_price[final_date == '2009-01-10'],
         end = mean_price[final_date == '2014-01-04'],
         pct_inc = round(((end - beg) / beg) * 100, 2)) %>%
  select(region, state, beg, end, pct_inc) %>%
  arrange(desc(pct_inc)) %>%
  distinct() %>%
  rename('Region' = 'region', 'State' = 'state', 'Price Before' = 'beg',
         'Price After' = 'end', '% Increase' = 'pct_inc') 
datatable(ess)

# Recession table
recession <- df %>%
  select(final_date, year, month, mean_price, product, region, state) %>%
  group_by(product, region, state) %>%
  filter(final_date == '2014-01-11' | final_date == '2016-12-31') %>%
  mutate(beg = mean_price[final_date == '2014-01-11'],
         end = mean_price[final_date == '2016-12-31'],
         pct_inc = round(((end - beg) / beg) * 100, 2)) %>%
  select(product, region, state, beg, end, pct_inc) %>%
  arrange(desc(pct_inc)) %>%
  distinct() %>%
  rename('Fuel Type' = 'product', 'Region' = 'region', 'State' = 'state', 'Price Before' = 'beg',
         'Price After' = 'end', '% Increase' = 'pct_inc')
datatable(recession)

# Post fuel tax table
post_tax <- df %>%
  select(final_date, year, month, mean_price, product, region, state) %>%
  group_by(product, region, state) %>%
  filter(final_date == '2017-07-22' | final_date == '2019-06-01') %>%
  mutate(beg = mean_price[final_date == '2017-07-22'],
         end = mean_price[final_date == '2019-06-01'],
         pct_inc = round(((end - beg) / beg) * 100, 2)) %>%
  select(product, region, state, beg, end, pct_inc) %>%
  arrange(desc(pct_inc)) %>%
  distinct() %>%
  rename('Fuel Type' = 'product', 'Region' = 'region', 'State' = 'state', 'Price Before' = 'beg',
         'Price After' = 'end', '% Increase' = 'pct_inc') 
datatable(post_tax)
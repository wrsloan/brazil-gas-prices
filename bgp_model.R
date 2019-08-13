# Model to predict stock prices
model <- df %>%
  select(final_date, state, product, mean_price, month, year, b_gdp, c_gdp,
         stock_price, wti_price, brent_price, sugar_price) %>%
  group_by(state, product) %>%
  filter(year <= 2018) %>%
  dummy_cols(select_columns = c('state', 'product'), remove_first_dummy = TRUE)

# Create partition, train/test sets
partition <- createDataPartition(model$mean_price, p = 0.8,  list = FALSE)
bgpTrain <- model[partition,]
bgpTest  <- model[-partition,]

# Bootstrapped linear regression
set.seed(540)
lm1 <- train(mean_price ~. - final_date - state - product - mean_price + (year * month) +
               (stock_price * b_gdp * c_gdp * wti_price * brent_price * sugar_price),
             data = bgpTrain, method = 'lm')

# Regularization using glmnet
set.seed(540)
fitControl <- trainControl(method = 'repeatedcv', number = 10, repeats = 10)
glmnet1 <- train(mean_price ~. - final_date - state - product - mean_price + (year * month) +
                   (stock_price * b_gdp * c_gdp * wti_price * brent_price * sugar_price),
                 data = bgpTrain, method = 'glmnet', trControl = fitControl)

# Bootstrapped linear regression metrics
lm1_df <- data.frame(lm1$results)
lm1_df$intercept <- NULL
lm1_df <- round(lm1_df, 3)

# Glmnet metrics
glm1_df <- data.frame(round(glmnet1$results, 3))
datatable(glm1_df)
# Regularization parameter plot
ggplot(glmnet1)

# Calculate rmse on held out test set
lm1_pred <- predict(lm1, bgpTest)
glm1_pred <- predict(glmnet1, bgpTest)

rmse <- function(mod_pred) {
  mod_rmse <- vector('double', length = nrow(bgpTest))
  for (i in seq_along(mod_rmse)) {
    mod_rmse[[i]] <- RMSE(mod_pred[[i]], bgpTest$mean_price[[i]])
  }
  rmse_var <- var(mod_rmse)
  rmse_mean <- mean(mod_rmse)
  paste0('RMSE Mean: ', round(rmse_mean, digits = 3), ', ',
         'RMSE Variance: ', round(rmse_var, digits = 3))
}

# Bootstrapped linear regression
rmse(lm1_pred)
# Glmnet
rmse(glm1_pred)
datatable(lm1_df)

# Summary statistics for bootstrapped linear regression
summary(lm1)
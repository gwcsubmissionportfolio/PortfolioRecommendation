# Function to create multiple portfolios with random weights and analyze their performance
create_multiple_portfolios <- function(stock_returns, log_returns_XLK, top_ticker_names) {
  set.seed(4)
  weights <- c(1:100)
  set.seed(20)  
  repetitions <- 100
  
  # Repeat the process for the desired number of repetitions
  stock_returns <- stock_returns %>%
    tq_repeat_df(n = repetitions)
  
  # Generate random weights for each stock in each portfolio
  random_weights <- sample(weights, length(top_ticker_names) * repetitions, replace = TRUE)
  index_zeroes_multiple <- sample(c(1:length(random_weights)), round(length(random_weights) * 0.75, 0))
  random_weights[index_zeroes_multiple] <- 0
  
  # Create a tibble containing the Ticker names and their corresponding random weights for each portfolio
  weights_data <- tibble(top_ticker_names) %>%
    tq_repeat_df(n = repetitions) %>%
    bind_cols(tibble(random_weights)) %>%
    group_by(portfolio) %>% 
    mutate(random_weights = random_weights / sum(random_weights))
  
  # Compute portfolio returns for each portfolio using the specified assets, weights, and returns
  portfolios <- stock_returns %>%
    tq_portfolio(assets_col = symbol, 
                 returns_col = Ra, 
                 weights = weights_data, 
                 col_rename = "Ra")
  
  # Combine portfolio returns with returns from the Benchmark Index
  combined_portfolios <- left_join(portfolios, 
                                   log_returns_XLK,
                                   by = "date")
  
  # Compute financial indicators for each portfolio
  CAPM_portfolios <- combined_portfolios %>%
    tq_performance(Ra = Ra, Rb = Rb, performance_fun = table.CAPM)


  # Compute annualized returns for each portfolio
  annualized_returns <- combined_portfolios %>%
    tq_performance(Ra = Ra, Rb = NULL, performance_fun = table.AnnualizedReturns)
  
  # Convert log returns into a wealth index for each portfolio
  portfolio_growth_monthly <- stock_returns %>%
    tq_portfolio(assets_col   = symbol, 
                 returns_col  = Ra, 
                 weights      = weights_data, 
                 col_rename   = "investment.growth",
                 wealth.index = TRUE) %>%
    mutate(investment.growth = investment.growth * 10000)
  
  sum_by_portfolio <- portfolio_growth_monthly  %>%                                        
    group_by(portfolio) %>% 
    summarise_at(vars(investment.growth), 
                 list(name = sum))
  
  stock_top5_percentile <- sum_by_portfolio %>% 
    filter(name > quantile(sum_by_portfolio$name, 0.95))
  
  df_new <- portfolio_growth_monthly %>% filter(portfolio %in% stock_top5_percentile$portfolio)
  # Plot investment growth for each portfolio
  plot <- df_new %>%
    ggplot(aes(x = date, y = investment.growth, color = factor(portfolio))) +
    geom_line(size = 1) +
    labs(title = "Optimized Portfolios",
         subtitle = "Comparing Portfolio Investment Growth",
         x = "Date", y = "Portfolio Value",
         color = "Portfolio") +
    # geom_smooth(method = "loess") +
    theme_minimal() +
    scale_color_brewer(palette = "Set1") +
    theme(legend.position = "none") +
    scale_y_continuous(labels = scales::dollar)
  
  portfolio_matrix <- weights_data %>% spread(key = portfolio, value = random_weights)
  
  stock_top1_percentile <- sum_by_portfolio %>% 
    filter(name > quantile(sum_by_portfolio$name, 0.99))
  
  df_new_2 <- portfolio_growth_monthly %>% filter(portfolio %in% stock_top1_percentile$portfolio)
  
  symbol_b = c(rep('XLK', length(log_returns_XLK$Rb))) # tq_portfolio does require us to parse assets_col
  # so we need to create a vector with an identifier of choice and bind it to the tibble which contains log
  #returns.
  XLK_asset_name = cbind(log_returns_XLK, symbol_b)
  
  portfolio_growth_XLK <- XLK_asset_name %>%
    tq_portfolio(assets_col   = symbol_b, 
                 returns_col  = Rb, 
                 col_rename   = "investment.growth",
                 wealth.index = TRUE) %>%
    mutate(investment.growth = investment.growth * 10000)
  ggplot() +
    geom_line(data = df_new_2, aes(x = date, y = investment.growth), color = "blue") +
    geom_line(data = portfolio_growth_XLK, aes(x = date, y = investment.growth), color = "red") +
    labs(title = "Portfolio Growth", x = "", y = "Portfolio Value") +
    theme_tq() +
    scale_color_tq() +
    scale_y_continuous(labels = scales::dollar)
  
  return(list(annualized_returns = annualized_returns, investment_growth_plot = plot, portfolio_matrix = portfolio_matrix))
}

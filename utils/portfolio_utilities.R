# Step 1: Parsing the HTML table
# We begin by parsing an HTML table hosted on Wikipedia. We are interested in table 2, so we use the htmltab function 
# to request and download the HTML data. You can choose any Index of your choice by providing the corresponding URL.
# Make sure to specify the correct table number as the second argument of the function.

# Step 2: Selecting relevant columns
# Once the table is obtained, we select the column(s) of interest. In this case, we want the Ticker names, so we cast 
# the 'Symbol' column into a vector containing character elements.
get_symbols<- function() {
  # Define the URL
  url <- "https://en.wikipedia.org/wiki/List_of_S%26P_500_companies"
  
  # Read the HTML content and extract the ticker symbols
  tickers <- url %>%
    read_html() %>%
    html_nodes(xpath = '//*[@id="constituents"]') %>% 
    html_table()
  
  # Extract the ticker symbols from the table
  sp500tickers <- tickers[[1]]
  
  # Replace special characters in ticker symbols
  sp500tickers <- sp500tickers %>% 
    mutate(Symbol = case_when(
      Symbol == "BRK.B" ~ "BRK-B",
      Symbol == "BF.B" ~ "BF-B",
      TRUE ~ as.character(Symbol)
    ))
  
  # Extract the ticker symbols
  symbols <- sp500tickers$Symbol

  return(symbols)
}

# Function to retrieve and process log returns data for a list of symbols from Yahoo Finance API
get_log_returns <- function(symbols, start_date, end_date) {
  # Retrieve stock price data using tq_get function from tidyquant package
  period_returns <- symbols %>%
    tq_get(get = "stock.prices", from = start_date, to = end_date) %>%
    group_by(symbol) %>%
    tq_transmute(select = adjusted, mutate_fun = periodReturn, period = "daily", type = "log", col_rename = "Ra") 
  
  # Return the processed log returns data
  return(period_returns)
}

# Function to retrieve and process log returns data for XLK index within a specified date range
get_xlk_log_returns <- function(start_date, end_date) {
  # Retrieve XLK index stock price data using tq_get function from tidyquant package
  log_returns_XLK <- "XLK" %>%
    tq_get(get = "stock.prices",
           from = start_date,
           to = end_date) %>%
    tq_transmute(select = adjusted, 
                 mutate_fun = periodReturn,
                 type = "log",
                 period = "daily", 
                 col_rename = "Rb") # Returns for comparison group b
  
  return(log_returns_XLK)
}

# Function to perform preliminary financial analysis by comparing log returns of TSX companies with the XLK index
perform_financial_analysis <- function(log_returns_SP, log_returns_XLK) {
  # Perform a left join on date to compare log returns of TSX companies with the XLK index
  comparison_data <- left_join(log_returns_SP, 
                               log_returns_XLK,
                                 by = "date") %>% 
    group_by(symbol)
  
  # Perform CAPM analysis to obtain financial indicators such as Alpha, Beta, and Information Ratio
  financial_indicators_CAPM <- comparison_data %>%
    tq_performance(Ra = Ra, Rb = Rb, performance_fun = table.CAPM) 

  return(financial_indicators_CAPM)
}

# Function to select stocks based on top quintile of returns or least volatility
get_top_percentile_ticker_names <- function(financial_indicators_CAPM, log_returns_SP) {
  # Depending on risk aversion, select top quintile of returns per Ticker or least volatile stocks
  
  stock_top_percentile <- financial_indicators_CAPM %>% 
    filter(AnnualizedAlpha > quantile(financial_indicators_CAPM$AnnualizedAlpha, 0.80))
  
  # Filter the initial log returns data to keep only the Ticker names present in both sets
  ticker_names <- stock_top_percentile$symbol
   return (ticker_names)
}

# Function to Get Details for selected stocks based on top quintile of returns or least volatility
select_stocks <- function(ticker_names) {
  stock_returns <- log_returns_SP %>%  
    filter(symbol %in% ticker_names) 

  return(stock_returns)
}

generate_random_weights <- function(ticker_names, repetitions, weights) {
  num_samples <- length(ticker_names) * repetitions
  random_weights <- sample(weights, num_samples, replace = TRUE)
  num_zeroes <- round(num_samples * 0.75)
  zero_indices <- sample(seq_along(random_weights), num_zeroes)
  random_weights[zero_indices] <- 0
  return(random_weights)
}


source('utils/include_libraries.R')
source('utils/portfolio_utilities.R')
source('utils/portfolio_creation.R')

start_date = "2023-06-01"
end_date   = "2024-02-29"

symbols <- get_symbols()

log_returns_SP <- get_log_returns(symbols, start_date, end_date)

log_returns_XLK <- get_xlk_log_returns(start_date, end_date)

financial_indicators_CAPM <- perform_financial_analysis(log_returns_SP, log_returns_XLK)

top_ticker_names <- get_top_percentile_ticker_names(financial_indicators_CAPM, log_returns_SP)

stock_returns <- select_stocks(top_ticker_names)

create_multiple_portfolios(stock_returns, log_returns_XLK, top_ticker_names)



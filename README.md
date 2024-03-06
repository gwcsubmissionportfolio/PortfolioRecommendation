# Portfolio Optimization Project

## Objective:
**Analysis and Portfolio generation using R**
- Portfolio optimization involves selecting the best asset distribution from a set of all possible portfolios to achieve certain criteria, such as maximizing expected return while minimizing financial risk.
- This process typically involves adjusting the weights of asset classes and assets within each class according to individual preferences, which are determined by a unique utility function.
- In this project, we aim to create and analyze portfolios using stocks from the S & P Index, extracting log returns data from Yahoo Finance API and comparing them to the TSX benchmark index.
- The goal is to identify the optimal portfolio through CAPM analysis and portfolio optimization techniques.

**LSTM**
- The time series data is sourced from the portfolio optimization application.
- To ensure consistency and comparability across different features, the data undergoes transformations such as feature scaling or normalization.
- These processes aim to standardize the data and prepare it for further analysis.
- Additionally, overlapping windows are created to facilitate training, enabling the model to capture temporal dependencies effectively.
- LSTM model is built and trained using the preprocessed data. Once trained, the LSTM model is used to generate sequences, and its performance is evaluated based on predefined metrics and criteria.
  
## Data Description:
- We will extract a list of actively traded companies from Wikipedia and obtain log returns data for these stocks using Yahoo Finance API.

## Aim:
- To perform CAPM analysis on stocks and identify the best-suited portfolio using portfolio optimization methods.

## Tech Stack:
- Language: Python, R
- Libraries: Keras, LSTM, pandas, numpy, sklearn, matplotlib, tidyverse, tidyquant, htmltab, dplyr, rlang

## Approach:
1. [Extract the list of stocks in S&P index from Wikipedia.](images/S&P_Tickers.png)
2. [Obtain log returns data for S&P index.](images/Log_Returns_S&P.png)
3. [Obtain log returns data for XLK index.](images/Log_Returns_XLK.png)
4. [Conduct CAPM analysis on the data.](images/CAPM_Analysis.png)
5. [Identify the top percentile of stocks based on performance.](images/Top_Percentile_Stocks.png)
6. [Create portfolios matrix using the top-performing stocks.](images/Portfolio_Matrix.png)
7. [Perform CAPM analysis on the multiple portfolios.](images/CAPM_100_Portfolios.png)
8. [Select the suitable portfolio based on CAPM analysis and portfolio matrix evaluation.](images/CAPM_Indicator_Analysis.png)
9. [Top Percentile performance against benchmark.](images/Top1_VS_XLK.png)
10. [Top 5 portfolio performance.](images/Top5_Percentile.png)
11. [LSTM model training and portfolio prediction.](images/LSTM_Analysis_Top_Portfolio.png)

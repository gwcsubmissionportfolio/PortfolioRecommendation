# Portfolio Optimization Project

## Objective:
- Portfolio optimization involves selecting the best asset distribution from a set of all possible portfolios to achieve certain criteria, such as maximizing expected return while minimizing financial risk.
- This process typically involves adjusting the weights of asset classes and assets within each class according to individual preferences, which are determined by a unique utility function.
- In this project, we aim to create and analyze portfolios using stocks from the S & P Index, extracting log returns data from Yahoo Finance API and comparing them to the TSX benchmark index.
- The goal is to identify the optimal portfolio through CAPM analysis and portfolio optimization techniques.

## Data Description:
- We will extract a list of actively traded companies from Wikipedia and obtain log returns data for these stocks using Yahoo Finance API.

## Aim:
- To perform CAPM analysis on stocks and identify the best-suited portfolio using portfolio optimization methods.

## Tech Stack:
- Language: R
- Libraries: tidyverse, tidyquant, htmltab, dplyr, rlang

## Approach:
1. [Extract the list of stocks in S&P index from Wikipedia.](images/S&P_Tickers.png)
2. [Obtain log returns data for S&P index.](Log_Returns_S&P.png)
3. [Obtain log returns data for XLK index.](Log_Returns_XLK.png)
4. [Conduct CAPM analysis on the data.](CAPM_Analysis.png)
5. [Identify the top percentile of stocks based on performance.](Top_Percentile_Stocks.png)
6. [Create portfolios matrix using the top-performing stocks.](Portfolio_Matrix.png)
7. [Perform CAPM analysis on the multiple portfolios.](CAPM_100_Portfolios.png)
8. [Select the suitable portfolio based on CAPM analysis and portfolio matrix evaluation.](CAPM_Indicator_Analysis.png)
9. [Top Percentile performance against benchmark.](Top1_VS_XLK.png)
10. [Top 5 portfolio performance.](Top5_Percentile.png)

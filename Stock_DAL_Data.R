rm(list = ls())

setwd("~/RProjects/COVID-19-Stock-Analysis")

library(tidyverse)
library(readxl)
library(writexl)

# stock data from 2014
Stock_2014_DAL <- read_excel("Stock_2014_DAL.xlsx")

# adding 2014 year label
names(Stock_2014_DAL)[2] <- "Open_14"
names(Stock_2014_DAL)[3] <- "High_14"
names(Stock_2014_DAL)[4] <- "Low_14"
names(Stock_2014_DAL)[5] <- "Close_14"
names(Stock_2014_DAL)[6] <- "Adj_Close_14"
names(Stock_2014_DAL)[7] <- "Volume_14"

# stock data from 2020
Stock_2020_DAL <- read_excel("Stock_2020_DAL.xlsx")

# adding 2020 year label
names(Stock_2020_DAL)[2] <- "Open_20"
names(Stock_2020_DAL)[3] <- "High_20"
names(Stock_2020_DAL)[4] <- "Low_20"
names(Stock_2020_DAL)[5] <- "Close_20"
names(Stock_2020_DAL)[6] <- "Adj_Close_20"
names(Stock_2020_DAL)[7] <- "Volume_20"

# scaling data
Stock_2020_DAL$Open_20 <- with(Stock_2020_DAL, Open_20 * (3/5))
Stock_2020_DAL$High_20 <- with(Stock_2020_DAL, High_20 * (3/5))
Stock_2020_DAL$Low_20 <- with(Stock_2020_DAL, Low_20 * (3/5))
Stock_2020_DAL$Close_20 <- with(Stock_2020_DAL, Close_20 * (3/5))
Stock_2020_DAL$Adj_Close_20 <- with(Stock_2020_DAL, Adj_Close_20 * (3/5))

# adding id for merging
Stock_2014_DAL <- Stock_2014_DAL %>% 
  mutate(id = row_number())
Stock_2020_DAL <- Stock_2020_DAL %>% 
  mutate(id = row_number())

# merging based on id
DAL_Stock <- merge(Stock_2014_DAL, Stock_2020_DAL, by = "id")

write_xlsx(DAL_Stock, "DAL_Stock.xlsx")
write.csv(DAL_Stock, "DAL_Stock.csv")

plot(DAL_Stock$Open_14,
     main="Stock Prices for Ebola and COVID-19",
     sub = "Beginning on the First Officially Declared Case",
     ylab="Initial Stock Price",
     type="l",
     col="blue", 
     ylim=c(10, 42))
lines(DAL_Stock$Open_20, col="red")

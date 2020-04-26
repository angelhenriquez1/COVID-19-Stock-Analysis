rm(list = ls())

setwd("~/RProjects/COVID-19-Stock-Analysis")

library(tidyverse)
library(readxl)
library(writexl)

# DAL stock data from 2014
Stock_2014_DAL <- read_excel("Stock_2014_DAL.xlsx")
# COVID-19 and Southwest Data
COVID19_SOUTHWEST <- read_excel("COVID19-SOUTHWEST.xlsx")
# Ebola virus dataset
Ebola_Southwest_Data <- read_excel("Ebola-Southwest-Data.xlsx")

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

# DAL Stock of 2014 and 2020
plot(DAL_Stock$Open_14,
     main="Stock Prices for Ebola and COVID-19",
     sub = "Beginning on the First Officially Declared Case",
     ylab="Initial Stock Price",
     type="l",
     col="blue", 
     ylim=c(10, 42))
lines(DAL_Stock$Open_20, col="red")
legend("bottomleft",
       c("2020","2014"),
       fill=c("red","blue")
)

# Difference between years
DAL_Stock$Change_in_Stocks <- DAL_Stock$Open_20 - DAL_Stock$Open_14

# plot of difference in DAL stocks between 2014 and 2020
plot(DAL_Stock$Change_in_Stocks, 
     main = "Difference in DAL Stocks Between 2014 and 2020", 
     ylab = "Stock Difference",
     xlab = "Days Since Beginning of Pandemics")
lines(DAL_Stock$Change_in_Stocks, 
      col="red")

# Excel file of DAL Stocks
write_xlsx(DAL_Stock, "DAL_Stock.xlsx")

# CSV file of DAL Stocks
write.csv(DAL_Stock, "DAL_Stock.csv")

# Southwest
COVID19_SOUTHWEST <- COVID19_SOUTHWEST %>%
  mutate(id = row_number())
Ebola_Southwest_Data <- Ebola_Southwest_Data %>%
  mutate(id = row_number())
Stock_2014_DAL <- Stock_2014_DAL %>%
  mutate(id = row_number())
Stock_2020_DAL <- Stock_2020_DAL %>%
  mutate(id = row_number())

# entire dataset
calhacksdata <- merge(COVID19_SOUTHWEST, Ebola_Southwest_Data, by = c("id")) 
calhacksdata <- merge(calhacksdata, DAL_Stock, by = c("id"))

# Graph of Southwest data for COVID-19
plot(COVID19_SOUTHWEST$Date, COVID19_SOUTHWEST$Close, xlab = "Date",ylab = " Closing Stock Price", Main = "Southwest Stock Price Over Span of Covid-19")
lines.default(COVID19_SOUTHWEST$Date, COVID19_SOUTHWEST$Close)
lm(COVID19_SOUTHWEST$Date~ COVID19_SOUTHWEST$Close)
abline(lm(COVID19_SOUTHWEST$Date~ COVID19_SOUTHWEST$Close))

# Graph of Southwest data for Ebola
plot(Ebola_Southwest_Data$Date, Ebola_Southwest_Data$Close, xlab = "Date",ylab = "Closing Stock Price", Main = "Southwest Stock Price Over Span of Ebola")
lines.default(Ebola_Southwest_Data$Date, Ebola_Southwest_Data$Close)
lm(Ebola_Southwest_Data$Date~ Ebola_Southwest_Data$Close)
abline(lm(Ebola_Southwest_Data$Date~ Ebola_Southwest_Data$Close))

# Excel file of entire dataset
write_xlsx(calhacksdata, "calhacksdata.xlsx")

# CSV file of entire dataset
write.csv(calhacksdata, "calhacksdata.csv")

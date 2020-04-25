rm(list = ls())

setwd("~/RProjects/COVID-19-Stock-Analysis")

# install.packages("writexl")

library(tidyverse)
library(readxl)
library(writexl)

# stock data from 2014
Stock_2014_DAL <- read_excel("Stock_2014_DAL.xlsx")
# stock data from 2020
Stock_2020_DAL <- read_excel("Stock_2020_DAL.xlsx")

# adding id for merging
Stock_2014_DAL <- Stock_2014_DAL %>% mutate(id = row_number())
Stock_2020_DAL <- Stock_2020_DAL %>% mutate(id = row_number())

# merging based on id
Stock_DAL <- merge(Stock_2014_DAL, Stock_2020_DAL, by = "id")

write.csv(Stock_DAL, "Stock_DAL.csv")








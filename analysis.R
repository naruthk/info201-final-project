library("httr")
library("jsonlite")
library("knitr")
library("shiny")

national <- read.csv("data/arrests_national.csv")

state <- read.csv("data/estimated_crimes.csv")
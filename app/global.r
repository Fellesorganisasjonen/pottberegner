library(shiny)
library(lubridate)
library(scales)
options(scipen = 999)

  # Funksjon for å beregne måneder igjen i året
  calculate_months_left <- function(date) {
    current_year <- format(date, "%Y")
    end_of_year <- as.Date(paste0(current_year, "-12-31"))
    
    if (date >= end_of_year) {
      months_left <- 0
    } else {
      months_left <- 12 - as.numeric(format(date, "%m")) + 1
    }
    
    return(months_left)
  }
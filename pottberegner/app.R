#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(readr)
library(ggplot2)
library(dplyr)
library(lubridate)
library(scales)
options(scipen = 999)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Pottberegner for Kapittel 3.4. og 5"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          numericInput("Årslønn", label = h4("Gjennomsnittlig årslønn"), value = 787668),
          sliderInput("Ramme",label=h4("Ramme"), min = 0, max = 10, post  = " %", value = 5.4, step = 0.1),
          dateInput("date", label = h4("Virkningstidspunkt*"), value = "2023-05-01", language = "no", format = "dd/mm/yyyy" ),
          p("* Virkningstidspunkt beregner hele fulle måender, og tar derfor utgangspunkt i den 1. for valgte måned"),
          sliderInput("Glidning",label=h4("Glidning"), min = 0, max = 10, post  = " %", value = 0.2, step = 0.1),
          sliderInput("Overheng",label=h4("Overheng"), min = 0, max = 10, post  = " %", value = 1, step = 0.1)
        ),

        # Show a plot of the generated distribution
        mainPanel(
          tableOutput("values"),
          tableOutput("results")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
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
  
  months <- reactive({ calculate_months_left(as.Date(input$date)) })
  rest <- reactive({(input$Ramme - input$Overheng - input$Glidning) / 100})
  gjennstaende <- reactive({rest()/months()*12})
  
  inputValues <- reactive({
    data.frame(
      Betegnesle = c(
        "Ramme årslønnsvekst",
        "Beregnet overheng",
        "Anslag lønnslidning",
        "Gjennstående forventet lønnsvekst"
      ),
      Verdier = as.character(c(
        scales::percent(input$Ramme / 100, accuracy = 0.1),
        scales::percent(input$Overheng / 100, accuracy = 0.1, prefix = "- "),
        scales::percent(input$Glidning / 100, accuracy = 0.1, prefix = "- "),
        scales::percent(rest(), accuracy = 0.1)
      ))
    )
  })
  
  inputResults <- reactive({
    data.frame(
      Betegnelse = c(
        "Virkningstidspunkt",
        paste("Gjennstående % omregnet (", scales::percent(rest(), accuracy = 0.1)," / ",months()," x 12)"),
        "Gjennomsnittlig pott per årsverk"
      ),
      Verdier = as.character(c(
        as.numeric(input$date),
        scales::percent(gjennstaende(), accuracy = 0.1),
        round(input$Årslønn * gjennstaende())
      )))
    
  })
  
  output$values <- renderTable({ inputValues() })
  
  output$results <- renderTable({ inputResults() })

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

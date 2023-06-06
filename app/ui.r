library(shinydashboard)

dashboardPage(
  skin = "red",
  dashboardHeader(title = "Tilleggskalkulator - Kapittel 3.4 og 5", titleWidth = 350),
  dashboardSidebar(
    width = 350,
    
    # Input for average annual salary
    numericInput("Årslønn", label = h4("Gjennomsnittlig årslønn"), value = 787668),
    
    # Slider input for Ramme
    sliderInput("Ramme", label = h4("Ramme"), min = 0, max = 10, post  = " %", value = 5.4, step = 0.1),
    
    # Date input for Virkningstidspunkt
    dateInput("date", label = h4("Virkningstidspunkt*"), value = "2023-05-01", language = "no", format = "dd/mm/yyyy"),
    
    # Information about Virkningstidspunkt
    p("* Virkningstidspunkt beregner hele fulle måender, og tar derfor utgangspunkt i den 1. for valgte måned"),
    
    # Slider input for Glidning
    sliderInput("Glidning", label = h4("Glidning"), min = 0, max = 10, post  = " %", value = 0.2, step = 0.1),
    
    # Slider input for Overheng
    sliderInput("Overheng", label = h4("Overheng"), min = 0, max = 10, post  = " %", value = 1, step = 0.1)
  ),
  dashboardBody(
    fluidRow(
      # Value box for Gjennomsnittlig tillegg
      valueBoxOutput("pottbox", width = 3),
      
      # Value box for Gjennstående % omregnet
      valueBoxOutput("restprosbox", width = 3),
      
      # Value box for Virkningstidspunkt
      valueBoxOutput("virkningsbox", width = 3),
      
      # Value box for Antall virkningsmåneder
      valueBoxOutput("restmndbox", width = 3)
    ),
    fluidRow(
      # Box for Rammen table
      box(title = "Rammen", status = "primary", tableOutput("values")),
      
      # Box for Rammefordeling plot
      box(title = "Rammefordeling", status = "primary", plotOutput("plot"))
    )
  )
)

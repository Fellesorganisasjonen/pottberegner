server <- function(input, output) {
  
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
        "Antall måneder med virkning",
        paste("Gjennstående % omregnet (", scales::percent(rest(), accuracy = 0.1)," / ",months()," x 12)"),
        "Gjennomsnittlig pott per årsverk"
      ),
      Verdier = as.character(c(
        as.numeric(months()),
        scales::percent(gjennstaende(), accuracy = 0.1),
        round(input$Årslønn * gjennstaende())
      )))
    
  })
  
  output$values <- renderTable({ inputValues() })
  
  output$results <- renderTable({ inputResults() })

}
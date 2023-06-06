server <- function(input, output) {
  
  # Calculate the number of months left based on the input date
  months <- reactive({ calculate_months_left(as.Date(input$date)) })
  
  # Calculate the remaining percentage
  rest <- reactive({(input$Ramme - input$Overheng - input$Glidning) / 100})
  
  # Calculate the remaining amount based on the expected salary increase
  gjennstaende <- reactive({rest()/months()*12})
  
  # Convert the input date to a date object and floor it to the month
  virk <- reactive({as.Date(floor_date(ymd(input$date), "month"))})
  
  # Placeholder variable
  x <- ""
  
  # Create a reactive data frame for input values
  inputValues <- reactive({
    data.frame(
      Betegnelse = c(
        "Ramme årslønnsvekst",
        "Beregnet overheng",
        "Anslag lønnslidning",
        "Gjennstående til forventet lønnsvekst"
      ),
      cat = c(
        "Frontfaget",
        "Overheng",
        "Lønnsglidning",
        "Gjennstående ramme"
      ),
      Verdier = as.character(c(
        scales::percent(input$Ramme / 100, accuracy = 0.1),
        scales::percent(input$Overheng / 100, accuracy = 0.1, prefix = "- "),
        scales::percent(input$Glidning / 100, accuracy = 0.1, prefix = "- "),
        scales::percent(rest(), accuracy = 0.1)
      )),
      Values = c(
        input$Ramme / 100,
        input$Overheng / 100,
        input$Glidning / 100,
        rest()
      ),
      Dummy = c(
        x,
        x,
        x,
        x
      )
    )
  })
  
  # Create a reactive data frame for input results
  inputResults <- reactive({
    data.frame(
      Betegnelse = c(
        "Antall måneder med virkning",
        paste("Gjennstående % omregnet (", scales::percent(rest(), accuracy = 0.1)," / ",months()," x 12)"),
        "Gjennomsnittlig tillegg per årsverk"
      ),
      Verdier = as.character(c(
        as.numeric(months()),
        scales::percent(gjennstaende(), accuracy = 0.1),
        round(input$Årslønn * gjennstaende())
      ))
    )
  })
  
  # Render the input values table
  output$values <- renderTable({ inputValues() %>% 
    select(c("Betegnelse", "Verdier")) })
  
  # Render the input results table
  output$results <- renderTable({ inputResults() })
  
  # Render the plot
  output$plot <- renderPlot({
    inputValues() %>%
      filter(Betegnelse != "Ramme årslønnsvekst") %>%
      ggplot(aes(x = Dummy, y = Values, fill = cat)) +
      geom_bar(stat = "identity") +
      scale_y_continuous(labels = scales::percent, limits = c(0, 0.1)) +
      theme_classic() +
      theme(legend.position = "bottom",
            axis.title = element_blank(),
            legend.title = element_blank()) 
  })
  
  # Render the pottbox value box
  output$pottbox <- renderValueBox({
    valueBox(
      paste(format(round(input$Årslønn * gjennstaende()), big.mark = " "), " NOK"),
      "Gjennomsnittlig tillegg",
      icon = icon("usd"),
      color = "purple"
    )
  })
  
  # Render the restprosbox value box
  output$restprosbox <- renderValueBox({
    valueBox(
      scales::percent(gjennstaende(), accuracy = 0.1),
      paste("Gjennstående % omregnet (", scales::percent(rest(), accuracy = 0.1)," / ",months()," x 12)"),
      icon = icon("percent"),
      color = "green"
    )
  })
  
  # Render the virkningsbox value box
  output$virkningsbox <- renderValueBox({
    valueBox(
      virk(),
      "Virkningstidspunkt",
      icon = icon("calendar"),
      color = "yellow"
    )
  })
  
  # Render the restmndbox value box
  output$restmndbox <- renderValueBox({
    valueBox(
      as.numeric(months()),
      "Antall virkningsmåneder",
      icon = icon("thumbs-up", lib = "glyphicon"),
      color = "aqua" 
    )
  })
  
}

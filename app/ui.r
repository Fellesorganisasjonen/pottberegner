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
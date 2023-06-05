library(shinydashboard)


dashboardPage(
  skin ="red",
    dashboardHeader(title = "Pottberegner - Kapittel 3.4 og 5",
    titleWidth = 350),
    dashboardSidebar(
      width = 350,
      numericInput("Årslønn", label = h4("Gjennomsnittlig årslønn"), value = 787668), # nolint 
      sliderInput("Ramme",label=h4("Ramme"), min = 0, max = 10, post  = " %", value = 5.4, step = 0.1), # nolint
      dateInput("date", label = h4("Virkningstidspunkt*"), value = "2023-05-01", language = "no", format = "dd/mm/yyyy" ), # nolint
      p("* Virkningstidspunkt beregner hele fulle måender, og tar derfor utgangspunkt i den 1. for valgte måned"), # nolint
      sliderInput("Glidning",label=h4("Glidning"), min = 0, max = 10, post  = " %", value = 0.2, step = 0.1), # nolint
      sliderInput("Overheng",label=h4("Overheng"), min = 0, max = 10, post  = " %", value = 1, step = 0.1)# nolint
    ),
    dashboardBody(
      fluidRow(
        box(tableOutput("values")),
        box(tableOutput("results"))
      )
    )
)
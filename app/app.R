
library(shiny)
library(dplyr)
library(ggplot2)

load('data/data.Rdata')

kjonnlist <- unique(df$kjonn)
fullforingslist <- unique(df$fullforingsgrad)
studretnlist <- unique(df$studieretning_utdanningsprogram)


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Gjennomføring i videregående skole"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            checkboxInput("pct", "Show percent"),
            selectInput("kjonnselect", "Kjønn", kjonnlist),
            selectInput("fullfselect", "Fullføringsgrad", fullforingslist),
            selectInput("studretnselect", "Studieretning", studretnlist)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {


    output$distPlot <- renderPlot({
        if (input$pct==TRUE) {
            value <- quo(andel_elever_prosent)
            y_axis_text <- "Andel elver (Prosent)"
        } else {
            value <- quo(elever)
            y_axis_text <- "Antall elever"
        }
        
        df %>% 
            filter(kjonn == input$kjonnselect & 
                       fullforingsgrad==input$fullfselect & 
                       studieretning_utdanningsprogram==input$studretnselect) %>% 
            ggplot(aes(intervall_ar, !!value, group=foreldrenes_utdanningsniva, color=foreldrenes_utdanningsniva)) +
            geom_line() +
            xlab("Kull") +
            ylab(y_axis_text) +
            theme(axis.text.x = element_text(angle = 45, hjust = 1))
    })
}


# Run the application 
shinyApp(ui = ui, server = server)

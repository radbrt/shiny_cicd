
library(shiny)
library(dplyr)
library(ggplot2)
#library(readr)

#save(df, file="./app/data/df.Rdata", version = 2)
load('data/df.Rdata')

kjonnlist <- unique(df$kjonn)
fullforingslist <- unique(df$fullforingsgrad)
studretnlist <- unique(df$studieretning_utdanningsprogram)


# UI
ui <- fluidPage(
    #includeCSS("www/style.css"),
    # Application title
    titlePanel("Gjennomføring i videregående skole"),

    tabsetPanel(
        tabPanel("Plot", plotOutput("distPlot"), checkboxInput("pct", "Vis prosent")), 
        tabPanel("Data", tableOutput("table"))
    ),
    hr(),
    fluidRow(
        column(3, selectInput("kjonnselect", "Kjønn", kjonnlist, width = "100%")),
        column(3, selectInput("fullfselect", "Fullføringsgrad", fullforingslist, width = "100%")),
        column(6, selectInput("studretnselect", "Studieretning", studretnlist, width = "100%"))
    )
)

# SERVER
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
            geom_line(size=1) +
            xlab("Kull") +
            ylab(y_axis_text) +
            theme(
                axis.title = element_text(colour = "#202234", family = "Helvetica", size = 14),
                axis.text = element_text(color = "#202234", size = 12),
                axis.text.x=element_text(angle=45, vjust=0.5),
                plot.background = element_rect(fill="#fafbfc", color = "#fafbfc"),
                panel.background = element_rect(fill = "#fafbfc"),
                panel.grid.major = element_line(size = 0.1, linetype = "solid", color = "darkgray"),
                panel.grid.minor = element_blank(),
                legend.key = element_rect(fill = "#fafbfc", colour = "#fafbfc"),
                legend.background = element_rect(fill = "#fafbfc"),
                legend.text = element_text(colour = "#202234", size = 12),
                legend.title = element_text(color="#202234", size=14)
            ) +
            scale_color_discrete(name = "Foreldrenes utdanning")
    })
    
    output$table <- renderTable(
        df %>% 
            filter(kjonn == input$kjonnselect & 
                       fullforingsgrad==input$fullfselect & 
                       studieretning_utdanningsprogram==input$studretnselect) 
    )
}


# Run the application 
shinyApp(ui = ui, server = server)

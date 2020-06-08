#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ampir)
library(DT)
library(data.table)

fileName <- 'little_test.fasta'

ui <- fluidPage(
  HTML("<h1>Antimicrobial peptide prediction with <a target='_blank' href='https://github.com/Legana/ampir'>ampir</a></h1>"),
  textAreaInput(
    "caption",
    "Enter FASTA",
    readChar(fileName, file.info(fileName)$size),
    height = "250px"
  ) %>%
    shiny::tagAppendAttributes(style = 'width: 100%;'),
  DT::dataTableOutput("value"),
  HTML("Source on <a target='_blank' href='https://github.com/Wytamma/ampir-shiny'>Github</a>"),
)

server <- function(input, output) {
  output$value <- DT::renderDataTable({
    fil <- tempfile(fileext = ".data")
    writeLines(input$caption, fil)
    my_protein_df <- read_faa(fil)
    print(my_protein_df)
    my_prediction <-
      predict_amps(my_protein_df, model = "precursor")
    setcolorder(my_prediction, c("seq_name", "prob_AMP", "seq_aa"))
    DT::datatable(my_prediction,
                  options = list(scrollX = TRUE,
                                 scrollCollapse = TRUE))
  })
}

# Run the application
shinyApp(ui = ui, server = server)

#
# CoVTRxdb
#

library(shiny)
library(dplyr)
library(reactable)
library(readr)

tbl <- read_csv("master_COVID_trials_info.csv")
# colnames(tbl) <- gsub("  ", " ", trimws(gsub("\\.", " ", colnames(tbl))))
# tbl <- tbl %>% select(TrialID, `Scientific title Original`, `Intervention Original`, `Country Curated Extracted`, `size Curated Extracted`, `drugs Curated Extracted`, `isRandomized Curated Extracted`, `isCombination Curated Extracted`)
# colnames(tbl) <- trimws(gsub("Original|Curated Extracted", "", colnames(tbl)))
# tbl <- tbl %>% mutate(drugs = ifelse(drugs == "", NA, drugs), isDrugTrial = !is.na(drugs))

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("CoVTRxdb"),

    fluidRow(
        column(8,
               # offset = 2,
               h3("Abstract"),
               p("COVID-19 clinical trials initiation may not be driven by scientific need: 
                 geographical and social biases appear to be confounders. 
                 To better understand these biases, 
                 we performed a global informatics-driven survey of clinical trial registrations 
                 and built CoVTRxdb, a unified catalog of drugs being tested. 
                 There have been 2,579 COVID-19 drug trials conducted as of September 4th 2020, 
                 with 2.01 million people enrolled. 
                 In each country, although trial registration is correlated with outbreak severity, 
                 the USA, China, and Iran are conducting the most trials. 
                 15.8% of trials test hydroxychloroquine, the most frequently tested drug. 
                 Of 407 hydroxychloroquine trials, 
                 81.6% are randomised and 70% are combined with other drugs. 
                 Remarkably, Twitter activity appears to be closely associated with 
                 hydroxychloroquine trial initiation. 
                 Of the 929,994 tweets about the most frequently trialed COVID-19 drugs, 
                 56.6% mentioned hydroxychloroquine. 
                 Hydroxychloroquine trial prevalence may be a result of social media attention, 
                 especially by world leaders."))
    ),
    fluidRow(
        column(8, 
               h3("Table of curated COVID-19 trials")
               )
    ),
    fluidRow(
        column(12,
           reactableOutput("table2", width = "100%")
        )
    ),
    fluidRow(
        column(12,
               h3("Data Sources"),
               p("Raw COVID-19 clinical trial data is publicly available from the WHO ICTRP (",
               a("https://www.who.int/clinical-trials-registry-platform"), ")")
        )
    )

)

# Define server logic required to draw a histogram
server <- function(input, output) {
    output$table2 <- renderReactable({
        reactable(tbl, filterable = T, 
                  defaultColDef = colDef(
                      header = function(value) gsub(".", " ", value, fixed = TRUE),
                      cell = function(value) format(value, nsmall = 1),
                      align = "center",
                      minWidth = 70,
                      headerStyle = list(background = "#f7f7f8")
                  ),
                  columns = list(
                      Intervention = colDef(minWidth = 140),
                      `Scientific title` = colDef(minWidth = 140),
                      drugs = colDef(minWidth = 100) # overrides the default# overrides the default
                  ),
                  bordered = TRUE,
                  highlight = TRUE,
                  showPageSizeOptions = TRUE
                  )
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

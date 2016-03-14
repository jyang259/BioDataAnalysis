library(shiny)

#Define UI for application that produces a .csv file output
shinyUI(fluidPage(
  
  #Application title
  titlePanel("Cancer Case Study Analysis"),
  
  sidebarLayout(
    sidebarPanel(
      h2("Enter Search Query"),
      
      #Text input for type of cancer to query
      textInput("text", label = h4("Type of Cancer"), 
                value = "Kidney"),
      
      #File input for list of genes to query
      fileInput("geneList", label = h4("Gene List"), accept = c('.txt')),
      
      #Submit button
      submitButton("Submit")
    ),
    
    mainPanel(
      p("This app extracts and analyzes cancer genomics data sets from cbioportal.org."),
      p("Enter the type of cancer and provide a list of genes (.txt file) you would like to collect information for."),
      p("The output .csv file will include copy number alterations (amplification and deletion) for the given genes, from data collected in case studies related to the requested cancer type."),
      
      tableOutput("tableResult")
    )
  )
  
))
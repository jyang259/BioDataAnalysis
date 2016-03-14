library(shiny)

#Define UI for application that produces a .csv file output
shinyUI(fluidPage(
  
  #Application title
  titlePanel("Cancer Case Study Analysis"),
  
  sidebarLayout(
    sidebarPanel("Enter Query"),
    mainPanel("Output File")
  )
  
))
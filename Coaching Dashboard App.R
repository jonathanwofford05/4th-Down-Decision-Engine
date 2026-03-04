model <- readRDS("C:/Users/jonat/OneDrive/Documents/outputs/conversion_model.rds")

ui <- fluidPage(
  titlePanel("NFL 4th Down Decision Engine"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("yd", "Yards to Go:", 1, 10, 3),
      sliderInput("yl", "Yardline:", 1, 99, 45),
      sliderInput("sd", "Score Differential:", -28, 28, 0),
      sliderInput("qt", "Quarter:", 1, 4, 4),
      sliderInput("tl", "Time Remaining (sec):", 1, 3600, 600)
    ),
    mainPanel(
      h2(textOutput("decision")),
      h4(textOutput("prob"))
    )
  )
)

server <- function(input, output){
  
  output$decision <- renderText({
    input_mat <- matrix(c(input$yd, input$yl, input$sd,
                          input$qt, input$tl, 0, 1), nrow=1)
    p <- predict(model, xgb.DMatrix(input_mat))
    
    ep_go <- p * 6 - (1 - p) * 2
    ep_fg <- 2.8
    ep_punt <- 0.4
    
    if(ep_go > ep_fg & ep_go > ep_punt) "RECOMMENDATION: GO FOR IT"
    else if(ep_fg > ep_punt) "RECOMMENDATION: KICK FIELD GOAL"
    else "RECOMMENDATION: PUNT"
  })
  
  output$prob <- renderText({
    input_mat <- matrix(c(input$yd, input$yl, input$sd,
                          input$qt, input$tl, 0, 1), nrow=1)
    p <- predict(model, xgb.DMatrix(input_mat))
    paste("Conversion Probability:", round(p*100, 2), "%")
  })
  
}

shinyApp(ui, server)
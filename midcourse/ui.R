
library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(theme = shinytheme("flatly"),
                  navbarPage("CollegeScore",
                             tabPanel("TabName",
                                 sidebarPanel(
                                     checkboxGroupInput("checkGroupr", 
                                                        label = h3("Select Region"), 
                                                        choices = list("US Service Schools" =0, 
                                                                       "New England" =1,
                                                                       "Mid East" =2,
                                                                       "Great Lakes" =3,
                                                                       "Plains" =4,
                                                                       "Southeast" =5,
                                                                       "Southwest" =6,
                                                                       "Rocky Mountains" =7,
                                                                       "Far West" =8,
                                                                       "Outlying Areas" =9),
                                                                        selected = 5),
                                     checkboxGroupInput("checkGroupo", 
                                                        label = h3("Select Ownership"), 
                                                        choices = list("Public"=1, 
                                                                       "Private Nonprofit"=2,
                                                                       "Private for-profit"=3),
                                                                        selected = 2),
                                     width = 2),#sidebarpanel
                                 
                                 #mainPanel
                                 mainPanel(fluidRow(column(8, leafletOutput("myMap") %>% 
                                                             withSpinner(color="#0dc5c1"),
                                                           DT::dataTableOutput("mytable")),
                                                    column(4, plotOutput("distPlot"), 
                                                           plotOutput("distPlot2"),
                                                           plotOutput("od_ton_chart")))
                                                    
                                                           
                                                   
                                                    
                                                    
                                  
                                              ) #mainpanel
                                   
                                           
                                           
                                            
                             ), #)tabpanel1
                             
                             #tabPanel2(#
                             tabPanel("Tab2")
                             )
                  
                  ))




#splitLayout(cellWidths = c("50%", "50%")

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(theme = shinytheme("flatly"),
                  navbarPage("CollegeScore",
                             tabPanel("Overview by State",
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
                                                                        selected = 1),
                                     selectInput("shadeby", "Shade By",
                                                  c("Colleges per capita" = "co_capita",
                                                    "Students per capita" = "stu_capita"),
                                                  selected = "co_capita",
                                                 multiple = FALSE),
                                     checkboxGroupInput("checkGrouptype", 
                                                        label = h3("Select Predominant Degree Awarded"), 
                                                        choices = list("Predominantly Bachelor's"=3, 
                                                                       "Predominantly Associate's"=2),
                                                        selected = 3),
                                     
                                     width = 2),#sidebarpanel
                                 
                                 #mainPanel
                                 mainPanel(fluidRow(column(8, leafletOutput("myMap") %>% 
                                                             withSpinner(color="#0dc5c1"),
                                                           DT::dataTableOutput("mytable"),
                                                            DT::dataTableOutput("mytable2")),
                                                    column(4, plotOutput("od_ton_chart"),
                                                           plotOutput("percentchange"),
                                                           plotOutput("distPlot"), 
                                                           plotOutput("distPlot2")
                                                           
                                                           ))
                                          ) #mainpanel
                                         
                             ), #)tabpanel1
                             
                             
                             #tabPanel2(
                             
                             tabPanel("Disciplines",
                                      sidebarPanel(
                                        selectInput("selectprog", 
                                                           label = h3("Select Program"),
                                                           choices = programlist,
                                                           multiple = FALSE
                                                           
                                      ),
                                      selectInput("selectcolor", label = h3("Select Color"),
                                                  choices = c("public_private", "region"),
                                                  multiple = FALSE)
                             ), #sidebarpanel
                             
                             #mainpanel
                             mainPanel(plotOutput('prgmplot'))
                             )#)tabpanel2
                  )#navbarpage
                  
                  ))




#splitLayout(cellWidths = c("50%", "50%")
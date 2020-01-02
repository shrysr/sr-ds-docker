library(shiny)

## Define UI
ui  <- fluidPage(
  titlePanel("Basic widget exploration"),

  fluidRow(

    column(2,
           h3("buttons"),
           actionButton("action007", label ="Action"),
           br(),
           br(),
           submitButton("Submit")
           ),
    column(2,
           h3("Single Checkbox"),
           checkboxInput("checkbox", "Choice A", value = T)
           ),
    column(3,
           checkboxGroupInput("checkGroup",
                              h3("checkbox group"),
                              choices = list("Choice 1" = 1,
                                             "Choice 2" = 2,
                                             "Choice 3" = 3
                                             ),
                              selected = 1
                              )
           ),
    column(2,
           dateInput("date",
                     h3("date input"),
                     value = ""
                     )
           )

  ),
  ## Inserting another fluid row element
  fluidRow(

    column(2,
           radioButtons("radio",
                        h3("Radio Buttons"),
                        choices = list("choice 1" = 1,
                                       "choice 2" = 2,
                                       "Radio 3"  = 3
                                       ),
                        selected =1
                        )
           ),

    column(2,
           selectInput("select",
                       h3("Select box"),
                       choices = list("choice 1" = 1,
                                      "choice 2" = 2,
                                      "choice 3" = 3
                                      ),
                       selected = 1
                       )
           ),
    column(2,
           sliderInput("slider1",
                       h3("Sliders"),
                       min = 0,
                       max = 100,
                       value = 50
                       ),

           sliderInput("slider2",
                       h3("Another Slider"),
                       min = 50,
                       max = 200,
                       value = c(60,80)
                       )
           ),
    column(2,
           selectInput("selectbox1",
                     h3("select from drop down box"),
                     choices = list("choice 1" = 22,
                                    "choice 2" = 2,
                                    "choice fake 3" = 33
                                    ),
                     selected = ""
                     )
           )

  ),
  fluidRow(
    column(3,
           dateRangeInput("daterange",
                          h3("Date range input")
                          )
           ),

    column(3,
           fileInput("fileinput",
                     h3("Select File")
                     )
           ),

    column(3,
           numericInput("numinput",
                        h3("Enter numeric value"),
                        value = 10
                        )
           ),
    column(3,
           h3("help text"),
           helpText("Hello this is line one.",
                    "This is line 2..\n",
                    "This is line 3."
                    )
           )
  )
)


## Define server logic

server <- function(input, output){


}



## Run the app
shinyApp(ui = ui, server = server)

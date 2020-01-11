#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(caret)
library(shiny)
library(shinythemes)

# data loading, cleaning, and model fitting was done in "data_and_model.R"
# load the the model
model_glm <- readRDS("model_glm.Rds")

# Define UI for application that predicts attrition
ui <- fluidPage(
    
    # Theme
    theme = shinytheme("readable"),

    # Application title
    titlePanel("Attrition prediciton"),

    # Sidebar with a slider inputs 
    sidebarLayout(
        sidebarPanel(
            sliderInput("monthly_income",
                        "Monthly Income:",
                        min = 1000,
                        max = 20000,
                        value = 10000),
            sliderInput("job_satisfaction",
                        "Job Satisfaction:",
                        min = 1,
                        max = 4,
                        value = 2),
            sliderInput("years_at_company",
                        "Years at company:",
                        min = 0,
                        max = 45,
                        value = 5),
            selectInput("gender_input", label = h3("Gender"),
                        choices = list("Female" = "Female",
                                       "Male" = "Male"), selected = 1)
        ),

        # Show a table with probabilities
        mainPanel(
           h2("Probability of attrition:"),
           tableOutput('table'),
           em("The model was trained using IBM HR ",
             a("data: ", 
               href = "https://www.kaggle.com/pavansubhasht/ibm-hr-analytics-attrition-dataset/download"))
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    output$table <-
        renderTable(predict.train(
            model_glm,
            newdata =
                data.frame(
                    MonthlyIncome = input$monthly_income,
                    JobSatisfaction = input$job_satisfaction,
                    YearsAtCompany = input$years_at_company,
                    Gender = input$gender_input
                ),
            type = "prob"
        ))
}

# Run the application 
shinyApp(ui = ui, server = server)

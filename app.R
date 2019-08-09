library(shiny)
library(shinydashboard)
library(mapdeck)


ui <- dashboardPage(
  dashboardHeader()
  , dashboardSidebar(

    sliderInput("n", "Number of points"
                , min = 1000, max = 1e6, value = 10000
                , step = 50000, round = 2),
    actionButton("go", label = "Go!")

  )
  , dashboardBody(

    mapdeck::mapdeckOutput(
      outputId = "map"
    )



  )
)

server <- function(input, output){

  # shinyapps
  #set_token( read.dcf(".mapbox", fields = "MAPBOX"))

  # local and aws
  set_token( read.dcf("~/.mapbox", fields = "MAPBOX"))

  ## initialise a map
  output$map <- renderMapdeck({
    mapdeck(location = c(runif(10000),runif(10000)), zoom = 3)
  })

  # when action button pressed, update values
  df <- eventReactive(input$go, {

    n <- input$n

    data.frame(
      lon = rnorm(n)
      , lat = rnorm(n)
      , colour = rnorm(n)
    )

  })

  # redraw map when action button pressed
  observeEvent( input$go,  {
  begin <- Sys.time()
  message(paste0( "begin: ", begin))


    now <- { Sys.time() - begin }
    message(paste0("start map: ", now))

    mapdeck_update(map_id = "map") %>%
      clear_scatterplot(layer_id = "points")

    message(df()[1,])
      mapdeck_update(map_id = "map") %>%
        add_scatterplot(
          data = df()
          , fill_colour = "colour"
          , layer_id = "points"
          , focus_layer = TRUE
        )

       now <- { Sys.time() - begin }
       message(paste0("map calc done: ", now))

  })




}

shinyApp(ui, server)

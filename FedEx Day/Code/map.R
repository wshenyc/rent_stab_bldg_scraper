library(shiny)
library(tidyverse)
library(glue)
library(lubridate)
library(shinydashboard)
library(dashboardthemes)
library(shinyalert)
library(echarts4r) #to make interactive charts & maps! 
library(parsedate)
library(leaflet)
library(htmltools)

##----DATA-----------------------------------------------------------
#
# Description: Load in data
#____________________________________________________________________________

#work dir 
dir <- "C:/Users/shenw/Documents/Fedex Day May 2022/FedEx-May-2022/FedEx Day"

master_dhcr_geo_unit<-read_csv(glue("{dir}/Data/dhcr_geo_unit.csv"))

##----UI-----------------------------------------------------------
#
# Description: UI page
#____________________________________________________________________________


header <- dashboardHeader (
  title = "RS Buildings"
)

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Map", tabName = "rs_map", icon = icon("city"))
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "rs_map",
            tabBox(
              width = 12,
              tabPanel(
                
                "Map of RS Buildings",
                leafletOutput("rs_leaflet", height = "70vh"),
                #width = 12
                
                br(),  
                
                fluidRow(
                  valueBox("~40,000" ,
                           "Buildings on the 2021 RGB Lists",
                           icon=icon("building"),
                           width = 6),
                  valueBox("~14,000" ,
                           "RS Units Lost Between 2019 and 2018",
                           icon=icon("house-user"),
                           width = 6),
                )
              )
            ))
  )
)

ui <- dashboardPage(
  title = "SWL Dashboard",
  
  header,
  sidebar,
  body
  
)

##----Server-----------------------------------------------------------
#
# Description: Server
#____________________________________________________________________________


server <- function(input, output, session) {
  
  output$rs_leaflet <- renderLeaflet ({
    leaflet() %>%
      addTiles() %>%
      setView(-74.00, 40.71, zoom = 12) %>%
      addProviderTiles("CartoDB.Positron") %>% 
      addCircleMarkers(data = master_dhcr_geo_unit, lng = ~longitude, lat = ~latitude,
                       radius = 5, stroke = FALSE, fillOpacity = 0.5,
                       popup = (paste('<strong>',paste(master_dhcr_geo_unit$bldgno1, master_dhcr_geo_unit$street1, ",",
                                                       master_dhcr_geo_unit$city, master_dhcr_geo_unit$zipcode), '</strong>', '<br>',
                            '<strong>', "Number of RS Units in 2018:", '</strong>',master_dhcr_geo_unit$uc2018, "<br>",
                                      '<strong>',"Number of RS Units in 2019:", '</strong>', master_dhcr_geo_unit$uc2019, "<br>", 
                            '<strong>', "Status 1:",'</strong>', master_dhcr_geo_unit$status1,  '<br>',
                            '<strong>', "Status 2:", '</strong>',master_dhcr_geo_unit$status2,  '<br>',
                            '<strong>', "Status 3:", '</strong>',master_dhcr_geo_unit$status3,  '<br>',sep = " ")),
                       group = "SWL Eligible Buildings",
                       clusterOptions = markerClusterOptions()
      )
    
  })
  
  
}

##----App launch-----------------------------------------------------------
#
# Description: Launches app 
#____________________________________________________________________________



shinyApp(ui, server)

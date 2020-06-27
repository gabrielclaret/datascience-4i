####
library(shinydashboard)
library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
library(highcharter)
library(lubridate)
library(stringr)
library(withr)
library(treemap)
library(DT)
library(shinyBS)
library(shinyjs)
library(WDI)
library(geosphere)
library(magrittr)
library(shinycssloaders)
options(spinner.color="#006272")
library(timevis)
library(markdown)

## build ui.R -----------------------------------
## 1. header -------------------------------
header <- 
   dashboardHeader( title = HTML(""), 
                    disable = TRUE, 
                    titleWidth  = 550
   )


## 2. siderbar ------------------------------
siderbar <- 
   dashboardSidebar( 
      width = 222,
      sidebarMenu(
         id = 'sidebar',
         style = "position: relative; overflow: visible;",
         #style = "position: relative; overflow: visible; overflow-y:scroll",
         #style = 'height: 90vh; overflow-y: auto;',

         menuItem( " Analise Exploratoria 1", tabName = 'dashboard', icon = icon('chart-line') ),

         menuItem("Analise Exploratoria 2", tabName = 'dashboard1', icon = icon('chart-line') ),
         
         menuItem("Analise Exploratoria 3", tabName = 'dashboard2', icon = icon('chart-line') ),
         
         menuItem("Analise Exploratoria 4", tabName = 'dashboard3', icon = icon('chart-line') ),
         
         menuItem("Crawler", tabName = 'crawler', icon = icon('cloud-download-alt') ),
         
         menuItem("ML - In Progress", tabName = 'ml', icon = icon('globe') )

         )
   )

## 3. body --------------------------------
body <- dashboardBody( 
   ## 3.0. CSS styles in header ----------------------------
   tags$head(

      tags$style(HTML('

                       /* navbar (rest of the header) */
                       .skin-blue .main-header .navbar {
                       background-color: #006272;
                       }

                       /* active selected tab in the sidebarmenu */
                       .skin-blue .main-sidebar .sidebar .sidebar-menu .active a{
                       background-color: #006272;
                                 }
                       ')
                ),
      
      ## modify icon size in the sub side bar menu
      tags$style(HTML('
                       /* change size of icons in sub-menu items */
                      .sidebar .sidebar-menu .treeview-menu>li>a>.fa {
                      font-size: 15px;
                      }

                      .sidebar .sidebar-menu .treeview-menu>li>a>.glyphicon {
                      font-size: 13px;
                      }

                      /* Hide icons in sub-menu items */
                      .sidebar .sidebar-menu .treeview>a>.fa-angle-left {
                      display: none;
                      } 
                      '
                  )) ,
      
      tags$style( HTML("hr {border-top: 1px solid #000000;}") ),
      
      ## to not show error message in shiny
      tags$style( HTML(".shiny-output-error { visibility: hidden; }") ),
      tags$style( HTML(".shiny-output-error:before { visibility: hidden; }") ),
      
      ## heand dropdown menu size
      #tags$style(HTML('.navbar-custom-menu>.navbar-nav>li>.dropdown-menu { width:100px;}'))
      tags$style(HTML('.navbar-custom-menu>.navbar-nav>li:last-child>.dropdown-menu { width:10px; font-size:10px; padding:1px; margin:1px;}')),
      tags$style(HTML('.navbar-custom-menu> .navbar-nav> li:last-child > .dropdown-menu > h4 {width:0px; font-size:0px; padding:0px; margin:0px;}')),
      tags$style(HTML('.navbar-custom-menu> .navbar-nav> li:last-child > .dropdown-menu > p {width:0px; font-size:0px; padding:0px; margin:0px;}'))
      ),
       
   ## 3.1 Dashboard body --------------
   tabItems(
      ## 3.1 Main dashboard ----------------------------------------------------------
      tabItem( tabName = 'dashboard',
               includeHTML("./lista_questao_1.html")
      ),
      
      tabItem( tabName = 'dashboard1',
               includeHTML("./lista_questao_2.html")
      ),
      
      tabItem( tabName = 'dashboard2',
               includeHTML("./lista_questao_3.html")
      ),
      
      tabItem( tabName = 'dashboard3',
               includeHTML("./lista_questao_4.html")
      ),
      
      tabItem( tabName = 'crawler',
               includeHTML("./crawlerresult.html")
      )#,
      
      #tabItem( tabName = 'ml',
      #         includeHTML("./machine_learning.html")
      #)
      
   )
)



## put UI together --------------------
ui <- 
   dashboardPage(header, siderbar, body )

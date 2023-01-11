



library(shiny)


shinyServer(function(input, output, session) {

    output$distPlot <- renderPlot({

        inst_data2gl %>%group_by(year) %>%
            filter(region_id == input$checkGroupr) %>% 
            filter(ownership == input$checkGroupo) %>% 
            summarise(fewd = mean(title_iv.female.withdrawn_by.2yrs, na.rm = T),
                      feen = mean(title_iv.female.still_enrolled_by.2yrs, na.rm = T),
                      mawd = mean(title_iv.male.withdrawn_by.2yrs, na.rm = T),
                      maen = mean(title_iv.male.still_enrolled_by.2yrs, na.rm = T),
            ) %>% 
            ggplot(aes(x=year))+
            geom_line(aes(y=fewd), color = "deeppink3" , linetype = "dashed", size = 1)+
            
            geom_line(aes(y=feen), color = "deeppink3", size =0.75)+
            #geom_point(aes(y=mi), color = "royalblue4")+
            geom_line(aes(y=mawd), color = "mediumblue", linetype = "dashed", size=0.75)+
            geom_line(aes(y=maen), color = "mediumblue", size = 0.75)+
            
            scale_x_continuous(breaks=seq(2000, 2022, 1))+
            theme_minimal()

    })
    df_fil <- reactive({
        w <- inst_data2glsf %>% filter(ownership == input$checkGroupo)
        return(w)
    })
    output$mymap <- renderLeaflet({
        
        
            leaflet(states) %>% 
            setView(-96, 37.8, 4) %>% 
            addProviderTiles("MapBox", options = providerTileOptions(
                id = "mapbox.light",
                accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN'))) %>% 
            addPolygons()
            
        
            
            
                             
            
    })

})





library(shiny)


shinyServer(function(input, output, session) {

    output$distPlot <- renderPlot({

        inst_data3gl %>%group_by(year) %>%
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
    
    output$distPlot2 <- renderPlot({
        inst_data3gl %>%group_by(year) %>%
            summarise(liwd = mean(title_iv.low_inc.withdrawn_by.2yrs, na.rm = T),
                      lien = mean(title_iv.low_inc.still_enrolled_by.2yrs, na.rm = T),
                      midwd = mean(title_iv.mid_inc.withdrawn_by.2yrs, na.rm = T),
                      midenr = mean(title_iv.mid_inc.still_enrolled_by.2yrs, na.rm = T),
                      hiwd = mean(title_iv.high_inc.withdrawn_by.2yrs, na.rm = T),
                      hien = mean(title_iv.high_inc.still_enrolled_by.2yrs, na.rm = T)
            ) %>% 
            ggplot(aes(x=year))+
            geom_line(aes(y=liwd), color = "purple",linetype = "dashed", size = 1)+
            geom_point(aes(y=liwd), color = "purple", size = 1)+
            geom_line(aes(y=lien), color = "purple", size =0.75)+
            #geom_point(aes(y=mi), color = "royalblue4")+
            geom_line(aes(y=midwd), color = "chartreuse4", linetype = "dashed", size=0.75)+
            geom_line(aes(y=midenr), color = "chartreuse4", size = 0.75)+
            geom_line(aes(y=hiwd), color = "darkgoldenrod1", linetype = "dashed", size=0.75)+
            geom_line(aes(y=hien), color = "darkgoldenrod1", size = 0.75)+
            scale_x_continuous(breaks=seq(2000, 2022, 1))+
            theme_minimal()
        
    })
    
    # selected_zone <- reactive({
    #     p <- input$Zone_shape_click
    #     subset(inst_data2glsf, id==p$id )
    # })
    # selected_od <- reactive({
    #     p <- input$Zone_shape_click
    #     selected <- subset(inst_data2glsf, id==p$id )
    # })
    #define reactive 
    df_fil <- reactive({
        w <- inst_data3gla %>% filter(ownership %in% input$checkGroupo,
                                      region_id %in% input$checkGroupr)
        return(w)
    })
    
 output$myMap <- renderLeaflet({
        zone_labels <- sprintf(
        "<strong>%s</strong><br/>",
        paste(states$id, "--", states$name, sep='')
        ) %>% lapply(htmltools::HTML)
        
        df_fil() %>% leaflet() %>% 
            addProviderTiles(providers$Esri.WorldGrayCanvas, group = "Default Maptile",
                                 options = providerTileOptions(noWrap = TRUE))%>%
           
            setView(-96, 37.8, 4) %>% 
            # addLayersControl(
            #     baseGroups = c("Default Maptile", "Satellite Maptile"),
            #     options = layersControlOptions(collapsed = TRUE)
            # )%>%
            # addMarkers(lat= ~latt, lng= ~longg) %>%  
            addCircleMarkers(data = df_fil(), lat= ~latt, lng= ~longg, 
                             #group = "public",
                             radius = 2,
                             color = "red", 
                             fillOpacity = 0.5)  %>% 
            # addCircleMarkers(data = private_non_profit, lat= ~latt, lng= ~longg, 
            #                  group = "private",
            #                  radius = 2,
            #                  color = "blue",
            #                  fillOpacity = 0.5) %>% 
            # addLayersControl(overlayGroups = c("public", "private_non_profit")) %>% 
            addPolygons(data=states, col="black", weight = 1,
                        layerId = ~id, label=  zone_labels,
                        highlight = highlightOptions(color = "blue",weight = 2, bringToFront = F, opacity = 0.7))

            
    })
 
 ##observeEvent
 observeEvent(input$myMap_shape_click, {
     click <- input$myMap_shape_click
     print(click)
     
     selected <- df_fil() %>% filter(state_fips2 == click$id)
     if(!is.null(click$id)){
         output$mytable = DT::renderDataTable({
             selected
                }) 
     
}
     
 })#observeEvent
 
 ggplot_data <- reactive({
     site <- input$myMap_shape_click$id
     df_fil() %>% filter(state_fips2 %in% site)
 })
 output$od_ton_chart <- renderPlot({
     ggplot_data() %>%
        dplyr::group_by(year) %>% 
        dplyr::summarise(val = mean(title_iv.female.withdrawn_by.2yrs, na.rm = T)) %>% 
     ggplot(aes(year, val)) +
         geom_line()
 }) 
 
 
 
 
 
 
 
 
 # selected_od <- reactive({
 #     p <- input$myMap_shape_click
 #     selected <- df_fil() %>% filter(state_fips2 %in% p$id)
 # })
 
 

 ##plotly that doesn't work
 # output$od_ton_chart=renderPlotly({
 #     selected <- selected_od()
 #     
 #     
 #         df_sub <- df_fil() %>% filter(state_fips %in% selected$id)  %>%
 #             select(ownership, enrollment.all, region)
 #         na.omit(df_sub)
 #         
 #        plot_ly(df_sub, x = ~region, y = ~enrollment.all, type = 'bar', name = 'FAF4 Tons')%>% 
 #                 add_trace(y = ~ownership, name = 'FAF5 Tons')%>% 
 #                 layout(yaxis = list(title = 'tons (000)'), barmode = 'group')
 #     
 #     
     
         
     

# })
 
})

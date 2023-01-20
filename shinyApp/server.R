



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
   
    #define reactive --filters by input from checkboxes
    df_fil <- reactive({
        w <- inst_data3gla %>% filter(ownership %in% input$checkGroupo,
                                      region_id %in% input$checkGroupr,
                                      degrees_awarded.predominant %in% input$checkGrouptype)
        return(w)
    })
    
    test <- reactive({
        v <- states_merged_cap %>% mutate(variable_b = states_merged_cap[[input$shadeby]])
        return(v)
        w <- inst_data3gla %>% filter(ownership %in% input$checkGroupo,
                                      region_id %in% input$checkGroupr,
                                      degrees_awarded.predominant %in% input$checkGrouptype)
        return(w)
        
        list(df1 = v, df2 = w)
    })
    
 output$myMap <- renderLeaflet({
 
       pal <- colorFactor(palette = c("blue", "red", "forestgreen"),
                          levels = c("1", "2", "3"))
       zone_labels <- sprintf(
                   "<strong>%s</strong><br/>",
                   paste(states_merged_cap$NAME.y)
               ) %>% lapply(htmltools::HTML)
       
        df_fil() %>% leaflet() %>%
            addProviderTiles(providers$Stamen.TonerLite) %>%
            setView(-96, 37.8, 4) %>%
            addCircleMarkers(data = df_fil(), lat= ~latt, lng= ~longg,
                             radius = 0.5,
                             color = ~pal(ownership),
                             fillOpacity = 0.2) %>% 
            addPolygons(data = states_merged_cap,
                    color = 'black',
                    weight = 2,
                    fillOpacity = 0.1,
                    #smoothFactor = 0.2,
                    layerId = ~STATEFP,
                    label = zone_labels,
                    highlight = highlightOptions(color = "blue",weight = 2, bringToFront = F, opacity = 0.7))
        
        

    })
 
 ##define reactive --selects column by shadeby
 coloring <- reactive({
     states_merged_cap$variable_b = states_merged_cap[[input$shadeby]]
     states_merged_cap
 })

 
  observeEvent(coloring(), {
      req(coloring())

     palb <- colorNumeric("Greens", coloring()$variable_b)

     zone_labels <- sprintf(
         "<strong>%s</strong><br/>",
         paste(states_merged_cap$NAME.y)
     ) %>% lapply(htmltools::HTML)

     leafletProxy("myMap") %>%
         # clearShapes() %>%
         # clearControls() %>%
         addPolygons(data = coloring(),
                     color =
                         ~palb(variable_b),
                     weight = 2,
                     fillOpacity = 0.1,
                     #smoothFactor = 0.2,
                     layerId = ~STATEFP,
                     label = zone_labels,
                     highlight = highlightOptions(color = "blue",weight = 2, bringToFront = F, opacity = 0.7))
 })

 
 
 
 ##observeEvent for myMap shape click
 observeEvent(input$myMap_shape_click, {
     click <- input$myMap_shape_click
     print(click)
     
     selected <- df_fil() %>% filter(state_fips2 %in% click$id)
    
     if(!is.null(click$id)){
         output$mytable = DT::renderDataTable({selected}, 
                                              options = list(dom = 'Bfrtip', scrollY = 500, scroller = TRUE, scrollX=TRUE))
         output$od_ton_chart = renderPlot({
             selected%>% 
                 filter(year > 2001) %>% 
                 dplyr::group_by(year) %>% 
                 dplyr::summarize(enrollment = sum(size, na.rm = T)) %>% 
                 ggplot()+
                 geom_line(aes(x=year, y=enrollment))+
                 ylab('Total Enrollment')+
                 scale_x_continuous(breaks = seq(2000, 2022, 5))+
                 theme(axis.text.x = element_text(angle = 90, vjust = 1, hjust=1),
                       legend.title=element_blank())+
                 ggtitle('Total Enrollment')
         })
         output$percentchange = renderPlot({
             selected %>% 
                 filter(year > 2001) %>% 
                 group_by(year) %>% 
                 summarize(enrollment = sum(size, na.rm = T)) %>% 
                 mutate(Diff_year = year - lag(year),
                        Diff_growth = enrollment - lag(enrollment),
                        Rate_percent = (Diff_growth/Diff_year)/enrollment * 100) %>% 
                 ggplot(aes(x=year, y=Rate_percent))+
                 geom_bar(stat = 'identity') +
                 ylab("% Change from Previous Year")+
                 ggtitle('Change in Enrollment')
         })
         
     }
 })
 
 
 #ggplot_data used to update plots with state click
 ggplot_data <- reactive({
     site <- input$myMap_shape_click$id
     df_fil() %>% filter(state_fips2 %in% site)
 })
 
 # output$od_ton_chart <- renderPlot({
 #         ggplot_data()  %>% 
 #         filter(year > 2001) %>% 
 #         dplyr::group_by(year) %>% 
 #         dplyr::summarize(enrollment = sum(size, na.rm = T)) %>% 
 #         ggplot()+
 #         geom_line(aes(x=year, y=enrollment))+
 #         ylab('Total Enrollment')+
 #         scale_x_continuous(breaks = seq(2000, 2022, 5))+
 #         theme(axis.text.x = element_text(angle = 90, vjust = 1, hjust=1),
 #               legend.title=element_blank())+
 #         ggtitle('Total Enrollment')
 # }) 
 
 # output$percentchange <- renderPlot({
 #     ggplot_data() %>% 
 #         filter(year > 2001) %>% 
 #         group_by(year) %>% 
 #         summarize(enrollment = sum(size, na.rm = T)) %>% 
 #         mutate(Diff_year = year - lag(year),
 #                Diff_growth = enrollment - lag(enrollment),
 #                Rate_percent = (Diff_growth/Diff_year)/enrollment * 100) %>% 
 #         ggplot(aes(x=year, y=Rate_percent))+
 #         geom_bar(stat = 'identity') +
 #         ylab("% Change from Previous Year")+
 #         ggtitle('Change in Enrollment')
 # })
 # 
 
 ##############Page 2
 dat <- reactive({
    prgmsg$variable = prgmsg[[input$selectprog]]
    prgmsg$colorvar = prgmsg[[input$selectcolor]]
    prgmsg
    
 })
 
 output$prgmplot <- renderPlot({
     dat() %>% 
         dplyr::group_by(year, colorvar) %>% 
         dplyr::summarise(val = mean(variable, na.rm = T)) %>% 
         ggplot(aes(year, val)) +
         geom_line(aes(color = colorvar, group = colorvar))+
         geom_point()+
         scale_y_continuous(labels = function(x) paste0(x*100, "%"))
 }) 
 
 
})

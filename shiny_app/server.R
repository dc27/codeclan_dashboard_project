source("R/filter_data_life_expectancy.R")
source("R/create_hb_map.R")
source("R/filter_data_life_expectancy_simd.R")
source("R/create_le_simd_plot.R")
source("R/filter_stats_life_satisfaction_sex_only.R")

server <- function(input, output) {
  # take ui inputs for date, sex
  life_expect_chosen_year <- filter_data_LE(
    input = input,
    data = life_expectancy_data_all_SIMD
    )
  
  # render map for life expectancy
  output$LE_map <- renderLeaflet({
    create_hb_map(life_expect_chosen_year(), reactive(input$sex_choice))
  })

#filter stats for when user clicks action buttons
  filtered_stats_life_satisfaction <- 
    eventReactive(input$update, 
                  ignoreNULL = FALSE,{
                                      life_satisfaction %>% 
                                      filter(sex %in% 
                                              c(input$sex_choices_life_satisfaction)) %>% 
                                        filter(health_board_name %in% 
                                              c(input$area_choices_life_satisfaction))
  })
  filtered_stats_LS_by_sex_only <-
    filter_stats_life_satisfaction_sex_only(input = input,
                                            data = life_satisfaction)
  output$satisfaction_map <- renderLeaflet({
    create_hb_map_LS(filtered_stats_LS_by_sex_only(), reactive(input$sex_choices_life_satisfaction))
  })

# create plot for life satisfaction
output$satisfaction_plot <- renderPlot({
  filtered_stats_life_satisfaction() %>% 
    ggplot(aes(x = health_board_name, y = value,
               fill = factor(indicator_factor,
                             levels = c("Very dissatisfied (below mode)",
                                        "Satisfied (mode)",
                                        "Very satisfied (above mode)")))) +
      geom_col(position = "dodge", colour = "grey") +
      scale_fill_brewer(palette = 1) +
      labs(y = "% Adults",
           title = "Life Satisfaction") +
      theme(plot.title = element_text(hjust = 0.5, vjust = 1, size=16),
            axis.title.x = element_blank(),
            axis.text.x = element_text(vjust=1,size=10),
            axis.text.y = element_text(hjust=1.5,size=10),
            legend.title = element_blank(),
            legend.position = "bottom",
            legend.spacing.x = unit(1.0, "cm"),
            legend.text = element_text(size = 10),
            panel.grid.major.y = element_blank(),
            plot.background = element_rect(fill = "white", colour = "grey"),
            panel.background = element_rect(fill = "white", colour = "grey"))+
      facet_wrap(~ sex)
  })  

  
  selected_simd <- filter_data_LE_simd(
    input = input,
    data = le_data_individual_simds
  )
  
  # render plot for life expectancy by SIMD
  output$LE_by_simd_plot <- renderPlot({
    create_le_simd_plot(selected_simd())
  })

  
}
# life expectancy files
source("R/life_expectancy/filter_data_life_expectancy.R")
source("R/life_expectancy/create_hb_map.R")
source("R/life_expectancy/filter_data_life_expectancy_simd.R")
source("R/life_expectancy/create_le_simd_plot.R")
source("R/life_expectancy/create_life_expect_plot_all_years.R")
# life satisfaction files
source("R/life_satisfaction/filter_stats_life_satisfaction.R")
source("R/life_satisfaction/filter_stats_life_satisfaction_sex_only.R")
source("R/life_satisfaction/create_life_satisfaction_plot.R")
# alcohol hospital admissions files
source("R/alcohol/filter_data_alcohol.R")
source("R/alcohol/filter_data_alcohol_all_dates.R")
source("R/alcohol/create_alcohol_col_plot.R")
source("R/alcohol/create_alcohol_line_plot.R")
# drug related hospital files
source("R/drugs/filter_data_drugs.R")
source("R/drugs/filter_drugs_all_dates.R")
source("R/drugs/create_drugs_col_plot.R")
source("R/drugs/create_drugs_line_plot.R")
# smoking responses files
source("R/smoking/create_smoking_plot.R")
source("R/smoking/filter_smoking_data.R")



server <- function(input, output) {
#####-----life expectancy------#####
  # take ui inputs for date, sex
  life_expect_chosen_year <- filter_data_LE(
    input = input,
    data = life_expectancy_data_all_SIMD
    )
  
  # render map for life expectancy
  output$LE_map <- renderLeaflet({
    create_hb_map(life_expect_chosen_year(), reactive(input$sex_choice))
  })

  # create plot for life expectancy by year for all scotland
  output$LE_year_plot <- renderPlot({
    create_life_expectancy_all_scotland_all_years(life_expectancy_data)
  })

  # filter data for life expectancy by SIMD
  selected_simd <- filter_data_LE_simd(
    input = input,
    data = le_data_individual_simds
  )
  
  # render plot for life expectancy by SIMD
  output$LE_by_simd_plot <- renderPlot({
    create_le_simd_plot(selected_simd())
  })

#####-----life satisfaction-----#####  
  # filter stats for when user clicks action buttons
  filtered_stats_life_satisfaction <- 
    eventReactive(input$update_LS, 
                  ignoreNULL = FALSE,
                  {filter_stats_life_satisfaction(
                    input = input,
                    data = life_satisfaction
                  )
                  })
  
  # create plot for life satisfaction
  output$satisfaction_plot <- renderPlot({
    create_life_satisfaction_plot(
      data = filtered_stats_life_satisfaction()
    )
  })
  
  # filter LS by sex only for map
  filtered_stats_LS_by_sex_only <-
    eventReactive(input$update_LS,
                  ignoreNULL = FALSE,
                  {filter_stats_life_satisfaction_sex_only(
                    input = input,
                    data = life_satisfaction)
                  })
  
  # create map for life satisfaction
  output$satisfaction_map <- renderLeaflet({
    create_hb_map_LS(filtered_stats_LS_by_sex_only(),
                     reactive(input$sex_choices_life_satisfaction))
  })
#####-----alcohol related hospital stats-----#####  
  # Alcohol server function
  # filter data for update action
  filtered_alcohol <-
    eventReactive(input$update_alcohol_plot,
                  ignoreNULL = FALSE,
                  {filter_data_alcohol(
                    input = input,
                    data = alcohol
                  )
  })
  filtered_alcohol_all_dates <-
    eventReactive(input$update_alcohol_plot,
                  ignoreNULL = FALSE,
                  {filter_data_alcohol_all_dates(
                    input = input,
                    data = alcohol
                  )})
  
  # Alcohol geom col plot
  output$alcohol_discharge <- renderPlot({
    create_alcohol_col_plot(
      data = filtered_alcohol()
    )
  })
  
  output$alcohol_over_time <- renderPlot({
    create_alcohol_line_plot(
      data = filtered_alcohol_all_dates()
    )
  })

#####-----drug related hospital stats-----#####
  # Drugs server function
  # filtered data for update action
  filtered_drugs <-
    eventReactive(
      input$update_drugs_plot,
      ignoreNULL = FALSE,
      {filter_data_drugs(
        input = input,
        data = drugs
      )}
    )
  
  filtered_drugs_only_by_council_area <- eventReactive(
    input$update_drugs_plot,
    ignoreNULL = FALSE,
    {filter_drugs_all_dates(
      input = input,
      data = drugs
    )}
  )
  
  # Drugs geom col plot
  output$drug_count <- renderPlot({
    create_drugs_col_plot(
      data = filtered_drugs()
    )
  })

  output$drugs_over_time <- renderPlot({
    create_drugs_line_plot(
      data = filtered_drugs_only_by_council_area()
    )
  })

#####-----smoking survey responses-----#####  
  # calling filtered smoking data
  smoking_filtered <- filter_smoking_data(
    input = input,
    data = scotland_smoking_data
  )

  
  # render plot for smoking tab
  output$smoking_plot <- renderPlot(createSmokingPlot(smoking_filtered))
}
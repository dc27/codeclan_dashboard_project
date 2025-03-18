create_life_expectancy_all_scotland_all_years <- function(data) {
  data %>%
    filter(simd_quintiles == "All") %>% 
    filter(feature_code == "S92000003") %>%
    pivot_wider(names_from = measurement, values_from = value) %>% 
    janitor::clean_names() %>% 
    ggplot(aes(date_code)) +
    geom_point(aes(y = count,
                   colour = sex),
               size = 4) +
    geom_ribbon(aes(ymin = x95_percent_lower_confidence_limit,
                    ymax = x95_percent_upper_confidence_limit,
                    group = sex),
                alpha = 0.2) +
    labs(x = "Date range",
         y = "Life expectancy (years)",
         title = "Life expectancy over time in Scotland",
         colour = "Sex") +
    theme(legend.position = "right",
          axis.text.x = element_text(angle = 90, hjust = 1),
          legend.title = element_text(hjust = 0.5))
}

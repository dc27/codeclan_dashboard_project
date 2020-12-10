# ignore the "all" field
le_data_individual_simds <- life_expectancy_data %>% 
  filter(simd_quintiles != "All")

# simd plot
create_le_simd_plot <- function(data) {
  ggplot(data = data,
       aes(simd_quintiles)) +
  geom_point(aes(y = count,
                 colour = sex)) +
    # confidence intervals
  geom_ribbon(aes(ymin = x95_percent_lower_confidence_limit,
                  ymax = x95_percent_upper_confidence_limit,
                  group = sex),
              alpha = 0.2) +
  theme_bw() +
  labs(x = "SIMD",
       y = "Life expectancy by SIMD",
       title = "Life expectancy by SIMD",
       colour = "Sex") +
  theme(legend.position = "right",
        legend.title = element_text(hjust = 0.5))
}
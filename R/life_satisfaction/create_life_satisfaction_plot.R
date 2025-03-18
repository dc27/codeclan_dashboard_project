
create_life_satisfaction_plot <- function(data) {
  data %>% 
  ggplot(aes(x = health_board_name, y = value,
             fill = factor(indicator_factor,
                           levels = c("Very dissatisfied (below mode)",
                                      "Satisfied (mode)",
                                      "Very satisfied (above mode)")))) +
  geom_col(position = "dodge", colour = "grey") +
  scale_fill_brewer(palette = 1) +
  labs(y = "% Adults",
       x = "",
       fill = "",
       title = "Life Satisfaction") +
    facet_wrap(~sex) +
    theme(legend.position = "bottom")
}
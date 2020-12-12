
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
       title = "Life Satisfaction") +
  theme(plot.title = element_text(hjust = 0.5, vjust = 1, size=16),
        axis.title.x = element_blank(),
        axis.text.x = element_text(vjust=1,size=10),
        axis.text.y = element_text(hjust=1.5,size=10),
        legend.title = element_blank(),
        legend.position = "bottom",
        legend.spacing.x = unit(0.5, "cm"),
        legend.text = element_text(size = 10),
        panel.grid.major.y = element_blank(),
        plot.background = element_rect(fill = "white", colour = "grey"),
        panel.background = element_rect(fill = "white", colour = "grey")) +
  facet_wrap(~ sex)
}
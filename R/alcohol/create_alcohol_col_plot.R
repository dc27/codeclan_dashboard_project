create_alcohol_col_plot <- function(data) {
 data %>% 
    ggplot() +
    aes(x = council_area, y = count, fill = units) +
    geom_col(position = "dodge", colour = "white") +
    scale_fill_brewer(palette = 1) +
    labs(x = "Council Region",
         y = "Count",
         title = "Alcohol Related Incidents Within Hospital") +
    theme(plot.title = element_text(hjust = 0.5, vjust = 1, size=16),
          axis.title.x = element_blank(),
          axis.text.x = element_text(vjust=1,size=10),
          axis.text.y = element_text(hjust=1,size=10),
          legend.title = element_blank(),
          legend.position = "bottom",
          legend.spacing.x = unit(1.0, "cm"),
          legend.text = element_text(size = 10),
          panel.grid.major.y = element_blank(),
          plot.background = element_rect(fill = "white", colour = "grey"),
          panel.background = element_rect(fill = "white", colour = "grey"))
}
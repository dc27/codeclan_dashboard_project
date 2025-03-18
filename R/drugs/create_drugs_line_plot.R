create_drugs_line_plot <- function(data) {
  data %>% 
    ggplot() +
    aes(x = date_code, y = value, group = council_area, colour = council_area) +
    geom_line(linewidth = 2) +
    geom_point(size = 3) +
    labs(x = "Year",
         y = "Discharges",
         title = "Drugs Misuse Discharges from Hospital",
         colour = "Council Area") +
    theme(plot.title = element_text(hjust = 0.5, vjust = 1, size=16),
          axis.title.x = element_blank(),
          axis.text.x = element_text(vjust=1,size=10),
          axis.text.y = element_text(hjust=1,size=10),
          legend.position = "right",
          legend.title.align = 0.5,
          legend.text = element_text(size = 10),
          panel.grid.major.y = element_blank(),
          plot.background = element_rect(fill = "white", colour = "grey"),
          panel.background = element_rect(fill = "white", colour = "grey"))
}
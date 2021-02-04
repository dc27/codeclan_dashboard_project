createSmokingPlot <- function(data){
    data %>%
    mutate(date_start = as.character(date_start)) %>% 
      ggplot() +
      aes(x = date_start, y = value, fill = currently_smokes_cigarettes) +
      geom_bar(stat = "identity", colour = "white") +
      labs(y = "Percentage", x = "Year",
           fill = "Currently smoking cigarettes") +
    scale_fill_manual(values = c((RColorBrewer::brewer.pal(9, "Blues")[2]),
                                  (RColorBrewer::brewer.pal(9, "Blues")[6]))) +
    theme(plot.title = element_text(hjust = 0.5, vjust = 1, size=16),
          axis.title.x = element_blank(),
          axis.text.x = element_text(vjust=1,size=10),
          axis.text.y = element_text(hjust=0.5,size=10),
          legend.title = element_blank(),
          legend.position = "bottom",
          legend.spacing.x = unit(0.5, "cm"),
          legend.text = element_text(size = 10),
          panel.grid.major.y = element_blank(),
          plot.background = element_rect(fill = "white", colour = "grey"),
          panel.background = element_rect(fill = "white", colour = "grey"))
    }
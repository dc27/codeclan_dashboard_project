createSmokingPlot <- function(data){
    data %>%
    mutate(date_start = as.character(date_start)) %>% 
      ggplot() +
      aes(x = date_start, y = value, fill = currently_smokes_cigarettes) +
      geom_bar(stat = "identity", colour = "white") +
      labs(y = "Percentage", x = "Year",
           fill = "Currently smoking cigarettes") +
    scale_fill_manual(values = c((RColorBrewer::brewer.pal(9, "Blues")[2]),
                                  (RColorBrewer::brewer.pal(9, "Blues")[6])))
    }
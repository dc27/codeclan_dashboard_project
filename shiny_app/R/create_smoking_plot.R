createSmokingPlot <- function(data){
    data() %>%
    mutate(date_start = as.character(date_start)) %>% 
      ggplot() +
      aes(x = date_start, y = value, fill = currently_smokes_cigarettes) +
      geom_bar(stat = "identity", colour = "black") +
      labs(y = "Percentage", x = "Year",
           fill = "Currently smoking cigarettes") +
    scale_fill_manual(values = c("white","orange"))
    }
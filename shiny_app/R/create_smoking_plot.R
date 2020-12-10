createSmokingPlot <- function(data){
    data() %>%
    mutate(date_start = as.character(date_start)) %>% 
      ggplot() +
      aes(x = date_start, y = value, fill = currently_smokes_cigarettes) +
      geom_bar(stat = "identity") +
      labs(title = "Scotland Smoking Data", y = "Percentage", x = "Year")
    }
createSmokingPlot <- function(data){
    data() %>%
      ggplot() +
      aes(x = date_start, y = value, fill = currently_smokes_cigarettes) +
      geom_bar(stat = "identity") +
      labs(title = "Scotland Smoking Data", y = "Percentage", x = "Year") +
    theme(axis.text.x = element_text(angle = 90, hjust = 1))
    }
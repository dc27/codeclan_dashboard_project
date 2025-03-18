create_alcohol_col_plot <- function(data) {
 data %>% 
    ggplot() +
    aes(x = council_area, y = count, fill = units) +
    geom_col(position = "dodge", colour = "white") +
    scale_fill_brewer(palette = 1) +
    labs(x = "Council Region",
         y = "Count",
         title = "Alcohol Related Incidents Within Hospital")
}
create_alcohol_line_plot <- function(data) {
  data %>% 
  ggplot() +
  aes(x = date_code, y = count, group = council_area, colour = council_area) +
  geom_line(linewidth = 2) +
  geom_point(size = 3) +
  labs(x = "Year",
       y = "Patients",
       title = "Alcohol Related Incidents Within Hospital",
       colour = "Council Area")
}
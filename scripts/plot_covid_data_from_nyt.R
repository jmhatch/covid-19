# load libraries
library(dplyr)
library(ggplot2)

# load NYT data
ma_week = readr::read_csv('./data/ma-counties.csv')

# plot
covid_plt = ggplot(data = ma_week, aes(x = cases, y = week_sum, group = county)) + 
  geom_line() + 
  geom_point(data = ma_week %>% dplyr::filter(date == max(date)), size = 2, color = 'red') +
  facet_wrap(~county) + 
  gghighlight::gghighlight(county == county, use_direct_label = FALSE) +
  scale_x_log10(labels = scales::trans_format('log10', scales::math_format(10^.x))) +
  scale_y_log10(labels = scales::trans_format('log10', scales::math_format(10^.x))) +
  theme_bw() +
  xlab('total confirmed cases') + 
  ylab('new confirmed cases (in the past week)')

# save plot
png(file = './images/ma_county_covid.png',  width = 735, height = 526)
  print(covid_plt)
dev.off()
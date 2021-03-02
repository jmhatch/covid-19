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

# Bristol county in particular
bristol_plt_log = ggplot(data = ma_week %>% dplyr::filter(county == 'Bristol'), aes(x = cases, y = week_sum, group = county)) + 
  geom_line() + 
  geom_point(data = ma_week %>% dplyr::filter(date == max(date) & county == 'Bristol'), size = 2, color = 'red') +
  facet_wrap(~county) + 
  gghighlight::gghighlight(county == county, use_direct_label = FALSE) +
  scale_x_log10(labels = scales::trans_format('log10', scales::math_format(10^.x))) +
  scale_y_log10(labels = scales::trans_format('log10', scales::math_format(10^.x))) +
  theme_bw() +
  xlab('total confirmed cases') + 
  ylab('new confirmed cases (in the past week)') + 
  geom_text(data = ma_week %>% dplyr::filter(date == max(date) & county == 'Bristol'), aes(label = date), hjust = 1, vjust = 1.5)

bristol_plt_linear = ggplot(data = ma_week %>% dplyr::filter(county == 'Bristol'), aes(x = cases, y = week_sum, group = county)) + 
  geom_line() + 
  geom_point(data = ma_week %>% dplyr::filter(date == max(date) & county == 'Bristol'), size = 2, color = 'red') +
  facet_wrap(~county) + 
  gghighlight::gghighlight(county == county, use_direct_label = FALSE) +
  theme_bw() +
  xlab('total confirmed cases') + 
  ylab('new confirmed cases (in the past week)') + 
  geom_text(data = ma_week %>% dplyr::filter(date == max(date) & county == 'Bristol'), aes(label = date), hjust = 1, vjust = 1.5)

# save plots
png(file = './images/bristol_county_covid_log.png',  width = 735, height = 526)
  print(bristol_plt_log)
dev.off()

png(file = './images/bristol_county_covid_linear.png',  width = 735, height = 526)
  print(bristol_plt_linear)
dev.off()
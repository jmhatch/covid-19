# load libraries
library(dplyr)
library(magrittr)

# download county-level aggregated data from NY Times
nyt_data = 'https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv' %>% url() %>% readr::read_csv()

# filter to get Massachusetts data
ma_nyt = nyt_data %>% dplyr::filter(state == 'Massachusetts')

# reverse the cumulative sum of covid-19 counts and name that column new_cases
ma_nyt %<>% dplyr::group_by(county) %>% dplyr::arrange(date) %>% dplyr::mutate(new_cases = c(cases[1], diff(cases))) %>% dplyr::ungroup()

# take a weekly rolling sum of new_cases
ma_week = ma_nyt %>% dplyr::group_by(county) %>% dplyr::arrange(date) %>% dplyr::mutate(week_sum = RcppRoll::roll_sum(new_cases, 7, align = 'right', fill = NA)) %>% dplyr::ungroup()

# set minimum number of total confirmed cases to 10
ma_week %<>% dplyr::filter(cases >= 10 & !is.na(week_sum))

# remove data where county is unknown or from Martha's Vineyard or Nantucket
ma_week %<>% dplyr::filter(!county %in% c('Unknown', 'Dukes', 'Nantucket'))

# handle 0 new cases
ma_week %<>% dplyr::filter(week_sum > 0)

# save data
write.csv(ma_week, './data/ma-counties.csv', row.names = FALSE)
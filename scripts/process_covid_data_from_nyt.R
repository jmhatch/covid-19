# load NYT data
nyt_data = read_csv('./data/us-counties.csv')

# filter to get Massachusetts data
ma_nyt = nyt_data %>% filter(state == 'Massachusetts')

# reverse the cumulative sum of covid-19 counts and name that column new_cases
ma_nyt %<>% group_by(county) %>% arrange(date) %>% mutate(new_cases = c(cases[1], diff(cases))) %>% ungroup()

# take a weekly rolling sum of new_cases
ma_week = ma_nyt %>% group_by(county) %>% arrange(date) %>% mutate(week_sum = roll_sum(new_cases, 7, align = 'right', fill = NA)) %>% ungroup()

# set minimum number of total confirmed cases to 10
ma_week %<>% filter(cases >= 10 & !is.na(week_sum))

# remove data where county is unknown or from Martha's Vineyard or Nantucket
ma_week %<>% filter(!county %in% c('Unknown', 'Dukes', 'Nantucket'))

# handle 0 new cases
ma_week %<>% filter(week_sum > 0)

## save data
write.csv(ma_week, './data/ma-counties.csv', row.names = FALSE)
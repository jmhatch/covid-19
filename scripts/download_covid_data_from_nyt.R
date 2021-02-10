# download county-level aggregated data from NY Times
nyt_data = 'https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv' %>% url() %>% read_csv()

# save NYT data
write.csv(nyt_data, './data/us-counties.csv', row.names = FALSE)
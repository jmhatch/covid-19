# load libraries
library(dplyr)
library(magrittr)
library(tidyr)

# download CDC community levels
cdc_comm_data = 'https://data.cdc.gov/api/views/3nnm-4jni/rows.csv?accessType=DOWNLOAD' %>% url() %>% readr::read_csv()

# filter to get Massachusetts data
cdc_comm_ma = cdc_comm_data %>% dplyr::filter(state == 'Massachusetts' & date_updated == max(date_updated))

# remove data where county is Martha's Vineyard or Nantucket
cdc_comm_ma %<>% dplyr::filter(!county %in% c('Dukes County, MA', 'Nantucket County, MA')) %>% tidyr::separate(county, c('county', 'state_abb'), sep = ',')

# download CDC transmission levels
cdc_tran_data = 'https://data.cdc.gov/api/views/8396-v7yb/rows.csv?accessType=DOWNLOAD' %>% url() %>% readr::read_csv()

# # filter to get Massachusetts data
# cdc_tran_ma = cdc_tran_data %>% dplyr::filter(state_name == 'Massachusetts' & report_date == max(report_date))
# 
# # remove data where county is Martha's Vineyard or Nantucket
# cdc_tran_ma %<>% dplyr::filter(!county_name %in% c('Dukes County', 'Nantucket County'))

# # combine county-level data
# cdc_county = cdc_comm_ma %>%
#   dplyr::select(state, state_abb, county, date_updated, `covid-19_community_level`) %>%
#   rename(date_community = date_updated) %>%
#   left_join(cdc_tran_ma %>% dplyr::select(state_name, county_name, report_date, community_transmission_level) %>% rename(state = state_name, county = county_name, date_transmission = report_date), by = c('state', 'county'))

# save data
write.csv(cdc_tran_data, './data/cdc-ma-counties.csv', row.names = FALSE)
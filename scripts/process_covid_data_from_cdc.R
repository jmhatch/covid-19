# load libraries
library(dplyr)
library(magrittr)

# download CDC community levels
cdc_comm_data = 'https://data.cdc.gov/api/views/3nnm-4jni/rows.csv?accessType=DOWNLOAD' %>% url() %>% readr::read_csv()

# filter to get Massachusetts data
cdc_comm_ma = cdc_comm_data %>% filter(state == 'Massachusetts' & date_updated == max(date_updated))

# remove data where county is Martha's Vineyard or Nantucket
cdc_comm_ma %<>% dplyr::filter(!county %in% c('Dukes County, MA', 'Nantucket County, MA'))

# save data
write.csv(cdc_comm_ma, './data/cdc-community-ma-counties.csv', row.names = FALSE)
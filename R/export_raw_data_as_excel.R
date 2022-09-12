library(dplyr)
library(purrr)

# setwd("C:/Users/ftw712/Desktop/ukraine_stats/")

export = arrow::open_dataset("data/ua_stats.parquet") %>%
collect() %>% 
filter(!publisher_id == "e2e717bf-551a-4917-bdc9-4fa0f342c530") %>% # remove eBird
mutate(date=stringr::str_replace_all(snapshot,"occurrence_","")) %>%
mutate(date=lubridate::ymd(date)) %>%
mutate(publisher = map_chr(publisher_id,~rgbif::organizations(uuid=.x)$data$title)) %>%
mutate(war = snapshot %in% c("occurrence_20220101","occurrence_20220401","occurrence_20220701","occurrence_20220909")) %>%
mutate(war = ifelse(war,"during","before")) %>%
glimpse()

openxlsx::write.xlsx(export, 'data/export/raw_data.xlsx',overwrite=TRUE)

quit(save="no")

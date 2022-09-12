library(dplyr)
library(purrr)

setwd("C:/Users/ftw712/Desktop/ukraine_stats/data/")

d = arrow::open_dataset("ua_stats.parquet") %>%
collect() %>% 
filter(!publisher_id == "e2e717bf-551a-4917-bdc9-4fa0f342c530") %>% # remove eBird
mutate(date=stringr::str_replace_all(snapshot,"occurrence_","")) %>%
mutate(date=lubridate::ymd(date)) %>%
mutate(publisher = map_chr(publisher_id,~rgbif::organizations(uuid=.x)$data$title)) %>%
mutate(after_war = snapshot %in% c("occurrence_20220101","occurrence_20220401","occurrence_20220701")) %>%
mutate(after_war = ifelse(after_war,"after","before")) %>% 
glimpse()

d %>% 
group_by(publisher,after_war) %>% 
summarise(n_occ=max(n_occ),
n_dataset=max(n_dataset),
n_species= max(n_species)) %>% 
tidyr::pivot_wider(names_from = c(after_war), values_from = c(n_occ,n_species,n_dataset)) %>%
mutate(across(everything(), .fns = ~tidyr::replace_na(.,0))) %>%
mutate(diff_species = n_species_after - n_species_before) %>%
mutate(diff_dataset = n_dataset_after - n_dataset_before) %>%
mutate(diff_occ = n_occ_after - n_occ_before) %>%
arrange(-diff_occ,-diff_species,-diff_dataset) %>%
glimpse()

library(ggplot2)
# mutate(before = ifelse(is.na(before),0,before)) %>% 
# arrange(-difference) %>% 
# as.data.frame() 


# tidyr::spread(after_war,n_occ,n_species,n_dataset) %>% 
# d %>% select(date) %>% arrange(date) %>% unique() %>% as.data.frame()

# p = ggplot(d, aes(date, n_occ,group=publisher)) +
# geom_line() + 
# facet_wrap(~publisher)

# ggsave(plot=p,"C:/Users/ftw712/Desktop/ua_occ_ts.pdf")


# https://api.gbif.org/v1/organization/e2e717bf-551a-4917-bdc9-4fa0f342c530


# "https://analytics-files.gbif.org/country/UA/publishedBy/csv/occ.csv"

# d = readr::read_csv("C:/Users/ftw712/Desktop/ukraine_stats/data/occ.csv") %>%
# glimpse() 

# p = ggplot(d, aes(date, n_occ)) +
# geom_line() +
# facet_wrap(~publisher) 

# +
# scale_x_date(date_labels = "%b %d")
# # ggsave("C:/Users/ftw712/Desktop/ua_occ_ts.pdf")

# The date scale will attempt to pick sensible defaults for
# major and minor tick marks. Override with date_breaks, date_labels
# date_minor_breaks arguments.
# base + scale_x_date(date_labels = "%b %d")




# library(dplyr)
# library(purrr)
# library(ggplot2)

# setwd("C:/Users/ftw712/Desktop/ukraine_stats/data/")

# d = arrow::open_dataset("ua_stats.parquet") %>%
# collect() %>% 
# mutate(date=stringr::str_replace_all(snapshot,"occurrence_","")) %>%
# mutate(date=lubridate::ymd(date)) %>%
# mutate(publisher = map(publisher_id,~rgbif::organizations(uuid=.x)$data$title)) %>%
# glimpse()

# d %>% pull(publisher
# https://api.gbif.org/v1/organization/e2e717bf-551a-4917-bdc9-4fa0f342c530


# "https://analytics-files.gbif.org/country/UA/publishedBy/csv/occ.csv"

# d = readr::read_csv("C:/Users/ftw712/Desktop/ukraine_stats/data/occ.csv") %>%
# glimpse() 

# +
# facet_wrap(~publisher) 


# +
# scale_x_date(date_labels = "%b %d")
# The date scale will attempt to pick sensible defaults for
# major and minor tick marks. Override with date_breaks, date_labels
# date_minor_breaks arguments.
# base + scale_x_date(date_labels = "%b %d")





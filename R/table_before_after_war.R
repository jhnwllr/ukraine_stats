library(dplyr)
library(purrr)
library(xtable) 

# setwd("C:/Users/ftw712/Desktop/ukraine_stats/data/")

d = arrow::open_dataset("data/ua_stats.parquet") %>%
collect() %>% 
filter(!publisher_id == "e2e717bf-551a-4917-bdc9-4fa0f342c530") %>% # remove eBird
mutate(date=stringr::str_replace_all(snapshot,"occurrence_","")) %>%
mutate(date=lubridate::ymd(date)) %>%
mutate(publisher = map_chr(publisher_id,~rgbif::organizations(uuid=.x)$data$title)) %>%
mutate(after_war = snapshot %in% c("occurrence_20220101","occurrence_20220401","occurrence_20220701","occurrence_20220909")) %>%
mutate(after_war = ifelse(after_war,"after","before")) %>% 
glimpse()

export = d %>% 
group_by(publisher,publisher_id,after_war) %>% 
summarise(n_occ=max(n_occ),
n_dataset=max(n_dataset),
n_species= max(n_species)) %>% 
tidyr::pivot_wider(names_from = c(after_war), values_from = c(n_occ,n_species,n_dataset)) %>%
mutate(across(everything(), .fns = ~tidyr::replace_na(.,0))) %>%
mutate(diff_species = n_species_after - n_species_before) %>%
mutate(diff_dataset = n_dataset_after - n_dataset_before) %>%
mutate(diff_occ = n_occ_after - n_occ_before) %>%
arrange(-diff_occ,-diff_species,-diff_dataset) %>%
mutate(publisher_link = paste0('<a href="https://www.gbif.org/publisher/',publisher_id,'">link</a>')) %>%
ungroup() %>% 
mutate(n_occ_after = format(n_occ_after, nsmall = 0)) %>%
mutate(n_species_after = format(n_species_after, nsmall = 0)) %>%
mutate(n_dataset_after = format(n_dataset_after, nsmall = 0)) %>%
mutate(diff_dataset = format(diff_dataset, nsmall = 0)) %>%
mutate(diff_species = format(diff_species, nsmall = 0)) %>%
mutate(diff_occ = format(diff_occ, nsmall = 0)) %>%
select(
publisher,
n_occ = n_occ_after,
n_species = n_species_after,
n_dataset = n_dataset_after,
added_occ_after_war = diff_occ,
added_species_after_war = diff_species,
added_dataset_after_war = diff_dataset,
publisher_link) %>%
glimpse() 

## export table formats
export %>% knitr::kable() %>% writeLines("data/export/markdown.md")
print(xtable(export), type = "html", file = "data/export/before_after_war.html",sanitize.text.function = force,include.rownames=FALSE)
openxlsx::write.xlsx(export, 'data/export/before_after_war.xlsx',overwrite=TRUE)

quit(save="no")
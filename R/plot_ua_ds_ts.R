library(dplyr)
library(purrr)
library(ggplot2)
library(showtext)

setwd("C:/Users/ftw712/Desktop/ukraine_stats/")

font_add("Roboto", "Roboto-Black.ttf")
font_families()

d = arrow::open_dataset("data/ua_stats.parquet") %>%
collect() %>% 
filter(!publisher_id == "e2e717bf-551a-4917-bdc9-4fa0f342c530") %>% # remove eBird
mutate(date=stringr::str_replace_all(snapshot,"occurrence_","")) %>%
mutate(date=lubridate::ymd(date)) %>%
mutate(publisher = map_chr(publisher_id,~rgbif::organizations(uuid=.x)$data$title)) %>%
mutate(war = snapshot %in% c("occurrence_20220101","occurrence_20220401","occurrence_20220701","occurrence_20220909")) %>%
mutate(war = ifelse(war,"during","before")) %>% 
group_by(date,war) %>% 
summarise(n_dataset = sum(n_dataset)) %>%
glimpse() 

# breaks = scales::pretty_breaks(n = 5)(c(0,700000))
# labels = gbifapi::plot_label_maker(breaks,"k",1e-3)
# d$war <- factor(d$war, levels=c("before", "during"), labels=c("before","during"))
# scale_y_continuous(breaks = breaks, label = labels) +

p = ggplot(d, aes(date, n_dataset)) +
theme(text=element_text(size=16,  family="Roboto")) +
theme_bw() +
geom_line() +
geom_point(size=2.5,aes(color=war)) + 
theme(legend.position = c(0.9,0.1)) +
scale_colour_manual(values = c(
    "before" ="#231F20",  
	"during"="#E37C72"
	)) +
xlab("") + 
ylab("") +
theme(axis.text.x=element_text(face="plain",size=12)) + 
theme(axis.text.y=element_text(face="plain",size=12)) +
theme(legend.key.size = unit(0.3, "cm")) +
theme(legend.title=element_blank()) +
theme(legend.text=element_text(size=12,face="plain")) +
labs(title="",subtitle = "Ukraine", caption = "Number of datasets published by Ukraine before and during invasion.") +
theme(panel.border = element_blank()) +
theme(axis.line = element_line(color = 'black')) + 
theme(plot.subtitle=element_text(size=18))
 
ggsave(plot=p,"plots/ua_ds_ts.pdf",width=4*1.5,height=3*1.5,device=cairo_pdf)
ggsave(plot=p,"plots/ua_ds_ts.png",width=4*1.5,height=3*1.5,dpi=600)
ggsave(plot=p,"plots/ua_ds_ts.svg",width=4*1.5,height=3*1.5)


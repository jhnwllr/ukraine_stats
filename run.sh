#!/bin/bash
eval `ssh-agent -s`
ssh-add

# cd /mnt/c/Users/ftw712/Desktop/ukraine_stats/

# ssh jwaller@c5gateway-vh.gbif.org "hdfs dfs -rm -r ua_stats.parquet"
# scp -r scala/publisher_occ_counts.scala jwaller@c5gateway-vh.gbif.org:/home/jwaller/
# ssh jwaller@c5gateway-vh.gbif.org "spark2-shell -i publisher_occ_counts.scala"
# ssh jwaller@c5gateway-vh.gbif.org 'bash -s' < shell/export_parquet.sh

# download and unzip 
# rm -r data/ua_stats.parquet
# wget -O data/ua_stats.parquet.zip http://download.gbif.org/custom_download/jwaller/ua_stats.parquet.zip
# rm -r data/ua_stats.parquet
# unzip data/ua_stats.parquet.zip -d data/ua_stats.parquet
# rm -r data/ua_stats.parquet.zip

# Rscript.exe --vanilla R/table_before_after_war.R
# Rscript.exe --vanilla R/plot_ua_occ_ts.R
Rscript.exe --vanilla R/export_raw_data_as_excel.R



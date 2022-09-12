FILE_NAME="ua_stats"
rm -r  /mnt/auto/misc/download.gbif.org/custom_download/jwaller/$FILE_NAME".parquet.zip"
hadoop fs -get /user/jwaller/$FILE_NAME".parquet"  /mnt/auto/misc/download.gbif.org/custom_download/jwaller/$FILE_NAME".parquet"
hdfs dfs -rm -r $FILE_NAME".parquet"
cd /mnt/auto/misc/download.gbif.org/custom_download/jwaller/
zip -r $FILE_NAME".parquet.zip" $FILE_NAME".parquet"
rm -r  /mnt/auto/misc/download.gbif.org/custom_download/jwaller/$FILE_NAME".parquet"
exit

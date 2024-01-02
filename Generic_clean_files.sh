 
#!/bin/bash
find /home/storage/over_load/train/data0 -mtime +7 -name "*.csv" -type f | xargs rm -rf;
find /home/storage/over_load/train/data0 -mtime +7 -name "*.pcd" -type f | xargs rm -rf;
find /home/storage/over_load/train/data0 -mtime +7 -name "*.log" -type f | xargs rm -rf;
find /home/storage/over_load/train/data0 -mtime +7 -type d | xargs rm -rf;

find /home/storage/over_load/train/cut_heavy -mtime +7 -name "*.pcd" -type f | xargs rm -rf;
find /home/storage/over_load/train/cut_heavy -mtime +7 -type d | xargs rm -rf;
find /home/storage/over_load/train/cut_empty -mtime +7 -name "*.pcd" -type f | xargs rm -rf;
find /home/storage/over_load/train/cut_empty -mtime +7 -type d | xargs rm -rf;

find /home/storage/over_load/train/forecast -mtime +7 -name "*.pcd" -type f | xargs rm -rf;
find /home/storage/over_load/train/forecast -mtime +7 -type d | xargs rm -rf;

find /home/storage/over_load/train/single -mtime +7 -name "*.pcd" -type f | xargs rm -rf;
find /home/storage/over_load/train/single -mtime +7 -type d | xargs rm -rf;

find /home/storage/over_load/train/heavypcd -mtime +30 -name "*.pcd" -type f | xargs rm -rf;
find /home/storage/over_load/train/heavypcd -mtime +30 -type d | xargs rm -rf;

find /home/storage/over_load/train/emptypcd -mtime +30 -name "*.pcd" -type f | xargs rm -rf;
find /home/storage/over_load/train/emptypcd -mtime +30 -type d | xargs rm -rf;
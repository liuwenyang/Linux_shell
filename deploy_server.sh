# 
rm build/CMakeCache.txt
chmod 777 build.sh
./build.sh nx
mv dist/main /home/storage/zc/
sh /home/storage/zc/localupdate.sh -m
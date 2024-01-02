# 
rm build/CMakeCache.txt
chmod 777 build.sh
./build.sh nx
mv client/client /home/storage/zc/
/home/storage/zc/localupdate.sh -c
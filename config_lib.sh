#!/bin/bash
if [ -z "$deploy_path" ]; then
    deploy_path=/home
fi
#设置工作cup核心数
nvpmodel -m 8 && nvpmodel -q



#设置风扇转速
echo 255 > /sys/devices/pwm-fan/hwmon/hwmon2/target_pwm
echo "power ok"
#启用扩展通配符(extglob)功能
shopt -s extglob
cd $deploy_path
echo --------------开启补丁授权包设置------------
tar -zxf nx_sq.tar.gz -C /
echo --------------补丁授权包设置完成------------
echo
for zip in *.zip; do
    echo A | unzip -q "$zip"
done

echo
echo y | mv include/* /usr/local/include 1>/dev/null && echo include ok
echo y | mv include2/* /usr/include 1>/dev/null && echo include2 ok
echo y | mv bin/* /usr/local/bin 1>/dev/null && echo bin ok
echo y | mv lib/* /usr/local/lib 1>/dev/null && echo lib ok
echo y | mv lib2/* /usr/lib/aarch64-linux-gnu 1>/dev/null && echo lib2 ok
echo y | mv share/* /usr/local/share 1>/dev/null && echo share ok
mkdir -p /usr/lib/aarch64-linux-gnu/cmake/opencv4/back
#mv /usr/ lib/aarch64-linux-gnu/cmake/opencv4/OpenCV* /usr/lib/aarch64-linux-gnu/cmake/opencv4/back
mv /usr/lib/aarch64-linux-gnu/cmake/opencv4/*.cmake /usr/lib/aarch64-linux-gnu/cmake/opencv4/back && echo opencv4 ok
chmod +x /usr/local/bin/* 1>/dev/null
ldconfig
echo
#赋权
chmod 777 $deploy_path/*
chmod 777  $deploy_path/storage -R && echo --------------storage赋权完成--------------
cp $deploy_path/storage /home && echo --------------移动storage完成--------------

echo 开始卸载todesk
sudo apt-get remove todesk -y
echo

echo
echo --------------基础环境完成--------------
echo

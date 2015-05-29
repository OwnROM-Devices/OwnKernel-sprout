 #
 # Copyright © 2015, Akhil Narang "akhilnarang" <akhilnarang.1999@gmail.com>
 #
 # Custom build script for OwnKernel
 #
 # This software is licensed under the terms of the GNU General Public
 # License version 2, as published by the Free Software Foundation, and
 # may be copied, distributed, and modified under those terms.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # Please maintain this if you use this script or any part of it
 #
./colors
dir=$PWD
op=$dir/arch/arm/boot/zImage
START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'
# Modify the following variable if you want to build
export CROSS_COMPILE="/home/akhil/android/arm-cortex_a7-linux-gnueabihf-linaro_4.9.3-2015.03/bin/arm-cortex_a7-linux-gnueabihf-"
export ARCH=arm
export SUBARCH=arm
export KBUILD_BUILD_USER="akhilnarang"
export KBUILD_BUILD_HOST="Give-This-Sleepless-Laptop-A-Break"

compile_kernel ()
{
echo -e "$bldblu***********************************************"
echo "          Compiling OwnKernel          "
echo -e "***********************************************$nocol"
make sprout_defconfig
make -j12
if [ ! -e $op ]
then
echo -e "$bldred Kernel Compilation failed! Fix the errors! $nocol"
exit
fi
}

case $1 in
clean)
make clean
rm -f include/linux/autoconf.h
;;
mrproper)
make mrproper
;;
menu|menuconfig)
make sprout_defconfig menuconfig
;;
cleanbuild)
make clean mrproper
rm -f include/linux/autoconf.h
compile_kernel
;;
*)
compile_kernel
;;
esac
END=$(date +"%s")
DIFF=$(($END - $START))
echo -e "$bldcya OwnKernel Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"

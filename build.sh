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
dir=$PWD
op=$dir/arch/arm/boot/zImage
START=$(date +"%s")
red=$(tput setaf 1)             #  red
grn=$(tput setaf 2)             #  green
ylw=$(tput setaf 3)             #  yellow
blu=$(tput setaf 4)             #  blue
ppl=$(tput setaf 5)             #  purple
cya=$(tput setaf 6)             #  cyan
txtbld=$(tput bold)             #  Bold
bldred=${txtbld}$(tput setaf 1) #  red
bldgrn=${txtbld}$(tput setaf 2) #  green
bldylw=${txtbld}$(tput setaf 3) #  yellow
bldblu=${txtbld}$(tput setaf 4) #  blue
bldppl=${txtbld}$(tput setaf 5) #  purple
bldcya=${txtbld}$(tput setaf 6) #  cyan
txtrst=$(tput sgr0)             #  Reset
rev=$(tput rev)                 #  Reverse color
pplrev=${rev}$(tput setaf 5)
cyarev=${rev}$(tput setaf 6)
ylwrev=${rev}$(tput setaf 3)
blurev=${rev}$(tput setaf 4)
normal='tput sgr0'

# Modify the following variable if you want to build
export CROSS_COMPILE="/home/akhil/android/arm-cortex_a7-linux-gnueabihf-linaro_4.9.3-2015.03/bin/arm-cortex_a7-linux-gnueabihf-"
export ARCH=arm
export SUBARCH=arm
export KBUILD_BUILD_USER="akhilnarang"
export KBUILD_BUILD_HOST="Sleeply-PC"

compile_kernel ()
{
echo -e "$cyarev***********************************************"
echo "          Compiling OwnKernel          "
echo -e "***********************************************$nocol"
make sprout_defconfig
if [ "$1" == "test" ]
then
make
else
make -j8
fi
if [ ! -e $op ]
then
echo -e "$cyarev Kernel Compilation failed! Fix the errors! $nocol"
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
test)
compile_kernel test
;;
*)
compile_kernel
esac
END=$(date +"%s")
DIFF=$(($END - $START))
echo -e "$cyarev OwnKernel Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$txtrst"

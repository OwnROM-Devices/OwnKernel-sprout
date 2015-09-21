 #
 # Copyright � 2015, Akhil Narang "akhilnarang" <akhilnarang.1999@gmail.com>
 # Original by Varun Chitre
 # Heavily modified by Akhil :P
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
okzip=$dir/ownkernel
okversion="6.5"
device="sprout"
zipname="OwnKernel_$device-$okversion.zip"
START=$(date +"%s")
awesome=$(tput bold)$(tput setaf 6)
config=$device"_defconfig"
export CROSS_COMPILE="/home/akhilnarang/UBERTC/out/arm-eabi-5.2-cortex-a7/bin/arm-eabi-"
export ARCH=arm
export SUBARCH=arm
export LOCALVERSION="-OwnKernel-$okversion"

function zip_kernel ()
{
cp $op $okzip/tools/zImage
cd $okzip
zip -r9 /home/akhilnarang/android/$zipname *
cd $dir
cd /home/akhilnarang/android
if [ -e "$zipname" ]
then
while read -p "Do you want to upload zip (y/n)? " uchoice
		do
		case "$uchoice" in
		        y|Y)
		                upload-sf $zipname ownrom/sprout/OwnKernel
		                break
		                ;;
			      n|N )
		                break
		                ;;
		        * )
		                echo
		                echo "Invalid try again!"
		                echo
		                ;;
		esac
		done
else
echo -e "Error occurred"
echo -e "Zip not found"
fi
cd $dir
}

function compile_kernel ()
{
echo $awesome
echo "    )                  )                       ";
echo " ( /(               ( /(                   (   ";
echo " )\()) (  (         )\()) (  (           ( )\  ";
echo "((_)\  )\))(   (  |((_)\ ))\ )(   (     ))((_) ";
echo "  ((_)((_)()\  )\ )_ ((_)((_|()\  )\ ) /((_)   ";
echo " / _ \_(()((_)_(_/( |/ (_))  ((_)_(_/((_))| |  ";
echo "| (_) \ V  V / ' \))' </ -_)| '_| ' \)) -_) |  ";
echo " \___/ \_/\_/|_||_|_|\_\___||_| |_||_|\___|_|  ";
echo "                                               ";
echo $nocol
make $config
make -j8
END=$(date +"%s")
DIFF=$(($END - $START))
if [ -e "$op" ]
then
echo -e "$awesome OwnKernel $okversion for $device Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
zip_kernel
else
echo -e "$awesome OwnKernel $okversion for $device Build Failed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
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
esac

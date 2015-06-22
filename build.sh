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
okzip=$dir/ownkernel
okversion="4.6"
device="sprout"
START=$(date +"%s")
awesome=$(tput bold)$(tput setaf 6)

export CROSS_COMPILE="/home/akhil/android/arm-eabi-6.0/bin/arm-eabi-"
export ARCH=arm
export SUBARCH=arm
export LOCALVERSION="$okversion"

function zip_kernel ()
{
cp $op $okzip/tools/zImage
cd $okzip
zip -r9 ~/android/OwnKernel_$device-$okversion.zip *
cd $dir
}

function mka()
{
mk_timer schedtool -B -n 1 -e ionice -n 1 make -j$(cat /proc/cpuinfo | grep "^processor" | wc -l) "$@"
}

function mk_timer()
{
    local start_time=$(date +"%s")
    $@
    local ret=$?
    local end_time=$(date +"%s")
    local tdiff=$(($end_time-$start_time))
    local hours=$(($tdiff / 3600 ))
    local mins=$((($tdiff % 3600) / 60))
    local secs=$(($tdiff % 60))
    echo
    if [ $ret -eq 0 ] ; then
        echo -n -e "#### make completed successfully "
    else
        echo -n -e "#### make failed to build some targets "
    fi
    if [ $hours -gt 0 ] ; then
        printf "(%02g:%02g:%02g (hh:mm:ss))" $hours $mins $secs
    elif [ $mins -gt 0 ] ; then
        printf "(%02g:%02g (mm:ss))" $mins $secs
    elif [ $secs -gt 0 ] ; then
        printf "(%s seconds)" $secs
    fi
    echo -e " ####"
    echo
    return $ret
}


compile_kernel ()
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
make sprout_defconfig
if [ "$1" == "less" ]
then
make
elif [ "$1" == "normal" ]
then
mka
elif [ ! "$1" == "" ]
then
make $1
else
mka
fi
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
less)
compile_kernel less
;;
-j*)
compile_kernel $1
;;
*)
compile_kernel normal
esac

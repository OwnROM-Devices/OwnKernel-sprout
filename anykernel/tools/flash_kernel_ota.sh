#!/system/bin/sh
 #
 # Copyright © 2014, Varun Chitre "varun.chitre15" <varun.chitre15@gmail.com>
 #
 # Live ramdisk patching script
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
cd /data/local/tmp/tools/
dd if=/dev/block/platform/mtk-msdc.0/by-name/boot of=./boot.img
./unpackbootimg -i /data/local/tmp/tools/boot.img
./mkbootimg --kernel /data/local/tmp/tools/zImage --ramdisk /data/local/tmp/tools/boot.img-ramdisk.gz --base 0x80000000 --kernel_offset 0x00008000 --ramdisk_offset 0x04000000 --tags_offset 0x00000100 --output /data/local/tmp/newboot.img
dd if=/data/local/tmp/newboot.img of=/dev/block/platform/mtk-msdc.0/by-name/boot
rm -rf /data/local/tmp/*

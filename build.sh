#!/bin/bash

#set -e
  
clear

# auto gcc cloner/updater
echo "**** gcc Time ****"
if [ -r gcc ]; then
  echo "gcc found! check for update..."
  cd gcc
  git config pull.rebase true
  git pull
  cd ..

else
  echo "gcc not found!, git cloning it now...."
  git clone https://github.com/MNoxx74/gcc-10.2.0.git gcc

fi

## Copy this script inside the kernel directory
KERNEL_DEFCONFIG=vendor/citrus_defconfig
ANYKERNEL3_DIR=$PWD/AnyKernel3/
FINAL_KERNEL_ZIP=PornX-11++.zip
KERNELDIR=$PWD
export CROSS_COMPILE=${KERNELDIR}/gcc/bin/aarch64-elf-
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER=MNoxx74
export KBUILD_BUILD_HOST=LinuxServer
# Speed up build process
MAKE="./makeparallel"

BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'

# Clean build always lol
echo "**** Cleaning ****"
rm -rfv out
mkdir -p out
make O=out clean

echo "**** Kernel defconfig is set to $KERNEL_DEFCONFIG ****"
echo -e "$blue***********************************************"
echo "          BUILDING KERNEL          "
echo -e "***********************************************$nocol"
make $KERNEL_DEFCONFIG O=out

#make ARCH=arm64 O=out menuconfig

make -j$(nproc --all) O=out

echo "**** Verify Image.gz-dtb ****"
if [ -f out/arch/arm64/boot/Image.gz-dtb ]; then

# Anykernel 3 time!!
echo "**** Verifying AnyKernel3 Directory ****"
ls $ANYKERNEL3_DIR
echo "**** Removing leftovers ****"
rm -rf $ANYKERNEL3_DIR/Image.gz-dtb
rm -rf $ANYKERNEL3_DIR/$FINAL_KERNEL_ZIP

echo "**** Copying Image.gz-dtb ****"
cp $PWD/out/arch/arm64/boot/Image.gz-dtb $ANYKERNEL3_DIR/

echo "**** Build Kernel Zip Files ****"
cd $ANYKERNEL3_DIR/
zip -r9 $FINAL_KERNEL_ZIP * -x README $FINAL_KERNEL_ZIP

echo "**** Upload Zip Files to gdrive ****"
gdrive upload $FINAL_KERNEL_ZIP

echo "**** Done ****"

cd ..

   BUILD_END=$(date +"%s")
   DIFF=$(($BUILD_END - $BUILD_START))
   echo -e "$yellow Build PornX Kernel Completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"

else
   echo "**** Build Failed ****"
   echo "**** Removing leftovers ****"
   rm -rf out/
   BUILD_END=$(date +"%s")
   DIFF=$(($BUILD_END - $BUILD_START))
   echo -e "$red mission failed we'll get em next time, Build failed in:- $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"
fi

#!/bin/sh
#
# name     : tmuxen， tmux environment made easy
# author   : Xu Xiaodong xxdlhy@gmail.com
# license  : GPL
# created  : 2012 Jul 01
# modified : 2012 Jul 02
#

cmd=$(which tmux) # tmux path
session=init   # session name

if [ -z $cmd ]; then
  echo "You need to install tmux."
  exit 1
fi

$cmd has -t $session

if [ $? != 0 ]; then
  $cmd new -s $session -d
  $cmd rename-window -t "init:1" vim
  # $cmd neww -n vim -t $session
  tmux send -t "init:vim" "cd ~/dragon/IntrinsycDragonBoard810-AndroidBSP-MM-3.0/Source_Package/APQ8094_LA.BF64.1.2.2-01640-8x94.0_MM_V30;cd kernel;cscope -Rbkq;vim drivers/input/touchscreen/synaptics_tcm/synaptics_tcm_core.c" ENTER
  $cmd splitw -h -p 35 -t $session
  tmux send -t "init:vim" "cd ~/dragon/IntrinsycDragonBoard810-AndroidBSP-MM-3.0/Source_Package/APQ8094_LA.BF64.1.2.2-01640-8x94.0_MM_V30;source build/envsetup.sh;lunch msm8994-userdebug" ENTER "make bootimage -j4"

  $cmd splitw -v -p 35 -t $session
  tmux send -t "init:vim" "cd ~/dragon/IntrinsycDragonBoard810-AndroidBSP-MM-3.0/Source_Package/APQ8094_LA.BF64.1.2.2-01640-8x94.0_MM_V30;cd out/target/product/msm8994" ENTER "fastboot flash boot boot.img"
  $cmd splitw -v -p 35 -t $session
  tmux send -t "init:vim" "cd ~/dragon/IntrinsycDragonBoard810-AndroidBSP-MM-3.0/Source_Package/APQ8094_LA.BF64.1.2.2-01640-8x94.0_MM_V30;cd out/target/product/msm8994" ENTER "adb reboot bootloader"
  $cmd neww -n adb -t $session
  tmux send -t "init:adb" "cd ~/dragon/IntrinsycDragonBoard810-AndroidBSP-MM-3.0/Source_Package/APQ8094_LA.BF64.1.2.2-01640-8x94.0_MM_V30;cd out/target/product/msm8994" ENTER "adb wait-for-devices;adb root;adb root;adb wait-for-devices" ENTER
  $cmd neww -n git -t $session
  tmux send -t "init:adb" "cd ~/dragon/IntrinsycDragonBoard810-AndroidBSP-MM-3.0/Source_Package/APQ8094_LA.BF64.1.2.2-01640-8x94.0_MM_V30;cd kernel;git branch;git status" ENTER


  $cmd selectw -t $session:1
  $cmd selectp -t 1
fi

$cmd a -t $session

exit 0

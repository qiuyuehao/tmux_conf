#!/bin/sh
#
# name     : tmuxen， tmux environment made easy
# author   : Xu Xiaodong xxdlhy@gmail.com
# license  : GPL
# created  : 2012 Jul 01
# modified : 2012 Jul 02
#

cmd=$(which tmux) # tmux path

session=dragon   # session name

session2=syna_driver_only

session3=minicom

if [ -z $cmd ]; then
  echo "You need to install tmux."
  exit 1
fi

$cmd has -t $session

if [ $? != 0 ]; then
  $cmd new -s $session -d
  $cmd rename-window -t "dragon:1" vim
  # $cmd neww -n vim -t $session
  tmux send -t "dragon:vim" "cd ~/dragon/IntrinsycDragonBoard810-AndroidBSP-MM-3.0/Source_Package/APQ8094_LA.BF64.1.2.2-01640-8x94.0_MM_V30;cd kernel;cscope -Rbkq;vim drivers/input/touchscreen/synaptics_tcm/synaptics_tcm_core.c" ENTER
  $cmd splitw -h -p 25 -t $session
  tmux send -t "dragon:vim" "cd ~/dragon/IntrinsycDragonBoard810-AndroidBSP-MM-3.0/Source_Package/APQ8094_LA.BF64.1.2.2-01640-8x94.0_MM_V30;source build/envsetup.sh;lunch msm8994-userdebug" ENTER "make bootimage -j4"

  $cmd splitw -v -p 35 -t $session
  tmux send -t "dragon:vim" "cd ~/dragon/IntrinsycDragonBoard810-AndroidBSP-MM-3.0/Source_Package/APQ8094_LA.BF64.1.2.2-01640-8x94.0_MM_V30;cd out/target/product/msm8994" ENTER "fastboot flash boot boot.img"
  # $cmd splitw -v -p 35 -t $session
  # tmux send -t "dragon:vim" "cd ~/dragon/IntrinsycDragonBoard810-AndroidBSP-MM-3.0/Source_Package/APQ8094_LA.BF64.1.2.2-01640-8x94.0_MM_V30;cd out/target/product/msm8994" ENTER "adb reboot bootloader"
  $cmd neww -n adb -t $session
  tmux send -t "dragon:adb" "cd ~/dragon/IntrinsycDragonBoard810-AndroidBSP-MM-3.0/Source_Package/APQ8094_LA.BF64.1.2.2-01640-8x94.0_MM_V30;cd out/target/product/msm8994" ENTER "adb wait-for-devices;adb root;adb root;adb wait-for-devices" ENTER
  $cmd neww -n git -t $session
  tmux send -t "dragon:git" "cd ~/dragon/IntrinsycDragonBoard810-AndroidBSP-MM-3.0/Source_Package/APQ8094_LA.BF64.1.2.2-01640-8x94.0_MM_V30;cd kernel;git branch;git status" ENTER


  $cmd new -s $session2 -d
  $cmd rename-window -t "syna_driver_only:1" syna_tcm_1_02
  tmux send -t "syna_driver_only:syna_tcm_1_02" "cd ~/syna/tcm_1_02;cscope -Rbkq;vim kernel/drivers/input/touchscreen/synaptics_tcm/synaptics_tcm_zeroflash.c" ENTER
  $cmd neww -n syna_dsx -t $session2
  tmux send -t "syna_driver_only:syna_dsx" "cd ~/syna/synaptics_dsx_public_v2_7_0;cscope -Rbkq;vim kernel/drivers/input/touchscreen/synaptics_dsx/synaptics_dsx_core.c" ENTER

  # $cmd new -s $session3 -d
  # $cmd rename-window -t "minicom:1" ttyUSB0
  # tmux send -t "minicom:ttyUSB0" "minicom" ENTER


  $cmd selectw -t $session:1
  $cmd selectp -t 1
fi

$cmd a -t $session

exit 0

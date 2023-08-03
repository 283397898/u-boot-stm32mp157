#!/bin/bash

if [ $# -eq 1 ]
then
	if [ $1 == "help" ]
	then
		echo "usage: ./sdtools.sh /dev/sdb(blockdevice)"
		exit 1
	elif [ ! -b $1 ]
	then
		echo "device $1 :It's not a block device"
		exit
	fi
else 
	echo "usage: ./sdtools.sh /dev/sdb(blockdevice)"
	exit 1

fi

read -p "是否需要重新分区y/n? " chose
if [ $chose == "y" ]
then
	#格式化分区
	echo "*****************开始重新分区****************************"
	sudo parted -s $1  mklabel msdos
	umount /dev/$15
	umount /dev/$14
	umount /dev/$13
	umount /dev/$12
	umount /dev/$11
	sudo sgdisk --resize-table=128 -a 1 -n 1:34:545 -c 1:fsbl1 -n 2:546:1057 -c 2:fsbl2 -n 3:1058:5153 -c 3:ssbl -n 4:5154:136225 -c 4:bootfs -n 5:136226 -c 5:rootfs -A 4:set:2 -p $1 -g
	echo "*****************分区完成********************************"
elif [ $chose == "n" ]
then
	echo "*****************跳过分区********************************"
else
	echo "选择错误，请重试..."
	exit 1
fi
echo "选择烧写模式"
echo "0.basic非安全烧写"
echo "1.trusted安全烧写"
read -p "请输入你的选择> " which
if [ $which -eq 0 ]
then
	echo "****************开始basic烧写****************************"
	sudo dd if=u-boot-spl.stm32 of="$11" conv=fdatasync
	sudo dd if=u-boot-spl.stm32 of="$12" conv=fdatasync
	sudo dd if=u-boot.img  of="$13" conv=fdatasync
	echo "****************烧写完成*********************************"
elif [ $which -eq 1 ]
then 
	echo "****************开始trusted烧写**************************"
	sudo dd if=tf-a-stm32mp157a-fsmp1a-trusted.stm32 of="$11" conv=fdatasync
	sudo dd if=tf-a-stm32mp157a-fsmp1a-trusted.stm32 of="$12" conv=fdatasync
	sudo dd if=u-boot-stm32mp157a-fsmp1a-trusted.stm32  of="$13" conv=fdatasync
	echo "****************烧写完成*********************************"
else
	echo "选择错误，退出，请重试......."
	exit 1
fi

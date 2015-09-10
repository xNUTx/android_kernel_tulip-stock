#!/system/bin/sh
# *********************************************************************
# *  ____                      _____      _                           *
# * / ___|  ___  _ __  _   _  | ____|_ __(_) ___ ___ ___  ___  _ __   *
# * \___ \ / _ \| '_ \| | | | |  _| | '__| |/ __/ __/ __|/ _ \| '_ \  *
# *  ___) | (_) | | | | |_| | | |___| |  | | (__\__ \__ \ (_) | | | | *
# * |____/ \___/|_| |_|\__, | |_____|_|  |_|\___|___/___/\___/|_| |_| *
# *                    |___/                                          *
# *                                                                   *
# *********************************************************************
# * Copyright 2011 Sony Ericsson Mobile Communications AB.            *
# * All rights, including trade secret rights, reserved.              *
# *********************************************************************
#

TAG="usb"
VENDOR_ID=0FCE
#PID_PREFIX=0
#ADB_ENABLE=0

/system/bin/log -t ${TAG} -p i "init.usbmode.sh enter..."
#echo "init.usbmode.sh enter..." >> /data/alog

PID_SUFFIX_PROP=$(/system/bin/getprop ro.usb.pid_suffix)
USB_CONFIG_PROP=$(/system/bin/getprop sys.usb.config)
ENG_PROP=$(/system/bin/getprop persist.usb.eng)

/system/bin/log -t ${TAG} -p i "get ro.usb.pid_suffix= ${PID_SUFFIX_PROP}"
/system/bin/log -t ${TAG} -p i "get sys.usb.config= ${USB_CONFIG_PROP}"
/system/bin/log -t ${TAG} -p i "get persist.usb.eng= ${ENG_PROP}"
#echo "${TAG} get ro.usb.pid_suffix= ${PID_SUFFIX_PROP}" >> /data/alog
#echo "${TAG} get sys.usb.config= ${USB_CONFIG_PROP}" >> /data/alog
#echo "${TAG} get persist.usb.eng= ${ENG_PROP}" >> /data/alog

echo 0 > /sys/class/android_usb/android0/enable
echo ${VENDOR_ID} > /sys/class/android_usb/android0/idVendor

case "${USB_CONFIG_PROP}" in
    "mtp")
		echo 0${PID_SUFFIX_PROP} > /sys/class/android_usb/android0/idProduct
		echo mtp > /sys/class/android_usb/android0/functions
		setprop sys.usb.state mtp
		stop adbd
      ;;
    "mtp,adb")
		case "$ENG_PROP" in
			"1")
				#echo "USB_CONFIG_PROP=mtp,adb ENG_PROP=1" >> /data/alog
				stop adbd
				echo 5146 > /sys/class/android_usb/android0/idProduct
				echo diag > /sys/class/android_usb/android0/f_diag/clients
				echo smd,tty > /sys/class/android_usb/android0/f_serial/transports
				echo diag,adb,serial > /sys/class/android_usb/android0/functions
				start adbd
				setprop sys.usb.state mtp,adb
				#setprop sys.usb.state diag,serial_tty,serial_smd,adb
				#setprop persist.sys.usb.config diag,serial_tty,serial_smd,adb
            ;;
			*)
				#echo "USB_CONFIG_PROP=mtp,adb ENG_PROP=0" >> /data/alog
				stop adbd
				echo 5${PID_SUFFIX_PROP} > /sys/class/android_usb/android0/idProduct
				echo mtp,adb > /sys/class/android_usb/android0/functions
				start adbd
				setprop sys.usb.state mtp,adb
        ;;
		esac
    ;;
	"mass_storage")
		echo E${PID_SUFFIX_PROP} > /sys/class/android_usb/android0/idProduct
		echo mass_storage > /sys/class/android_usb/android0/functions
		setprop sys.usb.state mass_storage
		stop adbd
    ;;
	"mass_storage,adb")
		stop adbd
		echo 6${PID_SUFFIX_PROP} > /sys/class/android_usb/android0/idProduct
		echo mass_storage,adb > /sys/class/android_usb/android0/functions
		start adbd
		setprop sys.usb.state mass_storage,adb
    ;;
	"mtp,cdrom")
		echo 4${PID_SUFFIX_PROP} > /sys/class/android_usb/android0/idProduct
		echo mtp,cdrom > /sys/class/android_usb/android0/functions
		setprop sys.usb.state mtp,cdrom
		stop adbd
    ;;
        "mtp,cdrom,adb")
		echo 4${PID_SUFFIX_PROP} > /sys/class/android_usb/android0/idProduct
		echo mtp,cdrom > /sys/class/android_usb/android0/functions
		setprop sys.usb.state mtp,cdrom,adb
	    stop adbd
    ;;
    "rndis")
		echo 7${PID_SUFFIX_PROP} > /sys/class/android_usb/android0/idProduct
		echo rndis > /sys/class/android_usb/android0/functions
		setprop sys.usb.state rndis
		stop adbd
    ;;
    "rndis,adb")
		stop adbd
		echo 8${PID_SUFFIX_PROP} > /sys/class/android_usb/android0/idProduct
		echo rndis,adb > /sys/class/android_usb/android0/functions
		start adbd
		setprop sys.usb.state rndis,adb
 #   ;;
#	"diag,serial_tty,serial_smd,adb")
#		case "$ENG_PROP" in
#			"1")
#				#echo "USB_CONFIG_PROP=mtp,adb ENG_PROP=1" >> /data/alog
#				stop adbd
##				echo diag > /sys/class/android_usb/android0/f_diag/clients
	#			echo smd,tty > /sys/class/android_usb/android0/f_serial/transports
	#			echo diag,adb,serial > /sys/class/android_usb/android0/functions
#				start adbd
#				setprop sys.usb.state diag,serial_tty,serial_smd,adb
#				setprop persist.sys.usb.config diag,serial_tty,serial_smd,adb
 #           ;;
  #          *)
#				#echo "USB_CONFIG_PROP=mtp,adb ENG_PROP=0" >> /data/alog
#				stop adbd
#				echo 5${PID_SUFFIX_PROP} > /sys/class/android_usb/android0/idProduct
#				echo mtp,adb > /sys/class/android_usb/android0/functions
#				start adbd
#				setprop sys.usb.state mtp,adb
#				setprop persist.sys.usb.config mtp,adb
 #           ;;
#        esac
    ;;
    *)
		#echo "unsupported composition: ${USB_CONFIG_PROP}" >> /data/alog
		/system/bin/log -t ${TAG} -p e "unsupported composition: ${USB_CONFIG_PROP}"
    ;;
esac

echo 1 > /sys/class/android_usb/android0/enable

set_PCCmode()
{
  case $1 in
    "mtp,cdrom,adb")
		echo /system/etc/dop.iso > /sys/class/android_usb/android0/f_mass_storage/lun/file
        /system/bin/log -t ${TAG} -p i "set pcc mode with mtp,cdrom,adb mount dop.iso..."
        #echo "set pcc mode with mtp,cdrom,adb mount dop.iso..." >> /data/alog
    ;;
    "mtp,cdrom")
        echo /system/etc/dop.iso > /sys/class/android_usb/android0/f_mass_storage/lun/file
        /system/bin/log -t ${TAG} -p i "set pcc mode with mtp,cdrom mount dop.iso..."
        #echo "set pcc mode with mtp,cdrom mount dop.iso..." >> /data/alog
    ;;
    *)
        /system/bin/log -t ${TAG} -p i "Didn't mount dop.iso..."
	    #echo "Didn't mount dop.iso..." >> /data/alog
        return 1
    ;;
  esac

  return 0
}

set_PCCmode ${USB_CONFIG_PROP}

exit 0

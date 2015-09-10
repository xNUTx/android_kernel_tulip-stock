#!/system/bin/sh


if [ -e /data/ssr.conf ]; then
	ssr_conf=`cat /data/ssr.conf`
	echo ssr.conf exist.
	echo ssr_conf=$ssr_conf
else
	echo ssr.conf does not exist.
	flg_ssr_enable_debug=`getprop ro.debuggable`
	if [ "$flg_ssr_enable_debug" == "1" ]; then
		ssr_conf=0
	else
		ssr_conf=1
	fi
	echo "$ssr_conf">/data/ssr.conf
	sr_conf=`cat /data/ssr.conf`
	echo ssr_conf=$ssr_conf
fi

case "$ssr_conf" in
	"0")
		flg_ssr_restart_level=0
		flg_ssr_enable_debug=0
		flg_ssr_enable_rpm_log=0
	;;
	"1")
		flg_ssr_restart_level=1
		flg_ssr_enable_debug=0
		flg_ssr_enable_rpm_log=0
	;;
	"3")
		flg_ssr_restart_level=1
		flg_ssr_enable_debug=1
		flg_ssr_enable_rpm_log=0
	;;
	"7")
		flg_ssr_restart_level=1
		flg_ssr_enable_debug=1
		flg_ssr_enable_rpm_log=1
	;;
	*)
		echo "SSR config is not available."
		flg_ssr_restart_level=1
		flg_ssr_enable_debug=0
		flg_ssr_enable_rpm_log=0
	;;
esac

case "$flg_ssr_restart_level" in
  "0")
   echo "SSR disable."
   echo SYSTEM > /sys/bus/msm_subsys/devices/subsys0/restart_level
   echo SYSTEM > /sys/bus/msm_subsys/devices/subsys1/restart_level
   echo SYSTEM > /sys/bus/msm_subsys/devices/subsys2/restart_level
  ;;
  "1")
   echo "SSR enable."
   echo RELATED > /sys/bus/msm_subsys/devices/subsys0/restart_level
   echo RELATED > /sys/bus/msm_subsys/devices/subsys1/restart_level
   echo RELATED > /sys/bus/msm_subsys/devices/subsys2/restart_level
  ;;
  *)
   echo "Unknow SSR restart_level."
  ;;
esac

chmod 664 /dev/ramdump*

setprop subsystem_ramdump.enable $flg_ssr_enable_debug
setprop subsystem_ramdump_rpmlog.enable $flg_ssr_enable_rpm_log
setprop subsystem_restart.enable $flg_ssr_restart_level

case "$flg_ssr_enable_debug" in
  "0")
   echo "SSR ramdump disable."
   rm -r /sdcard/ramdump
  ;;
  "1")
   echo "SSR ramdump enable."
  ;;
  *)
   echo "Unknow SSR ramdump setting."
  ;;
esac


echo "SSR setting done."
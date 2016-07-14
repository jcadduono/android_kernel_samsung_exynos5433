#!/bin/bash
# simple bash script for generating dtb image

# root directory of exynos5433 kernel git repo (default is this script's location)
RDIR=$(pwd)

# directory containing cross-compile armhf toolchain
TOOLCHAIN=$HOME/build/toolchain/gcc-linaro-4.9-2016.02-x86_64_arm-linux-gnueabihf

# device dependant variables
PAGE_SIZE=2048
DTB_PADDING=0

export ARCH=arm
export CROSS_COMPILE=$TOOLCHAIN/bin/arm-linux-gnueabihf-

BDIR=$RDIR/build
OUTDIR=$BDIR/arch/$ARCH/boot
DTSDIR=$RDIR/arch/$ARCH/boot/dts
DTBDIR=$OUTDIR/dtb
DTCTOOL=$BDIR/scripts/dtc/dtc
INCDIR=$RDIR/include

ABORT()
{
	[ "$1" ] && echo "Error: $*"
	exit 1
}

[ -x "$DTCTOOL" ] || ABORT "You need to run ./build.sh first!"

[ -x "${CROSS_COMPILE}gcc" ] ||
ABORT "Unable to find gcc cross-compiler at location: ${CROSS_COMPILE}gcc"

[ "$1" ] && DEVICE=$1
[ "$2" ] && VARIANT=$2

case $DEVICE in
a8hplte)
	case $VARIANT in
	sea)
		DTSFILES="exynos5433-a8hplte_sea_open_00 exynos5433-a8hplte_sea_open_01"
		;;
	*) ABORT "Unknown variant of $DEVICE: $VARIANT" ;;
	esac
	;;
chagallhlte)
	case $VARIANT in
	kor|ktt|lgt|skt)
		DTSFILES="exynos5433-chagallhlte_kor_open_00 exynos5433-chagallhlte_kor_open_03
				exynos5433-chagallhlte_kor_open_04 exynos5433-chagallhlte_kor_open_06"
		;;
	*) ABORT "Unknown variant of $DEVICE: $VARIANT" ;;
	esac
	DTBH_PLATFORM_CODE=0x3ec3
	DTBH_SUBTYPE_CODE=0xae525f37
	;;
gts210|gts210lte)
	case $VARIANT in
	chn|zc|zn)
		DTSFILES="exynos5433-gts210_chn_open_05 exynos5433-gts210_chn_open_06"
		;;
	eur|xx)
		DTSFILES="exynos5433-gts210_eur_open_03 exynos5433-gts210_eur_open_04
				exynos5433-gts210_eur_open_05 exynos5433-gts210_eur_open_06"
		;;
	sea)
		DTSFILES="exynos5433-gts210_sea_open_05 exynos5433-gts210_sea_open_06"
		;;
	usa)
		DTSFILES="exynos5433-gts210_usa_open_03 exynos5433-gts210_usa_open_04
				exynos5433-gts210_usa_open_05 exynos5433-gts210_usa_open_06"
		;;
	spr)
		DTSFILES="exynos5433-gts210_usa_spr_06"
		;;
	vzw)
		DTSFILES="exynos5433-gts210_usa_vzw_03 exynos5433-gts210_usa_vzw_04
				exynos5433-gts210_usa_vzw_05 exynos5433-gts210_usa_vzw_06"
		;;
	ww)
		DTSFILES="exynos5433-gts210_ww_open_05 exynos5433-gts210_ww_open_06"
		;;
	*) ABORT "Unknown variant of $DEVICE: $VARIANT" ;;
	esac
	DTBH_PLATFORM_CODE=0x347e
	DTBH_SUBTYPE_CODE=0x88668650
	;;
gts210wifi)
	case $VARIANT in
	eur|xx)
		DTSFILES="exynos5433-gts210wifi_eur_open_04 exynos5433-gts210wifi_eur_open_05
				exynos5433-gts210wifi_eur_open_06"
		;;
	ww)
		DTSFILES="exynos5433-gts210wifi_ww_open_05 exynos5433-gts210wifi_ww_open_06"
		;;
	*) ABORT "Unknown variant of $DEVICE: $VARIANT" ;;
	esac
	DTBH_PLATFORM_CODE=0x347e
	DTBH_SUBTYPE_CODE=0x88668650
	;;
gts28|gts28lte)
	case $VARIANT in
	eur|xx)
		DTSFILES="exynos5433-gts28_eur_open_03 exynos5433-gts28_eur_open_05
				exynos5433-gts28_eur_open_05 exynos5433-gts28_eur_open_06
				exynos5433-gts28_eur_open_09"
		;;
	ww)
		DTSFILES="exynos5433-gts28_ww_open_05 exynos5433-gts28_ww_open_06
				exynos5433-gts28_ww_open_09"
		;;
	*) ABORT "Unknown variant of $DEVICE: $VARIANT" ;;
	esac
	DTBH_PLATFORM_CODE=0x3138
	DTBH_SUBTYPE_CODE=0x36480ee3
	;;
gts28wifi)
	case $VARIANT in
	eur|xx)
		DTSFILES="exynos5433-gts28wifi_eur_open_05 exynos5433-gts28wifi_eur_open_06"
		;;
	ww)
		DTSFILES="exynos5433-gts28wifi_ww_open_05 exynos5433-gts28wifi_ww_open_06"
		;;
	*) ABORT "Unknown variant of $DEVICE: $VARIANT" ;;
	esac
	DTBH_PLATFORM_CODE=0x3138
	DTBH_SUBTYPE_CODE=0x36480ee3
	;;
tbelte)
	case $VARIANT in
	kor)
		DTSFILES="exynos5433-tbelte_kor_open_07 exynos5433-tbelte_kor_open_09
				exynos5433-tbelte_kor_open_11 exynos5433-tbelte_kor_open_12
				exynos5433-tbelte_kor_open_14"
		;;
	*) ABORT "Unknown variant of $DEVICE: $VARIANT" ;;
	esac
	DTBH_PLATFORM_CODE=0x3ec3
	DTBH_SUBTYPE_CODE=0x3a37307e
	;;
tre3calte)
	case $VARIANT in
	kor)
		DTSFILES="exynos5433-tre3calte_kor_open_05 exynos5433-tre3calte_kor_open_14"
		;;
	*) ABORT "Unknown variant of $DEVICE: $VARIANT" ;;
	esac
	DTBH_PLATFORM_CODE=0x3ec3
	DTBH_SUBTYPE_CODE=0x3a37307e
	;;
tre|tre3g|trelte)
	case $VARIANT in
	eur|xx)
		DTSFILES="exynos5433-tre_eur_open_07 exynos5433-tre_eur_open_08
				exynos5433-tre_eur_open_09 exynos5433-tre_eur_open_10
				exynos5433-tre_eur_open_12 exynos5433-tre_eur_open_13
				exynos5433-tre_eur_open_14 exynos5433-tre_eur_open_16"
		;;
	kor|ktt|lgt|skt)
		DTSFILES="exynos5433-trelte_kor_open_06 exynos5433-trelte_kor_open_07
				exynos5433-trelte_kor_open_09 exynos5433-trelte_kor_open_11
				exynos5433-trelte_kor_open_12"
		;;
	*) ABORT "Unknown variant of $DEVICE: $VARIANT" ;;
	esac
	DTBH_PLATFORM_CODE=0x3ec3
	DTBH_SUBTYPE_CODE=0x3a37307e
	;;
trlte)
	case $VARIANT in
	eur|xx)
		DTSFILES="exynos5433-trlte_eur_open_00 exynos5433-trlte_eur_open_09
				exynos5433-trlte_eur_open_10 exynos5433-trlte_eur_open_11
				exynos5433-trlte_eur_open_12"
		;;
	*) ABORT "Unknown variant of $DEVICE: $VARIANT" ;;
	esac
	DTBH_PLATFORM_CODE=0x3ec3
	DTBH_SUBTYPE_CODE=0x3a37307e
	;;
*) ABORT "Unknown device: $DEVICE" ;;
esac

mkdir -p "$OUTDIR" "$DTBDIR"

cd "$DTBDIR" || ABORT "Unable to cd to $DTBDIR!"

rm -f ./*

echo "Processing dts files..."

for dts in $DTSFILES; do
	echo "=> Processing: ${dts}.dts"
	"${CROSS_COMPILE}cpp" -nostdinc -undef -x assembler-with-cpp -I "$INCDIR" "$DTSDIR/${dts}.dts" > "${dts}.dts"
	echo "=> Generating: ${dts}.dtb"
	$DTCTOOL -p $DTB_PADDING -i "$DTSDIR" -O dtb -o "${dts}.dtb" "${dts}.dts"
done

echo "Generating dtb.img..."
"$RDIR/scripts/dtbTool/dtbTool" -o "$OUTDIR/dtb.img" -d "$DTBDIR/" -s $PAGE_SIZE --platform $DTBH_PLATFORM_CODE --subtype $DTBH_SUBTYPE_CODE || exit 1

echo "Done."

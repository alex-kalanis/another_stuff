#!/bin/bash

# for getting next ffmpeg version:
# - download chromium snap
# :: curl -H 'Snap-Device-Series: 16' http://api.snapcraft.io/v2/snaps/info/chromium >> snap.info
# - parse that json into something readable
#   - that's the part in python - get both link and version
#   - it's stable amd64 here
# - wget passed url from there
# - mount downloaded package - it behaves as apple imac dmg image
# :: sudo mount -t squashfs -o ro obtained_package.snap ./obtained_package
# - find ffmpeg inside
# :: find obtained_package/ -print 2>/dev/null | grep libffmpeg\.so
# - copy that ffmpeg file along with version of get to storage/
# - umount package, clear everything
# if that version already exists, it ends
# if there is an error, it ends

ESCAP=$'\033'

if [ "${1}" == "-h" ]; then
    echo "$ESCAP[1;36m----------------------------------------$ESCAP[0m"
    echo "$ESCAP[1;36m Help with FFMpeg download $ESCAP[0m"
    echo "$ESCAP[1;36m----------------------------------------$ESCAP[0m"
    echo "Just run with admin rights when you need to get latest FFmpeg with necessary codecs"
    exit 0
fi

ARCHITECTURE="amd64"
SOURCE_SNAP_PATH="http://api.snapcraft.io/v2/snaps/info/chromium"
TARGET_FFMPEG_DIR="./storage/"
ERROR_CODE=0

# get info about current status
wget "--header=Snap-Device-Series: 16" "${SOURCE_SNAP_PATH}" -O snap.info
DOWNLOAD_LINK=$(./get_target_link.py snap.info "${ARCHITECTURE}") || ERROR_CODE=2
FFMPEG_VERSION=$(./get_target_version.py snap.info "${ARCHITECTURE}") || ERROR_CODE=2
TARGET_FFMPEG_PATH="${TARGET_FFMPEG_DIR}libffmpeg.so.${FFMPEG_VERSION}"

if [ ! -e "${TARGET_FFMPEG_DIR}" ]; then
    # not dir which store all available versions
    mkdir "${TARGET_FFMPEG_DIR}"
fi

if [ -e "./obtained_package" ]; then
    # leftovers from bad run
    umount ./obtained_package
    rmdir obtained_package
fi

if [ -e "${TARGET_FFMPEG_PATH}" ]; then
    # file already there
    echo "[$ESCAP[1;31mFAIL$ESCAP[0m] FFmpeg ${FFMPEG_VERSION} already there!"
    rm snap.info
    exit 1
fi

if [ ${ERROR_CODE} -ne 0 ]; then
    # something crashed in python JSON parser
    echo "[$ESCAP[1;31mFAIL$ESCAP[0m] FFmpeg ${FFMPEG_VERSION} cannot get!"
    rm snap.info
    exit ${ERROR_CODE}
fi

wget "${DOWNLOAD_LINK}" -O obtained_package.snap
mkdir obtained_package
mount -t squashfs -o ro obtained_package.snap ./obtained_package
FFMPEG_SO_PATH=$(find ./obtained_package -print 2>/dev/null | grep libffmpeg\.so)
echo "${TARGET_FFMPEG_PATH}"

cp "${FFMPEG_SO_PATH}" "${TARGET_FFMPEG_PATH}"
# need to close all tasks
sleep 2
# clear
umount ./obtained_package
rmdir obtained_package
rm obtained_package.snap snap.info

echo "[$ESCAP[32m OK $ESCAP[0m] FFmpeg ${FFMPEG_VERSION} got"

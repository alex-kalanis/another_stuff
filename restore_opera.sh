#!/bin/bash

ESCAP=$'\033'
SOURCE_FFMPEG_DIR="./storage"

if [ "${1}" == "-h" ]; then
    echo "$ESCAP[1;36m----------------------------------------$ESCAP[0m"
    echo "$ESCAP[1;36m Help with FFMpeg restoration $ESCAP[0m"
    echo "$ESCAP[1;36m----------------------------------------$ESCAP[0m"
    echo "Just run with admin rights after each update"
    exit 0
fi

if [ ! -e "${SOURCE_FFMPEG_DIR}" ]; then
    # not dir which store all available versions
    mkdir "${SOURCE_FFMPEG_DIR}"
fi

if [ "${1}" == "-l" ]; then
    echo "$ESCAP[1;36m----------------------------------------$ESCAP[0m"
    echo "$ESCAP[1;36m List available FFMpeg files $ESCAP[0m"
    echo "$ESCAP[1;36m----------------------------------------$ESCAP[0m"
    echo "As variable param just pass the rest after .so"
    echo "The default is that one without part after .so"
    echo "$ESCAP[1;36m----------------------------------------$ESCAP[0m"
    echo ""
    echo "$ESCAP[1;33m -Name- $ESCAP[0m :: $ESCAP[1;35m -size- $ESCAP[0m"
    echo "$ESCAP[1;36m----------------------------------------$ESCAP[0m"
    find "${SOURCE_FFMPEG_DIR}/lib*" -type f -print0 | xargs -0 stat -c "$ESCAP[1;33m%n$ESCAP[0m :: $ESCAP[1;35m%s$ESCAP[0m"
    exit 0
fi

SOURCE_FFMPEG_PATH="${SOURCE_FFMPEG_DIR}libffmpeg.so.${1}"
TARGET_FFMPEG_PATH="/usr/lib/x86_64-linux-gnu/opera/libffmpeg.so"

if [ ! -f "${SOURCE_FFMPEG_PATH}"  ]; then
    SOURCE_FFMPEG_PATH="${SOURCE_FFMPEG_DIR}libffmpeg.so.${2}"
fi;

if [ ! -f "${SOURCE_FFMPEG_PATH}"  ]; then
    SOURCE_FFMPEG_PATH="${SOURCE_FFMPEG_DIR}libffmpeg.so"
fi;

if [ ! -f "${SOURCE_FFMPEG_PATH}" ]; then
    echo "[$ESCAP[1;31mFAIL$ESCAP[0m] FFmpeg not found"
    exit 1
fi

if [ -f "${TARGET_FFMPEG_PATH}" ]; then
    if [ "${1}" == "-p" ]; then
        cp "${TARGET_FFMPEG_PATH}" "${TARGET_FFMPEG_PATH}.$(date +%s)"
    elif [ "${2}" == "-p" ]; then
        cp "${TARGET_FFMPEG_PATH}" "${TARGET_FFMPEG_PATH}.$(date +%s)"
    else
        rm "${TARGET_FFMPEG_PATH}"
    fi
fi;
cp "${SOURCE_FFMPEG_PATH}" "${TARGET_FFMPEG_PATH}"
echo "[$ESCAP[32m OK $ESCAP[0m] FFmpeg Rewritten"

# for getting next ffmpeg version use other script
# - run this script
# - restart Opera
# - test run on CT24

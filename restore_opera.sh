#!/bin/bash

ESCAP=$'\033'

if [ "$1" == "-h" ]; then
    echo "$ESCAP[1;36m----------------------------------------$ESCAP[0m"
    echo "$ESCAP[1;36m Help with FFMpeg restoration $ESCAP[0m"
    echo "$ESCAP[1;36m----------------------------------------$ESCAP[0m"
    echo "Just run with admin rights after each update"
    exit 0
fi

if [ "$1" == "-l" ]; then
    echo "$ESCAP[1;36m----------------------------------------$ESCAP[0m"
    echo "$ESCAP[1;36m List available FFMpeg files $ESCAP[0m"
    echo "$ESCAP[1;36m----------------------------------------$ESCAP[0m"
    echo "As variable param just pass the rest after .so"
    echo "The default is that one without part after .so"
    echo "$ESCAP[1;36m----------------------------------------$ESCAP[0m"
    echo ""
    echo "$ESCAP[1;33m -Name- $ESCAP[0m :: $ESCAP[1;35m -size- $ESCAP[0m"
    echo "$ESCAP[1;36m----------------------------------------$ESCAP[0m"
    find /usr/share/code/lib* -type f -print0 | xargs -0 stat -c "$ESCAP[1;33m%n$ESCAP[0m :: $ESCAP[1;35m%s$ESCAP[0m"
#    ls -1 /usr/share/code/libff*
    exit 0
fi

SOURCE_FFMPEG_PATH="/usr/share/code/libffmpeg.so.$1"
TARGET_FFMPEG_PATH="/usr/lib/x86_64-linux-gnu/opera/libffmpeg.so"
if [ ! -f "$SOURCE_FFMPEG_PATH"  ]; then
    SOURCE_FFMPEG_PATH="/usr/share/code/libffmpeg.so"
fi;
if [ ! -f "$SOURCE_FFMPEG_PATH" ]; then
    echo "[$ESCAP[1;31mFAIL$ESCAP[0m] FFmpeg not found"
    exit 1
fi
if [ -f "$TARGET_FFMPEG_PATH" ]; then
    rm "$TARGET_FFMPEG_PATH"
fi;
cp "$SOURCE_FFMPEG_PATH" "$TARGET_FFMPEG_PATH"
echo "[$ESCAP[32m OK $ESCAP[0m] FFmpeg Rewritten"

# for getting next ffmpeg version:
# - download chromium snap
# :: curl -H 'Snap-Device-Series: 16' http://api.snapcraft.io/v2/snaps/info/chromium >> chromium.info
# - parse that json into something readable
#   - it's stable amd64 here
# - wget passed url from there
# - mount downloaded package - it behaves as apple imac dmg image
# :: sudo mount -t squashfs -o ro XKEcBqPM06H1Z7zGOdG5fbICuf8NWK5R_1772.snap ./snap_packages
# - find ffmpeg inside
# :: sudo find / -print 2>/dev/null | grep libffmpeg\.so
# - copy that ffmpeg file along with date of get to /usr/share/code/
# - umount package
# - run this script
# - restart Opera
# - test run on CT24

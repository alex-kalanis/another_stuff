#!/bin/bash

# convert WEBM files to PNG

TEST_RUN=0

# options
if [ "${#}" != "0" ]
then
    if [ "${1}" == "-t" ]
    then
        # test run - show files
        TEST_RUN=1
    fi
fi

# find files
find . -type f -path '*.webp' -print 2>/dev/null | while read CONVERT_FILE
do
    # now for each convert to new one

    if [ ${TEST_RUN} -eq 1 ]
    then
        # test run - show files
        echo ":: *${PWD}/${CONVERT_FILE}*"
    else
        # we do not have target file
        if [ ! -f "${PWD}/${CONVERT_FILE%.*}.png" ]
        then
            echo ":: Converting *${PWD}/${CONVERT_FILE}* => *${PWD}/${CONVERT_FILE%.*}.png*"
            ffmpeg -i "${PWD}/${CONVERT_FILE}" "${PWD}/${CONVERT_FILE%.*}.png"
            # new file exists
            if [ -f "${PWD}/${CONVERT_FILE%.*}.png" ]
            then
                # now remove old one
                rm "${PWD}/${CONVERT_FILE}"
            fi
        fi
    fi
done
# must be done for each line otherwise it will split the list by the spaces - and filenames can contain spaces


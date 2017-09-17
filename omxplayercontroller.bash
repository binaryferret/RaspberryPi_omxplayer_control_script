#!/bin/bash
################################################################################
# Author:           Nathan Buckley <@binaryferret> 
#
# Description:      A simple control script that monitors the status of a 
#                   control file and depending if it's p or q will either
#                   play a video from MEDIA_DIR using omxplayer
#                   or kill the omxplayer process if it's running. 
#
#                   Created as a quick way to include adverts into change 
#                   machine demo for rPi. I thought I'd share on github
#
#                   The control file will be modified by a third party app
#                   in my case it was the change machine demo application.
#
# Last Modified:    17/09/2017
################################################################################

function handlePlay()
{
    # Find out if already running.
    if !(ps ax | grep -v grep | grep omxplayer > /dev/null); 
    then
        echo "Not Running. So Starting new video"
        count=1
        # Get next file from MEDIA_DIR that is available.
        for file in $MEDIA_DIR/*
        do            
            if [ "$FILE_AT" -eq "$count" ]
            then
                
                FILE_NAME=$file
                echo "FILE: $FILE_NAME"
            fi
            ((count++))
        done

        # Play the file with omxplayer and make sure to put onto seperate process
        # to prevent blocking of this script.
        omxplayer --no-osd -b -l 1 --aspect-mode fill $FILE_NAME&
        ((FILE_AT++))
        
        #Check that we've not gone over the amount of available files.
        if [ "$FILE_AT" -gt "$FILE_COUNT" ]
        then
            FILE_AT=1
        fi
        
    fi
}

function handleQuit()
{
    ## find out if running
    if ps ax | grep -v grep | grep omxplayer > /dev/null; 
    then
        echo "Handle Quit: Killing omxplayer process"
        ## If running then just kill the process.
        pkill omxplayer
    fi
}

# The file to play.
FILE_NAME=""

# Control file that the change machine application will modify with either
# p or q
CONTROL_FILE="controlfile.cnt"

# Media directory containing videos that omxplayer can play.
MEDIA_DIR="Media"

# Amount of files that are in MEDIA_DIR
FILE_COUNT=$(ls $MEDIA_DIR | wc -l)

# FILE Currently At.
FILE_AT=1

# On first run make sure that controlfile is q so we don't start on load.
# and we then allow change app to notify when we should start showing video.
echo "q" > $CONTROL_FILE

while true; do    
    #echo "FILE COUNT = $FILE_COUNT"
    #echo "FILE AT = $FILE_AT"
    controlChar=$(cat $CONTROL_FILE)

    case "$controlChar" in
        p)
            handlePlay
            ;;
        q)
            handleQuit
            ;;
        *)
            echo "unhandled control = $controlChar"
            ;;
    esac

    sleep 1
done

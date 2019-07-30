#!/usr/bin/bash

#kill back ground process
kill_background_process() {
    declare -r bgProcess="task6-background"
    sudo pkill -f $bgProcess
}

kill_background_process
#!/usr/bin/bash

#monitoring led with selected process and CPU/Memory
monitor_process() {
    #declare constant delay variable
    declare -r delay=5

    while getopts ':cm' opt;
    do
        case $opt in
        c)
            get_cpu_usage $2
            ;;
        m)
            get_memory_usage $2
            ;;
        ?)
            exit 7;;
        esac

        #stop process monitor for a given period
        sleep $delay

        monitor_process $1 $2

        #reset OPTIND in order to goes in getopts more than one time
        OPTIND=1
    done
}

#get cpu usage
get_cpu_usage() {
    cpuUsage=$( ps -C $1 -o "%cpu" | awk '{ sum+=$1} END {print sum}' )
    if [[ $cpuUsage > 50 ]]
    then
        ./task4.sh 1
    else
        ./task4.sh 2
    fi
}

#get memory usage
get_memory_usage() {
    memoryUsage=$( ps -C $1 -o "%mem" | awk '{ sum+=$1} END {print sum}' )
    if [[ $memoryUsage > 50 ]]
    then
        ./task4.sh 1
    else
        ./task4.sh 2
    fi
}

#initilizae monitor
init_monitor() {
    if [[ $1 == "cpu" ]]
    then
        monitor_process -c $2
    elif [[ $1 == "memory" ]]
    then
        monitor_process -m $2
    fi
}

init_monitor $1 $2

#!/usr/bin/bash

#Let user to enter the program and CPU or Memory to monitor
print_select_program_menu() {
    echo -e "\nAssociate LED with the performance of a process"
    echo "==============================================="
    echo -n "Please enter the name of the program to monitor(partial name are ok): "

    find_selected_program
}

#comfirm program to monitor and output message to user
confirm_monitor_process() {
    while true;
    do
        echo -e "\nDo you wish to\n1) Monitor memory\n2) Monitor CPU?"
        echo -n "[Enter memory or cpu]: "
        read memoryOrCpu

        if [[ ($memoryOrCpu  == 'cpu') || ($memoryOrCpu == 'memory') ]];
        then
            #declare readonly variable to hold background process name
            declare -r bgProcess="task6-background.sh"
            #kill previous monitor process if there is one
            declare -a bgProcessList=( $(ps -aux | grep "$bgProcess" | grep -v grep) )
            if [[ ${#bgProcessList[@]} -ge "1" ]]
            then
                ./task7.sh
            fi

            init_process_monitor $memoryOrCpu $1 $bgProcess &
            break
        else
            echo "Invalid, enter 'cpu' or 'memory' only!"
        fi
    done
}

#initiliaze previous monitor process
#kill previous monitor process if there is one
init_process_monitor() {
    #$1 is cpu or memory
    #$2 is the process to monitor
    #$3 is the background script name
    ./$3 $1 $2
}

#find program according to user input
find_selected_program() {
    read userChoice

    #get process name instead of the whole cmd path
    declare -a programList=( `ps -aux --sort=cmd | grep $userChoice | grep -v "grep" | awk '{print $11}' | rev | awk -F"/" '{print $1}' | rev` )

    if [[ ${#programList[@]} -le 0 ]]
    then
        echo "No program found!"
        print_select_program_menu
        return
    fi
    remove_duplicate_program "${programList[@]}"
}

#remove duplicate process that is running by the same program
remove_duplicate_program() {
    declare -a list=( "$@" )
    declare -a conflictList=();

    currentProgramIndex=0;

    for i in ${list[@]}
    do
        nextProgramIndex=$((currentProgramIndex+1))
        nextProgramName=${list[$nextProgramIndex]}

        if [[ $i != $nextProgramName ]]
        then
            conflictList+=($i)
        fi

        currentProgramIndex=$nextProgramIndex
    done

    if [[ ${#conflictList[@]} -gt 1 ]]
    then
        #output name-conflict programs
        output_conflict "${conflictList[@]}"
    else
        echo "The process will be associated with LED:[$ledName] is: [${conflictList[@]}]"
        confirm_monitor_process "${conflictList[@]}"
    fi
}

#output conflict found and let user to select which to monitor
output_conflict() {
    while true
    do
        echo -e "\nName Conflict Found!"
        echo "======================="
        echo "Name conflict detected. Do you want to monitor:"

        declare -a conflictList=( $@ )

        processIndicator=0;
        conflictCount=${#conflictList[@]}

        for i in ${conflictList[@]}
        do
            outputMsg=$((processIndicator+1))\)\ $i
            echo $outputMsg

            processIndicator=$((processIndicator+1))
        done

        outputMsg=$((conflictCount+1))\)\ "Cancel Request"
        echo $outputMsg

        get_user_input $((conflictCount+1))

        inputResult=$?

        if [[ $inputResult == $((conflictCount+1)) ]]
        then
            break
        elif [[ $inputResult != 0 ]]
        then
            confirmProgram=${conflictList[$((inputResult-1))]}
            echo "The process will be associated with LED:[$ledName] is: [$confirmProgram]"
            confirm_monitor_process $confirmProgram
            break
        fi
    done
}

print_select_program_menu

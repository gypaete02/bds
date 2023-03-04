#!/bin/sh
# bspwm-desktop-switcher. A script that allows you to navigate in the bspwm desktop history.
# Requires bspwm to be installed

check_installation() {
    # TODO
    echo ""
}

next() {
    LEN=${#HISTORY[@]}

    ((CURRENT_INDEX++))
    if [ $CURRENT_INDEX -ge $LEN ]; then
        CURRENT_INDEX=0
    fi

    switch_to CURRENT_INDEX
}

previous() {
    LEN=${#HISTORY[@]}

    ((CURRENT_INDEX--))
    if [ $CURRENT_INDEX -lt 0 ]; then
        CURRENT_INDEX=$LEN
    fi

    switch_to CURRENT_INDEX
}

confirm() {

    LEN=${#HISTORY[@]}
    NEW=( ${HISTORY[$CURRENT_INDEX]} )

    i=0
    while [ $i -lt $LEN ]; do
        if [ $i != $CURRENT_INDEX ]; then
            NEW+=( ${HISTORY[$i]} )
        fi
        ((i++))
    done

    HISTORY=( ${NEW[@]} )
    CURRENT_INDEX=0
}

parse_args() {

    case $1 in
        next|n)
            next
            ;;
        previous|p)
            previous
            ;;
        confirm|c)
            confirm
            ;;
        *)
            print_help
            ;;
    esac

}

print_help() {
    # TODO
    echo "*HELP*"
}

switch_to() {
    IDX=$1
    ID=${HISTORY[$IDX]}
    
    echo "Switching to $ID"
    # bspc -f ^$ID
}

update_history() {
    USED_DESKTOPS=(a b c) # TODO use real bspwm values 
    NEW=()
    for history in "${HISTORY[@]}"; do
        for desktop in "${USED_DESKTOPS[@]}"; do
            [ "$history" = $desktop ] && NEW+=($history) && break
        done
    done

    if [ ${#NEW[@]} -lt 2 ]; then
        DESKTOPS=(a b c d e) # TODO get real bspwm values
        NEW=( ${DESKTOPS[0] ${DESKTOPS[1]} )
    fi

    HISTORY=( ${NEW[@]} )
}

# ::::: START :::::

check_installation

# ---
if [ -z $BDS_PATH ]; then
    BDS_PATH="$HOME/.local/state/bds/"
fi

if [ ! -d $BDS_PATH ]; then
    mkdir -p $BDS_PATH
fi

STATE_FILE="${BDS_PATH}/current_state"

if [ ! -e $STATE_FILE ]; then
    touch $STATE_FILE
fi

source $STATE_FILE

if [ -z "$HISTORY" ]; then
    # TODO use real bspwm values
    declare -a HISTORY=(a b c d e)
fi

if [ -z $CURRENT_INDEX ]; then
    declare -i CURRENT_INDEX=0
fi

export HISTORY=$HISTORY
export CURRENT_INDEX=$CURRENT_INDEX

#---

update_history
parse_args "$@"

echo "# This file must not be manually edited. If the file is corrupted, please delete it entierly." > $STATE_FILE
declare -p HISTORY CURRENT_INDEX >> $STATE_FILE

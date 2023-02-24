#!/bin/sh
# bspwm-desktop-switcher. A script that allows you to navigate in the bspwm desktop history.
# Requires bspwm to be installed

check_installation() {

}

next() {

}

previous() {

}

confirm() {

}

parse_args() {

}

if [ -z $BDS_PATH ]; then
    BDS_PATH="$HOME/.local/state/bds/"
fi

if [ ! -d $BDS_PATH ]; then
    mkdir -p $BDS_PATH
fi

HISTORY_FILE="${BDS_PATH}/history"

if [ ! -e $HISTORY_FILE ]; then
    touch $HISTORY_FILE
fi

HISTORY=( $(cat $HISTORY_FILE) )



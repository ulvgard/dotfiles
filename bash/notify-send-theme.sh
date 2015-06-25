#!/bin/bash
function notify-dark {
    notify-send -h string:fgcolor:#FF0066 \
        -h string:bgcolor:#222222 \
        -t 5000 \
        "$1"
}

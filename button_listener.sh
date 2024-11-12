#!/bin/bash

CURR_DIR=$(readlink -f $(dirname $0))
USB_OUTPUT_FILE="/tmp/usb_output_for_scanner"
DEVICE_NAME="airscan:e0:Canon LiDE 400 (USB)"
SCANNER_DIR="/mnt/share/scanner/"
SCANNER_USER="yupeng"

bus_no=1

function scan_to_file() {
    timestamp=$(date +"%Y%m%d%H%M%S")
    output_file="${SCANNER_DIR}/${timestamp}.png"
    sudo --user ${SCANNER_USER} scanimage --device-name "${DEVICE_NAME}" --format png --output-file "${output_file}" --resolution 300 --mode Color
}

function check_usb_and_scan() {
    dev_no=$1
    stdbuf --output L ${CURR_DIR}/get_usb_data.sh "$bus_no" "${dev_no}" > "${USB_OUTPUT_FILE}" &
    while true; do
        cnt=$(cat ${USB_OUTPUT_FILE} | wc -l)
        if [ $cnt -ne 0 ]; then
            scan_to_file
            # kill the only background job
            kill %1
            sleep 1
            break
        fi
        sleep 0.5
    done
}

function main() {
    while true; do
        dev_no=$(lsusb | grep 'Blackwire C5220 headset' | awk '{print substr($4, 1, length($4)-1)}')
        if [ "${dev_no}" != "" ]; then
            check_usb_and_scan "${dev_no}"
        fi
        sleep 1
    done
}

main

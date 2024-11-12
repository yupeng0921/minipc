#!/bin/bash

bus_no=$1
dev_no=$2

path="/sys/kernel/debug/usb/usbmon/${bus_no}u"
filter="${bus_no}:${dev_no}"

cat $path | grep $filter

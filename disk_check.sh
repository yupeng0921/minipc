#!/bin/bash

disk_id="wwn-0x50014ee2162a5444"
disk_dev_path="/dev/disk/by-id/${disk_id}"
disk_mount_path="/mnt/share"

function do_mount()
{
    dev_path=$1
    mount_path=$2
    dev_real_path=$(readlink -f ${dev_path})

    while true; do
        mount | grep -q ${mount_path}
        if [ $? -eq 0 ]; then
            path=$(mount | grep ${mount_path} | awk '{print $1}')
            if [ "${path}" == "${dev_real_path}" ]; then
                return
            else
                umount ${mount_path}
            fi
        else
            mount ${dev_path} ${mount_path}
            return
        fi
    done
}

function do_umount()
{
    dev_path=$1
    mount_path=$2

    while true; do
        mount | grep -q ${mount_path}
        if [ $? -eq 0 ]; then
            umount ${mount_path}
        else
            return
        fi
    done
}

function disk_check()
{
    dev_path=$1
    mount_path=$2
    if [ -e ${dev_path} ]; then
        do_mount $dev_path $mount_path
    else
        do_umount $dev_path $mount_path
    fi
}

function main()
{
    disk_check $disk_dev_path $disk_mount_path
}

trap main SIGUSR1

echo $$ > /tmp/disk_check_pid

main

while true; do
    sleep infinity &
    wait
done

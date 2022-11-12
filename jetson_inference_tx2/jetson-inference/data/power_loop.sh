#!/bin/bash


while [ true ] ; do
    cat /sys/bus/i2c/drivers/ina3221x/0-0041/iio\:device1/in_power0_input
    sleep 1
    read -t 0.0005 -n 1
done



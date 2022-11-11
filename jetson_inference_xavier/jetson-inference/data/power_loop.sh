#!/bin/bash


while [ true ] ; do
    gpu=$(cat /sys/bus/i2c/drivers/ina3221x/1-0040/iio\:device0/in_power0_input)
    cpu=$(cat /sys/bus/i2c/drivers/ina3221x/1-0040/iio\:device0/in_power1_input)
    soc=$(cat /sys/bus/i2c/drivers/ina3221x/1-0040/iio\:device0/in_power2_input)
    cv=$(cat /sys/bus/i2c/drivers/ina3221x/1-0041/iio\:device1/in_power0_input)
    ddr=$(cat /sys/bus/i2c/drivers/ina3221x/1-0041/iio\:device1/in_power1_input)
    sys=$(cat /sys/bus/i2c/drivers/ina3221x/1-0041/iio\:device1/in_power2_input)
    echo $(($gpu+$cpu+$soc+$cv+$ddr+$sys))
    sleep 1
done
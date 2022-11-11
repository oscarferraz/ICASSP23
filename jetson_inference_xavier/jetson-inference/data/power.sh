#!/bin/bash

network='ResNet-18'
image='electric_guitar'
str=''
device='GPU'
prec='FP32'
batch='32'



rm SomeFile.txt
rm power_values_filtered.txt
rm power.txt



function infer() {
    if [ $prec == "FP32" ]; then
        if [ $device == "GPU" ]; then
            bash power_loop.sh 2>&1 | tee power_values.txt &
            /usr/src/tensorrt/bin/trtexec --model=/jetson-inference/data/networks/$network/$network.caffemodel --deploy=/jetson-inference/data/networks/$network/deploy.prototxt --output=prob --iterations=200 --useSpinWait --threads --loadInputs='data:/jetson-inference/data/inference/images/nps_'$image'.bin' --batch=$batch 2>&1 | tee SomeFile.txt &
        else
            bash power_loop.sh 2>&1 | tee power_values.txt &
            /usr/src/tensorrt/bin/trtexec --model=/jetson-inference/data/networks/$network/$network.caffemodel --deploy=/jetson-inference/data/networks/$network/deploy.prototxt --output=prob --iterations=200 --useSpinWait --threads --loadInputs='data:/jetson-inference/data/inference/images/nps_'$image'.bin' --useDLACore=1 --allowGPUFallback --batch=$batch 2>&1 | tee SomeFile.txt &
        fi
    else
       if [ $device == "GPU" ]; then
            bash power_loop.sh 2>&1 | tee power_values.txt &
            /usr/src/tensorrt/bin/trtexec --model=/jetson-inference/data/networks/$network/$network.caffemodel --deploy=/jetson-inference/data/networks/$network/deploy.prototxt --output=prob --iterations=200 --useSpinWait --threads --loadInputs='data:/jetson-inference/data/inference/images/nps_'$image'.bin' --fp16 --batch=$batch 2>&1 | tee SomeFile.txt &
        else
            bash power_loop.sh 2>&1 | tee power_values.txt &
            /usr/src/tensorrt/bin/trtexec --model=/jetson-inference/data/networks/$network/$network.caffemodel --deploy=/jetson-inference/data/networks/$network/deploy.prototxt --output=prob --iterations=200 --useSpinWait --threads --loadInputs='data:/jetson-inference/data/inference/images/nps_'$image'.bin' --fp16 --useDLACore=1 --allowGPUFallback --batch=$batch 2>&1 | tee SomeFile.txt &
        fi
    fi

    wait -n
    pkill -P $$

    echo "$image" >> power_values_filtered.txt
    

    python3 mean.py

    rm SomeFile.txt
    rm power_values.txt
}

function img(){

    image='acoustic_guitar'
    str='acoustic guitar'
    infer

    image='backpack'
    str='backpack'
    infer

  
    image='baseball'
    str='baseball'
    infer

    image='chair'
    str='folding chair'
    infer

    image='electric_guitar'
    str='electric guitar'
    infer

    image='guac'
    str='guacamole'
    infer

    image='keyboard'
    str='computer keyboard'
    infer

    image='mouse'
    str='mouse'
    infer

    image='mug'
    str='coffee mug'
    infer

    image='screwdriver'
    str='screwdriver'
    infer


}

function printer(){


    echo "$network $device $prec batch $batch" >> power.txt
    echo "$network $device $prec batch $batch" >> power_values_filtered.txt
    echo "" >> power.txt
    echo "" >> power_values_filtered.txt
    img
    echo "" >> power.txt
    echo "" >> power_values_filtered.txt


}

batch=1


network='AlexNet'
device='GPU'
prec='FP32'
printer

network='AlexNet'
device='DLA'
prec='FP32'
printer

network='AlexNet'
device='GPU'
prec='FP16'
printer

network='AlexNet'
device='DLA'
prec='FP16'
printer

network='GoogleNet'
device='GPU'
prec='FP32'
printer

network='GoogleNet'
device='DLA'
prec='FP32'
printer

network='GoogleNet'
device='GPU'
prec='FP16'
printer

network='GoogleNet'
device='DLA'
prec='FP16'
printer

network='SqueezeNet'
device='GPU'
prec='FP32'
printer

network='SqueezeNet'
device='DLA'
prec='FP32'
printer

network='SqueezeNet'
device='GPU'
prec='FP16'
printer

network='SqueezeNet'
device='DLA'
prec='FP16'
printer


network='ResNet-18'
device='GPU'
prec='FP32'
printer

network='ResNet-18'
device='DLA'
prec='FP32'
printer

network='ResNet-18'
device='GPU'
prec='FP16'
printer

network='ResNet-18'
device='DLA'
prec='FP16'
printer






network='ResNet-50'
device='GPU'
prec='FP32'
printer

network='ResNet-50'
device='DLA'
prec='FP32'
printer

network='ResNet-50'
device='GPU'
prec='FP16'
printer

network='ResNet-50'
device='DLA'
prec='FP16'
printer





network='ResNet-101'
device='GPU'
prec='FP32'
printer

network='ResNet-101'
device='DLA'
prec='FP32'
printer

network='ResNet-101'
device='GPU'
prec='FP16'
printer

network='ResNet-101'
device='DLA'
prec='FP16'
printer





network='ResNet-152'
device='GPU'
prec='FP32'
printer

network='ResNet-152'
device='DLA'
prec='FP32'
printer

network='ResNet-152'
device='GPU'
prec='FP16'
printer


network='ResNet-152'
device='DLA'
prec='FP16'
printer




network='VGG-16'
device='GPU'
prec='FP32'
printer

network='VGG-16'
device='DLA'
prec='FP32'
printer

network='VGG-16'
device='GPU'
prec='FP16'
printer


network='VGG-16'
device='DLA'
prec='FP16'
printer




network='VGG-19'
device='GPU'
prec='FP32'
printer

network='VGG-19'
device='DLA'
prec='FP32'
printer

network='VGG-19'
device='GPU'
prec='FP16'
printer

network='VGG-19'
device='DLA'
prec='FP16'
printer





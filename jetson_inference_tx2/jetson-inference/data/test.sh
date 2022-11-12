#!/bin/bash
#bash test_power.sh 2>&1 | tee power_values.txt &
#/usr/src/tensorrt/bin/trtexec --model=/jetson-inference/data/networks/ResNet-18/ResNet-18.caffemodel --deploy=/jetson-inference/data/networks/ResNet-18/deploy.prototxt --output=prob --iterations=2000 --useSpinWait --threads --loadInputs=data:/jetson-inference/data/inference/images/nps_screwdriver.bin --batch=1 2>&1 | tee SomeFile.txt &

#wait -n
#pkill -P $$



#!/bin/bash

network='ResNet-18'
image='electric_guitar'
str=''
device='GPU'
prec='FP32'
batch='32'


rm t.txt
rm SomeFile.txt
rm log.txt



function infer() {
    if [ $prec == "FP32" ]; then
        bash power_loop.sh 2>&1 | tee power_values.txt &
        /usr/src/tensorrt/bin/trtexec --model=/jetson-inference/data/networks/$network/$network.caffemodel --deploy=/jetson-inference/data/networks/$network/deploy.prototxt --output=prob --iterations=20 --useSpinWait --threads --loadInputs='data:/jetson-inference/data/inference/images/nps_'$image'.bin' --batch=$batch 2>&1 | tee SomeFile.txt
    else
        /usr/src/tensorrt/bin/trtexec --model=/jetson-inference/data/networks/$network/$network.caffemodel --deploy=/jetson-inference/data/networks/$network/deploy.prototxt --output=prob --iterations=20 --useSpinWait --threads --loadInputs='data:/jetson-inference/data/inference/images/nps_'$image'.bin' --fp16 --batch=$batch 2>&1 | tee SomeFile.txt
    fi


    echo "$image" >> log.txt
    echo "" >> throughput.txt

    grep 'throughput' SomeFile.txt &>> t.txt
    awk '{print $4}' t.txt &>> throughput.txt

    awk '{print $0}' t.txt &>> log.txt
    grep "\[E\]" SomeFile.txt &>> t.txt

    rm t.txt
    rm SomeFile.txt
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

batch=1


network='ResNet-18'
device='GPU'
prec='FP32'

echo "$network $device $prec batch $batch" >> throughput.txt
echo "$network $device $prec batch $batch" >> log.txt
echo "" >> throughput.txt
echo "" >> log.txt
img
echo "" >> throughput.txt
echo "" >> log.txt


network='ResNet-18'
device='GPU'
prec='FP16'

echo "$network $device $prec batch $batch" >> throughput.txt
echo "$network $device $prec batch $batch" >> log.txt
echo "" >> throughput.txt
echo "" >> log.txt
img
echo "" >> throughput.txt
echo "" >> log.txt


network='ResNet-50'
device='GPU'
prec='FP32'

echo "$network $device $prec batch $batch" >> throughput.txt
echo "$network $device $prec batch $batch" >> log.txt
echo "" >> throughput.txt
echo "" >> log.txt
img
echo "" >> throughput.txt
echo "" >> log.txt


network='ResNet-50'
device='GPU'
prec='FP16'

echo "$network $device $prec batch $batch" >> throughput.txt
echo "$network $device $prec batch $batch" >> log.txt
echo "" >> throughput.txt
echo "" >> log.txt
img
echo "" >> throughput.txt
echo "" >> log.txt

network='ResNet-101'
device='GPU'
prec='FP32'

echo "$network $device $prec batch $batch" >> throughput.txt
echo "$network $device $prec batch $batch" >> log.txt
echo "" >> throughput.txt
echo "" >> log.txt
img
echo "" >> throughput.txt
echo "" >> log.txt


network='ResNet-101'
device='GPU'
prec='FP16'

echo "$network $device $prec batch $batch" >> throughput.txt
echo "$network $device $prec batch $batch" >> log.txt
echo "" >> throughput.txt
echo "" >> log.txt
img
echo "" >> throughput.txt
echo "" >> log.txt

network='ResNet-152'
device='GPU'
prec='FP32'

echo "$network $device $prec batch $batch" >> throughput.txt
echo "$network $device $prec batch $batch" >> log.txt
echo "" >> throughput.txt
echo "" >> log.txt
img
echo "" >> throughput.txt
echo "" >> log.txt


network='ResNet-152'
device='GPU'
prec='FP16'

echo "$network $device $prec batch $batch" >> throughput.txt
echo "$network $device $prec batch $batch" >> log.txt
echo "" >> throughput.txt
echo "" >> log.txt
img
echo "" >> throughput.txt
echo "" >> log.txt

network='VGG-16'
device='GPU'
prec='FP32'

echo "$network $device $prec batch $batch" >> throughput.txt
echo "$network $device $prec batch $batch" >> log.txt
echo "" >> throughput.txt
echo "" >> log.txt
img
echo "" >> throughput.txt
echo "" >> log.txt


network='VGG-16'
device='GPU'
prec='FP16'

echo "$network $device $prec batch $batch" >> throughput.txt
echo "$network $device $prec batch $batch" >> log.txt
echo "" >> throughput.txt
echo "" >> log.txt
img
echo "" >> throughput.txt
echo "" >> log.txt

network='VGG-19'
device='GPU'
prec='FP32'

echo "$network $device $prec batch $batch" >> throughput.txt
echo "$network $device $prec batch $batch" >> log.txt
echo "" >> throughput.txt
echo "" >> log.txt
img
echo "" >> throughput.txt
echo "" >> log.txt


network='VGG-19'
device='GPU'
prec='FP16'

echo "$network $device $prec batch $batch" >> throughput.txt
echo "$network $device $prec batch $batch" >> log.txt
echo "" >> throughput.txt
echo "" >> log.txt
img
echo "" >> throughput.txt
echo "" >> log.txt

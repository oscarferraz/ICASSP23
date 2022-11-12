#!/bin/bash

network='ResNet-18'
image='electric_guitar'
str=''
rm t.txt
rm t2.txt
rm SomeFile.txt
rm log.txt



function acc() {
    ./imagenet /jetson-inference/data/inference/images/nps_$image.png /jetson-inference/data/inference/images/output/out.png --model=/jetson-inference/data/networks/$network/$network.caffemodel --prototxt=/jetson-inference/data/networks/$network/deploy.prototxt --labels=/jetson-inference/data/inference/synset_words.txt --input-blob='data' --output-blob='prob' --headless 2>&1 | tee SomeFile.txt
    grep "$str" SomeFile.txt &>> t.txt
    if grep 'imagenet' t.txt
    then 
    grep 'imagenet' t.txt &>> t2.txt
    awk '{print substr($2, 1, length($2)-1)}' t2.txt &>> accuracy.txt
    awk '{print $0}' t2.txt &>> log.txt
    else
    grep  "$str" t.txt &>> t2.txt
    awk '{$4=$4*100; print $4}' t2.txt &>> accuracy.txt
    awk '{print $0}' t2.txt &>> log.txt
    fi

    rm t.txt
    rm t2.txt
    rm SomeFile.txt
}

function img(){

    image='acoustic_guitar'
    str='acoustic guitar'
    acc
    image='backpack'
    str='backpack'
    acc
    image='baseball'
    str='baseball'
    acc
    image='chair'
    str='folding chair'
    acc
    image='electric_guitar'
    str='electric guitar'
    acc
    image='guac'
    str='guacamole'
    acc

    image='keyboard'
    str='computer keyboard'
    acc

    image='mouse'
    str='mouse'
    acc
    image='mug'
    str='coffee mug'
    acc
    image='screwdriver'
    str='screwdriver'
    acc


}

echo "$network" >> accuracy.txt
echo "" >> accuracy.txt
img
echo "" >> accuracy.txt


network='ResNet-50'
echo "$network" >> accuracy.txt
echo "" >> accuracy.txt
img
echo "" >> accuracy.txt


network='ResNet-101'
echo "$network" >> accuracy.txt
echo "" >> accuracy.txt
img
echo "" >> accuracy.txt

network='ResNet-152'
echo "$network" >> accuracy.txt
echo "" >> accuracy.txt
img
echo "" >> accuracy.txt

network='VGG-16'
echo "$network" >> accuracy.txt
echo "" >> accuracy.txt
img
echo "" >> accuracy.txt

network='VGG-19'
echo "$network" >> accuracy.txt
echo "" >> accuracy.txt
img
echo "" >> accuracy.txt



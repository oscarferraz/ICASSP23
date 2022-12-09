# Benchmarking Convolutional Neural Network Inference on Low-Power Edge Devices

### Introduction

This repo contains the code and results for paper submitted at 2023 IEEE International Conference on Acoustics, Speech, and Signal Processing (ICASSP23).

<!--If you use these models in your research, please cite:

	@article{He2015,
		author = {Kaiming He and Xiangyu Zhang and Shaoqing Ren and Jian Sun},
		title = {Deep Residual Learning for Image Recognition},
		journal = {arXiv preprint arXiv:1512.03385},
		year = {2015}
	}

S. Subramaniyan et al., "Enabling High-Level Design Strategies for High-Throughput and Low-power NB-LDPC Decoders," in IEEE Design & Test, 2022, doi: 10.1109/MDAT.2022.3202852. https://ieeexplore.ieee.org/document/9869892-->
Please cite my work if this code or this papers are useful for you.

<!--I might release a cleaner version of this some time in the future, but probably not, because I'm working on other stuff now.

Good luck!-->

### Networks and hardware

The following networks were used in this work:

    - AlexNet
    - GoogleNetV1
    - SqueezeNet
    - ResNet-18
    - ResNet-50
    - ResNet-101
    - ResNet-152
    - VGG-16
    - VGG-19

All of these networks can be found at https://drive.google.com/drive/folders/1rdBGUq4RYoNh70cXGpIehNTI-j27ZM6g?usp=sharing

The inference was executed in:

    - Intel Movidius neural compute stick (NCS)
    - Nvidia Jetson Nano
    - Nvidia Jetson TX2
    - Nvidia Jetson Xavier

### How to run

The ncappzoo contain the file to run in NCS. To compile the model, run the makefile at ncappzoo/networks/*network* where *network* is the selected network. These makefiles have option to select the precision. These makefiles will run a simple classifier producing the accuracy for a defined set of images.
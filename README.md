# python3-opencv3
Docker image with OpenCV3 and its python3 bindings for X86-64. Python version is 3.4.

This contains support for mostly everything in X86 OpenCV, minus specialized hardware (gigE, ieee1394 etc.) and specialized software (Matlab etc.) bindings. 

GUI support is NOT included (but it's easy to add)

Note that everything is installed from Debian repositories, so stuff (`ffmpeg`, `nvidia-*`, ...) is probably out of date! This can be changed later using authoritative sources such as ffmpeg static builds.


## CUDA
CUDA support is spotty/untested. Specifics of successful CUDA support usually depends on the hardware (Amazon EC2, ...) being used.

CUDA support is enabled in `build.sh` as `USECUDA=ON|OFF ./build.sh`.

It does NOT include for CUDNN deep learning (But, CUDNN is a drop-in replacement for OpenCV DNN module which is not itself an OpenCV module!).
See http://docs.opencv.org/3.1.0/d6/d0f/group__dnn.html, https://github.com/gw0/docker-debian-cuda/blob/master/Dockerfile and http://www.pyimagesearch.com/2016/07/04/how-to-install-cuda-toolkit-and-cudnn-for-deep-learning/ for setup instructions

## Further reading
https://github.com/BVLC/caffe/wiki/Ubuntu-16.04-or-15.10-OpenCV-3.1-Installation-Guide
https://hub.docker.com/r/gw000/debian-cuda/
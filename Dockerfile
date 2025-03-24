FROM ubuntu:24.04                              

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \   
    && apt-get -y install --no-install-recommends \
       git cmake g++ ninja-build openmpi-bin libopenmpi-dev python3 python3-pip python3-dev \ 
       libboost-test-dev libboost-serialization-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY . /workspaces/mpihelloworld

WORKDIR /workspaces/mpihelloworld 

# ENV OMPI_MCA_btl_vader_single_copy_mechanism=none
ENV OMPI_ALLOW_RUN_AS_ROOT=1  
ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1   

RUN cmake --preset default \               
    && cmake --build --preset default \   
    && ctest --preset default \               
    && cmake --build --preset default -t install \ 
    && rm -rf build                         
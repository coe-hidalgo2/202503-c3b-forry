# Stage 1: Build
FROM ubuntu:24.04 AS builder                            

# Update package lists and install build dependencies
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \  
    && apt-get -y install --no-install-recommends \
       git cmake g++ ninja-build openmpi-bin libopenmpi-dev \
       python3 python3-pip python3-dev \
       libboost-test-dev libboost-serialization-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*          

# Copy the application source code into the builder stage
COPY . /workspaces/mpihelloworld                         

# Set the working directory for the build
WORKDIR /workspaces/mpihelloworld                        

# Set environment variables for MPI to allow root execution (common in containers)
ENV OMPI_ALLOW_RUN_AS_ROOT=1                             
ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1                     

# Configure, build, test, and install the application using CMake presets
RUN cmake --preset default      \                        
    && cmake --build --preset default                  \
    && ctest --preset default                          \
    && cmake --build --preset default -t install        \ 
    && rm -rf build                                     

# Stage 2: Runtime
FROM ubuntu:24.04 AS runtime                             

# Install runtime dependencies (only what's needed to run the application)
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \  
    && apt-get -y install --no-install-recommends           \
       openmpi-bin libopenmpi3t64                           \
       libboost-test1.83.0 libboost-serialization1.83.0     \
       python3 python3-pip python3-dev                      \
    && apt-get clean && rm -rf /var/lib/apt/lists/*          

# Copy the installed application from the builder stage
COPY --from=builder /usr/local /usr/local               

# Optionally, copy additional runtime files if needed
# COPY --from=builder /workspaces/mpihelloworld/config /config

# Set the working directory (if needed)
WORKDIR /workspaces/mpihelloworld                       

ENV OMPI_ALLOW_RUN_AS_ROOT=1                             
ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1
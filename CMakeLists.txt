cmake_minimum_required(VERSION 3.10)
project(MPIHelloWorld LANGUAGES CXX VERSION 1.0.0)

# Set the C++ standard to C++20
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find the MPI package
find_package(MPI REQUIRED)

# Fetch boost-mpi3 (header-only library)
include(FetchContent)
FetchContent_Declare(bmpi3 GIT_REPOSITORY https://gitlab.com/correaa/boost-mpi3.git) 
FetchContent_MakeAvailable(bmpi3)

# Fetch boost::ut (header-only testing framework)
FetchContent_Declare(
    ut
    GIT_REPOSITORY https://github.com/boost-ext/ut.git
    GIT_TAG master  
)
FetchContent_MakeAvailable(ut)

add_subdirectory(myapp)
enable_testing()
add_subdirectory(tests)

# package application
set(CPACK_PACKAGE_NAME "mpihelloworld")
set(CPACK_PACKAGE_VENDOR "Cemosis")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "MPIHelloWorld")
set(CPACK_PACKAGE_VERSION "1.0.0")
set(CPACK_PACKAGE_VERSION_MAJOR "1")
set(CPACK_PACKAGE_VERSION_MINOR "0")
set(CPACK_PACKAGE_VERSION_PATCH "0")
set(CPACK_PACKAGE_INSTALL_DIRECTORY "MPIHelloWorld")
set(CPACK_PACKAGE_EXECUTABLES "MPIHelloWorld" "MPIHelloWorld")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")
set(CPACK_RESOURCE_FILE_README "${CMAKE_CURRENT_SOURCE_DIR}/README.adoc")
set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}")
# ignore
set(CPACK_IGNORE_FILES "/build/;/.git/;/.gitignore;/.gitmodules;/.gitlab-ci.yml;/.gitattributes;/.gitlab/;/.github")
set(CPACK_GENERATOR "TGZ;ZIP")
include(CPack)

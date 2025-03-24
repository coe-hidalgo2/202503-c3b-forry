# Create an executable target for our MPI application
add_executable(myapp main.cpp)

# Add include directories for boost-mpi3 and boost::ut
target_include_directories(myapp PRIVATE 
    ${bmpi3_SOURCE_DIR}/include
    ${ut_SOURCE_DIR}/include
)

# Link the MPI C++ libraries to our executable
target_link_libraries(myapp PRIVATE bmpi3)

# install myapp

install(TARGETS myapp
    RUNTIME DESTINATION bin
)
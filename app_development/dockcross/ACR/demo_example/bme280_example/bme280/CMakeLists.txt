cmake_minimum_required (VERSION 3.0)
project (bme_project)

# The demonstration uses C99 but it could just as easily be a C++ application
set(CMAKE_C_FLAGS "-g -Wall -Wextra -pedantic --std=c11 -D_DEFAULT_SOURCE -D_BSD_SOURCE ${CMAKE_C_FLAGS}")

# Create a variable that holds the path to our libwiringPi.so file
set (WPI_PATH /work/BMEBuild/wiringPi/wiringPi)

# Add the local ‘include’ directory and the wiringPi directory to grab headers
include_directories (${WPI_PATH})
include_directories(./src/)

# Actually find the wiringPi library object
# find_library(WPI_LIB wiringPi HINTS ${WPI_PATH} NO_CMAKE_FIND_ROOT_PATH)
find_library(WPI_LIB wiringPi HINTS ${WPI_PATH} NO_CMAKE_FIND_ROOT_PATH)

# Alert the user if we do not find it
#if(NOT WPI_LIB)
# message(FATAL_ERROR “wiringPi library not found”)
#endif()
# Add all the *.c files in our source directory to our executable output

FILE(GLOB SRC_FILES src/*.c)

add_executable(bme_project ${SRC_FILES})

# Link the pre-compiled wiringPi library to the executable we just declared 
target_link_libraries(bme_project ${WPI_LIB} m)
project(rdom_input_aottest)

cmake_minimum_required(VERSION 3.1.3)

set(CMAKE_VERBOSE_MAKEFILE ON)

set(HALIDE_DISTRIB_DIR "C:/Users/vagrant/Documents/halide-sandbox/project/tutorial/halide_generator")
#set(HALIDE_SYSTEM_LIBS "bof")
#set(HALIDE_COMPILER_LIB "lib")

# halide.cmake defaults to using the shared-library version of libHalide;
# we can make it prefer the static-library version by setting this:
#set(HALIDE_DISTRIB_USE_STATIC_LIBRARY TRUE)

include("${HALIDE_DISTRIB_DIR}/halide.cmake")

#SET(${PROJECT_NAME}_HEADERS
#)

#SET(${PROJECT_NAME}_SOURCES
  #tools/halide/GenGen.cpp
  #rdom_input_generator.cpp
  #rdom_input_aottest.cpp
#)
#set(CMAKE_INSTALL_PREFIX "C:/Users/vagrant/Documents/halide-sandbox/project/tutorial/halide_generator")

#LINK_DIRECTORIES(lib)

ADD_EXECUTABLE(${PROJECT_NAME} "rdom_input_aottest.cpp")

set_target_properties(${PROJECT_NAME} PROPERTIES CXX_STANDARD 11 CXX_STANDARD_REQUIRED YES CXX_EXTENSIONS NO)
target_include_directories(${PROJECT_NAME} PRIVATE include tools)


string(REPLACE "_generator.cpp" "" GEN_NAME "rdom_input_generator.cpp")

#halide_library("${GEN_NAME}" SRCS rdom_input_generator.cpp)
halide_generator(rdom_input.generator SRCS rdom_input_generator.cpp)
#halide_library_from_generator(rdom_input GENERATOR rdom_input.generator)
target_link_libraries(${PROJECT_NAME} PUBLIC "${GEN_NAME}")

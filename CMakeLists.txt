project(rdom_input_aottest)

cmake_minimum_required(VERSION 3.1.3)

set(CMAKE_VERBOSE_MAKEFILE ON)

set(HALIDE_DISTRIB_DIR "C:/Users/vagrant/Documents/halide-sandbox/project/tutorial/halide_generator")
#set(HALIDE_SYSTEM_LIBS "C:/Users/vagrant/Documents/llvm-7.0.0.src/build/Debug/lib/")
#set(HALIDE_COMPILER_LIB "lib")

# halide.cmake defaults to using the shared-library version of libHalide;
# we can make it prefer the static-library version by setting this:
set(HALIDE_DISTRIB_USE_STATIC_LIBRARY TRUE)

#find_package(LLVM REQUIRED CONFIG)



message("HALIDE_SYSTEM_LIBS_RAW ds cmakelists ${HALIDE_SYSTEM_LIBS_RAW}")

message("Halide system libs dans le cmakelists ${HALIDE_SYSTEM_LIBS}")

set(LLVM_TOOLS_BINARY_DIR "C:/Users/vagrant/Documents/llvm-7.0.0.src/build/Debug/bin/")
file(TO_NATIVE_PATH "${LLVM_TOOLS_BINARY_DIR}/llvm-config${CMAKE_EXECUTABLE_SUFFIX}" LLVM_CONFIG)

# LLVM doesn't appear to expose --system-libs via its CMake interface,
# so we must shell out to llvm-config to find this info
execute_process(COMMAND ${LLVM_CONFIG} --system-libs --link-static OUTPUT_VARIABLE HALIDE_SYSTEM_LIBS_RAW)
message("Halide LLVM_CONFIG ${HALIDE_SYSTEM_LIBS_RAW}")
string(STRIP "${HALIDE_SYSTEM_LIBS_RAW}" HALIDE_SYSTEM_LIBS_RAW)  # strip whitespace from start & end
string(REPLACE " " ";" HALIDE_SYSTEM_LIBS "${HALIDE_SYSTEM_LIBS_RAW}")  # convert into a list
#"if("${HALIDE_SYSTEM_LIBS}" STREQUAL "")
  # It's theoretically possible that this could be legitimately empty,
  # but in practice that doesn't really happen, so we'll assume it means we
  # aren't configured correctly.
 # message(WARNING "'llvm-config --system-libs --link-static' is empty; this is possibly wrong.")
#endif()
message("HALIDE_SYSTEM_LIBS_RAW apres le strip ${HALIDE_SYSTEM_LIBS_RAW}")
message("voila avant include ${HALIDE_SYSTEM_LIBS}")
include("${HALIDE_DISTRIB_DIR}/halide.cmake")

#set(HALIDE_SYSTEM_LIBS ${HALIDE_SYSTEM_LIBS_RAW})
message("voila apres include ${HALIDE_SYSTEM_LIBS}")

#SET(${PROJECT_NAME}_HEADERS
#)

#SET(${PROJECT_NAME}_SOURCES
  #tools/halide/GenGen.cpp
  #rdom_input_generator.cpp
  #rdom_input_aottest.cpp
#)
#set(CMAKE_INSTALL_PREFIX "C:/Users/vagrant/Documents/halide-sandbox/project/tutorial/halide_generator")

#LINK_DIRECTORIES("C:/Program Files (x86)/Windows Kits/8.0/Lib/win8/um/x64")

ADD_EXECUTABLE(${PROJECT_NAME} "rdom_input_aottest.cpp")

set_target_properties(${PROJECT_NAME} PROPERTIES CXX_STANDARD 11 CXX_STANDARD_REQUIRED YES CXX_EXTENSIONS NO)
target_include_directories(${PROJECT_NAME} PRIVATE include tools)


string(REPLACE "_generator.cpp" "" GEN_NAME "rdom_input_generator.cpp")

#halide_library("${GEN_NAME}" SRCS rdom_input_generator.cpp)
halide_generator(rdom_input.generator SRCS rdom_input_generator.cpp)
halide_library_from_generator(rdom_input GENERATOR rdom_input.generator)
target_link_libraries(${PROJECT_NAME} PUBLIC "${GEN_NAME}")

cmake_minimum_required(VERSION 3.0)
project(rdom_input_aottest)

set(HALIDE_DISTRIB_DIR "C:/Users/vagrant/Documents/halide-sandbox/project/tutorial/halide_generator")
set(HALIDE_SYSTEM_LIBS "rdom_input")
#set(HALIDE_COMPILER_LIB "lib")

# halide.cmake defaults to using the shared-library version of libHalide;
# we can make it prefer the static-library version by setting this:
set(HALIDE_DISTRIB_USE_STATIC_LIBRARY TRUE)

include("${HALIDE_DISTRIB_DIR}/halide.cmake")


SET(${PROJECT_NAME}_HEADERS
)

SET(${PROJECT_NAME}_SOURCES
  #tools/halide/GenGen.cpp
  #rdom_input_generator.cpp
  rdom_input_aottest.cpp
)
set(CMAKE_INSTALL_PREFIX "C:/Users/vagrant/Documents/halide-sandbox/project/tutorial/halide_generator")

#file(GLOB ${PROJECT_NAME}_SOURCES "*.cpp")


#include_directories(include include tools lib)

LINK_DIRECTORIES(lib)

string(REPLACE "_generator.cpp" "" GEN_NAME "rdom_input_generator.cpp")

halide_library("rdom_input" SRCS rdom_input_generator.cpp)
ADD_EXECUTABLE(${PROJECT_NAME} ${${PROJECT_NAME}_SOURCES} ${${PROJECT_NAME}_HEADERS})
#ADD_LIBRARY(${PROJECT_NAME} STATIC ${${PROJECT_NAME}_SOURCES} ${${PROJECT_NAME}_HEADERS})
#target_link_libraries(${PROJECT_NAME} Halide)

#INSTALL(TARGETS ${PROJECT_NAME} DESTINATION bin) #${PROJECT_NAME}
#INSTALL(FILES bin/Halide.dll lesson_15_generate.h DESTINATION .)
#INSTALL(FILES ${WITBE_WITBE_DEPENDENCIES_PATH}/bin/Halide.dll DESTINATION halide_generators)

#New
set_target_properties(${PROJECT_NAME} PROPERTIES CXX_STANDARD 11 CXX_STANDARD_REQUIRED YES CXX_EXTENSIONS NO)
target_include_directories(${PROJECT_NAME} PRIVATE include tools)

# Define a halide_library() for each generator we have, and link each one into wavelet
#file(GLOB GENS RELATIVE . "rdom_input_generator.cpp")



#halide_generator(rdom_input.generator SRCS rdom_input_generator.cpp)
#halide_library_from_generator(rdom_input GENERATOR rdom_input.generator)

target_link_libraries(${PROJECT_NAME} PUBLIC ${GEN_NAME})

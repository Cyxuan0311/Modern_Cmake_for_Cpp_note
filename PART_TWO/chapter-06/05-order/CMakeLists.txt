cmake_minimum_required(VERSION 3.20.0)
projetc(Order CXX)

add_library(outer outer.cpp)
add_library(nester nester.cpp)

add_executable(main main.cpp)
target_link_libraries(main nester outer)


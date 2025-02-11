cmake_minimum_required(VERSION 3.20.0)

add_executable(print_commit print_commit.cpp)
execute_process(COMMAND git log -1 --pretty-format:%.h
    OUTPUT_VARIABLE SHA)

target_compile_definitions(print_commit PRIVATE "SHA=${SHA}")


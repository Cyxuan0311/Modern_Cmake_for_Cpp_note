add_executable(precompile hello.cpp)
target_precompile_headers(precompile PRIVATE <iostream>)

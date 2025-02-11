add_executable(precompiled hello.cpp)
target_precompile_headers(precompiled PRIVATE <iostream>)
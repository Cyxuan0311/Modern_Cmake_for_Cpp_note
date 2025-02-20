add_executable(unit_tests calc_test.cpp run_test.cpp)

include(Valgrind)
AddValgrind(unit_tests)
# include内置命令包含Valgrind模块

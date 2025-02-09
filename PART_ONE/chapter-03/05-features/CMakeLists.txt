List(FIND CMAKE_CXX_COMPILE_FEATURES
    cxx_variable_template result
)
if(result EQUAL -1)
    message(FATAL_ERROR "I really need varaible templates.")
endif()

set(MY_LIST 1 2 3)
foreach(VAR IN LISTS MY_LIST ITEMS e f)
    message(${VAR})
endforeach()


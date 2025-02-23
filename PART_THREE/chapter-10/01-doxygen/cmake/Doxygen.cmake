function(Doxygen input output)
  find_package(Doxygen)
  if (NOT DOXYGEN_FOUND)
    add_custom_target(docs COMMAND false    # 修改目标名称
                     COMMENT "Doxygen not found")
    return()
  endif()

  # 添加递归扫描配置
  set(DOXYGEN_RECURSIVE YES)
  set(DOXYGEN_GENERATE_HTML YES)
  # 修正输出路径
  set(DOXYGEN_HTML_OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${output})

  # 处理额外参数（如RECURSIVE等）
  foreach(arg IN LISTS ARGN)
    if(arg MATCHES "^(RECURSIVE|GENERATE_HTML|INSTALL_DOCS)$")
      set(DOXYGEN_${arg} YES)
    endif()
  endforeach()

  # 修改目标名称为docs
  doxygen_add_docs(docs    # 这里修改目标名称
    ${CMAKE_CURRENT_SOURCE_DIR}/${input}
    COMMENT "生成HTML文档"
  )
endfunction()

# Modern Cmake For C++

## 第一部分 基础知识：

### 第一章 初始Cmake:

#### 1.2、基础知识：
Cmake如何工作的？它依赖于系统中的其他工具来执行实际的编译、链接和其他任务，可以将他看作构建过程中的协调器。
分为三个阶段：
- 配置
- 生成
- 构建
  
**配置阶段：**
本阶段会读取该源码树目录的项目信息，并为生成阶段准备输出目录或构建树。接下来CmakeLists.txt文件会告诉CMake的有关项目结构、目标、依赖项的信息。该过程CMake将搜集的信息保存在构建树中，同时生成一个CMakeCache.txt文件来存储变量，节省下一次配置的时间开销。

**生成阶段：**
读取项目配置后，CMake将会为当前工作环境生成一个构建系统。构建系统只是其他构建工具的简化配置文件。

Note:
    生成阶段在配置阶段后自动执行。

**构建阶段：**
为了生成项目中的指定文件，我们必须使用适当的构建工具。比如编译器等等。

下图可以表示CMake的三个阶段：

[如图](image\Cmake的过程.png)

#### 1.4.使用命令行
CMake是一个工具集，由五个可执行文件组成：
- cmake:配置、生成和构建项目的主要可执行文件。
- ctest:用于运行和报告结果的测试驱动结果。
- cpack:用来生成安装程序和源码的打包程序。
- cmake-gui:cmake的图形界面。
- ccmake:cmake基于控制台的图形界面。
  
##### 1.4.1 CMake
Cmake提供了一些操作模式：

- 生成项目构建系统
- 构建项目
- 安装项目
- 运行脚本
- 运行命令行工具
- 获得帮助

**生成项目构建系统：**

    #生成模式的语法
    cmake [<options>] -S <path-to-source> -B <path-to-build>
    cmake [<option>] <path-to-source>
    cmake [<option>] <path-to-existing-build>

    -S指定源树的路径。-P指定生成构建系统的目录。
    不推荐使用第二种或第三种。容易使构建代码混乱。

**生成器的选项：**

    #指定生成器。
    cmake -G <generator-name> <path-to-source>
    #生成器支持更深入的工具集：
    cmake -G <generator-name> -T <toolset-spec> -A <platform-name> <path-to-source>
    #检查系统上有哪些生成器可用：
    cmake --help

**缓存选项：**

CMake在配置阶段向系统查询各种信息，这些信息缓存在构建树目录中的CMakeCache.txt

    cmake -C <inital-cache-script> <path-to-source>
    现有缓存变量的初始化和修改可以用另一种方式完成：
    cmake -D <var>[<type>]=value <path-to-source>
    :<type>部分是可选的，可使用BOOL、FILEPATH、PATH、STRING或INTERRNAL。

另外，有一个重要的变量包含构建的类型：Debug与Release
对于单配置生成器

    #可以用如下代码：
    cmake -S . -B build -D CMAKE_BUILD_TYPE=Release

对于多配置生成器

    cmake -L[A][H] <path-to-source>

删除一个或多个变量可以通过以下选项完成：

    cmake -U <globbing_expr> <path-to-source>

**用于调试和跟踪的选项：**
CMake可以通过许多选项来运行：

    cmake --system-information [file]
    #可选的file参数允许将输出存储在文件中。

**预置的选项：**
用户可以指定许多选项来从你的项目生成构建树。提供一个CMakePresets.json文件。

    #要列出所有的预设：
    cmake --list-presets
    #使用预设的方式如下：
    cmake --preset=<preset>

[如图](image\预设如何覆盖CmakeLists与系统变量.png)

**构建项目：**

    #构建模式的语法：
    cmake --build <dir> [<option>] [-- <build-tool-options>]
    #简化版本：
    cmake --build <dir>
    #CMake允许指定适用每个构建器的关键关键参数：
    cmake --build <dir> -- <build-tool-options>

**并行构建的选项：**
默认下，许多构建构建工具允许使用多个并发进程并行编译源代码：

    cmake --build <dir> --parallel [<number-of-jobs>]
    cmake --build <dir> -j [<number-of-jobs>]
    #不过我们亦可以使用presets来覆盖环境变量。

**目标的选项：**
主要我们在构建项目时，想要跳过以下目标：

    cmake --build <dir> --target <target1> -t <target2> ...
    #可以重复使用-t参数来指定多个目标。
    cmake --build <dir> -t clean
    #可以清理目录的所有构建
    cmake --build <dir> --clean-first
    #先清除，在构建

**多配置生成器的选项：**

    cmake --build <dir> --config <cfg>
    #cfg可以选择Debug、Release、MinSizeRel、RelWithDebInfo
    #Debug为默认

**调试选项：**

    cmake --build <dir> --verbose
    cmake --build <dir> -v
    #同样的效果也可以使用presets来缓存变量。

**安装项目：**
安装到系统中：

    cmake --install <dir> [<options>]
    cmake --install <dir>

**组件的选项：**
安装单个组件：

    cmake --install <dir> --component <comp>

**权限的选项：**

    cmake --install <dir> --default-directory-permissions<permissions>
    可选u、g、o.

**安装目录的选项：**

    cmake --install <dir> --prefix <prefix>

**运行脚本：**

    #可以编写其他的脚本，并使用该语法：
    cmake [{-D <var>=<value>}...] -P <cmake-script-file> [-- <unparsed-options>...]

**运行命令行工具：**

    cmake -E <command> [<options>]

**获得帮助：**

    cmake --help[-<topic>]

##### 1.4.2 CTest
CTest可以为以构建项目运行测试的方法。

##### 1.4.3 Cpack
Cpack可以为不同平台创建不同压缩包。

##### 1.4.4 CMake用户界面

##### 1.4.5 CCMake
ccmake可执行文件是CMake面向类Unix平台的接口。
比如：Linux等。

#### 1.5 项目文件：

##### 1.5.1 源码树：

- 顶部目录有一个CMakeLists.txt文件
- 使用Git管理
- 目录的路径可以使用cmake命令的-S参数给定。
- 不要在CMake代码中硬编码源树的绝对路径——用户可以将项目放在不同的路径。
  
##### 1.5.2 构建树：
CMake使用这个目录来存储构建过程中生成的所有内容。
- 二进制文件在这里创建
- 不要将这个目录添加到Git
- CMake推荐构建或与所有源文件分离的目录中生成的构建，可以避免使用临时的、系统特定的文件（或源内构建）污染项目的源码树。
- 可由-B指定。
- 建议项目包含安装阶段，可以将最终工件放在系统中的正确位置，这样用于构建的临时文件都可以删除。
  
##### 1.5.3 文件列表：
包含CMake语言的文件称为文件列表，可以通过include()和find_package(),或使用add_subdirectory()来将其包含在另一个文件。
- CMake不会强制对这些文件进行一致的命名，通常的扩展名为.cmake
- 主CMakeLists.txt的文件非常重要。
- 当CMake遍历源码树，包含不同的文件列表CMAKE_CURRENT_LIST_DIR、CMAKE_CURRENT_LIST_FILE、
CMAKE_PARENT_LIST_FILE 和CMAKE_CURRENT_LIST_LINE。

##### 1.5.4 CMakeLists.txt:

    cmake_minimum_required(VERSION 3.20)    //设置CMake的期望版本。
    project(app)    //命名项目（提供的名称将存储在PROJECT_NAME中）并指定配置她的选项。
    message("Top level CMakeKists.txt")
    add_subdirectory(api)   //包含另一个CMakeLists.txt。

##### 1.5.5 CMakeCache.txt:
当配置阶段第一次运行时，缓存变量将列表文件中生产并存储在CMakeCaches.txt中。
一般EXTERNAL部分为供用户修改，INTERNAL部分给Cmake管理。

##### 1.5.6 包配置文件：
CMake可以允许用户使用可依赖的外部包

##### 1.5.7 cmake_install.cmake CTestTestfile.cmake和CPackConfig.cmake

##### 1.5.8 CMakePresets.json和CMakeUserPresets.json

##### 1.5.9 设置.gitignore文件

#### 1.6 脚本与模块：

##### 1.6.1 脚本：
CMake提供了一种平台无关的编程语言。附带许多命令。
-P选项可以执行脚本。

可以参考链接：
[链接](PART_ONE\chapter-01\03-scripts)

##### 1.6.2 实用工具模块：
CMake项目使用外部模块来增强他的功能。模块使用CMake语言编写，包括宏定义、变量和各种命令。

可以参考：
[链接](PART_ONE\chapter-01\04-module)

##### 1.6.3 查找模块：
可以通过使用find_package()指令，并提供相关包的名称来使用他们。

#### 1.7 总结：
现在了解了CMake是什么，以及它是如何工作的;学习了CMake工具系列的关键组件，以及
如何在各种系统上安装它们。像一个真正的高级用户一样，知道通过命令行运行CMake的所有方
法:构建系统生成、构建项目、安装、运行脚本、命令行工具和打印帮助。了解CTest、CPack和GUI
应用程序。然后，以正确的视角为用户和其他开发人员创建项目。此外，还了解了项目的组成部分:
目录、列表文件、配置、预置和帮助文件，以及在VCS中应该忽略的内容。最后，还了解了其他非
项目文件:脚本和模块。

### 第二章 CMake语法
CMake语言将提供一些最有用与最常用的指令。
本章中：
- 基本语法
- 变量
- 列表
- 控制结构
- 实用指令
  
#### 2.1 相关准备
推荐的命令：

    cmake -B <build tree> -S <source tree>
    cmake --build <build tree>

#### 2.2 基本语法
编写CMake代码类似于用其他命令式语言编写代码：行从上到下、从左到右执行、偶尔进入包含的文件或调用的函数。

    #以下命令执行脚本
    cmake -P scripts.cmake

CMake文件中的所有内容不是指令调用就是注释。

##### 2.2.1 注释

可以查看该图片

[如图](image\Cmake的注释问题.png)

##### 2.2.2 执行指令
命令形式：

    command_name(args...)

- CMake的命令不区分大小写。但是是使用"_"的连接的小写单词。
- CMake的命令调用不是表达式，所以不能将一个命令作为另一个命令的参数。
- 命令后不需要加分号。

CMake操作分为三类：
- 脚本指令
- 项目指令
- CTest指令
  
##### 2.2.3 指令参数
在底层，CMake识别的唯一数据结构是字符串。根据上下文的不同，CMake提供了三种类型的参数：

- 方括号参数
- 引号参数
- 非引号参数
  
**方括号参数：**
方括号参数不会进行解值，并会将多行字符串作为单个参数逐个转递给命令。

    message([[
        multiline
        bracket
        argument
    ]])

    message([==[
        because we used two equal-signs "=="
        following is still a single argument:
        { "petsArray" = [["mouse","cat"],["dog"]] }
    ]==])
    # [=[开始，]=]结束，"="的数量要相同。

**引号参数：**
带引号的参数类似于常规的C++字符串————这些参数将多个字符串组合再一起，包括空格，他们将展开转义字符。

    message("1.escape sequence: \" \n in a quoted argument")
    message("2.multi...
    line")
    message("3.and a variable reference: ${CMAKE_VERSION}")

**非引号参数：**
非引号参数会计算转义字符、引用变量;其中的分号会被作为界定列表界定符，将字符串分割为多个参数。

    message(a\ single\ argument)
    message(two arguments)
    message(three;seperated;arguments)
    message(${CMAKE_VERSION}) # a variable reference
    message(() () ())   # matching parentheses

- message显示转义单个参数中的空格，才正确打印空格。
- message()不会添加空格，所以参数会连接在一起。
  
#### 2.3 变量
有三类变量：普通变量、缓存变量、环境变量。
先从CMake中的关于变量的关键点开始：

- 变量名区分大小写，可以包含任何字符。
- 变量都在内部作为字符串存储。
- 基本的变量操作指令是set()和unset()。 

        cmake_minimum_required(VERSION 3.20.0)
        set(MyString1 "Text1")
        set([[My String2]] "Text2")
        set("My String 3" "Text3")
        message(${MyString1})
        message(${My\ String2})
        message(${My\ String\ 3})

要取消变量的设置，可以使用：unset()

##### 2.3.1 引用变量
考虑以下变量的例子：
- MyInner的值是Hello
- MyOuter的值是${My
  
使用message("${MyOuter}Inner" World)
将输出Hello World
同时使用
        
        set(${MyInner} "Hi")

不会改变MyInner变量，而是更改Hello变量。

- ${}用于引用普通变量或缓存变量。
- $ENY{}用于引用环境变量。
- $CACHE{}用于引用缓存变量。
  
##### 2.3.2 环境变量
设置：

    set(ENV{CXX} "clang++")
清除：

    unset(ENV{VERBOSE})
引用：

    $ENV{<name>}

##### 2.3.3 缓存变量
引用：

    $CACHE{<name>}
设置：

    set(<variable> <value> CACHE <type> <docstring> [FORCE])
    <type>通常接受：
    - BOOL:一个bool开关。
    - FILEPATH:磁盘上的文件路径。
    - STRING:一行字符串。
    - INTERNAL:一行字符串。
    <doctring> 值只是一个标签，将由GUI显示在字段旁边，以便向用户提供关于该设置的更多详细信息。即使是INTERNAL 类型也需要它。

##### 2.3.4 如何正确使用变量作用域

CMake有两个作用域：
-  函数作用域：用于执行用function()定义的自定义函数。
-  目录作用域：当从add_subdirectory()指令执行嵌套目录中的CMakeLists.txt文件时。
  
作用域的创建：
- 定义的块 bolck() 
- 定义的函数 function() 
- 执行另外一个文件时会有新的作用域 add_subdirectory() 
条件块、循环块、宏不会创建独立的作用域

作用域的规则：
- 创建嵌套作用域时，外层作用域的变量副本被传递给内层作用域，嵌套作用域执行完成后，外层作用域的原始变量被恢复
- block()块作用域中set变量时可以传播到外层作用域
- 如果给block()添加PROPAGATE选项，对变量的修改会传播到外层作用域 
- 如果set添加了PARENT_SCOPE选项，会将该变量视作外层作用域的变量，修改会传播到外层作用域。

#### 2.4 列表
可以使用set创建列表：

    set(myList"a;list;of;five;elements")
    set(myList a list"of;five;elements")

#### 2.5 控制结构
分为三类：
- 条件块
- 循环
- 定义指令

##### 2.5.1 条件块

    if(<condition>)
        <commands>
    elseif(<condition>) #optional block,can be repeated
        <command>
    else()  #optional block
        <commands>
    endif()

##### 2.5.2 条件指令的语法

**逻辑运算符：**
NOT-condition
condition-AND-condition
condition-OR-condition

也可以嵌套。

**字符串和变量的求值：**

**比较：**
以下操作符支持比较：

    EQUAL、LESS、LESS_EQUAL、GREATER、GREATER_EQUAL

**简单的检查：**
• 若值在列表中:<variable|string>in _LIST<variable>
• 若指令可用:command <command-name>
• 若CMake策略存在:POLICY <policy-id>(这将在第3章中介绍)
• 若使用add_test()添加CTest 测试:test <test-name>
• 若定义了构建目标:target <target-name>

**文件系统检查：**
• EXISTS <path-to-file-or-directory>: 检查文件或目录是否存在这将解析符号链接(若符号链接的目标存在，则返回true)。
• <file1> IS_NEWER_THAN <file2>: 检查哪个文件更新如果file1 比(或等于)file2 更新，或者两个文件中有一个不存在，则返回true。
• IS_DIRECTORY path-to-directory: 检查路径是否为目录
• IS_SYMLINK file-name: 检查路径是否为符号链接
• IS_ABSOLUTE path: 检查路径是否为绝对路径
    
##### 2.5.3 循环
其中包括
- while循环
- foreach()循环

**While:**

    while(<condition>)
        <commands>
    endwhile()

**foreach:**

    C++风格：
    foreach(<loop_var> RANGE <max>)
        <commands>
    endforeach()

    foreach(<loop_var> RANGE <min> <max> [<step>])
    提供<min>、<max>、<step>

    foreach(<loop_variable> IN [LISTS <lists>] [ITEMS <items>])

    foreach(<loop_var>...IN ZIP_LISTS <lists>)
    压缩列表访问

##### 2.5.4 定义指令
有两种方法定义自己的命令：
macro()与function()。

- macro()的工作方式类似于替换与查找。
- function()而是为本地变量创建一个单独的作用域。
  
*宏：*

    使用方法：
    macro(<name> [<argument>...])
        <commands>
    endmacro()

*函数：*

    使用方法：
    function(<name> [<argument>...])
        <commands>
    endfunction()

*CMake中的过程范式：*

*关于命名约定：*

#### 2.6 实用指令

##### 2.6.1 message()指令
message()指令，将文本打印到标准输出。
也有许多可选模式。

##### 2.6.2 include()指令

使用方法：

    include(<file|module> [OPTIONAL] [RESULT_VARIABLE <var>])

    include("${CMAKE_CURRENT_LIST_DIR}/<filename>.cmake")

##### 2.6.3 include_guard()指令
用于限制一些包含副作用的文件。

##### 2.6.4 file()指令
file()指令会以一种与系统无关的方法读取、写入和传输文件。

##### 2.6.5 execute_process()指令
在 CMake 中，execute_process() 指令用于在 CMake 配置过程中执行外部命令或程序。这在需要在项目配置阶段执行一些额外操作（如生成代码、检查依赖等）时非常有用。

#### 2.7 总结

### 第三章 CMake项目

#### 3.2 指令和命令

##### 3.2.1 指定最低的CMake版本

cmake_minimum_required()将告诉系统cmake的版本。

##### 3.2.2 定义语言和元数据-project()

使用方法：

    project(<PROJECT-NAME> [<language-name>...])
    需要指定<PROJECT-NAME>,其他参数可选。
    language-name有C、CXX(C++)....

#### 3.3 划分项目
可以不同项目代码中的不同功能划分到不同目录中。

可以使用嵌套结构来进行，即include()和cars_sources变量。

    cmake_minimum_required(VERSION 3.20.0)
    project(Rental CXX)
    include(cars/cars.cmake)
    add_executable(Rental
        main.cpp
        ${cars_sources}
        # ${more variables}
    )

##### 3.3.1 作用域的子目录
CMake提供对嵌套目录的指令：

    add_subdiretory(source_dir [binary_dir])
        [EXCLUDE_FROM_ALL]
    
使用如下：

    cmake_minimum_required(VERSION 3.20.0)
    project(Rental CXX)

    add_executable(Rental main.cpp)

    add_subdirectory(cars)

    target_link_libraries(Rental PRIVATE cars)
    # 最后一行用于将cars目录中的文件链接到Rental中。

其中，car目录中的CMakeLists文件：

    add_library(cars OBJECT 
        car.cpp
    )
    target_include_directories(cars PUBLIC .)
add_library()生成了全局可见的目标cars,并使用target_include_directories()将cars目录添加到其公共包括目录中。

##### 3.3.2 嵌套项目
源码树中有这样的部件，他们有自己的CMakeLists.txt，其中有自己的project()指令。
可以通过嵌套目录中的列表文件添加project()来实现。


##### 3.3.3 外部项目

#### 3.4 项目结构
一个好的项目：
- 易导航和扩展
- 自包含
- 抽象层次结构应该通过可执行文件和二进制文件来表示。
  
如图：

[如图：](image\项目结构.png)

#### 3.5 环境范围

##### 3.5.1 识别操作系统
我们用一个CMake脚本就可以支持多个目标操作系统，只要检查CMAKE_SYSTEM_NAME变量即可。

    如：
    if(CMAKE_SYSTEM_NAME STREQUAL "Linux")

##### 3.5.2 交叉编译-主机系统和目标系统？
比如在Window机器中运行CMake来编译Android应用程序。
主要是将CMAKE_SYSTEM_NAME和CMAKE_SYSTEM_VERSION的变量设置。

##### 3.5.3 简化变量
CMake将预定义一些变量，这些变量将将提供关于主机和目标信息。

##### 3.5.4 主机系统信息
使用cmake_host_system_information命令可以查看主机信息。

##### 3.5.5 平台是32位还是64位？
使用CMAKE_SIZEOF_VOID_P变量获得。

##### 3.5.6 系统的端序


#### 3.6 配置工具链
包括工作环境、生成器、CMake可执行程序、编译器。

##### 3.6.1 设定C++标准
可以通过设置CMAKE_CXX_STANDARD变量来实现。

##### 3.6.2 坚持支持标准

    set(CMAKE_CXX_STANDARD_REQUIRED ON)

##### 3.6.3 特定于供应商的优化。

    set(CMAKE_CXX_EXTERSIONS OFF)
    这个选项将坚持使用于供应商无关的代码。

##### 3.6.4 过程间优化

    include(CheckIPOSupported)
    chech_ipo_supported(RESULT ipo_supported)
    if(ipo_supported)
        set(CMAKE_INTERPROCEDURAL_OPTIMIZATION True)
    endif()

##### 3.6.5 检查支持的编译器特性

##### 3.6.6 编译测试文件

#### 3.7 禁用内构建

## 第二部分 进行构建：
### 第四章 使用目标
CMake中的目标是为了单一目标的逻辑单元，一个目标可能依赖于其他目标，并且可以以声明的方式产生。CMake负者确定构建目标的顺序，再构建出最终的成品。

#### 4.2 目标的概念
与GUN make不同的是，在CMake中不需要显示的办法来编译目标文件。
只需要：

    add_executable(app1 a.cpp b.cpp c.cpp)
    # 只需要一个add_executable指令。

在CMake中，可以通过以下指令创建目标：
- add_executable()
- add_library()
- add_custom_target()

其中add_library()指令为将指定的源文件编译成库文件，这些库文件可以是静态库（.a 或 .lib）、共享库（.so 或 .dll）或者模块库等。

add_custom_target()是CMake中的一个重要指令，用于定义自定义的构建目标。这个目标不会和常规的编译过程绑定，而是允许用户指定特定的命令在构建过程中执行，常用于执行一些额外的任务，如代码格式化、文档生成、测试脚本运行等。

##### 4.2.1 依赖图
给一个项目，有两个库、两个可执行文件和一个自定义目标。

如图：
    [图片](image\Bank.png)

对于以下CMakeLists.txt:

    cmake_minimum_required(VERSION 3.20.0)
    project(BankApp CXX)

    add_executable(terminal_app terminal_app.cpp)
    add_executable(gui_app gui_app.cpp)

    target_link_libraries(terminal_app calculations)
    target_link_libraries(gui_app calculations drawing)

    add_library(calculations calculations.cpp)
    add_library(drawing drawing.cpp)

    add_custom_target(checksum ALL
                  COMMAND sh -c "cksum terminal_app>terminal.ck"
                  COMMAND sh -c "cksum gui_app>gui.ck"
                  BYPRODUCTS terminal.ck gui.ck 
                  COMMENT "Checking the sums..."
    )

    add_dependencies(checksum terminal_app gui_app)
    使用target_link_libraries()指令将库与可执行文件链接起来。
    
##### 4.2.2 可视化的依赖性
Cmake提供了一个简单的命令来生成一个项目关系图。

    cmake --graphviz=test.dot .

该模块将生成一个文本文件，然后导入到Graphiz软件，还可以生成PDF格式。

##### 4.2.3 目标属性
目标在某些特征上也和C++对象的工作方式相同。
比如，可以修改目标属性使其只读。

以下命令：

    get_target_property(<var> <target> <property-name>)

    set_target_property(<target1> <target2> ...
    PROPERTIES <prop1-name> <value1> <prop2-name> <value>...)

其中，get_target_property()可以查询，set_target_property()可以更改。

    add_dependencies(<target> <dep>)
    可以用来增加目标的特定的属性。

##### 4.2.4 可传递需求
有时候一个目标可能依靠另一个目标。我们就可以将原目标与目标目标之间的传播称为可传递需求。

举一个例子：

    target_compile_definitions(<source> <INTERFACE|PUBLIC|PRIVATE> [items1...])
    该命令将填充<source>目标的COMPILE_DEFINITIONS属性。
    其中INTERFACE、PUBLIC、PRIVATE将决定将属性传递哪个目标。

详细的原理如下：
- PRIVATE设置源目标的属性。
- INTERFACE设置相关目标的属性。
- PUBLIC设置源和相关目标的属性。
  
要在目标间创建依赖关系：

    # 可以使用：
    target_link_libraries(<target>
        <PRIVATE|PUBLIC|INTERFACE> <item>...
        [<PRIVATE|PUBLIC|INTERFACE> <item>...]...
    )

[图片](image/属性间的传递.png)

##### 4.2.5 处理冲突的传播属性
给一个例子：
若在多个目标中使用相同的库构建软件，然后链接单个可执行文件。
每个目标都有4个这样的列表：
- COMPATIBLE_INTERFACE_BOOL
- COMPATIBLE_INTERFACE_STRING
- COMPATIBLE_INTERFACE_NUMBER_MAX
- COMPATIBLE_INTERFACE_NUMBER_MIN
  
##### 4.2.6 实现伪目标

**导入目标**
CMake可以定义他们作为find_package()指令的结果。

**别名目标**

    以下指令可为exe与库创建别名目标：
    add_executable(<name> ALIAS <target>)
    add_library(<name> ALIAS <target>)
    别名目标的属性为只读。
    好处是实际的实现可能根据情况在不同的名称下可用。

**接口库**
一个不编译任何东西，而是一个实用工具目标。
两个用途：
- 纯头文件库
- 将一堆传播的属性捆绑到一个逻辑单元。
  
使用以下指令：
    
    add_library(Eigen INTERFACE
        src/eighn.h src/vector.h src/matrix.h
    )
    target_include_directories(Eigen INTERFACE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src>
        $<INSTALL_INTERFACE:include/Eigen>
    )
    # 创建纯头文件库。
    target_link_libraries(executable Eigen)
    # 链接该库。

##### 4.2.7 构建目标
有些时候我们不需要一些可执行文件或库，我们可以将其排除：

    add_executable(<name> EXCLUDE_FROM_ALL [<source>...])
    add_library(<name> EXCLUDE_FROM_ALL [<source>...])

#### 4.3 编写自定义命令
目的：
- 生成另一个目标所依赖的源代码。
- 将另一个语言翻译成C++
- 紧接在构建另一个目标之前或之后执行自定义操作。

##### 4.3.1 使用自定义命令作为生成器

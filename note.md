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

##### 4.3.2 使用自定义命令作为目标钩子


#### 4.4 生成器表达式
CMake通过三个阶段构建解决方案————配置、生成和运行构建工具

##### 4.4.1 一般语法
举一个简单的例子：

    target_compile_definitions(foo PUBLIC
        BAR=$<TARGET_FILE:foo>)
    
    上面的命令在编译器的参数中添加了一个-D定义标志。

生成器表达式：

    $<EXPRESSION:arg1,arg2,arg3>
    其中EXPRESSION为名称。
    arg为参数。

**嵌套**
将通用表达式作为参数传递给另一个表达式的能力：

    $<UPPER_CASE:$<PLATFORM>>
    $<UPPER_CASE:${my_variable}>

**条件表达式**
有两种形式：
一、

    $<IF:condition,true_string,false_string>

二、

    $<condition:true_string>

##### 4.4.2 计算类型
生成器表达式可以计算布尔与字符串类型。

    逻辑运算符：
    $<NOT:arg>
    否定布尔参数。
    $<AND:arg1,arg2,arg3...>
    所有参数都为1，则返回1.
    $<OR:arg1,arg2,arg3...>
    若所有参数有1，则返回1.
    $<BOOL:string_arg>
    将参数从字符串转换为BOOL类型。

还有，==字符串比较==、==查询变量==、==字符串求值==、==计算变量==、==查询依赖的目标==、==特殊用法==、==字符串转换==、==输出相关的表达式==。

##### 4.4.3 可以尝试的例子

**构建配置：**

    比如：
    target_compile_options(tgt $<$<CONFIG:DEBUG>:-ginlinepoints>)
    可以检查CONFIG是否等于DEBUG.

**特定于系统的单行代码：**

    生成器表达式还可以将命令压缩。
    if($(CMAKE_SYSTEM_NAME) STREQUAL "Liunx")
        target_compile_definitions(myProject PRIVATE LINUX=1)
    endif()

**带有编译器特定标志的接口库**

    接口库可以用来提供与编译器匹配的标志：
    add_library(enable_rtti INTERFACE)
    target_compile_options(enable_rtti INTERFACE
        $<$<OR:$<COMPILE_ID:GUN>,$<COMPILE_ID:Clang>>:-rtti>
    )

**嵌套生成器表达式**

**条件表达式与BOOL运算符求值的区别**

### 第五章 CMake编译C++

#### 5.2 编译基础
C++依赖于静态编译——整个程序在执行之前必须要翻译成本机代码。
创建和运行C++程序的步骤：
- 编写代码
- 将单一的.cpp文件编译。
- 将目标文件链接到一个可执行文件中，并添加所有其他所需的动态库与静态库。
- 为了运行该程序，操作系统将使用一个名为加载器的工具，将其机器码和所有必需的动态库映射到虚拟内存。然后加载器读取头文件以检查程序从哪里开始，并将控制权移交给代码。
- C++运行时启动。执行一个special_start函数来收集命令行参数和环境变量。启动线程，初始化静态符号，并注册清理回调。这样，才能调用main()(其中代码由开发者书写)。

##### 5.2.1 编译工作
目标文件是单个文件的直接翻译。每一个都要单独编译，并通过链接器链接到一起。

编译器必须执行以下步骤：
- 预处理
- 语言分析
- 汇编
- 优化
- 生成二进制文件
  
##### 5.2.2 初始配置
CMake提供了多个指令处理每个阶段：

- target_compile_features():编译目标
- target_sources():向目标添加源
- target_include_directories():设置预处理器的包含路径。
- target_compile_definitions():设置预处理定义
- target_compile_options():设置编译器的选项
- target_precompile_headers():预编译头文件

大部分指令如下：

    target_...(<target_name> <INTERFACE|PUBLIC|PRIVSTE> <value0>)

我们还要求编译器提供特定的特性，有益于找到问题。

##### 5.2.3 管理目标源
CMake中提供了target_sources()指令追加源文件到之前创建的目标

    如：
    target_sources(main PRIVATE gui_linux.cpp)

#### 5.3 预处理配置
##### 5.3.1 提供包含文件的路径

包括两种形式：

    #include<path-spec>：尖括号
    #include "path-spec": 引号


##### 5.3.2 预处理宏定义
可以将代码中的define语句用CMakeLists.txt中的target_compile_definitions()指令代替，主要原因是有时候会有外部因素需要调整。

**单元测试私有类的常见问题**
比如：

    class X{
        #ifndef UNIX_TEST
            private:
        #endif
            int x_;
    }

**使用Git进行编译版本跟踪**

##### 5.3.3 配置头文件
我们可以使用

    configure_file(<input> <output>)
    生成新的文件。

#### 5.4 配置优化器
优化器的作用是提高代码的性能。简单的说，就是将代码翻译成易于CPU阅读的版本。

    target_compile_options()指令可以让我们确界的知道编译器的选项内容。
    用法：
    target_compile_options(<target> [BEFORE]
    <I|PU|PR> [items...]..)

##### 5.4.1 优化级别
大多数编译器提供了从0-3四个级别的优化。

    -O<level>来指定。如-O<0>..
还有一些选项，比如-Os\\-Ofast等等。

##### 5.4.2 函数内联
代码中我们可以通过inline声明，实现函数内联。
但是在编译器中也可以实现内联。

    比如：
    int main(){
        X x;
        x.im_inlined();
        x.me_too();
        return o;
    }
    在编译中，编译器会替换为：
    int main(){
        X x;
        cout<<"Hi\n";
        cout<<"Bye\n";
        return 0;
    }

但是内联会导致代码的行号变换。不易跟踪。

    -fno-inline-可以显示禁用内联。

##### 5.4.3 循环展开
考虑以下代码：

    void func(){
        for(int i=0;i<3;i++)
            cout<<"Hello!\n";
    }

循环展开会变成：

    void func(){
        cout<<"Hello!\n";
        cout<<"Hello!\n";
        cout<<"Hello!\n";
    }
结果相同，但是效率更高。不过缓存会增大。

##### 5.4.4 循环向量化
考虑以下代码：

    int a[128];
    int b[128];

    for(i=0;i<128;i++)
        a[i]=b[i]+5;
循环向量化会变成：

    for(i=0;i<32;i+=4){
        a[i]=b[i]+5;
        a[i+1]=b[i+1]+5;
        a[i+2]=b[i+2]+5;
        a[i+3]=b[i+3]+5;
    }
会减少循环次数，提高效率。

优化器的作用对于在运行时增强程序的性能非常重要。通过有效地运用它的策略，将得到更大的回报。效率不仅在编码完成后很重要，而且在软件开发过程中也很重要。若编译时间很长，可以通过更好地管理过程来进行改进。

#### 5.5 编译过程

##### 5.5.1 减少编译时间
CMake将只负责重新编译受最近更改影响的源代码。

**预编译头文件**
CMake提供了一个指令可以使头文件与实现文件分开编译处理。

    target_precompile_headers(<target> <I|PU|PR> [header1..] ...)

CMake将把所有头文件的名称放在一个cmake_pch.h|xx文件中，然后该文件将预编译为一个特定于编译器的二进制文件，扩展名为.pch、.gch或.pchi。

**统一构建**
统一构建是CMake 3.16引入的编译时间优化特性，也叫巨型构建。它能组合多个实现源文件，以此减少编译时间，但也存在一定的局限性，具体如下：
 - **工作原理**：利用#include指令把多个实现源文件组合起来，使编译器将其视为一个文件进行处理。在组合源文件时，通过头文件包含守卫机制，避免头文件的重复解析。例如，当两个源文件都包含同一个头文件时，该头文件只会被解析一次。
 - **优势**：优化器可在更大规模上执行优化操作，对所有绑定的源之间的过程间调用进行优化，类似于链接时优化，从而提高代码性能。
 - **缺点**：此过程会增加处理文件所需的内存量，因为将多个源文件合并为一个进行处理，文件规模变大；同时会减少可并行工作的数量，因为编译器多线程编译时，将所有文件聚集在一起会使构建系统调度并行构建变得困难。此外，统一构建还可能引发C++语义问题，如跨文件隐藏符号的匿名命名空间作用域变为组作用域，静态全局变量、函数和宏定义也会出现类似情况，这可能导致名称冲突或执行错误的函数重载。
 - **启用方式**： 可以将CMAKE_UNITY_BUILD变量设置为true，这样在定义的每个目标上都会初始化UNITY_BUILD属性；也能在每个希望使用统一构建的目标上手动设置UNITY_BUILD为true，即通过set_target_properties(<target1> <target2> ... PROPERTIES UNITY_BUILD true)函数实现。通常，CMake会创建包含8个源文件的构建，这由目标的UNITY_BUILD_BATCH_SIZE属性指定（该属性从CMAKE_UNITY_BUILD_BATCH_SIZE变量复制而来），开发者可根据需求更改该属性或默认变量。从3.18版本开始，还能通过改变目标的UNITY_BUILD_MODE属性为GROUP（默认值为BATCH），并设置源文件的UNITY_GROUP属性来决定如何将文件与命名组捆绑在一起，此时CMake会忽略UNITY_BUILD_BATCH_SIZE，将组中的所有文件添加到单个统一构建中。 
 - **使用建议**： CMake的文档建议，默认情况下不要为公共项目启用统一构建，而是让应用程序的最终用户通过提供DCMAKE_UNITY_BUILD命令行参数来决定是否需要。如果代码编写方式可能引发问题，应显式地将目标的统一构建属性设置为false。不过，对于内部使用的代码，如公司内部或私人项目，可以考虑启用该特性。 

**不支持C++20模块**

##### 5.5.2 查找错误

在软件开发中，查找错误是确保代码质量的关键环节。5.5.2节围绕使用CMake进行C++项目开发时查找错误的方法展开，从错误和警告配置、调试构建过程、调试头文件问题以及为调试器提供信息这几个方面，为开发者提供了一套全面的错误查找策略。
1. **错误和警告的配置**
    - **-Werror标志的使用**： -Werror标志可将所有警告视为错误，阻止代码在存在警告时编译。虽然这在保证代码质量上看似有效，但在实际开发中，由于新编译器版本对弃用功能的限制更严格，可能导致构建在未更改代码的情况下崩溃。因此，此标志更适用于编写公共库时，以确保代码在更严格环境下的规范性，而在其他情况下，应谨慎使用。
    - **其他警告标志**： -Wpedantic标志用于启用严格的ISO C和ISO C++要求的所有警告，但它不能用于检查代码是否完全符合标准，仅能查找非ISO实践的诊断消息。 -Wall和 -Wextra则被认为是非常有用和有意义的警告标志，开发者应在有空闲时间时修复这些警告，以提升代码质量。此外，根据项目类型的不同，还有许多其他的警告标志可供选择，开发者可通过阅读所选编译器的手册来了解其具体含义和用途。
2. **调试构建**
    - **-save -temps标志**：在编译过程中，使用 -save -temps标志（GCC和Clang都支持），可以强制将每个阶段的输出存储在文件而非内存中。这会生成两个关键文件：预处理阶段输出文件（.ii），包含源代码各部分的注释，可用于发现如不正确的include路径和错误的#ifdef计算等问题；语言分析阶段输出文件（.s），为汇编阶段做准备，对解决特定处理器相关问题和关键优化问题很有帮助。
    - **调试信息的获取**：当编译崩溃或出现问题时，这些文件的内容能帮助开发者深入了解配置步骤中实际发生的情况，从而定位问题所在。例如，通过查看预处理阶段的输出，可检查是否包含了错误版本的库，或者是否存在导致预处理错误的指令。
3. **头文件的调试问题**
    - **-H标志的作用**：在处理头文件相关问题时， -H标志可用于打印头文件的包含路径。它能清晰地展示每个头文件的来源和嵌套级别，帮助开发者确定是否包含了不必要的头文件，或者是否存在头文件路径错误的情况。
    - **解决头文件问题**：通过分析 -H标志的输出，开发者可以发现如多重包含保护可能存在的问题，进而对自己的头文件进行相应的改正，以确保头文件的正确使用，减少编译错误的发生。
4. **为调试器提供信息**
    - **Debug和Release配置**： CMake在默认情况下，会向编译器提供不同的标志来管理Debug和Release配置。在Debug配置中，CMAKE_CXX_FLAGS_DEBUG包含 -g标志，该标志用于添加调试信息，以操作系统的本机格式提供（如stabs、COFF、XCOFF或DWARF），可被调试器（如gdb）访问，方便开发者在开发过程中进行调试。在Release配置中， CMAKE_CXX_FLAGS_RELEASE包含 -DNDEBUG标志，这是一个预处理器定义，表明不是调试构建。启用此选项时，一些面向调试的宏（如assert）可能无法工作。
    - **处理断言问题**：如果在生产代码中使用断言，且希望在Release版本中也能正常工作，可以通过两种方法解决：一是从CMAKE_CXX_FLAGS_RELEASE中移除NDEBUG；二是在包含头文件之前取消NDEBUG宏的定义，即 #undef NDEBUG，然后再包含 <assert.h>。这样可以确保在不同构建配置下，代码的行为符合预期，同时也能充分利用断言进行调试和错误检查。 

### 第六章 进行链接
链接过程中的各种库：静态、动态、模块。

#### 6.2 掌握正确的链接方式
编译器处理.cpp文件时，会生成目标文件，目标文件包含以下元素：
- ELF头标，用来识别环境，包括操作系统等等
- 按类型分组的各种信息
- 节头表，就像一个地图，包含文件的各种信息

其中信息段包括：
- .text段
- .data段
- .strtab段
- .bss段
- .rodata段
- .shstrtab段

链接的过程就是首先把对象文件的每个部分放在和其他对象文件中相同类型的部分放在一起。称为**重定位**.其次，还需要**解析引用**,简单的说就是负责搜集编译器所需要的代码定义，并搜集，再合并到可执行文件中。

最终的可执行文件与目标文件的区别在于：
程序头的区别，简单的说就是可执行文件多了一个程序头。

#### 6.3 构建不同类型的库

##### 6.3.1 静态库
静态库本质上是存贮在存档中的原始对象文件的集合。

    构建方式如下：
    add_library(<name> STATIC [<source>...])

##### 6.3.2 动态库
构建方式如下：

    add_library(<name> SHARED [<source>...])

动态库可以在多个不同的应用程序之间共享。

##### 6.3.3 模板库
构建方式如下：

    add_library(<name> MODULE [<source>...])

是动态库的一种，目的是运行时作为加载的插件使用。

##### 6.3.4 位置无关的代码
所有共享库和模块的源代码都应该在编译时启用位置无关的代码标志，因为使用虚拟内存抽象出实际的物理内存。所以符号的地址是未知的。

#### 6.4 用定义规则解决问题
在单个翻译单元（单个.cpp文件）中，我们对变量、函数等只需要定义一次。
这些东西不能定义两次，不过使用类型、模板、extren内联函数可以完全相同。

##### 6.4.1 动态链接的重复符号
在动态库中，链接器允许在这里复制符号。
但是链接器关心链接器的顺序，导出库名称时要非常小心，可能会遇到名称冲突。

##### 6.4.2 使用命名空间——不要依赖链接器
我们容易忘记向链接器添加必要的库。
可以使用命名空间来解决。

#### 6.5 连接顺序和未定义符号

    cmake_minimum_required(VERSION 3.20.0)
    projetc(Order CXX)

    add_library(outer outer.cpp)
    add_library(nester nester.cpp)

    add_executable(main main.cpp)
    target_link_libraries(main nester outer)
比如该CMakeLists.txt文件，当我们进行连接时：
- 主要处理main.o
- 在处理libnester.a
- 在处理libouter.a

根据05-order文件夹，我们的CMakeLists.txt文件完成了对a变量的解析，但对b没有。
所以会错。

#### 6.6 分离main()进行测试

为了便于测试，可以将 main() 函数与核心逻辑分离。这样可以在不依赖 main() 的情况下对核心逻辑进行单元测试。

通过将核心逻辑放在库中，并在测试中链接这个库，可以更容易地进行单元测试和集成测试。

### 第七章 管理依赖关系

#### 7.2 如何查找已安装的软件包
举一个例子：

    cmake_minimum_required(VERSION 3.20.0)
    project(FindPackageProtobufVariables CXX)

    find_package(Protobuf REQUIRED)
    protobuf_generate_cpp(GENERATED_SRC GENERATED_HEADER
        message.proto)

    add_executable(main main.cpp
        ${GENERATED_SRC} ${GENERATED_HEADER}
    )
    target_link_libraries(main PRIVATE ${Protobuf_LIBRARIES})
    target_include_directories(main PRIVATE ${Protobuf_INCLUDE_DIRS} ${CMAKE_CURRENT_BINARY_DIR})

让我们来分析一波:
• 前两行我们已经知道了，创建项目并声明其语言
• find_package(Protobuf REQUIRED) 要求 CMake 运行绑定的 FindProtobuf.cmake 建立了
Protobuf 库。该查找模块将扫描常用路径，若没有找到库，则终止(因为提供了REQUIRED关
键字)。其还将指定有用的变量和函数(例如下一行中的函数)
 • protobuf_generate_cpp 是 在 protobuf 查找模块中定义的自定义函数。在底层调用
add_custom_command()，后者使用适当的参数调用协议编译器。可以通过提供两个变量
来使用这个函数，将生成的源文件(GENERATED_SRC)和头文件(GENERATED_HEADER)
的路径，以及要编译的文件列表(message.proto)。
• add_executable，将使用main.cpp和前面指令中配置的Protobuf文件创建可执行文件。
• target_link_libraries会将find_package()找到的库(静态或动态)添加到主目标的链接指令中。
• target_include_directories()
添加包提供的必要的INCLUDE_DIRS和CMAKE_CURRENT_BINARY_DIR。这里需要后者，这样编译器才能找到生成的message.pb.h头文件
换句话说，实现了一下目标
- 查找库和编译器的位置
- 给CMake提供帮助来调用.proto文件的自定义编译器
- 添加包含和链接所需路径的变量

接下来我们要讲述的是find_package指令：

    find_package(<name> [version] [exact] [quiet] [required])
    - version为版本
    - exact为需要精确的版本
    - quiet用于将消息静默
    - required用于停止打印消息

#### 7.3 使用FindPkgConfig
CMake提供一个内置查找模块————FindPkgConfig,可以为用户提供所需的依赖项。


    cmake_minimum_required(VERSION 3.20.0)
    project(FindPkgConfig CXX)

    find_package(PkgConfig REQUIRED)
    pkg_check_modules(PQXX REQUIRED IMPORTED_TARGET libqxx)
    message("PQXX_FOUND: ${PQXX_FOUND}")

    add_executable(main main.cpp)
    target_link_libraries(main PRIVATE PkgConfig::PQXX)

#### 7.4 编写自己的查找模块
在极少数情况下，我们要为使用的库编写一个自定义的查找模块。

    如下：
    cmake_minimum_required(VERSION 3.20.0)
    project(FindPackageCustom CXX)

    list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/module")

    find_package(PQXX REQUIRED)
    add_executable(main main.cpp)
    target_link_libraries(main PRIVATE PQXX::PQXX)

其中，模块会储存在项目树中的cmake/module中。

    模块为：
    function(add_imported_library library headers)
    add_library(PQXX::PQXX UNKNOWN IMPORTED)
    set_target_properties(PQXX::PQXX PROPERTIES
        IMPORTED_LOCATION ${library}
        INTERFACE_INCLUDE_DIRECTORIES ${headers}
    )
    set(PQXX_FOUND 1 CACHE INTERFACE "PQXX found" FORCE)
    set(PQXX_LIBRARIES ${libraries}
        CACHE STRING "Path to pqxx library" FORCE)
    set(PQXX_INCLUDES ${headers}
        CACHE STRING "Path to pqxx headers" FORCE
    )

    mark_as_advanced(FORCE PQXX_LIBRARIES)
    mark_as_advanced(FORCE PQXX_INCLUDES)
    endfunction()

#### 7.5 使用Git库

##### 7.5.1 通过Git字模块提供外部库
我们使用git内置的机制，称为git子模块。
git子模块允许项目储存库使用其他git储存库，无需将引用的文件添加到项目储存库中。执行以下命令：

    无子模块：
    git submodule add <repository-url>
    已有子模块,初始化：
    git submodule update --init -- <local-path-to-submodule>
但是用户clone储存库时，不会自动提取子模块，要显示使用init/pull命令。

##### 7.5.2 不使用Git的项目克隆依赖项

    cmake_minimum_required(VERSION 3.20.0)
    project(GitClone CXX)

    add_executable(welcome main.cpp)
    configure_file(config.yaml config.yaml COPYONLY)

    find_package(yaml-cpp QUIET)
    if (NOT yaml-cpp_FOUND)
        message("yaml-cpp not found, cloning git repository")
        find_package(Git)
    if (NOT Git_FOUND)
        message(FATAL_ERROR "Git not found, can't initialize!")
    endif ()
    execute_process(
        COMMAND ${GIT_EXECUTABLE} clone
        https://github.com/jbeder/yaml-cpp.git
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extern
    )
    add_subdirectory(extern/yaml-cpp)
    endif()
    target_link_libraries(welcome PRIVATE yaml-cpp)

CMake代码的主要功能是构建一个名为welcome的可执行程序，并且尝试链接yaml-cpp库。如果系统中没有找到yaml-cpp库，它会通过Git 克隆yaml-cpp的代码仓库，然后将其作为子项目添加到当前项目中进行编译。

#### 7.6 使用ExternalProject和FetchConter模块

在复杂项目的依赖性管理中，ExternalProject和FetchContent模块是CMake提供的重要工具，它们各自有独特的功能和使用场景。这部分内容主要介绍了这两个模块的作用、使用方法、相互间的差异，具体内容如下：
1. **ExternalProject模块**
    - **功能及执行步骤**：CMake 3.0.0引入的ExternalProject模块，用于支持在线存储库中外部项目。它能管理外部项目目录结构、下载源代码、支持多种版本控制系统、配置构建项目、执行安装和测试等。在构建阶段，它会为每个外部项目执行创建子目录、下载文件、更新、补丁、配置、构建、安装和测试（可选）等步骤。
    - **下载步骤选项**：下载依赖项的方式多样，可使用自定义指令，也能通过URL或版本控制系统（如Git、Subversion、Mercurial、CVS ）下载。其中，URL下载可设置校验和、是否提取、是否显示进度等选项；Git下载需指定仓库地址和标签等。
    - **使用方法及局限性**：使用时，需包含该模块并调用ExternalProject_Add()指令。但该模块存在局限性，其依赖项在构建阶段创建，导致项目命名空间独立，外部项目定义的目标在主项目中不可见，无法直接使用target_link_libraries()链接，解决此问题的方法较为繁琐。
2. **FetchContent模块**
    - **与ExternalProject的关系及优势**：FetchContent模块是ExternalProject的高级包装器，从3.11版本开始可用，建议至少使用3.14版本。它在配置阶段填充依赖项，能将外部项目声明的所有目标带入主项目范围，解决了ExternalProject模块中目标不可见的问题，使用更方便。
    - **使用步骤**：使用FetchContent模块需要三个步骤，首先用include(FetchModule)包含该模块；然后使用FetchContent_Declare()指令配置依赖项，其签名与ExternalProject_Add()相同，但部分选项不允许转发；最后使用FetchContent_MakeAvailable()指令填充依赖项，该指令会下载文件、将目标读取到项目中，并执行相关操作。
    - **实际示例**：以yaml - cpp库为例，使用FetchContent模块时，只需将ExternalProject_Add替换为FetchContent_Declare，并添加FetchContent_MakeAvailable指令，就可显式访问由yaml - cpp库创建的目标，相比ExternalProject模块更简洁高效。 

## 第三部分 自动化：
### 第八章 测试框架
#### 8.2 为什么自动化测试值得这么麻烦？
自动化测试可以提高代码质量，但是也会对不同的代码进行测试代码更改，比较麻烦。

#### 8.3 使用CTest来标准化CMake中的测试
自动化测试只运行了一个可执行文件，将其测试。
CMake使用ctest命令行工具解决这个问题。如何在已配置的项目上使用CTest执行测试？有三种模式：
- 测试
- 构建和测试
- 仪表板客户端

我们不考虑第三种模式。

    回到前两种模式：
    命令行为：
    ctest [<option>]

##### 8.3.1 构建和测试工具
使用这种模式，我们要加上--build-and-test

    ctest --build-and-test <path-to-source> <path-to-build>  --build-generator <generator> [<options>...] [--build-options <opts>...] [--test-command <command> [<args>...]]
    还含有一些参数
    控制配置阶段。
    构建构建阶段。
    控制测试阶段。

##### 8.3.2 测试模式
大多数情况下,ctest命令总以应对大多数情况。
不过我们还是可以有一些解决问题的范式

**查询测试**

例如：

    ctest -N
    可以检查应用将执行那些测试。

**过滤测试**

    -R<r>
    -E<r>
    -L<r>
    -LE<r>
    CTest可以选择接受不同的文件类型。

**乱序测试**

**处理失败**

**重复测试**

**控制输出**

**其他选项**


#### 8.4 为CTest创捷最基本的单元测试

##### 8.4.1 为测试构建项目
主要考虑的是工程中代码文件多了后，编译多次后会产生差异。
好的办法是将整个解决方案构建成一个库，并连接单元测试。要创建的库是一个对象库。


测试的定义：使用特定的输入值执行指定的程序路径并验证结果



单元测试的根本目的为：

1. 创建想要测试类的实例
2. 执行其中的某个方法
3. 检验执行后方法的返回值或实例的状态是否符合预期
4. 生成测试结果并删除测试的对象



我们可以不借助任何框架，**针对已有代码，创建一个可执行程序，对这些代码执行测试步骤**。在已有项目中，额外创建一个`test`目录，其中主要有两个部分：

1. 多个**测试用例文件**，文件中可以包含多个函数，每个函数调用项目中的某个单元，测试其功能是否正确，并返回测试结果。为了完成对所有代码的测试，需要将已有代码中`main()`函数的逻辑分离出来，以针对main函数的逻辑编写测试用例进行测试（见8.6）。
2. **测试****`main`****文件**，引用多个测试用例文件，在`main`函数中根据传入的参数执行特定的测试用例
3. 编译整个项目后，生成可执行的测试文件，每次运行可执行测试文件并传入指定的参数以执行特定的测试用例，根据输出的结果判断每个测试用例是否执行成功



可以使用CMake自动执行以上过程并判断执行结果，甚至生成所有测试用例的执行报告

在`test`目录中创建`CMakeLists.txt`，以构建测试可执行文件和生成测试用例，构建的内容包括：

1. `include(CTest)`以使用`CTest`提供的各种功能，完成测试
   - 在生成阶段，如果`include(CTest)`命令的列表文件在目录`./test`中，会在构建树`<build_tree>`目录下的`test`下生成`CTestTestfile.cmake`文件
   - 构建完成后，执行`ctest`命令时，需要指定`CTestTestfile.cmake`文件的路径，并根据文件内容执行测试
2. 利用**测试****`main`****文件**和**多个测试用例构成的文件**，创建测试可执行文件目标
3. 使用`add_test()`指令，将测试用例的相关信息（包含测试用例名称、利用可执行文件执行测试用例的方式等）注册到CTest

```cmake
# calc_test.cpp 中定义了多个测试 calc.cpp 中功能的测试用例
# unit_tests.cpp 的 main 函数根据传入的参数，执行 calc_test.cpp 中定义的特定测试用例
add_executable(unit_tests unit_tests.cpp calc_test.cpp ../src/calc.cpp)
target_include_directories(unit_tests PRIVATE ../src)

# 向 CTest 注册多个测试用例，并指定执行每个测试用例时要执行的命令
add_test(NAME SumAddsTwoInts COMMAND unit_tests 1)
add_test(NAME MultiplyMultipliesTwoInts COMMAND unit_tests 2)

```



对`test`目录构建完成后，执行`ctest [--test-dir path_to_ctesttestfile]`按照`CTestTestfile.cmake`文件进行测试：

1. CTest会依次执行注册的每个测试用例对应的`CMMAND`
2. 收集每个测试用例执行时的输出和退出代码
3. 针对所有的测试用例的执行结果，生成测试报告并输出



如果没有给`ctest`命令指定`CTestTestfile.cmake`文件所在的路径，默认会到执行命令所在的目录中查找该文件。通常，应该在根CMakeLists.txt中执行`include(CTest)`，以保证`CTestTestfile.cmake`文件直接在`<build_tree>`中生成，这样就可以直接在`<build_tree>`中执行`ctest`命令了



`ctest`命令有多种使用方式


可以在使用`cmake`构建项目后，在构建目录中使用`ctest`命令自动运行生成的测试可执行文件

`ctest`命令提供了[多个选项](https://cmake.org/cmake/help/latest/manual/ctest.1.html#run-tests "多个选项")以指定测试过程中的各种行为：

1. `-N`，仅列出所有注册的测试用例，不执行测试
2. 过滤测试：只运行指定的测试用例，使用`-R`、`-E`、`-L`、`-LE`等
3. 打乱测试：随机化执行测试用例，使用`--schedule-random`


使用`ctest`的`--build-and-test`选项，可以指定先执行构建，构建完成后立即执行每个测试用例，实现一个命令同时完成构建和测试用例的执行



该命令可以同时传入`cmake`构建的参数和`ctest`测试的参数，命令形式为：

```bash
ctest --build-and-test <source_dir> <build_dir>  # 指定构建的源文件夹和目标文件夹
      --build-generator <generator> <options>    # 指定生成器
      [--build-options <options>]                # cmake 构建所需要的参数
      [--test-command <command> [<args>]]        # ctest 测试所需要的参数
```

- 其中的源文件夹、目的文件夹、生成器都不可省略
- 如果想要构建完成后立即运行测试用例，需要在`--test-command`命令后添加`test`，即指定：
  ```bash
  ctest xxxx --test-command test
  ```



单元框架中定义的测试用例会自动注册到CTest，当运行`ctest`时会自动执行，并生成测试报告



参考连接：[Catch2 Github主页](https://github.com/catchorg/Catch2 "Catch2 Github主页")，[Catch2与CMake的集成](https://github.com/catchorg/Catch2/blob/devel/docs/cmake-integration.md "Catch2与CMake的集成")

如果本地没有安装过Catch2，可以在`test`目录中创建的`CMakeLists.txt`文件中包含如下内容以使用Catch2：

```cmake
# 1. 从网络下载 Catch2 模块
include(FetchContent)
FetchContent_Declare(
  Catch2
  GIT_REPOSITORY https://github.com/catchorg/Catch2.git
  GIT_TAG        v3.4.0
)
FetchContent_MakeAvailable(Catch2)

# 引入 CTest 模块
include(CTest)

# 2. 将 Catch2 的路径加入 CMake 的模块搜索路径，以引入 Catch
list(APPEND CMAKE_MODULE_PATH ${catch2_SOURCE_DIR}/extras)
include(Catch)

# 3. 将使用 Catch2 创建的测试用例 cpp 文件编译为可执行文件，
#    并链接 Catch2::Catch2WithMain 库
add_executable(tests calc_test.cpp run_test.cpp)
target_link_libraries(tests PRIVATE sut Catch2::Catch2WithMain)

# 4. 调用 catch_discover_tests 函数，
#    用于从目标中获取使用 TEST_CASE 创建的测试用例信息，并注册到 CTest
catch_discover_tests(tests)

```

- 使用`FetchContent`获取的Catch2需要将`${catch2_SOURCE_DIR}/extras`目录追加到`CMAKE_MODULE_PATH`才能正确使用`include`导入
- 可以使用`Catche2`创建的测试文件需要包含头文件`#include <catch2/catch_test_macros.hpp>`，并使用`TEST_CASE`宏定义相关的测试用例
  ```c++
  #include <catch2/catch_test_macros.hpp>
  #include <cstdint>
  uint32_t factorial( uint32_t number ) {
      return number <= 1 ? number : factorial(number-1) * number;
  }

  TEST_CASE( "Factorials are computed", "[factorial]" ) {
      REQUIRE( factorial( 1) == 1 );
      REQUIRE( factorial( 2) == 2 );
      REQUIRE( factorial( 3) == 6 );
      REQUIRE( factorial(10) == 3'628'800 );
  }
  ```
- Catch2库的CMake的构建会导出两个target，`Catch2::Catch2`（链接这个时可以包含自定义`main`函数的测试文件）和 `Catch2::Catch2WithMain`（链接这个时，测试文件著需要包含测试用例即可）



GoogleTest中定义：

- **断言**：检查给定判断是否为真的语句

  断言是类似于函数调用的宏，每种判断都分两种函数：
  - `ASSERT_*`：该形式在判断为失败时直接终止程序
  - `EXPECT_*`：该形式在判断为失败时只记录一个错误信息，且会继续运行后续语句
  如果断言判断为假，会输出断言失败时所在的行号和失败信息，可以在断言后使用`<<`运算符显式指定失败信息：
  ```c++
  ASSERT_EQ(x.size(), y.size()) << "Vectors " << x.size() << " != " << y.size();
  ```
- **测试**：使用断言语句验证测试代码

  使用`TEST()`宏定义一个测试，包含两个参数，且名字都不能包含任何下划线：
  - 第一个参数指定该测试所属的测试套件名字
  - 第二个参数指定该测试的名字
  ```c++
  #include <gtest/gtest.h>
  TEST(TestSuiteName, TestName) {
    // ... test body ...
  }
  ```
- **测试套件**（测试用例）：多个测试的集合

  多个**逻辑相关**的测试应该划分到相同的**测试套件**中
- 可以将多个测试放到一个**测试夹具**（Test Fixtures）中，以在不同测试中**重用对象的相同配置**。创建测试夹具的方法为：
  - 继承`testing::Test`定义测试夹具类，在`protected`中定义构造函数、析构函数等所有成员（会基于当前的定义，创建额外的子类以进行测试）
  - 可以重写`void SetUp() override`和`void TearDown() override`函数，以在每个测试开始前和结束后执行特定的资源创建和释放操作
  - 需要使用`TEST_F()`创建使用测试夹具的测试，其中两个参数：
    1. 第一个参数必须是测试夹具的类名
    2. 第二个参数是测试的名字
  - 每个测试夹具的测试开始前，都会创建一个新的测试夹具类对象，并在测试结束后销毁
  ```c++
  #include <gtest/gtest.h>
  class TestFixtureClassName : public testing::Test {
   protected:
     // class body
  }

  TEST_F(TestFixtureClassName, TestName) {
    // ... test body ...
  }

  ```
- **测试程序**：多个测试套件的组合



直接运行所有的测试有两种方法：

1. 为测试单独定义包含`main()`函数的测试可执行文件，`main()`函数中至少包含如下两句，还可以包含一些自定义的测试过程
   ```c
   int main(int argc, char **argv) {
     // 将程序的参数传入 GoogleTest 以初始化相关内容
     testing::InitGoogleTest(&argc, argv);
     // 用于将测试套件和测试服务关联起来的宏，必须返回该值，且只能调用一次
     return RUN_ALL_TESTS();
   }
   ```
2. 如果不需要自定义`main`函数，可以在编译整个测试程序时，链接`gtest_main`静态库，该静态库中定义定义了必要的`main`函数
   ```bash
   g++ test.cpp -lgtest_main -lgtest
   ```





为了[将GoogleTest和CTest进行集成](https://google.github.io/googletest/quickstart-cmake.html "将GoogleTest和CTest进行集成")，可以在`test`目录的`CMakeLists.txt`文件中包含如下内容以使用GoogleTest：

```cmake
# 1. 从网上指定位置下载 GoogleTest
include(FetchContent)
FetchContent_Declare(
  googletest
  GIT_REPOSITORY https://github.com/google/googletest.git
  GIT_TAG v1.14.0
)
# For Windows: Prevent overriding the parent project's compiler/linker settings
# 用于在 Windows 上避免覆盖父项目的编译器和链接器设置
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)

# 2. 指定 CMake 构建时，需要向 CTest 注册测试套件相关的信息，以开启测试
enable_testing()

# 3. 编译包含测试套件的可执行文件，并链接 gtest_main 库以使用默认的 main 函数
add_executable(test test.cpp)
target_link_libraries(hello_test GTest::gtest_main)

# 4. 调用该函数将测试用例注册到 CTest，之后 CTest 就能获取完整的测试信息
include(GoogleTest)
gtest_discover_tests(test)

```

- `enable_testing()`会[开启CTest的支持](https://stackoverflow.com/questions/50468620/what-does-enable-testing-do-in-cmake "开启CTest的支持")，调用`include(CTest)`时会自动执行`enable_testing()`，但是`include(CTest)`还会导入CDash 相关的组件导致[冗余](https://discourse.cmake.org/t/is-there-any-reason-to-prefer-include-ctest-or-enable-testing-over-the-other/1905/2 "冗余")，因此应该优先使用`enable_testing()`



GoogleTest还提供了[gMock](https://google.github.io/googletest/gmock_for_dummies.html "gMock")以模拟测试中所需要的类对象等相关的依赖，以避免在测试时需要将程序所依赖的所有内容都包含进来。


#### 8.6 生成测试覆盖报告

参考链接：

- [【C++】单元测试覆盖率工具lcov的使用](https://blog.csdn.net/muxuen/article/details/141617525 "【C++】单元测试覆盖率工具lcov的使用")



为了保证测试用例的有效性，可以通过工具跟踪测试用例的执行，在测试期间收集每行代码的执行信息，并生成报告：

- `gcov`：编译器GCC中的一个覆盖率收集工具，可以在执行`g++`命令时指定使用该工具收集代码执行信息
- `LCOV`：`gcov`的图形前端，根据`gcov`生成的报告，以HTML的格式展示执行的结果

### 第九章 分析工具

本章中，我们将讨论以下主题：
- 格式化
- 静态检查
- Valgrind

#### 9.2 格式化

编辑代码时，我们是使用制表符还是tab

    如下命令可以使用clang-format工具来进行格式化检查：
    clang-format -i --style=LLVM filename1.cpp filename2.cpp

使用clang-format工具可以帮助我们。

#### 9.3 静态检查

静态程序分析是在不运行编译版本的情况下检查源代码的过程。
C++社区中提供了许多静态检查器。
有：
- Clang-Tidy
- Cpplint
- Cppcheck
- include-what-you-are
- link-what-you-use

#### 9.4 Valgrind的动态分析
Valgrind是一个工具框架，包括：
- Memcheck
- Cachegrind
- Callgrind-Cachegrind
- Massif
- Helgrind
- DRD

##### 9.4.1 Memcheck
用于检测内存错误，包括：
- 未初始化的内存使用
- 内存泄漏
- 内存越界

##### 9.4.2 Memcheck-Cover

通过使用第三方报告生成器，如lcov，可以生成代码覆盖率报告。


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
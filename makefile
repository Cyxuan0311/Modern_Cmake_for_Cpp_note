# 定义一个删除 build 文件夹的目标
clean:
	find . -type d -name "build" -exec rm -rf {} + 
# 定义一个伪目标，防止与同名文件冲突
.PHONY: clean
start + [name] 打开文件/文件夹/软件
md + [name] 创建文件
copy + [name] 复制文件
del + [name] 删除文件
move + [name] 移动文件
dir 列出当前文件列表
pause 暂停
%cd% 获取当前工作绝对路径
%~dp0 批处理脚本自身所在的绝对路径


跳转:
cd .. 返回上级
cd + folder 跳转到文件夹内
cd /c 快速切换到c盘
cd /d 快速切换到d盘
cd /e 快速切换到e盘
cd /f 快速切换到f盘
...

逻辑判断:
if not exist %FILEANME% if not exist %FILEANME% 同时不存在

其他操作
ctrl + c 快速关闭frpc.exe或frps.exe
taskkill /f /im + [进程名]  快速杀死进程
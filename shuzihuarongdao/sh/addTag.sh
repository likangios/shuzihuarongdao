#!/bin/sh
CONFUSE_FILE="$PROJECT_DIR/$PROJECT_NAME/Module/*"
END_FILE="$PROJECT_DIR/$PROJECT_NAME/End.list"
PATH_FILE="$PROJECT_DIR/$PROJECT_NAME/Module/"

export LC_CTYPE=C

#替换方法H
addTagToH(){
linenumber=$(grep  -n  "interface"   $PATH_FILE$1.$2  | tail -1 | cut  -d  ":"  -f  1)
sed -i '' "$linenumber a\\
/////RandomMethodTag End/////
" $PATH_FILE$1.$2
}
#替换方法M
addTagToM(){
#查找到包含implementation 的最后一行 获取行号
linenumber=$(grep  -n  "implementation"   $PATH_FILE$1.$2  | tail -1 | cut  -d  ":"  -f  1)
sed -i '' "$linenumber a\\
/////RandomMethodTag End/////
" $PATH_FILE$1.$2
}
#遍历文件头
exec 3<$END_FILE
while read name<&3
do
if [[ ! -z "$name" ]];
then
addTagToH $name h
addTagToM $name m
fi
done



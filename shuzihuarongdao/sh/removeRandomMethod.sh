#!/bin/sh
CONFUSE_FILE="$PROJECT_DIR/$PROJECT_NAME/Module/*"
END_FILE="$PROJECT_DIR/$PROJECT_NAME/End.list"
PATH_FILE="$PROJECT_DIR/$PROJECT_NAME/Module/"

export LC_CTYPE=C

#替换方法H
addTagToH(){
beginLine=$(grep  -n  "interface"   $PATH_FILE$1.$2  | tail -1 | cut  -d  ":"  -f  1)
ednLine=$(grep  -n  "/////RandomMethodTag End/////"   $PATH_FILE$1.$2  | tail -1 | cut  -d  ":"  -f  1)
nextLine=`expr $beginLine + 1`
if [[ ! -z "$ednLine" ]];
then
sed -i '' "$nextLine,$ednLine d" $PATH_FILE$1.$2
fi
}
#替换方法M
addTagToM(){
#查找到包含implementation 的最后一行 获取行号
beginLine=$(grep  -n  "implementation"   $PATH_FILE$1.$2  | tail -1 | cut  -d  ":"  -f  1)
ednLine=$(grep  -n  "/////RandomMethodTag End/////"   $PATH_FILE$1.$2  | tail -1 | cut  -d  ":"  -f  1)
nextLine=`expr $beginLine + 1`
if [[ ! -z "$ednLine" ]];
then
sed -i '' "$nextLine,$ednLine d" $PATH_FILE$1.$2
fi
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

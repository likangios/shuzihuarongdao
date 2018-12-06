#!/usr/bin/env bash
CONFUSE_FILE="$PROJECT_DIR/$PROJECT_NAME/Module/*"
END_FILE="$PROJECT_DIR/$PROJECT_NAME/End.list"
PATH_FILE="$PROJECT_DIR/$PROJECT_NAME/Module/"

METHOD_FILE_H="$PROJECT_DIR/$PROJECT_NAME/method_h.list"
METHOD_FILE_M="$PROJECT_DIR/$PROJECT_NAME/method_m.list"

export LC_CTYPE=C

echo '' > $METHOD_FILE_H
echo '' > $METHOD_FILE_M


#获取方法名字
getRandomName(){
nameArray=("History" "Voice" "Cache" "Error" "Update" "Card" "Finish" "Function" "insert" "Height" "Web" "Message" "Has" "Height" "Clean" "Config" "System" "Do" "Global" "Load" "Something" "Secret" "Back" "Local" "Type" "Name" "App" "Share" "Input" "Animation" "Help" "Datas" "Offet" "Dismiss" "Match" "Tabbar" "Start" "Scroll" "Show" "Model" "Device" "User" "Version" "Shadow" "Record" "Common" "Page" "Layer" "Name" "Frame" "Stop" "Cell" "Push" "Did" "Tool")
int=1
stringName=''
arrayCount=${#nameArray[*]}
while(( $int<=5 ))
do
randomNumber=`expr $RANDOM % $arrayCount`
randomWord=${nameArray[$randomNumber]}
stringName="$stringName$randomWord"
let "int++"
done
echo $stringName
}
#获取返回值类型
getRetrunType(){
randomNumber=`expr $RANDOM % 2`
if [ $randomNumber == 1 ]
then
echo "(void)"
else
echo "(id)"
fi
}
#获取是否有参数
getIsArg(){
randomNumber=`expr $RANDOM % 2`
if [ $randomNumber == 1 ]
then
echo ":(id)arg1"
else
echo ""
fi
}
#获取方法实现类名
getClassType(){
classArray=("NSString" "NSDictionary" "NSSet" "NSMutableArray" "NSArray" "NSURL")
arrayCount=${#classArray[*]}
randomNumber=`expr $RANDOM % $arrayCount`
randomClass=${classArray[$randomNumber]}
echo $randomClass
}
#获取参数
setOrGet(){
randomNumber=`expr $RANDOM % 2`
if [ $randomNumber == 1 ]
then
echo "set"
else
echo "get"
fi
}
#获取参数
methodType(){
randomNumber=`expr $RANDOM % 2`
if [ $randomNumber == 1 ]
then
echo "+"
else
echo "-"
fi
}
getRandomMethod (){
name=$(getRandomName)
type=$(getRetrunType)
arg=$(getIsArg)
cls=$(getClassType)
set=$(setOrGet)
add=$(methodType)
echo "type:$type"
echo "$add$type$name$arg;" >> $METHOD_FILE_H
echo "$add$type$name$arg{"  >> $METHOD_FILE_M
#echo    "//    NSLog(@\"$name\");"  >> $METHOD_FILE_M
if [ $type == "(void)" ]
then
echo    "}"  >> $METHOD_FILE_M
else
echo    "    $cls *obj=[[$cls alloc]init];"  >> $METHOD_FILE_M
echo    "    return obj;"  >> $METHOD_FILE_M
echo    "}"  >> $METHOD_FILE_M
fi
}

##替换方法H
#addMethodToH(){
#cat "$2" | while read  line; do
#if [[ ! -z "$line" ]];
#then
#echo "line:$line"
#echo "name:$1"
#echo "h:$3"
#sed -i '' "s/@end/$line\\
#@end/g" $PATH_FILE$1.$3
#fi
#done
#}
#替换方法H
addMethodToH(){
content=$(cat $2)
linenumber=$(grep  -n  "interface"   $PATH_FILE$1.$3  | tail -1 | cut  -d  ":"  -f  1)
cat "$2" | while read  line; do
echo content:$line
echo linenumber:$linenumber
if [[ ! -z "$line" ]];
then
sed -i '' "$linenumber a\\
$line
" $PATH_FILE$1.$3
let "linenumber++"
fi
done
}
#替换方法M
addMethodToM(){
content=$(cat $2)
linenumber=$(grep  -n  "implementation"   $PATH_FILE$1.$3  | tail -1 | cut  -d  ":"  -f  1)
cat "$2" | while read  line; do
echo content:$line
echo linenumber:$linenumber
if [[ ! -z "$line" ]];
then
sed -i '' "$linenumber a\\
$line
" $PATH_FILE$1.$3
let "linenumber++"
fi
done

#sed -i '' "s/@end/$line\\
#@end/g" $PATH_FILE$1.$3
}

#循环生成方法备用
methodProduct(){
echo '' > $METHOD_FILE_H
echo '' > $METHOD_FILE_M

int=1
while(( $int<=$* ))
do
getRandomMethod
let "int++"
done
}

#var=$(cat $END_FILE)
#echo var:$var
#methodProduct 2

#遍历文件头
#exec 3<$END_FILE
#while read name<&3
#do
#
#if [[ ! -z "$name" ]];
#then
#addMethodToH $name $METHOD_FILE_H h
#addMethodToM $name $METHOD_FILE_M m
#fi
#done

cat "$END_FILE" | while read  line; do
if [[ ! -z "$line" ]];
then
methodProduct 20
addMethodToH $line $METHOD_FILE_H h
addMethodToM $line $METHOD_FILE_M m
fi
done











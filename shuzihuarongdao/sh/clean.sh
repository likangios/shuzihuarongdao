#!/bin/sh

FUNC_LIST_FILE="$PROJECT_NAME/func.list"
STRING_SYMBOL_FILE="$PROJECT_DIR/$PROJECT_NAME/DecodeStringlist.list"
DecodeStringMethod="$PROJECT_DIR/$PROJECT_NAME/DecodeStringMethod.list"


HEAD_FILE="$PROJECT_DIR/$PROJECT_NAME/DecodeString.h"
CODE_OBFUSCATION_FILE="$PROJECT_DIR/$PROJECT_NAME/codeObfuscation.h"

echo "" >$HEAD_FILE
echo "" >$STRING_SYMBOL_FILE
echo "" >$DecodeStringMethod
echo "" >$FUNC_LIST_FILE
echo "" >$CODE_OBFUSCATION_FILE

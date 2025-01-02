#!/bin/bash

# Имя корневой директории
if [ -n "$1" ]; then
 ROOT_DIR="$1"
else
 ROOT_DIR="test_directory"
fi

NUM_FILES=20

mkdir -p "$ROOT_DIR"

# Генерация файлов
for i in $(seq 1 $NUM_FILES); do
 FILE_PATH="$ROOT_DIR/file_$i.txt"
 echo "This is file $i" > "$FILE_PATH"
 if ((i % 2 == 0)); then
  touch -mad $(date -Ins -d '1 day ago') "$FILE_PATH"
 fi
done

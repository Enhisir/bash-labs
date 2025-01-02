#!/bin/bash

# Имя корневой директории
if [ -n "$1" ]; then
 ROOT_DIR="$1"
else
 ROOT_DIR="test_directory"
fi

NUM_FILES=10
MAX_LINKS=10

mkdir -p "$ROOT_DIR"

# Генерация файлов и ссылок
for i in $(seq 1 $NUM_FILES); do
 FILE_PATH="$ROOT_DIR/file_$i.txt"
 echo "This is file $i" > "$FILE_PATH"  
 RANDOM_LINKS=$((RANDOM % MAX_LINKS + 1)) # Число от 1 до MAX_LINKS

 for j in $(seq 1 $RANDOM_LINKS); do
  LINK_PATH="$ROOT_DIR/link_${i}_${j}.txt"
  ln -s "$FILE_PATH" "$LINK_PATH"
 done
done

echo "Генерация завершена. Директория: $ROOT_DIR"

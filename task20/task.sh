#!/bin/bash

# Сергеев Матвей Игоревич
# 11-207
# Задача 20
# Написать shell-процедуру, которая: 
# 1. в заданном первым параметром каталоге находит все простые файлы, число ссылок на которые максимально, и удаляет их; 
# 2. удаляет все пустые каталоги; 
# 3. выдает на экран сообщения о каждом удаленном файле и каталоге.

if ! [ -d "$1" ]; then
    echo "Нужно передать существующий каталог"
    return 1
fi

FILES=$(find "$1" -type l -printf '%l\n' | sort | uniq -c)

MAX_CT=0 # находим максимальный элемент
while read -r LINE; do
 LINE=$(echo "$LINE" | xargs) # чистим строку от пробелов
 CT=$(echo "$LINE" | awk '{print $1}') # первый аргумент
 FILENAME=$(echo "$LINE" | awk '{$1=""; print $0}' | xargs) # все остальное (т.к. путь может содержать пробелы)
 if [ "$CT" -gt "$MAX_CT" ];
 then
  MAX_CT="$CT"
 fi
done <<< "$FILES"

MAX_CT_FILES=() # список файлов, на которые больше всего ссылаются
while read -r LINE; do
 LINE=$(echo "$LINE" | xargs)
 CT=$(echo "$LINE" | awk '{print $1}')
 FILEPATH=$(echo "$LINE" | awk '{$1=""; print $0}' | xargs)
 if [ "$CT" -eq "$MAX_CT" ];
 then
  MAX_CT_FILES+=($FILEPATH)
 fi
done <<< "$FILES"
echo "Маскимальное число ссылок: $MAX_CT"
printf '\t%s\n' "${MAX_CT_FILES[@]}"

# удаляем все ссылки и папки
for FILEPATH in "${MAX_CT_FILES[@]}"; do
 LINKS=$(find "$1" -lname "$FILEPATH" -printf "%p\n") # получаем все ссылки на текущий файл
 while read -r LINK; do
  echo "Удаляю $LINK..."
  rm -f "$LINK"
 done <<< "$LINKS"
 echo "Удаляю $FILEPATH..."
 rm -f "$FILEPATH"
done
find "$1" -empty -type d -delete -printf "Удаляю пустую папку %p...\n"

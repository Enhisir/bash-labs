#!/bin/bash

# Сергеев Матвей Игоревич
# 11-207
# Задача 82
# Написать shell-процедуру, которая:
# 1. читает содержимое первого файла, передаваемого в качестве первого параметра; 
# 2. читает содержимое второго файла, передаваемого  в качестве второго параметра;
# 3. если число строк в первом и втором файлах различное, то выводит на экран каждые 10 секунд попеременно строки из первого и второго файлов

FILE1="$1"
FILE2="$2"

# Проверяем существование файлов
if [ ! -f "$FILE1" ]; then
    echo "Нужно указать существующий файл №1"
    return 1
fi

if [ ! -f "$FILE2" ]; then
    echo "Нужно указать существующий файл №2"
    return 1
fi

# Считаем количество строк в файлах
LINES_FILE1=$(wc -l < "$FILE1")
LINES_FILE2=$(wc -l < "$FILE2")

# Проверяем, различается ли количество строк
if [ "$LINES_FILE1" -eq "$LINES_FILE2" ]; then
    echo "The files have the same number of lines."
    return 0
fi

LINES1=()
while read -r LINE; do
    LINES1+=("$LINE")
done < "$FILE1"

LINES2=()
while read -r LINE; do
    LINES2+=("$LINE")
done < "$FILE2"

# Вывод строк из файлов каждые 10 секунд
INDEX1=0
INDEX2=0

while [ "$INDEX1" -lt "$LINES_FILE1" ] || [ "$INDEX2" -lt "$LINES_FILE2" ]; do
    if [ "$INDEX1" -lt "$LINES_FILE1" ]; then
        echo "F1: ${LINES1[$INDEX1]}"
        INDEX1=$((INDEX1 + 1))
    fi
    if [ "$INDEX2" -lt "$LINES_FILE2" ]; then
        echo "F2: ${LINES2[$INDEX2]}"
        INDEX2=$((INDEX2 + 1))
    fi
    sleep 10
done
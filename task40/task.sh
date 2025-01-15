#!/bin/bash

# Сергеев Матвей Игоревич
# 11-207
# Задача 40
# Написать shell-процедуру, которая:
# 1. читает содержимое файла, передаваемого в качестве первого параметра; 
# 2. создает новый файл, имя которого передается в качестве второго параметра;
# 3. выводит на экран каждые 7 секунд очередную строку первого файла;
# 4. сортирует все выведенные на экран строки первого файла по длине и записывает их в новый файл;
# 5. при вводе с клавиатуры слова quit удаляет новый файл и завершает работу.

INPUT_FILE="$1"
OUTPUT_FILE="$2"

if ! [ -f "$INPUT_FILE" ]; then
 echo "Нужно передать существующий файл"
 exit 1
fi

# Удаляем выходной файл, если он существует
if [ -f "$OUTPUT_FILE" ]; then
 rm "$OUTPUT_FILE"
fi

# Чтение строк входного файла
READ_LINES=()
while read -r LINE; do
    READ_LINES+=("$LINE")
done < "$INPUT_FILE"

for LINE in "${READ_LINES[@]}"; do
 echo "$LINE"
 sleep 0.5
 read -t 0.5 -r USER_INPUT # Проверка ввода "quit"
 USER_INPUT=$(echo "$USER_INPUT" | awk '{print $1}')
 if [ "$USER_INPUT" = "quit" ]; then
  echo "Выхожу..."
  [ -f "$OUTPUT_FILE" ] && rm "$OUTPUT_FILE"
  exit 0
 fi
done

# в файле вывода в начале будут пустые строки, 
# если они присутствовали в файле ввода, 
# т.к. в задании не указано их удалять
SORTED_LINES=$(printf '%s\n' "${READ_LINES[@]}" | sort -n | cut -d" " -f2-)
echo "$SORTED_LINES" > "$OUTPUT_FILE"
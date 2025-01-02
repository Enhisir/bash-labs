#!/bin/bash

# Сергеев Матвей Игоревич
# 11-207
# Задача 103
# Написать shell-процедуру, которая:
# 1. читает из стандартного ввода имя сигнала;
# 2. читает по принятому сигналу из файла, имя которого передается в качестве первого параметра, последнюю строку;
# 3. находит в прочитанной строке имена нескольких сигналов, по каждому из которых завершает свою работу, формируя соответствующий код завершения (для каждого сигнала свой код завершения).

if [ ! -f "$1" ]; then
    echo "Нужно указать существующий файл"
    exit 1
fi

read -r FINISH_SIGNAL
FILE="$1"
FINISH_CODE=$(kill -l "$FINISH_SIGNAL")

# шаблон-финишер
handle_signal_from_file() {
    echo "Завершаю с сигналом: $1 ($2)"
    exit "$2"
}

# Функция, вызываемая при получении изначального сигнала
handle_signal() {
    LASTLINE=$(tail -n 1 "$FILE")
    SIGNALS=($LASTLINE)

    FOUND_SIGNALS=false
    for SG in "${SIGNALS[@]}"; do
     SG_CODE=$(kill -l "$SG")
     if [ -n "$SG_CODE" ]; then
      echo "Слушаю $SG ($SG_CODE)..."
      trap "handle_signal_from_file $SG $SG_CODE" "$SG"
      FOUND_SIGNALS=true
     fi
    done
    if ! [ FOUND_SIGNALS ]; then
     echo "Не обнаружено сигналов: $LASTLINE"
     exit 1
    fi
}

# Перехватываем указанный сигнал
echo "Слушаю $FINISH_SIGNAL ($FINISH_CODE)..."
trap handle_signal "$FINISH_SIGNAL"

# Ожидаем сигнал
while true; do
    sleep 1
done
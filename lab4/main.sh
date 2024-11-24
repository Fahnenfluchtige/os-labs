#!/bin/bash

# Проверка наличия `dialog`
if ! command -v dialog &> /dev/null; then
    echo "dialog не установлен. Установите его для работы скрипта."
    exit 1
fi

DIALOG=dialog

# Подключение модулей
source ./bad_student.sh
source ./max_attendance.sh
source ./average_attendance.sh

# Главное меню
function choose_action {
    local ACTION=$($DIALOG --clear --stdout --title "Главное меню" \
        --menu "Выберите действие:" 15 50 4 \
        1 "Поиск студентов с наибольшими ошибками" \
        2 "Найти занятия с максимальной посещаемостью" \
        3 "Вычислить среднюю посещаемость" \
        4 "Выход")

    case $ACTION in
        1) bad_student ;;
        2) max_attendance ;;
        3) average_attendance ;;
        4) clear; echo "Выход из программы."; exit 0 ;;
        *) $DIALOG --msgbox "Неверный выбор!" 10 30; choose_action ;;
    esac
}

choose_action


#!/bin/bash

function max_attendance {
    # Выбор предмета с помощью case
    local SUBJECT_CHOICE=$($DIALOG --clear --stdout --title "Выбор предмета" \
        --menu "Выберите предмет:" 15 50 2 \
        1 "Пивоварение" \
        2 "Уфология")

    if [[ -z "$SUBJECT_CHOICE" ]]; then
        $DIALOG --msgbox "Выбор предмета не сделан!" 10 30
        return
    fi

    case $SUBJECT_CHOICE in
        1) SUBJECT="Пивоварение"; total_questions=25 ;;
        2) SUBJECT="Уфология"; total_questions=5 ;;
        *) $DIALOG --msgbox "Неверный выбор предмета!" 10 30; return ;;
    esac

    # Выбор группы с помощью меню
    local GROUP_CHOICE=$($DIALOG --clear --stdout --title "Выбор группы" \
        --menu "Выберите группу:" 20 50 16 \
        "A-06-04" "" \
        "A-06-05" "" \
        "A-06-06" "" \
        "A-06-07" "" \
        "A-06-08" "" \
        "A-06-09" "" \
        "A-06-10" "" \
        "A-06-11" "" \
        "A-06-12" "" \
        "A-06-13" "" \
        "A-06-14" "" \
        "A-06-15" "" \
        "A-06-16" "" \
        "A-06-17" "" \
        "A-06-18" "" \
        "A-06-19" "" \
        "A-06-20" "" \
        "A-06-21" "" \
        "A-09-17" "" \
        "A-09-18" "" \
        "A-09-19" "" \
        "A-09-20" "" \
        "A-09-21" "" \
        "Ae-21-21" "")

    if [[ -z "$GROUP_CHOICE" ]]; then
        $DIALOG --msgbox "Выбор группы не сделан!" 10 30
        return
    fi

    # Путь к файлу посещаемости
    local attendance_file="./labfiles/$SUBJECT/$GROUP_CHOICE-attendance"

    if [[ ! -f $attendance_file ]]; then
        $DIALOG --msgbox "Файл посещаемости не найден для $SUBJECT и группы $GROUP_CHOICE!" 10 50
        return
    fi

    # Подсчет посещаемости
    local days=$(head -1 "$attendance_file" | awk '{print length($2)}')
    declare -A attendance

    while read -r student presence; do
        for ((i=1; i<=$days; i++)); do
            local symbol=${presence:i-1:1}
            [[ "$symbol" == "+" ]] && attendance[$i]=$((attendance[$i] + 1))
        done
    done < "$attendance_file"

    # Формируем результат
    local result="Занятия с максимальной посещаемостью:\n"
    for day in "${!attendance[@]}"; do
        result+="День $day: ${attendance[$day]} человек\n"
    done

    # Сортируем и выводим топ-3
    echo -e "$result" | sort -t: -k2 -nr | head -n 3 > /tmp/attendance.txt
    $DIALOG --title "Результаты посещаемости" --textbox /tmp/attendance.txt 20 50
    rm /tmp/attendance.txt
}


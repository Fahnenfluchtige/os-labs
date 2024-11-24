#!/bin/bash

function average_attendance {
    # Выбор предмета через menu
    local SUBJECT_CHOICE=$($DIALOG --clear --stdout --title "Выбор предмета" \
        --menu "Выберите предмет:" 20 50 2 \
        1 "Пивоварение" \
        2 "Уфология")

    if [[ -z "$SUBJECT_CHOICE" ]]; then
        $DIALOG --msgbox "Выбор предмета не сделан!" 10 30
        return
    fi

    case $SUBJECT_CHOICE in
        1) SUBJECT="Пивоварение" ;;
        2) SUBJECT="Уфология" ;;
        *) $DIALOG --msgbox "Неверный выбор предмета!" 10 30; return ;;
    esac

    # Выбор группы через menu
    local GROUPS_CHOICE=$($DIALOG --clear --stdout --title "Выбор группы" \
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

    if [[ -z "$GROUPS_CHOICE" ]]; then
        $DIALOG --msgbox "Выбор группы не сделан!" 10 30
        return
    fi

    local total_present=0
    local total_days=0
    local total_students=0

    # Подсчёт посещаемости
    local attendance_file="./labfiles/$SUBJECT/$GROUPS_CHOICE-attendance"

    if [[ ! -f $attendance_file ]]; then
        $DIALOG --msgbox "Файл для группы $GROUPS_CHOICE не найден!" 10 30
        return
    fi

    # Определяем общее количество студентов
    total_students=$(wc -l < "$attendance_file")
    
    if [[ $total_students -eq 0 ]]; then
        $DIALOG --msgbox "Данные о студентах отсутствуют!" 10 30
        return
    fi

    # Подсчет количества присутствий
    local days=$(head -1 "$attendance_file" | awk '{print length($2)}')
    while read -r student presence; do
        for ((i=1; i<=days; i++)); do
            local symbol=${presence:i-1:1}
            if [[ "$symbol" == "+" ]]; then
                total_present=$((total_present + 1))
            fi
        done
    done < "$attendance_file"

    total_days=$((total_days + days))

    # Проверка на наличие данных
    if [[ $total_days -eq 0 ]]; then
        $DIALOG --msgbox "Данные отсутствуют!" 10 30
        return
    fi

    # Вычисление средней посещаемости в процентах
    local total_possible=$((total_students * total_days))
    local average_percent=$(echo "scale=2; ($total_present / $total_possible) * 100" | bc)

    $DIALOG --msgbox "Средняя посещаемость для группы $GROUPS_CHOICE по предмету $SUBJECT: $average_percent%." 10 30
}


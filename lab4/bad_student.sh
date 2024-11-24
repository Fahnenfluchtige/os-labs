#!/bin/bash
#DIALOG=dialog
function bad_student {
    # Выбор предмета
    local SUBJECT_CHOICE=$($DIALOG --clear --stdout --title "Выбор предмета" \
        --menu "Выберите предмет:" 10 40 2 \
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

    # Ввод года
    local YEAR=$($DIALOG --inputbox "Введите год:" 10 30 --stdout)
    if [[ -z "$YEAR" ]]; then
        $DIALOG --msgbox "Выбор года не сделан!" 10 30
        return
    fi

    # Выбор группы через menu
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
        "Ae-21-21" "" \
    )

    if [[ $? -ne 0 || -z "$GROUP_CHOICE" ]]; then
        $DIALOG --msgbox "Выбор группы не сделан!" 10 30
        return
    fi

    # Отладка: выведем выбранную группу
    $DIALOG --msgbox "Вы выбрали группу: $GROUP_CHOICE" 10 30

    # Передача данных в функцию анализа
    parse_and_find_losers "$SUBJECT" "$YEAR" "$GROUP_CHOICE"
}




function parse_and_find_losers {
    local SUBJECT=$1
    local YEAR=$2
    local GROUP=$3

    local fs_path="./labfiles/$SUBJECT"
    declare -A student_mistakes

    if [[ ! -d $fs_path ]]; then
        $DIALOG --msgbox "Папка для предмета $SUBJECT не найдена!" 10 30
        return
    fi

    local tests_files=$(find "$fs_path/tests/" -type f -name "TEST-*")
    #echo "$test_files"
    local var_test=$(ls $fs_path/tests/)
    #$DIALOG --msgbox "$test_files, $fs_path, $var_test" 10 30
    #echo "$var_test"
    #echo "$tests_files"
    for test_file in $tests_files; do
        while IFS=',' read -r year student grp corr_ans score; do
	    #echo "$year, $YEAR, $student, $grp, $GROUP, $corr_ans, $score"
            if [[ "$year" == "$YEAR" && "$grp" == "$GROUP"  ]]; then
                echo "$year, $YEAR "
            fi

	    if [[ "$year" == "$YEAR" && "$grp" == "$GROUP" && "$score" -eq 2 ]]; then
                echo "$year, $YEAR $student, $grp, $corr_ans, $score"

		mistakes=$((total_questions - corr_ans))
                student_mistakes["$student"]=$((student_mistakes["$student"] + mistakes))
            fi
        done < "$test_file"
    done

    if [[ ${#student_mistakes[@]} -eq 0 ]]; then
        $DIALOG --msgbox "Нет данных для анализа!" 10 30
        return
    fi

    local result="Топ студентов с ошибками:\n"
    for student in "${!student_mistakes[@]}"; do
        result+="$student: ${student_mistakes[$student]} ошибок\n"
    done

    echo -e "$result" | sort -t: -k2 -nr | head -n 5 > /tmp/results.txt
    $DIALOG --title "Результаты анализа" --textbox /tmp/results.txt 20 50
    rm /tmp/results.txt
}



[org 0x7C00]               ; Адрес загрузки (начало загрузочного сектора)
[bits 16]                  ; Указание на 16-битный режим

start:
    ; === Вывод ASCII-лого ===
    mov ah, 0x0E           ; BIOS: режим текстового вывода
    mov si, logo           ; Адрес ASCII-графики
    call print_string      ; Вывод логотипа

    ; === Приветственное сообщение ===
    mov si, greeting       ; Сообщение: "Введите имя:"
    call print_string      ; Вывод сообщения

    ; === Ввод имени ===
    call read_name         ; Чтение имени пользователя

    ; === Перенос строки перед выводом имени ===
    mov ah, 0x0E           ; BIOS: текстовый вывод
    mov al, 13             ; Возврат каретки
    int 0x10
    mov al, 10             ; Новая строка
    int 0x10

    ; === Вывод введённого имени ===
    mov si, hello_msg      ; Сообщение: "Ваше имя:"
    call print_string
    mov si, name_buffer    ; Введённое имя
    call print_string

    ; === Перенос строки перед вводом числа ===
    mov ah, 0x0E           ; BIOS: текстовый вывод
    mov al, 13             ; Возврат каретки
    int 0x10
    mov al, 10             ; Новая строка
    int 0x10

    ; === Запрос ввода числа ===
    mov si, number_prompt
    call print_string
    call read_number       ; Ввод числа

    ; === Перенос строки перед выводом числа ===
    mov ah, 0x0E           ; BIOS: текстовый вывод
    mov al, 13             ; Возврат каретки
    int 0x10
    mov al, 10             ; Новая строка
    int 0x10

    ; === Вывод числа ===
    mov si, number_msg
    call print_string
    mov si, number_buffer
    call print_string

    ; === Завершение программы ===
end:
    jmp $                  ; Бесконечный цикл

; === Функции ===

; Вывод строки на экран
print_string:
    lodsb                  ; Загрузить символ в AL
    or al, al              ; Проверить конец строки
    jz .done               ; Если 0, завершить вывод
    int 0x10               ; BIOS: вывод символа
    jmp print_string       ; Следующий символ
.done:
    ret

; Чтение имени пользователя
read_name:
    xor di, di             ; Сброс указателя буфера
.next_char:
    call read_key          ; Чтение символа с клавиатуры
    cmp al, 0x0D           ; Проверить на Enter (код 0x0D)
    je .done               ; Если Enter, завершить ввод
    mov [name_buffer+di], al ; Сохранить символ в буфер
    inc di                 ; Увеличить указатель
    cmp di, 19             ; Ограничение длины имени (20 символов максимум)
    je .done               ; Завершить, если достигнут предел буфера
    mov ah, 0x0E           ; BIOS: вывод символа
    int 0x10               ; Отобразить символ
    jmp .next_char         ; Читать следующий символ
.done:
    mov byte [name_buffer+di], 0 ; Завершение строки нулевым символом
    ret

; Чтение числа
read_number:
    xor di, di             ; Сброс указателя буфера
.next_digit:
    call read_key          ; Чтение символа с клавиатуры
    cmp al, 0x0D           ; Проверить на Enter
    je .done               ; Завершить, если Enter
    cmp al, '0'            ; Проверка: это цифра?
    jl .ignore_digit       ; Пропустить, если меньше '0'
    cmp al, '9'
    jg .ignore_digit       ; Пропустить, если больше '9'
    mov [number_buffer+di], al ; Сохранить цифру в буфер
    inc di                 ; Увеличить указатель
    cmp di, 19             ; Ограничить длину числа (20 символов максимум)
    je .done
    mov ah, 0x0E           ; BIOS: вывод символа
    int 0x10               ; Отобразить символ
    jmp .next_digit        ; Читать следующий символ
.ignore_digit:
    jmp .next_digit        ; Пропустить символ и продолжить
.done:
    mov byte [number_buffer+di], 0 ; Завершение строки нулевым символом
    ret

; Чтение символа с клавиатуры
read_key:
    xor ah, ah             ; Установить функцию 0x00
    int 0x16               ; Вызов BIOS для чтения клавиши
    ret

; === Данные ===
logo db " __   __        __   ___          __   __  ", 13, 10
     db "|__) /  \ |    / _` |__  |\ |    /  \ /__` ", 13, 10
     db "|__) \__/ |___ \__> |___ | \|    \__/ .__/ ", 13, 10, 0
greeting db "Welcome to Bolgen OS!", 13, 10, "Please enter your name: ", 0
hello_msg db "Your name is: ", 0
number_prompt db "Please enter a number: ", 0
number_msg db "Your number is: ", 0
name_buffer times 20 db 0   ; Буфер для имени
number_buffer times 20 db 0 ; Буфер для числа

; Заполнение до 512 байт
times 510-($-$$) db 0
dw 0xAA55                  ; Магическое число

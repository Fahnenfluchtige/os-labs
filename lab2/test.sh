#!/bin/bash



#Создайте директорию с именем любимого фильма/сериала, в ней создайте директории с именами некоторых персонажей.
#В каждой директории посвященной персонажу создайте файл info.txt, содержащий его полное имя, краткое описание характера и отношение к сюжету (без спойлеров).


mkdir -p Nana_2006

cd Nana_2006

char=("Nana" "Hachi" "Ren" "Nobu" "Yasu" "Shin" "Reira" "Takumi" )
 
for item in ${char[*]}
do
    echo -e "Creating dir for character $item"
    mkdir -p "$item"
done

echo "Нана Осаки (Nana Osaki): главная героиня аниме, крутая сильная и независимая вокалистка группы Blast, пытающаяся покорить сцену." >> Nana/info.txt
echo "Нана Комацу (Nana Komatsu) aka Хачи (Hachi): тоже главная героиня аниме, не менее крутая и позитивная, но более зависимая девушка, ищущая себя в большом городе." >> Hachi/info.txt
echo "Рен Хондзе (Ren Honjo): бойфренд Наны, талантливый гитарист группы Trapnest со неоднозначными взглядами на мир." >> Ren/info.txt
echo "Нобу Терашима (Nobu Terashima): гитарист группы Blast, добрый и преданный друг, всегда готов прийти на помощь." >> Nobu/info.txt
echo "Ясу Такахаси (Yasu Takahashi): барабанщик группы Blast и юрист, всегда спокойный и рассудительный, заботится о всех участниках группы." >> Yasu/info.txt
echo "Шин Оказаки (Shinichi Okazaki): самый молодой участник группы Blast, басист с загадочным прошлым, скрывающий свою настоящую личность." >> Shin/info.txt
echo "Рейра Серизава (Reira Serizawa): вокалистка группы Trapnest, её голос и внешность привлекают внимание, но за этим скрывается сложный характер." >> Reira/info.txt
echo "Такуми Ичиносэ (Takumi Ichinose): басист и лидер группы Trapnest, хладнокровный и расчётливый, всегда ставит свою карьеру на первое место (а поклонниц на нулевое)." >> Takumi/info.txt

# С помощью команды cat в корневой созданной директории создайте файл в котором сначала будут перечислены все персонажи,
# а затем - все данные о них, приведенные в файлах info.txt. Между информацией об отдельных персонажах поместите разделитель, дополнительный комментарий или описание.

for item in ${char[*]}
do
   # hope xargs and sed is not forbiden, it's very helpful
   cat $item/info.txt | sed 's/(.*//' |  xargs -I {} echo "{}" >> about_all_characs.txt


  # echo $item >> about_all_characs.txt
done # need to optimize... it's better not to use cat, just echo =) but task is meaned to use cat -- so do I
 
for item in ${char[*]}
do
    echo -e '\n-----------------------------------------------\n' >> about_all_characs.txt
    cat $item/info.txt >> about_all_characs.txt
    echo -e '\n-----------------------------------------------\n' >> about_all_characs.txt
done


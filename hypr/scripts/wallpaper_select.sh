#!/bin/bash

# Папка с твоими обоями (измени путь на свой!)
WALLPAPER_DIR="$HOME/static-walls"

# Проверяем, запущена ли swww-daemon, если нет — стартуем
if ! awww query &>/dev/null; then
    awww-daemon &
    sleep 0.5
fi

# Получаем список файлов и текущую установленную картинку
PICS=($(ls "$WALLPAPER_DIR" | grep -E ".jpg$|.jpeg$|.png$|.webp$"))
CURRENT=$(awww query | awk -F 'image: ' '{print $2}' | xargs basename)

# Если swww ничего не вернул, просто ставим первую картинку
if [ -z "$CURRENT" ]; then
    awww img "$WALLPAPER_DIR/${PICS[0]}"
    exit 0
fi

# Ищем индекс текущих обоев
for i in "${!PICS[@]}"; do
   if [[ "${PICS[$i]}" == "$CURRENT" ]]; then
       CURRENT_INDEX=$i
       break
   fi
done

# Вычисляем индекс следующей картинки (циклически)
NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#PICS[@]} ))
NEXT_WALLPAPER="${PICS[$NEXT_INDEX]}"

# Переключаем с красивым эффектом (опционально)
awww img "$WALLPAPER_DIR/$NEXT_WALLPAPER" --transition-type center --transition-fps 60 --transition-duration 1.5 --transition-step 90

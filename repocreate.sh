#!/usr/bin/env bash

GREEN="\e[32m"
RED="\e[31m"
ENDCOLOR="\e[0m"

echo "\n"
echo "${GREEN}|-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-|${ENDCOLOR}"
echo "${GREEN}| Simple script para crear un repositorio en github |${ENDCOLOR}"
echo "${GREEN}|  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  |${ENDCOLOR}"
echo "${GREEN}\nEscribe el nombre del repositorio: ${ENDCOLOR}"
echo -n "> "
read -r nombreRepo

# Miro que la variable no este vacia
while [ -z "$nombreRepo" ]; do
    echo "El nombre del repositorio ${RED}no${ENDCOLOR} puede estar en blanco: "
    echo -n "> "
    read -r nombreRepo
done

echo "\nSe va a crear un repositorio llamado: ${RED}$nombreRepo${ENDCOLOR}\n"

mkdir $nombreRepo && cd $nombreRepo

echo "${GREEN}Deseas que el repositorio sea...${ENDCOLOR}?"
echo "1. Publico"
echo "2. Privado"

echo -n "> "
read -r privacidad


privado=true
if [ "$privacidad" = "1" ]; then
    privado=false
elif [ "$privacidad" != "1" ] && [ "$privacidad" != "2" ]; then
    echo "\n${GREEN}INFO:${ENDCOLOR}Opcion \"$privacidad\" no disponible, se configuro el repositorio como privado\n"
fi

echo "Es privado el repo: $privado"

echo "\n${GREEN}Deseas crear archivos README.md y .gitignore? (y/n)${ENDCOLOR}"
read -r readme

# Compruebo que haya una respuesta valida
while [ "$readme" != "y" ] && [ "$readme" != "n" ]; do
    echo "\n${RED}Deseas crear archivos README.md y .gitignore? (y/n)${ENDCOLOR}"
    read -r readme
done

git init 

if [ "$readme" = "y" ]; then
    echo "\n"
    touch README.md && echo "# $nombreRepo" > README.md;
    echo > .gitignore
    git add .
    git commit -m "feat: Commit inicial de estructura de proyecto"
    echo "\n${GREEN}Archivos creados${ENDCOLOR}\n"
else
    echo "\n${RED}README.md, gitignore no fueron creados${ENDCOLOR}\n"
fi


echo -n "\n${GREEN}Usuario de Github:${ENDCOLOR} "
read username

echo "\nSi no tienes un token de acceso a tu cuenta de Github..."
echo "este es el momento para obtenerlo https://tinyurl.com/44xjrs79\n"


curl -s -u $username https://api.github.com/user/repos -d '{"name":"'$nombreRepo'","private":'$privado'}'

URL=https://github.com/$username/$nombreRepo.git

clear

git remote add origin $URL

if [ "$readme" = "y" ]; then
    git push --set-upstream origin main
    git push -u origin
fi

# Borro los archivos locales
cd ..
rm -rf $nombreRepo

echo "\n${GREEN}Clonando repositorio del origen...${ENDCOLOR}\n"
git clone $URL
echo "\n${GREEN}Repositorio creado en $(pwd)!${ENDCOLOR}\n"

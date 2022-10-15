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

echo "${GREEN}Deseas crear archivos README.md y .gitignore? (y/n)${ENDCOLOR}"
read -r readme

# Compruebo que haya una respuesta valida
while [ "$readme" != "y" ] && [ "$readme" != "n" ]; do
    echo "\n${RED}Deseas crear archivos README.md y .gitignore? (y/n)${ENDCOLOR}"
    read -r readme
done


if [ "$readme" = "y" ]; then
    touch README.md && echo "# $nombreRepo" > README.md
    echo "\n${GREEN}Archivos creados${ENDCOLOR}\n"
else
    echo "\n${RED}README.md, gitignore no fueron creados${ENDCOLOR}\n"
fi


git init 
git add .
git commit -m "feat: Commit inicial de estructura de proyecto"

echo -n "\n${GREEN}Usuario de Github:${ENDCOLOR} "
read username

echo "Si no tienes un token de acceso a tu cuenta de Github..."
echo "este es el momento para obtenerlo https://tinyurl.com/44xjrs79\n"
sleep 2

curl -s -u $username https://api.github.com/user/repos -d '{"name":"'$nombreRepo'","private":false}'

URL=https://github.com/$username/$nombreRepo.git

git remote add origin $URL

git push --set-upstream origin main

git push -u origin


# Borro los archivos locales
cd ..
rm -rf $nombreRepo

echo "\n${GREEN}Clonando repositorio del origen...${ENDCOLOR}\n"
git clone $URL
echo "\n${RED}Repositorio creado en $(pwd)!${ENDCOLOR}"




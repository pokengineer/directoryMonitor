#!/bin/bash

################# Funciones  #################
function ayuda(){
	echo "
script que monitorea un determinado directorio y registra los cambios
producidos en los documentos.
El script recibirá como parámetro obligatorio el path a monitorear y los tipos de archivos, por ejemplo
.docx, .xlsx, etc.

Ejemplos:
./monitorScript.sh ./testeo \"txt\"
./monitorScript.sh ./testeo \"*\"
"
return
}
########### Verificar parametros  ###########
ARGS=2
if [ "$1" = "--help" -o "$1" = "-?" -o "$1" = "-h" ]
then
	ayuda
	exit
fi

if [ $# -ne "$ARGS" ]
then
	echo "se requiere dos parametros para ejecutar la funcion. Revisar ayuda."
	exit 1
fi

if [ ! -d "$1" ]; then
   echo "El parametro enviado no es un directorio valido"
   exit 2
fi

#no se me ocurrio otra forma de hacer esto
if [ "$2" = "*" ]; then
   inotifywait -r -m -e modify,move,create,delete $1 |
	while read path action file; do
        echo "$file que se encuentra en $path sufrio un ( $action )" # mostralo siempre
	done
   exit
fi

#esta es la parte que hace todo basicamente
echo "se buscaran modificaciones en $1"
inotifywait -r -m -e modify,move,create,delete $1 |
	while read path action file; do
        if [[ "$file" =~ .*"$2"$ ]]; then # termina con $2
            echo "$file que se encuentra en $path sufrio un ( $action )" # mostralo
        fi
	done

exit

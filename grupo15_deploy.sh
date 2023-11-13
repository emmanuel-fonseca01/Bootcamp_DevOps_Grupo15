
#!/bin/bash

##STAGE_ONE##

if [ "$(whoami)" == "root" ];
then
	echo "Usuario valido"
else
	echo "usuario invalido"
	exit
fi

#######Usuario_Verificado#######

echo "Actualizacion en progreso"
apt-get update
sleep 3
echo "Actualizacion completa"


echo "Procediendo a verificar paquetes"

#apache
if dpkg -l | grep -q "apache2\|mariadb-server\|git\|php\|curl";
then
	echo "Paquetes instalados"
else
	echo "Instalando paquetes"

	#apache
	if ! dpkg -l | grep -q "apache2";
	then
		apt install apache2 -y
	fi

	#mariaDB
	if ! dpkg -l | grep -q "mariadb-server";
	then
		apt install mariadb-server -y
	
	fi

	#git
	if ! dpkg -l | grep -q "git";
	then
		apt install git -y
	fi

	#PHP
	if ! dpkg -l | grep -q "php";
	then
		apt install php -y
		apt install php-mysql php-xml php-gd php-mbstring php-bcmath -y
	fi

	#Curl
	if ! dpkg -l | grep -q "curl";
	then
		apt install curl -y
	fi
	echo "Todos los paquetes instalados"
fi
sleep 2
###PaquetesVerificados###

echo "Procediendo a habilitar paquetes"

#Apache
sudo systemctl start apache2
sudo systemctl enable apache2
mv /var/www/html/index.html /var/www/html/index.html.bkp



#mariaDB
sudo systemctl start mariadb
sudo systemctl enable mariadb

echo "Los paquetes han sido habilitados"
sleep 2
###PaquetesHabilitados###


echo "Procediendo a configurar la base de datos"
mysql -e "CREATE DATABASE devopstravel;
CREATE USER 'codeuser'@'localhost' IDENTIFIED BY 'codepass';
GRANT ALL PRIVILEGES ON *.* TO 'codeuser'@'localhost';
FLUSH PRIVILEGES;"

###mariaDBconfigurada###

echo "=================================================="


##STAGE_TWO##


echo "Verificando repositorio"
REPO="bootcamp-devops-2023"
WHERE_REPO="clase2-linux-bash"


if [ -d "$REPO" ]; 
then
	echo "El repositorio previamente fue clonado"
	cd "$REPO" || exit
	git pull origin "$WHERE_REPO"
else
	echo "Procediendo a clonar repositorio"
	git clone https://github.com/roxross/"$REPO".git
	cd "$repo" || exit
	git checkout "$WHERE_REPO"
	
fi
sleep 3


echo "Testeando el codigo"

cd "/root/BootCamp-DevOps-roxross"
if [ -d "$REPO/app-295devops-travel" ]; then
	echo "El codigo del app ya existe"
else
	echo "Procediendo a copiar el codigo del app"
	cp -r "$REPO/app-295devops-travel"/* /var/www/html


if test -f "/var/www/html/index.php";
then 
	echo "El codigo ha sido copiado"
fi

echo "Comprobando"
sleep 3

sudo systemctl reload apache2
curl localhost/info.php


echo "==================================================================="

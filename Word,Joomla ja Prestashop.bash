#!/bin/bash
clear

#Seda paketi läheb vaja et näidata dialoogi
apt-get install -y dialog

#Dialoog 1
dialog --title "Wordpressi skript" --msgbox 'Antud skript on mõeldud ubuntu 14.04 jaoks!' 10 30
#Dialoog 2
dialog --title "Wordpressi skript" --msgbox 'Palun käivitage see skript ROOT õigustes.!' 10 30
#Dialoog 3
dialog --title "Wordpressi skript" --msgbox 'Jätke kõik paroolid meelde!' 10 30

#LAMP Serveri paigaldus - Kui pakette pole siis paigaldab need

#enne tuleks teha igaksjuhuks ära update ja ka upgrade
apt-get upgrade
apt-get update

#Paigaldan Apache2 veebiserveri
apt-get install apache2

#Paigaldan Mysql-serveri ja klient tarkvara serverile
apt-get install mysql-server mysql-client

#Paigaldan PHP5 peale
apt-get install php5 php5-mysql libapache2-mod-php5


#Teen Wordpressi jaoks andmebaasi

#Puhastan ekraani
clear

#Küsin kasutajalt andmebaasi parooli
echo "Palun sisesta Wordpressi andmebaasi parool"

#Muudan sisestatud väärtuse muutujaks
read -r PASSWDDB

# replace "-" with "_" for database username

#Puhastan ekraani
clear

#Küsin kasutajaöt andmebaasi nime ja samuti andmebaasi kasutaja nime
echo "Palun sisesta Wordpressi andmebaasi nimi (see on ka andmebaasi kasutaja nimi)"

#Muudan sisestatud väärtuse muutujaks
read -r MAINDB 

#Puhastan ekraani
clear

# If /root/.my.cnf exists then it won't ask for root password
if [ -f /root/.my.cnf ]; then

    mysql -e "CREATE DATABASE ${MAINDB} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
    mysql -e "CREATE USER ${MAINDB}@localhost IDENTIFIED BY '${PASSWDDB}';"
    mysql -e "GRANT ALL PRIVILEGES ON ${MAINDB}.* TO '${MAINDB}'@'localhost';"
    mysql -e "FLUSH PRIVILEGES;"

# If /root/.my.cnf doesn't exist then it'll ask for root password   
else
    echo "Palun sisesta MYSQL (root) parool"
    read -r rootpasswd
    mysql -uroot -p${rootpasswd} -e "CREATE DATABASE ${MAINDB} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
    mysql -uroot -p${rootpasswd} -e "CREATE USER ${MAINDB}@localhost IDENTIFIED BY '${PASSWDDB}';"
    mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON ${MAINDB}.* TO '${MAINDB}'@'localhost';"
    mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"

#lõpetan if funktsiooni	
fi
	
echo "1. Andmebaas Wordpressi jaoks on valmis"

#Lähen Juurkausta
cd ~

#Laen alla Wordpressi kõige uuema versiooni
wget http://wordpress.org/latest.tar.gz

#Pakin arhiivi lahti
tar xzvf latest.tar.gz

#Teen update ära
sudo apt-get update

#Laen alla php5 ja libssh2 paketid, kuna neid läheb vaja meil wordpressi jaoks
sudo apt-get install php5-gd libssh2-php

#Lähen wordpressi kataloogi
cd ~/wordpress

#Loon sample konfiguratsiooni failist wp-config.php faili, ning muudan selle sisu natuke
cp wp-config-sample.php wp-config.php

perl -pi -e "s/database_name_here/$MAINDB/g" wp-config.php
perl -pi -e "s/username_here/$MAINDB/g" wp-config.php
perl -pi -e "s/password_here/$PASSWDDB/g" wp-config.php


perl -i -pe'
  BEGIN {
    @chars = ("a" .. "z", "A" .. "Z", 0 .. 9);
    push @chars, split //, "!@#$%^&*()-_ []{}<>~\`+=,.;:/?|";
    sub salt { join "", map $chars[ rand @chars ], 1 .. 64 }
  }
  s/put your unique phrase here/salt()/ge
' wp-config.php

#Viin failid üle /var/www/html kausta
sudo rsync -avP ~/wordpress/ /var/www/html/wordpress

#Lähen sinna kausta sisse
cd /var/www/html/wordpress

#Muudan kausta sisu õigused ära
sudo chown -R www-data:www-data *

sudo chown ww-data:www-data /var/www/html/wordpress

#Loon uploads kausta wp-contents kausta
mkdir /var/www/html/wordpress/wp-content/uploads

#Annan Apachele õigused uploads kaustale
sudo chown -R www-data:www-data /var/www/html/wordpress/wp-content/uploads

#Puhastan ekraani
clear

dialog --title "Wordpressi skript" --msgbox 'Wordpressi paigaldus on valmis, palun avage interneti brauser ja siirduge aadressile http://localhost/wordpress/' 10 30

#Nüüd kustutan üleliiksed failid ära

#Lähen Juurkausta
cd ~
#Kustutan allalaetud wordpressi arhiivi ära
sudo rm -rf latest.tar.gz
#Kustutan seal ära "wordpress" kausta
sudo rm -rf wordpress


#Joomla

#####Andmebaas

dialog --title "Joomla skript" --msgbox 'Joomla paigalduse alustamine' 10 30

#Puhastan ekraani
clear

#Küsin kasutajalt andmebaasi parooli
echo "Palun sisesta Joomla andmebaasi parool"

#Muudan sisestatud väärtuse muutujaks
read -r PASSWDDB1

# replace "-" with "_" for database username

#Puhastan ekraani
clear

#Küsin kasutajaöt andmebaasi nime ja samuti andmebaasi kasutaja nime
echo "Palun sisesta Joomla andmebaasi nimi (see on ka andmebaasi kasutaja nimi)"

#Muudan sisestatud väärtuse muutujaks
read -r MAINDB1



# If /root/.my.cnf exists then it won't ask for root password
if [ -f /root/.my.cnf ]; then

    mysql -e "CREATE DATABASE ${MAINDB1} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
    mysql -e "CREATE USER ${MAINDB1}@localhost IDENTIFIED BY '${PASSWDDB1}';"
    mysql -e "GRANT ALL PRIVILEGES ON ${MAINDB1}.* TO '${MAINDB1}'@'localhost';"
    mysql -e "FLUSH PRIVILEGES;"

# If /root/.my.cnf doesn't exist then it'll ask for root password   
else
    echo "Palun sisesta MYSQL (root) parool"
    read -r rootpasswd
    mysql -uroot -p${rootpasswd} -e "CREATE DATABASE ${MAINDB1} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
    mysql -uroot -p${rootpasswd} -e "CREATE USER ${MAINDB1}@localhost IDENTIFIED BY '${PASSWDDB1}';"
    mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON ${MAINDB1}.* TO '${MAINDB1}'@'localhost';"
    mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"

#lõpetan if funktsiooni	
fi
	
#Puhastan ekraani	
clear

#Teen apache2 teenusele restardi
service apache2 restart
#Teen MySQL serverile restardi
service mysql restart

#Lähen Temp kausta
cd /tmp

#Laen alla Joomla arhiivi
wget https://downloads.joomla.org/cms/joomla3/3-6-4/joomla_3-6-4-stable-full_package-zip?format=zip

#Laen alla Unzip paketi
sudo apt-get install -y unzip

#teen joomla kataloogi /var/www/htmli
mkdir -p /var/www/html/joomla

#Unzipin paketi
unzip -q joomla_3-6-4-stable-full_package-zip?format=zip -d /var/www/html/joomla

#Annan kataloogi apache deemonile
sudo chown -R www-data.www-data /var/www/html/joomla

#annan käivitamise õigused joomla kataloogile
sudo chmod -R 755 /var/www/html/joomla

#Puhastan ekraani
clear

rm -rf /tmp/joomla*

#Lõpetan skripti andes teada et kuhu edasi suunduda
dialog --title "Joomla skript" --msgbox 'Palun minge veebibrauseris http://localhost/joomla et paigaldus lõpuni teha' 10 30



#Prestashop

dialog --title "Prestashopi skript" --msgbox 'Prestashopi paigalduse alustamine' 10 30

#Puhastan ekraani
clear

#Küsin kasutajalt andmebaasi parooli
echo "Palun sisesta Prestashopi andmebaasi parool"

#Muudan sisestatud väärtuse muutujaks
read -r PASSWDDB2

# replace "-" with "_" for database username

#Puhastan ekraani
clear

#Küsin kasutajaöt andmebaasi nime ja samuti andmebaasi kasutaja nime
echo "Palun sisesta Prestashopi andmebaasi nimi (see on ka andmebaasi kasutaja nimi)"

#Muudan sisestatud väärtuse muutujaks
read -r MAINDB2

# If /root/.my.cnf exists then it won't ask for root password
if [ -f /root/.my.cnf ]; then

    mysql -e "CREATE DATABASE ${MAINDB2} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
    mysql -e "CREATE USER ${MAINDB2}@localhost IDENTIFIED BY '${PASSWDDB2}';"
    mysql -e "GRANT ALL PRIVILEGES ON ${MAINDB2}.* TO '${MAINDB2}'@'localhost';"
    mysql -e "FLUSH PRIVILEGES;"

# If /root/.my.cnf doesn't exist then it'll ask for root password   
else
    echo "Palun sisesta MYSQL (root) parool"
    read -r rootpasswd
    mysql -uroot -p"${rootpasswd} -e "CREATE DATABASE ${MAINDB2} /*\!40100 DEFAULT CHARACTER SET utf8 */;""
    mysql -uroot -p${rootpasswd} -e "CREATE USER ${MAINDB2}@localhost IDENTIFIED BY '${PASSWDDB2}';"
    mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON ${MAINDB2}.* TO '${MAINDB2}'@'localhost';"
    mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"

#lõpetan if funktsiooni	
fi

#Lähen TMP kausta
cd /tmp

#Laen alla prestashopi arhiivi
wget https://download.prestashop.com/download/releases/prestashop_1.6.1.10.zip

#teen prestashopile uue kataloogi /var/www/html alla
mkdir /var/www/html/prestashop

#Pakin terve arhiivi alla
unzip -q prestashop_1.6.1.10.zip -d /var/www/html/

#Annan apache deemonile õigused kaustale
chown -R www-data:www-data /var/www/html/prestashop/

#Lõpetuseks teen apachele restardi
service apache2 restart
#Samuti ka Mysql serverile
service mysql restart

#Kustutan allalaetud arhiivi ära
rm -rf /tmp/prestashop*

dialog --title "Prestashopi skript" --msgbox 'Palun siirduge http://localhost/prestashop/install läbi veebibrauseri' 10 30
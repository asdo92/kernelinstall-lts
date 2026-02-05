#!/bin/bash
# Kernel Installer by Alexia Michelle <alexia@goldendoglinux.org>
# License GNU GPL 3.0 (See License for more Information)

# Este es un script para quienes deseen compilar el programa. Si no querés compilarlo podes simplemente correr
# ./kernel-installer-lts

compilar() {
sudo apt install -y gcc make gettext libncurses-dev pkg-config libncursesw5-dev
make clean
make
sudo make install
kernel-installer-lts
}


echo -e "\nEste es un script para quienes deseen compilar el programa.\nSi no lo quieres compilar, puedes simplemente ejecutar ./kernel-installer-lts.\nTambién requiere sudo. Si tu sistema no tiene sudo, ejecutalo como root\n\n¿Deseas Compilar de todos modos? [S/N]"
read i

case $i in

Y|y|S|s)
compilar
;;
N|n)
echo -e "\nAbortando."
;;
*)
echo "Opcion incorrecta"
;;
esac

#!/bin/bash

#####################################
# Author: Monish Palanikumar
# Version: v1.0
# Date: 04/05/2021
# Description: Enumeration Script
# Usage: ./enum.sh
#####################################

if [[ $# -ne 1 ]]; then
    echo "----------------------------------------------------"
    echo "Incorrect usage!"
    echo "Usage: $0 <website to be enumerated>"
    echo "----------------------------------------------------"
    exit 1
fi

url=$1

if [ ! -x "$(command -v assetfinder)" ]; then
    echo "[-] assetfinder required to run script"
    echo "----------------------------------------------------"
    exit 1
fi

if [ ! -x "$(command -v sublist3r)" ]; then
    echo "[-] sublist3r required to run script"
    echo "----------------------------------------------------"
    exit 1
fi

if [ ! -x "$(command -v subfinder)" ]; then
    echo "[-] subfinder required to run script"
    echo "----------------------------------------------------"
    exit 1
fi

if [ ! -x "$(command -v httprobe)" ]; then
    echo "[-] httprobe required to run script"
    echo "----------------------------------------------------"
    exit 1
fi

if [ ! -d "$url" ];then
    mkdir $url
fi

if [ ! -d "$url/recon" ];then
    mkdir $url/recon
fi

echo "----------------------------------------------------"
echo "[+] Starting assetfinder"
assetfinder --subs-only $url > ./$url/recon/assetfinder.txt
echo "[+] Assetfinder done. View results in ${url}/recon/assetfinder.txt"
echo "----------------------------------------------------"

echo "[+] Starting subfinder"
subfinder -d $url -o ./$url/recon/subfinder.txt
echo "[+] Subfinder done. View results in ${url}/recon/subfinder.txt"
echo "----------------------------------------------------"

echo "[+] Starting sublist3r"
sublist3r -d $url -o ./$url/recon/1.txt
sed s/"<BR>"/\n/g ./$url/recon/1.txt > ./$url/recon/sublister.txt
rm ./$url/recon/1.txt
echo "[+] Sublist3r done. View results in ${url}/recon/sublister.txt"
echo "----------------------------------------------------"


echo "[+]Consolidating final list of domains"
paste -sd"\n" ./$url/recon/*.txt | sort -u > ./$url/recon/appended.txt
echo "[+] Done consolidating. View results in ${url}/recon/appended.txt"
echo "----------------------------------------------------"

echo "[+] Getting live domains"
cat ./$url/recon/appended.txt | httprobe -c 100 -t 5000 | tee -a  ./$url/recon/FINAL.txt
echo "[+] Done Getting live websites."
echo "----------------------------------------------------"

echo "Enumeration Completed !"
echo -e "You can now view the results in ${url}/recon/FINAL.txt"
echo "----------------------------------------------------"
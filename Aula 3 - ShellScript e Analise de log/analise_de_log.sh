#!/bin/bash

banner()
{
    echo "Use: ./analise_log.sh Opcao"
    echo "Ex: ./analise_log.sh 1"
    echo ""
    echo "Opções:"
    echo "1 - listar ips"
    echo "2 - Primeiro e Ultimo Acesso de um IP"
    echo "3 - Detectar possíveis ataques de XSS (Cross-Site Scripting)"
    echo "4 - Detectar tentativas de SQL Injection"
    echo "5 - Detectar varredura de diretórios (Directory Traversal)"
    echo "6 - Detectar possíveis ataques por scanners (User-Agent suspeito)"
    echo "7 - Identificar tentativas de acesso a arquivos sensíveis (.env, .git, etc.)"
    echo "8 - Detectar possíveis ataques de força bruta a arquivos/pastas"
    echo "9 - Localizar user-agent utilizado por um IP suspeito"
    echo "10 - Listar os ips e verificar o numero de requisições"
    echo "11 - Localizar acesso a um determinado arquivo sensível"
}
banner2()
{
    echo ""
    echo "By Jefferson Oliveira"
}

if [ -z ${1} ]
then
    banner
    banner2
exit
elif [  ${1} == "1" ]
then
    echo "Listando IPs"
    cat access.log | cut -d " " -f1 | sort | uniq
elif [ ${1} == "2" ]
then
    echo "Primeiro e Ultimo Acesso de um IP"
    read ip
    echo "Primeiro Acesso:"
    cat access.log | grep "$ip" | head -n1
    echo "Ultimo Acesso:"
    cat access.log | grep "$ip" | tail -n1 
elif [ ${1} == "3" ]
then
    echo "Detectar possíveis ataques de XSS (Cross-Site Scripting)"

    grep -iE "<script|%3Cscript" access.log
elif [ ${1} == "4" ]
then
    echo "Detectar tentativas de SQL Injection"

    grep -iE "union|select|insert|drop|%27|%22" access.log
elif [ ${1} == "5" ]
then
    echo "Detectar varredura de diretórios (Directory Traversal)"
  
    grep -E "\.\./|\.\.%2f|/admin|/login|/wp-admin|/phpmyadmin|/\.git|/backup|/uploads|/config|/api|/test" access.log
elif [ ${1} == "6" ]
then
    echo "Detectar possíveis ataques por scanners (User-Agent suspeito)"
   
    grep -iE "nikto|nmap|sqlmap|acunetix|curl|masscan|python|java|html|txt" access.log
elif [ ${1} == "7" ]
then
    echo "Identificar tentativas de acesso a arquivos sensíveis (.env, .git, etc.)"
   
    grep -iE "\.env|\.git|\.htaccess|\.bak" access.log
elif [ ${1} == "8" ]
then
    echo "Detectar possíveis ataques de força bruta a arquivos/pastas"
    
    grep " 404 " access.log | cut -d " " -f 1 | sort | uniq -c | sort -nr | head
elif [ ${1} == "9" ]
then
    echo "Localizar user-agent utilizado por um IP suspeito"
    read ip 
    grep "$ip" access.log | cut -d '"' -f 6 | sort | uniq
elif [ ${1} == "10" ]
then
    echo "Listar os ips e verificar o numero de requisições"
    
    cat access.log | cut -d " " -f 1 | sort | uniq -c #| sort -nr | head
elif [ ${1} == "11" ]
then
    echo "Localizar acesso a um determinado arquivo sensível"
    echo "Digite o nome do arquivo (ex: .env, .git, wp-config.php):"
    read arquivo
    grep "$arquivo" access.log
else
    while true;do
        banner
        banner2
        #exit 
    done
fi

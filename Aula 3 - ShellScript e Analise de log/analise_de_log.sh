#!/bin/bash

banner()
{
    echo "Use: ./script.sh Opcao"
    echo "Ex: ./script 1"
    echo ""
    echo "listar ips: 1"
    echo "Primeiro e Ultimo Acesso de um IP: 2"
    echo "Ultimo Acesso de um IP: 3"
}
banner2()
{
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
    cat access.log | grep "$ip" | head -n1
    cat access.log | grep "$ip" | tail -n1 
elif [ ${1} == "3" ]
then
    echo "Detectar possíveis ataques de XSS (Cross-Site Scripting)"

    grep -iE "<script|%3Cscript" access.log
elif [ ${1} == "4" ]
then
    echo "Detectar tentativas de SQL Injection)"

    grep -iE "union|select|insert|drop|%27|%22" access.log
elif [ ${1} == "5" ]
then
    echo "Detectar varredura de diretórios (Directory Traversal)"
  
    grep -E "\.\./|\.\.%2f" access.log
elif [ ${1} == "6" ]
then
    echo "Detectar possíveis ataques por scanners (User-Agent suspeito)"
   
    grep -iE "nikto|nmap|sqlmap|acunetix|curl|masscan|python" access.log
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
    cho "Localizar user-agent utilizado por um IP suspeito "
    read ip 
    grep "$ip" access.log | cut -d '"' -f 6 | sort | uniq
elif [ ${1} == "10" ]
then
    echo "Listar os ips e verificar o numero de requisições"
    
    cat access.log | cut -d " " -f 1 | sort | uniq -c #| sort -nr | head
elif [ ${1} == "11" ]
then
    echo "Localizar acesso a um determinado arquivo sensível"
    read arquivo
    grep "$arquivo" access.log
else
    banner
    banner2
    exit
fi
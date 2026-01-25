#!/bin/bash

banner()
{
    echo "Use: ./analise_log.sh Opcao"
    echo "Ex: ./analise_log.sh 1"
    echo ""
    echo "Importe para um arquivo txt para melhor visualização dos resultados"
    echo "Ex: ./analise_log.sh 1 > possiveis_xss.txt"
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
banner3()
{
    echo "Analise de log - Script para auxiliar na analise de logs de servidores web"
    echo "GitHub:https://github.com/jeffersonestacio46"
}

if [ -z ${1} ]
then
    banner
    banner2
    banner3
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
    echo "Detectar possíveis ataques de XSS (Cross-Site Scripting)";
    grep -iE "<script>|%3Cscript|%3C%73%63%72%69%70%74|%3C%2Fscript%3E|alert\(\)|%2F|%3D|%3A|%22|%27|%2|%3Cscript%3E|%3Cimg%20src%3Dx%20onerror%3Dalert%281%29%3E|javascript%3Aalert%281%29" access.log
elif [ ${1} == "4" ]
then
    echo "Detectar tentativas de SQL Injection";
    grep -iE "union|select|insert|drop|%27|%22|' OR 1=1 --|%27%20OR%201%3D1%20--|%2527%2520OR%25201%253D1%2520--" access.log
elif [ ${1} == "5" ]
then
    echo "Detectar varredura de diretórios (Directory Traversal)";
    grep -E "\.\./|\.\.%2f|/admin|/login|/wp-admin|/phpmyadmin|/\.git|/backup|/uploads|/config|/api|/test|robots" access.log
elif [ ${1} == "6" ]
then
    echo "Detectar possíveis ataques por scanners"
    grep -iE "nikto|nmap|sqlmap|acunetix|curl|masscan|python|java|html|txt" access.log
elif [ ${1} == "7" ]
then
    echo "Identificar tentativas de acesso a arquivos sensíveis";   
    grep -iE "\.env|\.git|\.htaccess|\.bak|.git/config|wp-config.php|config.json|.htaccess|.htpasswd|/admin/|/backup/|/config/|/backup.zip|sql.gz|404|403" access.log
elif [ ${1} == "8" ]
then
    echo "Lista de IPs com tentativas falhas em possíveis ataques de força bruta(404):"
    grep " 404 " access.log | cut -d " " -f 1 | sort | uniq -c | sort -nr | head;
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
    grep "$arquivo" access.log > arquivo_acessos.txt
else
    echo "Opção inválida. Use uma das opções abaixo:"
    banner
    for i in {1..11}
    do
        echo "Opção $i"
    done
fi

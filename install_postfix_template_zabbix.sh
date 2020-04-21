#!/bin/bash

set -e

# Script de instalacion de monitoreo de postfix para zabbix (no incluye instalacion de zabbix agent)
# Basado en: https://githubusercontent.com/rafael747/zabbix-postfix

# scripts necesarios

echo -e "\n#### Descargando e instalando scripts ####\n"

cd /usr/local/sbin

echo -n "Baixando scripts..."

wget -q -N https://raw.githubusercontent.com/rmatiuhart/zabbix-postfix/master/zabbix_postfix.sh >/dev/null
wget -q -N https://raw.githubusercontent.com/matiuhart/zabbix-postfix/master/zabbix_postfix_totals.sh
wget -q -N https://raw.githubusercontent.com/matiuhart/zabbix-postfix/master/pygtail.py > /dev/null

echo  "OK!"

chmod +x pygtail.py
chmod +x zabbix_postfix.sh

# regra permitindo zabbix executar comandos

cd /etc/sudoers.d/

echo -n "Descargando e instalando sudoers..."

wget -q -N https://raw.githubusercontent.com/matiuhart/zabbix-postfix/master/zabbix_postfix >/dev/null

echo "OK!"

chmod 440 zabbix_postfix

# Configuracion de zabbix (mailq infomacao)

cd /etc/zabbix/zabbix_agentd.conf.d/

echo -n "Descargando e instalando archivo de user parameters para Zabbix agent..."

wget -q -N https://raw.githubusercontent.com/matiuhart/zabbix-postfix/master/zabbix_postfix.conf >/dev/null

echo "OK!"

echo -n "Reiniciando servicios..."
service sudo restart >/dev/null
service zabbix-agent restart >/dev/null

echo "OK!"

echo "Se deben instalar los siguientes paquetes que son dependencias: pflogsumm (visualizador de logs de postfix) y bc (calculadora) ..."
echo "Debian/Ubuntu"
echo "apt-get install pflogsumm bc"
echo ""
echo "RHEL/Centos"
echo "yum install postfix-perl-scripts bc"

echo -e "\nSe deben adicioinar los siguientes crones:\n"

echo '# Zabbix check'
echo '*/5 * * * * /usr/local/sbin/zabbix_postfix.sh 1>/dev/null 2>/dev/null'
echo '# Zabbix check totales enviados/recibidos diarios'
echo '59  23    *   *  * /usr/local/sbin/zabbix_postfix_totals.sh 1>/dev/null 2>/dev/null''

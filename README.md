# zabbix-postfix
Pantilla de Zabbix para monitoreo de Postfix

El proyecto original no traía estadisticas de mails totales diarios enviados/recibidos, por lo que se realizó un fork y se agregaron script e items en plantilla necesarios para guardar éstas estadísticas al final del día (23.59hs)

En el Server:
 * Importar la plantilla **template_postfix.xml**
    
En el cliente: 

 * Instalar **zabbix-agent**
 * Ejecutar **install_postfix_template_zabbix.sh** para instalar los scripts necesacios para el chequeo
 
 ### O

    # Instalar paquetes necesarios
    
    # Debian/Ubuntu
    apt-get install pflogsumm bc
    
    # RHEL/Centos
    yum install postfix-perl-scripts bc

    cp zabbix_postfix.sh /usr/local/sbin/
    cp pygtail.py /usr/local/sbin/
    chmod +x /usr/local/sbin/pygtail.py
    chmod +x /usr/local/sbin/zabbix_postfix.sh
    
    cp zabbix_postfix /etc/sudoers.d/
    chmod 440 /etc/sudoers.d/zabbix_postfix
    
    cp zabbix_postfix.conf /etc/zabbix/zabbix_agentd.conf.d/
    
    service sudo restart
    service zabbix-agent restart
    
 * Adicionar crontabs
 
    ```
    # Zabbix check general
    */5 * * * * /usr/local/sbin/zabbix_postfix.sh 1>/dev/null 2>/dev/null'

    # Zabbix check totales enviados/recibidos diarios
    59  23    *   *  * /usr/local/sbin/zabbix_postfix_totals.sh 1>/dev/null 2>/dev/null'

    ```



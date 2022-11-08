# Monitoring service for ssl certificate's expiration date with Zabbix Server and Zabbix Sender 

## Installation
1. Clone repo:

```$ git clone https://github.com/nenavizhuleto/scripts.git```

2. Cd into *scripts* directory:

```$ cd scripts/```

3. Run installer:

```
# ./ssl_expire_install
```

4. Edit config file:

```# vim /etc/ssl_expire/ssl_expire.conf```

5. Start service:

```# systemctl start ssl_expire_mon.service```

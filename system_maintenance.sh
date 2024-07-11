#!/bin/bash
if [ "$(whoami)" != "root" ]; then
    echo "Ejecutar este script como superuser"
    exit 1
fi
echo "Realizando las actualizaciones del sistema"
echo ""
apt-get update
echo "Sistema al día"
echo ""
echo "Removiendo paquetes innecesarios"
echo ""
apt autoremove -y
echo "Paquetes eliminados con exito"
echo ""
echo ""
freemem_before=$(cat /proc/meminfo | grep MemFree | tr -s ' ' | cut -d ' ' -f2) && freemem_before=$(echo "$freemem_before/1024.0" | bc)
cachedmem_before=$(cat /proc/meminfo | grep "^Cached" | tr -s ' ' | cut -d ' ' -f2) && cachedmem_before=$(echo "$cachedmem_before/1024.0" | bc)
echo -e "Limpiando memoria en cache.\n\nEn este momento tienes $cachedmem_before MiB en cache y $freemem_before MiB memoria libre"
echo ""
if [ "$?" != "0" ]
then
  echo "Algo salió mal, es imposible hacer syncronización de sistema de archivos"
  exit 1
fi
sync && echo 3 > /proc/sys/vm/drop_caches
freemem_after=$(cat /proc/meminfo | grep MemFree | tr -s ' ' | cut -d ' ' -f2) && freemem_after=$(echo "$freemem_after/1024.0" | bc)
echo -e "Memoria liberada $(echo "$freemem_after - $freemem_before" | bc) MiB, ahora tienes $freemem_after MiB de memoria libre en RAM."
echo ""
echo "Este es tu actual estado del disco:"
echo ""
df -h
echo "Estos son los actuales usuarios configurados para el sistema:"
echo ""
awk -F: '{ print $1 }' /etc/passwd
echo "Favor ver el top 5 de procesos consumiendo CPU en el sistema"
echo ""
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6
exit 1
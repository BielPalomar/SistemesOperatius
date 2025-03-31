#!/bin/bash

echo "=========================================="
echo "  GESTOR DE PROCESOS - PLANTA DE TRATAMIENTO DE AGUA"
echo "=========================================="
echo ""
echo "Procesos activos de tratamiento:"
proc=$( ps -Ao pid,ni,time,cmd | head -n 6)
echo "$proc"

option=-1
while [[ option -ne 5 ]]; do
  echo ""
  echo "Opciones:"
  echo "1. Detener un proceso"
  echo "2. Cambiar prioridad de un proceso"
  echo "3. Reiniciar un proceso"
  echo "4. Ver estadísticas de la planta"
  echo "5. Salir"
  echo ""
  echo -n "Seleccione una opción (1-5): "
  read option

  case "$option" in
    1)
      echo -n "Introduzca el ID del proceso: "
      read procId
      echo "Intentando detener el proceso $procId..."
      kill $procId
      if [[ $? -eq 0 ]]; then
        echo "Proceso detenido correctamente"
      else
        echo "Ha habido un error al detener el proceso"
      fi
    ;;
    2)
      echo -n "Introduzca el ID del proceso: "
      read procId
      echo -n "Introduzca el nuevo valor de prioridad (-20 a 19, menor es más prioritario): "
      read newNice
      echo "Cambiando prioridad del proceso $procId a $newNice..."
      renice $newNice $procId > /dev/null
      if [[ $? -eq 0 ]]; then
        echo "Prioridad cambiada correctamente"
      else
        echo "Ha habido un error al cambiar la prioridad"
      fi
    ;;
    3)
      echo -n "Introduzca el ID del proceso: "
      read procId
      echo "Reiniciando el proceso $procId" # Basta con un mensaje informativo segun el enunciado
      echo "Proceso $procId reiniciado correctamente"
    ;;
    4)
      echo "Estadísticas de la Planta de Tratamiento de Agua"
      echo "------------------------------------------------"
      echo "Uso de memoria:"
      echo "$(free -h)"
      echo ""
      echo "Carga del sistema:"
      echo "$(uptime)"
      echo ""
      echo "Uso de disco:"
      echo $(df -h | head -n 2 | tail -n 1)
      echo ""
      echo "Procesos más intensivos en CPU:"
      echo ""
      echo "$(top -b -o +%CPU | head -n 12 | tail -n 6)"
      echo ""
      echo "Presione Enter para continuar..."
      read
    ;;
    5)
      ;;
    *) echo "Opción no válida"
    ;;
  esac
  
done


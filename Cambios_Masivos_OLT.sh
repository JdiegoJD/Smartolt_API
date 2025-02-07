#!/bin/bash

. Funciones_API_SMARTOLT.sh

Pedir_Plan_Bajada () {
echo "Ingrese el nuevo plan de bajada que desea colocar"
read DOWN_PLAN
return 0
}

Pedir_Plan_Subida () {
echo "Ingrese el nuevo plan de subida que desea colocar"
read UP_PLAN
return 0
}

Pedir_Perfil () {
echo "Ingrese el perfil de velocidad"
read speed_profile
return 0
}

Pedir_Vlan () {
echo "Ingrese la nueva Vlan que desea colocar"
read vlan_nueva
return 0
}

Pedir_Archivo () {
echo "Ingrese la ubicacion del archivo con los seriales de las ONUs a las que desea aplicar los cambios"
read SN_onus
return 0
}

Elegir_OLT () {

        echo "En cual OLT desea aplicar los cambios?"

        c=0

        for i in ${olt_name[*]}; do

                c=$(($c + 1))

                echo "$c - $i"

        done

        read index

        index=$(($index - 1))
}


Obtener_Interfaz () {

	variable1=$(grep -Eo 'interface gpon_onu-[1-9]..[1-5]..1?[0-9]:[0-9]{1,3}' .onu.txt)

	variable2=$(echo $variable1 | sed -n s/'\\'//gp)

	variable3=$(echo $variable2 | sed -n s/':'/\./p)

	interface_id=$(echo $variable3 | sed -n s/"interface gpon_onu-"//gp)
}

Crear_Vport () {

{\
        echo "${olt_user[$index]}";\
        echo "${olt_pswd[$index]}";\
        sleep 1;\
        echo "conf t";\
        echo "interface vport-$interface_id:1";\
        echo "service-port 1 user-vlan $vlan_nueva vlan $vlan_nueva";\
        echo "qos traffic-policy SMARTOLT-$speed_profile-DOWN direction egress";\
        sleep 1;\
}\
| telnet ${olt_ip[$index]}
}

Pedir_Datos_Migracion () {

Mostrar_OLT

echo "Ingrese la OLT ID donde desea mover las ONUs"
read OLT_ID

echo "Ingrese la tarjeta a donde va a mover las ONUs"
read BOARD

echo "Ingrese el puerto a donde desea mover las ONUs"
read PORT
}

while [ true ]; do

cat <<EOF
Elija la operacion que desea realizar
1 - Cambiar Vlans
2 - Crear el Vport
3 - Cambiar Velocidad
4 - Resync Config
5 - Reiniciar Onus
6 - Mover Onus de PON
7 - Salir
EOF

read

	case "$REPLY" in
		1) Pedir_Vlan
		   Pedir_Archivo
		   lineas=$(wc -l $SN_onus | grep -Eo '^[0-9]+')
		   for i in $(seq $lineas); do
		   	onu_id=$(sed -n $i\p $SN_onus)
		   	Cambiar_Vlan
		   	Resync_Config
		   done
		   exit
		   ;;
		2) Elegir_OLT
		   Pedir_Vlan
		   Pedir_Perfil
		   Pedir_Archivo
		   lineas=$(wc -l $SN_onus | grep -Eo '^[0-9]+')
		   for i in $(seq $lineas); do
			onu_id=$(sed -n $i\p $SN_onus)
			Obtener_Info $onu_id > .onu.txt
			if grep 'service-port 1 user-vlan' .onu.txt > /dev/null; then
				continue
			fi
			Obtener_Interfaz
			Crear_Vport
		   done
		   exit
		   ;;
		3)
		   Pedir_Plan_Subida
		   Pedir_Plan_Bajada
		   Pedir_Archivo
		   lineas=$(wc -l $SN_onus | grep -Eo '^[0-9]+')
		   for i in $(seq $lineas); do
			onu_id=$(sed -n $i\p $SN_onus)
			Cambiar_velocidad
		   done
		   exit
		   ;;
		4)
		   Pedir_Archivo
		   lineas=$(wc -l $SN_onus | grep -Eo '^[0-9]+')
		   for i in $(seq $lineas); do
			onu_id=$(sed -n $i\p $SN_onus)
			Resync_Config
		   done
		   exit
		   ;;
		5)
		   Pedir_Archivo
		   lineas=$(wc -l $SN_onus | grep -Eo '^[0-9]+')
                   for i in $(seq $lineas); do
                        onu_id=$(sed -n $i\p $SN_onus)
                        Reboot
                   done
                   exit
                   ;;
		6) 
  		   Pedir_Archivo
                   Pedir_Datos_Migracion
                   lineas=$(wc -l $SN_onus | grep -Eo '^[0-9]+')
                   for i in $(seq $lineas); do
                        onu_id=$(sed -n $i\p $SN_onus)
                        Mover_Onus $OLT_ID $BOARD $PORT
                   done
                   exit
                   ;;

		7) exit
		   ;;
	esac

done

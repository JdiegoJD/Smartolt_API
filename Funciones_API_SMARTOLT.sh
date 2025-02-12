
. smartolt.conf

smartolt_URL="https://$Dominio.smartolt.com/api/onu"

Cambiar_velocidad () {
curl --location -g "$smartolt_URL/update_onu_speed_profiles/$onu_id" --header "X-Token: $API_KEY" \
-F "upload_speed_profile_name="$UP_PLAN"" \
-F "download_speed_profile_name="$DOWN_PLAN""
return 0
}

Cambiar_Vlan () {
curl --location -g "$smartolt_URL/update_main_vlan/$onu_id" \
--header "X-Token: $API_KEY" \
-F "vlan="$vlan_nueva""
return 0
}

Resync_Config () {
curl --location -g --request POST "$smartolt_URL/resync_config/$onu_id" \
--header "X-Token: $API_KEY"
return 0
}

Obtener_Info () {
curl --location -g "$smartolt_URL/get_running_config/$onu_id" \
--header "X-Token: $API_KEY"
return 0
}

Habilitar_Onu () {
curl --location -g --request POST "$smartolt_URL/enable/$onu_id" \
--header "X-Token: $API_KEY"
return 0
}

Quitar_MGMNT_IP () {
curl --location -g --request POST "$smartolt_URL/set_onu_mgmt_ip_inactive/$onu_id" \
--header "X-Token: $API_KEY"
return 0
}

Reboot () {
curl --location -g --request POST "$smartolt_URL/reboot/$onu_id" \
--header "X-Token: $API_KEY"
}

Mostrar_OLT () {
curl --location -g "https://$Dominio.smartolt.com/api/system/get_olts" \
--header "X-Token: $API_KEY"
}

Mover_Onus () {
curl --location -g "$smartolt_URL/move/$onu_id" \
--header "X-Token: $API_KEY" \
--form "olt_id="$1"" \
--form "board="$2"" \
--form "port="$3""
}


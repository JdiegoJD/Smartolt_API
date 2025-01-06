Programa de linea de comandos para el software Smartolt de redes FTTH. Este script esta escrito usando el bash de linux.


#		Explicacion de este programa

Este es un complemento para la gestion de ONUs con el software SMARTOLT ya que este no proporciona una forma directa de hacer cambios al mayor, debes realizarlos ONU por ONU.
Para cambiar la vlan o speed profile a muchisimas ONUs a la vez, es posible usar la API, la cual se encuentra en https://api.smartolt.com/.
Aqui se incluyen varias funciones basicas para facilitar el trabajo de usar la API, solo debes ejecutar el script y seleccionar entre las opciones disponibles.
Deberas proporcionar un archivo con los seriales de las ONUs a cambiar


#		Comenzar a utilizar

Antes que nada, deberas editar el archivo de configuracion smartolt.conf con la informacion de tus equipos
El dominio de tu smartolt y la API KEY son los unicos valores necesarios para que el script funcione
En caso de que no poseas una API KEY, puedes obtenerla desde la interfaz de SmartOLT
Para ello, ingresa a settings > general > API KEY
Opcionalmente puedes luego configurar parametros de red para cuantas OLT poseas
Deberas colocar un nombre, una IP y el usuario y la clave de acceso
Esto es porque en el script se incluyen funciones que se logean directamente a la OLT
Para la gran mayoria de usos, no sera necesario, pero igual esta incluido


#                  Uso

Una vez hayas ingresado la API KEY y el dominio, solo debes ejecutar Cambios_Masivos.sh
El programa es bastante intuitivo y te indicara que debes hacer. Luego hara todo de forma automatica.
Ten en cuenta que los valores que te pide ingresar como planes de velocidad o VLANs, ya deben estar creadas en la OLT
Para los archivos, puedes colocarlos en la misma carpeta donde ejecutas el script y solo colocar el nombre
De colocarlo en otro lado, deberas escribir la ruta completa

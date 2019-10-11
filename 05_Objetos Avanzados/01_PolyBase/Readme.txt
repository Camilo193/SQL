Requisitos para este ejemplo:
Una subscripción a Azure Portal.
INSTALAR MASE. : https://azure.microsoft.com/en-us/features/storage-explorer/
Instalar PolyBase con SQL Server Installation Center
Para instalar PolyBase debe contar con Server JRE: https://www.oracle.com/technetwork/java/javase/downloads/java-archive-javase8-2177648.html
Luego de instalar Polybase se activa el protocolo TCP/IP en SQL Network Configuration en Protocols for MSSQLSERVER - ver (TCP IP ENABLE).png
Si no activar el protocolo sacará un error al activar los servicios de PolyBase - ver (error).png
Cuando se activa el protocolo TCP/IP se reinicia el servicio de SQL Server(MSSQLSERVER)
Ahora si podremos activar SQL Server PolyBase Engine y SQL Server PolyBase Data Movement
Se debe crear una Storage Account
Subir el archivo llamado customers.csv a azure. - ver (container).png
Ya con todo esto configurado, podremos comenzar con nuestro ejemplo.
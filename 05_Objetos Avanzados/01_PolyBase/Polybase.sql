--Importamos la base de datos
USE WideWorldImporters;  
GO 
--Ejecutamos las siguientes configuraciones
EXEC sp_configure 'show advanced option', '1';  
RECONFIGURE; 
GO
EXEC sp_configure 'hadoop connectivity', 4; 
GO 
RECONFIGURE; 
GO
--------------------------------------------------------------------------------
--Creamos una clave maestra
CREATE MASTER KEY ENCRYPTION BY PASSWORD='MyP@ssword123secretword';
--------------------------------------------------------------------------------
--Creamos una credencial con la llave primaria o secundaria de nuestro Storage
--Ver la imagen llamada clave para saber como obtener la clave primaria o secundaria
CREATE DATABASE SCOPED CREDENTIAL mycredential  
WITH IDENTITY = 'credential', Secret = '+uDyQMQdSsYdJLvclFNBJfKa0ePMwTOM5Y2xgtUltuSFfVS/mM39jjbLTtFiGiHOJJ7R5dNVH5+Sg=='
--------------------------------------------------------------------------------
--Luego crearemos los datos externos. Esto se conectará a nuestra Cuenta Azure
-- tipo de los datos externos es Hadoop. Location es la localización del archivo almacenado. 
--Mycontainer es el nombre del contenedor creado en la Figura 5 y 
--polybasesstoragesqlshack es el nombre de la Cuenta de Azure Storage creada en el paso 4. 
--Blob.core.windows.net es parte de la dirección del contenedor que puede ser recuperado en MASE
--Ver imagen direccion
CREATE EXTERNAL DATA SOURCE mycustomers
WITH (
    TYPE = HADOOP,
    LOCATION = 'wasbs://mycontainer@polybasestoragesqlserver.blob.core.windows.net/',
    CREDENTIAL = mycredential
);
--------------------------------------------------------------------------------
--Creamos el formato para el archivo .csv
CREATE EXTERNAL FILE FORMAT csvformat 
WITH ( 
    FORMAT_TYPE = DELIMITEDTEXT, 
    FORMAT_OPTIONS ( 
        FIELD_TERMINATOR = ','
    ) 
);
--------------------------------------------------------------------------------
--Crearemos una tabla externa para consultar el archivo csv como una tabla SQL:
CREATE EXTERNAL TABLE customerstable
( 
    	name VARCHAR(128),
    	lastname VARCHAR(128),
email VARCHAR(100)
) 
WITH 
( 
    LOCATION = '/', 
    DATA_SOURCE = mycustomers, 
    FILE_FORMAT = csvformat
 
)
--------------------------------------------------------------------------------
--Hacemos un SELECT a los datos
SELECT name, lastname, email
FROM WideWorldImporters.dbo.customerstable

--------------------------------------------------------------------------------




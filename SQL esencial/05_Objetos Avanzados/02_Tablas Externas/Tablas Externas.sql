--Crear una tabla externa con datos en formato text-delimited
CREATE EXTERNAL DATA SOURCE mydatasource
WITH (
--Define un origen de los datos externos
    TYPE = HADOOP,
    LOCATION = 'hdfs://xxx.xxx.xxx.xxx:8020'
)

CREATE EXTERNAL FILE FORMAT myfileformat
WITH (
----Define formato de archivo externo
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS (FIELD_TERMINATOR ='|')
);

--Se referencian los objetos (database-level objects)
CREATE EXTERNAL TABLE ClickStream (
    url varchar(50),
    event_date date,
    user_IP varchar(50)
)
WITH (
        LOCATION='/webdata/employee.tbl',
        DATA_SOURCE = mydatasource,
        FILE_FORMAT = myfileformat
    )
;
------------------------------------------------------------------------------------------
--Crear una tabla externa con datos en formato RCFile
CREATE EXTERNAL DATA SOURCE mydatasource_rc
WITH (
--Define un origen de datos externo
    TYPE = HADOOP,
    LOCATION = 'hdfs://xxx.xxx.xxx.xxx:8020'
)

CREATE EXTERNAL FILE FORMAT myfileformat_rc
WITH (
--Define un formato de archivo externo
    FORMAT_TYPE = RCFILE,
    SERDE_METHOD = 'org.apache.hadoop.hive.serde2.columnar.LazyBinaryColumnarSerDe'
)
;
--Se referencias los objetos de nivel (database-level objects)
CREATE EXTERNAL TABLE ClickStream_rc (
    url varchar(50),
    event_date date,
    user_ip varchar(50)
)
WITH (
        LOCATION='/webdata/employee_rc.tbl',
        DATA_SOURCE = mydatasource_rc,
        FILE_FORMAT = myfileformat_rc
    )
;

------------------------------------------------------------------------------------------
--Crear una tabla externa con datos en formato ORC

--Define un origen de datos externo
CREATE EXTERNAL DATA SOURCE mydatasource_orc
WITH (
    TYPE = HADOOP,
    LOCATION = 'hdfs://xxx.xxx.xxx.xxx:8020'
)

--Define un formato de archivo externo
CREATE EXTERNAL FILE FORMAT myfileformat_orc
WITH (
    FORMAT = ORC,
    COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
)
;
--Se referencias los objetos de nivel (database-level objects)
CREATE EXTERNAL TABLE ClickStream_orc (
    url varchar(50),
    event_date date,
    user_ip varchar(50)
)
WITH (
        LOCATION='/webdata/',
        DATA_SOURCE = mydatasource_orc,
        FILE_FORMAT = myfileformat_orc
    )
;
------------------------------------------------------------------------------------------
--Consultar datos de Hadoop
--ClickStream es una tabla externa que se conecta al archivo de texto en un cluster Hadoop
SELECT TOP 10 (url) FROM ClickStream WHERE user_ip = 'xxx.xxx.xxx.xxx'
;
------------------------------------------------------------------------------------------
--Unir datos Hadoop con datos SQL
SELECT url.description
FROM ClickStream cs --ClickStream es una tabla externa
JOIN UrlDescription url ON cs.url = url.name
WHERE cs.url = 'msdn.microsoft.com'
;
------------------------------------------------------------------------------------------
--Importar datos de Hadoop a una tabla SQL
SELECT DISTINCT user.FirstName, user.LastName
INTO ms_user --Almacena el resultado del join entre la tabla de usuario y la tabla externa
FROM user INNER JOIN (
    SELECT * FROM ClickStream WHERE cs.url = 'www.microsoft.com'
    ) AS ms
ON user.user_ip = ms.user_ip
;
------------------------------------------------------------------------------------------
--Crear una tabla externa para una fuente de datos fragmentada (sharded)
CREATE EXTERNAL TABLE [dbo].[all_dm_exec_requests]([session_id] smallint NOT NULL,
  [request_id] int NOT NULL,
  [start_time] datetime NOT NULL,
  [status] nvarchar(30) NOT NULL,
  [command] nvarchar(32) NOT NULL,
  [sql_handle] varbinary(64),
  [statement_start_offset] int,
  [statement_end_offset] int,
  [cpu_time] int NOT NULL)
WITH
(
  DATA_SOURCE = MyExtSrc,
  SCHEMA_NAME = 'sys',
  OBJECT_NAME = 'dm_exec_requests',  
  DISTRIBUTION=  
);
------------------------------------------------------------------------------------------
--Crear una tabla externa para SQL Server
     -- Creamos una MASTER KEY
      CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'S0me!nfo';
    GO
	 --Especificamos las credenciales para una fuente de datos externa
     --IDENTITY: user name para la fuente externa
     -- SECRET: password para la fuente externa
     CREATE DATABASE SCOPED CREDENTIAL SqlServerCredentials
     WITH IDENTITY = 'username', Secret = 'password';
    GO

   --LOCATION: Location string debe tener el sgte. formato '<vendor>://<server>[:<port>]'.
   -- PUSHDOWN: especifique si el cálculo debe ser empujado hacia la fuente. ON by default.
   --CREDENTIAL: scoped credential, creada anteriormente.

    CREATE EXTERNAL DATA SOURCE SQLServerInstance
    WITH ( 
    LOCATION = 'sqlserver://SqlServer',
    -- PUSHDOWN = ON | OFF,
      CREDENTIAL = SQLServerCredentials
    );
    GO

    CREATE SCHEMA sqlserver;
    GO

     /* LOCATION: sql server table/view en 'database_name.schema_name.object_name' format
     * DATA_SOURCE: La fuente de datos externa, creada anteriormente.
     */
     CREATE EXTERNAL TABLE sqlserver.customer(
     C_CUSTKEY INT NOT NULL,
     C_NAME VARCHAR(25) NOT NULL,
     C_ADDRESS VARCHAR(40) NOT NULL,
     C_NATIONKEY INT NOT NULL,
     C_PHONE CHAR(15) NOT NULL,
     C_ACCTBAL DECIMAL(15,2) NOT NULL,
     C_MKTSEGMENT CHAR(10) NOT NULL,
     C_COMMENT VARCHAR(117) NOT NULL
      )
      WITH (
      LOCATION='tpch_10.dbo.customer',
      DATA_SOURCE=SqlServerInstance
     );
------------------------------------------------------------------------------------------

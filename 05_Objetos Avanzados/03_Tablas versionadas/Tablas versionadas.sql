USE WideWorldImporters
GO
------------------------------------------------------------------------------
--Creamos una tabla nueva para nuestra prueba
CREATE TABLE dbo.Department   
(
    DeptID INT NOT NULL PRIMARY KEY CLUSTERED
  , DeptName VARCHAR(50) NOT NULL
  , ManagerID INT NULL
  , ParentDeptID INT NULL
  , SysStartTime DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL
  , SysEndTime DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL
  , PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime)
)
--Agregamos la opción de tabla versionada
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.DepartmentHistory));
------------------------------------------------------------------------------
--Acá podemos activar o desactivar la opción
ALTER TABLE dbo.Department
SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.DepartmentHistory));
GO
------------------------------------------------------------------------------
--Agregamos un dato a la tabla versionada

INSERT INTO dbo.Department(
           DeptID
           ,DeptName
           ,ManagerID
           ,ParentDeptID)
     VALUES
           (1
           ,'Florida'
           ,1
           ,10)
GO
-----------------------------------------------------------------------------
--Hacemos un UPDATE en la tabla
UPDATE	dbo.Department
SET		DeptName = 'Alaska'
WHERE	DeptID = 1
-----------------------------------------------------------------------------
--Hacemos un SELECT para visualizar todos los cambios que ha tenido
SELECT	* 
FROM	dbo.Department 
FOR SYSTEM_TIME ALL --Periodos de tiempo
WHERE	DeptID = 1
--------------------------------------------------------------------------------
--Hacemos un SELECT con el periodo de tiempo BEETWEEN
SELECT	* 
FROM	dbo.Department 
FOR SYSTEM_TIME BETWEEN '2019-10-01' AND '2019-10-02'
--También se puede usar
-- FOR SYSTEM_TIME CONTAINED IN (@StartDateTime, @EndDateTime)
-- FOR SYSTEM_TIME FROM @StartDateTime TO @EndDateTime
-- FOR SYSTEM_TIME AS OF @Date
WHERE	DeptID = 1


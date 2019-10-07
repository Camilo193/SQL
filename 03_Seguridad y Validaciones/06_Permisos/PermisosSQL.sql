--PERMISOS EN SQL
--Un esquema de permisos adecuado permite un aceso granular, eficiente y controlado a los diferentes recursos de la base de datos, dichos permisos deben seguir un esquema de gobierno a la vez que reducen la superficie de ataque de un potencial usuario malicioso

--Otorgar permisos
USE WideWorldImporters
GO
EXEC sp_droprolemember 'rev_editor', 'giseditor'
GO
EXEC sp_droprole 'rev_editor'
GO
EXEC sp_addrole 'rev_editor', 'rev'
GO
GRANT DELETE ON SCHEMA::[rev] TO [rev_editor]
GRANT EXECUTE ON SCHEMA::[rev] TO [rev_editor]
GRANT INSERT ON SCHEMA::[rev] TO [rev_editor]
GRANT SELECT ON SCHEMA::[rev] TO [rev_editor]
GRANT UPDATE ON SCHEMA::[rev] TO [rev_editor]
GO
EXEC sp_droprolemember 'rev_viewer', 'gisviewer'
GO
EXEC sp_droprole 'rev_viewer'
GO
EXEC sp_addrole 'rev_viewer', 'rev'
GO
GRANT SELECT ON SCHEMA::[rev] TO [rev_viewer]
GO

--Verificar roles
EXEC sp_helprolemember 'rev_editor'
GO
EXEC sp_helprolemember 'rev_viewer'
GO

--Verificar permisos de rol
select dp.NAME AS principal_name,
 dp.type_desc AS principal_type_desc,
 o.NAME AS object_name,
 p.permission_name,
 p.state_desc AS permission_state_desc 
 from sys.database_permissions p
 left OUTER JOIN sys.all_objects o
 on p.major_id = o.OBJECT_ID
 inner JOIN sys.database_principals dp
 on p.grantee_principal_id = dp.principal_id
 where dp.NAME in ('rev_editor','rev_viewer')
GO

--Crear un usuario editor
USE master
GO
EXEC sp_addlogin N'giseditor', 'gis$editor', @logindb, @loginlang
GO

--Cree el usuario para el inicio de sesión en la base de datos WideWorldImporters.
USE WideWorldImporters
GO
CREATE USER [giseditor] FOR LOGIN [giseditor]
GO

--Añada el usuario al rol de editor.
USE WideWorldImporters
GO
EXEC sp_addrolemember N'rev_editor', N'giseditor'
GO

--Crear un usuario visualizador
--Cree el inicio de sesión de visualizador.
USE master
GO
EXEC sp_addlogin N'gisviewer', 'gis$viewer', @logindb, @loginlang
GO

--Cree el usuario para el inicio de sesión en la base de datos WideWorldImporters.
USE WideWorldImporters
GO
CREATE USER [gisviewer] FOR LOGIN [gisviewer]
GO

--Añada el usuario al rol de editor.
USE WideWorldImporters
GO
EXEC sp_addrolemember N'rev_viewer', N'gisviewer'
GO

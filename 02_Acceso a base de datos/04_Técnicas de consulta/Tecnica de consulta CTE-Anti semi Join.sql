--CTE
--WITH <nombre de su CTE> <nombre de columnas>
--AS
--(
--<query de origen>
--)
--SELECT * FROM <nombre de su CTE>

WITH CTE ([PersonID],[FullName],[PreferredName],[SearchName],[IsEmployee]) AS (
SELECT [PersonID]
      ,[FullName]
      ,[PreferredName]
      ,[SearchName]
      ,[IsEmployee] = CASE WHEN [IsEmployee] = 1 THEN 'SI' ELSE 'NO' END
  FROM [WideWorldImporters].[Application].[People]
)

SELECT [PersonID],[FullName],[PreferredName],[SearchName],[IsEmployee]
FROM CTE
--------------------OTRO EJEMPLO----------------
WITH CTE_2 AS (
SELECT [PersonID]
      ,[FullName]
      ,[PreferredName]
      ,[SearchName]
      ,[IsEmployee] = CASE WHEN [IsEmployee] = 1 THEN 'SI' ELSE 'NO' END
  FROM [WideWorldImporters].[Application].[People]
)

SELECT [PersonID],[FullName],[PreferredName],[SearchName],[IsEmployee]
FROM CTE_2
---------------------------------------------------------------------------
--Subconsultas correlacionadas
---------------------------------------------------------------------------
SELECT C.CountryID,C.CountryName,C.FormalName,C.Continent
FROM [WideWorldImporters].[Application].[Countries] C
WHERE EXISTS (SELECT CountryID 
              FROM [WideWorldImporters].[Application].[Countries] CC
			  WHERE CC.CountryID = C.CountryID
			  AND CC.Continent = 'Europe')

---------------------------------------------------------------------------
--Anti Semi Join
--primera forma
---------------------------------------------------------------------------
SELECT  *
FROM    [WideWorldImporters].[Application].[StateProvinces] be
WHERE   NOT EXISTS ( SELECT 1
                     FROM   [WideWorldImporters].[Application].[Countries] bea
                     WHERE  bea.CountryID = be.CountryID );

--segunda forma
SELECT  be.*
FROM    [WideWorldImporters].[Application].[StateProvinces] be
LEFT OUTER JOIN [WideWorldImporters].[Application].[Countries] bea
        ON bea.CountryID = be.CountryID
WHERE   bea.CountryID IS NULL;
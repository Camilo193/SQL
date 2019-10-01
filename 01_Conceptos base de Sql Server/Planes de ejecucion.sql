USE WideWorldImporters
--Activamos el plan de ejecución
SET SHOWPLAN_XML ON 
--Ejecutamos procedimiento para ver su plan de ejecución
EXECUTE WideWorldImporters.DBO.GetCustomer 
-- Desactivamos el plan de ejecución
SET SHOWPLAN_XML OFF 
--Ejecutamos nuevamente y ya no obtendremos el plan de ejecución
EXECUTE WideWorldImporters.DBO.getItemHoldings
--Cache del plan de consultas
--Pueden ser reutilizados para ejecutar consultas más rápido.
SELECT qp.query_plan, 
       CP.usecounts, 
       cp.cacheobjtype, 
       cp.size_in_bytes, 
       cp.usecounts, 
       SQLText.text
 FROM sys.dm_exec_cached_plans AS CP --Muestra una fila por cada plan de consultas 
 --almacenado en el caché de planes
 CROSS APPLY sys.dm_exec_sql_text( plan_handle)AS SQLText --Muestra el texto SQL,
 --identificado por sql_handle.
 CROSS APPLY sys.dm_exec_query_plan( plan_handle)AS QP
 WHERE objtype = 'Adhoc' and cp.cacheobjtype = 'Compiled Plan'
 --Muestra plan de ejecucion y ejecuta la consulta
 SET STATISTICS XML ON
EXECUTE WideWorldImporters.DBO.getItemHoldings
--Desactivamos la opción
 SET STATISTICS XML OFF



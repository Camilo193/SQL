--Importamos la base de datos
USE WideWorldImporters
GO
---------------------------------------------------------------------
--Habilitamos la recopilación de estadísticas en los procedimientos almacenados
EXECUTE sys.sp_xtp_control_proc_exec_stats 1
---------------------------------------------------------------------
--Está consulta devuelve los nombres de los procedimientos y 
--las estadísticas de ejecución para los procedimientos almacenados  
--después de la recopilación de estadísticas:
SELECT
        object_id,
        object_name(object_id) as 'object name',
        cached_time,
        last_execution_time,  execution_count,
        total_worker_time,    last_worker_time,
        min_worker_time,      max_worker_time,
        total_elapsed_time,   last_elapsed_time,
        min_elapsed_time,     max_elapsed_time
    from
        sys.dm_exec_procedure_stats
    where
        database_id = db_id()
        and
        object_id in
            (
            SELECT object_id
                from sys.sql_modules
                where uses_native_compilation=1
            )
    order by
        total_worker_time desc;
---------------------------------------------------------------------
--las estadísticas de ejecución para todas las consultas de 
--procedimientos almacenados después de recopilar estadísticas, 
--ordenadas por tiempo total de trabajo,
SELECT
        st.objectid,
        object_name(st.objectid) as 'object name',
        SUBSTRING()
            st.text,
            (qs.statement_start_offset/2) + 1,
            ((qs.statement_end_offset-qs.statement_start_offset)/2) + 1
            ) as 'query text',
        qs.creation_time,
        qs.last_execution_time,   qs.execution_count,
        qs.total_worker_time,     qs.last_worker_time,
        qs.min_worker_time,       qs.max_worker_time,
        qs.total_elapsed_time,    qs.last_elapsed_time,
        qs.min_elapsed_time,      qs.max_elapsed_time
    FROM
                    sys.dm_exec_query_stats qs
        cross apply sys.dm_exec_sql_text(sql_handle) st
    WHERE
        st.dbid = db_id()
        and
        st.objectid in
            (SELECT object_id
                from sys.sql_modules
                where uses_native_compilation=1
            )
    ORDER BY
        qs.total_worker_time desc;
---------------------------------------------------------------------
--Los procedimientos almacenados admiten SHOWPLAN_XML
SET SHOWPLAN_XML ON  
GO  
EXEC my_proc   
GO  
SET SHOWPLAN_XML OFF  
GO  
---------------------------------------------------------------------
--Deshabilitamos la recopilación de estadísticas en los procedimientos almacenados
EXECUTE sys.sp_xtp_control_proc_exec_stats 0



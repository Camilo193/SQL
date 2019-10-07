--Transact SQL- Sentencias De Control De Flujo
--Lenguaje de control de flujo

--SQL Server Permite El Control Del Flujo Mediante Un Pequeño Conjunto De Instrucciones:
--If… Else
--While
--Case
--Return

--If-Else: Nos Permite Ejecutar Instrucciones Condicionales.
--IF <Expresion_Logica>
-- <Instruccion>
--ELSE
--<Instruccion>

	DECLARE @TotalPeople INT
	SELECT @TotalPeople = COUNT(*) FROM [Application].[People]
	IF @TotalPeople > 100
	 PRINT 'Existen Mas De 100 Personas'
	ELSE
	 PRINT 'Existen Menos De 100 Personas'

--While
--While <Expresion_Logica>
-- begin
-- <Grupo_Sentencia>
-- end

	Declare @Contador int
	set @Contador = 10
	while (@Contador > 0)
	 begin
	 print '@Contador = ' + CONVERT(NVARCHAR,@Contador)
	 set @Contador = @Contador -1
	 end

--CASE
--CASE <expresion>
-- WHEN <valor_expresion> THEN <valor_devuelto>
-- WHEN <valor_expresion> THEN <valor_devuelto>
-- ELSE <valor_devuelto>
--END

	DECLARE @PAIS NVARCHAR(20)
	SELECT @PAIS =
	CASE 'CO'
	 WHEN 'PE' THEN 'PERU'
	 WHEN 'ME' THEN 'MEXICO'
	 WHEN 'CO' THEN 'COLOMBIA'
	 ElSE 'No Existe Registro'
	END
	PRINT @PAIS

--Otro ejemplo
	Select IsEmployee =
	 CASE WHEN IsEmployee = 0 THEN 'NO'
	 WHEN IsEmployee = 1 THEN 'SI'
	 ELSE 'Desconocido'
	 END 
	FROM [Application].[People]

--RETURN
DECLARE @CONTADOR INT
SET @CONTADOR = 10
WHILE (@CONTADOR >0)
 BEGIN
 PRINT '@CONTADOR = ' + CONVERT(NVARCHAR,@CONTADOR)
 SET @CONTADOR = @CONTADOR -1
 IF (@CONTADOR = 5)
 RETURN
 END
PRINT 'FIN'
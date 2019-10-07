--Instalar R studio
--https://docs.microsoft.com/en-us/sql/advanced-analytics/install/sql-machine-learning-services-windows-install?view=sql-server-2017#bkmk_enableFeature
--Se habilita los scripts externos luego de instalar R
EXEC sp_configure  'external scripts enabled', 1
RECONFIGURE WITH OVERRIDE

--Luego debemos reiniciar el servicio SSMS

--------------------------------------------------------------------------------------
--Creamos el modelo con los datos de origen
CREATE TABLE dbo.MTCars(
    mpg decimal(10, 1) NOT NULL,
    cyl int NOT NULL,
    disp decimal(10, 1) NOT NULL,
    hp int NOT NULL,
    drat decimal(10, 2) NOT NULL,
    wt decimal(10, 3) NOT NULL,
    qsec decimal(10, 2) NOT NULL,
    vs int NOT NULL,
    am int NOT NULL,
    gear int NOT NULL,
    carb int NOT NULL
);
----------------------------------------------------------------------------------
--Insertamos los datos
INSERT INTO dbo.MTCars
EXEC sp_execute_external_script @language = N'R'
    , @script = N'MTCars <- mtcars;'
    , @input_data_1 = N''
    , @output_data_1_name = N'MTCars';

----------------------------------------------------------------------------------
--Creamos y entrenamos el modelo

DROP PROCEDURE IF EXISTS generate_GLM;
GO
CREATE PROCEDURE generate_GLM
AS
BEGIN
    EXEC sp_execute_external_script
    @language = N'R'
    , @script = N'carsModel <- glm(formula = am ~ hp + wt, data = MTCarsData, family = binomial);
        trained_model <- data.frame(payload = as.raw(serialize(carsModel, connection=NULL)));'
    , @input_data_1 = N'SELECT hp, wt, am FROM MTCars'
    , @input_data_1_name = N'MTCarsData'
    , @output_data_1_name = N'trained_model'
    WITH RESULT SETS ((model VARBINARY(max)));
END;
GO
----------------------------------------------------------------------------------
--Almacenamos el modelo en la base de datos

CREATE TABLE GLM_models (
    model_name varchar(30) not null default('default model') primary key,
    model varbinary(max) not null
);

----------------------------------------------------------------------------------
--Llamamos al procedimiento almacenado
--Generamos el modelo y lo guarda en la tabla creada
INSERT INTO GLM_models(model)
EXEC generate_GLM;
--Si se ejecuta varias veces obtenemos error de restricción por PRIMARY KEY
----------------------------------------------------------------------------------
--Una opción para evitar este error es actualizar el nombre de cada modelo nuevo
UPDATE GLM_models
SET model_name = 'GLM_' + format(getdate(), 'yyyy.MM.HH.mm', 'en-gb')
WHERE model_name = 'default model'

----------------------------------------------------------------------------------
--Creamos una tabla con nuevos datos
CREATE TABLE dbo.NewMTCars(
	hp INT NOT NULL
	, wt DECIMAL(10,3) NOT NULL
	, am INT NULL
)
GO

----------------------------------------------------------------------------------
--Insertamos los datos
INSERT INTO dbo.NewMTCars(hp, wt)
VALUES (110, 2.634)

INSERT INTO dbo.NewMTCars(hp, wt)
VALUES (72, 3.435)

INSERT INTO dbo.NewMTCars(hp, wt)
VALUES (220, 5.220)

INSERT INTO dbo.NewMTCars(hp, wt)
VALUES (120, 2.800)
GO
----------------------------------------------------------------------------------
--Ahora vamos a predecir la transmisión manual
--Obtenemos el modelo
DECLARE @glmmodel varbinary(max) = 
    (SELECT model FROM dbo.GLM_models WHERE model_name = 'default model');

EXEC sp_execute_external_script
    @language = N'R'
    , @script = N'
            current_model <- unserialize(as.raw(glmmodel));
            new <- data.frame(NewMTCars);
            predicted.am <- predict(current_model, new, type = "response");
            str(predicted.am);
            OutputDataSet <- cbind(new, predicted.am);
            '
--Obtenemos los nuevos datos de entrada
    , @input_data_1 = N'SELECT hp, wt FROM dbo.NewMTCars'
    , @input_data_1_name = N'NewMTCars'
    , @params = N'@glmmodel varbinary(max)'
    , @glmmodel = @glmmodel
	--Llamamos a una función de predicción R compatible con el modelo
WITH RESULT SETS ((new_hp INT, new_wt DECIMAL(10,3), predicted_am DECIMAL(10,3)));

----------------------------------------------------------------------------------

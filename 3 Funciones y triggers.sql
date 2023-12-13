--FUNCIONES
--Funcion para buscar un estudiante

CREATE OR ALTER FUNCTION BUSQUEDA_ESTUDIANTE(@ID_ESTUDIANTE VARCHAR(20))
RETURNS INT AS
BEGIN
	DECLARE @ENCONTRADO INT
		IF(EXISTS (SELECT 1 FROM ESTUDIANTES WHERE ID_ESTUDIANTE=@ID_ESTUDIANTE))
			SET @ENCONTRADO=1
		ELSE
			SET @ENCONTRADO=0
		RETURN @ENCONTRADO
END
GO

DECLARE @BUSCAR INT
DECLARE @ID_ESTUDIANTE VARCHAR(20)

SET @ID_ESTUDIANTE= 118070523

SET @BUSCAR= [dbo].[BUSQUEDA_ESTUDIANTE]
IF @BUSCAR=1
	PRINT 'EL ESTUDIANTE EXISTE'
ELSE
	PRINT 'EL ESTUDIANTE NO EXISTE'
GO

SELECT * FROM ESTUDIANTES
SELECT * FROM PROFESORES

------------------------------------------------------------------------------------------------------------------------------------------------
--Funcion que muestre el nombre completo la residencia y los telefonos de los profesores que tienen cursos abiertos
CREATE OR ALTER FUNCTION FN_PROFESORES_ASIGNADOS(@CANT_CURSOS INT)
RETURNS @TMP_PROFESORES TABLE( ID_PROFESOR INT IDENTITY(1,1) PRIMARY KEY,
								NOMBRE_PROFESOR VARCHAR(200),
								RESIDENCIA VARCHAR(300),
								TELEFONO VARCHAR(10))
AS
 BEGIN
	INSERT INTO @TMP_PROFESORES
	SELECT NOMBRE+' '+APELLIDO1+' '+APELLIDO2 AS 'NOMBRE PROFESOR', RESIDENCIA,TELELFONO
	FROM PROFESORES P INNER JOIN CURSOS_ABIERTOS CA
	ON P.ID_PROFESOR = CA.ID_PROFESOR
	GROUP BY NOMBRE,APELLIDO1,APELLIDO2,TELELFONO,RESIDENCIA
	HAVING COUNT(CA.ID_PROFESOR)> @CANT_CURSOS
RETURN
END
GO
SELECT * FROM FN_PROFESORES_ASIGNADOS(1)
















------------------------------------------------------------------------------------------------------------------------------------------------
--TRIGGERS

CREATE TABLE HISTORIAL_TRIGGERS(
NUMERO_HISTORIAL INT IDENTITY,
TABLA_ORIGEN VARCHAR(25) NOT NULL,
COD_TABLA VARCHAR(50) NOT NULL,
MOVIMIENTO VARCHAR(50) NOT NULL,
FECHA DATE,
USUARIO VARCHAR(100)
);
--Trigger para insertar un programa
CREATE OR ALTER TRIGGER TR_FI_PROGRAMAS
ON PROGRAMAS 
FOR INSERT
AS
	DECLARE @COD_TABLE VARCHAR(20) 
	SELECT @COD_TABLE= ID_PROGRAMA FROM inserted
	INSERT INTO HISTORIAL_TRIGGERS(TABLA_ORIGEN,COD_TABLA,MOVIMIENTO,FECHA,USUARIO) VALUES
	('PROGRAMAS',@COD_TABLE,'INSERCION DE PROGRAMA',GETDATE(),SYSTEM_USER)

	INSERT INTO PROGRAMAS VALUES
	(505, 'Hardware');

SELECT * FROM PROGRAMAS 
SELECT* FROM HISTORIAL_TRIGGERS
------------------------------------------------------------------------------------------------------------------------------------------------
--Actualizar un curso
CREATE OR ALTER TRIGGER TR_FU_CURSOS
ON CURSOS 
FOR UPDATE
AS
	DECLARE @COD_TABLE VARCHAR(20) 
	SELECT @COD_TABLE= CODIGO_CURSO FROM inserted
	INSERT INTO HISTORIAL_TRIGGERS(TABLA_ORIGEN,COD_TABLA,MOVIMIENTO,FECHA,USUARIO) VALUES
	('CURSOS',@COD_TABLE,'ACTUALIZACION DE UN CURSO',GETDATE(),SYSTEM_USER)

	/*UPDATE CURSOS
	SET CODIGO_CURSO= '13N13'
	WHERE CODIGO_CURSO= '13�13'*/


SELECT * FROM CURSOS
------------------------------------------------------------------------------------------------------------------------------------------------
--Borrar un profesor
CREATE OR ALTER TRIGGER TR_FD_PROFES
ON PROFESORES
FOR DELETE
AS
	DECLARE @COD_TABLE VARCHAR(20) 
	SELECT @COD_TABLE= ID_PROFESOR FROM deleted
	INSERT INTO HISTORIAL_TRIGGERS(TABLA_ORIGEN,COD_TABLA,MOVIMIENTO,FECHA,USUARIO) VALUES
	('PROFESORES',@COD_TABLE,'BORRADO DE UN PROFESOR',GETDATE(),SYSTEM_USER)

	/*DELETE FROM PROFESORES
	WHERE ID_PROFESOR= '118070444'*/

SELECT * FROM PROFESORES
------------------------------------------------------------------------------------------------------------------------------------------------
--Insertar un certificado de profesor
CREATE OR ALTER TRIGGER TR_FI_CERTIFICACDO_PROFES
ON CERTIFICACIONES_PROFESORES
FOR INSERT
AS
	DECLARE @COD_TABLE VARCHAR(20) 
	SELECT @COD_TABLE= NUMERO_CERTIFICACION FROM inserted
	INSERT INTO HISTORIAL_TRIGGERS(TABLA_ORIGEN,COD_TABLA,MOVIMIENTO,FECHA,USUARIO) VALUES
	('CERTIFICACIONES_PROFESORES',@COD_TABLE,'INSERTAR UN CERTIFICADO DE UN PROFESOR',GETDATE(),SYSTEM_USER)

	INSERT INTO CERTIFICACIONES_PROFESORES VALUES
	(12,118070444,118070444,'11K11','Bachiller en BOOTSRAP', 'BACHILLERATO')

SELECT * FROM CERTIFICACIONES_PROFESORES
------------------------------------------------------------------------------------------------------------------------------------------------
--Actualizar un registro de dia fuera del profesor
CREATE OR ALTER TRIGGER TR_FU_DIA_FUERA_PROFE
ON DIAS_FUERA_PROFES
FOR UPDATE
AS
	DECLARE @COD_TABLE VARCHAR(20) 
	SELECT @COD_TABLE= CODIGO_REGISTRO_DIAS_FUERA FROM inserted
	INSERT INTO HISTORIAL_TRIGGERS(TABLA_ORIGEN,COD_TABLA,MOVIMIENTO,FECHA,USUARIO) VALUES
	('DIAS_FUERA_PROFES',@COD_TABLE,'ACTUALIZAR UN DIA FUERA DE UN PROFESOR',GETDATE(),SYSTEM_USER)

	/*UPDATE DIAS_FUERA_PROFES
	SET OBSERVACIONES= 'Capacitacion sobre Algebra Lineal y Matematica Pura'
	WHERE ID_PROFESOR= 118070444*/


SELECT * FROM DIAS_FUERA_PROFES
------------------------------------------------------------------------------------------------------------------------------------------------
-- Borrar una registro de horas laboradas
CREATE OR ALTER TRIGGER TR_FD_HORAS_LABORADAS_PROFES
ON HORAS_LABORADAS_PROFESORES
FOR DELETE
AS
	DECLARE @COD_TABLE VARCHAR(20) 
	SELECT @COD_TABLE= NUMERO_REGISTRO_HORAS FROM deleted
	INSERT INTO HISTORIAL_TRIGGERS(TABLA_ORIGEN,COD_TABLA,MOVIMIENTO,FECHA,USUARIO) VALUES
	('HORAS_LABORADAS_PROFESORES',@COD_TABLE,'BORRAR UNA HORA LABORADA',GETDATE(),SYSTEM_USER)

	/*DELETE FROM HORAS_LABORADAS_PROFESORES
	WHERE NUMERO_REGISTRO_HORAS= '121'*/

SELECT * FROM HORAS_LABORADAS_PROFESORES
------------------------------------------------------------------------------------------------------------------------------------------------
--Insertar una registro de horas laboradas
CREATE OR ALTER TRIGGER TR_FI_DEDUCCIONES
ON DEDUCCIONES
FOR INSERT
AS
	DECLARE @COD_TABLE VARCHAR(20) 
	SELECT @COD_TABLE= NUMERO_DEDUCCION FROM inserted
	INSERT INTO HISTORIAL_TRIGGERS(TABLA_ORIGEN,COD_TABLA,MOVIMIENTO,FECHA,USUARIO) VALUES
	('DEDUCCIONES',@COD_TABLE,'INSERTAR UNA DEDUCCION',GETDATE(),SYSTEM_USER)

	INSERT INTO DEDUCCIONES VALUES
	(12,1,5.5,3.84,10.34)

SELECT * FROM DEDUCCIONES
------------------------------------------------------------------------------------------------------------------------------------------------
-- Actualizar un registro de pago a los profesores 
CREATE OR ALTER TRIGGER TR_FU_PAGOS_PROFES
ON PAGOS_PROFES
FOR UPDATE 
AS
	DECLARE @COD_TABLE VARCHAR(20) 
	SELECT @COD_TABLE= NUMERO_REGISTRO_PAGO FROM DELETED 
	INSERT INTO HISTORIAL_TRIGGERS(TABLA_ORIGEN,COD_TABLA,MOVIMIENTO,FECHA,USUARIO) VALUES
	('PAGOS PROFES',@COD_TABLE,'ACTUALIZAR UN REGISTRO DE PAGO A LOS PROFESORES',GETDATE(),SYSTEM_USER)

	/*UPDATE PAGOS_PROFES
	SET SALARIO_BRUTO= 124800
	WHERE ID_ESTUDIANTE= 222971456*/


SELECT * FROM PAGOS_PROFES
------------------------------------------------------------------------------------------------------------------------------------------------
--Borrar un laboratorio
CREATE OR ALTER TRIGGER TR_FD_LABORATORIOS
ON LABORATORIOS
FOR DELETE
AS
	DECLARE @COD_TABLE VARCHAR(20) 
	SELECT @COD_TABLE= CODIGO_LABORATORIO FROM deleted
	INSERT INTO HISTORIAL_TRIGGERS(TABLA_ORIGEN,COD_TABLA,MOVIMIENTO,FECHA,USUARIO) VALUES
	('LABORATORIOS',@COD_TABLE,'BORRAR UN LABORATORIO',GETDATE(),SYSTEM_USER)

	/*DELETE FROM LABORATORIOS
	WHERE = CODIGO_LABORATORIO '9Y'*/

SELECT * FROM LABORATORIOS
------------------------------------------------------------------------------------------------------------------------------------------------
--Insertar un estudiante
CREATE OR ALTER TRIGGER TR_FI_ESTUDIANTES
ON ESTUDIANTES
FOR INSERT
AS
	DECLARE @COD_TABLE VARCHAR(20) 
	SELECT @COD_TABLE= ID_ESTUDIANTE FROM inserted
	INSERT INTO HISTORIAL_TRIGGERS(TABLA_ORIGEN,COD_TABLA,MOVIMIENTO,FECHA,USUARIO) VALUES
	('ESTUDIANTES',@COD_TABLE,'INSERTAR UN ESTUDIANTE',GETDATE(),SYSTEM_USER)

	INSERT INTO ESTUDIANTES VALUES
	(654856324,'MILAGRO','ALVARADO','RODRIGUEZ','San Miguel de Naranjo','19990411','20211001','ACT')

SELECT * FROM ESTUDIANTES
------------------------------------------------------------------------------------------------------------------------------------------------
--Actualizar un feriado de estudiantes
CREATE OR ALTER TRIGGER TR_FU_FERIADO_ESTUDIANTES
ON FERIADOS_ESTUDIANTES
FOR UPDATE
AS
	DECLARE @COD_TABLE VARCHAR(20) 
	SELECT @COD_TABLE= CODIGO_REGISTRO_FERIADO FROM inserted
	INSERT INTO HISTORIAL_TRIGGERS(TABLA_ORIGEN,COD_TABLA,MOVIMIENTO,FECHA,USUARIO) VALUES
	('FERIADOS_ESTUDIANTES',@COD_TABLE,'ACTUALIZAR UN FERIADO UN ESTUDIANTE',GETDATE(),SYSTEM_USER)

	/*UPDATE FERIADOS_ESTUDIANTES
	SET FECHA_FIN_V= '20220829'
	WHERE ID_ESTUDIANTE= 13466890*/

SELECT * FROM FERIADOS_ESTUDIANTES
------------------------------------------------------------------------------------------------------------------------------------------------
--Borrar horarios cursos
CREATE OR ALTER TRIGGER TR_FD_HORARIOS_CURSOS
ON HORARIOS_CURSOS
FOR DELETE
AS
	DECLARE @COD_TABLE VARCHAR(20) 
	SELECT @COD_TABLE= NUMERO_HORARIO FROM deleted
	INSERT INTO HISTORIAL_TRIGGERS(TABLA_ORIGEN,COD_TABLA,MOVIMIENTO,FECHA,USUARIO) VALUES
	('HORARIOS_CURSOS',@COD_TABLE,'BORRAR UN HORARIO DE LOS CURSOS',GETDATE(),SYSTEM_USER)

		/*DELETE FROM HORARIOS_CURSOS
	WHERE NUMERO_HORARIO= '13'*/

SELECT * FROM HORARIOS_CURSOS
------------------------------------------------------------------------------------------------------------------------------------------------
--Borrar un curso abierto
CREATE OR ALTER TRIGGER TR_FD_CURSOS_ABIERTOS
ON CURSOS_ABIERTOS
FOR DELETE
AS
	DECLARE @COD_TABLE VARCHAR(20) 
	SELECT @COD_TABLE= ID_CURSO_ABIERTO FROM deleted
	INSERT INTO HISTORIAL_TRIGGERS(TABLA_ORIGEN,COD_TABLA,MOVIMIENTO,FECHA,USUARIO) VALUES
	('CURSOS_ABIERTOS',@COD_TABLE,'BORRAR UN CURSO ABIERTO',GETDATE(),SYSTEM_USER)

		/*DELETE FROM CURSOS_ABIERTOS
	WHERE ID_CURSO_ABIERTO= '66D4'*/

SELECT * FROM CURSOS_ABIERTOS
------------------------------------------------------------------------------------------------------------------------------------------------
--Insertar un record academico de un estudiante
CREATE OR ALTER TRIGGER TR_FI_RECORD_ACADEMICO_EST
ON RECORD_ACADEMICO_ESTUDIANTES 
FOR INSERT
AS
	DECLARE @COD_TABLE VARCHAR(20) 
	SELECT @COD_TABLE= CODIGO_RECORD FROM INSERTED
	INSERT INTO HISTORIAL_TRIGGERS(TABLA_ORIGEN,COD_TABLA,MOVIMIENTO,FECHA,USUARIO) VALUES
	('RECORD ACADEMICO ESTUDIANTES',@COD_TABLE,'INSERTAR UN NUEVO RECORD ACADEMICO',GETDATE(),SYSTEM_USER)

	INSERT INTO RECORD_ACADEMICO_ESTUDIANTES VALUES
	(2015,558735544,'1A1',20,40,20,80,'APROBADO');

SELECT * FROM RECORD_ACADEMICO_ESTUDIANTES
------------------------------------------------------------------------------------------------------------------------------------------------
--Actualizar un encabezado de matriculas
CREATE OR ALTER TRIGGER TR_FU_ENCABEZADO_MATRICULAS
ON ENCABEZADO_MATRICULAS
FOR UPDATE
AS
	DECLARE @COD_TABLE VARCHAR(20) 
	SELECT @COD_TABLE= NUMERO_MATRICULA FROM INSERTED
	INSERT INTO HISTORIAL_TRIGGERS(TABLA_ORIGEN,COD_TABLA,MOVIMIENTO,FECHA,USUARIO) VALUES
	('ENCABEZADO MATRICULAS',@COD_TABLE,'ACTUALIZAR UN REGISTRO DE ENCABEZADO MATRICULAS',GETDATE(),SYSTEM_USER)

	/*UPDATE ENCABEZADO_MATRICULAS
	SET ESTADO_M= 'INACTIVO'
	WHERE ID_ESTUDIANTE= 13466890*/

SELECT *FROM ENCABEZADO_MATRICULAS
------------------------------------------------------------------------------------------------------------------------------------------------
--Borrar un pago de los estudiantes
CREATE OR ALTER TRIGGER TR_FD_PAGO_ESTUDIANTES
ON PAGO_ESTUDIANTES
FOR DELETE
AS
	DECLARE @COD_TABLE VARCHAR(20) 
	SELECT @COD_TABLE= NUMERO_REGISTRO_PAGO FROM deleted
	INSERT INTO HISTORIAL_TRIGGERS(TABLA_ORIGEN,COD_TABLA,MOVIMIENTO,FECHA,USUARIO) VALUES
	('PAGO ESTUDIANTES',@COD_TABLE,'BORRAR UN REGISTRO DE PAGO DE ESTUDIANTES',GETDATE(),SYSTEM_USER)

	/*DELETE FROM PAGO_ESTUDIANTES
	WHERE NUMERO_REGISTRO_PAGO= '10'*/

SELECT * FROM PAGO_ESTUDIANTES
------------------------------------------------------------------------------------------------------------------------------------------------
--Borrar un registro en detalle matricula
CREATE OR ALTER TRIGGER TR_FD_DETALLE_MATRICULAS
ON DETALLES_MATRICULA
FOR DELETE
AS
	DECLARE @COD_TABLE VARCHAR(20) 
	SELECT @COD_TABLE= NUMERO_RECIBO FROM deleted
	INSERT INTO HISTORIAL_TRIGGERS(TABLA_ORIGEN,COD_TABLA,MOVIMIENTO,FECHA,USUARIO) VALUES
	('DETALLE MATRICULAS',@COD_TABLE,'BORRAR UN REGISTRO DE DETALLE MATRICULAS',GETDATE(),SYSTEM_USER)

	/*DELETE FROM DETALLES_MATRICULA
	WHERE NUMERO_RECIBO= '10001'*/
SELECT * FROM DETALLES_MATRICULA
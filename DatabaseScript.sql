CREATE DATABASE CENTRO_IDIOMAS
GO

USE CENTRO_IDIOMAS
GO

/*
USE MASTER
GO
*/

/*
DROP DATABASE CENTRO_IDIOMAS
GO
*/


CREATE TABLE ESTUDIANTE(
	ID_ESTUDIANTE INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_ESTUDIANTES PRIMARY KEY,
	NOMBRE VARCHAR(80) NOT NULL,
	P_APELLIDO VARCHAR(80) NOT NULL,
	S_APELLIDO VARCHAR(80) NOT NULL,
	EDAD INT NOT NULL,
	TELEFONO VARCHAR(11) NOT NULL,
	EMAIL VARCHAR(50) NOT NULL,	
	DEUDA BIT NOT NULL CONSTRAINT DF_DEUDA DEFAULT 0,
	CURSOS_MATRICULADOS INT NOT NULL CONSTRAINT DF_ESTUDIANTES_MATRICULADOS DEFAULT 0,
	BORRADO_E BIT NOT NULL CONSTRAINT DF_BORRADO_ESTUDIANTES DEFAULT 0
)

CREATE TABLE PROFESOR(
	ID_PROFESOR INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_PROFESORES PRIMARY KEY,
	NOMBRE VARCHAR(80) NOT NULL,
	P_APELLIDO VARCHAR(80) NOT NULL,
	S_APELLIDO VARCHAR(80) NOT NULL,
	EDAD INT NOT NULL,
	TELEFONO VARCHAR(11) NOT NULL,
	EMAIL VARCHAR(50) NOT NULL,	
	IDIOMA VARCHAR(20),
	HORA_ENTRADA TIME CONSTRAINT DF_ENTRADA DEFAULT('07:00:00'),
	HORA_SALIDA TIME CONSTRAINT DF_SALIDA DEFAULT('15:00:00'),
	BORRADO_E BIT NOT NULL CONSTRAINT DF_BORRADO_PROFESORES DEFAULT 0
)

CREATE TABLE LOGIN(
	USUARIO VARCHAR(20) CONSTRAINT PK_USUARIO PRIMARY KEY,
	ID_ESTUDIANTE INT NULL CONSTRAINT FK_LOGINS FOREIGN KEY (ID_ESTUDIANTE) REFERENCES ESTUDIANTE(ID_ESTUDIANTE),
	CONTRASENA VARCHAR(10) NOT NULL,
)

CREATE TABLE PROGRAMA(
	ID_PROGRAMA INT IDENTITY(1,1) CONSTRAINT PK_PROGRAMA PRIMARY KEY,
	IDIOMA VARCHAR(20) NOT NULL,
	CURSOS INT NOT NULL CONSTRAINT DF_N_CURSOS DEFAULT 0,
	BORRADO_E BIT NOT NULL CONSTRAINT DF_BORRADO_PROGRAMA DEFAULT 0
)

CREATE TABLE CURSO(
	ID_CURSO INT IDENTITY(1,1) CONSTRAINT PK_CURSOS PRIMARY KEY,
	ID_PROGRAMA INT NOT NULL,
	NOMBRE_CURSO VARCHAR(50),
	REQUISITO VARCHAR(50),                                                                                                                                                                                                                                                                  
	HORAS INT NOT NULL,
	COSTO DECIMAL(10,2) NOT NULL,
	BORRADO_E BIT NOT NULL CONSTRAINT DF_BORRADO_CURSOS DEFAULT 0,
	CONSTRAINT FK_CURSOS1 FOREIGN KEY(ID_PROGRAMA) REFERENCES PROGRAMA(ID_PROGRAMA)
)


CREATE TABLE CURSOESTUDIANTE(
	ID_CURSO INT NOT NULL,
	ID_ESTUDIANTE INT NOT NULL,
	NOMBRE_CURSO VARCHAR(100),
	FECHA_INICIO DATE NOT NULL CONSTRAINT DF_FECHA_INICIO DEFAULT GETDATE(),
	FECHA_FINAL DATE NOT NULL CONSTRAINT DF_FECHA_FINAL DEFAULT GETDATE(),
	ESTADO VARCHAR(4) NOT NULL CONSTRAINT DF_EST DEFAULT 'ACT' CONSTRAINT CK_EST CHECK(ESTADO IN('ACT', 'REP','APR')),
	HORAS_SINC_RES INT NOT NULL CONSTRAINT DF_HORAS_S DEFAULT 0,
	BORRADO_E BIT NOT NULL CONSTRAINT DF_BORRADO_CURSO_EST DEFAULT 0,
	CONSTRAINT FK_CURSO_EST1 FOREIGN KEY(ID_ESTUDIANTE) REFERENCES ESTUDIANTE(ID_ESTUDIANTE),	
	CONSTRAINT FK_CURSO_EST2 FOREIGN KEY(ID_CURSO) REFERENCES CURSO(ID_CURSO),
	CONSTRAINT PK_CURSO_EST PRIMARY KEY(ID_ESTUDIANTE, ID_CURSO)
)

CREATE TABLE MATRICULA(
	ID_MATRICULA INT IDENTITY(1,1) CONSTRAINT PK_MATRICULA PRIMARY KEY,
	ID_ESTUDIANTE INT NOT NULL,	
	ID_CURSO INT NOT NULL,
	IDIOMA VARCHAR(20),
	FECHA DATE NOT NULL CONSTRAINT DF_FECHA_MATRICULA DEFAULT GETDATE(),
	NIVEL_INTENSIDAD VARCHAR(30) NOT NULL CONSTRAINT CHK_INTENSIDAD CHECK(NIVEL_INTENSIDAD IN('BAJO', 'MEDIO', 'ALTO', 'INTENSIVO')
	AND NIVEL_INTENSIDAD = UPPER(NIVEL_INTENSIDAD)),
	COSTO DECIMAL(10,2) NOT NULL,
	CANCELADO BIT NOT NULL CONSTRAINT DF_CANCELADO DEFAULT 0,
	BORRADO_E BIT NOT NULL CONSTRAINT DF_BORRADO_MATRICULA DEFAULT 0,
	CONSTRAINT FK_MATRICULA1 FOREIGN KEY (ID_ESTUDIANTE) REFERENCES ESTUDIANTE(ID_ESTUDIANTE),
	CONSTRAINT FK_MATRICULA2 FOREIGN KEY (ID_CURSO) REFERENCES CURSO(ID_CURSO)
)


CREATE TABLE CLASE(
	ID_CLASE INT IDENTITY(1,1) CONSTRAINT PK_CLASES PRIMARY KEY,
	ID_ESTUDIANTE INT NOT NULL,
	ID_PROFESOR INT NOT NULL,
	ID_CURSO INT NOT NULL,
	INICIO DATETIME NOT NULL CONSTRAINT DF_INICIO_CLASE DEFAULT GETDATE(),
	FINAL DATETIME NOT NULL CONSTRAINT DF_FINAL_CLASE DEFAULT GETDATE(),	
	BORRADO_E BIT NOT NULL CONSTRAINT DF_BORRADO_CLASE DEFAULT 0,	
	CONSTRAINT FK_CLASES1 FOREIGN KEY(ID_ESTUDIANTE) REFERENCES ESTUDIANTE(ID_ESTUDIANTE),
	CONSTRAINT FK_CLASES2 FOREIGN KEY(ID_PROFESOR) REFERENCES PROFESOR(ID_PROFESOR),
	CONSTRAINT FK_CLASES3 FOREIGN KEY(ID_CURSO) REFERENCES CURSO(ID_CURSO)
)

CREATE TABLE FERIADO(
	FECHA DATE CONSTRAINT PK_FERIADOS PRIMARY KEY NOT NULL,
	DESCRIPCION VARCHAR(100),
	ANIO INT NOT NULL
)



/*
GO
CREATE OR ALTER TRIGGER TR_PROGRAMAS_N_CURSOS
ON CURSOS after INSERT
AS 
DECLARE @cursosPrograma int, @programa int

select @programa = ID_PROGRAMA from inserted

select @cursosPrograma = COUNT(ID_PROGRAMA) FROM CURSOS
WHERE ID_PROGRAMA = @programa

UPDATE PROGRAMA
SET CURSOS = @cursosPrograma
WHERE ID_PROGRAMA = @programa
GO


GO
CREATE OR ALTER TRIGGER TR_PROGRAMAS_N_CURSOS_delete
ON CURSOS after delete
AS 
DECLARE @cursosPrograma int, @programa int

select @programa = ID_PROGRAMA from deleted

select @cursosPrograma = COUNT(ID_PROGRAMA) FROM CURSOS
WHERE ID_PROGRAMA = @programa

UPDATE PROGRAMA
SET CURSOS = @cursosPrograma
WHERE ID_PROGRAMA = @programa
GO
*/

--insertamos los programas 
INSERT INTO PROGRAMA(IDIOMA) VALUES('INGLES'),
('ALEMAN'),('FRANCES'),('MANDARIN')

--insertamos los cursos
INSERT INTO CURSO(ID_PROGRAMA, NOMBRE_CURSO, REQUISITO, HORAS,COSTO)
VALUES (1,'INGLES 1', '',80, 2500.00),(1,'INGLES 2', 'INGLES 1',80, 2500.00),(1,'INGLES 3', 'INGLES 2',80, 2500.00),(1,'INGLES 4','INGLES 3', 80, 2500.00),
(1,'INGLES 5','INGLES 4', 80, 2500.00),(1,'INGLES 6','INGLES 5', 80, 2500.00),(1,'INGLES 7','INGLES 6', 80, 2500.00),(1,'INGLES 8','INGLES 7', 80, 2500.00),
(1,'INGLES 9','INGLES 8', 80, 2500.00), (1,'INGLES 10','INGLES 9', 80, 2500.00), (1,'INGLES 11','INGLES 10', 80, 2500.00), (1,'INGLES 12','INGLES 11', 80, 2500.00),

(2,'ALEMAN 1','', 94, 2500.00), (2,'ALEMAN 2','ALEMAN 1',94, 2500.00), (2,'ALEMAN 3', 'ALEMAN 2',94, 2500.00),(2,'ALEMAN 4','ALEMAN 3', 94, 2500.00),
(2,'ALEMAN 5','ALEMAN 4' ,94, 2500.00),(2,'ALEMAN 6', 'ALEMAN 5',94, 2500.00),(2,'ALEMAN 7','ALEMAN 6', 94, 2500.00),(2,'ALEMAN 8', 'ALEMAN 7',94, 2500.00),
(2,'ALEMAN 9', 'ALEMAN 8',94, 2500.00),(2,'ALEMAN 10', 'ALEMAN 9',94, 2500.00),

(3,'FRANCES 1','', 100, 2500.00),(3,'FRANCES 2','FRANCES 1', 100, 2500.00),(3,'FRANCES 3', 'FRANCES 2',100, 2500.00),(3,'FRANCES 4', 'FRANCES 3',100, 2500.00),

(4,'MANDARIN 1', '',120, 2500.00),(4,'MANDARIN 2','MANDARIN 1', 120, 2500.00),(4,'MANDARIN 3','MANDARIN 2', 120, 2500.00),(4,'MANDARIN 4', 'MANDARIN 3',120, 2500.00),
(4,'MANDARIN 5','MANDARIN 4', 120, 2500.00),(4,'MANDARIN 6','MANDARIN 5', 120, 2500.00),(4,'MANDARIN 7','MANDARIN 6', 120, 2500.00),(4,'MANDARIN 8','MANDARIN 7', 120, 2500.00),
(4,'MANDARIN 9', 'MANDARIN 8',120, 2500.00),(4,'MANDARIN 10','MANDARIN 9', 120, 2500.00),(4,'MANDARIN 11','MANDARIN 10', 120, 2500.00),(4,'MANDARIN 12', 'MANDARIN 11',120, 2500.00),
(4,'MANDARIN 13', 'MANDARIN 12',120, 2500.00),(4,'MANDARIN 14','MANDARIN 13', 120, 2500.00)

--trigger que asigna el idioma al insertar una matricula
GO 
CREATE OR ALTER TRIGGER TR_IDIOMA
ON MATRICULA AFTER INSERT 
AS
	DECLARE @programa INT
	, @curso int, @idioma VARCHAR(20), @id_matricula int

	SELECT @id_matricula = ID_MATRICULA FROM inserted
	SELECT @curso = ID_CURSO FROM inserted
	SELECT @programa = ID_PROGRAMA FROM CURSOS
	WHERE ID_CURSO = @curso

	SELECT @idioma = IDIOMA FROM PROGRAMA
	WHERE ID_PROGRAMA = @programa

	UPDATE MATRICULA
	SET IDIOMA = @idioma
	WHERE ID_MATRICULA = @id_matricula
GO

--aca insertamos un usuario para poder iniciar el programa
INSERT INTO ESTUDIANTE(NOMBRE, P_APELLIDO, S_APELLIDO, EDAD, TELEFONO, EMAIL)
VALUES('Steven', 'Soza', 'Maliaño', 27, '72171608', 'sozastev@gmail.com')

--tambien insertamos el login correpondiente
INSERT INTO LOGIN(USUARIO,ID_ESTUDIANTE,CONTRASENA)
VALUES('stevsoza', @@IDENTITY, 'asdjkl')


INSERT INTO ESTUDIANTE(NOMBRE, P_APELLIDO, S_APELLIDO, EDAD, TELEFONO, EMAIL)
VALUES('Martin', 'Juanes', 'Perez', 27, '35634234', 'raid@gmail.com')

INSERT INTO LOGIN(USUARIO,ID_ESTUDIANTE,CONTRASENA)
VALUES('marin', @@IDENTITY, 'qwe')

--insertamos los feriados de este año
INSERT INTO FERIADO(FECHA, DESCRIPCION,ANIO)
VALUES('2022/1/1', 'Año nuevo',2022),
	('2022/4/10', 'Semana santa',2022),
	('2022/4/11', 'Semana santa/Juan Santamaria',2022),
	('2022/4/12', 'Semana santa',2022),
	('2022/4/13', 'Semana santa',2022),
	('2022/4/14', 'Jueves Santo',2022),
	('2022/4/15', 'Viernes Santo',2022),
	('2022/4/16', 'Semana santa',2022),
	('2022/5/1', 'Día del trabajo',2022),
	('2022/5/8', 'Inauguracion Presidencial',2022),
	('2022/7/25', 'Anexion Nicoya',2022),
	('2022/8/2', 'Virgen de los Angeles',2022),
	('2022/8/15', 'Asunción de María',2022),
	('2022/8/31', 'Día de las culturas',2022),
	('2022/9/15', 'Día de la indepencia',2022),
	('2022/12/1', 'Abolición del Ejercito',2022),
	('2022/12/25', 'Navidad',2022) 
GO

--trigger que aumenta el número de los cursos que ha matriculado el estudiante
CREATE OR ALTER TRIGGER TR_CURSOS_ESTUDIANTE
ON CURSOESTUDIANTE after INSERT, UPDATE
AS 
DECLARE @id_estudiante int, @numero_cursos int

select @id_estudiante = ID_ESTUDIANTE from inserted
SELECT @numero_cursos = COUNT(@id_estudiante) FROM CURSOESTUDIANTE
WHERE ID_ESTUDIANTE = @id_estudiante

UPDATE ESTUDIANTE
SET CURSOS_MATRICULADOS = @numero_cursos
WHERE ID_ESTUDIANTE = @id_estudiante
GO

--el mismo trigger consideranto sea un deleted
CREATE OR ALTER TRIGGER TR_CURSOS_ESTUDIANTE_deleted
ON CURSOESTUDIANTE after DELETE
AS 
DECLARE @id_estudiante int, @numero_cursos int

select @id_estudiante = ID_ESTUDIANTE from deleted
SELECT @numero_cursos = COUNT(@id_estudiante) FROM CURSOESTUDIANTE
WHERE ID_ESTUDIANTE = @id_estudiante

UPDATE ESTUDIANTE
SET CURSOS_MATRICULADOS = @numero_cursos
WHERE ID_ESTUDIANTE = @id_estudiante
GO

--trigger que asigna si el estudiante tiene deudas pendientes
GO
CREATE OR ALTER TRIGGER TR_MATRICULA 
ON MATRICULA AFTER INSERT, UPDATE
AS
DECLARE @id_estudiante int

select @id_estudiante = ID_ESTUDIANTE FROM inserted

IF EXISTS (SELECT * FROM MATRICULA 
			WHERE ID_ESTUDIANTE = @id_estudiante AND CANCELADO = 0)
BEGIN
	UPDATE ESTUDIANTE
	SET DEUDA = 1
	WHERE ID_ESTUDIANTE = @id_estudiante
END			
ELSE
BEGIN
	UPDATE ESTUDIANTE
	SET DEUDA = 0
	WHERE ID_ESTUDIANTE = @id_estudiante
END
GO

GO
CREATE OR ALTER TRIGGER TR_MATRICULA_DELETE
ON MATRICULA AFTER DELETE
AS
DECLARE @id_estudiante int

select @id_estudiante = ID_ESTUDIANTE FROM deleted

BEGIN
	UPDATE ESTUDIANTE
	SET DEUDA = 0
	WHERE ID_ESTUDIANTE = @id_estudiante
END
GO
--el siguiente trigger realiza la reposicion de las clases
go
CREATE OR ALTER TRIGGER TR_CLASE_REPROGRA
ON CLASE FOR UPDATE
AS
DECLARE @id_curso INT, @id_estudiante int, @id_clase int
SELECT @id_clase = ID_CLASE FROM deleted
SELECT @id_curso = ID_CURSO FROM deleted
SELECT @id_estudiante = ID_ESTUDIANTE FROM deleted


IF (SELECT BORRADO_E FROM inserted WHERE ID_CLASE = @id_clase) = 1 
	AND ((SELECT BORRADO_E FROM deleted WHERE ID_CLASE = ID_CLASE) = 0)
BEGIN
	UPDATE CURSOESTUDIANTE
	SET HORAS_SINC_RES = +2
	WHERE ID_CURSO = @id_curso AND ID_ESTUDIANTE = @id_estudiante
END
GO


INSERT INTO PROFESOR(NOMBRE, EMAIL, TELEFONO, P_APELLIDO, S_APELLIDO, EDAD, IDIOMA, HORA_ENTRADA, HORA_SALIDA)
VALUES('CARLOS', 'CALROS@GMAIL.COM', '28273949', 'PEREZ', 'SOZA', 25, 'INGLES', '08:00:00','16:00:00'),
('JUAN', 'JAUN@GMAIL.COM', '28273949', 'SOTO', 'BERMUDEZ', 25, 'ESPAÑOL', '13:00:00','21:00:00'),
('MARTIN', 'TARMIN@GMAIL.COM', '28273949', 'SALAS', 'LIZANO', 25, 'INGLES', '10:00:00','18:00:00'),
('PEDRO', 'DEPRO@GMAIL.COM', '28273949', 'PADRINO', 'PERAZA', 25, 'INGLES', '08:00:00','16:00:00')


-- SELECT * FROM CLASES
GO
CREATE OR ALTER PROCEDURE CURSO_IDIOMA
		@id_curso int, --recibe
		@idioma VARCHAR(20) out--devuelve
AS BEGIN
SELECT @idioma = IDIOMA FROM PROGRAMA INNER JOIN CURSO
ON CURSO.ID_PROGRAMA = PROGRAMA.ID_PROGRAMA
WHERE @id_curso = ID_CURSO
END
GO
-- SELECT * FROM CURSOESTUDIANTE
-- SELECT * FROM CURSO
-- SELECT * FROM CLASE
-- SELECT * FROM PROFESOR
-- SELECT * FROM LOGIN
-- SELECT * FROM ESTUDIANTE
-- SELECT * FROM MATRICULA
-- SELECT * FROM PROGRAMA
-- SELECT * FROM FERIADO


-- DELETE FROM CLASES
-- WHERE ID_ESTUDIANTE = 2

-- INSERT INTO CLASES (ID_ESTUDIANTE, ID_PROFESOR, ID_CURSO, INICIO, FINAL)
-- VALUES(1, 1, 1 ,'2022-03-03T04:00:00','2022-03-03T05:59:00')


-- SELECT  P.ID_PROFESOR, NOMBRE, P_APELLIDO, TELEFONO, EMAIL 
-- FROM PROFESORES P LEFT JOIN CLASES C
-- ON P.ID_PROFESOR = C.ID_PROFESOR
-- WHERE (C.INICIO NOT BETWEEN ('2022-02-27T15:00:00') AND ('2022-02-27T16:59:00')) 
-- AND (C.FINAL NOT BETWEEN ('2022-02-27T15:00:00') AND ('2022-02-27T16:59:00')) AND IDIOMA = 'INGLES'
-- -- AND (CONVERT(TIME,'2022-02-27T15:00:00') BETWEEN HORA_ENTRADA AND HORA_SALIDA)
-- -- AND (CONVERT(TIME, '2022-02-27T16:59:00') BETWEEN HORA_ENTRADA AND HORA_SALIDA)
-- OR C.ID_PROFESOR IS NULL AND IDIOMA = 'INGLES'



-- --ULTIMO
-- SELECT  P.ID_PROFESOR, NOMBRE, P_APELLIDO, TELEFONO, EMAIL
-- FROM PROFESORES P LEFT JOIN CLASES C
-- ON P.ID_PROFESOR = C.ID_PROFESOR
-- WHERE NOT EXISTS (SELECT * FROM CLASES
-- WHERE (C.INICIO BETWEEN('2022-03-02T08:00:00') AND ('2022-03-02T09:59:00') 
-- OR C.FINAL BETWEEN ('2022-03-02T08:00:00') AND ('2022-03-02T09:59:00')) AND BORRADO_E = 0) 
-- AND CONVERT(TIME,'2022-02-02T08:00:00') BETWEEN HORA_ENTRADA AND HORA_SALIDA
-- AND CONVERT(TIME, '2022-02-02T09:59:00') BETWEEN HORA_ENTRADA AND HORA_SALIDA AND IDIOMA = 'INGLES'
-- OR C.ID_PROFESOR IS NULL AND IDIOMA = 'INGLES'
-- AND CONVERT(TIME,'2022-02-02T08:00:00') BETWEEN HORA_ENTRADA AND HORA_SALIDA
-- AND CONVERT(TIME, '2022-02-02T09:59:00') BETWEEN HORA_ENTRADA AND HORA_SALIDA
-- --GROUP BY P.ID_PROFESOR, NOMBRE, P_APELLIDO, TELEFONO, EMAIL



-- GO
-- DECLARE @FECHA TIME

-- BEGIN
-- 	SET @FECHA = CONVERT(TIME,'2022-02-27T15:00:00')
-- 	PRINT 'TIEMPO: '+ CAST(@FECHA AS VARCHAR)
-- END
-- GO


GO
CREATE OR ALTER TRIGGER TR_CLASES
ON CLASE AFTER INSERT 
AS
DECLARE @id_curso INT, @id_estudiante INT

select @id_curso = ID_CURSO FROM inserted
SELECT @id_estudiante = ID_ESTUDIANTE FROM inserted

UPDATE CURSOESTUDIANTE
SET HORAS_SINC_RES = HORAS_SINC_RES -2
WHERE ID_ESTUDIANTE = @id_estudiante AND ID_CURSO = @id_curso
GO


CREATE OR ALTER PROCEDURE CURSO_NEXT
	@id_estudiante int,
	@idioma VARCHAR(20),
	@msj varchar(100) out
AS BEGIN
DECLARE @id_curso int
	IF NOT EXISTS(SELECT * FROM CURSOESTUDIANTE
					WHERE ID_ESTUDIANTE = @id_estudiante)
	BEGIN	
		SELECT TOP 1 @id_curso = C.ID_CURSO FROM CURSO C
			INNER JOIN PROGRAMA PR 
			ON C.ID_PROGRAMA = PR.ID_PROGRAMA
			WHERE PR.IDIOMA = @idioma

		set @msj = CAST(@id_curso AS varchar)	
	END
	ELSE
	BEGIN
	SELECT 	TOP 1 @id_curso = C.ID_CURSO FROM CURSO C
				INNER JOIN CURSOESTUDIANTE CE
				ON CE.ID_CURSO != C.ID_CURSO OR CE.ID_CURSO = C.ID_CURSO AND CE.ESTADO = 'REP'
				INNER JOIN ESTUDIANTE E
				ON CE.ID_ESTUDIANTE = E.ID_ESTUDIANTE
				INNER JOIN PROGRAMA PR 
				ON C.ID_PROGRAMA = PR.ID_PROGRAMA
				WHERE PR.IDIOMA = @idioma AND E.ID_ESTUDIANTE = @id_estudiante
		set @msj = CAST(@id_curso AS varchar)
	END	
END


SELECT * FROM CURSOESTUDIANTE

INSERT INTO CURSOESTUDIANTE(ID_ESTUDIANTE, ID_CURSO, FECHA_INICIO, FECHA_FINAL, ESTADO, HORAS_SINC_RES)
VALUES
(1,1,'2022-03-22T08:00:00','2022-03-25T08:00:00','ACT',20)

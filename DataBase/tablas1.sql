USE vamas2;
CREATE DATABASE vamas
DROP DATABASE vamas

CREATE TABLE personas 
(
	idpersona		SMALLINT AUTO_INCREMENT PRIMARY KEY,
	apellidos		VARCHAR(40) 	NOT NULL,
	nombres			VARCHAR(40) 	NOT NULL,
	tipodocumento		VARCHAR(20)	NOT NULL,
	nrodocumento		CHAR(8)	   	NOT NULL,
	telefono		CHAR(9)		NOT NULL,
	direccion		VARCHAR(200)	NOT NULL,
	estado			CHAR(1)		NOT NULL DEFAULT '1',
	fechanac		DATE 		NOT NULL,
	fecha_create		DATETIME 	NOT NULL DEFAULT NOW(),
	fechabaja		DATETIME	NULL
)ENGINE = INNODB;

INSERT INTO personas (apellidos,nombres,tipodocumento,nrodocumento,telefono,direccion,fechanac)
VALUES('Marquina Jaime','Ángel Eduardo','DNI','72745028','951531166','León de Vivero MZ V L-2','2004-07-10'),
	('Padilla Chumbiauca','Marks Steven','DNI','72854857','924563458','Atrás de plaza vea','2004-06-07'),
	('Uribe Garcia','Cristhian Manuel','DNI','72548675','95123654','Rosedal por donde roban','2004-05-21'),
	('Chacaliaza Pachas','Ítalo Jesús','DNI','7254789','963214587','AV. Santos Nagaro 210','2003-10-29'),
	('Marquina Jaime','Emily Fernanda','DNI','78383886','952145879','León de Vivero Mz V LT-22','2013-12-16');
	
SELECT * FROM personas;

SELECT * FROM colaboradores;




-------------------------------------------------------


DELIMITER $$
CREATE PROCEDURE registrarColaboradores(
	IN _idpersona SMALLINT,
	IN _usuario VARCHAR(20),
	IN _correo VARCHAR(20),
	IN _clave VARCHAR(200)
)
BEGIN
	INSERT INTO colaboradores(idpersona,usuario,correo,clave,nivelacceso)
	VALUES(_idpersona,_usuario,_correo,_clave,'C');
END $$

CALL registrarColaboradores('1','mase','1342364@senati.pe','SENATI');
DROP PROCEDURE registrarColaboradores
SELECT * FROM colaboradores 

-----------------------------------------

DELIMITER $$
CREATE PROCEDURE registrarColaboradores(
	IN _idpersona SMALLINT,
	IN _usuario VARCHAR(20),
	IN _correo VARCHAR(20),
	IN _clave VARCHAR(20)
)
BEGIN
	INSERT INTO colaboradores(idpersona,usuario,correo,clave,nivelacceso)
	VALUES(_idpersona,_usuario,_correo,_clave,'C');
END $$

CALL registrarColaboradores('6','FerMJ','1342364@senati.pe','SENATI');

-----------------------------------------

DELIMITER $$
CREATE PROCEDURE obtener_idpersona(IN _nrodocumento CHAR(8))
BEGIN
	SELECT idpersona 
	FROM personas
	WHERE nrodocumento = _nrodocumento;
END $$

CALL obtener_idpersona(72854857);


--------------------------------------------------------------

CREATE TABLE colaboradores
(
	idcolaboradores		SMALLINT AUTO_INCREMENT PRIMARY KEY,
	idpersona		SMALLINT 	NOT NULL,
	usuario			VARCHAR(20)	NOT NULL,
	clave			VARCHAR(200)	NOT NULL,
	correo			VARCHAR(100)	NULL,
	nivelacceso		CHAR(1)		NOT NULL DEFAULT 'C',
	fecha_create		DATETIME 	NOT NULL DEFAULT NOW(),
	fecha_update		DATETIME	NULL,
	estado			CHAR(1)		NOT NULL DEFAULT '1',
	CONSTRAINT fk_idpersona_per FOREIGN KEY (idpersona) REFERENCES personas(idpersona),
	CONSTRAINT uc_usuario UNIQUE (usuario)
)ENGINE = INNODB; 




INSERT INTO colaboradores(idpersona,usuario,clave,correo,nivelacceso)
VALUES(1,'AngelMJ','SENATI','1343238@senati.pe','A'),(2,'MarksPC','SENATI','1343238@senati.pe','S'),
	(5,'EmyMJ','SENATI','1343238@senati.pe','S'),(4,'JesusPC','SENATI','1343238@senati.pe','C');

UPDATE colaboradores SET
	clave = '$2y$10$WY.iP85bEYxBMkVBG0jKO.9Q97kEbofLVwJPUT1OAmsDzLXQ8Pcka';
	
UPDATE colaboradores SET
	correo = 'angelitomasna200410@gmail.com' WHERE idcolaboradores = 1;

SELECT * FROM colaboradores WHERE usuario = 'AngelMJ' AND estado = 1;
--------------------------------------------


CREATE TABLE recuperarClave
(
	idrecuperar		INT AUTO_INCREMENT PRIMARY KEY,
	idcolaboradores		SMALLINT 	NOT NULL,
	fecharegeneracion	DATETIME 	NOT NULL DEFAULT NOW(),
	correo			VARCHAR(200)	NOT NULL, 		-- Email que se utilizó en ese momento
	clavegenerada		CHAR(4)		NOT NULL,
	estado 			CHAR(1)		NOT NULL DEFAULT '1',
	CONSTRAINT fk_idcolaboradores_rcl FOREIGN KEY(idcolaboradores) REFERENCES colaboradores(idcolaboradores)
)ENGINE = INNODB;

--------------------------------------------

CREATE TABLE habilidades
(
	idhabilidades		SMALLINT AUTO_INCREMENT PRIMARY KEY,
	idcolaboradores		SMALLINT 	NOT NULL,
	habilidad		VARCHAR(40)	NOT NULL,
	fecha_create		DATETIME 	NOT NULL DEFAULT NOW(),
	fecha_update		DATETIME	NULL,
	estado			CHAR(1)		NOT NULL DEFAULT '1',
	CONSTRAINT fk_idcolaboradores_col FOREIGN KEY(idcolaboradores) REFERENCES colaboradores (idcolaboradores)
)ENGINE = INNODB;

INSERT INTO habilidades(idcolaboradores,habilidad)
VALUES('1','Análisis de datos'),('2','Front-end framework React')
SELECT * FROM habilidades;

----------------------------------------------------------

CREATE TABLE empresas
(
	idempresa		SMALLINT AUTO_INCREMENT PRIMARY KEY,
	nombre			VARCHAR(40)	NOT NULL,
	razonsocial		VARCHAR(40)	NOT NULL,
	tipodocumento		VARCHAR(20)	NOT NULL,
	documento		VARCHAR(40)	NOT NULL,
	fecha_create		DATETIME	NOT NULL DEFAULT NOW(),
	fecha_update		DATETIME	NULL,
	estado			CHAR(1)		NOT NULL DEFAULT '1'
)ENGINE = INNODB;

INSERT INTO empresas(nombre,razonsocial,tipodocumento,documento)
VALUES('VAMAS S.A.C.','Vamas','RUC','20609878313'),
	('Mamá Carmen','Restaurant Mamá Carmen','RUC','20452365744'),
	('Prueba1','Prueba 1','RUC','2015785698'),
	('Prueba2','Prueba 2','RUC','20457896321');
	
UPDATE empresas SET estado = 1 WHERE idempresa = 1;

SELECT * FROM empresas;

-------------------------------------------------------------

CREATE TABLE tiposproyecto
(
	idtipoproyecto		SMALLINT AUTO_INCREMENT PRIMARY KEY,
	tipoproyecto		VARCHAR(40)	NOT NULL,
	fecha_create		DATETIME	NOT NULL DEFAULT NOW(),
	fecha_update		DATETIME	NULL ,
	estado			CHAR(1)		NOT NULL DEFAULT '1'
)ENGINE = INNODB;

INSERT INTO tiposproyecto(tipoproyecto) 
VALUES('Desarollo Web'),('Sistema de ventas'),('Sistema de almacen'),('Marketing');
SELECT * FROM tiposproyecto WHERE estado = 1

----------------------------------------------------------

CREATE TABLE proyecto
(
	idproyecto		SMALLINT AUTO_INCREMENT PRIMARY KEY,
	idtipoproyecto      	SMALLINT    	NOT NULL,
	idempresa           	SMALLINT    	NOT NULL,
	titulo			VARCHAR(60)	NOT NULL,
	descripcion		VARCHAR(200)	NOT NULL,
	fechainicio		DATE 		NOT NULL,
	fechafin		DATE		NOT NULL,
	precio			DECIMAL(6,2)	NOT NULL,
	condiciones		JSON		NULL,
	idusuariore		SMALLINT	NOT NULL,
	porcentaje		DECIMAL(5,2)	NULL DEFAULT'0',
	estado			CHAR(1)		NOT NULL DEFAULT '1',
	fecha_create		DATETIME	NOT NULL DEFAULT NOW(),
	fecha_update		DATETIME	NULL,
	CONSTRAINT fk_idtipoproyecto_pro FOREIGN KEY (idtipoproyecto) REFERENCES tiposproyecto (idtipoproyecto),
	CONSTRAINT fk_idempresa_tip 	FOREIGN KEY (idempresa) REFERENCES empresas (idempresa),
	CONSTRAINT fk_idusuariore_pro	FOREIGN KEY (idusuariore) REFERENCES colaboradores (idcolaboradores)
)ENGINE = INNODB;

INSERT INTO proyecto (idtipoproyecto,idempresa,titulo,descripcion,fechainicio,fechafin,precio,idusuariore)
VALUES ('1','1','Página web sobre test psicologicos','Prueba 2','2023-05-29','2023-05-31',150.00,'1');

INSERT INTO proyecto (idtipoproyecto,idempresa,titulo,descripcion,fechainicio,fechafin,precio,idusuariore)
VALUES ('2','2','Sistema de ventas pra un restaurante','Prueba 3','2023-05-29','2023-05-31',120.00,'1');

SELECT * FROM proyecto;

CALL listar_proyecto();

----------------------------------------------------------

CREATE TABLE fases
(
	idfase			SMALLINT AUTO_INCREMENT PRIMARY KEY,
	idproyecto		SMALLINT 	NOT NULL,
	idresponsable		SMALLINT 	NOT NULL,
	nombrefase		VARCHAR(40)	NOT NULL,
	fechainicio		DATE		NOT NULL,
	fechafin		DATE		NOT NULL,
	comentario		VARCHAR(200)	NOT NULL,
	porcentaje_fase		DECIMAL(5,2)	NULL DEFAULT'0',
	porcentaje		DECIMAL(5,2)	NOT NULL,
	fecha_create		DATETIME	NOT NULL DEFAULT NOW(),
	fecha_update		DATETIME	NULL,
	estado			CHAR(1)		NOT NULL DEFAULT '1',
	CONSTRAINT fk_idproyecto_fas FOREIGN KEY (idproyecto) REFERENCES proyecto (idproyecto),
	CONSTRAINT fk_idresponsable_fas FOREIGN KEY (idresponsable) REFERENCES colaboradores (idcolaboradores)
)ENGINE = INNODB;

INSERT INTO fases(idproyecto,idresponsable,nombrefase,fechainicio,fechafin,comentario,porcentaje) 
VALUES(1,'1','Creación del boceto','2023-05-29','2023-05-31',
	'En esta fase se crearán diferentes tipos de bocetos e ideas para la pagina y se eligirá uno',25);

INSERT INTO fases(idproyecto,idresponsable,nombrefase,fechainicio,fechafin,comentario,porcentaje) 
VALUES(1,'2','Creación de la Vista','2023-05-31','2023-06-03',
	'En esta fase se creará la vista basada en el boceto escogido',25);
	



SELECT * FROM fases;
CALL listar_fase();

----------------------------------------------------------

CREATE TABLE tareas 
(
	idtarea			SMALLINT AUTO_INCREMENT PRIMARY KEY,
	idfase			SMALLINT 	NOT NULL,
	idcolaboradores		SMALLINT	NOT NULL,
	roles			VARCHAR(40)	NOT NULL,
	tarea			VARCHAR(200)	NOT NULL,
	porcentaje_tarea	DECIMAL(5,2)	NULL DEFAULT 0,
	porcentaje		DECIMAL(5,2)	NOT NULL,
	evidencia		JSON		NULL DEFAULT'[]',
	fecha_create		DATETIME	NOT NULL DEFAULT NOW(),
	fecha_update		DATETIME	NULL,
	estado			CHAR(1)		NOT NULL DEFAULT '1',
	CONSTRAINT fk_idfase_tar FOREIGN KEY (idfase) REFERENCES fases (idfase),
	CONSTRAINT fk_idcolaboradores_tar FOREIGN KEY (idcolaboradores) REFERENCES colaboradores (idcolaboradores)
)ENGINE = INNODB;


INSERT INTO tareas(idfase,idcolaboradores,roles,tarea,porcentaje)
VALUES('1','1','Programador Front-end','Hacer el boceto y presentar su avance',10);

INSERT INTO tareas(idfase,idcolaboradores,roles,tarea,porcentaje)
VALUES('1','2','Programador Front-end','Hacer el boceto y presentar su avance',20);


SELECT * FROM tareas;
TRUNCATE TABLE tareas;
SELECT * FROM colaboradores;
SELECT * FROM fases;

SELECT tar.porcentaje_tarea * tar.porcentaje /100 FROM tareas tar;

SELECT fas.porcentaje_fase * fas.porcentaje /100 FROM fases fas;
















-------------------------------------------------------------------------
-- REGISTRAR A UN NUEVO COLABORADOR PRUEBA 1

DELIMITER //

CREATE PROCEDURE RegistrarColaborador(
    IN p_Apellidos VARCHAR(40),
    IN p_Nombres VARCHAR(40),
    IN p_TipoDocumento VARCHAR(20),
    IN p_NroDocumento CHAR(8),
    IN p_Telefono CHAR(9),
    IN p_Direccion VARCHAR(200),
    IN p_FechaNac DATE,
    IN p_Usuario VARCHAR(20),
    IN p_Clave VARCHAR(200),
    IN p_Correo VARCHAR(100),
    OUT p_IDPersona INT
)
BEGIN
    -- Declarar variables
    DECLARE v_IDColaborador INT;

    -- Iniciar una transacción
    START TRANSACTION;

    -- Insertar en la tabla de personas
    INSERT INTO personas (apellidos, nombres, tipodocumento, nrodocumento, telefono, direccion, fechanac)
    VALUES (p_Apellidos, p_Nombres, p_TipoDocumento, p_NroDocumento, p_Telefono, p_Direccion, p_FechaNac);
    SET p_IDPersona = LAST_INSERT_ID(); -- Obtener el IDPersona generado automáticamente

    -- Insertar en la tabla de colaboradores
    INSERT INTO colaboradores (idpersona, usuario, clave, correo, nivelacceso)
    VALUES (p_IDPersona, p_Usuario, p_Clave, p_Correo, 'C');
    SET v_IDColaborador = LAST_INSERT_ID(); -- Obtener el IDColaborador generado automáticamente

    -- Confirmar la transacción
    COMMIT;

    -- Retornar el ID de la persona generada
    SELECT p_IDPersona AS IDPersonaGenerado;
END //

DELIMITER ;

SELECT * FROM colaboradores;

SET @IDPersonaGenerado = 0;
CALL RegistrarColaborador('Doe', 'John', 'DNI', '12345678', '123456789', '123 Main St', '1990-01-01', 'johndoe', 'password', 'johndoe@example.com', @IDPersonaGenerado);
SELECT @IDPersonaGenerado AS IDPersonaGenerado;

CALL RegistrarColaborador('mase', 'PC', 'DNI', '12345678', '123456789', '123 Main St', '1990-01-01', 'mase', '123', 'mase@gmail.com', @IDPersonaGenerado);


DROP PROCEDURE RegistrarColaborador












-----------------------------------------------------------------
-- Hacemos la validacion de contraseña y actualización de user, con conteo automarico de tiempo :




CREATE TABLE recuperarClave
(
	idrecuperar			INT AUTO_INCREMENT PRIMARY KEY,
	idcolaboradores			SMALLINT	NOT NULL,
	fecharegeneracion		DATETIME	NOT NULL DEFAULT NOW(),
	correo				VARCHAR(100)	NOT NULL, 		-- Email que se utilizó en ese momento
	clavegenerada			CHAR(4)		NOT NULL,
	estado 				CHAR(1)		NOT NULL DEFAULT '1',
	CONSTRAINT fk_idcolaboradores_rcl FOREIGN KEY(idcolaboradores) REFERENCES colaboradores (idcolaboradores)
)ENGINE = INNODB;

INSERT INTO recuperarClave(idcolaboradores,correo,clavegenerada) 
VALUES(1,'email@email.com','1234');

SELECT * FROM recuperarClave

DELIMITER $$
CREATE PROCEDURE recuperar_clave
(
	IN _idcolaboradores		INT,
	IN _correo			VARCHAR(100),
	IN _clavegenerada		CHAR(4)
)
BEGIN
	UPDATE recuperarClave SET estado = '0' WHERE idcolaboradores = _idcolaboradores;
	INSERT INTO recuperarClave (idcolaboradores,correo,clavegenerada)
	VALUES(_idcolaboradores , _correo, _clavegenerada);

END $$

CALL recuperar_clave(1,'1342364@senati.pe','1234');

-----------------------------------------------------
DROP PROCEDURE spu_usuario_validartiempo

DELIMITER $$
CREATE PROCEDURE spu_usuario_validartiempo
(
	IN _idcolaboradores		INT
)
BEGIN
	IF ((SELECT COUNT(*) FROM recuperarclave WHERE idcolaboradores = _idcolaboradores) = 0) THEN
		SELECT 'GENERAR' AS 'status';
		ELSE
		-- Buscamos el ultimo estado del usuario NO IMPORTA SI es 0 o 1
		IF ((SELECT estado FROM recuperarclave WHERE idcolaboradores = _idcolaboradores ORDER BY 1 DESC LIMIT 1) = 0) THEN
			SELECT 'GENERAR' AS 'status';
		ELSE
			-- En esta seccion, el ultimo registro es '1', No sabemos si esta dentro de los 15 min permitidos
		IF
		(
				(
				SELECT COUNT(*) FROM recuperarclave
				WHERE idcolaboradores = _idcolaboradores AND estado = '1' AND NOW() NOT BETWEEN fechageneracion AND DATE_ADD(fechageneracion, INTERVAL 15 MINUTE)
				ORDER BY fechageneracion DESC LIMIT 1
				) = 1
		) THEN
				-- El usuario tiene estado 1, pero esta fuera de los 15 minutos
				SELECT 'GENERAR' AS 'status';
			ELSE
				SELECT 'DENEGAR' AS 'status';
			END IF;
		END IF;
	END IF;
END $$


CALL spu_usuario_validartiempo(3);
SELECT * FROM recuperarclave;
TRUNCATE recuperarclave;
----------------------------------------

DELIMITER $$
CREATE PROCEDURE spu_usuario_valida_tiempo
(
	IN _idcolaboradores 		INT
)
BEGIN
	SELECT COUNT(*) AS 'Total'
		FROM recuperarClave
		WHERE 
			idcolaboradores = _idcolaboradores AND
			estado = 1 AND
			NOW() BETWEEN fecharegeneracion AND
			DATE_ADD(fecharegeneracion, INTERVAL 15 MINUTE);
END $$

DROP PROCEDURE spu_usuario_valida_tiempo

CALL spu_usuario_valida_tiempo(1)
SELECT * FROM colaboradores;
		
-----------------
-- Procedimiento valida la clave ingresada
DELIMITER $$
CREATE PROCEDURE spu_usuario_validarclave
(
	IN _idcolaboradores  		INT,
	IN _clavegenerada		CHAR(4)
)
BEGIN 
	IF 
	(
		(
		SELECT clavegenerada FROM recuperarClave 
		WHERE idcolaboradores = _idcolaboradores
		AND estado = '1' 
		LIMIT 1
		) = _clavegenerada
	)
	THEN 
		SELECT 'PERMITIDO' AS 'status';
	ELSE
		SELECT 'DENEGADO' AS 'status';
	END IF;
END $$

CALL spu_usuario_validarclave(1,1234);

SELECT * FROM recuperarClave WHERE estado = 1;

-- OJALÁ SEA EL ULTIMO CTMRE
-- PROCEDIMIENTO QUE FINALMENTE ACUALIZARÁ LA CLAVE DESPUÉS DE TODAS
-- LAS VALIDACIONES

DELIMITER $$
CREATE PROCEDURE spu_usuarios_actualizarclave
(
	IN _idcolaboradores			INT,
	IN _claveacceso		VARCHAR(90)
)
BEGIN
	UPDATE colaboradores SET clave = _clave WHERE idcolaboradores = _idcolaboradores;
	UPDATE recuperarclave SET estado = '0' WHERE idcolaboradores = _idcolaboradores;
END $$
CALL spu_usuarios_actualizarclave(1,1);







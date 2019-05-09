USE [Comernova_DESA_1]
GO

/****** Object:  UserDefinedFunction [dbo].[CurpGenerator]    Script Date: 04/25/2019.******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--- <summary>
--- Copyright EliusQ – 2019
--- ==================================================================================
--- Nombre del Objeto: Generador de Curp SQL
--- Proyecto: Comernova/Originacion
--- Proceso Negocio: Precaptura
--- Descripcion: Genera la CURP
--- Nombre Base Datos: Comernova
--- Llamado por: Indefinido
--- </summary>
--- <remarks>
--- Historial de cambios:
------------------------------------------------------------------------------------------
-- Rev  | Ticket    | Fecha         | Desarrollador         | Resumen del cambio.
------------------------------------------------------------------------------------------
-- 1    | -         | 2019-04-25    | Elias Garza Sánchez   | Creación
-- 2    |-          | 2019-05-09    | Elias Garza Sánchez   | Terminación
-- </remarks>

ALTER function [dbo].[CurpGenerator](
    @P_Nombre varchar(15),
    @P_APaterno varchar(15),
    @P_AMaterno varchar(15),
    @P_Año varchar(4),
    @P_Mes varchar(2),
    @P_Dia varchar(2),
    @P_Genero char,
    @P_Estado varchar(40)
	)

    RETURNS varchar(18)
AS
BEGIN

    DECLARE
    @V_Nombre varchar(40),
    @V_APaterno varchar(15),
    @V_AMaterno varchar(15),
    @V_Año varchar(4),
    @V_Mes varchar(2),
    @V_Dia varchar(2),
    @V_Genero char,
    @V_Estado varchar(40),
    @V_Homoclave char(1),
	@V_CURP varchar(18),
	@V_CPaterno varchar(2),
	@V_CMaterno varchar(2),
	@V_CNombre varchar(2),

	--------------------------------
	@arreglo1   VARCHAR(38),
	@l_car      VARCHAR(2),
	@l_vals     VARCHAR(50),
	@l_acum     VARCHAR(18),
	@l_digito   VARCHAR(2),
	@Ultimodigito Varchar(2),
	@l_posicion INT,
	@l_residuo  INT,
	@l_valor    INT,
	@l_i        INT
	--------------------------------
	
--SCRIPTS--

--NOMBRE -- NAME--
	--Validacion de los nombres ' Jose ' & ' Maria ' -- Name Validation name ' Jose ' & ' Maria '
	--Validación "MARIA" -- Validation "MARIA"
		SET @P_Nombre = REPLACE(REPLACE(@P_Nombre,'Maria ',''),'maria ','')
	--Validación "JOSE" -- Validation "JOSE"
		SET @P_Nombre = REPLACE(REPLACE(@P_Nombre,'Jose ',''),'jose ','')


--AJUSTAR COMPUESTO [NOMBRE(S)] -- FIT COMPOUND [NAME (S)]--

	SET @P_Nombre = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@P_Nombre, 'DA ',''),'DAS ',''),'DE ',''),'DEL ',''),'DER ',''),'DI ',''),'DIE ',''),'DD ',''),'EL ',''),'LA ',''),'LOS ',''),'LAS ',''),'LE ',''),'LES ',''),'MAC ',''),'MC ',''),'VAN ',''),'VON ',''),'Y ','')
	SET @P_APaterno = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@P_APaterno, 'DA ',''),'DAS ',''),'DE ',''),'DEL ',''),'DER ',''),'DI ',''),'DIE ',''),'DD ',''),'EL ',''),'LA ',''),'LOS ',''),'LAS ',''),'LE ',''),'LES ',''),'MAC ',''),'MC ',''),'VAN ',''),'VON ',''),'Y ','')
	SET @P_AMaterno = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@P_AMaterno, 'DA ',''),'DAS ',''),'DE ',''),'DEL ',''),'DER ',''),'DI ',''),'DIE ',''),'DD ',''),'EL ',''),'LA ',''),'LOS ',''),'LAS ',''),'LE ',''),'LES ',''),'MAC ',''),'MC ',''),'VAN ',''),'VON ',''),'Y ','')


    --Normalizando el Nombre -- Normalize name
    SET @P_Nombre = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@P_Nombre, 'Ã', 'A'),'À', 'A'),'Á', 'A'),'Ä', 'A'),'Â', 'A'),'È', 'E'),'É', 'E'),'Ë', 'E'),'Ê', 'E'),'Ì', 'I'),'Í', 'I'),'Ï', 'I'),'Î', 'I'),'Ò', 'O'),'Ó', 'O'),'Ö', 'O'),'Ô', 'O'),'Ù', 'U'),'Ú', 'U'),'Ü', 'U'),'Û', 'U'),'ã', 'a'),'à', 'a'),'á', 'a'),'ä', 'a'),'â', 'a'),'è', 'e'),'é', 'e'),'ë', 'e'),'ê', 'e'),'ì', 'i'),'í', 'i'),'ï', 'i'),'î', 'i'),'ò', 'o'),'ó', 'o'),'ö', 'o'),'ô', 'o'),'ù', 'u'),'ú', 'u'),'ü', 'u'),'û', 'u'),'Ñ', 'N'),'ñ', 'n'),'Ç', 'C'),'ç', 'c')

    --Obtiene la primera letras del Nombre --Get the first letter of the name
    SET @V_Nombre = SUBSTRING (@P_Nombre,1,1)


--APELLIDO PATERNO -- PARENTAL SURNAME--
    --Obtiene las primeras 2 letras del apellido paterno -- Get the first 2 letter of the parental name
    SET @V_APaterno = SUBSTRING (@P_APaterno,1,2)


--APELLIDO MATERNO -- MATERNAL SURNAME--
    --Obtiene la primera del nombre materno -- Get the first letter of the maternal surname
    SET @V_AMaterno = SUBSTRING (@P_AMaterno,1,1)


--AÑO -- YEAR--
    --Obtiene el año -- Get Year
    SET @V_Año = SUBSTRING (@P_Año,3,4)

    --Obtiene el Mes -- Get Month
    SET @V_Mes = @P_Mes

    --Obtiene el Dia -- Get Day
    SET @V_Dia = @P_Dia

    --Obtiene la primera letra del Genero (Hombre/Mujer) -- Get the first letter of the gender (Men/Woman)
    SET @V_Genero = @P_Genero


--ESTADOS -- STATES--
    --Obtiene las Entidades Federativas -- Get the federal entity

	SET @P_Estado = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@P_Estado, 'Ã', 'A'),'À', 'A'),'Á', 'A'),'Ä', 'A'),'Â', 'A'),'È', 'E'),'É', 'E'),'Ë', 'E'),'Ê', 'E'),'Ì', 'I'),'Í', 'I'),'Ï', 'I'),'Î', 'I'),'Ò', 'O'),'Ó', 'O'),'Ö', 'O'),'Ô', 'O'),'Ù', 'U'),'Ú', 'U'),'Ü', 'U'),'Û', 'U'),'ã', 'a'),'à', 'a'),'á', 'a'),'ä', 'a'),'â', 'a'),'è', 'e'),'é', 'e'),'ë', 'e'),'ê', 'e'),'ì', 'i'),'í', 'i'),'ï', 'i'),'î', 'i'),'ò', 'o'),'ó', 'o'),'ö', 'o'),'ô', 'o'),'ù', 'u'),'ú', 'u'),'ü', 'u'),'û', 'u'),'Ñ', 'N'),'ñ', 'n'),'Ç', 'C'),'ç', 'c')
	SELECT @V_Estado = CASE @P_Estado
    WHEN 'Aguascalientes'
    THEN 'AS'

    WHEN 'Baja California'
    THEN 'BC'

    WHEN 'Baja California Sur'
    THEN 'BS'

    WHEN 'Campeche'
    THEN 'CC'

    WHEN 'Chiapas'
    THEN 'CS'

    WHEN 'Chihuahua'
    THEN 'CH'

    WHEN 'Ciudad de Mexico'
    THEN 'DF'

    WHEN 'Coahuila'
    THEN 'CL'

    WHEN 'Colima'
    THEN 'CM'

    WHEN 'Durango'
    THEN 'DG'

    WHEN 'Guanajuato'
    THEN 'GT'

    WHEN 'Guerrero'
    THEN 'GR'

    WHEN 'Hidalgo'
    THEN 'HG'

    WHEN 'Jalisco'
    THEN 'JC'

    WHEN 'Mexico'
    THEN 'MC'

    WHEN 'Michoacan'
    THEN 'MN'

    WHEN 'Morelos'
    THEN 'MS'

    WHEN 'Nayarit'
    THEN 'NT'

    WHEN 'Nuevo Leon'
    THEN 'NL'

    WHEN 'Oaxaca'
    THEN 'OC'

    WHEN 'Puebla'
    THEN 'PL'

    WHEN 'Queretaro'
    THEN 'QO'

    WHEN 'Quintana Roo'
    THEN 'QR'

    WHEN 'San Luis Potosi'
    THEN 'SP'

    WHEN 'Sinaloa'
    THEN 'SL'

    WHEN 'Sonora'
    THEN 'SR'

    WHEN 'Tabasco'
    THEN 'TC'

    WHEN 'Tamaulipas'
    THEN 'TS'

    WHEN 'Tlaxcala'
    THEN 'TL'

    WHEN 'Veracruz'
    THEN 'VZ'

    WHEN 'Yucatan'
    THEN 'YN'

    WHEN 'Zacatecas'
    THEN 'ZS'
END


    --Reemplaza las consonantes de Nombre/Apellido Paterno/Apellido Materno & Obtiene las primer letra de  Nombre/Apellido Paterno/Apellido Materno -- Replace name and surname consonants 
	SET @V_CPaterno = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@P_APaterno, 'A', ''), 'E', ''), 'O', ''), 'U', ''), 'I', '')
	SET @V_CPaterno = SUBSTRING (@V_CPaterno,2,1)
  
	SET @V_CMaterno = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@P_AMaterno, 'A', ''), 'E', ''), 'O', ''), 'U', ''), 'I', '')
	SET @V_CMaterno = SUBSTRING (@V_CMaterno,2,1)
  
	SET @V_CNombre = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@P_Nombre, 'A', ''), 'E', ''), 'O', ''), 'U', ''), 'I', '')
	SET @V_CNombre = SUBSTRING (@V_CNombre,2,1)


    --Obtiene la Homoclave--Get Homoclave
    IF (@V_Año >= 2000)
        SET @V_Homoclave = 'A'
    ELSE
        SET @V_Homoclave = '0'


--VALIDACIONES DE PALABRAS ANTISONANTES -- ANTIRING WORD VALIDATIONS--
	--Filtra palabras altisonantes en los primeros 4 caracteres del CURP -- Filter sounding words in the first 4 characters of the CURP
	SET @V_Curp = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@V_Curp, 'BACA', 'XACA'),'LOCO', 'XOCO'),'BUEI', 'XUEI'),'BUEY', 'XUEY'),'MAME', 'XAME'),'CACA', 'XACA'),'MAMO', 'XAMO'),'CACO', 'XACO'),'MEAR', 'XEAR'),'CAGA', 'XAGA'),'MEAS', 'XEAS'),'CAGO', 'XAGO'),'MEON', 'XEON'),'CAKA', 'XAKA'),'MIAR', 'XIAR'),'CAKO', 'XAKO'),'MION', 'XION'),'COGE', 'XOGE'),'MOCO', 'XOCO'),'COGI', 'XOGI'),'MOKO', 'XOKO'),'COJA', 'XOJA'),'MULA', 'XULA'),'COJE', 'XOJE'),'MULO', 'XULO'),'COJI', 'XOJI'),'NACA', 'XACA'),'COJO', 'XOJO'),'NACO', 'XACO'),'COLA', 'XOLA'),'PEDA', 'XEDA'),'CULO', 'XULO'),'PEDO', 'XEDO'),'FALO', 'XALO'),'PENE', 'XENE'),'FETO', 'XETO'),'PIPI', 'XIPI'),'GETA', 'XETA'),'PITO', 'XITO'),'GUEI', 'XUEI'),'POPO', 'XOPO'),'GUEY', 'XUEY'),'PUTA', 'XUTA'),'JETA', 'XETA'),'PUTO', 'XUTO'),'JOTO', 'XOTO'),'QULO', 'XULO'),'KACA', 'XACA'),'RATA', 'XATA'),'KACO', 'XACO'),'ROBA', 'XOBA'),'KAGA', 'XAGA'),'ROBE', 'XOBE'),'KAGO', 'XAGO'),'ROBO', 'XOBO'),'KAKA', 'XAKA'),'RUIN', 'XUIN'),'KAKO', 'XAKO'),'SENO', 'XENO'),'KOGE', 'XOGE'),'TETA', 'XETA'),'KOGI', 'XOGI'),'VACA', 'XACA'),'KOJA', 'XOJA'),'VAGA', 'XAGA'),'KOJE', 'XOJE'),'VAGO', 'XAGO'),'KOJI', 'XOJI'),'VAKA', 'XAKA'),'KOJO', 'XOJO'),'VUEI', 'XUEI'),'KOLA', 'XOLA'),'VUEY', 'XUEY'),'KULO', 'XULO'),'WUEI', 'XUEI'),'LILO', 'XILO'),'WUEY', 'XUEY'),'LOCA', 'XOCA')

--CURP--
	--Genera el Resultado en una CURP de 17 Digitos -- Generates the result in a 17-Digit CURP
	SET @V_CURP = (@V_APaterno + @V_AMaterno + @V_Nombre + @V_Año + @V_Mes + @V_Dia + @V_Genero + @V_Estado + @V_CPaterno + @V_CMaterno + @V_CNombre + @V_Homoclave)


--EL DIGITO--
	--Get last character
	SET @arreglo1 = '0123456789ABCDEFGHIJKLMN-OPQRSTUVWXYZ*'

	--PRINT 'inicia'
IF (LEN(@V_CURP) <= 17)
	--RETURN 0

	-- Ciclo para obtener los valores de CADA caracter de la Curp en \"arreglo2() \' y armar una cadena con estos valores 
	SET @l_i = 1
	--PRINT 'antes de ciclo'
WHILE @l_i <= LEN(@V_CURP)
BEGIN
	SET @l_car = SUBSTRING(@V_CURP, @l_i, 1)
	--PRINT 'ciclo= ' + convert(varchar,@l_i) + ', @l_car = ' + @l_car
IF @l_car = ''
	SET @l_car = '*'
	SET @l_posicion = PATINDEX('%' + @l_car + '%', @arreglo1)
	--PRINT 'ciclo= ' + convert(varchar,@l_i) + ', @l_posicion = ' + convert(varchar, @l_posicion)
IF @l_posicion > -1
	SET @l_vals = ISNULL(@l_vals, '') + RIGHT('00' + CONVERT(VARCHAR, @l_posicion - 1), 2)
ELSE
	SET @l_vals = ISNULL(@l_vals, '') + '00'
  
	--PRINT 'ciclo= ' + convert(varchar,@l_i) + ', @l_vals = ' + convert(varchar, @l_vals)
	SET @l_i = @l_i + 1
END

	--PRINT 'despues de ciclo '
	SET @l_i = 1
	SET @l_acum = ''

	--PRINT 'antes de ciclo 2, @l_vals' + isnull(@l_vals, '')
WHILE @l_i <= 17
BEGIN
	SET @l_acum = ISNULL(@l_acum, '') + (CONVERT(FLOAT, SUBSTRING(@l_vals, @l_i * 2 - 1, 2)) * (19 - @l_i))
	--PRINT 'ciclo )= ' + convert(varchar,@l_i) +', @l_acum = ' + isnull(@l_acum, '')
	SET @l_i = @l_i + 1
END

	--PRINT 'despues de ciclo 2'
	SET @l_residuo = @l_acum % 10
	--PRINT 'residuo = ' + convert(varchar, @l_residuo)
IF @l_residuo = 0
	SET @l_digito = '0'
ELSE
BEGIN
	SET @l_valor = 10 - @l_residuo
	--PRINT '@l_valor = ' + convert(varchar, @l_valor)
	SET @l_digito = RIGHT(CONVERT(VARCHAR, @l_valor), 1)
END

	SET @l_digito = convert(varchar, @l_digito)
	SET @Ultimodigito =  convert(varchar, @l_digito)

--CURP--
     --Genera el Resultado en una CURP -- Generates the result in a CURP
	SET @V_CURP = (@V_CURP + @Ultimodigito)

    RETURN UPPER(@V_CURP)

END 
--Nota
--Como saber el significado de cada letra y numero en la curp, a continuación de explica la misma:
    --CURP: SABC560626MDFLRN09
    --[SABC] - Inicial y Primer Vocal interna del primer apellido; Inicial de segundo apellido e inicial del nombre.
    --[560626] - Fecha de Nacimiento: AA/MM/DD.
    --[M] - Sexo (Genero) [H/M]
    --[DF] - Entidad Federativa de Nacimiento.
    --[LRN] - }Primeras consonantes internas de apellido(s) y nombre.
    --[09] - Homoclave Genrerada por algoritmo por la RENAPO
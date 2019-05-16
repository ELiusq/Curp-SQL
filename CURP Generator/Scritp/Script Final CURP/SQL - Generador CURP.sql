USE [TESTEQ]
GO
/****** Object:  UserDefinedFunction [dbo].[CurpGenerator]    Script Date: 14/05/2019 12:44:25 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--- Historial de cambios:
------------------------------------------------------------------------------------------
-- Rev  | Ticket    | Fecha         | Desarrollador         | Resumen del cambio.
------------------------------------------------------------------------------------------
-- 1    | -         | 2019-04-25    | Elias Garza Sanchez   | Creación
-- 2    | -         | 2019-05-14    | Elias Garza Sánchez   | Terminación

CREATE FUNCTION [dbo].[CurpGenerator](
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
    @V_APaterno varchar(40),
    @V_AMaterno varchar(40),
    @V_Año varchar(4),
    @V_Mes varchar(2),
    @V_Dia varchar(2),
    @V_Genero char,
    @V_Estado varchar(40),
    @V_Homoclave char(1),
    @V_CURP varchar(18),
    @V_CPaterno varchar(20),
    @V_CMaterno varchar(20),
    @ConsonanteInt1 varchar(2),
    @ConsonanteInt2 varchar(20),
    @ConsonanteIntAP1 varchar(2),
    @ConsonanteIntAP2 varchar(20),
    @V_SegAPaterno varchar(40),
    ----------------------------
    @arreglo1   VARCHAR(38),
    @l_car      VARCHAR(2),
    @l_vals     VARCHAR(50),
    @l_acum     VARCHAR(18),
    @l_digito   VARCHAR(2),
    @Ultimodigito Varchar(2),
    @l_posicion INT,
    @l_residuo  INT,
    @l_valor    INT,
    @l_i        INT,
    ---------------------------
    @V_PrimerAP varchar(2),
    @V_SegundoAP varchar(2),
    @V_LetrasApellido varchar(2)
    
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

--APELLIDO PATERNO -- PARENTAL SURNAME--   ANDRADE 
    SET @V_PrimerAP = SUBSTRING (@P_APaterno,1,1)
    SET @V_SegundoAP = SUBSTRING (@P_APaterno,2,1)

    IF @V_SegundoAP IN ('A','E','I','O','U')
        BEGIN
        SET @V_LetrasApellido = @V_PrimerAP + @V_SegundoAP
    END
    
    IF @V_SegundoAP NOT IN ('A','E','I','O','U')
    BEGIN 
        SET @V_SegAPaterno = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@P_APaterno, 'B', ''), 'C', ''), 'D', ''), 'F', ''), 'G', ''), 'H', ''), 'J', ''), 'K', ''), 'L', ''), 'M', ''), 'N', ''), 'P', ''), 'Q', ''), 'R', ''), 'S', ''), 'T', ''), 'V', ''), 'W', ''), 'X', ''), 'Y', ''), 'Z', '')
        SET @V_SegundoAP = SUBSTRING (@V_SegAPaterno,2,1)
    SET @V_LetrasApellido = @V_PrimerAP + @V_SegundoAP  
    END


--APELLIDO MATERNO -- MATERNAL SURNAME--
    --Obtiene la primera del nombre materno -- Get the first letter of the maternal surname
    IF @V_AMaterno = ''
        SET @V_AMaterno = 'X'
    ELSE
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


SET @P_APaterno = UPPER(@P_APaterno)
SET @ConsonanteIntAP1 = SUBSTRING (@P_APaterno,1,1)
IF @ConsonanteIntAP1 = 'B' OR @ConsonanteIntAP1 = 'C' OR @ConsonanteIntAP1 = 'D' OR @ConsonanteIntAP1 = 'F' OR @ConsonanteIntAP1 = 'G' OR @ConsonanteIntAP1 = 'H' OR @ConsonanteIntAP1 = 'J' OR @ConsonanteIntAP1 = 'K' OR @ConsonanteIntAP1 = 'L' OR @ConsonanteIntAP1 = 'M' OR @ConsonanteIntAP1 = 'N' OR @ConsonanteIntAP1 = 'P' OR @ConsonanteIntAP1 = 'Q' OR @ConsonanteIntAP1 = 'R' OR @ConsonanteIntAP1 = 'S' OR @ConsonanteIntAP1 = 'T' OR @ConsonanteIntAP1 = 'V' OR @ConsonanteIntAP1 = 'W' OR @ConsonanteIntAP1 = 'X' OR @ConsonanteIntAP1 = 'Y' OR @ConsonanteIntAP1 = 'Z'
BEGIN    SET @ConsonanteIntAP2 = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@P_APaterno, 'A', ''), 'E', ''), 'O', ''), 'U', ''), 'I', '')
    SET @ConsonanteIntAP1 = SUBSTRING (@ConsonanteIntAP2,2,1)
   
END

 IF  @ConsonanteIntAP1 = 'A' OR @ConsonanteIntAP1 = 'E' OR @ConsonanteIntAP1 = 'I' OR @ConsonanteIntAP1 = 'O' OR @ConsonanteIntAP1 = 'U'
BEGIn SET @ConsonanteIntAP2 = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@P_APaterno, 'A', ''), 'E', ''), 'O', ''), 'U', ''), 'I', '')
    SET @ConsonanteIntAP1 = SUBSTRING (@ConsonanteIntAP2,1,1)
    
END

    ----------------------------------------------------------------------------------------------------------------------------------------
    SET @V_CMaterno = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@P_AMaterno, 'A', ''), 'E', ''), 'O', ''), 'U', ''), 'I', '')
    SET @V_CMaterno = SUBSTRING (@V_CMaterno,2,1)
  
    ----------------------------------------------------------------------------------------------------------------------------------------
SET @P_Nombre = UPPER(@P_Nombre)
SET @ConsonanteInt1 = SUBSTRING (@P_Nombre,1,1)
IF @ConsonanteInt1 = 'B' OR @ConsonanteInt1 = 'C' OR @ConsonanteInt1 = 'D' OR @ConsonanteInt1 = 'F' OR @ConsonanteInt1 = 'G' OR @ConsonanteInt1 = 'H' OR @ConsonanteInt1 = 'J' OR @ConsonanteInt1 = 'K' OR @ConsonanteInt1 = 'L' OR @ConsonanteInt1 = 'M' OR @ConsonanteInt1 = 'N' OR @ConsonanteInt1 = 'P' OR @ConsonanteInt1 = 'Q' OR @ConsonanteInt1 = 'R' OR @ConsonanteInt1 = 'S' OR @ConsonanteInt1 = 'T' OR @ConsonanteInt1 = 'V' OR @ConsonanteInt1 = 'W' OR @ConsonanteInt1 = 'X' OR @ConsonanteInt1 = 'Y' OR @ConsonanteInt1 = 'Z'
BEGIN    SET @ConsonanteInt2 = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@P_Nombre, 'A', ''), 'E', ''), 'O', ''), 'U', ''), 'I', '')
    SET @ConsonanteInt1 = SUBSTRING (@ConsonanteInt2,2,1)
   
END

 IF  @ConsonanteInt1 = 'A' OR @ConsonanteInt1 = 'E' OR @ConsonanteInt1 = 'I' OR @ConsonanteInt1 = 'O' OR @ConsonanteInt1 = 'U'
BEGIn SET @ConsonanteInt2 = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@P_Nombre, 'A', ''), 'E', ''), 'O', ''), 'U', ''), 'I', '')
    SET @ConsonanteInt1 = SUBSTRING (@ConsonanteInt2,1,1)
    
END

    ----------------------------------------------------------------------------------------------------------------------------------------

    --Obtiene la Homoclave--Get Homoclave
    IF (@V_Año >= 2000)
        SET @V_Homoclave = 'A'
    ELSE
        SET @V_Homoclave = '0'

--CURP--
    --Genera el Resultado en una CURP de 17 Digitos -- Generates the result in a 17-Digit CURP
    SET @V_CURP = (@V_LetrasApellido + @V_AMaterno + @V_Nombre + @V_Año + @V_Mes + @V_Dia + @V_Genero + @V_Estado + @ConsonanteIntAP1 + @V_CMaterno + @ConsonanteInt1 + @V_Homoclave)

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

    --VALIDACIONES DE PALABRAS ANTISONANTES -- ANTIRING WORD VALIDATIONS--
    --Filtra palabras altisonantes en los primeros 4 caracteres del CURP -- Filter sounding words in the first 4 characters of the CURP
    SET @V_CURP = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@V_CURP, 'BACA', 'BACX'),'LOCO', 'LOCX'),'BUEI', 'BUEX'),'BUEY', 'BUEX'),'MAME', 'MAMX'),'CACA', 'CACX'),'MAMO', 'MAMX'),'CACO', 'CACX'),'MEAR', 'MEAX'),'CAGA', 'CAGX'),'MEAS', 'MEAX'),'CAGO', 'CAGX'),'MEON', 'MEOX'),'CAKA', 'CAKX'),'MIAR', 'MIAX'),'CAKO', 'CAKX'),'MION', 'MIOX'),'COGE', 'COGX'),'MOCO', 'MOCX'),'COGI', 'COGX'),'MOKO', 'MOKX'),'COJA', 'COJX'),'MULA', 'MULX'),'COJE', 'COJX'),'MULO', 'MULX'),'COJI', 'COJX'),'NACA', 'NACX'),'COJO', 'COJX'),'NACO', 'NACX'),'COLA', 'COLX'),'PEDA', 'PEDX'),'CULO', 'CULX'),'PEDO', 'PEDX'),'FALO', 'FALX'),'PENE', 'PENX'),'FETO', 'FETX'),'PIPI', 'PIPX'),'GETA', 'GETX'),'PITO', 'PITX'),'GUEI', 'GUEX'),'POPO', 'POPX'),'GUEY', 'GUEX'),'PUTA', 'PUTX'),'JETA', 'JETX'),'PUTO', 'PUTX'),'JOTO', 'JOTX'),'QULO', 'QULX'),'KACA', 'KACX'),'RATA', 'RATX'),'KACO', 'KACX'),'ROBA', 'ROBX'),'KAGA', 'KAGX'),'ROBE', 'ROBX'),'KAGO', 'KAGX'),'ROBO', 'ROBX'),'KAKA', 'KAKX'),'RUIN', 'RUIX'),'KAKO', 'KAKX'),'SENO', 'SENX'),'KOGE', 'KOGX'),'TETA', 'TETX'),'KOGI', 'KOGX'),'VACA', 'VACX'),'KOJA', 'KOJX'),'VAGA', 'VAGX'),'KOJE', 'KOJX'),'VAGO', 'VAGX'),'KOJI', 'KOJX'),'VAKA', 'VAKX'),'KOJO', 'KOJX'),'VUEI', 'VUEX'),'KOLA', 'KOLX'),'VUEY', 'VUEX'),'KULO', 'KULX'),'WUEI', 'WUEX'),'LILO', 'LILX'),'WUEY', 'WUEX'),'LOCA', 'LOCX')


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
    --[LRN] - Primeras consonantes internas de apellido(s) y nombre.
    --[09] - Homoclave Genrerada por algoritmo por la RENAPO
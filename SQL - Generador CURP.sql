USE [DBTest]
GO

/****** Object:  UserDefinedFunction [dbo].[CurpGenerator]    Script Date: 04/26/2019.******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--- <summary>
--- Copyright ELiusq – 2019
--- <remarks>
--- Historial de cambios:
---------------------------------------------------------------------------
-- Rev  | Fecha         | Desarrollador         | Resumen del cambio.
---------------------------------------------------------------------------
-- 1    | 2019-04-26    | ELiusq                | Creación
--
-- </remarks>

CREATE function [dbo].[CurpGenerator](
    @P_Name varchar(15),
    @P_LNP varchar(15),
    @P_LNM varchar(15),
    @P_Year varchar(4),
    @P_Month varchar(2),
    @P_Day varchar(2),
    @P_Sx char,
    @P_State varchar(4),
	)

    RETURNS varchar(18)
AS
BEGIN

    --Declarar Los Datos 
    DECLARE
    @V_Name varchar(15),
    @V_LNP varchar(15),
    @V_LNM varchar(15),
    @V_Year varchar(4),
    @V_Month varchar(2),
    @V_Day varchar(2),
    @V_Sx char,
    @V_State varchar(4),
    @CURP varchar(18)

	--SCRIPTS


    --Get the first 2 letters of the name
    SET @V_Name = SUBSTRING (@P_Name,1,1)

    --Get the first letter of the parental name
    SET @V_LNP = SUBSTRING (@P_LNP,1,2)

    --Get the first letter of the maternal surname
    SET @V_LNM = SUBSTRING (@P_LNM,1,1)

    --Get Year
    SET @V_Year = @P_Year

    --Get Month
    SET @V_Month = @P_Month

    --Get Day
    SET @V_Day = @P_Day

    --Get the first letter of the genre
    SET @V_Sx = @P_Sx

    --Get the federal entity
    SET @V_State = @P_State


    --Get CURP
    SELECT @Curp = (@V_LNP + @V_LNM + @V_Name + @V_Year + @V_Month + @V_Day + @V_Sx + @V_State)

    RETURN @CURP
END

--Nota
--Como saber el significado de cada letra y numero en la curp, a continuación de explica la misma:
    --CURP: SABC560626MDFLRN09
    --[SABC] - Inicial y Primer Vocal interna del primer apellido; Inicial de segundo apellido e inicial del nombre.
    --[560626] - Fecha de Nacimiento: AA/MM/DD.
    --[M] - Sexo (Genero) [H/M]
    --[DF] - Entidad Federativa de Nacimiento.
    --[LRN] - Primeras consonantes de apellido(s) y nombre.
    --[09] - Homoclave Genrerada por algoritmo por la RENAPO
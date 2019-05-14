DECLARE  @V_CNombre varchar(80),
@LetrasApellido varchar(2),
@ConsonanteInt1 varchar(2),
@ConsonanteInt2 varchar(20)

SET @V_CNombre = 'AURORA ROCIO'

SET @V_CNombre = UPPER(@V_CNombre)

SET @ConsonanteInt1 = SUBSTRING (@V_CNombre,1,1)

BEGIN
IF @ConsonanteInt1 = 'B' OR @ConsonanteInt1 = 'C' OR @ConsonanteInt1 = 'D' OR @ConsonanteInt1 = 'F' OR @ConsonanteInt1 = 'G' OR @ConsonanteInt1 = 'H' OR @ConsonanteInt1 = 'J' OR @ConsonanteInt1 = 'K' OR @ConsonanteInt1 = 'L' OR @ConsonanteInt1 = 'M' OR @ConsonanteInt1 = 'N' OR @ConsonanteInt1 = 'P' OR @ConsonanteInt1 = 'Q' OR @ConsonanteInt1 = 'R' OR @ConsonanteInt1 = 'S' OR @ConsonanteInt1 = 'T' OR @ConsonanteInt1 = 'V' OR @ConsonanteInt1 = 'W' OR @ConsonanteInt1 = 'X' OR @ConsonanteInt1 = 'Y' OR @ConsonanteInt1 = 'Z'
	SET @ConsonanteInt2 = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@V_CNombre, 'A', ''), 'E', ''), 'O', ''), 'U', ''), 'I', '')
	SET @ConsonanteInt1 = SUBSTRING (@ConsonanteInt2,2,1)
	SELECT @ConsonanteInt1 AS 'Comprueba 1'
END

BEGIN
IF  @ConsonanteInt1 = 'A' OR @ConsonanteInt1 = 'E' OR @ConsonanteInt1 = 'I' OR @ConsonanteInt1 = 'O' OR @ConsonanteInt1 = 'U'
	SET @ConsonanteInt2 = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@V_CNombre, 'A', ''), 'E', ''), 'O', ''), 'U', ''), 'I', '')
	SET @ConsonanteInt1 = SUBSTRING (@ConsonanteInt2,1,1)
	SELECT @ConsonanteInt1 AS 'Comprueba 2'
END

SELECT @ConsonanteInt1

--IF  @ConsonanteInt1 = 'A' OR @ConsonanteInt1 = 'E' OR @ConsonanteInt1 = 'I' OR @ConsonanteInt1 = 'O' OR @ConsonanteInt1 = 'U'
--SET @ConsonanteInt1 = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@V_CNombre, 'A', ''), 'E', ''), 'O', ''), 'U', ''), 'I', '')

--IF @ConsonanteInt1 = 'B' OR @ConsonanteInt1 = 'C' OR @ConsonanteInt1 = 'D' OR @ConsonanteInt1 = 'F' OR @ConsonanteInt1 = 'G' OR @ConsonanteInt1 = 'H' OR @ConsonanteInt1 = 'J' OR @ConsonanteInt1 = 'K' OR @ConsonanteInt1 = 'L' OR @ConsonanteInt1 = 'M' OR @ConsonanteInt1 = 'N' OR @ConsonanteInt1 = 'P' OR @ConsonanteInt1 = 'Q' OR @ConsonanteInt1 = 'R' OR @ConsonanteInt1 = 'S' OR @ConsonanteInt1 = 'T' OR @ConsonanteInt1 = 'V' OR @ConsonanteInt1 = 'W' OR @ConsonanteInt1 = 'X' OR @ConsonanteInt1 = 'Y' OR @ConsonanteInt1 = 'Z'
----SET @ConsonanteInt1 = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@ConsonanteInt1, 'B', ''), 'C', ''), 'D', ''), 'F', ''), 'G', ''), 'H', ''), 'J', ''), 'K', ''), 'L', ''), 'M', ''), 'N', ''), 'P', ''), 'Q', ''), 'R', ''), 'S', ''), 'T', ''), 'V', ''), 'W', ''), 'X', ''), 'Y', ''), 'Z', '')
--	SET @ConsonanteInt1 = SUBSTRING (@V_CNombre,2,1)
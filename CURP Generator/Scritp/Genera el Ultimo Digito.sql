	Declare	
	@arreglo1   VARCHAR(38),
	@l_car      VARCHAR(2),
	@l_vals     VARCHAR(50),
	@l_acum     VARCHAR(18),
	@l_digito   VARCHAR(2),
	@l_posicion INT,
	@l_residuo  INT,
	@l_valor    INT,
	@l_i        INT,
	@V_CURP varchar(18),
	

	SET @V_Curp = 'GASE960115HTCRNL0'


    --Get last character

	 SET @arreglo1 = '0123456789ABCDEFGHIJKLMN-OPQRSTUVWXYZ*'

  --PRINT 'inicia'
  IF (LEN(@V_CURP) < 17)
    RETURN 0

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
  --Sumatoria de valores 

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
  PRINT '@l_digito = ' + convert(varchar, @l_digito)

  Select @V_CURP
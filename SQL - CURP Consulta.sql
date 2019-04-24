Create function dbo.-*- (@curp char(18))
Returns int
as
Begin

	--Declarar Los Datos 
	Declare @Nombre int;
	Declare @APaterno int;
	Declare @AMaterno int;
	Declare @Genero int;
	Declare @Estado int;

    Declare @Año int;
    Declare @Mes int;
    Declare @Dia int;

    Declare @AñoActual int;
    Declare @MesActual int;
    Declare @DiaActual int;
    
	--Obtener los datos
	Set @Nombre
	Set @APaterno
	Set @AMaterno
	Set @Genero
	Set @Estado

    --Set @AñoActual = Datepart(year,Getdate())
    --Set @MesActual = Datepart(month,Getdate())
    --Set @DiaActual = Datepart(day,Getdate())
    
    Set @Año = 1900+ Cast (Substring (@curp,5,2) as int);
    Set @Mes = Cast (Substring (@curp,7,2) as int);
    Set @Dia = Cast (Substring (@curp,9,2) as int);
    
	--Scripts

    



    Return (@curp); 
End;
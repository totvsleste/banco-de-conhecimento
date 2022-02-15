DECLARE @recno int,
@message varchar(200)

PRINT '-------- Relatorio Listagem de Produto --------';  
 
-- Cursor para percorrer os registros
DECLARE cursor1 CURSOR FOR
	SELECT R_E_C_N_O_
	FROM SEA990 EA
	WHERE EA.D_E_L_E_T_ = ''
	AND NOT EXISTS 
		(
			SELECT 1 
			FROM SE1990 E1 
			WHERE E1.D_E_L_E_T_ = '' 
			AND E1.E1_FILIAL = EA.EA_FILORIG
			AND E1.E1_PREFIXO = EA.EA_PREFIXO
			AND E1.E1_NUM = EA.EA_NUM
			AND E1.E1_PARCELA = EA.EA_PARCELA
		)
	AND EA_CART = 'R'

--Abrindo Cursor
OPEN cursor1
 
-- Lendo a próxima linha
FETCH NEXT FROM cursor1 INTO @recno
 
-- Percorrendo linhas do cursor (enquanto houverem)
WHILE @@FETCH_STATUS = 0
	BEGIN

	Print ' '
	Select @message = 'RECNO QUE SERA EXCLUIDO ' + @recno
	Print @message
 
	-- Executando as rotinas desejadas manipulando o registro
	DELETE SEA990 WHERE R_E_C_N_O_ = @recno
	
	-- Lendo a próxima linha
	FETCH NEXT FROM cursor1 INTO @recno
END
 
-- Fechando Cursor para leitura
CLOSE cursor1
 
-- Finalizado o cursor
DEALLOCATE cursor1
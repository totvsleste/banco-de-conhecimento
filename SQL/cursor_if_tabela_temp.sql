DECLARE 
	@filial varchar(8),
	@idtrans varchar(9),
	@quantidade int,
	@diferenca NUMERIC(16,2)

declare @TEMP_TABLE TABLE (
	idtrans VARCHAR(9),
	filial VARCHAR(8),
	diferenca NUMERIC(16,2))
 
DECLARE cursor1 CURSOR FOR

	SELECT *
		FROM 
		(
			SELECT E2_FILIAL, E2_IDTRANS, 
			(
				SELECT COUNT(E5_IDTRANS)
					FROM SE5010 E5 (NOLOCK)
					WHERE E5.D_E_L_E_T_ = ''
						AND E5_TIPO = 'TB' AND (E5_NUMERO = E2.E2_NUM OR E5_IDTRANS = E2.E2_NUM)
						AND E5_FILORIG = E2.E2_FILIAL
						AND E5_DTCANBX = ''
						AND E5_SITUACA <> 'C'
			) AS QUANTIDADE
			FROM SE2010 E2 (NOLOCK)
				WHERE E2.D_E_L_E_T_ = '' 
					AND E2_TIPO = 'TB' AND E2_IDTRANS <> ''
					AND E2_EMISSAO >= '20180801' AND E2_SALDO = 0
		)AS RESULT
		WHERE QUANTIDADE > 2
		ORDER BY E2_FILIAL

OPEN cursor1
 
	FETCH NEXT FROM cursor1 INTO @filial, @idtrans, @quantidade
 
	WHILE @@FETCH_STATUS = 0
	BEGIN

		SELECT @diferenca=SUM(A)-SUM(B)
			FROM 
				(SELECT SUM(E5_VALOR) A, 0 B
						FROM SE5010 E5 (NOLOCK)
						WHERE E5.D_E_L_E_T_ = ''
							AND E5_TIPO = 'TB' AND (E5_NUMERO = @idtrans OR E5_IDTRANS = @idtrans)
							AND E5_FILORIG = @filial
							AND E5_RECPAG = 'R'
							AND E5_DTCANBX = ''
							AND E5_SITUACA <> 'C'
					UNION ALL
					SELECT 0 A, SUM(E5_VALOR) B
						FROM SE5010 E5 (NOLOCK)
						WHERE E5.D_E_L_E_T_ = ''
							AND E5_TIPO = 'TB' AND (E5_NUMERO = @idtrans OR E5_IDTRANS = @idtrans)
							AND E5_FILORIG = @filial
							AND E5_RECPAG = 'P'
							AND E5_DTCANBX = ''
							AND E5_SITUACA <> 'C') Z

					IF @diferenca <> 0
						BEGIN
							INSERT INTO @TEMP_TABLE
							SELECT @idtrans, @filial,@diferenca
						END

		FETCH NEXT FROM cursor1 INTO @filial, @idtrans, @quantidade
	END
 
CLOSE cursor1
 
DEALLOCATE cursor1

SELECT * FROM @TEMP_TABLE TRB
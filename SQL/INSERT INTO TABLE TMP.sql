declare @TEMP_TABLE TABLE (
	E1_FILIAL VARCHAR(8),
	E1_PORTADO VARCHAR(3),
	E1_AGEDEP VARCHAR(10),
	E1_CONTA VARCHAR(20),
	E1_XSUBCTA VARCHAR(3),
	E1_NUMBCO VARCHAR(20)
)
INSERT INTO @TEMP_TABLE
SELECT E1_FILIAL, E1_PORTADO, E1_AGEDEP, E1_CONTA, E1_XSUBCTA, E1_NUMBCO 
FROM SE1010
WHERE E1_NUMBCO <> ''
GROUP BY E1_FILIAL, E1_PORTADO, E1_AGEDEP, E1_CONTA, E1_XSUBCTA, E1_NUMBCO
HAVING (COUNT(E1_NUMBCO) >1 )

SELECT SE1.E1_FILIAL, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_TIPO, SE1.E1_EMISSAO, SE1.E1_VENCTO, SE1.E1_VALOR, SE1.E1_SALDO, SE1.E1_PORTADO, SE1.E1_AGEDEP, SE1.E1_CONTA, SE1.E1_XSUBCTA, TRB.E1_NUMBCO
FROM SE1010 SE1
INNER JOIN @TEMP_TABLE TRB ON SE1.E1_FILIAL = TRB.E1_FILIAL AND SE1.E1_PORTADO = TRB.E1_PORTADO
AND SE1.E1_AGEDEP = TRB.E1_AGEDEP AND SE1.E1_CONTA = TRB.E1_CONTA AND SE1.E1_XSUBCTA = TRB.E1_XSUBCTA
AND SE1.E1_NUMBCO = TRB.E1_NUMBCO
WHERE SE1.D_E_L_E_T_ = '' AND SE1.E1_XOCORR = '5'
ORDER BY TRB.E1_NUMBCO
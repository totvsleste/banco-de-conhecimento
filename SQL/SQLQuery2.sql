SELECT 	CT2_DEBITO AS CTACTB, ZA_CTACXA AS CTACXA
FROM CT2990 CT2 WITH (NOLOCK)
LEFT JOIN SZA990 SZA ON (SZA.ZA_FILIAL = '' AND CT2_DEBITO = ZA_CTACT1 AND SZA.D_E_L_E_T_ = '')
WHERE CT2.CT2_FILIAL = '0301'
AND CT2_KEY = '0301  FIN2122251    PA 58058002'
AND CT2_MOEDLC = '01'
AND CT2.D_E_L_E_T_ = ''
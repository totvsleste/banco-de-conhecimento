User Function COMPCP()

	Local a_RecSE2		:= {25,26,27,28}
	Local a_RecPA		:= {29}
	Local l_Contabiliza	:= .T.
	Local l_Aglutina	:= .T.
	Local l_Digita		:= .F.
	Local l_Juros		:= .F.
	Local l_Desconto	:= .F.
	Local l_Comissao	:= .F.
	Local d_DtBaixa		:= dDataBase

	If MaIntBxCP(2,a_RecSE2,,a_RecPA,,{l_Contabiliza,l_Aglutina,l_Digita,l_Juros,l_Desconto,l_Comissao},,,,,d_DtBaixa)
		Alert("Titulos compensados com sucesso!!!")
	Else
		Alert("Deu merda!!!!")
	EndIf

Return()
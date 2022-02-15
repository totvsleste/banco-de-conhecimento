User Function QDOGRDOC()

	Local n_Opc		:= ParamIxb[1]
	Local l_Pend	:= ParamIxb[2]

	If n_Opc == 3
		Alert("Inclusao")
	Elseif n_Opc == 4
		Alert("Alteracao")
	EndIf

Return(.T.)
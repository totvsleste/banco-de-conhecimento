User Function VldCharEsp()

	Local o_ValidaChar	:= clsComponentes():New()
	Local l_Result		:= .T.

	o_ValidaChar:CADEIASTRING := "nao pode utilizar @"
	l_Result := o_ValidaChar:mtdVldChrEsp()

Return( l_Result )
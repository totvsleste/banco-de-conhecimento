User Function MNTA9902()

	Local a_Arq1	:= ParamIxb[1]
	Local a_Arq2	:= ParamIxb[2]
	Local a_Arq3	:= ParamIxb[3]
	Local a_Arq4	:= ParamIxb[4]
	Local a_Arq5	:= ParamIxb[5]

	Local a_Ret		:= {}

	aAdd( a_Arq2, { "TESTE"  , NIL, "TESTE LABEL", } )

	Aadd( a_Ret, {a_Arq1, a_Arq2, a_Arq3, a_Arq4, a_Arq5} )

Return( a_Ret )
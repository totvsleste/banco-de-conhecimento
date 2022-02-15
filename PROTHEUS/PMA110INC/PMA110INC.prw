/*/{Protheus.doc} PMA110INC
//TODO Descrição auto-gerada.
@author Francisco
@since 15/05/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function PMA110INC()

	Local l_Ret	:= .F.

	If AF1->AF1_FSPROC <> "1"
		Alert( "Processo ainda nao finalizado!" )
		l_Ret := .T.
	EndIf

Return( l_Ret )
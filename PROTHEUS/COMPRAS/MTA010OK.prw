#include 'protheus.ch'
#include 'parmtype.ch'

user function MTA010OK

	Local l_ret := .T.

	Alert("MTA010OK")

	IF INCLUI
		l_ret := U_FCOMM002( "Inserir" )
	ENDIF

	IF ALTERA
		l_ret := U_FCOMM002( "Editar" )
	ENDIF

	IF !INCLUI .AND. !ALTERA
		l_ret := U_FCOMM002( "Excluir" )
	ENDIF

Return( l_ret )
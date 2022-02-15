User Function MT010INC()

	IF INCLUI
		U_FCOMM002( "Inserir" )
	ENDIF

	IF ALTERA
		U_FCOMM002( "Editar" )
	ENDIF

	IF !INCLUI .AND. !ALTERA
		U_FCOMM002( "Excluir" )
	ENDIF

Return()
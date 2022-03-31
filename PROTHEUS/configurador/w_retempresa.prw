function u_w_retempresa()

	Local a_Filial  := {}

    dbUseArea(.T.,"DBFCDX","\system\sigamat.emp","SM0", .T., .F.)

	DBSELECTAREA("SM0")
	SM0->(DBGOTOP())
	WHILE SM0->(!EOF())

        AADD(a_Filial,{SM0->M0_CODIGO, SM0->M0_CODFIL,SM0->M0_FILIAL} )

		SM0->(DBSKIP())

	ENDDO

    a_Filial := Upper(a_Filial[1])

return()

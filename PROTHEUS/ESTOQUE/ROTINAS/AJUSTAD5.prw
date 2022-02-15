User Function AJUSTAD5()


	If Aviso( SM0->M0_NOMECOM, "Executar somente se tiver certeza do que está fazendo!!", {"Sim","Nao"}, 2, "Atenção" ) == 1

		LjMsgRun( "Aguarde.... Ajustando SD5", "Ajuste de SD5", {|| f_AjustaSD5() } )

	EndIF

Return()

Static Function f_AjustaSD5()

	Local nI
	Local d_Valid	:= CTOD("  /  /  ")
	Local a_Dados	:= {	{ "FV3934", 850.00, "O10230", "03", "000007300", "2" },;
							{ "FV3934", 835.65, "O10231", "03", "000007300", "2" },;
							{ "FV3934", 850.00, "O10232", "03", "000007300", "2" },;
							{ "FV3934", 850.00, "O10233", "03", "000007300", "2" },;
							{ "FV3934", 844.25, "O10234", "03", "000007300", "2" },;
							{ "FV3934", 850.00, "O10235", "03", "000007300", "2" },;
							{ "FV3934", 850.00, "O10236", "03", "000007300", "2" },;
							{ "FV3934", 650.00, "O10237", "03", "000007300", "2" } }

	For nI:=1 To Len( a_Dados ) Step 1

		dbSelectArea( "SB8" )
		dbSetOrder( 3 )
		dbSeek( xFilial( "SB8" ) + a_Dados[ nI ][ 1 ] + a_Dados[ nI ][ 4 ] + a_Dados[ nI ][ 3 ] )

		dbSelectArea( "SD5" )
		RecLock( "SD5", .T. )
		SD5->D5_FILIAL	:= xFilial( "SD5" )
		SD5->D5_PRODUTO	:= a_Dados[ nI ][ 1 ]
		SD5->D5_LOCAL	:= a_Dados[ nI ][ 4 ]
		SD5->D5_DOC		:= a_Dados[ nI ][ 5 ]
		SD5->D5_SERIE	:= a_Dados[ nI ][ 6 ]
		SD5->D5_DATA	:= CTOD( "31/08/2017" )
		SD5->D5_ORIGLAN	:= "503"
		SD5->D5_NUMSEQ	:= ProxNum()
		SD5->D5_CLIFOR	:= "000020"
		SD5->D5_LOJA	:= "01"
		SD5->D5_QUANT	:= a_Dados[ nI ][ 2 ]
		SD5->D5_LOTECTL	:= a_Dados[ nI ][ 3 ]
		SD5->D5_DTVALID	:= SB8->B8_DTVALID
		MsUnlock()

	Next nI

Return()
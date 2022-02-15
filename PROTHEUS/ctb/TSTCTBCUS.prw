User Function TSTCTBCUS()

	Local c_User		:= RetCodUsr()				//Código do Usuário logado
	Local c_NUser		:= UsrFullName( c_User )	//Nome do usuário logado
	Local c_Arquivo 	:= "SC7"					//Alias em execução
	Local n_Total   	:= 0						//Totaliza contabilização
	Local l_Digita  	:= .T.						//Abre tela de contabilização
	Local l_Aglutina	:= .F.						//Aglutina ou não o lançamento
	Local c_Lote		:= "8840"					//Lote Contábil
	Local c_Padrao		:= "001" 					//Lançamento padrão customizado

	//Função responsável por montar o cabeçalho da tela de contabilização
	Local n_HdlPrv	:= HeadProva( c_Lote, "MATA097", Alltrim(c_NUser), @c_Arquivo )

	DbSelectArea("SC7")
	ProcRegua( RecCount() )

	SC7->(DbGoTop())
	Do While SC7->(!Eof())

		IncProc("Gerando Lançamento Contábil...")

		//Função responsável por detalhar (itens) os lançamentos contábeis
		n_Total += DetProva( n_HdlPrv, c_Padrao, "MATA097", c_Lote )

		SC7->(DbSkip())

	EndDo

	//Finaliza os totais da contabilização
	RodaProva( n_HdlPrv, n_Total )

	//Função responsável por gravar a contabilização
	cA100Incl( c_Arquivo, n_HdlPrv, 3, c_Lote, l_Digita, l_Aglutina )

Return
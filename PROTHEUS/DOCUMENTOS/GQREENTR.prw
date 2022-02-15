#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
/{Protheus.doc} GQREENTR
Ponto de entrada na finalizacao do documento de entrada

@author Francisco
@since 08/11/2016
@version undefined

@type function

*/

User Function GQREENTR()

Local a_SF1Area	:= SF1->( GetArea() )
Local a_SD1Area	:= SD1->( GetArea() )
Local a_CTTArea	:= CTT->( GetArea() )
Local a_SB1Area	:= SB1->( GetArea() )
Local a_SA2Area	:= SA2->( GetArea() )

Local a_AreaSE2	:= SE2->(GETAREA())
Local c_Fornece	:= SF1->F1_FORNECE
Local c_Loja	:= SF1->F1_LOJA
Local a_ParcTX	:= {}
//Local l_Flag	:= .T.
Local n_Opca	:= 0
Local n_TpNF	:= SF1->F1_TIPO
//inicio - adicionando ajuste conforme solicitado no e-mail de 30/06/2020 - inibir solicitacao do CC aposs confirmacao da nota.
Local l_InfoCC	:= SuperGetMV("FS_INFCCD",.F.,.F.) //o padrao nao informar. caso queira que o campo seja ativado, devera cadastrar o parametro na base com o conteudo .T.
//final   - adicionando ajuste conforme solicitado no e-mail de 30/06/2020 - inibir solicitacao do CC apos confirmacao da nota.
//--//
//inicio - adicionando para atender a necessidade detectada no projeto de melhoria protheus para preenchimento de observacoes a serem impressas na planilha de controle fluig - inicio
Local l_InfoProt:= SuperGetMV("FS_INFPRT",.F.,.T.) .And. (SF1->(FieldPos("F1_FSOBS")) > 0) //o padrao e informar. caso nao queira informar a observacao do protolo, devera cadastrar o parametro na base com o conteudo .F.
//final - adicionando para atender a necessidade detectada no projeto de melhoria protheus para preenchimento de observacoes a serem impressas na planilha de controle fluig - fim
//--//
Local a_Chave := {}
//--//
Private c_Hist		:= Space(TAMSX3("E2_HIST")[1])
Private c_CCD		:= Space(TAMSX3("E2_CC")[1])
Private c_Doc		:= SF1->F1_DOC
Private c_Serie		:= SF1->F1_SERIE
Private c_Prefixo	:= SF1->F1_PREFIXO
Private c_TxtObs	:= " "

U_FCOMA001()
U_FFINA004()

If n_TpNF $ "D;B" //Ponto de entrada nao se aplica para Beneficiamento e Devolucao de Venda
	RestArea(a_AreaSE2)
	Return()
Endif

//inicio - adicionando ajuste conforme solicitado no e-mail de 30/06/2020 - inibir solicitação do CC após confirmação da nota.
If !(l_InfoCC)	
	c_CCD	:= f_BuscaCC(c_Prefixo,c_Doc, c_Fornece, c_Loja)
Endif
//final   - adicionando ajuste conforme solicitado no e-mail de 30/06/2020 - inibir solicitação do CC após confirmação da nota.

SetPrvt("oFont1","oDlg1","oSay1","oSay2","oGet1","oGet2","oSBtn1","oSBtn2,o_Say3,o_tmgObs")

oFont1     := TFont():New( "Trebuchet MS",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )

//inicio - adicionando para atender a necessidade detectada no projeto de melhoria protheus para preenchimento de observacoes a serem impressas na planilha de controle fluig - inicio
If l_InfoProt
	oDlg1      := MSDialog():New( 091,232,481,830,"Informacoes complementares",,,.F.,,,,,,.T.,,oFont1,.T. )
Else
	oDlg1      := MSDialog():New( 091,232,181,830,"Informacoes complementares para o t�tulo",,,.F.,,,,,,.T.,,oFont1,.T. )
Endif
//final - adicionando para atender a necessidade detectada no projeto de melhoria protheus para preenchimento de observacoes a serem impressas na planilha de controle fluig - fim

oSay1      := TSay():New( 008,004,{||"Historico:"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet1      := TGet():New( 007,048,{|u| iif(pcount()>0,c_Hist:=u,c_Hist)},oDlg1,248,010,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

//inicio - adicionando ajuste conforme solicitado no e-mail de 30/06/2020 - inibir solicitação do CC após confirmação da nota.
If ((l_InfoCC) .Or. Empty(c_CCD))
	oSay2      := TSay():New( 024,004,{||"Centro Custo:"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
	oGet2      := TGet():New( 023,048,{|u| iif(pcount()>0,c_CCD:=u,c_CCD)},oDlg1,044,010,'',{|| ExistCpo("CTT",c_CCD,1) },CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"CTT","",,)
Endif
//final   - adicionando ajuste conforme solicitado no e-mail de 30/06/2020 - inibir solicitação do CC após confirmação da nota.

//inicio - adicionando para atender a necessidade detectada no projeto de melhoria protheus para preenchimento de observacoes a serem impressas na planilha de controle fluig - inicio
If l_InfoProt
	o_Say3   := TSay():New( 044,004,{||"Observa��es:"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
	o_tmgObs := tMultiget():new( 043, 048, {| u | if( pCount() > 0, c_TxtObs := u, c_TxtObs ) }, oDlg1, 200, 100, , , , , , .T. )
Endif
//final - adicionando para atender a necessidade detectada no projeto de melhoria protheus para preenchimento de observacoes a serem impressas na planilha de controle fluig - fim

//inicio - adicionando para atender a necessidade detectada no projeto de melhoria protheus para preenchimento de observacoes a serem impressas na planilha de controle fluig - inicio
If l_InfoProt
	oSBtn2     := SButton():New( 153,244,2,{|| n_Opca:=0,oDlg1:End()},oDlg1,,"", )
	oSBtn1     := SButton():New( 153,272,1,{|| n_Opca:=1,oDlg1:End() },oDlg1,,"", )
Else
//final - adicionando para atender a necessidade detectada no projeto de melhoria protheus para preenchimento de observacoes a serem impressas na planilha de controle fluig - fim
	oSBtn2     := SButton():New( 033,244,2,{|| n_Opca:=0,oDlg1:End()},oDlg1,,"", )
	oSBtn1     := SButton():New( 033,272,1,{|| n_Opca:=1,oDlg1:End() },oDlg1,,"", )
Endif

oDlg1:Activate(,,,.T.)

If n_Opca == 1

	//inicio - adicionando para atender a necessidade detectada no projeto de melhoria protheus para preenchimento de observacoes a serem impressas na planilha de controle fluig - inicio
	If l_InfoProt
		If SF1->(RecLock("SF1",.F.))
			SF1->F1_FSOBS	:=	c_TxtObs
			SF1->(msUnlock())
		Endif
	Endif
	//final - adicionando para atender a necessidade detectada no projeto de melhoria protheus para preenchimento de observacoes a serem impressas na planilha de controle fluig - final

	DbSelectArea("SE2")
	SE2->( DbSetOrder(6))
	SE2->( DbSeek(xFilial("SE2")+c_Fornece+c_Loja+c_Prefixo+c_Doc))
	
	While SE2->( !Eof()) .And. SE2->E2_FILIAL+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM==XFILIAL("SE2")+c_Fornece+c_Loja+c_Prefixo+c_Doc
		
		//Nao alterar esta ordem
		AADD(a_ParcTX,SE2->E2_PARCIR)
		AADD(a_ParcTX,SE2->E2_PARCCOF)
		AADD(a_ParcTX,SE2->E2_PARCPIS)
		AADD(a_ParcTX,SE2->E2_PARCSLL)
		AADD(a_ParcTX,SE2->E2_PARCINS)
		AADD(a_ParcTX,SE2->E2_PARCISS)
		
		f_VerificaImposto(a_ParcTX)
		
		RecLock("SE2",.F.)
			SE2->E2_CC	 := c_CCD
			SE2->E2_HIST := c_Hist
		MsUnLock()
		
		SE2->( DbSkip() )
	Enddo
Endif


//Adiionando anexos de documento de entrada na classifica�ao
//para o caso em que os mesmos s�o adicionados via pr�-nota
//os mesmos ser�o adicionados ao contas a pagar
//inicio
If FindFunction("U_FCOMA102")
	aAdd(a_Chave,	c_Doc + c_Serie + c_Fornece + c_Loja )
	aAdd(a_Chave,   "SF1"                   )
	aAdd(a_Chave,   xFilial(a_Chave[2])     )
	aAdd(a_Chave,   "SE2"                   )
	U_FCOMA102(a_Chave)
Endif
//final

RestArea( a_AreaSE2 )
RestArea( a_SF1Area )
RestArea( a_SD1Area )
RestArea( a_CTTArea )
RestArea( a_SB1Area )
RestArea( a_SA2Area )                                         

Return()

/*/{Protheus.doc} f_VerificaImposto
Funcao que verifica os impostos do tiulo principal. 
@type function
@version 
@author TOTVS bahia
@since 12/08/2020
@param a_Impostos, array, param_description
@return return_type, return_description
/*/
Static Function f_VerificaImposto(a_Impostos)

Local a_AreaSE2	:= SE2->(GETAREA())
Local c_Uniao	:= GETMV("MV_UNIAO")+"  00"
Local c_Munic	:= GETMV("MV_MUNIC")+"  00"
Local c_ForIns	:= GETMV("MV_FORINSS")+"  00"
Local nX        := 0

For nX:=1 to Len(a_Impostos)

	//Fornecedor Uniao
	If nX >= 1 .And. nX <= 4
		DbSelectArea("SE2")
		SE2->( DbSetOrder(6))
		SE2->( DbSeek(xFilial("SE2")+c_Uniao+c_Prefixo+c_Doc+a_Impostos[nX]+"TX "))
		
		If SE2->( Found() )
			RecLock("SE2",.F.)
				SE2->E2_CC 		:= c_CCD
				//SE2->E2_HIST	:= c_Hist
			MsUnLock()
		Endif

	//Fornecedor INSS
	ElseIf nX == 5
		DbSelectArea("SE2")
		SE2->( DbSetOrder(6))
		SE2->( DbSeek(xFilial("SE2")+c_ForIns+c_Prefixo+c_Doc+a_Impostos[nX]+"INS"))

		If SE2->( Found() )
			RecLock("SE2",.F.)
				SE2->E2_CC 		:= c_CCD
				//SE2->E2_HIST	:= c_Hist
			MsUnLock()
		Endif
	
	//Fornecedor Municipio
	Else
		DbSelectArea("SE2")
		SE2->( DbSetOrder(6))
		SE2->( DbSeek(xFilial("SE2")+c_Munic+c_Prefixo+c_Doc+a_Impostos[nX]+"ISS"))

		If SE2->( Found() )
			RecLock("SE2",.F.)
				SE2->E2_CC 		:= c_CCD
				//SE2->E2_HIST	:= c_Hist
			MsUnLock()
		Endif
	Endif
Next

RestArea(a_AreaSE2)

Return()

/*/{Protheus.doc} f_BuscaCC
Busca centro de custo informado no item da nota fiscal.
@type function
@version 
@author totvs
@since 30/06/2020
@param c_Serie, character, param_description
@param c_Doc, character, param_description
@param c_Fornece, character, param_description
@param c_Loja, character, param_description
@return return_type, return_description
/*/
Static Function f_BuscaCC(c_Serie,c_Doc, c_Fornece, c_Loja)
Local a_SD1Alias:=	SD1->(GetArea())
Local c_Custo	:=	""

SD1->(dbSetOrder(1))
If SD1->(dbSeek(xFilial("SD1") + c_Doc + c_Serie + c_Fornece + c_Loja, .T.) )

	While SD1->(!Eof()) .And. SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA == xFilial("SD1") + c_Doc + c_Serie + c_Fornece + c_Loja
		c_Custo	:=	SD1->D1_CC
		If !Empty(c_Custo)
			Exit
		Endif
		SD1->(dbSkip())
	Enddo
Endif
SD1->(RestArea(a_SD1Alias))
Return(c_Custo)


//-- teste unitario --//
user function TGQ_ENTR(c_Empresa, c_Filial)
Local a_AreaT1	:=	{}
Default c_Empresa :=  '01'
Default c_Filial  :=  '07'

If !Empty(c_Empresa) .And. !Empty(c_Filial)
    RPCSETTYPE(3)
    RPCSETENV(c_Empresa ,c_Filial)
Endif

If cFilAnt <> Nil
	a_AreaT1	:=	SF1->(GetArea())
	c_Chave := SF1->(xFilial("SF1"))+PADR("003956",9)+"UNI"+"686101"
	SF1->(dbSetOrder(1))
	If SF1->(dbSeek(c_Chave,.T.))
    	U_GQREENTR()
	Endif
	SF1->(RestArea(a_AreaT1))
Endif

Return 

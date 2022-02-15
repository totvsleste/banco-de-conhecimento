#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWBROWSE.CH"
#INCLUDE "DBTREE.CH"
#INCLUDE "FWEVENTVIEWCONSTS.CH"
#INCLUDE "CRMA010.CH"
#INCLUDE "SHELL.CH"

Static __lEdit	:= .F.
Static cProven	:= ""
//------------------------------------------------------------------------------
/*/{Protheus.doc} CRMA010B(cCodConsulta) 

Interface das consultas da previsão de vendas

@sample		CRMA010B(cCodConsulta)
@param		ExpC - Código da Consulta do broswer
@return		Nenhum

@author		Ronaldo Robes
@since		12/05/2015
@version	12.1.7
/*/
//------------------------------------------------------------------------------
Function CRMA010B(cCodConsulta, lEdit )
	
Local oBrowse := FwMBrowse():New()
Local oDSChart:= CRM010Graf(cCodConsulta)
Local oModel := Nil

Default cCodConsulta := AZF->AZF_CODIGO
Default lEdit			:= .F.

__lEdit := lEdit

If IsInCallStack ("CRMA290") // área de trabalho
	aRotina := Nil 
EndIf
oBrowse:SetAlias('AZF')
oBrowse:SetDescription(STR0034) //"Painel de Vendas"
oBrowse:SetMenuDef('CRMA010B')
oBrowse:SetAttach( .T. )
oBrowse:SetOpenChart( .T. )
oBrowse:SetViewsDefault( oDSChart:aViews )
oBrowse:SetChartsDefault( oDSChart:aCharts )
oBrowse:SetFilterDefault("AZF_CODIGO == '"+cCodConsulta+"' " )
oBrowse:AddFilter(STR0045 , "(AZF_STAAD1 == '1' .OR. AZF_STAAD1 == '9')" ) //"Abertas ou Ganhas"
oBrowse:DisableReport()

oBrowse:Activate()
	
Return Nil

//------------------------------------------------------------------------------
/*/{Protheus.doc} MenuDef

Monta menu da interface da rotina

@sample		MenuDef
@param		Nenhum
@return		Nenhum

@author		Ronaldo Robes
@since		12/05/2015
@version	12.1.7
/*/
//------------------------------------------------------------------------------
Static Function MENUDEF()
	
Local aRotina := {}


If __lEdit	
	
	ADD OPTION aRotina TITLE STR0069 ACTION "CRM010BALT()" OPERATION 4 ACCESS 0 //"Alterar" 

EndIf

ADD OPTION aRotina TITLE STR0046 ACTION "CRM010BVIEW()" OPERATION 4 ACCESS 0 //"Exportar" 



Return aRotina

//------------------------------------------------------------------------------
/*/{Protheus.doc} CRM010Graf()

Distribui dados no gráfico

@sample		CRM010Graf()
@param		ExpC - cCodConsulta
@return		ExpO - Objeto para formatação dos graficos

@author		Ronaldo Robes
@since		12/05/2015
@version	12.1.7
/*/
//------------------------------------------------------------------------------
Static Function CRM010GRAF(cCodConsulta)
	
Local oTableAtt  := FWTableAtt():New()
Local oPorStatus := Nil // Colunas: Suspects por Status
Local oPorVend   := Nil // Colunas: Suspects por Vendedor
Local oDSChart   := Nil
Local oDSMyAbert := Nil
Local oDMSUserAt := Nil
Local lCRA010B   := ExistBlock("CRM10VIEW")
	
oTableAtt:SetAlias("AZF")
	
// Funil: Funil de Vendas
oDSChart := FWDSChart():New()
oDSChart:SetName(STR0047)   //"Funil de Vendas"
oDSChart:SetTitle(STR0047)  //"Funil de Vendas"
oDSChart:SetID("DSFUNIL")
oDSChart:SetType("FUNNELCHART")
oDSChart:SetSeries({{"AZF" ,"AZF_PERC","SUM"}})
oDSChart:SetCategory({{"AC2" , "AC2_DESCRI"}})
oDSChart:SetPublic(.T.)
oDSChart:SetLegend(CONTROL_ALIGN_BOTTOM) //Inferior
oDSChart:SetTitleAlign(CONTROL_ALIGN_CENTER)
oTableAtt:AddChart(oDSChart)
	
If lCRA010B						
	oDMSUserAt := ExecBlock("CRM10VIEW",.F.,.F.,{oDMSUserAt})
	oTableAtt:AddView(oDMSUserAt)
Else
	oDSMyAbert := FWDSView():New()
	oDSMyAbert:SetName(STR0045) // "Abertas ou Ganhas"
	oDSMyAbert:SetID("DSMyAbert")
	oDSMyAbert:SetOrder(1) // AD1_FILIAL+AD1_NROPOR
	oDSMyAbert:SetCollumns({"AZF_NROPOR","AZF_DTFIM","AZF_STAAD1","AZF_FEELIN","AZF_FCS" })
	oDSMyAbert:SetPublic(.T.)
	oDSMyAbert:AddFilter(STR0045, " (AZF_STAAD1 == '1' .OR. AZF_STAAD1 == '9') .AND. (AZF_FCS == '000003' .OR.  AZF_FCS == '000004' )") // "Abertas ou Ganhas"
	oTableAtt:AddView(oDSMyAbert)
EndIf
	
Return(oTableAtt)

//------------------------------------------------------------------------------
/*/{Protheus.doc} CRM010BVIEW
Processa informações manipuladas em tela

@sample		CRM010BVIEW()
@param		Nenhum
@return		Nenhum

@author		SI2901 - Cleyton F.Alves 
@since		11/03/2015
@version	12.1.7
/*/
//------------------------------------------------------------------------------
Function CRM010BVIEW()
	Processa({||  CRM10BView() },STR0108,"",.T.) //"Exportando os dados para Microsoft Excel."
Return Nil

//------------------------------------------------------------------------------
/*/{Protheus.doc} CRM010BVIEW
Processa informações manipuladas em tela

@sample		CRM010BVIEW()
@param		Nenhum
@return		Nenhum

@author		SI2901 - Cleyton F.Alves
@since		11/03/2015
@version	12.1.7
/*/
//------------------------------------------------------------------------------
Static Function CRM10BView()

Local aAreaAZF	:= AZF->( GetArea() )
Local aResult		:= {}
Local aCabecGer	:= {}
Local aCabHier	:= {}
Local aHierXCargo	:= {}
Local aAZFStruct	:= {}
Local aCacheHier	:= {}
Local nPosAgr		:= 0
Local nX			:= 0
Local nY			:= 0
Local nPosCargo	:= 0
Local cCodResult	:= AZF->AZF_CODIGO
Local cUnidade	:= ""
Local cCodHier	:= ""
Local cCodNiv		:= ""
Local cCargo		:= ""
Local cNomVen		:= ""
Local cFieldChav	:= ""
Local cTitle		:= ""
Local cDscEnt		:= ""
Local cUserName	:= ""
Local cCodVend	:= ""
Local lSeekAZS	:= .F.
Local cUserSup	:= ""
Local nRegProc	:= 0
Local nCountAZF	:= 0
Local nLenAZFStru	:= 0
Local nLenHXCargo	:= 0
Local cQuery		:= ""
Local cFilialAZF	:= xFilial("AZF")
Local cFilialAZE	:= xFilial("AZE")
Local cFilialAZC	:= xFilial("AZC")	
Local cFieldCombo	:= "" // Campos com combo box que no Relatório sai o valor do Combo e não do campo 
cFieldChav := "AZF_FILIAL, AZF_NIVPAI, AZF_CODHIE, AZF_CODIGO, AZF_DATA, AZF_HORA, AZF_USER, AZF_NOMUSU,"

AZF->( DbSetOrder(1) )
AZS->( DBSetOrder(4) )
AZD->( DBSetOrder(1) )
ADK->( DBSetOrder(1) )
SX3->( DBSetOrder(1) )

If SX3->( DbSeek( "AZF" ) )
	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "AZF"
		aAdd( aAZFStruct, {	AllTrim( SX3->X3_CAMPO )		,;
		AllTrim( SX3->X3_CONTEXT )	,;
		AllTrim( SX3->X3_TIPO )		,;
		AllTrim( SX3->X3_PICTURE )	,;
		AllTrim( X3Titulo() )	 } )
		SX3->( DBSkip() )
	EndDo
EndIf

nLenAZFStru := Len( aAZFStruct )


If AZF->(DbSeek(cFilialAZF+cCodResult))
	AZF->( DBEval( {|| nCountAZF++ },, {|| AZF->AZF_FILIAL == cFilialAZF .And. AZF->AZF_CODIGO == cCodResult } ) )
EndIf
	
If AZF->(DbSeek(cFilialAZF+cCodResult))
	
	ProcRegua( nCountAZF )
	
	cCodHier := AZF->AZF_CODHIE
	
	AZD->(DbSeek(cFilialAZC+AZF->AZF_CODHIE))
	
	While AZD->(!Eof()) .And. AZD->AZD_FILIAL == cFilialAZC .And. AZD->AZD_CODIGO == AZF->AZF_CODHIE
		aAdd(aCabHier,{AZD->AZD_CODIGO,AZD->AZD_NIVEL,AZD->AZD_DSCNIV})
		aAdd( aCabecGer, { AZD->AZD_DSCNIV, "C", "@!", "AZD_DSCNIV" } )
		AZD->( DBSkip() )
	EndDo
	
	AZE->(DbSeek(cFilialAZE+AZF->AZF_CODHIE))
	
	While AZE->(!Eof()) .And. AZE->AZE_FILIAL == cFilialAZE .And. AZE->AZE_CODIGO == AZF->AZF_CODHIE
		If !Empty( AZE->AZE_CODCAR ) .And. !Empty(  AZE->AZE_NIVEL )
			aAdd( aHierXCargo, {AZE->AZE_CODCAR,AZE->AZE_NIVEL} )
		EndIf
		AZE->( DBSkip() )
	EndDo

	nLenHXCargo  := Len( aHierXCargo )
	
	While AZF->( !Eof() ) .And. AZF->AZF_FILIAL == cFilialAZF .And. AZF->AZF_CODIGO == cCodResult
		
		nRegProc++
				
		nPosAgr := aScan(aResult,{|x| x[1] == AZF->AZF_CODAGR .And. x[2] == AZF->AZF_CODNIV })
		
		cFieldCombo := "AZF_FEELIN"
		
		If nPosAgr == 0
			aAdd(aResult,{ AZF->AZF_CODAGR	,;
			AZF->AZF_CODNIV	,;
			AZF->AZF_NIVPAI	,;
			{} })
			nPosAgr := Len(aResult)
		EndIf
		
		aAdd(aResult[nPosAgr,4],{})
		
		nY := Len(aResult[nPosAgr,4])
		
		For nX := 1 To Len(aCabHier)
			aAdd(aResult[nPosAgr,4,nY],"")
		Next
		
		For nX := 1 To nLenAZFStru
			
			cTitle := ""
			
			If !( aAZFStruct[nX][1] $ cFieldChav )
				
				If ( Len( aResult ) == 1 ) .And. ( nY == 1 )
					aAdd(aCabecGer,{ aAZFStruct[nX][5] ,aAZFStruct[nX][3], aAZFStruct[nX][4], aAZFStruct[nX][1] })
				EndIf
				
				If aAZFStruct[nX][2] <> "V"
					
					IF aAZFStruct[nX][1] $ cFieldCombo
						aAdd( aResult[nPosAgr,4,nY], CRMA010Combo( aAZFStruct[nX][1], AZF->( FieldGet( FieldPos( aAZFStruct[nX][1] ) ) ) ) )
					Else
						aAdd( aResult[nPosAgr,4,nY], AZF->( FieldGet( FieldPos( aAZFStruct[nX][1] ) ) ) )
					EndIf
					
				Else
					aAdd( aResult[nPosAgr,4,nY], CriaVar(aAZFStruct[nX][1],.T.) )
				EndIf
				
			EndIf
			
		Next nX
		
		If AZS->( MSSeek( xFilial("AZS") + AZF->AZF_VEND  ) )
			
			If AZS->AZS_VEND <> cCodVend
				aCacheHier	:= {}
				cCargo  	:= CRMXRtrnPos( AZS->AZS_CODUSR )
			EndIf
			
			cUnidade	:= ""
			cUserName	:= ""
			cCodVend 	:= AZS->AZS_VEND
			cDscEnt  	:= CRM010SEGM("AZF_ENTDES")
		
			For nX := 1 To nLenHXCargo
				
				nPosCargo := aScan(aCabHier,{|x| x[1]+x[2] == AZF->AZF_CODHIE+aHierXCargo[nX][2]})
				
				If nPosCargo > 0
					
					If Empty( cUserName ) .And. aHierXCargo[nX][1] == cCargo
						cUserName := AllTrim( CRMXLoadUser( AZS->AZS_CODUSR  )[4] )
					Else
						
						nPos := aScan( aCacheHier, {|x| x[1] == AZS->AZS_CODUSR+AZS->AZS_SEQUEN+AZS->AZS_PAPEL+AZF->AZF_CODHIE+aHierXCargo[nX][1] } )
						
						If nPos == 0
							aUserSup := CRMXREstrNeg( AZS->AZS_CODUSR , aHierXCargo[nX][1], "S", AZS->AZS_SEQUEN + AZS->AZS_PAPEL )
							If !Empty( aUserSup )
								cUserName	:= AllTrim( CRMXLoadUser( aUserSup[1][1] )[4] )
								aAdd( aCacheHier, {AZS->AZS_CODUSR+AZS->AZS_SEQUEN+AZS->AZS_PAPEL+AZF->AZF_CODHIE+aHierXCargo[nX][1],cUserName})
							EndIf
						Else
							cUserName := aCacheHier[nPos][2]
						EndIf
						
	
					EndIf
				
					If Empty( aResult[nPosAgr,4,nY,nPosCargo] )
						aResult[nPosAgr,4,nY,nPosCargo] := cUserName
					EndIf
						
					
				EndIf
				
			Next nX

		EndIf
		
		IncProc( STR0109 + AllTrim( Str( nRegProc ) ) + STR0110 + AllTrim( Str( nCountAZF ) ) ) // "Registros processados: "#" de: "
		
		AZF->(DBSkip())
		
	EndDo
	
EndIf

CRM010BEXC(aCabecGer,aResult,.T.,.T.)

RestArea( aAreaAZF )

//-----------------------------------------------------------
// Limpa a referência do array na memória
//-----------------------------------------------------------
aAreaAZF		:= ASize( aAreaAZF	, 0 )
aResult		:= ASize( aResult		, 0 )
aCabecGer 		:= ASize( aCabecGer	, 0 )
aCabHier 		:= ASize( aCabHier	, 0 )
aHierXCargo 	:= ASize( aHierXCargo, 0 )
aAZFStruct		:= ASize( aCabHier	, 0 )
aCacheHier		:= ASize( aCacheHier	, 0 )

aArea			:= Nil
aResult		:= Nil
aCabecGer		:= Nil
aCabHier		:= Nil
aHierXCargo	:= Nil
aAZFStruct		:= Nil
aCacheHier		:= Nil

Return Nil

//------------------------------------------------------------------------------
/*/{Protheus.doc} CRM010BEXC
Exporta dados para o excel

@sample		CRM010BEXC(aHeader,aPrint,lTotalize,lPicture)
@param		ExpA - Composição do cabeçalho 
			ExpA - Composição do corpo do relatório
			ExpL - Informa se totaliza os dados numériocs
			ExpL - Define se informa a picture nos campos
@return		ExpC - Arquivo HTM para importarção do excel

@author		SI2901 - Cleyton F.Alves
@since		11/03/2015
@version	12
/*/
//------------------------------------------------------------------------------
Static Function CRM010BEXC(aHeader,aPrint,lTotalize,lPicture)
	Local oExcel		:= FWMSExcel():New()
	Local oMsExcel		:= Nil
	Local aCols			:= {}
	Local aCells		:= {}
	Local cWorkSheet	:= ""
	Local cTable		:= cWorkSheet
	Local cType			:= ""
	Local cColumn		:= ""
	Local cPicture		:= ""
	Local cFile			:= ""
	Local cTemp			:= GetTempPath(.T.)
	Local nAgrups		:= 0
	Local nFormat		:= 0
	Local nAlign		:= 0
	Local nCol			:= 0
	Local nColunas		:= 0
	Local nLin			:= 0
	Local nLinhas		:= 0
	Local lTotal		:= .F.
	Local uCell			:= Nil
	
	Default aHeader		:= {}
	Default aPrint		:= {}
	Default lTotalize	:= .T.
	Default lPicture	:= .F.

	cWorkSheet	:= STR0033 //"Previsão de Vendas" 
	cTable		:= STR0033 //"Previsão de Vendas"
	cFile 		:= "FORECAST" + "_" + DToS( Date() ) + StrTran( Time(), ":", "" ) + ".xml"
		
	oExcel:AddworkSheet(cWorkSheet)
	oExcel:AddTable(cWorkSheet,cTable)

	nColunas := Len(aHeader)
	
	For nCol := 1 To nColunas
		cType   := aHeader[nCol,2]
		nAlign  := If(cType=="C",1,If(cType=="N",3,2))
		nFormat := If(cType=="D",1,If(cType=="N",2,1))
		cColumn := aHeader[nCol,1]
		lTotal  := ( lTotalize .and. cType == "N" )
		oExcel:AddColumn(@cWorkSheet, @cTable, @cColumn,@nAlign,@nFormat,@lTotal)
	Next nCol
	
	aCells := Array(nColunas)
	
	For nAgrups:=1 To Len(aPrint)	
		aCols	:= aPrint[nAgrups,4]
		
		nLinhas := Len(aCols)
		For nLin := 1 To nLinhas
			For nCol := 1 To len(aCols[nLinhas])
				uCell := Iif(ValType(aCols[nLin,nCol])=="D",DTOC(aCols[nLin,nCol]),aCols[nLin,nCol])
				If lPicture
					cPicture := aHeader[nCol,3]
					If !Empty(cPicture).AND. ! ValType(aCols[nLin,nCol])=="N"
						uCell := Transform(uCell,cPicture)
					EndIf
				EndIf
				aCells[nCol] := uCell
				
			Next nCol
			oExcel:AddRow(@cWorkSheet,@cTable,aClone(aCells))
		Next nLin
	Next nAgrups

	//-------------------------------------------------------------------
	// Gera a planilha no servidor.
	//-------------------------------------------------------------------
	oExcel:Activate()
	oExcel:GetXMLFile( cFile )

	//-------------------------------------------------------------------
	// Copia a planilha para máquina local e executa.
	//-------------------------------------------------------------------
	If ( CpyS2T ( cFile, cTemp, .T. ) )
		ShellExecute( "OPEN", "EXCEL", cTemp + "\" + cFile, "", SW_SHOWMAXIMIZED )
	EndIf

	//-------------------------------------------------------------------
	// Apaga o arquivo do servidor.
	//-------------------------------------------------------------------
	If ( File( cFile ) )
		FErase( cFile )
	EndIf	
Return


//------------------------------------------------------------------------------
/*/{Protheus.doc} CRM010BALT
Altera informações de atualização na oportunidade de vendas 

@sample	CRM010BALT()

@author	SI2901 - Cleyton F.Alves
@since		11/03/2015
@version	12
/*/
//------------------------------------------------------------------------------
Function CRM010BALT()

Local aArea		:= GetArea()
Local oDlg      	:= Nil
Local oPanel	  	:= Nil
Local oSay			:= Nil
Local oPnlFol       := Nil
Local cChave        := ''
Local oProcesso      
Local oCombo
Local oStage
Local oGetDsSt
Local oValFech
Local oFechto
Local nAZFRecno 	:= AZF->(Recno())
Local cDesPr		:= ''
Local cStage		:= ''
Local cDesSt		:= ''
Local dFechto		:= CtoD('//')
Local nFechto		:= 0
Local nFeelin       := 1
Local cFeelin		:= ''
Local cOpor         := ''
Local cRevisa       := ''
Local cCodConsulta  := ''
Local aFeelin		:= {}
Local nPerc			:= 0
Local cTitleRc		:= ""
Local lCRM010Alt  	:= Existblock( "CRMA010ALT" )

If lCRM010Alt
	ExecBlock("CRMA010ALT")
Else
	AZF->( dbGoto( nAZFRecno ) ) 
	
	cOpor   	:= AZF->AZF_NROPOR
	cRevisa 	:= AZF->AZF_REVISA  
	cCodConsulta:= AZF->AZF_CODIGO
	nPerc 		:= AZF->AZF_PERC
	
	
	AD1->(DbSetOrder(1))	// AD1_FILIAL+AD1_NROPOR+AD1_REVISA  
	AD1->(DbSeek(xFilial("AD1")+ cOpor + cRevisa)) 
	
	cProven		:= AD1->AD1_PROVEN
	cDesPr		:= Alltrim(POSICIONE("AC1",1,FwxFilial("AC1")+cStage,"AC1_DESCRI"))  
	cStage		:= AD1->AD1_STAGE
	cDesSt		:= Alltrim(POSICIONE("AC2",1,FwxFilial("AC2")+cProven+cStage,"AC2_DESCRI"))
	dFechto		:= AD1->AD1_DTPFIM
	nFechto		:= AD1->AD1_RCINIC
	aFeelin		:= x3CboxToArray("AD1_FEELIN")[1]
	aadd(aFeelin,'')
	
	cFeelin		:= CRM10GetFeel(AD1->AD1_FEELIN,aFeelin)
	nFeelin		:= Val( cFeelin )
	
	If !AD1->AD1_STATUS $ "9|2"  //Só permite alterar oportunidades que não foram fechadas
	
		DbSelectArea( "SX3" )
		DbSetOrder( 2 )
		If DbSeek( "AD1_RCINIC" )
			cTitleRc := Alltrim( X3DESCRIC() )
		EndIf   
	
		oDlg := FWDialogModal():New()
			oDlg:SetBackground( .F. )  
			oDlg:SetTitle( STR0069 + '-' + STR0070 )	// "Alterar - Oportunidade de Vendas"
			oDlg:SetEscClose( .T. )
			oDlg:SetSize(200,200) 
			oDlg:CreateDialog()
			oDlg:EnableFormBar( .T. )
			oDlg:CreateFormBar()
			
			oPnlFol := oDlg:GetPanelMain()
		                               
			@ 05, 15 SAY STR0071 SIZE 70, 09  OF oPnlFol   PIXEL //"Processo de Venda "
			@ 15, 15 MSGET oProcesso VAR cProven;
					 WHEN .F. SIZE 50, 10 VALID .T. OF oPnlFol PIXEL 
			
			@ 05, 80 SAY STR0055 SIZE 40, 09  OF oPnlFol   PIXEL // "Descrição "
			@ 15, 80 MSGET Alltrim(POSICIONE("AC1",1,FwxFilial("AC1")+cStage,"AC1_DESCRI"))  VAR cDesPr WHEN .F. SIZE 100, 10 VALID .T. OF oPnlFol PIXEL 
		
			@ 30, 15 SAY STR0072 SIZE 40, 09  OF oPnlFol   PIXEL // "Estágio "
			@ 40, 15 MSGET oStage VAR cStage;
					 F3 'AC2PRE';
			 		 WHEN .T.;
			  		 SIZE 50, 10;
			  		 PICTURE PesqPict('AD1','AD1_STAGE');
			  		 VALID CR010Posic(cProven,cStage,@oGetDsSt,@cDesSt)  OF oPnlFol PIXEL 
			
			@ 30, 80 SAY STR0055 SIZE 40, 09  OF oPnlFol   PIXEL //"Descricao "
			@ 40, 80 MSGET oGetDsSt VAR cDesSt WHEN .F. SIZE 100, 10 VALID .T. OF oPnlFol PIXEL 
			
			@ 60, 15 SAY STR0073 SIZE 90, 09  OF oPnlFol   PIXEL // "Data Prevista de Fechamento"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
			@ 70, 15 MSGET oFechto VAR dFechto WHEN .T. ;
					 SIZE 80, 10 VALID .T. OF oPnlFol PIXEL 
			
			@ 90 , 15 SAY cTitleRc SIZE 90, 09  OF oPnlFol   PIXEL // Titulo do X3
			@ 100, 15 MSGET oValFech VAR nFechto WHEN .T.;
					  PICTURE PesqPict('AD1','AD1_RCINIC');
			 		  SIZE 80, 10 VALID .T. OF oPnlFol PIXEL 
			
			@ 120, 15 SAY STR0075 SIZE 70, 09  OF oPnlFol   PIXEL // "Chance de Sucesso"
			@ 130, 15 MSCOMBOBOX oCombo VAR cFeelin ITEMS aFeelin SIZE 100,044 OF oPnlFol PIXEL  ON CHANGE nFeelin := oCombo:nAt
		
			oDlg:AddButton( STR0076,{|| CRM010AD1(cOpor,cRevisa,cStage,dFechto,nFechto,nFeelin,cCodConsulta, nPerc),oDlg:Deactivate() }, STR0076 , , .T., .F., .T., ) //Confirmar
			oDlg:AddButton( STR0077, {|| oDlg:Deactivate() }, STR0077	 , , .T., .F., .T., ) //Cancelar
			
		oDlg:Activate() 
	Else
		MsgStop( STR0096 ) //"Status da oportunidade não permite alteração"
	EndIf
	
	RestArea( aArea )
EndIf
Return

//-----------------------------------------------------------------------------
/*/{Protheus.doc} CRM10GetFeel 

Retorna a descrição da chance de sucesso

@sample		ModelDef()

@param 		cTPFee - tipo da chance de sucesso
@param 		aCombo - opções das chances de sucesso

@return		lRet - verifica se numero do estagio existe na tabela

@author		Aline Sebrian Damasceno
@since		16/10/2015
@version	12.1.7
/*/
//------------------------------------------------------------------------------
Static Function CRM10GetFeel(cTPFee,aCombo)
Local cFeelin  :=''
Local nFee     := 0

	nFee:=Ascan(aCombo, {|x| Substr(x,1,1) == cTPFee})
	If nFee>0
		cFeelin:=aCombo[nFee]
	EndIf

Return cFeelin


//-----------------------------------------------------------------------------
/*/{Protheus.doc} CR010Posic 

Posiciona na tabela AC2

@sample		ModelDef()

@param 		cProven - processo de venda
@param 		cStage  - estágio
@param 		oGet1   - objeto do estagio
@param 		cDescri - descrição do estagio

@return		lRet - verifica se numero do estagio existe na tabela

@author		Aline Sebrian Damasceno
@since		16/10/2015
@version	12.1.7
/*/
//------------------------------------------------------------------------------
Function CR010Posic(cProven,cStage,oGet1,cDescri) 
Local   lRet    := .T.
   
lRet    := ExistCpo("AC2",cProven+cStage) 
cDescri := iIf(lRet,Alltrim(POSICIONE("AC2",1,FwxFilial("AC2")+cProven+cStage,"AC2_DESCRI")),'') 

If lRet 
	oGet1:Refresh() 
EndIf 

Return lRet


//-----------------------------------------------------------------------------
/*/{Protheus.doc} CRM010AD1 

Atualiza a tabela de oportunidades

@sample		ModelDef()

@param 		cOpor - numero da oportunidade
@param 		cRevisa - revisao da oportunidade
@param 		cStage - numero do estágio
@param 		dFechto - data fechamento
@param 		NFeelin - item da chance de sucesso
@param 		cCodConsulta - codigo consulta previsao de vendas

@author		Aline Sebrian Damasceno
@since		16/10/2015
@version	12.1.7
/*/
//------------------------------------------------------------------------------
Function CRM010AD1( cOpor,cRevisa,cStage,dFechto,nFechto,nFeelin,cCodConsulta,nPerc )
Local aArea 	:= GetArea() 

Local oModel 	:= Nil
Local oMdlAD1 	:= Nil
Local cFeelin 	:= ''
Local nVerba	:= 0
Local lRet		:= .T.
Local cError	:= " "
Default cOpor  		 := ''
Default cRevisa 	 := ''
Default cStage  	 := ''
Default dFechto 	 := Ctod('')
Default nFechto 	 := 0
Default nFeelin 	 := 0
Default cCodConsulta := ''
Default nPerc		 := 0

cFeelin 	:= StrZero(nFeelin,1)

AD1->( DbSetOrder( 1 ) )
If	AD1->( DbSeek( xFilial( "AD1" ) + Alltrim(cOpor) + Alltrim(cRevisa)) )
	If !AD1->AD1_STATUS $ "2|9"
		If AD1->AD1_FEELIN == cFeelin .AND. AD1->AD1_DTPFIM == dFechto .AND. AD1->AD1_RCINIC == nFechto .AND. AD1->AD1_STAGE == cStage
			ApMsgAlert( STR0081 ) //"Nao houve alteração"	
			lRet := .F.
		Else
			oModel:= FWLoadModel("FATA300")
			oModel:SetOperation( 4 )
			oModel:Activate()
			
			oMdlAD1   := oModel:GetModel("AD1MASTER")
			oMdlAD1:SetValue("AD1_DTPFIM" ,dFechto)
			oMdlAD1:SetValue("AD1_RCINIC",nFechto)
			oMdlAD1:SetValue("AD1_STAGE" ,cStage)
			oMdlAD1:SetValue("AD1_FEELIN",cFeelin)
			
			nVerba := oMdlAD1:GetValue( "AD1_VERBA" ) 
			
			If oModel:VldData()
				oModel:CommitData()
				oModel:DeActivate()
			Else
				aError := oModel:GetErrorMessage()
				If !Empty ( aError )
					cError := aError[6]
				EndIf
				ApMsgAlert( STR0081 + ": " + cError ) //"Nao houve alteração: "	 "Erro" 
				lRet :=.F.
			EndIf
			
			oModel:deActivate()
			oModel:= oModel:Destroy()
								
			//-------------------------------------------------------
			// Atualiza Previsao de Vendas
			//-------------------------------------------------------
			AZF->(dbSetOrder(2))
			AZF->(dbSeek(xFilial("AZF")+cCodConsulta+cOpor+cRevisa))
			
			RecLock("AZF",.F.)
			AZF->AZF_FEELIN := cFeelin
			AZF->AZF_DTPFIM  := dFechto
			AZF->AZF_STAGE  := cStage
			AZF->AZF_PERC01  := ( nFechto * nPerc ) / 100
			AZF->AZF_PERC02  := ( nVerba * nPerc ) / 100
			If Alltrim(cRevisa) <> AD1->AD1_REVISA
				AZF->AZF_REVISA := SOMA1(Alltrim(cRevisa))
			EndIf
			AZF->(MsUnlock())
			
			AZF->(FKCommit())
			
		EndIf
		
	Else
		ApMsgAlert( STR0080 ) //"Não e possivel efeuar alteração com este status"		
		lRet := .F.
	EndIf
EndIf


RestArea( aArea )


Return( lRet )

//-----------------------------------------------------------------------------
/*/{Protheus.doc} CRM010F3 

Filtro de Consulta padrão(AC2PRE) para seleção do estágio do processo de venda

@Return	Lógico - Filtro de execução da consulta padrão

@author	Thamara Villa
@since		08/06/16
@version	V12 
/*/
//------------------------------------------------------------------------------
Function CRM010F3()

Return( AC2->AC2_PROVEN == cProven )

//-----------------------------------------------------------------------------
/*/{Protheus.doc} CRM010SEGM("AZF_DESSEG")

Inicializador padrão de campos

@Param cField, caracter, - campo a ser inicializado
@Return	cReturn, caracter - Código ou Nome do campo

@author	Renato da Cunha
@since		05/08/16
@version	V12 
/*/
//------------------------------------------------------------------------------
Function CRM010SEGM(cField)

Local cReturn	:= " "
Local cCode		:= " "
Local cDescript	:= " "
Local cSegment	:= ""

Default cField := " "

	If cField == "AZF_CODSEG"
	
		If ( !Empty( AZF->AZF_CODCLI ) .And. !Empty( AZF->AZF_LOJCLI ) )
			SA1->( DBSetOrder( 1 ) )
			If SA1->( MsSeek(xFilial( "SA1" ) + AZF->AZF_CODCLI + AZF->AZF_LOJCLI ) ) 
				cCode := SA1->A1_CODSEG
			EndIf
		Else
			SUS->( DBSetOrder( 1 ) )
			If SUS->( MsSeek(xFilial( "SUS" ) + AZF->AZF_PROSPE + AZF->AZF_LOJPRO ) ) 
				cCode := SUS->US_CODSEG
			EndIf
		EndIf
	
		If !Empty( cCode )
			cReturn := cCode
		EndIf 
	
	ElseIf cField == "AZF_DESSEG"
		
		If ( !Empty( AZF->AZF_CODCLI ) .And. !Empty( AZF->AZF_LOJCLI ) )
			
			SA1->( DBSetOrder( 1 ) )
			If SA1->( MsSeek(xFilial( "SA1" ) + AZF->AZF_CODCLI + AZF->AZF_LOJCLI ) ) 
				cCode := SA1->A1_CODSEG
			EndIf
			
			AOV->( DBSetOrder( 1 ) )
			If AOV->( MsSeek(xFilial( "AOV" ) + cCode ) ) 
				cDescript := AOV->AOV_DESSEG
			EndIf

		Else
			SUS->( DBSetOrder( 1 ) )
			If SUS->( MsSeek(xFilial( "SUS" ) + AZF->AZF_PROSPE + AZF->AZF_LOJPRO ) ) 
				cCode := SUS->US_CODSEG
			EndIf
			
			AOV->( DBSetOrder( 1 ) )
			If AOV->( MsSeek(xFilial( "AOV" ) + cCode ) ) 
				cDescript := AOV->AOV_DESSEG
			EndIf
		EndIf
	
		If !Empty( cDescript )
			cReturn := cDescript
		EndIf
		
	ElseIf cField == "AZF_ENTDES"
		
		If ( !Empty( AZF->AZF_CODCLI ) .And. !Empty( AZF->AZF_LOJCLI ) )
			SA1->( DBSetOrder( 1 ) )
			If SA1->( MsSeek(xFilial( "SA1" ) + AZF->AZF_CODCLI + AZF->AZF_LOJCLI ) ) 
				cDescript  := SA1->A1_NOME
			EndIf
		Else
			SUS->( DBSetOrder( 1 ) )
			If SUS->( MsSeek(xFilial( "SUS" ) + AZF->AZF_PROSPE + AZF->AZF_LOJPRO ) ) 
				cDescript  := SUS->US_NOME
			EndIf
		EndIf
	
		If !Empty( cDescript )
			cReturn := cDescript
		EndIf
		
	EndIf


Return( cReturn )

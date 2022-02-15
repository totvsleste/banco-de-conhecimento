#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWBROWSE.CH"
#INCLUDE "DBTREE.CH"
#INCLUDE "FWEVENTVIEWCONSTS.CH"
#INCLUDE "CRMA010.CH"
#INCLUDE "CRMDEF.CH"

Static _aNodes		:= {}
Static _aParams		:= {}
Static _cCodPVendas		:= ""

//------------------------------------------------------------------------------
/*/{Protheus.doc} CRMA010C 
Interface da montagem de nova consulta de previsão de vendas

@sample	CRMA010C()
@param		Nenhum
@return	Nenhum

@author	SI2901 - Cleyton F.Alves
@since		11/03/2015
@version	12
/*/
//------------------------------------------------------------------------------
Function CRMA010C( oView )
	
Local aUserPaper	:= CRMXGetPaper()
Local nRet			:= 0
Local oModel		:= Nil

Default oView := Nil

If !Empty( aUserPaper )
	
	AO5->( DbSetOrder(2) )
	
	If AO5->( DbSeek(xFilial("AO5") + "AZS" + aUserPaper[USER_PAPER_CODUSR] + aUserPaper[USER_PAPER_SEQUEN] + aUserPaper[USER_PAPER_CODPAPER] ) ) 
		If AZC->( DbSeek( xFilial("AZC") ) )
			//Só libera a montagem da previsao se o usuario definir uma descrição;
			If CRM010Params()
				FwMsgRun(,{|| nRet :=  FWExecView(STR0033 + " [" + _aParams[1] + "] ","CRMA010C",MODEL_OPERATION_UPDATE,,{|| .T.}) },Nil,STR0116) //"Aguarde, inicializando..."  //"Previsão de Vendas"
				If nRet == 0 .And. !Empty( _cCodPVendas )
					CRMA010B( _cCodPVendas, .T. )	
					If oView <> Nil
						oModel := oView:GetModel()
						oModel:DeActivate()
						oModel:Activate()
						oView:Refresh()
					EndIf
				EndIf
			EndIf
		Else
			MsgAlert(STR0063) //"Cadastre a hierarquia de cargos."
		EndIf	
	Else
		MsgInfo(STR0064) //"Usuário não faz parte da estrutura de negócio"
	EndIf
Else
	ApMsgAlert(STR0084)//"Não foi possível identificar o papel deste usuário!"#"Atenção"
EndIf



Return Nil

//------------------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Monta modelo de dados do Níveis do Agrupador Dinamico.

@sample	ModelDef()
@param		Nenhum
@return	ExpO - Modelo de Dados

@author	SI2901 - Cleyton F.Alves
@since		11/03/2015
@version	12
/*/
//------------------------------------------------------------------------------
Static Function ModelDef()

Local oModel		:= Nil
Local oMdlAOL		:= Nil
Local oMdlAOM		:= Nil
Local oMdlAZC		:= Nil
Local oStructCAB	:= FWFormModelStruct():New()
Local oStructPAP	:= FWFormModelStruct():New()
Local oStructAOL	:= FWFormStruct(1,"AOL"  ,/*bAvalCampo*/,/*lViewUsado*/)
Local oStructAOM	:= FWFormStruct(1,"AOM"  ,/*bAvalCampo*/,/*lViewUsado*/)
Local oStructAZC	:= FWFormStruct(1,"AZC"  ,/*bAvalCampo*/,/*lViewUsado*/)
Local bPosVldMdl	:= {|oModel| CRM010CPVld( oModel ) }
Local bCommit 	:= {|oModel| CRM010CCmt( oModel ) }
Local bLoadCAB	:= {|| {xFilial("AOL")} }
Local bLoadPAP	:= {|| CRM010PAP() }
Local bLoadAOL	:= {|oMdlAOL| CRM010AOL(oMdlAOL) }
Local bLoadAOM	:= {|oMdlAOM| CRM010AOM(oMdlAOM,oModel:GetModel("AOLDETAIL"):GetValue("AOL_CODAGR")) }
Local bLoadAZC	:= {|oMdlAZC| CRM010AZC(oMdlAZC) }

oStructCAB:AddField("","","CAB_FILIAL","C",FwSizeFilial(),0)
oStructPAP:AddField("","","PAP_FILIAL","C",FwSizeFilial(),0)
oStructPAP:AddField("","","PAP_MARK"  ,"L",1,0,Nil,Nil,Nil,Nil,Nil,Nil,Nil,.T.)
oStructPAP:AddField("","","PAP_CODIGO","C",TamSX3("AD2_CODPAP")[1],TamSX3("AD2_CODPAP")[2],Nil,{||.F.})
oStructPAP:AddField("","","PAP_DESCRI","C",55,0,Nil,{||.F.})
oStructAOL:AddField("","","AOL_MARK"  ,"L",1,0,{|oMdlAOL| CRMAOLMark(oMdlAOL)},Nil,Nil,Nil,Nil,Nil,Nil,.T.)
oStructAOM:AddField("","","AOM_MARK"  ,"L",1,0,,Nil,Nil,Nil,Nil,Nil,Nil,.T.)
oStructAZC:AddField("","","AZC_MARK"  ,"L",1,0,{|oMdlAZC| CRMAZCMark(oMdlAZC)},Nil,Nil,Nil,Nil,Nil,Nil,.T.)

oModel := MPFormModel():New("CRMA010C",/*bPreValidacao*/,bPosVldMdl,bCommit,/*bCancel*/)

oModel:AddFields("CABMASTER",/*cOwner*/,oStructCAB,/*bPreValid*/,/*bPosValid*/,bLoadCAB)
oModel:AddGrid("PAPDETAIL" ,"CABMASTER",oStructPAP,/*bLinePre*/,/*bLinePost*/,/*bPreVal*/,/*bPosVal*/,bLoadPAP)
oModel:AddGrid("AOLDETAIL" ,"CABMASTER",oStructAOL,/*bLinePre*/,/*bLinePost*/,/*bPreVal*/,/*bPosVal*/,bLoadAOL)
oModel:AddGrid("AOMDETAIL" ,"AOLDETAIL",oStructAOM,/*bLinePre*/,/*bLinePost*/,/*bPreVal*/,/*bPosVal*/,bLoadAOM)
oModel:AddGrid("AZCDETAIL" ,"AOLDETAIL",oStructAZC,/*bLinePre*/,/*bLinePost*/,/*bPreVal*/,/*bPosVal*/,bLoadAZC)

oModel:SetRelation("PAPDETAIL",{{"PAP_FILIAL","xFilial('AD2')"}},AD2->(IndexKey(1)))
oModel:SetRelation("AOLDETAIL",{{"AOL_FILIAL","xFilial('AOL')"}},AOL->(IndexKey(1)))
oModel:SetRelation("AOMDETAIL",{{"AOM_FILIAL","xFilial('AOM')"},{"AOM_CODAGR","AOL_CODAGR"}},AOM->(IndexKey(1)))

oModel:SetPrimaryKey({""})

oModel:GetModel("PAPDETAIL"):SetOptional(.T.)
oModel:GetModel("PAPDETAIL"):SetOnlyQuery(.T.)

oModel:GetModel("AOLDETAIL"):SetOptional(.T.)
oModel:GetModel("AOLDETAIL"):SetOnlyQuery(.T.) 

oModel:GetModel("AOMDETAIL"):SetOptional(.T.) 
oModel:GetModel("AOMDETAIL"):SetOnlyQuery(.T.)

oModel:GetModel("AZCDETAIL"):SetOptional(.T.)
oModel:GetModel("AZCDETAIL"):SetOnlyQuery(.T.)

oModel:GetModel('AOLDETAIL'):SetNoDeleteLine(.T.)
oModel:GetModel('AOLDETAIL'):SetNoInsertLine(.T.)
oModel:GetModel('AOLDETAIL'):SetNoUpdateLine(.F.)
		
oModel:GetModel('AOMDETAIL'):SetNoDeleteLine(.T.)
oModel:GetModel('AOMDETAIL'):SetNoInsertLine(.T.)
oModel:GetModel('AOMDETAIL'):SetNoUpdateLine(.F.)

oModel:GetModel('AZCDETAIL'):SetNoDeleteLine(.T.)
oModel:GetModel('AZCDETAIL'):SetNoInsertLine(.T.)
oModel:GetModel('AZCDETAIL'):SetNoUpdateLine(.F.)

oModel:GetModel('PAPDETAIL'):SetNoDeleteLine(.T.)
oModel:GetModel('PAPDETAIL'):SetNoInsertLine(.T.)
oModel:GetModel('PAPDETAIL'):SetNoUpdateLine(.F.)

oModel:GetModel("CABMASTER"):SetDescription(STR0050) //"Agrupador de Registros"
oModel:GetModel("PAPDETAIL"):SetDescription(STR0051) //"Papeis"
oModel:GetModel("AOLDETAIL"):SetDescription(STR0052) //"Agrupadores"
oModel:GetModel("AOMDETAIL"):SetDescription(STR0053) //"Níveis do Agrupador"
oModel:GetModel("AZCDETAIL"):SetDescription(STR0054) //"Hierarquia de Cargos"

oModel:SetDescription(STR0036) //"Novo"

Return( oModel )

//------------------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Monta interface do Níveis do Agrupador Dinamico.

@sample	ViewDef()
@param	Nenhum
@return	ExpO - Interface do Agrupador de Registros

@author	SI2901 - Cleyton F.Alves
@since		11/03/2015
@version	12
/*/
//------------------------------------------------------------------------------
Static Function ViewDef()

Local oStructPAP	:= FWFormViewStruct():New()
Local oStructAOL	:= FWFormStruct(2,"AOL",{|cCampo| AllTrim(cCampo) $ "AOL_CODAGR|AOL_RESUMO|AOL_ENTIDA|AOL_DSCENT|AOL_TIPO|"},/*lViewUsado*/)
Local oStructAOM	:= FWFormStruct(2,"AOM",/*bAvalCampo*/,/*lViewUsado*/)
Local oStructAZC	:= FWFormStruct(2,"AZC",/*bAvalCampo*/,/*lViewUsado*/)
Local oModel   	:= FWLoadModel('CRMA010C')
Local oView		:= Nil
Local oPanel		:= Nil

oStructPAP:SetProperty("*",MVC_VIEW_CANCHANGE,.F.)
oStructAOL:SetProperty("*",MVC_VIEW_CANCHANGE,.F.)
oStructAZC:SetProperty("*",MVC_VIEW_CANCHANGE,.F.)

oStructPAP:AddField("PAP_MARK"  ,"01",""     ,""     ,{},"L","@BMP",Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,.T.)
oStructPAP:AddField("PAP_CODIGO","02",STR0040,STR0040,{},"C",""    ,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,.T.) //"Codigo"
oStructPAP:AddField("PAP_DESCRI","03",STR0055,STR0055,{},"C",""    ,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,.T.) //"Descrição"

oStructAOL:AddField("AOL_MARK"    ,"01","","",{},"L","@BMP",Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,.T.)
oStructAOM:AddField("AOM_MARK"    ,"01","","",{},"L","@BMP",Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,.T.)
oStructAZC:AddField("AZC_MARK"    ,"00","","",{},"L","@BMP",Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,.T.)

oView:=FWFormView():New()
oView:SetModel(oModel)

oView:AddGrid("VIEW_PAP",oStructPAP,"PAPDETAIL")
oView:AddGrid("VIEW_AOL",oStructAOL,"AOLDETAIL")
oView:AddGrid("VIEW_AZC",oStructAZC,"AZCDETAIL")

oView:CreateVerticalBox("ESQUERDA",40)
oView:CreateVerticalBox("DIREITA",60)

oView:CreateHorizontalBox("ESQ_SUP",65,"ESQUERDA")
oView:CreateHorizontalBox("ESQ_INF",35,"ESQUERDA")

oView:CreateHorizontalBox("DIR_SUP",30,"DIREITA")
oView:CreateHorizontalBox("DIR_CEN",35,"DIREITA")
oView:CreateHorizontalBox("DIR_INF",35,"DIREITA")

//Painel Superior Esquerdo
oView:AddOtherObject ("OBJ_ESTRU",{|oPanel| CRM010Estr(oPanel,oView,oView:GetModel())})
oView:SetOwnerView("OBJ_ESTRU","ESQ_SUP")
oView:EnableTitleView("OBJ_ESTRU",STR0056) //"Estrutura de Negócio"

//Painel Superior Direito
oView:SetOwnerView("VIEW_AOL","DIR_SUP")
oView:EnableTitleView("VIEW_AOL",STR0052) //"Agrupadores"
oView:SetViewProperty('VIEW_AOL',"CHANGELINE",{ { || CRM010dTree(Nil,oView:GetModel()) }})

//Painel Central Direito
oView:AddOtherObject ("OBJ_TREE",{|oPanel| CRM010Tree(oPanel,oView,oView:GetModel())})
oView:SetOwnerView("OBJ_TREE","DIR_CEN" )

//Painel Inferior Direito
oView:SetOwnerView("VIEW_PAP","DIR_INF")
oView:EnableTitleView("VIEW_PAP",STR0051) //"Papeis do Time de Vendas"

//Painel Inferior Esquerdo
oView:SetOwnerView("VIEW_AZC","ESQ_INF")
oView:EnableTitleView("VIEW_AZC",STR0054) //"Hierarquia Cargos"
oView:ShowUpdateMsg(.F.)

Return( oView )

//------------------------------------------------------------------------------
/*/	{Protheus.doc} CRM010Tree
Cria o objeto DbTree.

@sample		CRM010Tree(oPanel,oViewActive,oMdlActive)

@param		ExpO - Panel do Objeto de Interface
			ExpO - Formulário Ativo
			ExpO - Modelo de Dados Ativo
@return		Nenhum

@author		Cleyton F.Alves
@since		11/03/2015
@version	12
/*/
//------------------------------------------------------------------------------
Static Function CRM010TREE(oPanel,oViewActive,oMdlActive)
	
Local oTree	 		:= Nil
Local oMdlAOLGrid	:= oMdlActive:GetModel("AOLDETAIL")
Local oMdlAOMGrid	:= oMdlActive:GetModel("AOMDETAIL")
Local cAOLResumo	:= oMdlAOLGrid:GetValue("AOL_RESUMO")

oTree := DbTree():New(0,0,000,000,oPanel,{|| .T. },{|| .T. },.T.)	// Adiciona a tree na view
oTree:Align := CONTROL_ALIGN_ALLCLIENT
oTree:AddItem(cAOLResumo+Space(200), CRMA580Root(),"FOLDER12","FOLDER13",,,1)  // RAIZ //"Entidades

// carregando a tree com os dados
If !oMdlAOMGrid:IsEmpty()
	CRM010dTree(oTree,oMdlActive)
EndIf

//Clique com botao esquerdo do mouse
oTree:bLDblClick	:= {|| CRM010Click(oTree,oViewActive,oMdlActive) } //clica duas vezes bLDblClick

oTree:EndTree()
CRMA580DSTree(oTree)

Return Nil

//------------------------------------------------------------------------------
/*	
{Protheus.doc} CRM010dTree

Carrega o componente DbTree com os Níveis do Agrupador.

@sample		CRM010dTree(oTree,oMdlActive)
@param		ExpO - Componente DBTree
			ExpO - MPFormModel do agrupador de registros
@return		Nenhum

@author		Cleyton F.Alves
@since		31/03/2015
@version	12
*/
//------------------------------------------------------------------------------

Static Function CRM010DTREE(oTree,oMdlActive)
	Local oMdlAOLGrid	:= Nil
	Local oMdlAOMGrid	:= Nil
	Local oStructAOM	:= Nil
	Local aCampos		:= {}
	Local cCargoPos		:= ""
	Local cAOLResumo	:= ""
	Local nX			:= 0
	
	Default oMdlActive  := FwModelActive()
	Default oTree 	:= CRMA580DGTree()
	
	oMdlAOLGrid := oMdlActive:GetModel("AOLDETAIL")
	oMdlAOMGrid	:= oMdlActive:GetModel("AOMDETAIL")
	oStructAOM	:= oMdlAOMGrid:GetStruct()
	cAOLResumo 	:= oMdlAOLGrid:GetValue("AOL_RESUMO")
	aCampos		:= oStructAOM:GetFields()
	
	oTree:Reset()
	oTree:AddItem(cAOLResumo+Space(200), CRMA580Root() ,"FOLDER12","FOLDER13",,,1)  // RAIZ //"Entidades
	
	oMdlAOMGrid:GoLine(1)
	cCargoPos := oMdlAOMGrid:GetValue("AOM_CODNIV")
	For nX := 1 To oMdlAOMGrid:Length()
		oMdlAOMGrid:GoLine(nX)
		If oMdlAOMGrid:GetValue("AOM_NIVPAI") == CRMA580Root()
			oTree:TreeSeek( CRMA580Root() )
			CRM010MTree(oTree,oMdlAOMGrid,aCampos,oMdlAOMGrid:GetValue("AOM_CODNIV"))
		EndIf
	Next nX
	oMdlAOMGrid:GoLine(1)
	
	oTree:TreeSeek(cCargoPos)
	oTree := CRMA580DGTree()
Return Nil

//------------------------------------------------------------------------------
/*/ {Protheus.doc} CRM010MTree

Funcao recursiva para montar os níveis do DBTree.

@sample		CRM010MTree(oTree,oMdlAOMGrid,aCampos,cNivelPai)

@param		ExpO - Componente DBTree
			ExpO - ModelGrid Nível do Agrupador
			ExpA - Campos da tabela AOM
			ExpC - Codigo do Nível Pai.
@return		ExpL - Verdadeiro

@author		Cleyton F.Alves
@since		31/03/2015
@version	12
/*/
//------------------------------------------------------------------------------
Static Function CRM010MTREE( oTree, oMdlAOMGrid, aCampos, cNivelPai)
	Local nLinha  := 0
	Local nX	  := 0
	Local cCodAgr := oMdlAOMGrid:GetValue("AOM_CODAGR")
	Local cCodNiv := oMdlAOMGrid:GetValue("AOM_CODNIV")
	
	oTree:AddItem( oMdlAOMGrid:GetValue("AOM_DESCRI"), oMdlAOMGrid:GetValue("AOM_CODNIV"),"","",,,2 )
	
	If oMdlAOMGrid:GetValue("AOM_MARK")
		oTree:ChangeBmp("LBOK","LBOK",,,oMdlAOMGrid:GetValue("AOM_CODNIV"))
	Else
		oTree:ChangeBmp("LBNO","LBNO",,,oMdlAOMGrid:GetValue("AOM_CODNIV"))
	EndIf
	
	If oMdlAOMGrid:SeekLine({{"AOM_NIVPAI",cNivelPai}})
		nLinha := oMdlAOMGrid:GetLine()
		For nX := nLinha To oMdlAOMGrid:Length()
			oMdlAOMGrid:GoLine(nX)
			If oMdlAOMGrid:GetValue("AOM_NIVPAI") == cNivelPai
				oTree:TreeSeek(cNivelPai)
				CRM010MTree(oTree,oMdlAOMGrid,aCampos,oMdlAOMGrid:GetValue("AOM_CODNIV"))
				oMdlAOMGrid:GoLine(nX)
			EndIf
		Next nX
	EndIf
Return(.T.)

//-----------------------------------------------------------------------------
/*/{Protheus.doc} CRMAOLMark

Controla o campo AOL_MARK do GRID AOL para permitir apenas uma linha marcada.

@sample	CRMAOLMark(oMdlAOL)

@param		ExpO - Objeto do modelo de dados atual.
@return		ExpL - verdadeiro

@author	Cleyton F.Alves
@since		10/06/2015
@version	12
/*/
//------------------------------------------------------------------------------
Static Function CRMAOLMARK(oMdlAOL)

Local oView		:= FwViewActive()
Local nLinAtu	:= oMdlAOL:GetLine()  
Local lMark	 	:= oMdlAOL:GetValue("AOL_MARK")
Local nX		:= 0

For nX := 1 To oMdlAOL:Length()
	oMdlAOL:GoLine(nX)
	oMdlAOL:LoadValue("AOL_MARK",.F.)
Next nX
oMdlAOL:GoLine(nLinAtu)

If !Empty(oMdlAOL:GetValue("AOL_CODAGR"))
	oMdlAOL:LoadValue("AOL_MARK",lMark)
Else
	oMdlAOL:LoadValue("AOL_MARK",.F.)
EndIf

oView:Refresh("VIEW_AOL") 

Return( .T. )

//-------------------------------------------------------------------
/*/{Protheus.doc} CRMAZCMark

Retona um array com inFormações do usuários marcados

@sample	CRMAZCMark(oMdlAZC)
@param		ExpA - Array com nós da tree.
@return		ExpA - Array com os nós marcados.

@author 	Ronaldo Robes
@since 		08/05/2015
@version 	P12
/*/
//-------------------------------------------------------------------

Static Function CRMAZCMARK(oMdlAZC)

Local oView		:= FwViewActive()
Local nLinAtu	:= oMdlAZC:GetLine()  
Local lMark	 	:= oMdlAZC:GetValue("AZC_MARK")
Local nX		:= 0

For nX := 1 To oMdlAZC:Length()
	oMdlAZC:GoLine(nX)
	oMdlAZC:LoadValue("AZC_MARK",.F.)
Next nX

oMdlAZC:GoLine(nLinAtu)
oMdlAZC:LoadValue("AZC_MARK",.T.)
oView:Refresh("VIEW_AZC") 

Return( .T. )

//-----------------------------------------------------------------------------
/*/{Protheus.doc} CRM010AOL
Retorna os agrupador selecionado pelo usuario.

@sample	CRM010AOL(oMdlAOL)
@param	ExpO - Modelo de Dados
@return	ExpA - Array dos Agrupadores

@author	SI2901 - Cleyton F.Alves
@since		10/06/2015
@version	12
/*/
//-----------------------------------------------------------------------------
Static Function CRM010AOL(oMdlAOL)

Local aAreaAOL	 := AOL->(GetArea())
Local aLoadAOL   := {}
Local oStructAOL := oMdlAOL:GetStruct()
Local aCampos    := oStructAOL:GetFields()
Local cMacro     := ""
Local cCodAgr    := ""
Local cAliasAgr  := ""
Local nX         := 0
Local cQuery     := ""
Local cQryUsu    := ""
Local cAliasSB1  := GetNextAlias()
Local lMarcado   := .T.
Local nY         := 0 
Local lCR010QRY  := ExistBlock("CR010QRY")
Local lFirst	 := .T.

If lCR010QRY
	cQryUsu := ExecBlock("CR010QRY",.F.,.F.,{cQryUsu})
EndIf

//Não usamos EMBEDDED por causa do ponto de entrada 
//com o complemento da query
cQuery := "SELECT AOL.R_E_C_N_O_ AS RECNUM "
cQuery += "FROM "
cQuery += RetSqlName("AOL")+" AOL "

If !Empty(cQryUsu)
	cQuery += cQryUsu
Else
	cQuery += " WHERE "
	cQuery += "(AOL_ENTIDA = 'AD1' OR "
	cQuery += " AOL_ENTIDA = 'SA1' OR "
	cQuery += " AOL_ENTIDA = 'SUS' OR "
	cQuery += " AOL_ENTIDA = 'AD2' OR "
	cQuery += " AOL_ENTIDA = 'ADJ') AND "
	cQuery += " AOL_MSBLQL <> '1' AND "
	cQuery += " AOL.D_E_L_E_T_ <> '*' "
EndIf

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB1,.F.,.T.)

While (cAliasSB1)->(!Eof())

	AOL->(DbGoTo((cAliasSB1)->RECNUM))

	nX++
	aAdd(aLoadAOL,{nX,{}})	
				
	For nY := 1 To Len(aCampos)	
	
		If !aCampos[nY][MODEL_FIELD_VIRTUAL]
			cMacro := "AOL->"+ALlTrim(aCampos[nY][MODEL_FIELD_IDFIELD])
		Else 
			If aCampos[nY][MODEL_FIELD_IDFIELD] == "AOL_DSCENT"
				cMacro := "AllTrim(Posicione('SX2',1,AOL->AOL_ENTIDA,'X2NOME()'))"
			ElseIf aCampos[nY][MODEL_FIELD_IDFIELD] == "AOL_MARK"
				If( lFirst )
					cMacro 	:= ".T."
					lFirst	:= .F. 
				Else
					cMacro := ".F."
				EndIf
			Else
				cMacro := AllTrim(aCampos[nY][MODEL_FIELD_INIT])
			EndIf
		EndIf
			
		aAdd(aLoadAOL[Len(aLoadAOL),2] , &cMacro )
	Next nY

	(cAliasSB1)->(DbSkip())
EndDo	

(cAliasSB1)->(DbCloseArea())

RestArea(aAreaAOL)

Return(aLoadAOL)

//-----------------------------------------------------------------------------
/*/{Protheus.doc} CRM010AOM

Retorna os niveis do agrupador selecionado pelo usuario.

@sample	CRM010AOM(oMdlAOM,cCodAgr)

@param		ExpO - Model dos Níveis de Agrupador
@param		ExpC - String do Agrupadore Selecionado.

@return		ExpA - Array de carregamento do Model

@author	SI2901 - Cleyton F.Alves
@since		10/06/2015
@version	12
/*/
//-----------------------------------------------------------------------------
Static Function CRM010AOM(oMdlAOM,cCodAgr)

Local aLoadAOM   := {}
Local oStructAOM := oMdlAOM:GetStruct()
Local aCampos    := oStructAOM:GetFields()
Local cMacro     := ""
local nY := 0 

If AOM->(DbSeek(xFilial("AOM")+cCodAgr))
	While AOM->(!Eof()) .And. AOM->AOM_FILIAL == xFilial("AOM") .And. AllTrim(AOM->AOM_CODAGR) == AllTrim(cCodAgr)

		aAdd(aLoadAOM,{AOM->(Recno()) ,{} })	

		For nY := 1 To Len(aCampos)	
			If !aCampos[nY][MODEL_FIELD_VIRTUAL]
				cMacro := "AOM->"+ALlTrim(aCampos[nY][MODEL_FIELD_IDFIELD])
			Else
				cMacro := AllTrim(aCampos[nY][MODEL_FIELD_INIT])
			EndIf

			aAdd(aLoadAOM[Len(aLoadAOM),2] , &cMacro )
		Next nY
		AOM->(DbSkip())

	EndDo	
EndIf

Return(aLoadAOM)

//-----------------------------------------------------------------------------
/*/{Protheus.doc} CRM010AZC

Retorna as hierarquias selecionadas pelo usuario.

@sample	CRM010AZC(oMdlAZC)
@param		ExoO - Model dos Níveis de Agrupador
@return		ExpA - Array de carregamento do Model

@author		SI2901 - Cleyton F.Alves
@since		10/06/2015
@version	12
/*/
//-----------------------------------------------------------------------------
Static Function CRM010AZC(oMdlAZC)

Local aLoadAZC   := {}
Local oStructAZC := oMdlAZC:GetStruct()
Local aCampos    := oStructAZC:GetFields()
Local cMacro     := ""
local nY         := 0 
Local nX         := 0

AZC->(DbGoTop())

While AZC->(!Eof()) .And. AZC->AZC_FILIAL == xFilial("AZC")

	nX++
	aAdd(aLoadAZC,{nX,{}})

	For nY := 1 To Len(aCampos)
		If !aCampos[nY][MODEL_FIELD_VIRTUAL]
			cMacro := "AZC->"+ALlTrim(aCampos[nY][MODEL_FIELD_IDFIELD])
		ElseIf AllTrim(aCampos[nY][MODEL_FIELD_IDFIELD]) == "AZC_MARK"
			cMacro := Iif(nX == 1,".T.",".F.")
		Else
			cMacro := AllTrim(aCampos[nY][MODEL_FIELD_INIT])
		EndIf
		
		aAdd(aLoadAZC[Len(aLoadAZC),2] , &cMacro )
	Next nY
	AZC->(DbSkip())

EndDo

Return(aLoadAZC)

//-----------------------------------------------------------------------------
/*/{Protheus.doc} CRM010PAP
Retorna os papeis selecionados pelo usuario.

@sample	CRM010PAP(oMdlPAP)
@param		ExpO - Model dos Papei
@return		ExpA - Array com a carga do model

@author	SI2901 - Cleyton F.Alves
@since		10/06/2015
@version	12
/*/
//-----------------------------------------------------------------------------
Static Function CRM010PAP()

Local aLoadPAP   	:= {}
Local cAliasPap  	:= GetNextAlias()
Local nX		 	:= 0
Local lCrm010Pap	:= ExistBlock( "CRM010CQRY" ) //Ponto de entrada para manipulação da query de papeis
Local cWhere		:= " "
Local cWherePE		:= " "

cWhere := "%"
cWhere += " AD2.AD2_FILIAL = '" + xFilial("AD2") + "' AND "

If lCrm010Pap
	cWherePE := ExecBlock("CRM010CQRY", .F., .F.)
	If !Empty( cWherePE )
		cWhere += cWherePE
	EndIf
EndIf

cWhere += "%"

	BeginSQL Alias cAliasPAP
	
	SELECT DISTINCT AD2_FILIAL, AD2_CODPAP
	FROM 	%Table:AD2% AD2 
	WHERE 	%Exp:cWhere% 
			AD2.%NotDel% 
	ORDER BY AD2_CODPAP
	EndSql
	
	While (cAliasPAP)->(!Eof())
		aAdd(aLoadPAP,{ nX++, { (cAliasPAP)->AD2_FILIAL,;
								    .F.,;
									(cAliasPAP)->AD2_CODPAP,;
									IIF( !Empty((cAliasPAP)->AD2_CODPAP), Ft300NCargo((cAliasPAP)->AD2_CODPAP),STR0057) } })
		(cAliasPAP)->(DBSkip())
	End
	
	(cAliasPAP)->(DBCloseArea())

Return(aLoadPAP)

//---------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} CRM010Estr

Monta a estrutura da árvore para hierarquia de negocio

@sample	CRM010Estr(oPanel,oViewActive,oMdlActive)
@param	ExpO - Panel de apresentação
		ExpO - Formulario ativo da tree
		ExpO - Model ativo da tree 		
@return	ExpO - Tree da hierarquia de negocio

@author	Bruno Colisse
@since		03/07/2015
@version	12.0
/*/
//---------------------------------------------------------------------------------------------------------------
Static Function CRM010ESTR(oPanel,oViewActive,oMdlActive)
Local oTreeHQ		:= Nil
Local aNodes		:= CRM10PStruct()

oTreeHQ := DBTree():New(0,0,000,000,oPanel,{|| .T. },{|| .T. },.T.)
oTreeHQ:Align	:= CONTROL_ALIGN_ALLCLIENT
oTreeHQ:AddTree(STR0058+Space(200),.F., "ORGIMG32", "ORGIMG32",,,PadR("000-RAIZ", 20)) //"Estrutura de hierarquia"
CRM010TItem(oTreeHQ, aNodes,.T.)
oTreeHQ:PTCollapse()

If !Empty( aNodes ) 
	oTreeHQ:bLClicked  := { || CRM010TItem(oTreeHQ, aNodes) } 
	oTreeHQ:bRClicked  := { || CursorWait(),CRM010MEst( oTreeHQ, aNodes,.F. ),CursorArrow() } 
EndIf

CRMA010CSNode( aNodes ) 
	
Return oTreeHQ 

//-------------------------------------------------------------------
/*/{Protheus.doc} CRM240PStruct
Processa os níveis da estrutura.

@param Nenhum

@return Nenhum

@author  Valdiney V GOMES / Anderson Silva  
@version P12
@since   11/01/2016  
/*/
//-------------------------------------------------------------------
Static Function CRM10PStruct() 

Local aRole		:= CRMXGetPaper()
Local aNodes		:= {}
Local aAttribute	:= {}
Local aStruct 	:= {}
Local cTitle		:= ""
Local nStruct		:= 0
Local nLenStruct	:= 0

//-------------------------------------------------------------------
// Lista os nós filhos do papel na estrutura de negócio.  
//-------------------------------------------------------------------	
aStruct := CRMA240GetStruct( "AZS", aRole[1] + aRole[2] + aRole[3] )
nLenStruct := Len( aStruct )

//-------------------------------------------------------------------
// Percorre todos nós encontradps.  
//------------------------------------------------------------------- 	
For nStruct := 1 To nLenStruct
	
	aAttribute	:= {}

	//-------------------------------------------------------------------
	// Lista os atributos do nível.  
	//-------------------------------------------------------------------	
	aAdd( aAttribute, aStruct[nStruct][1] 	)
	aAdd( aAttribute, aStruct[nStruct][2] 	)
	aAdd( aAttribute, aStruct[nStruct][3] 	)
	aAdd( aAttribute, aStruct[nStruct][4] 	)
	aAdd( aAttribute, aStruct[nStruct][5]	)
	aAdd( aAttribute, aStruct[nStruct][6] 	)
	aAdd( aAttribute, aStruct[nStruct][3] + "-" + aStruct[nStruct][4] )
	aAdd( aAttribute, cTitle )		
	aAdd( aAttribute, "" )	
	aAdd( aAttribute, "" )	
	aAdd( aAttribute, .F. )	
	aAdd( aAttribute, .T. )					
					
	//-------------------------------------------------------------------
	// Lista todos os níveis da estrutura.  
	//-------------------------------------------------------------------	
	aAdd( aNodes, aAttribute )

Next nStruct 

Return( aNodes )

//-------------------------------------------------------------------
/*/{Protheus.doc} CRM010TItem
Cria os niveis do Tree.

@param oTree		, objeto, Tree da estrutura de negocio.  
@param aNodes		, array	 , Estrutura Pais x Filhos. 
@param lRoot		, logico, Indica se a criação dos itens será pelo nivel 1 ( Raiz ). 

@return Nenhum

@author  Valdiney V GOMES / Anderson Silva  
@version P12
@since   11/01/2016  
/*/
//-------------------------------------------------------------------
Static Function CRM010TItem(oTreeHQ, aNodes, lRoot)

Local cCargoId	:= ""
Local cFather		:= "" 
Local cFatherPos	:= ""
Local nNode		:= 0
Local nPosCargo	:= 0
Local nLenNodes	:= 0
Local oView		:= FwViewActive()

Default oTreeHQ	:= Nil
Default aNodes	:= {}
Default lRoot		:= .F.

//--------------------------
// Id do nível selecionado.
//-------------------------- 
cCargoId := AllTrim( oTreeHQ:GetCargo() ) 

If ( lRoot .Or. !( Left( cCargoId, 3 ) $ "AZS|000-RAIZ" ) )
	
	CursorWait()
	
	/*
		Desabilita a pintura da MSDialog para aguardar o carregamento do DBTREE,
		desta forma o usuário não terá a visualização da montagem do níveis. 
	*/
	oView:oOwner:SetUpdatesEnabled(.F.)
	
	If oTreeHQ:TreeSeek("_"+cCargoId) 
		oTreeHQ:DelItem()
	EndIf
	
	nLenNodes	:= Len( aNodes ) 
	nPosCargo 	:= aScan( aNodes, {|x| x[1] +"-"+ x[2] == cCargoId } )

	If nPosCargo == 0
		//Posiciona no primeiro nó;
		nPosCargo := 1 
	EndIf
	
	If aNodes[nPosCargo][12]
	
		oTreeHQ:BeginUpdate()
		
		For nNode := nPosCargo To nLenNodes
			
			//------------------------------------------------------------------- 
			// Pai do nível corrente.  
			//------------------------------------------------------------------- 
			cFather	:= aNodes[nNode][1] + "-" + aNodes[nNode][2]
		
			If( cFather == cFatherPos .Or. Empty( cFatherPos ) )
				
				cTitle := CRMA240Title( aNodes[nNode][3], aNodes[nNode][4], .T. )
				
				oTreeHQ:AddItem(cTitle , aNodes[nNode][3] + "-" + aNodes[nNode][4], "CHECKED","CHECKED", , , 2)
			
				If aNodes[nNode][3] <> "AZS"
					oTreeHQ:TreeSeek( aNodes[nNode][3] + "-" + aNodes[nNode][4] )
					oTreeHQ:AddItem(STR0115 , "_" + aNodes[nNode][3] + "-" + aNodes[nNode][4],,, , , 2) //"Aguarde..."
					oTreeHQ:TreeSeek( cCargoId ) 	
				EndIf
				
				aNodes[nNode][8]	:= 	cTitle
				aNodes[nNode][11]	:= .T. 
				cFatherPos	:= aNodes[nNode][1] + "-" + aNodes[nNode][2]
								
			EndIf
			
			aNodes[nNode][11]	:= .T. 
		
		Next nNode
		
		oTreeHQ:TreeSeek(cCargoId)
		oTreeHQ:EndUpdate()
	EndIf
	
	If nPosCargo > 0
		aNodes[nPosCargo][12] := .F.
	EndIf

	oView:oOwner:SetUpdatesEnabled(.T.)
	
	CursorArrow()
	
EndIf

Return Nil

//---------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} CRM010MEST

Monta a árvore para consulta de precisão de vendas

@sample	CRM010MEST(oTreeHQ,aNodes)
@param	ExpO - Tree da hierarquia de negocio
		ExpA - Array com os nós da tree
@return	ExpA - Array com os nós da tree manipulado

@author	Bruno Colisse
@since		03/07/2015
@version	12.0
/*/
//---------------------------------------------------------------------------------------------------------------
Static Function CRM010MEST(oTreeHQ,aNodes)

Local cCargo 		:= oTreeHQ:GetCargo() 
Local cEntidade	:= SubStr( cCargo, 1, Rat( "-", cCargo ) - 1 )
Local cCodigo 	:= AllTrim( SubStr( cCargo, Rat( "-", cCargo ) + 1, Len( cCargo ) ) )
Local cIdInt 		:= AllTrim(AOM->AOM_IDINT) // id Inteligente da estrutura
Local nX 			:= 0
Local nNodeSel	:= 0
Local lStatus 	:= .F.
Local aRet 		:= {} 

If AllTrim(cCargo) != "000-RAIZ"

	For nX := 1 To Len( aNodes )
		
		If ( AllTrim( aNodes[nX][3] ) == cEntidade .And. aNodes[nX][4] == AllTrim( cCodigo ) )
			
			If aNodes[nX][11]
				aNodes[nX][11] := .F.
				lStatus 		 := .F.
				oTreeHQ:ChangeBmp("UNCHECKED","UNCHECKED",,,cCargo)
			Else
				aNodes[nX][11] := .T.
				lStatus 		 := .T.
				oTreeHQ:ChangeBmp("CHECKED","CHECKED",,,cCargo)	
			EndIf
			
			cIdEstN 	:= aNodes[nX][5]
			nNodeSel	:= nX
			
			Exit
			
		EndIf
		
	Next nX
		
		For nX := nNodeSel To Len( aNodes )
			
		If SubStr( aNodes[nX][5], 1, Len( cIdEstN ) ) == SubStr( cIdEstN, 1, Len( aNodes[nX][5] ) ) .And. nNodeSel <> nX
			
			aNodes[nX][11] := lStatus
					
			If lStatus 
				oTreeHQ:ChangeBmp("CHECKED","CHECKED",,,aNodes[nX, 3] + "-" + aNodes[nX, 4] )
			Else
				oTreeHQ:ChangeBmp("UNCHECKED","UNCHECKED",,,aNodes[nX, 3] + "-" + aNodes[nX, 4] )
			EndIf 
							
		EndIf	
	
		
	Next nX
	
	aRet := CRM010Usr( aNodes )
		
	CRMA010CSNODE(aNodes)
	
EndIf

Return aRet

//-------------------------------------------------------------------
/*/{Protheus.doc} CRM010Usr

Retona um array com inFormações do usuários marcados

@sample	CRM010Usr(aNodes)
@param	ExpA - Array com nós da tree.
@return	ExpA - Array com os nós marcados.

@author 	Bruno Colisse
@since 		08/05/2015
@version 	P12
/*/
//-------------------------------------------------------------------
Static Function CRM010USR(aNodes)

Local aRet := {}
Local nX := 0

For nX := 1 To Len(aNodes)
	If aNodes[nX][3] == "AZS" .And. aNodes[nX][11]
		aAdd(aRet,aNodes[nX][4])
	EndIf
Next nX
			
Return aRet

//------------------------------------------------------------------------------
/*/{Protheus.doc} CRM010CLICK

Funcao que marca e desmarca o DbTree

@sample		CRM010Click(oTreeHQ,oViewActive,oMdlActive)

@param		ExpO - Componente DBTree
			ExpO - FwFormView do Agrupador de Registros
			ExpO - MPFormModel do Agrupador de Registros

@return		Nenhum

@author		Cleyton F.Alves
@since		10/06/2015
@version	12
/*/
//------------------------------------------------------------------------------
Static Function CRM010CLICK(oTree,oViewActive,oMdlActive)

Local oMdlAOMGrid	:= oMdlActive:GetModel("AOMDETAIL")
Local cIdTree		:= AllTrim(oTree:GetCargo())
Local nLinAtu		:= 0
Local nx			:= 0
Local cCodAgr       := ""
Local cCodNiv       := ""

If cIdTree <> CRMA580Root() .AND. oMdlAOMGrid:SeekLine({{"AOM_CODNIV",cIdTree}})
		
	If oMdlAOMGrid:GetValue("AOM_MSBLQL") <> "1"
		
		cCodAgr	:= oMdlAOMGrid:GetValue("AOM_CODAGR")
		cCodNiv	:= oMdlAOMGrid:GetValue("AOM_CODNIV")
		cCodNp	:= oMdlAOMGrid:GetValue("AOM_NIVPAI")
		
		
		If oMdlAOMGrid:GetValue("AOM_MARK")
			oTree:ChangeBmp("LBNO","LBNO",,,oMdlAOMGrid:GetValue("AOM_CODNIV"))
			oMdlAOMGrid:SetValue("AOM_MARK",.F.)
			//Se desmarcar o Pai, desmarca os filhos
			Crm010Mark( oTree, oMdlAOMGrid, cCodNiv, .T. )
		Else
			oTree:ChangeBmp("LBOK","LBOK",,,oMdlAOMGrid:GetValue("AOM_CODNIV"))
			oMdlAOMGrid:SetValue("AOM_MARK",.T.)
			
			//Se marcar o pai, marca os filhos	
			Crm010Mark( oTree, oMdlAOMGrid, cCodNiv, .F. )
			
			//Se marcar o Filho marca o Pai
			If oMdlAOMGrid:SeekLine({{"AOM_CODNIV",cCodNp}})
				If !oMdlAOMGrid:GetValue("AOM_MARK")
					oTree:ChangeBmp("LBOK","LBOK",,,oMdlAOMGrid:GetValue("AOM_CODNIV"))
					oMdlAOMGrid:SetValue("AOM_MARK",.T.)
				EndIF
			EndIf
		
		EndIf
	
	Else
		MsgAlert(STR0062) //"Registro Bloqueado!"
	EndIf
	
EndIf
	
oViewActive:Refresh("VIEW_PAP")
	
Return Nil

//------------------------------------------------------------------------------
/*/{Protheus.doc} CRMA010CSNODE

Funcao encapsula a estrutura hierarquica

@sample		CRMA010CSNODE(aNodes)
@param		ExpA - Array com a estrutura hierarquica
@return		Nenhum

@author		Cleyton F.Alves
@since		10/06/2015
@version	12
/*/
//------------------------------------------------------------------------------
Function CRMA010CSNODE(aNodes)
_aNodes := aClone(aNodes)
Return()

//------------------------------------------------------------------------------
/*/{Protheus.doc} CRMA010CGNODE

Funcao que recupera a estrutura da hierarquia

@sample		CRMA010CGNODE()
@param		Nenhum
@return		ExpA - Array recuperado com os nós da hierarquia

@author		Cleyton F.Alves
@since		10/06/2015
@version	12
/*/
//------------------------------------------------------------------------------
Function CRMA010CGNODE()
Return(_aNodes)

//------------------------------------------------------------------------------
/*/{Protheus.doc} CRM010NAMELD

Faz a pre validação do model

@sample		Crm010nameLd
@Return		expC  - cGet

@author		Ronaldo Robes 	
@since		10/06/2015
@version	12
/*/
//------------------------------------------------------------------------------
Static Function CRM010CPVld( oModel )

	Local lRet 	:= .F.
	Local oMdlAOL := Nil
	Local oMdlAOM	:= Nil
	Local oMdlAZC	:= Nil
	Local nX		:= 0
	Local nY		:= 0
	Local aGrid	:= {}
	Local cHelp	:= ""
	Local aNodes	:= CRMA010CGNode()
	
	Default oModel := FwModelActive()
		
	//Verifica se há papeis de usuario marcado.
	For nX := 1 To Len( aNodes )
		If aNodes[nX,11]
			lRet := .T.
			Exit
		EndIf
	Next nX
		
	If !lRet
		Help("",1,"CRM010CVLD",,STR0085,1) //"Selecione uma papel de usuário na estrutura de negócio!"
	EndIf

	If lRet
	 
		aAdd( aGrid, { oModel:GetModel( "PAPDETAIL" ), "PAP_MARK" } )
		aAdd( aGrid, { oModel:GetModel( "AOLDETAIL" ), "AOL_MARK" } )
		aAdd( aGrid, { oModel:GetModel( "AOMDETAIL" ), "AOM_MARK" } )
		aAdd( aGrid, { oModel:GetModel( "AZCDETAIL" ), "AZC_MARK" } )
		
		For nX := 1 To Len( aGrid )
			
			//Seta para falso para encontrar um item marcado no model.
			lRet := .F.
			
			For nY := 1 To aGrid[nX][1]:Length()
				
				aGrid[nX][1]:GoLine( nY )
				
				If aGrid[nX][1]:GetValue( aGrid[nX][2] )
					lRet := .T.	
					Exit
				EndIf
						
			Next nY
			
			If !lRet 
				Do Case
					Case aGrid[nX][1]:GetId() == "PAPDETAIL"
						cHelp := STR0086 //"Selecione um papel!"
					Case aGrid[nX][1]:GetId() == "AOLDETAIL"
						cHelp := STR0087 //"Selecione um agrupador!"
					Case aGrid[nX][1]:GetId() == "AOMDETAIL"
						cHelp := STR0088 //"Selecione um nível do agrupador!"
					Case aGrid[nX][1]:GetId() == "AZCDETAIL"
						cHelp := STR0089 //"Selecione uma hieráquia de cargos!"
				EndCase
				Help("",1,"CRM010CVLD",,cHelp,1)
				Exit
			EndIf
			
		Next nX
	
	EndIf
	
Return( lRet )

//-----------------------------------------------------------------------------
/*/{Protheus.doc} CRM010CCmt

Grava a pesquisa de forecast por agrupador.

@sample	CRM010CCmt(oModel)
@param		ExpA - Model com os papeis da seleção Papeis
@return	Nenhum

@author	SI2901 - Cleyton F.Alves
@since		05/04/2015
@version	12
/*/
//-----------------------------------------------------------------------------
Static Function CRM010CCmt( oModel )

Local oMdlAOLGrid		:= oModel:GetModel("AOLDETAIL")
Local oMdlAOMGrid		:= oModel:GetModel("AOMDETAIL")
Local oMdlPAPGrid		:= oModel:GetModel("PAPDETAIL")
Local oMdlAZCGrid		:= oModel:GetModel("AZCDETAIL")
Local aNodes			:= CRMA010CGNODE()
Local aFrom			:= {}
Local aDetalhe 		:= {}
Local aGroupMark		:= {}
Local aXmlAux			:= {}
Local aExpres			:= {}
Local dDataConsult	:= dDataBase
Local cTmpSA3			:= GetNextAlias()
Local cTimeConsult	:= Time()
Local cCodAgr			:= "" 
Local cCodNiv			:= ""
Local cCodPai			:= ""
Local cCodHie			:= oMdlAZCGrid:GetValue("AZC_CODIGO")
Local cXml				:= ""
Local cQryIni			:= ""
Local cWhrIni			:= ""
Local cQuery			:= ""
Local cWhere			:= ""
Local lRet				:= .F.
Local nX				:= 0
Local nY				:= 0
Local nZ            	:= 0
Local nPosGroup		:= 0
Local cCodPVendas 	:= CRM010CNum("AZF","AZF_CODIGO")
Local nLenSX8 		:= GetSX8Len() 
Local lCommit			:= .F.
Local cItemAZF		:= StrZero(0,TamSX3("AZF_ITEM")[1])	
Local nLenDet			:= 0
Local nLenAOL			:= 0
Local nLenPAP			:= 0
Local nLenAOM			:= 0
Local nLenNodes 		:= Len(aNodes)
Local aMarkUsers		:= {}
Local nLinha			:= 0
Local nCount			:= 0
Local nTVendP			:= 0

//Controle de Transação na gravação da tabela AZF
Begin Transaction  
				
//Parte fixa da query que será sempre executada
//não utilizado embbeded por causa da parte variável da query
cQryIni := "SELECT "
cQryIni += "AD1_PROSPE AZF_PROSPE, AD1_CODCLI AZF_CODCLI, AD1_LOJPRO AZF_LOJPRO, AD1_LOJCLI AZF_LOJCLI, AD1_NROPOR AZF_NROPOR, ADY_PROPOS AZF_PROPOS, ADY_STATUS AZF_STAADY,"
cQryIni += "AD1_DTINI  AZF_DTINI , AD1_DTFIM  AZF_DTFIM , AD1_DTPFIM AZF_DTPFIM, AD1_DESCRI AZF_DESCRI, AD1_FCS AZF_FCS   , "
cQryIni += "AD1_STATUS AZF_STAAD1, AD1_FEELIN AZF_FEELIN, AD1_PROVEN AZF_PROVEN, AD1_STAGE  AZF_STAGE , AD2_VEND   AZF_VEND  , "
cQryIni += "AD2_PERC   AZF_PERC  , AD2_CODPAP AZF_PAPEL , AD1_REVISA AZF_REVISA, " 
cQryIni += "(AD1_RCINIC * AD2_PERC)/100 AZF_PERC01, "
cQryIni += "(AD1_VERBA  * AD2_PERC)/100 AZF_PERC02  "
cQryIni += "FROM  "
cQryIni += RetSqlName("AD1")+" AD1 INNER JOIN "
cQryIni += RetSqlName("AD2")+" AD2 ON AD1.AD1_NROPOR = AD2.AD2_NROPOR AND AD1.AD1_REVISA = AD2.AD2_REVISA "
cQryIni += " LEFT JOIN "
cQryIni += RetSqlName("ADY")+" ADY ON  ADY.ADY_FILIAL = '" +xFilial( "ADY" )+ "' AND ADY.ADY_OPORTU = AD1.AD1_NROPOR "
cQryIni += "AND ADY.ADY_REVISA = AD1.AD1_REVISA AND ADY.ADY_SINCPR='T'"
cWhrIni := "WHERE "
cWhrIni += "AD1.AD1_FILIAL = '"+xFilial("AD1")+"' AND "
cWhrIni += "( ( AD1.AD1_STATUS = '1' AND AD1.AD1_DTPFIM >= '" + dTos( _aParams[2] ) + "' AND AD1.AD1_DTPFIM  <= '" + dTos( _aParams[3] ) + "' ) OR "
cWhrIni += "( AD1.AD1_STATUS = '9' AND AD1.AD1_DTFIM >= '" + dTos( _aParams[2] ) + "' AND AD1.AD1_DTFIM <= '" + dTos( _aParams[3] ) + "' ) ) AND "
cWhrIni += "AD1.D_E_L_E_T_ <> '*' AND "
cWhrIni += "AD2.AD2_FILIAL = '"+xFilial("AD2")+"' AND "
cWhrIni += "AD2.D_E_L_E_T_ <> '*' AND "

//Adiciona o filtro da grid dos papeis
nLenPAP := oMdlPAPGrid:Length()
For nX := 1 To nLenPAP
	oMdlPAPGrid:GoLine(nX)
	If oMdlPAPGrid:GetValue("PAP_MARK")
		aAdd(aDetalhe,oMdlPAPGrid:GetValue("PAP_CODIGO")) 
	EndIf
Next nX

nLenDet := Len( aDetalhe ) 
For nX := 1 To nLenDet
	
	If nX == 1
		cWhrIni += "("
	EndIf
	
	cWhrIni += "AD2_CODPAP = '"+aDetalhe[nX]+"' "
	
	If nX == Len(aDetalhe)
		cWhrIni += ") AND "
	Else
		cWhrIni += " OR "
	EndIf
	
Next nX

nLenNodes := Len(aNodes)

aAdd( aMarkUsers, {} )
nLinha := Len( aMarkUsers )

For nZ := 1 To nLenNodes
	
	If aNodes[nZ,11] .And. aNodes[nZ,3] == "AZS"
		
		If ( AZS->( MSSeek( xFilial("AZS") + aNodes[nZ,4] ) ) ) .And. !Empty( AZS->AZS_VEND )
		
			If nCount == 200
				aAdd( aMarkUsers, {} )
				nLinha := Len( aMarkUsers )
				nCount := 0
			EndIf 
			
			aAdd( aMarkUsers[nLinha], AZS->AZS_VEND ) 

			nCount++
			nTVendP++
	
		EndIf

	EndIf	

Next nZ

//Adiciona as condições do agrupador no filtro da query
nLenAOL := oMdlAOLGrid:Length()
For nX := 1 To nLenAOL 

	oMdlAOLGrid:GoLine(nX)

	If oMdlAOLGrid:GetValue("AOL_MARK")
		
		nLenAOM := oMdlAOMGrid:Length()		
		
		ProcRegua( nLenAOM )
		
		For nY := 1 To nLenAOM
		
			oMdlAOMGrid:GoLine(nY)

			If oMdlAOMGrid:GetValue("AOM_MARK")
									
				cTypeAgr	:= oMdlAOLGrid:GetValue("AOL_TIPO")
				cAliasAgr	:= oMdlAOLGrid:GetValue("AOL_ENTIDA")
				cCodAgr		:= oMdlAOLGrid:GetValue("AOL_CODAGR")
				cCodNiv		:= oMdlAOMGrid:GetValue("AOM_CODNIV")
				
				If CRM010LdLv( cCodAgr, cCodNiv ) // Se o Nível possuí subnivel, pula para os subniveis - Pois os Subníveis herdam caracteriscas dos pais
					Loop
				EndIf
				aGroupMark := CRM010MtArr(cCodAgr,cCodNiv,cTypeAgr,cAliasAgr)
				
				aFrom := {}
				
				aAdd(aFrom,"AD1")
				aAdd(aFrom,"AD2")

				cQuery := cQryIni
				cWhere := cWhrIni
				
				aExpres := CRM010MtExp(aGroupMark,cAliasAgr,@aFrom,cCodAgr)
				cQuery  += aExpres[1]
				cWhere  += " ( " + aExpres[2] + " ) "

				If AllTrim(cAliasAgr) == "SUS"
					cQuery += ", "+RetSqlName("SUS")+" SUS "
							
					cWhere += "SUS.US_FILIAL  = '"+xFilial("SUS")+"' AND "
					cWhere += "AD1.AD1_PROSPE = SUS.US_COD  AND "
					cWhere += "AD1_LOJPRO     = SUS.US_LOJA AND "
					cWhere += "SUS.D_E_L_E_T_ <> '*' "
							
				ElseIf AllTrim(cAliasAgr) == "SA1"
					cQuery += ", " + RetSqlName("SA1")+" SA1 "
							
					cWhere += "SA1.A1_FILIAL  = '"+xFilial("SA1")+"' AND "
					cWhere += "AD1.AD1_CODCLI = SA1.A1_COD  AND "
					cWhere += "AD1_LOJCLI     = SA1.A1_LOJA AND "
					cWhere += "SA1.D_E_L_E_T_ <> '*' "
					
				EndIf
				
				Processa({|| lCommit := CRM010AZF(cCodPVendas,@cItemAZF,cQuery,cWhere,cCodAgr,cCodNiv,cCodPai,cCodHie,dDataConsult,cTimeConsult,aMarkUsers, nTVendP) }, STR0111 + AllTrim( Capital( oMdlAOLGrid:GetValue("AOL_RESUMO") ) ) +STR0112+ AllTrim( Capital( oMdlAOMGrid:GetValue("AOM_DESCRI") ) ) , "",.T.) //"Agrupador:  | Nível: "
				
				If lCommit
					lRet := lCommit
				EndIf
										
			EndIf
		Next nY
		
	EndIf

Next nX

If lRet 
	//Deixado fora do controle de transação por causa da operação com seleção de agrupador
	//que tem comportamento diferente da operação sem seleção de agrupador
	While (GetSX8Len() > nLenSX8 )
		AZF->( ConfirmSX8() )
	End
	_cCodPVendas := cCodPVendas
Else

	DisarmTransaction()	
			
	While ( GetSX8Len() > nLenSX8 )
		AZF->( RollBackSx8() )
	End
	Help("",1,"CRM010C",,STR0082,1)//"A consulta realizada não será gravada pois não retorna nenhum resultado!"
EndIf


End Transaction 

Return( .T. )

//-----------------------------------------------------------------------------
/*/{Protheus.doc} CRM010MtArr

Monta a expressão da query para o agrupador

@sample	CRM010MtArr(cCodAgr,cCodNiv,cTypeAgr,cAliasAgr)
@param	ExpC - Codigo do Agrupador
		ExpC - Nivel do Agrupador
		ExpC - Tipo do Agrupador
		ExpC - Alias do Agrupador 
@return	ExpA - Array com o filtro SQL

@author		SI2901 - Cleyton F.Alves
@since		05/04/2015
@version	12
/*/
//-----------------------------------------------------------------------------
Static Function CRM010MTARR(cCodAgr,cCodNiv,cTypeAgr,cAliasAgr)

Local cCodPai		:= cCodNiv
Local aFilAux		:= {}
Local aFilters		:= {}
Local aGroupMark	:= {}
Local nZ			:= 0

AOM->(dbSetOrder(1))

While !Empty(cCodPai) .And. AOM->(dbSeek(xFilial("AOM")+cCodAgr+cCodPai))

	cXml  	:= AOM->AOM_FILXML
	cCodPai	:= AOM->AOM_NIVPAI
	aFilters:= {}
				
	If !Empty(cXml)

		aFilAux	:= CRMA580XTA(cXml)
						
		For nZ := 1 To Len(aFilAux)
			aAdd(aFilters,{ IIF(!Empty(aFilAux[nZ][8]),aFilAux[nZ][8],cAliasAgr)	,;
							aFilAux[nZ][1]										 	,;
							aFilAux[nZ][2]										 	,;
							aFilAux[nZ][3] 										 	,;
							aFilAux[nZ][11]										 	,;
							aFilAux[nZ][12]										 	,;
							AOM->AOM_CODNIV											,;
							AOM->AOM_NIVPAI											})
		Next nZ

	EndIf
					
	nPosGroup := aScan(aGroupMark,{|z| z[1]+z[2] == cCodAgr+cCodNiv})
					
	If nPosGroup == 0
		aAdd(aGroupMark,{cCodAgr,cCodNiv,cTypeAgr,cAliasAgr,{}})
		nPosGroup := Len(aGroupMark)
	EndIf
				
	aAdd(aGroupMark[nPosGroup,5],aFilters)

EndDo

Return(aGroupMark)

//-----------------------------------------------------------------------------
/*/{Protheus.doc} CRM010MtExp

Monta a expressão da query para o agrupador

@sample	CRM010MtExp(aXmlAux,cAliasPrin,aFrom,cCodAgrup,cCodNiv)

@param	Nenhum
@return	ExpC - String dos Agrupadores Selecionados.

@author		SI2901 - Cleyton F.Alves
@since		05/04/2015
@version	12
/*/
//-----------------------------------------------------------------------------
Static Function CRM010MTEXP(aXmlAgrup,cAliasPrin,aFrom,cCodAgrup)

Local nP         := 0
Local nQ         := 0
Local nR         := 0
Local nPos       := 0
Local nLenXmlAux := 0
Local aAreaAtu   := GetArea()
Local aAreaSX9   := SX9->(GetArea())
Local aXmlAux    := {}
Local cCodNiv    := ""
Local cTipoAgr   := ""
Local cFrom      := ""
Local cWhere     := ""
Local cWhereAux  := ""
Local cVarExec   := ""
Local lNovoOk    := .T.
Local cOperador  := IIf(Trim(Upper(TcGetDb())) $ "ORACLE,POSTGRES,DB2,INFMIX","||","+")
	

DbSelectArea("AON")	
AON->(DbSetOrder(1))

DbSelectArea("SX9")
SX9->(DbSetOrder(2))

For nP := 1 To Len(aXmlAgrup)
	
	For nQ := 1 To Len(aXmlAgrup[nP,5])
	
		cTipoAgr := aXmlAgrup[nP,3]
		
		aXmlAux := aClone(aXmlAgrup[nP,5,nQ])

		If cTipoAgr == "1"
	
			nLenXmlAux  := Len( aXmlAux )
			
			For nR := 1 To nLenXmlAux
		
				cCodNiv := aXmlAux[nR,7]
			
		
				lNovoOk := .T.		
				
				//Se o alias da expressão do agrupador for diferente
				//do alias principal significa que o filtro está sobre 
				//outra tabela. Então é preciso relacionar essa tabela para
				//o FROM da query principal, caso ela não esteja relacionada 
				If aXmlAux[nR,1] <> cAliasPrin
						
					If !Empty(aXmlAux[nR,5]) .And. !Empty(aXmlAux[nR,6]) 
							
						//Verifica se a tabela ja foi relacionada na query principal
						If aScan(aFrom,aXmlAux[nR,1]) == 0
							aAdd(aFrom,aXmlAux[nR,1])
							cFrom   += ", "+RetSqlName(aXmlAux[nR,1])+" "+aXmlAux[nR,1]+" " // ", SBM010 SBM "
							
							// Adiciona o campo FILIAL.  
							If Left(aXmlAux[nR,1],1) == "S" 
								cWhere += Substr(aXmlAux[nR,1],2,2) + "_FILIAL = '" + xFilial(aXmlAux[nR,1]) + "'"
								cWhere += " AND "
							Else
								cWhere += aXmlAux[nR,1]             + "_FILIAL = '" + xFilial(aXmlAux[nR,1]) + "'"
								cWhere += " AND "
							EndIf 	
							
						EndIf
			
						//Monta o relacionamento com base no arquivo SX9. 
						//Caso não exista o registro, a rotina não faz o relacionamento
						//e o resultado fica comprometido. Por isso a mensagem é importante.
						cWhere += AllTrim(aXmlAux[nR,5]) 
						cWhere += " = "
						cWhere += AllTrim(aXmlAux[nR,6])
						cWhere += " AND "
					Else
						Help( "  ",1,"MTA461AGRSX9" )//"Verifique o relacionamento das tabelas do agrupador"
						lNovoOk := .F.
					EndIf
				EndIf
			
				
				If lNovoOk
					cWhere += aXmlAux[nR,4]
					If nR < nLenXmlAux .Or. nQ < Len(aXmlAgrup[nP,5])
						cWhere += " AND "
					EndIf
				EndIf
		
				If aXmlAux[nR,1] == 'ADJ' .And. aScan(aFrom,'ADJ') == 0
					aAdd(aFrom,aXmlAux[nR,1])
					cFrom  += ' INNER JOIN ' + RetSqlName("ADJ") + ' ADJ ON AD1.AD1_NROPOR = ADJ.ADJ_NROPOR AND AD1.AD1_REVISA = ADJ.ADJ_REVISA '
				EndIf
			
			Next nR
		
		ElseIf cTipoAgr == "2" //agrupador fixo

			If AON->(dbSeek(xFilial("AON")+cCodAgrup+cCodNiv))
				
				//Retorna primeiro indice da tabela
				cVarExec := AON->AON_ENTIDA+"->(IndexKey(1))"
				cVarExec := &(cVarExec)
						
				//Remove o campo filial do indice
				If at("_FILIAL",cVarExec) > 0
					cVarExec := SubStr(cVarExec,(at("_FILIAL",cVarExec)+8),Len(cVarExec))
				EndIf
							
				//Monta a expressao campo da chave do indice = chave do agrupador
				If !Empty(cVarExec)
					cWhere   := " ("
					While AON->( !Eof()) .And. AON->(AON_FILIAL+AON_CODAGR+AON_CODNIV) == xFilial("AON")+cCodAgrup+cCodNiv
	
						cWhere += cVarExec+" = '"+AON->AON_CHAVE+"' OR "	
							
						AON->(dbSkip())
					EndDo
					cWhereAux := Left(cWhere,Len(cWhere)-3)
					cWhere    := iif(!Empty(cWhereAux),cWhereAux+") ",'')
					cWhere    := StrTran(cWhere,"+",cOperador)
								
				EndIf
			EndIf
		EndIf
	Next nQ	
Next nP

RestArea(aAreaSX9)
RestArea(aAreaAtu)

Return({cFrom,cWhere})

//------------------------------------------------------------------------------
/*/{Protheus.doc} CRM010AZF

Grava a consulta para funil de vendas

@sample	CRM010AZF(cCodPVendas,cItemAZF,cQuery,cWhere,cCodAgr,cCodNiv,cCodPai,cCodHie)
@param		Expc - Codigo da consulta
			Expc - Item da Consulta
			ExpC - Expressão Query
			ExpC - Filtro da Expressão Query
			ExpC - Codigo do Agrupador
			ExpC - Codigo do Nivel do Agrupador
			ExpC - Codigo Pai do Agrupador
			ExpC - Codigo da Hierarquia Selecionada
			ExpD - Data da Consulta
			ExpC - Hora da Consulta
@return		ExpL - True ou False da execução da consulta

@author		Cleyton F.Alves
@since		10/06/2015
@version	12
/*/
//------------------------------------------------------------------------------
Static Function CRM010AZF(cCodPVendas,cItemAZF,cQuery,cWhere,cCodAgr,cCodNiv,cCodPai,cCodHie,dDataConsult,cTimeConsult,aMarkUsers, nTVendP)

Local lRet			:= .F.
Local lSeek			:= .F.
Local cAliasRet		:= GetNextAlias()
Local nRegVal		:= 0
Local nX			:= 0
Local nZ			:= 0
Local nSize			:= 0
Local nLoop			:= 0
Local cTPessoa		:= ""
Local cOportun		:= ""
Local cRevisao		:= ""
Local cPropos		:= ""
Local cStaADY		:= ""
Local cAliasTmp		:= ""
Local cCodPap		:= ""
Local cVend			:= ""
Local cTeste		:= ""
Local cCodUser		:= CRMXCodUser()
Local nLenNodes		:= 0
Local cWhereVar		:= ""
Local cQueryVar		:= ""
Local cNewField		:= ""
Local cNewInit		:= ""
Local aFields	 	:= CRM010NEWF()
Local nCount		:= 0
Local nLinha		:= 0
Local nVendProc		:= 0
Local cWhrAD2		:= ""
Local cFilialAZS	:= xFilial("AZS")
Local cFilialAZF	:= xFilial("AZF")



AZS->( DBSetOrder( 1 ) )
SUM->( DBSetOrder( 1 ) )
SA1->( DBSetOrder( 1 ) )
SUS->( DBSetOrder( 1 ) )
AZF->( DBSetOrder( 2 ) )

nLenMrkUser := Len(aMarkUsers) 
ProcRegua( nTVendP )

AZS->( DbSetOrder(4) )

For nX := 1 To nLenMrkUser
	 
	nLenVend	 := Len(aMarkUsers[nX])
	
	cWhereVar	:= cWhere
	cWhrAD2  	:= ""
		
	For nZ := 1 To nLenVend
		
		nVendProc++	
		IncProc( STR0113 + AllTrim( Str( nVendProc ) ) + STR0114 + AllTrim( Str( nTVendP ) ) ) //"Estrutura de Negócio níveis processados: "##" de: "  	
				
		If nZ == 1
			cWhereVar += " AND (  "
		EndIf
		
		cWhrAD2 += " AD2.AD2_VEND = '" + aMarkUsers[nX][nZ] + "' OR "
		
		If nZ < nLenVend
			Loop
		Else
			cWhereVar += SubStr(cWhrAD2, 1, Len( cWhrAD2 ) - 4 ) 
			cWhereVar += " ) " 
		EndIf

		cWhereVar += " ORDER BY AD2_VEND "
		cQueryVar := cQuery + cWhereVar 
		
		If Select( cAliasRet ) > 0 
			(cAliasRet)->( DBCloseArea() ) 
		EndIf 
		
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryVar),cAliasRet,.T.,.T.)
								
		While (cAliasRet)->(!Eof())
			
			If ( AZS->( MSSeek( cFilialAZS + (cAliasRet)->AZF_VEND ) ) ) 
			
				
				cItemAZF := Soma1(cItemAZF)
				
				lSeek := AZF->( DBSeek(  cFilialAZF + cCodPVendas + (cAliasRet)->AZF_NROPOR +(cAliasRet)->AZF_REVISA ) )
				
				//------------------------------------------------------------------------------
				// Valida se o vendedor informado é diferente, pois pode haver compartilhamento
				// de oportunidade, nesse caso, tem que incluir o registro.
				//------------------------------------------------------------------------------
				If lSeek .And. AZF->AZF_VEND <> (cAliasRet)->AZF_VEND
					lSeek := .F.
				EndIf
				
				RecLock("AZF",!lSeek)
				
				AZF->AZF_FILIAL		:= cFilialAZF
				AZF->AZF_CODIGO		:= cCodPVendas
				AZF->AZF_ITEM		:= cItemAZF
				AZF->AZF_DESREL		:= _aParams[1]
				AZF->AZF_PROSPE		:= (cAliasRet)->AZF_PROSPE
				AZF->AZF_CODCLI		:= (cAliasRet)->AZF_CODCLI
				AZF->AZF_LOJPRO		:= (cAliasRet)->AZF_LOJPRO
				AZF->AZF_LOJCLI		:= (cAliasRet)->AZF_LOJCLI
				AZF->AZF_NROPOR		:= (cAliasRet)->AZF_NROPOR
				AZF->AZF_DTINI		:= StoD( (cAliasRet)->AZF_DTINI )
				AZF->AZF_DTFIM		:= StoD( (cAliasRet)->AZF_DTFIM )
				AZF->AZF_DTPFIM		:= StoD( (cAliasRet)->AZF_DTPFIM )
				AZF->AZF_DESCRI		:= (cAliasRet)->AZF_DESCRI
				AZF->AZF_FCS		:= (cAliasRet)->AZF_FCS
				AZF->AZF_STAAD1		:= (cAliasRet)->AZF_STAAD1
				AZF->AZF_FEELIN		:= (cAliasRet)->AZF_FEELIN
				AZF->AZF_PROVEN		:= (cAliasRet)->AZF_PROVEN
				AZF->AZF_STAGE		:= (cAliasRet)->AZF_STAGE
				AZF->AZF_VEND		:= (cAliasRet)->AZF_VEND
				AZF->AZF_PERC		:= (cAliasRet)->AZF_PERC
				AZF->AZF_REVISA		:= (cAliasRet)->AZF_REVISA
				AZF->AZF_PERC01		:= (cAliasRet)->AZF_PERC01
				AZF->AZF_PERC02		:= (cAliasRet)->AZF_PERC02
				AZF->AZF_DATA		:= dDataConsult
				AZF->AZF_HORA		:= cTimeConsult
				AZF->AZF_USER		:= cCodUser
				AZF->AZF_CODAGR 	:= cCodAgr
				AZF->AZF_CODNIV		:= cCodNiv
				AZF->AZF_PROPOS 	:= (cAliasRet)->AZF_PROPOS
				AZF->AZF_STAADY 	:= (cAliasRet)->AZF_STAADY
				AZF->AZF_CODSEG		:= CRM010SEGM("AZF_CODSEG")
				AZF->AZF_DESSEG		:= CRM010SEGM("AZF_DESSEG")
				AZF->AZF_CODUNI		:= CRM010UNID( (cAliasRet)->AZF_VEND )
				
				If !Empty (aFields)
					nSize := Len( aFields )
					For nLoop := 1 to nSize
						AZF->(FieldPut(FieldPos(aFields[nLoop,1] ),&(aFields[nLoop,2]) ))
					Next nLoop
				EndIf
				
				If !Empty( (cAliasRet)->AZF_PAPEL )
					If SUM->( MSSeek( xFilial("SUM") + (cAliasRet)->AZF_PAPEL ) )
						AZF->AZF_PAPEL := SUM->UM_DESC
					EndIf
				Else
					AZF->AZF_PAPEL	:= STR0057
				EndIf
				
				AZF->AZF_NIVPAI := cCodPai
				AZF->AZF_CODHIE := cCodHie
				
				If !Empty(AZF->AZF_CODCLI)
					
					If SA1->( MsSeek(xFilial( "SA1" ) + AZF->AZF_CODCLI + AZF->AZF_LOJCLI ) )
						cTPessoa := SA1->A1_TPESSOA
					Else
						cTPessoa := ""
					EndIf
					
				ElseIf !Empty(AZF->AZF_PROSPE)
					
					If SUS->( MsSeek(xFilial( "SUS" ) + AZF->AZF_CODCLI + AZF->AZF_LOJCLI ) )
						cTPessoa := SUS->US_SETPUB
					Else
						cTPessoa := ""
					EndIf
					
				EndIf
				
				AZF->AZF_PUBLIC := IIF( cTPessoa=="EP", "1","2" )
				
				AZF->( MsUnlock() )
				
				lRet := .T.
			
			EndIf
			
			(cAliasRet)->(DBSkip())
			
		EndDo

	Next nZ
			
Next nX

Return( lRet )

//------------------------------------------------------------------------------
/*/{Protheus.doc} CRM010NAMELD

Define um nome para consulta de previsao de vendas

@sample		Crm010nameLd
@Return		expC  - cGet

@author		Ronaldo Robes 	
@since		10/06/2015
@version	12
/*/
//------------------------------------------------------------------------------

Static Function CRM010Params()

	Local oDlgModal 	:= Nil
	Local oPanelMain	:= Nil
	Local oLayMain		:= Nil
	Local oDlgLayM		:= Nil
	Local oDlgLayP		:= Nil
	Local oGetDescr		:= Nil 
	Local oGetDtIni		:=  Nil
	Local oGetDtFim		:= Nil
	Local dDataIni		:= FirstDate( dDataBase )
	Local dDataFim		:= LastDate( dDataBase )  
	Local cGet			:= Space( TAMSX3("AZF_DESREL")[1] )
	Local lRet 			:= .F.
	
	oDlgModal := FWDialogModal():New()
	oDlgModal:SetTitle(STR0090)	//"Parâmetros"
	oDlgModal:SetBackground(.T.)				 
	oDlgModal:SetEscClose(.F.)
	oDlgModal:SetSize(130,160) 
	oDlgModal:EnableFormBar(.T.) 
	oDlgModal:CreateDialog()
	oDlgModal:SetCloseButton(.T.)
	oDlgModal:CreateFormBar()
	
	oDlgModal:AddButton(STR0076,{|| IIF( !Empty( cGet ), ( oDlgModal:DeActivate() , lRet := .T. ), ApMsgAlert(STR0091) ) },STR0076,,.T.,.F.,.T.)
	oDlgModal:AddButton(STR0092,{|| oDlgModal:DeActivate()  },STR0092,,.T.,.F.,.T.)//Cancelar
	
	oPanelMain := oDlgModal:GetPanelMain()
	
   	oLayMain := FWLayer():New()
  	oLayMain:Init( oPanelMain, .F. )
  	
  	oLayMain:AddLine( "LINE_DESCRI"	, 50, .T.)
  	oLayMain:AddLine( "LINE_PERIOD"	, 50, .T.)
  	
  	oLayMain:AddCollumn( "COL_DESCRI"	, 100, .T., "LINE_DESCRI" )
  	oLayMain:AddCollumn( "COL_PERIOD"	, 100, .T., "LINE_PERIOD" )
  	
  	oLayMain:AddWindow( "COL_DESCRI"	, "WIN_DESCRI", STR0079, 100, .F., .F.,,"LINE_DESCRI" )//Descrição
  	oLayMain:AddWindow( "COL_PERIOD"	, "WIN_PERIOD", STR0093, 100, .F., .F.,,"LINE_PERIOD" )//Periodo
   
 	oDlgLayD := oLayMain:GetWinPanel( "COL_DESCRI", "WIN_DESCRI", "LINE_DESCRI" )
  	@ 02,05 MSGET oGetDescr VAR cGet OF oDlgLayD SIZE 140,10 PICTURE "@!" PIXEL HASBUTTON 
  
 	oDlgLayP := oLayMain:GetWinPanel( "COL_PERIOD", "WIN_PERIOD", "LINE_PERIOD" )
 	
 	@ 05,05 SAY STR0094 OF oDlgLayP SIZE 10,10 PIXEL  //"De:"
 	@ 03,20 MSGET oGetDtIni VAR dDataIni OF oDlgLayP SIZE 54,10 PIXEL HASBUTTON  
 	
 	@ 05,75 SAY STR0095 OF oDlgLayP SIZE 20,10 PIXEL //"Ate:"
 	@ 03,92 MSGET oGetDtFim VAR dDataFim OF oDlgLayP SIZE 54,10 PIXEL HASBUTTON 
   
   oDlgModal:Activate() 
	
	_aParams := { Alltrim( cGet ), dDataIni, dDataFim }
		
Return( lRet ) 

//-------------------------------------------------------------------
/*/{Protheus.doc} CRMA010Init
Inicializador padrão dos campos de descrição da previsão de vendas. 

@param cTarget, caracter, Campo do tipo combo box. 
@param lForce, lógico, Indica se deve retornar o título independente da opção. 
@param lTitle, lógico, Indica se deve retornar o título a partir do campo código.. 
@return cTitle, caracter, Conteúdo a ser inicializado no campo informado. 

@author  Valdiney V GOMES
@version P12 
@since   15/12/2015  
/*/
//-------------------------------------------------------------------	
Function CRMA010Init( cField, lForce, lTitle )
	Local cTitle 	:= ""
	
	Default cField	:= ""
	Default lForce 	:= .F.
	Default lTitle 	:= .F.
	
	If ( ( ( Type( "INCLUI" ) == "L" ) .And. ! INCLUI ) .Or. lForce  )
		If ( cField == "AZF_DESPRO" .Or. ( cField == "AZF_PROVEN" .And. lTitle ) )	
			//-------------------------------------------------------------------
			// Processo de venda.  
			//-------------------------------------------------------------------
			cTitle := Posicione( "AC1", 1, xFilial("AC1") + AZF->AZF_PROVEN, "AC1_DESCRI" )
		ElseIf( cField == "AZF_DESEST" .Or. ( cField == "AZF_STAGE" .And. lTitle ) )
			//-------------------------------------------------------------------
			// Estágio de venda  
			//-------------------------------------------------------------------
			cTitle := Posicione( "AC2", 1, xFilial("AC1") + AZF->AZF_PROVEN + AZF->AZF_STAGE, "AC2_DESCRI" )
		ElseIf( cField == "AZF_DESFCS" .Or. ( cField == "AZF_FCS" .And. lTitle ) )
			//-------------------------------------------------------------------
			// Fator crítico de sucesso.  
			//-------------------------------------------------------------------
			cTitle := Posicione( "SX5", 1, xFilial("SX5") + "A6" + AZF->AZF_FCS, "X5DESCRI()")
		ElseIf( cField == "AZF_DESSTA" .Or. ( cField == "AZF_STAAD1" .And. lTitle ) )
			//-------------------------------------------------------------------
			// Status da oportunidade.  
			//-------------------------------------------------------------------
			cTitle := CRMA010Combo( "AD1_STATUS", AZF->AZF_STAAD1 )
		ElseIf( cField == "AZF_DESFEE" .Or. ( cField == "AZF_FEELIN" .And. lTitle ) )
			//-------------------------------------------------------------------
			// Chance de sucesso.  
			//-------------------------------------------------------------------
			cTitle := CRMA010Combo( "AD1_FEELIN", AZF->AZF_FEELIN )
		ElseIf( cField == "AZF_DESSET" .Or. ( cField == "AZF_PUBLIC" .And. lTitle ) )
			//-------------------------------------------------------------------
			// Recupera a descrição do setor público.  
			//-------------------------------------------------------------------
			cTitle := CRMA010Combo( "US_SETPUB", AZF->AZF_PUBLIC )
		ElseIf ( cField == "AZF_STAADY")                                                                                                    
			//-------------------------------------------------------------------
			// Recupera a descrição do status da proposta.  
			//-------------------------------------------------------------------
			cTitle := CRMA010Combo( "ADY_STATUS", AZF->AZF_STAADY )
		ElseIf ( cField == "AZF_ENTDES" .Or. ( cField == "AZF_ENTDES" .And. lTitle ) )
			//-------------------------------------------------------------------
			// Descrição da Entidade 
			//-------------------------------------------------------------------
			cTitle := CRM010SEGM("AZF_ENTDES")
		ElseIf (cField == "AZF_CODAGR" )
			//-------------------------------------------------------------------
			// Descrição do Agrupador 
			//-------------------------------------------------------------------
			cTitle := Posicione( "AOL", 1, xFilial("AOL") + AZF->AZF_CODAGR, "AOL_RESUMO" )
		
		ElseIf (cField == "AZF_DESNIV" )
			//-------------------------------------------------------------------
			// Descrição do Nível 
			//-------------------------------------------------------------------
			cTitle := Posicione( "AOM", 1, xFilial("AOM") + AZF->AZF_CODAGR + AZF->AZF_CODNIV, "AOM_DESCRI" )
		
		EndIf 
	
	
	EndIf 
Return cTitle  	

//-------------------------------------------------------------------
/*/{Protheus.doc} CRMA010Combo
Recupera o título de um item informado em um combo box. 

@param cField, caracter, Campo do tipo combo box. 
@param nValue, numérico, Opção da qual será retornada o título da opção. 
@return cTitle, caracter, Título da opção informada. 

@author  Valdiney V GOMES
@version P12 
@since   15/12/2015  
/*/
//-------------------------------------------------------------------
Function CRMA010Combo( cField, cValue )
	Local aArea		:= SX3->( GetArea() )
	Local aValue	:= {}
	Local aOption  	:= {} 
	Local cTitle	:= ""
	Local nOption 	:= 1	       

	Default cField	:= ""
	Default cValue	:= ""
	      
	//-------------------------------------------------------------------
	// Localiza o campo no dicionário.  
	//-------------------------------------------------------------------		
	SX3->( DBSetOrder( 2 ) )  
	
	If ( SX3->( DBSeek( cField ) ) ) 
		//-------------------------------------------------------------------
		// Recupera as opções do campo.  
		//-------------------------------------------------------------------	 
		aOption := Str2Arr( X3CBox(), ";" )
	
		If ! ( Empty( aOption ) )
			For nOption  := 1 To Len( aOption )
				//-------------------------------------------------------------------
				// Recupera o índice o e valor de cada opção.  
				//-------------------------------------------------------------------	
				aValue := Str2Arr( aOption[nOption], "=", .F. )
				
				//-------------------------------------------------------------------
				// Recupera o título da opção informada.  
				//-------------------------------------------------------------------				
				If ( aValue[1] == cValue )
					cTitle := AllTrim( aValue[2] )
					Exit
				EndIf 
			Next	
		EndIf  
	EndIf	
	
	SX3->( RestArea( aArea ) )
return cTitle

//-------------------------------------------------------------------
/*/{Protheus.doc} CRM010CNum
Gera codigo sequencial da consulta

@param cAlias, caracter, Alias da tabela 
@param cCampo, caracter, Campo que sera controlado a numeração.
@author  Anderson Silva
@version P12 
@since   15/12/2015  
/*/
//-------------------------------------------------------------------
Static Function CRM010CNum( cAlias, cCampo )

Local aArea		:= GetArea()    				
Local cNumAux	:= ""
Local cMay 		:= ""


If !Empty( cAlias ) .And. !Empty( cCampo ) 

	cNumAux	:= GetSxeNum( cAlias, cCampo ) 	
	cMay 	:= cAlias + AllTrim( xFilial( cAlias ) ) + cNumAux
	
	DbSelectArea( cAlias )
	(cAlias)->( DBSetOrder( 1 ) )
	While ( (cAlias)->( DbSeek( xFilial( cAlias ) + cNumAux ) .Or. !MayIUseCode( cMay ) ) )
		cNumAux	:= GetSxeNum( cAlias, cCampo ) 	
		cMay 		:= cAlias + AllTrim( xFilial( cAlias ) ) + cNumAux
	End 
EndIf

// Confirma o codigo da lista
If __lSX8
	(cAlias)->( ConfirmSX8() )
Endif

RestArea(aArea)
Return( cNumAux )

//-------------------------------------------------------------------
/*/{Protheus.doc} CRM010NEWF
Retorna os campos de usuário do tipo real, para serem populados
em tempo de execução da consulta de previsão de vendas.

Também permite carregar o valor de campos virtuais nos relatórios
chamado pelo fonte CRMA010B.

O Campo deve possuir um inicializador, ou não será carregado.
@Param nOper, Numerico, Tipo da operação 1 - Usuário / 2 - Virtuais

@Return aFields, Array contendo os campos customizados Reais
@author Renato da Cunha
@version P12 
@since   10/08/2016  
/*/
//-------------------------------------------------------------------
Function CRM010NEWF( nOper )

Local aAreaSX3 	:= SX3->(GetArea())
Local aFields	:= {}
Local cField	:= ""
Local cInipad	:= "" 

Default nOper	:= 1 

SX3->(DbSetOrder(1)) //X3_ARQUIVO+X3_ORDEM


If SX3->(dbSeek("AZF"))
	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "AZF" 
		
	Do Case
		Case nOper == 1 
			IF SX3->X3_ARQUIVO == "AZF" .AND. SX3->X3_PROPRI == "U" .AND. SX3->X3_CONTEXT == "R"
				cField 	:= SX3->X3_CAMPO
				cInipad	:= SX3->X3_RELACAO
		
			EndIf
		
		Case nOper == 2 
			If  SX3->X3_ARQUIVO == "AZF" .AND. SX3->X3_PROPRI == "U"  .And. SX3->X3_CONTEXT == "V"
				cField 	:= SX3->X3_CAMPO
				cInipad	:= AllTrim(SX3->X3_INIBRW)
			EndIf 
		
	EndCase
	
	If !Empty (cField) .And. !Empty (cInipad)
		aAdd(aFields, {cField,cInipad})
	EndIf
		
		SX3->(dbSkip())
	EndDo
EndIf		
RestArea( aAreaSX3 ) 
Return( aFields )

//-------------------------------------------------------------------
/*/{Protheus.doc} CRM010UNID
Função para retornar a unidade de negócio do vendedor, de acordo com a 
prioridade de busca do parametro MV_CRMESTR.

@Param cSalesman, Caracter, código do vendedor

@Return cUnity, Caracter, código da unidade de negócio do vendedor
@author Renato da Cunha
@version P12 
@since   11/09/2016  
/*/
//-------------------------------------------------------------------

Static Function CRM010UNID ( cSalesman )

Local aXArea	:= {}
Local cTpStruc	:= SuperGetMv("MV_CRMESTR",.F.,"1") //1-AO3 / 2-Vendedor / 3-Papel
Local cUnity	:= ""

Default cSalesman := ""

iF !Empty( cSalesman )	
	
	Do Case
		Case cTpStruc == "1"
			
			aXArea := AO3->( GetArea() )
			AO3->( DbSetOrder( 2 ) ) //AO3_FILIAL+AO3_VEND
			
			If AO3->( DbSeek(xFilial("AO3")+cSalesman) )
				cUnity := AO3->AO3_CODUND
			EndIf
			
		Case cTpStruc == "2"
			
			aXArea := SA3->( GetArea() )
			SA3->( DbSetOrder( 1 ) ) // A3_FILIAL+A3_COD
			
			If SA3->( DbSeek(xFilial("SA3")+cSalesman) )
				cUnity := SA3->A3_UNIDAD
			EndIf
			
		Case cTpStruc == "3"
		
			aXArea := AZS->( GetArea() )
			AZS->( DbSetOrder( 4 ) ) // AZS_FILIAL+AZS_VEND
			
			If AZS->( DbSeek(xFilial("AZS")+cSalesman) )
				cUnity := AZS->AZS_CODUND
			EndIf
			
	End Case
	
	IF !Empty( aXArea )
		RestArea( aXArea )
	EndIf

EndIf 
Return( cUnity )

//-------------------------------------------------------------------
/*/{Protheus.doc} CRM010LdLv
Função para retornar se o nivel do agrupador possui filhos.

@Param cCodAgr, Caracter, código do agrupador
@Param cCodNiv, Caracter, código do nível atual do agrupador

@Return lRet, Lógico, .T. se o nível atual possui filhos

@author Renato da Cunha
@version P12 
@since   21/09/2016  
/*/
//-------------------------------------------------------------------
Static Function CRM010LdLv( cCodAgr, cCodNiv  )
Local lRet		:= .F.
Local aAreaAOM 	:= AOM->( GetArea() )

Default cCodAgr	:= ""
Default cCodNiv	:= ""

DbSelectArea("AOM")
AOM->( DbSetOrder(3) ) //AOM_FILIAL+AOM_CODAGR+AOM_NIVPAI

If DbSeek( xFilial( "AOM" ) + cCodAgr + cCodNiv )
	lRet := .T.
EndIf

RestArea( aAreaAOM )

Return( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} Crm010Mark
Função para marcar/desmarcar os filhos de um nível do agrupador

@Param oTree, Objeto, Objeto que contém a arvore
@Param oMdlAOMGrid, Objeto, Objeto com dados do grid do Agrupador
@Param cCodNiv, Caracter, Código do nível atual(pai)
@param lUnmark, lógico, Informa se a chamada da função deve desmarcar filhos

@Return Nil

@author Renato da Cunha
@version P12 
@since   21/09/2016  
/*/
//-------------------------------------------------------------------
Static Function Crm010Mark( oTree, oMdlAOMGrid, cCodNiv, lUnmark )

Local nLength	:= 0
Local nLinAtu	:= ""

Default oMdlAOMGrid := NIL
Default cCodNiv		:= ""
Default lUnmark		:= .F.

If !Empty( oMdlAOMGrid ) .And. !Empty( cCodNiv ) .And. !Empty( oTree )	
	 
	nLinAtu	:= oMdlAOMGrid:GetLine()
	
	For nLength := 1 to oMdlAOMGrid:Length()
		oMdlAOMGrid:GoLine( nLength )
		
		If oMdlAOMGrid:GetValue("AOM_NIVPAI") == cCodNiv
			
			If !lUnmark
				If !oMdlAOMGrid:GetValue("AOM_MARK")
					oTree:ChangeBmp("LBOK","LBOK",,,oMdlAOMGrid:GetValue("AOM_CODNIV"))
					oMdlAOMGrid:SetValue("AOM_MARK",.T.)
				EndIF  
			Else
				oTree:ChangeBmp("LBNO","LBNO",,,oMdlAOMGrid:GetValue("AOM_CODNIV"))
				oMdlAOMGrid:SetValue("AOM_MARK",.F.)
			EndIf			
		EndIf	
	Next nLength

	oMdlAOMGrid:GoLine(nLinAtu)

EndIf
Return Nil 
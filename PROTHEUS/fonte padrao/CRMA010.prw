#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWBROWSE.CH"
#INCLUDE "DBTREE.CH"
#INCLUDE "FWEVENTVIEWCONSTS.CH"
#INCLUDE "CRMA010.CH"

Static cCodConsulta := ""
 	
//------------------------------------------------------------------------------
/*/{Protheus.doc} CRMA010()  

Forecast - Previsão de Vendas

@sample		CRMA010()
@param		Nenhum     
@return		Nenhum

@author		Ronaldo Robes
@since		12/05/2015
@version	12.1.7
/*/
//------------------------------------------------------------------------------
Function CRMA010()

Local aButtons := Nil

DbSelectArea("AZF")
AZF->( DbSetOrder(1) )

aButtons := { {.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},;
			  {.F.,Nil},{.F.,Nil},{.T.,"Sair"},{.F.,Nil},{.F.,Nil},;
			  {.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}

FWExecView(STR0033,'CRMA010', MODEL_OPERATION_UPDATE,,{||.T.},,,aButtons) //'Previsão de Vendas'
	
Return Nil

//------------------------------------------------------------------------------
/*/{Protheus.doc} CRMA010()

Rotina de carga da interface do Forecast

@sample		ModelDef()
@param		Nenhum
@return     Nenhum

@author		Ronaldo Robes
@since		12/05/2015
@version	12.1.7
/*/
//------------------------------------------------------------------------------
Static Function ModelDef()

Local oStrCAB	:= FWFormModelStruct():New()	
Local oStrAZF	:= FWFormModelStruct():New() 

Local oModel	:= Nil
Local bCarga	:= {|| {xFilial("AZF") }}

oStrCAB:AddField("","","CABEC_FILIAL"	,"C",FwSizeFilial()			,0						)
oStrAZF:AddField("","","AZF_MARK"		,"L", 1 ,0,{ |oMdlAZF|  CRM010AZFMark(oMdlAZF)},Nil,Nil,Nil,Nil,Nil,Nil,.T.)
oStrAZF:AddField("","","AZF_FILIAL"		,"C",FwSizeFilial()			,0						)
oStrAZF:AddField("","","AZF_CODIGO"		,"C",TamSX3("AZF_CODIGO")[1],TamSX3("AZF_CODIGO")[2])
oStrAZF:AddField("","","AZF_DESREL"		,"C",TamSX3("AZF_DESREL")[1],TamSX3("AZF_DESREL")[2])
oStrAZF:AddField("","","AZF_DATA"  		,"D",TamSX3("AZF_DATA")[1]	,TamSX3("AZF_DATA")[2]	)
oStrAZF:AddField("","","AZF_HORA"  		,"C",TamSX3("AZF_HORA")[1]	,TamSX3("AZF_HORA")[2]	)
oStrAZF:AddField("","","AZF_USER"  		,"C",TamSX3("AZF_USER")[1]	,TamSX3("AZF_USER")[2]	)
oStrAZF:AddField("","","AZF_NOMUSU"  	,GetSx3Cache("AZF_NOMUSU","X3_TIPO"),TamSX3("AZF_NOMUSU")[1],TamSX3("AZF_NOMUSU")[2])

oModel := MPFormModel():New("CRMA010",/*bPreValidacao*/,/*bPosVldMdl*/,/*bCommitMdl*/,/*bCancel*/)
oModel:AddFields("CABMASTER",/*cOwner*/,oStrCAB,/*bPreValidacao*/,/*bPosVldMdl*/,bCarga)
oModel:AddGrid("AZFDETAIL" ,"CABMASTER",oStrAZF,/*bPreValid*/    ,/*bPosVldMdl*/,/*bLoad*/)

oModel:SetRelation("AZFDETAIL",{{"CABEC_FILIAL","AZF_FILIAL"}},AZF->(IndexKey(1)))

oModel:SetPrimaryKey({""})

oModel:GetModel("AZFDETAIL"):bLoad := { |oMdlAZF| CRM010AZF(oMdlAZF)}
oModel:GetModel("AZFDETAIL"):SetOptional(.T.)
oModel:GetModel("AZFDETAIL"):SetOnlyQuery(.T.)

oModel:GetModel('AZFDETAIL'):SetNoInsertLine(.T.)
oModel:GetModel('AZFDETAIL'):SetNoDeleteLine(.T.)
oModel:GetModel('AZFDETAIL'):SetNoUpdateLine(.F.)

oModel:SetDescription(STR0034) //"Painel de Vendas"
oModel:GetModel('AZFDETAIL'):SetDescription(STR0034)//"Painel de Vendas"
oModel:GetModel('CABMASTER'):SetDescription(STR0034)//"Painel de Vendas"

	
Return oModel

//------------------------------------------------------------------------------
/*/{Protheus.doc} ViewDef()

Formulário de Interface do Forecast - Previsão de Vendas

@sample		ViewDef()
@param		Nenhum
@return		Nenhum

@author		Ronaldo Robes
@since		12/05/2015
@version	12.1.7
/*/
//------------------------------------------------------------------------------
Static Function ViewDef()
	
Local oView		:= Nil
Local oStrAZF	:= FWFormViewStruct():New()
Local oModel	:= FWLoadModel('CRMA010')

oStrAZF:SetProperty("*",MVC_VIEW_CANCHANGE,.F.)


oStrAZF:AddField("AZF_MARK" ,"01","","",{},"L","@BMP",Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,.T.)//"MARK"	
oStrAZF:AddField("AZF_CODIGO","03",STR0040,STR0040,{},"C","",Nil,Nil,.F.,Nil,Nil,Nil,Nil,Nil,.T.)//"CODIGO"
oStrAZF:AddField("AZF_DESREL","04",STR0078,STR0078,{},"C","",Nil,Nil,.F.,Nil,Nil,Nil,Nil,Nil,.T.)
oStrAZF:AddField("AZF_DATA"  ,"05",STR0041,STR0041,{},"D","",Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,.T.)//"Data"
oStrAZF:AddField("AZF_HORA"  ,"06",STR0042,STR0042,{},"C","",Nil,Nil,.F.,Nil,Nil,Nil,Nil,Nil,.T.)//"Hora"
oStrAZF:AddField("AZF_USER"  ,"07",STR0043,STR0043,{},"C","",Nil,Nil,.F.,Nil,Nil,Nil,Nil,Nil,.T.)//"Usuário"
oStrAZF:AddField("AZF_NOMUSU","08",STR0044,STR0044,{},GetSx3Cache("AZF_NOMUSU","X3_TIPO"),"",Nil,Nil,.F.,Nil,Nil,Nil,Nil,Nil,.T.)//"Nome"

oView := FWFormView():New()
oView:SetModel(oModel)
oView:AddGrid('VIEW_AZF',oStrAZF,'AZFDETAIL')

oView:CreateHorizontalBox('CORPO',100)
oView:SetOwnerView('VIEW_AZF','CORPO')
oView:EnableTitleView('VIEW_AZF', STR0035) //'Histórico de Consultas'

oView:AddUserButton(STR0036,STR0037,{|oView|CRMA010C(oView)}) 							//'Novo'# '+Novo'
oView:AddUserButton(STR0038,STR0038,{|oView|CRMA010B(cCodConsulta)}) 				//Visualizar 
oView:AddUserButton(STR0039,STR0039,{|oView|CRMA010DEL(oView:GetModel(),oView,cCodConsulta)}) 	//Excluir

Return oView

//------------------------------------------------------------------------------
/*/{Protheus.doc} MenuDef

Monta menu da interface da rotina

@sample		MenuDef
@param		Nenhum
@return		ExpA - Array com o menu das rotinas.

@author		Ronaldo Robes
@since		12/05/2015
@version	12.1.7
/*/
//------------------------------------------------------------------------------
Static Function MenuDef()
	
Local aRotina := {}
	
ADD OPTION aRotina TITLE STR0036 ACTION "CRMA010C" OPERATION 4 ACCESS 0 //"Novo"
ADD OPTION aRotina TITLE STR0038 ACTION "CRMA010B" OPERATION 4 ACCESS 0 //"Visualizar"

Return aRotina

//-----------------------------------------------------------------------------
/*/{Protheus.doc} 
Carga de dados da Grid de visulização.

@sample		CRM010AZF(oMdlAZF)

@param		ExoO - oMdlAZF - Objeto do modelo de dados atual.
@return		ExpA - Retorna Array com a carga do model

@author		SI2901 - Cleyton F.Alves
@since		10/06/2015
@version	12.1.7
/*/
//-----------------------------------------------------------------------------
 Function CRM010AZF(oMdlAZF)

Local aLoadAZF   := {}
Local oStructAZF := oMdlAZF:GetStruct()
Local aCampos    := oStructAZF:GetFields()
Local cAliasAZF  := GetNextAlias()
Local cQuery     := ""
Local nX		 := 0
Local nY		 := 0
Local cMacro     := ""
Local cCodUsr	 := CRMXCodUser()

AZF->(dbSetOrder(1))

BeginSQL Alias cAliasAZF

SELECT 	DISTINCT 
		AZF_FILIAL,
		AZF_CODIGO,
		AZF_DATA,
		AZF_HORA,
		AZF_USER,
		AZF_DESREL
FROM 	%Table:AZF% AZF 
WHERE 	AZF.AZF_FILIAL = %xFilial:AZF% 	AND 
		AZF.AZF_USER = %Exp:cCodUsr% AND 
		AZF.%NotDel%
ORDER BY AZF_FILIAL,
		 AZF_DATA,
		 AZF_HORA

EndSql

While (cAliasAZF)->(!Eof())

	nX++
	aAdd(aLoadAZF,{ nX , {} })
	
	If nX == 1
		cCodConsulta := (cAliasAZF)->AZF_CODIGO
	EndIf 	
				
	For nY := 1 To Len(aCampos)	
		
		If AllTrim(aCampos[nY,MODEL_FIELD_IDFIELD]) == "AZF_FILIAL"
			aAdd(aLoadAZF[nx,2] , (cAliasAZF)->AZF_FILIAL )
		elseIf AllTrim(aCampos[nY,MODEL_FIELD_IDFIELD]) == "AZF_MARK"
			aAdd(aLoadAZF[nx,2] , Iif(nX==1,.T.,.F.) )
	    ElseIf AllTrim(aCampos[nY,MODEL_FIELD_IDFIELD]) == "AZF_CODIGO"
			aAdd(aLoadAZF[nx,2] , (cAliasAZF)->AZF_CODIGO )
	    ElseIf AllTrim(aCampos[nY,MODEL_FIELD_IDFIELD]) == "AZF_DATA"
			aAdd(aLoadAZF[nx,2] , substr((cAliasAZF)->AZF_DATA,7,2)+'/'+ substr((cAliasAZF)->AZF_DATA,5,2)+'/'+ substr((cAliasAZF)->AZF_DATA,1,4) )
	    ElseIf AllTrim(aCampos[nY,MODEL_FIELD_IDFIELD]) == "AZF_HORA"
			aAdd(aLoadAZF[nx,2] , (cAliasAZF)->AZF_HORA )
	    ElseIf AllTrim(aCampos[nY,MODEL_FIELD_IDFIELD]) == "AZF_USER"
			aAdd(aLoadAZF[nx,2] , (cAliasAZF)->AZF_USER )
	    ElseIf AllTrim(aCampos[nY,MODEL_FIELD_IDFIELD]) == "AZF_NOMUSU"
			aAdd(aLoadAZF[nx,2] , UsrRetName((cAliasAZF)->AZF_USER ) )
	    ElseIf AllTrim(aCampos[nY,MODEL_FIELD_IDFIELD]) == "AZF_DESREL"
			aAdd(aLoadAZF[nx,2] , (cAliasAZF)->AZF_DESREL )
		EndIf
	
	Next nY

	(cAliasAZF)->(dbSkip())
EndDo	

(cAliasAZF)->(dbCloseArea())

Return(aLoadAZF)

//------------------------------------------------------------------------------
/*/{Protheus.doc} CRMA010DEL
Deleção fisica do registro deletado na grid.

@sample		CRMA010DEL()
@param		Exp1 - Modelo ativo 
			Exp2 - Formulário Ativo
@return		Nenhum

@author		SI2901 - Cleyton F.Alves
@since		11/03/2015
@version	12.1.7
/*/
//------------------------------------------------------------------------------
Function CRMA010DEL(oModelAtu,oView,cCodConsulta)

Local nCount := 0
Local oMdlAFZ := oModelAtu:GetModel( "AZFDETAIL" )

AZF->(DbSetOrder(1))
AZF->(DbSeek(xFilial("AZF")+cCodConsulta))

If MsgYesNo(STR0068) //"Confirma a exclusão?"
	
	// O grid da AZF é sumarizado, necessário garantir a deleção dos demais registros
	While ADZ->( !Eof() ) .And. AZF->(AZF_FILIAL+AZF_CODIGO) == xFilial("AZF")+cCodConsulta
		RecLock("AZF",.F.)
		DbDelete()
		MsUnLock()
		AZF->(dbSkip())
	EndDo
	
EndIf

oMdlAFZ:SetNoDeleteLine( .F. )

For nCount := 1 To oMdlAFZ:Length()
	If oMdlAFZ:GetValue( "AZF_MARK" )
		oMdlAFZ:DeleteLine()
	EndIf
Next( nCount )

oMdlAFZ:SetNoDeleteLine( .T. )

oView:Refresh()

Return Nil

//-----------------------------------------------------------------------------
/*/{Protheus.doc} CRM010AZFMark

Controla o campo AOL_MARK do GRID AOL para permitir apenas uma linha marcada.

@sample	CRMAOLMark(oMdlAOL)

@param		ExpO - Objeto do modelo de dados atual.
@return		ExpL - verdadeiro

@author	Cleyton F.Alves
@since		10/06/2015
@version	12
/*/
//------------------------------------------------------------------------------

Static Function CRM010AZFMark(oMdlAtivo)

Local oView		:= FwViewActive()
Local oMdlAZF	:= oMdlAtivo:GetModel("AZFDETAIL")
Local nLinAtu	:= oMdlAtivo:GetLine()  
Local lMark	 	:= oMdlAtivo:GetValue("AZF_MARK")
Local nX		:= 0

For nX := 1 To oMdlAtivo:Length()
	oMdlAtivo:GoLine(nX)
	oMdlAtivo:LoadValue("AZF_MARK",.F.)
Next nX

oMdlAtivo:GoLine(nLinAtu)
oMdlAtivo:LoadValue("AZF_MARK",.T.)

cFilConsulta := oMdlAtivo:GetValue("AZF_FILIAL")
cCodConsulta := oMdlAtivo:GetValue("AZF_CODIGO")

oView:Refresh()

Return .T.


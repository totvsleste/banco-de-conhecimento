#INCLUDE 'PROTHEUS.CH'
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWEVENTVIEWCONSTS.CH"
#INCLUDE "FWBROWSE.CH"
#INCLUDE "CRMA010.CH"

//------------------------------------------------------------------------------
/*/{Protheus.doc} CRMA010D  

Rotina que faz a chamada para o cadastro da hierarquia de cargos

@sample		CRMA010D()
@param 		Nenhum
@return		Nenhum

@author		Cleyton F.Alves
@since		30/07/2015
@version	12.1.6
/*/
//------------------------------------------------------------------------------

Function CRMA010D()

Local oBrowse		:= Nil
Private lMsErroAuto := .F.
Default uRotAuto 	:= Nil
Default nOpcAuto 	:= Nil

DbSelectArea("AZC")
AZC->(DbSetOrder(1))

DbSelectArea("AZD")
AZD->(DbSetOrder(1))

DbSelectArea("AZE")
AZE->(DbSetOrder(1))

oBrowse := FWMBrowse():New()
oBrowse:SetAlias('AZC')
oBrowse:SetDescription(STR0054) //"Cadastro de hierarquia de cargos"
oBrowse:Activate()

Return nil

//------------------------------------------------------------------------------
/*/{Protheus.doc} MenuDef 

Funcao de chamada do menu.

@sample		MenuDef()
@param 		Nenhum
@return		ExpA - Array com a chamada dos fontes pelos botôes

@author		Cleyton F.Alves
@since		30/07/2015
@version	12.1.6
/*/
//------------------------------------------------------------------------------
Static Function MENUDEF()

Local aRotina := FWMVCMENU("CRMA010D")

Return(aRotina)

//------------------------------------------------------------------------------
/*/{Protheus.doc} ModelDef 

Carrega o modelo de dados para a função.

@sample		ModelDef()
@param 		Nenhum
@return		ExpO - Modelo de Dados

@author		Cleyton F.Alves
@since		30/07/2015
@version	12.1.6
/*/
//------------------------------------------------------------------------------
Static Function MODELDEF()

Local oStrAZC	:= FWFormStruct(1,'AZC')
Local oStrAZD	:= FWFormStruct(1,'AZD')
Local oStrAZE	:= FWFormStruct(1,'AZE')
Local oModel	:= Nil

oModel := MPFormModel():New('CRMA010D',/*bPreValidacao*/,/*bPosVldMdl*/,/*bCommitMdl*/,/*bCancel*/)

oModel:AddFields('AZCMASTER', /*cOwner*/, oStrAZC, /*bPreValidaadmicao*/, /*bPosValidacao*/, /*bCarga*/ )
oModel:AddGrid('AZDDETAIL','AZCMASTER',oStrAZD, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )
oModel:AddGrid('AZEDETAIL','AZDDETAIL',oStrAZE, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )

//relacionamentos
oModel:SetRelation('AZDDETAIL',{{"AZD_FILIAL","xFilial('AZD')"},{"AZD_CODIGO", "AZC_CODIGO" }},AZD->(IndexKey(1)))
oModel:SetRelation('AZEDETAIL',{{"AZE_FILIAL","xFilial('AZE')"},{"AZE_CODIGO", "AZC_CODIGO" },{"AZE_NIVEL", "AZD_NIVEL" }},AZE->(IndexKey(1)))

oModel:SetDescription(STR0054)//"Hierarquia de Cargos"

oModel:GetModel("AZDDETAIL"):SetOptional(.T.)

oModel:GetModel("AZEDETAIL"):SetOptional(.T.)
oModel:GetModel("AZEDETAIL"):SetUniqueLine({'AZE_CODCAR'})

oModel:GetModel('AZCMASTER'):SetDescription(STR0054)//"Hierarquia de Cargos" 
oModel:GetModel('AZDDETAIL'):SetDescription(STR0065)//"Niveis da Hierarquia" 
oModel:GetModel('AZEDETAIL'):SetDescription(STR0066)//"Cargos do Nível" 

Return oModel

//------------------------------------------------------------------------------
/*/{Protheus.doc} ViewDef 

Carrega a view de interação do usuário

@sample		ViewDef()
@param 		Nenhum
@return		ExpO - Formulario

@author		Cleyton F.Alves
@since		30/07/2015
@version	12.1.6
/*/
//------------------------------------------------------------------------------
Static Function VIEWDEF()

Local oModel  := FWLoadModel('CRMA010D')
Local oStrAZC := FWFormStruct(2,'AZC')
Local oStrAZD := FWFormStruct(2,'AZD') 
Local oStrAZE := FWFormStruct(2,'AZE')
Local oView   := Nil
Local cCampos := {}

oView := FWFormView():New()
oView:SetModel( oModel )

oView:AddField('VIEW_AZC',oStrAZC,'AZCMASTER')
oView:AddGRID( 'GRID_AZD',oStrAZD,'AZDDETAIL') 
oView:AddGRID( 'GRID_AZE',oStrAZE,'AZEDETAIL')

oView:CreateHorizontalBox('CABEC'  , 15)
oView:CreateHorizontalBox('MEIO'   , 45 )
oView:CreateHorizontalBox('DETALHE', 40 )
 
oView:SetOwnerView('VIEW_AZC','CABEC'	)
oView:SetOwnerView('GRID_AZD','MEIO'	)
oView:SetOwnerView('GRID_AZE','DETALHE'	)

oStrAZC:RemoveField('AZC_FILIAL')

oStrAZD:RemoveField('AZD_FILIAL')
oStrAZD:RemoveField('AZD_CODIGO')

oStrAZE:RemoveField('AZE_FILIAL')
oStrAZE:RemoveField('AZE_CODIGO')
oStrAZE:RemoveField('AZE_NIVEL')

oView:AddIncrementField('GRID_AZD','AZD_NIVEL' )

Return oView

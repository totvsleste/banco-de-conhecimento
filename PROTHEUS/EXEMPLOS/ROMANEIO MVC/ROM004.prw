#INCLUDE "TOTVS.CH"
#INCLUDE 'FWMVCDEF.CH'

User Function ROM004()

	Local oBrowse
	Private cCadastro := "Nota Fiscal de Saida"

	Private n_RecAdto	:= 0

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('SF2')
	oBrowse:SetDescription('Notas Fiscais de Saida')

	oBrowse:Activate()

Return()

//--------------------------------------------------------------------------------------------------------
Static Function MenuDef()

	Local a_Rotina := {}

	ADD OPTION a_Rotina Title 'Visualizar'  Action 'VIEWDEF.ROM004'	OPERATION 1 ACCESS 0

Return( a_Rotina )

//--------------------------------------------------------------------------------------------------------
Static Function ModelDef()

	Local o_StrSF2	:= FWFormStruct( 1, 'SF2' )

	Private oModel	:= MPFormModel():New('ROM004M',/*bPre*/,/*bPost*/,/*bCommit*/,/*bCancel*/)

	oModel:AddFields('SF2MASTER',/*cOwner*/,o_StrSF2)
	oModel:GetModel('SF2MASTER'):SetDescription('Notas Fiscais')

Return oModel

Static Function ViewDef()

	Local oView		:= FWFormView():New()
	Local oModel	:= FWLoadModel('ROM004')

	Local o_StrSF2	:= FWFormStruct( 2, 'SF2' )

	oView:SetModel(oModel)

	oView:CreateHorizontalBox('CABEC',100)
	oView:AddField('SF2VIEW',o_StrSF2,'SF2MASTER')
	oView:EnableTitleView('SF2VIEW','Notas Fiscais')
	oView:SetOwnerView('SF2VIEW','CABEC')

Return oView
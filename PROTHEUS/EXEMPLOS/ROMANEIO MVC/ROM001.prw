#INCLUDE "TOTVS.CH"
#INCLUDE 'FWMVCDEF.CH'

User Function ROM001()

	Local oBrowse
	Private cCadastro := "Romaneios"

	Private n_RecAdto	:= 0

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('SZ0')
	oBrowse:SetDescription('Romaneios')

	oBrowse:Activate()

Return()

//--------------------------------------------------------------------------------------------------------
Static Function MenuDef()

	Local a_Rotina := {}

	ADD OPTION a_Rotina Title 'Visualizar'  Action 'VIEWDEF.ROM001'	OPERATION 1 ACCESS 0
	ADD OPTION a_Rotina Title 'Incluir' 	Action 'VIEWDEF.ROM001'	OPERATION 3 ACCESS 0
	ADD OPTION a_Rotina Title 'Alterar' 	Action 'VIEWDEF.ROM001'	OPERATION 4 ACCESS 0
	ADD OPTION a_Rotina Title 'Excluir' 	Action 'VIEWDEF.ROM001'	OPERATION 5 ACCESS 0

Return( a_Rotina )

//--------------------------------------------------------------------------------------------------------
Static Function ModelDef()

	Local o_StrSZ0	:= FWFormStruct( 1, 'SZ0' )
	Local o_StrSZ1	:= FWFormStruct( 1, 'SZ1' )
	Local o_StrSZ2	:= FWFormStruct( 1, 'SZ2' )
	Local o_StrSZ3	:= FWFormStruct( 1, 'SZ3' )

	Private oModel	:= MPFormModel():New('ROM001M',/*bPre*/,/*bPost*/,/*bCommit*/,/*bCancel*/)

	oModel:AddFields('SZ0MASTER',/*cOwner*/,o_StrSZ0)
	oModel:GetModel('SZ0MASTER'):SetDescription('Romaneio')

	oModel:AddGrid('SZ1GRID','SZ0MASTER',o_StrSZ1,/*bLinePre*/,/*bLinePost*/ /*{|oModel| f_TDP002POS( oModel ) }*/,/*bPre*/,/*bPos*/,/*bLoad*/)
	oModel:SetRelation('SZ1GRID',{ { 'Z1_FILIAL', 'XFILIAL("SZ0")' }, { 'Z1_ROMANEI', 'Z0_ROMANEI' } }, SZ1->( IndexKey( 1 ) ) )
	oModel:GetModel('SZ1GRID'):SetUniqueLine({'Z1_NF','Z1_SERIE'})
	oModel:GetModel('SZ1GRID'):SetDescription('Nota Fiscal')

	oModel:AddGrid('SZ2GRID','SZ1GRID',o_StrSZ2,/*bLinePre*/,/*bLinePost*/ /*{|oModel| f_TDP002POS( oModel ) }*/,/*bPre*/,/*bPos*/,/*bLoad*/)
	oModel:SetRelation('SZ2GRID',{ { 'Z2_FILIAL', 'XFILIAL("SZ0")' }, { 'Z2_ROMANEI', 'Z0_ROMANEI' }, {'Z2_NF', 'Z1_NF'}, {'Z2_SERIE','Z1_SERIE'} }, SZ2->( IndexKey( 1 ) ) )
	oModel:GetModel('SZ2GRID'):SetUniqueLine({'Z2_NF','Z2_SERIE','Z2_ITEM'})
	oModel:GetModel('SZ2GRID'):SetDescription('Itens Nota Fiscal')

	oModel:AddGrid('SZ3GRID','SZ0MASTER',o_StrSZ3,/*bLinePre*/,/*bLinePost*/ /*{|oModel| f_TDP002POS( oModel ) }*/,/*bPre*/,/*bPos*/,/*bLoad*/)
	oModel:SetRelation('SZ3GRID',{ { 'Z3_FILIAL', 'XFILIAL("SZ0")' }, { 'Z3_ROMANEI', 'Z0_ROMANEI' } }, SZ3->( IndexKey( 1 ) ) )
	oModel:GetModel('SZ3GRID'):SetUniqueLine({'Z3_COD'})
	oModel:GetModel('SZ3GRID'):SetDescription('Resumo do Romaneio')

Return oModel

Static Function ViewDef()

	Local oView		:= FWFormView():New()
	Local oModel	:= FWLoadModel('ROM001')

	Local o_StrSZ0	:= FWFormStruct( 2, 'SZ0' )
	Local o_StrSZ1	:= FWFormStruct( 2, 'SZ1' )
	Local o_StrSZ2	:= FWFormStruct( 2, 'SZ2' )
	Local o_StrSZ3	:= FWFormStruct( 2, 'SZ3' )

	oView:SetModel(oModel)

	oView:CreateHorizontalBox('CABEC',25)
	oView:AddField('SZ0VIEW',o_StrSZ0,'SZ0MASTER')
	oView:EnableTitleView('SZ0VIEW','ROMANEIO')
	oView:SetOwnerView('SZ0VIEW','CABEC')

	oView:CreateHorizontalBox('NFGRID',25)
	oView:AddGrid('SZ1VIEW',o_StrSZ1,'SZ1GRID')
	oView:EnableTitleView('SZ1VIEW','NOTA FISCAIS')
	oView:SetOwnerView('SZ1VIEW','NFGRID')

	oView:CreateHorizontalBox('ITGRID',25)
	oView:AddGrid('SZ2VIEW',o_StrSZ2,'SZ2GRID')
	oView:EnableTitleView('SZ2VIEW','ITENS DA NOTA FISCAL')
	oView:SetOwnerView('SZ2VIEW','ITGRID')
	oView:AddIncrementField('SZ2VIEW','Z2_ITEM')

	oView:CreateHorizontalBox('RESUMO',25)
	oView:AddGrid('SZ3VIEW',o_StrSZ3,'SZ3GRID')
	oView:EnableTitleView('SZ3VIEW','RESUMO')
	oView:SetOwnerView('SZ3VIEW','RESUMO')

	oView:AddUserButton( 'Nota Fiscal'	, 'Seleciona Notas Fiscais', {|oModel,oView| U_ROM002() } )

Return oView
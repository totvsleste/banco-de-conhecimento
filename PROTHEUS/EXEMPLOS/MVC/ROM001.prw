#INCLUDE "TOTVS.CH"
#INCLUDE 'FWMVCDEF.CH'

User Function ROM001()

	Local oBrowse
	Private cCadastro := "Pedido de Venda"

	Private n_RecAdto	:= 0

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('SA1')
	oBrowse:SetDescription('Pedido de Venda')

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

	Local o_StrSZ0	:= FWFormStruct( 1, 'SA1' )
	Local o_StrSZ1	:= FWFormStruct( 1, 'SA2' )
	
	Private oModel	:= MPFormModel():New('ROM001M',/*bPre*/,/*bPost*/,/*bCommit*/,/*bCancel*/)

	oModel:AddFields('SC5MASTER',/*cOwner*/,o_StrSZ0)
	oModel:GetModel('SC5MASTER'):SetDescription('Pedido de Venda')

	oModel:AddGrid('SC6GRID','SC5MASTER',o_StrSZ1,/*bLinePre*/,/*bLinePost*/ /*{|oModel| f_TDP002POS( oModel ) }*/,/*bPre*/,/*bPos*/,/*bLoad*/)
	oModel:SetRelation('SC6GRID',{ { 'A2_FILIAL', 'XFILIAL("SA1")' }, { 'A2_CGC', 'A1_CGC' } }, SA2->( IndexKey( 3 ) ) )
	//oModel:GetModel('SC6GRID'):SetUniqueLine({'Z1_NF','Z1_SERIE'})
	oModel:GetModel('SC6GRID'):SetDescription('Itens Pedido de Venda')

	oModel:AddCalc( "CALCULOS" , "SC5MASTER" , "SC6GRID" , "A2_MCOMPRA" , "C6QTDVEN" , "FORMULA" , { || .T. } ,, "Total - Títulos" , { | oModel , nTotal , xValor | SFTOTAIS( oModel , nTotal , xValor , "SC6GRID" ) } )


	
Return oModel

Static Function ViewDef()

	Local oView		:= FWFormView():New()
	Local oModel	:= FWLoadModel('ROM001')

	Local o_StrSZ0	:= FWFormStruct( 2, 'SA1' )
	Local o_StrSZ1	:= FWFormStruct( 2, 'SA2' )
	
	oView:SetModel(oModel)

	oView:CreateHorizontalBox('CABEC',50)
	oView:AddField('SC5VIEW',o_StrSZ0,'SC5MASTER')
	oView:EnableTitleView('SC5VIEW','ROMANEIO')
	oView:SetOwnerView('SC5VIEW','CABEC')

	oView:CreateHorizontalBox('NFGRID',50)
	oView:AddGrid('SC6VIEW',o_StrSZ1,'SC6GRID')
	oView:EnableTitleView('SC6VIEW','ITENS PEDIDO')
	oView:SetOwnerView('SC6VIEW','NFGRID')

	//oView:AddUserButton( 'Nota Fiscal'	, 'Seleciona Notas Fiscais', {|oModel,oView| U_ROM002() } )

Return oView

STATIC FUNCTION SFTOTAIS( oModel , nTotal , xValor , oGrid )

Alert("ok")

Return()

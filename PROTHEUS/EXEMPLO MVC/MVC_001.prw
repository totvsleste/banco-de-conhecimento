#INCLUDE 'TOTVS.CH'
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

User Function MVC_001()

	Local oBrowse	:= Nil

	oBrowse	:= FWmBrowse():New()
	oBrowse:SetAlias("SA1")
	oBrowse:SetDescription('Contratos')
	oBrowse:Activate()

Return

Static Function MenuDef()

	Local a_Rotina	:= {}

	ADD OPTION a_Rotina TITLE '&Visualizar'	ACTION 'VIEWDEF.MVC_001' OPERATION 1 ACCESS 0
	ADD OPTION a_Rotina TITLE '&Incluir'    ACTION 'VIEWDEF.MVC_001' OPERATION 3 ACCESS 0
	ADD OPTION a_Rotina TITLE '&Alterar'    ACTION 'VIEWDEF.MVC_001' OPERATION 4 ACCESS 0
	ADD OPTION a_Rotina TITLE '&Excluir'    ACTION 'VIEWDEF.MVC_001' OPERATION 5 ACCESS 0
	ADD OPTION a_Rotina TITLE 'Im&primir'   ACTION 'VIEWDEF.MVC_001' OPERATION 8 ACCESS 0
	ADD OPTION a_Rotina TITLE '&Copiar'     ACTION 'VIEWDEF.MVC_001' OPERATION 9 ACCESS 0

Return a_Rotina

Static Function ModelDef()

	Local oStruSA1	:= FWFormStruct( 1, 'SA1' )
	Local oStruSA2	:= FWFormStruct( 1, 'SA2' )
	Local oStruSA3	:= FWFormStruct( 1, 'SA3' )
	Local oStruSA6	:= FWFormStruct( 1, 'SA6' )
	Local oModel	:= MPFormModel():New( 'MVC_001M' )

	oModel:AddFields( 'SA1MASTER', /*cOwner*/, oStruSA1, /*bPre*/, /*bPos*/, /*bLoad*/ /*{|oModel| F_TDPALFORM(oModel) }*/ )
	oModel:AddFields( 'SA2MASTER', "SA1MASTER", oStruSA2, /*bPre*/, /*bPos*/, /*bLoad*/ /*{|oModel| F_TDPALFORM(oModel) }*/ )
	oModel:AddFields( 'SA3MASTER', 'SA1MASTER', oStruSA3, /*bPre*/, /*bPos*/, /*bLoad*/ /*{|oModel| F_TDPALFORM(oModel) }*/ )
	oModel:AddFields( 'SA6MASTER', 'SA1MASTER', oStruSA6, /*bPre*/, /*bPos*/, /*bLoad*/ /*{|oModel| F_TDPALFORM(oModel) }*/ )

	oModel:SetRelation('SA2MASTER',{ { 'A2_FILIAL', 'XFILIAL("SA2")' }, { 'A2_FSCOD_G', 'A1_FSCOD_G' } }, SA2->( IndexKey( 10 ) ) )
	oModel:SetRelation('SA3MASTER',{ { 'A3_FILIAL', 'XFILIAL("SA3")' }, { 'A3_FSCOD_G', 'A1_FSCOD_G' } }, SA3->( IndexKey( 9 ) ) )
	oModel:SetRelation('SA6MASTER',{ { 'A6_FILIAL', 'XFILIAL("SA6")' }, { 'A6_FSCOD_G', 'A1_FSCOD_G' } }, SA6->( IndexKey( 4 ) ) )

Return oModel

Static Function ViewDef()

	Local oModel	:= FWLoadModel( 'MVC_001' )
	Local oStruSA1	:= FWFormStruct( 2, 'SA1' )
	Local oStruSA2	:= FWFormStruct( 2, 'SA2' )
	Local oStruSA3	:= FWFormStruct( 2, 'SA3' )
	Local oStruSA6	:= FWFormStruct( 2, 'SA6' )
	Local oView		:= FWFormView():New()

	oView:SetModel(oModel)
	oView:AddField( 'SA1_VIEW', oStruSA1, 'SA1MASTER' )
	oView:AddField( 'SA2_VIEW', oStruSA2, 'SA2MASTER' )
	oView:AddField( 'SA3_VIEW', oStruSA3, 'SA3MASTER' )
	oView:AddField( 'SA6_VIEW', oStruSA6, 'SA6MASTER' )

	oStruSA1:AddGroup( 'GRUPO01', 'Alguns Dados', '', 2 )
	oStruSA1:AddGroup( 'GRUPO02', 'Outros Dados', '', 2 )

	// Colocando todos os campos para um agrupamento'
	oStruSA1:SetProperty( '*' , MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
	// Trocando o agrupamento de alguns campos
	oStruSA1:SetProperty( 'A1_COD', MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	oStruSA1:SetProperty( 'A1_LOJA' , MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )

	oView:CreateHorizontalBox( 'EMCIMA', 50 )
	oView:CreateHorizontalBox( 'EMBAIXO', 50 )

	oView:CreateVerticalBox( 'EMCIMAESQ', 50, 'EMCIMA' )
	oView:CreateVerticalBox( 'EMCIMADIR', 50, 'EMCIMA' )

	oView:CreateVerticalBox( 'EMBAIXOESQ', 50, 'EMBAIXO' )
	oView:CreateVerticalBox( 'EMBAIXODIR', 50, 'EMBAIXO' )

	oView:SetOwnerView( 'SA1_VIEW', 'EMCIMAESQ' )
	oView:SetOwnerView( 'SA6_VIEW', 'EMCIMADIR' )

	oView:SetOwnerView( 'SA2_VIEW', 'EMBAIXOESQ' )
	oView:SetOwnerView( 'SA3_VIEW', 'EMBAIXODIR' )

	oView:EnableTitleView( 'SA1_VIEW', "CLIENTES" )
	oView:EnableTitleView( 'SA6_VIEW', "BANCOS" )
	oView:EnableTitleView( 'SA2_VIEW', "FORNECEDORES" )
	oView:EnableTitleView( 'SA3_VIEW', "VENDEDORES" )

Return oView
#Include 'Protheus.ch'
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"


User Function MVCSZ4()

	Local oBrowse	:= Nil

	oBrowse	:= FWmBrowse():New()
	oBrowse:SetAlias("SZ4")
	oBrowse:Activate()

Return Nil

Static Function MenuDef()

	Local a_Rotina	:= {}

	ADD OPTION a_Rotina TITLE '&Visualizar'	ACTION 'VIEWDEF.MVCSZ4' OPERATION 1 ACCESS 0
	ADD OPTION a_Rotina TITLE '&Incluir'    ACTION 'VIEWDEF.MVCSZ4' OPERATION 3 ACCESS 0
	ADD OPTION a_Rotina TITLE '&Alterar'    ACTION 'VIEWDEF.MVCSZ4' OPERATION 4 ACCESS 0
	ADD OPTION a_Rotina TITLE '&Excluir'    ACTION 'VIEWDEF.MVCSZ4' OPERATION 5 ACCESS 0
	ADD OPTION a_Rotina TITLE 'Im&primir'   ACTION 'VIEWDEF.MVCSZ4' OPERATION 8 ACCESS 0
	ADD OPTION a_Rotina TITLE '&Copiar'     ACTION 'VIEWDEF.MVCSZ4' OPERATION 9 ACCESS 0

Return a_Rotina

Static Function ModelDef()

	Local oModel	:= MPFormModel():New( 'MVCSZ4M',/*bPre*/,/*bPos*/,/*bCommit*/,/*bCancel*/ )
	Local oStruSZ4	:= FWFormStruct( 1, 'SZ4' , { |x| ALLTRIM(x) $ 'Z4_NUMERO, Z4_EMISSAO'  } )
	Local oStrSZ4G	:= FWFormStruct( 1, 'SZ4' )

	oModel:AddFields('SZ4MASTER',/*cOwner*/,oStruSZ4,/*bPre*/,/*bPos*/,/*bLoad*/ /*{|oModel| F_TDPALFORM(oModel) }*/ )
	oModel:AddGrid('SZ4GRID','SZ4MASTER',oStrSZ4G,/*bLinePre*/,/*bLinePost*/,/*bPre*/,/*bPos*/,/*bLoad*/ )

	oModel:SetRelation('SZ4GRID',{ { 'Z4_FILIAL', 'XFILIAL("SZ4")' }, { 'Z4_NUMERO', 'Z4_NUMERO' } }, SZ4->( IndexKey( 1 ) ) )

	oModel:SetPrimaryKey( { "Z4_FILIAL", "Z4_NUMERO", "Z4_ITEM" } )

	oModel:GetModel('SZ4GRID'):SetUniqueLine({'Z4_ITEM'})

	oModel:GetModel('SZ4MASTER'):SetDescription('Cabecalho')
	oModel:GetModel('SZ4GRID'):SetDescription('Itens')

	oStrSZ4G:RemoveField('Z4_NUMERO')
	oStrSZ4G:RemoveField('Z4_EMISSAO')

Return oModel

Static Function ViewDef()

	Local oView		:= FWFormView():New()
	Local oStruSZ4	:= FWFormStruct( 2, 'SZ4' , { |x| ALLTRIM(x) $ 'Z4_NUMERO, Z4_EMISSAO'  } )
	Local oStrSZ4G	:= FWFormStruct( 2, 'SZ4' )
	Local oModel	:= FWLoadModel('MVCSZ4')

	oStrSZ4G:RemoveField('Z4_NUMERO')
	oStrSZ4G:RemoveField('Z4_EMISSAO')

	oView:SetModel(oModel)
	oView:AddField('Z41_VIEW',oStruSZ4,'SZ4MASTER')
	oView:AddGrid('Z42_VIEW',oStrSZ4G,'SZ4GRID')

	oView:CreateHorizontalBox('CABEC',30)
	oView:CreateHorizontalBox('GRID',70)

	oView:SetOwnerView('Z41_VIEW','CABEC')
	oView:SetOwnerView('Z42_VIEW','GRID')

	oView:AddIncrementField('Z42_VIEW','Z4_ITEM')

	oView:EnableTitleView('Z41_VIEW','Cabecalho')
	oView:EnableTitleView('Z42_VIEW','Itens')

Return oView

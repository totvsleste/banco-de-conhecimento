#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} EXERC03
Programa responsavel pelo Cadastro para manutencao de Disciplinas

@author francisco.ssa
@since 02/06/2014
@version 1.0

@return ${return}, ${return_description}

@example
(examples)

@see (links_or_references)
/*/

User Function EXERC03()
	Local oBrowse	:= Nil

	oBrowse := FWmBrowse():New()
	oBrowse:SetAlias("ZB3")
	oBrowse:SetDescription('Disciplinas')
	oBrowse:Activate()

Return()

/*/{Protheus.doc} MenuDef
Funcao responsavel pela criacao do menu de opcoes

@author francisco.ssa
@since 02/06/2014
@version 1.0

@return Array, Retorna vetor com as opcoes do menu

@example
(examples)

@see (links_or_references)
/*/
Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE '&Visualizar'	ACTION 'VIEWDEF.EXERC03' 	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE '&Incluir'	ACTION 'VIEWDEF.EXERC03' 	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE '&Alterar'	ACTION 'VIEWDEF.EXERC03' 	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE '&Excluir'	ACTION 'VIEWDEF.EXERC03' 	OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Im&primir'	ACTION 'VIEWDEF.EXERC03' 	OPERATION 8 ACCESS 0
	ADD OPTION aRotina TITLE '&Copiar'		ACTION 'VIEWDEF.EXERC03' 	OPERATION 9 ACCESS 0
	ADD OPTION aRotina Title 'Legenda'		Action 'U_EXERC03A'			OPERATION 8 ACCESS 0

Return aRotina

//--------------------------------------------------------------------------------------------------------

/*/{Protheus.doc} ModelDef
Funcao responsavel pela ModelDef

@author francisco.ssa
@since 02/06/2014
@version 1.0

@return Objeto, Retorna a Model

@example
(examples)

@see (links_or_references)
/*/

Static Function ModelDef()

	Local oStruZB3 := FWFormStruct(1, 'ZB3' )
	Local oModel	:= MPFormModel():New('EXERC03M')

	oModel:AddFields( 'ZB3MASTER', /*cOwner*/, oStruZB3)
	oModel:SetDescription( 'Disciplinas' )
	oModel:GetModel( 'ZB3MASTER' ):SetDescription( 'Disciplinas')

Return oModel

/*/{Protheus.doc} ViewDef
Funcao responsavel pela ViewDef

@author francisco.ssa
@since 02/06/2014
@version 1.0

@return Objeto, Retorna a View

@example
(examples)

@see (links_or_references)
/*/
Static Function ViewDef()

	Local oModel 	:= FWLoadModel( 'EXERC03' )
	Local oStruZB3 := FWFormStruct( 2, 'ZB3' )
	Local oView		:= FWFormView():New()

	oView:SetModel( oModel )
	oView:AddField( 'VIEW_ZB3', oStruZB3, 'ZB3MASTER' )
	oView:CreateHorizontalBox( 'TELAZB3' , 100 )
	oView:SetOwnerView( 'VIEW_ZB3', 'TELAZB3' )

Return oView

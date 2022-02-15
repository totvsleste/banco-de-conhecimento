#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} EXERC01
Programa responsavel pelo Cadastro para manutencao de Turmas

@author francisco.ssa
@since 02/06/2014
@version 1.0

@return ${return}, ${return_description}

@example
(examples)

@see (links_or_references)
/*/

User Function EXERC01()
	Local oBrowse	:= Nil

	oBrowse := FWmBrowse():New()
	oBrowse:SetAlias("ZB1")	//Cadastro de Autor/Interprete
	oBrowse:AddLegend( "ALLTRIM(ZB1_SITUAC)=='1'", "BR_VERDE"	, "Ativa" )
	oBrowse:AddLegend( "ALLTRIM(ZB1_SITUAC)=='2'", "BR_AMARELO"	, "Suspensa" )
	oBrowse:AddLegend( "ALLTRIM(ZB1_SITUAC)=='3'", "BR_VERMELHO"	, "Encerrada" )
	oBrowse:SetDescription('Turmas')
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

	ADD OPTION aRotina TITLE '&Visualizar'	ACTION 'VIEWDEF.EXERC01' 	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE '&Incluir'	ACTION 'VIEWDEF.EXERC01' 	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE '&Alterar'	ACTION 'VIEWDEF.EXERC01' 	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE '&Excluir'	ACTION 'VIEWDEF.EXERC01' 	OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Im&primir'	ACTION 'VIEWDEF.EXERC01' 	OPERATION 8 ACCESS 0
	ADD OPTION aRotina TITLE '&Copiar'		ACTION 'VIEWDEF.EXERC01' 	OPERATION 9 ACCESS 0
	ADD OPTION aRotina Title 'Legenda'		Action 'U_EXERC01A'			OPERATION 8 ACCESS 0

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

	Local oStruZB1 := FWFormStruct(1, 'ZB1' )
	Local oModel	:= MPFormModel():New('EXERC01M')

	oModel:AddFields( 'ZB1MASTER', /*cOwner*/, oStruZB1)
	oModel:SetDescription( 'Turmas' )
	oModel:GetModel( 'ZB1MASTER' ):SetDescription( 'Turmas')

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

	Local oModel 	:= FWLoadModel( 'EXERC01' )
	Local oStruZB1 := FWFormStruct( 2, 'ZB1' )
	Local oView		:= FWFormView():New()

	oView:SetModel( oModel )
	oView:AddField( 'VIEW_ZB1', oStruZB1, 'ZB1MASTER' )
	oView:CreateHorizontalBox( 'TELAZB1' , 100 )
	oView:SetOwnerView( 'VIEW_ZB1', 'TELAZB1' )

Return oView

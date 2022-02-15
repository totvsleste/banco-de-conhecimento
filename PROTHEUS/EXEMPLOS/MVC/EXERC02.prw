#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} EXERC02
Programa responsavel pelo Cadastro para manutencao de Alunos

@author francisco.ssa
@since 02/06/2014
@version 1.0

@return ${return}, ${return_description}

@example
(examples)

@see (links_or_references)
/*/

User Function EXERC02()
	Local oBrowse	:= Nil

	oBrowse := FWmBrowse():New()
	oBrowse:SetAlias("ZB2")	//Cadastro de Autor/Interprete
	oBrowse:AddLegend( "ALLTRIM(ZB2_SITUAC)=='1'", "BR_VERDE"		, "Ativa" )
	oBrowse:AddLegend( "ALLTRIM(ZB2_SITUAC)=='2'", "BR_AMARELO"		, "Trancado" )
	oBrowse:SetDescription('Alunos')
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

	ADD OPTION aRotina TITLE '&Visualizar'	ACTION 'VIEWDEF.EXERC02' 	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE '&Incluir'	ACTION 'VIEWDEF.EXERC02' 	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE '&Alterar'	ACTION 'VIEWDEF.EXERC02' 	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE '&Excluir'	ACTION 'VIEWDEF.EXERC02' 	OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Im&primir'	ACTION 'VIEWDEF.EXERC02' 	OPERATION 8 ACCESS 0
	ADD OPTION aRotina TITLE '&Copiar'		ACTION 'VIEWDEF.EXERC02' 	OPERATION 9 ACCESS 0
	ADD OPTION aRotina Title 'Legenda'		Action 'U_EXERC02A'			OPERATION 8 ACCESS 0

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

	Local oStruZB2 := FWFormStruct(1, 'ZB2' )
	Local oModel	:= MPFormModel():New('EXERC02M')

	oModel:AddFields( 'ZB2MASTER', /*cOwner*/, oStruZB2)
	oModel:SetDescription( 'Alunos' )
	oModel:GetModel( 'ZB2MASTER' ):SetDescription( 'Alunos')

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

	Local oModel 	:= FWLoadModel( 'EXERC02' )
	Local oStruZB2 := FWFormStruct( 2, 'ZB2' )
	Local oView		:= FWFormView():New()

	oView:SetModel( oModel )
	oView:AddField( 'VIEW_ZB2', oStruZB2, 'ZB2MASTER' )
	oView:CreateHorizontalBox( 'TELAZB2' , 100 )
	oView:SetOwnerView( 'VIEW_ZB2', 'TELAZB2' )

Return oView

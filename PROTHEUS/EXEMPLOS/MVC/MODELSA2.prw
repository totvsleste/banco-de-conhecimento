#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} MODELSA2
Programa responsavel pelo Cadastro para manutencao de Alunos

@author francisco.ssa
@since 02/06/2014
@version 1.0

@return ${return}, ${return_description}

@example
(examples)

@see (links_or_references)
/*/

User Function MODELSA2()
	Local oBrowse	:= Nil

	Private aRotina	:= MenuDef()

	oBrowse := FWmBrowse():New()
	oBrowse:SetAlias("SA2")	//Cadastro de Autor/Interprete
	oBrowse:SetDescription('Fornecedor')
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

	ADD OPTION aRotina TITLE '&Visualizar'	ACTION 'VIEWDEF.MODELSA2' 	OPERATION 2 ACCESS 0

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

	Local oStruSA2 := FWFormStruct(1, 'SA2' )
	Local oModel	:= MPFormModel():New('MODSA2')

	oModel:AddFields( 'SA2MASTER', /*cOwner*/, oStruSA2)
	oModel:SetDescription( 'Alunos' )
	oModel:GetModel( 'SA2MASTER' ):SetDescription( 'Alunos')

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

	Local oModel 	:= FWLoadModel( 'MODELSA2' )
	Local oStruSA2 	:= FWFormStruct( 2, 'SA2',  { |x| ALLTRIM(x) $ 'A2_COD, A2_LOJA, A2_NOME, A2_NREDUZ, A2_CGC, A2_BANCO, A2_AGENCIA, A2_NUMCON' } )
	Local oView		:= FWFormView():New()

	oView:SetModel( oModel )
	oView:AddField( 'VIEW_SA2', oStruSA2, 'SA2MASTER' )
	oView:CreateHorizontalBox( 'TELASA2' , 100 )
	oView:SetOwnerView( 'VIEW_SA2', 'TELASA2' )

Return oView

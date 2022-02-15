#INCLUDE 'FWMVCDEF.CH'

User Function EXERC05()

	Private oMark

	Private b_Filter := " ZB2_SITUAC == '2' "

	oMark := FWMarkBrowse():New()
	oMark:SetAlias('ZB2')
	oMark:SetDescription('Alunos')
	oMark:SetFieldMark( 'ZB2_OK' )
	oMark:AddLegend( "ALLTRIM(ZB2_SITUAC)=='1'", "BR_VERDE"		, "Ativa" )
	oMark:AddLegend( "ALLTRIM(ZB2_SITUAC)=='2'", "BR_AMARELO"		, "Trancado" )
	oMark:SetFilterDefault( b_Filter )
	oMark:Activate()

Return NIL

//-------------------------------------------------------------------
Static Function MenuDef()

	Local a_Rotina := {}
	ADD OPTION a_Rotina TITLE 'Visualizar' ACTION 'VIEWDEF.EXERC05' OPERATION 2 ACCESS 0
	ADD OPTION a_Rotina TITLE 'Processar' ACTION 'U_EXERC05A()' OPERATION 2 ACCESS 0

Return a_Rotina

/*/{Protheus.doc} ModelDef
Funcao responsavel pelo Modelo. Reaproveitamento de codigo

@author francisco.ssa
@since 03/06/2014
@version 1.0

@return Objeto, Modelo

@example
(examples)

@see (links_or_references)
/*/
Static Function ModelDef()

Return FWLoadModel( 'EXERC02' )

/*/{Protheus.doc} ViewDef
Funcao responsavel pela View. Reaproveitamento de codigo

@author francisco.ssa
@since 03/06/2014
@version 1.0

@return Objeto, View

@example
(examples)

@see (links_or_references)
/*/
Static Function ViewDef()

Return FWLoadView( 'EXERC02' )

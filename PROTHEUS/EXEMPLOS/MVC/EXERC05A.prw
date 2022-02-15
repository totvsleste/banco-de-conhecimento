/*/{Protheus.doc} EXERC05A
Programa responsavel por fazer a contagem dos registros marcados

@author francisco.ssa
@since 03/06/2014
@version 1.0

@return Nil, Nao esperado

@example
(examples)

@see (links_or_references)
/*/
User Function EXERC05A()

	Local aArea		:= GetArea()
	Local cMarca	:= oMark:Mark()
	Local nCt		:= 0

	ZB2->( DBGOTOP() )
	While !ZB2->( EOF() )
		If oMark:IsMark(cMarca)
			nCt++
		EndIf
		ZB2->( dbSkip() )
	End

	ApMsgInfo( 'Foram marcados ' + AllTrim( Str( nCt ) ) + ' registros.' )

	ZB2->( DBGOTOP() )

	RestArea( aArea )

Return NIL

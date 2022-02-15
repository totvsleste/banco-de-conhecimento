#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOTVS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "FS_BUTTON_CSS.CH"

User Function FLOJA004()

	Private n_TamBotao	:= SuperGetMV( "FS_TAMBUTT",,11 )

	//Inicializa as mensagens da barra de status
	oTMsgBar:SetMsg("")

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de Variaveis Private dos Objetos                             ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

	SetPrvt("oFont1","oDlg4","oGrp1","1","2","3","4","5","6","7","8","9")
	SetPrvt("11","12","13","14","15","16","17","18","19","20","21")
	SetPrvt("23","24","25")

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

	oFont1     := TFont():New( "Arial Unicode MS",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )

	oDlg4      := MSDialog():New( 092,232,540,830,"Atendentes",,,.F.,,,,,,.T.,,oFont1,.T. )

	oGrp1      := TGroup():New( 001,003,210,295," Atendentes ",oDlg4,CLR_BLACK,CLR_WHITE,.T.,.F. )

	f_CargaVendedores()

	oDlg4:Activate(,,,.T.)

Return

Static Function f_CargaVendedores()

	Local c_Alias		:= GetNextAlias()
	Local j				:= ""
	Local n_Vez			:= 1
	Local c_NomeVend	:= ""
	Local nLinha		:= 0
	Local i				:= 0
	Local n_Linha		:= 14
	Local n_ContLn		:= 1
	Local n_Coluna		:= 7

	BeginSQL Alias c_Alias

		SELECT
			A3_COD,
			A3_NREDUZ
		FROM
			%TABLE:SA3% SA3
		WHERE
			SA3.%NOTDEL%

	EndSQL
	dbSelectArea( c_Alias )
	While ( c_Alias )->(!EOF())

		//Tela Atual monta apenas 25 botoes
		If n_Vez <= 25

			c_NomeVend := ""
			If Len( Alltrim( ( c_Alias )->A3_NREDUZ ) + " " + ( c_Alias )->A3_COD ) > n_TamBotao

				nLinha:= MLCount( Alltrim( ( c_Alias )->A3_NREDUZ + " " + ( c_Alias )->A3_COD ), n_TamBotao )

				For i := 1 to nLinha

					c_NomeVend += MemoLine( Alltrim( ( c_Alias )->A3_NREDUZ + " " + ( c_Alias )->A3_COD ), n_TamBotao, i ) + chr(10)

				Next

			Else
				c_NomeVend := Alltrim( ( c_Alias )->A3_NREDUZ + " " + ( c_Alias )->A3_COD )
			EndIf

			If n_ContLn > 5
				n_Linha 	+= 40
				n_Coluna	:= 7
				n_ContLn	:= 1
			Else
				n_ContLn++
			EndIf

			j := Alltrim( Str( n_Vez ) )
			oBtVend&j      := TButton():New( n_Linha,n_Coluna,"",oGrp1,{|| f_SelecionaAtendente() },056,040,,oFont1,,.T.,,"",,,,.F. )
			oBtVend&j:SetCss( STYLE0009 )
			oBtVend&j:cCaption :=  c_NomeVend

			n_Vez++
			n_Coluna += 57

		EndIf

		( c_Alias )->( dbSkip() )

	EndDo

	oDlg4:Refresh()
	( c_Alias )->( dbCloseArea() )

Return()

Static Function f_SelecionaAtendente()

	c_Vendedor	:= Replace( oDlg4:oCtlFocus:cCaption, CHR(10), "" )
	c_CodVend	:= substr( c_Vendedor, At( "0", c_Vendedor ), 6)
	c_Vendedor	:= Substr( c_Vendedor, 1, at( "0", c_Vendedor ) - 1 )

	oTMsgItem1:SetText("")
	oTMsgItem3:SetText( c_Vendedor )
	oDlg4:End()

Return
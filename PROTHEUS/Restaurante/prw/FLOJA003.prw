#INCLUDE 'TOTVS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "FS_BUTTON_CSS.CH"

#define ENTER CHR(13) + CHR(10)

User Function FLOJA003()

	Private n_TamBotao	:= SuperGetMV( "FS_TAMBUTT",,11 )

	Private oFont1
	Private oDlg3
	Private oGrp1
	Private oBGrp1
	Private oBGrp2
	Private oBGrp3
	Private oBGrp4
	Private oBGrp5
	Private oBGrp6
	Private oBGrp7
	Private oBGrp8
	Private oBGrp9
	Private oBGrp10
	Private oGrp2
	Private oBPrd17
	Private oBPrd18
	Private oBPrd19
	Private oBPrd20
	Private oBPrd21
	Private oBPrd22
	Private oBPrd23
	Private oBPrd24
	Private oBPrd25
	Private oBPrd26
	Private oBPrd28
	Private oBPrd29
	Private oBPrd30
	Private oBPrd31
	Private oBPrd32
	Private oBPrd33
	Private oBPrd46
	Private oBPrd47
	Private oBPrd48
	Private oBPrd49
	Private oBPrd50
	Private oBPrd52
	Private oGrp3
	Private oMGet1
	Private oBPrd11
	Private oBPrd12
	Private oBPrd13
	Private oBPrd14
	Private oBPrd15
	Private oBPrd16
	Private oBPrd34
	Private oBPrd35
	Private oBPrd37
	Private oBPrd38
	Private oBPrd39
	Private oBPrd40
	Private oBPrd41
	Private oBPrd42
	Private oBPrd43
	Private oBPrd44
	Private oBPrd45

	Private c_Cupom		:= ""
	Private n_Item		:= 1
	Private c_HrIni		:= Time()

	//Inicializa as mensagens da barra de status
	oTMsgBar:SetMsg("")

	If Empty( c_Vendedor )
		oTMsgItem1:SetText( "Nenhum atendente selecionado. Impossível continuar!!!")
		Return()
	EndIf

	If Empty( c_Mesa )
		oTMsgItem1:SetText( "Não é possível abrir uma comanda sem informar a mesa!!!")
		Return()
	EndIf

	oTMsgItem1:SetText( "")

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

	oFont1     := TFont():New( "Arial Unicode MS",0,-12,,.F.,0,,400,.F.,.F.,,,,,, )
	oFont4     := TFont():New( "Courier",0,-9,,.F.,0,,400,.F.,.F.,,,,,, )

	oDlg3      := MSDialog():New( 019,047,660,1220,"Produtos",,,.F.,,,,,,.T.,,oFont1,.T. )

	//-------------------------- GRUPO DE PRODUTOS ------------------------------------------------
	oGrp1      := TGroup():New( 004,004,056,584," Grupos de Produtos ",oDlg3,CLR_BLACK,CLR_WHITE,.T.,.F. )

	//-------------------------- PRODUTOS ---------------------------------------------------------
	oGrp2      := TGroup():New( 059,004,319,412," Produtos ",oDlg3,CLR_BLACK,CLR_WHITE,.T.,.F. )

	//-------------------------- CONTA PARCIAL ----------------------------------------------------
	oGrp3      := TGroup():New( 060,416,320,584," Conta Parcial ",oDlg3,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oMGet1     := TMultiGet():New( 068,420,{| u | if( pCount() > 0, c_Cupom := u, c_Cupom ) },oGrp3,160,248,oFont4,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
	oMGet1:EnableVScroll( .T. )
	oMGet1:Disable()

	f_CargaGrupos()
	f_RefazCupom()

	oDlg3:Activate(,,,.T.)

	//Forca sempre escolher um atendente e mesa durante a comanda.
	c_Mesa		:= ""
	c_Vendedor 	:= ""
	oTMsgItem2:SetText( "" )
	oTMsgItem3:SetText( "" )

Return

Static Function f_GrvParcial()

	Local c_CodProd	:= Alltrim( Replace( Substr( oDlg3:oCtlFocus:cCaption, At( "#", oDlg3:oCtlFocus:cCaption ) + 1, 30 ), chr(10), "" ) )
	Local c_Item	:= ""

	BeginSQL Alias "QRY" //c_Alias

		SELECT
			B1_COD,
			B1_DESC,
			B1_UPRC
		FROM
			%TABLE:SB1% SB1
		WHERE
			SB1.%NOTDEL%
			AND SB1.B1_COD = %EXP:c_CodProd%
	EndSQL
	dbSelectArea( "QRY" )
	If QRY->( !EOF() )

		dbSelectArea("SZ0")
		dbSetOrder(1)
		If !dbSeek( xFilial("SZ0") + Padr( c_Mesa, TamSX3("Z0_MESA")[1] ) + Padr( c_CodProd, TamSX3("Z0_PRODUTO")[1] ) + Padr( c_CodVend, TamSX3("Z0_ATENDE")[1] ) + "1", .T. )

			BeginSQL Alias "ITM"

				SELECT
					MAX(Z0_ITEM) AS ITEM
				FROM
					%TABLE:SZ0% Z0
				WHERE
					Z0.Z0_FILIAL = %XFILIAL:SZ0%
					AND Z0.%NOTDEL%
					AND Z0.Z0_MESA = %EXP:c_Mesa%
					AND Z0.Z0_STATUS = %EXP:'1'%

			EndSQL
			dbSelectArea("ITM")
			c_Item := Strzero( Val( ITM->ITEM ) + 1, 2 )
			ITM->( dbCloseArea() )

			Reclock("SZ0",.T.)
			SZ0->Z0_FILIAL	:= XFILIAL("SZ0")
			SZ0->Z0_MESA 	:= c_Mesa
			SZ0->Z0_ATENDE 	:= c_CodVend
			SZ0->Z0_ITEM 	:= c_Item
			SZ0->Z0_PRODUTO := c_CodProd
			SZ0->Z0_QUANT 	:= 1
			SZ0->Z0_PRECO 	:= QRY->B1_UPRC
			SZ0->Z0_TOTAL 	:= QRY->B1_UPRC * 1
			SZ0->Z0_STATUS 	:= "1"
			SZ0->Z0_DATA	:= DATE()
			SZ0->Z0_HORA	:= TIME()
			MsUnlock()
		Else
			Reclock("SZ0",.F.)
			SZ0->Z0_QUANT 	+= 1
			SZ0->Z0_TOTAL	:= SZ0->Z0_QUANT * QRY->B1_UPRC
			MsUnlock()
		EndIf

	EndIf
	n_Item++
	oMGet1:GoEnd()
	QRY->( dbCloseArea() )
	f_RefazCupom()

Return()

Static Function f_RefazCupom()

	Local c_Quant	:= ""
	Local c_Preco	:= ""
	Local c_TotPrd	:= ""
	Local l_Cabec	:= .T.

	dbSelectArea("SZ0")
	dbSetOrder(1)
	dbSeek( xFilial("SZ0") + Padr( c_Mesa, TamSX3("Z0_MESA")[1] ), .T. )
	While SZ0->( !EOF() ) .And. SZ0->Z0_MESA == Padr( c_Mesa, TamSX3("Z0_MESA")[1] )

		If SZ0->Z0_STATUS <> "1"
			SZ0->( dbSkip() )
			Loop
		EndIf

		If l_Cabec

			c_Cupom := "--------------------------------------" + ENTER
			c_Cupom += "          PARCIAL DA MESA "  + c_Mesa + ENTER
			c_Cupom += "--------------------------------------" + ENTER
			c_Cupom += "DATA: " + DTOC( SZ0->Z0_DATA ) + ENTER
			c_Cupom += "HORA: " + SZ0->Z0_HORA + ENTER
			c_Cupom += "--------------------------------------" + ENTER
			c_Cupom += "It  Produto             Qt   Prc   Tot" + ENTER
			c_Cupom += "--------------------------------------" + ENTER

			l_Cabec := .F.

		EndIf

		c_Quant 	:= Alltrim( Transform( SZ0->Z0_QUANT, "@e 999.99" ) )
		c_Preco		:= Alltrim( Transform( SZ0->Z0_PRECO, "@e 999.99" ) )
		c_TotPrd	:= Alltrim( Transform( SZ0->Z0_TOTAL, "@e 999.99" ) )

		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek( xFilial("SB1") + SZ0->Z0_PRODUTO, .T. )

		c_Cupom += Strzero( Val( SZ0->Z0_ITEM ), 2) + " " + PADR( SB1->B1_DESC, 20 ) + " " + PADR( c_Quant, 2 ) + " " + PADR( c_Preco, 5 ) + " " + PADR( c_TotPrd, 5 ) + ENTER

		SZ0->( dbSkip() )
	EndDo

Return

Static Function f_CargaProdutos()

	Local c_DescGrupo	:= oDlg3:oCtlFocus:cCaption
	Local c_Alias		:= GetNextAlias()
	Local j				:= ""
	Local n_Vez			:= 11
	Local c_DescPrd		:= ""
	Local n_ContLn		:= 1
	Local n_Linha		:= 68
	Local n_Coluna		:= 7

	f_ClearBtPrd()
	f_RefazCupom()

	BeginSQL Alias c_Alias

		SELECT
			B1_COD,
			B1_DESC
		FROM
			%TABLE:SB1% SB1
		INNER JOIN
			%TABLE:SBM% SBM
		ON
			SB1.B1_GRUPO = SBM.BM_GRUPO AND SBM.BM_DESC = %EXP:c_DescGrupo% AND SBM.%NOTDEL%
		WHERE
			SB1.%NOTDEL%

	EndSQL

	While ( c_Alias )->( !EOF() )

		//Tela Atual monta apenas 10 botoes
		If n_Vez <= 42

			c_DescPrd := ""
			If Len( Alltrim( ( c_Alias )->B1_DESC ) + " # " + Alltrim( ( c_Alias )->B1_COD ) ) > n_TamBotao

				nLinha:= MLCount( Alltrim( ( c_Alias )->B1_DESC ) + " # " + Alltrim( ( c_Alias )->B1_COD ), n_TamBotao )

				For i := 1 to nLinha

					c_DescPrd += MemoLine( Alltrim( ( c_Alias )->B1_DESC ) + " # " + Alltrim( ( c_Alias )->B1_COD ), n_TamBotao, i ) + chr(10)

				Next

			Else
				c_DescPrd := Alltrim( ( c_Alias )->B1_DESC ) + " # " + Alltrim( ( c_Alias )->B1_COD )
			EndIf

			If n_ContLn > 7
				n_Linha 	+= 40
				n_Coluna	:= 7
				n_ContLn	:= 1
			Else
				n_ContLn++
			EndIf

			j := Alltrim( Str( n_Vez ) )

			oBPrd&j     		:= TButton():New( n_Linha,n_Coluna,"oBPrd1",oGrp2,{|| f_GrvParcial() },056,040,,oFont1,,.T.,,"",,,,.F. )
			oBPrd&j:cCaption 	:= c_DescPrd
			oBPrd&j:SetCss( STYLE0001 )

			n_Vez++
			n_Coluna += 57

		EndIf

		( c_Alias )->( dbSkip() )
	EndDo

	( c_Alias )->( dbCloseArea() )

Return()

Static Function f_ClearBtPrd()

	If Type("oBPrd11") <> "U"
		oBPrd11:lVisible := .F.
	EndIf

	If Type("oBPrd12") <> "U"
		oBPrd12:lVisible := .F.
	EndIf

	If Type("oBPrd13") <> "U"
		oBPrd13:lVisible := .F.
	EndIf

	If Type("oBPrd14") <> "U"
		oBPrd14:lVisible := .F.
	EndIf

	If Type("oBPrd15") <> "U"
		oBPrd15:lVisible := .F.
	EndIf

	If Type("oBPrd16") <> "U"
		oBPrd16:lVisible := .F.
	EndIf

	If Type("oBPrd17") <> "U"
		oBPrd17:lVisible := .F.
	EndIf

	If Type("oBPrd18") <> "U"
		oBPrd18:lVisible := .F.
	EndIf

	If Type("oBPrd19") <> "U"
		oBPrd19:lVisible := .F.
	EndIf

	If Type("oBPrd20") <> "U"
		oBPrd20:lVisible := .F.
	EndIf

	If Type("oBPrd21") <> "U"
		oBPrd21:lVisible := .F.
	EndIf

	If Type("oBPrd22") <> "U"
		oBPrd22:lVisible := .F.
	EndIf

	If Type("oBPrd23") <> "U"
		oBPrd23:lVisible := .F.
	EndIf

	If Type("oBPrd24") <> "U"
		oBPrd24:lVisible := .F.
	EndIf

	If Type("oBPrd25") <> "U"
		oBPrd25:lVisible := .F.
	EndIf

	If Type("oBPrd26") <> "U"
		oBPrd26:lVisible := .F.
	EndIf

	If Type("oBPrd27") <> "U"
		oBPrd27:lVisible := .F.
	EndIf

	If Type("oBPrd28") <> "U"
		oBPrd28:lVisible := .F.
	EndIf

	If Type("oBPrd29") <> "U"
		oBPrd29:lVisible := .F.
	EndIf

	If Type("oBPrd30") <> "U"
		oBPrd30:lVisible := .F.
	EndIf

	If Type("oBPrd31") <> "U"
		oBPrd31:lVisible := .F.
	EndIf

	If Type("oBPrd32") <> "U"
		oBPrd32:lVisible := .F.
	EndIf

	If Type("oBPrd33") <> "U"
		oBPrd33:lVisible := .F.
	EndIf

	If Type("oBPrd34") <> "U"
		oBPrd34:lVisible := .F.
	EndIf

	If Type("oBPrd35") <> "U"
		oBPrd35:lVisible := .F.
	EndIf

	If Type("oBPrd36") <> "U"
		oBPrd36:lVisible := .F.
	EndIf

	If Type("oBPrd37") <> "U"
		oBPrd37:lVisible := .F.
	EndIf

	If Type("oBPrd38") <> "U"
		oBPrd38:lVisible := .F.
	EndIf

	If Type("oBPrd39") <> "U"
		oBPrd39:lVisible := .F.
	EndIf

	If Type("oBPrd40") <> "U"
		oBPrd40:lVisible := .F.
	EndIf

	If Type("oBPrd41") <> "U"
		oBPrd41:lVisible := .F.
	EndIf

	If Type("oBPrd42") <> "U"
		oBPrd42:lVisible := .F.
	EndIf

	If Type("oBPrd43") <> "U"
		oBPrd43:lVisible := .F.
	EndIf

	If Type("oBPrd44") <> "U"
		oBPrd44:lVisible := .F.
	EndIf

	If Type("oBPrd45") <> "U"
		oBPrd45:lVisible := .F.
	EndIf

	If Type("oBPrd46") <> "U"
		oBPrd46:lVisible := .F.
	EndIf

	If Type("oBPrd47") <> "U"
		oBPrd47:lVisible := .F.
	EndIf

	If Type("oBPrd48") <> "U"
		oBPrd48:lVisible := .F.
	EndIf

	If Type("oBPrd49") <> "U"
		oBPrd49:lVisible := .F.
	EndIf

	If Type("oBPrd50") <> "U"
		oBPrd50:lVisible := .F.
	EndIf

	If Type("oBPrd51") <> "U"
		oBPrd51:lVisible := .F.
	EndIf

	If Type("oBPrd52") <> "U"
		oBPrd52:lVisible := .F.
	EndIf

Return()

Static Function f_CargaGrupos()

	Local c_Alias	:= GetNextAlias()
	Local j			:= ""
	Local n_Vez		:= 1
	Local c_DescGrp	:= ""
	Local nLinha	:= 0
	Local i			:= 0
	Local n_Linha	:= 12
	Local n_Coluna	:= 8

	BeginSQL Alias c_Alias

		SELECT
			BM_DESC
		FROM
			%TABLE:SBM% SBM
		WHERE
			SBM.%NOTDEL%

	EndSQL
	dbSelectArea( c_Alias )
	While ( c_Alias )->(!EOF())

		//Tela Atual monta apenas 10 botoes
		If n_Vez <= 10

			c_DescGrp := ""
			If Len( Alltrim( ( c_Alias )->BM_DESC ) ) > n_TamBotao

				nLinha:= MLCount( Alltrim( ( c_Alias )->BM_DESC ), n_TamBotao )

				For i := 1 to nLinha

					c_DescGrp += MemoLine( Alltrim( ( c_Alias )->BM_DESC ), n_TamBotao, i ) + chr(10)

				Next

			Else
				c_DescGrp := Alltrim( ( c_Alias )->BM_DESC )
			EndIf

			j := Alltrim( Str( n_Vez ) )
			oBGrp&j      := TButton():New( n_Linha,n_Coluna,"",oGrp1,{|| f_CargaProdutos() },056,040,,oFont1,,.T.,,"",,,,.F. )
			oBGrp&j:SetCss( STYLE0000 )
			oBGrp&j:cCaption :=  c_DescGrp

			n_Vez++
			n_Coluna += 57

		EndIf

		( c_Alias )->( dbSkip() )

	EndDo

	oDlg3:Refresh()
	( c_Alias )->( dbCloseArea() )

Return()

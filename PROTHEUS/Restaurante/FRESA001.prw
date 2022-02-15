#INCLUDE 'TOTVS.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TBICONN.CH"
#INCLUDE "FS_BUTTON_CSS.CH"

#define LAYOUT_ALIGN_LEFT		1
#define LAYOUT_ALIGN_RIGHT		2
#define LAYOUT_ALIGN_HCENTER	4
#define LAYOUT_ALIGN_TOP		32
#define LAYOUT_ALIGN_BOTTON		64
#define LAYOUT_ALIGN_VCENTER	128

#define LAYOUT_LINEAR_L2R		0
#define LAYOUT_LINEAR_R2L		1
#define LAYOUT_LINEAR_T2B		2
#define LAYOUT_LINEAR_B2T		3

#define ENTER CHR(13) + CHR(10)

User Function FRESA001()

	Local oWnd

	BEGIN SEQUENCE

		MsAguarde( {|| f_CarregaDic() }, "Aguarde!!!", "Aguarde enquanto preparamos seu ambiente...")


		oDlg	:= MSDialog():New( 092,232,650,809,"Mesas",,,.F.,,,,,,.T.,,,.T. )

		//oBtn1	:= TButton():New( 003,004,"MESA 1",oDlg,{|| f_Operacao( "01" ) },088,044,,,,.T.,,"",,,,.F. )
		//oBtn2	:= TButton():New( 003,097,"MESA 2",oDlg,{|| f_Operacao( "02" ) },088,044,,,,.T.,,"",,,,.F. )
		//oBtn3	:= TButton():New( 003,190,"MESA 3",oDlg,{|| f_Operacao( "03" ) },088,044,,,,.T.,,"",,,,.F. )

		oBtn5	:= TBtnBmp2():New( 003,020,100,100,'mesa_100_1',,,,{|| f_Operacao( "01" ) },oDlg,,,.T. )
		oBtn6	:= TBtnBmp2():New( 003,220,100,100,'mesa_100_2',,,,{|| f_Operacao( "02" ) },oDlg,,,.T. )
		oBtn7	:= TBtnBmp2():New( 003,420,100,100,'mesa_100_3',,,,{|| f_Operacao( "03" ) },oDlg,,,.T. )

		oBtn8	:= TBtnBmp2():New( 153,020,100,100,'mesa_100_1',,,,{|| f_Operacao( "01" ) },oDlg,,,.T. )
		oBtn9	:= TBtnBmp2():New( 153,220,100,100,'mesa_100_2',,,,{|| f_Operacao( "02" ) },oDlg,,,.T. )
		oBtn10	:= TBtnBmp2():New( 153,420,100,100,'mesa_100_3',,,,{|| f_Operacao( "03" ) },oDlg,,,.T. )

		oBtn11	:= TBtnBmp2():New( 303,020,100,100,'mesa_100_1',,,,{|| f_Operacao( "01" ) },oDlg,,,.T. )
		oBtn12	:= TBtnBmp2():New( 303,220,100,100,'mesa_100_2',,,,{|| f_Operacao( "02" ) },oDlg,,,.T. )
		oBtn13	:= TBtnBmp2():New( 303,420,100,100,'mesa_100_3',,,,{|| f_Operacao( "03" ) },oDlg,,,.T. )

		oBtn17	:= TBtnBmp2():New( 453,220,100,100,'mesa_100_3',,,,{|| f_Operacao( "03" ) },oDlg,,,.T. )

		//oBtn4	:= TButton():New( 052,003,"SAIR",oDlg,{|| oDlg:End() },276,044,,,,.T.,,"",,,,.F. )

		//oBtn5	:= TBtnBmp2():New( 200,004,100,100,'mesa1',,,,{|| f_Operacao( "01" ) },oDlg,,,.T. )
		//oBtn6	:= TBtnBmp2():New( 200,097,100,100,'mesa2',,,,{|| f_Operacao( "02" ) },oDlg,,,.T. )
		//oBtn7	:= TBtnBmp2():New( 200,190,100,100,'mesa3',,,,{|| f_Operacao( "03" ) },oDlg,,,.T. )

		oDlg:Activate(,,,.T.)

		/*
		oWnd:= TWindow():New(0, 0, 150, 150, "Exemplo de TGridLayout", NIL, NIL, NIL, NIL, NIL, NIL, NIL,CLR_BLACK, CLR_BLUE, NIL, NIL, NIL, NIL, NIL, NIL, .T. )

		oLayout1:= tGridLayout():New(oWnd,CONTROL_ALIGN_ALLCLIENT,0,0)
		oLayout1:SetColor(,CLR_WHITE)

		oTButton1 := TButton():New( 0, 0, "Mesa 01", oLayout1,{|| f_Operacao( "01" ) }, 40,30,,,.F.,.T.,.F.,,.F.,,,.F. )
		oTButton2 := TButton():New( 0, 0, "Mesa 02", oLayout1,{|| f_Operacao( "02" ) }, 40,30,,,.F.,.T.,.F.,,.F.,,,.F. )
		oTButton3 := TButton():New( 0, 0, "Mesa 03", oLayout1,{|| f_Operacao( "03" ) }, 40,30,,,.F.,.T.,.F.,,.F.,,,.F. )

		oLayout1:addInLayout(oTButton1, 1, 1)
		oLayout1:addInLayout(oTButton2, 1, 2)
		oLayout1:addInLayout(oTButton3, 1, 3)

		oTButton3 := TButton():New( 0, 0, "Sair", oLayout1,{|| Final() }, 40,30,,,.F.,.T.,.F.,,.F.,,,.F. )
		oLayout1:addInLayout(oTButton3, 2, 1,,3)

		//oBtn5 := TBtnBmp2():New( 200,004,200,200,'mesa1',,,,{||Alert("Botão 02")},oLayout1,,,.T. )
		oBtn5 := TBtnBmp():NewBar( 'mesa1',,,, '', { || f_Operacao( "01" ) }, .F., oLayout1, .T., { || .T. },, .F.,,, 1,,,,, .T. )
		oBtn6 := TBtnBmp():NewBar( 'mesa2',,,, '', { || f_Operacao( "02" ) }, .F., oLayout1, .T., { || .T. },, .F.,,, 1,,,,, .T. )
		oBtn7 := TBtnBmp():NewBar( 'mesa3',,,, '', { || f_Operacao( "03" ) }, .F., oLayout1, .T., { || .T. },, .F.,,, 1,,,,, .T. )

		oLayout1:addInLayout(oBtn5, 3, 1,,1)
		oLayout1:addInLayout(oBtn6, 3, 1,,2)
		oLayout1:addInLayout(oBtn7, 3, 1,,3)

		//ACTIVATE DIALOG oWnd CENTERED

		oWnd:Activate()
		*/


	END SEQUENCE

Return()

Static Function f_CarregaDic()

	PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "FAT" TABLES "SB1"

Return()

Static Function f_Operacao( c_Mesa )

	Local c_Pesq		:= Space(200)

	Private c_Cupom		:= ""
	Private n_Quant		:= 1
	Private aBrowse		:= {}
	Private n_Total		:= 0
	Private n_Servico	:= 0.1
	Private c_HrIni		:= TIME()
	Private n_Item		:= 0

	// 12345678901234567890123456789012345678901234
	//"--------------------------------------------"
	//"             PARCIAL DA MESA 01             "
	//"--------------------------------------------"
	c_Cupom += "-----------------------------------------" + ENTER
	c_Cupom += "             PARCIAL DA MESA " + c_Mesa + ENTER
	c_Cupom += "-----------------------------------------" + ENTER
	c_Cupom += "DATA: " + DTOC( Date() ) + ENTER
	c_Cupom += "HORA: " + c_HrIni + ENTER
	c_Cupom += "-----------------------------------------" + ENTER
	c_Cupom += "It  Produto                Qt   Prc   Tot" + ENTER
	c_Cupom += "-----------------------------------------" + ENTER

	f_CarregaGrid( c_Pesq, .F. )

	oFont1     := TFont():New( "Arial",0,-21,,.T.,0,,700,.F.,.F.,,,,,, )
	oFont2     := TFont():New( "Arial",0,-29,,.T.,0,,700,.F.,.F.,,,,,, )
	oFont3     := TFont():New( "Arial Narrow",0,-19,,.F.,0,,400,.F.,.F.,,,,,, )
	oFont4     := TFont():New( "Courier",0,-9,,.F.,0,,400,.F.,.F.,,,,,, )

	oDlg1      := MSDialog():New( 092,232,594,1114,"Comandas",,,.F.,,,,,,.T.,,,.T. )

	oBtn5      := TButton():New( 004,005,"TRANSFERIR MESA",oDlg1,{|| f_Transferencia( @c_Mesa ) },075,017,,,,.T.,,"",,,,.F. )
	oBtn7      := TButton():New( 004,082,"ESTORNAR ITEM",oDlg1,{|| f_EstornaIt( c_Mesa ) },075,017,,,,.T.,,"",,,,.F. )
	oBtn6      := TButton():New( 004,158,"FECHAR MESA",oDlg1,{|| f_FecharMesa( c_Mesa ) },075,017,,,,.T.,,"",,,,.F. )
	oBtn6      := TButton():New( 004,235,"SAIR",oDlg1,{|| oDlg1:End() },075,017,,,,.T.,,"",,,,.F. )
	oSay1      := TSay():New( 006,350,{|| "MESA: " + c_Mesa },oDlg1,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,112,016)

	oGet2      := TGet():New( 032,005,{|u| If(PCount()>0,c_Pesq:=u,c_Pesq)},oDlg1,187,015,'@!',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	oBtn4      := TButton():New( 032,193,"PESQUISAR",oDlg1,{ || f_CarregaGrid( c_Pesq, .T. ) },038,017,,,,.T.,,"",,,,.F. )

	oBtn2      := TButton():New( 031,257,"-",oDlg1,{|| f_Subrai1() },038,017,,,,.T.,,"",,,,.F. )
	oGet1      := TGet():New( 031,296,{|u| If(PCount()>0,n_Quant:=u,n_Quant)},oDlg1,032,015,'@e 99',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.T.,.F.,,.F.,.F.,"","",,)
	oBtn1      := TButton():New( 031,329,"+",oDlg1,{|| f_Soma1() },038,017,,,,.T.,,"",,,,.F. )
	oBtn3      := TButton():New( 031,372,"CONFIRMAR",oDlg1,{|| f_GravaItem() },038,017,,,,.T.,,"",,,,.F. )

	oBrowse := TSBrowse():New(056,04,250,192,oDlg1,,16,oFont3,3)
	oBrowse:AddColumn( TCColumn():New('Produto',,,{|| },{|| }) )
	oBrowse:AddColumn( TCColumn():New('Preco',,,{|| },{|| }) )
	oBrowse:AddColumn( TCColumn():New('Codigo',,,{|| },{|| }) )
	oBrowse:SetArray(aBrowse)

	oMGet1     := TMultiGet():New( 056,258,{| u | if( pCount() > 0, c_Cupom := u, c_Cupom ) },oDlg1,180,192,oFont4,,CLR_WHITE,CLR_GRAY,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
	oMGet1:EnableVScroll( .T. )
	oMGet1:Disable()

	oDlg1:Activate(,,,.T.)

Return()

Static Function f_FecharMesa( c_Mesa )

	Local c_HrSai	:= Time()
	Local n_Conta	:= 0
	Local n_VlrSV	:= 0

	If MsgYesNo("Deseja encerrar a MESA " + c_Mesa + "?")

		n_VlrSV	:= n_Servico * n_Total
		n_Conta := ( n_Servico * n_Total ) + n_Total

		c_Cupom += "-----------------------------------------" + ENTER
		c_Cupom += "PRODUTOS                    " + Transform( n_Total, "@e 999.99") + ENTER
		c_Cupom += "SERVICO                     " + Transform( n_VlrSV, "@e 999.99") + ENTER
		c_Cupom += "TOTAL                       " + Transform( n_Conta, "@e 999.99") + ENTER
		c_Cupom += "-----------------------------------------" + ENTER
		c_Cupom += "DATA: " + DTOC( Date() ) + ENTER
		c_Cupom += "HORA: " + TIME() + ENTER
		c_Cupom += "PERMANÊNCIA: " + ELAPTIME( c_HrIni, c_HrSai ) + ENTER
		c_Cupom += "-----------------------------------------" + ENTER

	EndIf

Return()

Static Function f_GravaItem()

	Local c_Produto	:= aBrowse[oBrowse:nAt][3]
	Local c_Descric	:= aBrowse[oBrowse:nAt][1]
	Local n_QtdVend	:= Alltrim( Transform(n_Quant, "@e 99") )
	Local n_Preco	:= Alltrim( Transform(val(replace(aBrowse[oBrowse:nAt][2],",",".")), "@e 999.99") )
	Local n_TotPrd	:= Alltrim( Transform(n_Quant * val(replace(aBrowse[oBrowse:nAt][2],",",".")), "@e 999.99") )

	n_Item++
	n_Total += n_Quant * val( Replace( aBrowse[oBrowse:nAt][2],",",".") )
	c_Cupom += 	Strzero( n_Item, 2) + " " + PADR( c_Descric, 24 ) + " " + PADR( n_QtdVend, 2 ) + " " + PADR( n_Preco, 5 ) + " " + PADR( n_TotPrd, 5 ) + ENTER

	n_Quant := 1
	oMGet1:GoEnd()
	oGet1:Refresh()

Return()

Static Function f_CarregaGrid( c_Pesq, l_Comp )

	Local c_Alias	:= GetNextAlias()
	Local c_Where	:= ""

	IF Empty( c_Pesq )
		c_Where := " 1=1 "
		c_Where	:= "%"+ c_Where + "%"
	Else
		c_Where := " B1_DESC LIKE '%" + Upper( Alltrim( c_Pesq ) ) + "%' "
		c_Where	:= "%"+ c_Where + "%"
	EndiF

	BeginSQL Alias c_Alias

		SELECT
			B1_DESC, B1_UPRC, B1_COD
		FROM
			%TABLE:SB1% (NOLOCK)
		WHERE
			%NOTDEL%
			AND %EXP:c_Where%
		ORDER BY
			%Order:SB1,3%

	EndSQL
	dbSelectArea( c_Alias )
	( c_Alias )->( dbGoTop() )
	aBrowse := {}
	While ( c_Alias )->( !EOF())

		AADD( aBrowse, { Alltrim( ( c_Alias )->B1_DESC ), Transform( ( c_Alias )->B1_UPRC, "@E 999.99" ), Alltrim( ( c_Alias )->B1_COD ) } )

		( c_Alias )->( dbSkip() )

	EndDo
	( c_Alias )->( dbCloseArea() )

	If l_Comp
		oBrowse:SetArray(aBrowse)
		oBrowse:Refresh()
		oGet2:SetFocus()
	EndIf

Return()

Static Function f_Soma1()

	n_Quant++
	oGet1:Refresh()

Return()

Static Function f_Subrai1()

	n_Quant--
	If n_Quant < 1
	  n_Quant := 1
	EndIf
	oGet1:Refresh()

Return()

Static Function f_Transferencia( c_Mesa )

	Local n_Opca		:= 0
	Local c_MesaDest	:= Space(2)

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de Variaveis Private dos Objetos                             ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	SetPrvt("oFont1","oDlg2","oBmp1","oGrp1","oGet1","oGrp2","oGet2","oBtn2","oBtn3")

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	oFont1     := TFont():New( "Arial",0,-19,,.T.,0,,700,.F.,.F.,,,,,, )
	oDlg2      := MSDialog():New( 092,232,282,604,"Transferencia de Mesa",,,.F.,,,,,,.T.,,oFont1,.T. )

	oBmp1      := TBitmap():New( 020,072,024,020,,"",.F.,oDlg2,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	oGrp1      := TGroup():New( 004,004,052,064,"Mesa Atual",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oGet1      := TGet():New( 023,020,{|u| If(PCount()>0,c_Mesa:=u,c_Mesa)},oDlg2,020,015,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	oGet1:Disable()

	oGrp2      := TGroup():New( 005,101,052,172,"Mesa Destino",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oGet2      := TGet():New( 024,125,{|u| If(PCount()>0,c_MesaDest:=u,c_MesaDest)},oDlg2,020,013,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

	oBtn2      := TButton():New( 056,056,"Cancelar",oDlg2,{ || n_Opca := 0, oDlg2:End() },052,024,,oFont1,,.T.,,"",,,,.F. )
	oBtn3      := TButton():New( 056,120,"Confirmar",oDlg2,{ || n_Opca := 1, oDlg2:End() },052,024,,oFont1,,.T.,,"",,,,.F. )

	oDlg2:Activate(,,,.T.)

	If n_Opca == 1

		c_Mesa := c_MesaDest

	EndIf

Return()

Static Function f_EstornaIt( c_Mesa )

	Alert("Em Desenvolvimento!")

Return
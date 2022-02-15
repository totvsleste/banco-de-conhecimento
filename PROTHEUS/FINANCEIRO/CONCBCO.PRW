#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "FINA380.CH"
#INCLUDE "FWCOMMAND.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PARMTYPE.CH"
#Include "FWMBROWSE.CH"

#define DMPAPER_A4 9

Static lFWCodFil := .T.

/*/{Protheus.doc} CONCBCO
Programa responsável pela conciliação bancária manual
@author Francisco
@since 31/10/2018
@version 12.1.17
@return Nil, Não esperado

@type function
/*/
User Function CONCBCO()

	Local a_Field1 			:= {}	//Campos da tabela 1
	Local a_Campo1			:= {}	//Campos da grid 1

	Local a_Field2 			:= {}	//Campos da tabela 2
	Local a_Campo2			:= {}	//Campos da grid 2

	Local a_Field3 			:= {}	//Campos da tabela 3
	Local a_Field4 			:= {}	//Campos da tabela 4

	Local o_Table1
	Local o_Table2
	Local o_Table3
	Local o_Table4

	Local n_Opcs			:= 0
	Local l_VldDlg			:= .F.
	Local a_Cores1 			:= { { "TRB->E5_ALTER == 'S'", "BR_VERDE" }, { "TRB->E5_ALTER == 'N'", "BR_VERMELHO" } }
	Local a_Cores2 			:= { { "TRC->ZJV_ALTER == 'S'", "BR_VERDE" }, { "TRC->ZJV_ALTER == 'N'", "BR_VERMELHO" } }

	Private _nRValBco 		:= 0
	Private _nRValExt 		:= 0
	Private _nPValBco 		:= 0
	Private _nPValExt 		:= 0
	Private n_OpcConf		:= 0
	Private c_Chave			:= ""

	Private o_Banco			:= clsRecursoBanco():new()

	Private c_Perg			:= "CONCBCO"
	Private aSelFil			:= {}

	Private c_Marca			:= GetMark()

	Private __cFilAnt  		:= ""
	Private __cEmpAnt  		:= ""
	Private __cNewFil  		:= ""
	Private __cNewEmp  		:= ""

	Private nSldIniBanc		:= 0
	Private nSldFinBanc		:= 0
	Private nValRecT		:= 0
	Private nValPagT		:= 0
	Private nQtdTitR		:= 0
	Private nQtdTitP		:= 0

	Private nZjuIniBanc		:= 0
	Private nZjuFinBanc		:= 0
	Private nVRecT			:= 0
	Private nVPagT			:= 0
	Private nQR				:= 0
	Private nQP				:= 0

	Private cBco380			:= SPACE( TAMSX3("A6_COD")[1] )	//PADR("104", TAMSX3("A6_COD")[1]  ) //
	Private cAge380			:= SPACE( TAMSX3("A6_AGENCIA")[1] ) //PADR("3351", TAMSX3("A6_AGENCIA")[1] ) //
	Private cCta380			:= SPACE( TAMSX3("A6_NUMCON")[1] ) //PADR("1385", TAMSX3("A6_NUMCON")[1] ) //
	Private dIniDt380		:= CTOD("  /  /  ") //CTOD("01/08/2018") //
	Private dFimDt380		:= CTOD("  /  /  ") //CTOD("31/08/2018")	//
	Private c_TipoConc		:= ""

	Private l_Pergunta		:= .T.
	Private n_OpcEsc		:= 0
	Private l_Unilat		:= .F.

	Private oFont1
	Private oDlg1
	Private oGrp1
	Private oSay1
	Private oSay2
	Private oSay3
	Private oSay4
	Private oSay5
	Private oSay6
	Private oGet1
	Private oGet2
	Private oGet3
	Private oGet5
	Private oGet6
	Private oGrp2
	Private oBrw1
	Private oGrp3
	Private oBrw2
	Private oGrp4
	Private oSay7
	Private oSay8
	Private oSay9
	Private oSay10
	Private oSay11
	Private oGet7
	Private oGet8
	Private oGet9
	Private oGet10
	Private oGet11
	Private oGet12

	If o_Table1 <> Nil
		o_Table1:Delete()
		o_Table1 := Nil
	Endif

	//Criacao da tabela temporaria par guardar o SE5
	o_Table1 := FWTemporaryTable():New( "TRB" )

	aadd(a_Field1,{"TB_OK"		,"C"	,02,0})
	aadd(a_Field1,{"E5_FILIAL"	,"C"	,TAMSX3("E5_FILIAL")[1]	,0})
	aadd(a_Field1,{"E5_DTDISPO"	,"D"	,8,0})
	aadd(a_Field1,{"E5_RECPAG"	,"C"	,TAMSX3("E5_RECPAG")[1]		,0})
	aadd(a_Field1,{"E5_VALOR"	,"N"	,14							,2})
	aadd(a_Field1,{"E5_NUMCHEQ"	,"C"	,TAMSX3("E5_NUMCHEQ")[1]	,0})
	aadd(a_Field1,{"E5_PREFIXO"	,"C"	,TAMSX3("E5_PREFIXO")[1]	,0})
	aadd(a_Field1,{"E5_NUMERO"	,"C"	,TAMSX3("E5_NUMERO")[1]		,0})
	aadd(a_Field1,{"E5_TIPO"	,"C"	,TAMSX3("E5_TIPO")[1]		,0})
	aadd(a_Field1,{"E5_BENEF"	,"C"	,TAMSX3("E5_BENEF")[1]		,0})
	aadd(a_Field1,{"E5_HISTOR"	,"C"	,TAMSX3("E5_HISTOR")[1]		,0})
	aadd(a_Field1,{"E5_CLIFOR"	,"C"	,TAMSX3("E5_CLIFOR")[1]		,0})
	aadd(a_Field1,{"E5_LOJA"	,"C"	,TAMSX3("E5_LOJA")[1]		,0})
	aadd(a_Field1,{"E5_XCHAVE"	,"C"	,TAMSX3("E5_XCHAVE")[1]		,0})
	aadd(a_Field1,{"E5_RECNO"	,"N"	,14							,0})
	aadd(a_Field1,{"E5_ALTER"	,"C"	,1							,0})
	aadd(a_Field1,{"E5_LOTE"	,"C"	,TAMSX3("E5_LOTE")[1]		,0})

	o_Table1:SetFields( a_Field1 )
	o_Table1:AddIndex("indice1", {"E5_DTDISPO"} )
	o_Table1:AddIndex("indice2", {"E5_FILIAL","E5_XCHAVE"} )
	o_Table1:Create()

	aAdd(a_Campo1,{"TB_OK"	,,''					,'@!'})
	aAdd(a_Campo1,{"E5_FILIAL"	,,'Filial'			,'@!'})
	aAdd(a_Campo1,{"E5_DTDISPO"	,,'Disponibilidade'	,'@!'})
	aAdd(a_Campo1,{"E5_RECPAG"	,,'Rec/Pag'			,'@!'})
	aAdd(a_Campo1,{"E5_VALOR"	,,'Valor'			,'@e 999,999,999.99'})
	aAdd(a_Campo1,{"E5_NUMCHEQ"	,,'Cheque'			,'@!'})
	aAdd(a_Campo1,{"E5_PREFIXO"	,,'Prefixo'			,'@!'})
	aAdd(a_Campo1,{"E5_NUMERO"	,,'Numero'			,'@!'})
	aAdd(a_Campo1,{"E5_TIPO"	,,'Tipo'			,'@!'})
	aAdd(a_Campo1,{"E5_BENEF"	,,'Benefiario'		,'@!'})
	aAdd(a_Campo1,{"E5_XCHAVE"	,,'Chave'			,'@!'})
	aAdd(a_Campo1,{"E5_HISTOR"	,,'Historico'		,'@!'})
	aAdd(a_Campo1,{"E5_CLIFOR"	,,'Cli/For'			,'@!'})
	aAdd(a_Campo1,{"E5_LOJA"	,,'Loja'			,'@!'})
	aAdd(a_Campo1,{"E5_LOTE"	,,'Lote'			,'@E'})
	aAdd(a_Campo1,{"E5_RECNO"	,,'RECNO'			,'@E'})

	If o_Table3 <> Nil
		o_Table3:Delete()
		o_Table3 := Nil
	Endif

	//Totalizadores por chave
	o_Table3 := FWTemporaryTable():New( "TRD" )
	aadd(a_Field3,{"RD_FILIAL"	,"C"	,TAMSX3("E5_FILIAL")[1]	,0})
	aadd(a_Field3,{"RD_XCHAVE"	,"C"	,TAMSX3("E5_XCHAVE")[1]	,0})
	aadd(a_Field3,{"RD_VALOR"	,"N"	,14						,2})

	o_Table3:SetFields( a_Field3 )
	o_Table3:AddIndex("indice1", {"RD_FILIAL","RD_XCHAVE"} )
	o_Table3:Create()

	If o_Table2 <> Nil
		o_Table2:Delete()
		o_Table2 := Nil
	Endif

	//Criacao da tabela temporaria par guardar o SE5
	o_Table2 := FWTemporaryTable():New( "TRC" )

	aadd(a_Field2,{"TC_OK"		,"C",2,0})
	aadd(a_Field2,{"ZJV_DATA"	,"D",8,0})
	aadd(a_Field2,{"ZJV_TIPO"	,"C",TAMSX3("ZJV_TIPO")[1],1})
	aadd(a_Field2,{"ZJV_VALOR"	,"N",14,2})
	aadd(a_Field2,{"ZJV_NUMDOC"	,"C",TAMSX3("ZJV_NUMDOC")[1],0})
	aadd(a_Field2,{"ZJV_USER"	,"C",TAMSX3("ZJV_USER")[1],0})
	aadd(a_Field2,{"ZJV_HISTOR"	,"C",TAMSX3("ZJV_HISTOR")[1],0})
	aadd(a_Field2,{"ZJV_CHAVE"	,"C",TAMSX3("ZJV_CHAVE")[1],0})
	aadd(a_Field2,{"ZJV_RECNO"	,"N",14,0})
	aadd(a_Field2,{"ZJV_ALTER"	,"C",1,0})

	aAdd(a_Campo2,{"TC_OK"		,,''			,'@D'})
	aAdd(a_Campo2,{"ZJV_DATA"	,,'Data'		,'@!'})
	aAdd(a_Campo2,{"ZJV_TIPO"	,,'Tipo'		,'@!'})
	aAdd(a_Campo2,{"ZJV_VALOR"	,,'Valor'		,'@e 999,999,999.99'})
	aAdd(a_Campo2,{"ZJV_NUMDOC"	,,'Cod.For'		,'@!'})
	aAdd(a_Campo2,{"ZJV_USER"	,,'Usuario'		,'@!'})
	aAdd(a_Campo2,{"ZJV_HISTOR"	,,'Historico'	,'@!'})
	aAdd(a_Campo2,{"ZJV_CHAVE"	,,'Chave'		,'@!'})
	aAdd(a_Campo2,{"ZJV_RECNO"	,,'RECNO'		,'@E'})

	o_Table2:SetFields( a_Field2 )
	o_Table2:AddIndex("indice1", {"ZJV_DATA"} )
	o_Table2:AddIndex("indice2", {"ZJV_CHAVE"} )
	o_Table2:Create()

	If o_Table4 <> Nil
		o_Table4:Delete()
		o_Table4 := Nil
	Endif

	//Totalizadores por chave
	o_Table4 := FWTemporaryTable():New( "TRE" )
	aadd(a_Field4,{"RE_CHAVE"	,"C"	,TAMSX3("ZJV_CHAVE")[1]	,0})
	aadd(a_Field4,{"RE_VALOR"	,"N"	,14,2})

	o_Table4:SetFields( a_Field4 )
	o_Table4:AddIndex("indice1", {"RE_CHAVE"} )
	o_Table4:Create()

	f_ValidPerg()
	If !f_CarregaParametros( "1" )
		Return()
	EndIf
	Processa( { || f_CarregaDados() } , "Aguarde..." , "Carregando dados..." , .F. )

	If MV_PAR01 == 1
		c_TipoConc := "TODOS"
	ELSEIf MV_PAR01 == 2
		c_TipoConc := "NÃO CONCILIADO"
	ELSE
		c_TipoConc := "CONCILIADO"
	ENDIF

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	oFont1     := TFont():New( "Consolas",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )
	oFont2		:= TFont():New( "Calibri",0,18,,.T.,0,,700,.T.,.F.,,,,,, )

	oDlg1      := MSDialog():New( 068,056,643,1313,"Conciliacao Bancaria",,,.F.,,,,,,.T.,,oFont1,.T. )

	//------------------------------ Saldos Bancarios - EMPRESA ---------------------------------------------------------
	oGrp1      := TGroup():New( 030,004,115,180," Saldos Bancarios - EMPRESA ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oSay1      := TSay():New( 039,008,{||"Saldo Anterior:"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
	oGet1      := TGet():New( 038,080,{ |u| If(PCount() > 0, nSldIniBanc := u, nSldIniBanc ) },oGrp1,060,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","")
	//oGet1:Disable()

	oSay2      := TSay():New( 052,008,{||"Saldo Atual:"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
	oGet2      := TGet():New( 051,080,{ |u| If(PCount() > 0, nSldFinBanc := u, nSldFinBanc ) },oGrp1,060,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","")
	//oGet2:Disable()

	oSay3      := TSay():New( 064,008,{||"Valor Recebido:"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	oGet3      := TGet():New( 063,080,{ |u| If(PCount() > 0, nValRecT := u, nValRecT ) },oGrp1,060,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","")
	//oGet3:Disable()

	oSay4      := TSay():New( 077,008,{||"Valor Pago:"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	oGet4      := TGet():New( 076,080,{ |u| If(PCount() > 0, nValPagT := u, nValPagT ) },oGrp1,060,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","")
	//oGet4:Disable()

	oSay5      := TSay():New( 089,008,{||"Docs. Reconc. Receber:"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,008)
	oGet5      := TGet():New( 088,080,{ |u| If(PCount() > 0, nQtdTitR := u, nQtdTitR ) },oGrp1,060,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","")
	//oGet5:Disable()

	oSay6      := TSay():New( 103,008,{||"Docs. Reconc. Pagar:"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,008)
	oGet6      := TGet():New( 102,080,{ |u| If(PCount() > 0, nQtdTitP := u, nQtdTitP ) },oGrp1,060,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","")
	//oGet6:Disable()

	//------------------------------ Saldos Bancarios - BANCO ---------------------------------------------------------
	oGrp4      := TGroup():New( 030,184,115,360," Saldos Bancarios - BANCO ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oSay12     := TSay():New( 039,188,{||"Saldo Anterior:"},oGrp4,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
	oGet12     := TGet():New( 038,268,{ |u| If(PCount() > 0, nZjuIniBanc := u, nZjuIniBanc ) },oGrp4,060,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","")
	//oGet12:Disable()

	oSay11     := TSay():New( 052,188,{||"Saldo Atual:"},oGrp4,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
	oGet11     := TGet():New( 051,268,{ |u| If(PCount() > 0, nZjuFinBanc := u, nZjuFinBanc ) },oGrp4,060,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","")
	//oGet11:Disable()

	oSay10     := TSay():New( 064,188,{||"Valor Recebido:"},oGrp4,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	oGet10     := TGet():New( 063,268,{ |u| If(PCount() > 0, nVRecT := u, nVRecT ) },oGrp4,060,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","")
	//oGet10:Disable()

	oSay9      := TSay():New( 077,188,{||"Valor Pago:"},oGrp4,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	oGet9      := TGet():New( 076,268,{ |u| If(PCount() > 0, nVPagT := u, nVPagT ) },oGrp4,060,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","")
	//oGet9:Disable()

	oSay8      := TSay():New( 089,188,{||"Docs. Reconc. Receber:"},oGrp4,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,008)
	oGet8      := TGet():New( 088,268,{ |u| If(PCount() > 0, nQR := u, nQR ) },oGrp4,060,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","")
	//oGet8:Disable()

	oSay7      := TSay():New( 103,188,{||"Docs. Reconc. Pagar:"},oGrp4,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,008)
	oGet7      := TGet():New( 102,268,{ |u| If(PCount() > 0, nQP := u, nQP ) },oGrp4,060,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","")
	//oGet7:Disable()

	//------------------------------ Botoes de comandos ---------------------------------------------------------
	//------------------------------ Coluna 1 -------------------------------------------------------------------
	oGrp5      := TGroup():New( 030,364,115,628," Acoes ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oBtn1      := TButton():New( 039,368,"Marcar/Desmarcar Todos (SE5)",oGrp5,{ || f_SE5MarcaTodos() },116,012,,oFont1,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( 054,368,"Marcar/Desmarcar Todos (Instituição)",oGrp5,{ || f_ZJVMarcaTodos( "1" ) },116,012,,oFont1,,.T.,,"",,,,.F. )
	oBtn3      := TButton():New( 069,368,"Marcar/Desmarcar Todos (Ambos)",oGrp5,{ || f_SE5MarcaTodos(), f_ZJVMarcaTodos( "2" ) },116,012,,oFont1,,.T.,,"",,,,.F. )

	//Texto com os parâmetros
	oSay13     := TSay():New( 088,410,{|| "CONCILIAÇÃO BANCÁRIA MANUAL ( " + c_TipoConc + " )" },oGrp4,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,232,008)
	oSay14     := TSay():New( 100,410,{|| "BANCO: " + Alltrim( cBco380 ) + " - AGENCIA: " + Alltrim( cAge380 ) +" - CONTA: " + Alltrim( cCta380 ) },oGrp4,,oFont2,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,232,008)

	//------------------------------ Coluna 2 -------------------------------------------------------------------
	oBtn1      := TButton():New( 039,490,"Imprimir",oGrp5,{|| f_Imprimir( MV_PAR01,nSldFinBanc,nSldIniBanc,nValRecT,nValPagT,nSldFinBanc,nSldIniBanc,nVRecT,nVPagT,cBco380,cAge380,cCta380 ) },116,012,,oFont1,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( 054,490,"Visualizar",oGrp5,{|| f_VisualSE5("SE5",TRB->E5_RECNO ) },116,012,,oFont1,,.T.,,"",,,,.F. )
	oBtn3      := TButton():New( 069,490,"Nova Consulta",oGrp5,{|| f_NovaConsulta() },116,012,,oFont1,,.T.,,"",,,,.F. )

	//------------------------------ Movimentacao Bancaria - Protheus (SE5) ---------------------------------------------------------
	oGrp2      := TGroup():New( 118,004,203,628," Movimentação Bancaria - Protheus (SE5) ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oBrw1      := MsSelect():New( "TRB","TB_OK","",a_Campo1,.F.,c_Marca,{126,008,201,624},,,oGrp2,,a_Cores1 )
	oBrw1:oBrowse:Refresh()
	oBrw1:oBrowse:lhasMark 	:= .T.
	oBrw1:oBrowse:lCanAllmark 	:= .F.
	oBrw1:bMark	:= {|| f_MarkSE5() }

	//------------------------------ Movimentacao Bancaria - Banco (Instituicao) ---------------------------------------------------------
	oGrp3      := TGroup():New( 205,004,286,628," Movimentação Bancaria - Banco (Instituição) ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oBrw2      := MsSelect():New( "TRC","TC_OK",,a_Campo2,.F.,c_Marca,{215,008,283,624},,,oGrp3,,a_Cores2 )
	oBrw2:oBrowse:Refresh()
	oBrw2:oBrowse:lhasMark 	:= .T.
	oBrw2:oBrowse:lCanAllmark 	:= .F.
	oBrw2:bMark	:= {|| f_MarkZJV() }

	oDlg1:Activate(,,,.T.,{|| l_VldDlg },,{ || EnchoiceBar( oDlg1, {|| f_Confirma() },{ || oDlg1:End() }, .F., ) } )

	TRB->( dbCloseArea() )
	TRC->( dbCloseArea() )
	TRD->( dbCloseArea() )
	TRE->( dbCloseArea() )

Return()

/*/{Protheus.doc} f_Confirma
Funcao responsável pela gravação da conciliação bancária
@author Francisco
@since 31/10/2018
@version 12.1.17
@return Nil, Não esperado

@type function
/*/
Static Function f_Confirma()

	If !l_Unilat

		_nRValBco := 0
		_nPValBco := 0
		_nRValExt := 0
		_nPValExt := 0

		//------------------------ [ DEFINE TOTAL (MARCADOS) DE MOVIMENTAÇÃO BANCARIA ] ------------------------
		dbSelectArea("TRB")
		TRB->( dbGoTop() )
		While TRB->( !EOF() )
			If TRB->TB_OK == c_Marca
				If TRB->E5_RECPAG == "R"
					_nRValBco	+= TRB->E5_VALOR
				Else
					_nPValBco	+= TRB->E5_VALOR
				EndIf
			EndIf
			TRB->( dbSkip() )
		EndDo

		//------------------------ [ DEFINE TOTAL (MARCADOS) DO ARQUIVO IMPORTADO DO BANCO ] ------------------------
		dbSelectArea("TRC")
		TRC->( dbGoTop() )
		While TRC->( !EOF() )
			If TRC->TC_OK == c_Marca
				If TRC->ZJV_TIPO == "C"
					_nRValExt	+= TRC->ZJV_VALOR
				Else
					_nPValExt	+= TRC->ZJV_VALOR
				EndIf
			EndIf
			TRC->( dbSkip() )
		EndDo

	EndIf

	If( ( _nRValBco == _nPValBco .AND. ( _nPValExt + _nRValExt ) > 0 ) .And. !l_Unilat .And. Mv_Par01 <> 3 )
		If  nValRecT == 0 .And. nValPagT == 0 .And. nVRecT - nVPagT <> 0	//Conciliacao apenas da instituicao.
			Aviso("Valores diferentes","Os valores do Sistema e do Banco não conferem, verifique os valores e corrija",{"Voltar"})
			TRB->( dbGoTop() )
			TRC->( dbGoTop() )
			Return()
		EndIf
	ElseIf( ( ( _nRValExt - _nPValExt ) <> ( _nRValBco - _nPValBco ) ) .And. !l_Unilat .And. Mv_Par01 <> 3 )
		Aviso("Valores diferentes","Os valores do Sistema e do Banco não conferem, verifique os valores e corrija",{"Voltar"})
		TRB->( dbGoTop() )
		TRC->( dbGoTop() )
		Return()
	EndIf

	If( Mv_Par01 == 3 )
		If fCheckSld()
			TRB->( dbGoTop() )
			TRC->( dbGoTop() )
			Return
		EndIf
	EndIf

	n_OpcConf := Aviso("Confirmação","Confirma o procedimento",{"Sim","Não"})

	If n_OpcConf == 2 .OR. n_OpcConf == 0
		TRB->( dbGoTop() )
		TRC->( dbGoTop() )
		Return
	EndIf

	//-------------------------------------------------------------------------------------------------
	//Monta a chave baseado no banco, agencia e conta
	//Utiliza a funcionalidade do SEQUENCE no SQL SERVER
	o_Banco:SEQ_NOME	:= Alltrim( cBco380 ) + "_" + Alltrim( cAge380 ) + "_" + Alltrim( cCta380 )
	o_Banco:SEQ_START	:= 1
	o_Banco:mtdCriaSequence()

	o_Banco:SEQ_MASK	:= '00000000'
	o_Banco:SEQ_TAM		:= "8"
	c_Chave				:= "A" + o_Banco:mtdExecSequence()

	//------------------------ [ GRAVA OS DADOS DA SE5 APÓS CONFIRMAÇÃO ] ------------------------

	__SE5 := GetArea("SE5")
	dbSelectArea("TRB")
	TRB->( dbGoTop() )
	While TRB->( !EOF() )
		SE5->( dbGoTo( TRB->E5_RECNO ) )
		If !SE5->(EOF()) .OR. !SE5->(BOF())
			//Executa apenas para os registros que foram alterados
			If TRB->E5_ALTER == "S"
				RecLock("SE5",.F.)
				If TRB->TB_OK == c_Marca
					SE5->E5_RECONC := "x"
					SE5->E5_XCHAVE := c_Chave
				Else
					SE5->E5_RECONC := " "
					SE5->E5_XCHAVE := " "
				EndIf
				SE5->(MsUnLock())
			EndIf
		EndIf
		TRB->( dbSkip() )
	EndDo
	RestArea( __SE5 )

	If !l_Unilat
		//------------------------ [ GRAVA OS DADOS DA ZJV APÓS CONFIRMAÇÃO ] ------------------------
		__ZJV := GetArea("ZJV")
		dbSelectArea("TRC")
		TRC->( dbGoTop() )
		While TRC->( !EOF() )
			ZJV->(dbGoTo( TRC->ZJV_RECNO ) )
			If !ZJV->(EOF()) .OR. !ZJV->(BOF())
				//Executa apenas para os registros que foram alterados
				If TRC->ZJV_ALTER == "S"
					RecLock("ZJV",.F.)
					If TRC->TC_OK == c_Marca
						ZJV->ZJV_RECONC := "x"
						ZJV->ZJV_CHAVE := c_Chave
					Else
						ZJV->ZJV_RECONC := " "
						ZJV->ZJV_CHAVE := " "
					EndIf
					ZJV->(MsUnLock())
				EndIf
			EndIf
			TRC->( dbSkip() )
		EndDo
		RestArea( __ZJV )
	EndIf

	//------------------------ [ FIM DA AREA DE GRAVAÇÃO ] ------------------------

	Aviso("Procedimento efetuado","Processo efetuado com sucesso !!!",{"Continua"})

	nValRecT	:= 0
	nValPagT	:= 0
	nQtdTitR	:= 0
	nQtdTitP	:= 0

	nVRecT 		:= 0
	nVPagT 		:= 0
	nQR    		:= 0
	nQP    		:= 0

	//------------------------ [ REDEFINE TOTAL (MARCADOS) DE MOVIMENTAÇÃO BANCARIA ] ------------------------
	dbSelectArea("TRB")
	TRB->( dbGoTop() )
	While TRB->( !EOF() )
		If TRB->TB_OK == c_Marca
			If TRB->E5_RECPAG == "R"
				nValRecT += TRB->E5_VALOR
				nQtdTitR++
			Else
				nValPagT += TRB->E5_VALOR
				nQtdTitP++
			EndIf
		EndIf
		TRB->( dbSkip() )
	EndDo

	//------------------------ [ REDEFINE TOTAL (MARCADOS) DO ARQUIVO IMPORTADO DO BANCO ] ------------------------
	If !l_Unilat

		dbSelectArea("TRC")
		TRC->( dbGoTop() )
		While TRC->( !EOF() )
			If TRC->TC_OK == c_Marca
				If TRC->ZJV_TIPO == "C"
					nVRecT	+= TRC->ZJV_VALOR
					nQR++
				Else
					nVPagT	+= TRC->ZJV_VALOR
					nQP++
				EndIf
			EndIf
			TRC->( dbSkip() )
		EndDo

	EndIf

	Processa( { || f_CarregaDados() } , "Aguarde..." , "Carregando dados..." , .F. )
	f_RefreshAll()
	TRB->( dbGoTop() )
	TRC->( dbGoTop() )

Return()

/*/{Protheus.doc} fCheckSld
Função responsável por checar os saldos em tela no momento da gravação
@author J2A
@since 31/10/2018
@version 12.1.17
@return Lógico, retorna Verdadeiro ou Falso

@type function
/*/
Static Function fCheckSld()

	Local lRet    := .F.
	Local nA      := 0
	Local nSldBco := 0
	Local nSldExt := 0

	//Movimentação bancária
	dbSelectArea("TRB")
	TRB->( dbGoTop() )
	While TRB->( !EOF() )
		If TRB->TB_OK <> c_Marca
			If( TRB->E5_RECPAG == "P" )
				nSldBco += TRB->E5_VALOR
			Else
				nSldBco -= TRB->E5_VALOR
			EndIf
		EndIf
		TRB->( dbSkip() )
	EndDo

	//Importação do banco
	dbSelectArea("TRC")
	TRC->( dbGoTop() )
	While TRC->( !EOF() )
		If TRC->TC_OK <> c_Marca
			If TRC->ZJV_TIPO == "D"
				nSldExt	+= TRC->ZJV_VALOR
			Else
				nSldExt	-= TRC->ZJV_VALOR
			EndIf
		EndIf
		TRC->( dbSkip() )
	EndDo


	If( nSldBco <> nSldExt .OR. ( nSldBco + nSldExt ) == 0 ) .And. !l_Unilat

		Help( "" , 1 , "CONCBCO" ,, "Os valores bancários selecionados não conferem com os da movimentação: " + CRLF + ;
		"Movimentação Bancária (SE5): R$" + AllTrim( Transform( nSldBco , "999,999,999,999.99" ) ) + CRLF + ;
		"Dados do Banco - Importação do Banco: R$" + AllTrim( Transform( nSldExt , "999,999,999,999.99" ) ) , 1 , 0 )
		lRet := .T.

	EndIf

Return( lRet )

/*/{Protheus.doc} f_NovaConsulta
Função responsável por gerar uma nova consulta sem precisar fechar a tela.
@author Francisco
@since 31/10/2018
@version 12.1.17
@return Nil, Não esperado

@type function
/*/
Static Function f_NovaConsulta()

	If f_CarregaParametros( "2" )

		Processa( { || f_CarregaDados() } , "Aguarde..." , "Carregando dados..." , .F. )

		If MV_PAR01 == 1
			c_TipoConc := "TODOS"
		ELSEIf MV_PAR01 == 2
			c_TipoConc := "NÃO CONCILIADO"
		ELSE
			c_TipoConc := "CONCILIADO"
		ENDIF
	EndIf

Return()

/*/{Protheus.doc} f_ZJVMarcaTodos
Função responsável por marcar todos os registros das tabelas ZJV
@author Francisco
@since 31/10/2018
@version 12.1.17
@return Nil, Não esperado
@param c_Origem, characters, origem da chamada da função
@type function
/*/
Static Function f_ZJVMarcaTodos( c_Origem )

	Local nX	:= 0
	Local n_Opca	:= 0

	If c_Origem == "1"
		l_Pergunta := .T.
	EndIf

	If l_Pergunta
		n_Opca	:= Aviso(SM0->M0_NOMECOM,"Olá! O que você deseja fazer?",{"Marcar Todos","Desmarcar Todos","Cancelar"},2,"Atenção")
	Else
		n_Opca	:= n_OpcEsc
	EndIf

	dbSelectArea("TRC")
	TRC->( dbGoTop() )
	While TRC->( !EOF() )

		If n_Opca == 1
			IF TRC->TC_OK <> c_Marca

				RecLock("TRC",.F.)
				TRC->TC_OK		:= c_Marca
				TRC->ZJV_ALTER	:= "S"
				MsUnLock()

				If TRC->ZJV_TIPO == "C"
					nVRecT += TRC->ZJV_VALOR
					nQR++
				ElseIf TRC->ZJV_TIPO == "D"
					nVPagT += TRC->ZJV_VALOR
					nQP++
				EndIf
			EndIf

		ElseIf n_Opca == 2
			If TRC->TC_OK == c_Marca

				RecLock("TRC",.F.)
				TRC->TC_OK		:= "  "
				TRC->ZJV_ALTER	:= "S"
				MsUnLock()

				If TRC->ZJV_TIPO	== "C"
					nVRecT -= TRC->ZJV_VALOR
					nQR--
				ElseIf TRC->ZJV_TIPO== "D"
					nVPagT -= TRC->ZJV_VALOR
					nQP--
				EndIf
			EndIf
		EndIf

		TRC->( dbSkip() )
	EndDo

	f_RefreshAll()

Return
/*/{Protheus.doc} f_SE5MarcaTodos
Função responsável por marcar todos os registros das tabelas SE5
@author Francisco
@since 31/10/2018
@version 12.1.17
@return Nil, Não esperado
@type function
/*/
Static Function f_SE5MarcaTodos()

	Local n_Opca	:= Aviso(SM0->M0_NOMECOM,"Olá! O que você deseja fazer?",{"Marcar Todos","Desmarcar Todos","Cancelar"},2,"Atenção")

	dbSelectArea("TRB")
	TRB->( dbGoTop() )
	While TRB->( !EOF() )
		If n_Opca == 1
			l_Pergunta 	:= .F.
			n_OpcEsc 	:= 1
			IF TRB->TB_OK <> c_Marca

				RecLock("TRB",.F.)
				TRB->TB_OK	:= c_Marca
				TRB->E5_ALTER	:= "S"
				MsUnLock()
				If TRB->E5_RECPAG	== "R"
					nValRecT += TRB->E5_VALOR
					nQtdTitR++
				ElseIf TRB->E5_RECPAG	== "P"
					nValPagT += TRB->E5_VALOR
					nQtdTitP++
				EndIf
			EndIF
		ElseIf n_Opca == 2
			l_Pergunta 	:= .F.
			n_OpcEsc	:= 2
			If TRB->TB_OK == c_Marca

				RecLock("TRB",.F.)
				TRB->TB_OK		:= "  "
				TRB->E5_ALTER	:= "S"
				MsUnLock()

				If TRB->E5_RECPAG	== "R"
					nValRecT -= TRB->E5_VALOR
					nQtdTitR--
				ElseIf TRB->E5_RECPAG	== "P"
					nValPagT -= TRB->E5_VALOR
					nQtdTitP--
				EndIf
			EndIF
		EndIf

		TRB->( dbSkip() )
	EndDo

	f_RefreshAll()

Return

/*/{Protheus.doc} f_RefreshAll
Função responsável por atualizar as variáveis de tela
@author Francisco
@since 31/10/2018
@version 12.1.17
@return Nil, Não esperado

@type function
/*/
Static Function f_RefreshAll()

	oGet1:Refresh()
	oGet2:Refresh()
	oGet3:Refresh()
	oGet4:Refresh()
	oGet5:Refresh()
	oGet6:Refresh()
	oGet7:Refresh()
	oGet8:Refresh()
	oGet9:Refresh()
	oGet10:Refresh()
	oGet11:Refresh()
	oGet12:Refresh()
	oSay13:Refresh()
	oSay14:Refresh()
	oBrw1:oBrowse:Refresh()
	oBrw2:oBrowse:Refresh()

Return
/*/{Protheus.doc} f_MarkSE5
Função responsável por recálculos e outras funcionalidades no momento da marcação individual do SE5
@author Francisco
@since 31/10/2018
@version 12.1.17
@return Nil, Não esperado
@param c_Origem, characters, origem da chamada da função
@type function
/*/
Static Function f_MarkSE5()

	Local l_Chave	:= .F.
	Local c_ChveE5	:= ""
	Local c_FilE5	:= ""
	Local d_IniChav	:= CTOD( SuperGetMV( "FS_INICHAV",,"11/10/2018" ) )	//Inicio da funcionalidade do controle de chave
	Local l_Achei	:= .F.

	Local n_ZJVSoma	:= 0	//Somatório do valor da ZJV
	Local n_SE5Soma	:= 0
	Local n_TRDSoma	:= 0	//Somatório do valor da ZJV
	Local n_TRESoma	:= 0

	Local c_SE5Area	:= SE5->( GetArea() )
	Local c_ZJVArea	:= ZJV->( GetArea() )

	Local c_RecPag	:= ""

	RecLock("TRB", .F. )
	TRB->E5_ALTER	:= IIF( TRB->E5_ALTER == "N","S","N")
	MsUnLock()

	dbSelectArea("TRB")
	IF TRB->TB_OK <> c_Marca

		dbSelectArea("TRC")
		TRC->( dbGoTop() )

		//------------------------------------------------------------
		//Retirado por: Francisco Rezende
		//Em: 26/11/2018
		//Solicitado por: Glaucia
		//Motivo: Sujeira na base de dados. Foi detectado vários problemas no conceito de chave utilizado no passado.
		//If ( !Empty( TRB->E5_XCHAVE ) )
		//If Aviso(SM0->M0_NOMECOM,"Olá! Deseja desfazer a conciliação de forma Manual ou pela Chave?",{"Chave","Manual"},2,"Atenção") == 1
		//l_Chave := .T.
		//EndIf
		//EndIf
		//Fim
		//-------------------------------------------------------------

		If !l_Chave

			If TRB->E5_RECPAG	== "R"
				nValRecT -= TRB->E5_VALOR
				nQtdTitR--
			ElseIf TRB->E5_RECPAG	== "P"
				nValPagT -= TRB->E5_VALOR
				nQtdTitP--
			EndIf

			While TRC->(!EOF() )
				If TRC->ZJV_TIPO = "C"
					c_RecPag	:= "R"
				Else
					c_RecPag	:= "P"
				EndIf
				If TRB->E5_DTDISPO == TRC->ZJV_DATA .And. TRB->E5_VALOR = TRC->ZJV_VALOR .And. TRC->TC_OK == c_Marca .And. TRB->E5_RECPAG == c_RecPag
					If Aviso(SM0->M0_NOMECOM,"Olá! Encontrei esse mesmo valor marcado no mesmo dia no arquivo de importação, deseja que eu o desmarque para você?",{"Sim","Não"},2,"Atenção") == 1
						RecLock("TRC", .F. )
						TRC->TC_OK		:= "  "
						TRC->ZJV_ALTER	:= IIF( TRC->ZJV_ALTER == "N","S","N")
						MsUnLock()
						If TRC->ZJV_TIPO == "C"
							nVRecT -= TRC->ZJV_VALOR
							nQR--
						ElseIf TRC->ZJV_TIPO == "D"
							nVPagT -= TRC->ZJV_VALOR
							nQP--
						EndIf
						l_Achei := .T.
						Exit
					EndIf
				EndIf
				TRC->( dbSkip() )
			EndDo

		Else

			n_TRDSoma	:= 0
			n_TRESoma	:= 0
			c_ChveE5	:= TRB->E5_XCHAVE
			c_FilE5		:= TRB->E5_FILIAL
			n_SE5Soma	:= f_TotSE5Chave( c_FilE5, cBco380, cAge380, cCta380, c_ChveE5 )
			n_ZJVSoma	:= f_TotZJVChave( Substr( c_FilE5, 1, 4 ), cBco380, cAge380, cCta380, c_ChveE5 )

			//A tabela TRD contem o valor total selecionado conforme os parâmetros por chave
			dbSelectArea("TRD")
			dbSetOrder(1)
			If dbSeek( c_FilE5 + c_ChveE5 )
				n_TRDSoma := TRD->RD_VALOR
			EndIf

			//A tabela TRE contem o valor total selecionado conforme os parâmetros por chave
			dbSelectArea("TRE")
			dbSetOrder(1)
			iF dbSeek( c_ChveE5 )
				n_TRESoma := TRE->RE_VALOR
			EndIf

			//----------------------------------------------------------------------------------
			//Preciso comparar se o total por chave nos arquivos de trabalho
			//correspondem aos seus totais em suas respectivas tabelas
			//Por exemplo:
			//O arquivo TRB (as movimentações do SE5 filtrado) == TRD (as movimentações do SE5)
			//O arquivo TRC (as movimentações do ZJV filtrado) == TRD (as movimentações do ZJV)
			//----------------------------------------------------------------------------------
			If ( n_SE5Soma == n_TRDSoma) .And. ( n_TRESoma == n_ZJVSoma )

				TRB->( dbSetOrder(2) )
				TRB->( dbSeek( c_FilE5 + c_ChveE5 ) )
				While TRB->( !EOF() ) .And. TRB->E5_FILIAL == c_FilE5 .And. TRB->E5_XCHAVE == c_ChveE5

					RecLock("TRB", .F. )
					TRB->TB_OK		:= "  "
					TRB->E5_ALTER	:= "S"
					MsUnLock()

					If TRB->E5_RECPAG == "R"
						nValRecT -= TRB->E5_VALOR
						nQtdTitR--
					ElseIf TRB->E5_RECPAG == "P"
						nValPagT -= TRB->E5_VALOR
						nQtdTitP--
					EndIf

					TRB->( dbSkip() )

				EndDo

				TRC->( dbSetOrder(2) )
				TRC->( dbSeek( c_ChveE5 ) )
				While TRC->(!EOF() ) .And. TRC->ZJV_CHAVE == c_ChveE5

					RecLock("TRC", .F. )
					TRC->TC_OK		:= "  "
					TRC->ZJV_ALTER	:= "S"
					MsUnLock()

					If TRC->ZJV_TIPO == "C"
						nVRecT -= TRC->ZJV_VALOR
						nQR--
					ElseIf TRC->ZJV_TIPO == "D"
						nVPagT -= TRC->ZJV_VALOR
						nQP--
					EndIf

					TRC->( dbSkip() )

				EndDo
			Else

				ShowHelpDlg("Conciliação Bancária",;
				{"A soma total da chave " + TRB->E5_XCHAVE + " não corresponde ao valor total no Protheus!"},5,;
				{"Utilize a opção Manual ou aumente o período da busca!"},5)

				RecLock("TRB", .F. )
				TRB->TB_OK		:= c_Marca
				TRB->E5_ALTER	:= IIF( TRB->E5_ALTER == "N","S","N")
				MsUnLock()

				TRB->( dbSetOrder(1) )
				TRC->( dbSetOrder(1) )
				RestArea( c_SE5Area )
				RestArea( c_ZJVArea )
				f_RefreshAll()
				Return()
			EndIf
		Endif

	ELSE

		If TRB->E5_RECPAG	== "R"
			nValRecT += TRB->E5_VALOR
			nQtdTitR++
		ElseIf TRB->E5_RECPAG	== "P"
			nValPagT += TRB->E5_VALOR
			nQtdTitP++
		EndIf

		dbSelectArea("TRC")
		TRC->( dbGoTop() )
		While TRC->(!EOF() )
			If TRC->ZJV_TIPO = "C"
				c_RecPag	:= "R"
			Else
				c_RecPag	:= "P"
			EndIf
			If TRB->E5_DTDISPO == TRC->ZJV_DATA .And. TRB->E5_VALOR = TRC->ZJV_VALOR .And. TRB->E5_RECPAG == c_RecPag
				If Aviso(SM0->M0_NOMECOM,"Olá! Encontrei esse mesmo valor e no mesmo dia lá no arquivo de importação, deseja que eu o selecione para você?",{"Sim","Não"},2,"Atenção") == 1
					RecLock("TRC", .F. )
					TRC->TC_OK		:= c_Marca
					TRC->ZJV_ALTER	:= IIF( TRC->ZJV_ALTER == "N","S","N")
					MsUnLock()
					If TRC->ZJV_TIPO == "C"
						nVRecT += TRC->ZJV_VALOR
						nQR++
					ElseIf TRC->ZJV_TIPO == "D"
						nVPagT += TRC->ZJV_VALOR
						nQP++
					EndIf
					l_Achei := .T.
					Exit
				EndIf
			EndIf
			TRC->( dbSkip() )
		EndDo

	ENDIF

	If !l_Achei
		TRC->( dbGoTop() )
	EndIf

	TRB->( dbSetOrder(1) )
	TRC->( dbSetOrder(1) )
	RestArea( c_SE5Area )
	RestArea( c_ZJVArea )

	f_RefreshAll()

Return()

Static Function f_TotSE5Chave( c_FilSE5, c_BcoSE5, c_AgeSE5, c_CtaSE5, c_ChvSE5 )

	Local n_VlrSE5	:= 0

	BeginSQL Alias "QE5"

		SELECT E5_FILIAL, E5_BANCO, E5_AGENCIA, E5_CONTA, E5_XCHAVE, SUM(E5_VALOR) AS QE5_VALOR
		FROM SE5010 E5
		WHERE E5.%NOTDEL%
		AND E5_FILIAL = %exp:c_FilSE5%
		AND E5_BANCO = %exp:c_BcoSE5%
		AND E5_AGENCIA = %exp:c_AgeSE5%
		AND E5_CONTA = %exp:c_CtaSE5%
		AND E5_XCHAVE = %exp:c_ChvSE5%
		GROUP BY E5_FILIAL, E5_BANCO, E5_AGENCIA, E5_CONTA, E5_XCHAVE

	EndSQL
	dbSelectArea("QE5")
	n_VlrSE5 := QE5->QE5_VALOR
	QE5->( dbCloseArea() )

Return( n_VlrSE5 )

Static Function f_TotZJVChave( c_FilZJV, c_BcoZJV, c_AgeZJV, c_CtaZJV, c_ChvZJV )

	Local n_VlrZJV	:= 0

	BeginSQL Alias "QJV"

		SELECT ZJV_FILIAL, ZJV_BANCO, ZJV_AGENCI, ZJV_CONTA, ZJV_CHAVE, SUM(ZJV_VALOR) AS QJV_VALOR
		FROM ZJV010 ZJV
		WHERE ZJV.%NOTDEL%
		AND ZJV_FILIAL = %exp:c_FilZJV%
		AND ZJV_BANCO = %exp:c_BcoZJV%
		AND ZJV_AGENCI = %exp:c_AgeZJV%
		AND ZJV_CONTA = %exp:c_CtaZJV%
		AND ZJV_CHAVE = %exp:c_ChvZJV%
		GROUP BY ZJV_FILIAL, ZJV_BANCO, ZJV_AGENCI, ZJV_CONTA, ZJV_CHAVE

	EndSQL
	dbSelectArea("QJV")
	n_VlrZJV := QJV->QJV_VALOR
	QJV->( dbCloseArea() )

Return( n_VlrZJV )

/*/{Protheus.doc} f_MarkSE5
Função responsável por recálculos e outras funcionalidades no momento da marcação individual do ZJV
@author Francisco
@since 31/10/2018
@version 12.1.17
@return Nil, Não esperado
@param c_Origem, characters, origem da chamada da função
@type function
/*/
Static Function f_MarkZJV()

	dbSelectArea("TRC")
	RecLock("TRC", .F. )
	TRC->ZJV_ALTER	:= IIF( TRC->ZJV_ALTER == "N","S","N")
	MsUnLock()

	If TRC->TC_OK <> c_Marca
		If TRC->ZJV_TIPO	== "C"
			nVRecT -= TRC->ZJV_VALOR
			nQR--
		ElseIf TRC->ZJV_TIPO == "D"
			nVPagT -= TRC->ZJV_VALOR
			nQP--
		EndIf
	Else
		If TRC->ZJV_TIPO == "C"
			nVRecT += TRC->ZJV_VALOR
			nQR++
		ElseIf TRC->ZJV_TIPO == "D"
			nVPagT += TRC->ZJV_VALOR
			nQP++
		EndIf
	EndIf

	f_RefreshAll()

Return

/*/{Protheus.doc} f_ZeraValores
Função responsável por zerar os valores das variáveis de tela.
@author Francisco
@since 31/10/2018
@version 12.1.17
@return Nil, Não esperado

@type function
/*/
Static Function f_ZeraValores()

	nValRecT 	:= 0
	nQtdTitR	:= 0
	nValPagT 	:= 0
	nQtdTitP	:= 0
	nVRecT 		:= 0
	nQR			:= 0
	nVPagT		:= 0
	nQP			:= 0
	nSldIniBanc	:= 0
	nZjuIniBanc	:= 0
	nZjuFinBanc	:= 0
	nSldFinBanc	:= 0

	dbSelectArea( "TRB" )
	TRB->( dbGoTop() )
	While TRB->( !EOF() )
		RecLock("TRB",.F.)
		dbDelete()
		MsUnlock()
		TRB->( dbSkip() )
	EndDo

	dbSelectArea( "TRC" )
	TRC->( dbGoTop() )
	While TRC->( !EOF() )
		RecLock( "TRC", .F. )
		dbDelete()
		MsUnlock()
		TRC->( dbSkip() )
	EndDo

	dbSelectArea( "TRD" )
	TRD->( dbGoTop() )
	While TRD->( !EOF() )
		RecLock( "TRD", .F. )
		dbDelete()
		MsUnlock()
		TRD->( dbSkip() )
	EndDo

	dbSelectArea( "TRE" )
	TRE->( dbGoTop() )
	While TRE->( !EOF() )
		RecLock( "TRE", .F. )
		dbDelete()
		MsUnlock()
		TRE->( dbSkip() )
	EndDo

Return()

/*/{Protheus.doc} f_CarregaDados
Função responsável por carregar os dados das tabelas temporárias TRB (SE5) e TRC (ZJV)
@author Francisco
@since 31/10/2018
@version 12.1.17
@return Nil, Não esperado

@type function
/*/
Static Function f_CarregaDados()

	Local cAliasTMP   	:= GetNextAlias() //Criando um alias de memoria
	Local cTipoDoc 		:= FormatIn( AllTrim( SuperGetMv("MV_TPDOC",.F.,"BA/JR/MT") ) , "/" )
	Local cQuery  	 	:= ""

	f_ZeraValores()

	cQuery += " E5_TIPODOC NOT IN " + cTipoDoc

	If MV_PAR01 == 2  //NÃO CONCILIADOS
		cQuery += " AND E5_RECONC = '' "
	ElseIf MV_PAR01 == 3  //CONCILIADOS
		cQuery += " AND E5_RECONC <> '' "
	EndIf

	If MV_PAR02 = 1
		cQuery += " AND E5_RECPAG = 'R' "
	ElseIf MV_PAR02 = 2
		cQuery += " AND E5_RECPAG = 'P' "
	EndIf

	If !Empty(MV_PAR13)
		cQuery += " AND E5_BENEF LIKE '%" + ALLTRIM( MV_PAR13 ) + "%' "
	EndIf

	If !Empty(MV_PAR14)
		cQuery += " AND E5_HISTOR LIKE '%" + ALLTRIM( MV_PAR14 ) + "%' "
	EndIf

	If( Select( cAliasTMP ) > 0 )
		( cAliasTMP )->( DbCloseArea() )
	EndIf

	cQuery := "%" + cQuery + "%"

	BeginSql Alias cAliasTMP

		SELECT E5_RECONC, E5_FILIAL, E5_DTDISPO, E5_RECPAG, E5_VALOR, E5_NUMCHEQ, E5_PREFIXO, E5_NUMERO, E5_TIPO, E5_BENEF, E5_HISTOR, E5_CLIFOR,
		E5_LOJA, E5_XCHAVE, R_E_C_N_O_
		FROM %TABLE:SE5%
		WHERE SUBSTRING( %XFILIAL:SE5% , 1 , 4 ) = %Exp:Substr(__cNewFil,1,4)%
		AND E5_DATA BETWEEN %Exp:dIniDt380% AND %Exp:dFimDt380%
		AND E5_BANCO = %Exp:cBco380%
		AND E5_AGENCIA = %Exp:cAge380%
		AND E5_CONTA = %Exp:cCta380%
		AND E5_SITUACA <> %Exp:'C'%
		AND E5_VALOR BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND E5_NUMCHEQ BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		AND E5_PREFIXO BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%
		AND E5_NUMERO BETWEEN %Exp:MV_PAR09% AND %Exp:MV_PAR10%
		AND E5_TIPO BETWEEN %Exp:MV_PAR11% AND %Exp:MV_PAR12%
		AND E5_CLIFOR BETWEEN %Exp:MV_PAR16% AND %Exp:MV_PAR17%
		AND E5_XCHAVE BETWEEN %Exp:MV_PAR18% AND %Exp:MV_PAR19%
		AND E5_VALOR > %EXP:0%
		AND E5_LOTE BETWEEN %Exp:MV_PAR20% AND %Exp:MV_PAR21%
		AND %NOTDEL%
		AND %Exp:cQuery%

	EndSql

	DbSelectArea( cAliasTMP )
	( cAliasTMP )->( DbGoTop() )
	While( ( cAliasTMP )->( !EOF() ) )

		dbSelectArea( "TRB" )
		RecLock( "TRB", .T. )
		TRB->TB_OK		:= IIF( EMPTY( ( cAliasTMP )->E5_RECONC ), "  ", c_Marca )
		TRB->E5_FILIAL	:= ( cAliasTMP )->E5_FILIAL
		TRB->E5_DTDISPO	:= Stod( ( cAliasTMP )->E5_DTDISPO )
		TRB->E5_RECPAG	:= ( cAliasTMP )->E5_RECPAG
		TRB->E5_VALOR	:= ( cAliasTMP )->E5_VALOR
		TRB->E5_NUMCHEQ	:= ( cAliasTMP )->E5_NUMCHEQ
		TRB->E5_PREFIXO	:= ( cAliasTMP )->E5_PREFIXO
		TRB->E5_NUMERO	:= ( cAliasTMP )->E5_NUMERO
		TRB->E5_TIPO	:= ( cAliasTMP )->E5_TIPO
		TRB->E5_BENEF	:= ( cAliasTMP )->E5_BENEF
		TRB->E5_HISTOR	:= ( cAliasTMP )->E5_HISTOR
		TRB->E5_CLIFOR	:= ( cAliasTMP )->E5_CLIFOR
		TRB->E5_LOJA	:= ( cAliasTMP )->E5_LOJA
		TRB->E5_XCHAVE	:= ( cAliasTMP )->E5_XCHAVE
		TRB->E5_RECNO	:= ( cAliasTMP )->R_E_C_N_O_
		TRB->E5_ALTER	:= "N"
		MsUnlock()

		//--------------------------------------------
		//Totaliza por chave
		//Esses valores serão confrontados no momento
		//desconciliar um movimento por chave
		//--------------------------------------------
		dbSelectArea("TRD")
		dbSetOrder(1)
		If dbSeek( ( cAliasTMP )->E5_FILIAL + ( cAliasTMP )->E5_XCHAVE )
			RecLock("TRD", .F.)
			TRD->RD_VALOR	+= ( cAliasTMP )->E5_VALOR
			MsUnlock()
		Else
			RecLock("TRD", .T.)
			TRD->RD_FILIAL	:= ( cAliasTMP )->E5_FILIAL
			TRD->RD_XCHAVE	:= ( cAliasTMP )->E5_XCHAVE
			TRD->RD_VALOR	:= ( cAliasTMP )->E5_VALOR
			MsUnlock()
		EndIf
		//--------------------------------------------

		If !EMPTY(( cAliasTMP )->E5_RECONC)
			If ( cAliasTMP )->E5_RECPAG	== "R"
				nValRecT += ( cAliasTMP )->E5_VALOR
				nQtdTitR++
			ElseIf ( cAliasTMP )->E5_RECPAG	== "P"
				nValPagT += ( cAliasTMP )->E5_VALOR
				nQtdTitP++
			EndIf
		EndIf

		( cAliasTMP )->( DbSkip() )

	EndDo
	( cAliasTMP )->( DbCloseArea() )
	TRB->( dbGoTop() )

	//------------------------ [ CARREGA OS DADOS DO SZJ - ARQUIVO IMPORTADO DO BANCO ] ------------------------

	//Alteração inclusa por Otaviano Mattos - 27/08/2018 - Inicio da Alteração
	cQuery := " 1 = 1 "
	//TODOS, NÃO CONCILIADOS, CONCILIADOS
	If MV_PAR01 == 2  //NÃO CONCILIADOS
		cQuery += " AND ZJV_RECONC = '' "
	ElseIf MV_PAR01 == 3  //CONCILIADOS
		cQuery += " AND ZJV_RECONC <> '' "
	EndIf

	If MV_PAR02 = 1
		cQuery += " AND ZJV_TIPO = 'C' "
	ElseIf MV_PAR02 = 2
		cQuery += " AND ZJV_TIPO = 'D' "
	EndIf

	If !Empty(MV_PAR15)
		cQuery += " AND ZJV_HISTOR LIKE '%" + ALLTRIM ( MV_PAR15 ) + "%' "
	EndIf

	cQuery   := "%" + cQuery + "%"

	If( Select( cAliasTMP ) > 0 )
		( cAliasTMP )->( DbCloseArea() )
	EndIf

	BeginSql Alias cAliasTMP

		SELECT ZJV_RECONC, ZJV_DATA, ZJV_TIPO, ZJV_VALOR, ZJV_NUMDOC, ZJV_USER, ZJV_HISTOR, ZJV_CHAVE, R_E_C_N_O_
		FROM %TABLE:ZJV%
		WHERE SUBSTRING( %XFILIAL:ZJV% , 1 , 4 ) = %Exp:Substr(__cNewFil,1,4)%
		AND ZJV_DATA BETWEEN %Exp:dIniDt380% AND %Exp:dFimDt380%
		AND ZJV_BANCO = %Exp:cBco380%
		AND ZJV_AGENCI = %Exp:cAge380%
		AND ZJV_CONTA = %Exp:cCta380%
		AND ZJV_VALOR BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		AND ZJV_NUMDOC BETWEEN %Exp:MV_PAR09% AND %Exp:MV_PAR10%
		AND ZJV_CHAVE BETWEEN %Exp:MV_PAR18% AND %Exp:MV_PAR19%
		AND ZJV_VALOR > %EXP:0%
		AND %NOTDEL%
		AND %Exp:cQuery%

	EndSql

	DbSelectArea( cAliasTMP )
	( cAliasTMP )->( DbGoTop() )
	While( ( cAliasTMP )->( .NOT. EOF() ) )

		dbSelectArea("TRC")
		RecLock("TRC", .T. )
		TRC->TC_OK		:= IIF( EMPTY( ( cAliasTMP )->ZJV_RECONC ), "  ", c_Marca )
		TRC->ZJV_DATA	:= STOD( ( cAliasTMP )->ZJV_DATA )
		TRC->ZJV_TIPO	:= ( cAliasTMP )->ZJV_TIPO
		TRC->ZJV_VALOR	:= ( cAliasTMP )->ZJV_VALOR
		TRC->ZJV_NUMDOC	:= ( cAliasTMP )->ZJV_NUMDOC
		TRC->ZJV_USER	:= ( cAliasTMP )->ZJV_USER
		TRC->ZJV_HISTOR	:= ( cAliasTMP )->ZJV_HISTOR
		TRC->ZJV_CHAVE	:= ( cAliasTMP )->ZJV_CHAVE
		TRC->ZJV_RECNO	:= ( cAliasTMP )->R_E_C_N_O_
		TRC->ZJV_ALTER	:= "N"

		//--------------------------------------------
		//Totaliza por chave
		//Esses valores serão confrontados no momento
		//desconciliar um movimento por chave
		//--------------------------------------------
		dbSelectArea("TRE")
		dbSetOrder(1)
		If dbSeek( ( cAliasTMP )->ZJV_CHAVE )
			RecLock("TRE", .F.)
			TRE->RE_VALOR	+= ( cAliasTMP )->ZJV_VALOR
			MsUnlock()
		Else
			RecLock("TRE", .T.)
			TRE->RE_CHAVE	:= ( cAliasTMP )->ZJV_CHAVE
			TRE->RE_VALOR	:= ( cAliasTMP )->ZJV_VALOR
			MsUnlock()
		EndIf
		//--------------------------------------------

		If !EMPTY(( cAliasTMP )->ZJV_RECONC)
			If ( cAliasTMP )->ZJV_TIPO	== "C"
				nVRecT += ( cAliasTMP )->ZJV_VALOR
				nQR++
			ElseIf ( cAliasTMP )->ZJV_TIPO	== "D"
				nVPagT += ( cAliasTMP )->ZJV_VALOR
				nQP++
			EndIf
		EndIf

		( cAliasTMP )->( DbSkip() )

	EndDo
	TRC->( dbGoTop() )
	( cAliasTMP )->( DbCloseArea() )

	//------------------------ [ CARREGA OS VALORES DE SALDO ATUAL E ANTERIOR DO BANCO PARA O PERIODO ] ------------------------

	__aAreaSE8 := GetArea()

	//Armazena Filial Inicial
	__cAntFil := cFilAnt

	//Altera para a Filial do Banco
	cFilAnt   := __cNewFil

	dbSelectArea( "SE8" )
	SE8->( dbSetOrder(1) )
	SE8->( dbgotop() )
	SE8->( dbSeek( xFilial("SE8") + cBco380 + cAge380 + cCta380 + Dtos( dIniDt380 ), .T. ) )
	//ALERT("SAL ANTES DO dbskip -1 E8"+STR(SE8->E8_SALATUA,14))
	SE8->(dbSkip( -1 ))
	//ALERT("SAL ANTERIOR E8"+STR(SE8->E8_SALATUA,14))

	If xFilial("SE8") != SE8->E8_FILIAL .OR. SE8->E8_BANCO != cBco380 .OR. SE8->E8_AGENCIA != cAge380 .OR. SE8->E8_CONTA != cCta380 .OR. SE8->( BOF() ) .OR. SE8->( EOF() )
		nSldIniBanc	:= 0					//Saldo anterior (Bancario)
	Else
		nSldIniBanc	:= SE8->E8_SALATUA		//Saldo anterior
	EndIf

	//---------------COLUNA BANCOS--------------//

	dbSelectArea( "ZJU" )
	ZJU->( dbSetOrder(1) )
	ZJU->( dbgotop() )
	ZJU->( dbSeek( xFilial("ZJU") + cBco380 + cAge380 + cCta380 + Dtos( dIniDt380 ), .T. ) )
	//ALERT("SAL ANTES DO dbskip -1 E8"+STR(SE8->E8_SALATUA,14))
	//ZJU->(dbSkip( -1 ))
	//ALERT("SAL ANTERIOR E8"+STR(SE8->E8_SALATUA,14))

	If xFilial("ZJU") != ZJU->ZJU_FILIAL .OR. ZJU->ZJU_BANCO != cBco380 .OR. ZJU->ZJU_AGENCI != cAge380 .OR. ZJU->ZJU_CONTA != cCta380 .OR. ZJU->( BOF() ) .OR. ZJU->( EOF() )
		nZjuIniBanc	:= 0					//Saldo anterior (Bancario)
	Else
		nZjuIniBanc	:= ZJU->ZJU_SALINI		//Saldo anterior
	EndIf

	dbSelectArea( "ZJU" )
	ZJU->( dbSetOrder(1) )
	ZJU->( dbgotop() )
	ZJU->( dbSeek( xFilial("ZJU") + cBco380 + cAge380 + cCta380 + Dtos( dFimDt380 ), .T. ) )
	If xFilial ("ZJU") != ZJU->ZJU_FILIAL .OR. ZJU->ZJU_BANCO != cBco380 .OR. ZJU->ZJU_AGENCIA != cAge380 .OR. ZJU->(ZJU_CONTA) != cCta380 .OR. Dtos(dFimDt380) != DTOS(ZJU->ZJU_DATAEX) .OR. BOF() .OR. EOF()
		ZJU->( dbSkip(-1) )
		lSaldoAtu := !( ZJU->ZJU_FILIAL+ZJU->ZJU_BANCO+ZJU->ZJU_AGENCI+ZJU->ZJU_CONTA != xFilial("SE8")+cBco380+cAge380+cCta380 .OR. SE8->( BOF() ) .OR. SE8->( EOF() ) )
	Else
		lSaldoAtu := .T.
	Endif

	// Atualiza o valor do saldo atual
	If !lSaldoAtu
		nZjuFinBanc	:= 0					/*Saldo atual (Bancario)*/
	Else
		nZjuFinBanc	:= ZJU->ZJU_SALFIN		/*Saldo atual (Reconciliados)*/
	EndIf

	//---------------COLUNA BANCOS--------------//

	dbSelectArea( "SE8" )
	SE8->( dbSetOrder(1) )
	SE8->( dbgotop() )
	SE8->( dbSeek( xFilial("SE8") + cBco380 + cAge380 + cCta380 + Dtos( dFimDt380 ), .T. ) )
	If xFilial ("SE8") != SE8->(E8_FILIAL) .OR. SE8->(E8_BANCO) != cBco380 .OR. SE8->(E8_AGENCIA) != cAge380 .OR. SE8->(E8_CONTA) != cCta380 .OR. Dtos(dFimDt380) != DTOS(SE8->E8_DTSALAT) .OR. BOF() .OR. EOF()
		SE8->( dbSkip(-1) )
		lSaldoAtu := !( SE8->E8_FILIAL + SE8->E8_BANCO + SE8->E8_AGENCIA + SE8->E8_CONTA != xFilial("SE8") + cBco380 + cAge380 + cCta380 .OR. SE8->( BOF() ) .OR. SE8->( EOF() ) )
	Else
		lSaldoAtu := .T.
	Endif

	// Atualiza o valor do saldo atual
	If !lSaldoAtu
		nSldFinBanc	:= 0					/*Saldo atual (Bancario)*/
	Else
		nSldFinBanc	:= E8_SALATUA		/*Saldo atual (Reconciliados)*/
	EndIf

	RestArea( __aAreaSE8 )

	cFilAnt := __cAntFil

	If TRB->(EOF()) .OR. TRC->(EOF())
		l_Unilat	:= .T.
	EndIf

Return()

/*/{Protheus.doc} f_ValidPerg
Função responsável pela criação do grupo de perguntas
@author Francisco
@since 21/09/2018
@version 12.1.17
@return Nil, Não Esperado
@param c_Perg, characters, Grupo de Perguntas
@type function
/*/
Static Function f_ValidPerg()

	Local o_PutSX1		:= clsComponentes():New()

	//o_PutSX1:mtdPutSX1( X1_GRUPO, X1_ORDEM, X1_PERGUNT, X1_PERSPA, X1_PERENG, X1_VARIAVL, X1_TIPO, X1_TAMANHO, X1_DECIMAL, X1_PRESEL, X1_GSC, X1_VALID, X1_VAR01, X1_DEF01, X1_DEFSPA1, X1_DEFENG1, X1_CNT01, X1_VAR02, X1_DEF02, X1_DEFSPA2, X1_DEFENG2, X1_CNT02, X1_VAR03, X1_DEF03, X1_DEFSPA3, X1_DEFENG3, X1_CNT03, X1_VAR04, X1_DEF04, X1_DEFSPA4, X1_DEFENG4, X1_CNT04, X1_VAR05, X1_DEF05, X1_DEFSPA5, X1_DEFENG5, X1_CNT05, X1_F3, X1_PYME, X1_GRPSXG, X1_HELP, X1_PICTURE, X1_IDFIL )
	o_PutSX1:mtdPutSX1( c_Perg, "01", "Conciliado?      ", "", "", "mv_ch1", "N", 01, 0, 0, "C", "", "MV_PAR01", "Todos", "", "", "", "", "Não Conciliado", "", "", "", "", "Conciliado", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" )
	o_PutSX1:mtdPutSX1( c_Perg, "02", "Carteira?        ", "", "", "mv_ch2", "N", 01, 0, 0, "C", "", "MV_PAR02", "A Receber", "", "", "", "", "A Pagar", "", "", "", "", "Ambas", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" )
	o_PutSX1:mtdPutSX1( c_Perg, "03", "Valor de?        ", "", "", "mv_ch3", "N", 16, 2, 0, "G", "", "MV_PAR03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" )
	o_PutSX1:mtdPutSX1( c_Perg, "04", "Valor ate?       ", "", "", "mv_ch4", "N", 16, 2, 0, "G", "", "MV_PAR04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" )
	o_PutSX1:mtdPutSX1( c_Perg, "05", "Num Cheque de?   ", "", "", "mv_ch5", "C", 15, 0, 0, "G", "", "MV_PAR05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" )
	o_PutSX1:mtdPutSX1( c_Perg, "06", "Num Cheque Ate?  ", "", "", "mv_ch6", "C", 15, 0, 0, "G", "", "MV_PAR06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" )
	o_PutSX1:mtdPutSX1( c_Perg, "07", "Prefixo de?      ", "", "", "mv_ch7", "C", 03, 0, 0, "G", "", "MV_PAR07", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" )
	o_PutSX1:mtdPutSX1( c_Perg, "08", "Prefixo ate?     ", "", "", "mv_ch8", "C", 03, 0, 0, "G", "", "MV_PAR08", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" )
	o_PutSX1:mtdPutSX1( c_Perg, "09", "Numero de?       ", "", "", "mv_ch9", "C", 09, 0, 0, "G", "", "MV_PAR09", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" )
	o_PutSX1:mtdPutSX1( c_Perg, "10", "Numero ate?      ", "", "", "mv_cha", "C", 09, 0, 0, "G", "", "MV_PAR10", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" )
	o_PutSX1:mtdPutSX1( c_Perg, "11", "Tipo de?         ", "", "", "mv_chb", "C", 03, 0, 0, "G", "", "MV_PAR11", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" )
	o_PutSX1:mtdPutSX1( c_Perg, "12", "Tipo ate?        ", "", "", "mv_chc", "C", 03, 0, 0, "G", "", "MV_PAR12", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" )
	o_PutSX1:mtdPutSX1( c_Perg, "13", "Beneficiário?    ", "", "", "mv_chd", "C", 30, 0, 0, "G", "", "MV_PAR13", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" )
	o_PutSX1:mtdPutSX1( c_Perg, "14", "Hist. Mov. Banco?", "", "", "mv_che", "C", 40, 0, 0, "G", "", "MV_PAR14", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" )
	o_PutSX1:mtdPutSX1( c_Perg, "15", "Hist. Arq. Banco?", "", "", "mv_che", "C", 25, 0, 0, "G", "", "MV_PAR15", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" )
	o_PutSX1:mtdPutSX1( c_Perg, "16", "Cli/For de?      ", "", "", "mv_chf", "C", 09, 0, 0, "G", "", "MV_PAR16", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" )
	o_PutSX1:mtdPutSX1( c_Perg, "17", "Cli/For ate?     ", "", "", "mv_chg", "C", 09, 0, 0, "G", "", "MV_PAR17", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" )
	o_PutSX1:mtdPutSX1( c_Perg, "18", "Chave de?        ", "", "", "mv_chh", "C", 09, 0, 0, "G", "", "MV_PAR18", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" )
	o_PutSX1:mtdPutSX1( c_Perg, "19", "Chave ate?       ", "", "", "mv_chi", "C", 09, 0, 0, "G", "", "MV_PAR19", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" )
	o_PutSX1:mtdPutSX1( c_Perg, "20", "Lote de?         ", "", "", "mv_chj", "C", 04, 0, 0, "G", "", "MV_PAR20", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" )
	o_PutSX1:mtdPutSX1( c_Perg, "21", "Lote Ate??       ", "", "", "mv_chl", "C", 04, 0, 0, "G", "", "MV_PAR21", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" )

	//o_PutSX1:mtdPutSX1( c_Perg, "03", "Vencimento de?   ", "", "", "mv_ch4", "N", 01, 0, 2, "C", "", "MV_PAR03", "Entrada", "", "", "", "", "Saida", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" )

Return()

/*/{Protheus.doc} f_CarregaParametros
Função responsável por carregar os parâmetros de configuração da rotina
@author Francisco
@since 31/10/2018
@version 12.1.17
@return Nil, Não esperado
@param c_Origem, characters, origem da chamada da função
@type function
/*/
Static Function f_CarregaParametros( c_Origem )

	Local lGestao   	:= Iif( lFWCodFil, FWSizeFilial() > 2, .F. )	// Indica se usa Gestao Corporativa
	Local lF380VLD		:= ExistBlock("F380VLD",.F.,.F.)
	Local dDTLimRec		:= GetMV("MV_DATAREC")
	Local nEspLin     	:= 0
	Local nEspLarg		:= 0
	Local oDlgX

	//Seleciona Empresa e Filiais
	If c_Origem == "1"
		If lGestao
			aSM0 := FWLoadSM0()
			If FWModeAccess("SA6",3) == "C" .And. FWModeAccess("SE5",3) == "E"
				aSelFil := FwSelectGC()
			Endif
		Endif
	EndIf

	dbSelectArea("SE5")
	dbSetOrder(1)
	dbSeek(xFilial("SE5"))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chamada da funcao pergunte                                   ³
	//³ mv_par01 - Visibilidade                                      ³
	//³          1 - Todos                                           ³
	//³          2 - NÃO CONCILIADOs                                 ³
	//³          3 - Conciliados                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Pergunte( c_Perg, .T. )
		Return(.F.)
	EndIf

	If MV_PAR01 = 1
		cCadastro := ""	//"Conciliação Bancária Manual (TODOS)"
	ElseIf MV_PAR01 = 2
		cCadastro := "" //"Conciliação Bancária Manual (NÃO CONCILIADOS)"
	Else
		cCadastro := "" //"Conciliação Bancária Manual (CONCILIADOS)"
	EndIf

	dbSelectArea("SE5")
	dbSetOrder(1)
	dbSeek(xFilial("SE5"))

	__cFilAnt  := cFilAnt
	__cEmpAnt  := cEmpAnt
	__cNewFil  := Iif( Len(aSelFil)>=1 , aSelFil[1], cFilAnt )
	__cNewEmp  := cEmpAnt

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Altera o Ambiente para a Nova Empresa  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄAÙ
	StaticCall(RSPM001,GPEGETEMPR,__cNewEmp+__cNewFil)

	DEFINE MSDIALOG oDlgX FROM	91,83 TO 278,412 TITLE cCadastro PIXEL

	oDlgX:lMaximized := .F.
	oPanel := TPanel():New(0,0,'',oDlgX,, .T., .T.,, ,20,20)
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT

	@ 000 + nEspLin, 003 + nEspLarg TO 073+nEspLin,163+nEspLarg OF oPanel  PIXEL

	//Banco
	@ 011 + nEspLin, 010 + nEspLarg SAY OemToAnsi(STR0020) SIZE 20, 7 OF oPanel PIXEL
	@ 009 + nEspLin, 045 + nEspLarg MSGET cBco380	F3 "SA6" Picture PesqPict("SE8","E8_BANCO") Valid CarregaSA6( cBco380,,,.T. ) SIZE 17, 10 OF oPanel Hasbutton PIXEL

	//Agencia
	@ 026 + nEspLin, 010 + nEspLarg SAY OemToAnsi(STR0021) SIZE 24, 7 OF oPanel PIXEL
	@ 024 + nEspLin, 045 + nEspLarg MSGET cAge380	Picture PesqPict("SE8","E8_AGENCIA")  Valid CarregaSA6( cBco380, cAge380,,.T. ) SIZE 32, 10 OF oPanel PIXEL

	//Conta
	@ 042 + nEspLin, 010 + nEspLarg SAY OemToAnsi(STR0022) SIZE 20, 7 OF oPanel PIXEL
	@ 040 + nEspLin, 045 + nEspLarg MSGET cCta380	Picture PesqPict("SE8","E8_CONTA") Valid CarregaSA6( cBco380, cAge380, cCta380,.T. ) SIZE 47, 10 OF oPanel PIXEL

	//De
	@ 057 + nEspLin, 010 + nEspLarg SAY OemToAnsi(STR0027) SIZE 20, 7 OF oPanel PIXEL
	@ 056 + nEspLin, 045 + nEspLarg MSGET dIniDt380	Picture "99/99/99" VALID (dIniDt380 > dDtLimRec) SIZE 50, 10 OF oPanel Hasbutton PIXEL

	//Ate
	@ 058 + nEspLin, 098 + nEspLarg SAY OemToAnsi(STR0024) SIZE 20, 7 OF oPanel PIXEL
	@ 056 + nEspLin, 114 + nEspLarg MSGET dFimDt380	Picture "99/99/99" VALID ((dFimDt380 > dDtLimRec) .and. (dFimDt380 >= dIniDt380)) SIZE 50, 10 OF oPanel Hasbutton PIXEL

	DEFINE SBUTTON FROM 76, 104 TYPE 1 ENABLE ACTION (nOpca:=1,oDlgX:End()) OF oPanel
	DEFINE SBUTTON FROM 76, 132 TYPE 2 ENABLE ACTION oDlgX:End() OF oPanel

	ACTIVATE MSDIALOG oDlgX CENTERED

Return(.T.)

/*/{Protheus.doc} f_VisualSE5
Função responsável por visualizar o título no SE5 e rastreio.
@author Francisco
@since 31/10/2018
@version 12.1.17
@return Nil, Não esperado
@param c_Alias, characters, Alias do Arquivo
@param n_RecnoSE5, numeric, RECNO do Arquivo
@type function
/*/
Static Function f_VisualSE5( c_Alias, n_RecnoSE5 )

	Local aArea 		:= GetArea()
	Local aButtons 		:= {{'PROJETPMS',{|| Eval(bTracker) },"Rastrear Títulos","Rastrear"}}

	Private bTracker	:= {|| f_Rastrear( SE5->E5_RECPAG, SE5->E5_FILIAL, SE5->E5_PREFIXO, SE5->E5_NUMERO, SE5->E5_PARCELA, SE5->E5_TIPO, SE5->E5_LOTE ) }
	Private cCadastro	:= "Movimento Bancário"

	dbSelectArea("SE5")
	SE5->( dbGoTo( n_RecnoSE5 ) )

	//u_fTracker( SE5->E5_RECPAG, SE5->E5_FILIAL, SE5->E5_PREFIXO, SE5->E5_NUMERO, SE5->E5_PARCELA, SE5->E5_TIPO, SE5->E5_LOTE )

	AxVisual( c_Alias, n_RecnoSE5, 2,,,,, aButtons )

	RestArea( aArea )

Return

/*/{Protheus.doc} f_Rastrear
Função responsável por rastrear da movimentação bancária para o título de origem
@author Francisco
@since 31/10/2018
@version 12.1.17
@return Nil, Não esperado
@param __cRecPag, c, tipo do movimento P/R
@param __cFilial, c, Filial do Título
@param __cPrefixo, c, Prefixo do Título
@param __cNumero, c, Numero do Título
@param __cParcela, c, Parcela do Título
@param __cTipo, c, Tipo do Título
@param __cLote, c, Lote do Título
@type function
/*/
Static Function f_Rastrear(__cRecPag,__cFilial,__cPrefixo,__cNumero,__cParcela, __cTipo, __cLote )

	Local oBrowse
	Local cFilter

	Private cCadastro
	Private aRotina := {}
	aAdd(aRotina,{"Visualizar","AXVISUAL",2,2,0,Nil})

	If Empty(__cNumero) .AND. Empty(__cLote)
		Aviso("Sem rastro","Não existe documento de origem para ser rastreado",{"Voltar"})
		Return(Nil)
	EndIf

	If __cRecPag == "R"

		cCadastro := "TITULO RECEBER"

		If( Empty( __cLote ) .OR. .NOT. Empty( __cNumero ) )
			cFilter := "E1_NUM = '"+__cNumero+"' .AND. E1_FILIAL = '" + __cFilial + "' .AND. E1_PREFIXO = '" + __cPrefixo + "' .AND. E1_PARCELA = '" + __cParcela + "' .AND. E1_TIPO = '" + __cTipo + "' "
		Else
			cFilter := "E1_LOTE = '"+__cLote+"' "
		EndIf

		DbSelectArea("SE1")
		DbSetOrder(1)
		DEFINE FWMBROWSE oBrowse ALIAS "SE1" NO DETAILS DESCRIPTION cCadastro FILTERDEFAULT cFilter

	Else

		cCadastro := "TITULO A PAGAR"

		If( Empty( __cLote ) .OR. .NOT. Empty( __cNumero ) )
			cFilter := "E2_NUM = '"+__cNumero+"' .AND. E2_FILIAL = '" + __cFilial + "' .AND. E2_PREFIXO = '" + __cPrefixo + "' .AND. E2_PARCELA = '" + __cParcela + "' .AND. E2_TIPO = '" + __cTipo + "' "
		Else
			cFilter := "E2_LOTE = '"+__cLote+"' "
		EndIf

		DbSelectArea("SE2")
		DbSetOrder(1)
		DEFINE FWMBROWSE oBrowse ALIAS "SE2" NO DETAILS DESCRIPTION cCadastro FILTERDEFAULT cFilter

	EndIf

	oBrowse:ACTIVATE()
Return(Nil)

/*/{Protheus.doc} f_Imprimir
Função responsável pela impressão da conciliação
@author Francisco
@since 31/10/2018
@version 12.1.17
@return Nil, Não esperado
@param __cTIPO, c, Tipo
@param __nSldAtu, c, Saldo Atual
@param __nSldAnt, c, Saldo Anterior
@param __nValRec, c, Valor Recebido
@param __nValPag, c, Valor Pago
@param __nSdAt, c, Saldo Atual
@param __nSdAn, c, Saldo Anterior
@param __nVlRec, c, Valor Recebido
@param __nVlPag, c, Valor Pago
@param cBco380, characters, Banco
@param cAge380, characters, Agencia
@param cCta380, characters, Conta Corrente
@type function
/*/
Static Function f_Imprimir( __cTIPO,__nSldAtu,__nSldAnt,__nValRec,__nValPag,__nSdAt,__nSdAn,__nVlRec,__nVlPag,cBco380,cAge380,cCta380)

	Private oReport
	Private oSection
	Private oSection2
	Private oFont16 	:= TFont():New( "Calibri",0,16,,.T.,0,,700,.T.,.F.,,,,,, )
	Private oFont12 	:= TFont():New( "Calibri",0,12,,.T.,0,,700,.T.,.F.,,,,,, )
	PRIVATE cTitulo 	:= ""

	PRIVATE cBco380
	PRIVATE cAge380
	PRIVATE cCta380

	PRIVATE __cInfoCta := OemToAnsi( "BANCO: " + Transform( cBco380, "9999" ) ) + OemToAnsi( " - AGENCIA: " + Transform( cAge380, "9999" ) ) + OemToAnsi( " - CONTA: " + Transform( cCta380, "9999" ) )

	If __cTipo == 1
		cTitulo := 'TODOS OS TIPOS (CONCILIADOS E NÃO CONCILIADOS) / '+__cInfoCta
	ElseIf __cTipo == 2
		cTitulo := 'NÃO CONCILIADOS / '+__cInfoCta
	Else
		cTitulo := 'CONCILIADO / '+__cInfoCta
	EndIf

	oReport   := TReport():New('RPFIN001', cTitulo, , {|oReport| PrintReport(__cTipo,__nSldAtu,__nSldAnt,__nValRec,__nValPag,__nSdAt,__nSdAn,__nVlRec,__nVlPag,cBco380,cAge380,cCta380)},"Este relatorio ira iprimir Movientações Bancárias Conciliadas e Não Conciliadas.")

	oSection  :=TRSection():New(oReport,"SE5","DADOS DO SISTEMA")
	oSection2 :=TRSection():New(oReport,"ZJV","DADOS DO ARQUIVO DO BANCO")
	oSection:SetTotalInLine(.F.)
	oSection:lHeaderVisible := .F.
	oSection:SetLineStyle(.F.)
	oSection:SetLineHeight(30)
	oSection:SetColSpace(1)
	oSection:SetLeftMargin(0)
	oSection:SetLinesBefore(2)
	oSection:SetCols(0)
	oSection:SetHeaderSection(.T.)
	oSection:SetHeaderPage(.F.)
	oSection:SetHeaderBreak(.F.)
	oSection:SetLineBreak(.F.)
	oSection:SetAutoSize(.F.)
	oSection:SetPageBreak(.F.)
	oSection:SetBorder('',,,.T.)
	oSection:aTable := {}

	TRCell():New(oSection , "E5_FILIAL"	, "SE5", 'FILIAL'		,PesqPict('SE5',"E5_FILIAL")	,TamSX3("E5_FILIAL")[1]+1	,.T. ,{|| TRB->E5_FILIAL })
	TRCell():new(oSection , "E5_DATA"	, "SE5", 'DATA DISP.'	,PesqPict('SE5',"E5_DATA")		,TamSX3("E5_DTDISPO")[1]+1	,.T. ,{|| TRB->E5_DTDISPO })
	TRCell():new(oSection , "E5_RECPAG"	, "SE5", 'REC/PAG'		,PesqPict('SE5',"E5_RECPAG")	,TamSX3("E5_RECPAG")[1]+1	,.T. ,{|| TRB->E5_RECPAG })
	TRCell():new(oSection , "E5_VALOR"	, "SE5", 'VALOR MOVIM.'	,PesqPict('SE5',"E5_VALOR")		,TamSX3("E5_VALOR")[1]+1	,.T. ,{|| TRB->E5_VALOR })
	TRCell():new(oSection , "E5_NUMCHEQ", "SE5", 'NUM. CHEQUE'	,PesqPict('SE5',"E5_NUMCHEQ")	,TamSX3("E5_NUMCHEQ")[1]+1	,.T. ,{|| TRB->E5_NUMCHEQ })
	TRCell():new(oSection , "E5_PREFIXO", "SE5", 'PRFIXO'		,PesqPict('SE5',"E5_PREFIXO")	,TamSX3("E5_PREFIXO")[1]+1	,.T. ,{|| TRB->E5_PREFIXO })
	TRCell():new(oSection , "E5_NUMERO"	, "SE5", 'NUMERO'		,PesqPict('SE5',"E5_NUMERO")	,TamSX3("E5_NUMERO")[1]+1	,.T. ,{|| TRB->E5_NUMERO })
	TRCell():new(oSection , "E5_TIPO"	, "SE5", 'TIPO'  		,PesqPict('SE5',"E5_TIPO")		,TamSX3("E5_TIPO")[1]+1		,.T. ,{|| TRB->E5_TIPO })
	TRCell():new(oSection , "E5_BENEF"	, "SE5", 'BENEFICIÁRIO'	,PesqPict('SE5',"E5_BENEF")		,TamSX3("E5_BENEF")[1]+1	,.T. ,{|| TRB->E5_BENEF })
	TRCell():new(oSection , "E5_HISTOR"	, "SE5", 'HISTÓRICO'	,PesqPict('SE5',"E5_HISTOR")	,TamSX3("E5_HISTOR")[1]+1	,.T. ,{|| TRB->E5_HISTOR })
	TRCell():new(oSection , "E5_CLIFOR" , "SE5", 'CLI/FOR'		,PesqPict('SE5',"E5_CLIFOR")	,TamSX3("E5_CLIFOR")[1]+1	,.T. ,{|| TRB->E5_CLIFOR })
	TRCell():new(oSection , "E5_LOJA"	, "SE5", 'LOJA'			,PesqPict('SE5',"E5_LOJA")		,TamSX3("E5_LOJA")[1]+1		,.T. ,{|| TRB->E5_LOJA })
	TRCell():New(oSection , "E5_OK" 	, "SE5", 'STATUS'		,PesqPict('SE5',"E5_OK"    )	,TamSX3("E5_OK")[1]+1		,.T. ,{|| IIF( TRB->TB_OK == c_Marca,"X"," ") })
	TRCell():new(oSection , "E5_XCHAVE" , "SE5", 'CHAVE'		,PesqPict('SE5',"E5_XCHAVE")	,TamSX3("E5_XCHAVE")[1]+1	,.T. ,{|| TRB->E5_XCHAVE })


	TRCell():New(oSection2 , "ZJV_DATA"		, "ZJV", 'DATA'		,PesqPict('ZJV',"ZJV_DATA")		,TamSX3("ZJV_DATA")[1]+1	,.T. ,{|| TRC->ZJV_DATA })
	TRCell():new(oSection2 , "ZJV_TIPO"		, "ZJV", 'TIPO'		,PesqPict('ZJV',"ZJV_TIPO")		,TamSX3("ZJV_TIPO")[1]+1	,.T. ,{|| TRC->ZJV_TIPO })
	TRCell():new(oSection2 , "ZJV_VALOR"	, "ZJV", 'VALOR'	,PesqPict('ZJV',"ZJV_VALOR")	,TamSX3("ZJV_VALOR")[1]+1	,.T. ,{|| TRC->ZJV_VALOR })
	TRCell():new(oSection2 , "ZJV_NUMDOC"	, "ZJV", 'NUMERO'	,PesqPict('ZJV',"ZJV_NUMDOC")	,TamSX3("ZJV_NUMDOC")[1]+1	,.T. ,{|| TRC->ZJV_NUMDOC })
	TRCell():new(oSection2 , "ZJV_USER"		, "ZJV", 'USUARIO'	,PesqPict('ZJV',"ZJV_USER")		,TamSX3("ZJV_USER")[1]+1	,.T. ,{|| TRC->ZJV_USER })
	TRCell():new(oSection2 , "ZJV_HISTOR"	, "ZJV", 'HISTORICO',PesqPict('ZJV',"ZJV_HISTOR")	,TamSX3("ZJV_HISTOR")[1]+1	,.T. ,{|| TRC->ZJV_HISTOR })
	TRCell():new(oSection2 , "ZJV_CHAVE"	, "ZJV", 'CHAVE'	,PesqPict('ZJV',"ZJV_CHAVE")	,TamSX3("ZJV_CHAVE")[1]+1	,.T. ,{|| TRC->ZJV_CHAVE })
	TRCell():New(oSection2 , "ZJV_OK" 		, "ZJV", 'STATUS'	,PesqPict('ZJV',"ZJV_OK"    )	,TamSX3("ZJV_OK")[1]+1		,.T. ,{|| IIF( TRC->TC_OK == c_Marca,"X"," ") })

	oReport:PrintDialog()

Return (oReport)

/*/{Protheus.doc} PrintReport
Função auxiliar da impressão
@author Francisco
@since 31/10/2018
@version 12.1.17
@return Nil, Não esperado
@param __cTIPO, c, Tipo
@param __nSldAtu, c, Saldo Atual
@param __nSldAnt, c, Saldo Anterior
@param __nValRec, c, Valor Recebido
@param __nValPag, c, Valor Pago
@param __nSdAt, c, Saldo Atual
@param __nSdAn, c, Saldo Anterior
@param __nVlRec, c, Valor Recebido
@param __nVlPag, c, Valor Pago
@param cBco380, characters, Banco
@param cAge380, characters, Agencia
@param cCta380, characters, Conta Corrente
@type function
/*/
Static Function PrintReport(__cTipo,__nSldAtu,__nSldAnt,__nValRec,__nValPag,__nSdAt,__nSdAn,__nVlRec,__nVlPag,cBco380,cAge380,cCta380)

	oReport:SkipLine(3)

	oReport:Say(245,100, OemToAnsi("EMPRESA - Saldo Atual: "+Transform(__nSldAtu,"@E 999,999,999.99"))+OemToAnsi(" - Saldo Anterior: "+Transform(__nSldAnt,"@E 999,999,999.99"))+OemToAnsi(" - Valor Recebido: "+Transform(__nValRec,"@E 999,999,999.99"))+OemToAnsi(" - Valor Pago: "+Transform(__nValPag,"@E 999,999,999.99")),oFont12)
	oReport:SkipLine(3)

	oReport:FatLine()
	oReport:FatLine()

	oReport:SetMeter( 500 )
	oSection:Init()

	dbSelectArea("TRB")
	TRB->( dbGoTop() )
	While TRB->( !EOF() )

		If __cTipo == 2
			oSection:OnPrintLine({|| iif(TRB->TB_OK <> c_Marca, .T., .F.)})
		ElseIf __cTipo == 3
			oSection:OnPrintLine({|| iif(TRB->TB_OK == c_Marca, .T., .F.)})
		Endif

		oReport:IncMeter()
		oSection:PrintLine()
		If oReport:Cancel()
			Exit
		Endif

		TRB->( dbSkip() )
	EndDo

	oReport:EndPage()

	cTitulo := "EXTRATO BANCÁRIO"

	//----------------------------------------[ INICIO DA SEGUNDA SEÇÃO ]----------------------------------------
	oReport:SkipLine(3)
	oReport:Say(245,100, OemToAnsi("BANCO - Saldo Atual: "+Transform(__nSldAtu,"@E 999,999,999.99"))+OemToAnsi(" - Saldo Anterior: "+Transform(__nSldAnt,"@E 999,999,999.99"))+OemToAnsi(" - Valor Recebido: "+Transform(__nValRec,"@E 999,999,999.99"))+OemToAnsi(" - Valor Pago: "+Transform(__nValPag,"@E 999,999,999.99")),oFont12)
	oReport:SkipLine(3)

	oReport:FatLine()
	oReport:FatLine()

	oSection2:Init()

	dbSelectArea("TRC")
	TRC->( dbGoTop() )
	While TRC->( !EOF() )

		If __cTipo == 2
			oSection2:OnPrintLine( { || iif( TRC->TC_OK <> c_Marca, .T., .F. ) } )
		ElseIf __cTipo == 3
			oSection2:OnPrintLine( { || iif( TRC->TC_OK == c_Marca, .T., .F. ) } )
		Endif

		oReport:IncMeter()
		oSection2:PrintLine()
		If oReport:Cancel()
			Exit
		Endif
		TRC->( dbSkip() )
	EndDo

	oSection:Finish()
	oSection2:Finish()

	TRB->( dbGoTop() )
	TRC->( dbGoTop() )

Return

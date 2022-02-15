#INCLUDE "TOTVS.CH"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

#DEFINE EMPRESA IIF(cEmpAnt=="99","1",cEmpAnt)
#DEFINE FILIAL cFilAnt
#DEFINE ENTER CHR(13) + CHR(10)
#DEFINE SECAO IIF(cEmpAnt=="99","01",cEmpAnt) + "." + cFilAnt

/*/{Protheus.doc} FVITA009
Programa responavel por gravar a transferencia entre filiais dos EPIs

@type function
@author francisco.ssa
@since 03/06/2016
@version 11.80

@return Nil, Nao esperado

@example
(examples)

@see (links_or_references)
/*/
User Function FVITA009()

	Local c_Perg		:= "FVITA009"
	Local o_TempTrab	:= clsComponentes():New()
	Local a_Fields		:= {}
	Local c_Query		:= ""
	Local a_Strut 		:= {}
	Local a_Index		:= {}
	Local c_AliasSA1	:= ""
	Local n_Opca		:= 0
	Local n_Oper		:= 1

	Private c_Marca	:= GetMark()

	//Estrutura
	Aadd(a_Strut, {"FS_OK"		,"C",2,0} )
	Aadd(a_Strut, {"FS_COD"		,"C",TAMSX3("A1_COD")[1],0} )
	Aadd(a_Strut, {"FS_NOME"	,"C",TAMSX3("A1_NOME")[1],0} )
	Aadd(a_Strut, {"FS_CGC"		,"C",TAMSX3("A1_CGC")[1],0} )
	Aadd(a_Strut, {"FS_VENCLC"	,"D",8,0} )
	Aadd(a_Strut, {"FS_MUN"		,"C",TAMSX3("A1_MUN")[1],0} )
	Aadd(a_Strut, {"FS_MCOMPRA"	,"N",TAMSX3("A1_MCOMPRA")[1],0} )

	//Índices
	AADD( a_Index, {"FS_COD"} )
	AADD( a_Index, {"FS_NOME"} )


	If n_Oper == 1
		c_Query := " SELECT '  ' AS FS_OK, A1_COD, A1_NOME, A1_CGC, A1_VENCLC, A1_MUN, A1_MCOMPRA "
		c_Query += " FROM " + RetSQLName( "SA1" ) + " SA1 "
		c_Query += " WHERE SA1.A1_FILIAL = '" + xFilial("SA1") + "' "
	Else
		//Nesse exemplo temos uma perda de performance, já que essa consulta será executada de fato aqui e no INSERT INTO do método mtdArqTrab
		BeginSQL Alias "QRY"
			SELECT '  ' AS FS_OK, A1_COD, A1_NOME, A1_CGC, A1_VENCLC, A1_MUN, A1_MCOMPRA
			FROM %TABLE:SA1% SA1
			WHERE SA1.A1_FILIAL = %XFILIAL:SA1%
			AND SA1.%NOTDEL%
		EndSQL
		c_Query		:= GetLastQuery()[2]
		QRY->( dbCloseArea() )
	EndIf

	//Método para criação do arquivo de trabalho
	c_AliasSA1 := o_TempTrab:mtdArqTrab( c_Query, a_Strut, a_Index )

	Aadd(a_Fields, {"FS_OK"			,,'  '     	 	,'@!'})
	Aadd(a_Fields, {"FS_COD"		,,'Produto'		,'@!'})
	Aadd(a_Fields, {"FS_NOME"		,,'Descrição'	,'@!'})
	Aadd(a_Fields, {"FS_CGC"		,,'CA'			,''})
	Aadd(a_Fields, {"FS_VENCLC"		,,'Validade CA'	,''})
	Aadd(a_Fields, {"FS_MUN"		,,'Serial'		,''})
	Aadd(a_Fields, {"FS_MCOMPRA"	,,'Lote'		,''})


	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de Variaveis Private dos Objetos                             ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	SetPrvt("oFont1","oDlg1","oGrp1","oBrw1")

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	oFont1     := TFont():New( "Verdana",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )
	oDlg1      := MSDialog():New( 092,232,634,1271,"Transferência entre Filiais",,,.F.,,,,,,.T.,,oFont1,.T. )
	oDlg1:bInit := {||EnchoiceBar(oDlg1,,,.F.,{})}
	oGrp1      := TGroup():New( 001,001,255,520,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oBrw1      := MsSelect():New( c_AliasSA1,"FS_OK","",a_Fields,.F.,c_Marca,{033,003,250,518},,, oGrp1 )
	//o_Brw1:bMark				:= {|| f_SelectUser() }
	oBrw1:oBrowse:lhasMark 	:= .T.
	oBrw1:oBrowse:lCanAllmark 	:= .T.
	oBrw1:oBrowse:bAllMark 	:= {|| f_MarcaTudo() }

	oDlg1:Activate(,,,.T.,,,{|| EnchoiceBar(oDlg1,{|| n_Opca:=1, oDlg1:End() },{|| n_Opca := 0, oDlg1:End() },.F.)})	//,a_Buttons)})

	IF n_Opca == 1

		Alert("Clicou no ok!")

	ENDIF

	//Apaga o arquivo de trabalho no banco Temp
	o_TempTrab:mtdClearArqTrab()

Return()


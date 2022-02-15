User Function FFINA01L( c_Opca )

	Local o_TempTable 	:= FWTemporaryTable():New( "TRB" )	//criar um arquivo de trabalho no TEMP do SGDB
	Local a_Fields 		:= {}
	Local a_Campos		:= {}
	Local n_Opca		:= 0
	Local aCores 		:= {{"TRB->FS_RECCP <> '3'","BR_VERDE"},{"TRB->FS_RECCP == '3'","BR_VERMELHO"}}

	f_ValidPerg( c_Perg )

	If !Pergunte(c_Perg,.T.)
		Return()
	EndIf

	Private c_Marca		:= GetMark()
	Private CCADASTRO	:= "Contas a Receber"

	Private oFont1
	Private oDlg1
	Private oBrw1
	Private oBtn1
	Private oBtn2
	Private oBtn3
	Private oBtn4
	Private oBtn5

	//-------------------------------------
	//Monta os campos da tabela temporaria
	//------------------------------------
	aadd( a_Fields,{"FS_OK"			,"C",2,0} )
	aadd( a_Fields,{"FS_FILIAL"		,"C",TamSX3("E2_FILIAL")[1],0} )
	aadd( a_Fields,{"FS_PREFIXO"	,"C",TamSX3("E2_PREFIXO")[1],0} )
	aadd( a_Fields,{"FS_NUM"		,"C",TamSX3("E2_NUM")[1],0} )
	aadd( a_Fields,{"FS_PARCELA"	,"C",TamSX3("E2_PARCELA")[1],0} )
	aadd( a_Fields,{"FS_TIPO"		,"C",TamSX3("E2_TIPO")[1],0} )
	aadd( a_Fields,{"FS_NATUREZ"	,"C",TamSX3("E2_NATUREZ")[1],0} )
	aadd( a_Fields,{"FS_FORNECE"	,"C",TamSX3("E2_FORNECE")[1],0} )
	aadd( a_Fields,{"FS_LOJA"		,"C",TamSX3("E2_LOJA")[1],0} )
	aadd( a_Fields,{"FS_NOMFOR"		,"C",TamSX3("E2_NOMFOR")[1],0} )
	aadd( a_Fields,{"FS_EMISSAO"	,"D",8,0} )
	aadd( a_Fields,{"FS_VENCTO"		,"D",8,0} )
	aadd( a_Fields,{"FS_VENCREA"	,"D",8,0} )
	aadd( a_Fields,{"FS_VALOR"		,"N",TamSX3("E2_VALOR")[1],2} )
	aadd( a_Fields,{"FS_SALDO"		,"N",TamSX3("E2_SALDO")[1],2} )
	aadd( a_Fields,{"FS_RECNO"		,"N",8,2} )
	aadd( a_Fields,{"FS_RECCP"		,"C",TamSX3("E2_FSRECCP")[1],0} )

	o_TempTable:SetFields( a_Fields )	//cria os campos
	o_TempTable:AddIndex("I1", {"FS_FILIAL", "FS_PREFIXO","FS_NUM", "FS_PARCELA", "FS_FORNECE", "FS_LOJA"} )	//Cria os indices
	o_TempTable:Create()				//Confirma a criacao da tabela

	f_RecTitulos( c_Opca )	//Povoa o arquivo de trabalho

	//Os campos que serao exibidos no MsSelect()
	aAdd( a_Campos	,{ "FS_OK"			,,'  '					,'@!' } )
	aAdd( a_Campos	,{ "FS_FILIAL"		,,'Filial'				,'@!' } )
	aAdd( a_Campos	,{ "FS_PREFIXO"		,,'Prefixo'				,'@!' } )
	aAdd( a_Campos	,{ "FS_NUM"			,,'Numero'				,'@!' } )
	aAdd( a_Campos	,{ "FS_PARCELA"		,,'Parcela'				,'@!' } )
	aAdd( a_Campos	,{ "FS_TIPO"		,,'Tipo'				,'@!' } )
	aAdd( a_Campos	,{ "FS_NATUREZ"		,,'Natureza'			,'@!' } )
	aAdd( a_Campos	,{ "FS_FORNECE"		,,'Fornecedor'			,'@!' } )
	aAdd( a_Campos	,{ "FS_LOJA"		,,'Loja'				,'@!' } )
	aAdd( a_Campos	,{ "FS_NOMFOR"		,,'Nome'				,'@!' } )
	aAdd( a_Campos	,{ "FS_EMISSAO"		,,'Emissao'				,'@D' } )
	aAdd( a_Campos	,{ "FS_VENCTO"		,,'Vencimento'			,'@D' } )
	aAdd( a_Campos	,{ "FS_VENCREA"		,,'Vencto Real'			,'@D' } )
	aAdd( a_Campos	,{ "FS_VALOR"		,,'Valor'				,'@e 999,999,999.99' } )
	aAdd( a_Campos	,{ "FS_SALDO"		,,'Saldo'				,'@e 999,999,999.99' } )
	//aAdd( a_Campos	,{ "FS_RECNO"		,,'RECNO'				,'@e 99999999999' } )

	oFont1     := TFont():New( "Consolas",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )
	oDlg1      := MSDialog():New( 092,232,545,1171,IIF( c_Opca == '1',"Reconhecimento de Título","Liberação de Título"),,,.F.,,,,,,.T.,,oFont1,.T. )

	oBrw1      := MsSelect():New( "TRB","FS_OK",,a_Campos,.F.,c_Marca,{001,001,208,472},,, oDlg1,,aCores )

	oBrw1:oBrowse:Refresh()
	oBrw1:oBrowse:lhasMark 	 	:= .T.
	oBrw1:oBrowse:lCanAllmark	:= .F.
	oBrw1:oBrowse:bAllMark 	 	:= {|| f_InvertMark() }
	//oBrw1:bMark					:= {|| f_MarcaReg() }

	oBtn1      := TButton():New( 212,424,"Ok",oDlg1,{ || n_Opca := 1, oDlg1:End() },037,012,,oFont1,,.T.,,"",,,,.F. )

	oDlg1:Activate(,,,.T.)

	If n_Opca == 1
		TRB->(dbGoTop())
		While TRB->(!EOF())
			If TRB->FS_OK == ThisMark()

				...sua logica...

			EndIf
			TRB->( dbSkip() )
		EndDo
	EndIf
	TRB->( dbCloseArea() )
Return()

/*/{Protheus.doc} f_InvertMark
Função responsável por inverter a marcação do Browse MsSelect
@author Francisco
@since 19/06/2018
@version 12.1.17
@return Nil, Não esperado

@type function
/*/
Static Function f_InvertMark()

	DBSELECTAREA("TRB")
	TRB->(DBGOTOP())
	WHILE TRB->(!EOF())

		RECLOCK("TRB",.F.)
		If  TRB->FS_OK <> THISMARK()
			TRB->FS_OK := THISMARK()
		Else
			TRB->FS_OK := "  "
		Endif
		MSUNLOCK()

		TRB->(DBSKIP())

	ENDDO
	TRB->(DBGOTOP())
	oBrw1:oBrowse:Refresh()

Return()
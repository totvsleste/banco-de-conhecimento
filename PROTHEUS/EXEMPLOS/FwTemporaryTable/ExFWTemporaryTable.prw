#INCLUDE 'protheus.ch'

User Function ExFWTemporaryTable()

	Local aFields := {}
	Local oTempTable
	Local nI
	Local cAlias := "MEUALIAS"
	Local cQuery

	//-------------------
	//Criação do objeto
	//-------------------
	oTempTable := FWTemporaryTable():New( cAlias )

	//--------------------------
	//Monta os campos da tabela
	//--------------------------
	aadd(aFields,{"DESCR","C",30,0})
	aadd(aFields,{"CONTR","N",3,1})
	aadd(aFields,{"ALIAS","C",3,0})

	oTemptable:SetFields( aFields )
	oTempTable:AddIndex("indice1", {"DESCR"} )
	oTempTable:AddIndex("indice2", {"CONTR", "ALIAS"} )
	//------------------
	//Criação da tabela
	//------------------
	oTempTable:Create()

	conout("Executando a cópia dos registros da tabela: " + RetSqlName("CT0") )

	//--------------------------------------------------------------------------
	//Caso o INSERT INTO SELECT preencha todos os campos, este será um método facilitador
	//Caso contrário deverá ser chamado o InsertIntoSelect():
	// oTempTable:InsertIntoSelect( {"DESCR", "CONTR" } , RetSqlName("CT0") , { "CT0_DESC", "CT0_CONTR" } )
	//--------------------------------------------------------------------------
	//oTempTable:InsertSelect( RetSqlName("CT0") , { "CT0_DESC", "CT0_CONTR", "CT0_ALIAS" } )
	oTempTable:InsertIntoSelect( {"DESCR", "CONTR" } , RetSqlName("CT0") , { "CT0_DESC", "CT0_CONTR" } )

	//------------------------------------
	//Executa query para leitura da tabela
	//------------------------------------
	cQuery := "select * from "+ oTempTable:GetRealName()
	MPSysOpenQuery( cQuery, 'QRYTMP' )

	DbSelectArea('QRYTMP')

	while !eof()
		for nI := 1 to fcount()
			varinfo(fieldname(nI),fieldget(ni))
		next
		dbskip()
	Enddo

	//---------------------------------
	//Exclui a tabela
	//---------------------------------
	oTempTable:Delete()

return

User Function CLASSEAQRTRB()

	Local o_Trabalho	:= clsComponentes():New()
	Local cQuery		:= " SELECT CT0_DESC, CT0_CONTR FROM " + RETSQLNAME( "CT0" ) + " "	//Query com o resultado do que será gravado no arquivo de trabalho
	Local a_Index		:= {}
	Local aEstruct		:= {}
	Local c_AliasCT0	:= ""

	//É obrigatório que o nome do campo inicie com FS_
	AADD( aEstruct, { "FS_DESC", "C", TamSX3( "CT0_DESC" )[ 1 ], 0 } )
	AADD( aEstruct, { "FS_CONTR", "C", TamSX3( "CT0_CONTR" )[ 1 ], 0 } )

	//Índices
	AADD( a_Index, {"FS_DESC","FS_CONTR"} )
	AADD( a_Index, {"FS_CONTR","FS_DESC"} )

	//Método para criação do arquivo de trabalho
	c_AliasCT0 := o_Trabalho:mtdArqTrab( cQuery, aEstruct, a_Index )

	//Utilização do Alias gerado
	While (c_AliasCT0)->(!Eof())

		Alert( (c_AliasCT0)->FS_DESC )

		(c_AliasCT0)->( dbSkip() )

	EndDo

	//Fecha o Alias
	(c_AliasCT0)->( dbCloseArea() )

	//Apaga o arquivo de trabalho no banco Temp
	o_Trabalho:mtdClearArqTrab()

Return

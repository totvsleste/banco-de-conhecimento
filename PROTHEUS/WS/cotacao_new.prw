User Function cota001()

	Local o_Server		:= WSFachadaWSSGSService():New()
	Local o_Explorer	:= clsExplorer():New()
	Local c_Caminho		:= "\COTACAO\"
	Local c_Arquivo		:= ""
	Local c_XML			:= ""
	Local o_XML
	Local cAviso		:= ""
	Local cErro			:= ""
	Local o_Data
	Local d_Cotacao		:= CTOD("  /  /  ")
	Local n_Valor		:= 0
	Local a_Moedas		:= { 1, 21619, 21635 }
	Local nX			:= 1

	If !o_Explorer:mtdExistePasta( c_Caminho )
		If !o_Explorer:mtdCriaPasta( c_Caminho )
			Conout( "ERRO 001: Nao foi possivel criar a pasta" )
		EndIf
	EndIf

	For nX:=1 To Len( a_Moedas )

		c_Arquivo		:= DTOS( Date() ) + "-" + Alltrim( Str( a_Moedas[ nX ] ) ) + ".txt"
		o_Server:nin0	:= a_Moedas[ nX ]
		o_Server:getUltimoValorXML()

		c_XML	:=  o_Server:cgetUltimoValorXMLReturn
		MemoWrite( c_Caminho + c_Arquivo, c_XML)

		o_XML	:= XmlParser( c_XML, "_", @cAviso, @cErro )

		o_Data		:= o_XML:_RESPOSTA:_SERIE:_DATA
		d_Cotacao	:= STOD( o_Data:_ANO:TEXT + o_Data:_MES:TEXT + o_Data:_DIA:TEXT )
		n_Valor		:= Val( Replace( o_XML:_RESPOSTA:_SERIE:_VALOR:TEXT,",","." ) )

		dbSelectArea( "SM2" )
		dbSetOrder( 1 )
		If dbSeek( DTOS( d_Cotacao ), .T. )

			RecLock( "SM2", .F.)
			If nX == 1
				SM2->M2_MOEDA1	:= n_Valor
			ElseIf nX == 2
				SM2->M2_MOEDA2	:= n_Valor
			Else
				SM2->M2_MOEDA3	:= n_Valor
			Endif
			MsUnLock()

		Else

			RecLock( "SM2", .T.)
			SM2->M2_DATA	:= d_Cotacao
			SM2->M2_MOEDA1	:= n_Valor
			MsUnLock()

		EndIf
	Next

Return
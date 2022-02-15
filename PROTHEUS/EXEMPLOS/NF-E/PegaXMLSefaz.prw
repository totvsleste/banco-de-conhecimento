#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

User Function PEGAXMLSEFAZ()

	Local cUrl 			:= ""
	Local cIdEnt 		:= ""
	Local cGetIdEntErr 	:= ""
	Local cCNPJ			:= "13060270000130"
	Local lRetornaFxOk 	:= .F.
	Local o_WS

	cURL := PadR(GetNewPar("MV_SPEDURL","http://"),250)
	IF !( CTIsReady(cURL) )
		Alert( "Problema na conexao com Totvs Sped Services :: " + cURL )
	EndIF

	cURL := AllTrim(cURL)+"/NFeSBRA.apw"
	IF !( CTIsReady(cURL) )
		Alert( "Problema na conexao com Totvs Sped Services :: " + cURL )
	EndIF

	cIdEnt := StaticCall( SPEDNFe, GetIdEnt )	//GetIdEnt( @cGetIdEntErr )
	IF Empty( cIdEnt )
		IF Empty( cGetIdEntErr )
			cGetIdEntErr := "Nao foi Possivel Obter o Codigo da Entidade. Verifique a sua Configuracao do SPED"
		EndIF
		Alert( cGetIdEntErr )
	EndIF

	o_WS 					:= WSNFeSBRA():New()	//WebService de saida
	//o_WS 					:= WSNFeEBRA():New()	//WebService de entrada
	//o_WsNFeId				:= NFEEBRA_NFESID():New()
	o_WS:cUSERTOKEN 		:= "TOTVS"
	o_WS:cID_ENT 			:= cIdEnt
	o_WS:_URL 				:= cURL
	o_WS:cIdInicial 		:= ""				//F2_SERIE+F2_DOC
	o_WS:cIdFinal 			:= "ZZZZZZZZZZ"		//F2_SERIE+F2_DOC
	o_WS:dDataDe 			:= Stod("20160101")
	o_WS:dDataAte 			:= Stod("20171231")
	o_WS:cCNPJDESTInicial 	:= cCNPJ
	o_WS:cCNPJDESTFinal 	:= cCNPJ
	o_WS:nDiasparaExclusao	:= 0
	lRetornaFxOk 			:= o_WS:RetornaFX()

	IF !( lRetornaFxOk )
		Alert( "Problema no Retorno da Nota Fiscal" )
	EndIF

	/*o_WS:cUSERTOKEN 			:= "TOTVS"
	o_WS:cID_ENT 				:= cIdEnt
	//o_WS:oWsNFeId:oWsId		:= "1  8370"
	o_WS:RETORNANOTA()*/

	nItens := Len( o_WS:oWsRetornaFxResult:oWsNotas:oWsNFES3 )

	For nItem := 1 To nItens
		MemoWrite( "C:\Totvs\xml_novo.xml", o_WS:oWsRetornaFxResult:oWsNotas:oWsNFES3[nItem]:oWsNFE:cXML )
		Exit
	Next nItem

Return()
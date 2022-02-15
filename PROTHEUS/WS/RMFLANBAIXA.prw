#include 'protheus.ch'
#include 'parmtype.ch'

CLASS DADOSBAIXA

	DATA INATIVO
	DATA COLIGADA
	DATA IDLAN
	DATA IDBAIXA

	METHOD NEW() CONSTRUCTOR

ENDCLASS

METHOD NEW() CLASS DADOSBAIXA

	::INATIVO		:= ""
	::COLIGADA  	:= ""
	::IDLAN	    	:= ""
	::IDBAIXA		:= ""

Return SELF


CLASS RMFLANBAIXA

	DATA DADOSGLOBAIS
	DATA IDLAN
	DATA CODCOLIGADA
	DATA CODSISTEMA
	DATA CODUSUARIO
	DATA SENHAUSUARIO
	DATA OWSDL
	DATA OWSDLLOGIN
	DATA MSGERROR
	DATA DADOSBAIXA
	DATA RETBAIXA
	DATA LISTARBAIXAS

	METHOD NEW() CONSTRUCTOR
	METHOD INIT()
	METHOD LISTARBAIXAS()
	METHOD CONSULTABAIXA()
	METHOD INCLUIRBAIXA()
	METHOD INCBAIXAVINC()
	METHOD CANCELARBAIXA()

ENDCLASS

METHOD New() CLASS RMFLANBAIXA

	::DADOSGLOBAIS 			:= RMGLOBAL():New()
	::CODCOLIGADA				:= ::DADOSGLOBAIS:COLIGADA
	::CODSISTEMA				:= ::DADOSGLOBAIS:CODSISTEMA
	::CODUSUARIO				:= ::DADOSGLOBAIS:LOGIN
	::SENHAUSUARIO			:= ::DADOSGLOBAIS:SENHA
	::IDLAN					:= ""
	::MSGERROR					:= ""
	::DADOSBAIXA				:= DADOSBAIXA():New()
	::OWSDL					:= TWsdlManager():New()
	::OWSDLLOGIN				:= NIL
	::RETBAIXA					:= NIL

	Conout("RMFLAN -> " + Time() + " - Construcao da estrutura de dados da classe de integracao de produtos")

Return SELF

METHOD Init(lBaixa) CLASS RMFLANBAIXA

	Local xRet 		:= .F.
	Local cError 		:= ""
	Local cMsgError	:= ""
	Local aOper		:= {}
	Local oWsdl		:= ::OWSDL
	Local cUserName	:= ::CODUSUARIO
	Local cPasswd		:= ::SENHAUSUARIO

	Default lBaixa	:= .F.

	oWsdl:nTimeOut	:= 150

	IF lBaixa
		xRet := oWsdl:ParseURL( ::DADOSGLOBAIS:URLPROCESS )
	Else
		xRet := oWsdl:ParseURL( ::DADOSGLOBAIS:URLCOMPL )
	EndIF

	IF .Not. xRet

		cError 		:= oWsdl:cError
		cMsgError 		:= oWsdl:cFaultString
		cMsgError		:= FWNoAccent(cMsgError)
		::MSGERROR 	:= cMsgError
		Conout("FBAIXA -> " + Time() + " - " + cMsgError)
		Return .F.

	EndIF

	aOper := oWsdl:ListOperations()

	IF ValType(aOper) <> 'A'

		::MSGERROR := "NAO FOI POSSIVEL LISTAR AS OPERACOES DO DATASERVER FinLanBaixaDataView"
		Return .F.

	EndIF

//	xRet := oWsdl:setOperation('AutenticaAcesso')
//
//	IF .Not. xRet
//
//		cError 		:= oWsdl:cError
//		cMsgError 		:= oWsdl:cFaultString
//		cMsgError		:= FWNoAccent(cMsgError)
//		::MSGERROR 	:= cMsgError
//		Conout("FBAIXA -> " + Time() + " - " + cMsgError)
//		Return .F.
//
//	EndIF
//
//	xRet := oWsdl:SetAuthentication(cUserName,cPasswd)
//	xRet := oWsdl:GetAuthentication(cUserName,cPasswd)
//
//	IF .Not. xRet
//
//		cError 		:= oWsdl:cError
//		cMsgError 		:= oWsdl:cFaultString
//		cMsgError		:= FWNoAccent(cMsgError)
//		::MSGERROR 	:= cMsgError
//		Conout("FBAIXA -> " + Time() + " - " + cMsgError)
//		Return .F.
//
//	EndIF
//
//	cEncode64	:= Encode64(::CODUSUARIO + ":" + ::SENHAUSUARIO)
//	xRet 		:= oWsdl:AddHttpHeader("Authorization","Basic " + cEncode64)
//
//	IF .Not. xRet
//		Conout("RMAUTHORIZATION -> " + Time() + " - Erro Encode64 " + cEncode64)
//	EndIF
//
//	xRet := oWsdl:SendSoapMsg()
//
//	IF .Not. xRet
//
//		cError 		:= oWsdl:cError
//		cMsgError 		:= oWsdl:cFaultString
//		cMsgError		:= FWNoAccent(cMsgError)
//		::MSGERROR 	:= cMsgError
//		Conout("FBAIXA -> " + Time() + " - " + cMsgError)
//		Return .F.
//
//	EndIF
//
//	xRet := oWsdl:getSoapResponse()
//
//	::OWSDLLOGIN 		:= xRet
//	::OWSDL 			:= oWsdl

	Conout("FBAIXA -> " + Time() + " - Inicializacao do metodo de integracao para lancamentos financeiros de baixa")

Return .T.

METHOD LISTARBAIXAS() CLASS RMFLANBAIXA

	Local oWsdl 		:= Nil
	Local xRet 		:= ""
	Local cError 		:= ""
	Local cMsgError 	:= ""
	Local cWarning	:= ""
	Local cUsuario	:= Nil
	Local cCodSist	:= Nil
	Local aSimple		:= {}
	Local aReg			:= {}
	Local x			:= 0

	oWsdl 				:= ::OWSDL
	cUsuario			:= ::CODUSUARIO
	cCodSist			:= ::CODSISTEMA

	oWsdl:nTimeOut	:= 150

	xRet 				:= oWsdl:ParseURL( ::DADOSGLOBAIS:URLCOMPL )
	xRet 				:= oWsdl:setOperation('ReadView')

	IF .Not. xRet

		cError 		:= oWsdl:cError
		cMsgError 		:= oWsdl:cFaultString
		cMsgError		:= FWNoAccent(cMsgError)
		Conout("FBAIXA -> " + Time() + " - " + cMsgError)
		::MSGERROR 	:= cMsgError
		Return .F.

	EndIF

	aSimple := oWsdl:simpleInput()

	IF ValType(aSimple) <> 'A'

		::MSGERROR := "NAO FOI POSSIVEL OBTER A LISTA DE DADOS SIMPLES DO METODO ReadView"
		Conout("FBAIXA -> " + Time() + " - " + ::MSGERROR)
		Return .F.

	EndIF

	::CODCOLIGADA		:= cValToChar(Val(FwCodEmp()))

	cColigada 			:= ::CODCOLIGADA
	cCodSist 			:= 'F'
	cUsuario 			:= IIF(lower(cUserName) = "administrador","mestre",cUserName)
	cFiltro			:= "IDLAN  = " + ::IDLAN + " AND STATUS = 0 AND FLANBAIXA.CODCOLIGADA = " + ::CODCOLIGADA

	oWsdl:setValue(0,"FinLanBaixaDataView")
	oWsdl:setValue(1,cFiltro)
	oWsdl:setValue(2,"CODCOLIGADA=" + cColigada + ";CODSISTEMA=" + cCodSist + ";CODUSUARIO=" + cUsuario)

	cEncode64	:= Encode64(::CODUSUARIO + ":" + ::SENHAUSUARIO)
	xRet 		:= oWsdl:AddHttpHeader("Authorization","Basic " + cEncode64)

	IF .Not. xRet
		Conout("RMAUTHORIZATION -> " + Time() + " - Erro Encode64 " + cEncode64)
	EndIF

	xRet := oWsdl:SendSoapMsg()

	IF .Not. xRet

		cError 		:= oWsdl:cError
		cMsgError 	:= oWsdl:cFaultString
		cMsgError	:= FWNoAccent(cMsgError)
		Conout("FBAIXA -> " + Time() + " - " + cMsgError)
		::MSGERROR 	:= cMsgError
		Return .F.

	EndIF

	xRet := oWsdl:getSoapResponse()
	xRet := StrTran(xRet,"&lt;","<")
	xRet := StrTran(xRet,"&gt;",">")
	xRet := StrTran(xRet,"&#xD;",'')
	oXml := XmlParser( xRet, "_", @cError, @cWarning )

	IF Type('oXml:_S_ENVELOPE:_S_BODY:_READVIEWRESPONSE:_READVIEWRESULT:_NEWDATASET:_FLANBAIXA') = "U"
		Return .F.
	EndIF

	oXml := oXml:_S_ENVELOPE:_S_BODY:_READVIEWRESPONSE:_READVIEWRESULT:_NEWDATASET:_FLANBAIXA
	oXml := oXml

	IF ValType(oXml) = "A"

		For x := 1 To Len(oXml)

			xColigada 		:= IIF(Type('oXml[' + cValToChar(x) + ']:_CODCOLIGADA:Text'	) <> 'U',oXml[x]:_CODCOLIGADA:Text	,"")
			xIdLan			:= IIF(Type('oXml[' + cValToChar(x) + ']:_IDLAN:Text'		) <> 'U',oXml[x]:_IDLAN:Text		,"")
			xIdBaixa		:= IIF(Type('oXml[' + cValToChar(x) + ']:_IDBAIXA:Text'		) <> 'U',oXml[x]:_IDBAIXA:Text		,"")

			IF .Not. Empty(xColigada) .And. .Not. Empty(xIdLan) .And. .Not. Empty(xIdBaixa)
				aadd(aReg,{xColigada,xIdLan,xIdBaixa})
			EndIF

		Next x

	ElseIF ValType(oXml) = 'O'

		xColigada 		:= IIF(Type('oXml:_CODCOLIGADA:Text'	) <> 'U',oXml:_CODCOLIGADA:Text	,"")
		xIdLan			:= IIF(Type('oXml:_IDLAN:Text'			) <> 'U',oXml:_IDLAN:Text		,"")
		xIdBaixa		:= IIF(Type('oXml:_IDBAIXA:Text'		) <> 'U',oXml:_IDBAIXA:Text		,"")

		IF .Not. Empty(xColigada) .And. .Not. Empty(xIdLan) .And. .Not. Empty(xIdBaixa)
			aadd(aReg,{xColigada,xIdLan,xIdBaixa})
		EndIF

	EndIF

	::LISTARBAIXAS := aClone(aReg)

Return aReg

METHOD CONSULTABAIXA(xColigada,xIdLan,xIdBaixa) CLASS RMFLANBAIXA

	Local oWsdl 	:= Nil
	Local xRet 		:= ""
	Local cError 	:= ""
	Local cMsgError := ""
	Local cWarning	:= ""
	Local cColigada	:= xColigada
	Local nIdLan	:= xIdLan
	Local nIdBaixa	:= xIdBaixa
	Local cUsuario	:= Nil
	Local cCodSist	:= Nil
	Local aSimple	:= {}
	Local aRetorno	:= {}

	oWsdl 			:= ::OWSDL
	cUsuario		:= ::CODUSUARIO
	cCodSist		:= ::CODSISTEMA

	xRet := oWsdl:setOperation('ReadRecord')

	IF .Not. xRet

		cError 		:= oWsdl:cError
		cMsgError 	:= oWsdl:cFaultString
		cMsgError	:= FWNoAccent(cMsgError)
		Conout("FBAIXA -> " + Time() + " - " + cMsgError)
		::MSGERROR 	:= cMsgError
		Return .F.

	EndIF

	aSimple := oWsdl:simpleInput()

	IF ValType(aSimple) <> 'A'

		::MSGERROR := "NAO FOI POSSIVEL OBTER A LISTA DE DADOS SIMPLES DO METODO ReadRecord"
		Conout("FBAIXA -> " + Time() + " - " + ::MSGERROR)
		Return .F.

	EndIF

	oWsdl:setValue(0,"FinLanBaixaDataView")
	oWsdl:setValue(1,cColigada + ";" + nIdLan + ";" + nIdBaixa)
	oWsdl:setValue(2,"CODCOLIGADA=" + cColigada + ";CODSISTEMA=" + cCodSist + ";CODUSUARIO=" + cUsuario)

	cEncode64	:= Encode64(::CODUSUARIO + ":" + ::SENHAUSUARIO)
	xRet 		:= oWsdl:AddHttpHeader("Authorization","Basic " + cEncode64)

	IF .Not. xRet
		Conout("RMAUTHORIZATION -> " + Time() + " - Erro Encode64 " + cEncode64)
	EndIF

	xRet := oWsdl:SendSoapMsg()

	IF .Not. xRet

		cError 		:= oWsdl:cError
		cMsgError 	:= oWsdl:cFaultString
		cMsgError	:= FWNoAccent(cMsgError)
		Conout("FBAIXA -> " + Time() + " - " + cMsgError)
		::MSGERROR 	:= cMsgError
		Return .F.

	EndIF

	xRet := oWsdl:getSoapResponse()
	xRet := StrTran(xRet,"&lt;","<")
	xRet := StrTran(xRet,"&gt;",">")
	xRet := StrTran(xRet,"&#xD;",'')
	xRet := StrTran(xRet,"&AMP;",'')
	oXml := XmlParser( xRet, "_", @cError, @cWarning )

	IF Type('oXml:_S_ENVELOPE:_S_BODY:_READRECORDRESPONSE:_READRECORDRESULT:_FINLANBAIXAVIEW') = "U"
		Return .F.
	EndIF

	oXml := oXml:_S_ENVELOPE:_S_BODY:_READRECORDRESPONSE:_READRECORDRESULT:_FINLANBAIXAVIEW
	oXml := oXml

	oXmlBaixa 	:= Nil
	oXmlRatCCu	:= Nil

	IF Type('oXml:_FLANBAIXA') <> 'U'
		oXmlBaixa := oXml:_FLANBAIXA
	EndIF

	IF Type('oXml:_FLANBAIXARATCCU') <> 'U'
		oXmlRatCCU := oXml:_FLANBAIXARATCCU
	EndIF

	oXml := oXml
	aadd(aRetorno,{oXmlBaixa,oXmlRatCCu})

return aRetorno

METHOD INCBAIXAVINC(cXML) CLASS RMFLANBAIXA

	oRM				:= ::DADOSGLOBAIS
	oWsdl 			:= ::OWSDL
	cUsuario		:= ::CODUSUARIO
	cCodSist		:= ::CODSISTEMA
	cColigada		:= cValToChar(Val(FWCodEmp()))

	xRet 			:= oWsdl:setOperation('ExecuteWithParams')

	Default cXML 	:= ""

	IF Empty(cXML)
		Conout("FBAIXA -> " + Time() + " - XML Vazio")
		::MSGERROR 	:= 'XML Vazio'
		Return .F.
	EndIF

	IF .Not. xRet

		cError 		:= oWsdl:cError
		cMsgError 	:= oWsdl:cFaultString
		cMsgError	:= FWNoAccent(cMsgError)
		Conout("FBAIXA -> " + Time() + " - " + cMsgError)
		::MSGERROR 	:= cMsgError
		Return .F.

	EndIF

	aSimple := oWsdl:simpleInput()

	IF ValType(aSimple) <> 'A'

		::MSGERROR := "NAO FOI POSSIVEL OBTER A LISTA DE DADOS SIMPLES DO METODO SaveRecord"
		Conout("FBAIXA -> " + Time() + " - " + ::MSGERROR)
		Return .F.

	EndIF

	oWsdl:setValue(0,"FinLanBaixaData"	)
	oWsdl:setValue(1,cXML				)

	cEncode64	:= Encode64(::CODUSUARIO + ":" + ::SENHAUSUARIO)
	xRet 		:= oWsdl:AddHttpHeader("Authorization","Basic " + cEncode64)

	IF .Not. xRet
		Conout("RMAUTHORIZATION -> " + Time() + " - Erro Encode64 " + cEncode64)
	EndIF

	xRet := oWsdl:SendSoapMsg()

	IF .Not. xRet

		cError 		:= oWsdl:cError
		cMsgError 	:= oWsdl:cFaultString
		cMsgError	:= FWNoAccent(cMsgError)
		Conout("FBAIXA -> " + Time() + " - " + cMsgError)
		::MSGERROR 	:= cMsgError
		Return .F.

	EndIF

	xResult := oWsdl:getSoapResponse()

	lret 	:= .T.

Return xResult

METHOD INCLUIRBAIXA(cXML) CLASS RMFLANBAIXA

	oRM				:= ::DADOSGLOBAIS
	oWsdl 			:= ::OWSDL
	cUsuario		:= ::CODUSUARIO
	cCodSist		:= ::CODSISTEMA
	cColigada		:= cValToChar(Val(FWCodEmp()))

	xRet 			:= oWsdl:setOperation('ExecuteWithParams')

	Default cXML 	:= ""

	IF Empty(cXML)
		Conout("FBAIXA -> " + Time() + " - XML Vazio")
		::MSGERROR 	:= 'XML Vazio'
		Return .F.
	EndIF

	IF .Not. xRet

		cError 		:= oWsdl:cError
		cMsgError 	:= oWsdl:cFaultString
		cMsgError	:= FWNoAccent(cMsgError)
		Conout("FBAIXA -> " + Time() + " - " + cMsgError)
		::MSGERROR 	:= cMsgError
		Return .F.

	EndIF

	aSimple := oWsdl:simpleInput()

	IF ValType(aSimple) <> 'A'

		::MSGERROR := "NAO FOI POSSIVEL OBTER A LISTA DE DADOS SIMPLES DO METODO SaveRecord"
		Conout("FBAIXA -> " + Time() + " - " + ::MSGERROR)
		Return .F.

	EndIF

	oWsdl:setValue(0,"FinTBCBaixaDataProcess"	)
	oWsdl:setValue(1,cXML						)

	cEncode64	:= Encode64(::CODUSUARIO + ":" + ::SENHAUSUARIO)
	xRet 		:= oWsdl:AddHttpHeader("Authorization","Basic " + cEncode64)

	IF .Not. xRet
		Conout("RMAUTHORIZATION -> " + Time() + " - Erro Encode64 " + cEncode64)
	EndIF

	xRet := oWsdl:SendSoapMsg()
	xRet := xRet

	IF .Not. xRet

		cError 		:= oWsdl:cError
		cMsgError 	:= oWsdl:cFaultString
		cMsgError	:= FWNoAccent(cMsgError)
		Conout("FBAIXA -> " + Time() + " - " + cMsgError)
		::MSGERROR 	:= cMsgError
		Return .F.

	EndIF

	xResult := oWsdl:getSoapResponse()

	lret 	:= .T.

Return xResult

METHOD CANCELARBAIXA(cXML) CLASS RMFLANBAIXA

	oRM				:= ::DADOSGLOBAIS
	oWsdl 			:= ::OWSDL
	cUsuario		:= ::CODUSUARIO
	cCodSist		:= ::CODSISTEMA
	cColigada		:= ::CODCOLIGADA

	oWsdl:nTimeOut:= 150

	xRet 			:= oWsdl:ParseURL( oRM:URLPROCESS )
	xRet 			:= oWsdl:setOperation('ExecuteWithParams')

	Default cXML 	:= ""

	IF Empty(cXML)
		Conout("FBAIXA -> " + Time() + " - XML Vazio")
		::MSGERROR 	:= 'XML Vazio'
		Return .F.
	EndIF

	IF .Not. xRet

		cError 		:= oWsdl:cError
		cMsgError 	:= oWsdl:cFaultString
		cMsgError	:= FWNoAccent(cMsgError)
		Conout("FBAIXA -> " + Time() + " - " + cMsgError)
		::MSGERROR 	:= cMsgError
		Return .F.

	EndIF

	aSimple := oWsdl:simpleInput()

	IF ValType(aSimple) <> 'A'

		::MSGERROR := "ERRO AO OBTER DADOS SIMPLES PARA EXCLUSAO DE BAIXA"
		Conout("FBAIXA -> " + Time() + " - " + ::MSGERROR)
		Return .F.

	EndIF

	oWsdl:setValue(0,"FinLanBaixaCancelamentoData"	)
	oWsdl:setValue(1,cXML								)

	cEncode64	:= Encode64(::CODUSUARIO + ":" + ::SENHAUSUARIO)
	xRet 		:= oWsdl:AddHttpHeader("Authorization","Basic " + cEncode64)

	IF .Not. xRet
		Conout("RMAUTHORIZATION -> " + Time() + " - Erro Encode64 " + cEncode64)
	EndIF

	xRet := oWsdl:SendSoapMsg()

	IF .Not. xRet

		cError 		:= oWsdl:cError
		cMsgError 		:= oWsdl:cFaultString
		cMsgError		:= FWNoAccent(cMsgError)
		Conout("FBAIXA -> " + Time() + " - " + cMsgError)
		::MSGERROR 	:= cMsgError
		Return .F.

	EndIF

	xResult := oWsdl:getSoapResponse()

	lret 	:= .T.

	oWsdl:setValue(0,"FinLanDesbloqueiaAlteracaoData"	)
	oWsdl:setValue(1,cXML								)

	xRet := oWsdl:SendSoapMsg()
	lret := .T.

	IF .Not. xRet

		cError 		:= oWsdl:cError
		cMsgError 		:= oWsdl:cFaultString
		cMsgError		:= FWNoAccent(cMsgError)
		Conout("RMFLAN -> " + Time() + " - " + cMsgError)
		::MSGERROR 	:= cMsgError
		Return .F.

	EndIF

	xResult := oWsdl:getSoapResponse()

	lret 	:= .T.

Return xResult

User Function RMFBAIXA

	Local oRM			:= RMFLANBAIXA():New()
	Local oXML			:= RMFINXML():New()
	Local cPrefix		:= SE1->E1_PREFIXO
	Local cNumero		:= SE1->E1_NUM
	Local cParcela		:= SE1->E1_PARCELA
	Local cTipo			:= SE1->E1_TIPO
	Local cLoja			:= SE1->E1_LOJA
	Local nValor		:= SE1->E1_VALOR
	Local nVlrBaixa		:= SE1->E1_VALOR
	Local nMoeda		:= SE1->E1_MOEDA
	Local nIdLan		:= SE1->E1_YIDLAN
	Local nIdBaixa		:= SE1->E1_YIDBAIX
	Local cXML			:= ""
	Local lret
	Local aRetorno
	Local xRetorno
	Local x

	RPCClearEnv()
	RPCSetEnv('01','071028',,,"EEC","KJOB01",{"EE7","EE8","EEL","SA1","SA2","EE9","EEC","EEQ","SWD","EEB","EEJ","EEN","EEO","EET","SC5","SC6","SF4","SE4","SB2","SC0"})
	RPCSetType(3)

	oRM:Init()
	aRetorno 			:= oRM:LISTARBAIXAS()

	/*/
	For x := 1 To Len(aRetorno)

		xColigada 		:= aRetorno[x,1]
		xIdLan			:= aRetorno[x,2]
		xIdBaixa		:= aRetorno[x,3]

		xRetorno		:= oRM:CONSULTABAIXA(xColigada,xIdLan,xIdBaixa)
		lret			:= .T.

	Next x
	/*/

	cVlrOrig				:= SE1->E1_VALOR
	cVlrCotacao			:= oXML:GETCOTACAO()
	cVlrCotacao			:= IIF(Empty(cVlrCotacao),1,cVlrCotacao)

	IF SE1->E1_MOEDA	= 1
		cVlrBaixa			:= SE1->E1_VALOR
	Else
		cVlrBaixa			:= SE1->E1_VALOR * cVlrCotacao
	EndIF

	cVlrOrig				:= cVlrOrig * cVlrCotacao
	cVlrOrig				:= cValToChar(cVlrOrig)
	cVlrBaixa				:= cValToChar(cVlrBaixa)
	cVlrCotacao				:= cValToChar(cVlrCotacao)

	cVlrOrig				:= StrTran(cVlrOrig		,".",",")
	cVlrBaixa				:= StrTran(cVlrBaixa	,".",",")
	cVlrCotacao				:= StrTran(cVlrCotacao	,".",",")

	oXML:IDLAN				:= cValToChar(nIdLan)
	oXML:CODCOLIGADA		:= cValToChar(Val(FWCodEmp()))
	oXML:CODCOLXCX			:= cValToChar(Val(FWCodEmp()))
	oXML:IDXCX				:= "-1"
	oXML:CODCOLCXA			:= cValToChar(Val(FWCodEmp()))
	oXML:CODCXA				:= "001"
	oXML:VALORBAIXA			:= cVlrBaixa
	oXML:VALORORIGINAL		:= cVlrOrig
	oXML:COTACAOBAIXA		:= cVlrCotacao
	oXML:IDFORMAPGTO		:= '009'
	oXML:USUARIO			:= IIF(lower(cUserName) = "administrador","mestre",cUserName)
	oXML:DATABAIXA			:= Substr(oXML:DATABAIXA,1,10)

	cVlrMe									:= StrTran(cValToChar(EEQ->EEQ_VL		),'.',',')
	cVarAtiva								:= StrTran(cValToChar(EEQ->EEQ_YATIVO	),'.',',')
	cVarPassiva								:= StrTran(cValToChar(EEQ->EEQ_YPASSI	),'.',',')
	cVlrComissao							:= "0"

	IF EEQ->EEQ_AREMET > 0
		cVlrComissao						:= StrTran(cValToChar(EEQ->EEQ_AREMET	),'.',',')
	ElseIF EEQ->EEQ_CGRAFI > 0
		cVlrComissao						:= StrTran(cValToChar(EEQ->EEQ_CGRAFI	),'.',',')
	ElseIF EEQ->EEQ_ADEDUZ > 0
		cVlrComissao						:= StrTran(cValToChar(EEQ->EEQ_ADEDUZ	),'.',',')
	EndIF

	oXML:VALORME							:= cVlrMe
	oXML:VALORVARIACAOATIVA				:= cVarAtiva
	oXML:VALORVARIACAOPASSIVA			:= cVarPassiva
	oXML:VALORCOMISSAO					:= cVlrComissao

	cXML 					:= oXML:GETXMLBAIXA()

	oRM:Init(.T.)
	xRetorno				:= oRM:INCLUIRBAIXA(cXML)

	//-- Elimina o objeto da memoria
	FreeObj(oRM)

	//-- Remove os arquivos
	U_LIMPAURI()

	lret 					:= .T.

	RPCClearEnv()

Return
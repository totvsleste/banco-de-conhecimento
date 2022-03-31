#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/* ===============================================================================
WSDL Location    https://homolog.cenprotempresas.org.br/ieptb/services/ProtestoInterface?wsdl
Gerado em        25/03/22 17:42:49
Observa��es      C�digo-Fonte gerado por ADVPL WSDL Client 1.120703
                 Altera��es neste arquivo podem causar funcionamento incorreto
                 e ser�o perdidas caso o c�digo-fonte seja gerado novamente.
=============================================================================== */

User Function _GQUVERP ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSservices
------------------------------------------------------------------------------- */

WSCLIENT WSservices

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ConsultarApresentante
	WSMETHOD EnviarTitulo
	WSMETHOD MovimentoDiario
	WSMETHOD CadastrarCedente
	WSMETHOD ConsultarArquivo
	WSMETHOD OperacaoTitulo
	WSMETHOD Autenticar
	WSMETHOD ConsultarCedente
	WSMETHOD ConsultarTitulo

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   ctoken                    AS string
	WSDATA   oWSapresentante           AS services_apresentante_consulta_request
	WSDATA   oWSresultado              AS services_apresentante_consulta_response
	WSDATA   oWStitulo                 AS services_enviarTituloRequest
	WSDATA   oWSmovimento              AS services_movimento_consultar
	WSDATA   oWScedente                AS services_cedente_cadastro
	WSDATA   oWSarquivo                AS services_consultarArquivoRequest
	WSDATA   oWScredenciais            AS services_autenticarRequest
	WSDATA   ccompleta                 AS string
	WSDATA   cinstrumento              AS string
	WSDATA   canuencia                 AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSservices
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O C�digo-Fonte Client atual requer os execut�veis do Protheus Build [7.00.210324P-20211206] ou superior. Atualize o Protheus ou gere o C�digo-Fonte novamente utilizando o Build atual.")
EndIf
If val(right(GetWSCVer(),8)) < 1.040504
	UserException("O C�digo-Fonte Client atual requer a vers�o de Lib para WebServices igual ou superior a ADVPL WSDL Client 1.040504. Atualize o reposit�rio ou gere o C�digo-Fonte novamente utilizando o reposit�rio atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSservices
	::oWSapresentante    := services_APRESENTANTE_CONSULTA_REQUEST():New()
	::oWSresultado       := services_APRESENTANTE_CONSULTA_RESPONSE():New()
	::oWStitulo          := {} // Array Of  services_ENVIARTITULOREQUEST():New()
	::oWSmovimento       := {} // Array Of  services_MOVIMENTO_CONSULTAR():New()
	::oWScedente         := {} // Array Of  services_CEDENTE_CADASTRO():New()
	::oWSarquivo         := {} // Array Of  services_CONSULTARARQUIVOREQUEST():New()
	::oWScredenciais     := services_AUTENTICARREQUEST():New()
Return

WSMETHOD RESET WSCLIENT WSservices
	::ctoken             := NIL 
	::oWSapresentante    := NIL 
	::oWSresultado       := NIL 
	::oWStitulo          := NIL 
	::oWSmovimento       := NIL 
	::oWScedente         := NIL 
	::oWSarquivo         := NIL 
	::oWScredenciais     := NIL 
	::ccompleta          := NIL 
	::cinstrumento       := NIL 
	::canuencia          := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSservices
Local oClone := WSservices():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:ctoken        := ::ctoken
	oClone:oWSapresentante :=  IIF(::oWSapresentante = NIL , NIL ,::oWSapresentante:Clone() )
	oClone:oWSresultado  :=  IIF(::oWSresultado = NIL , NIL ,::oWSresultado:Clone() )
	oClone:oWStitulo     :=  IIF(::oWStitulo = NIL , NIL ,::oWStitulo:Clone() )
	oClone:oWSmovimento  :=  IIF(::oWSmovimento = NIL , NIL ,::oWSmovimento:Clone() )
	oClone:oWScedente    :=  IIF(::oWScedente = NIL , NIL ,::oWScedente:Clone() )
	oClone:oWSarquivo    :=  IIF(::oWSarquivo = NIL , NIL ,::oWSarquivo:Clone() )
	oClone:oWScredenciais :=  IIF(::oWScredenciais = NIL , NIL ,::oWScredenciais:Clone() )
	oClone:ccompleta     := ::ccompleta
	oClone:cinstrumento  := ::cinstrumento
	oClone:canuencia     := ::canuencia
Return oClone

// WSDL Method ConsultarApresentante of Service WSservices

WSMETHOD ConsultarApresentante WSSEND ctoken,oWSapresentante WSRECEIVE oWSresultado WSCLIENT WSservices
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ConsultarApresentante xmlns="http://grupobst.com.br/services">'
cSoap += WSSoapValue("token", ::ctoken, ctoken , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("apresentante", ::oWSapresentante, oWSapresentante , "apresentante-consulta-request", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</ConsultarApresentante>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"",; 
	"DOCUMENT","http://grupobst.com.br/services",,,; 
	"https://homolog.cenprotempresas.org.br/ieptb/services/ProtestoInterface")

::Init()
::oWSresultado:SoapRecv( WSAdvValue( oXmlRet,"_CONSULTARAPRESENTANTERESPONSE:_RESULTADO","apresentante-consulta-response",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method EnviarTitulo of Service WSservices

WSMETHOD EnviarTitulo WSSEND ctoken,BYREF oWStitulo WSRECEIVE NULLPARAM WSCLIENT WSservices
Local cSoap := "" , oXmlRet
Local oATmp01

BEGIN WSMETHOD

cSoap += '<EnviarTitulo xmlns="http://grupobst.com.br/services">'
cSoap += WSSoapValue("token", ::ctoken, ctoken , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("titulo", ::oWStitulo, oWStitulo , "enviarTituloRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</EnviarTitulo>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"",; 
	"DOCUMENT","http://grupobst.com.br/services",,,; 
	"https://homolog.cenprotempresas.org.br/ieptb/services/ProtestoInterface")

::Init()
oATmp01 :=           WSAdvValue( oXmlRet,"_ENVIARTITULORESPONSE:_TITULO","enviarTituloResponse",NIL,NIL,NIL,NIL,@oWStitulo,"xs") 
If valtype(oATmp01)="A"
	aEval(oATmp01,{|x,y| ( aadd(::oWStitulo,services_enviarTituloResponse():New()) , ::oWStitulo[y]:SoapRecv(x) ) })
Endif

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method MovimentoDiario of Service WSservices

WSMETHOD MovimentoDiario WSSEND ctoken,BYREF oWSmovimento WSRECEIVE NULLPARAM WSCLIENT WSservices
Local cSoap := "" , oXmlRet
Local oATmp01

BEGIN WSMETHOD

cSoap += '<MovimentoDiario xmlns="http://grupobst.com.br/services">'
cSoap += WSSoapValue("token", ::ctoken, ctoken , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("movimento", ::oWSmovimento, oWSmovimento , "movimento-consultar", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</MovimentoDiario>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"",; 
	"DOCUMENT","http://grupobst.com.br/services",,,; 
	"https://homolog.cenprotempresas.org.br/ieptb/services/ProtestoInterface")

::Init()
oATmp01 :=           WSAdvValue( oXmlRet,"_MOVIMENTODIARIORESPONSE:_MOVIMENTO","movimentoResponse",NIL,NIL,NIL,NIL,@oWSmovimento,"xs") 
If valtype(oATmp01)="A"
	aEval(oATmp01,{|x,y| ( aadd(::oWSmovimento,services_movimentoResponse():New()) , ::oWSmovimento[y]:SoapRecv(x) ) })
Endif

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CadastrarCedente of Service WSservices

WSMETHOD CadastrarCedente WSSEND ctoken,BYREF oWScedente WSRECEIVE NULLPARAM WSCLIENT WSservices
Local cSoap := "" , oXmlRet
Local oATmp01

BEGIN WSMETHOD

cSoap += '<CadastrarCedente xmlns="http://grupobst.com.br/services">'
cSoap += WSSoapValue("token", ::ctoken, ctoken , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cedente", ::oWScedente, oWScedente , "cedente-cadastro", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</CadastrarCedente>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"",; 
	"DOCUMENT","http://grupobst.com.br/services",,,; 
	"https://homolog.cenprotempresas.org.br/ieptb/services/ProtestoInterface")

::Init()
oATmp01 :=           WSAdvValue( oXmlRet,"_CADASTRARCEDENTERESPONSE:_CEDENTE","cedente-cadastro-response",NIL,NIL,NIL,NIL,@oWScedente,"xs") 
If valtype(oATmp01)="A"
	aEval(oATmp01,{|x,y| ( aadd(::oWScedente,services_cedente_cadastro_response():New()) , ::oWScedente[y]:SoapRecv(x) ) })
Endif

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ConsultarArquivo of Service WSservices

WSMETHOD ConsultarArquivo WSSEND ctoken,BYREF oWSarquivo WSRECEIVE NULLPARAM WSCLIENT WSservices
Local cSoap := "" , oXmlRet
Local oATmp01

BEGIN WSMETHOD

cSoap += '<ConsultarArquivo xmlns="http://grupobst.com.br/services">'
cSoap += WSSoapValue("token", ::ctoken, ctoken , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("arquivo", ::oWSarquivo, oWSarquivo , "consultarArquivoRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</ConsultarArquivo>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"",; 
	"DOCUMENT","http://grupobst.com.br/services",,,; 
	"https://homolog.cenprotempresas.org.br/ieptb/services/ProtestoInterface")

::Init()
oATmp01 :=           WSAdvValue( oXmlRet,"_CONSULTARARQUIVORESPONSE:_ARQUIVO","consultarArquivoResponse",NIL,NIL,NIL,NIL,@oWSarquivo,"xs") 
If valtype(oATmp01)="A"
	aEval(oATmp01,{|x,y| ( aadd(::oWSarquivo,services_consultarArquivoResponse():New()) , ::oWSarquivo[y]:SoapRecv(x) ) })
Endif

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method OperacaoTitulo of Service WSservices

WSMETHOD OperacaoTitulo WSSEND ctoken,BYREF oWStitulo WSRECEIVE NULLPARAM WSCLIENT WSservices
Local cSoap := "" , oXmlRet
Local oATmp01

BEGIN WSMETHOD

cSoap += '<OperacaoTitulo xmlns="http://grupobst.com.br/services">'
cSoap += WSSoapValue("token", ::ctoken, ctoken , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("titulo", ::oWStitulo, oWStitulo , "operacaoTituloRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</OperacaoTitulo>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"",; 
	"DOCUMENT","http://grupobst.com.br/services",,,; 
	"https://homolog.cenprotempresas.org.br/ieptb/services/ProtestoInterface")

::Init()
oATmp01 :=           WSAdvValue( oXmlRet,"_OPERACAOTITULORESPONSE:_TITULO","operacaoTituloResponse",NIL,NIL,NIL,NIL,@oWStitulo,"xs") 
If valtype(oATmp01)="A"
	aEval(oATmp01,{|x,y| ( aadd(::oWStitulo,services_operacaoTituloResponse():New()) , ::oWStitulo[y]:SoapRecv(x) ) })
Endif

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method Autenticar of Service WSservices

WSMETHOD Autenticar WSSEND BYREF oWScredenciais WSRECEIVE NULLPARAM WSCLIENT WSservices
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<Autenticar xmlns="http://grupobst.com.br/services">'
cSoap += WSSoapValue("credenciais", ::oWScredenciais, oWScredenciais , "autenticarRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</Autenticar>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"",; 
	"DOCUMENT","http://grupobst.com.br/services",,,; 
	"https://homolog.cenprotempresas.org.br/ieptb/services/ProtestoInterface")

::Init()
::oWScredenciais:SoapRecv( WSAdvValue( oXmlRet,"_AUTENTICARRESPONSE:_CREDENCIAIS","autenticarResponse",NIL,NIL,NIL,NIL,@oWScredenciais,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ConsultarCedente of Service WSservices

WSMETHOD ConsultarCedente WSSEND ctoken,oWScedente WSRECEIVE oWSresultado WSCLIENT WSservices
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ConsultarCedente xmlns="http://grupobst.com.br/services">'
cSoap += WSSoapValue("token", ::ctoken, ctoken , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cedente", ::oWScedente, oWScedente , "cedente-consulta", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</ConsultarCedente>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"",; 
	"DOCUMENT","http://grupobst.com.br/services",,,; 
	"https://homolog.cenprotempresas.org.br/ieptb/services/ProtestoInterface")

::Init()
::oWSresultado:SoapRecv( WSAdvValue( oXmlRet,"_CONSULTARCEDENTERESPONSE:_RESULTADO","cedente-consulta-response",NIL,NIL,NIL,NIL,NIL,"xs") )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ConsultarTitulo of Service WSservices

WSMETHOD ConsultarTitulo WSSEND ctoken,ccompleta,cinstrumento,canuencia,BYREF oWStitulo WSRECEIVE NULLPARAM WSCLIENT WSservices
Local cSoap := "" , oXmlRet
Local oATmp01

BEGIN WSMETHOD

cSoap += '<ConsultarTitulo xmlns="http://grupobst.com.br/services">'
cSoap += WSSoapValue("token", ::ctoken, ctoken , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("completa", ::ccompleta, ccompleta , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("instrumento", ::cinstrumento, cinstrumento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("anuencia", ::canuencia, canuencia , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("titulo", ::oWStitulo, oWStitulo , "consultarTituloRequest", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</ConsultarTitulo>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"",; 
	"DOCUMENT","http://grupobst.com.br/services",,,; 
	"https://homolog.cenprotempresas.org.br/ieptb/services/ProtestoInterface")

::Init()
oATmp01 :=           WSAdvValue( oXmlRet,"_CONSULTARTITULORESPONSE:_TITULO","consultarTituloResponse",NIL,NIL,NIL,NIL,@oWStitulo,"xs") 
If valtype(oATmp01)="A"
	aEval(oATmp01,{|x,y| ( aadd(::oWStitulo,services_consultarTituloResponse():New()) , ::oWStitulo[y]:SoapRecv(x) ) })
Endif

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure apresentante-consulta-request

WSSTRUCT services_apresentante_consulta_request
	WSDATA   cnome                     AS string OPTIONAL
	WSDATA   ccodigo                   AS string OPTIONAL
	WSDATA   cdocumento                AS string OPTIONAL
	WSDATA   cuf                       AS string OPTIONAL
	WSDATA   cmunicipio                AS string OPTIONAL
	WSDATA   cativo                    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT services_apresentante_consulta_request
	::Init()
Return Self

WSMETHOD INIT WSCLIENT services_apresentante_consulta_request
Return

WSMETHOD CLONE WSCLIENT services_apresentante_consulta_request
	Local oClone := services_apresentante_consulta_request():NEW()
	oClone:cnome                := ::cnome
	oClone:ccodigo              := ::ccodigo
	oClone:cdocumento           := ::cdocumento
	oClone:cuf                  := ::cuf
	oClone:cmunicipio           := ::cmunicipio
	oClone:cativo               := ::cativo
Return oClone

WSMETHOD SOAPSEND WSCLIENT services_apresentante_consulta_request
	Local cSoap := ""
	cSoap += WSSoapValue("nome", ::cnome, ::cnome , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("codigo", ::ccodigo, ::ccodigo , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("documento", ::cdocumento, ::cdocumento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("uf", ::cuf, ::cuf , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("municipio", ::cmunicipio, ::cmunicipio , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ativo", ::cativo, ::cativo , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure apresentante-consulta-response

WSSTRUCT services_apresentante_consulta_response
	WSDATA   ntotal                    AS int OPTIONAL
	WSDATA   oWSapresentante           AS services_apresentante_response OPTIONAL
	WSDATA   oWSresposta               AS services_statusResponse OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT services_apresentante_consulta_response
	::Init()
Return Self

WSMETHOD INIT WSCLIENT services_apresentante_consulta_response
	::oWSapresentante      := {} // Array Of  services_APRESENTANTE_RESPONSE():New()
Return

WSMETHOD CLONE WSCLIENT services_apresentante_consulta_response
	Local oClone := services_apresentante_consulta_response():NEW()
	oClone:ntotal               := ::ntotal
	oClone:oWSapresentante := NIL
	If ::oWSapresentante <> NIL 
		oClone:oWSapresentante := {}
		aEval( ::oWSapresentante , { |x| aadd( oClone:oWSapresentante , x:Clone() ) } )
	Endif 
	oClone:oWSresposta          := IIF(::oWSresposta = NIL , NIL , ::oWSresposta:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT services_apresentante_consulta_response
	Local nRElem2, oNodes2, nTElem2
	Local oNode3
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::ntotal             :=  WSAdvValue( oResponse,"_TOTAL","int",NIL,NIL,NIL,"N",NIL,"xs") 
	oNodes2 :=  WSAdvValue( oResponse,"_APRESENTANTE","apresentante-response",{},NIL,.T.,"O",NIL,"xs") 
	nTElem2 := len(oNodes2)
	For nRElem2 := 1 to nTElem2 
		If !WSIsNilNode( oNodes2[nRElem2] )
			aadd(::oWSapresentante , services_apresentante_response():New() )
			::oWSapresentante[len(::oWSapresentante)]:SoapRecv(oNodes2[nRElem2])
		Endif
	Next
	oNode3 :=  WSAdvValue( oResponse,"_RESPOSTA","statusResponse",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode3 != NIL
		::oWSresposta := services_statusResponse():New()
		::oWSresposta:SoapRecv(oNode3)
	EndIf
Return

// WSDL Data Structure enviarTituloRequest

WSSTRUCT services_enviarTituloRequest
	WSDATA   calteracao                AS string OPTIONAL
	WSDATA   oWScedente                AS services_xmlCedente OPTIONAL
	WSDATA   oWSsacador                AS services_xmlSacador OPTIONAL
	WSDATA   oWSdevedor                AS services_devedor_enviar OPTIONAL
	WSDATA   oWSdivida                 AS services_divida_enviar OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT services_enviarTituloRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT services_enviarTituloRequest
	::oWSdevedor           := {} // Array Of  services_DEVEDOR_ENVIAR():New()
Return

WSMETHOD CLONE WSCLIENT services_enviarTituloRequest
	Local oClone := services_enviarTituloRequest():NEW()
	oClone:calteracao           := ::calteracao
	oClone:oWScedente           := IIF(::oWScedente = NIL , NIL , ::oWScedente:Clone() )
	oClone:oWSsacador           := IIF(::oWSsacador = NIL , NIL , ::oWSsacador:Clone() )
	oClone:oWSdevedor := NIL
	If ::oWSdevedor <> NIL 
		oClone:oWSdevedor := {}
		aEval( ::oWSdevedor , { |x| aadd( oClone:oWSdevedor , x:Clone() ) } )
	Endif 
	oClone:oWSdivida            := IIF(::oWSdivida = NIL , NIL , ::oWSdivida:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT services_enviarTituloRequest
	Local cSoap := ""
	cSoap += WSSoapValue("alteracao", ::calteracao, ::calteracao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("cedente", ::oWScedente, ::oWScedente , "xmlCedente", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("sacador", ::oWSsacador, ::oWSsacador , "xmlSacador", .F. , .F., 0 , NIL, .F.,.F.) 
	aEval( ::oWSdevedor , {|x| cSoap := cSoap  +  WSSoapValue("devedor", x , x , "devedor-enviar", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
	cSoap += WSSoapValue("divida", ::oWSdivida, ::oWSdivida , "divida-enviar", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure movimento-consultar

WSSTRUCT services_movimento_consultar
	WSDATA   cdata                     AS string OPTIONAL
	WSDATA   oWSstatus                 AS services_tipoMovimento OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT services_movimento_consultar
	::Init()
Return Self

WSMETHOD INIT WSCLIENT services_movimento_consultar
	::oWSstatus            := {} // Array Of  services_TIPOMOVIMENTO():New()
Return

WSMETHOD CLONE WSCLIENT services_movimento_consultar
	Local oClone := services_movimento_consultar():NEW()
	oClone:cdata                := ::cdata
	oClone:oWSstatus := NIL
	If ::oWSstatus <> NIL 
		oClone:oWSstatus := {}
		aEval( ::oWSstatus , { |x| aadd( oClone:oWSstatus , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT services_movimento_consultar
	Local cSoap := ""
	cSoap += WSSoapValue("data", ::cdata, ::cdata , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	aEval( ::oWSstatus , {|x| cSoap := cSoap  +  WSSoapValue("status", x , x , "tipoMovimento", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure cedente-cadastro

WSSTRUCT services_cedente_cadastro
	WSDATA   oWSoperacao               AS services_tipoOperacao OPTIONAL
	WSDATA   cnome                     AS string OPTIONAL
	WSDATA   ccodigo                   AS string OPTIONAL
	WSDATA   cemail                    AS string OPTIONAL
	WSDATA   ctelefone                 AS string OPTIONAL
	WSDATA   cdocumentoTipo            AS string OPTIONAL
	WSDATA   cdocumento                AS string OPTIONAL
	WSDATA   oWSendereco               AS services_cedente_endereco OPTIONAL
	WSDATA   oWSdadosBancario          AS services_cedente_bancario OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT services_cedente_cadastro
	::Init()
Return Self

WSMETHOD INIT WSCLIENT services_cedente_cadastro
Return

WSMETHOD CLONE WSCLIENT services_cedente_cadastro
	Local oClone := services_cedente_cadastro():NEW()
	oClone:oWSoperacao          := IIF(::oWSoperacao = NIL , NIL , ::oWSoperacao:Clone() )
	oClone:cnome                := ::cnome
	oClone:ccodigo              := ::ccodigo
	oClone:cemail               := ::cemail
	oClone:ctelefone            := ::ctelefone
	oClone:cdocumentoTipo       := ::cdocumentoTipo
	oClone:cdocumento           := ::cdocumento
	oClone:oWSendereco          := IIF(::oWSendereco = NIL , NIL , ::oWSendereco:Clone() )
	oClone:oWSdadosBancario     := IIF(::oWSdadosBancario = NIL , NIL , ::oWSdadosBancario:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT services_cedente_cadastro
	Local cSoap := ""
	cSoap += WSSoapValue("operacao", ::oWSoperacao, ::oWSoperacao , "tipoOperacao", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("nome", ::cnome, ::cnome , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("codigo", ::ccodigo, ::ccodigo , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("email", ::cemail, ::cemail , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("telefone", ::ctelefone, ::ctelefone , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("documentoTipo", ::cdocumentoTipo, ::cdocumentoTipo , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("documento", ::cdocumento, ::cdocumento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("endereco", ::oWSendereco, ::oWSendereco , "cedente-endereco", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("dadosBancario", ::oWSdadosBancario, ::oWSdadosBancario , "cedente-bancario", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure consultarArquivoRequest

WSSTRUCT services_consultarArquivoRequest
	WSDATA   oWStipoArquivo            AS services_tipoArquivo OPTIONAL
	WSDATA   cdataArquivo              AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT services_consultarArquivoRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT services_consultarArquivoRequest
Return

WSMETHOD CLONE WSCLIENT services_consultarArquivoRequest
	Local oClone := services_consultarArquivoRequest():NEW()
	oClone:oWStipoArquivo       := IIF(::oWStipoArquivo = NIL , NIL , ::oWStipoArquivo:Clone() )
	oClone:cdataArquivo         := ::cdataArquivo
Return oClone

WSMETHOD SOAPSEND WSCLIENT services_consultarArquivoRequest
	Local cSoap := ""
	cSoap += WSSoapValue("tipoArquivo", ::oWStipoArquivo, ::oWStipoArquivo , "tipoArquivo", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("dataArquivo", ::cdataArquivo, ::cdataArquivo , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure autenticarRequest

WSSTRUCT services_autenticarRequest
	WSDATA   cusuario                  AS string OPTIONAL
	WSDATA   csenha                    AS string OPTIONAL
	WSDATA   capresentante             AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT services_autenticarRequest
	::Init()
Return Self

WSMETHOD INIT WSCLIENT services_autenticarRequest
Return

WSMETHOD CLONE WSCLIENT services_autenticarRequest
	Local oClone := services_autenticarRequest():NEW()
	oClone:cusuario             := ::cusuario
	oClone:csenha               := ::csenha
	oClone:capresentante        := ::capresentante
Return oClone

WSMETHOD SOAPSEND WSCLIENT services_autenticarRequest
	Local cSoap := ""
	cSoap += WSSoapValue("usuario", ::cusuario, ::cusuario , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("senha", ::csenha, ::csenha , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("apresentante", ::capresentante, ::capresentante , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure apresentante-response

WSSTRUCT services_apresentante_response
	WSDATA   cnome                     AS string OPTIONAL
	WSDATA   ccodigo                   AS string OPTIONAL
	WSDATA   cemail                    AS string OPTIONAL
	WSDATA   ctelefone                 AS string OPTIONAL
	WSDATA   cdocumento                AS string OPTIONAL
	WSDATA   oWSendereco               AS services_cedente_endereco OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT services_apresentante_response
	::Init()
Return Self

WSMETHOD INIT WSCLIENT services_apresentante_response
Return

WSMETHOD CLONE WSCLIENT services_apresentante_response
	Local oClone := services_apresentante_response():NEW()
	oClone:cnome                := ::cnome
	oClone:ccodigo              := ::ccodigo
	oClone:cemail               := ::cemail
	oClone:ctelefone            := ::ctelefone
	oClone:cdocumento           := ::cdocumento
	oClone:oWSendereco          := IIF(::oWSendereco = NIL , NIL , ::oWSendereco:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT services_apresentante_response
	Local oNode6
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cnome              :=  WSAdvValue( oResponse,"_NOME","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::ccodigo            :=  WSAdvValue( oResponse,"_CODIGO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cemail             :=  WSAdvValue( oResponse,"_EMAIL","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::ctelefone          :=  WSAdvValue( oResponse,"_TELEFONE","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cdocumento         :=  WSAdvValue( oResponse,"_DOCUMENTO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	oNode6 :=  WSAdvValue( oResponse,"_ENDERECO","cedente-endereco",NIL,NIL,NIL,"O",NIL,"xs") 
	If oNode6 != NIL
		::oWSendereco := services_cedente_endereco():New()
		::oWSendereco:SoapRecv(oNode6)
	EndIf
Return

// WSDL Data Structure statusResponse

WSSTRUCT services_statusResponse
	WSDATA   ccodigo                   AS string OPTIONAL
	WSDATA   cmensagem                 AS string OPTIONAL
	WSDATA   lstatus                   AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT services_statusResponse
	::Init()
Return Self

WSMETHOD INIT WSCLIENT services_statusResponse
Return

WSMETHOD CLONE WSCLIENT services_statusResponse
	Local oClone := services_statusResponse():NEW()
	oClone:ccodigo              := ::ccodigo
	oClone:cmensagem            := ::cmensagem
	oClone:lstatus              := ::lstatus
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT services_statusResponse
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::ccodigo            :=  WSAdvValue( oResponse,"_CODIGO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cmensagem          :=  WSAdvValue( oResponse,"_MENSAGEM","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::lstatus            :=  WSAdvValue( oResponse,"_STATUS","boolean",NIL,NIL,NIL,"L",NIL,"xs") 
Return

// WSDL Data Structure xmlCedente

WSSTRUCT services_xmlCedente
	WSDATA   ccodigo                   AS string OPTIONAL
	WSDATA   cnome                     AS string OPTIONAL
	WSDATA   cdocumentoTipo            AS string OPTIONAL
	WSDATA   cdocumento                AS string OPTIONAL
	WSDATA   cendereco                 AS string OPTIONAL
	WSDATA   cnumero                   AS string OPTIONAL
	WSDATA   ccomplemento              AS string OPTIONAL
	WSDATA   ccep                      AS string OPTIONAL
	WSDATA   cbairro                   AS string OPTIONAL
	WSDATA   cmunicipio                AS string OPTIONAL
	WSDATA   cuf                       AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT services_xmlCedente
	::Init()
Return Self

WSMETHOD INIT WSCLIENT services_xmlCedente
Return

WSMETHOD CLONE WSCLIENT services_xmlCedente
	Local oClone := services_xmlCedente():NEW()
	oClone:ccodigo              := ::ccodigo
	oClone:cnome                := ::cnome
	oClone:cdocumentoTipo       := ::cdocumentoTipo
	oClone:cdocumento           := ::cdocumento
	oClone:cendereco            := ::cendereco
	oClone:cnumero              := ::cnumero
	oClone:ccomplemento         := ::ccomplemento
	oClone:ccep                 := ::ccep
	oClone:cbairro              := ::cbairro
	oClone:cmunicipio           := ::cmunicipio
	oClone:cuf                  := ::cuf
Return oClone

WSMETHOD SOAPSEND WSCLIENT services_xmlCedente
	Local cSoap := ""
	cSoap += WSSoapValue("codigo", ::ccodigo, ::ccodigo , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("nome", ::cnome, ::cnome , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("documentoTipo", ::cdocumentoTipo, ::cdocumentoTipo , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("documento", ::cdocumento, ::cdocumento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("endereco", ::cendereco, ::cendereco , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("numero", ::cnumero, ::cnumero , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("complemento", ::ccomplemento, ::ccomplemento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("cep", ::ccep, ::ccep , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("bairro", ::cbairro, ::cbairro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("municipio", ::cmunicipio, ::cmunicipio , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("uf", ::cuf, ::cuf , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure xmlSacador

WSSTRUCT services_xmlSacador
	WSDATA   cnome                     AS string OPTIONAL
	WSDATA   cdocumentoTipo            AS string OPTIONAL
	WSDATA   cdocumento                AS string OPTIONAL
	WSDATA   cendereco                 AS string OPTIONAL
	WSDATA   cnumero                   AS string OPTIONAL
	WSDATA   ccomplemento              AS string OPTIONAL
	WSDATA   ccep                      AS string OPTIONAL
	WSDATA   cbairro                   AS string OPTIONAL
	WSDATA   cmunicipio                AS string OPTIONAL
	WSDATA   cuf                       AS string OPTIONAL
	WSDATA   cempresa                  AS string OPTIONAL
	WSDATA   cfilial                   AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT services_xmlSacador
	::Init()
Return Self

WSMETHOD INIT WSCLIENT services_xmlSacador
Return

WSMETHOD CLONE WSCLIENT services_xmlSacador
	Local oClone := services_xmlSacador():NEW()
	oClone:cnome                := ::cnome
	oClone:cdocumentoTipo       := ::cdocumentoTipo
	oClone:cdocumento           := ::cdocumento
	oClone:cendereco            := ::cendereco
	oClone:cnumero              := ::cnumero
	oClone:ccomplemento         := ::ccomplemento
	oClone:ccep                 := ::ccep
	oClone:cbairro              := ::cbairro
	oClone:cmunicipio           := ::cmunicipio
	oClone:cuf                  := ::cuf
	oClone:cempresa             := ::cempresa
	oClone:cfilial              := ::cfilial
Return oClone

WSMETHOD SOAPSEND WSCLIENT services_xmlSacador
	Local cSoap := ""
	cSoap += WSSoapValue("nome", ::cnome, ::cnome , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("documentoTipo", ::cdocumentoTipo, ::cdocumentoTipo , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("documento", ::cdocumento, ::cdocumento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("endereco", ::cendereco, ::cendereco , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("numero", ::cnumero, ::cnumero , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("complemento", ::ccomplemento, ::ccomplemento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("cep", ::ccep, ::ccep , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("bairro", ::cbairro, ::cbairro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("municipio", ::cmunicipio, ::cmunicipio , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("uf", ::cuf, ::cuf , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("empresa", ::cempresa, ::cempresa , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("filial", ::cfilial, ::cfilial , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure devedor-enviar

WSSTRUCT services_devedor_enviar
	WSDATA   cnome                     AS string OPTIONAL
	WSDATA   cdocumentoTipo            AS string OPTIONAL
	WSDATA   cdocumento                AS string OPTIONAL
	WSDATA   cendereco                 AS string OPTIONAL
	WSDATA   cnumero                   AS string OPTIONAL
	WSDATA   ccomplemento              AS string OPTIONAL
	WSDATA   ccep                      AS string OPTIONAL
	WSDATA   cbairro                   AS string OPTIONAL
	WSDATA   cmunicipio                AS string OPTIONAL
	WSDATA   cuf                       AS string OPTIONAL
	WSDATA   cprincipal                AS string OPTIONAL
	WSDATA   cfone                     AS string OPTIONAL
	WSDATA   cemail                    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT services_devedor_enviar
	::Init()
Return Self

WSMETHOD INIT WSCLIENT services_devedor_enviar
Return

WSMETHOD CLONE WSCLIENT services_devedor_enviar
	Local oClone := services_devedor_enviar():NEW()
	oClone:cnome                := ::cnome
	oClone:cdocumentoTipo       := ::cdocumentoTipo
	oClone:cdocumento           := ::cdocumento
	oClone:cendereco            := ::cendereco
	oClone:cnumero              := ::cnumero
	oClone:ccomplemento         := ::ccomplemento
	oClone:ccep                 := ::ccep
	oClone:cbairro              := ::cbairro
	oClone:cmunicipio           := ::cmunicipio
	oClone:cuf                  := ::cuf
	oClone:cprincipal           := ::cprincipal
	oClone:cfone                := ::cfone
	oClone:cemail               := ::cemail
Return oClone

WSMETHOD SOAPSEND WSCLIENT services_devedor_enviar
	Local cSoap := ""
	cSoap += WSSoapValue("nome", ::cnome, ::cnome , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("documentoTipo", ::cdocumentoTipo, ::cdocumentoTipo , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("documento", ::cdocumento, ::cdocumento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("endereco", ::cendereco, ::cendereco , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("numero", ::cnumero, ::cnumero , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("complemento", ::ccomplemento, ::ccomplemento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("cep", ::ccep, ::ccep , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("bairro", ::cbairro, ::cbairro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("municipio", ::cmunicipio, ::cmunicipio , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("uf", ::cuf, ::cuf , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("principal", ::cprincipal, ::cprincipal , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("fone", ::cfone, ::cfone , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("email", ::cemail, ::cemail , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure divida-enviar

WSSTRUCT services_divida_enviar
	WSDATA   cespecie                  AS string OPTIONAL
	WSDATA   cnumero                   AS string OPTIONAL
	WSDATA   cnossoNumero              AS string OPTIONAL
	WSDATA   cvalor                    AS string OPTIONAL
	WSDATA   csaldo                    AS string OPTIONAL
	WSDATA   ctipoEndosso              AS string OPTIONAL
	WSDATA   caceite                   AS string OPTIONAL
	WSDATA   cfinsFalimentares         AS string OPTIONAL
	WSDATA   cdeclaracaoPortador       AS string OPTIONAL
	WSDATA   cemissao                  AS string OPTIONAL
	WSDATA   cvencimento               AS string OPTIONAL
	WSDATA   oWSdocumento              AS services_documento_enviar OPTIONAL
	WSDATA   oWSplanilha               AS services_xmlPlanilha OPTIONAL
	WSDATA   cpracaManual              AS string OPTIONAL
	WSDATA   canotacao                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT services_divida_enviar
	::Init()
Return Self

WSMETHOD INIT WSCLIENT services_divida_enviar
	::oWSdocumento         := {} // Array Of  services_DOCUMENTO_ENVIAR():New()
Return

WSMETHOD CLONE WSCLIENT services_divida_enviar
	Local oClone := services_divida_enviar():NEW()
	oClone:cespecie             := ::cespecie
	oClone:cnumero              := ::cnumero
	oClone:cnossoNumero         := ::cnossoNumero
	oClone:cvalor               := ::cvalor
	oClone:csaldo               := ::csaldo
	oClone:ctipoEndosso         := ::ctipoEndosso
	oClone:caceite              := ::caceite
	oClone:cfinsFalimentares    := ::cfinsFalimentares
	oClone:cdeclaracaoPortador  := ::cdeclaracaoPortador
	oClone:cemissao             := ::cemissao
	oClone:cvencimento          := ::cvencimento
	oClone:oWSdocumento := NIL
	If ::oWSdocumento <> NIL 
		oClone:oWSdocumento := {}
		aEval( ::oWSdocumento , { |x| aadd( oClone:oWSdocumento , x:Clone() ) } )
	Endif 
	oClone:oWSplanilha          := IIF(::oWSplanilha = NIL , NIL , ::oWSplanilha:Clone() )
	oClone:cpracaManual         := ::cpracaManual
	oClone:canotacao            := ::canotacao
Return oClone

WSMETHOD SOAPSEND WSCLIENT services_divida_enviar
	Local cSoap := ""
	cSoap += WSSoapValue("especie", ::cespecie, ::cespecie , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("numero", ::cnumero, ::cnumero , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("nossoNumero", ::cnossoNumero, ::cnossoNumero , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("valor", ::cvalor, ::cvalor , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("saldo", ::csaldo, ::csaldo , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("tipoEndosso", ::ctipoEndosso, ::ctipoEndosso , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("aceite", ::caceite, ::caceite , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("finsFalimentares", ::cfinsFalimentares, ::cfinsFalimentares , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("declaracaoPortador", ::cdeclaracaoPortador, ::cdeclaracaoPortador , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("emissao", ::cemissao, ::cemissao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("vencimento", ::cvencimento, ::cvencimento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	aEval( ::oWSdocumento , {|x| cSoap := cSoap  +  WSSoapValue("documento", x , x , "documento-enviar", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
	cSoap += WSSoapValue("planilha", ::oWSplanilha, ::oWSplanilha , "xmlPlanilha", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("pracaManual", ::cpracaManual, ::cpracaManual , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("anotacao", ::canotacao, ::canotacao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Enumeration tipoMovimento

WSSTRUCT services_tipoMovimento
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT services_tipoMovimento
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "GERADO" )
	aadd(::aValueList , "PAGO" )
	aadd(::aValueList , "CONFIRMADO" )
	aadd(::aValueList , "CANCELADO" )
	aadd(::aValueList , "DEVOLVIDO" )
	aadd(::aValueList , "PROTESTADO" )
	aadd(::aValueList , "RETIRADO" )
	aadd(::aValueList , "SUSTADO" )
	aadd(::aValueList , "SUSTADO_DEFINITIVO" )
	aadd(::aValueList , "SUSPENSO" )
Return Self

WSMETHOD SOAPSEND WSCLIENT services_tipoMovimento
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT services_tipoMovimento
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT services_tipoMovimento
Local oClone := services_tipoMovimento():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Enumeration tipoOperacao

WSSTRUCT services_tipoOperacao
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT services_tipoOperacao
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "INCLUIR" )
	aadd(::aValueList , "ALTERAR" )
	aadd(::aValueList , "EXCLUIR" )
Return Self

WSMETHOD SOAPSEND WSCLIENT services_tipoOperacao
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT services_tipoOperacao
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT services_tipoOperacao
Local oClone := services_tipoOperacao():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Structure cedente-endereco

WSSTRUCT services_cedente_endereco
	WSDATA   cendereco                 AS string OPTIONAL
	WSDATA   ccomplemento              AS string OPTIONAL
	WSDATA   ccep                      AS string OPTIONAL
	WSDATA   cbairro                   AS string OPTIONAL
	WSDATA   cmunicipio                AS string OPTIONAL
	WSDATA   cuf                       AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT services_cedente_endereco
	::Init()
Return Self

WSMETHOD INIT WSCLIENT services_cedente_endereco
Return

WSMETHOD CLONE WSCLIENT services_cedente_endereco
	Local oClone := services_cedente_endereco():NEW()
	oClone:cendereco            := ::cendereco
	oClone:ccomplemento         := ::ccomplemento
	oClone:ccep                 := ::ccep
	oClone:cbairro              := ::cbairro
	oClone:cmunicipio           := ::cmunicipio
	oClone:cuf                  := ::cuf
Return oClone

WSMETHOD SOAPSEND WSCLIENT services_cedente_endereco
	Local cSoap := ""
	cSoap += WSSoapValue("endereco", ::cendereco, ::cendereco , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("complemento", ::ccomplemento, ::ccomplemento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("cep", ::ccep, ::ccep , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("bairro", ::cbairro, ::cbairro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("municipio", ::cmunicipio, ::cmunicipio , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("uf", ::cuf, ::cuf , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT services_cedente_endereco
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cendereco          :=  WSAdvValue( oResponse,"_ENDERECO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::ccomplemento       :=  WSAdvValue( oResponse,"_COMPLEMENTO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::ccep               :=  WSAdvValue( oResponse,"_CEP","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cbairro            :=  WSAdvValue( oResponse,"_BAIRRO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cmunicipio         :=  WSAdvValue( oResponse,"_MUNICIPIO","string",NIL,NIL,NIL,"S",NIL,"xs") 
	::cuf                :=  WSAdvValue( oResponse,"_UF","string",NIL,NIL,NIL,"S",NIL,"xs") 
Return

// WSDL Data Structure cedente-bancario

WSSTRUCT services_cedente_bancario
	WSDATA   cbanco                    AS string OPTIONAL
	WSDATA   cagencia                  AS string OPTIONAL
	WSDATA   cconta                    AS string OPTIONAL
	WSDATA   coperacao                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT services_cedente_bancario
	::Init()
Return Self

WSMETHOD INIT WSCLIENT services_cedente_bancario
Return

WSMETHOD CLONE WSCLIENT services_cedente_bancario
	Local oClone := services_cedente_bancario():NEW()
	oClone:cbanco               := ::cbanco
	oClone:cagencia             := ::cagencia
	oClone:cconta               := ::cconta
	oClone:coperacao            := ::coperacao
Return oClone

WSMETHOD SOAPSEND WSCLIENT services_cedente_bancario
	Local cSoap := ""
	cSoap += WSSoapValue("banco", ::cbanco, ::cbanco , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("agencia", ::cagencia, ::cagencia , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("conta", ::cconta, ::cconta , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("operacao", ::coperacao, ::coperacao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Enumeration tipoArquivo

WSSTRUCT services_tipoArquivo
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT services_tipoArquivo
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "RETORNO" )
	aadd(::aValueList , "CONFIRMACAO" )
Return Self

WSMETHOD SOAPSEND WSCLIENT services_tipoArquivo
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT services_tipoArquivo
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT services_tipoArquivo
Local oClone := services_tipoArquivo():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Structure documento-enviar

WSSTRUCT services_documento_enviar
	WSDATA   cextensao                 AS string OPTIONAL
	WSDATA   cdocumentoBase64          AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT services_documento_enviar
	::Init()
Return Self

WSMETHOD INIT WSCLIENT services_documento_enviar
Return

WSMETHOD CLONE WSCLIENT services_documento_enviar
	Local oClone := services_documento_enviar():NEW()
	oClone:cextensao            := ::cextensao
	oClone:cdocumentoBase64     := ::cdocumentoBase64
Return oClone

WSMETHOD SOAPSEND WSCLIENT services_documento_enviar
	Local cSoap := ""
	cSoap += WSSoapValue("extensao", ::cextensao, ::cextensao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("documentoBase64", ::cdocumentoBase64, ::cdocumentoBase64 , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure xmlPlanilha

WSSTRUCT services_xmlPlanilha
	WSDATA   cjuros                    AS string OPTIONAL
	WSDATA   cmulta                    AS string OPTIONAL
	WSDATA   cmora                     AS string OPTIONAL
	WSDATA   oWScalculo                AS services_xmlCalculo OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT services_xmlPlanilha
	::Init()
Return Self

WSMETHOD INIT WSCLIENT services_xmlPlanilha
	::oWScalculo           := {} // Array Of  services_XMLCALCULO():New()
Return

WSMETHOD CLONE WSCLIENT services_xmlPlanilha
	Local oClone := services_xmlPlanilha():NEW()
	oClone:cjuros               := ::cjuros
	oClone:cmulta               := ::cmulta
	oClone:cmora                := ::cmora
	oClone:oWScalculo := NIL
	If ::oWScalculo <> NIL 
		oClone:oWScalculo := {}
		aEval( ::oWScalculo , { |x| aadd( oClone:oWScalculo , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT services_xmlPlanilha
	Local cSoap := ""
	cSoap += WSSoapValue("juros", ::cjuros, ::cjuros , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("multa", ::cmulta, ::cmulta , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("mora", ::cmora, ::cmora , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	aEval( ::oWScalculo , {|x| cSoap := cSoap  +  WSSoapValue("calculo", x , x , "xmlCalculo", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure xmlCalculo

WSSTRUCT services_xmlCalculo
	WSDATA   cparcela                  AS string OPTIONAL
	WSDATA   cvencimento               AS string OPTIONAL
	WSDATA   cvalor                    AS string OPTIONAL
	WSDATA   csaldo                    AS string OPTIONAL
	WSDATA   cjuros                    AS string OPTIONAL
	WSDATA   cmulta                    AS string OPTIONAL
	WSDATA   cmora                     AS string OPTIONAL
	WSDATA   cobservacao               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT services_xmlCalculo
	::Init()
Return Self

WSMETHOD INIT WSCLIENT services_xmlCalculo
Return

WSMETHOD CLONE WSCLIENT services_xmlCalculo
	Local oClone := services_xmlCalculo():NEW()
	oClone:cparcela             := ::cparcela
	oClone:cvencimento          := ::cvencimento
	oClone:cvalor               := ::cvalor
	oClone:csaldo               := ::csaldo
	oClone:cjuros               := ::cjuros
	oClone:cmulta               := ::cmulta
	oClone:cmora                := ::cmora
	oClone:cobservacao          := ::cobservacao
Return oClone

WSMETHOD SOAPSEND WSCLIENT services_xmlCalculo
	Local cSoap := ""
	cSoap += WSSoapValue("parcela", ::cparcela, ::cparcela , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("vencimento", ::cvencimento, ::cvencimento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("valor", ::cvalor, ::cvalor , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("saldo", ::csaldo, ::csaldo , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("juros", ::cjuros, ::cjuros , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("multa", ::cmulta, ::cmulta , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("mora", ::cmora, ::cmora , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("observacao", ::cobservacao, ::cobservacao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap



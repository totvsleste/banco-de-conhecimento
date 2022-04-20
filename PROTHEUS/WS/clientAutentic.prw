#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/* ===============================================================================
WSDL Location    http://localhost:1978/FFABA001.apw?WSDL
Gerado em        05/04/22 16:09:07
Observa��es      C�digo-Fonte gerado por ADVPL WSDL Client 1.120703
                 Altera��es neste arquivo podem causar funcionamento incorreto
                 e ser�o perdidas caso o c�digo-fonte seja gerado novamente.
=============================================================================== */

User Function _JLKZOCK ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSFFABA001
------------------------------------------------------------------------------- */

WSCLIENT WSFFABA001

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD MTDLISTACLIENTES

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSO_EMPRESA              AS FFABA001_STREMPRESA
	WSDATA   oWSMTDLISTACLIENTESRESULT AS FFABA001_ARRAYOFSTRLISTACLIENTES

	// Estruturas mantidas por compatibilidade - N�O USAR
	WSDATA   oWSSTREMPRESA             AS FFABA001_STREMPRESA

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSFFABA001
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O C�digo-Fonte Client atual requer os execut�veis do Protheus Build [7.00.210324P-20211206] ou superior. Atualize o Protheus ou gere o C�digo-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSFFABA001
	::oWSO_EMPRESA       := FFABA001_STREMPRESA():New()
	::oWSMTDLISTACLIENTESRESULT := FFABA001_ARRAYOFSTRLISTACLIENTES():New()

	// Estruturas mantidas por compatibilidade - N�O USAR
	::oWSSTREMPRESA      := ::oWSO_EMPRESA
Return

WSMETHOD RESET WSCLIENT WSFFABA001
	::oWSO_EMPRESA       := NIL 
	::oWSMTDLISTACLIENTESRESULT := NIL 

	// Estruturas mantidas por compatibilidade - N�O USAR
	::oWSSTREMPRESA      := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSFFABA001
Local oClone := WSFFABA001():New()
	oClone:_URL          := ::_URL 
	oClone:oWSO_EMPRESA  :=  IIF(::oWSO_EMPRESA = NIL , NIL ,::oWSO_EMPRESA:Clone() )
	oClone:oWSMTDLISTACLIENTESRESULT :=  IIF(::oWSMTDLISTACLIENTESRESULT = NIL , NIL ,::oWSMTDLISTACLIENTESRESULT:Clone() )

	// Estruturas mantidas por compatibilidade - N�O USAR
	oClone:oWSSTREMPRESA := oClone:oWSO_EMPRESA
Return oClone

// WSDL Method MTDLISTACLIENTES of Service WSFFABA001

WSMETHOD MTDLISTACLIENTES WSSEND oWSO_EMPRESA WSRECEIVE oWSMTDLISTACLIENTESRESULT WSCLIENT WSFFABA001
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<MTDLISTACLIENTES xmlns="http://localhost:1978/">'
cSoap += WSSoapValue("O_EMPRESA", ::oWSO_EMPRESA, oWSO_EMPRESA , "STREMPRESA", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</MTDLISTACLIENTES>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://localhost:1978/MTDLISTACLIENTES",; 
	"DOCUMENT","http://localhost:1978/",,"1.031217",; 
	"http://localhost:1978/FFABA001.apw")

::Init()
::oWSMTDLISTACLIENTESRESULT:SoapRecv( WSAdvValue( oXmlRet,"_MTDLISTACLIENTESRESPONSE:_MTDLISTACLIENTESRESULT","ARRAYOFSTRLISTACLIENTES",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure STREMPRESA

WSSTRUCT FFABA001_STREMPRESA
	WSDATA   cC_EMPRESA                AS string
	WSDATA   cC_FILIAL                 AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FFABA001_STREMPRESA
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FFABA001_STREMPRESA
Return

WSMETHOD CLONE WSCLIENT FFABA001_STREMPRESA
	Local oClone := FFABA001_STREMPRESA():NEW()
	oClone:cC_EMPRESA           := ::cC_EMPRESA
	oClone:cC_FILIAL            := ::cC_FILIAL
Return oClone

WSMETHOD SOAPSEND WSCLIENT FFABA001_STREMPRESA
	Local cSoap := ""
	cSoap += WSSoapValue("C_EMPRESA", ::cC_EMPRESA, ::cC_EMPRESA , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("C_FILIAL", ::cC_FILIAL, ::cC_FILIAL , "string", .T. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ARRAYOFSTRLISTACLIENTES

WSSTRUCT FFABA001_ARRAYOFSTRLISTACLIENTES
	WSDATA   oWSSTRLISTACLIENTES       AS FFABA001_STRLISTACLIENTES OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FFABA001_ARRAYOFSTRLISTACLIENTES
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FFABA001_ARRAYOFSTRLISTACLIENTES
	::oWSSTRLISTACLIENTES  := {} // Array Of  FFABA001_STRLISTACLIENTES():New()
Return

WSMETHOD CLONE WSCLIENT FFABA001_ARRAYOFSTRLISTACLIENTES
	Local oClone := FFABA001_ARRAYOFSTRLISTACLIENTES():NEW()
	oClone:oWSSTRLISTACLIENTES := NIL
	If ::oWSSTRLISTACLIENTES <> NIL 
		oClone:oWSSTRLISTACLIENTES := {}
		aEval( ::oWSSTRLISTACLIENTES , { |x| aadd( oClone:oWSSTRLISTACLIENTES , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FFABA001_ARRAYOFSTRLISTACLIENTES
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_STRLISTACLIENTES","STRLISTACLIENTES",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSSTRLISTACLIENTES , FFABA001_STRLISTACLIENTES():New() )
			::oWSSTRLISTACLIENTES[len(::oWSSTRLISTACLIENTES)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure STRLISTACLIENTES

WSSTRUCT FFABA001_STRLISTACLIENTES
	WSDATA   cA1_CGC                   AS string OPTIONAL
	WSDATA   cA1_NOME                  AS string OPTIONAL
	WSDATA   cC_MENSAGEM               AS string OPTIONAL
	WSDATA   lL_STATUS                 AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT FFABA001_STRLISTACLIENTES
	::Init()
Return Self

WSMETHOD INIT WSCLIENT FFABA001_STRLISTACLIENTES
Return

WSMETHOD CLONE WSCLIENT FFABA001_STRLISTACLIENTES
	Local oClone := FFABA001_STRLISTACLIENTES():NEW()
	oClone:cA1_CGC              := ::cA1_CGC
	oClone:cA1_NOME             := ::cA1_NOME
	oClone:cC_MENSAGEM          := ::cC_MENSAGEM
	oClone:lL_STATUS            := ::lL_STATUS
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT FFABA001_STRLISTACLIENTES
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cA1_CGC            :=  WSAdvValue( oResponse,"_A1_CGC","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cA1_NOME           :=  WSAdvValue( oResponse,"_A1_NOME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cC_MENSAGEM        :=  WSAdvValue( oResponse,"_C_MENSAGEM","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lL_STATUS          :=  WSAdvValue( oResponse,"_L_STATUS","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
Return



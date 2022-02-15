#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://srv-app:2828/RMVitae.svc?wsdl
Gerado em        03/28/18 11:30:24
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _YTURTPF ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSRMVitae
------------------------------------------------------------------------------- */

WSCLIENT WSRMVitae

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ManterSecao
	WSMETHOD ManterCargo
	WSMETHOD ManterFuncao
	WSMETHOD ManterCentroCusto
	WSMETHOD ManterFuncionario
	WSMETHOD ManterDepartamento
	WSMETHOD ManterHistoricoAfastamento
	WSMETHOD ManterHistoricoEndereco
	WSMETHOD ManterHistoricoFuncao
	WSMETHOD ManterHistoricoSalario
	WSMETHOD ManterHistoricoSecao
	WSMETHOD ManterHistoricoSituacao
	WSMETHOD ManterEPI
	WSMETHOD ManterCatalogoEPI
	WSMETHOD ManterLoteEPI
	WSMETHOD TransferirEPI
	WSMETHOD TestarServico

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSpSecao                 AS RMVitae_Secao
	WSDATA   oWSpOperacao              AS RMVitae_EOperacao
	WSDATA   oWSManterSecaoResult      AS RMVitae_Retorno
	WSDATA   oWSpCargo                 AS RMVitae_Cargo
	WSDATA   oWSManterCargoResult      AS RMVitae_Retorno
	WSDATA   oWSpFuncao                AS RMVitae_Funcao
	WSDATA   oWSManterFuncaoResult     AS RMVitae_Retorno
	WSDATA   oWSpCentroCusto           AS RMVitae_CentroCusto
	WSDATA   oWSManterCentroCustoResult AS RMVitae_Retorno
	WSDATA   oWSpPessoa                AS RMVitae_Pessoa
	WSDATA   oWSpFuncionario           AS RMVitae_Funcionario
	WSDATA   oWSpDependente            AS RMVitae_Dependente
	WSDATA   oWSManterFuncionarioResult AS RMVitae_Retorno
	WSDATA   oWSpDepartamento          AS RMVitae_Departamento
	WSDATA   oWSManterDepartamentoResult AS RMVitae_Retorno
	WSDATA   oWSpHistoricoAfastamento  AS RMVitae_HistoricoAfastamento
	WSDATA   oWSManterHistoricoAfastamentoResult AS RMVitae_Retorno
	WSDATA   oWSpHistoricoEndereco     AS RMVitae_HistoricoEndereco
	WSDATA   oWSManterHistoricoEnderecoResult AS RMVitae_Retorno
	WSDATA   oWSpHistoricoFuncao       AS RMVitae_HistoricoFuncao
	WSDATA   oWSManterHistoricoFuncaoResult AS RMVitae_Retorno
	WSDATA   oWSpHistoricoSalario      AS RMVitae_HistoricoSalario
	WSDATA   oWSManterHistoricoSalarioResult AS RMVitae_Retorno
	WSDATA   oWSpHistoricoSecao        AS RMVitae_HistoricoSecao
	WSDATA   oWSManterHistoricoSecaoResult AS RMVitae_Retorno
	WSDATA   oWSpHistoricoSituacao     AS RMVitae_HistoricoSituacao
	WSDATA   oWSManterHistoricoSituacaoResult AS RMVitae_Retorno
	WSDATA   oWSpEPI                   AS RMVitae_EPI
	WSDATA   oWSManterEPIResult        AS RMVitae_Retorno
	WSDATA   oWSpCatalogoEPI           AS RMVitae_CatalogoEPI
	WSDATA   oWSManterCatalogoEPIResult AS RMVitae_Retorno
	WSDATA   oWSpLoteEPI               AS RMVitae_LoteEPI
	WSDATA   oWSManterLoteEPIResult    AS RMVitae_Retorno
	WSDATA   oWSTransferirEPIResult    AS RMVitae_Retorno
	WSDATA   lTestarServicoResult      AS boolean

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSRMVitae
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20160323 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
If val(right(GetWSCVer(),8)) < 1.040504
	UserException("O Código-Fonte Client atual requer a versão de Lib para WebServices igual ou superior a ADVPL WSDL Client 1.040504. Atualize o repositório ou gere o Código-Fonte novamente utilizando o repositório atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSRMVitae
	::oWSpSecao          := RMVitae_SECAO():New()
	::oWSpOperacao       := RMVitae_EOPERACAO():New()
	::oWSManterSecaoResult := RMVitae_RETORNO():New()
	::oWSpCargo          := RMVitae_CARGO():New()
	::oWSManterCargoResult := RMVitae_RETORNO():New()
	::oWSpFuncao         := RMVitae_FUNCAO():New()
	::oWSManterFuncaoResult := RMVitae_RETORNO():New()
	::oWSpCentroCusto    := RMVitae_CENTROCUSTO():New()
	::oWSManterCentroCustoResult := RMVitae_RETORNO():New()
	::oWSpPessoa         := RMVitae_PESSOA():New()
	::oWSpFuncionario    := RMVitae_FUNCIONARIO():New()
	::oWSpDependente     := RMVitae_DEPENDENTE():New()
	::oWSManterFuncionarioResult := RMVitae_RETORNO():New()
	::oWSpDepartamento   := RMVitae_DEPARTAMENTO():New()
	::oWSManterDepartamentoResult := RMVitae_RETORNO():New()
	::oWSpHistoricoAfastamento := RMVitae_HISTORICOAFASTAMENTO():New()
	::oWSManterHistoricoAfastamentoResult := RMVitae_RETORNO():New()
	::oWSpHistoricoEndereco := RMVitae_HISTORICOENDERECO():New()
	::oWSManterHistoricoEnderecoResult := RMVitae_RETORNO():New()
	::oWSpHistoricoFuncao := RMVitae_HISTORICOFUNCAO():New()
	::oWSManterHistoricoFuncaoResult := RMVitae_RETORNO():New()
	::oWSpHistoricoSalario := RMVitae_HISTORICOSALARIO():New()
	::oWSManterHistoricoSalarioResult := RMVitae_RETORNO():New()
	::oWSpHistoricoSecao := RMVitae_HISTORICOSECAO():New()
	::oWSManterHistoricoSecaoResult := RMVitae_RETORNO():New()
	::oWSpHistoricoSituacao := RMVitae_HISTORICOSITUACAO():New()
	::oWSManterHistoricoSituacaoResult := RMVitae_RETORNO():New()
	::oWSpEPI            := RMVitae_EPI():New()
	::oWSManterEPIResult := RMVitae_RETORNO():New()
	::oWSpCatalogoEPI    := RMVitae_CATALOGOEPI():New()
	::oWSManterCatalogoEPIResult := RMVitae_RETORNO():New()
	::oWSpLoteEPI        := RMVitae_LOTEEPI():New()
	::oWSManterLoteEPIResult := RMVitae_RETORNO():New()
	::oWSTransferirEPIResult := RMVitae_RETORNO():New()
Return

WSMETHOD RESET WSCLIENT WSRMVitae
	::oWSpSecao          := NIL 
	::oWSpOperacao       := NIL 
	::oWSManterSecaoResult := NIL 
	::oWSpCargo          := NIL 
	::oWSManterCargoResult := NIL 
	::oWSpFuncao         := NIL 
	::oWSManterFuncaoResult := NIL 
	::oWSpCentroCusto    := NIL 
	::oWSManterCentroCustoResult := NIL 
	::oWSpPessoa         := NIL 
	::oWSpFuncionario    := NIL 
	::oWSpDependente     := NIL 
	::oWSManterFuncionarioResult := NIL 
	::oWSpDepartamento   := NIL 
	::oWSManterDepartamentoResult := NIL 
	::oWSpHistoricoAfastamento := NIL 
	::oWSManterHistoricoAfastamentoResult := NIL 
	::oWSpHistoricoEndereco := NIL 
	::oWSManterHistoricoEnderecoResult := NIL 
	::oWSpHistoricoFuncao := NIL 
	::oWSManterHistoricoFuncaoResult := NIL 
	::oWSpHistoricoSalario := NIL 
	::oWSManterHistoricoSalarioResult := NIL 
	::oWSpHistoricoSecao := NIL 
	::oWSManterHistoricoSecaoResult := NIL 
	::oWSpHistoricoSituacao := NIL 
	::oWSManterHistoricoSituacaoResult := NIL 
	::oWSpEPI            := NIL 
	::oWSManterEPIResult := NIL 
	::oWSpCatalogoEPI    := NIL 
	::oWSManterCatalogoEPIResult := NIL 
	::oWSpLoteEPI        := NIL 
	::oWSManterLoteEPIResult := NIL 
	::oWSTransferirEPIResult := NIL 
	::lTestarServicoResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSRMVitae
Local oClone := WSRMVitae():New()
	oClone:_URL          := ::_URL 
	oClone:oWSpSecao     :=  IIF(::oWSpSecao = NIL , NIL ,::oWSpSecao:Clone() )
	oClone:oWSpOperacao  :=  IIF(::oWSpOperacao = NIL , NIL ,::oWSpOperacao:Clone() )
	oClone:oWSManterSecaoResult :=  IIF(::oWSManterSecaoResult = NIL , NIL ,::oWSManterSecaoResult:Clone() )
	oClone:oWSpCargo     :=  IIF(::oWSpCargo = NIL , NIL ,::oWSpCargo:Clone() )
	oClone:oWSManterCargoResult :=  IIF(::oWSManterCargoResult = NIL , NIL ,::oWSManterCargoResult:Clone() )
	oClone:oWSpFuncao    :=  IIF(::oWSpFuncao = NIL , NIL ,::oWSpFuncao:Clone() )
	oClone:oWSManterFuncaoResult :=  IIF(::oWSManterFuncaoResult = NIL , NIL ,::oWSManterFuncaoResult:Clone() )
	oClone:oWSpCentroCusto :=  IIF(::oWSpCentroCusto = NIL , NIL ,::oWSpCentroCusto:Clone() )
	oClone:oWSManterCentroCustoResult :=  IIF(::oWSManterCentroCustoResult = NIL , NIL ,::oWSManterCentroCustoResult:Clone() )
	oClone:oWSpPessoa    :=  IIF(::oWSpPessoa = NIL , NIL ,::oWSpPessoa:Clone() )
	oClone:oWSpFuncionario :=  IIF(::oWSpFuncionario = NIL , NIL ,::oWSpFuncionario:Clone() )
	oClone:oWSpDependente :=  IIF(::oWSpDependente = NIL , NIL ,::oWSpDependente:Clone() )
	oClone:oWSManterFuncionarioResult :=  IIF(::oWSManterFuncionarioResult = NIL , NIL ,::oWSManterFuncionarioResult:Clone() )
	oClone:oWSpDepartamento :=  IIF(::oWSpDepartamento = NIL , NIL ,::oWSpDepartamento:Clone() )
	oClone:oWSManterDepartamentoResult :=  IIF(::oWSManterDepartamentoResult = NIL , NIL ,::oWSManterDepartamentoResult:Clone() )
	oClone:oWSpHistoricoAfastamento :=  IIF(::oWSpHistoricoAfastamento = NIL , NIL ,::oWSpHistoricoAfastamento:Clone() )
	oClone:oWSManterHistoricoAfastamentoResult :=  IIF(::oWSManterHistoricoAfastamentoResult = NIL , NIL ,::oWSManterHistoricoAfastamentoResult:Clone() )
	oClone:oWSpHistoricoEndereco :=  IIF(::oWSpHistoricoEndereco = NIL , NIL ,::oWSpHistoricoEndereco:Clone() )
	oClone:oWSManterHistoricoEnderecoResult :=  IIF(::oWSManterHistoricoEnderecoResult = NIL , NIL ,::oWSManterHistoricoEnderecoResult:Clone() )
	oClone:oWSpHistoricoFuncao :=  IIF(::oWSpHistoricoFuncao = NIL , NIL ,::oWSpHistoricoFuncao:Clone() )
	oClone:oWSManterHistoricoFuncaoResult :=  IIF(::oWSManterHistoricoFuncaoResult = NIL , NIL ,::oWSManterHistoricoFuncaoResult:Clone() )
	oClone:oWSpHistoricoSalario :=  IIF(::oWSpHistoricoSalario = NIL , NIL ,::oWSpHistoricoSalario:Clone() )
	oClone:oWSManterHistoricoSalarioResult :=  IIF(::oWSManterHistoricoSalarioResult = NIL , NIL ,::oWSManterHistoricoSalarioResult:Clone() )
	oClone:oWSpHistoricoSecao :=  IIF(::oWSpHistoricoSecao = NIL , NIL ,::oWSpHistoricoSecao:Clone() )
	oClone:oWSManterHistoricoSecaoResult :=  IIF(::oWSManterHistoricoSecaoResult = NIL , NIL ,::oWSManterHistoricoSecaoResult:Clone() )
	oClone:oWSpHistoricoSituacao :=  IIF(::oWSpHistoricoSituacao = NIL , NIL ,::oWSpHistoricoSituacao:Clone() )
	oClone:oWSManterHistoricoSituacaoResult :=  IIF(::oWSManterHistoricoSituacaoResult = NIL , NIL ,::oWSManterHistoricoSituacaoResult:Clone() )
	oClone:oWSpEPI       :=  IIF(::oWSpEPI = NIL , NIL ,::oWSpEPI:Clone() )
	oClone:oWSManterEPIResult :=  IIF(::oWSManterEPIResult = NIL , NIL ,::oWSManterEPIResult:Clone() )
	oClone:oWSpCatalogoEPI :=  IIF(::oWSpCatalogoEPI = NIL , NIL ,::oWSpCatalogoEPI:Clone() )
	oClone:oWSManterCatalogoEPIResult :=  IIF(::oWSManterCatalogoEPIResult = NIL , NIL ,::oWSManterCatalogoEPIResult:Clone() )
	oClone:oWSpLoteEPI   :=  IIF(::oWSpLoteEPI = NIL , NIL ,::oWSpLoteEPI:Clone() )
	oClone:oWSManterLoteEPIResult :=  IIF(::oWSManterLoteEPIResult = NIL , NIL ,::oWSManterLoteEPIResult:Clone() )
	oClone:oWSTransferirEPIResult :=  IIF(::oWSTransferirEPIResult = NIL , NIL ,::oWSTransferirEPIResult:Clone() )
	oClone:lTestarServicoResult := ::lTestarServicoResult
Return oClone

// WSDL Method ManterSecao of Service WSRMVitae

WSMETHOD ManterSecao WSSEND oWSpSecao,oWSpOperacao WSRECEIVE oWSManterSecaoResult WSCLIENT WSRMVitae
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ManterSecao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("pSecao", ::oWSpSecao, oWSpSecao , "Secao", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += WSSoapValue("pOperacao", ::oWSpOperacao, oWSpOperacao , "EOperacao", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ManterSecao>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IRMVitae/ManterSecao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://srv-app:2828/RMVitae.svc")

::Init()
::oWSManterSecaoResult:SoapRecv( WSAdvValue( oXmlRet,"_MANTERSECAORESPONSE:_MANTERSECAORESULT","Retorno",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ManterCargo of Service WSRMVitae

WSMETHOD ManterCargo WSSEND oWSpCargo,oWSpOperacao WSRECEIVE oWSManterCargoResult WSCLIENT WSRMVitae
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ManterCargo xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("pCargo", ::oWSpCargo, oWSpCargo , "Cargo", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += WSSoapValue("pOperacao", ::oWSpOperacao, oWSpOperacao , "EOperacao", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ManterCargo>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IRMVitae/ManterCargo",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://srv-app:2828/RMVitae.svc")

::Init()
::oWSManterCargoResult:SoapRecv( WSAdvValue( oXmlRet,"_MANTERCARGORESPONSE:_MANTERCARGORESULT","Retorno",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ManterFuncao of Service WSRMVitae

WSMETHOD ManterFuncao WSSEND oWSpFuncao,oWSpOperacao WSRECEIVE oWSManterFuncaoResult WSCLIENT WSRMVitae
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ManterFuncao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("pFuncao", ::oWSpFuncao, oWSpFuncao , "Funcao", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += WSSoapValue("pOperacao", ::oWSpOperacao, oWSpOperacao , "EOperacao", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ManterFuncao>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IRMVitae/ManterFuncao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://srv-app:2828/RMVitae.svc")

::Init()
::oWSManterFuncaoResult:SoapRecv( WSAdvValue( oXmlRet,"_MANTERFUNCAORESPONSE:_MANTERFUNCAORESULT","Retorno",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ManterCentroCusto of Service WSRMVitae

WSMETHOD ManterCentroCusto WSSEND oWSpCentroCusto,oWSpOperacao WSRECEIVE oWSManterCentroCustoResult WSCLIENT WSRMVitae
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ManterCentroCusto xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("pCentroCusto", ::oWSpCentroCusto, oWSpCentroCusto , "CentroCusto", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += WSSoapValue("pOperacao", ::oWSpOperacao, oWSpOperacao , "EOperacao", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ManterCentroCusto>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IRMVitae/ManterCentroCusto",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://srv-app:2828/RMVitae.svc")

::Init()
::oWSManterCentroCustoResult:SoapRecv( WSAdvValue( oXmlRet,"_MANTERCENTROCUSTORESPONSE:_MANTERCENTROCUSTORESULT","Retorno",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ManterFuncionario of Service WSRMVitae

WSMETHOD ManterFuncionario WSSEND oWSpPessoa,oWSpFuncionario,oWSpDependente,oWSpOperacao WSRECEIVE oWSManterFuncionarioResult WSCLIENT WSRMVitae
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ManterFuncionario xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("pPessoa", ::oWSpPessoa, oWSpPessoa , "Pessoa", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += WSSoapValue("pFuncionario", ::oWSpFuncionario, oWSpFuncionario , "Funcionario", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += WSSoapValue("pDependente", ::oWSpDependente, oWSpDependente , "Dependente", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += WSSoapValue("pOperacao", ::oWSpOperacao, oWSpOperacao , "EOperacao", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ManterFuncionario>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IRMVitae/ManterFuncionario",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://srv-app:2828/RMVitae.svc")

::Init()
::oWSManterFuncionarioResult:SoapRecv( WSAdvValue( oXmlRet,"_MANTERFUNCIONARIORESPONSE:_MANTERFUNCIONARIORESULT","Retorno",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ManterDepartamento of Service WSRMVitae

WSMETHOD ManterDepartamento WSSEND oWSpDepartamento,oWSpOperacao WSRECEIVE oWSManterDepartamentoResult WSCLIENT WSRMVitae
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ManterDepartamento xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("pDepartamento", ::oWSpDepartamento, oWSpDepartamento , "Departamento", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += WSSoapValue("pOperacao", ::oWSpOperacao, oWSpOperacao , "EOperacao", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ManterDepartamento>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IRMVitae/ManterDepartamento",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://srv-app:2828/RMVitae.svc")

::Init()
::oWSManterDepartamentoResult:SoapRecv( WSAdvValue( oXmlRet,"_MANTERDEPARTAMENTORESPONSE:_MANTERDEPARTAMENTORESULT","Retorno",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ManterHistoricoAfastamento of Service WSRMVitae

WSMETHOD ManterHistoricoAfastamento WSSEND oWSpHistoricoAfastamento,oWSpOperacao WSRECEIVE oWSManterHistoricoAfastamentoResult WSCLIENT WSRMVitae
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ManterHistoricoAfastamento xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("pHistoricoAfastamento", ::oWSpHistoricoAfastamento, oWSpHistoricoAfastamento , "HistoricoAfastamento", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += WSSoapValue("pOperacao", ::oWSpOperacao, oWSpOperacao , "EOperacao", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ManterHistoricoAfastamento>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IRMVitae/ManterHistoricoAfastamento",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://srv-app:2828/RMVitae.svc")

::Init()
::oWSManterHistoricoAfastamentoResult:SoapRecv( WSAdvValue( oXmlRet,"_MANTERHISTORICOAFASTAMENTORESPONSE:_MANTERHISTORICOAFASTAMENTORESULT","Retorno",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ManterHistoricoEndereco of Service WSRMVitae

WSMETHOD ManterHistoricoEndereco WSSEND oWSpHistoricoEndereco,oWSpOperacao WSRECEIVE oWSManterHistoricoEnderecoResult WSCLIENT WSRMVitae
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ManterHistoricoEndereco xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("pHistoricoEndereco", ::oWSpHistoricoEndereco, oWSpHistoricoEndereco , "HistoricoEndereco", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += WSSoapValue("pOperacao", ::oWSpOperacao, oWSpOperacao , "EOperacao", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ManterHistoricoEndereco>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IRMVitae/ManterHistoricoEndereco",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://srv-app:2828/RMVitae.svc")

::Init()
::oWSManterHistoricoEnderecoResult:SoapRecv( WSAdvValue( oXmlRet,"_MANTERHISTORICOENDERECORESPONSE:_MANTERHISTORICOENDERECORESULT","Retorno",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ManterHistoricoFuncao of Service WSRMVitae

WSMETHOD ManterHistoricoFuncao WSSEND oWSpHistoricoFuncao,oWSpOperacao WSRECEIVE oWSManterHistoricoFuncaoResult WSCLIENT WSRMVitae
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ManterHistoricoFuncao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("pHistoricoFuncao", ::oWSpHistoricoFuncao, oWSpHistoricoFuncao , "HistoricoFuncao", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += WSSoapValue("pOperacao", ::oWSpOperacao, oWSpOperacao , "EOperacao", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ManterHistoricoFuncao>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IRMVitae/ManterHistoricoFuncao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://srv-app:2828/RMVitae.svc")

::Init()
::oWSManterHistoricoFuncaoResult:SoapRecv( WSAdvValue( oXmlRet,"_MANTERHISTORICOFUNCAORESPONSE:_MANTERHISTORICOFUNCAORESULT","Retorno",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ManterHistoricoSalario of Service WSRMVitae

WSMETHOD ManterHistoricoSalario WSSEND oWSpHistoricoSalario,oWSpOperacao WSRECEIVE oWSManterHistoricoSalarioResult WSCLIENT WSRMVitae
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ManterHistoricoSalario xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("pHistoricoSalario", ::oWSpHistoricoSalario, oWSpHistoricoSalario , "HistoricoSalario", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += WSSoapValue("pOperacao", ::oWSpOperacao, oWSpOperacao , "EOperacao", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ManterHistoricoSalario>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IRMVitae/ManterHistoricoSalario",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://srv-app:2828/RMVitae.svc")

::Init()
::oWSManterHistoricoSalarioResult:SoapRecv( WSAdvValue( oXmlRet,"_MANTERHISTORICOSALARIORESPONSE:_MANTERHISTORICOSALARIORESULT","Retorno",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ManterHistoricoSecao of Service WSRMVitae

WSMETHOD ManterHistoricoSecao WSSEND oWSpHistoricoSecao,oWSpOperacao WSRECEIVE oWSManterHistoricoSecaoResult WSCLIENT WSRMVitae
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ManterHistoricoSecao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("pHistoricoSecao", ::oWSpHistoricoSecao, oWSpHistoricoSecao , "HistoricoSecao", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += WSSoapValue("pOperacao", ::oWSpOperacao, oWSpOperacao , "EOperacao", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ManterHistoricoSecao>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IRMVitae/ManterHistoricoSecao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://srv-app:2828/RMVitae.svc")

::Init()
::oWSManterHistoricoSecaoResult:SoapRecv( WSAdvValue( oXmlRet,"_MANTERHISTORICOSECAORESPONSE:_MANTERHISTORICOSECAORESULT","Retorno",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ManterHistoricoSituacao of Service WSRMVitae

WSMETHOD ManterHistoricoSituacao WSSEND oWSpHistoricoSituacao,oWSpOperacao WSRECEIVE oWSManterHistoricoSituacaoResult WSCLIENT WSRMVitae
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ManterHistoricoSituacao xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("pHistoricoSituacao", ::oWSpHistoricoSituacao, oWSpHistoricoSituacao , "HistoricoSituacao", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += WSSoapValue("pOperacao", ::oWSpOperacao, oWSpOperacao , "EOperacao", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ManterHistoricoSituacao>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IRMVitae/ManterHistoricoSituacao",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://srv-app:2828/RMVitae.svc")

::Init()
::oWSManterHistoricoSituacaoResult:SoapRecv( WSAdvValue( oXmlRet,"_MANTERHISTORICOSITUACAORESPONSE:_MANTERHISTORICOSITUACAORESULT","Retorno",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ManterEPI of Service WSRMVitae

WSMETHOD ManterEPI WSSEND oWSpEPI,oWSpOperacao WSRECEIVE oWSManterEPIResult WSCLIENT WSRMVitae
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ManterEPI xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("pEPI", ::oWSpEPI, oWSpEPI , "EPI", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += WSSoapValue("pOperacao", ::oWSpOperacao, oWSpOperacao , "EOperacao", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ManterEPI>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IRMVitae/ManterEPI",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://srv-app:2828/RMVitae.svc")

::Init()
::oWSManterEPIResult:SoapRecv( WSAdvValue( oXmlRet,"_MANTEREPIRESPONSE:_MANTEREPIRESULT","Retorno",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ManterCatalogoEPI of Service WSRMVitae

WSMETHOD ManterCatalogoEPI WSSEND oWSpCatalogoEPI,oWSpOperacao WSRECEIVE oWSManterCatalogoEPIResult WSCLIENT WSRMVitae
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ManterCatalogoEPI xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("pCatalogoEPI", ::oWSpCatalogoEPI, oWSpCatalogoEPI , "CatalogoEPI", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += WSSoapValue("pOperacao", ::oWSpOperacao, oWSpOperacao , "EOperacao", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ManterCatalogoEPI>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IRMVitae/ManterCatalogoEPI",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://srv-app:2828/RMVitae.svc")

::Init()
::oWSManterCatalogoEPIResult:SoapRecv( WSAdvValue( oXmlRet,"_MANTERCATALOGOEPIRESPONSE:_MANTERCATALOGOEPIRESULT","Retorno",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ManterLoteEPI of Service WSRMVitae

WSMETHOD ManterLoteEPI WSSEND oWSpLoteEPI,oWSpOperacao WSRECEIVE oWSManterLoteEPIResult WSCLIENT WSRMVitae
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ManterLoteEPI xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("pLoteEPI", ::oWSpLoteEPI, oWSpLoteEPI , "LoteEPI", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += WSSoapValue("pOperacao", ::oWSpOperacao, oWSpOperacao , "EOperacao", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</ManterLoteEPI>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IRMVitae/ManterLoteEPI",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://srv-app:2828/RMVitae.svc")

::Init()
::oWSManterLoteEPIResult:SoapRecv( WSAdvValue( oXmlRet,"_MANTERLOTEEPIRESPONSE:_MANTERLOTEEPIRESULT","Retorno",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method TransferirEPI of Service WSRMVitae

WSMETHOD TransferirEPI WSSEND oWSpCatalogoEPI,oWSpLoteEPI,oWSpEPI WSRECEIVE oWSTransferirEPIResult WSCLIENT WSRMVitae
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<TransferirEPI xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("pCatalogoEPI", ::oWSpCatalogoEPI, oWSpCatalogoEPI , "CatalogoEPI", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += WSSoapValue("pLoteEPI", ::oWSpLoteEPI, oWSpLoteEPI , "LoteEPI", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += WSSoapValue("pEPI", ::oWSpEPI, oWSpEPI , "EPI", .F. , .F., 0 , "http://tempuri.org/", .F.,.F.) 
cSoap += "</TransferirEPI>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IRMVitae/TransferirEPI",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://srv-app:2828/RMVitae.svc")

::Init()
::oWSTransferirEPIResult:SoapRecv( WSAdvValue( oXmlRet,"_TRANSFERIREPIRESPONSE:_TRANSFERIREPIRESULT","Retorno",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method TestarServico of Service WSRMVitae

WSMETHOD TestarServico WSSEND NULLPARAM WSRECEIVE lTestarServicoResult WSCLIENT WSRMVitae
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<TestarServico xmlns="http://tempuri.org/">'
cSoap += "</TestarServico>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/IRMVitae/TestarServico",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://srv-app:2828/RMVitae.svc")

::Init()
::lTestarServicoResult :=  WSAdvValue( oXmlRet,"_TESTARSERVICORESPONSE:_TESTARSERVICORESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure Secao

WSSTRUCT RMVitae_Secao
	WSDATA   cATIVECONOMICA            AS string OPTIONAL
	WSDATA   cBAIRRO                   AS string OPTIONAL
	WSDATA   nCAPITALSOCEMP            AS decimal OPTIONAL
	WSDATA   nCAPITALSOCESTAB          AS decimal OPTIONAL
	WSDATA   cCATEGORIA                AS string OPTIONAL
	WSDATA   cCEI                      AS string OPTIONAL
	WSDATA   cCEP                      AS string OPTIONAL
	WSDATA   cCGC                      AS string OPTIONAL
	WSDATA   cCIDADE                   AS string OPTIONAL
	WSDATA   cCNAERAIS                 AS string OPTIONAL
	WSDATA   cCNO                      AS string OPTIONAL
	WSDATA   nCODCOLIGADA              AS short OPTIONAL
	WSDATA   cCODDEPTO                 AS string OPTIONAL
	WSDATA   nCODFILIAL                AS short OPTIONAL
	WSDATA   cCODIGO                   AS string OPTIONAL
	WSDATA   cCODIGOCEF                AS string OPTIONAL
	WSDATA   cCODIGOPAI                AS string OPTIONAL
	WSDATA   cCODMUNICIPIO             AS string OPTIONAL
	WSDATA   nCODTIPORUA               AS short OPTIONAL
	WSDATA   cCOMPLEMENTO              AS string OPTIONAL
	WSDATA   cCONTATO                  AS string OPTIONAL
	WSDATA   cDESCRICAO                AS string OPTIONAL
	WSDATA   cDESCRICAOPPP             AS string OPTIONAL
	WSDATA   cEMAIL                    AS string OPTIONAL
	WSDATA   cESTADO                   AS string OPTIONAL
	WSDATA   cFPAS                     AS string OPTIONAL
	WSDATA   nIDENTIFICACAOCGC         AS short OPTIONAL
	WSDATA   cINSCRESTADUAL            AS string OPTIONAL
	WSDATA   cINSCRMUNICIPAL           AS string OPTIONAL
	WSDATA   cLOCALIDADE               AS string OPTIONAL
	WSDATA   cNATUREZAJURIDICA         AS string OPTIONAL
	WSDATA   cNROCENCUSTOCONT          AS string OPTIONAL
	WSDATA   nNROFILIALCONT            AS short OPTIONAL
	WSDATA   cNUMERO                   AS string OPTIONAL
	WSDATA   cPAIS                     AS string OPTIONAL
	WSDATA   nPESSOAFISICA             AS short OPTIONAL
	WSDATA   cPREFIXORAIS              AS string OPTIONAL
	WSDATA   cRAMAL                    AS string OPTIONAL
	WSDATA   cRECCREATEDBY             AS string OPTIONAL
	WSDATA   cRECCREATEDON             AS dateTime OPTIONAL
	WSDATA   cRECMODIFIEDBY            AS string OPTIONAL
	WSDATA   cRECMODIFIEDON            AS dateTime OPTIONAL
	WSDATA   cRUA                      AS string OPTIONAL
	WSDATA   cSAT                      AS string OPTIONAL
	WSDATA   nSECAODESATIVADA          AS short OPTIONAL
	WSDATA   cTELEFONE                 AS string OPTIONAL
	WSDATA   cTPLOTACAO                AS string OPTIONAL
	WSDATA   cVTCODDEPTO               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT RMVitae_Secao
	::Init()
Return Self

WSMETHOD INIT WSCLIENT RMVitae_Secao
Return

WSMETHOD CLONE WSCLIENT RMVitae_Secao
	Local oClone := RMVitae_Secao():NEW()
	oClone:cATIVECONOMICA       := ::cATIVECONOMICA
	oClone:cBAIRRO              := ::cBAIRRO
	oClone:nCAPITALSOCEMP       := ::nCAPITALSOCEMP
	oClone:nCAPITALSOCESTAB     := ::nCAPITALSOCESTAB
	oClone:cCATEGORIA           := ::cCATEGORIA
	oClone:cCEI                 := ::cCEI
	oClone:cCEP                 := ::cCEP
	oClone:cCGC                 := ::cCGC
	oClone:cCIDADE              := ::cCIDADE
	oClone:cCNAERAIS            := ::cCNAERAIS
	oClone:cCNO                 := ::cCNO
	oClone:nCODCOLIGADA         := ::nCODCOLIGADA
	oClone:cCODDEPTO            := ::cCODDEPTO
	oClone:nCODFILIAL           := ::nCODFILIAL
	oClone:cCODIGO              := ::cCODIGO
	oClone:cCODIGOCEF           := ::cCODIGOCEF
	oClone:cCODIGOPAI           := ::cCODIGOPAI
	oClone:cCODMUNICIPIO        := ::cCODMUNICIPIO
	oClone:nCODTIPORUA          := ::nCODTIPORUA
	oClone:cCOMPLEMENTO         := ::cCOMPLEMENTO
	oClone:cCONTATO             := ::cCONTATO
	oClone:cDESCRICAO           := ::cDESCRICAO
	oClone:cDESCRICAOPPP        := ::cDESCRICAOPPP
	oClone:cEMAIL               := ::cEMAIL
	oClone:cESTADO              := ::cESTADO
	oClone:cFPAS                := ::cFPAS
	oClone:nIDENTIFICACAOCGC    := ::nIDENTIFICACAOCGC
	oClone:cINSCRESTADUAL       := ::cINSCRESTADUAL
	oClone:cINSCRMUNICIPAL      := ::cINSCRMUNICIPAL
	oClone:cLOCALIDADE          := ::cLOCALIDADE
	oClone:cNATUREZAJURIDICA    := ::cNATUREZAJURIDICA
	oClone:cNROCENCUSTOCONT     := ::cNROCENCUSTOCONT
	oClone:nNROFILIALCONT       := ::nNROFILIALCONT
	oClone:cNUMERO              := ::cNUMERO
	oClone:cPAIS                := ::cPAIS
	oClone:nPESSOAFISICA        := ::nPESSOAFISICA
	oClone:cPREFIXORAIS         := ::cPREFIXORAIS
	oClone:cRAMAL               := ::cRAMAL
	oClone:cRECCREATEDBY        := ::cRECCREATEDBY
	oClone:cRECCREATEDON        := ::cRECCREATEDON
	oClone:cRECMODIFIEDBY       := ::cRECMODIFIEDBY
	oClone:cRECMODIFIEDON       := ::cRECMODIFIEDON
	oClone:cRUA                 := ::cRUA
	oClone:cSAT                 := ::cSAT
	oClone:nSECAODESATIVADA     := ::nSECAODESATIVADA
	oClone:cTELEFONE            := ::cTELEFONE
	oClone:cTPLOTACAO           := ::cTPLOTACAO
	oClone:cVTCODDEPTO          := ::cVTCODDEPTO
Return oClone

WSMETHOD SOAPSEND WSCLIENT RMVitae_Secao
	Local cSoap := ""
	cSoap += WSSoapValue("ATIVECONOMICA", ::cATIVECONOMICA, ::cATIVECONOMICA , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("BAIRRO", ::cBAIRRO, ::cBAIRRO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CAPITALSOCEMP", ::nCAPITALSOCEMP, ::nCAPITALSOCEMP , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CAPITALSOCESTAB", ::nCAPITALSOCESTAB, ::nCAPITALSOCESTAB , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CATEGORIA", ::cCATEGORIA, ::cCATEGORIA , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CEI", ::cCEI, ::cCEI , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CEP", ::cCEP, ::cCEP , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CGC", ::cCGC, ::cCGC , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CIDADE", ::cCIDADE, ::cCIDADE , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CNAERAIS", ::cCNAERAIS, ::cCNAERAIS , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CNO", ::cCNO, ::cCNO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODCOLIGADA", ::nCODCOLIGADA, ::nCODCOLIGADA , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODDEPTO", ::cCODDEPTO, ::cCODDEPTO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODFILIAL", ::nCODFILIAL, ::nCODFILIAL , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODIGO", ::cCODIGO, ::cCODIGO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODIGOCEF", ::cCODIGOCEF, ::cCODIGOCEF , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODIGOPAI", ::cCODIGOPAI, ::cCODIGOPAI , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODMUNICIPIO", ::cCODMUNICIPIO, ::cCODMUNICIPIO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODTIPORUA", ::nCODTIPORUA, ::nCODTIPORUA , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("COMPLEMENTO", ::cCOMPLEMENTO, ::cCOMPLEMENTO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CONTATO", ::cCONTATO, ::cCONTATO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DESCRICAO", ::cDESCRICAO, ::cDESCRICAO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DESCRICAOPPP", ::cDESCRICAOPPP, ::cDESCRICAOPPP , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("EMAIL", ::cEMAIL, ::cEMAIL , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("ESTADO", ::cESTADO, ::cESTADO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("FPAS", ::cFPAS, ::cFPAS , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("IDENTIFICACAOCGC", ::nIDENTIFICACAOCGC, ::nIDENTIFICACAOCGC , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("INSCRESTADUAL", ::cINSCRESTADUAL, ::cINSCRESTADUAL , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("INSCRMUNICIPAL", ::cINSCRMUNICIPAL, ::cINSCRMUNICIPAL , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("LOCALIDADE", ::cLOCALIDADE, ::cLOCALIDADE , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("NATUREZAJURIDICA", ::cNATUREZAJURIDICA, ::cNATUREZAJURIDICA , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("NROCENCUSTOCONT", ::cNROCENCUSTOCONT, ::cNROCENCUSTOCONT , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("NROFILIALCONT", ::nNROFILIALCONT, ::nNROFILIALCONT , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("NUMERO", ::cNUMERO, ::cNUMERO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("PAIS", ::cPAIS, ::cPAIS , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("PESSOAFISICA", ::nPESSOAFISICA, ::nPESSOAFISICA , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("PREFIXORAIS", ::cPREFIXORAIS, ::cPREFIXORAIS , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RAMAL", ::cRAMAL, ::cRAMAL , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDBY", ::cRECCREATEDBY, ::cRECCREATEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDON", ::cRECCREATEDON, ::cRECCREATEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDBY", ::cRECMODIFIEDBY, ::cRECMODIFIEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDON", ::cRECMODIFIEDON, ::cRECMODIFIEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RUA", ::cRUA, ::cRUA , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("SAT", ::cSAT, ::cSAT , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("SECAODESATIVADA", ::nSECAODESATIVADA, ::nSECAODESATIVADA , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("TELEFONE", ::cTELEFONE, ::cTELEFONE , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("TPLOTACAO", ::cTPLOTACAO, ::cTPLOTACAO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("VTCODDEPTO", ::cVTCODDEPTO, ::cVTCODDEPTO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
Return cSoap

// WSDL Data Enumeration EOperacao

WSSTRUCT RMVitae_EOperacao
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT RMVitae_EOperacao
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Inserir" )
	aadd(::aValueList , "Editar" )
	aadd(::aValueList , "Excluir" )
Return Self

WSMETHOD SOAPSEND WSCLIENT RMVitae_EOperacao
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT RMVitae_EOperacao
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT RMVitae_EOperacao
Local oClone := RMVitae_EOperacao():New()
	oClone:Value := ::Value
Return oClone

// WSDL Data Structure Retorno

WSSTRUCT RMVitae_Retorno
	WSDATA   cMensagem                 AS string OPTIONAL
	WSDATA   lSucesso                  AS boolean OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT RMVitae_Retorno
	::Init()
Return Self

WSMETHOD INIT WSCLIENT RMVitae_Retorno
Return

WSMETHOD CLONE WSCLIENT RMVitae_Retorno
	Local oClone := RMVitae_Retorno():NEW()
	oClone:cMensagem            := ::cMensagem
	oClone:lSucesso             := ::lSucesso
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT RMVitae_Retorno
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cMensagem          :=  WSAdvValue( oResponse,"_MENSAGEM","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::lSucesso           :=  WSAdvValue( oResponse,"_SUCESSO","boolean",NIL,NIL,NIL,"L",NIL,NIL) 
Return

// WSDL Data Structure Cargo

WSSTRUCT RMVitae_Cargo
	WSDATA   nCODCOLIGADA              AS short OPTIONAL
	WSDATA   cCODIGO                   AS string OPTIONAL
	WSDATA   cDESCRICAO                AS string OPTIONAL
	WSDATA   nINATIVO                  AS short OPTIONAL
	WSDATA   nJORNADATRABALHO          AS int OPTIONAL
	WSDATA   cNOME                     AS string OPTIONAL
	WSDATA   cRECCREATEDBY             AS string OPTIONAL
	WSDATA   cRECCREATEDON             AS dateTime OPTIONAL
	WSDATA   cRECMODIFIEDBY            AS string OPTIONAL
	WSDATA   cRECMODIFIEDON            AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT RMVitae_Cargo
	::Init()
Return Self

WSMETHOD INIT WSCLIENT RMVitae_Cargo
Return

WSMETHOD CLONE WSCLIENT RMVitae_Cargo
	Local oClone := RMVitae_Cargo():NEW()
	oClone:nCODCOLIGADA         := ::nCODCOLIGADA
	oClone:cCODIGO              := ::cCODIGO
	oClone:cDESCRICAO           := ::cDESCRICAO
	oClone:nINATIVO             := ::nINATIVO
	oClone:nJORNADATRABALHO     := ::nJORNADATRABALHO
	oClone:cNOME                := ::cNOME
	oClone:cRECCREATEDBY        := ::cRECCREATEDBY
	oClone:cRECCREATEDON        := ::cRECCREATEDON
	oClone:cRECMODIFIEDBY       := ::cRECMODIFIEDBY
	oClone:cRECMODIFIEDON       := ::cRECMODIFIEDON
Return oClone

WSMETHOD SOAPSEND WSCLIENT RMVitae_Cargo
	Local cSoap := ""
	cSoap += WSSoapValue("CODCOLIGADA", ::nCODCOLIGADA, ::nCODCOLIGADA , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODIGO", ::cCODIGO, ::cCODIGO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DESCRICAO", ::cDESCRICAO, ::cDESCRICAO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("INATIVO", ::nINATIVO, ::nINATIVO , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("JORNADATRABALHO", ::nJORNADATRABALHO, ::nJORNADATRABALHO , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("NOME", ::cNOME, ::cNOME , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDBY", ::cRECCREATEDBY, ::cRECCREATEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDON", ::cRECCREATEDON, ::cRECCREATEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDBY", ::cRECMODIFIEDBY, ::cRECMODIFIEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDON", ::cRECMODIFIEDON, ::cRECMODIFIEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
Return cSoap

// WSDL Data Structure Funcao

WSSTRUCT RMVitae_Funcao
	WSDATA   nATIVTRANSP               AS short OPTIONAL
	WSDATA   nBENEFPONTOS              AS int OPTIONAL
	WSDATA   cCARGO                    AS string OPTIONAL
	WSDATA   cCBO                      AS string OPTIONAL
	WSDATA   cCBO2002                  AS string OPTIONAL
	WSDATA   nCODCOLIGADA              AS short OPTIONAL
	WSDATA   cCODFUNCAOCHEFIA          AS string OPTIONAL
	WSDATA   cCODIGO                   AS string OPTIONAL
	WSDATA   cCODPERFILCAND            AS string OPTIONAL
	WSDATA   cCODTABELA                AS string OPTIONAL
	WSDATA   cDATAULTIMAREVISAO        AS dateTime OPTIONAL
	WSDATA   cDESCRICAO                AS string OPTIONAL
	WSDATA   cDESCRICAOPPP             AS string OPTIONAL
	WSDATA   cEXIBEORGANOGRAMA         AS string OPTIONAL
	WSDATA   cFAIXASALARIAL            AS string OPTIONAL
	WSDATA   nINATIVA                  AS short OPTIONAL
	WSDATA   nJORNADAREF               AS decimal OPTIONAL
	WSDATA   nLIMITEFUNC               AS int OPTIONAL
	WSDATA   cNOME                     AS string OPTIONAL
	WSDATA   nNUMPONTOS                AS decimal OPTIONAL
	WSDATA   cNUMREVISAO               AS string OPTIONAL
	WSDATA   cOBJETIVO                 AS string OPTIONAL
	WSDATA   nPERCQUADROVAGAS          AS decimal OPTIONAL
	WSDATA   cRECCREATEDBY             AS string OPTIONAL
	WSDATA   cRECCREATEDON             AS dateTime OPTIONAL
	WSDATA   cRECMODIFIEDBY            AS string OPTIONAL
	WSDATA   cRECMODIFIEDON            AS dateTime OPTIONAL
	WSDATA   nVERBAQUADROVAGAS         AS decimal OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT RMVitae_Funcao
	::Init()
Return Self

WSMETHOD INIT WSCLIENT RMVitae_Funcao
Return

WSMETHOD CLONE WSCLIENT RMVitae_Funcao
	Local oClone := RMVitae_Funcao():NEW()
	oClone:nATIVTRANSP          := ::nATIVTRANSP
	oClone:nBENEFPONTOS         := ::nBENEFPONTOS
	oClone:cCARGO               := ::cCARGO
	oClone:cCBO                 := ::cCBO
	oClone:cCBO2002             := ::cCBO2002
	oClone:nCODCOLIGADA         := ::nCODCOLIGADA
	oClone:cCODFUNCAOCHEFIA     := ::cCODFUNCAOCHEFIA
	oClone:cCODIGO              := ::cCODIGO
	oClone:cCODPERFILCAND       := ::cCODPERFILCAND
	oClone:cCODTABELA           := ::cCODTABELA
	oClone:cDATAULTIMAREVISAO   := ::cDATAULTIMAREVISAO
	oClone:cDESCRICAO           := ::cDESCRICAO
	oClone:cDESCRICAOPPP        := ::cDESCRICAOPPP
	oClone:cEXIBEORGANOGRAMA    := ::cEXIBEORGANOGRAMA
	oClone:cFAIXASALARIAL       := ::cFAIXASALARIAL
	oClone:nINATIVA             := ::nINATIVA
	oClone:nJORNADAREF          := ::nJORNADAREF
	oClone:nLIMITEFUNC          := ::nLIMITEFUNC
	oClone:cNOME                := ::cNOME
	oClone:nNUMPONTOS           := ::nNUMPONTOS
	oClone:cNUMREVISAO          := ::cNUMREVISAO
	oClone:cOBJETIVO            := ::cOBJETIVO
	oClone:nPERCQUADROVAGAS     := ::nPERCQUADROVAGAS
	oClone:cRECCREATEDBY        := ::cRECCREATEDBY
	oClone:cRECCREATEDON        := ::cRECCREATEDON
	oClone:cRECMODIFIEDBY       := ::cRECMODIFIEDBY
	oClone:cRECMODIFIEDON       := ::cRECMODIFIEDON
	oClone:nVERBAQUADROVAGAS    := ::nVERBAQUADROVAGAS
Return oClone

WSMETHOD SOAPSEND WSCLIENT RMVitae_Funcao
	Local cSoap := ""
	cSoap += WSSoapValue("ATIVTRANSP", ::nATIVTRANSP, ::nATIVTRANSP , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("BENEFPONTOS", ::nBENEFPONTOS, ::nBENEFPONTOS , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CARGO", ::cCARGO, ::cCARGO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CBO", ::cCBO, ::cCBO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CBO2002", ::cCBO2002, ::cCBO2002 , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODCOLIGADA", ::nCODCOLIGADA, ::nCODCOLIGADA , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODFUNCAOCHEFIA", ::cCODFUNCAOCHEFIA, ::cCODFUNCAOCHEFIA , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODIGO", ::cCODIGO, ::cCODIGO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODPERFILCAND", ::cCODPERFILCAND, ::cCODPERFILCAND , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODTABELA", ::cCODTABELA, ::cCODTABELA , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DATAULTIMAREVISAO", ::cDATAULTIMAREVISAO, ::cDATAULTIMAREVISAO , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DESCRICAO", ::cDESCRICAO, ::cDESCRICAO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DESCRICAOPPP", ::cDESCRICAOPPP, ::cDESCRICAOPPP , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("EXIBEORGANOGRAMA", ::cEXIBEORGANOGRAMA, ::cEXIBEORGANOGRAMA , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("FAIXASALARIAL", ::cFAIXASALARIAL, ::cFAIXASALARIAL , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("INATIVA", ::nINATIVA, ::nINATIVA , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("JORNADAREF", ::nJORNADAREF, ::nJORNADAREF , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("LIMITEFUNC", ::nLIMITEFUNC, ::nLIMITEFUNC , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("NOME", ::cNOME, ::cNOME , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("NUMPONTOS", ::nNUMPONTOS, ::nNUMPONTOS , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("NUMREVISAO", ::cNUMREVISAO, ::cNUMREVISAO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("OBJETIVO", ::cOBJETIVO, ::cOBJETIVO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("PERCQUADROVAGAS", ::nPERCQUADROVAGAS, ::nPERCQUADROVAGAS , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDBY", ::cRECCREATEDBY, ::cRECCREATEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDON", ::cRECCREATEDON, ::cRECCREATEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDBY", ::cRECMODIFIEDBY, ::cRECMODIFIEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDON", ::cRECMODIFIEDON, ::cRECMODIFIEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("VERBAQUADROVAGAS", ::nVERBAQUADROVAGAS, ::nVERBAQUADROVAGAS , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
Return cSoap

// WSDL Data Structure CentroCusto

WSSTRUCT RMVitae_CentroCusto
	WSDATA   cATIVO                    AS string OPTIONAL
	WSDATA   cCAMPOLIVRE               AS string OPTIONAL
	WSDATA   cCODCCUSTO                AS string OPTIONAL
	WSDATA   cCODCLASSIFICA            AS string OPTIONAL
	WSDATA   nCODCOLCONTA              AS short OPTIONAL
	WSDATA   nCODCOLCONTAGER           AS short OPTIONAL
	WSDATA   nCODCOLIGADA              AS short OPTIONAL
	WSDATA   cCODCONTA                 AS string OPTIONAL
	WSDATA   cCODCONTAGER              AS string OPTIONAL
	WSDATA   cCODREDUZIDO              AS string OPTIONAL
	WSDATA   cDATAINCLUSAO             AS dateTime OPTIONAL
	WSDATA   cENVIASPED                AS string OPTIONAL
	WSDATA   cNOME                     AS string OPTIONAL
	WSDATA   cPERMITELANC              AS string OPTIONAL
	WSDATA   cRECCREATEDBY             AS string OPTIONAL
	WSDATA   cRECCREATEDON             AS dateTime OPTIONAL
	WSDATA   cRECMODIFIEDBY            AS string OPTIONAL
	WSDATA   cRECMODIFIEDON            AS dateTime OPTIONAL
	WSDATA   nRESPONSAVEL              AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT RMVitae_CentroCusto
	::Init()
Return Self

WSMETHOD INIT WSCLIENT RMVitae_CentroCusto
Return

WSMETHOD CLONE WSCLIENT RMVitae_CentroCusto
	Local oClone := RMVitae_CentroCusto():NEW()
	oClone:cATIVO               := ::cATIVO
	oClone:cCAMPOLIVRE          := ::cCAMPOLIVRE
	oClone:cCODCCUSTO           := ::cCODCCUSTO
	oClone:cCODCLASSIFICA       := ::cCODCLASSIFICA
	oClone:nCODCOLCONTA         := ::nCODCOLCONTA
	oClone:nCODCOLCONTAGER      := ::nCODCOLCONTAGER
	oClone:nCODCOLIGADA         := ::nCODCOLIGADA
	oClone:cCODCONTA            := ::cCODCONTA
	oClone:cCODCONTAGER         := ::cCODCONTAGER
	oClone:cCODREDUZIDO         := ::cCODREDUZIDO
	oClone:cDATAINCLUSAO        := ::cDATAINCLUSAO
	oClone:cENVIASPED           := ::cENVIASPED
	oClone:cNOME                := ::cNOME
	oClone:cPERMITELANC         := ::cPERMITELANC
	oClone:cRECCREATEDBY        := ::cRECCREATEDBY
	oClone:cRECCREATEDON        := ::cRECCREATEDON
	oClone:cRECMODIFIEDBY       := ::cRECMODIFIEDBY
	oClone:cRECMODIFIEDON       := ::cRECMODIFIEDON
	oClone:nRESPONSAVEL         := ::nRESPONSAVEL
Return oClone

WSMETHOD SOAPSEND WSCLIENT RMVitae_CentroCusto
	Local cSoap := ""
	cSoap += WSSoapValue("ATIVO", ::cATIVO, ::cATIVO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CAMPOLIVRE", ::cCAMPOLIVRE, ::cCAMPOLIVRE , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODCCUSTO", ::cCODCCUSTO, ::cCODCCUSTO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODCLASSIFICA", ::cCODCLASSIFICA, ::cCODCLASSIFICA , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODCOLCONTA", ::nCODCOLCONTA, ::nCODCOLCONTA , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODCOLCONTAGER", ::nCODCOLCONTAGER, ::nCODCOLCONTAGER , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODCOLIGADA", ::nCODCOLIGADA, ::nCODCOLIGADA , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODCONTA", ::cCODCONTA, ::cCODCONTA , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODCONTAGER", ::cCODCONTAGER, ::cCODCONTAGER , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODREDUZIDO", ::cCODREDUZIDO, ::cCODREDUZIDO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DATAINCLUSAO", ::cDATAINCLUSAO, ::cDATAINCLUSAO , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("ENVIASPED", ::cENVIASPED, ::cENVIASPED , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("NOME", ::cNOME, ::cNOME , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("PERMITELANC", ::cPERMITELANC, ::cPERMITELANC , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDBY", ::cRECCREATEDBY, ::cRECCREATEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDON", ::cRECCREATEDON, ::cRECCREATEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDBY", ::cRECMODIFIEDBY, ::cRECMODIFIEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDON", ::cRECMODIFIEDON, ::cRECMODIFIEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RESPONSAVEL", ::nRESPONSAVEL, ::nRESPONSAVEL , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
Return cSoap

// WSDL Data Structure Pessoa

WSSTRUCT RMVitae_Pessoa
	WSDATA   cBAIRRO                   AS string OPTIONAL
	WSDATA   cCARTEIRATRAB             AS string OPTIONAL
	WSDATA   cCARTIDENTIDADE           AS string OPTIONAL
	WSDATA   cCEP                      AS string OPTIONAL
	WSDATA   cCIDADE                   AS string OPTIONAL
	WSDATA   nCODIGO                   AS int OPTIONAL
	WSDATA   cCODNATURALIDADE          AS string OPTIONAL
	WSDATA   cCOMPLEMENTO              AS string OPTIONAL
	WSDATA   cCPF                      AS string OPTIONAL
	WSDATA   cDTNASCIMENTO             AS dateTime OPTIONAL
	WSDATA   cESTADO                   AS string OPTIONAL
	WSDATA   cESTADOCIVIL              AS string OPTIONAL
	WSDATA   cGRAUINSTRUCAO            AS string OPTIONAL
	WSDATA   cNACIONALIDADE            AS string OPTIONAL
	WSDATA   nNIT                      AS short OPTIONAL
	WSDATA   cNOME                     AS string OPTIONAL
	WSDATA   cNUMERO                   AS string OPTIONAL
	WSDATA   cORGEMISSORIDENT          AS string OPTIONAL
	WSDATA   cRECCREATEDBY             AS string OPTIONAL
	WSDATA   cRECCREATEDON             AS dateTime OPTIONAL
	WSDATA   cRECMODIFIEDBY            AS string OPTIONAL
	WSDATA   cRECMODIFIEDON            AS dateTime OPTIONAL
	WSDATA   cRUA                      AS string OPTIONAL
	WSDATA   cSERIECARTTRAB            AS string OPTIONAL
	WSDATA   cSEXO                     AS string OPTIONAL
	WSDATA   cTELEFONE1                AS string OPTIONAL
	WSDATA   cTELEFONE2                AS string OPTIONAL
	WSDATA   cUFCARTTRAB               AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT RMVitae_Pessoa
	::Init()
Return Self

WSMETHOD INIT WSCLIENT RMVitae_Pessoa
Return

WSMETHOD CLONE WSCLIENT RMVitae_Pessoa
	Local oClone := RMVitae_Pessoa():NEW()
	oClone:cBAIRRO              := ::cBAIRRO
	oClone:cCARTEIRATRAB        := ::cCARTEIRATRAB
	oClone:cCARTIDENTIDADE      := ::cCARTIDENTIDADE
	oClone:cCEP                 := ::cCEP
	oClone:cCIDADE              := ::cCIDADE
	oClone:nCODIGO              := ::nCODIGO
	oClone:cCODNATURALIDADE     := ::cCODNATURALIDADE
	oClone:cCOMPLEMENTO         := ::cCOMPLEMENTO
	oClone:cCPF                 := ::cCPF
	oClone:cDTNASCIMENTO        := ::cDTNASCIMENTO
	oClone:cESTADO              := ::cESTADO
	oClone:cESTADOCIVIL         := ::cESTADOCIVIL
	oClone:cGRAUINSTRUCAO       := ::cGRAUINSTRUCAO
	oClone:cNACIONALIDADE       := ::cNACIONALIDADE
	oClone:nNIT                 := ::nNIT
	oClone:cNOME                := ::cNOME
	oClone:cNUMERO              := ::cNUMERO
	oClone:cORGEMISSORIDENT     := ::cORGEMISSORIDENT
	oClone:cRECCREATEDBY        := ::cRECCREATEDBY
	oClone:cRECCREATEDON        := ::cRECCREATEDON
	oClone:cRECMODIFIEDBY       := ::cRECMODIFIEDBY
	oClone:cRECMODIFIEDON       := ::cRECMODIFIEDON
	oClone:cRUA                 := ::cRUA
	oClone:cSERIECARTTRAB       := ::cSERIECARTTRAB
	oClone:cSEXO                := ::cSEXO
	oClone:cTELEFONE1           := ::cTELEFONE1
	oClone:cTELEFONE2           := ::cTELEFONE2
	oClone:cUFCARTTRAB          := ::cUFCARTTRAB
Return oClone

WSMETHOD SOAPSEND WSCLIENT RMVitae_Pessoa
	Local cSoap := ""
	cSoap += WSSoapValue("BAIRRO", ::cBAIRRO, ::cBAIRRO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CARTEIRATRAB", ::cCARTEIRATRAB, ::cCARTEIRATRAB , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CARTIDENTIDADE", ::cCARTIDENTIDADE, ::cCARTIDENTIDADE , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CEP", ::cCEP, ::cCEP , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CIDADE", ::cCIDADE, ::cCIDADE , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODIGO", ::nCODIGO, ::nCODIGO , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODNATURALIDADE", ::cCODNATURALIDADE, ::cCODNATURALIDADE , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("COMPLEMENTO", ::cCOMPLEMENTO, ::cCOMPLEMENTO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CPF", ::cCPF, ::cCPF , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DTNASCIMENTO", ::cDTNASCIMENTO, ::cDTNASCIMENTO , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("ESTADO", ::cESTADO, ::cESTADO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("ESTADOCIVIL", ::cESTADOCIVIL, ::cESTADOCIVIL , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("GRAUINSTRUCAO", ::cGRAUINSTRUCAO, ::cGRAUINSTRUCAO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("NACIONALIDADE", ::cNACIONALIDADE, ::cNACIONALIDADE , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("NIT", ::nNIT, ::nNIT , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("NOME", ::cNOME, ::cNOME , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("NUMERO", ::cNUMERO, ::cNUMERO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("ORGEMISSORIDENT", ::cORGEMISSORIDENT, ::cORGEMISSORIDENT , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDBY", ::cRECCREATEDBY, ::cRECCREATEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDON", ::cRECCREATEDON, ::cRECCREATEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDBY", ::cRECMODIFIEDBY, ::cRECMODIFIEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDON", ::cRECMODIFIEDON, ::cRECMODIFIEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RUA", ::cRUA, ::cRUA , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("SERIECARTTRAB", ::cSERIECARTTRAB, ::cSERIECARTTRAB , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("SEXO", ::cSEXO, ::cSEXO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("TELEFONE1", ::cTELEFONE1, ::cTELEFONE1 , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("TELEFONE2", ::cTELEFONE2, ::cTELEFONE2 , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("UFCARTTRAB", ::cUFCARTTRAB, ::cUFCARTTRAB , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
Return cSoap

// WSDL Data Structure Funcionario

WSSTRUCT RMVitae_Funcionario
	WSDATA   cCHAPA                    AS string OPTIONAL
	WSDATA   nCODCOLIGADA              AS short OPTIONAL
	WSDATA   nCODFILIAL                AS short OPTIONAL
	WSDATA   cCODFUNCAO                AS string OPTIONAL
	WSDATA   cCODHORARIO               AS string OPTIONAL
	WSDATA   nCODOCORRENCIA            AS short OPTIONAL
	WSDATA   nCODPESSOA                AS int OPTIONAL
	WSDATA   cCODRECEBIMENTO           AS string OPTIONAL
	WSDATA   cCODSECAO                 AS string OPTIONAL
	WSDATA   cCODSINDICATO             AS string OPTIONAL
	WSDATA   cCODSITUACAO              AS string OPTIONAL
	WSDATA   cCODTIPO                  AS string OPTIONAL
	WSDATA   cCONTRIBSINDICAL          AS string OPTIONAL
	WSDATA   cDATAADMISSAO             AS dateTime OPTIONAL
	WSDATA   cDATADEMISSAO             AS dateTime OPTIONAL
	WSDATA   cDTDESLIGAMENTO           AS dateTime OPTIONAL
	WSDATA   cDTOPCAOFGTS              AS dateTime OPTIONAL
	WSDATA   cDTPAGTORESCISAO          AS dateTime OPTIONAL
	WSDATA   cDTULTIMOMOVIM            AS dateTime OPTIONAL
	WSDATA   nINDINICIOHOR             AS short OPTIONAL
	WSDATA   nJORNADAMENSAL            AS short OPTIONAL
	WSDATA   cMOTIVOADMISSAO           AS string OPTIONAL
	WSDATA   cMOTIVODEMISSAO           AS string OPTIONAL
	WSDATA   cNOME                     AS string OPTIONAL
	WSDATA   nNROFICHAREG              AS int OPTIONAL
	WSDATA   cPISPASEP                 AS string OPTIONAL
	WSDATA   cRECCREATEDBY             AS string OPTIONAL
	WSDATA   cRECCREATEDON             AS dateTime OPTIONAL
	WSDATA   cRECMODIFIEDBY            AS string OPTIONAL
	WSDATA   cRECMODIFIEDON            AS dateTime OPTIONAL
	WSDATA   nSALARIO                  AS decimal OPTIONAL
	WSDATA   cSITUACAOFGTS             AS string OPTIONAL
	WSDATA   cSITUACAORAIS             AS string OPTIONAL
	WSDATA   cTIPOADMISSAO             AS string OPTIONAL
	WSDATA   cTIPODEMISSAO             AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT RMVitae_Funcionario
	::Init()
Return Self

WSMETHOD INIT WSCLIENT RMVitae_Funcionario
Return

WSMETHOD CLONE WSCLIENT RMVitae_Funcionario
	Local oClone := RMVitae_Funcionario():NEW()
	oClone:cCHAPA               := ::cCHAPA
	oClone:nCODCOLIGADA         := ::nCODCOLIGADA
	oClone:nCODFILIAL           := ::nCODFILIAL
	oClone:cCODFUNCAO           := ::cCODFUNCAO
	oClone:cCODHORARIO          := ::cCODHORARIO
	oClone:nCODOCORRENCIA       := ::nCODOCORRENCIA
	oClone:nCODPESSOA           := ::nCODPESSOA
	oClone:cCODRECEBIMENTO      := ::cCODRECEBIMENTO
	oClone:cCODSECAO            := ::cCODSECAO
	oClone:cCODSINDICATO        := ::cCODSINDICATO
	oClone:cCODSITUACAO         := ::cCODSITUACAO
	oClone:cCODTIPO             := ::cCODTIPO
	oClone:cCONTRIBSINDICAL     := ::cCONTRIBSINDICAL
	oClone:cDATAADMISSAO        := ::cDATAADMISSAO
	oClone:cDATADEMISSAO        := ::cDATADEMISSAO
	oClone:cDTDESLIGAMENTO      := ::cDTDESLIGAMENTO
	oClone:cDTOPCAOFGTS         := ::cDTOPCAOFGTS
	oClone:cDTPAGTORESCISAO     := ::cDTPAGTORESCISAO
	oClone:cDTULTIMOMOVIM       := ::cDTULTIMOMOVIM
	oClone:nINDINICIOHOR        := ::nINDINICIOHOR
	oClone:nJORNADAMENSAL       := ::nJORNADAMENSAL
	oClone:cMOTIVOADMISSAO      := ::cMOTIVOADMISSAO
	oClone:cMOTIVODEMISSAO      := ::cMOTIVODEMISSAO
	oClone:cNOME                := ::cNOME
	oClone:nNROFICHAREG         := ::nNROFICHAREG
	oClone:cPISPASEP            := ::cPISPASEP
	oClone:cRECCREATEDBY        := ::cRECCREATEDBY
	oClone:cRECCREATEDON        := ::cRECCREATEDON
	oClone:cRECMODIFIEDBY       := ::cRECMODIFIEDBY
	oClone:cRECMODIFIEDON       := ::cRECMODIFIEDON
	oClone:nSALARIO             := ::nSALARIO
	oClone:cSITUACAOFGTS        := ::cSITUACAOFGTS
	oClone:cSITUACAORAIS        := ::cSITUACAORAIS
	oClone:cTIPOADMISSAO        := ::cTIPOADMISSAO
	oClone:cTIPODEMISSAO        := ::cTIPODEMISSAO
Return oClone

WSMETHOD SOAPSEND WSCLIENT RMVitae_Funcionario
	Local cSoap := ""
	cSoap += WSSoapValue("CHAPA", ::cCHAPA, ::cCHAPA , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODCOLIGADA", ::nCODCOLIGADA, ::nCODCOLIGADA , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODFILIAL", ::nCODFILIAL, ::nCODFILIAL , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODFUNCAO", ::cCODFUNCAO, ::cCODFUNCAO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODHORARIO", ::cCODHORARIO, ::cCODHORARIO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODOCORRENCIA", ::nCODOCORRENCIA, ::nCODOCORRENCIA , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODPESSOA", ::nCODPESSOA, ::nCODPESSOA , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODRECEBIMENTO", ::cCODRECEBIMENTO, ::cCODRECEBIMENTO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODSECAO", ::cCODSECAO, ::cCODSECAO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODSINDICATO", ::cCODSINDICATO, ::cCODSINDICATO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODSITUACAO", ::cCODSITUACAO, ::cCODSITUACAO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODTIPO", ::cCODTIPO, ::cCODTIPO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CONTRIBSINDICAL", ::cCONTRIBSINDICAL, ::cCONTRIBSINDICAL , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DATAADMISSAO", ::cDATAADMISSAO, ::cDATAADMISSAO , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DATADEMISSAO", ::cDATADEMISSAO, ::cDATADEMISSAO , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DTDESLIGAMENTO", ::cDTDESLIGAMENTO, ::cDTDESLIGAMENTO , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DTOPCAOFGTS", ::cDTOPCAOFGTS, ::cDTOPCAOFGTS , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DTPAGTORESCISAO", ::cDTPAGTORESCISAO, ::cDTPAGTORESCISAO , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DTULTIMOMOVIM", ::cDTULTIMOMOVIM, ::cDTULTIMOMOVIM , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("INDINICIOHOR", ::nINDINICIOHOR, ::nINDINICIOHOR , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("JORNADAMENSAL", ::nJORNADAMENSAL, ::nJORNADAMENSAL , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("MOTIVOADMISSAO", ::cMOTIVOADMISSAO, ::cMOTIVOADMISSAO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("MOTIVODEMISSAO", ::cMOTIVODEMISSAO, ::cMOTIVODEMISSAO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("NOME", ::cNOME, ::cNOME , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("NROFICHAREG", ::nNROFICHAREG, ::nNROFICHAREG , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("PISPASEP", ::cPISPASEP, ::cPISPASEP , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDBY", ::cRECCREATEDBY, ::cRECCREATEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDON", ::cRECCREATEDON, ::cRECCREATEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDBY", ::cRECMODIFIEDBY, ::cRECMODIFIEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDON", ::cRECMODIFIEDON, ::cRECMODIFIEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("SALARIO", ::nSALARIO, ::nSALARIO , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("SITUACAOFGTS", ::cSITUACAOFGTS, ::cSITUACAOFGTS , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("SITUACAORAIS", ::cSITUACAORAIS, ::cSITUACAORAIS , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("TIPOADMISSAO", ::cTIPOADMISSAO, ::cTIPOADMISSAO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("TIPODEMISSAO", ::cTIPODEMISSAO, ::cTIPODEMISSAO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
Return cSoap

// WSDL Data Structure Dependente

WSSTRUCT RMVitae_Dependente
	WSDATA   cCHAPA                    AS string OPTIONAL
	WSDATA   nCODCOLIGADA              AS short OPTIONAL
	WSDATA   cESTADOCIVIL              AS string OPTIONAL
	WSDATA   cGRAUPARENTESCO           AS string OPTIONAL
	WSDATA   cNOME                     AS string OPTIONAL
	WSDATA   nNRODEPEND                AS short OPTIONAL
	WSDATA   cRECCREATEDBY             AS string OPTIONAL
	WSDATA   cRECCREATEDON             AS dateTime OPTIONAL
	WSDATA   cRECMODIFIEDBY            AS string OPTIONAL
	WSDATA   cRECMODIFIEDON            AS dateTime OPTIONAL
	WSDATA   cSEXO                     AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT RMVitae_Dependente
	::Init()
Return Self

WSMETHOD INIT WSCLIENT RMVitae_Dependente
Return

WSMETHOD CLONE WSCLIENT RMVitae_Dependente
	Local oClone := RMVitae_Dependente():NEW()
	oClone:cCHAPA               := ::cCHAPA
	oClone:nCODCOLIGADA         := ::nCODCOLIGADA
	oClone:cESTADOCIVIL         := ::cESTADOCIVIL
	oClone:cGRAUPARENTESCO      := ::cGRAUPARENTESCO
	oClone:cNOME                := ::cNOME
	oClone:nNRODEPEND           := ::nNRODEPEND
	oClone:cRECCREATEDBY        := ::cRECCREATEDBY
	oClone:cRECCREATEDON        := ::cRECCREATEDON
	oClone:cRECMODIFIEDBY       := ::cRECMODIFIEDBY
	oClone:cRECMODIFIEDON       := ::cRECMODIFIEDON
	oClone:cSEXO                := ::cSEXO
Return oClone

WSMETHOD SOAPSEND WSCLIENT RMVitae_Dependente
	Local cSoap := ""
	cSoap += WSSoapValue("CHAPA", ::cCHAPA, ::cCHAPA , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODCOLIGADA", ::nCODCOLIGADA, ::nCODCOLIGADA , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("ESTADOCIVIL", ::cESTADOCIVIL, ::cESTADOCIVIL , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("GRAUPARENTESCO", ::cGRAUPARENTESCO, ::cGRAUPARENTESCO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("NOME", ::cNOME, ::cNOME , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("NRODEPEND", ::nNRODEPEND, ::nNRODEPEND , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDBY", ::cRECCREATEDBY, ::cRECCREATEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDON", ::cRECCREATEDON, ::cRECCREATEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDBY", ::cRECMODIFIEDBY, ::cRECMODIFIEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDON", ::cRECMODIFIEDON, ::cRECMODIFIEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("SEXO", ::cSEXO, ::cSEXO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
Return cSoap

// WSDL Data Structure Departamento

WSSTRUCT RMVitae_Departamento
	WSDATA   cATIVO                    AS string OPTIONAL
	WSDATA   nCODCOLCONTAGER           AS short OPTIONAL
	WSDATA   nCODCOLIGADA              AS short OPTIONAL
	WSDATA   cCODCONTAGER              AS string OPTIONAL
	WSDATA   cCODDEPARTAMENTO          AS string OPTIONAL
	WSDATA   nCODFILIAL                AS short OPTIONAL
	WSDATA   cCONTATO                  AS string OPTIONAL
	WSDATA   cEMAIL                    AS string OPTIONAL
	WSDATA   cFAX                      AS string OPTIONAL
	WSDATA   cLOCALIZACAO              AS string OPTIONAL
	WSDATA   cNOME                     AS string OPTIONAL
	WSDATA   cRAMAL                    AS string OPTIONAL
	WSDATA   cRECCREATEDBY             AS string OPTIONAL
	WSDATA   cRECCREATEDON             AS dateTime OPTIONAL
	WSDATA   cRECMODIFIEDBY            AS string OPTIONAL
	WSDATA   cRECMODIFIEDON            AS dateTime OPTIONAL
	WSDATA   cTELEFONE                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT RMVitae_Departamento
	::Init()
Return Self

WSMETHOD INIT WSCLIENT RMVitae_Departamento
Return

WSMETHOD CLONE WSCLIENT RMVitae_Departamento
	Local oClone := RMVitae_Departamento():NEW()
	oClone:cATIVO               := ::cATIVO
	oClone:nCODCOLCONTAGER      := ::nCODCOLCONTAGER
	oClone:nCODCOLIGADA         := ::nCODCOLIGADA
	oClone:cCODCONTAGER         := ::cCODCONTAGER
	oClone:cCODDEPARTAMENTO     := ::cCODDEPARTAMENTO
	oClone:nCODFILIAL           := ::nCODFILIAL
	oClone:cCONTATO             := ::cCONTATO
	oClone:cEMAIL               := ::cEMAIL
	oClone:cFAX                 := ::cFAX
	oClone:cLOCALIZACAO         := ::cLOCALIZACAO
	oClone:cNOME                := ::cNOME
	oClone:cRAMAL               := ::cRAMAL
	oClone:cRECCREATEDBY        := ::cRECCREATEDBY
	oClone:cRECCREATEDON        := ::cRECCREATEDON
	oClone:cRECMODIFIEDBY       := ::cRECMODIFIEDBY
	oClone:cRECMODIFIEDON       := ::cRECMODIFIEDON
	oClone:cTELEFONE            := ::cTELEFONE
Return oClone

WSMETHOD SOAPSEND WSCLIENT RMVitae_Departamento
	Local cSoap := ""
	cSoap += WSSoapValue("ATIVO", ::cATIVO, ::cATIVO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODCOLCONTAGER", ::nCODCOLCONTAGER, ::nCODCOLCONTAGER , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODCOLIGADA", ::nCODCOLIGADA, ::nCODCOLIGADA , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODCONTAGER", ::cCODCONTAGER, ::cCODCONTAGER , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODDEPARTAMENTO", ::cCODDEPARTAMENTO, ::cCODDEPARTAMENTO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODFILIAL", ::nCODFILIAL, ::nCODFILIAL , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CONTATO", ::cCONTATO, ::cCONTATO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("EMAIL", ::cEMAIL, ::cEMAIL , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("FAX", ::cFAX, ::cFAX , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("LOCALIZACAO", ::cLOCALIZACAO, ::cLOCALIZACAO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("NOME", ::cNOME, ::cNOME , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RAMAL", ::cRAMAL, ::cRAMAL , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDBY", ::cRECCREATEDBY, ::cRECCREATEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDON", ::cRECCREATEDON, ::cRECCREATEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDBY", ::cRECMODIFIEDBY, ::cRECMODIFIEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDON", ::cRECMODIFIEDON, ::cRECMODIFIEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("TELEFONE", ::cTELEFONE, ::cTELEFONE , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
Return cSoap

// WSDL Data Structure HistoricoAfastamento

WSSTRUCT RMVitae_HistoricoAfastamento
	WSDATA   nACIDENTETRANSITO         AS short OPTIONAL
	WSDATA   cCHAPA                    AS string OPTIONAL
	WSDATA   cCODCID                   AS string OPTIONAL
	WSDATA   nCODCOLIGADA              AS short OPTIONAL
	WSDATA   nCODESTABILIDADE          AS int OPTIONAL
	WSDATA   nDOENCANOTIFCOMPULSORIA   AS short OPTIONAL
	WSDATA   cDTFINAL                  AS dateTime OPTIONAL
	WSDATA   cDTINICIO                 AS dateTime OPTIONAL
	WSDATA   nESTTEMPOSERVICO          AS short OPTIONAL
	WSDATA   cMOTIVO                   AS string OPTIONAL
	WSDATA   cOBSERVACAO               AS string OPTIONAL
	WSDATA   cRECCREATEDBY             AS string OPTIONAL
	WSDATA   cRECCREATEDON             AS dateTime OPTIONAL
	WSDATA   cRECMODIFIEDBY            AS string OPTIONAL
	WSDATA   cRECMODIFIEDON            AS dateTime OPTIONAL
	WSDATA   cTIPO                     AS string OPTIONAL
	WSDATA   nTPTOMADOR                AS short OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT RMVitae_HistoricoAfastamento
	::Init()
Return Self

WSMETHOD INIT WSCLIENT RMVitae_HistoricoAfastamento
Return

WSMETHOD CLONE WSCLIENT RMVitae_HistoricoAfastamento
	Local oClone := RMVitae_HistoricoAfastamento():NEW()
	oClone:nACIDENTETRANSITO    := ::nACIDENTETRANSITO
	oClone:cCHAPA               := ::cCHAPA
	oClone:cCODCID              := ::cCODCID
	oClone:nCODCOLIGADA         := ::nCODCOLIGADA
	oClone:nCODESTABILIDADE     := ::nCODESTABILIDADE
	oClone:nDOENCANOTIFCOMPULSORIA := ::nDOENCANOTIFCOMPULSORIA
	oClone:cDTFINAL             := ::cDTFINAL
	oClone:cDTINICIO            := ::cDTINICIO
	oClone:nESTTEMPOSERVICO     := ::nESTTEMPOSERVICO
	oClone:cMOTIVO              := ::cMOTIVO
	oClone:cOBSERVACAO          := ::cOBSERVACAO
	oClone:cRECCREATEDBY        := ::cRECCREATEDBY
	oClone:cRECCREATEDON        := ::cRECCREATEDON
	oClone:cRECMODIFIEDBY       := ::cRECMODIFIEDBY
	oClone:cRECMODIFIEDON       := ::cRECMODIFIEDON
	oClone:cTIPO                := ::cTIPO
	oClone:nTPTOMADOR           := ::nTPTOMADOR
Return oClone

WSMETHOD SOAPSEND WSCLIENT RMVitae_HistoricoAfastamento
	Local cSoap := ""
	cSoap += WSSoapValue("ACIDENTETRANSITO", ::nACIDENTETRANSITO, ::nACIDENTETRANSITO , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CHAPA", ::cCHAPA, ::cCHAPA , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODCID", ::cCODCID, ::cCODCID , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODCOLIGADA", ::nCODCOLIGADA, ::nCODCOLIGADA , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODESTABILIDADE", ::nCODESTABILIDADE, ::nCODESTABILIDADE , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DOENCANOTIFCOMPULSORIA", ::nDOENCANOTIFCOMPULSORIA, ::nDOENCANOTIFCOMPULSORIA , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DTFINAL", ::cDTFINAL, ::cDTFINAL , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DTINICIO", ::cDTINICIO, ::cDTINICIO , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("ESTTEMPOSERVICO", ::nESTTEMPOSERVICO, ::nESTTEMPOSERVICO , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("MOTIVO", ::cMOTIVO, ::cMOTIVO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("OBSERVACAO", ::cOBSERVACAO, ::cOBSERVACAO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDBY", ::cRECCREATEDBY, ::cRECCREATEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDON", ::cRECCREATEDON, ::cRECCREATEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDBY", ::cRECMODIFIEDBY, ::cRECMODIFIEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDON", ::cRECMODIFIEDON, ::cRECMODIFIEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("TIPO", ::cTIPO, ::cTIPO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("TPTOMADOR", ::nTPTOMADOR, ::nTPTOMADOR , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
Return cSoap

// WSDL Data Structure HistoricoEndereco

WSSTRUCT RMVitae_HistoricoEndereco
	WSDATA   cBAIRRO                   AS string OPTIONAL
	WSDATA   cCEP                      AS string OPTIONAL
	WSDATA   cCIDADE                   AS string OPTIONAL
	WSDATA   nCODPESSOA                AS int OPTIONAL
	WSDATA   nCODTIPORUA               AS short OPTIONAL
	WSDATA   cCOMPLEMENTO              AS string OPTIONAL
	WSDATA   cDTMUDANCA                AS dateTime OPTIONAL
	WSDATA   cESTADO                   AS string OPTIONAL
	WSDATA   cFAX                      AS string OPTIONAL
	WSDATA   cNUMERO                   AS string OPTIONAL
	WSDATA   cPAIS                     AS string OPTIONAL
	WSDATA   cRECCREATEDBY             AS string OPTIONAL
	WSDATA   cRECCREATEDON             AS dateTime OPTIONAL
	WSDATA   cRECMODIFIEDBY            AS string OPTIONAL
	WSDATA   cRECMODIFIEDON            AS dateTime OPTIONAL
	WSDATA   cRUA                      AS string OPTIONAL
	WSDATA   cTELEFONE                 AS string OPTIONAL
	WSDATA   cTELEFONE2                AS string OPTIONAL
	WSDATA   cTELEFONE3                AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT RMVitae_HistoricoEndereco
	::Init()
Return Self

WSMETHOD INIT WSCLIENT RMVitae_HistoricoEndereco
Return

WSMETHOD CLONE WSCLIENT RMVitae_HistoricoEndereco
	Local oClone := RMVitae_HistoricoEndereco():NEW()
	oClone:cBAIRRO              := ::cBAIRRO
	oClone:cCEP                 := ::cCEP
	oClone:cCIDADE              := ::cCIDADE
	oClone:nCODPESSOA           := ::nCODPESSOA
	oClone:nCODTIPORUA          := ::nCODTIPORUA
	oClone:cCOMPLEMENTO         := ::cCOMPLEMENTO
	oClone:cDTMUDANCA           := ::cDTMUDANCA
	oClone:cESTADO              := ::cESTADO
	oClone:cFAX                 := ::cFAX
	oClone:cNUMERO              := ::cNUMERO
	oClone:cPAIS                := ::cPAIS
	oClone:cRECCREATEDBY        := ::cRECCREATEDBY
	oClone:cRECCREATEDON        := ::cRECCREATEDON
	oClone:cRECMODIFIEDBY       := ::cRECMODIFIEDBY
	oClone:cRECMODIFIEDON       := ::cRECMODIFIEDON
	oClone:cRUA                 := ::cRUA
	oClone:cTELEFONE            := ::cTELEFONE
	oClone:cTELEFONE2           := ::cTELEFONE2
	oClone:cTELEFONE3           := ::cTELEFONE3
Return oClone

WSMETHOD SOAPSEND WSCLIENT RMVitae_HistoricoEndereco
	Local cSoap := ""
	cSoap += WSSoapValue("BAIRRO", ::cBAIRRO, ::cBAIRRO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CEP", ::cCEP, ::cCEP , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CIDADE", ::cCIDADE, ::cCIDADE , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODPESSOA", ::nCODPESSOA, ::nCODPESSOA , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODTIPORUA", ::nCODTIPORUA, ::nCODTIPORUA , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("COMPLEMENTO", ::cCOMPLEMENTO, ::cCOMPLEMENTO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DTMUDANCA", ::cDTMUDANCA, ::cDTMUDANCA , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("ESTADO", ::cESTADO, ::cESTADO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("FAX", ::cFAX, ::cFAX , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("NUMERO", ::cNUMERO, ::cNUMERO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("PAIS", ::cPAIS, ::cPAIS , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDBY", ::cRECCREATEDBY, ::cRECCREATEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDON", ::cRECCREATEDON, ::cRECCREATEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDBY", ::cRECMODIFIEDBY, ::cRECMODIFIEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDON", ::cRECMODIFIEDON, ::cRECMODIFIEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RUA", ::cRUA, ::cRUA , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("TELEFONE", ::cTELEFONE, ::cTELEFONE , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("TELEFONE2", ::cTELEFONE2, ::cTELEFONE2 , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("TELEFONE3", ::cTELEFONE3, ::cTELEFONE3 , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
Return cSoap

// WSDL Data Structure HistoricoFuncao

WSSTRUCT RMVitae_HistoricoFuncao
	WSDATA   cCHAPA                    AS string OPTIONAL
	WSDATA   nCODCOLIGADA              AS short OPTIONAL
	WSDATA   cCODFAIXA                 AS string OPTIONAL
	WSDATA   cCODFUNCAO                AS string OPTIONAL
	WSDATA   cCODNIVEL                 AS string OPTIONAL
	WSDATA   cDTMUDANCA                AS dateTime OPTIONAL
	WSDATA   cMOTIVO                   AS string OPTIONAL
	WSDATA   cRECCREATEDBY             AS string OPTIONAL
	WSDATA   cRECCREATEDON             AS dateTime OPTIONAL
	WSDATA   cRECMODIFIEDBY            AS string OPTIONAL
	WSDATA   cRECMODIFIEDON            AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT RMVitae_HistoricoFuncao
	::Init()
Return Self

WSMETHOD INIT WSCLIENT RMVitae_HistoricoFuncao
Return

WSMETHOD CLONE WSCLIENT RMVitae_HistoricoFuncao
	Local oClone := RMVitae_HistoricoFuncao():NEW()
	oClone:cCHAPA               := ::cCHAPA
	oClone:nCODCOLIGADA         := ::nCODCOLIGADA
	oClone:cCODFAIXA            := ::cCODFAIXA
	oClone:cCODFUNCAO           := ::cCODFUNCAO
	oClone:cCODNIVEL            := ::cCODNIVEL
	oClone:cDTMUDANCA           := ::cDTMUDANCA
	oClone:cMOTIVO              := ::cMOTIVO
	oClone:cRECCREATEDBY        := ::cRECCREATEDBY
	oClone:cRECCREATEDON        := ::cRECCREATEDON
	oClone:cRECMODIFIEDBY       := ::cRECMODIFIEDBY
	oClone:cRECMODIFIEDON       := ::cRECMODIFIEDON
Return oClone

WSMETHOD SOAPSEND WSCLIENT RMVitae_HistoricoFuncao
	Local cSoap := ""
	cSoap += WSSoapValue("CHAPA", ::cCHAPA, ::cCHAPA , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODCOLIGADA", ::nCODCOLIGADA, ::nCODCOLIGADA , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODFAIXA", ::cCODFAIXA, ::cCODFAIXA , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODFUNCAO", ::cCODFUNCAO, ::cCODFUNCAO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODNIVEL", ::cCODNIVEL, ::cCODNIVEL , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DTMUDANCA", ::cDTMUDANCA, ::cDTMUDANCA , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("MOTIVO", ::cMOTIVO, ::cMOTIVO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDBY", ::cRECCREATEDBY, ::cRECCREATEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDON", ::cRECCREATEDON, ::cRECCREATEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDBY", ::cRECMODIFIEDBY, ::cRECMODIFIEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDON", ::cRECMODIFIEDON, ::cRECMODIFIEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
Return cSoap

// WSDL Data Structure HistoricoSalario

WSSTRUCT RMVitae_HistoricoSalario
	WSDATA   nALTERACAOJORNADA         AS short OPTIONAL
	WSDATA   cCHAPA                    AS string OPTIONAL
	WSDATA   nCODCOLIGADA              AS short OPTIONAL
	WSDATA   cCODEVENTO                AS string OPTIONAL
	WSDATA   cDATADEINCLUSAO           AS dateTime OPTIONAL
	WSDATA   cDATADEREFERENCIA         AS dateTime OPTIONAL
	WSDATA   cDTMUDANCA                AS dateTime OPTIONAL
	WSDATA   cHISTORICODEFAIXA         AS string OPTIONAL
	WSDATA   cHISTORICODENIVEL         AS string OPTIONAL
	WSDATA   cHISTORICOTABELASALARIAL  AS string OPTIONAL
	WSDATA   nJORNADA                  AS short OPTIONAL
	WSDATA   cMOTIVO                   AS string OPTIONAL
	WSDATA   nNROSALARIO               AS short OPTIONAL
	WSDATA   nPERCENTAPLICADO          AS decimal OPTIONAL
	WSDATA   cRECCREATEDBY             AS string OPTIONAL
	WSDATA   cRECCREATEDON             AS dateTime OPTIONAL
	WSDATA   cRECMODIFIEDBY            AS string OPTIONAL
	WSDATA   cRECMODIFIEDON            AS dateTime OPTIONAL
	WSDATA   nSALARIO                  AS decimal OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT RMVitae_HistoricoSalario
	::Init()
Return Self

WSMETHOD INIT WSCLIENT RMVitae_HistoricoSalario
Return

WSMETHOD CLONE WSCLIENT RMVitae_HistoricoSalario
	Local oClone := RMVitae_HistoricoSalario():NEW()
	oClone:nALTERACAOJORNADA    := ::nALTERACAOJORNADA
	oClone:cCHAPA               := ::cCHAPA
	oClone:nCODCOLIGADA         := ::nCODCOLIGADA
	oClone:cCODEVENTO           := ::cCODEVENTO
	oClone:cDATADEINCLUSAO      := ::cDATADEINCLUSAO
	oClone:cDATADEREFERENCIA    := ::cDATADEREFERENCIA
	oClone:cDTMUDANCA           := ::cDTMUDANCA
	oClone:cHISTORICODEFAIXA    := ::cHISTORICODEFAIXA
	oClone:cHISTORICODENIVEL    := ::cHISTORICODENIVEL
	oClone:cHISTORICOTABELASALARIAL := ::cHISTORICOTABELASALARIAL
	oClone:nJORNADA             := ::nJORNADA
	oClone:cMOTIVO              := ::cMOTIVO
	oClone:nNROSALARIO          := ::nNROSALARIO
	oClone:nPERCENTAPLICADO     := ::nPERCENTAPLICADO
	oClone:cRECCREATEDBY        := ::cRECCREATEDBY
	oClone:cRECCREATEDON        := ::cRECCREATEDON
	oClone:cRECMODIFIEDBY       := ::cRECMODIFIEDBY
	oClone:cRECMODIFIEDON       := ::cRECMODIFIEDON
	oClone:nSALARIO             := ::nSALARIO
Return oClone

WSMETHOD SOAPSEND WSCLIENT RMVitae_HistoricoSalario
	Local cSoap := ""
	cSoap += WSSoapValue("ALTERACAOJORNADA", ::nALTERACAOJORNADA, ::nALTERACAOJORNADA , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CHAPA", ::cCHAPA, ::cCHAPA , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODCOLIGADA", ::nCODCOLIGADA, ::nCODCOLIGADA , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODEVENTO", ::cCODEVENTO, ::cCODEVENTO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DATADEINCLUSAO", ::cDATADEINCLUSAO, ::cDATADEINCLUSAO , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DATADEREFERENCIA", ::cDATADEREFERENCIA, ::cDATADEREFERENCIA , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DTMUDANCA", ::cDTMUDANCA, ::cDTMUDANCA , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("HISTORICODEFAIXA", ::cHISTORICODEFAIXA, ::cHISTORICODEFAIXA , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("HISTORICODENIVEL", ::cHISTORICODENIVEL, ::cHISTORICODENIVEL , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("HISTORICOTABELASALARIAL", ::cHISTORICOTABELASALARIAL, ::cHISTORICOTABELASALARIAL , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("JORNADA", ::nJORNADA, ::nJORNADA , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("MOTIVO", ::cMOTIVO, ::cMOTIVO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("NROSALARIO", ::nNROSALARIO, ::nNROSALARIO , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("PERCENTAPLICADO", ::nPERCENTAPLICADO, ::nPERCENTAPLICADO , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDBY", ::cRECCREATEDBY, ::cRECCREATEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDON", ::cRECCREATEDON, ::cRECCREATEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDBY", ::cRECMODIFIEDBY, ::cRECMODIFIEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDON", ::cRECMODIFIEDON, ::cRECMODIFIEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("SALARIO", ::nSALARIO, ::nSALARIO , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
Return cSoap

// WSDL Data Structure HistoricoSecao

WSSTRUCT RMVitae_HistoricoSecao
	WSDATA   cCHAPA                    AS string OPTIONAL
	WSDATA   nCODCOLIGADA              AS short OPTIONAL
	WSDATA   cCODSECAO                 AS string OPTIONAL
	WSDATA   cDTMUDANCA                AS dateTime OPTIONAL
	WSDATA   cMOTIVO                   AS string OPTIONAL
	WSDATA   cRECCREATEDBY             AS string OPTIONAL
	WSDATA   cRECCREATEDON             AS dateTime OPTIONAL
	WSDATA   cRECMODIFIEDBY            AS string OPTIONAL
	WSDATA   cRECMODIFIEDON            AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT RMVitae_HistoricoSecao
	::Init()
Return Self

WSMETHOD INIT WSCLIENT RMVitae_HistoricoSecao
Return

WSMETHOD CLONE WSCLIENT RMVitae_HistoricoSecao
	Local oClone := RMVitae_HistoricoSecao():NEW()
	oClone:cCHAPA               := ::cCHAPA
	oClone:nCODCOLIGADA         := ::nCODCOLIGADA
	oClone:cCODSECAO            := ::cCODSECAO
	oClone:cDTMUDANCA           := ::cDTMUDANCA
	oClone:cMOTIVO              := ::cMOTIVO
	oClone:cRECCREATEDBY        := ::cRECCREATEDBY
	oClone:cRECCREATEDON        := ::cRECCREATEDON
	oClone:cRECMODIFIEDBY       := ::cRECMODIFIEDBY
	oClone:cRECMODIFIEDON       := ::cRECMODIFIEDON
Return oClone

WSMETHOD SOAPSEND WSCLIENT RMVitae_HistoricoSecao
	Local cSoap := ""
	cSoap += WSSoapValue("CHAPA", ::cCHAPA, ::cCHAPA , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODCOLIGADA", ::nCODCOLIGADA, ::nCODCOLIGADA , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODSECAO", ::cCODSECAO, ::cCODSECAO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DTMUDANCA", ::cDTMUDANCA, ::cDTMUDANCA , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("MOTIVO", ::cMOTIVO, ::cMOTIVO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDBY", ::cRECCREATEDBY, ::cRECCREATEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDON", ::cRECCREATEDON, ::cRECCREATEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDBY", ::cRECMODIFIEDBY, ::cRECMODIFIEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDON", ::cRECMODIFIEDON, ::cRECMODIFIEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
Return cSoap

// WSDL Data Structure HistoricoSituacao

WSSTRUCT RMVitae_HistoricoSituacao
	WSDATA   cCHAPA                    AS string OPTIONAL
	WSDATA   nCODCOLIGADA              AS short OPTIONAL
	WSDATA   cDATAMUDANCA              AS dateTime OPTIONAL
	WSDATA   cMOTIVO                   AS string OPTIONAL
	WSDATA   cNOVASITUACAO             AS string OPTIONAL
	WSDATA   cRECCREATEDBY             AS string OPTIONAL
	WSDATA   cRECCREATEDON             AS dateTime OPTIONAL
	WSDATA   cRECMODIFIEDBY            AS string OPTIONAL
	WSDATA   cRECMODIFIEDON            AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT RMVitae_HistoricoSituacao
	::Init()
Return Self

WSMETHOD INIT WSCLIENT RMVitae_HistoricoSituacao
Return

WSMETHOD CLONE WSCLIENT RMVitae_HistoricoSituacao
	Local oClone := RMVitae_HistoricoSituacao():NEW()
	oClone:cCHAPA               := ::cCHAPA
	oClone:nCODCOLIGADA         := ::nCODCOLIGADA
	oClone:cDATAMUDANCA         := ::cDATAMUDANCA
	oClone:cMOTIVO              := ::cMOTIVO
	oClone:cNOVASITUACAO        := ::cNOVASITUACAO
	oClone:cRECCREATEDBY        := ::cRECCREATEDBY
	oClone:cRECCREATEDON        := ::cRECCREATEDON
	oClone:cRECMODIFIEDBY       := ::cRECMODIFIEDBY
	oClone:cRECMODIFIEDON       := ::cRECMODIFIEDON
Return oClone

WSMETHOD SOAPSEND WSCLIENT RMVitae_HistoricoSituacao
	Local cSoap := ""
	cSoap += WSSoapValue("CHAPA", ::cCHAPA, ::cCHAPA , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODCOLIGADA", ::nCODCOLIGADA, ::nCODCOLIGADA , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DATAMUDANCA", ::cDATAMUDANCA, ::cDATAMUDANCA , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("MOTIVO", ::cMOTIVO, ::cMOTIVO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("NOVASITUACAO", ::cNOVASITUACAO, ::cNOVASITUACAO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDBY", ::cRECCREATEDBY, ::cRECCREATEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDON", ::cRECCREATEDON, ::cRECCREATEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDBY", ::cRECMODIFIEDBY, ::cRECMODIFIEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDON", ::cRECMODIFIEDON, ::cRECMODIFIEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
Return cSoap

// WSDL Data Structure EPI

WSSTRUCT RMVitae_EPI
	WSDATA   cAQUISICAO                AS dateTime OPTIONAL
	WSDATA   cCA                       AS string OPTIONAL
	WSDATA   nCODCOLIGADA              AS short OPTIONAL
	WSDATA   cCODEPI                   AS string OPTIONAL
	WSDATA   nCODFILIAL                AS short OPTIONAL
	WSDATA   cCODIDENTEPI              AS string OPTIONAL
	WSDATA   cCODLOC                   AS string OPTIONAL
	WSDATA   cDTDURABILIDADE           AS dateTime OPTIONAL
	WSDATA   cDTVALIDADECA             AS dateTime OPTIONAL
	WSDATA   nDURABILIDADE             AS int OPTIONAL
	WSDATA   nEMPRESTADO               AS short OPTIONAL
	WSDATA   nIDLOTE                   AS int OPTIONAL
	WSDATA   nINVALIDO                 AS short OPTIONAL
	WSDATA   cOBS                      AS string OPTIONAL
	WSDATA   nPERCENTUALUTILIZADO      AS double OPTIONAL
	WSDATA   nPERIODICIDADE            AS int OPTIONAL
	WSDATA   cRECCREATEDBY             AS string OPTIONAL
	WSDATA   cRECCREATEDON             AS dateTime OPTIONAL
	WSDATA   cRECMODIFIEDBY            AS string OPTIONAL
	WSDATA   cRECMODIFIEDON            AS dateTime OPTIONAL
	WSDATA   nSTATUS                   AS short OPTIONAL
	WSDATA   cVALIDADE                 AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT RMVitae_EPI
	::Init()
Return Self

WSMETHOD INIT WSCLIENT RMVitae_EPI
Return

WSMETHOD CLONE WSCLIENT RMVitae_EPI
	Local oClone := RMVitae_EPI():NEW()
	oClone:cAQUISICAO           := ::cAQUISICAO
	oClone:cCA                  := ::cCA
	oClone:nCODCOLIGADA         := ::nCODCOLIGADA
	oClone:cCODEPI              := ::cCODEPI
	oClone:nCODFILIAL           := ::nCODFILIAL
	oClone:cCODIDENTEPI         := ::cCODIDENTEPI
	oClone:cCODLOC              := ::cCODLOC
	oClone:cDTDURABILIDADE      := ::cDTDURABILIDADE
	oClone:cDTVALIDADECA        := ::cDTVALIDADECA
	oClone:nDURABILIDADE        := ::nDURABILIDADE
	oClone:nEMPRESTADO          := ::nEMPRESTADO
	oClone:nIDLOTE              := ::nIDLOTE
	oClone:nINVALIDO            := ::nINVALIDO
	oClone:cOBS                 := ::cOBS
	oClone:nPERCENTUALUTILIZADO := ::nPERCENTUALUTILIZADO
	oClone:nPERIODICIDADE       := ::nPERIODICIDADE
	oClone:cRECCREATEDBY        := ::cRECCREATEDBY
	oClone:cRECCREATEDON        := ::cRECCREATEDON
	oClone:cRECMODIFIEDBY       := ::cRECMODIFIEDBY
	oClone:cRECMODIFIEDON       := ::cRECMODIFIEDON
	oClone:nSTATUS              := ::nSTATUS
	oClone:cVALIDADE            := ::cVALIDADE
Return oClone

WSMETHOD SOAPSEND WSCLIENT RMVitae_EPI
	Local cSoap := ""
	cSoap += WSSoapValue("AQUISICAO", ::cAQUISICAO, ::cAQUISICAO , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CA", ::cCA, ::cCA , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODCOLIGADA", ::nCODCOLIGADA, ::nCODCOLIGADA , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODEPI", ::cCODEPI, ::cCODEPI , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODFILIAL", ::nCODFILIAL, ::nCODFILIAL , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODIDENTEPI", ::cCODIDENTEPI, ::cCODIDENTEPI , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODLOC", ::cCODLOC, ::cCODLOC , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DTDURABILIDADE", ::cDTDURABILIDADE, ::cDTDURABILIDADE , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DTVALIDADECA", ::cDTVALIDADECA, ::cDTVALIDADECA , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DURABILIDADE", ::nDURABILIDADE, ::nDURABILIDADE , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("EMPRESTADO", ::nEMPRESTADO, ::nEMPRESTADO , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("IDLOTE", ::nIDLOTE, ::nIDLOTE , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("INVALIDO", ::nINVALIDO, ::nINVALIDO , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("OBS", ::cOBS, ::cOBS , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("PERCENTUALUTILIZADO", ::nPERCENTUALUTILIZADO, ::nPERCENTUALUTILIZADO , "double", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("PERIODICIDADE", ::nPERIODICIDADE, ::nPERIODICIDADE , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDBY", ::cRECCREATEDBY, ::cRECCREATEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDON", ::cRECCREATEDON, ::cRECCREATEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDBY", ::cRECMODIFIEDBY, ::cRECMODIFIEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDON", ::cRECMODIFIEDON, ::cRECMODIFIEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("STATUS", ::nSTATUS, ::nSTATUS , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("VALIDADE", ::cVALIDADE, ::cVALIDADE , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
Return cSoap

// WSDL Data Structure CatalogoEPI

WSSTRUCT RMVitae_CatalogoEPI
	WSDATA   nCODCOLIGADA              AS short OPTIONAL
	WSDATA   cCODEPI                   AS string OPTIONAL
	WSDATA   cCODGRUPOEPI              AS string OPTIONAL
	WSDATA   nDESCARTAVEL              AS short OPTIONAL
	WSDATA   cDESCRICAO                AS string OPTIONAL
	WSDATA   nIDPRD                    AS int OPTIONAL
	WSDATA   nINATIVA                  AS short OPTIONAL
	WSDATA   cNOME                     AS string OPTIONAL
	WSDATA   cRECCREATEDBY             AS string OPTIONAL
	WSDATA   cRECCREATEDON             AS dateTime OPTIONAL
	WSDATA   cRECMODIFIEDBY            AS string OPTIONAL
	WSDATA   cRECMODIFIEDON            AS dateTime OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT RMVitae_CatalogoEPI
	::Init()
Return Self

WSMETHOD INIT WSCLIENT RMVitae_CatalogoEPI
Return

WSMETHOD CLONE WSCLIENT RMVitae_CatalogoEPI
	Local oClone := RMVitae_CatalogoEPI():NEW()
	oClone:nCODCOLIGADA         := ::nCODCOLIGADA
	oClone:cCODEPI              := ::cCODEPI
	oClone:cCODGRUPOEPI         := ::cCODGRUPOEPI
	oClone:nDESCARTAVEL         := ::nDESCARTAVEL
	oClone:cDESCRICAO           := ::cDESCRICAO
	oClone:nIDPRD               := ::nIDPRD
	oClone:nINATIVA             := ::nINATIVA
	oClone:cNOME                := ::cNOME
	oClone:cRECCREATEDBY        := ::cRECCREATEDBY
	oClone:cRECCREATEDON        := ::cRECCREATEDON
	oClone:cRECMODIFIEDBY       := ::cRECMODIFIEDBY
	oClone:cRECMODIFIEDON       := ::cRECMODIFIEDON
Return oClone

WSMETHOD SOAPSEND WSCLIENT RMVitae_CatalogoEPI
	Local cSoap := ""
	cSoap += WSSoapValue("CODCOLIGADA", ::nCODCOLIGADA, ::nCODCOLIGADA , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODEPI", ::cCODEPI, ::cCODEPI , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODGRUPOEPI", ::cCODGRUPOEPI, ::cCODGRUPOEPI , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DESCARTAVEL", ::nDESCARTAVEL, ::nDESCARTAVEL , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DESCRICAO", ::cDESCRICAO, ::cDESCRICAO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("IDPRD", ::nIDPRD, ::nIDPRD , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("INATIVA", ::nINATIVA, ::nINATIVA , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("NOME", ::cNOME, ::cNOME , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDBY", ::cRECCREATEDBY, ::cRECCREATEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDON", ::cRECCREATEDON, ::cRECCREATEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDBY", ::cRECMODIFIEDBY, ::cRECMODIFIEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDON", ::cRECMODIFIEDON, ::cRECMODIFIEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
Return cSoap

// WSDL Data Structure LoteEPI

WSSTRUCT RMVitae_LoteEPI
	WSDATA   cCA                       AS string OPTIONAL
	WSDATA   nCODCOLIGADA              AS short OPTIONAL
	WSDATA   cCODEPI                   AS string OPTIONAL
	WSDATA   nCODFILIAL                AS short OPTIONAL
	WSDATA   cCODSECAO                 AS string OPTIONAL
	WSDATA   cDTAQUISICAO              AS dateTime OPTIONAL
	WSDATA   cDTDURABILIDADE           AS dateTime OPTIONAL
	WSDATA   cDTVALIDADE               AS dateTime OPTIONAL
	WSDATA   cDTVALIDADECA             AS dateTime OPTIONAL
	WSDATA   nDURABILIDADE             AS int OPTIONAL
	WSDATA   cFABRICANTE               AS string OPTIONAL
	WSDATA   nHIGIENIZADO              AS short OPTIONAL
	WSDATA   nIDLOTE                   AS int OPTIONAL
	WSDATA   nIDMOV                    AS int OPTIONAL
	WSDATA   nINVALIDO                 AS short OPTIONAL
	WSDATA   cOBSERVACOES              AS string OPTIONAL
	WSDATA   nQUANTIDADE               AS int OPTIONAL
	WSDATA   cRECCREATEDBY             AS string OPTIONAL
	WSDATA   cRECCREATEDON             AS dateTime OPTIONAL
	WSDATA   cRECMODIFIEDBY            AS string OPTIONAL
	WSDATA   cRECMODIFIEDON            AS dateTime OPTIONAL
	WSDATA   nVALORUNITARIO            AS decimal OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT RMVitae_LoteEPI
	::Init()
Return Self

WSMETHOD INIT WSCLIENT RMVitae_LoteEPI
Return

WSMETHOD CLONE WSCLIENT RMVitae_LoteEPI
	Local oClone := RMVitae_LoteEPI():NEW()
	oClone:cCA                  := ::cCA
	oClone:nCODCOLIGADA         := ::nCODCOLIGADA
	oClone:cCODEPI              := ::cCODEPI
	oClone:nCODFILIAL           := ::nCODFILIAL
	oClone:cCODSECAO            := ::cCODSECAO
	oClone:cDTAQUISICAO         := ::cDTAQUISICAO
	oClone:cDTDURABILIDADE      := ::cDTDURABILIDADE
	oClone:cDTVALIDADE          := ::cDTVALIDADE
	oClone:cDTVALIDADECA        := ::cDTVALIDADECA
	oClone:nDURABILIDADE        := ::nDURABILIDADE
	oClone:cFABRICANTE          := ::cFABRICANTE
	oClone:nHIGIENIZADO         := ::nHIGIENIZADO
	oClone:nIDLOTE              := ::nIDLOTE
	oClone:nIDMOV               := ::nIDMOV
	oClone:nINVALIDO            := ::nINVALIDO
	oClone:cOBSERVACOES         := ::cOBSERVACOES
	oClone:nQUANTIDADE          := ::nQUANTIDADE
	oClone:cRECCREATEDBY        := ::cRECCREATEDBY
	oClone:cRECCREATEDON        := ::cRECCREATEDON
	oClone:cRECMODIFIEDBY       := ::cRECMODIFIEDBY
	oClone:cRECMODIFIEDON       := ::cRECMODIFIEDON
	oClone:nVALORUNITARIO       := ::nVALORUNITARIO
Return oClone

WSMETHOD SOAPSEND WSCLIENT RMVitae_LoteEPI
	Local cSoap := ""
	cSoap += WSSoapValue("CA", ::cCA, ::cCA , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODCOLIGADA", ::nCODCOLIGADA, ::nCODCOLIGADA , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODEPI", ::cCODEPI, ::cCODEPI , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODFILIAL", ::nCODFILIAL, ::nCODFILIAL , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("CODSECAO", ::cCODSECAO, ::cCODSECAO , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DTAQUISICAO", ::cDTAQUISICAO, ::cDTAQUISICAO , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DTDURABILIDADE", ::cDTDURABILIDADE, ::cDTDURABILIDADE , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DTVALIDADE", ::cDTVALIDADE, ::cDTVALIDADE , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DTVALIDADECA", ::cDTVALIDADECA, ::cDTVALIDADECA , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("DURABILIDADE", ::nDURABILIDADE, ::nDURABILIDADE , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("FABRICANTE", ::cFABRICANTE, ::cFABRICANTE , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("HIGIENIZADO", ::nHIGIENIZADO, ::nHIGIENIZADO , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("IDLOTE", ::nIDLOTE, ::nIDLOTE , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("IDMOV", ::nIDMOV, ::nIDMOV , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("INVALIDO", ::nINVALIDO, ::nINVALIDO , "short", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("OBSERVACOES", ::cOBSERVACOES, ::cOBSERVACOES , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("QUANTIDADE", ::nQUANTIDADE, ::nQUANTIDADE , "int", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDBY", ::cRECCREATEDBY, ::cRECCREATEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECCREATEDON", ::cRECCREATEDON, ::cRECCREATEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDBY", ::cRECMODIFIEDBY, ::cRECMODIFIEDBY , "string", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("RECMODIFIEDON", ::cRECMODIFIEDON, ::cRECMODIFIEDON , "dateTime", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
	cSoap += WSSoapValue("VALORUNITARIO", ::nVALORUNITARIO, ::nVALORUNITARIO , "decimal", .F. , .F., 0 , "http://schemas.datacontract.org/2004/07/WSRMCiteluz.Classe.Entidade", .F.,.F.) 
Return cSoap



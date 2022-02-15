#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "TBICONN.CH"

WSSERVICE WSTESTE Description "<span style='color:red;'>Fábrica de Software - TOTVS BA</span><br/>&nbsp;&nbsp;&nbsp;•<span style='color:red;'> WS para <b>fornecimento de EPI</b>.</span>"

	//-------------------------------------
	//Estrutura declara no WS Fabrica
	//-------------------------------------
	WSDATA o_Empresa	AS strEmpresa
	WSDATA o_Retorno	AS strRetorno
	WSDATA o_Seguranca	AS strSeguranca
	//-------------------------------------

	WSMETHOD mtdTestaMet

ENDWSSERVICE

WSMETHOD mtdTestaMet WSRECEIVE o_Empresa, o_Seguranca WSSEND o_Retorno WSSERVICE WSTESTE

	Local c_UserWS	:= ""
	Local c_PswWS	:= ""

	RpcSetType(3)
	RpcSetEnv(::o_Empresa:c_Empresa, ::o_Empresa:c_Filial)

	::o_Retorno	:= WSCLASSNEW( "strRetorno" )
	c_UserWS	:= "usuario"
	c_PswWS		:= "123"

	IF ( ::o_Seguranca:c_Usuario <> c_UserWS ) .OR. ( ::o_Seguranca:c_Senha <> c_PswWS )

		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida! :("
		Return(.T.)

	ENDIF

	::o_Retorno:l_Status	:= .T.
	::o_Retorno:c_Mensagem	:= 'Funciona! Uhuuu!!!'

Return(.T.)


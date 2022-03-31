//Bibliotecas
#include "Ap5Mail.ch"
#include "rwmake.ch"
#include "protheus.ch"
#INCLUDE "Report.CH"
#INCLUDE 'TOPCONN.CH'
#Include 'FWMVCDef.ch'
#include "vkey.ch"
#include "TOTVS.CH"
#include "TbiConn.ch"
#include 'FONT.CH'
#include 'COLORS.CH'
#INCLUDE "Restful.ch"

WSRESTFUL mtdClientes DESCRIPTION "WEBSERVICE PROTHEUS REST - Cadastro de clientes"

	WSMETHOD POST DESCRIPTION "mtdClientes - POST - Integraçao cadastro de clientes" 	WSSYNTAX "/POST/{method}"

END WSRESTFUL

/*
{
    "empresa":"01",
    "filial":"01",
    "clientes":
    [
        {
        "nome":"jose",
        "cnpj":"0000000000",
        "endereco":"rua a"
        },
        {
        "nome":"paulo",
        "cnpj":"0000000000",
        "endereco":"rua b"
        }
    ]
}
*/


WSMETHOD POST WSSERVICE mtdClientes

	Local l_Ret		:=  .T.
	Local c_Body 	:=  ::GETCONTENT()
	Local c_Motivo  :=  ""
	Local nX        := 0

	Private o_Cliente	:=	Nil
	Private l_Ok		:=  FWJsonDeserialize(c_Body,@o_Cliente)
	Private c_ApiKey	:= ::GetHeader("Basic")
	Private c_Empresa   :=  ""
	Private c_Filial    :=  ""
	Private c_CNPJ	    :=	""
	Private	c_Tipo	    :=	""
	Private	c_Razao		:=	""
	Private	c_Fantasia	:=	""
	Private	c_Endereco	:=	""
	Private c_Data      :=  ""
	Private a_Clientes  := {}

	If ValType("c_ApiKey") <> "C"
		c_Motivo	+=	'Basic nao foi informado na requisicao.'
		l_Ret		:= .F.
		::SETRESPONSE('{"status":false, "mensagem":"'+c_Motivo+'"}')
		Return(.T.)
	Endif

	If ValType("o_Cliente:empresa") <> "C"  .Or. ValType("o_Cliente:filial") <> "C"
		c_Motivo	+=	'empresa e filial nao foi informado na requisicao.'
		l_Ret		:= .F.
	Else
		c_Empresa   :=  decodeUTF8( o_Cliente:empresa)
		c_Filial    :=  decodeUTF8( o_Cliente:filial)
		If !Empty(c_Empresa) .And. !Empty(c_Filial)
			RPCSETTYPE(3)
			RPCSETENV(c_Empresa,c_Filial)
		Endif
	Endif

	If ValType("CFILANT") <> "C"
		c_Motivo	+=	'Login rejeitado do sistema Protheus, codigo de empresa e filial invalido.'
		l_Ret		:= .F.
	Endif

	c_ApiKeyWS	:=	Alltrim( SuperGetMV("FS_WAPIKEY",.F.,"202203031721adminteste") )    //MjAyMjAzMDMxNzIxYWRtaW50ZXN0ZQ==
	c_VldApiKey	:=	Decode64( c_ApiKey )
	If (c_ApiKeyWS <> c_VldApiKey )
		c_Motivo	+=	'Tentativa de acesso ao WS nao permitida, api-key informada invalida !'
		l_Ret		:= .F.
	Endif

	a_Clientes := o_cliente:clientes

	If l_Ret

		for nX:=1 To Len(a_Clientes)
			
			conout("cnpj  - >" + a_Clientes[nX]:cnpj)
			c_CNPJ	:=	""	//cnpj
			If ValType("a_Clientes[nX]:cnpj") <> "C"
				c_Motivo	+=	'cnpj nao foi informado na requisicao.'
				l_Ret		:= .F.
			Else
				c_CNPJ	:=	decodeUTF8( a_Clientes[nX]:cnpj )
			Endif

            c_Tipo	:=	""	//tipo
            If ValType("a_Clientes[nX]:tipo") <> "C"
                c_Motivo	+=	'tipo nao foi informado na requisicao.'
                l_Ret		:= .F.
            Else
                c_Tipo	:=	decodeUTF8( a_Clientes[nX]:tipo )
            Endif

		next Nx

		If !(l_Ret)
			::SETRESPONSE('{"status":false, "mensagem":"'+c_Motivo+'"}')
		Endif

		If l_Ret

			for nX:=1 To Len(a_Clientes)

                c_Fantasia  := a_Clientes[nX]:nome
                c_CNPJ      := a_Clientes[nX]:Cnpj
                c_Endereco  :=  a_Clientes[nX]:endereco

            next nX

            c_Retorno := "PROCESSOU OK: "
			
			a_Ret	:=	{.T.,c_Retorno} ///....EXECAUTO......

			l_Ret	:=	a_Ret[1]
			c_Motivo+=	a_Ret[2]

			If !(l_Ret)
				::SETRESPONSE('{"status":false, "mensagem":"'+c_Motivo+'"}')
			Else
				::SETRESPONSE('{"status":true, "mensagem":"'+c_Motivo+'"}')
			Endif
		Endif

	Endif

Return(.T.)

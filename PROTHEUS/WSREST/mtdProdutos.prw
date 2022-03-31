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

WSRESTFUL mtdProdutos DESCRIPTION "WEBSERVICE PROTHEUS REST - Cadastro de clientes"

	WSMETHOD POST DESCRIPTION "mtdClientes - POST - Integraçao cadastro de clientes" 	WSSYNTAX "/POST/{method}"

END WSRESTFUL 

/*
{
   "empresa":"01",
   "filial":"01",
   "cnpj":"20410420000153",
   "tipo":"X",
   "razao":"XXXXXXXXXXXXXXXXXXXXX",
   "fantasia":"XXXXXXXXXXXXXX",
   "endereco":"XXXXXXXXXXXXXXXXX",
   "data":"20220322"
}
*/

/*
[
    {
        "empresa":"01",
        "filial":"01",
        "cnpj":"20410420000153",
        "tipo":"X",
        "razao":"XXXXXXXXXXXXXXXXXXXXX",
        "fantasia":"XXXXXXXXXXXXXX",
        "endereco":"XXXXXXXXXXXXXXXXX",
        "data":"20220322"
    },
    {
        "empresa":"01",
        "filial":"01",
        "cnpj":"20410420000153",
        "tipo":"X",
        "razao":"XXXXXXXXXXXXXXXXXXXXX",
        "fantasia":"XXXXXXXXXXXXXX",
        "endereco":"XXXXXXXXXXXXXXXXX",
        "data":"20220322"
    }
]
*/


WSMETHOD POST WSSERVICE mtdProdutos

    Local c_Body 	    :=  ::GETCONTENT()
    Local l_ProdOk	    :=  FWJsonDeserialize( c_Body, @o_Produtos )
    Local l_Ret		    :=  .T.
    Local c_Motivo      :=  ""

	Private o_Produtos  :=	Nil
    Private c_ApiKey	:= ::GetHeader("Basic")
    
	If Type("c_ApiKey") <> "C"

		c_Motivo	+=	'Basic nao foi informado na requisicao.'
		l_Ret		:= .F.
		
        ::SETRESPONSE('{"status":false, "mensagem":"'+c_Motivo+'"}')
		
        Return(.T.)

	Endif

    Private c_Empresa   :=  ""
	Private c_Filial    :=  ""
	Private c_CNPJ	    :=	""
	Private	c_Tipo	    :=	"" 
	Private	c_Razao		:=	""
    Private	c_Fantasia	:=	""
    Private	c_Endereco	:=	""
    Private c_Data      :=  ""
	
    If Type("o_Produtos:empresa") <> "C"  .Or. Type("o_Produtos:filial") <> "C"
        c_Motivo	+=	'empresa e filial nao foi informado na requisicao.'
        l_Ret		:= .F.
    Else 
        c_Empresa   :=  decodeUTF8( o_Produtos:empresa)
        c_Filial    :=  decodeUTF8( o_Produtos:filial)
        If !Empty(c_Empresa) .And. !Empty(c_Filial)
            RPCSETTYPE(3)
            RPCSETENV(c_Empresa,c_Filial)
        Endif
    Endif

    If Type("CFILANT") <> "C"
        c_Motivo	+=	'Login rejeitado do sistema Protheus, codigo de empresa e filial invalido.'
        l_Ret		:= .F.
    Endif

    c_ApiKeyWS	:=	Alltrim( SuperGetMV("FS_WAPIKEY",.F.,"202203031721adminteste") )
    c_VldApiKey	:=	Decode64( c_ApiKey )
    If (c_ApiKeyWS <> c_VldApiKey )
        c_Motivo	+=	'Tentativa de acesso ao WS nao permitida, api-key informada invalida !'
        l_Ret		:= .F.
    Endif

    If l_Ret

        c_CNPJ	:=	""	//cnpj
        If Type("o_Produtos:cnpj") <> "C"  
            c_Motivo	+=	'cnpj nao foi informado na requisicao.'
            l_Ret		:= .F.
        Else 
            c_CNPJ	:=	decodeUTF8( o_Produtos:cnpj )
        Endif

        c_Tipo	:=	""	//tipo
        If Type("o_Produtos:tipo") <> "C"  
            c_Motivo	+=	'tipo nao foi informado na requisicao.'
            l_Ret		:= .F.
        Else 
            c_Tipo	:=	decodeUTF8( o_Produtos:tipo )
        Endif

        c_Razao	:=	""	//razao
        If Type("o_Produtos:razao") <> "C"  
            c_Motivo	+=	'razao nao foi informado na requisicao.'
            l_Ret		:= .F.
        Else 
            c_Razao	:=	decodeUTF8( o_Produtos:razao )
        Endif

        c_Fantasia	:=	""	//fantasia
        If Type("o_Produtos:fantasia") <> "C"  
            c_Motivo	+=	'fantasia nao foi informado na requisicao.'
            l_Ret		:= .F.
        Else 
            c_Fantasia	:=	decodeUTF8( o_Produtos:fantasia )
        Endif

        c_Endereco	:=	""	//endereco
        If Type("o_Produtos:endereco") <> "C"  
            c_Motivo	+=	'endereco nao foi informado na requisicao.'
            l_Ret		:= .F.
        Else 
            c_Endereco	:=	decodeUTF8( o_Produtos:endereco )
        Endif      

        c_Data	:=	""	//data
        If Type("o_Produtos:data") <> "C"  
            c_Motivo	+=	'data nao foi informado na requisicao.'
            l_Ret		:= .F.
        Else 
            c_Data	:=	decodeUTF8( o_Produtos:data )
        Endif         

        If !(l_Ret)
			::SETRESPONSE('{"status":false, "mensagem":"'+c_Motivo+'"}')
		Endif

		If l_Ret  
            c_Retorno := "PROCESSOU OK: "
            c_Retorno += "Cnpj: "+c_CNPJ
            c_Retorno += ", Nome: "+c_Razao
            c_Retorno += ", Data: "+Dtoc(StoD(c_Data))

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

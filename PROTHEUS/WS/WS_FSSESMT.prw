#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "TBICONN.CH"

WSSERVICE WS_FSSESMT Description "<span style='color:red;'>Fábrica de Software - TOTVS BA</span><br/>&nbsp;&nbsp;&nbsp;•<span style='color:red;'> WS para <b> integração Fluig SESMT</b>.</span>"

	//--------------------------------------
	//Estruturas criadas no fonte WSFABRICA
	//--------------------------------------
	WSDATA o_EmpFil	 		AS strEmpresa	//Estrutura de Empresa e Filial
	WSDATA o_Retorno		AS strRetorno	//Estrutura de retorno dos Metodos
	WSDATA o_Seguranca	 	AS strSeguranca	//Estrutura de Empresa e Filial
	//--------------------------------------

	WSDATA o_DadosSA 		AS strDadosSA 		 //Estrutura de Parametros do Titulo

	WSMETHOD mtdIncSA  //Metodo da movimentacao Bancaria

ENDWSSERVICE

//Estrutura do CENTRO DE CUSTO
WSSTRUCT strDadosSA

	WSDATA c_Usuario	AS STRING
	WSDATA CP_ITENS 	AS ARRAY OF strItSA

ENDWSSTRUCT

WSSTRUCT strItSA

	WSDATA c_Produto	AS STRING
	WSDATA n_Quant		AS INTEGER
	WSDATA c_Armazem	AS STRING

ENDWSSTRUCT

//Estrutura com os dados da SA
WSMETHOD mtdIncSA WSRECEIVE o_Seguranca, o_EmpFil, o_DadosSA WSSEND o_Retorno WSSERVICE WS_FSSESMT

	Local a_Cabec	:= {}
	Local a_Item	:= {}
	Local a_Itens	:= {}
	Local c_Num		:= ""
	Local c_Local	:= ""
	Local nX		:= 0
	Local c_UserWS	:= ""
	Local c_PswWS	:= ""

	Private lMsHelpAuto := .T.  	//se .t. direciona as mensagens de help para o arq. de log
	Private lMsErroAuto := .F. 		//necessário a criação, pois será  //atualizado quando houver alguma inconsistência nos parâmetros

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Abertura do ambiente                                         |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RpcSetType( 3 )
	RpcSetEnv( ::o_EmpFil:c_Empresa, ::o_EmpFil:c_Filial )

	::o_Retorno	:= WSCLASSNEW("strRetorno")
	c_UserWS	:= SUPERGETMV("FS_GEUSRWS",,"totvs_ws")
	c_PswWS		:= SUPERGETMV("FS_GEPSWWS",,"totvs@123")

	IF ( ::o_Seguranca:c_Usuario <> c_UserWS ) .OR. ( ::o_Seguranca:c_Senha <> c_PswWS )

		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida!"
		Return(.T.)

	ENDIF

	c_Num	:= GETSXENUM("SCP","CP_NUM")
	c_Local	:= SUPERGETMV("FS_RMLOCSA",.F.,"01")

	a_Cabec	:= {;
			{"CP_FILIAL"	,XFILIAL("SCP")			,NIL},;
			{"CP_NUM"		,c_Num					,NIL},;
			{"CP_CODSOLI"	,"000000"				,Nil},;
			{"CP_SOLICIT"	,::o_DadosSA:c_Usuario	,NIL},;
			{"CP_EMISSAO"	,DDATABASE				,NIL}}

	For nX:=1 To Len( ::o_DadosSA:CP_ITENS )

		DBSELECTAREA("SB1")
		DBSETORDER(1)
		DBSEEK( XFILIAL("SB1") + PADR( ::o_DadosSA:CP_ITENS[nX]:c_Produto, TAMSX3("B1_COD")[1] ) , .T. )

		AADD( a_Item, {;
					{"CP_ITEM"		,StrZero( nX, 2 )														,Nil},;
					{"CP_PRODUTO"	,PADR( ::o_DadosSA:CP_ITENS[nX]:c_Produto, TAMSX3("B1_COD")[1] )		,Nil},;
					{"CP_UM"	  	,SB1->B1_UM																,Nil},;
					{"CP_QUANT" 	,Val( PADR( ::o_DadosSA:CP_ITENS[nX]:n_Quant, TAMSX3("CP_QUANT")[1] ) )	,Nil},;
					{"CP_DATPRF"	,DDATABASE + 1															,Nil},;
					{"CP_LOCAL"		,PADR( ::o_DadosSA:CP_ITENS[nX]:c_Armazem, TAMSX3("CP_LOCAL")[1] )		,Nil},;
					{"CP_DESCRI"	,SB1->B1_DESC															,Nil},;
					{"CP_USER"		,"000000"																,Nil}} )

	Next nX

	Begin Transaction

		DBSELECTAREA("SCP")
		MSExecAuto( { |x,y,z| MATA105(x,y,z) }, a_Cabec, a_Item, 3 )

		If lMsErroAuto

			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= MostraErro()

			RollbackSX8()
			DisarmTransaction()

		ELSE

			::o_Retorno:l_Status	:= .T.
			::o_Retorno:c_Mensagem	:= "Solicitação de Armazém " +  Alltrim( c_Num )+ " cadastrada com sucesso!!!"

			ConfirmSX8()

		EndIf

	End Transaction

Return(.T.)
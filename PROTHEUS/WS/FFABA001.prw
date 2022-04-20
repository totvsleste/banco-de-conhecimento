#INCLUDE "TOTVS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE 'FWMVCDEF.CH'

#DEFINE ENTER CHR( 13 ) + CHR( 10 )

WSSERVICE FFABA001 Description "<span style='color:red;'>Fábrica de Software - TOTVS BA</span><br/>&nbsp;&nbsp;&nbsp;<span style='color:red;'> WS de Integração do Portal do Fornecedor com o Gestão de Contratos</b>.</span>"

	//------------------------------------------------
	//Estrutura declarada no WS Fabrica ( WSFABRICA.PRW )
	//------------------------------------------------
	WSDATA o_Empresa	AS strEmpresa
	WSDATA o_Retorno	AS strRetorno
	//-------------------------------------

	WSDATA o_ListaClientes		AS ARRAY OF strListaClientes
	
	WSMETHOD mtdListaClientes
	
ENDWSSERVICE

WSSTRUCT strListaClientes

	WSDATA A1_CGC	AS STRING OPTIONAL
	WSDATA A1_NOME	AS STRING OPTIONAL
	WSDATA l_Status     AS boolean OPTIONAL
	WSDATA c_Mensagem   AS STRING OPTIONAL
	
ENDWSSTRUCT

//---------------- F I M ------------------------------

WSMETHOD mtdListaClientes WSRECEIVE o_Empresa WSSEND o_ListaClientes WSSERVICE FFABA001

	RpcSetType(3)
	RpcSetEnv( o_Empresa:c_Empresa, o_Empresa:c_Filial )

	dbSelectArea("SA1")
	dbSetOrder(1)
	while SA1->(!EOF())

		o_Retorno := WSCLASSNEW("strListaClientes")

		o_Retorno:A1_CGC		:= SA1->A1_CGC
		o_Retorno:A1_NOME		:= SA1->A1_NOME 
		o_Retorno:l_Status		:= .T.
		o_Retorno:c_Mensagem	:= "Consulta executada com sucesso!!!"

		AADD( Self:o_ListaClientes, o_Retorno )

		SA1->(DBSKIP())

	ENDDO
	
Return(.T.)

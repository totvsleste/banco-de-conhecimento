#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "TBICONN.CH"

WSSERVICE WS_FSCONTASPGAR Description "<span style='color:red;'>Fábrica de Software - TOTVS BA</span><br/>&nbsp;&nbsp;&nbsp;•<span style='color:red;'> WS para <b>manutencao do contas a pagar</b>.</span>"

	WSDATA n_Opc			AS INTEGER
	WSDATA c_PreRet			AS STRING
	WSDATA c_NumRet			AS STRING
	WSDATA o_EmpFil	 		AS strEmpresFil 		 //Estrutura de Empresa e Filial
	WSDATA o_ParamTit 		AS strParamTitulos 		 //Estrutura de Parametros do Titulo
	WSDATA o_RetMtd			AS strRetornMetodos		 //Estrutura de retorno dos Metodos

	WSMETHOD mtdInclusaoCP  //Metodo da movimentacao Bancaria

ENDWSSERVICE

//Estrutura de Empresa e Filial
WSSTRUCT strEmpresFil

	WSDATA c_Empresa 	AS STRING
	WSDATA c_Filial		AS STRING

ENDWSSTRUCT

//Estrutura de Retorno dos Metodos
WSSTRUCT strRetornMetodos

	WSDATA l_Status		AS BOOLEAN
	WSDATA c_Mensagem		AS STRING

ENDWSSTRUCT

//Estrutura dos Parametros
WSSTRUCT strParamTitulos

	WSDATA c_Fornecedor		AS STRING
	WSDATA c_Loja			AS STRING
	WSDATA c_Tipo			AS STRING
	WSDATA d_Emissao		AS STRING
	WSDATA d_Vencto			AS STRING
	WSDATA n_Valor			AS INTEGER
	WSDATA c_Hist			AS STRING
	WSDATA c_Natureza		AS STRING
	WSDATA c_CCD			AS STRING

ENDWSSTRUCT

WSMETHOD mtdInclusaoCP WSRECEIVE n_Opc, o_EmpFil, o_ParamTit, c_NumRet, c_PreRet WSSEND o_RetMtd WSSERVICE WS_FSCONTASPGAR

	Local a_Array 			:= {}
	Local d_Data			:= ""

	Local c_Banco			:= ""
	Local c_Agencia			:= ""
	Local c_Conta			:= ""

	Local c_Prefixo			:= ""
	Local c_Numero 			:= ""

	Local c_UserWS			:= ""
	Local c_PswWS			:= ""

	Local a_AuxSEV			:= {}
	Local a_Rateio			:= {}

	Local a_AuxSEZ			:= {}
	Local a_CCUSTO			:= {}
	Local cSvFilAnt	        := ""

	PRIVATE lMsErroAuto 	:= .F.

	::o_RetMtd	:= WSCLASSNEW("strRetornMetodos")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Abertura do ambiente                                         |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//RpcSetType(3)
	//RpcSetEnv(o_EmpFil:c_Empresa,o_EmpFil:c_Filial)

	if ::n_Opc == 3

		c_Prefixo	:= GetMV("FS_PRECP")
		c_Numero 	:= STRZERO( VAL( GetMV( "FS_NUMCP" ) ) + 1, 9 )

	else

		c_Prefixo	:= ::c_PreRet
		c_Numero 	:= ::c_NumRet

	endif

	PUTMV("FS_NUMCP", c_Numero)

	Begin Transaction

//		AADD( a_Array, { "E2_FILIAL"	, xfilial("SE2")  			,NIL })
		AADD( a_Array, { "E2_FORNECE"	, PADR(o_ParamTit:c_Fornecedor, TAMSX3("A2_COD")[1])  	,NIL })
		AADD( a_Array, { "E2_LOJA"	 	, PADR(o_ParamTit:c_Loja, TAMSX3("A2_LOJA")[1])  			,NIL })
		AADD( a_Array, { "E2_PREFIXO"	, PADR(c_Prefixo, TAMSX3("E2_PREFIXO")[1])					,NIL })
		AADD( a_Array, { "E2_NUM"	  	, PADR(c_Numero, TAMSX3("E2_NUM")[1])						,NIL })
		AADD( a_Array, { "E2_PARCELA"	, PADR("A", TAMSX3("E2_PARCELA")[1])						,NIL })
		AADD( a_Array, { "E2_TIPO"	 	, PADR(o_ParamTit:c_Tipo, TAMSX3("E2_TIPO")[1])			,NIL })
		AADD( a_Array, { "E2_EMISSAO" 	, CtoD(o_ParamTit:d_Emissao)								,NIL })
		AADD( a_Array, { "E2_MOEDA"  	, 1															,NIL })
		AADD( a_Array, { "E2_CC" 		, PADR("99999", TAMSX3("E2_CCD")[1])				,NIL })
		AADD( a_Array, { "E2_VENCTO" 	, CtoD(o_ParamTit:d_Vencto)								,NIL })
		AADD( a_Array, { "E2_VALOR"  	, o_ParamTit:n_Valor										,NIL })
		AADD( a_Array, { "E2_NATUREZ"	, PADR(o_ParamTit:c_Natureza, TAMSX3("E2_NATUREZ")[1])	,NIL })
		AADD( a_Array, { "E2_HIST"		, PADR(o_ParamTit:c_Hist, TAMSX3("E2_HIST")[1])			,NIL })
		AADD( a_Array, { "E2_MULTNAT" 	, '2'					,Nil })

//		cSvFilAnt := cFilAnt
//		cFilAnt   := o_EmpFil:c_Filial

		MsExecAuto( { |x,y,z| FINA050(x,y,z)}, a_Array,, ::n_Opc) // 3 - Inclusao, 4 - Alteração, 5 - Exclusão

//		cFilAnt := cSvFilAnt

		If lMsErroAuto

			DisarmTransaction()
			::o_RetMtd:l_Status		:= .F.
			::o_RetMtd:c_Mensagem	:= MostraErro("\TOTVSBA_LOG\","Manutencao_Titulo.txt")

		Else

			::o_RetMtd:l_Status		:= .T.
			::o_RetMtd:c_Mensagem	:= c_Prefixo+"/"+c_Numero

		Endif

	End Transaction

RETURN(.T.)
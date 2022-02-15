#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "TBICONN.CH"

User Function FSCONTASAPAGAR()

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

	//::o_RetMtd	:= WSCLASSNEW("strRetornMetodos")

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//| Abertura do ambiente                                         |
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	//RpcSetType(3)
	//RpcSetEnv(o_EmpFil:c_Empresa,o_EmpFil:c_Filial)

	//if ::n_Opc == 3

		c_Prefixo	:= "TST"
		c_Numero 	:= "990000"


	Begin Transaction

//		AADD( a_Array, { "E2_FILIAL"	, xfilial("SE2")  			,NIL })
		AADD( a_Array, { "E2_FORNECE"	, "010106" 	,NIL })
		AADD( a_Array, { "E2_LOJA"	 	, "01"  			,NIL })
		AADD( a_Array, { "E2_PREFIXO"	, PADR(c_Prefixo, TAMSX3("E2_PREFIXO")[1])					,NIL })
		AADD( a_Array, { "E2_NUM"	  	, PADR(c_Numero, TAMSX3("E2_NUM")[1])						,NIL })
		AADD( a_Array, { "E2_PARCELA"	, PADR("A", TAMSX3("E2_PARCELA")[1])						,NIL })
		AADD( a_Array, { "E2_TIPO"	 	, "FOL"			,NIL })
		AADD( a_Array, { "E2_EMISSAO" 	, CtoD("29/05/2017")								,NIL })
		AADD( a_Array, { "E2_MOEDA"  	, 1															,NIL })
		AADD( a_Array, { "E2_CC" 		, PADR("99999", TAMSX3("E2_CCD")[1])				,NIL })
		AADD( a_Array, { "E2_VENCTO" 	, CtoD("29/05/2017")								,NIL })
		AADD( a_Array, { "E2_VALOR"  	, 10000										,NIL })
		AADD( a_Array, { "E2_NATUREZ"	, PADR("FPES01", TAMSX3("E2_NATUREZ")[1])	,NIL })
		AADD( a_Array, { "E2_HIST"		, PADR("TESTE", TAMSX3("E2_HIST")[1])			,NIL })
		AADD( a_Array, { "E2_MULTNAT" 	, '2'					,Nil })

//		cSvFilAnt := cFilAnt
//		cFilAnt   := o_EmpFil:c_Filial

		MsExecAuto( { |x,y,z| FINA050(x,y,z)}, a_Array,, ::n_Opc) // 3 - Inclusao, 4 - AlteraГЦo, 5 - ExclusЦo

//		cFilAnt := cSvFilAnt

		If lMsErroAuto

			DisarmTransaction()
			MostraErro()

		Else

			Conout("ok")

		Endif

	End Transaction

RETURN(.T.)
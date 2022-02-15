#INCLUDE 'TOTVS.CH'

#DEFINE EMPRESA IIF(cEmpAnt=="99","1",cEmpAnt)
#DEFINE FILIAL cFilAnt
#DEFINE ENTER CHR(13) + CHR(10)

#DEFINE SECAO IIF(cEmpAnt=="99","01",cEmpAnt) + "." + cFilAnt

/*/{Protheus.doc} FCOMM001
Programa responsavel pela manutencao do EPI
Chamada: Ponto de Entrada MT010INC

@type function
@author francisco.ssa
@since 03/06/2016
@version 11.80

@return Nil, Nao esperado

@example
(examples)

@see (links_or_references)
/*/
User Function FCOMM001( c_Oper )

	Local c_TipoEPI	:= SUPERGETMV("FS_RMTPEPI",.F.,"5")
	Local l_Ret		:= .T.

	IF ALLTRIM( SB1->B1_TIPO ) == "PA"

		LjMsgRun( "Aguarde... Enviando os EPIs para o RM Vitae", "Integração Protheus RM", {|| l_Ret := f_IntegraRMVitaeEPI( c_Oper ) } )

	ENDIF

Return( l_Ret )

/*/{Protheus.doc} f_IntegraRMVitaeEPI
Funcao responsavel pela manutencao do Catalogo de EPI

@type function
@author francisco.ssa
@since 03/06/2016
@version 11.80

@return Nil, Nao esperado

@example
(examples)

@see (links_or_references)
/*/
Static Function f_IntegraRMVitaeEPI( c_Oper )

	Local o_WS		:= WSRMVitae():New()
	Local l_Ret		:= .T.

	o_WS:oWSpOperacao:Value				:= c_Oper
	o_WS:oWSpCatalogoEPI:nCODCOLIGADA	:= Val( EMPRESA )
	o_WS:oWSpCatalogoEPI:cCODEPI     	:= FILIAL + ALLTRIM( SB1->B1_COD )
	//o_WS:oWSpCatalogoEPI:cCODGRUPOEPI	:= ALLTRIM( SB1->B1_GRUPO )
	o_WS:oWSpCatalogoEPI:nDESCARTAVEL	:= 0
	o_WS:oWSpCatalogoEPI:cDESCRICAO		:= SUBSTR( ALLTRIM( SB1->B1_DESC ), 1, 16 )
	o_WS:oWSpCatalogoEPI:nINATIVA		:= 0
	o_WS:oWSpCatalogoEPI:cNOME			:= ALLTRIM( ALLTRIM( SB1->B1_DESC ) )

	o_WS:ManterCatalogoEPI()

	If ValType( o_WS:oWSManterCatalogoEPIResult:lSucesso ) == "U"

		MsgInfo("ATENÇÃO!!!! WS não está ativo. Entre em contato com o setor de TI!!!","FVITM108")
		l_Ret := .F.
		Return( l_Ret )

	EndIf

	If !o_WS:oWSManterCatalogoEPIResult:lSucesso

		ALERT(  o_WS:oWSManterCatalogoEPIResult:cMensagem + ENTER + "Chave: " + EMPRESA + " - " + Alltrim( SB1->B1_COD ) )
		l_Ret := .F.

	EndIf

Return( l_Ret )
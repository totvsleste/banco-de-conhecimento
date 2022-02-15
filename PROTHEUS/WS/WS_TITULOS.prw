#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออหอออออออัอออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWS_Estoque       บAutor  ณ TOTVS       บ Data ณSetembro/2014บฑฑ
ฑฑฬออออออออออุอออออออออออออออออสอออออออฯอออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณWS relacionado ao estoque                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A T U A L I Z A C O E S                           บฑฑ
ฑฑฬออออออออออหอออออออออออออออออออหออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      บANALISTA           บALTERACOES                              บฑฑ
ฑฑศออออออออออสอออออออออออออออออออสออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
WSSERVICE WS_PROVISAO Description "<span style='color:red;'>Fแbrica de Software - TOTVS BA</span><br/>&nbsp;&nbsp;&nbsp;•<span style='color:red;'> WS para <b>Movimentacao de Estoque</b>.</span>"

	//------------------------------------------------
	//Estrutura declarada no WS Fabrica (WSFABRICA.PRW)
	//------------------------------------------------
	WSDATA o_Empresa	AS strEmpresa
	WSDATA o_Retorno	AS strRetorno
	WSDATA o_Seguranca	AS strSeguranca
	//-------------------------------------

	//PROPRIEDADES DO METODO FSCONSULTASALDO
	WSDATA CNPJ 	 	AS STRING
	WSDATA TITULOS		AS ARRAY OF strTitulosProv

	//METODO DO WS CONSULTA ESTOQUE
	WSMETHOD mtdTitulosProv
	
ENDWSSERVICE

//TIPO DO RETORNO
WSSTRUCT strTitulosProv

	WSDATA E2_FILIAL 	AS STRING OPTIONAL
	WSDATA E2_PREFIXO 	AS STRING OPTIONAL
	WSDATA E2_NUM	    AS STRING OPTIONAL
	WSDATA E2_PARCELA	AS STRING OPTIONAL
	WSDATA E2_TIPO	    AS STRING OPTIONAL
	WSDATA E2_NATUREZ	AS STRING OPTIONAL
	WSDATA E2_FORNECE	AS STRING OPTIONAL
	WSDATA E2_LOJA	    AS STRING OPTIONAL
	WSDATA A2_NREDUZ	AS STRING OPTIONAL
	WSDATA E2_EMISSAO	AS STRING OPTIONAL
	WSDATA E2_VENCTO	AS STRING OPTIONAL
	WSDATA E2_VENCREA	AS STRING OPTIONAL
	WSDATA E2_VALOR	    AS FLOAT OPTIONAL
	WSDATA E2_SALDO 	AS FLOAT OPTIONAL
    WSDATA STATUS       AS BOOLEAN OPTIONAL
    WSDATA MENSAGEM     AS STRING OPTIONAL
	
ENDWSSTRUCT

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออหอออออออัอออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFSConsultaSaldo  บAutor  ณ TOTVS       บ Data ณSetembro/2014บฑฑ
ฑฑฬออออออออออุอออออออออออออออออสอออออออฯอออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o saldo de estoque ou saldo das pe็as reservadas    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A T U A L I Z A C O E S                           บฑฑ
ฑฑฬออออออออออหอออออออออออออออออออหออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      บANALISTA           บALTERACOES                              บฑฑ
ฑฑศออออออออออสอออออออออออออออออออสออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
WSMETHOD mtdTitulosProv WSRECEIVE o_Empresa, o_Seguranca, CNPJ WSSEND TITULOS WSSERVICE WS_PROVISAO

	Local o_Retorno
    Local c_Alias       := GetNextAlias()
    Local c_UserWS      := ""
    Local c_PswWS       := ""

	RpcSetType(3)
	RpcSetEnv(::o_Empresa:c_Empresa,::o_Empresa:c_Filial)

    c_UserWS	:= SUPERGETMV("FS_GEUSRWS",,"totvs_ws")
	c_PswWS		:= SUPERGETMV("FS_GEPSWWS",,"totvs@123")

	IF ( ::o_Seguranca:c_Usuario <> c_UserWS ) .OR. ( ::o_Seguranca:c_Senha <> c_PswWS )

		o_Retorno := WSCLASSNEW("strTitulosProv")

        o_Retorno:STATUS  	:= .F.
		o_Retorno:MENSAGEM	:= "Tentativa de acesso ao WS nao permitida!"

        AADD( Self:TITULOS, o_Retorno )

		Return(.T.)

	ENDIF

    BeginSQL Alias c_Alias
        SELECT
            A2_NREDUZ,
            E2_FILIAL,
            E2_PREFIXO,
            E2_NUM,
            E2_PARCELA,
            E2_TIPO,
            E2_NATUREZ,
            E2_PORTADO,
            E2_FORNECE,
            E2_LOJA,
            E2_EMISSAO,
            E2_VENCTO,
            E2_VENCREA,
            E2_VALOR,
            E2_SALDO

        FROM 
            %TABLE:SE2% E2
        INNER JOIN 
            %TABLE:SA2% A2
        ON
            A2.%NOTDEL%
            AND A2.A2_COD = E2.E2_FORNECE
            AND A2.A2_LOJA = E2.E2_LOJA
            AND A2.A2_CGC = %EXP:CNPJ%
        WHERE
            E2.%NOTDEL%
    EndSQL

	DBSELECTAREA( c_Alias )
	WHILE ( c_Alias )->(!EOF())

		o_Retorno := WSCLASSNEW("strTitulosProv")

		o_Retorno:E2_FILIAL     := ( c_Alias )->E2_FILIAL
        o_Retorno:E2_PREFIXO    := ( c_Alias )->E2_PREFIXO
        o_Retorno:E2_NUM        := ( c_Alias )->E2_NUM
        o_Retorno:E2_PARCELA    := ( c_Alias )->E2_PARCELA
        o_Retorno:E2_TIPO	    := ( c_Alias )->E2_TIPO    
        o_Retorno:E2_NATUREZ    := ( c_Alias )->E2_NATUREZ	
        o_Retorno:E2_FORNECE    := ( c_Alias )->E2_FORNECE	
        o_Retorno:E2_LOJA	    := ( c_Alias )->E2_LOJA    
        o_Retorno:A2_NREDUZ	    := ( c_Alias )->A2_NREDUZ
        o_Retorno:E2_EMISSAO    := DTOC( STOD( ( c_Alias )->E2_EMISSAO ) )
        o_Retorno:E2_VENCTO	    := DTOC( STOD( ( c_Alias )->E2_VENCTO ) ) 
        o_Retorno:E2_VENCREA    := DTOC( STOD( ( c_Alias )->E2_VENCREA ) )	
        o_Retorno:E2_VALOR	    := ( c_Alias )->E2_VALOR
        o_Retorno:E2_SALDO      := ( c_Alias )->E2_SALDO
        o_Retorno:STATUS  	    := .T.
		o_Retorno:MENSAGEM	    := ""

		AADD( Self:TITULOS, o_Retorno )

		( c_Alias )->(DBSKIP())

	ENDDO

( c_Alias )->(DBCLOSEAREA())

RETURN(.T.)


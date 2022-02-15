#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "TBICONN.CH"

WSSERVICE WS_FTRBENS Description "<span style='color:red;'>Fábrica de Software - TOTVS BA</span><br/>&nbsp;&nbsp;&nbsp;<span style='color:red;'> WS para <b> Transferência de Bens do Ativo Fixo</b>.</span>"

	//------------------------------------------------
	//Estrutura declarada no WS Fabrica
	//------------------------------------------------
	WSDATA o_Empresa	AS strEmpresa
	WSDATA o_Retorno	AS strRetorno
	WSDATA o_Seguranca	AS strSeguranca

	WSDATA o_DadosATF	AS strDadosATF //Estrutura de Parametros do Ativo 			

	WSMETHOD mtdTransfBens			//Metodo para transferência do bem			
	
ENDWSSERVICE

WSSTRUCT strDadosATF

	WSDATA c_FILORIG	AS String
	WSDATA c_CBASEDE	AS String 
	WSDATA c_CBASEATE	AS String 
	WSDATA c_ITEMDE 	AS String 
	WSDATA c_ITEMATE 	AS String
	WSDATA c_GRPDE	    AS String
	WSDATA c_GRPATE	    AS String
	WSDATA c_LOCDE 	    AS String	
	WSDATA c_LOCATE 	AS String
	WSDATA c_DATADE	    AS String	
	WSDATA c_DATAATE 	AS String  
	WSDATA c_FILDEST	AS String
	WSDATA c_LOCDEST	AS String						
ENDWSSTRUCT

/*/{Protheus.doc} mtdTransfBens
Realiza a transferência do(s) ben(s)
@author 
@since Abr/2021
@version 12.1.17

/*/
WSMETHOD mtdTransfBens WSRECEIVE o_Empresa, o_Seguranca, o_DadosATF WSSEND o_Retorno WSSERVICE WS_FTRBENS

	Local o_Retorno
    Local c_Alias    := GetNextAlias()
    Local c_UserWS   := ""
    Local c_PswWS    := ""
	Local aDadosAuto := {}		// Array com os dados a serem enviados pela MsExecAuto() para gravacao automatica
    Local aParamAuto := {}

	Private lMsHelpAuto := .T.        //Se .t. direciona as mensagens de help para o arq. de log
	Private lMsErroAuto := .F.       //Necessário a criação, pois será  //atualizado quando houver alguma inconsistência nos parâmetros
	
	RpcSetType(3)
	RpcSetEnv(::o_Empresa:c_Empresa,::o_Empresa:c_Filial)

    ::o_Retorno	:= WSCLASSNEW("strRetorno")
    c_UserWS	:= SUPERGETMV("FS_USUATF",,"totvs_ws")
	c_PswWS		:= SUPERGETMV("FS_SENATF",,"totvs@123")

	IF ( ::o_Seguranca:c_Usuario <> c_UserWS ) .OR. ( ::o_Seguranca:c_Senha <> c_PswWS )

        ::o_Retorno:l_Status  	:= .F.
		::o_Retorno:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida!"

		Return(.T.)

	ENDIF

    BeginSQL Alias c_Alias
        SELECT
		    N1_CBASE,
			N1_ITEM,
            N1_LOCAL,
            N1_NFISCAL,
            N1_GRUPO,
            N1_NSERIE,
            N1_TAXAPAD,
			N1_LOCAL,
            N3_CCUSTO,
            N3_CCONTAB,
            N3_CBASE,
            N3_ITEM,
            N3_TIPO,
            N3_CCUSTO,
            N3_CCONTAB,
            N3_CCORREC,
            N3_CDEPREC,
            N3_CCDEPR,
			N3_CDESP,
			N3_CUSTBEM,
			N3_CCCORR,
			N3_CCDESP,
			N3_CCCDES,
			N4_DATA

        FROM 
            %TABLE:SN1% N1
        INNER JOIN 
            %TABLE:SN3% N3
        ON
            N3.%NOTDEL%
            AND N3.N3_FILIAL = N1.N1_FILIAL
            AND N3.N3_CBASE = N1.N1_CBASE
            AND N3.N3_ITEM = N1.N1_ITEM
			AND N3.N3_BAIXA = %''%
        INNER JOIN 
            %TABLE:SN4% N4
        ON
            N4.%NOTDEL%
            AND N4.N4_FILIAL = N3.N3_FILIAL
            AND N4.N4_CBASE = N3.N3_CBASE
            AND N4.N4_ITEM = N3.N3_ITEM
			AND N4.N4_TIPO = N4.N4_TIPO
        WHERE
		    N1.N1_FILIAL = %::o_DadosATF:c_FILORIG% AND
		    N1.N1_CBASE >= %::o_DadosATF:c_CBASEDE% AND
		    N1.N1_CBASE <= %::o_DadosATF:c_CBASEATE% AND
		    N1.N1_ITEM >= %::o_DadosATF:c_ITEMDE% AND
		    N1.N1_ITEM <= %::o_DadosATF:c_ITEMATE% AND
		    N1.N1_LOCAL >= %::o_DadosATF:c_LOCDE% AND
		    N1.N1_LOCAL <= %::o_DadosATF:c_LOCATE% AND
		    N1.N1_GRUPO >= %::o_DadosATF:c_GRPDE% AND
		    N1.N1_GRUPO <= %::o_DadosATF:c_GRPATE% AND
		    N1.N1_AQUISIC >= %STOD(::o_DadosATF:c_DATADE)% AND
		    N1.N1_AQUISIC <= %STOD(::o_DadosATF:c_DATAATE)% AND			
            N1.%NOTDEL%
    EndSQL

    // Parâmetros das perguntas da rotina atfa060 
    aAdd( aParamAuto, {"MV_PAR01", 2} ) //Pergunta 01 - Contabiliza        ? 1 = Sim ; 2 = Não 
    aAdd( aParamAuto, {"MV_PAR02", 2} ) //Pergunta 02 - Mostra Lanc Contab ? 1 = Sim ; 2 = Não 
    aAdd( aParamAuto, {"MV_PAR03", 2} ) //Pergunta 02 - Aglut Lançamentos  ? 1 = Sim ; 2 = Não 

	DBSELECTAREA( c_Alias )
	WHILE ( c_Alias )->(!EOF())
            aDadosAuto:= {{'N3_CBASE'  , (c_Alias)->N1_CBASE   , Nil},;    // Código base do ativo
                          {'N3_ITEM'   , (c_Alias)->N1_ITEM    , Nil},;    // Item sequencial do código bas do ativo
                          {'N3_TIPO'   , (c_Alias)->N3_TIPO    , Nil},;    // Tipo do Ativo  
                          {'N1_FILIAL' , ::o_DadosATF:c_FILDEST, Nil},;    // Filial de Destino do Ativo
                          {'N4_DATA'   , (c_Alias)->N4_DATA    , Nil},;    // Data de aquisição do ativo
                          {'N3_CCUSTO' , (c_Alias)->N3_CCUSTO  , Nil},;    // Centro de Custo de Despesa
                          {'N3_CCONTAB', (c_Alias)->N3_CCONTAB , Nil},;    // Conta Contabil
                          {'N3_CCORREC', (c_Alias)->N3_CCORREC , Nil},;    // Conta de Correcao do Bem
                          {'N3_CDEPREC', (c_Alias)->N3_CDEPREC , Nil},;    // Conta Despesa Depreciação
                          {'N3_CCDEPR' , (c_Alias)->N3_CCDEPR  , Nil},;    // Conta Depreciação Acumulada
                          {'N3_CDESP'  , (c_Alias)->N3_CDESP   , Nil},;    // Conta Correção Depreciação
                          {'N3_CUSTBEM', (c_Alias)->N3_CUSTBEM , Nil},;    // Centro de Custo da Conta do Bem
                          {'N3_CCCORR' , (c_Alias)->N3_CCCORR  , Nil},;    // Centro Custo Correção Monetária
                          {'N3_CCDESP' , (c_Alias)->N3_CCDESP  , Nil},;    // Centro Custo Despesa Depreciação
                          {'N3_CCCDEP' , (c_Alias)->N3_CCCDEP  , Nil},;    // Centro Custo Despesa Acumulada
                          {'N3_CCCDES' , (c_Alias)->N3_CCCDES  , Nil},;    // Centro Custo Correção Depreciacão
                          {'N1_GRUPO'  , (c_Alias)->N1_GRUPO   , Nil},;    // Código do Grupo do Bem
                          {'N1_LOCAL'  , ::o_DadosATF:c_LOCDEST, Nil},;    // Localizacao do Bem
                          {'N1_NFISCAL', (c_Alias)->N1_NFISCAL , Nil},;    // Numero da NF
                          {'N1_NSERIE' , (c_Alias)->N1_NSERIE  , Nil},;    // Serie da NF
                          {'N1_TAXAPAD', (c_Alias)->N1_TAXAPAD , Nil}}     // Codigo da Taxa Padrao
    
			( c_Alias )->(DBSKIP())
	ENDDO

	If Len(aDadosAuto) > 0
	    Begin Transaction
            /* 
            O quarto parâmetro pode ser configurado com os seguintes estados.
            .T. = Espelhar. 
            .F. = Atualizar. 
            */ 
            MSExecAuto({|x, y, w, z| AtfA060(x, y, w, z)},aDadosAuto, 4, aParamAuto , .F.)
            //MSExecAuto({|x, y, w, z| AtfA060(x, y, w, z)},aDadosAuto, 4, , .F.)

		    If lMsErroAuto
			   DisarmTransaction()
			   ::o_Retorno:l_Status	   := .F.
			   ::o_Retorno:c_Mensagem  := MostraErro()
		    Else
			   ::o_Retorno:l_Status	   := .T.
			   ::o_Retorno:c_Mensagem  := "Transferência do bem concluida!"	
		    EndIf
		
	    End Transaction
	EndIf 
		
Return(.T.)

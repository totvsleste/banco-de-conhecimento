#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE 'FWMVCDEF.CH'

WSSERVICE WS_FTRBENS Description "<span style='color:red;'>Fábrica de Software - TOTVS BA</span><br/>&nbsp;&nbsp;&nbsp;<span style='color:red;'> WS para <b> Transferência de Bens do Ativo Fixo</b>.</span>"

	//------------------------------------------------
	//Estrutura declarada no WS Fabrica
	//------------------------------------------------
	WSDATA o_Empresa	AS strEmpresa
	WSDATA o_Retorno	AS strRetorno
	WSDATA o_Seguranca	AS strSeguranca

	WSDATA o_DadosATF	AS strDadosATF //Estrutura de Parametros do Ativo

	WSMETHOD mtdTransfBens			//Metodo para transferência do bem na mesma entidade
	WSMETHOD mtdTranBeEnt			//Metodo para transferência do bem entre entidades

ENDWSSERVICE

WSSTRUCT strDadosATF

	WSDATA c_FILDEST	AS String
	WSDATA c_FILORIG	AS String
	WSDATA c_CBASEDE	AS String
	WSDATA c_CBASEATE	AS String
	WSDATA c_ITEMDE 	AS String
	WSDATA c_ITEMATE 	AS String
	WSDATA c_GRPDE	    AS String
	WSDATA c_GRPATE	    AS String
	WSDATA c_LOCDE 	    AS String
	WSDATA c_LOCATE 	AS String
	WSDATA c_LOCDEST	AS String
	WSDATA c_DATADE	    AS String
	WSDATA c_DATAATE 	AS String
	WSDATA c_DATTRANS   AS String
ENDWSSTRUCT

/*/{Protheus.doc} mtdTransfBens
Realiza a transferência do(s) bem(s)
@author Totvs/BA 
@since Abr/2021
@version 12.1.17
/*/
WSMETHOD mtdTransfBens WSRECEIVE o_Empresa, o_Seguranca, o_DadosATF WSSEND o_Retorno WSSERVICE WS_FTRBENS

	Local o_Retorno
	Local c_Alias     := GetNextAlias()
	Local c_UserWS    := ""
	Local c_PswWS     := ""
	Local aDadosAuto  := {}		// Array com os dados a serem enviados pela MsExecAuto() para gravacao automatica
	Local aParamAuto  := {}
	Local c_Fil       := ""
	Local c_FilDest   := ""
	Local c_BemDe     := ""
	Local c_BemAte    := ""
	Local c_IteDe     := ""
	Local c_IteAte    := ""
	Local c_LcDe      := ""
	Local c_LcAte     := ""
	Local c_GrDe      := ""
	Local c_GrAte     := ""
	Local d_DtaDe     := Ctod("  /  /  ")
	Local d_DtaAte    := Ctod("  /  /  ")
	Local d_DtBaixa   := Ctod("  /  /  ")
	Local d_UltDepr	  := ""
	Local c_TipDepr	  := ""
	Local c_CalcDep	  := ""
	Local d_DtaTrans  := Ctod("  /  /  ")
	Local a_LogErro   := {}
	Local a_ErroTrat  := {}
	Local c_ErroResu  := ""
	Local i			  := 0
	Local d_DtaAnt    := Ctod("  /  /  ")

	Private lMsHelpAuto    := .T.       //Se .t. direciona as mensagens de help para o arq. de log
	Private lMsErroAuto    := .F.       //Necessário a criação, pois será atualizado quando houver alguma inconsistência nos parâmetros
	Private lAutoErrNoFile := .T.

	RpcSetType(3)
	RpcSetEnv(::o_Empresa:c_Empresa,::o_Empresa:c_Filial)

	::o_Retorno	:= WSCLASSNEW("strRetorno")
	c_UserWS	:= SUPERGETMV("FS_USUATF",,"totvs_ws")
	c_PswWS		:= SUPERGETMV("FS_SENATF",,"totvs@123")

	If ( ::o_Seguranca:c_Usuario <> c_UserWS ) .Or. ( ::o_Seguranca:c_Senha <> c_PswWS )
		::o_Retorno:l_Status  	:= .F.
		::o_Retorno:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida!"

		Return(.T.)
	EndIf

	//Testa se as filiais de Origem e Destino são da mesma Entidade(Empresa)
	If SubStr(::o_DadosATF:c_FILORIG,1,4) != SubStr(::o_DadosATF:c_FILDEST,1,4)
		::o_Retorno:l_Status   := .F.
		::o_Retorno:c_Mensagem := "Não é possível realizar a transferência de bens entre entidades diferentes!"

		Return(.T.)
	EndIf

	c_Fil      := ::o_DadosATF:c_FILORIG
	c_BemDe    := ::o_DadosATF:c_CBASEDE
	c_BemAte   := ::o_DadosATF:c_CBASEATE
	c_IteDe    := ::o_DadosATF:c_ITEMDE
	c_IteAte   := ::o_DadosATF:c_ITEMATE
	c_LcDe     := ::o_DadosATF:c_LOCDE
	c_LcAte    := ::o_DadosATF:c_LOCATE
	c_GrDe     := ::o_DadosATF:c_GRPDE
	c_GrAte    := ::o_DadosATF:c_GRPATE
	d_DtaDe    := Ctod(::o_DadosATF:c_DATADE)
	d_DtaAte   := Ctod(::o_DadosATF:c_DATAATE)
	c_FilDest  := ::o_DadosATF:c_FILDEST
	c_LcDest   := ::o_DadosATF:c_LOCDEST
	d_DtaTrans := Ctod(::o_DadosATF:c_DATTRANS)

	d_DtaAnt  := dDataBase
	dDataBase := d_DtaTrans

	dbSelectArea("SM0")
	dbSeek(::o_Empresa:c_Empresa+c_Fil)

	cFilAnt := o_Empresa:c_Filial

	BeginSQL Alias c_Alias
        SELECT DISTINCT
		    N1_CBASE,
			N1_ITEM,
            N1_LOCAL,
            N1_NFISCAL,
            N1_GRUPO,
            N1_NSERIE,
            N1_TAXAPAD,
			N1_LOCAL,
            N1_AQUISIC,
            N1_FILIAL,
            N3_FILIAL,
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
            N3_CCCDEP
			//N4_DATA

        FROM 
            %TABLE:SN1% N1

        INNER JOIN 
            %TABLE:SN3% N3
        ON
            N3.N3_FILIAL = N1.N1_FILIAL
            AND N3.N3_CBASE = N1.N1_CBASE
            AND N3.N3_ITEM = N1.N1_ITEM
            AND N3.N3_DTBAIXA = %EXP:d_DtBaixa%
            AND N3.N3_TIPO = %EXP:"01"%
            AND N3.%NOTDEL%

        /*
        INNER JOIN 
            %TABLE:SN4% N4
        ON
            N4.N4_FILIAL = N3.N3_FILIAL
            AND N4.N4_CBASE = N3.N3_CBASE
            AND N4.N4_ITEM = N3.N3_ITEM
			AND N4.N4_TIPO = N3.N3_TIPO
            AND N4.%NOTDEL%
        */
        WHERE
		    N1.N1_FILIAL = %EXP:c_Fil% AND
		    N1.N1_CBASE >= %EXP:c_BemDe% AND
		    N1.N1_CBASE <= %EXP:c_BemAte% AND
		    N1.N1_ITEM >= %EXP:c_IteDe% AND
		    N1.N1_ITEM <= %EXP:c_IteAte% AND
		    N1.N1_LOCAL >= %EXP:c_LcDe% AND
		    N1.N1_LOCAL <= %EXP:c_LcAte% AND
		    N1.N1_GRUPO >= %EXP:c_GrDe% AND
		    N1.N1_GRUPO <= %EXP:c_GrAte% AND
		    N1.N1_AQUISIC >= %EXP:d_DtaDe% AND
		    N1.N1_AQUISIC <= %EXP:d_DtaAte% AND			
            N1.%NOTDEL%

        ORDER BY
            N3.N3_FILIAL,N3.N3_CBASE,N3.N3_ITEM,N3.N3_TIPO
	EndSQL

	Pergunte("AFA060", .F.)
	// Parâmetros das perguntas da rotina atfa060
	//aAdd( aParamAuto, {"MV_PAR01", 2} ) //Pergunta 01 - Contabiliza        ? 1 = Sim ; 2 = Não
	//aAdd( aParamAuto, {"MV_PAR02", 2} ) //Pergunta 02 - Mostra Lanc Contab ? 1 = Sim ; 2 = Não
	//aAdd( aParamAuto, {"MV_PAR03", 2} ) //Pergunta 03 - Aglut Lançamentos  ? 1 = Sim ; 2 = Não
	//aAdd( aParamAuto, {"MV_PAR04", 1} ) //Pergunta 04 - Aglut Lançamentos  ? 1 = Sim ; 2 = Não

	dbSelectArea( c_Alias )
	dbGotop()
	Do While ( c_Alias )->(!Eof())

		aDadosAuto := {{'N3_CBASE'  , (c_Alias)->N1_CBASE   , Nil},;    // Código base do ativo
		{'N3_ITEM'   , (c_Alias)->N1_ITEM    , Nil},;    // Item sequencial do código bas do ativo
		{'N3_TIPO'   , (c_Alias)->N3_TIPO    , Nil},;    // Tipo do Ativo
		{'N1_FILIAL' , ::o_DadosATF:c_FILDEST, Nil},;    // Código da filial
		{'N4_DATA'   , d_DtaTrans            , Nil},;    // Data de aquisição do ativo
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
		{'N1_LOCAL'  , ::o_DadosATF:c_LOCDEST, Nil}}     // Localizacao do Bem

		If Len(aDadosAuto) > 0
			Begin Transaction
               /* 
               O quarto parâmetro pode ser configurado com os seguintes estados.
               .T. = Espelhar. 
               .F. = Atualizar. 
               */ 
				MSExecAuto({|x, y, w, z| ATFA060(x, y, w, z)},aDadosAuto, 4, aParamAuto, .F.)

				If lMsErroAuto
					a_LogErro   := GetAutoGRLog()
					a_ErroTrat  := f_TrataErro(a_LogErro)
					c_ErroResu  := ""

					For i := 1 to Len( a_ErroTrat )
						c_ErroResu += a_ErroTrat[ i ]
					Next

					//Exclusivo para a versao 12
					If (GetVersao(.F.) == "12")
						c_ErroResu :=  f_AjustaAcentos(c_ErroResu)
						SetSoapFault('Erro',c_ErroResu)
					EndIf

					::o_Retorno:l_Status   := .F.
					::o_Retorno:c_Mensagem := c_ErroResu
					DisarmTransaction()
				Else
					::o_Retorno:l_Status	 := .T.
					::o_Retorno:c_Mensagem := "Transferência do bem concluida!"
				EndIf

			End Transaction
		EndIf

		dbSelectArea( c_Alias )
		dbSkip()
	EndDo

	dDataBase := d_DtaAnt

Return(.T.)


/*/{Protheus.doc} mtdTranBeEnt
Realiza a transferência do(s) bem(s) entre as entidades
@author Totvs/BA 
@since Jul/2021
@version 12.1.17
/*/
WSMETHOD mtdTranBeEnt WSRECEIVE o_Empresa, o_Seguranca, o_DadosATF WSSEND o_Retorno WSSERVICE WS_FTRBENS
	Local o_Retorno
	Local c_Alias     := GetNextAlias()
	Local c_UserWS    := ""
	Local c_PswWS     := ""
	Local c_Fil       := ""
	Local c_FilDest   := ""
	Local c_BemDe     := ""
	Local c_BemAte    := ""
	Local c_IteDe     := ""
	Local c_IteAte    := ""
	Local c_LcDe      := ""
	Local c_LcAte     := ""
	Local c_GrDe      := ""
	Local c_GrAte     := ""
	Local d_DtaDe     := Ctod("  /  /  ")
	Local d_DtaAte    := Ctod("  /  /  ")
	Local d_DtBaixa   := Ctod("  /  /  ")
	Local d_UltDepr	  := ""
	Local c_TipDepr	  := ""
	Local c_CalcDep	  := ""
	Local d_DtaTrans  := Ctod("  /  /  ")
	Local a_LogErro   := {}
	Local a_ErroTrat  := {}
	Local c_ErroResu  := ""
	Local i			  := 0
	Local c_MetDepr   := ""
	Local c_Motivo    := ""
	Local n_QtdBaixa  := 0
	Local aCab        := {}   // Array com os dados a serem enviados pela MsExecAuto() para gravação automática
	Local aCabA       := {}   // Array com os dados a serem enviados pela MsExecAuto() para gravação automática
	Local aAtivo      := {}   // Array com os dados a serem enviados pela MsExecAuto() para gravação automática
	Local aItens      := {}   // Array com os dados a serem enviados pela MsExecAuto() para gravação automática
	Local aParam      := {}
	Local aParam1     := {}
	Local c_Base      := ""
	Local c_Baixa     := "0"
	Local cTpSaldo    := "1"
	Local d_DtaAnt    := Ctod("  /  /  ")
	Local c_cFilAnt   := ""
	Local c_cBase     := ""
	Local c_nItem     := ""
    Local n_QtdIncl   := 0
    Local n_VOrig1    := 0
    Local n_VOrig2    := 0
    Local n_VOrig3    := 0
    Local n_VOrig4    := 0
    Local n_VOrig5    := 0
	Local oModel

	Private lMsHelpAuto    := .T.       //Se .T. direciona as mensagens de help para o arq. de log
	Private lMsErroAuto    := .F.       //Necessário a criação, pois será atualizado quando houver alguma inconsistência nos parâmetros
	Private lAutoErrNoFile := .T.

	RpcSetType(3)
	RpcSetEnv(::o_Empresa:c_Empresa,::o_Empresa:c_Filial)

	c_cFilAnt := cFilAnt

	::o_Retorno	:= WSCLASSNEW("strRetorno")
	c_UserWS	:= SUPERGETMV("FS_USUATF",,"totvs_ws")
	c_PswWS		:= SUPERGETMV("FS_SENATF",,"totvs@123")

	If ( ::o_Seguranca:c_Usuario <> c_UserWS ) .Or. ( ::o_Seguranca:c_Senha <> c_PswWS )
		::o_Retorno:l_Status  	:= .F.
		::o_Retorno:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida!"

		Return(.T.)
	EndIf

	//Testa se as filiais de Origem e Destino são da mesma Entidade(Empresa)
	If SubStr(::o_DadosATF:c_FILORIG,1,4) == SubStr(::o_DadosATF:c_FILDEST,1,4)
		::o_Retorno:l_Status   := .F.
		::o_Retorno:c_Mensagem := "Só é possível realizar a transferência de bens entre entidades diferentes!"

		Return(.T.)
	EndIf

	c_Fil      := ::o_DadosATF:c_FILORIG
	c_BemDe    := ::o_DadosATF:c_CBASEDE
	c_BemAte   := ::o_DadosATF:c_CBASEATE
	c_IteDe    := ::o_DadosATF:c_ITEMDE
	c_IteAte   := ::o_DadosATF:c_ITEMATE
	c_LcDe     := ::o_DadosATF:c_LOCDE
	c_LcAte    := ::o_DadosATF:c_LOCATE
	c_GrDe     := ::o_DadosATF:c_GRPDE
	c_GrAte    := ::o_DadosATF:c_GRPATE
	d_DtaDe    := Ctod(::o_DadosATF:c_DATADE)
	d_DtaAte   := Ctod(::o_DadosATF:c_DATAATE)
	c_FilDest  := ::o_DadosATF:c_FILDEST
	c_LcDest   := ::o_DadosATF:c_LOCDEST
	d_DtaTrans := Ctod(::o_DadosATF:c_DATTRANS)

	d_DtaAnt  := dDataBase
	dDataBase := d_DtaTrans

	dbSelectArea("SM0")
	dbSeek(::o_Empresa:c_Empresa+c_Fil)

	Pergunte("AFA036",.F.)

	//Array contendo os parametros do F12
	aAdd( aParam, {"MV_PAR01", 2} ) //Pergunta 01 - Mostra Lanc. Contab? 1 = Sim ; 2 = Não
	aAdd( aParam, {"MV_PAR02", 2} ) //Pergunta 02 - Aglutina Lancamento Contabil ? 1 = Sim ; 2 = Não
	aAdd( aParam, {"MV_PAR03", 2} ) //Pergunta 03 - Contabaliza On-Line? 1 = Sim ; 2 = Não
	aAdd( aParam, {"MV_PAR04", 2} ) //Pergunta 04 - Visualização ? 2 = Tipos de Ativos   // deve se usar obrigatoriamente o número 2

	cFilAnt   := o_Empresa:c_Filial
	c_MetDepr := GetMV('MV_ATFDPBX')
	l_Executa := .T.

	BeginSQL Alias c_Alias
	 SELECT DISTINCT
		    N1_CBASE,
			N1_ITEM,
            N1_LOCAL,
            N1_NFISCAL,
            N1_GRUPO,
            N1_NSERIE,
            N1_TAXAPAD,
			N1_LOCAL,
            N1_AQUISIC,
            N1_FILIAL,
			N1_QUANTD,
			N1_CHAPA,
			N1_MARGEM,
			N1_PATRIM,
			N1_DESCRIC,
			N1_VLAQUIS,
			N1_STATUS,
			N1_NFITEM,
			N1_PRODUTO,
			N1_CSTPIS,
			N1_CSTCOFI,
			N1_ORIGCRD,
			N1_FORNEC,
			N1_LOJA,
            N3_FILIAL,
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
            N3_CCCDEP,
			N3_HISTOR,
            N3_DINDEPR,
            N3_VORIG1,
            N3_TXDEPR1,
            N3_VORIG2,
            N3_TXDEPR2,
            N3_VORIG3,
            N3_TXDEPR3,
            N3_VORIG4,
            N3_TXDEPR4,
            N3_VORIG5,
            N3_TXDEPR5,
            N3_VRDACM1,
            N3_VRDACM2, 
            N3_VRDACM3, 
            N3_VRDACM4, 
            N3_VRDACM5,
            N3_SUBCCON,
            N3_SEQ,
            N3_SEQREAV,
            N3_CLVLCON,
			N3_TPSALDO

        FROM 
            %TABLE:SN1% N1

        INNER JOIN 
            %TABLE:SN3% N3
        ON
            N3.N3_FILIAL = N1.N1_FILIAL
            AND N3.N3_CBASE = N1.N1_CBASE
            AND N3.N3_ITEM = N1.N1_ITEM
            AND N3.N3_DTBAIXA = %EXP:d_DtBaixa%
            //AND N3.N3_TIPO = %EXP:"01"%
            AND N3.%NOTDEL%

        WHERE
		    N1.N1_FILIAL = %EXP:c_Fil% AND
		    N1.N1_CBASE >= %EXP:c_BemDe% AND
		    N1.N1_CBASE <= %EXP:c_BemAte% AND
		    N1.N1_ITEM >= %EXP:c_IteDe% AND
		    N1.N1_ITEM <= %EXP:c_IteAte% AND
		    N1.N1_LOCAL >= %EXP:c_LcDe% AND
		    N1.N1_LOCAL <= %EXP:c_LcAte% AND
		    N1.N1_GRUPO >= %EXP:c_GrDe% AND
		    N1.N1_GRUPO <= %EXP:c_GrAte% AND
		    N1.N1_AQUISIC >= %EXP:d_DtaDe% AND
		    N1.N1_AQUISIC <= %EXP:d_DtaAte% AND	
			N1.N1_BAIXA = %EXP:d_DtBaixa% AND		
            N1.%NOTDEL%

        ORDER BY
            N1.N1_FILIAL,N1.N1_CBASE,N1.N1_ITEM
	EndSQL

	dbSelectArea( c_Alias )
	//getlastquery()[2]
    dbGotop()
	Do While ( c_Alias )->(!Eof())         

        c_Motivo := "04"

        DbSelectArea("SN3")
		SN3->(DbSetOrder(1))
        SN3->(DbSeek(c_Fil+c_BemDe+c_IteDe+"01"+c_Baixa+"001",.F.))

		DbSelectArea("SN1")
		SN1->(DbSetOrder(1))
        SN1->(DbSeek(c_Fil+c_BemDe+c_IteDe,.F.))

        n_QtdIncl := SN1->N1_QUANTD

		aCab := {{"FN6_FILIAL", SN1->N1_FILIAL, NIL},;
			     {"FN6_CBASE" , SN1->N1_CBASE , NIL},;
			     {"FN6_CITEM" , SN1->N1_ITEM  , NIL},;
			     {"FN6_MOTIVO", c_Motivo      , NIL},;
		 	     {"FN6_PERCBX", 100           , NIL},;
			     {"FN6_QTDBX" , SN1->N1_QUANTD, NIL},;
			     {"FN6_DTBAIX", dDatabase     , NIL},;
			     {"FN6_DEPREC", c_MetDepr     , NIL}}
			
		aAtivo := {{"N3_FILIAL" , SN1->N1_FILIAL , NIL},;
			       {"N3_CBASE"  , SN1->N1_CBASE  , NIL},;
			       {"N3_ITEM"   , SN1->N1_ITEM   , NIL},;
			       {"N3_TIPO"   , SN3->N3_TIPO   , NIL},;
			       {"N3_BAIXA"  , c_Baixa        , NIL},;
			       {"N3_TPSALDO", SN3->N3_TPSALDO, NIL}}

	    If Len(aCab) > 0
	       Begin Transaction
               __NOPER := 2
               MsExecAuto({|a,b,c,d,e,f|ATFA036(a,b,c,d,e,f)},aCab,aAtivo,3,,.T.,aParam)

  		       If lMsErroAuto
			      a_LogErro  := GetAutoGRLog()
				  a_ErroTrat := f_TrataErro(a_LogErro)
			      c_ErroResu := ""

			      For i := 1 to Len( a_ErroTrat )
				      c_ErroResu += a_ErroTrat[ i ]
			      Next

			      //Exclusivo para a versao 12
			      If (GetVersao(.F.) == "12")
				     c_ErroResu := f_AjustaAcentos(c_ErroResu)
				     SetSoapFault('Erro',c_ErroResu)
			      EndIf

			      ::o_Retorno:l_Status   := .F.
			      ::o_Retorno:c_Mensagem := c_ErroResu
			      DisarmTransaction()
		       Else
                  dbSelectArea("SM0")
                  dbSeek(::o_Empresa:c_Empresa+c_FilDest)

                  cFilAnt := c_FilDest
	              Pergunte("AFA012",.F.)

                  aParam1 := {}
                  aAdd( aParam1, {"MV_PAR01", 2} ) //Pergunta 01 - Mostra Lanc.Contab ? 1 = Sim ; 2 = Não
                  aAdd( aParam1, {"MV_PAR02", 1} ) //Pergunta 02 - Repete Chapa ? 1 = Sim ; 2 = Não
                  aAdd( aParam1, {"MV_PAR03", 1} ) //Pergunta 03 - Descrição estendida? 1 = Sim ; 2 = Não
                  aAdd( aParam1, {"MV_PAR04", 2} ) //Pergunta 04 - Copiar Valores ? 1 = Todos ; 2 = Sem Acumulados
                  aAdd( aParam1, {"MV_PAR05", 2} ) //Pergunta 03 - Descrição estendida? 1 = Sim ; 2 = Não
                  aAdd( aParam1, {"MV_PAR06", 2} ) //Pergunta 04 - Copiar Valores ? 1 = Todos ; 2 = Sem Acumulados

                  If l_Executa
				     n_VOrig1 := (c_Alias)->N3_VORIG1 - (c_Alias)->N3_VRDACM1
                     c_Base := NumBase(c_FilDest)
     
                     aCabA := {}
                     AAdd(aCabA,{"N1_FILIAL" , c_FilDest                  , NIL})
                     AAdd(aCabA,{"N1_CBASE"  , c_Base                     , NIL})
                     AAdd(aCabA,{"N1_ITEM"   , (c_Alias)->N1_ITEM         , NIL})
                     AAdd(aCabA,{"N1_AQUISIC", dDataBase                  , NIL})
                     AAdd(aCabA,{"N1_DESCRIC", (c_Alias)->N1_DESCRIC      , NIL})
                     AAdd(aCabA,{"N1_QUANTD" , (c_Alias)->N1_QUANTD       , NIL})
                     AAdd(aCabA,{"N1_CHAPA"  , c_Base                     , NIL})
                     AAdd(aCabA,{"N1_PATRIM" , (c_Alias)->N1_PATRIM       , NIL})
                     AAdd(aCabA,{"N1_GRUPO"  , (c_Alias)->N1_GRUPO        , NIL})
                     AAdd(aCabA,{"N1_MARGEM" , (c_Alias)->N1_MARGEM       , NIL})
                     AAdd(aCabA,{"N1_LOCAL"  , c_LcDest                   , NIL})
	                 AAdd(aCabA,{"N1_VLAQUIS", n_VOrig1                   , NIL}) 
 	                 AAdd(aCabA,{"N1_STATUS" , (c_Alias)->N1_STATUS       , NIL})
	                 AAdd(aCabA,{"N1_NFITEM" , (c_Alias)->N1_NFITEM       , NIL})
 	                 AAdd(aCabA,{"N1_PRODUTO", (c_Alias)->N1_PRODUTO      , NIL})
	                 AAdd(aCabA,{"N1_CSTPIS" , (c_Alias)->N1_CSTPIS       , NIL})
 	                 AAdd(aCabA,{"N1_CSTCOFI", (c_Alias)->N1_CSTCOFI      , NIL})
 	                 AAdd(aCabA,{"N1_ORIGCRD", (c_Alias)->N1_ORIGCRD      , NIL})
 	                 AAdd(aCabA,{"N1_CODBAR" , c_Base + (c_Alias)->N1_ITEM, NIL})
                     //AAdd(aCabA,{"N1_FORNEC" , (c_Alias)->N1_FORNEC     , NIL})
                     //AAdd(aCabA,{"N1_LOJA"   , (c_Alias)->N1_LOJA       , NIL})
                     //AAdd(aCabA,{"N1_SERIE"  , (c_Alias)->N1_SERIE      , NIL})
	                 //AAdd(aCabA,{"N1_NFISCAL", (c_Alias)->N1_NFISCAL    , NIL})

                     l_Executa := .F.
                  EndIf

	              dbSelectArea( c_Alias )
                  aItens  := {}
                  c_cBase := (c_Alias)->N1_CBASE
                  c_nItem := (c_Alias)->N3_ITEM

	             Do While ( c_Alias )->(!Eof()) .And. c_cBase ==  (c_Alias)->N1_CBASE ;
                    .And. c_nItem == (c_Alias)->N3_ITEM

                     If (c_Alias)->N3_VORIG1 > (c_Alias)->N3_VRDACM1
                       n_VOrig1 := (c_Alias)->N3_VORIG1 - (c_Alias)->N3_VRDACM1
					Else
				  	   n_VOrig1 := (c_Alias)->N3_VORIG1
					EndIf
 
                    If (c_Alias)->N3_VORIG2 > (c_Alias)->N3_VRDACM2
                       n_VOrig2 := (c_Alias)->N3_VORIG2 - (c_Alias)->N3_VRDACM2
					Else
				  	   n_VOrig2 := (c_Alias)->N3_VORIG2
					EndIf

                    If (c_Alias)->N3_VORIG3 > (c_Alias)->N3_VRDACM3
                       n_VOrig3 := (c_Alias)->N3_VORIG3 - (c_Alias)->N3_VRDACM3
					Else
				  	   n_VOrig3 := (c_Alias)->N3_VORIG3
					EndIf

                    If (c_Alias)->N3_VORIG4 > (c_Alias)->N3_VRDACM4
                       n_VOrig4 := (c_Alias)->N3_VORIG4 - (c_Alias)->N3_VRDACM4
					Else
				  	   n_VOrig4 := (c_Alias)->N3_VORIG4
					EndIf

                    If (c_Alias)->N3_VORIG5 > (c_Alias)->N3_VRDACM5
                       n_VOrig5 := (c_Alias)->N3_VORIG5 - (c_Alias)->N3_VRDACM5
					Else
				  	   n_VOrig5 := (c_Alias)->N3_VORIG5
					EndIf

                    //n_VOrig2 := (c_Alias)->N3_VORIG2 - (c_Alias)->N3_VRDACM2
                    //n_VOrig3 := (c_Alias)->N3_VORIG3 - (c_Alias)->N3_VRDACM3
                    //n_VOrig4 := (c_Alias)->N3_VORIG4 - (c_Alias)->N3_VRDACM4
                    //n_VOrig5 := (c_Alias)->N3_VORIG5 - (c_Alias)->N3_VRDACM5

                    AAdd(aItens,{;
                                {"N3_FILIAL" , c_FilDest            , NIL},;
                                {"N3_CBASE"  , c_Base               , NIL},;
                                {"N3_ITEM"   , (c_Alias)->N3_ITEM   , NIL},;
                                {"N3_TIPO"   , (c_Alias)->N3_TIPO   , NIL},;
                                {"N3_BAIXA"  , c_Baixa              , NIL},;
                                {"N3_HISTOR" , (c_Alias)->N3_HISTOR , NIL},;
                                {"N3_CCONTAB", (c_Alias)->N3_CCONTAB, NIL},;
                                {"N3_CUSTBEM", (c_Alias)->N3_CUSTBEM, NIL},;
                                {"N3_CDEPREC", (c_Alias)->N3_CDEPREC, NIL},;
                                {"N3_CDESP"  , (c_Alias)->N3_CDESP  , NIL},;
                                {"N3_CCORREC", (c_Alias)->N3_CCORREC, NIL},;
                                {"N3_CCUSTO" , (c_Alias)->N3_CCUSTO , NIL},;
                                {"N3_DINDEPR", dDataBase            , NIL},;
                                {"N3_VORIG1" , n_VOrig1             , NIL},;
                                {"N3_TXDEPR1", (c_Alias)->N3_TXDEPR1, NIL},;
                                {"N3_VRDACM1", 0                    , NIL},;
                                {"N3_VORIG2" , n_VOrig2             , NIL},;
                                {"N3_TXDEPR2", (c_Alias)->N3_TXDEPR2, NIL},;
                                {"N3_VRDACM2", 0                    , NIL},;
                                {"N3_VORIG3" , n_VOrig3             , NIL},;
                                {"N3_TXDEPR3", (c_Alias)->N3_TXDEPR3, NIL},;
                                {"N3_VRDACM3", 0                    , NIL},;
                                {"N3_VORIG4" , n_VOrig4             , NIL},;
                                {"N3_TXDEPR4", (c_Alias)->N3_TXDEPR4, NIL},;
                                {"N3_VRDACM4", 0                    , NIL},;
                                {"N3_VORIG5" , n_VOrig3             , NIL},;
                                {"N3_TXDEPR5", (c_Alias)->N3_TXDEPR5, NIL},;
                                {"N3_VRDACM5", 0                    , NIL},;
                                {"N3_SUBCCON", (c_Alias)->N3_SUBCCON, NIL},;
                                {"N3_SEQ"    , (c_Alias)->N3_SEQ    , NIL},;
                                {"N3_SEQREAV", (c_Alias)->N3_SEQREAV, NIL},;
                                {"N3_CLVLCON", (c_Alias)->N3_CLVLCON, NIL},;
							    {"N3_TPSALDO", (c_Alias)->N3_TPSALDO, NIL},;
                                {"N3_AQUISIC", dDataBase            , NIL}})

                    dbSelectArea( c_Alias )
                    dbSkip()
                 EndDo

                 If Len(aItens) > 0
                    //Controle de transacao
                    Begin Transaction

                        MSExecAuto({|x,y,z| ATFA012(x,y,z)},aCabA,aItens,3,aParam1)

  		                If lMsErroAuto
			               a_LogErro  := GetAutoGRLog()
				           a_ErroTrat := f_TrataErro(a_LogErro)
			               c_ErroResu := ""

			               For i := 1 to Len( a_ErroTrat )
				               c_ErroResu += a_ErroTrat[ i ]
			               Next

			               //Exclusivo para a versao 12
			               If (GetVersao(.F.) == "12")
				              c_ErroResu := f_AjustaAcentos(c_ErroResu)
				              SetSoapFault('Erro',c_ErroResu)
			               EndIf

			               ::o_Retorno:l_Status   := .F.
			               ::o_Retorno:c_Mensagem := c_ErroResu
			               DisarmTransaction()
                        Else
                           l_Executa := .F.
			               ::o_Retorno:l_Status	:= .T.
			               ::o_Retorno:c_Mensagem := "Transferência do bem "+ c_Base + " concluida!"
				        EndIf
	                 End Transaction
                 EndIf

                n_VOrig1 := 0
                n_VOrig2 := 0
                n_VOrig3 := 0
                n_VOrig4 := 0
                n_VOrig5 := 0

                 dbSelectArea("SM0")
                 dbSeek(::o_Empresa:c_Empresa+c_Fil)

                 cFilAnt   := o_Empresa:c_Filial
                 c_MetDepr := GetMV('MV_ATFDPBX')
		      EndIf
		
	        End Transaction
	    EndIf

        dbSelectArea( c_Alias )
        dbSkip()
    EndDo

	dDataBase := d_DtaAnt
	cFilant   := c_cFilAnt

Return(.T.)

/*/{Protheus.doc} f_TrataErro
funcao que realiza o tratamento da mensagem de erro
@author Totvs/BA
@since Abr/2021
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
Static Function f_TrataErro( aErr )

	Local lHelp    := .F.
	Local lAjuda   := .F.
	Local lTabela  := .F.
	Local lATFA060 := .F.
	Local cLinha   := ""
	Local aRet     := {}
	Local nI       := 0
	Local l_Importante	:= .F.
	Local lATFA012 := .F.

	For nI := 1 to LEN( aErr)

		cLinha  := UPPER( aErr[nI] )
		cLinha  := STRTRAN( cLinha,CHR(13), " " )
		cLinha  := STRTRAN( cLinha,CHR(10), " " )

		If SUBS( cLinha, 1, 10 ) == 'IMPORTANTE' .or. SUBS( cLinha, 1, 10 ) == 'Importante'
			l_Importante := .T.
		EndIf

		If SUBS( cLinha, 1, 4 ) == 'HELP' .or. SUBS( cLinha, 1, 4 ) == 'Help'
			lHelp := .T.
		EndIf

		If SUBS( cLinha, 1, 5 ) == 'AJUDA' .or. SUBS( cLinha, 1, 5 ) == 'Ajuda'
			lAjuda := .T.
		EndIf

		If SUBS( cLinha, 1, 6 ) == 'TABELA' .or. SUBS( cLinha, 1, 6 ) == 'Tabela'
			lHelp   := .F.
			lTabela := .T.
		EndIf

		If Upper(SUBS(cLinha,1,8)) == 'ERRO -->'
			lHelp := .T.
			cLinha := StrTran(cLinha,'--------------------------------------------------------------------------------','')
		EndIf

		If SUBS( cLinha, 1, 7 ) == 'ATFA060' .or. SUBS( cLinha, 1, 7 ) == 'Atfa060'
			lHelp    := .F.
			lATFA060 := .T.
		EndIf

		If SUBS( cLinha, 1, 9 ) == 'SN3DETAIL' .or. SUBS( cLinha, 1, 9 ) == 'sn3detail' .or. ;
				SUBS( cLinha, 1, 9 ) == 'SN1DETAIL' .or. SUBS( cLinha, 1, 9 ) == 'sn1detail'
			lHelp    := .F.
			lATFA012 := .T.
		EndIf

		If  lHelp .or. ( lTabela .AND. '< -- INVALIDO' $  cLinha ) .Or. lAjuda
			aAdd( aRet,  StrTran(cLinha,'< -- INVALIDO','( INVALIDO )') )
		ElseIf lTabela
			aAdd( aRet, cLinha )
		ElseIf l_Importante
			aAdd( aRet, cLinha )
		ElseIf lATFA060 .Or. lATFA012
			aAdd( aRet, cLinha )
		EndIf
		lHelp := .F.
	Next

Return aRet

/*/{Protheus.doc} NoAcentoESB
funcao que retira os acentos
@author Totvs/BA
@since Abr/2021
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
Static Function f_AjustaAcentos(cMens)

	Local _ni
	Local _s1   := "ï¿½ï¿½ï¿½ï¿½ï¿½" + "ï¿½ï¿½ï¿½ï¿½ï¿½" + "ï¿½ï¿½ï¿½ï¿½ï¿½" + "ï¿½ï¿½ï¿½ï¿½ï¿½" + "ï¿½ï¿½ï¿½ï¿½ï¿½" + "ï¿½ï¿½ï¿½ï¿½ï¿½" + "ï¿½ï¿½ï¿½ï¿½ï¿½" + "ï¿½ï¿½ï¿½ï¿½ï¿½"  + "ï¿½ï¿½ï¿½ï¿½" + "ï¿½ï¿½"
	Local _s2   := "aeiou" + "AEIOU" + "aeiou" + "AEIOU" + "aeiou" + "AEIOU" + "aeiou" + "AEIOU"  + "aoAO" + "cC"
	Local _nPos :=0
	//Local _cRet := ''

	For _ni := 1 To Len(_s1)
		IF (_nPos := At(Subs(_s1,_ni,1),cMens)) > 0
			cMens := StrTran(cMens,Subs(_s1,_ni,1),Subs(_s2,_ni,1))
		ENDIF
	Next

	cMens := StrTran( cMens, 'ï¿½', ' ')	//-- Remove o Caracter 1.'o'
	cMens := StrTran( cMens, 'ï¿½', ' ')	//-- Remove o Caracter 1.'a'
	cMens := StrTran( cMens, '&', ' ')		//-- Remove o Caracter &
	cMens := StrTran( cMens, 'ï¿½', ' ')	//-- Remove o Caracter ï¿½

	cMens := NoAcento(cMens)

Return(AllTrim(cMens))

/*/{Protheus.doc} NumBase
Função que gera o código do bem
@author Totvs/BA
@since Jul/2021
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
Static Function NumBase(c_Filial)
	Local _SN1, cQry7, c_Ret
	Local c_AliasSN1 := GetNextAlias()

	_SN1 := RetSqlName("SN1")

	cQry7 := "SELECT MAX(N1_CBASE)+1 AS NBASE "
	cQry7 := cQry7 +" FROM " + _SN1	+ " WITH (NOLOCK)"
	cQry7 := cQry7 +" WHERE D_E_L_E_T_<>'*' AND N1_FILIAL = '"+c_Filial+"' ""

	//cQry7 := ChangeQuery(cQry7)

	TCQUERY cQry7 NEW ALIAS "QRY7"

	dbSelectArea("QRY7")
	dbGotop()
	c_Ret := Alltrim(Str(QRY7->NBASE))

	dbSelectArea("QRY7")
	dbCloseArea()
Return(c_Ret)

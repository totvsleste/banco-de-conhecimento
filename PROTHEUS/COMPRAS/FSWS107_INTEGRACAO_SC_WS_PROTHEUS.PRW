#INCLUDE "TOPCONN.CH
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "TBICONN.CH"
#include "vkey.ch"
#DEFINE ENTER CHR(13)+CHR(10)

/*
Retorno
Z7_NIVEL
Z7_USER
Z7_NPFLUIG
Z7_STATUS

*/

conout("Inicia FSWS107" + Time() )

WSSERVICE WS_FSWS107 Description "<span style='color:red;'>F�brica de Software - TOTVS BA</span><br/>&nbsp;&nbsp;&nbsp;�<span style='color:red;'> WS para <b>Aprova��o/Rejei��o de SC</b>.</span>"

	WSDATA o_EmpFil	 		AS strEmpSCFil 					//Estrutura de Empresa e Filial
	WSDATA o_ParamAprov		AS strParSCAprov 				//Estrutura de Parametros da Aprova��o/Rejeicao da SC.
	WSDATA o_RetMtd			AS strRetSCMetodos				//Estrutura de retorno dos Metodos
	WSDATA o_Seguranca	 	AS strSegSC						//Estrutura de Empresa e Filial
	WSDATA o_RetUsr			AS ARRAY OF STstrRetUsuarios	//Estrutura de retorno dos Usuarios
	WSDATA cNpFluig			AS String
	WSDATA cNumSC			AS String
	WSDATA o_Prazo		 	AS strPrzSc					//Estrutura de Prazo com data e hora
	WSDATA o_BancoConhecimento AS strBancoConhecimento

	WSMETHOD mtdAprovacaoSC  //Metodo da Aprova��o da SC
	WSMETHOD mtdRetAprovadores  //Metodo da Aprova��o da PC
	WSMETHOD mtdAtualizaPrazoSc  //Metodo da Aprova��o da PC
	WSMETHOD mtdGravaBancoConhecimento  //Metodo da Aprova��o da PC

ENDWSSERVICE

WSSTRUCT strBancoConhecimento

	WSDATA a_Banco AS ARRAY OF strBanco

ENDWSSTRUCT

WSSTRUCT strBanco

	WSDATA AC9_FILENT AS STRING
    WSDATA AC9_ENTIDA AS STRING
    WSDATA AC9_CODENT AS STRING
    
	WSDATA ACB_OBJETO AS STRING
	WSDATA ACB_DESCRI AS STRING

	WSDATA LINK_OBJ AS STRING

ENDWSSTRUCT

WSSTRUCT STstrRetUsuarios

	WSDATA c_Codigo AS STRING
	WSDATA o_Temp AS STRING

ENDWSSTRUCT

WSSTRUCT strPrzSc

	WSDATA c_Data	AS STRING
	WSDATA c_Hora 	AS STRING

ENDWSSTRUCT

WSSTRUCT strSegSC

	WSDATA c_Usuario	AS STRING
	WSDATA c_Senha 		AS STRING

ENDWSSTRUCT

//Estrutura de Empresa e Filial
WSSTRUCT strEmpSCFil

	WSDATA c_Empresa 	AS STRING
	WSDATA c_Filial		AS STRING

ENDWSSTRUCT

//Estrutura de Retorno dos Metodos
WSSTRUCT strRetSCMetodos

	WSDATA l_Status			AS BOOLEAN
	WSDATA c_Mensagem		AS STRING

ENDWSSTRUCT

//Estrutura dos Parametros
WSSTRUCT strParSCAprov

	WSDATA aDADOS AS ARRAY OF strDadosAprov

ENDWSSTRUCT

//Estrutura dos dados do aprovador
WSSTRUCT strDadosAprov

	WSDATA cZ7_NIVEL		AS STRING
	WSDATA cZ7_USER			AS STRING
	WSDATA cZ7_NPFLUIG		AS STRING
	WSDATA cZ7_STATUS		AS STRING
	WSDATA cZ7_NUMSC		AS STRING

ENDWSSTRUCT

WSMETHOD mtdGravaBancoConhecimento WSRECEIVE o_EmpFil, o_BancoConhecimento WSSEND o_RetMtd WSSERVICE WS_FSWS107

	Local c_Objeto	:= ""
	Local a_DadosBC	:= o_BancoConhecimento:a_Banco
	Local nX		:= 0

	RpcSetType(3)
	RpcSetEnv(o_EmpFil:c_Empresa,o_EmpFil:c_Filial)

	For nX := 1 To Len( a_DadosBC ) Step 1

		c_Objeto	:= GetSXENum( "ACB", "ACB_CODOBJ" )

		dbSelectArea("ACB")
		RecLock("ACB",.T.)
		ACB->ACB_FILIAL	:= XFILIAL("ACB")
		ACB->ACB_CODOBJ	:= c_Objeto
		ACB->ACB_OBJETO	:= a_DadosBC[nX]:ACB_OBJETO
		ACB->ACB_DESCRI	:= a_DadosBC[nX]:ACB_DESCRI
		MsUnlock()

		dbSelectArea("AC9")
		RecLock("AC9",.T.)
		AC9->AC9_FILIAL	:= XFILIAL("AC9")
		AC9->AC9_FILENT	:= a_DadosBC[nX]:AC9_FILENT
   	 	AC9->AC9_ENTIDA	:= a_DadosBC[nX]:AC9_ENTIDA
    	AC9->AC9_CODENT	:= a_DadosBC[nX]:AC9_CODENT
    	AC9->AC9_CODOBJ	:= c_Objeto
		MsUnlock()

		ConfirmSX8()

		conout(a_DadosBC[nX]:LINK_OBJ)
		shellExecute("Browser", a_DadosBC[nX]:LINK_OBJ, "", "", 1 )

	Next nX

	::o_RetMtd:l_Status		:= .T.
	::o_RetMtd:c_Mensagem	:= "Processo executado!!!"

Return(.T.)

WSMETHOD mtdAprovacaoSC WSRECEIVE o_EmpFil, o_ParamAprov WSSEND o_RetMtd WSSERVICE WS_FSWS107

	::o_RetMtd	:= WSCLASSNEW("strRetSCMetodos")
    lRet := .F.
	//��������������������������������������������������������������Ŀ
	//| Abertura do ambiente                                         |
	//����������������������������������������������������������������
	RpcSetType(3)
	RpcSetEnv(o_EmpFil:c_Empresa,o_EmpFil:c_Filial)
	aAprovadores := o_ParamAprov:aDADOS
	If !empty(aAprovadores)
    	For _I := 1 to len(aAprovadores)

			cZ7NIVEL	:=	aAprovadores[_I]:cZ7_NIVEL
			cZ7USER		:=	aAprovadores[_I]:cZ7_USER
			cZ7NPFLUIG	:=	aAprovadores[_I]:cZ7_NPFLUIG
			cZ7STATUS	:=	aAprovadores[_I]:cZ7_STATUS
			cZ7DOC		:=	aAprovadores[_I]:cZ7_NUMSC

			lRet := u_FP107A(cZ7NIVEL, cZ7USER, cZ7NPFLUIG, cZ7STATUS, cZ7DOC, .T., o_EmpFil:c_Filial) //aprova��o SC
    	Next
	Endif

	::o_RetMtd:l_Status		:= lRet
	::o_RetMtd:c_Mensagem	:= "Processo executado"

RETURN(.T.)

WSMETHOD mtdRetAprovadores WSRECEIVE o_EmpFil, cNumSC, cNpFluig  WSSEND o_RetUsr WSSERVICE WS_FSWS107

	Local c_Sql := ""

	//| Abertura do ambiente                                         |
	RpcSetType(3)
	RpcSetEnv(o_EmpFil:c_Empresa,o_EmpFil:c_Filial)

	c_Sql := GqryAprSC( cNumSC, cNpFluig)

	c_Sql 	:= ChangeQuery(c_Sql)
	cAlias 	:= GetNextAlias()
	DbUseArea(.T., "TOPCONN", TcGenQry(,,c_Sql), cAlias, .T., .T.)

	dbSelectArea(cAlias)
	dbGoTop()
	While !Eof()
		o_Temp:= WSCLASSNEW("STstrRetUsuarios")
		o_Temp:c_Codigo	:= (cAlias)->Z7_USER
		o_Temp:c_Nivel	:= (cAlias)->Z7_NIVEL
		AADD(Self:o_RetUsr, o_Temp)
		dbSkip()
	Enddo
	dbCloseArea(cAlias)

RETURN(.T.)

WSMETHOD mtdAtualizaPrazoSc WSRECEIVE o_EmpFil, o_Prazo, cNumSC, cNpFluig  WSSEND o_RetMtd WSSERVICE WS_FSWS107

	Local c_Sql := ""

	//| Abertura do ambiente                                         |
	RpcSetType(3)
	RpcSetEnv(o_EmpFil:c_Empresa,o_EmpFil:c_Filial)

	BeginSql Alias 'SUBQRY'

		SELECT
		 Z7_REC = SZ7.R_E_C_N_O_
		 ,*
		   FROM %Table:SZ7% SZ7
		   WHERE SZ7.%NOTDEL%
		   AND Z7_STATUS = %EXP:'4'%
		   AND Z7_NPFLUIG = %EXP:cNpFluig%
		   AND Z7_NUMSC = %EXP:cNumSC%
		   ORDER BY Z7_FILENT, Z7_NUMSC, Z7_NIVEL, Z7_USERORI

	EndSql

	dbSelectArea("SUBQRY")
	SUBQRY->(dbGoTop())
	While SUBQRY->(!Eof())

	 	dbSelectArea("SZ7")
		dbSetOrder(1)
   		If dbSeek(xFilial("SZ7") + SUBQRY->Z7_FILENT + SUBQRY->Z7_NUMSC + SUBQRY->Z7_NIVEL + SUBQRY->Z7_USER + SUBQRY->Z7_NIVEL +SUBQRY->Z7_STATUS, .T. )

   			 dbSelectArea("SZ7")

 			If RecLock("SZ7",.F.) .AND.;
				SZ7->Z7_FILIAL + SZ7->Z7_FILENT + SZ7->Z7_NUMSC + SZ7->Z7_NIVEL + SZ7->Z7_USER + SZ7->Z7_NIVEL +SZ7->Z7_STATUS == SZ7->(xFilial("SZ7")) + SUBQRY->Z7_FILENT + SUBQRY->Z7_NUMSC + SUBQRY->Z7_NIVEL + SUBQRY->Z7_USER + SUBQRY->Z7_NIVEL +SUBQRY->Z7_STATUS

       			SZ7->Z7_DTMAPR    := CTOD(o_Prazo:c_Data)
       			SZ7->Z7_HRMAPR    := o_Prazo:c_Hora

       			MsUnlock()

 			Else
       			conout("Registro nao encontrado, chave (Filial + Filial Entrega + Numero da SC + Nivel + ID Usuario aprovador): "+xFilial("SZ7") + " - " + SUBQRY->Z7_FILENT  + " - " +  SUBQRY->Z7_NUMSC  + " - " +  SUBQRY->Z7_NIVEL  + " - " +  SUBQRY->Z7_USER )
			Endif
		Endif

		SUBQRY->(dbSkip())

	Enddo

	SUBQRY->(dbCloseArea())

	::o_RetMtd:l_Status		:= .T.
	::o_RetMtd:c_Mensagem	:= "Processo executado"

RETURN(.T.)


//=========================================================================================================
// Rotina de aprova��o ou Rejei��o de registros de aprova�a� de Solicita��o de compras
// Autor: Eduardo Arcieri e Claudio Santos
// Em: 06/05/2016
// Par�metros:
//             	Nivel			: 	Nivel do usu�rio aprovador de 1 - 9
//				Id usuario		:	Id do usu�rio aprovador
//				Id Fluig		:	Solicita��o associada ao fluig que identifica o documento de SC,
//									esse par�metro deve ser informado apenas quando a execu��o partir
//									do fluig.
//				Status			:	Status da movimenta��o [1]Aprovado e [2]Rejeitado
//				Documento		:	Deve ser preenchido apenas quado a oriem da execu��o for do protheus
//				Executado		:	[.T.]Executado a partir do fluig e [.F.] Executado do protheus.
//=========================================================================================================
User Function FP107A(cNivel, cUser, cNPFLUIG, cSTATUS, cDOC, lExec, _cFilial) //aprova��o
Local _lRet := 	.T.
Local cUpd	:=	""

cUpd	+=	" UPDATE "+RETSQLNAME("SZ7")+ " SET " +ENTER
cUpd	+=	" Z7_STATUS = '"+IIF(VALTYPE(cSTATUS)=="C", cSTATUS, Alltrim(Str(cSTATUS)))+"' "+ENTER
cUpd	+=	" ,Z7_DTAPR	= '"+Dtos(date())+"' "+ENTER
cUpd	+=	" ,Z7_HRAPR	= '"+time()+"' "	  +ENTER
cUpd	+=	" WHERE " +ENTER
cUpd	+=	" Z7_FILIAL = '"+ _cFilial +"' " +ENTER
cUpd	+=	" AND	(Z7_STATUS = '0' OR Z7_STATUS = '4') " +ENTER
If cSTATUS == "1" //Aprova��o
	cUpd	+=	" AND Z7_NIVEL 		= '"+cNivel		+"' " +ENTER
	cUpd	+=	" AND Z7_USER  		= '"+cUser 		+"' " +ENTER
Endif
If lExec
	cUpd	+=	" AND Z7_NPFLUIG  	= '"+cNPFLUIG 	+"' " +ENTER
Else
	cUpd	+=	" AND Z7_NUMSC  	= '"+cDOC	 	+"' " +ENTER
Endif

nRetorno := TCSQLExec(cUpd)

If nRetorno <> 0
	If !lExec
		cMens += "Erro no update, tabela SZ7 - aprovdores de SC, rotina FSWS107, fun��o FP107A, informe ao Administrador do sistema."	+ENTER
		Alert(cMens)
	Endif

	_lRet	:=	.F.

Endif

If _lRet .And. cSTATUS == "1" //Verifica se a solicita��o de compras j� pode ser liberada e a libera se for o caso.

	LiberaSC(cNPFLUIG, cSTATUS, cDOC, lExec)

ElseIf _lRet .And. cSTATUS == "2" //Rejeicao
	RejeitaSC(cNPFLUIG, cSTATUS, cDOC, lExec)

Endif

Return(_lRet)

//=========================================================================================================
// Rotina de aprova��o ou Rejei��o de Solicita��o de compras
// Autor: Eduardo Arcieri e Claudio Santos
// Em: 06/05/2016
// Par�metros:
//             	Nivel			: 	Nivel do usu�rio aprovador de 1 - 9
//				Id usuario		:	Id do usu�rio aprovador
//				Id Fluig		:	Solicita��o associada ao fluig que identifica o documento de SC,
//									esse par�metro deve ser informado apenas quando a execu��o partir
//									do fluig.
//				Status			:	Status da movimenta��o [1]Aprovado e [2]Rejeitado
//				Documento		:	Deve ser preenchido apenas quado a oriem da execu��o for do protheus
//				Executado		:	[.T.]Executado a partir do fluig e [.F.] Executado do protheus.
//=========================================================================================================
Static Function LiberaSC(_cNPFLUIG, _cSTATUS, _cDOC, _lExec)
Local	cSql	:=	""
Local 	nReg	:=	1
Local 	cUpd2	:=	""

cSql += " SELECT REG = ISNULL(COUNT(*), 0) FROM "+RETSQLNAME("SZ7")+" SZ7 " +ENTER
cSql += " WHERE " +ENTER
cSql += " Z7_FILIAL = '"+xFILIAL("SZ7")+"' " +ENTER
cSql += " AND	(Z7_STATUS = '0' OR Z7_STATUS = '4') " +ENTER
If _lExec
	cSql	+=	" AND Z7_NPFLUIG  	= '"+_cNPFLUIG 	+"' " +ENTER
Else
	cSql	+=	" AND Z7_NUMSC  	= '"+cDOC	 	+"' " +ENTER
Endif

cSql 	:= 	ChangeQuery(cSql)
cAlias 	:= 	GetNextAlias()
DbUseArea(.T., "TOPCONN", TcGenQry(,,cSql), cAlias, .T., .T.)
dbSelectArea(cAlias)
(cAlias)->(dbGoTop())
If (cAlias)->(!Eof())
	nReg	:=	(cAlias)->REG
Endif
(cAlias)->(dbCloseArea())

If nReg == 0 //n�o h� mais nenhum registro em aprova��o

	If _lExec
		cNUMSC	:=	fPesqDoc(_cNPFLUIG) //Retorna numero do documento da SC associado ao numero do processo no Fluig.
	Else
		cNUMSC	:=	_cDOC
	Endif

	cUpd2	+=	" UPDATE "+RETSQLNAME("SC1")+ " SET " +ENTER
	cUpd2	+=	" C1_APROV = 'L' "+ENTER
	If SC1->(FieldPos("C1_FSAPROV") ) > 0
		cUpd2	+=	",C1_FSAPROV = 'L' "+ENTER
	Endif
	cUpd2	+=	" WHERE " +ENTER
	cUpd2	+=	" 		C1_FILIAL 	= 	'"+xFILIAL("SC1")+"' " 	+ENTER
	cUpd2	+=	" AND	C1_NUM		=	'"+cNUMSC+"' " 			+ENTER

	nRetorno := TCSQLExec(cUpd2)

	If nRetorno <> 0
		If !lExec
			cMens += "Erro no update, tabela SZ7 - aprovdores de SC, rotina FSWS107, fun��o LiberaSC, informe ao Administrador do sistema."			+ENTER
			Alert(cMens)
		Endif

		_lRet	:=	.F.

	Endif



Endif

Return

//--------------------------------------------------------
//Pesquisa documento da SC na SZ7 - Aprovadores SC
//--------------------------------------------------------
Static Function fPesqDoc(_cNPFLUIG)
_Doc := ""
cSql2:= ""
cSql2 	+= " SELECT TOP 1 Z7_NUMSC FROM "+RETSQLNAME("SZ7")+" SZ7 " +ENTER
cSql2 	+= " WHERE " +ENTER
cSql2 	+= " 		Z7_STATUS = '1' " +ENTER
cSql2	+=	" AND 	Z7_NPFLUIG  	= '"+_cNPFLUIG+"' " +ENTER

cSql2 	:= 	ChangeQuery(cSql2)
cAlias2 := 	GetNextAlias()
DbUseArea(.T., "TOPCONN", TcGenQry(,,cSql2), cAlias2, .T., .T.)
dbSelectArea(cAlias2)
(cAlias2)->(dbGoTop())
If (cAlias2)->(!Eof())
	_Doc	:=	(cAlias2)->Z7_NUMSC
Endif
(cAlias2)->(dbCloseArea())

Return(_Doc)
//-----------------------------------------------------------

Static Function GqryAprSC(cNumSc, cNpFluig) //Cabe�alho e Usu�rios Aprovadores
local	cSql	:=	""
cSql	+=	" SELECT * "													+ENTER
cSql	+=	" FROM "+RETSQLNAME("SZ7")+ " SZ7 "								+ENTER
cSql	+=	" WHERE SZ7.D_E_L_E_T_ = '' "									+ENTER
cSql	+=	" AND Z7_STATUS  = '4' "										+ENTER
cSql	+=	" AND Z7_NUMSC   = '"+ cNumSc +"' "								+ENTER
cSql	+=	" AND Z7_NPFLUIG = '"+ cNpFluig +"' "							+ENTER
cSql	+=	" ORDER BY "													+ENTER
cSql	+=	" SZ7.Z7_DTINC "												+ENTER
cSql	+=	",SZ7.Z7_HRINC "												+ENTER
cSql	+=	",SZ7.Z7_FILIAL "												+ENTER
cSql	+=	",SZ7.Z7_FILENT "												+ENTER
cSql	+=	",SZ7.Z7_NUMSC "												+ENTER
cSql	+=	",SZ7.Z7_NIVEL "												+ENTER
cSql	+=	",SZ7.Z7_USER "													+ENTER

Return(cSql)

/*/{Protheus.doc} RejeitaSC
//TODO Descri��o auto-gerada.
@author carlo
@since 21/06/2017
@version undefined

@type function
/*/
Static Function RejeitaSC(_cNPFLUIG, _cSTATUS, _cDOC, _lExec)
Local 	nReg	:=	1
Local 	cUpd2	:=	""

If _lExec
	cNUMSC	:=	fPesqDoc(_cNPFLUIG) //Retorna numero do documento da SC associado ao numero do processo no Fluig.
Else
	cNUMSC	:=	_cDOC
Endif

If SC1->(FieldPos("C1_FSAPROV") ) > 0
	cUpd2	+=	" UPDATE "+RETSQLNAME("SC1")+ " SET " +ENTER
	cUpd2	+=	" C1_FSAPROV = 'R' "+ENTER
	cUpd2	+=	" WHERE " +ENTER
	cUpd2	+=	" 		C1_FILIAL 	= 	'"+xFILIAL("SC1")+"' " 	+ENTER
	cUpd2	+=	" AND	C1_NUM		=	'"+cNUMSC+"' " 			+ENTER

	nRetorno := TCSQLExec(cUpd2)

	If nRetorno <> 0
		If !lExec
			cMens += "Erro no update, tabela SC1 - SC, rotina FSWS107, fun��o RejeitaSC, informe ao Administrador do sistema."			+ENTER
			Alert(cMens)
		Endif

		_lRet	:=	.F.

	Endif

Endif

conout("Finaliza FSWS107" + Time() )

Return

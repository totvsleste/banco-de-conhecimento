//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include "TOPCONN.CH"
#include "vkey.ch"
#DEFINE ENTER CHR(13)+CHR(10)
/*
C1-APROV
"L"//Liberado
"R"//Rejeitado
"B"//Bloqueado
*/
/*/{Protheus.doc} MT120GRV
//ponto de entrada na gravacao final do pedido de compras
@author carlo
@since 11/02/2017
@version undefined

@type function
/*/
User Function MT120GRV
Local cNum  		:= PARAMIXB[1]
Local lInclui  		:= PARAMIXB[2]
Local lAltera 		:= PARAMIXB[3]
Local lExclui 		:= PARAMIXB[4]
Local _aArea 		:= 	GetArea()
Local lRet 			:=	.T.//..customizacao do cliente
Local c_PosGCT		:=	0
Local c_FSGCT		:=	"N" //Pedido gerado por medicao S/N
//Alteracoes efetuadas por Francisco
//Em: 18.11.2016
//Motivo: Gravacao de Log
Local o_Explorer	:= clsExplorer():New()
Local c_Log			:= "PONTO DE ENTRADA: MT120GRV"
Local c_Arquivo		:= o_Explorer:mtdGravaLog( c_Log )
Local c_CamLog		:= SuperGetMv( "FS_LOG_PE" , .F. , "C:\TOTVS\LOGS\" )
Local c_Time		:= SUBSTR(TIME(), 1, 2) + SUBSTR(TIME(), 4, 2) + SUBSTR(TIME(), 7, 2)

Public lAprovPC		:=	SUPERGetMV("FS_ALCSC7",.F.,.T.) //Fluxo de Aprova��o PC .T. = Ativado .F. = N�o ativado
Public lBloqueiaPC	:=	.F.

//Adicionado em 15/02/2017 para permitir integracao com GCT - gestao de contratos
If	CNB->(FieldPos("C7_FSGCT") ) > 0 .And. Len(ACOLS) > 0
	c_PosGCT	:=	ascan(AHEADER, {|x|, x[2] = "C7_FSGCT" 	} )
	If nPosGCT > 0
		c_FSGCT	:=	ACOLS[1][c_PosGCT]
	Endif
Endif
//fim


If c_FSGCT == "N" //Pedido gerado por compras //Condição inserida em 15/02/2017 para atender a regra de negocio onde, pedidos gerados pelo GCT não são bloqueados e nem enviados para aprovação via fluig.

	If !o_Explorer:mtdExistePasta( c_CamLog )

		if !o_Explorer:mtdCriaPasta( c_CamLog )

			o_Explorer:mtdEditaLog(c_Arquivo, "Falha ao tentar a criar pasta " +  c_CamLog + ". Procure o setor de TI!" )

		EndIf

	EndIf

	o_Explorer:mtdEditaLog(c_Arquivo, "Variavel lExclui -> " + cValToChar(lExclui) )

	If lExclui
		dbSelectArea("SC1")
		dbSetOrder(6) //C1_FILIAL+ C1_PEDIDO+ C1_ITEMPED+ C1_PRODUTO
		If DbSeek(xFilial("SC1")+cNum,.T.)
			While SC1->C1_FILIAL == xFILIAL("SC1") .AND. SC1->C1_PEDIDO = cNum

				lCotacao:=	Iif(Empty(C1_COTACAO)	,.F., .T.)
				lPedido :=  Iif(Empty(C1_PEDIDO)	,.F., .T.)
				lItem	:=	Iif(Empty(C1_ITEMPED)	,.F., .T.)
				lQuje	:=	Iif(Empty(C1_QUJE)		,.F., .T.)

				//Alteracoes efetuadas por Francisco
				//Em: 18.11.2016
				//Motivo: Gravacao de Log
				o_Explorer:mtdEditaLog(c_Arquivo, "Variavel lCotacao -> " + cValToChar(lCotacao) )
				o_Explorer:mtdEditaLog(c_Arquivo, "Variavel lPedido -> " + cValToChar(lPedido) )
				o_Explorer:mtdEditaLog(c_Arquivo, "Variavel lItem -> " + cValToChar(lItem) )
				o_Explorer:mtdEditaLog(c_Arquivo, "Variavel lQuje -> " + cValToChar(lQuje) )


				If lCotacao .And. lPedido .And. lItem

					//Alteracoes efetuadas por Francisco
					//Em: 18.11.2016
					//Motivo: Gravacao de Log
					o_Explorer:mtdEditaLog(c_Arquivo, "Gravando C1_QUJE..." )

					Reclock("SC1", .F.)
						C1_QUJE		:=	Iif(lQuje	, 0	,	SC1->C1_QUJE)
					msUnlock()

					//Alteracoes efetuadas por Francisco
					//Em: 18.11.2016
					//Motivo: Gravacao de Log
					o_Explorer:mtdEditaLog(c_Arquivo, "Apos gravacao de C1_QUJE" )

				Endif
				dbSkip()
			Enddo
		Endif
	Endif

	//Alteracoes efetuadas por Francisco
	//Em: 18.11.2016
	//Motivo: Gravacao de Log
	o_Explorer:mtdEditaLog(c_Arquivo, "Variavel lAprovPC -> " + cValToChar(lAprovPC) )

	//Fluxo de Aprovacao 18/04/16
	If lAprovPC
		//Alteracoes efetuadas por Francisco
		//Em: 18.11.2016
		//Motivo: Gravacao de Log
		o_Explorer:mtdEditaLog(c_Arquivo, "Variavel lInclui -> " + cValToChar(lInclui) )

		dbSelectArea("SC7")

		_aPedido := {}

		If !lInclui //Alteracao ou Exclusao
			_cSql	:=	""
			_cSql	+=	"SELECT " 												+ENTER
			_cSql	+=	" Z8_FILIAL	= C7_FILIAL	"								+ENTER
			_cSql	+=	",Z8_FILENT	= C7_FILENT	"								+ENTER
			_cSql	+=	",Z8_NUMPC	= C7_NUM	"								+ENTER
			_cSql	+=	",Z8_VALORPC	= SUM((C7_TOTAL + C7_VALIPI + C7_VALFRE + C7_DESPESA + C7_SEGURO) - C7_VLDESC)	"				+ENTER
			_cSql	+=	"FROM "+RETSQLNAME("SC7")+" SC7 " 						+ENTER
			_cSql	+=	"WHERE " 												+ENTER
			_cSql	+=	"	SC7.D_E_L_E_T_		=	'' " 						+ENTER
			_cSql	+=	"AND C7_FILIAL			=	'"+xFILIAL("SC7")+"' "		+ENTER
			_cSql	+=	"AND C7_NUM				=	'"+cNum+"' "				+ENTER
			_cSql	+=	"GROUP BY C7_FILIAL, C7_FILENT, C7_NUM " 				+ENTER
			TCQUERY _cSql NEW ALIAS "QRY"

			//Alteracoes efetuadas por Francisco
			//Em: 18.11.2016
			//Motivo: Gravacao de Log
			o_Explorer:mtdEditaLog(c_Arquivo, "Query 1 -> " + _cSql )

			/*_cSql := ChangeQuery(_cSql)
			cAliasSC7 := GetNextAlias()
			DbUseArea(.T., "TOPCONN", TcGenQry(,,_cSql), cAliasSC7, .T., .T.)

			dbSelectArea(cAliasSC7)*/

			QRY->(dbGoTop())
			If QRY->(!Eof()) .And. !Empty(QRY->Z8_VALORPC)
				//Alteracoes efetuadas por Francisco
				//Em: 18.11.2016
				//Motivo: Gravacao de Log
				o_Explorer:mtdEditaLog(c_Arquivo, "Montagem do vetor _aPedido -> " + "[" + Z8_FILIAL + "]" + "[" + Z8_FILENT + "]" + "[" + Z8_NUMPC + "]" + "[" + Alltrim( Str( Z8_VALORPC ) ) + "]" )

				//Inserido em 25/01/2017 - Eduardo Arcieri
				c_Prazo	:=	f_Prioridade(QRY->Z8_FILIAL, QRY->Z8_FILENT, QRY->Z8_NUMPC)
				//Fim

				AADD(_aPedido,{QRY->Z8_FILIAL, QRY->Z8_FILENT, QRY->Z8_NUMPC, QRY->Z8_VALORPC,c_Prazo}) //ULTIMO PARAMETRO INSERIDO EM 25/01/2017 - eduardo arcieri
			EndIF
			QRY->(dbCloseArea())
		ElseIf lInclui //Inclus�o
			nZ8VALORPC 	:= 	0
		    nTotProd 	:= 	aVALORES[1]
			nDescProd 	:= 	aVALORES[2]
			nTotFrete 	:= 	aVALORES[3]
			nTotDesp 	:= 	aVALORES[4]
			nTotSeguro 	:= 	aVALORES[7]
			nTotIpi		:=	0
			nTotIcms 	:= 	0

			//Alteracoes efetuadas por Francisco
			//Em: 18.11.2016
			//Motivo: Gravacao de Log
			o_Explorer:mtdEditaLog(c_Arquivo, "Variavel nTotProd -> " + Alltrim( Str( nTotProd ) ) )
			o_Explorer:mtdEditaLog(c_Arquivo, "Variavel nDescProd -> " + Alltrim( Str( nDescProd ) ) )
			o_Explorer:mtdEditaLog(c_Arquivo, "Variavel nTotFrete -> " + Alltrim( Str( nTotFrete ) ) )
			o_Explorer:mtdEditaLog(c_Arquivo, "Variavel nTotDesp -> " + Alltrim( Str( nTotDesp ) ) )
			o_Explorer:mtdEditaLog(c_Arquivo, "Variavel nTotSeguro -> " + Alltrim( Str( nTotSeguro ) ) )


	        For _I := 1 to len(aVALORES[9])
				nTotIpi		+=	Iif(aVALORES[9][_I][6] = "IPI", aVALORES[9][_I][5], 0)
				nTotIcms 	+= 	Iif(aVALORES[9][_I][6] = "ICM", aVALORES[9][_I][5], 0)

				//Alteracoes efetuadas por Francisco
				//Em: 18.11.2016
				//Motivo: Gravacao de Log
				o_Explorer:mtdEditaLog(c_Arquivo, "Variavel nTotIpi -> " + Alltrim( Str( nTotIpi ) ) )
				o_Explorer:mtdEditaLog(c_Arquivo, "Variavel nTotIcms -> " + Alltrim( Str( nTotIcms ) ) )

	        Next
			nTotalNota 		:= 	(nTotProd + nTotIpi + nTotFrete + nTotDesp + nTotSeguro) - nDescProd
			nZ8VALORPC		:=	nTotalNota

			//Alteracoes efetuadas por Francisco
			//Em: 18.11.2016
			//Motivo: Gravacao de Log
			o_Explorer:mtdEditaLog(c_Arquivo, "Variavel nTotalNota -> " + Alltrim( Str( nTotalNota ) ) )
			o_Explorer:mtdEditaLog(c_Arquivo, "Variavel nZ8VALORPC -> " + Alltrim( Str( nZ8VALORPC ) ) )
			o_Explorer:mtdEditaLog(c_Arquivo, "Montagem do vetor _aPedido -> " + "[" + M->cFILIALENT + "]" + "[" + cNum + "]" + "[" + Alltrim( Str( nZ8VALORPC ) ) + "]" )

			//Inserido em 25/01/2017 - Eduardo Arcieri
			c_Prazo	:=	f_Prioridade(xFILIAL("SC7"), M->cFILIALENT, cNum)
			//Fim

			AADD(_aPedido,{xFILIAL("SC7"), M->cFILIALENT, cNum, nZ8VALORPC,c_Prazo}) //ULTIMO PARAMETRO INSERIDO EM 25/01/2017 - eduardo arcieri
		Endif
		_aAprovadores := {}

		//Alteracoes efetuadas por Francisco
		//Em: 18.11.2016
		//Motivo: Gravacao de Log
		o_Explorer:mtdEditaLog(c_Arquivo, "Quantidade de registros da _aPedido -> " + Alltrim( Str( Len( _aPedido ) ) ) )

		If !Empty(_aPedido)
			_cSql	:=	""
			_cSql	+=	"SELECT * " 														+ENTER
			_cSql	+=	"FROM "+RETSQLNAME("SZ6")+" SZ6 " 									+ENTER
			_cSql	+=	"WHERE " 															+ENTER
			_cSql	+=	"	SZ6.D_E_L_E_T_		=	'' " 									+ENTER
			_cSql	+=	"AND Z6_FILIAL			=	'"+_aPedido[1][2]+"' " 					+ENTER
			_cSql	+=	"AND Z6_VLMIN 			< 	"+Alltrim(Str(_aPedido[1][4]))+" " 		+ENTER
			_cSql	+=	"AND Z6_MSBLQL			<>	'1' " 									+ENTER
			_cSql	+=	"ORDER BY Z6_NIVEL, Z6_USER " 										+ENTER

			_cSql := ChangeQuery(_cSql)
			cAliasSZ6 := GetNextAlias()
			DbUseArea(.T., "TOPCONN", TcGenQry(,,_cSql), cAliasSZ6, .T., .T.)

			dbSelectArea(cAliasSZ6)
			dbGoTop()
			While !Eof()

				AADD(_aAprovadores,{Z6_VISTO, Z6_NIVEL, Z6_USER})

				//Alteracoes efetuadas por Francisco
				//Em: 18.11.2016
				//Motivo: Gravacao de Log
				o_Explorer:mtdEditaLog(c_Arquivo, "Montagem do vetor _aAprovadores -> " + "[" + Z6_VISTO + "]" + "[" + Z6_NIVEL + "]" + "[" + Z6_USER + "]" )

				dbSkip()
			Enddo
			dbCloseArea(cAliasSZ6)
		Endif
	Endif

	//Alteracoes efetuadas por Francisco
	//Em: 18.11.2016
	//Motivo: Gravacao de Log
	o_Explorer:mtdEditaLog(c_Arquivo, "Variavel lAprovPC -> " + cValToChar(lAprovPC) )
	o_Explorer:mtdEditaLog(c_Arquivo, "Variavel lExclui -> " + cValToChar(lExclui) )
	o_Explorer:mtdEditaLog(c_Arquivo, "Variavel lAltera -> " + cValToChar(lAltera) )
	o_Explorer:mtdEditaLog(c_Arquivo, "Variavel _aAprovadores qtd registros -> " + Alltrim( Str( Len( _aAprovadores ) ) ) )

	//Exclus�o no registro de Aprova��o (cancelamento)
	lExcluido := .F.
	If lAprovPC .And. (lExclui .Or. lAltera) .And. !Empty(_aAprovadores) //.And. !Empty(_aPedido)
		cUpd	:=	" UPDATE "+RETSQLNAME("SZ8")+" SET Z8_STATUS = '3' " 	+ENTER
		cUpd	+=	" WHERE D_E_L_E_T_ = '' "								+ENTER
		cUpd	+=	" AND Z8_FILIAL = '"+xFilial("SZ8")+"' "				+ENTER
		cUpd	+=	" AND Z8_NUMPC	=	'"+cNum+"' "						+ENTER
		cUpd	+=	" AND Z8_STATUS IN 	('0',"								+ENTER //0-Pendente
		cUpd	+=						"'1',"								+ENTER //1-Aprovado
		cUpd	+=						"'2',"								+ENTER //2-Rejeitado
		cUpd	+=						"'4')"								+ENTER //4-SC Enviada Fluig
		nRetorno:= TCSQLExec(cUpd)
		If 	nRetorno < 0
			Alert("Erro na atualiza��o do banco de dados, cancelamento (exclusao do registro anterior de aprova��o, favor informar ao setor de TI, fonte MT120GRV.")

			//Alteracoes efetuadas por Francisco
			//Em: 18.11.2016
			//Motivo: Gravacao de Log
			o_Explorer:mtdEditaLog(c_Arquivo, "Erro no UPDATE: " + cUpd )

			Return(.F.)
		Else
			lExcluido := .T.
		Endif
	Endif

	//Alteracoes efetuadas por Francisco
	//Em: 18.11.2016
	//Motivo: Gravacao de Log
	o_Explorer:mtdEditaLog(c_Arquivo, "Variavel lAprovPC 	-> " + cValToChar(lAprovPC) 	)
	o_Explorer:mtdEditaLog(c_Arquivo, "Variavel lInclui 	-> " + cValToChar(lInclui) 		)
	o_Explorer:mtdEditaLog(c_Arquivo, "Variavel lAltera 	-> " + cValToChar(lAltera) 		)
	o_Explorer:mtdEditaLog(c_Arquivo, "Variavel lExcluido 	-> " + cValToChar(lExcluido) 	)
	o_Explorer:mtdEditaLog(c_Arquivo, "Variavel _aAprovadores qtd registros -> " + Alltrim( Str( Len( _aAprovadores ) ) ) )
	o_Explorer:mtdEditaLog(c_Arquivo, "Variavel _aPedido qtd registros -> " + Alltrim( Str( Len( _aPedido ) ) ) )

	//Inclusao no registro de aprova��o
	lBloqueiaPC := .F.
	If lAprovPC .And. (lInclui .Or. (lAltera .And. lExcluido)) .And. !Empty(_aAprovadores) .And. !Empty(_aPedido)
		For _I := 1 to len(_aAprovadores)

			//Alteracoes efetuadas por Francisco
			//Em: 18.11.2016
			//Motivo: Gravacao de Log
			o_Explorer:mtdEditaLog(c_Arquivo, "Atualizando SZ8" )

			RecLock( "SZ8", .t. )
				Z8_FILIAL	:=	_aPedido[1][1]
				Z8_FILENT	:=	_aPedido[1][2]
				Z8_NUMPC	:=	_aPedido[1][3]
				Z8_VISTO	:=	_aAprovadores[_I][1]
				Z8_NIVEL	:=	_aAprovadores[_I][2]
				Z8_USER		:=	_aAprovadores[_I][3]
				Z8_VALORPC	:=	_aPedido[1][4]
				Z8_DTINC	:=	dDatabase
				Z8_HRINC	:=	SubStr(Time(),1,2)+SubStr(Time(),4,2)+SubStr(Time(),6,2)
				Z8_STATUS	:=	"0" //Pendente
				//inserido em 25/01/2017 - eduardo arcieri
				Z8_USERORI 	:=	_aAprovadores[_I][3]
				Z8_PRAZO   	:=	_aPedido[1][5]
				//
			msUnlock()

			//Alteracoes efetuadas por Francisco
			//Em: 18.11.2016
			//Motivo: Gravacao de Log
			o_Explorer:mtdEditaLog(c_Arquivo, "Apos atualizacao de SZ8" )
			o_Explorer:mtdEditaLog(c_Arquivo, "Variavel lBloqueiaPC (ANTES) -> " + cValToChar(lBloqueiaPC) )


			If !lBloqueiaPC
				lBloqueiaPC := .T.

				//Alteracoes efetuadas por Francisco
				//Em: 18.11.2016
				//Motivo: Gravacao de Log
				o_Explorer:mtdEditaLog(c_Arquivo, "Variavel lBloqueiaPC (DEPOIS) -> " + cValToChar(lBloqueiaPC) )

			Endif
		Next
	Endif

	//Alteracoes efetuadas por Francisco
	//Em: 18.11.2016
	//Motivo: Gravacao de Log
	o_Explorer:mtdEditaLog(c_Arquivo, "Variavel lRet -> " + cValToChar(lRet) )
	o_Explorer:mtdCopyFile( c_Arquivo, c_CamLog + Alltrim( cNum ) + "_PE_MT120GRV" + c_Time + ".LOG", .T. )


	//Fluxo de Aprovacao 22/04/16
Endif
RestArea(_aArea)

Return lRet


/*/{Protheus.doc} f_Prioridade
//Retornar prazo de acordo com a prioridade do pedido.
@author eduardo arcieri
@since 25/01/2017
@version undefined
@param c_FInc, characters, descricao
@param c_FEnt, characters, descricao
@param c_Pedido, characters, descricao
@type function
/*/
Static Function f_Prioridade(c_FInc, c_FEnt, c_Pedido)
local c_Prz	:=	""
Local c_AliasPrz 	:= 	GetNextAlias()

IIf(Select(c_AliasPrz)>0,(c_AliasPrz)->(dbCloseArea()),Nil)

BEGINSQL ALIAS c_AliasPrz

SELECT C7_ZZGRAU
FROM %table:SC7% SC7
WHERE 	SC7.%notDel%
AND		SC7.C7_FILIAL 	= 	%exp:c_FInc%
AND		SC7.C7_FILENT 	= 	%exp:c_FEnt%
AND		SC7.C7_NUM		=	%exp:c_Pedido%
AND		SC7.C7_ZZGRAU	=	%exp:"E"%
AND		SC7.C7_ZZGRAU	<>	''

UNION ALL

SELECT C7_ZZGRAU
FROM %table:SC7% SC7
WHERE 	SC7.%notDel%
AND		SC7.C7_FILIAL 	= 	%exp:c_FInc%
AND		SC7.C7_FILENT 	= 	%exp:c_FEnt%
AND		SC7.C7_NUM		=	%exp:c_Pedido%
AND		SC7.C7_ZZGRAU	<>	%exp:"E"%
AND		SC7.C7_ZZGRAU	<>	''

ENDSQL

dbSelectArea(c_AliasPrz)
If (c_AliasPrz)->(!Eof()) .And. !empty((c_AliasPrz)->C7_ZZGRAU)
	c_Prz := (c_AliasPrz)->C7_ZZGRAU

	c_FSPRZAPR	:=	SUPERGetMV("FS_PRZAPR",.F.,"A=2;E=1;N=15;F=5;")
	a_FSPRZAPR	:=	Separa(c_FSPRZAPR,";",.F.)
	For nz := 1 to len(a_FSPRZAPR)
		If SubStr(a_FSPRZAPR[nz],1,1) == Alltrim(c_Prz)
			c_Prz := SubSTr(a_FSPRZAPR[nz],3,len(a_FSPRZAPR[nz]))
		Endif
	Next
Endif

IIf(Select(c_AliasPrz)>0,(c_AliasPrz)->(dbCloseArea()),Nil)

Return(c_Prz)
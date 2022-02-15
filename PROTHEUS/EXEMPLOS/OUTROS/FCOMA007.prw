#INCLUDE "TOTVS.CH"

User Function FCOMA007()

	Local o_Transfer	:= WSECMOutstandingServiceService():New()
	Local o_Processos	:= ECMOutstandingServiceService_STRINGARRAY():New()
	Local oServico		:= WSECMWorkflowEngineServiceService():New()
	Local cUsername		:= SUPERGETMV("FS_USRFLUIG", .F., "admin")//SUPERGETMV("FS_USRFLUIG")//"claudio.ssilva"
	Local cPassword		:= SUPERGETMV("FS_PSWFLUIG", .F., "admtotvs3")//"claudio.ssilva"
	Local nCompanyId	:= SUPERGETMV("FS_EMPFLUIG", .F., 1)//2(TESTE)
	Local cCuserId 		:= SUPERGETMV("FS_IDUSRPT", .F.,"admin") //"claudio.ssilva" //USUARIO GENERICO CRIADO FLUIG(MATRICULA) usado para iniciar processos.


	o_Transfer:cusername		:= SUPERGETMV("FS_USRFLUIG", .F., "ti")
	o_Transfer:cpassword		:= SUPERGETMV("FS_PSWFLUIG", .F., "fjc@12345")
	o_Transfer:ncompanyId		:= SUPERGETMV("FS_EMPFLUIG", .F., 1)

	c_DataHora := DTOS( dDataBase ) + TIME()

	BeginSql Alias 'QRY'

		SELECT Z8_REC = SZ8.R_E_C_N_O_ , *
		FROM %TABLE:SZ8% SZ8
		INNER JOIN %TABLE:SZ5% SZ5 ON SZ5.Z5_FILIAL = SZ8.Z8_FILENT AND SZ5.Z5_USER = SZ8.Z8_USER AND SZ5.%NOTDEL%
		WHERE SZ8.Z8_FILIAL = %XFILIAL:SZ8%
		AND SZ8.%NOTDEL%
		AND Z8_STATUS = %EXP:'4'%
		AND Z8_DTMAPR + Z8_HRMAPR <= %Exp:c_DataHora%
		AND Z8_NIVEL = (SELECT MIN(Z8_NIVEL) FROM %TABLE:SZ8% Z8 WHERE SZ8.Z8_FILIAL = Z8.Z8_FILIAL AND SZ8.Z8_FILENT = Z8.Z8_FILENT AND SZ8.Z8_NUMPC = Z8.Z8_NUMPC AND Z8.%NOTDEL% )

	EndSql
	dbSelectArea("QRY")
	QRY->(dbGoTop())
	While QRY->(!Eof())

		If !Empty( QRY->Z5_USERALT )

			o_Transfer:ccolleagueIdFrom	:= QRY->Z8_USER
			o_Transfer:ccolleagueIdTo	:= QRY->Z5_USERALT

			//Nao alterar esta ordem
			aadd( o_Transfer:oWSTransferParameters:citem, "documentIdFinal:0" )
			aadd( o_Transfer:oWSTransferParameters:citem, "documentIdInitial:0" )
			aadd( o_Transfer:oWSTransferParameters:citem, "instanceIdFinal:" + Alltrim( QRY->Z8_NPFLUIG ) )
			aadd( o_Transfer:oWSTransferParameters:citem, "instanceIdInitial:" + Alltrim( QRY->Z8_NPFLUIG ) )
			aadd( o_Transfer:oWSTransferParameters:citem, "transferActiveDocuments:false" )
			aadd( o_Transfer:oWSTransferParameters:citem, "transferApprovals:false" )
			aadd( o_Transfer:oWSTransferParameters:citem, "transferApprovers:false" )
			aadd( o_Transfer:oWSTransferParameters:citem, "transferDocumentSecurity:false" )
			aadd( o_Transfer:oWSTransferParameters:citem, "transferMyDocumentsInApproval:false" )
			aadd( o_Transfer:oWSTransferParameters:citem, "transferOpenWorkflow:false" )
			aadd( o_Transfer:oWSTransferParameters:citem, "transferPendingWorkflow:true" )

			o_Transfer:transfer()

			If Substr( o_Transfer:cresult, 1, 5) = "ERROR"
				dbSelectArea("SZ8")
				dbSetOrder(1)
				If dbSeek(xFilial("SZ8") + QRY->Z8_FILENT + QRY-> Z8_NUMPC + QRY->Z8_NIVEL + QRY->Z8_USER, .T. )
					RecLock("SZ8",.F.)
					SZ8->Z8_RET2 := o_Transfer:cresult
					MsUnlock()
				EndIf
			Else

				n_Prazo 	:= val(QRY->Z8_PRAZO)

				if  n_Prazo = 0
					n_Prazo := 4
				endif

				//yyyy-MM-dd
				cData := dtos(dDataBase)
				cData := substr(cData, 1, 4) + "-" + substr(cData, 5, 2) + "-" + substr(cData, 7, 2)

				cHora := Time()

				nHora := val( SubStr( cHora, 1, 2 ) ) * 60 * 60 // Resultado: 10
			  	nHora += val( SubStr( cHora, 4, 2 ) ) * 60 // Resultado: 37
			  	nHora += val( SubStr( cHora, 7, 2 ) ) // Resultado: 17

				IF oServico:calculateDeadLineHours( cUsername, cPassword, nCompanyId, cCuserId, cData, nHora, n_Prazo, "Default" )

					//2015-05-08
					c_DtPrz := oServico:oWScalculateDeadLineHoursresult:cdate
					c_DtPrzFl := substr(c_DtPrz, 1, 4)+substr(c_DtPrz, 6, 2)+substr(c_DtPrz, 9, 2)

					n_HrPrz := oServico:oWScalculateDeadLineHoursresult:nhora

					n_segundos 	:= int(n_HrPrz%60)
					n_HrPrz /= 60
					n_minutos  	:= int(n_HrPrz%60)
					n_HrPrz	/= 60
					n_horas  	:= int(n_HrPrz%24)
					c_HrPrzFl	:= strZERO(n_horas,2) + ":" + strZERO(n_minutos,2) + ":" + strZERO(n_segundos,2)

					dbSelectArea("SZ8")
					RecLock("SZ8",.T.)
					SZ8->Z8_FILIAL	:= QRY->Z8_FILIAL
					SZ8->Z8_FILENT	:= QRY->Z8_FILENT
					SZ8->Z8_NUMPC	:= QRY->Z8_NUMPC
					SZ8->Z8_VISTO	:= QRY->Z8_VISTO
					SZ8->Z8_NIVEL	:= QRY->Z8_NIVEL
					SZ8->Z8_USER	:= QRY->Z5_USERALT
					SZ8->Z8_VALORPC	:= QRY->Z8_VALORPC
					SZ8->Z8_DTINC	:= dDataBase
					SZ8->Z8_HRINC	:= Time()
					SZ8->Z8_DTAPR	:= CTOD("  /  /  ")
					SZ8->Z8_HRAPR	:= Space(TamSX3("Z8_HRAPR")[1])
					SZ8->Z8_STATUS	:= "4"
					SZ8->Z8_NPFLUIG	:= QRY->Z8_NPFLUIG
					SZ8->Z8_RETORNO	:= QRY->Z8_RETORNO
					SZ8->Z8_EMAIL	:= QRY->Z8_EMAIL
					SZ8->Z8_USERORI	:= QRY->Z8_USER
					SZ8->Z8_PRAZO	:= QRY->Z8_PRAZO
					SZ8->Z8_RET2	:= QRY->Z8_RET2
					SZ8->Z8_STATUS2	:= QRY->Z8_STATUS2
					SZ8->Z8_DTMAPR	:= CTOD(substr(c_DtPrz, 9, 2)+"/"+substr(c_DtPrz, 6, 2)+"/"+substr(c_DtPrz, 1, 4))
					SZ8->Z8_HRMAPR	:= c_HrPrzFl
					MsUnlock()

					c_Z8NPFLUIG :=	SZ8->Z8_NPFLUIG
					n_RecInc 	:= 	SZ8->(recno())

					n_SZ8REC 	:= 	QRY->Z8_REC

					c_UpdSZ8	:=	""
					c_UpdSZ8	+=	"UPDATE "+RETSQLNAME("SZ8")+" SET "
					c_UpdSZ8	+=	"Z8_STATUS2 = '1' "
					c_UpdSZ8	+=	",Z8_RET2 = 'Sucesso' "
					c_UpdSZ8	+=	",Z8_STATUS = '5' "
					c_UpdSZ8	+=	"WHERE R_E_C_N_O_ = "+Alltrim(Str(n_SZ8REC))

					nRetorno:= TCSQLExec(c_UpdSZ8)
					If 	nRetorno < 0
						Conout("Erro no cancelamento do registro do aprovador original do pedido, favor informar a TI, registro no. "+Alltrim(Str(n_SZ8REC)))

					Else

						BeginSql Alias 'SUBQRY'

							SELECT Z8_REC = SZ8.R_E_C_N_O_ , *
							FROM %TABLE:SZ8% SZ8
							INNER JOIN %TABLE:SZ5% SZ5 ON SZ5.Z5_FILIAL = SZ8.Z8_FILENT AND SZ5.Z5_USER = SZ8.Z8_USER AND SZ5.%NOTDEL%
							WHERE SZ8.Z8_FILIAL = %XFILIAL:SZ8%
							AND SZ8.%NOTDEL%
							AND Z8_STATUS = %EXP:'4'%
							AND SZ8.R_E_C_N_O_ <> %EXP:n_RecInc%
							AND Z8_NPFLUIG = %EXP:c_Z8NPFLUIG%

						EndSql

						dbSelectArea("SUBQRY")
						SUBQRY->(dbGoTop())
						While SUBQRY->(!Eof())

							dbSelectArea("SZ8")
							RecLock("SZ8",.T.)
							SZ8->Z8_FILIAL	:= SUBQRY->Z8_FILIAL
							SZ8->Z8_FILENT	:= SUBQRY->Z8_FILENT
							SZ8->Z8_NUMPC	:= SUBQRY->Z8_NUMPC
							SZ8->Z8_VISTO	:= SUBQRY->Z8_VISTO
							SZ8->Z8_NIVEL	:= SUBQRY->Z8_NIVEL
							SZ8->Z8_USER	:= SUBQRY->Z8_USER
							SZ8->Z8_VALORPC	:= SUBQRY->Z8_VALORPC
							SZ8->Z8_DTINC	:= dDataBase
							SZ8->Z8_HRINC	:= Time()
							SZ8->Z8_DTAPR	:= CTOD("  /  /  ")
							SZ8->Z8_HRAPR	:= Space(TamSX3("Z8_HRAPR")[1])
							SZ8->Z8_STATUS	:= "4"
							SZ8->Z8_NPFLUIG	:= SUBQRY->Z8_NPFLUIG
							SZ8->Z8_RETORNO	:= SUBQRY->Z8_RETORNO
							SZ8->Z8_EMAIL	:= SUBQRY->Z8_EMAIL
							SZ8->Z8_USERORI	:= SUBQRY->Z8_USERORI
							SZ8->Z8_PRAZO	:= SUBQRY->Z8_PRAZO
							SZ8->Z8_RET2	:= SUBQRY->Z8_RET2
							SZ8->Z8_STATUS2	:= SUBQRY->Z8_STATUS2
							SZ8->Z8_DTMAPR	:= CTOD(substr(c_DtPrz, 9, 2)+"/"+substr(c_DtPrz, 6, 2)+"/"+substr(c_DtPrz, 1, 4))
							SZ8->Z8_HRMAPR	:= c_HrPrzFl
							MsUnlock()

							n_SZ8REC2 	:= 	SUBQRY->Z8_REC

							c_UpdSZ82	:=	""
							c_UpdSZ82	+=	"UPDATE "+RETSQLNAME("SZ8")+" SET "
							c_UpdSZ82	+=	"Z8_STATUS2 = '1' "
							c_UpdSZ82	+=	",Z8_RET2 = 'Sucesso' "
							c_UpdSZ82	+=	",Z8_STATUS = '5' "
							c_UpdSZ82	+=	"WHERE R_E_C_N_O_ = "+Alltrim(Str(n_SZ8REC2))

							nRetorno:= TCSQLExec(c_UpdSZ82)
							If 	nRetorno < 0
								Conout("Erro no cancelamento do registro do aprovador original do pedido, favor informar a TI, registro no. "+Alltrim(Str(n_SZ8REC2)))
							Endif

							SUBQRY->(dbSkip())

						Enddo

						SUBQRY->(dbCloseArea())
					Endif
				Else

					cErroLog 	:= 	SubStr(GetWSCError(),1,250)
					conout("Erro no calculo do prazo do processo FCOMA007:"+cErroLog)

				Endif

			EndIF

		EndIf
		QRY->(dbSkip())

	EndDo
	QRY->(dbCloseArea())

	c_DataHora := DTOS( dDataBase ) + TIME()
	BeginSql Alias "QRY"

	SELECT
	 Z7_REC = SZ7.R_E_C_N_O_
	,Filial = Z4_FILIAL
	,Id_Aprovador = Z4_USER
	,Nivel = Z4_NIVEL
	,Z3_USERALT = ISNULL((SELECT TOP 1 Z3_USERALT FROM %Table:SZ3% SZ3
						WHERE SZ3.%NOTDEL%
						AND Z3_USER = Z4_USER
						AND Z3_MSBLQL <> %EXP:'1'%), '')
	,Solicitacao = Z7_NUMSC
	,Aplicacao = (SELECT TOP 1 C1_ZCDAPL FROM %Table:SC1% WHERE %NOTDEL% AND C1_NUM = Z7_NUMSC)
	,TpCompras = (SELECT TOP 1 C1_ZZTPCOM FROM %Table:SC1% WHERE %NOTDEL% AND C1_NUM = Z7_NUMSC)
	,*
	FROM %Table:SZ7% SZ7
	INNER JOIN %Table:SZ4% SZ4
	ON     SZ7.%NOTDEL%
	AND Z4_MSBLQL <> %EXP:'1'%
	AND Z4_FILIAL = Z7_FILENT
	AND Z4_USER = Z7_USERORI
	AND Z4_MSBLQL <> %EXP:'1'%
	AND Z4_CDAPL = (SELECT TOP 1 C1_ZCDAPL FROM %Table:SC1% WHERE %NOTDEL% AND C1_NUM = Z7_NUMSC)
	AND (Z4_CDTC = (SELECT TOP 1 C1_ZZTPCOM FROM %Table:SC1% WHERE %NOTDEL% AND C1_NUM = Z7_NUMSC)
	OR   Z4_CDTC = '*' )
	WHERE SZ7.%NOTDEL%
	AND Z7_STATUS = %EXP:'4'%
	AND Z7_DTMAPR + Z7_HRMAPR <= %Exp:c_DataHora%
	ORDER BY Z7_FILENT, Z7_NUMSC, Z7_NIVEL, Z7_USERORI

	EndSql
	dbSelectArea("QRY")
	QRY->(dbGoTop())
	While QRY->(!Eof())

		If !Empty( QRY->Z3_USERALT )

			o_Transfer:ccolleagueIdFrom	:= QRY->Z7_USER
			o_Transfer:ccolleagueIdTo	:= QRY->Z3_USERALT

			//Nao alterar esta ordem
			aadd( o_Transfer:oWSTransferParameters:citem, "documentIdFinal:0" )
			aadd( o_Transfer:oWSTransferParameters:citem, "documentIdInitial:0" )
			aadd( o_Transfer:oWSTransferParameters:citem, "instanceIdFinal:" + Alltrim( QRY->Z7_NPFLUIG ) )
			aadd( o_Transfer:oWSTransferParameters:citem, "instanceIdInitial:" + Alltrim( QRY->Z7_NPFLUIG ) )
			aadd( o_Transfer:oWSTransferParameters:citem, "transferActiveDocuments:false" )
			aadd( o_Transfer:oWSTransferParameters:citem, "transferApprovals:false" )
			aadd( o_Transfer:oWSTransferParameters:citem, "transferApprovers:false" )
			aadd( o_Transfer:oWSTransferParameters:citem, "transferDocumentSecurity:false" )
			aadd( o_Transfer:oWSTransferParameters:citem, "transferMyDocumentsInApproval:false" )
			aadd( o_Transfer:oWSTransferParameters:citem, "transferOpenWorkflow:false" )
			aadd( o_Transfer:oWSTransferParameters:citem, "transferPendingWorkflow:true" )

			o_Transfer:transfer()

			If Substr( o_Transfer:cresult, 1, 5) = "ERROR"
				dbSelectArea("SZ7")
				dbSetOrder(1)
				If dbSeek(xFilial("SZ7") + QRY->Z7_FILENT + QRY-> Z7_NUMSC + QRY->Z7_NIVEL + QRY->Z7_USER, .T. )
					RecLock("SZ7",.F.)
					SZ7->Z7_RET2 := o_Transfer:cresult
					MsUnlock()
				EndIf
			Else

				n_Prazo 	:= val(QRY->Z7_PRAZO)

				//yyyy-MM-dd
				cData := dtos(dDataBase)
				cData := substr(cData, 1, 4) + "-" + substr(cData, 5, 2) + "-" + substr(cData, 7, 2)

				cHora := Time()

				nHora := val( SubStr( cHora, 1, 2 ) ) * 60 * 60 // Resultado: 10
			  	nHora += val( SubStr( cHora, 4, 2 ) ) * 60 // Resultado: 37
			  	nHora += val( SubStr( cHora, 7, 2 ) ) // Resultado: 17

				IF oServico:calculateDeadLineHours( cUsername, cPassword, nCompanyId, cCuserId, cData, nHora, n_Prazo, "Default" )

					c_DtPrz := oServico:oWScalculateDeadLineHoursresult:cdate
					c_DataPrazoFluig := substr(c_DtPrz, 1, 4)+substr(c_DtPrz, 6, 2)+substr(c_DtPrz, 9, 2)

					n_HrPrz := oServico:oWScalculateDeadLineHoursresult:nhora

					n_segundos 	:= int(n_HrPrz%60)
					n_HrPrz /= 60
					n_minutos  	:= int(n_HrPrz%60)
					n_HrPrz	/= 60
					n_horas  	:= int(n_HrPrz%24)
					c_HrPrzFl := strZERO(n_horas,2) + ":" + strZERO(n_minutos,2) + ":" + strZERO(n_segundos,2)

					dbSelectArea("SZ7")
					RecLock("SZ7",.T.)
					SZ7->Z7_FILIAL  := QRY->Z7_FILIAL
					SZ7->Z7_FILENT  := QRY->Z7_FILENT
					SZ7->Z7_NUMSC   := QRY->Z7_NUMSC
					SZ7->Z7_NIVEL   := QRY->Z7_NIVEL
					SZ7->Z7_USER    := QRY->Z3_USERALT
					SZ7->Z7_DTINC   := dDataBase
					SZ7->Z7_HRINC   := Time()
					SZ7->Z7_STATUS  := "4"
					SZ7->Z7_NPFLUIG := QRY->Z7_NPFLUIG
					SZ7->Z7_RETORNO := QRY->Z7_RETORNO
					SZ7->Z7_USERORI := QRY->Z7_USER
					SZ7->Z7_PRAZO   := QRY->Z7_PRAZO
					SZ7->Z7_RET2    := QRY->Z7_RET2
					SZ7->Z7_STATUS2 := QRY->Z7_STATUS2
					SZ7->Z7_DTMAPR	:= CTOD(substr(c_DtPrz, 9, 2)+"/"+substr(c_DtPrz, 6, 2)+"/"+substr(c_DtPrz, 1, 4))
					SZ7->Z7_HRMAPR	:= c_HrPrzFl
					MsUnlock()

					c_Z7NPFLUIG :=	SZ7->Z7_NPFLUIG

					n_RecInc 	:= 	SZ7->(recno())

					n_SZ7REC := QRY->Z7_REC

					c_UpdSZ7	:=	""
					c_UpdSZ7	+=	"UPDATE "+RETSQLNAME("SZ7")+" SET "
					c_UpdSZ7	+=	"Z7_STATUS2 = '1' "
					c_UpdSZ7	+=	",Z7_RET2 = 'Sucesso' "
					c_UpdSZ7	+=	",Z7_STATUS = '5' "
					c_UpdSZ7	+=	"WHERE R_E_C_N_O_ = "+Alltrim(Str(n_SZ7REC))

					nRetorno:= TCSQLExec(c_UpdSZ7)
					If 	nRetorno < 0
						Conout("Erro no cancelamento do registro do aprovador original da solicitacao, favor informar a TI, registro no. "+Alltrim(Str(n_SZ7REC)))

					Else
						BeginSql Alias "SUBQRY"

							SELECT
							 Z7_REC = SZ7.R_E_C_N_O_
							,Filial = Z4_FILIAL
							,Id_Aprovador = Z4_USER
							,Nivel = Z4_NIVEL
							,Z3_USERALT = ISNULL((SELECT TOP 1 Z3_USERALT FROM %Table:SZ3% SZ3
												WHERE SZ3.%NOTDEL%
												AND Z3_USER = Z4_USER
												AND Z3_MSBLQL <> %EXP:'1'%), '')
							,Solicitacao = Z7_NUMSC
							,Aplicacao = (SELECT TOP 1 C1_ZCDAPL FROM %Table:SC1% WHERE %NOTDEL% AND C1_NUM = Z7_NUMSC)
							,TpCompras = (SELECT TOP 1 C1_ZZTPCOM FROM %Table:SC1% WHERE %NOTDEL% AND C1_NUM = Z7_NUMSC)
							,*
							FROM %Table:SZ7% SZ7
							INNER JOIN %Table:SZ4% SZ4
							ON     SZ7.%NOTDEL%
							AND Z4_MSBLQL <> %EXP:'1'%
							AND Z4_FILIAL = Z7_FILENT
							AND Z4_USER = Z7_USERORI
							AND Z4_MSBLQL <> %EXP:'1'%
							AND Z4_CDAPL = (SELECT TOP 1 C1_ZCDAPL FROM %Table:SC1% WHERE %NOTDEL% AND C1_NUM = Z7_NUMSC)
							AND (Z4_CDTC = (SELECT TOP 1 C1_ZZTPCOM FROM %Table:SC1% WHERE %NOTDEL% AND C1_NUM = Z7_NUMSC)
							OR   Z4_CDTC = '*' )
							WHERE SZ7.%NOTDEL%
							AND Z7_STATUS = %EXP:'4'%
							AND SZ7.R_E_C_N_O_ <> %EXP:n_RecInc%
							AND Z7_NPFLUIG = %EXP:c_Z7NPFLUIG%

							ORDER BY Z7_FILENT, Z7_NUMSC, Z7_NIVEL, Z7_USERORI

						EndSql

						dbSelectArea("SUBQRY")
						SUBQRY->(dbGoTop())
						While SUBQRY->(!Eof())

							dbSelectArea("SZ7")
							RecLock("SZ7",.T.)
							SZ7->Z7_FILIAL  := QRY->Z7_FILIAL
							SZ7->Z7_FILENT  := QRY->Z7_FILENT
							SZ7->Z7_NUMSC   := QRY->Z7_NUMSC
							SZ7->Z7_NIVEL   := QRY->Z7_NIVEL
							SZ7->Z7_USER    := QRY->Z7_USER
							SZ7->Z7_DTINC   := dDataBase
							SZ7->Z7_HRINC   := Time()
							SZ7->Z7_STATUS  := "4"
							SZ7->Z7_NPFLUIG := QRY->Z7_NPFLUIG
							SZ7->Z7_RETORNO := QRY->Z7_RETORNO
							SZ7->Z7_USERORI := QRY->Z7_USERORI
							SZ7->Z7_PRAZO   := QRY->Z7_PRAZO
							SZ7->Z7_RET2    := QRY->Z7_RET2
							SZ7->Z7_STATUS2 := QRY->Z7_STATUS2
							SZ7->Z7_DTMAPR	:= CTOD(substr(c_DtPrz, 9, 2)+"/"+substr(c_DtPrz, 6, 2)+"/"+substr(c_DtPrz, 1, 4))
							SZ7->Z7_HRMAPR	:= c_HrPrzFl
							MsUnlock()

							n_SZ7REC2 	:= 	SUBQRY->Z7_REC

							c_UpdSZ72	:=	""
							c_UpdSZ72	+=	"UPDATE "+RETSQLNAME("SZ7")+" SET "
							c_UpdSZ72	+=	"Z7_STATUS2 = '1' "
							c_UpdSZ72	+=	",Z7_RET2 = 'Sucesso' "
							c_UpdSZ72	+=	",Z7_STATUS = '5' "
							c_UpdSZ72	+=	"WHERE R_E_C_N_O_ = "+Alltrim(Str(n_SZ7REC2))

							nRetorno:= TCSQLExec(c_UpdSZ72)
							If 	nRetorno < 0
								Conout("Erro no cancelamento do registro do aprovador original do solicitacao, favor informar a TI, registro no. "+Alltrim(Str(n_SZ7REC2)))
							Endif

							SUBQRY->(dbSkip())

						Enddo

						SUBQRY->(dbCloseArea())


					Endif

				Else

				EndIf


			EndIF

		EndIf
		QRY->(dbSkip())

	EndDo
	QRY->(dbCloseArea())

Return()
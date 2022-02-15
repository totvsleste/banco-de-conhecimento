#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} FCOMA007
//Rotina de substituicao de aprovadores.
@author carlo
@since 16/05/2017
@version undefined

@type function
/*/
User Function FCOMA007()

	Local o_Transfer	:= WSECMOutstandingServiceService():New()
	Local o_Processos	:= ECMOutstandingServiceService_STRINGARRAY():New()
	Local oServico		:= WSECMWorkflowEngineServiceService():New()
	Local cUsername		:= SUPERGETMV("FS_USRFLUIG", .F., "admin")//SUPERGETMV("FS_USRFLUIG")//"claudio.ssilva"
	Local cPassword		:= SUPERGETMV("FS_PSWFLUIG", .F., "admtotvs3")//"claudio.ssilva"
	Local nCompanyId	:= SUPERGETMV("FS_EMPFLUIG", .F., 1)//2(TESTE)
	Local cCuserId 		:= SUPERGETMV("FS_IDUSRPT", .F.,"admin") //"claudio.ssilva" //USUARIO GENERICO CRIADO FLUIG(MATRICULA) usado para iniciar processos.
	Local c_IdNoFluig	:= SUPERGETMV("FS_IDNFLUIG",.F.,"000044,")

	a_IdNoFluig := Separa(c_IdNoFluig,',',.f.)
	c_IdNoFluig := "("
	For n_X := 1 to len(a_IdNoFluig)
		c_IdNoFluig += "'"+a_IdNoFluig[n_X]+"'"+ Iif( n_X == len(a_IdNoFluig),"","," )
	Next
	c_IdNoFluig := ")"

	o_Transfer:cusername		:= SUPERGETMV("FS_USRFLUIG", .F., "ti")
	o_Transfer:cpassword		:= SUPERGETMV("FS_PSWFLUIG", .F., "fjc@12345")
	o_Transfer:ncompanyId		:= SUPERGETMV("FS_EMPFLUIG", .F., 1)   //teste

	c_DataHora := DTOS( dDataBase ) + TIME()

	BeginSql Alias 'QRY'
		SELECT SZ8.R_E_C_N_O_, *
		FROM %TABLE:SZ8% SZ8
		INNER JOIN %TABLE:SZ5% SZ5 ON SZ5.Z5_FILIAL = SZ8.Z8_FILENT AND SZ5.Z5_USER = SZ8.Z8_USER AND SZ5.%NOTDEL%
		WHERE SZ8.Z8_FILIAL = %XFILIAL:SZ8%
		AND SZ8.%NOTDEL%
		AND Z8_STATUS = %EXP:'4'%
		AND Z8_DTMAPR + Z8_HRMAPR <= %Exp:c_DataHora%
		AND Z8_NIVEL = (SELECT MIN(Z8_NIVEL) FROM %TABLE:SZ8% Z8 WHERE SZ8.Z8_FILIAL = Z8.Z8_FILIAL AND SZ8.Z8_FILENT = Z8.Z8_FILENT AND SZ8.Z8_NUMPC = Z8.Z8_NUMPC AND Z8.%NOTDEL% )
		AND Z8_NUMPC IN (SELECT C7_NUM FROM %TABLE:SC7% SC7 WHERE SC7.%NOTDEL% AND C7_FILIAL = SZ8.Z8_FILIAL AND C7_CONAPRO = %EXP:'B'%)
		AND Z5_USERALT <> ''
		ORDER BY SZ8.Z8_FILIAL, SZ8.Z8_FILENT, SZ8.Z8_NUMPC, SZ8.Z8_NIVEL, SZ8.R_E_C_N_O_
	EndSql
//		AND Z5_USERALT NOT IN %EXP:c_IdNoFluig%
//		AND Z5_USER NOT IN %EXP:c_IdNoFluig%

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

			dbSelectArea("SZ8")
			dbSetOrder(1)
			If dbSeek(xFilial("SZ8") + QRY->Z8_FILENT + QRY->Z8_NUMPC + QRY->Z8_NIVEL + QRY->Z8_USER + QRY->Z8_STATUS, .T. )

				o_Transfer:transfer()

				If Substr( o_Transfer:cresult, 1, 5) = "ERROR"
					If	RecLock("SZ8",.F.)
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

						If	SZ8->(RecLock("SZ8",.F.)) .AND.;
							SZ8->Z8_FILENT + SZ8->Z8_NUMPC + SZ8->Z8_NIVEL + SZ8->Z8_USER + SZ8->Z8_STATUS == QRY->Z8_FILENT + QRY->Z8_NUMPC + QRY->Z8_NIVEL + QRY->Z8_USER + QRY->Z8_STATUS

							SZ8->Z8_STATUS2 = '1'
							SZ8->Z8_RET2 = 'Sucesso'
							SZ8->Z8_STATUS = '6' //novo status = registro substituido por outro aprovador
							SZ8->Z8_USERORI	:= QRY->Z5_USERALT
							SZ8->(MsUnlock())

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
								dbSetOrder(1)
								If dbSeek(xFilial("SZ8") + SUBQRY->Z8_FILENT + SUBQRY->Z8_NUMPC + SUBQRY->Z8_NIVEL + SUBQRY->Z8_USER + SUBQRY->Z8_STATUS, .T. )
									If RecLock("SZ8",.F.) .AND.;
									 	SZ8->Z8_FILENT + SZ8->Z8_NUMPC + SZ8->Z8_NIVEL + SZ8->Z8_USER + SZ8->Z8_STATUS == SUBQRY->Z8_FILENT + SUBQRY->Z8_NUMPC + SUBQRY->Z8_NIVEL + SUBQRY->Z8_USER + SUBQRY->Z8_STATUS

										SZ8->Z8_DTMAPR	:= CTOD(substr(c_DtPrz, 9, 2)+"/"+substr(c_DtPrz, 6, 2)+"/"+substr(c_DtPrz, 1, 4))
										SZ8->Z8_HRMAPR	:= c_HrPrzFl

										MsUnlock()
									Else
										conout("Registro nao encontrado, chave (Filial + Filial Entrega + Numero do Pedido + Nivel + ID Usuario aprovador): "+xFilial("SZ8") + " - " + SUBQRY->Z8_FILENT  + " - " +  SUBQRY->Z8_NUMPC  + " - " +  SUBQRY->Z8_NIVEL  + " - " +  SUBQRY->Z8_USER )
									Endif
								Endif

								dbSelectArea("SUBQRY")
								SUBQRY->(dbSkip())

							Enddo

							SUBQRY->(dbCloseArea())

						Else
							o_Transfer:ccolleagueIdFrom	:= QRY->Z5_USERALT
							o_Transfer:ccolleagueIdTo	:= QRY->Z8_USER
							o_Transfer:transfer()

						EndIf


					Endif


				Endif

			Else

				cErroLog 	:= 	SubStr(GetWSCError(),1,250)
				conout("Erro no calculo do prazo do processo FCOMA007:"+cErroLog)

			EndIF

		EndIf
		QRY->(dbSkip())

	EndDo
	QRY->(dbCloseArea())


	//APROVACAO DE SOLICITACOES

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
		ON     SZ4.%NOTDEL%
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
		AND Z7_NUMSC IN (SELECT C1_NUM FROM %Table:SC1% WHERE D_E_L_E_T_ = '' AND C1_APROV = 'B' )
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


			dbSelectArea("SZ7")
			dbSetOrder(1)
			If dbSeek(xFilial("SZ7") + QRY->Z7_FILENT + QRY-> Z7_NUMSC + QRY->Z7_NIVEL + QRY->Z7_USER + QRY->Z7_NIVEL +QRY->Z7_STATUS, .T. )

				o_Transfer:transfer()

				If Substr( o_Transfer:cresult, 1, 5) = "ERROR"
					RecLock("SZ7",.F.)
					SZ7->Z7_RET2 := o_Transfer:cresult
					MsUnlock()
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
						If RecLock("SZ7",.F.)

							SZ7->Z7_STATUS  := "6" //NOVO STATUS 6 = registro substituido por outro aprovador
							SZ7->Z7_RET2    := "1"
							SZ7->Z7_STATUS2 := "Sucesso"
							MsUnlock()

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

							BeginSql Alias "SUBQRY"

								SELECT
									Z7_REC = SZ7.R_E_C_N_O_
									,Filial = Z4_FILIAL
									,Id_Aprovador = Z4_USER
									,Nivel = Z4_NIVEL
									,Z3_USERALT = ISNULL((	SELECT TOP 1 Z3_USERALT FROM %Table:SZ3% SZ3
															WHERE SZ3.%NOTDEL%
															AND Z3_USER = Z4_USER
															AND Z3_MSBLQL <> %EXP:'1'%), '')
									,Solicitacao = Z7_NUMSC
									,Aplicacao = (SELECT TOP 1 C1_ZCDAPL FROM %Table:SC1% WHERE %NOTDEL% AND C1_NUM = Z7_NUMSC)
									,TpCompras = (SELECT TOP 1 C1_ZZTPCOM FROM %Table:SC1% WHERE %NOTDEL% AND C1_NUM = Z7_NUMSC)
									,*
								FROM %Table:SZ7% SZ7
								INNER JOIN %Table:SZ4% SZ4
								ON     SZ4.%NOTDEL%
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
								AND Z7_NUMSC IN (SELECT C1_NUM FROM %Table:SC1% WHERE D_E_L_E_T_ = '' AND C1_APROV = 'B' )
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

										SZ7->Z7_DTMAPR	:= CTOD(substr(c_DtPrz, 9, 2)+"/"+substr(c_DtPrz, 6, 2)+"/"+substr(c_DtPrz, 1, 4))
										SZ7->Z7_HRMAPR	:= c_HrPrzFl

										MsUnlock()
									Endif
								Else
									conout("Registro nao encontrado, chave (Filial + Filial Entrega + Numero da SC + Nivel + ID Usuario aprovador + Status): "+xFilial("SZ7") + " - " + SUBQRY->Z7_FILENT  + " - " +  SUBQRY->Z7_NUMSC  + " - " +  SUBQRY->Z7_NIVEL  + " - " +  SUBQRY->Z7_USER  + " - " +  SUBQRY->Z7_STATUS )

								Endif

								SUBQRY->(dbSkip())

							Enddo

							SUBQRY->(dbCloseArea())

						Endif

					Endif

			EndIf

		Else
			conout("Registro nao encontrado, chave (Filial + Filial Entrega + Numero da SC + Nivel + ID Usuario aprovador + Status): "+xFilial("SZ7") + " - " + QRY->Z7_FILENT  + " - " +  QRY->Z7_NUMSC  + " - " +  QRY->Z7_NIVEL  + " - " +  QRY->Z7_USER  + " - " +  QRY->Z7_STATUS )

		EndIF

	EndIf
	QRY->(dbSkip())

	EndDo
	QRY->(dbCloseArea())

Return()
#INCLUDE "FileIO.CH"
#INCLUDE "PROTHEUS.CH"                                              
#INCLUDE "fwschedule.ch"
#INCLUDE "CTBXSEM.CH"

STATIC __cExt			:= GetDbExtension()
STATIC __lBlind 		:= IsBlind()
STATIC __lCT1LOCKED		:= .F.
STATIC __lCT1LSTLCK
STATIC __aCTBMLock 		:= {}
STATIC __nT2Abort				//Numero Máximo de Tentativas de Lock de Contas.
STATIC __nTETry					//Tempo entre tentativas de Lock de Contas.
STATIC __nTSA					//Numero de Tentativas sem alerta ao usuário.


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ C050Next  ³ Autor ³ Pilar S Albaladejo    ³ Data ³ 30/11/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gera numero de Lote e Documento na valida‡„o da Data.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ C050NextdDataLanc,cLote,cSubLote,cDoc,oLote,oSubLote,oDoc,; ³±±
±±³			 ³	  CTF_LOCK,nOpc,nOperacao)  			                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ctba050                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpD1 = Data do Lancamento								   ³±±
±±³          ³ ExpC1 = Lote                  							   ³±±
±±³          ³ ExpC2 = SubLote               							   ³±±
±±³          ³ ExpC3 = Documento             							   ³±±
±±³          ³ ExpO1 = Objeto do lote        							   ³±±
±±³          ³ ExpO2 = Objeto do Sublote     							   ³±±
±±³          ³ ExpO3 = Objeto do Documento   							   ³±±
±±³          ³ ExpN1 = Semaforo para proximo documento                     ³±±
±±³          ³ ExpN2 = Numero da Opcao escolhida                           ³±±
±±³          ³ ExpN3 = Numero da Operacao                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ MMI-5346 ³ Numero de póliza debe ser consecutivo por mes.              ³±±
±±³Jose Glez ³                                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Marco Aur ³22/03/18³DMICNS-1588³Validacao da origem do processo para nao³±±
±±³          ³        ³           ³ gerar indices - Arg                    ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function C050Next(dDataLanc,cLote,cSubLote,cDoc,oLote,oSubLote,oDoc,CTF_LOCK,nOpc,nOperacao)

Local aSaveArea:= GetArea()
Local lRet := .T.

dbSelectArea("CTF")
dbSetOrder(1)

If nOperacao == 2 		// Lancamento de integracao
	MsSeek(xFilial()+Dtos(dDataLanc)+cLote+cSubLote+cDoc,.t.)
EndIf	

If nOpc == 3 .Or. nOpc == 6 .Or. nOpc == 7
	
	Ctb105Next(dDataLanc,@cLote ,@cSubLote,@cDoc,nOperacao,@oLote,@oSubLote,@oDoc,@CTF_LOCK)		// Gera n£mero de Documento
	
	If ValType(oLote) == "O" .And. ValType(oSubLote) == "O" .And. ValType(oDoc)  == "O"
		oLote:Refresh()	;oSubLote:Refresh();oDoc:Refresh()		// Atualiza a Tela
	EndIf	
EndIf
RestArea(aSaveArea)

Return lRet

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CTB105Next ³ Autor ³ Pilar S Albaladejo    ³ Data ³04.02.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gera pr¢ximo n£mero de Documento / Lote                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctb105Next(dDataLanc,@cLote,@cSubLote,@cDoc)                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CTBA050 / CTBA105                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpD1 = Data do Lan‡amento								   ³±±
±±³			 ³ ExpC1 = Lote 											   ³±±
±±³          ³ Expc2 = SubLote											   ³±±
±±³          ³ Expc3 = Documento										   ³±±
±±³          ³ ExpN1 = Numero da Operacao 								   ³±±
±±³          ³ ExpO1 = Objeto do Lote     								   ³±±
±±³          ³ ExpO2 = Objeto do SubLote  								   ³±±
±±³          ³ ExpO3 = Objeto do Documento								   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
FUNCTION CTB105Next(dDataLanc,cLote,cSubLote,cDoc,nOperacao,oLote,oSubLote,oDoc,CTF_LOCK)

Local aSaveArea	:= GetArea()
Local nIndCT2	:= CT2->(IndexOrd())
Local nRecCT2	:= CT2->(Recno())

DEFAULT CTF_LOCK:= 0

// Indica se o lancamento eh manual (1) ou de integracao (2)
nOperacao := Iif(nOperacao == Nil,1,nOperacao)
             
If nOperacao == 1
	If CTF_LOCK > 0							/// SE HOUVER CTF_LOCK INDICA ALTERACAO/EXCLUSAO
		dbSelectArea("CTF")		
		DbGoto(CTF_LOCK)     
		CtbDestrava(CTF->CTF_DATA,CTF->CTF_LOTE,CTF->CTF_SBLOTE,CTF->CTF_DOC,@CTF_LOCK)		///	(MAS CHECA SE OUTRO USUÁRIO NAO GRAVOU CT2 COM O MESMO NUMERO PARA NÃO DELETAR INDEVIDO)
	Endif

	If Empty(cLote)
		If GetNewPar("MV_LOTECON","T") == "T"				// Numero de Lote vindo da Tabela SX5 (MV_LOTECON = T)
			cLote := If(cModulo=="CTB",Tabela("09","CON"),Tabela("09",cModulo))
			cLote := Iif(Len(Alltrim(cLote)) < 6, PADL(cLote,6,"0"),cLote)
		Else							// Numero de Lote Sequencial pelo CTF (MV_LOTECON = U)
			dbSelectArea("CTF") 
			dbSetOrder(1)
			If !MsSeek(xFilial("CTF")+Dtos(dDataLanc)+"ZZZZZZZZZ",.t.)
				dbSkip(-1)         
				If dtos(CTF->CTF_DATA) == dtos(dDataLanc)
					cLote    := Soma1(CTF->CTF_LOTE)
				Else
					cLote    := '000001'
				Endif
			Endif
		Endif
	Endif
	
	If !lSubLote
		cSubLote := cLoteSub
	Endif
Else
	Return(.T.)
EndIf
                  
Do While !ProxDoc(dDataLanc,cLote,cSubLote,@cDoc,@CTF_LOCK)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Caso o N§ do Doc estourou, incrementa o lote         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cLote := SOMA1(cLote)
	DbSelectArea("SX5")
	MsSeek(xFilial("SX5")+"09"+If(cModulo=="CTB","CON",cModulo))
	RecLock("SX5")
	SX5->X5_DESCRI := Substr(cLote,3,4)
	MsUnlock()
Enddo

CT2->(dbSetOrder(nIndCT2))		//// VOLTA A POSICAO ORIGINAL NO CT2 - INDICE
CT2->(MsGoTo(nRecCT2))			//// VOLTA A POSICAO ORIGINAL NO CT2 - REGISTRO
RestArea(aSaveArea)

If ValType(oLote) == "O" .And. ValType(oSubLote) == "O" .And. ValType(oDoc) == "O"
	oLote:Refresh()	;oSubLote:Refresh();oDoc:Refresh()		// Atualiza a Tela
EndIf	

Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³UnLockDoc  ³ Autor ³ Pilar S Albaladejo    ³ Data ³ 30/11/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna o Numero do Documento (apaga registro no CTF)       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ UnLockDoc(Ctf_Lock)				                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Ctba050                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Semaforo para proximo documento                     ³±±                    								   
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function UnLockDoc(Ctf_Lock)

If CTF_Lock > 0
	DbSelectArea("CTF")
	dbGoto(CTF_Lock)                   
	If CTF->(RLock())
		CTF->(MsUnlock())
		Reclock("CTF",.F.)
		CTF->(dbDelete())
		MsUnlock()
	Else
		MsUnlock()
	Endif
	CTF_Lock := 0
          
	Leave1Code("CTF"+CTF->(CTF_FILIAL+DTOS(CTF_DATA)+CTF_LOTE+CTF_SBLOTE+CTF_DOC) )
Endif

Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ LockDoc   ³ Autor ³ Pilar S Albaladejo    ³ Data ³ 30/11/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Trava o Documento a ser utilizado no Lan‡amento Cont bil    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ LockDoc( dDataLanc , cLote , cDoc )                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CTBA050 / CTBA105                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpD1 = Data do Lan‡amento 							       ³±±
±±³          ³ ExpC1 = Lote Cont bil 									   ³±±
±±³          ³ ExpC2 = SubLote                     						   ³±±
±±³          ³ ExpC3 = N£mero do Documento 								   ³±±
±±³          ³ ExpN1 = Semaforo para proximo documento                     ³±±                    								   
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function LockDoc(dDataLanc,cLote,cSubLote,cDoc,CTF_LOCK )

Local aSaveArea := GetArea()
Local lMsgUnq	  := IsInCallStack("CTBI102")

RecLock("CTF",.T.)
CTF->CTF_FILIAL		:= xFilial("CTF")
CTF->CTF_DATA		:= dDataLanc
CTF->CTF_LOTE		:= cLote
CTF->CTF_SBLOTE		:= cSubLote
CTF->CTF_DOC		:= cDoc
CTF->(MsUnlock())
CTF->(dbCommit())
CTF->(FKCOMMIT())

//³Não efetuar o MsUnlock() - O Registro deve ficar reservado³
RecLock("CTF",.F.)
CTF_LOCK := CTF->(Recno())

// Proteção para mensagem única
If lMsgUnq
	MsUnLock()
EndIf 

RestArea(aSaveArea)

Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ ProxDoc   ³ Autor ³ Pilar S Albaladejo    ³ Data ³04.02.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gera pr¢ximo n£mero de Documento baseado na Data / Lote     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ProxDoc ( dDataLan, cLote ,cSublote, @cDoc )	               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. /.F. (Se retornou .F. ‚ por que estourou o doc no Lote) ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CTBA105 , CTBA050                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpD1 = Data do lan‡amento								   ³±±
±±³          ³ ExpC1 = Lote Cont bil 									   ³±±
±±³          ³ ExpC2 = Sub-Lote Cont bil								   ³±±
±±³          ³ Expc3 = N§ do Doc (X Referˆncia)							   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                 
FUNCTION ProxDoc(dDataLanc,cLote,cSubLote,cDoc,CTF_LOCK,lSimula,cTabCTK,cTabCT2)

Local aArea     := GetArea()
Local aAreaCTF  := CTF->(GetArea())
Local aAreaCT2  := CT2->(GetArea())
Local lRet		:= .T.
Local cKeyCTF	:= ""
Local cChaveCT2	:= ""
Default cDoc			:= ""

DEFAULT CTF_LOCK := 0
Default lSimula		:= .F.
Default cTabCTK		:= "CTK"
Default cTabCT2		:= "CT2"
// Consecutivo por mes
If cPaisLoc == "MEX"
dDataLanc = StoD( Substr(DtoS(dDataLanc), 1, 6) + "01" )
EndIf

aAreaCT2 := (cTabCT2)->(GetArea())

dbSelectArea( "CTF" )
dbSetOrder( 1 )
cKeyCTF := xFilial("CTF")+dtos(dDataLanc)+cLote+cSubLote

If ExistBlock("CTBPRXDOC") .And. !lSimula
	cDoc := ExecBlock("CTBPRXDOC",.F.,.F.,{dDataLanc,cLote,cSubLote})
Else
	lQuery := .F.
	cQuery := "SELECT Max(CTF_DOC) MAXDOC "
	cQuery += "  FROM " + RetSqlName("CTF") + " CTF "
	cQuery += " WHERE CTF_FILIAL = '" + xFilial("CTF") + "'"
	cQuery += "   AND CTF_DATA = '" + DTOS(dDataLanc) + "' "
	cQuery += "   AND CTF_LOTE = '" + cLote + "' "
	cQuery += "   AND CTF_SBLOTE = '" + cSubLote + "' "
	cQuery += "   AND D_E_L_E_T_ = ' ' "
	
	cQuery := ChangeQuery(cQuery)
	
	If ExistBlock( 'CTBPXDCQRY' )
		cQuery := Execblock( 'CTBPXDCQRY' , .F. , .F. , {cQuery} )
	Endif
	
	IF Select( "TMPPRXDOC" ) > 0
		dbSelectArea("TMPPRXDOC")
		("TMPPRXDOC")->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPPRXDOC")
	
	If Select( "TMPPRXDOC" ) > 0
		cDoc := AllTrim(("TMPPRXDOC")->MAXDOC)
		
		dbSelectArea("TMPPRXDOC")
		("TMPPRXDOC")->(dbCloseArea())
	Endif
	
	dbSelectArea("CTF")
	
	If STRZERO(VAL(cDoc),6) == "999999"
		lRet := .F.
	Else
		If Empty(cDoc)
			cDoc := "000001"
		Else
			cDoc := StrZero(Val(cDoc)+1,6)
		EndIf
	EndIf
EndIf
If lRet
	dbSelectArea("CT2")
	If lSimula
		dbSelectArea("SIX")
		dbSetOrder(1)		//INDICE+ORDEM
		dbGoTop()
		If SIX->(dbSeek("CT21"))
			cChaveCT2 := AllTrim(SIX->CHAVE)
			IndRegua("CT2", cTabCT2, cChaveCT2, , , )
		EndIf
		dbSelectArea("CT2")
	Else
		dbSetOrder(1)
	EndIf
	While !MayIUseCode("CTF"+cKeyCTF+cDoc) .Or. CTF->(MsSeek(cKeyCTF+cDoc,.F.)) .Or. CT2->(MsSeek(cKeyCTF+cDoc,.F.))
		Leave1Code("CTF"+cKeyCTF+cDoc)
		If cDoc == "999999"
			lRet := .F.
			Exit
		Else
			cDoc := StrZero(Val(cDoc)+1,6)
		EndIf
	EndDo
	If lRet
		LockDoc(dDataLanc,cLote,cSubLote,cDoc,@CTF_LOCK)
	EndIF
EndIf
RestArea(aAreaCT2)
RestArea(aAreaCTF)
RestArea(aArea)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A370CanProºAutor  ³Marcos S. Lobo      º Data ³  06/26/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria Semaforo de processamento e verifica concorrencia com  º±±
±±º          ³base nos intervalos de parametros                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - Contabilizacao Off-Line Financeiro                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±³Parametros³ExpD1 - Data Inicial do processamento                       ³±±
±±³          ³ExpD2 - Data Final do processamento                         ³±±
±±³          ³ExpC3 - Filial Inicial a ser considerada no processamento.  ³±±
±±³          ³ExpC4 - Filial Final a ser considerada no processamento.    ³±±
±±³          ³ExpC3 - Chave do programa que esta chamando a função        ³±±
±±³          ³        Tamanho maximo chave : Caracter de 6                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T./.F.                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CanProcItvl(dDtVldDe, dDtVldAte, cFilDe, cFilAte, cChave)

Local lRet		:= .F.
Local aAreaOri	:= GetArea()
Local nX		:= 1
Local aInfos	:= {}
Local nEr		:= 0 
Local cFile		:= ""
Local cBuffer	:= ""
Local cUserLck	:= ""
Local lCreate	:= .F.
Local lOK
Local dDTDe
Local dDTAte
Local nHandle 	:= -1

PRIVATE cUserCTB	:= PADR('SCHED',15)
PRIVATE cAliasTMP	:= ""

DEFAULT cFilDe  := cFilAnt
DEFAULT cFilAte := cFilAnt
DEFAULT cChave	:= 'ctbnfx'

If Empty( cChave ) .or. cChave == nil
	cChave := "ctbnfx"
EndIf

cChave := "_" + substr( cChave, 2, Len(cChave))	

cAliasTMP	:= cChave 

If GetNewPar( "MV_CTBNFSE" , "1" ) == "2"  
	Return .T.		/// Se o semaforo estiver desligado (Default é ligado), permite o processamento.
EndIf

If ! __lBlind
	cUserCTB := cUserName
EndIf
 
While ! LockByName( cChave + "ctbprc" + cEmpAnt ,.T., .F., .T.)
    nER++

	If ! __lBlind
		MsAguarde( {|| Sleep(1000) }, STR0001 + ALLTRIM( STR( nER )), STR0002 ) //"Semaforo de processamento... tentativa "#"Aguarde, arquivo sendo criado por outro usuário."
	Else
		Sleep( 5000 )
	EndIf

	If nER >= 5	/// A PARTIR DA QUINTA TENTATIVA
		If ! __lBlind
			If Aviso(STR0003,STR0004,{STR0005,STR0006},2) == 2//"Criação de Semaforo de processamento."#"Não foi possivel acesso exclusivo para criar o semaforo de processamento."#"Repetir"#"Fechar"
				ProcLogAtu("ERRO",STR0007,STR0008+STR0009)	 //"Atenção!"###"Este processo esta sendo utilizado com parametros conflitantes ( mesmo periodo ou carteiras ) por outro usuário ( "###" ) no momento. Verifique o período e os parametros selecionados para o processamento ou tente novamente mais tarde."
				Return lRet
			Else
				nER := 0
			EndIf		

		ElseIf nER >= 30
			ProcLogAtu("ERRO",STR0007,STR0008+STR0009)	 //"Atenção!"###"Este processo esta sendo utilizado com parametros conflitantes ( mesmo periodo ou carteiras ) por outro usuário ( "###" ) no momento. Verifique o período e os parametros selecionados para o processamento ou tente novamente mais tarde."
			Return lRet

		EndIf
    EndIf
EndDo

// nome do temporario
cFile := cChave + AllTrim( cEmpAnt )

// função para a criação do temporario do semaforo de processamento
IF ! CtbProcTmp( cFile )
	Return .T.
Endif

dbSelectArea( cAliasTMP )
dbGoTop()

lSai		:= .F.
lRet1		:= .T.
lRet2		:= .T.
lRet3		:= .T.	

While ! lSai .and. ( cAliasTMP )->(!Eof())
	        
	IF cFilDe <= ( cAliasTMP )->FILIALI .and. cFilAte >= (cAliasTMP)->FILIALF
		lRet1 := .F.
	ElseIF cFilDe >= (cAliasTMP)->FILIALI .and. cFilDe <= (cAliasTMP)->FILIALF
		lRet1 := .F.
	ElseIf cFilAte >= (cAliasTMP)->FILIALI .and. cFilAte <= (cAliasTMP)->FILIALF
		lRet1 := .F.
	ElseIf cFilDe > cFilAte
		lRet1 := .F.		
	Endif	    

	IF dDtVldDe <= (cAliasTMP)->DTDE .and. dDtVldAte >= (cAliasTMP)->DTATE
		lRet2 := .F.
	ElseIF dDtVldDe >= (cAliasTMP)->DTDE .and. dDtVldDe <= (cAliasTMP)->DTATE
		lRet2 := .F.
	ElseIf dDtVldAte >= (cAliasTMP)->DTDE .and. dDtVldAte <= (cAliasTMP)->DTATE
		lRet2 := .F.
	ElseIf dDtVldDe > dDtVldAte
		lRet2 := .F.		
	Endif
	
	If !lRet1 .and. !lRet2
		/// SE LOCALIZOU NO MESMO PERIODO E NAS MESMAS FILIAIS

		If !__lBlind
			Aviso(STR0007,STR0008+Alltrim((cAliasTMP)->CUSER)+" "+(cAliasTMP)->HORAI+" "+STR0009,{STR0006},2) //"Atenção!"###"Este processo esta sendo utilizado com parametros conflitantes ( mesmo periodo ou carteiras ) por outro usuário ( "###" ) no momento. Verifique o período e os parametros selecionados para o processamento ou tente novamente mais tarde."###"Fechar"
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o log de processamento com o erro  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ProcLogAtu("ERRO",STR0007,STR0008+Alltrim((cAliasTMP)->CUSER)+STR0009) //"Atenção!"###"Este processo esta sendo utilizado com parametros conflitantes ( mesmo periodo ou carteiras ) por outro usuário ( "###" ) no momento. Verifique o período e os parametros selecionados para o processamento ou tente novamente mais tarde."
		lSai		:= .T.
	EndIf

	(cAliasTMP)->(dbSkip())
EndDo

If ! lSai
	RecLock( cAliasTMP,.T.)

	Field->CROTINA	:= FunName()
	Field->FILIALI	:= cFILDE
	Field->FILIALF	:= cFILATE
	Field->CUSER	:= cUserCTB
	Field->DATAI    := Date()
	Field->HORAI	:= Time()
	Field->DTDE		:= dDtVldDe
	Field->DTATE    := dDtVldAte

	MsUnlock()	
	MsRLock( (cAliasTMP)->(Recno()) ) ///DEIXA REGISTRO ALOCADO com MsRLock em função de transções...
	lRet := .T.		///PROCESSAMENTO PODE SER EFETUADO
EndIf

UnLockByName( cChave + "ctbprc" + cEmpAnt, .T., .F., .T. )

RestArea( aAreaOri )

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FreeProcItºAutor  ³Marcos S. Lobo      º Data ³  06/26/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Libera registro alocado no semaforo de processamento.       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP Contabilizacao Off-Line Financeiro                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function FreeProcItvl( cChave )

Local cFile 	:= ""
Local cAliasTMP := ""
Local nER		:= 0

cChave := "_" + substr( cChave, 2, Len( cChave ) )	

cAliasTMP := cChave	

cFile 	:= cChave + AllTrim( cEmpAnt )

If GetNewPar( "MV_CTBNFSE" , "1" ) == "2"  
	Return 	/// Se o semaforo estiver desligado (Default é ligado), permite o processamento.
EndIf

If ! File( cFile + __cExt )
	Return
EndIf

If Select( cAliasTMP ) <= 0
	Return
EndIf

While ! LockByName( cChave + "ctbprc" + cEmpAnt, .T., .F., .T.)
    nER++

	If !__lBlind
		MsAguarde({|| Sleep(1000) }, STR0001+ALLTRIM(STR(nER)), STR0002)//"Semaforo de processamento... tentativa "#"Aguarde, arquivo sendo criado por outro usuário."
	Else
		Sleep(5000)		
	EndIf

	If nER > 5	/// A PARTIR DA QUINTA TENTATIVA
		If !__lBlind
			If Aviso(STR0003,STR0004,{STR0005,STR0006},2) == 2//"Gravacao de Semaforo de processamento."#"Não foi possivel acesso exclusivo para gravar o semaforo de processamento."#"Repetir"#"Fechar"
				ProcLogAtu("ERRO",STR0007,STR0008+STR0009)	 //"Atenção!"###"Este processo esta sendo utilizado com parametros conflitantes ( mesmo periodo ou carteiras ) por outro usuário ( "###" ) no momento. Verifique o período e os parametros selecionados para o processamento ou tente novamente mais tarde."
				Return
			Else
				nER := 0
			EndIf		

		ElseIf nER >= 30
			ProcLogAtu("ERRO",STR0007,STR0008+STR0009)	 //"Atenção!"###"Este processo esta sendo utilizado com parametros conflitantes ( mesmo periodo ou carteiras ) por outro usuário ( "###" ) no momento. Verifique o período e os parametros selecionados para o processamento ou tente novamente mais tarde."
			Return
		EndIf
    EndIf
EndDo

dbSelectArea( cAliasTMP )

If ! Eof()
	If (cAliasTMP)->( MsRLock( (cAliasTmp)->(Recno()) ) ) ///DEIXA REGISTRO ALOCADO com MsRLock em função de transções...
		Field->HORAF	:= Time()
		Field->DATAF	:= Date()

		MsRUnlock()
	EndIf

	MsRLock( (cAliasTmp)->(Recno()) )///DEIXA REGISTRO ALOCADO com MsRLock em função de transções...

	(cAliasTMP)->(dbDelete())

	MsRUnlock()
	dbCloseArea()
EndIf

UnLockByName( cChave + "ctbprc" + cEmpAnt, .T., .F., .T. )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtbDestrav³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Destrava e retorna nro. do documento                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CtbDestrava(dData,cLote,cSubLote,cDoc,CTF_LOCK)             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhuma	                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpD1 = Data do Lancamento Contabil                        ³±±
±±³          ³ ExpC1 = Lote                                               ³±±
±±³          ³ ExpC2 = Sub-Lote                                           ³±±
±±³          ³ ExpC3 = Documento                                          ³±±
±±³          ³ ExpN1 = Semaforo                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CtbDestrava(dData,cLote,cSubLote,cDoc,CTF_LOCK,lSimula,cTabCTK,cTabCT2)

Local aSaveArea := GetArea()
Local aAreaCT2  := CT2->(GetArea())
Local cChaveCT2	:= ""

Default lSimula	:= .F.
Default cTabCTK	:= "CTK"
Default cTabCT2	:= "CT2"
                            
If CTF_LOCK > 0
	dbSelectArea("CT2")
	If lSimula .and. !(Type("cFunname") <> "U" .and. (cFunname == "FINA840" .or. cFunname == "FINA087A"))
		dbSelectArea("SIX")
		dbSetOrder(1)		//INDICE+ORDEM
		dbGoTop()
		If SIX->(dbSeek("CT21"))
			cChaveCT2 := AllTrim(SIX->CHAVE)
			IndRegua("CT2", cTabCT2, cChaveCT2, , , )
		EndIf
		dbSelectArea("CT2")
	Else
		dbSetOrder(1)
	EndIf
	If CT2->(!MsSeek(xFilial("CT2")+Dtos(dData)+cLote+cSubLote+cDoc))
		UnlockDoc(@CTF_LOCK)	
	Else
		Leave1Code("CTF"+CTF->(CTF_FILIAL+DTOS(CTF_DATA)+CTF_LOTE+CTF_SBLOTE+CTF_DOC) )
		CTF->(MsUnlock())
	EndIf
Endif

RestArea(aAreaCT2)
RestArea(aSaveArea)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBSerialIºAutor  ³Marcos S. Lobo      º Data ³  06/26/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria e checa semaforo de processamento por rotina 		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP Processos SigaCTB - Serializacao                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±³Parametros³cChave- Chave do programa que esta chamando a função		  ³±±
±±³          ³cOnOff  Indicador se trata-se de rotina on-line/off-line    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T./.F.                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CtbSerialI( cChave, cONOFF, cFILDE, cFILATE )

Local lRet		:= .F.
Local lRet1		:= .F.
Local aAreaOri	:= GetArea()
Local nX		:= 1
Local aInfos	:= {}
Local nER		:= 0 
Local cFile		:= ""
Local cBuffer	:= ""
Local cUserLck	:= ""
Local nHandle 	:= -1
Local lCreate	:= .F.
Local lOK
Local lFiliais	:= .F.
Local cFilialCt2

Local cCTBSER	:= GetNewPar( "MV_CTBSER"	, "1" )	/// 1 =Ligado, 2=Desligado, 3=TestMode
Local nCTBSERT	:= GetNewPar( "MV_CTBSERT"	, 1000) /// Tempo em Milisegundos (Retry)

PRIVATE cUserCTB	:= PADR( 'SCHED', 15 )
PRIVATE cAliasTMP	:= ""

If cCTBSER	== "2"	/// Se MV_CTBSER desligado
	RestArea( aAreaOri )
	Return .T.
EndIf

dbSelectArea( "CT2" )
cFilialCt2 := xFilial("CT2")

DEFAULT cFilDE	:= If( Empty( cFilialCt2 ), ""	, cFilialCt2 )
DEFAULT cFilATE	:= If( Empty( cFilialCt2 ), "ZZ", cFilialCt2 )
DEFAULT cChave	:= "ctbproc"
DEFAULT cONOFF	:= "OFF"

If Empty( cChave ) .or. cChave == nil
	cChave := "ctbproc"
EndIf

cChave := "_" + Lower( cChave )	/// Atribui LowerCase por causa do Linux/Unix (case sensitive)

cAliasTMP := cChave

If ! __lBlind
	cUserCTB := cUserName
EndIf
 
While ! LockByName( cChave + "SERIAL" + cEmpAnt ,.T., .F., .T. )
    nER++

	If ! __lBlind
		MsAguarde( {|| Sleep( nCTBSERT ) }, "1." + STR0001+ALLTRIM(STR(nER)), STR0002) //"Semaforo de processamento... tentativa " #"Aguarde, arquivo sendo criado por outro usuário."
	Else
		Sleep( 5000 )
	EndIf

	If nER >= 5	 /// A PARTIR DA QUINTA TENTATIVA
		If !__lBlind
			If Aviso(STR0003,STR0004,{STR0005,STR0006},2) == 2//"Criação de Semaforo de processamento."#"Não foi possivel acesso exclusivo para criar o semaforo de processamento."#"Repetir"#"Fechar"
				RestArea(aAreaOri)
				Return .F.
			Else
				nER := 0
			EndIf		

		ElseIf nER >= 30
			RestArea(aAreaOri)
			Return .F.
		EndIf
    EndIf
EndDo

// nome do temporario
cFile := cChave + AllTrim( cEmpAnt )

// função para a criação do temporario do semaforo de processamento
IF ! CtbProcTmp( cFile )
	Conout( "|" + Str( ThreadID() ) + "| Erro na criação do arquivo de semaforo." )
	UnLockByName( cChave + "SERIAL" + cEmpAnt, .T., .F., .T. )  
	Return .F.
Endif

If Select( cAliasTMP ) <= 0
	Conout( "|" + Str( ThreadID() ) + "| Erro ao selecionar o arquivo de semaforo." )
	UnLockByName( cChave + "SERIAL" + cEmpAnt, .T., .F., .T. )  
	Return .F.
Endif

dbSelectArea( cAliasTMP )
dbGoTop()

lSai		:= .F.
lRet1  		:= .T.
nER			:= 0
lFiliais	:= (cAliasTMP)->( FieldPos("FILIALI") > 0) 

While ! lSai .and. (cAliasTMP)->(!Eof())

	IF ! Deleted()
		If cONOFF == "ON"/// se for processamento ON-LINE verifica se existe OFF-Line rodando
			DbSelectArea(cAliasTMP)
			If (cAliasTMP)->CONOFF == "OFF"
				If SimpleLock()
					Reclock(cAliasTMP)			/// SE CONSEGUIR ALOCAR 	
					(cAliasTMP)->(dbDelete())		/// NAO TEM CONCORRENCIA
					MsUnlock()
				Else
					If lFiliais
						IF cFilDe <= ( cAliasTMP )->FILIALI .and. cFilAte >= (cAliasTMP)->FILIALF
							lRet1 := .F.
						ElseIF cFilDe >= (cAliasTMP)->FILIALI .and. cFilDe <= (cAliasTMP)->FILIALF
							lRet1 := .F.
						ElseIf cFilAte >= (cAliasTMP)->FILIALI .and. cFilAte <= (cAliasTMP)->FILIALF
							lRet1 := .F.
						ElseIf cFilDe > cFilAte
							lRet1 := .F.		
						Endif	  
					Else
						If ( (cAliasTMP)->THREADID <> ThreadID() ) // se a thread for diferente, travo o processo
							lRet1 := .F.					/// PROCESSO "OFF" EM USO POR OUTRO USUÁRIO			
						Endif
					EndIf
				EndIf
			Endif
		Else			/// se for processamento OFF-LINE verifica tanto ON-line quanto OFF-Line rodando
			If SimpleLock()
				Reclock(cAliasTMP)				/// SE CONSEGUIR ALOCAR 	
				(cAliasTMP)->(dbDelete())		/// NAO TEM CONCORRENCIA
				MsUnlock()
			Else
				If lFiliais
					IF cFilDe <= ( cAliasTMP )->FILIALI .and. cFilAte >= (cAliasTMP)->FILIALF
						lRet1 := .F.
					ElseIF cFilDe >= (cAliasTMP)->FILIALI .and. cFilDe <= (cAliasTMP)->FILIALF
						lRet1 := .F.
					ElseIf cFilAte >= (cAliasTMP)->FILIALI .and. cFilAte <= (cAliasTMP)->FILIALF
						lRet1 := .F.
					ElseIf cFilDe > cFilAte
						lRet1 := .F.		
					Endif	    
				Else
					If ( (cAliasTMP)->THREADID <> ThreadID())  // se a thread for diferente, travo o processo
						lRet1 := .F.				    	/// PROCESSO "OFF" EM USO POR OUTRO USUÁRIO			
					Endif
				EndIf
			EndIf
		EndIf
	    
		If ! lRet1
			nER++
			/// SE LOCALIZOU NO MESMO PERIODO E NAS MESMAS FILIAIS
			If nER <= 5
				MsAguarde({|| Sleep(nCTBSERT) }, "2." + STR0001+ALLTRIM(STR(nER)), STR0002) //"Semaforo de processamento... tentativa "#"Aguarde, arquivo sendo criado por outro usuário."				
				lRet1		:= .T.
				dbGoTop()
				Loop		
			Else
				If !__lBlind
					If cONOFF == "ON"
						Aviso(STR0003,STR0004,{STR0005},2) //"Criação de Semaforo de processamento."#"Não foi possivel acesso exclusivo para criar o semaforo de processamento."#"Repetir"#"Fechar"
						nER			:= 0
						lRet1		:= .T.
						dbGoTop()
						Loop
					Else					/// PROCESSOS OFF-LINE
						If Aviso(STR0003,STR0004,{STR0005,STR0006},2) == 2//"Criação de Semaforo de processamento."#"Não foi possivel acesso exclusivo para criar o semaforo de processamento."#"Repetir"#"Fechar"
							/// SE OPTAR POR FECHAR - CANCELA O PROCESSO (VOLTA AO MENU)
							MsgInfo(STR0010)
							lSai := .T.
						Else	/// SE OPTAR POR REPETIR A TENTATIVA
							nER			:= 0
							lRet1		:= .T.
							dbGoTop()
							Loop
						EndIf
					EndIf
				Else
					If cONOFF == "ON"
						nER			:= 0
						lRet1		:= .T.
						dbGoTop()
						Loop
					Else
						CONOUT(FunName()+" - "+STR0010)
						lSai := .T.
					EndIf
				EndIf
			EndIf
		EndIf

	Endif

	( cAliasTMP )->(dbSkip())
EndDo

If ! lSai
	RecLock( cAliasTMP, .T. )

	Field->CONOFF	:= cONOFF
	Field->CROTINA	:= FunName()
	Field->FILIALI	:= cFILDE
	Field->FILIALF	:= cFILATE
	Field->CUSER	:= cUserCTB
	Field->HORAI	:= Time()
	Field->DATAI    := Date()
	Field->THREADID	:= ThreadID()

	MsUnlock()	
	MsRLock( (cAliasTMP)->(Recno()) ) ///DEIXA REGISTRO ALOCADO com MsRLock em função de transções...

	lRet := .T.		///PROCESSAMENTO PODE SER EFETUADO

	If cCTBSER == "3"
		MsgInfo( FunName() + " Lock." , "ID: " + ALLTRIM( STR( ThreadID() ) ) + " - Process type " + cONOFF + " Line" )
	EndIf
EndIf

UnLockByName( cChave + "SERIAL" + cEmpAnt, .T., .F., .T. )
FreeUsedCode()  //libera codigos ainda travados

RestArea( aAreaOri )

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBSerialFºAutor  ³Marcos S. Lobo      º Data ³  06/26/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Libera registro alocado no semaforo de processamento.       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP Processos SigaCTB - Serializacao                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CtbSerialF( cChave, cONOFF )

Local aAreaOri	:= GetArea()
Local cFile 	:= ""
Local cAliasTMP := cChave
Local cCTBSER	:= GetNewPar( "MV_CTBSER" , "1")	/// 1 =Ligado, 2=Desligado, 3=TestMode

If cCTBSER == "2"	/// Se MV_CTBSER desligado
	RestArea( aAreaOri )
	Conout( "1. Semaforo desligado !" )
	Return .T.
EndIf

If Empty( cChave ) 
	cChave := "ctbproc"
EndIf

cChave := "_" + Lower( cChave )		/// Atribui LowerCase por causa do Linux/Unix (case sensitive)
cAliasTMP := cChave

cFile := cChave + AllTrim( cEmpAnt )

If ! File( cFile + __cExt )
	RestArea( aAreaOri )
	Conout( "2. Semaforo desligado !" )
	Return .F.
EndIf

If Select( cAliasTMP ) <= 0
	RestArea( aAreaOri )
	Conout( "3. Semaforo desligado !" )
	Return .F.
EndIf

dbSelectArea( cAliasTMP )

If ! Eof() .And. ! Deleted()
	If SimpleLock()
		// RecLock(cAliasTmp)
		Field->HORAF	:= Time()
		Field->DATAF	:= Date()
		MsUnlock()
	
		RecLock(cAliasTmp)
		( cAliasTMP )->( dbDelete() )
		MsUnlock()
	EndIf

	If cCTBSER == "3"
		MsgInfo( FunName() + " UnLock." , "ID: " + ALLTRIM( STR( ThreadID() )) + " - Process type " + cONOFF + " Line")	
	EndIf
EndIf


UnLockByName( cChave + "SERIAL" + cEmpAnt, .T., .F., .T. )
FreeUsedCode()  //libera codigos ainda travados

dbSelectArea( cAliasTMP )
dbCloseArea()

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Ct1MLock  ºAutor  ³Marcos S. Lobo      º Data ³  01/08/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Ct1MLock(aCodes)

Local lLockOk   := .T.
Local aAreaBak	:= GetArea()
Local aAreaTAB	:= {}
Local nL
Local cFilTAB	:= ""
Local lOkError  := .T.
Local bErrBlock	:= ErrorBlock( { |e| lOkError := CtbChkErro(e) } )
Local aLocks	:= {}
LOCAL lLockCT1	:= .T.

BEGIN SEQUENCE

	dbSelectArea( "CT1" )
	aAreaTAB := GetArea()
	
	If ValType(__lCT1LSTLCK) == "U"
		__lCT1LSTLCK := FieldPos("CT1_LSTLCK") > 0
		__lCT1LOCKED := FieldPos("CT1_LOCKED") > 0
	EndIf
	
	dbSetOrder( 1 )
	cFilTAB := xFilial( "CT1" )
	
	For nL := 1 to Len( aCodes )
		If ! Empty( aCodes[nL] )

			dbSelectArea( "CT1" )
			If MsSeek( cFilTAB + aCodes[nL] )

				If LockByName( "CT1" + cEmpAnt + CT1->( CT1_FILIAL + CT1_CONTA ), .T., .F., .T. )

					If InTransact()
						lLockCT1 := RecLock("CT1")
					Else
						lLockCT1 := MsRLock()
					EndIf

					IF ( CT1->( Recno() ) <> 0 .And. CT1->( ! Eof() ) )
						aAdd(__aCTBMLock,Recno())
	
						If __lCT1LSTLCK
	
							REPLACE CT1->CT1_LSTLCK WITH (cUserName+"|"+RetCodUsr()+"|"+Alltrim(FunName())+"|"+DTOC(Date())+"|"+Time())
	
							If __lCT1LOCKED
								REPLACE CT1->CT1_LOCKED WITH "S"
							EndIf
						EndIf
					ENDIF
	
					If lLockCT1 // se consegui locar o registro
						IF ! InTransact() //Nao retirar ## verifica se o mesmo esta em transação
							CT1->( MsRUnLock() )
						ELSE
							CT1->(MsUnlock())
						Endif
					EndIf
				Else
					lLockOk := .F.
					Ct1MUnLock()
					Exit
				EndIf		
			EndIf
		EndIf
	Next
	
	RestArea(aAreaTAB)
	RestArea(aAreaBak)

END SEQUENCE

ErrorBlock( bErrBlock )
	
/* *** COMENTADO... APENAS SE NECESSARIO DEBUGAR/TESTAR SEMAFORO DAS CONTAS COM CONCORRENCIA (AVALIAR USO DE PE/PARAMETRO PARA HABILITAR, SE NECESSARIO)
If lLockOk
	nQbL 		:= 0
	nLenCodes	:= Len(aCodes)
	cContas		:= ""
	For nL := 1 to nLenCodes
		nQbl++
		cContas += alltrim(aCodes[nL])
		If nL < nLenCodes
			cContas += ", "
			If nQbl == 2					///Definida quebra de linha a cada 2 contas
				cContas += CRLF
				nQbl := 0
			EndIf
		EndIf
	Next
	MsgInfo("Semaforo nas contas:"+CRLF+cContas+CRLF+"Ativado !",FunName()+" Thread:"+ALLTRIM(STR( THREADID() )) )
EndIf
*/

Return(lLockOK)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Ct1MUnlockºAutor  ³Marcos S. Lobo      º Data ³  01/08/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Ct1MUnLock()		/// Libera as contas alocadas pela Ct1Mlock()

Local aAreaBak	:= GetArea()
Local aAreaTAB	:= {}
Local nL		:= 1
Local lLockCT1  := .F.

If ValType(__aCTBMLock) == "A" .and. Len(__aCTBMLock) > 0
	For nL := 1 to Len(__aCTBMLock)
		dbSelectArea("CT1")
		aAreaTAB := GetArea()
		MsGoTo(__aCTBMLock[nL])

		If __lCT1LOCKED
			If InTransact()
				lLockCT1 := RecLock("CT1")
			Else
				lLockCT1 := MsRLock()
			EndIf
	
			REPLACE CT1->CT1_LOCKED WITH "N" // limpo o flag de lock do ct1

			If lLockCT1 // se consegui locar o registro
				IF ! InTransact() //Nao retirar
					CT1->( MsRUnLock() )
				ELSE
					MsUnlock()
				Endif
			EndIf

			__lCT1LOCKED := .F.
		EndIf

		UnLockByName( "CT1" + cEmpAnt + CT1->( CT1_FILIAL + CT1_CONTA ), .T., .F., .T. ) // retiro a trava do lockbyname para cada conta
	Next

	__aCTBMLock  := {}
	__lCT1LSTLCK := nil

	RestArea(aAreaTAB)
EndIf

RestArea(aAreaBak)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBcanGrv ºAutor  ³Marcos S. Lobo      º Data ³  01/29/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CtbCanGrv(aTravas,lAtSldBase,lAtuSldCT7,lAtuSldCT3,lAtuSldCT4,lAtuSldCTI,lLiberaW,lUltCJ)

Local lPodeGrv := .F.
Local LWhile   := .T.				///SE for o CTBA102/CTBA105/CTBA103 apenas retorna .F. para tentar gravacao da próxima linha

DEFAULT aTravas 	:= {}
DEFAULT lAtSldBase	:= .T.
DEFAULT lAtuSldCT7	:= .T.
DEFAULT lAtuSldCT3	:= .T.
DEFAULT lAtuSldCT4	:= .T.
DEFAULT lAtuSldCTI	:= .T.
DEFAULT lLiberaW 	:= .F.				///CTBA102/CTBA105/CTBA103 = .T., demais programas .F. CTBA101,CTBA280,CTBA340, etc.
DEFAULT lUltCJ		:= .F.

nTry     	:= 0
nTryGer		:= 0
If __nT2Abort == Nil
	__nT2Abort 	:= GetNewPar("MV_CTSNDT",15) 		///Contabilidade Saldos Numero de Tentativas de Alocacao
EndIf
If __nTETry == Nil
	__nTETry		:= GetNewPar("MV_CTSTET",3000)	///Contabilidade Saldos Tempo Entre Tentativas (milisegundos) 
EndIf
If __nTSA == Nil
	__nTSA		:= GetNewPar("MV_CTSTSA",5)		///Contabilidade Saldos Tentativas sem alerta
EndIf

While !lPodeGrv .and. If(lLiberaW,lWhile,.T.)

	//Se estiver com saldos off-line, ou, todos os pontos de entrada tiverem desabilitado atualização de saldos.
	If !lAtSldBase .or. ( !lAtuSldCT7 .and. !lAtuSldCT3 .and. !lAtuSldCT4 .and. !lAtuSldCTI )
	   	// Permite a gravação sem semaforo e atualizar saldos.
	   	lPodeGrv := .T.
	Else
		IF __nT2Abort <> 0 .and. nTryGer >= __nT2Abort
			// Se estourou a quantitade máxima de tentativas de atualizar saldos, sem sucesso.
			If !__lBlind
				// Pergunta se deseja gravar sem atualizar saldos.
				If MsgYesNo(STR0010+ALLTRIM(STR(INT(nTryGer)))+STR0011+CRLF+;   //"Foram efetuadas "//" tentativas de atualização de saldo sem sucesso !"//
							STR0012+CRLF+;    //"É possível gravar os lançamento deixando a atualização de saldos para execução através do 'Reprocessamento de Saldos'."
							STR0013+CRLF+;    //"Selecione 'Ok' para gravar lançamentos sem atualizar saldos (recomendado), ou, "
							STR0014,STR0015)  //"Selecione 'Cancelar' para tentar novamente a gravação com atualização de saldos."
					lAtSldBase := .F.
					lPodeGrv := .T.
				EndIf
			Else
				// Em processamentos sem interface assume gravação dos lançamentos sem saldos (caso não consiga alocar as contas)
				lAtSldBase := .F.
				lPodeGrv := .T.
			EndIf
		EndIf
	
		nTry++
		nTryGer++
		
		If nTry >= __nTSA
			cContas := ""
			If !__lBlind
				MsAguarde({|| Sleep(__nTETry) }, STR0015+alltrim(str(int(nTryGer))), STR0016) //"Aguardando liberação de registros...Tentativa: "//"Conta(s) em uso por outro usuário !"
			Else
				Sleep(__nTETry)
			EndIf
		EndIf    	
	
		//Chamar a multlock	
	  	IF CT1MLock(aTravas)    
			lPodeGrv := .T.
		Else          			
			lPodeGrv := .F.
			If lLiberaW				///SE for o CTBA102/CTBA105/CTBA103 apenas retorna .F. para tentar gravacao da próxima linha
				If !lUltCJ			//Se houverem outros conjuntos para atualizar saldos (se não for o último)
					lWhile := .F.	// Libera while para tentar atualizar o proximo conjunto.
				EndIF
			EndIf
		Endif
	Endif
EndDo

Return(lPodeGrv)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    |CtbProcTmp³ Autor ³ Renato F. Campos      ³ Data ³ 10/05/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina analizadora do erro                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³CTBXFUNA                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CtbProcTmp( cFile )

Local lOkError := .T.
Local bErrBlock	:= ErrorBlock( { |e| lOkError := CtbChkErro(e) } )
Local nCTBSERT	:= GetNewPar( "MV_CTBSERT"	, 1000) /// Tempo em Milisegundos (Retry)

BEGIN SEQUENCE
	
	// Verifica se a rotina tem acesso exclusivo ao temporario criado
	// se possuir acesso exclusivo, o mesmo é excluido fisicamente
	If File( cFile + __cExt )
	
		If Select( cAliasTmp ) > 0
			dbSelectArea( cAliasTmp )
			dbCloseArea()
		Endif
	
		dbUseArea( .T.,, cFile, cAliasTMP, .F., .F. ) //COM ACESSO EXCLUSIVO
	
		IF ! NETERR()
			IF ( GetNewPar( "MV_CTBSERZ" , .T. )  == .T. ) // .T. efetua o zap no arquivo , .F. passa sem zapear
				If SimpleLock()
					// garanto que o arquivo será limpo, caso não consiga excluir o mesmo
				    Select( cAliasTmp )
					ZAP
		
					// fecho a area selecionada
					dbCloseArea()
				Else
					Conout("Não foi possivel limpar a tabela de semaforo")
				Endif    
			Endif
	
			// parametro de deleção do arquivo de semaforo                                    
			IF ( GetNewPar( "MV_CTBSERD" , .T. )  == .T. ) // .T. deleta o arquivo, .F. passa sem deletar
				FErase( cFile + __cExt )
			Endif
		Else
			dbCloseArea()
		EndIf
	EndIf
	
	// tenta criar o arquivo temporario
	If ! File( cFile + __cExt )
		aStruct  := {}
	
		AAdd( aStruct, { "CONOFF"	, "C", 3				, 0 } )
		AAdd( aStruct, { "CROTINA"	, "C", 15				, 0 } )
		AAdd( aStruct, { "FILIALI"	, "C", Len( cFilAnt )	, 0 } )
		AAdd( aStruct, { "FILIALF"	, "C", Len( cFilAnt )	, 0 } )
		AAdd( aStruct, { "DTDE"		, "D", 8 				, 0 } )
		AAdd( aStruct, { "DTATE"	, "D", 8 				, 0 } )
		AAdd( aStruct, { "CCART"	, "C", 1				, 0 } )
		AAdd( aStruct, { "CUSER"	, "C", Len( cUserCTB )	, 0 } )
		AAdd( aStruct, { "DATAI"	, "D", 8				, 0 } )
		AAdd( aStruct, { "HORAI"	, "C", Len(Time())		, 0 } )
		AAdd( aStruct, { "DATAF"	, "D", 8				, 0 } )
		AAdd( aStruct, { "HORAF"	, "C", Len(Time())		, 0 } )
		AAdd( aStruct, { "THREADID"	, "N", 10				, 0 } )
	
		MsCreate( cFile , aStruct , __LOCALDRIVER ) 
		Sleep( nCTBSERT )

		cArqTrab := cFile
	Else
		cArqTrab := cFile
	EndIf  
	
	// tenta abrir o temporario
	// se não conseguir abrir o temporario, retornara uma mensagem de erro para o usuario
	If Select( cAliasTMP ) <= 0
		dbUseArea( .T.,, cArqTrab, cAliasTMP, .T., .F. )
	
		IF NETERR()
			If ! __lBlind
				Help(" ",1,"CT5CRIA6",,STR0017,1,0)//"Erro na criação do semaforo de processamentos concorrentes, semaforo desabilitado !"
				Return .F.
			EndIf
		EndIf
	EndIf
END SEQUENCE

ErrorBlock( bErrBlock )

RETURN lOkError


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    |CtbChkErro³ Autor ³ Renato F. Campos      ³ Data ³ 10/05/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina analizadora do erro                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³CTBXFUNA                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function CtbChkErro( e )

Local lOkError := .T.

If e:gencode == 20 // fail to create
	lOkError := .F.
	Help(" ",1,"SEMACT5",,STR0017,1,0)//"Erro na criação do arquivo semaforo de processamentos concorrentes, semaforo desabilitado !"
ElseIf ( e:gencode == 35 .Or. e:gencode == 21 )  // fail to open
	lOkError := .F.
	Help(" ",1,"SEMACT51",,STR0018,1,0)//"Erro na abertura do arquivo semaforo de processamentos concorrentes, semaforo desabilitado !"
Else
	// otherwise fail
	lOkError := .F.
	Help( " ",1,"ERR_FORM",,e:Description,3,1)
Endif

If ! lOkError
	Break
Endif

Return lOkError



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  | Ctb102Smlt ºAutor  ³Renato F. Campos  º Data ³  05/11/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Efetua a verificação de concorrencia entre usuarios         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBA102                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Ctb102Smlt( cChave )
LOCAL lRetorno := .T.

DEFAULT cChave := CT2->( DTOS( CT2_DATA ) + CT2_LOTE + CT2_SBLOTE + CT2_DOC )

cChave := '__' + Lower( cChave )

IF GetNewPar( "MV_CT2SMLT" , .F. ) == .T. // se estiver configurado para verificar alterações simultaneos

	// efetua o lock fisica
	lRetorno := LockByName( cChave + "SMLT" + cEmpAnt ,.T., .F., .T.)
ENDIF

RETURN lRetorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  | Ct102SmltF ºAutor  ³Renato F. Campos  º Data ³  05/11/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Efetua a liberação da concorrencia entre usuarios           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTBA102                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Ct102SmltF( cChave )

DEFAULT cChave := CT2->( DTOS( CT2_DATA ) + CT2_LOTE + CT2_SBLOTE + CT2_DOC )

cChave := '__' + Lower( cChave )

UnLockByName( cChave + "SMLT" + cEmpAnt, .T., .F., .T. )

RETURN

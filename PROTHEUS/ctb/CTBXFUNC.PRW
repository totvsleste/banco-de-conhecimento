#INCLUDE "FileIO.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "CTBXFUNC.CH"
#Include "TopConn.ch"

Static _baDtComp   		:= {|| CtbCacheIs(1) }
Static _baDtInUse  		:= {|| CtbCacheIs(2) }
Static _bCtbAmarra 		:= {|| CtbCacheIs(3) }
Static _bCtbPosic  		:= {|| CtbCacheIs(4) }
Static _baCtbMInUse		:= {|| CtbCacheIs(5) }
Static _baCtbDtInUse	:= {|| CtbCacheIs(6) }
Static _baCtbValidDt	:= {|| CtbCacheIs(7) }
Static _bEntdBloq 		:= {|| CtbCacheIs(8) }
Static _bPerCache 		:= {|| CtbCacheIs(9) }
Static _dFechDom // Variavel para arquivo 623 rep dominicana

Static _aAtivCT1
Static _aAtivCTD
Static _aAtivCTH
Static _aAtivCTT

Static __lCacheIs
Static __lAtivComp

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณ GerInfoA2()  ณ Autor ณ Jos้ Lucas			      ณ Data ณ 16.03.10	ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Cria arquivo de trabalho para gera็ใo e prepara็ใo dos dados para os ณฑฑ
ฑฑณ          ณ Relat๓rios Distritales Artigo 02, Artigo 04 e Artigo 06.             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ GerInfoA2(dDataIni,dDataFin,nLimite)                                 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ L๓gico .T. = Se gerado com Sucesso ou .F. Se houve falha no processo.ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Gen้rico                                                  			ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ ExpD1 = Data Inicial                                        		    ณฑฑ
ฑฑณ          ณ ExpD2 = Data Final                                          		    ณฑฑ
ฑฑณ          ณ ExpN3 = Valor Limite Inferior.                              		    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
/*/
Function GerInfoA2(dDataIni,dDataFin,nLimite)
Local aSaveArea   := GetArea()
Local aTamFornece := TamSX3("A2_COD")
Local aTamLoja    := TamSX3("A2_LOJA")
Local aTamTipoDoc := If(cPaisLoc $ "COL|EQU|PER",TamSX3("A2_TIPDOC"),{2,0,"C"})
Local aTamNrDoc   := TamSX3("A2_CGC")
Local aTamNome    := TamSX3("A2_NOME")
Local aTamEnde    := TamSX3("A2_END")
Local aTamTel     := TamSX3("A2_TEL")
Local aTamCodMun  := TamSX3("A2_COD_MUN")
Local aTamCid     := TamSX3("A2_MUN")
Local aTamEstado  := TamSX3("A2_ESTADO")
Local aTamTTlCom  := TamSX3("F3_VALCONT")
Local aTamCtaPag  := TamSX3("E2_VALOR")
Local cCpoImp     := ""
Local cFornece    := ""
Local cLoja       := ""
/*-*/
Local cAuxFORNECE := ""
Local cAuxLOJA    := ""
Local cAuxTIPODOC := ""
Local cAuxNRDOC   := ""
Local cAuxDV      := ""
Local cAuxNOME    := ""
Local cAuxENDER   := ""
Local cAuxFONE    := ""
Local cAuxMUN     := ""
Local cAuxESTADO  := ""
Local dAuxDTMOVTO := Ctod("//")
Local dAuxDTBAIXA := Ctod("//")
Local nTotalPago  := 0.00
Local nTotalAber  := 0.00
Local nTotalComp  := 0
Local aTipoDoc    := {{"13","CC"},{"23","CE"},{"12","TI"},{"31","NIT"},{"11","RC"},{"41","PA"}}
Local nPosTipo    := 0
Local cArqAux     := "ARTIGO2"
Local aCampos     := {}
Local cMunicipio  := ""

DEFAULT dDataIni  := CTOD("  /  /  ")
DEFAULT dDataFim  := CTOD("31/12/10")
DEFAULT nLimite   := If(Empty(nLimite),500000,Val(nLimite))

	If ExistBlock("ESPINFOA02")
		ExecBlock("ESPINFOA02",.F.,.F.,{dDataIni,dDataFin,nLimite})
		Return(cArqAux)
	EndIf

	cCpoImp := "1"
	SFB->(dbSetOrder(1))
	If SFB->(dbSeek(xFilial("SFB")+"IVA"))
	    cCpoImp := AllTrim(SFB->FB_CPOLVRO)
	EndIf

	If Select(cArqAux) > 0
		dbSelectArea(cArqAux)
		dbCloseArea()
	EndIf

	AADD(aCampos,{ "FORNECE"	, "C", aTamFornece[1], 0 })  				// Codigo do Fornecedor
	AADD(aCampos,{ "LOJA"		, "C", aTamLoja[1]	 , 0 })  				// Loja
	AADD(aCampos,{ "TIPODOC" 	, "C", aTamTipoDoc[1], 0 })					// Tipo do Documneto
	AADD(aCampos,{ "NRDOC"		, "C", aTamNrDoc[1]	 , 0 })					// Numero do Documento
	AADD(aCampos,{ "DV"			, "C", 01            , 0 })                 // Digito Verificador do Documento
	AADD(aCampos,{ "NOME"		, "C", aTamNome[1]	 , 0 }) 	 			// Nome
	AADD(aCampos,{ "ENDERECO"	, "C", aTamEnde[1]	 , 0 })  				// Endereco
	AADD(aCampos,{ "TELEFONE"	, "C", aTamTel[1]	 , 0 })  				// Telefone
	AADD(aCampos,{ "COD_MUN"	, "C", aTamCodMun[1] , 0 })					// Codigo Oficial do Municipio
	AADD(aCampos,{ "MUNICIPIO"	, "C", aTamCid[1]    , 0 })	 				// Nome do Municipio
	AADD(aCampos,{ "ESTADO"		, "C", aTamEstado[1] , 0 })					// Estado
	AADD(aCampos,{ "TTLCOMPRAS"	, "N", aTamTTlCom[1] , aTamTTlCom[2] })		// Valor Fiscal
	AADD(aCampos,{ "CTAPAGAR"	, "N", aTamCtaPag[1] , aTamCtaPag[2] })		// Valor Pago
	AADD(aCampos,{ "DTMOVTO"	, "D", 08,0 })		// Valor Fiscal
	AADD(aCampos,{ "DTBAIXA"	, "D", 08,0 })		// Valor Pago

	cArqTmp := CriaTrab(aCampos, .T.)
	dbUseArea( .T.,, cArqTmp, cArqAux, .F., .F. )
	lCriaInd := .T.

	DbSelectarea(cArqAux)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria Indice Temporario do Arquivo de Trabalho 1.             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lCriaInd
		cChave  := "FORNECE+LOJA+TIPODOC+NRDOC"
		cArqInd	:= CriaTrab(Nil, .F.)
		IndRegua(cArqAux,cArqInd,cChave,,,OemToAnsi(STR0001))  //"Selecionando Registros..."
	EndIf

	If Select("QRYA02") > 0
		dbSelectArea("QRYA02")
		dbCloseArea()
	EndIf

	cQryArt02 := ""
	cQryArt02 += "SELECT "
	cQryArt02 += "F3_ENTRADA DTMOVTO, "
	cQryArt02 += "F3_CLIEFOR FORNECE, "
	cQryArt02 += "F3_LOJA LOJA, "
	cQryArt02 += "F3_ESPECIE NFESPEC, "
	If cPaisLoc $ "COL|EQU|PER"
		cQryArt02 += "A2_TIPDOC TIPODOC, "
	EndIf
	cQryArt02 += "A2_PFISICA NRDOC2, "
	cQryArt02 += "A2_CGC NRDOC, "
	cQryArt02 += "A2_NOME NOME, "
	cQryArt02 += "A2_END ENDERECO, "
	cQryArt02 += "A2_TEL TELEFONE, "
	cQryArt02 += "A2_COD_MUN COD_MUN, "
	cQryArt02 += "A2_MUN MUNICIPIO, "
	cQryArt02 += "A2_EST ESTADO, "
	cQryArt02 += "F3_BASIMP" + cCpoImp + "  TTLCOMPRAS, "
	cQryArt02 += "0.00 CTAPAGAR, "
	cQryArt02 += "0.00 SLDPAGAR, "
	cQryArt02 += "' ' DTBAIXA "
	cQryArt02 += " FROM "
	cQryArt02 += RetSqlName("SF3") + " SF3, "
	cQryArt02 += RetSqlName("SA2") + " SA2 "
	cQryArt02 += " WHERE "
	cQryArt02 += "  SF3.F3_FILIAL = '"+xFilial("SF3")+"' "
	cQryArt02 += "  AND F3_TIPOMOV = 'C' "
	cQryArt02 += "  AND SF3.F3_ENTRADA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFin)+"' "
	cQryArt02 += "  AND SF3.D_E_L_E_T_ = ' ' "
	cQryArt02 += "  AND SA2.A2_FILIAL = '"+xFilial("SA2")+"' "
	cQryArt02 += "  AND SA2.A2_COD = SF3.F3_CLIEFOR "
	cQryArt02 += "  AND SA2.A2_LOJA = SF3.F3_LOJA "
	cQryArt02 += "  AND SA2.D_E_L_E_T_ = ' ' "

	cQryArt02 += " UNION "

	cQryArt02 += "SELECT "
	cQryArt02 += "E2_VENCTO DTMOVTO, "
	cQryArt02 += "E2_FORNECE FORNECE, "
	cQryArt02 += "E2_LOJA LOJA, "
	cQryArt02 += "E2_TIPO NFESPEC, "
	If cPaisLoc $ "COL|EQU|PER"
		cQryArt02 += "A2_TIPDOC TIPODOC, "
	EndIf
	cQryArt02 += "A2_PFISICA NRDOC2, "
	cQryArt02 += "A2_CGC NRDOC, "
	cQryArt02 += "A2_NOME NOME, "
	cQryArt02 += "A2_END ENDERECO, "
	cQryArt02 += "A2_TEL TELEFONE, "
	cQryArt02 += "A2_COD_MUN COD_MUN, "
	cQryArt02 += "A2_MUN MUNICIPIO, "
	cQryArt02 += "A2_EST ESTADO, "
	cQryArt02 += "0.00 TTLCOMPRAS, "
	cQryArt02 += "E2_VALOR CTAPAGAR, "
	cQryArt02 += "E2_SALDO SLDPAGAR, "
	cQryArt02 += "E2_BAIXA DTBAIXA "
	cQryArt02 += " FROM "
	cQryArt02 += RetSqlName("SE2") + " SE2, "
	cQryArt02 += RetSqlName("SA2") + " SA2 "
	cQryArt02 += " WHERE "
	cQryArt02 += "  SE2.E2_FILIAL = '"+xFilial("SE2")+"' "
	cQryArt02 += "  AND SE2.E2_VENCTO BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFin)+"' "
	cQryArt02 += "  AND SE2.D_E_L_E_T_ = ' ' "
	cQryArt02 += "  AND SA2.A2_FILIAL = '"+xFilial("SA2")+"' "
	cQryArt02 += "  AND SA2.A2_COD = SE2.E2_FORNECE "
	cQryArt02 += "  AND SA2.A2_LOJA = SE2.E2_LOJA "
	cQryArt02 += "  AND SA2.D_E_L_E_T_ = ' ' "
	cQryArt02 += " ORDER BY FORNECE,LOJA "

	cQryArt02 := ChangeQuery(cQryArt02)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryArt02),"QRYA02",.T.,.F.)

	TcSetField("QRYA02","DTMOVTO" 	  ,"D",08,0)
	TcSetField("QRYA02","DTBAIXA" 	  ,"D",08,0)
	TcSetField("QRYA02","TTLCOMPRAS"  ,"N",aTamTTlCom[1],aTamTTlCom[2])
	TcSetField("QRYA02","CTAPAGAR"    ,"N",aTamCtaPag[1],aTamCtaPag[2])

	SA2->(dbSetOrder(1))    //Fornecedores
	SF3->(dbSetOrder(1))    //Livros Fiscais

	QRYA02->(dbGoTop())
	While QRYA02->(!Eof())
		cFornece := QRYA02->FORNECE
		cLoja    := QRYA02->LOJA

	    nTotalPago := 0.00
	    nTotalAber := 0.00
	    nTotalComp := 0.00

	    /*  dados do fornecedor */
		cAuxFORNECE	:= QRYA02->FORNECE
		cAuxLOJA	:= QRYA02->LOJA
		nPosTipo    := Ascan(aTipoDoc,{|tipo| tipo[1] == AllTrim(QRYA02->TIPODOC)})
		cAuxTIPODOC	:= If(nPosTipo>0,aTipoDoc[nPosTipo][2],"NA")
		If QRYA02->TIPODOC == "31"		//NIT
			cAuxNRDOC	:= QRYA02->NRDOC
			cAuxDV		:= Subs(QRYA02->NRDOC,10,1)
		Else
			cAuxNRDOC	:= QRYA02->NRDOC2
			cAuxDV		:= " "
		Endif
		cAuxNOME	:= QRYA02->NOME
		cAuxENDER	:= QRYA02->ENDERECO
		cAuxFONE	:= QRYA02->TELEFONE
		cAuxMUN		:= QRYA02->COD_MUN

		SX5->(DbSetOrder(1))
		If 	SX5->(DbSeek(xFilial("SX5")+"12"+QRYA02->ESTADO))
			cAuxESTADO:=Alltrim(X5Descri())
		EndIf

		dAuxDTMOVTO	:= QRYA02->DTMOVTO
		dAuxDTBAIXA	:= QRYA02->DTBAIXA
		While QRYA02->(!Eof()) .AND. QRYA02->FORNECE == cFornece .AND. QRYA02->LOJA == cLoja
		    If Empty(QRYA02->DTBAIXA)
				nTotalPago += QRYA02->CTAPAGAR
			Endif
			If AllTrim(QRYA02->NFESPEC) $ "NCP|NDI"
				nTotalComp -= QRYA02->TTLCOMPRAS
				nTotalAber -= QRYA02->SLDPAGAR
			Else
				nTotalComp += QRYA02->TTLCOMPRAS
				nTotalAber += QRYA02->SLDPAGAR
			Endif
			QRYA02->(dbSkip())
		Enddo

		If nTotalComp >= nLimite
			cMunicipio := ""
			CC2->(dbSetOrder(3))
			If CC2->(dbSeek(xFilial("CC2")+cAuxMUN))
				cMunicipio := CC2->CC2_MUN
			EndIf
	 		RecLock(cArqAux,.T.)
				(cArqAux)->FORNECE    := cAuxFORNECE
				(cArqAux)->LOJA	      := cAuxLOJA
				(cArqAux)->TIPODOC    := cAuxTIPODOC
				(cArqAux)->NRDOC	  := cAuxNRDOC
				(cArqAux)->DV		  := Subs(cAuxNRDOC,10,1)
				(cArqAux)->NOME		  := cAuxNOME
				(cArqAux)->ENDERECO	  := cAuxENDER
				(cArqAux)->TELEFONE   := cAuxFONE
				(cArqAux)->COD_MUN    := Subs(cAuxMUN,3,3)
				(cArqAux)->MUNICIPIO  := cMunicipio
				(cArqAux)->ESTADO     := cAuxESTADO
				(cArqAux)->DTMOVTO    := dAuxDTMOVTO
				(cArqAux)->DTBAIXA    := dAuxDTBAIXA
				(cArqAux)->TTLCOMPRAS := nTotalComp
				(cArqAux)->CTAPAGAR   := nTotalAber
			(cArqAux)->(MsUnLock())
		EndIf
	EndDo

RestArea(aSaveArea)
Return(cArqAux)

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณ GerInfoA4() ณ Autor ณ Jos้ Lucas			       ณ Data ณ 16.03.10	ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Cria arquivo de trabalho para gera็ใo e prepara็ใo dos dados para os ณฑฑ
ฑฑณ          ณ Relat๓rios Distritales Artigo 04.                                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ GerInfoA4(dDataIni,dDataFin,nLimite)                                 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ L๓gico .T. = Se gerado com Sucesso ou .F. Se houve falha no processo.ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Gen้rico                                                  			ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ ExpD1 = Data Inicial                                        		    ณฑฑ
ฑฑณ          ณ ExpD2 = Data Final                                          		    ณฑฑ
ฑฑณ          ณ ExpN3 = Valor Limite Inferior.                              		    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
/*/
Function GerInfoA4(dDataIni,dDataFin)
Local aSaveArea   := GetArea()
Local aTamFornece := TamSX3("A2_COD")
Local aTamLoja	  := TamSX3("A2_LOJA")
Local aTamTipoDoc := If(cPaisLoc $ "COL|EQU|PER",TamSX3("A2_TIPDOC"),{2,0,"C"})
Local aTamNrDoc   := TamSX3("A2_CGC")
Local aTamNome	  := TamSX3("A2_NOME")
Local aTamEnde    := TamSX3("A2_END")
Local aTamTel	  := TamSX3("A2_TEL")
Local aTamCodMun  := TamSX3("A2_COD_MUN")
Local aTamCid	  := TamSX3("A2_MUN")
Local aTamEstado  := TamSX3("A2_ESTADO")
Local aTamVConta  := TamSX3("F3_VALCONT")
Local aTamBasImp  := TamSX3("F3_BASIMP1")
Local aTamAlqImp  := TamSX3("F3_ALQIMP1")
Local aTamVALIMP  := TamSX3("F3_VALIMP1")
Local cFornece    := ""
Local cLoja       := ""
Local cAliq       := ""
Local nTotalPago  := 0.00
Local nTotalAber  := 0.00
Local aTipoDoc    := {{"13","CC"},{"23","CE"},{"12","TI"},{"31","NIT"},{"11","RC"},{"41","PA"}}
Local nPosTipo    := 0
Local cCpoBase    := "F3_BASIMP"
Local cCpoAlq     := "F3_ALQIMP"
Local cCpoRet     := "F3_VALIMP"
Local cArqAux     := "ARTIGO4"
Local aCampos     := {}
Local cMunicipio  := ""

DEFAULT dDataIni  := CTOD("01/01/01")
DEFAULT dDataFim  := CTOD("31/12/49")

	If ExistBlock("ESPINFOA04")
		ExecBlock("ESPINFOA04",.F.,.F.,{dDataIni,dDataFin,nLimite})
		Return(cArqAux)
	EndIf

	SFB->(dbSetOrder(1))
	If SFB->(dbSeek(xFilial("SFB")+"RC0"))
	    cColImp := SFB->FB_CPOLVRO

	    cCpoBase += SFB->FB_CPOLVRO
		cCpoAlq += SFB->FB_CPOLVRO
		cCpoRet += SFB->FB_CPOLVRO
		aTamBasImp := TamSX3(cCpoBase)
		aTamAlqImp := TamSX3(cCpoAlq)
		aTamVALIMP := TamSX3(cCpoRet)
		If Len(aTamBasImp) == 0 .or. Len(aTamAlqImp) == 0 .or. Len(aTamVALImp) == 0
			aTamBasImp := TamSX3("F3_BASIMP1")
			aTamAlqImp := TamSX3("F3_ALQIMP1")
			aTamVALIMP := TamSX3("F3_VALIMP1")
		EndIf
	Else
		Help(" ",1,"F3ICA",,STR0006,1,0)//"Fijar la configuracion de la retenci๓n de ICA en la tabla de impuestos."
		Return .F.
	EndIf

	If Select(cArqAux) > 0
		dbSelectArea(cArqAux)
		dbCloseArea()
	EndIf

	AADD(aCampos,{ "DTMOVTO"	, "D", 08			 , 0 })  				// Data do Movimento
	AADD(aCampos,{ "FORNECE"	, "C", aTamFornece[1], 0 })  				// Codigo do Fornecedor
	AADD(aCampos,{ "LOJA"		, "C", aTamLoja[1]	 , 0 })  				// Loja
	AADD(aCampos,{ "TIPODOC" 	, "C", aTamTipoDoc[1], 0 })					// Tipo do Documneto
	AADD(aCampos,{ "NRDOC"		, "C", aTamNrDoc[1]	 , 0 })					// Numero do Documento
	AADD(aCampos,{ "DV"         , "C", 01            , 0 })                 // Digito Verificador do Documento
	AADD(aCampos,{ "NOME"		, "C", aTamNome[1]	 , 0 }) 	 			// Nome
	AADD(aCampos,{ "ENDERECO"	, "C", aTamEnde[1]	 , 0 })  				// Endereco
	AADD(aCampos,{ "TELEFONE"	, "C", aTamTel[1]	 , 0 })  				// Telefone
	AADD(aCampos,{ "COD_MUN"	, "C", aTamCodMun[1] , 0 })					// Codigo Oficial do Municipio
	AADD(aCampos,{ "MUNICIPIO"	, "C", aTamCid[1]    , 0 })	 				// Nome do Municipio
	AADD(aCampos,{ "ESTADO"		, "C", aTamEstado[1] , 0 })					// Estado
	AADD(aCampos,{ "VALORCONT"	, "N", aTamVConta[1] , aTamVConta[2] })		// Valor Contabil
	AADD(aCampos,{ "BASIMP"     , "N", aTamBasImp[1] , aTamBasImp[2] })		// Base do Imposto
	AADD(aCampos,{ "ALQIMP"		, "N", aTamAlqImp[1] , aTamAlqImp[2] })		// Alicuota do Imposto
	AADD(aCampos,{ "ALQIDX"		, "C", aTamAlqImp[1] , 0 })					// Alicuota do Imposto usada para indexar o arquivo
	AADD(aCampos,{ "VALIMP"		, "N", aTamVALIMP[1] , aTamVALIMP[2] })		// Valor da Reten็ใo

	cArqTmp := CriaTrab(aCampos, .T.)
	dbUseArea( .T.,, cArqTmp, cArqAux, .F., .F. )
	lCriaInd := .T.
	DbSelectarea(cArqAux)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria Indice Temporario do Arquivo de Trabalho 1.             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lCriaInd
		cChave  := "FORNECE+LOJA+ALQIDX"
		cArqInd	:= CriaTrab(Nil, .F.)
		IndRegua(cArqAux,cArqInd,cChave,,,OemToAnsi(STR0001))  //"Selecionando Registros..."
	EndIf

	If Select("QRYA04") > 0
		dbSelectArea("QRYA04")
		dbCloseArea()
	EndIf

	cQryArt04 := ""
	cQryArt04 += "SELECT "
	cQryArt04 += "F3_ENTRADA DTMOVTO, "
	cQryArt04 += "F3_CLIEFOR FORNECE, "
	cQryArt04 += "F3_LOJA LOJA, "
	cQryArt04 += "F3_ESPECIE NFESPEC, "
	If cPaisLoc $ "COL|EQU|PER"
		cQryArt04 += "A2_TIPDOC TIPODOC, "
	EndIf
	cQryArt04 += "A2_PFISICA NRDOC2, "
	cQryArt04 += "A2_CGC NRDOC, "
	cQryArt04 += "A2_NOME NOME, "
	cQryArt04 += "A2_END ENDERECO, "
	cQryArt04 += "A2_TEL TELEFONE, "
	cQryArt04 += "A2_COD_MUN COD_MUN, "
	cQryArt04 += "A2_MUN MUNICIPIO, "
	cQryArt04 += "A2_EST ESTADO, "
	cQryArt04 += "F3_VALCONT VALORCONT, "
	If !Empty(cColImp)
		cQryArt04 += "F3_BASIMP"+cColImp+" BASIMP, "
		cQryArt04 += "F3_ALQIMP"+cColImp+" ALQIMP, "
		cQryArt04 += "F3_VALIMP"+cColImp+" VALIMP "
	EndIf
	cQryArt04 += " FROM "
	cQryArt04 += RetSqlName("SF3") + " SF3, "
	cQryArt04 += RetSqlName("SA2") + " SA2 "
	cQryArt04 += " WHERE "
	cQryArt04 += "  SF3.F3_FILIAL = '"+xFilial("SF3")+"' "
	cQryArt04 += "  AND SF3.F3_TIPOMOV = 'C' "
	cQryArt04 += "  AND SF3.F3_BASIMP" + cColImp + " <> 0"
	cQryArt04 += "  AND SF3.F3_ENTRADA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFin)+"' "
	cQryArt04 += "  AND SF3.D_E_L_E_T_ = ' ' "
	cQryArt04 += "  AND SA2.A2_FILIAL = '"+xFilial("SA2")+"' "
	cQryArt04 += "  AND SA2.A2_COD = SF3.F3_CLIEFOR "
	cQryArt04 += "  AND SA2.A2_LOJA = SF3.F3_LOJA "
	cQryArt04 += "  AND SA2.D_E_L_E_T_ = ' ' "
	cQryArt04 += " ORDER BY FORNECE,LOJA,NRDOC"

	cQryArt04 := ChangeQuery(cQryArt04)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryArt04),"QRYA04",.T.,.F.)

	TcSetField("QRYA04","DTMOVTO" 	  ,"D",08,0)
	TcSetField("QRYA04","VALORCONT"   ,"N",aTamVConta[1],aTamVConta[2])
	TcSetField("QRYA04","BASIMP"      ,"N",aTamBasImp[1],aTamBasImp[2])
	TcSetField("QRYA04","ALQIMP"	  ,"N",aTamAlqImp[1],aTamAlqImp[2])
	TcSetField("QRYA04","VALIMP" 	  ,"N",aTamVALIMP[1],aTamVALIMP[2])

	SA2->(dbSetOrder(1))    //Fornecedores
	SF3->(dbSetOrder(1))    //Livros Fiscais
	CC2->(dbSetOrder(3))

	QRYA04->(dbGoTop())
	While QRYA04->(!Eof())

	    cFornece := QRYA04->FORNECE
	    cLoja    := QRYA04->LOJA

	    nTotalPago := 0.00
	    nTotalAber := 0.00

		While QRYA04->(!Eof()) .AND. QRYA04->FORNECE == cFornece .AND. QRYA04->LOJA == cLoja
			cAliq := StrZero(QRYA04->ALQIMP,aTamAlqImp[1],aTamAlqImp[2])
	   		cSeek := cFornece + cLoja + cAliq
	   		If ! (cArqAux)->(dbSeek(cSeek))
				cMunicipio := ""
				If CC2->(dbSeek(xFilial("CC2")+QRYA04->COD_MUN))
					cMunicipio := CC2->CC2_MUN
				EndIf
		 		RecLock(cArqAux,.T.)
			   		nPosTipo := Ascan(aTipoDoc,{|x| AllTrim(x[1]) == AllTrim(QRYA04->TIPODOC)})
					(cArqAux)->FORNECE    := QRYA04->FORNECE
					(cArqAux)->LOJA	      := QRYA04->LOJA
					(cArqAux)->TIPODOC    := If(nPosTipo>0,aTipoDoc[nPosTipo][2],"NA")
					If AllTrim(QRYA04->TIPODOC) == "31"		//NIT
						(cArqAux)->NRDOC	  := QRYA04->NRDOC
					Else
						(cArqAux)->NRDOC	  := QRYA04->NRDOC2
					Endif
					(cArqAux)->NOME		  := QRYA04->NOME
					(cArqAux)->ENDERECO   := QRYA04->ENDERECO
					(cArqAux)->TELEFONE   := QRYA04->TELEFONE
					(cArqAux)->COD_MUN    := Subs(QRYA04->COD_MUN,3,3)
					(cArqAux)->MUNICIPIO  := cMunicipio

					SX5->(DbSetOrder(1))
					If 	SX5->(DbSeek(xFilial("SX5")+"12"+QRYA04->ESTADO))
						(cArqAux)->ESTADO :=Alltrim(X5Descri())
					EndIf

					(cArqAux)->VALORCONT  := QRYA04->VALORCONT
					(cArqAux)->DTMOVTO    := QRYA04->DTMOVTO
					(cArqAux)->ALQIMP     := QRYA04->ALQIMP
					(cArqAux)->ALQIDX     := cAliq
			Else
		 		RecLock(cArqAux,.F.)
			Endif
			If AllTrim(QRYA04->NFESPEC) $ "NCP|NDI"
				(cArqAux)->BASIMP     -= QRYA04->BASIMP
				(cArqAux)->VALIMP     -= QRYA04->VALIMP
			Else
				(cArqAux)->BASIMP     += QRYA04->BASIMP
				(cArqAux)->VALIMP     += QRYA04->VALIMP
			Endif
			(cArqAux)->(MsUnLock())
			QRYA04->(dbSkip())
		EndDo
	EndDo

RestArea(aSaveArea)
Return(cArqAux)

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณ GerInfoA6() ณ Autor ณ Jos้ Lucas 			      ณ Data ณ 16.03.10	ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Cria arquivo de trabalho para gera็ใo e prepara็ใo dos dados para os ณฑฑ
ฑฑณ          ณ Relat๓rios Distritales Artigo 06, Reten็ao de ICA;	 	            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ GerInfoA06(dDataIni,dDataFin,nLimite)                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ L๓gico .T. = Se gerado com Sucesso ou .F. Se houve falha no processo.ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Gen้rico                                                  			ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ ExpD1 = Data Inicial                                        		    ณฑฑ
ฑฑณ          ณ ExpD2 = Data Final                                          		    ณฑฑ
ฑฑณ          ณ ExpN3 = Valor Limite Inferior.                              		    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
/*/
Function GerInfoA6(dDataIni,dDataFin,nLimite)
Local aSaveArea   := GetArea()
Local aTamFornece := TamSX3("A1_COD")
Local aTamLoja	  := TamSX3("A1_LOJA")
Local aTamTipoDoc := If(cPaisLoc $ "COL|EQU|PER",TamSX3("A1_TIPDOC"),{2,0,"C"})
Local aTamNrDoc   := TamSX3("A1_CGC")
Local aTamNome	  := TamSX3("A1_NOME")
Local aTamEnde    := TamSX3("A1_END")
Local aTamTel	  := TamSX3("A1_TEL")
Local aTamCodMun  := TamSX3("A1_COD_MUN")
Local aTamCid	  := TamSX3("A1_MUN")
Local aTamEstado  := TamSX3("A1_ESTADO")
Local aTamVConta  := TamSX3("F3_VALCONT")
Local aTamBasImp  := TamSX3("F3_BASIMP1")
Local aTamAlqImp  := TamSX3("F3_ALQIMP1")
Local aTamVALIMP  := TamSX3("F3_VALIMP1")
Local cCliente    := ""
Local cLoja       := ""
/* dados do cliente */
Local cAuxCLIENTE	:= ""
Local cAuxLOJA		:= ""
Local cAuxTIPODOC	:= ""
Local cAuxNRDOC		:= ""
Local cAuxNOME		:= ""
Local cAuxENDER		:= ""
Local cAuxFONE		:= ""
Local cAuxMUN		:= ""
Local cAuxESTADO	:= ""
Local nAuxVALORCONT	:= 0
Local nAuxALQIMP	:= 0
Local dAuxDTMOVTO	:= Ctod("//")
/*-*/
Local nTotalPago  := 0.00
Local nTotalRet   := 0.00
Local aTipoDoc    := {{"13","CC"},{"23","CE"},{"12","TI"},{"31","NIT"},{"11","RC"},{"41","PA"}}
Local nPosTipo    := 0
Local cCpoBase    := "F3_BASIMP"
Local cCpoAlq     := "F3_ALQIMP"
Local cCpoRet     := "F3_VALIMP"
Local cArqAux     := "ARTIGO6"
Local aCampos     := {}
Local cMunicipio  := ""

DEFAULT dDataIni  := CTOD("  /  /  ")
DEFAULT dDataFim  := CTOD("31/12/10")
DEFAULT nLimite   := If(Empty(nLimite),1000000,Val(nLimite))

	If ExistBlock("ESPINFOA6")
		ExecBlock("ESPINFOA6",.F.,.F.,{dDataIni,dDataFin,nLimite})
		Return(cArqAux)
	EndIf

	SFB->(dbSetOrder(1))
	If SFB->(dbSeek(xFilial("SFB")+"RC0"))
	    cColImp := SFB->FB_CPOLVRO
	    cCpoBase += SFB->FB_CPOLVRO
		cCpoAlq += SFB->FB_CPOLVRO
		cCpoRet += SFB->FB_CPOLVRO
		aTamBasImp := TamSX3(cCpoBase)
		aTamAlqImp := TamSX3(cCpoAlq)
		aTamVALIMP := TamSX3(cCpoRet)
		If Len(aTamBasImp) == 0 .or. Len(aTamAlqImp) == 0 .or. Len(aTamVALImp) == 0
			aTamBasImp := TamSX3("F3_BASIMP1")
			aTamAlqImp := TamSX3("F3_ALQIMP1")
			aTamVALIMP := TamSX3("F3_VALIMP1")
		EndIf
	Else
		Help(" ",1,"F3ICA",,STR0006,1,0)//"Fijar la configuracion de la retenci๓n de ICA en la tabla de impuestos."
		Return .F.
	EndIf

	If Select(cArqAux) > 0
		dbSelectArea(cArqAux)
		dbCloseArea()
	EndIf

	AADD(aCampos,{ "DTMOVTO"	, "D", 08			 , 0 })  				// Data do Movimento
	AADD(aCampos,{ "CLIENTE"	, "C", aTamFornece[1], 0 })  				// Codigo do Cliente
	AADD(aCampos,{ "LOJA"		, "C", aTamLoja[1]	 , 0 })  				// Loja
	AADD(aCampos,{ "TIPODOC" 	, "C", aTamTipoDoc[1], 0 })					// Tipo do Documneto
	AADD(aCampos,{ "NRDOC"		, "C", aTamNrDoc[1]	 , 0 })					// Numero do Documento
	AADD(aCampos,{ "DV"         , "C", 01            , 0 })                 // Digito Verificador do Documento
	AADD(aCampos,{ "NOME"		, "C", aTamNome[1]	 , 0 }) 	 			// Nome
	AADD(aCampos,{ "ENDERECO"	, "C", aTamEnde[1]	 , 0 })  				// Endereco
	AADD(aCampos,{ "TELEFONE"	, "C", aTamTel[1]	 , 0 })  				// Telefone
	AADD(aCampos,{ "COD_MUN"	, "C", aTamCodMun[1] , 0 })					// Codigo Oficial do Municipio
	AADD(aCampos,{ "MUNICIPIO"	, "C", aTamCid[1]    , 0 })	 				// Nome do Municipio
	AADD(aCampos,{ "ESTADO"		, "C", aTamEstado[1] , 0 })					// Estado
	AADD(aCampos,{ "VALORCONT"	, "N", aTamVConta[1] , aTamVConta[2] })		// Valor Contabil
	AADD(aCampos,{ "BASIMP"	    , "N", aTamBasImp[1] , aTamBasImp[2] })		// Base do Imposto
	AADD(aCampos,{ "ALQIMP"		, "N", aTamAlqImp[1] , aTamAlqImp[2] })		// Alicuota do Imposto
	AADD(aCampos,{ "VALIMP"		, "N", aTamVALIMP[1] , aTamVALIMP[2] })		// Valor da Reten็ใo

	cArqTmp := CriaTrab(aCampos, .T.)
	dbUseArea( .T.,, cArqTmp, cArqAux, .F., .F. )
	lCriaInd := .T.
	DbSelectarea(cArqAux)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria Indice Temporario do Arquivo de Trabalho 1.             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lCriaInd
		cChave  := "CLIENTE+LOJA"
		cArqInd	:= CriaTrab(Nil, .F.)
		IndRegua(cArqAux,cArqInd,cChave,,,OemToAnsi(STR0001))  //"Selecionando Registros..."
	EndIf

	If Select("QRYA06") > 0
		dbSelectArea("QRYA06")
		dbCloseArea()
	EndIf

	cQryArt06 := ""
	cQryArt06 += "SELECT "
	cQryArt06 += "F3_ENTRADA DTMOVTO, "
	cQryArt06 += "F3_CLIEFOR CLIENTE, "
	cQryArt06 += "F3_LOJA LOJA, "
	cQryArt06 += "F3_ESPECIE NFESPEC, "
	If cPaisLoc $ "COL|EQU|PER"
		cQryArt06 += "A1_TIPDOC TIPODOC, "
	EndIf
	cQryArt06 += "A1_PFISICA NRDOC2, "
	cQryArt06 += "A1_CGC NRDOC, "
	cQryArt06 += "A1_NOME NOME, "
	cQryArt06 += "A1_END ENDERECO, "
	cQryArt06 += "A1_TEL TELEFONE, "
	cQryArt06 += "A1_COD_MUN COD_MUN, "
	cQryArt06 += "A1_MUN MUNICIPIO, "
	cQryArt06 += "A1_EST ESTADO, "
	cQryArt06 += "F3_VALCONT VALORCONT, "
	If !Empty(cColImp)
		cQryArt06 += "F3_BASIMP"+cColImp+" BASIMP, "
		cQryArt06 += "F3_ALQIMP"+cColImp+" ALQIMP, "
		cQryArt06 += "F3_VALIMP"+cColImp+" VALIMP "
	EndIf
	cQryArt06 += " FROM "
	cQryArt06 += RetSqlName("SF3") + " SF3, "
	cQryArt06 += RetSqlName("SA1") + " SA1 "
	cQryArt06 += " WHERE "
	cQryArt06 += "  SF3.F3_FILIAL = '"+xFilial("SF3")+"' "
	cQryArt06 += "  AND SF3.F3_TIPOMOV = 'V' "
	cQryArt06 += "  AND SF3.F3_BASIMP" + cColImp + " <> 0"
	cQryArt06 += "  AND SF3.F3_ENTRADA BETWEEN '"+DTOS(dDataIni)+"' AND '"+DTOS(dDataFin)+"' "
	cQryArt06 += "  AND SF3.D_E_L_E_T_ = ' ' "
	cQryArt06 += "  AND SA1.A1_FILIAL = '"+xFilial("SA1")+"' "
	cQryArt06 += "  AND SA1.A1_COD = SF3.F3_CLIEFOR "
	cQryArt06 += "  AND SA1.A1_LOJA = SF3.F3_LOJA "
	cQryArt06 += "  AND SA1.D_E_L_E_T_ = ' ' "
	cQryArt06 += " ORDER BY CLIENTE,LOJA"

	cQryArt06 := ChangeQuery(cQryArt06)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryArt06),"QRYA06",.T.,.F.)

	TcSetField("QRYA06","DTMOVTO" 	  ,"D",08,0)
	TcSetField("QRYA06","VALORCONT"   ,"N",aTamVConta[1],aTamVConta[2])
	TcSetField("QRYA06","BASIMP"      ,"N",aTamBasImp[1],aTamBasImp[2])
	TcSetField("QRYA06","ALQIMP"	  ,"N",aTamAlqImp[1],aTamAlqImp[2])
	TcSetField("QRYA06","VALIMP" 	  ,"N",aTamVALIMP[1],aTamVALIMP[2])

	SA2->(dbSetOrder(1))    //Fornecedores
	SF3->(dbSetOrder(1))    //Livros Fiscais
	CC2->(dbSetOrder(3))

	QRYA06->(dbGoTop())
	While QRYA06->(!Eof())

	    cCliente := QRYA06->CLIENTE
	    cLoja    := QRYA06->LOJA

	    nTotalPago := 0.00
	    nTotalRet  := 0.00
	    /*
	    dados do cliente */
		cAuxCLIENTE		:= QRYA06->CLIENTE
		cAuxLOJA		:= QRYA06->LOJA
		nPosTipo 		:= Ascan(aTipoDoc,{|x| AllTrim(x[1]) == AllTrim(QRYA06->TIPODOC)})
		cAuxTIPODOC		:= If(nPosTipo>0,aTipoDoc[nPosTipo][2],"NA")
		If AllTrim(QRYA06->TIPODOC) == "31"		//NIT
			cAuxNRDOC		:= QRYA06->NRDOC
		Else
			cAuxNRDOC		:= QRYA06->NRDOC2
		Endif
		cAuxNOME		:= QRYA06->NOME
		cAuxENDER		:= QRYA06->ENDERECO
		cAuxFONE		:= QRYA06->TELEFONE
		cAuxMUN			:= QRYA06->COD_MUN

		SX5->(DbSetOrder(1))
		If 	SX5->(DbSeek(xFilial("SX5")+"12"+QRYA06->ESTADO))
			cAuxESTADO:=Alltrim(X5Descri())
		EndIf

		nAuxVALORCONT	:= QRYA06->VALORCONT
		nAuxALQIMP		:= QRYA06->ALQIMP
		dAuxDTMOVTO		:= QRYA06->DTMOVTO
		While QRYA06->(!Eof()) .AND. QRYA06->CLIENTE == cCliente .AND. QRYA06->LOJA == cLoja
			If QRYA06->NFESPEC $ "NCC,NDE"
				nTotalPago -= QRYA06->BASIMP
				nTotalRet  -= QRYA06->VALIMP
			Else
				nTotalPago += QRYA06->BASIMP
				nTotalRet  += QRYA06->VALIMP
			EndIf
			QRYA06->(dbSkip())
		EndDo
		If nTotalRet >= nLimite
			cMunicipio := ""
			If CC2->(dbSeek(xFilial("CC2")+cAuxMUN))
				cMunicipio := CC2->CC2_MUN
			EndIf
	   		nPosTipo := Ascan(aTipoDoc,{|x| AllTrim(x[1]) == AllTrim(QRYA06->TIPODOC)})
			RecLock(cArqAux,.T.)
				(cArqAux)->CLIENTE    := cAuxCLIENTE
				(cArqAux)->LOJA	      := cAuxLOJA
				(cArqAux)->TIPODOC    := cAuxTIPODOC
				(cArqAux)->NRDOC	  := cAuxNRDOC
				(cArqAux)->NOME		  := cAuxNOME
				(cArqAux)->ENDERECO   := cAuxENDER
				(cArqAux)->TELEFONE	  := cAuxFONE
				(cArqAux)->COD_MUN    := Subs(cAuxMUN,3,3)
				(cArqAux)->MUNICIPIO  := cMunicipio
				(cArqAux)->ESTADO     := cAuxESTADO
				(cArqAux)->VALORCONT  := nAuxVALORCONT
				(cArqAux)->ALQIMP     := nAuxALQIMP
				(cArqAux)->DTMOVTO    := dAuxDTMOVTO
				(cArqAux)->BASIMP     := nTotalPago
				(cArqAux)->VALIMP     := nTotalRet
			(cArqAux)->(MsUnLock())
		Endif
	EndDo

RestArea(aSaveArea)
Return(cArqAux)

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณ GerInfFMTณ Autor ณ Jos้ Lucas		           ณ Data ณ 09.03.10	ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Cria arquivo de trabalho para gera็ใo e prepara็ใo dos dados para os ณฑฑ
ฑฑณ          ณ relat๓rios em meio magn้ticos no Formato 1001...5002.                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ GerInfFMT(cPlanoRef,dDataIni,dDataFin,cMoeda,nLimite,nColuna,        ณฑฑ
ฑฑณ			 ณ ,cEntCont,cTipDoc,cDocumen,cDocEst,cCodDoc,aLimSec)					ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ Area de trabalho (FMT<1001>).                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Gen้rico                                                  			ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ ExpC1 = Pano Referencial                                   		    ณฑฑ
ฑฑณ          ณ ExpD1 = Data Inicial                                        		    ณฑฑ
ฑฑณ          ณ ExpD2 = Data Final                                          		    ณฑฑ
ฑฑณ          ณ ExpC2 = Moeda		                                     		    ณฑฑ
ฑฑณ          ณ ExpN1 = Valor Limite Inferior.                              		    ณฑฑ
ฑฑณ          ณ ExpN2 = Quantidade de Colunas dos saldos a imprimir.        		    ณฑฑ
ฑฑณ          ณ ExpC3 = Entidade Contabeis para processamento.		       		    ณฑฑ
ฑฑณ          ณ ExpC4 = Tipo Documento para valores abaixo do limite.       		    ณฑฑ
ฑฑณ          ณ ExpC5 = Documento para valores abaixo do limite.            		    ณฑฑ
ฑฑณ          ณ ExpC6 = Tipo de Documento para estrangeiros.                		    ณฑฑ
ฑฑณ          ณ ExpC7 = Documento para estrageiros.	                       		    ณฑฑ
ฑฑณ          ณ ExpA1 = Limite Secundarios.                                		    ณฑฑ
ฑฑณ          ณ ExpL1 = Flag para filtrar registros ja gerados.             		    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
/*/
Function GerInfFMT(cPlanoRef,dDataIni,dDataFin,cMoeda,nLimite,nColunas,cEntCont,cTipDoc,cDocumen,cDocEst,cCodDoc,aLimSec,lFirst)
Local aSaveArea  := GetArea()
Local aTamCodPla := TamSX3("CVD_CODPLA")
Local aTamCtaRef := TamSX3("CVD_CTAREF")
Local aTamTipo00 := If(cPaisLoc == "COL",TamSX3("CV0_TIPO00"),{2,0,"C"})
Local aTamTipDoc := If(cPaisLoc $ "COL|EQU|PER",TamSX3("A1_TIPDOC"),{2,0,"C"})
Local aTamNrDoc  := TamSX3("CV0_CODIGO")
Local aTamPNome  := TamSX3("A1_NOME")
Local aTamSNome  := If(cPaisLoc == "COL",TamSX3("A1_NOMEPES"),{20,0,"C"})
Local aTamPSobr  := If(cPaisLoc == "COL",TamSX3("A1_NOMEMAT"),{20,0,"C"})
Local aTamSSobr  := If(cPaisLoc == "COL",TamSX3("A1_NOMEMAT"),{20,0,"C"})
Local aTamRazao  := TamSX3("A1_NOME")
Local aTamEnder  := TamSX3("A1_END")
Local aTamMunic  := TamSX3("A1_COD_MUN")
Local aTamEstad  := TamSX3("A1_EST")
Local aTamPais   := TamSX3("A1_PAIS")
Local aTamSldCrd := TamSX3("CVY_SLDCRD")
Local aTamPart   := TamSX3("CVC_PARTIC")

Local cPriNome := ""
Local cSegNome := ""
Local cPriSobr := ""
Local cSegSobr := ""
Local cRazao   := ""
Local cEnd     := ""
Local cCod_Mun := ""
Local cEstado  := ""
Local cPais    := ""
Local cNrDoc   := ""
Local cCpoVal  := ""
Local cCpoDB   := ""
Local cCpoCR   := ""
Local aCtbMoeda   := {}
Local aCampos     := {}
Local lCriaInd    := .F.
Local lImpAntLP   := .F.
Local dDataLP     := CTOD("  /  /  ")
Local nCntEstran  := 0
Local cNrDocEstra := ""
Local nPercPart   := 0.00
Local nI          := 0

DEFAULT cTipDoc   := ""
DEFAULT cDocumen  := ""
DEFAULT cDocEst   := ""
DEFAULT cCodDoc   := ""
DEFAULT cEntCont  := "1"
DEFAULT cMoeda    := ""
DEFAULT lFirst    := .T.

	// Retorna Decimais
	aCtbMoeda := CTbMoeda(cMoeda)
	nDecimais := aCtbMoeda[5]
	dMinData  := CTOD("")
	cArqAux   := "FMT"+AllTrim(cPlanoRef)

	If !lFirst
		RestArea(aSaveArea)
		Return(cArqAux)
	EndIf

	// Verifica passagem de parametros
	cNrDocEstra := If(Empty(cCodDoc),"444444001",cCodDoc)
	cMoeda      := If(Empty(cMoeda),"01",cMoeda)
	If ExistBlock("ESPINFOFMT")
		ExecBlock("ESPINFOFMT",.F.,.F.,{cPlanoRef,dDataIni,dDataFin,cMoeda,nLimite,nColunas,cTipDoc,cDocumen,cDocEst,cCodDoc,aLimSec})
		Return(cArqAux)
	EndIf

	//Cierra tabla temporal.
	If Select(cArqAux) > 0
   		__oTmpFMT:Delete()
	EndIf

	If __oTmpFMT <> Nil
		__oTmpFMT:Delete()
	EndIf

	AADD(aCampos,{ "PLANOREF"	, "C", aTamCodPla[1], 0 })  				// Codigo Plano Referencial
	AADD(aCampos,{ "CTAREF"		, "C", aTamCtaRef[1], 0 })  				// Codigo da Conta Referencial
	AADD(aCampos,{ "TIPO3"		, "C", aTamTipo00[1], 0 })  				// Tipo do Documento
	AADD(aCampos,{ "TIPODOC" 	, "C", aTamTipDoc[1], 0 })					// Tipo do Documneto
	AADD(aCampos,{ "NRDOC"		, "C", aTamNrDoc[1]	, 0 })					// Numero do Documento
	AADD(aCampos,{ "DV"         , "C", 01           , 0 })                  // Digito Verificador do Documento
	AADD(aCampos,{ "PRINOME"	, "C", aTamPNome[1]	, 0 }) 	 				// Primeiro Nome
	AADD(aCampos,{ "SEGNOME"	, "C", aTamPSobr[1]	, 0 })  				// Segundo Nome
	AADD(aCampos,{ "PRISNOME"	, "C", aTamSSobr[1]	, 0 })  				// Primeiro Sobrenome
	AADD(aCampos,{ "SEGSNOME"	, "C", aTamSNome[1]	, 0 })					// Segundo Sobrenome
	AADD(aCampos,{ "RAZAO"		, "C", aTamRazao[1]+10 , 0 })	 				// Nome ou Razao Social
	AADD(aCampos,{ "ENDERECO"	, "C", aTamEnder[1] , 0 })					// Endereco
	AADD(aCampos,{ "MUNICIPIO"	, "C", aTamMunic[1] , 0 })					// Municipio
	AADD(aCampos,{ "ESTADO"		, "C", aTamEstad[1] , 0 })					// Estado
	AADD(aCampos,{ "PAIS"		, "C", aTamPais[1]  , 0 })					// Pais
	AADD(aCampos,{ "VALORPAG"	, "N", aTamSldCrd[1]+9, aTamSldCrd[2]+2 })	// Valor Pago
	AADD(aCampos,{ "VALORDED"	, "N", aTamSldCrd[1]+9, aTamSldCrd[2]+2 })	// Valor Dedu็ใo
	AADD(aCampos,{ "PERCPART"	, "N", aTamPart[1]  , aTamPart[2] })		// Percentual de Participa็ใo.
	AADD(aCampos,{ "NOMARQ"		, "C", 08		    , 0 })					// Nome do Arquivo.
	AADD(aCampos,{ "EMAIL"		, "C", 50		    , 0 })					// Nome do Arquivo.

	For nI := 3 To nColunas //jgr
		AADD(aCampos,{ "VALOR"+StrZero(nI,2)	, "N", aTamSldCrd[1]+9, aTamSldCrd[2]+2 })	// Valor colunas 03 a n  (conf. CVD_COLUNA)
	Next

	//Crea tabla temporal
	__oTmpFMT := FWTemporaryTable():New(cArqAux)
	__oTmpFMT:SetFields( aCampos )
	__oTmpFMT:AddIndex("T1", {"PLANOREF","CTAREF","TIPODOC","NRDOC","PRINOME","SEGNOME","PRISNOME","SEGSNOME"})
	__oTmpFMT:AddIndex("T2", {"NOMARQ","PLANOREF","CTAREF","TIPODOC","NRDOC","PRINOME","SEGNOME","PRISNOME","SEGSNOME"})
	__oTmpFMT:Create()

	cArqPlan := CtPlanoRef(,,,,cPlanoRef,,,dDataIni,dDataFin,cMoeda,"1",lImpAntLP,dDataLP,.T.,nColunas,cEntCont,,,,,,)

	CV0->(dbSetOrder(2))    //Entidades
	SA1->(dbSetOrder(3))    //Clientes
	SA2->(dbSetOrder(3))    //Fornecedores
	SRA->(dbSetOrder(5))    //Assalariados
	CVC->(dbSetOrder(2))	//Participantes

	(cArqPlan)->(dbGoTop())
	While (cArqPlan)->(!Eof())
	    cPriNome  := ""
	    cSegNome  := ""
	    cPriSobr  := ""
	    cSegSobr  := ""
	    cRazao    := ""
	    cEnd      := ""
	    cCod_Mun  := ""
	    cEstado   := ""
	    cPais     := ""
	    cTipoDoc  := ""
	    cNrDoc    := ""
	    nPercPart := 0.00
	    cEmail    := ""

		If ! AllTrim((cArqPlan)->PLANOREF) $ "1004|1011"
			cPriNome := "Desconocido" //"Desconocido"
		   	cSegNome := "Desconocido" //"Desconocido"
		   	cPriSobr := "Desconocido" //"Desconocido"
			cSegSobr := "Desconocido" //"Desconocido"
		   	cEnd     := "                    "
		   	cCod_Mun := "       "
		   	cEstado  := "   "
		   	cPais    := "   "
		   	cNrDoc   := AllTrim((cArqPlan)->ENTCTB)

			If EMPTY((cArqPlan)->ENTCTB)
				cRazao   := "Entidad 05 No identificado" //"Entidad 05 No identificado"
	    	   	cTipoDoc := "ENT"
		 	ElseIf CV0->(dbSeek(xFilial("CV0")+AllTrim((cArqPlan)->ENTCTB)))
		 		If cPaisLoc == "COL" .And. CV0->CV0_TIPO00 == "01"
		 			IF SeekCTE((cArqPlan)->ENTCTB)
		 				cPriNome := QryCte->A1_NOMEPRI
		    	  	 	cSegNome := QryCte->A1_NOMEPES
		    	   		cPriSobr := QryCte->A1_NOMEMAT
		 		   	   	cSegSobr := QryCte->A1_NOMEPAT
		    		   	cRazao   := QryCte->A1_NOME
		    		   	cEnd     := QryCte->A1_END
		    	   		cCod_Mun := QryCte->A1_COD_MUN
		    	  	 	cEstado  := QryCte->A1_EST
		    	   		cPais    := QryCte->A1_PAIS
		    	   		cTipoDoc := QryCte->A1_TIPDOC
		    	   		cNrDoc   := QryCte->A1_CGC
		    	   		cEmail	 := QryCte->A1_EMAIL
		    	   		If ExistBlock("DIGVERCOL")
			    			cNrDoc   := ExecBlock("DIGVERCOL",.F.,.F.,{"QryCte",cNrDoc})
			    		EndIf
		    	   	Else
		    	   		cRazao   := "Entidad Cliente No Identificado" //"Entidad Cliente No Identificado"
		    	   		cTipoDoc := "CLI"
		    		EndIf
					QryCte->(dbclosearea())

					SA1->(dbSetOrder(3))    //Clientes
				ElseIf cPaisLoc == "COL" .And. CV0->CV0_TIPO00 == "02"
	     			IF SeekPRO((cArqPlan)->ENTCTB)
		 				cPriNome := QryPro->A2_NOMEPRI
			    	   	cSegNome := QryPro->A2_NOMEPES
		    		   	cPriSobr := QryPro->A2_NOMEMAT
		    		   	cSegSobr := QryPro->A2_NOMEPAT
		    	   		cRazao   := QryPro->A2_NOME
			    	   	cEnd     := QryPro->A2_END
		    		   	cCod_Mun := QryPro->A2_COD_MUN
		    		   	cEstado  := QryPro->A2_EST
		    	   		cPais    := QryPro->A2_PAIS
		    	   		cTipoDoc := QryPro->A2_TIPDOC
			    	   	cNrDoc   := QryPro->A2_CGC
			    	   	cEmail	 := QryPro->A2_EMAIL
			    	   	If ExistBlock("DIGVERCOL")
			    			cNrDoc   := ExecBlock("DIGVERCOL",.F.,.F.,{"QryPro",cNrDoc})
	    		   		EndIf
	    		   	Else
		 				cRazao   := "Entidad Proveedor No Identificado" //"Entidad Proveedor No Identificado"
		 				cTipoDoc := "PRO"
		 			EndIF
		 			QryPro->(dbclosearea())

		 			SA2->(dbSetOrder(3))    //Fornecedores
		 		ElseIf cPaisLoc == "COL" .And. CV0->CV0_TIPO00 == "03"
		 			If SRA->(dbSeek(xFilial("SRA")+AllTrim((cArqPlan)->ENTCTB),.T.))
		 				cPriNome := SRA->RA_PRINOME
		    	   		cSegNome := SRA->RA_SECNOME
	    		   		cPriSobr := SRA->RA_PRISOBR
	    		   		cSegSobr := SRA->RA_SECSOBR
	    	   			cRazao   := SRA->RA_NOME
		    	   		cEnd	 := SRA->RA_ENDEREC
	    		   		cCod_Mun := SRA->RA_MUNICIP
	    		   		cEstado  := SRA->RA_ESTADO
	    	   			cPais    := ""//SRA->RA_PAIS Verificar C๓digo do Pais...
	   	   				cTipoDoc := SRA->RA_TPCIC
		    	   		cNrDoc   := SRA->RA_CIC
			    	   	cEmail	 := SRA->RA_EMAIL
			    	   	If ExistBlock("DIGVERCOL")
			    			cNrDoc   := ExecBlock("DIGVERCOL",.F.,.F.,{"SRA",cNrDoc})
			    		EndIf
			    	Else
			    		cRazao   := "Entidad Empleado No Identificado" //"Entidad Empleado No Identificado"
			    		cTipoDoc := "EMP"
	    			EndIf
	       		ElseIf cPaisLoc == "COL" .And. CV0->CV0_TIPO00 == "04"
					If CVC->(dbSeek(xFilial("CVC")+AllTrim((cArqPlan)->ENTCTB),.T.))
	 	 	   			cPriNome  := CVC->CVC_NOME
		    	   		cSegNome  := CVC->CVC_2NOME
	    		   		cPriSobr  := CVC->CVC_1SNOME
	    		   		cSegSobr  := CVC->CVC_2SNOME
	    	   			cRazao    := CVC->CVC_NOME
	    	   			cEnd	  := CVC->CVC_END
		    	   		cCod_Mun  := CVC->CVC_CODMUN
	    		   		cEstado   := CVC->CVC_UF
	    		   		cPais     := ""//SRA->RA_PAIS Verificar C๓digo do Pais...
	   	   				cTipoDoc  := CVC->CVC_TIPDOC
	    	   			cNrDoc    := CVC->CVC_CGC
		    	   	    nPercPart := CVC->CVC_PARTIC
		    	   	    cEmail	  := CVC->CVC_EMAIL

		    	   	    If ExistBlock("DIGVERCOL")
			    			cNrDoc   := ExecBlock("DIGVERCOL",.F.,.F.,{"CVC",cNrDoc})
			    		EndIf
			    	Else
			    		cRazao   := "Entidad Costos No Identificado" //"Entidad Costos No Identificado"
			    		cTipoDoc := "PAR"
	    			EndIf
	       		EndIf
	        EndIf
	    EndIf

	  	nValorPago := ((cArqPlan)->VLRATUDB01 - (cArqPlan)->VLRATUCR01)
		If AllTrim((cArqPlan)->PLANOREF) == "1001"
			//Avaliar Limite Principal.
	    	If AllTrim((cArqPlan)->CTAREF) == "5016" .and. nValorPago < 100000
	    		cRazao   := "Cuantํas menores" //"Cuantํas menores"
	       		cNrDoc   := cDocumen
		       	cTipoDoc := cTipDoc
			EndIf
		EndIf

		If AllTrim((cArqPlan)->PLANOREF) $ "1006|1007|1008|1009"
			//Verificar Limite Mํnimo.
			If abs(nValorPago) < nLimite
	    		cRazao   := "Cuantํas menores" //"Cuantํas menores"
	       		cNrDoc   := cDocumen
		       	cTipoDoc := cTipDoc
		       	cPriNome := ""
		    	cSegNome := ""
		    	cPriSobr := ""
		 	   	cSegSobr := ""
			EndIf
		EndIf

		If AllTrim((cArqPlan)->PLANOREF) $ "1001|1002|1006|1007|1008|1009|1010"
			If cTipoDoc $ SuperGetMv("MV_COLTIPD",.T.,"")
				cTipoDoc := "42"
			EndIF

			If cTipoDoc $ "42|43" .AND. cNrDoc <> cDocumen
				cEnd      := ""
	    		cCod_Mun  := ""
	    		cEstado   := ""
			EndIf

			//Registro para Beneficiarios Estrangerios, Documento nใo identificado.
			If cTipoDoc == "43" .AND. cNrDoc <> cDocumen
				If nCntEstran > 0
			    	If AllTrim((cArqPlan)->PLANOREF) $ "1004|1011"
	    			   cSeek := (cArqPlan)->PLANOREF+(cArqPlan)->CTAREF
	    			Else
	    			   cNrDocEstra := cNrDocEstra += Space(aTamNrDoc[1])
	    			   cPriNome := cPriNome + Space(aTamPNome[1])
	    			   cSegNome := cSegNome + Space(aTamSNome[1])
	    			   cPriSobr := cPriSobr + Space(aTamPSobr[1])
	    			   cSegSobr := cSegSobr + Space(aTamSSobr[1])

		       		   cSeek := (cArqPlan)->PLANOREF+(cArqPlan)->CTAREF+cDocEst+Subs(cNrDocEstra,1,aTamNrDoc[1])+Subs(cPriNome,1,aTamPNome[1])
		       		   cSeek += Subs(cSegNome,1,aTamSNome[1])+Subs(cPriSobr,1,aTamPSobr[1])+Subs(cSegSobr,1,aTamSSobr[1])
		    		EndIf
			    	If ! (cArqAux)->(dbSeek(cSeek))
			   			cNrDocEstra := Soma1(alltrim(cNrDocEstra))
					EndIf
		   		EndIf
				cNrDoc   := cNrDocEstra
		   		cTipoDoc := cDocEst
		   		nCntEstran ++
			EndIf
		EndIf

		//Acumular Valores para um Unico Beneficiario.
		lAppend := .T.
		If cNrDoc == cNrDocEstra .and. cTipoDoc == cDocEst
	    	If AllTrim((cArqPlan)->PLANOREF) $ "1004|1011"
	    		cSeek := (cArqPlan)->PLANOREF+(cArqPlan)->CTAREF
	    	Else
	    		cNrDocEstra := cNrDocEstra += Space(aTamNrDoc[1])
	    		cPriNome := cPriNome + Space(aTamPNome[1])
	    		cSegNome := cSegNome + Space(aTamSNome[1])
	    		cPriSobr := cPriSobr + Space(aTamPSobr[1])
	    		cSegSobr := cSegSobr + Space(aTamSSobr[1])

	    		cSeek := (cArqPlan)->PLANOREF+(cArqPlan)->CTAREF+cDocEst+Subs(cNrDocEstra,1,aTamNrDoc[1])+Subs(cPriNome,1,aTamPNome[1])
	    		cSeek += Subs(cSegNome,1,aTamSNome[1])+Subs(cPriSobr,1,aTamPSobr[1])+Subs(cSegSobr,1,aTamSSobr[1])
	    	EndIf
	    	If ! (cArqAux)->(dbSeek(cSeek))
	    		lAppend := .T.
	    	Else
	    		lAppend := .F.
	    	EndIf
	    Else
	    	If AllTrim((cArqPlan)->PLANOREF) $ "1004|1011"
	    		cSeek := (cArqPlan)->PLANOREF+(cArqPlan)->CTAREF
	    	Else
	    		cSeek := (cArqPlan)->PLANOREF+(cArqPlan)->CTAREF+cTipoDoc+alltrim(cNrDoc)
		    EndIf
	    	If ! (cArqAux)->(dbSeek(cSeek))
	    		lAppend := .T.
	    	Else
	    		lAppend := .F.
	    	EndIf
		EndIf

		cCpoVal:= "VALOR"+(cArqPlan)->COLUNA
		cCpoDB := "VLRATUDB"+(cArqPlan)->COLUNA
		cCpoCR := "VLRATUCR"+(cArqPlan)->COLUNA
	   	If lAppend
	   		RecLock(cArqAux,lAppend)
				(cArqAux)->PLANOREF	 := (cArqPlan)->PLANOREF
				(cArqAux)->CTAREF	 := (cArqPlan)->CTAREF
				(cArqAux)->TIPO3	 := If(cPaisLoc == "COL",CV0->CV0_TIPO00,"")
				(cArqAux)->TIPODOC	 := cTipoDoc
				(cArqAux)->NRDOC	 := cNrDoc
				(cArqAux)->DV		 := If(!Empty(cNrDoc) .and. Empty(Subs(cNrDoc,10,01)),"1",Subs(cNrDoc,10,01))
				If (cArqAux)->TIPODOC $ "11|12|13|21|22|41"
					(cArqAux)->RAZAO	 := ""
				Else
					(cArqAux)->RAZAO	 := cRazao
				EndIf
				(cArqAux)->ENDERECO	 := cEnd
				(cArqAux)->PRINOME	 := cPriNome
				(cArqAux)->SEGNOME	 := cSegNome
				(cArqAux)->PRISNOME	 := cPriSobr
				(cArqAux)->SEGSNOME	 := cSegSobr
				(cArqAux)->MUNICIPIO := Subs(cCod_Mun,3,3)
				(cArqAux)->ESTADO	 := If(Empty(cEstado),Subs(cCod_Mun,1,2),cCod_Mun)
				(cArqAux)->PAIS		 := If(Empty(cPais),"169",cPais)
				(cArqAux)->EMAIL		 := CEmail
				If (cArqPlan)->COLUNA == "01"
					(cArqAux)->VALORPAG	 := NoRound(((cArqPlan)->VLRATUDB01-(cArqPlan)->VLRATUCR01),2)
					If CARQAUX $ "FMT1009|FMT1008"
						(cArqAux)->VALORPAG	 += NoRound(((cArqPlan)->VLRANTDB01-(cArqPlan)->VLRANTCR01),2)
					EndIF
				ElseIf (cArqPlan)->COLUNA == "02"
					(cArqAux)->VALORDED	 := NoRound(((cArqPlan)->VLRATUDB01-(cArqPlan)->VLRATUCR01),2)
					If CARQAUX $ "FMT1009|FMT1008"
						(cArqAux)->VALORDED	 += NoRound(((cArqPlan)->VLRANTDB01-(cArqPlan)->VLRANTCR01),2)
					EndIF
				Else
					(cArqAux)->(&cCpoVal):= NoRound(((cArqPlan)->VLRATUDB01-(cArqPlan)->VLRATUCR01),2)
					If CARQAUX $ "FMT1009|FMT1008"
						(cArqAux)->(&cCpoVal)	 += NoRound(((cArqPlan)->VLRANTDB01-(cArqPlan)->VLRANTCR01),2)
					EndIF
				EndIf

				If (cArqAux)->(FieldPos("VLRATUDB02")) > 0
					If (cArqPlan)->COLUNA == "01"
						(cArqAux)->VALORPAG	 := NoRound(((cArqPlan)->VLRATUDB02-(cArqPlan)->VLRATUCR02),2)
					ElseIf (cArqPlan)->COLUNA == "02"
						(cArqAux)->VALORDED	 := NoRound(((cArqPlan)->VLRATUDB02-(cArqPlan)->VLRATUCR02),2)
					EndIf
				EndIf
				(cArqAux)->PERCPART  := nPercPart
			(cArqAux)->(MsUnLock())
		Else
	   		RecLock(cArqAux,.F.)
				(cArqAux)->ENDERECO	 := cEnd
				(cArqAux)->MUNICIPIO := Subs(cCod_Mun,3,3)
				(cArqAux)->ESTADO	 := If(Empty(cEstado),Subs(cCod_Mun,1,2),cCod_Mun)
				(cArqAux)->PAIS		 := If(Empty(cPais),"169",cPais)
				(cArqAux)->EMAIL		 := CEmail
				If (cArqPlan)->COLUNA == "01"
					(cArqAux)->VALORPAG	+= NoRound(((cArqPlan)->VLRATUDB01-(cArqPlan)->VLRATUCR01),2)
				ElseIf (cArqPlan)->COLUNA == "02"
					(cArqAux)->VALORDED	+= NoRound(((cArqPlan)->VLRATUDB01-(cArqPlan)->VLRATUCR01),2)
				Else
					(cArqAux)->(&cCpoVal)+= NoRound(((cArqPlan)->VLRATUDB01-(cArqPlan)->VLRATUCR01),2)
				EndIf
				If (cArqAux)->(FieldPos("VLRATUDB02")) > 0
					If (cArqPlan)->COLUNA == "01"
						(cArqAux)->VALORPAG	+= NoRound(((cArqPlan)->VLRATUDB02-(cArqPlan)->VLRATUCR02),2)
					ElseIf (cArqPlan)->COLUNA == "02"
						(cArqAux)->VALORDED	+= NoRound(((cArqPlan)->VLRATUDB02-(cArqPlan)->VLRATUCR02),2)
					EndIf
				EndIf
			(cArqAux)->(MsUnLock())
		EndIf
		(cArqPlan)->(dbSkip())
	EndDo

	nCntRec   := 0.00
	nTotalRec := mv_par07
	cNomFile  := cNomArq
	AADD(aNomArq,cNomFile)

	(cArqAux)->(dbGoTop())
	While (cArqAux)->(!Eof())
		nCntRec++
		If nCntRec > nTotalRec
			nCntRec  := 1
			cNomFile := Soma1(cNomFile)
	        AADD(aNomArq,cNomFile)
			EncInfFMT(cPlanoRef,"MV_FMTCONS",cNomFile,.F.)
	    EndIf
		RecLock(cArqAux,.F.)
			(cArqAux)->NOMARQ := cNomFile
		MsUnLock()
		(cArqAux)->(dbSkip())
	EndDo
	(cArqAux)->(dbGoTop())
	(cArqAux)->(dbSetOrder(2))

RestArea(aSaveArea)
Return(cArqAux)

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณ EncInfFMT() ณ Autor ณ Jos้ Lucas		           ณ Data ณ 09.03.10	ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Fecha as areas abertas atrav้s da GerInfoFMT e atualiza o conteudo doณฑฑ
ฑฑณ          ณ parametro MV_FMTCONS.                                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ EncInfFMT(cPlanoRef,cParametro,cConteudo).                           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ                                                                      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Gen้rico                                                  			ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ ExpC1 = Nome do Parametro.                                 		    ณฑฑ
ฑฑณ          ณ ExpC2 = Conteudo atualizado.                                		    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
/*/
Function EncInfFMT(cPlanoRef,cParam,cConteudo,lClose)
Local aSaveArea := GetArea()
Local cArqAux   := "FMT"+cPlanoRef

DEFAULT cConteudo := ""
DEFAULT lClose    := .F.

	If lClose
		dbSelectArea(cArqAux)
		dbCloseArea()
	EndIf

	If Empty(cConteudo)
		PUTMV( cParam , Soma1( AllTrim( SUPERGETMV( cParam , .F. , "0000000001" ) ) ) )
	Else
		PUTMV( cParam , cConteudo )
	EndIf

RestArea(aSaveArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTBLCUSO  บAutor  ณMarcello            บFecha ณ 23/04/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se o sistema utiliza o conceito de lancamentos     บฑฑ
ฑฑบ          ณcomplementares.                                             บฑฑ
ฑฑบ          ณRetorno:    lRet (L) - .T. usa lancamentos complementares   บฑฑ
ฑฑบ          ณ                       .F. nao usa                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CTB - Lacamentos complementares                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Function CTBLCUso()
Local lRet	:= .T.

lRet := IIF(cPaisLoc $ "COL/PER", .T., .F.)
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTBLCADCT2บAutor  ณMarcello            บFecha ณ 23/04/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAlimenta o array com os lancamentos contabeis para a        บฑฑ
ฑฑบ          ณgeracao dos lancamentos complementares.                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณParametros: nRegCT2 (N) - numero do registro do lancamento  บฑฑ
ฑฑบ          ณ            contabil no arquivo CT2.                        บฑฑ
ฑฑบ          ณRetorno:    lRet (L) - .T. operacao feita com sucesso       บฑฑ
ฑฑบ          ณ                       .F. falha na operacao                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CTB - Lancamentos complementares                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Function CTBLCAdCT2(nRegCT2,cHist)
Local lRet		:= .F.
Local nRegAnt	:= 0
Local nPos		:= 0

Default nRegCT2	:= 0
Default cHist	:= ""

	If nRegCT2 <> 0
		If Type("__aCT2LC") <> "A"
			__aCT2LC := {}
		Endif
		nRegAnt := CT2->(Recno())
		If nRegAnt <> nRegCT2
			CT2->(DbGoto(nRegCT2))
		Endif
		nPos := Ascan(__aCT2LC,{|alanc| alanc[1] == nRegCT2})
		If nPos == 0
			Aadd(__aCT2LC,{nRegCT2,cHist})
		Else
			__aCT2LC[nPos,2] := cHist
		Endif
		If nRegAnt <> nRegCT2
			CT2->(DbGoto(nRegAnt))
		Endif
		lRet := .T.
	Endif

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTBLCDELLCบAutor  ณMarcello            บFecha ณ 23/04/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณApaga os lancamentos complementares, referentes ao          บฑฑ
ฑฑบ          ณlancamento principal na tabela CT2.                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณParametros: nRegCT2 (N) - numero do registro do lancamento  บฑฑ
ฑฑบ          ณ            contabil no arquivo CT2.                        บฑฑ
ฑฑบ          ณ            lDelCV3CTK (L) - indica se os registros das     บฑฑ
ฑฑบ          ณ            tabelas CV3 e CTK tambem devem ser apagados     บฑฑ
ฑฑบ          ณRetorno:    lRet (L) - .T. operacao feita com sucesso       บฑฑ
ฑฑบ          ณ                       .F. falha na operacao                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CTB - Lancamentos complementares                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Function CTBLCDelLC(nRegCT2,lDelCV3CTK)
Local cChave	:= ""
Local cSequ		:= ""
Local dDtSeq	:= Ctod("//")
Local cFilCT2	:= ""
Local cFilCV3	:= ""
Local cFilCTK	:= ""
Local lRet		:= .F.
Local aArea		:= {}
Local aCT2		:= {}
Local aCV3		:= {}
Local aCTK		:= {}
Local aEnts		:= {}
Local lClVl		:=	.F.
Local lItem		:=	.F.
Local lCusto	:= 	.F.
/**/
Local dData		:= Ctod("//")
Local dDTLP		:= Ctod("//")
Local nValor	:= 0
Local cLote		:= ""
Local cMoeda	:= ""
Local cSbLote	:= ""
Local cDoc		:= ""
Local cDC		:= ""
Local cHP		:= ""
Local cCtasDB	:= ""
Local cCtasCR	:= ""
Local cCCD		:= ""
Local cCCC		:= ""
Local cItemDB	:= ""
Local cItemCR	:= ""
Local cCLVLDB	:= ""
Local cCLVLCR	:= ""
Local cTpSald	:= ""
/***/
Local aTravas 	:= {}
Local lSldBase	:= .T.
Local lSldCT7	:= .T.
Local lSldCT3	:= .T.
Local lSldCT4	:= .T.
Local lSldCTI	:= .T.

Default nRegCT2		:= 0
Default lDelCV3CTK	:= .F.

	If nRegCT2 > 0
		lClVl	:=	CtbMovSaldo("CTH")
		lItem	:=	CtbMovSaldo("CTD")
		lCusto	:= 	CtbMovSaldo("CTT")
		aArea := GetArea()
		If lDelCV3CTK
			DbSelectArea("CV3")
			aCV3 := GetArea()
			cFilCV3 := xFilial("CV3")
			CV3->(DbSetOrder(1))

			DbSelectArea("CTK")
			aCTK := GetArea()
			cFilCTK := xFilial("CTK")
			CTK->(DbSetOrder(1))
		Endif

		DbSelectArea("CT2")
		aCT2 := GetArea()
		cChave := PadR("__CTBLC__" + StrZero(nRegCT2,10),TamSX3("CT2_ORIGEM")[1])
		CT2->(DbSetORder(13))
		cfilCT2 := xFilial("CT2")
		If CT2->(DbSeek(cFilCT2 + cChave))
			While !(CT2->(Eof())) .And. CT2->CT2_FILIAL == cFilCT2 .And. CT2->CT2_ORIGEM == cChave
				RecLock("CT2",.F.)
				If lDelCV3CTK
					cChv := PadR(AllTrim(Str(CT2->(Recno()))),TamSX3("CV3_RECDES")[1])
					cSequ := PadR(AllTrim(CT2->CT2_SEQUEN),TamSX3("CV3_SEQUEN")[1])
					dDTSeq := CV3->CV3_DTSEQ
					If CV3->(DbSeek(cFilCV3 + Dtos(dDtSeq) + cSequ))
						While !(CV3->(Eof())) .And. CV3->CV3_FILIAL == cFilCV3 .And. CV3->CV3_SEQUEN == cSequ .And. CV3->CV3_DTSEQ == dDtSeq
							RecLock("CV3",.F.)
							CV3->(DbDelete())
							CV3->(DbSkip())
						EndDo
					Endif
					cSequ := PadR(AllTrim(CT2->CT2_SEQUEN),TamSX3("CTK_SEQUEN")[1])
					If CTK->(DbSeek(cFilCTK + cSequ))
						While !(CTK->(Eof())) .And. CTK->CTK_FILIAL == cFilCTK .And. CTK->CTK_SEQUEN == cSequ
							RecLock("CTK",.F.)
							CTK->(DbDelete())
							CTK->(DbSkip())
						EndDo
					Endif
				Endif
				DbSelectArea("CT2")
				dData	:= CT2->CT2_DATA
				dDTLP	:= CT2->CT2_DTLP
				cLote	:= CT2->CT2_LOTE
				cMoeda	:= CT2->CT2_MOEDLC
				cSbLote	:= CT2->CT2_SBLOTE
				cDoc	:= CT2->CT2_DOC
				cDC		:= CT2->CT2_DC
				cLinha	:= CT2->CT2_LINHA
				cSeqLan	:= CT2->CT2_SEQLAN
				cHP		:= CT2->CT2_HP
				cCtasDB	:= CT2->CT2_DEBITO
				cCtasCR	:= CT2->CT2_CREDIT
				cCCD	:= CT2->CT2_CCD
				cCCC	:= CT2->CT2_CCC
				cItemDB	:= CT2->CT2_ITEMD
				cItemCR	:= CT2->CT2_ITEMC
				cCLVLDB	:= CT2->CT2_CLVLDB
				cCLVLCR	:= CT2->CT2_CLVLCR
				nValor	:= CT2->CT2_VALOR
				cTpSald	:= CT2->CT2_TPSALD
				aEnts	:= Aclone(CtbOutrEnt(.F.,"CT2"))
				/**/
				aTravas := {cCtasDB,cCtasCR}
				CtbCanGrv(aTravas,@lSldBase,@lSldCT7,@lSldCT3,@lSldCT4,@lSldCTI)
				If cDC <> "4"
					CtbGravSaldo(cLote,cSbLote,cDoc,dData,cDC,cMoeda,cCtasDB,cCtasCR,cCCD,cCCC,cItemDB,cItemCR,cClVlDB,cClVlCR,;
								nValor,cTpSald,5,cCtasDB,cCtasCR,cCCD,cCCC,cItemDB,cItemCR,cClVlDB,cClVlCR,nValor,cDC,cTpSald,cMoeda,;
								lCusto,lItem,lClVL,,lSldBase,.F.,dDTLP,,,,,lSldCT7,lSldCT3,lSldCT4,lSldCTI,,"-",aEnts[1],aEnts[1])
				Endif
				GravaLanc(dData,cLote,cSbLote,cDoc,cLinha,cDC,cMoeda,cHP,cCtasDB,cCtasCR,cCCD,cCCC,cItemDB,cItemCR,CClVlDB,cClVlCR,;
							nValor,"",cTpSald,cSeqLan,5,.T.,{},cEmpAnt,cFilAnt,,,,,,,.F.,"",{},,,,,)
				CT2->(DbSkip())
			EndDo
		Endif
		If lDelCV3CTK
			DbSelectArea("CV3")
			RestArea(aCV3)
			DbSelectArea("CTK")
			RestArea(aCTK)
		Endif
		DbSelectArea("CT2")
		CT2->(RestArea(aCT2))
		RestArea(aArea)
	Endif

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTBLCGERLCบAutor  ณMarcello            บFecha ณ 23/04/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera os lancamentos complementares, atraves de um lancamentoบฑฑ
ฑฑบ          ณde intregracao "000".                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณRetorno:    lRet (L) - .T. operacao feita com sucesso       บฑฑ
ฑฑบ          ณ                       .F. falha na operacao                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CTB - Lancamentos complementares                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Function CTBLCGerLC(nRegCT2,cHistor)
Local lCTKSXE	:= .F.
Local lAtuCorr	:= .F.
Local lSeqCorr	:= .F.
Local cChave	:= ""
Local cHist		:= ""
Local cSeqCorr	:= ""
Local cCodSeq	:= ""
Local cLinha	:= ""
Local cSeqLan	:= ""
Local cFilCTO	:= ""
Local cFilCT2	:= ""
Local cOutro	:= ""
Local cSequen	:= ""
Local nLenCT2	:= 0
Local nLanc		:= 0
Local nMoedas	:= 0
Local nRegLC	:= 0
Local nOutros 	:= 0
Local aEntes	:= {}
Local aOutros	:= {}
Local aOutAnt	:= {}
Local aMoedas	:= {}
Local aMoedLan	:= {}
Local aCtasDB	:= {}
Local aCtasCR	:= {}
Local aAreaCT2	:= {}
Local aAreaCT1	:= {}
Local aAreaCTO	:= {}
Local aArea		:= {}
/**/
Local lClVl		:=	CtbMovSaldo("CTH")
Local lItem		:=	CtbMovSaldo("CTD")
Local lCusto	:= 	CtbMovSaldo("CTT")
/**/
Local aTravas 	:= {}
Local lSldBase	:= .T.
Local lSldCT7	:= .T.
Local lSldCT3	:= .T.
Local lSldCT4	:= .T.
Local lSldCTI	:= .T.
/**/
Local aValores	:= {}
Local aPeriodos	:= {}
Local dData		:= Ctod("//")
Local dDataAnt	:= Ctod("//")
Local nValor	:= 0
Local cLote		:= ""
Local cLoteAnt	:= ""
Local cSLoteAnt	:= ""
Local cDocAnt	:= ""
Local cLoteCT2	:= ""
Local cSbLote	:= ""
Local cSbLCT2	:= ""
Local cDoc 		:= ""
Local CTF_LOCK	:= ""
Local cHP		:= ""
Local cCCD		:= ""
Local cCCC		:= ""
Local cItemDB	:= ""
Local cItemCR	:= ""
Local cCLVLDB	:= ""
Local cCLVLCR	:= ""
Local cTpSald	:= ""
Local cRotina	:= ""
Local cOrigem	:= ""
Local cCriter	:= ""
Local cDocCT2	:= ""
Local cSeqLCT2	:= ""
Local cEmpOri	:= ""
Local cFilOri	:= ""

Default nRegCT2		:= 0
Default cHistor		:= ""

	If Type("__aCT2LC") <> "A"
		__aCT2LC := {}
	Endif

	If nRegCT2 > 0
		__aCT2LC := {{nRegCT2,cHistor}}
	Endif

	nLenCT2 := Len(__aCT2LC)

	If nLenCT2 > 0
		aArea := GetArea()
		lCTKSXE	:= FindFunction('HASCTKSXE')
		lSeqCorr  := UsaSeqCor()
		If lSeqCorr
			cSeqCorr := space(TamSx3("CT2_NODIA")[1])
			cCodSeq  := CtbRdia()
			lAtuCorr := .T.
		EndIf
		aAreaCT1 := CT1->(GetArea())
		CT1->(DbSetOrder(1))
		aAreaCT2 := CT2->(GetArea())
		cFilCT2 := xFilial("CT2")
		/**/
		aOutros := {}
		aOutros := Aclone(Ct101Outr({}))
		If (nOutros := Ascan(aOutros,{|cpo| AllTrim(cpo) == "CT2_SEQUEN"})) == 0
			Aadd(aOutros,"CT2_SEQUEN")
		Endif
		If (nOutros := Ascan(aOutros,{|cpo| AllTrim(cpo) == "CT2_ORIGEM"})) == 0
			Aadd(aOutros,"CT2_ORIGEM")
		Endif
		If (nOutros := Ascan(aOutros,{|cpo| AllTrim(cpo) == "CT2_LP"})) == 0
			Aadd(aOutros,"CT2_LP")
		Endif
		If (nOutros := Ascan(aOutros,{|cpo| AllTrim(cpo) == "CT2_KEY"})) == 0
			Aadd(aOutros,"CT2_KEY")
		Endif
		If (nOutros := Ascan(aOutros,{|cpo| AllTrim(cpo) == "CT2_MANUAL"})) == 0
			Aadd(aOutros,"CT2_MANUAL")
		Endif

		aOutAnt	:= {}
		For nOutros := 1 To Len(aOutros)
			cOutro := "M->" + aOutros[nOutros]
			If Type(cOutro) <> "U"
				Aadd(aOutAnt,{cOutro,&(cOutro)})
			Endif
		Next

		For nLanc := 1 To nLenCT2
			cHist := __aCT2LC[nLanc,2]
			CT2->(DbGoTo(__aCT2LC[nLanc,1]))
			aCtasDB := {}
			aCtasCR := {}
			If !Empty(CT2->CT2_DEBITO)
				CT1->(DbSeek(xFilial("CT1") + CT2->CT2_DEBITO))
				If CT1->CT1_LCCMPL == "1"
					aCtasDB := {CT1->CT1_CTPART,CT1->CT1_CTCPAR}
				Endif
			Endif
			If !Empty(CT2->CT2_CREDIT)
				CT1->(DbSeek(xFilial("CT1") + CT2->CT2_CREDIT))
				If CT1->CT1_LCCMPL == "1"
					aCtasCR := {CT1->CT1_CTPART,CT1->CT1_CTCPAR}
				Endif
			Endif
			If !Empty(aCtasDB) .Or. !Empty(aCtasCR)
				If Empty(aMoedas)
					aAreaCTO := CTO->(GetArea())
					CTO->(DbSetOrder(1))
					cFilCTO := xFilial("CTO")
					CTO->(DBSeek(cFilCTO))
					While CTO->CTO_FILIAL == cFilCTO .And. !(CTO->(Eof()))
						If (CTO->CTO_BLOQ <> "1")
							Aadd(aMoedas,CTO->CTO_MOEDA)
						Endif
						CTO->(DbSkip())
					Enddo
				Endif
				dData	:= CT2->CT2_DATA
				cLote	:= CT2->CT2_LOTE
				cSbLote	:= CT2->CT2_SBLOTE
				If (dData <> dDataAnt) .Or. (cLote <> cLoteAnt) .Or. (cSbLote <> cSLoteAnt)
					ProxDoc(dData,cLote,cSbLote,@cDoc)
					cDocAnt		:= cDoc
					cLoteAnt	:= cLote
					cSLoteAnt	:= cSbLote
					dDataAnt	:= dData
					lAtuCorr := .T.
					cSeqLan	:= StrZero(0,TamSX3("CT2_SEQLAN")[1])
				Else
					cDoc := cDocAnt
					lAtuCorr := .F.
				Endif
				cHP		:= CT2->CT2_HP
				cCCD	:= CT2->CT2_CCD
				cCCC	:= CT2->CT2_CCC
				cItemDB	:= CT2->CT2_ITEMD
				cItemCR	:= CT2->CT2_ITEMC
				cCLVLDB	:= CT2->CT2_CLVLDB
				cCLVLCR	:= CT2->CT2_CLVLCR
				nValor	:= CT2->CT2_VALOR
				cTpSald	:= CT2->CT2_TPSALD
				cCriter := CT2->CT2_CRCONV
				cRotina	:= "__CTBLC__"
				cOrigem := "__CTBLC__" + StrZero(__aCT2LC[nLanc,1],10)

				For nOutros := 1 To Len(aOutros)
					&("M->"+(aoutros[nOutros])) := &("CT2->"+(aoutros[nOutros]))
				Next

				M->CT2_ORIGEM	:= cOrigem
				M->CT2_LP	 	:= "000"
				M->CT2_MANUAL	:= "2"
				cChave 			:= "CT2->(" + CT2->(IndexKey(1)) + ")"
				M->CT2_KEY		:= &(cChave)
				aEnts := Aclone(CtbOutrEnt(.F.,"CT2"))

				aValores := {}
				For nMoedas := 1 To Len(aMoedas)
					aPeriodos := CtbPeriodos(aMoedas[nMoedas],dData,dData,.F.,.F.)
					If Empty(aPeriodos[1,1])
						Aadd(aValores,0)
					Else
						Aadd(aValores,CTBConv("9",dData,aMoedas[nMoedas],nValor))
					Endif
				Next

				/**/
				If Empty(cHist)
					CT2->(DbSetOrder(10))
					cDocCT2  := CT2->CT2_DOC
					cSeqLCT2 := CT2->CT2_SEQLAN
					cEmpOri  := CT2->CT2_EMPORI
					cFilOri  := CT2->CT2_FILORI
					If CT2->(MsSeek(cFilCT2+dtos(dData)+cLote+cSbLote+cDocCT2+cSeqLCT2+cEmpOri+cFilOri+'01'))
						While !(CT2->(Eof())) .And. CT2->CT2_FILIAL == cFilCT2	.And.;
									CT2->CT2_DATA == dData 			.And.;
									CT2->CT2_LOTE == cLote 			.And.;
									CT2->CT2_SBLOTE == cSbLote 		.And.;
									CT2->CT2_DOC == cDocCT2			.And.;
									CT2->CT2_SEQLAN == cSeqLCT2		.And.;
									CT2->CT2_TPSALD	==cTpSald		.And.;
									CT2->CT2_MOEDLC == '01'			.And.;
									CT2->CT2_EMPORI == cEmpOri		.And.;
									CT2->CT2_FILORI	== cFilOri
							cHist += (CT2->CT2_HIST + CHR(13) + CHR(10))
							CT2->(DbSkip())
						EndDo
					Endif
				Endif

				If !Empty(aCtasDB)
					CtbProxLin(dData,cLote,cSbLote,cDoc,@cLinha)
					If !lCTKSXE
						cSequen := GetSx8Num("CTK","CTK_SEQUEN",,1)
					Else
						cSequen := GetSx8Num("_CT")
					EndIf
					M->CT2_SEQUEN := cSequen
					cSeqLan := Soma1(cSeqLan)
					aTravas := {aCtasDB[1],aCtasDB[2]}
					CtbCanGrv(aTravas,@lSldBase,@lSldCT7,@lSldCT3,@lSldCT4,@lSldCTI)
					For nMoedas := 1 To Len(aMoedas)
						aMoedLan := {{aMoedas[nMoedas]," ",aValores[nMoedas],"2",dData,aValores[nMoedas]}}
						If aValores[nMoedas] <> 0
							nRegLC := 0
							GravaLanc(dData,cLote,cSbLote,cDoc,cLinha,"3",aMoedas[nMoedas],cHP,aCtasDB[1],aCtasDB[2],cCCD,cCCC,cItemDB,cItemCR,CClVlDB,cClVlCR,;
									aValores[nMoedas],cHist,cTpSald,@cSeqLan,3,.T.,aMoedLan,cEmpAnt,cFilAnt,Val(aMoedas[nMoedas])-1,,,,,cRotina,.F.,"",aOutros,,@nRegLC,@cCodSeq,lSeqCorr,@cSeqCorr,lAtuCorr)
							lAtuCorr := .F.
							If nMoedas == 1
								CTBLCGrCV3(nRegLC,__aCT2LC[nLanc,1])
							Endif
							/**/
							CtbGravSaldo(cLote,cSbLote,cDoc,dData,"3",aMoedas[nMoedas],aCtasDB[1],aCtasDB[2],cCCD,cCCC,cItemDB,cItemCR,cClVlDB,cClVlCR,aValores[nMoedas],;
										cTpSald,5,aCtasDB[1],aCtasDB[2],cCCD,cCCC,cItemDB,cItemCR,cClVlDB,cClVLCR,aValores[nMoedas],"3",cTpSald,aMoedas[nMoedas],lCusto,;
										lItem,lClVL,,.T.,.F.,CT2->CT2_DTLP,,,,,lSldCT7,lSldCT3,lSldCT4,lSldCTI,,"+"/*cOperacao*/,aEnts[1],aEnts[1])
						Endif
					Next
					ConfirmSX8()
				Endif
				If !Empty(aCtasCR)
					CtbProxLin(dData,cLote,cSbLote,cDoc,@cLinha)
					If !lCTKSXE
						cSequen := GetSx8Num("CTK","CTK_SEQUEN",,1)
					Else
						cSequen := GetSx8Num("_CT")
					EndIf
					M->CT2_SEQUEN := cSequen
					cSeqLan := Soma1(cSeqLan)
					aTravas := {aCtasCR[2],aCtasCR[1]}
					CtbCanGrv(aTravas,@lSldBase,@lSldCT7,@lSldCT3,@lSldCT4,@lSldCTI)
					For nMoedas := 1 To Len(aMoedas)
						aMoedLan := {{aMoedas[nMoedas]," ",aValores[nMoedas],"2",dData,aValores[nMoedas]}}
						If aValores[nMoedas] <> 0
							nRegLC := 0
							GravaLanc(dData,cLote,cSbLote,cDoc,cLinha,"3",aMoedas[nMoedas],cHP,aCtasCR[2],aCtasCR[1],cCCD,cCCC,cItemDB,cItemCR,CClVlDB,cClVlCR,;
									aValores[nMoedas],cHist,cTpSald,@cSeqLan,3,.T.,aMoedLan,cEmpAnt,cFilAnt,Val(aMoedas[nMoedas])-1,,,,,cRotina,.F.,"",aOutros,,@nRegLC,@cCodSeq,lSeqCorr,@cSeqCorr,lAtuCorr)
							lAtuCorr := .F.
							If nMoedas == 1
								CTBLCGrCV3(nRegLC,__aCT2LC[nLanc,1])
							Endif
							/**/
							CtbGravSaldo(cLote,cSbLote,cDoc,dData,"3",aMoedas[nMoedas],aCtasCR[2],aCtasCR[1],cCCD,cCCC,cItemDB,cItemCR,cClVlDB,cClVlCR,aValores[nMoedas],;
										cTpSald,5,aCtasCR[2],aCtasCR[1],cCCD,cCCC,cItemDB,cItemCR,cClVlDB,cClVLCR,aValores[nMoedas],"3",cTpSald,aMoedas[nMoedas],lCusto,;
										lItem,lClVL,,.T.,.F.,CT2->CT2_DTLP,,,,,lSldCT7,lSldCT3,lSldCT4,lSldCTI,,"+"/*cOperacao*/,aEnts[1],aEnts[1])
						Endif
					Next
					ConfirmSX8()
				Endif
			Endif
		Next
		For nOutros := 1 To Len(aOutAnt)
			cOutro := aOutAnt[nOutros,1]
			&(cOutro) := aOutAnt[nOutros,2]
		Next
		CT2->(RestArea(aAreaCT2))
		CT1->(RestArea(aAreaCT1))
		RestArea(aArea)
	Endif
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTBLCGRCV3บAutor  ณ                    บFecha ณ 05/08/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria os registros na tabela CV3 referentes aos lancamentos  บฑฑ
ฑฑบ          ณcomplementares.                                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณRetorno:    lRet (L) - .T. operacao feita com sucesso       บฑฑ
ฑฑบ          ณ                       .F. falha na operacao                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CTB - Lancamentos complementares                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Function CTBLCGrCV3(nRegCT2,nRegOri)
Local nCT2		:= 0
Local lRet		:= .F.

Default nRegCT2 := 0
Default nRegOri := 0

	If nRegCT2 <> 0
		nCT2 := CT2->(Recno())
		If nRegCT2 <> nCT2
			CT2->(dbGoTo(nRegCT2))
		Endif
		RecLock("CV3",.T.)
			CV3->CV3_FILIAL	:= xFilial("CV3")
			CV3->CV3_DTSEQ	:= CT2->CT2_DATA
			CV3->CV3_SEQUEN	:= CT2->CT2_SEQUEN
			CV3->CV3_DC		:= CT2->CT2_DC
			CV3->CV3_LP		:= CT2->CT2_LP
			CV3->CV3_LPSEQ	:= CT2->CT2_LINHA
			CV3->CV3_KEY	:= CT2->CT2_KEY
			CV3->CV3_DEBITO	:= CT2->CT2_DEBITO
			CV3->CV3_CREDIT	:= CT2->CT2_CREDIT
			CV3->CV3_VLR01	:= CT2->CT2_VLR01
			CV3->CV3_VLR02	:= CT2->CT2_VLR02
			CV3->CV3_VLR03	:= CT2->CT2_VLR03
			CV3->CV3_VLR04	:= CT2->CT2_VLR04
			CV3->CV3_VLR05	:= CT2->CT2_VLR05
			CV3->CV3_HIST	:= CT2->CT2_HIST
			CV3->CV3_CCC	:= CT2->CT2_CCC
			CV3->CV3_CCD	:= CT2->CT2_CCD
			CV3->CV3_ITEMC	:= CT2->CT2_ITEMC
			CV3->CV3_ITEMD	:= CT2->CT2_ITEMD
			CV3->CV3_CLVLDB	:= CT2->CT2_CLVLDB
			CV3->CV3_CLVLCR	:= CT2->CT2_CLVLCR
			CV3->CV3_MOEDLC	:= CT2->CT2_MOEDLC
			CV3->CV3_TABORI	:= "CT2"
			CV3->CV3_RECORI	:= Alltrim(Str(nRegOri))
			CV3->CV3_RECDES := Alltrim(Str(nRegCT2))
		CV3->(MsUnlock())
		If nRegCT2 <> nCT2
			CT2->(dbGoTo(nCT2))
		Endif
	Endif
Return(lRet)

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o	 ณ CTBGrvHist() ณAutor  ณ Jos้ Lucas        ณ Data ณ 13/02/10 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Grava Hist๓irco de altera็๕es das Entidades e Grupo de 	  ณฑฑ
ฑฑณ          ณ Natureza Contabil.                                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe	 ณ CTBGrvHist(cFilTabela,cEntidade,cCodigo,cGrupo,cTipoCampo, ณฑฑ
ฑฑณ          ณ            cCampo,cValorAnt,cValorNovo,nOpcao)             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso		 ณ CTBXFUN						            				  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
/*/
Function CTBGrvHist(cFilTabela,cEntidade,cCodigo,cGrupo,cTipoCampo,cCampo,cValorAnt,cValorNovo,nOpc)
LOCAL aArea 	 := GetArea()
LOCAL cHistorico := Space(80)
LOCAL cSequencia := ""
LOCAL cTitulo    := ""
LOCAL lGravaLog  := GetNewpar( "MV_CTBLGET" , .F. )

DEFAULT cGrupo   := Space(TamSX3("CTT_CUSTO")[1])
DEFAULT cCodigo  := Space(TamSX3("CTT_CUSTO")[1])
DEFAULT nOpc	 := 0

	If lGravaLog
		cSequencia := CriaVar("CW8_SEQ")
		SX3->(DbSetOrder(2))
		SX3->(DbSeek(cCampo))
		cTitulo    := X3Titulo()
		cTipoCampo := SX3->X3_TIPO
		SX3->(DbSetOrder(1))

	   	If cTipoCampo == "N"
			cValorAnt  := Str(cValorAnt,TamSX3(cCampo)[1],TamSX3(cCampo)[2])
			cValorNovo := Str(cValorNovo,TamSX3(cCampo)[1],TamSX3(cCampo)[2])
		ElseIf cTipoCampo == "D"
			cValorAnt  := DTOC(cValorAnt)
			cValorNovo := DTOC(cValorNovo)
		ElseIf cTipoCampo == "L"
			cValorAnt  := If(cValorAnt,".T.",".F.")
			cValorNovo := If(cValorNovo,".T.",".F.")
		EndIf

		DbSelectArea("CW8")
		cSequencia := CW8GetSeq(cFilTabela, cEntidade, cCodigo, cGrupo, cCampo)

		CW8->(DbSetOrder(1))
		If ! CW8->(DbSeek(xFilial("CW8")+cFilTabela+cEntidade+cCodigo+cGrupo+cCampo+DTOS(dDataBase)+cSequencia) )
			RecLock("CW8",.T.)
				CW8->CW8_FILIAL := xFilial("CW8")
				CW8->CW8_FILTAB := cFilTabela
				CW8->CW8_TABELA := cEntidade
				CW8->CW8_CODIGO	:= cCodigo
				CW8->CW8_GRUPO  := cGrupo
				CW8->CW8_CAMPO	:= cCampo
				CW8->CW8_SEQ    := cSequencia
				CW8->CW8_TIPCPO := cTipoCampo
				CW8->CW8_TITULO := cTitulo
				CW8->CW8_VALANT := cValorAnt
				CW8->CW8_VALNOV := cValorNovo
				CW8->CW8_DATA   := dDataBase
				CW8->CW8_HORA	:= Substr(Time(),1,5)
		   		CW8->CW8_OPC	:= Str(nOpc,1)
				cHistorico := __CUSERID + " - " + cUserName + " -  " + Dtoc(dDatabase) + " / " + Substr(Time(),1,5)
			                            //" - Inclusao " ### " - Alteracao " ### " - Indefinido" ### - Exclusao
				cHistorico += If(nOpc==3, " - Inclusao " , If(nOpc==4, " - Alteracao " ,If(nOpc==0, " - Indefinido" , "Exclusao" ) ))
				MSMM(CW8_HISTOR,,,cHistorico,1,,,"CW8","CW8_HISTOR")
			CW8->(MsUnLock())
		EndIf
	EndIf

Restarea(aArea)
Return

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o	 ณ CW8GetSeq() ณAutor  ณ Jos้ Lucas         ณ Data ณ 13/02/10 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Obter a proxima sequencia para grava็ใo.				 	  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe	 ณ ExpC:=CW8GetSeq(cFilTabela,cEntidade,cCodigo,cGrupo,cCampo)ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso		 ณ CTBXFUN						            				  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
/*/
Static Function CW8GetSeq(cFilTabela,cEntidade,cCodigo,cGrupo,cCampo)
LOCAL aArea      := GetArea()
LOCAL cQuery     := ""
LOCAL cSequencia := "000000"
Local cAlias    := ""

	If Select("QRYCW8") > 0
		QRYCW8->(DbCloseArea())
	EndIf

	cQuery := ""
	cAlias := ""

	cQuery := "SELECT MAX(CW8_SEQ) MAXSEQ FROM "
	cQuery += RetSqlName("CW8") + " CW8 "
	cQuery += " WHERE"
	cQuery += " CW8_FILIAL = '" + xFilial("CW8") + "' "
	cQuery += " AND CW8_FILTAB = '" + cFilTabela + "' "
	cQuery += " AND CW8_TABELA = '" + cEntidade + "' "
	cQuery += " AND CW8_CODIGO = '" + cCodigo + "' "
	cQuery += " AND CW8_GRUPO = '" + cGrupo + "' "
	cQuery += " AND CW8_CAMPO = '" + cCampo + "' "
	cQuery += " AND CW8_DATA = '" + DTOS(dDataBase) + "' "
	cQuery += " AND D_E_L_E_T_ = ' ' "

	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), 'QRYCW8', .F., .T.)

	QRYCW8->(DbGoTop())
	IF QRYCW8->(!EOF())
	   cSequencia := QRYCW8->MAXSEQ
	ENDIF

	QRYCW8->(DbCloseArea())

	cSequencia := Soma1(cSequencia)

RestArea(aArea)
Return( cSequencia )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTGERAISRLบAutor  ณMarcos Hirakawa     บ Data ณ  05/17/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ SELECIONAR REGISTROS DE RETENวรO DE IMPOSTO DE RENDA       บฑฑ
ฑฑบ          ณ DA TABELA SFE, CAMPO FE_TIPO = "R", Para gerar o arquivo   บฑฑ
ฑฑบ          ณ XML.                                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ VENEZUELA                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Function CtGeraISRL(dDataIni,dDataFim, aA_002_1_3,lFirst)
LOCAL aSavArea   := {}
LOCAL cArqTmp    := "ISRL"
LOCAL cQuery1    := ""
LOCAL aStrQRY1   :={}
Local cRIFAGENTE := ""
LOCAL cArqtrb    := ""
LOCAL cNomIND    := ""
LOCAL cORDPAGO   := ""
LOCAL nORDPAGO   := 0
LOCAL cORDPAGO1  := ""
LOCAL nI         := 1
LOCAL nPERCENT   := 0.00
LOCAL cNFISCAL   := ""
LOCAL cPERIODO   := Alltrim(aA_002_1_3[2][3]) + Alltrim(aA_002_1_3[6][3])  // ANO_MES
LOCAL nCntRec    := 0.00
LOCAL nTotalRec  := mv_par07
LOCAL cNomFile   := ""
LOCAL lCriaSIX   := .T.
LOCAL lCloseArq  := .T.
LOCAL cKeyTrb    := ""

Private oTmpTable

DEFAULT lFirst      := .T.

If lFirst
	If ExistBlock("ESPISRL")
		cArqTmp := ExecBlock("ESPISRL",.F.,.F.,{cArqtmp, dDataIni, dDataFim ,cPERIODO,lFirst})
		Return(cArqTmp)
	EndIf

	dbSelectArea("SM0")
	cRIFAGENTE := Alltrim(M0_CGC)
	cRIFAGENTE := If(Empty(cRIFAGENTE),"00000000000",cRIFAGENTE)

	aadd(aStrQRY1,{ "RIFAGENTE" , "C", 14, 0 })
	aadd(aStrQRY1,{ "EMISSAO"   , "C", 06, 0 })
	aadd(aStrQRY1,{ "RIFSUJEITO", "C", 14, 0 })
	aadd(aStrQRY1,{ "NUMFATURA" , "C", 10, 0 })
	aadd(aStrQRY1,{ "ORDEMPAGO" , "C", 08, 0 })
	aadd(aStrQRY1,{ "CONCEITO"  , "C", 03, 0 })
	aadd(aStrQRY1,{ "VALORBASE" , "C", 17, 0 })
	aadd(aStrQRY1,{ "PERCENT"   , "C", 06, 0 })
	aadd(aStrQRY1,{ "NOMARQ"	, "C", 08, 0 })					// Nome do Arquivo.

	If Select("ISRL") > 0
   		oTmpTable:Delete()
	EndIf
	//Criar a abrir arquivo de trabalho e indice - alias ISRL

	If oTmpTable <> Nil
		oTmpTable:Delete()
	EndIf

	oTmpTable := FWTemporaryTable():New("ISRL")
	oTmpTable:SetFields( aStrQRY1 )
	oTmpTable:AddIndex("T1", {"NOMARQ","EMISSAO","RIFSUJEITO","NUMFATURA","ORDEMPAGO"})
	oTmpTable:Create()

	//Montar query e arquivo de trabalho para receber resultado da Query.
	If Select("TOPISRL") > 0
   		dbSelectArea("TOPISRL")
   		dbCloseArea()
	EndIf

	cQuery1 := "SELECT DISTINCT '" + cRIFAGENTE + "'RIFAGENTE, "
	cQuery1 += "FE_EMISSAO EMISSAO, "
	cQuery1 += "FE_ORDPAGO, "
	cQuery1 += "FE_NFISCAL, "
	cQuery1 += "FE_SERIE, "
	cQuery1 += "FE_VALBASE VALORBASE, "
	cQuery1 += "FE_ALIQ, "
	cQuery1 += "FE_CONCEPT, "
	cQuery1 += "FE_FORNECE, "
	cQuery1 += "FE_LOJA "
	cQuery1 += " FROM " + RetSqlName("SFE") + " SFE"
	cQuery1 += " WHERE SFE.FE_FILIAL = '" + xFilial("SFE") + "'"
	cQuery1 +=   " AND SFE.D_E_L_E_T_ = ' '"
	cQuery1 +=   " AND SFE.FE_TIPO='R'"
	cQuery1 +=   " AND SFE.FE_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "'"
	cQuery1 +=   " ORDER BY SFE.FE_EMISSAO, SFE.FE_NFISCAL, SFE.FE_ORDPAGO"

	cQuery1 := ChangeQuery(cQuery1)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),"TOPISRL",.T.,.T.)

	TCSetField("TOPISRL","EMISSAO","D",8,0)

	TOPISRL->(dbGoTop())
	If (Eof() .or. Bof())
   		Help(" ",1,"F3ICA3",,STR0008,1,0)//Nใo existe reten็๕es geradas!
   		TOPISRL->(dbCloseArea())		//Fechar o arquivo resultado da Query
   		Return
	EndIf

	TOPISRL->(dbGoTop())
	While ! TOPISRL->(Eof())
   		cNFISCAL := (AllTrim(TOPISRL->FE_SERIE) + AllTrim(TOPISRL->FE_NFISCAL) )

   		If "" == cNFISCAL .or. Empty(cNFISCAL)
    		cNFISCAL:= "0"
   		Else
      		If Len(cNFISCAL) > 10
         		cNFISCAL := RIGHT(cNFISCAL,10)
      		EndIf
   		EndIf

		cORDPAGO1:=  ALLTRIM(TOPISRL->FE_ORDPAGO)
		cORDPAGO := ""

   		If "" == cORDPAGO1 .OR. Empty(cORDPAGO1)
			cORDPAGO := "NA"
		Else
			nORDPAGO := Len(cORDPAGO1)
			For nI := 1 To nORDPAGO
		   		If subs(cORDPAGO1, nI,1) $ "0123456789"
			   		cORDPAGO += subs(cORDPAGO1, nI,1)
		   		Endif
			Next nI
		EndIf

   		nPERCENT := STR(FE_ALIQ,6,2)
   		If SUBS( nPERCENT , 4, 3) == ".00" // 010.00
	   		nPERCENT := STR(FE_ALIQ,3,0)
   		EndIf

		SA2->(dbSetOrder(1))
		SA2->(dbSeek(xFilial("SA2")+TOPISRL->FE_FORNECE+TOPISRL->FE_LOJA))
		dbSelectArea("ISRL")
		RecLock("ISRL", .T.)
			ISRL->RIFAGENTE := ALLTRIM(TOPISRL->RIFAGENTE)
			ISRL->EMISSAO   := cPERIODO // SUBS(TOPISRL->EMISSAO,1,6)
			ISRL->RIFSUJEITO:= SA2->A2_CGC
			ISRL->NUMFATURA := cNFISCAL
			ISRL->ORDEMPAGO := cORDPAGO
			ISRL->CONCEITO  := TOPISRL->FE_CONCEPT
			ISRL->VALORBASE := alltrim(STR(TOPISRL->VALORBASE,17,2))
			ISRL->PERCENT   := ALLTRIM(nPERCENT)
		MsUnLock()

		dbSelectArea("TOPISRL")
		TOPISRL->(dbSkip())
	EndDo

	dbSelectArea("ISRL")
	ISRL->(dbGoTop())

	nCntRec   := 0.00
	nTotalRec := mv_par07
	cNomFile  := cNomArq
	AADD(aNomArq,cNomFile)

	ISRL->(dbSetOrder(0))
	ISRL->(dbGoTop())
	While ISRL->(!Eof())
		nCntRec++
		If nCntRec > nTotalRec
			nCntRec  := 1
			cNomFile := Soma1(cNomFile)
        	AADD(aNomArq,cNomFile)
        	cAliasISRL := "ISRL"
 		EndIf
		RecLock("ISRL",.F.)
			ISRL->NOMARQ := cNomFile
		MsUnLock()
		ISRL->(dbSkip())
	EndDo

	ISRL->(dbSetOrder(1))
	ISRL->(dbGoTop())
EndIf
Return("ISRL")

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณ CTCloseArq() ณ Autor ณ Jos้ Lucas		          ณ Data ณ 05.05.11	ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Fecha a area aberta atrav้s da fun็ใo CtGeraISRL.                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ CtCloseArq(cAliasISRL,lClose)                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ                                                                      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Gen้rico                                                  			ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ ExpC1 = Nome do Alias definido para area de trabalho        		    ณฑฑ
ฑฑณ          ณ ExpL1 = Variavel de controle para fechamento da area.       		    ณฑฑ
ฑฑณ          ณ ExpC2 = Nome do Arquivo (cNomArq).				        		    ณฑฑ
ฑฑณ          ณ ExpL2 = Variavel de controle para apagar o arquivo de trabalho.	    ณฑฑ
ฑฑณ          ณ         Exemplo: ISRL001.xml										    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
/*/
Function CTCloseArq(cAlias,lClose,cNomArq,lApaga)
Local aSaveArea := GetArea()

DEFAULT lClose    := .F.

	If lClose
		dbSelectArea(cAlias)
		If !Empty(cNomArq) .and. lApaga .and. RecCount() == 0
			dbCloseArea()
			FErase(cNomArq)
		EndIf
	EndIf

RestArea(aSaveArea)
Return

/*/
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
// ฑฑณFuno    ณCTBOPRCND ณ Autor ณ MARCOS HIRAKAWA       ณ Data ณ 09.03.10	       ณฑฑ
// ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
// ฑฑณDescrio ณ REALIZA UMA OPERACAO ENTRE DUAS ENTIDADES DA MESMA VISAO GERENCIAL   ณฑฑ
// ฑฑณ          ณ E RETORNA O RESULTADO SE A CONDICAO FOR VERDADEIRA.                  ณฑฑ
// ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
// ฑฑณSintaxe   ณCTBOPRCND(cEntidade1,  cEntidade2,  cOperacao, cCondicao)             ณฑฑ
// ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
// ฑฑณRetorno   ณ array[1] Saldo Atual (com sinal)                                     ณฑฑ
// ฑฑณ          ณ array[2] Debito na Data                                              ณฑฑ
// ฑฑณ          ณ array[3] Credito na Data                                             ณฑฑ
// ฑฑณ          ณ array[4] Saldo Atual Devedor                                         ณฑฑ
// ฑฑณ          ณ array[5] Saldo Atual Credor                                          ณฑฑ
// ฑฑณ          ณ array[6] Saldo Anterior (com sinal)                                  ณฑฑ
// ฑฑณ          ณ array[7] Saldo Anterior Devedor                                      ณฑฑ
// ฑฑณ          ณ array[8] Saldo Anterior Credor                                       ณฑฑ
// ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
// ฑฑณ Uso      ณ dentro do CTGERPLAN:                                          	   ณฑฑ
// ฑฑณ          ณ SALDO=CTBOPRCND("699","799","-",">=0")                        	   ณฑฑ
// ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
// ฑฑณParametrosณ ExpC1, cEntidade1 = CODIGO DA 1a. ENTIDADE DA VISAO GERENCIAL.       ณฑฑ
// ฑฑณ          ณ ExpC2, cEntidade2 = CODIGO DA 2a. ENTIDADE DA VISAO GERENCIAL.       ณฑฑ
// ฑฑณ          ณ ExpC3, cOperacao   = Sintaxe da operacao:                    		   ณฑฑ
// ฑฑณ          ณ                      Soma, subtracao, multiplicacao e divisao 	   ณฑฑ
// ฑฑณ          ณ ExpC4, cCondicao   = Sintaxe da condicao , referente ao resultado    ณฑฑ
// ฑฑณ          ณ                      da cOperacao.                                   ณฑฑ
// ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
// ฑฑณ exemplo  ณ CTGERPLAN          SALDO=CTBOPRCND(699,799,"-",">=0")                ณฑฑ
// ฑฑณ          ณ CTGERPLAN          SALDO=CTBOPRCND(699,799,"-","<0")                 ณฑฑ
// ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
/*/
FUNCTION CTBOPRCND(cEntidade1, cEntidade2, cOperacao, cCondicao)
Local aSaldo    := {0,0,0,0,0,0,0,0}
Local aSaldoE01 := {0,0,0,0,0,0,0,0}
Local aSaldoE02 := {0,0,0,0,0,0,0,0}
Local nX        := 0
Local cEnt01  := upper(valtype(cEntidade1))
Local cEnt02  := upper(valtype(cEntidade2))
Local cOperP   := { "-", "+" , "*" , "/" , "%" }
Local lT       := .T.
Local lT1      := .T.
Local nROper   := 0
Local nLena    := 0

// ATENCAO: VARIAVEIS DE MEMORIA DEVEM SER TIPIFICADAS COMO PRIVATE PARA O FUNCIONAMENTO DA MACRO SUBSTITUICAO.
private cExpressao := ""
private aCTGERPL := {}
PRIVATE NJ := 1
PRIVATE cCond0 := ""

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerificacao dos parametros cCondicao!                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cCond0 := Test_cond( alltrim(cCondicao), @lT )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerificacao dos parametros cOperacao!                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if (! (empty( alltrim(cOperacao) ) )) .and. (! lT)
		if aScan(cOperP , cOperacao, 1) > 0
		   lT := .F.
		endif
	endif

	if lT
		Return aSaldo
	endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerificacao dos parametros cEntidade1 e cEntidade2 para serem caratecteres  !ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if cEnt01 == "N"
		cEnt01 := alltrim(str(cEntidade1,18,0))
	elseif cEnt01 == "C"
		cEnt01 := alltrim(cEntidade1)
	else
		cEnt01 := "" // cEntidade1 // ?
	Endif

	if "" == cEnt01
		Return aSaldo
	endif

	if cEnt02 == "N"
		cEnt02 := alltrim(str(cEntidade2,18,0))
	elseif cEnt02 == "C"
		cEnt02 := alltrim(cEntidade2)
	else
		cEnt02 := "" // cEntidade2 // ?
	Endif

	if "" == cEnt02
		Return aSaldo
	endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Na FUNCAO GetSldEnt, retornar o array! nTpSaldo = 0 .   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	// CARREGA SALDOS DA ENTIDADE 01 cEntidade1 - cEnt01
	IF !Empty(cEnt01)
		aSaldoE01 := GetSldEnt(cEnt01 , /* cCodVis */ , /* cOrdVis*/ , 0 /* nTpSaldo: 0-> Retornar o array */ , /* cArqTmp*/  )
	ENDIF

	// CARREGA SALDOS DA ENTIDADE 02 cEntidade2 - cEnt02
	IF !Empty(cEnt02)
		aSaldoE02 := GetSldEnt(cEnt02 , /* cCodVis */ , /* cOrdVis*/ , 0 /* nTpSaldo: 0-> Retornar o array */ , /* cArqTmp*/  )
	ENDIF

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณREALIZA OPERACAO cOperacao ENTRE SALDOS DAS ENTIDADES 01 E 02ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nLena  := Len(aSaldo)
	For nX :=1 to nLena
		nROper := 0
		do case
			case cOperacao == "-"
				nROper := round( aSaldoE01[nX] - aSaldoE02[nX] ,2)
			case cOperacao == "+"
				nROper := round( aSaldoE01[nX] + aSaldoE02[nX] ,2)
			case cOperacao == "*"
				nROper := round( aSaldoE01[nX] * aSaldoE02[nX] ,2)
			case cOperacao == "/"
				if aSaldoE02[nX] <> 0
					nROper := round( aSaldoE01[nX] / aSaldoE02[nX] ,2)
				endif
			case cOperacao == "%"
				if aSaldoE02[nX] <> 0
					nROper := round( aSaldoE01[nX] / aSaldoE02[nX] * 100 ,2)
				endif
		endcase
		aSaldo[nX] := nROper
	Next nX

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณATUALIZADO VALOR DE RETORNO EM FUNCAO DO ATENDIMENTO DA CONDICAO  cCond0 / cCondicao                          ณ
	//ณATENCAO: VARIAVEIS DE MEMORIA DEVEM SER TIPIFICADAS COMO PRIVATE PARA O FUNCIONAMENTO DA MACRO & SUBSTITUICAO.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nLena  := Len(aSaldo)
	aCTGERPL:= Aclone(aSaldo)
	NJ := 1
	DO WHILE NJ <= nLena
		cExpressao := "aCTGERPL[NJ] " + cCond0
		aCTGERPL[nJ] := IIF(&cExpressao, (aCTGERPL[nJ]), 0)
		NJ++
	ENDDO

Return (aCTGERPL)

// /*/
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
// ฑฑณFuno    ณCTBVLRCND ณ Autor ณ MARCOS HIRAKAWA       ณ Data ณ 09.03.10	       ณฑฑ
// ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
// ฑฑณDescrio ณ RETORNA O VALOR DE UMA ENTIDADE EM FUNCAO DO TESTE LOGICO APLICADO   ณฑฑ
// ฑฑณ          ณ AO VALOR DE UMA SEGUNDA ENTIDADE.                                    ณฑฑ
// ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
// ฑฑณSintaxe   ณCTBVLRCND(cEntidade1, cCondicao, cEntidade2)                          ณฑฑ
// ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
// ฑฑณRetorno   ณ array[1] Saldo Atual (com sinal)                                     ณฑฑ
// ฑฑณ          ณ array[2] Debito na Data                                              ณฑฑ
// ฑฑณ          ณ array[3] Credito na Data                                             ณฑฑ
// ฑฑณ          ณ array[4] Saldo Atual Devedor                                         ณฑฑ
// ฑฑณ          ณ array[5] Saldo Atual Credor                                          ณฑฑ
// ฑฑณ          ณ array[6] Saldo Anterior (com sinal)                                  ณฑฑ
// ฑฑณ          ณ array[7] Saldo Anterior Devedor                                      ณฑฑ
// ฑฑณ          ณ array[8] Saldo Anterior Credor                                       ณฑฑ
// ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
// ฑฑณ Uso      ณ dentro do CTGERPLAN:                                          	   ณฑฑ
// ฑฑณ          ณ SALDO=CTBVLRCND(801,">=0",828)                               		   ณฑฑ
// ฑฑณ          ณ se o saldo da celula "801" (cEntidade1)  da visao gerencial          ณฑฑ
// ฑฑณ          ณ e' ">=0" (cCondicao) , entao o saldo da celula "828" (cEntidade2)    ณฑฑ
// ฑฑณ          ณ da visao gerencial recebera' o saldo do "801", senao 0 (Zero).       ณฑฑ
// ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
// ฑฑณParametrosณ ExpC1, cEntidade1 = CODIGO DA 1a. ENTIDADE DA VISAO GERENCIAL.       ณฑฑ
// ฑฑณ          ณ ExpC2, cCondicao  = Sintaxe da condicao.                             ณฑฑ
// ฑฑณ          ณ ExpC3, cEntidade2 = CODIGO DA 2a. ENTIDADE DA VISAO GERENCIAL,       ณฑฑ
// ฑฑณ          ณ                      QUE PODERA'RECEBER O VALOR DA 1a. ENTIDADE.     ณฑฑ
// ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
// ฑฑณ exemplo  ณ CTGERPLAN          SALDO=CTBVLRCND(801,">=0",828)                    ณฑฑ
// ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// /*/
FUNCTION CTBVLRCND(cEntidade1, cCondicao, cEntidade2)
Local aSaldo	 := {0,0,0,0,0,0,0,0}
Local aSaldoE01 := {0,0,0,0,0,0,0,0}
Local aSaldoE02 := {0,0,0,0,0,0,0,0}
Local nX		:= 0
Local cEnt01 := upper(valtype(cEntidade1))
Local cEnt02 := upper(valtype(cEntidade2))
Local lT := .T.
Local nROper := 0
Local nLena  := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณATENCAO: VARIAVEIS DE MEMORIA DEVEM SER TIPIFICADAS COMO PRIVATE PARA O FUNCIONAMENTO DA MACRO SUBSTITUICAO.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
private cExpressao := ""
private aCTGERVL := {}
PRIVATE NJ:=1
private cCond0 := ""

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerificacao dos parametros cCondicaoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cCond0 :=  Test_cond( alltrim(cCondicao) , @lT )
	if lT
		Return aSaldo
	endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerificacao dos parametros cEntidade1 e cEntidade2 para serem caratecteres!ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if cEnt01 == "N"
		cEnt01 := alltrim(str(cEntidade1,18,0))
	elseif cEnt01 == "C"
		cEnt01 := alltrim(cEntidade1)
	else
		cEnt01 := "" // cEntidade1 // ?
	Endif

	if ( ("" == cEnt01) .OR. (empty(cEnt01)) )
		Return aSaldo
	endif

	if cEnt02 == "N"
		cEnt02 := alltrim(str(cEntidade2,18,0))
	elseif cEnt02 == "C"
		cEnt02 := alltrim(cEntidade2)
	else
		cEnt02 := "" // cEntidade2 // ?
	Endif

	if ( ("" == cEnt02) .OR. (empty(cEnt02)) )
		Return aSaldo
	endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Na GetSldEnt, retornar o array! nTpSaldo = 0 .   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	// CARREGA SALDOS DA ENTIDADE 01 cEntidade1 - cEnt01
	IF !Empty(cEnt01)
		aSaldoE01 := GetSldEnt(cEnt01, /* cCodVis */ , /* cOrdVis*/ , 0 /* nTpSaldo Retornar o array */ , /* cArqTmp*/  )
	ENDIF

	// CARREGA SALDOS DA ENTIDADE 02 cEntidade2 - cEnt02
	IF !Empty(cEnt02)
		aSaldoE02 := GetSldEnt(cEnt02, /* cCodVis */ , /* cOrdVis*/ , 0 /* nTpSaldo Retornar o array */ , /* cArqTmp*/  )
	ENDIF

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ DEFINE O VALOR DO RETORNO EM FUNCAO DA CONDICAO                                                               ณ
	//ณ ATENCAO: VARIAVEIS DE MEMORIA DEVEM SER TIPIFICADAS COMO PRIVATE PARA O FUNCIONAMENTO DA MACRO SUBSTITUICAO.  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nLena  := Len(aSaldoE01)
	aCTGERVL:= Aclone(aSaldoE01)
	NJ:=1
	Do while NJ <= nLena
		cExpressao := "aCTGERVL[NJ] " + cCond0
		aCTGERVL[nJ] := IIF(&cExpressao, aSaldoE02[nJ], 0)
		NJ++
	Enddo

Return (aCTGERVL)

// /*/
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
// ฑฑณFuno    ณTest_cond ณ Autor ณ MARCOS HIRAKAWA       ณ Data ณ 09.03.10	       ณฑฑ
// ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
// ฑฑณDescrio ณ Verifica o conteudo e sintaxe da condicao cCond0.                    ณฑฑ
// ฑฑณ          ณ Se for condicao valida, retorna .F. no parametro lT                  ณฑฑ
// ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
// ฑฑณSintaxe   ณTest_cond( cCond0, @lT )                                              ณฑฑ
// ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
// ฑฑณRetorno   ณ cCond2 : Sintaxe da condicao SEM ESPACOS                             ณฑฑ
// ฑฑณ          ณ @lT : .T. se cCond2 e' vazio                                         ณฑฑ
// ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
// ฑฑณParametrosณ ExpC1, cCond0 = Sintaxe da condicao.                                 ณฑฑ
// ฑฑณ          ณ ExpL2, @lT    = variavel logica para indicar que cCond0 e' vazio.    ณฑฑ
// ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
// ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
// */
Static Function Test_cond( cCond0, lVazio )
local nLena
local nX
local lT1
local cCond1 := ""
local cCond2 := ""

Default lVazio := .T.

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณRetirar espacos do cCondicao e concatenar caratere por caractere.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if (! ( empty( cCond0 ) )) .and. ( "" <> cCond0 )
		nLena := len( cCond0 )
		for nX := 1 to nLena
			cCond1 :=  upper(alltrim(subs(cCond0,nX,1)))
			lT1:= .F.
			if (!empty ( cCond1) ) .and. ( cCond1 <> " " )
				if cCond1 $ "<>=!#.()"
					lT1:= .T.
				elseif cCond1 $ "0123456789"
					lT1:= .T.
				elseif cCond1 $ "|.AND.|.OR.|"
					lT1:= .T.
				else
					lT1:= .F.
				endif
			endif
			cCond2 += iif( lT1 , cCond1, "")
		Next nX
		lVazio := .F.
	endif

return ( cCond2 )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCtEQUF101 บAutor  ณMarcos Hirakawa     บ Data ณ  06/23/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gerador XML do Formulario 101 de Equador .                 บฑฑ
ฑฑบ          ณ Declaracao de Imposto de Renda                             บฑฑ
ฑฑบ          ณ Trabalha com o arquivo EQU_F101.INI                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSintaxe   ณ dDataIni = Data Inicial para CTGERPLAN.                    บฑฑ
ฑฑบ          ณ dDataFim = Data Final   para CTGERPLAN.                    บฑฑ
ฑฑบ          ณ aArr4 = Array com a respostas do EQU_F101.INI, que         บฑฑ
ฑฑบ          ณ         e' o aArrT[4] /_atotal[4] do EQU_F101.INI          บฑฑ
ฑฑบ          ณ aArr4[01] = ano da declaracao do Imposto de Renda. 102     บฑฑ
ฑฑบ          ณ aArr4[02] = N๚mero de Formulario que Substituye. 104       บฑฑ
ฑฑบ          ณ aArr4[03] = RUC del Identificacion del Sujeto Pasivo. 201  บฑฑ
ฑฑบ          ณ aArr4[04] = Razao o Denominacion Social. 202               บฑฑ
ฑฑบ          ณ aArr4[05] = Expediente                 . 203               บฑฑ
ฑฑบ          ณ aArr4[06] = CEDULA IDENTIDADE / 198                        บฑฑ
ฑฑบ          ณ             PASAPORTE REPRESETANTE LEGAL 198               บฑฑ
ฑฑบ          ณ aArr4[07] = RUC CONTADOR - 199                             บฑฑ
ฑฑบ          ณ aArr4[08] = Codigo Visao Contabil                          บฑฑ
ฑฑบ          ณ aArr4[09] = Moneda                                         บฑฑ
ฑฑบ          ณ aArr4[10] = Tipo de Saldo                                  บฑฑ
ฑฑบ          ณ aArr4[11] = Codigo Quadro Contabil                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ aArrT = Array _atotal do EQU_F101.INI                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
FUNCTION CtEQUF101( dDataIni, dDataFim,  aArr4 , aArrT) //
Local aArea0  := GetArea()
Local cArqTmp := ""
Local cALIASTmp := "F101"
Local cCont := ""
Local cContA:= ""
LOCAL cArqtrb
LOCAL cNomIND
LOCAL nI := 1
LOCAL nJ := 1
LOCAL lEnd := .F.
LOCAL CSALDOS := aArr4[10]  // aArr4[8]
LOCAL aSetOfBook
Local cFL101 := ( cALIASTmp + GetDbExtension() )

	/*BEGINDOC
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ// VETORES COM CONTEUDO DE CARACTERES DO FORMULARIO 101                                                   ณ
	//ณ// {PAINEL001} = aArr4 /  aArrT[4] / _atotal[4]                                                           ณ
	//ณ// {OBJ001;004}2010 // 102 ano da declaracao do Imposto de Renda                                          ณ
	//ณ// {OBJ002;060}     // 104 NUMERO FORMULARIO SUBSTITUTO                                                   ณ
	//ณ// {OBJ003;060}     // 201 RUC SUJETO PASSIVO //                                                          ณ
	//ณ// {OBJ004;060}     // 202 RAZAO TESTE SOCIAL // Razao o Denominacion Social                              ณ
	//ณ// {OBJ005;060}     // 203 Expediente                                                                     ณ
	//ณ// {OBJ006/09;060}     // 198 CEDULA IDENTIDADE / PASAPORTE REPRESETANTE LEGAL                            ณ
	//ณ// {OBJ007/10;060}     // 199 RUC CONTADOR //                                                             ณ
	//ณ// {OBJ008/06;003}011  // Codigo Visao Contabil                                                           ณ
	//ณ// {OBJ009/07;002}01   // Moneda                                                                          ณ
	//ณ// {OBJ010/08;002}1    // Tipo de Saldo                                                                   ณ
	//ณ// {OBJ011/11;002}1    // Codigo Quadro Contabil                                                          ณ
	//ณ//  ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤณ
	//ณ// (PRE) aAdd(_aTotal[17],"102")                                                                          ณ
	//ณ// (PRE) aAdd(_aTotal[17],"104")                                                                          ณ
	//ณ// (PRE) aAdd(_aTotal[17],"198")                                                                          ณ
	//ณ// (PRE) aAdd(_aTotal[17],"199")                                                                          ณ
	//ณ// (PRE) aAdd(_aTotal[17],"201")                                                                          ณ
	//ณ// (PRE) aAdd(_aTotal[17],"202")                                                                          ณ
	//ณ// (PRE) aAdd(_aTotal[17],"203")                                                                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	ENDDOC*/
	aSetOfBook	:= CTBSetOf( aArr4[08] )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta Arquivo Temporario com o  CTGerPlan         		     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
		CTGerPlan(oMeter,oText,oDlg,@lEnd,@cArqTmp,;
				dDataIni,; // dDataIni
				dDataFim,; // dDataFim
				"",; // 08-cAlias
				"",; // 09-cIdent
				"",; // 10-cContaIni
				Repl( "Z", Len( CT1->CT1_CONTA )),; // 11-cContaFim
				"",; // 12-cCCIni
				Repl( "Z", Len(CTT->CTT_CUSTO)),; // 13-cCCFim
				"",; // 14-cItemIni
				Repl("Z", Len(CTD->CTD_ITEM)),; // 15-cItemFim
				"",; // 16-cClvlIni
				Repl("Z", Len(CTH->CTH_CLVL)),; // 17-cClvlFim
				aArr4[09],;  // 18- MOEDA
				cSaldos,; // 19-cSaldos
				aSetOfBook,; // 20-aSetOfBook
				Space(2),; // 21-cSegmento
				Space(20),; // 22-cSegIni
				Repl("Z", 20),; // 23-cSegFim
				Space(30) /* 24-cFiltSegm */ ,;
				/*25 lNImpMov */,;
				/*26 lImpConta */,;
				/*27 nGrupo */,;
				/*28 cHeader */,;
				/*29 lImpAntLP */,;
				dDataFim /*30 dDataLP */,;
				/*31 nDivide */,;
				.T. /*32-lVlrZerado */ ,; //
				/*33 cFiltroEnt */,;
				/*34 cCodFilEnt */,;
				/*35 cSegmentoG */,;
				/*36 cSegIniG */,;
				/*37 cSegFimG */,;
				/*38 cFiltSegmG */,;
				/*39 lUsGaap */,;
				/*40 cMoedConv */,;
				/*41 cConsCrit */,;
				/*42 dDataConv */,;
				/*43 nTaxaConv */,;
				/*44 aGeren */,;
				/*45 lImpMov */,;
				/*46 lImpSint */,;
				/*47 cFilUSU */,;
				/*48 lRecDesp0 */,;
				/*49 cRecDesp */,;
				/*50 dDtZeraRD */,;
				/*51 lImp3Ent */,;
				/*52 lImp4Ent */,;
				/*53 lImpEntGer */,;
				/*54 lFiltraCC */,;
				/*55 lFiltraIt */,;
				/*56  lFiltraCV */,;
				aArr4[09],;  // /*57 - cMoedaDsc*/
				lMovPeriodo:=.F.,; // 58-lMovPeriodo
				/*59 aSelFil */,;
				/*60 dDtCorte */,;
				.T.,; // 61-lPlGerSint
				.F.,; // 62-lConsSaldo  = Consolida saldo ? Padrao .F.
				/* 63-lCompEnt    = Consolida saldo entre entidades? Padrao .F. */,;
				/*64 cArqAux = Arquivo auxiliar permitindo a recursividade */,;
				/*65-lUsaNmVis = Usa nome da visao gerencial ? Padrao .F. */,;
				/*66-cNomeVis = Nome da visao gerencial (retorno, passar por ref.)*/,;
				/*67-lCttSint = Indica se imprime ou nใo C.Custo Sint้ticos */,;
				.F.,; // 68-lTodasFil  = Todas Filiais ? Padrao .F.
				aArr4[11] /*69 Codigo quadro Contabil. */ )},; // Codigo quadro Contabil.
				 STR0010,;//"Criando Arquivo Temporario"
				STR0011)//"DEMONSTRACAO DE RESULTADOS"

	dbSelectArea("cArqTmp")
	if 'ORD' $ UPPER(INDEXKEY())
	   DBSETORDER(1) // ORDEM POR CONTA
	ENDIF
	dbGoTop()
	DO WHILE .NOT. ("cArqTmp")->(EOF())
		nI := 1
		cContA := subs( (alltrim( ("cArqTmp")->CONTA ) + space(3)), 1, 3)
		cCont  := ""
		IF cContA == "102" // ano
			nJ := 01
		ELSEIF cContA == "104" // NUMERO FORMULARIO SUBSTITUTO
			nJ := 02
		ELSEIF cContA == "198" // CEDULA IDENTIDADE / PASAPORTE REPRESETANTE LEGAL
			nJ := 06
		ELSEIF cContA == "199" // RUC CONTADOR
			nJ := 07
		ELSEIF cContA == "201" // RUC SUJETO PASSIVO
			nJ := 03
		ELSEIF cContA == "202" // Razao o Denominacion Social
			nJ := 04
		ELSEIF cContA == "203" // Expediente
			nJ := 05
		ELSEIF cContA == "828" // Auxiliar do calculo
			nJ := -2
		ELSEIF cContA $ "|100|200|800|920|928|" // Auxiliar do calculo
			nJ := -1
		Else
			nJ := 0
		endif

		IF nJ > 0
			cCont := IiF( "" == ALLTRIM(aArr4[nJ]), "" , ALLTRIM(aArr4[nJ]) )
		elseIF nJ == 0
			cCont := alltrim(str( ( ("cArqTmp")->SALDOATU ) , 18,2))
		endif

		DO WHILE .T. .AND. nI <= 1000
			IF RecLock( "cArqTmp", .f. )
				IF nJ >= 0 .and. "" <> cCont
					("cArqTmp")->DESCCTA := cCont
				ELSE
					DBDELETE()
				ENDIF
			EXIT
			ENDIF

			INKEY(.5)
			nI++
		ENDDO
		("cArqTmp")->(dbCommit())
		("cArqTmp")->(MsUnlock())
		IF nI > 1000
			__Quit()
		ENDIF
		("cArqTmp")->(DBSKIP())
	ENDDO

	dbSelectArea("cArqTmp")
	dbGoTop()

	IF Select("F101") > 0
		DbSelectArea("F101")
		dbCloseArea()
	Endif
	IF FILE( cFL101 ) // FILE("F101.DBF")
		FErase( cFL101 )
	ENDIF

	COPY TO (cFL101)

	DbSelectArea("cArqTmp")
	dbCloseArea()

	If Select("cArqTmp") == 0
		FErase(cArqTmp+GetDBExtension())
		FErase(cArqTmp+OrdBagExt())
	EndIF

	dbUseArea ( .T. /*[ lNew]*/, __LocalDriver /*[ cRdd]*/, (cFL101) /*[ cArq]*/, cALIASTmp /*[ cAlias]*/, .T. /*[ lShare]*/, .F. /*[ lReadOnly]*/ )

	DbSelectArea(cALIASTmp)
	dbGoTop()

RETURN (cALIASTmp)

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณCTBValidAt ณ Autor ณ WAGNER MONTENEGRO     ณ Data ณ 28.04.10ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณValida as Atividades Complementares                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณCTBValidAt(cDBCR,nRotina)             					  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ aAtivCT1,aAtivCTD,aAtivCTH,aAtivCTT         				  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Generico                                                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ ExpC1 = Debito ou Credito "DB" / "CR"                      ณฑฑ
ฑฑณ          ณ ExpC2 = 1 ou 2 (1=Chamada por CTBA101)                     ณฑฑ
ฑฑณ          ณ                (2=Chamada por CTBA105)                     ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑANALISTA          * ALTERAวีES                                          ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑ Danilo Dias    * Incluido Parโmetros:                                  ณฑฑ
ฑฑ 			      *    cConta  = N๚mero da Conta Contแbil (CT1)           ณฑฑ
ฑฑ 			      *    cCusto  = N๚mero da Centro de Custo (CTT)          ณฑฑ
ฑฑ 			      *    cItem   = N๚mero do Item Contแbil (CTD)            ณฑฑ
ฑฑ 			      *    cClasse = N๚mero da Classe de Valor (CTH)          ณฑฑ
ฑฑ 			      * Tratamento para validar se existe Atividade ativada   ณฑฑ
ฑฑ 			      * e obrigat๓ria sem preenchimento no lan็amento.        ณฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
/*/
Function CTBValidAT( cDBCR, nRotina, cConta, cCusto, cItem, cClasse )
Local cAliasCT2 := If( nRotina == 1, "M->", "TMP->" ) //SE ROTINA 1=CTBA101 2=CTBA105
Local lRet      := .T.
Local cEntidade := ""
Local cAlias    := ""
Local aGenerico := {}

//Controle de Loop
Local ni
Local nj
Local nf

	aSaveArea:= GetArea()

	If __lAtivComp == NIL
		// Carrega os campos de atividade complementar do SX3
		CtbLoadAcAt(cAliasCT2,cDBCR)
	EndIf

	//RESETA ARRAY RECEBIDO DAS ROTINAS E PREENCHE COM O CACHE Jม CARREGADO
	If _aAtivCT1 == Nil
		aAtivCT1 := {}
	Else
		aAtivCT1 := Nil
		aAtivCT1 := {}

		For nI := 1 To Len( _aAtivCT1 )
			If _aAtivCT1[ nI , 1 ] == cDBCR
				aAdd( aAtivCT1 , _aAtivCT1[ nI , 2 ] )
			EndIf
		Next nI
	EndIf

	If _aAtivCTT == Nil
		aAtivCTT := {}
	Else
		aAtivCTT := Nil
		aAtivCTT := {}

		For nI := 1 To Len( _aAtivCTT )
			If _aAtivCTT[ nI , 1 ] == cDBCR
				aAdd( aAtivCTT , _aAtivCTT[ nI , 2 ] )
			EndIf
		Next nI
	EndIf

	If _aAtivCTD == Nil
		aAtivCTD := {}
	Else
		aAtivCTD := Nil
		aAtivCTD := {}

		For nI := 1 To Len( _aAtivCTD )
			If _aAtivCTD[ nI , 1 ] == cDBCR
				aAdd( aAtivCTD , _aAtivCTD[ nI , 2 ] )
			EndIf
		Next nI
	EndIf

	If _aAtivCTH == Nil
		aAtivCTH := {}
	Else
		aAtivCTH := Nil
		aAtivCTH := {}

		For nI := 1 To Len( _aAtivCTH )
			If _aAtivCTH[ nI , 1 ] == cDBCR
				aAdd( aAtivCTH , _aAtivCTH[ nI , 2 ] )
			EndIf
		Next nI
	EndIf

	//Valida preenchimento de informa็๕es complementares obrigat๓rias
	If ( lRet )
		For nj := 1 To 4
			If ( nj == 1 )
				cAlias    := "CT1"
		   		nf        := Len( aAtivCT1 )
		   		cEntidade := cConta
		   		aGenerico := AClone( aAtivCT1 )
		  	ElseIf ( nj == 2 )
		  		cAlias    := "CTD"
		   		nf        := Len( aAtivCTD )
		   		cEntidade := cItem
		   		aGenerico := AClone( aAtivCTD )
			ElseIf ( nj == 3 )
				cAlias    := "CTH"
		   		nf        := Len( aAtivCTH )
		   		cEntidade := cClasse
		   		aGenerico := AClone( aAtivCTH )
		 	ElseIf ( nj == 4 )
		 		cAlias    := "CTT"
		   		nf        := Len( aAtivCTT )
		   		cEntidade := cCusto
		   		aGenerico := AClone( aAtivCTT )
		   	Else
		   		cEntidade := ""
		   		aGenerico := {}
		   		nf        := 0
		  	EndIf

		  	If ( lRet ) .And. ( !Empty( cEntidade ) )
		  		(cAlias)->(dbSetOrder(1))
			  	If ( cAlias )->( dbSeek( xFilial(cAlias) + cEntidade ) )
					For ni := 1 To nf
						If ( Val(&(aGenerico[ni][1])) == 1 ) .And. ( Val(&(aGenerico[ni][2])) == 1 )
							If ( Empty( &(aGenerico[ni][3]) ) )
								Help( " ", 1, "P" + aGenerico[ni][3] )
								lRet := .F.
								Exit
							EndIf
						EndIf
					Next
				EndIf
			EndIf
		Next
	EndIf

RestArea(aSaveArea)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCtbCache  บAutor  ณMicrosiga           บ Data ณ  06/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Function CtbCache(nCache)
Local lRet := .F.

	If 	nCache == 1
		lRet := Eval(_baDtComp)
	ElseIf nCache == 2
		lRet := Eval(_baDtInUse)
	ElseIf nCache == 3
		lRet := Eval(_bCtbAmarra)
	ElseIf nCache == 4
		lRet := Eval(_bCtbPosic)
	ElseIf nCache == 5
		lRet := Eval(_baCtbMInUse)
	ElseIf nCache == 6
		lRet := Eval(_baCtbDtInUse)
	ElseIf nCache == 7
		lRet := Eval(_baCtbValidDt)
	ElseIf nCache == 8
		lRet := Eval(_bEntdBloq)
	ElseIf nCache == 9
		lRet := Eval(_bPerCache)
	EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCtbCacheIsบAutor  ณMicrosiga           บ Data ณ  06/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Function CtbCacheIs(nCache)
	If __lCacheIs == Nil
		__lCacheIs := ( GetNewPar( "MV_CTBCACH" , "1" ) == "1" )   //"0"=Nao Trabalha com Cache "1"=Trabalha com Cache
	EndIf
Return(__lCacheIs)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTDom623  บAutor  ณAlvaro Camillo Neto บ Data ณ  17/05/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Seleciona registro para o arquivo magnetico da Republica   บฑฑ
ฑฑบ          ณ Dominicana ISR623.INI                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rep Dominicana                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Function CTDom623(cConceito,cTipoRet,lFirst,dDataFech)
Local cArqTmp := ""
Local cQuery  := ""
Local cArqQry := GetNextAlias()
Local aCampos := {}
Local aArea   := GetArea()
Local aAreaSM0:= SM0->(GetArea())
Local dDataIni:= Stod("")
Local dDataFim:= Stod("")
Local nNumMax := 0
Local nContReg:= 0
Local cArqAux := "ISR623"
Local cDest	   := ""
Local cExt	   := ""
Local nContArq:= 1


Default cConceito := "00000007"
Default cTipoRet  := "R"
Default lFirst    := .T.

	lArqXML := .F.

	If lFirst
		_dFechDom := dDataFech
	Else
		dDataFech := _dFechDom
		Return(cArqAux)
	EndIf

	Pergunte("CTBA950",.F.)
	dDataIni:= MV_PAR01
	dDataFim:= MV_PAR02
	nNumMax := MV_PAR07

	aadd(aCampos,{ "RNCENTIDAD", "C", Len(SM0->M0_CGC), 0 })
	aadd(aCampos,{ "PERIODRET" , "C", 06, 0 })
	aadd(aCampos,{ "DATARET"   , "D", 08, 0 })
	aadd(aCampos,{ "VALOR"     , "N", 14, 2 })
	aadd(aCampos,{ "NUMREF"    , "C", 20, 0 })
	aadd(aCampos,{ "TIPREF"    , "C", 19 , 0 })
	aadd(aCampos,{ "NOM_BANCO" , "C", TamSX3("A6_NOME")[1], 0 })
	AADD(aCampos,{ "NOMARQ"		, "C",30, 0 }) // Nome do Arquivo.
	AADD(aCampos,{ "DATFECH"   , "D",08, 0 }) // Nome do Arquivo.

	cQuery  += " SELECT " + CRLF
	cQuery  += "     FE_EMISSAO, " + CRLF
	cQuery  += "     A2_CGC, " + CRLF
	cQuery  += "     A6_NOME, " + CRLF
	cQuery  += "     FE_NUMREF, " + CRLF
	cQuery  += "     FE_TIPREF, " + CRLF
	cQuery  += "     FE_RETENC " + CRLF
	cQuery  += "  FROM "+RetSQLName("SFE")+" SFE " + CRLF
	cQuery  += " LEFT JOIN "+RetSQLName("SA2")+" SA2 ON " + CRLF
	cQuery  += "     A2_FILIAL = '"+xFilial("SA2")+"' AND " + CRLF
	cQuery  += "     A2_COD = FE_FORNECE AND " + CRLF
	cQuery  += "     A2_LOJA = FE_LOJA AND " + CRLF
	cQuery  += "     SA2.D_E_L_E_T_ = '' " + CRLF
	cQuery  += " LEFT JOIN "+RetSQLName("SA6")+" SA6 ON " + CRLF
	cQuery  += "     A6_FILIAL = '"+xFilial("SA6")+"' AND " + CRLF
	cQuery  += "     A6_COD = FE_BANCO AND " + CRLF
	cQuery  += "     A6_AGENCIA = FE_AGENCIA AND " + CRLF
	cQuery  += "     A6_NUMCON = FE_NUMCON AND " + CRLF
	cQuery  += "     SA6.D_E_L_E_T_ = '' " + CRLF
	cQuery  += " WHERE " + CRLF
	cQuery  += "    FE_FILIAL = '"+xFilial("SFE")+"' AND  " + CRLF
	cQuery  += "    FE_EMISSAO >= '"+DtoS(dDataIni)+"' AND  " + CRLF
	cQuery  += "    FE_EMISSAO <= '"+DtoS(dDataFim)+"' AND " + CRLF
	cQuery  += "    FE_TIPO = '"+cTipoRet+"' AND " + CRLF
	cQuery  += "    FE_CONCEPT = '"+cConceito+"' AND  " + CRLF
	cQuery  += "    SFE.D_E_L_E_T_ = '' " + CRLF
	cQuery  += " ORDER BY FE_EMISSAO "  + CRLF
	cQuery := ChangeQuery(cQuery )

	If Select(cArqQry) > 0
		(cArqQry)->(dbCloseArea())
	EndIf

	dbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqQry , .T. , .F.)

	TCSetField( cArqQry, "FE_RETENC", "N", TamSX3("FE_RETENC")[1], TamSX3("FE_RETENC")[2] )
	TCSetField( cArqQry, "FE_EMISSAO", "D" )

	DbSelectArea(cArqQry)
	(cArqQry)->(dbGoTop())

	SM0->(dbSetOrder(1))
	SM0->(dbSeek( cEmpAnt + cFilAnt ))

	SplitPath(cNomArq,,,@cDest,@cExt)
	cNomArq  := Alltrim(cDest + "_" + Alltrim(SM0->M0_CGC) + cExt)
	cNomFile := cNomArq
	AADD(aNomArq,cNomArq)

	If (cArqQry)->(!EOF())
		If Select(cArqAux) > 0
			dbSelectArea(cArqAux)
			dbCloseArea()
		EndIf

		cArqTmp := CriaTrab(aCampos, .T.)
		dbUseArea( .T.,, cArqTmp, cArqAux, .F., .F. )
		DbSelectarea(cArqAux)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria Indice Temporario do Arquivo de Trabalho 1.             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cChave  := "NOMARQ+DTOS(DATARET)"
	cArqInd	:= CriaTrab(Nil, .F.)
	IndRegua(cArqAux,cArqInd,cChave,,,OemToAnsi(STR0009))//"Selecionando Registros..."

		While (cArqQry)->(!EOF())
			nContReg++
			If nContReg > nNumMax
				nContReg  := 1
				nContArq++
				SplitPath(cNomArq,,,@cDest,@cExt)
				cNomFile := Alltrim(cDest)+"_"+cValToChar(nContArq)+cExt
				AADD(aNomArq,cNomFile)
		    EndIf
			RecLock(cArqAux,.T.)
				(cArqAux)->RNCENTIDAD	:= (cArqQry)->A2_CGC
				(cArqAux)->PERIODRET	:= StrZero(Month((cArqQry)->FE_EMISSAO),2) + cValToChar(Year((cArqQry)->FE_EMISSAO))
				(cArqAux)->DATARET		:= (cArqQry)->FE_EMISSAO
				(cArqAux)->VALOR		:= (cArqQry)->FE_RETENC
				(cArqAux)->NUMREF		:= (cArqQry)->FE_NUMREF
				(cArqAux)->TIPREF		:= IIF( (cArqQry)->FE_TIPREF == '1',"Cheque","Transferencia" ) //"Cheque" ### "Transferencia"
				(cArqAux)->NOM_BANCO	:= (cArqQry)->A6_NOME
				(cArqAux)->NOMARQ 		:= cNomFile
			MsUnlock()
			(cArqQry)->(dbSkip())
		EndDo
		(cArqAux)->(DBGOTOP())
	Else
		cArqAux := ""
	EndIf

RestArea(aAreaSM0)
RestArea(aArea)
Return (cArqAux)

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณCTGera609  ณ Autor ณ Pequim				 ณ Data ณ 29.04.11ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณFuncao para gerar o arquivo de trabalho das retencoes de ISRณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณCTGera609(dDtIni,dDtFin)             				  		  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ cArqTmp								                      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Republica Dominicana                                       ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ ExpD1 = Data inicial do periodo para selecao de dados      ณฑฑ
ฑฑณ          ณ ExpC2 = Data final do periodo para selecao de dados        ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
/*/
Function CtGera609(cConceito,cTipoRet,lFirst,dDataFech)
Local aArea		:= GetArea()
Local aAreaSM0	:= SM0->(GetArea())
Local cArqAux	:= "ISR609"
Local cArqTmp	:= ""
Local cQuery	:= ""
Local cAliasQry:= GetNextAlias()
Local aCampos	:= {}
Local nTamFor	:= TAMSX3("FE_FORNECE")[1]
Local nTamLoj	:= TAMSX3("FE_LOJA")[1]
Local nTamRNC	:= Len(SM0->M0_CGC)
Local cDest		:= ""
Local cExt		:= ""
Local nContArq	:= 1
Local nNumMax	:= 0
Local nContReg	:= 0
Local cAnoMes	:= ""

Default cConceito := "00000001"
Default cTipoRet  := "R"
Default lFirst    := .T.

	lArqXML := .F.

	If lFirst
		_dFechDom := dDataFech
	Else
		dDataFech := _dFechDom
		Return(cArqAux)
	EndIf

	Pergunte("CTBA950",.F.)
	dDataIni:= MV_PAR01
	dDataFim:= MV_PAR02
	nNumMax := MV_PAR07

	//Estrutura do TRB
	aadd(aCampos, { "RNCAGENT  ", "C", nTamRnc, 0 } )
	aadd(aCampos, { "PERIODO   ", "C", 06     , 0 } )
	aadd(aCampos, { "FORNECE   ", "C", nTamFor, 0 } )
	aadd(aCampos, { "LOJA      ", "C", nTamLoj, 0 } )
	aadd(aCampos, { "RAZAOSOC  ", "C", 30     , 0 } )
	aadd(aCampos, { "TIPOSERV  ", "C", 02     , 0 } )
	aadd(aCampos, { "DATAFACT  ", "D", 08     , 0 } )
	aadd(aCampos, { "DATACERT  ", "D", 08     , 0 } )
	aadd(aCampos, { "VALISR    ", "N", 12     , 2 } )
	aadd(aCampos, { "VALNOTA   ", "N", 12     , 2 } )
	aadd(aCampos, { "NOMARQ    ", "C", 50     , 0 } )

	//---------------------------------------------------------------------------------------------------
	//Criar TRB
	If Select(cArqAux) > 0
		dbSelectArea(cArqAux)
		dbCloseArea()
	EndIf

	cChave  := "NOMARQ+DTOS(DATACERT)+FORNECE+LOJA"
	cArqTmp :=CriaTrab(aCampos)
	dbUseArea( .T.,, cArqTmp, cArqAux, NIL, .F. )

	cIndex := CriaTrab(nil,.f.)
	IndRegua(cArqAux,cIndex,cChave,,,"Selecionando Registros...")

	//Selecao das informacoes
	If ExistBlock("ESP609")
		cArqAux := ExecBlock("ESP609",.F.,.F.,{oMeter,oText,oDlg,lEnd,cArqtmp,dDataIni,dDataFim})
	Else
		cQuery := " SELECT "
		//Campos SFE
		cQuery += 		" SFE.FE_FILIAL,SFE.FE_TIPO,SFE.FE_FORNECE,SFE.FE_LOJA,SFE.FE_RETENC, "
		cQuery += 		" SFE.FE_VALBASE, SFE.FE_VALIMP, SFE.FE_EMISSAO, "

		//Campos SA2
		cQuery += 		" SA2.A2_COD, SA2.A2_LOJA, SA2.A2_NOME, "

		//Campos SE2
		cQuery += 		" SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA, SE2.E2_TIPO, "
		cQuery += 		" SE2.E2_FORNECE, SE2.E2_LOJA, SE2.E2_NATUREZ, SE2.E2_EMISSAO, "

		//Campos SED
		cQuery += 		" SED.ED_CODIGO, SED.ED_CLASFIS "

		cQuery += " FROM " + RetSQLTab('SFE')
		//Relacao SFE/SE2
		cQuery += "INNER JOIN "+RetSQLTab('SE2')+ " ON "
		cQuery += " 	SE2.E2_FILIAL = '"+xFilial("SE2")+"' AND "
		cQuery += "    SFE.FE_SERIE = SE2.E2_PREFIXO AND "
		cQuery += "    SFE.FE_NFISCAL = SE2.E2_NUM AND "
		cQuery += "    SFE.FE_PARCELA = SE2.E2_PARCELA AND "
		cQuery += "    SFE.FE_FORNECE = SE2.E2_FORNECE AND "
		cQuery += "    SFE.FE_LOJA = SE2.E2_LOJA AND "
		cQuery += "    SE2.D_E_L_E_T_ = ' ' "

		//Relacao SFE/SA2
		cQuery += "INNER JOIN "+RetSQLTab('SA2')+ " ON "
		cQuery += " 	SA2.A2_FILIAL = '"+xFilial("SA2")+"' AND "
		cQuery += "    SFE.FE_FORNECE = SA2.A2_COD AND "
		cQuery += "    SFE.FE_LOJA = SA2.A2_LOJA AND "
		cQuery += "    SA2.D_E_L_E_T_ = ' ' "

		//Relacao SE2/SED
		cQuery += "INNER JOIN "+RetSQLTab('SED')+ " ON "
		cQuery += " 	SED.ED_FILIAL = '"+xFilial("SED")+"' AND "
		cQuery += "    SE2.E2_NATUREZ = SED.ED_CODIGO AND "
		cQuery += "    SED.D_E_L_E_T_ = ' ' "

		cQuery += " WHERE "
		cQuery += " 	SFE.FE_FILIAL =   '"+xFilial("SFE")+"' AND "
		cQuery += "    SFE.FE_EMISSAO >= '"+DTOS(dDataIni)+"' AND "
		cQuery += "    SFE.FE_EMISSAO <= '"+DTOS(dDataFim)+"' AND "
		cQuery += "    SFE.FE_TIPO =     '"+cTipoRet+"' AND "
		cQuery += "    SFE.FE_CONCEPT =  '"+cConceito+"' AND  "
		cQuery += "    SFE.D_E_L_E_T_ = ' ' "
		cQuery += "ORDER BY SFE.FE_EMISSAO,SFE.FE_FORNECE,SFE.FE_LOJA"
		cQuery := ChangeQuery(cQuery)

		If Select(cAliasQry) > 0
			(cAliasQry)->(dbCloseArea())
		EndIf

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)

		TCSetField(cAliasQry,"FE_RETENC" ,"N",TamSX3("FE_RETENC")[1] ,TamSX3("FE_RETENC")[2] )
		TcSetField(cAliasQry,"FE_EMISSAO","D",TamSX3("FE_EMISSAO")[1],TamSX3("FE_EMISSAO")[2])
		TcSetField(cAliasQry,"E2_EMISSAO","D",TamSX3("E2_EMISSAO")[1],TamSX3("E2_EMISSAO")[2])

		DbSelectArea(cAliasQry)
		(cAliasQry)->(dbGoTop())

		//Define nome do primeiro arquivo
		SM0->(dbSetOrder(1))
		SM0->(dbSeek( cEmpAnt + cFilAnt ))
		SplitPath(cNomArq,,,@cDest,@cExt)
		cAnoMes  := Substr(dtos(dDataFech),1,6)
		cNomArq  := PADR(Alltrim(cDest + "_" + Alltrim(SM0->M0_CGC)+ "_" + cAnoMes + cExt),50)
		cNomFile := cNomArq
		AADD(aNomArq,cNomArq)

		// Verifica se encontrou registros para exportar.
		If !((cAliasQry)->(BOF()) .and. (cAliasQry)->(EOF()))
			//Gravar dados no TRB
			While !(cAliasQry)->(EOF())
				//Temporario - RETIRAR NO FONTE FINAL
				If !( (cAliasQry)->E2_TIPO $ "ISR/IR-/IS-" )
					(cAliasQry)->(DBSKIP())
					LOOP
				Endif

				nContReg++
				//Define nome dos demais arquivos (se existirem mais registros do que o numero maximo
				//de registros definidos para cada arquivo)
				If nContReg > nNumMax
					nContReg  := 1
					nContArq++
					SplitPath(cNomArq,,,@cDest,@cExt)
					cNomFile := PADR(Alltrim(cDest)+"_"+cValToChar(nContArq)+cExt,50)
					AADD(aNomArq,cNomFile)
				EndIf

				RecLock(cArqAux,.T.)
					(cArqAux)->RNCAGENT	:= PADR(SM0->M0_CGC,14)
					(cArqAux)->PERIODO	:= StrZero(Month((cAliasQry)->FE_EMISSAO),2) + cValToChar(Year((cAliasQry)->FE_EMISSAO))
					(cArqAux)->FORNECE	:= (cAliasQry)->FE_FORNECE
					(cArqAux)->LOJA		:= (cAliasQry)->FE_LOJA
					(cArqAux)->RAZAOSOC	:= (cAliasQry)->A2_NOME
					(cArqAux)->TIPOSERV	:= StrZero(VAL((cAliasQry)->ED_CLASFIS),2)
					(cArqAux)->DATAFACT	:= (cAliasQry)->E2_EMISSAO
					(cArqAux)->DATACERT	:= (cAliasQry)->FE_EMISSAO
					(cArqAux)->VALNOTA	:= (cAliasQry)->FE_VALBASE
					(cArqAux)->VALISR		:= (cAliasQry)->FE_RETENC
					(cArqAux)->NOMARQ 	:= cNomFile
				MSUnlock()

				(cAliasQry)->(DBSKIP())
			EndDo
			(cArqAux)->(DBGOTOP())
		Else
			cArqAux := ""
		EndIf
	Endif

RestArea(aAreaSM0)
RestArea(aArea)
Return (cArqAux)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCtbMod22PtบAutor  ณMicrosiga           บ Data ณ  12/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExecuta visao para utilizacao no arquivo modelo22.ini para  บฑฑ
ฑฑบ          ณgerar declaracao modelo 22 para Portugal                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Function CtbMod22Pt(aParam, aVisao, cAliasQ12, cAlias396, cAlias397)
Local aQuadro12 := {}
Local aParQdo12 := { 0,0.00 }
Local bAddQ12   := {|oLstBox|	CtbQ12Add(NIL, aParQdo12, oLstBox, aQuadro12) }
Local bDelQ12   := {|oLstBox|	CtbQ12Del(oLstBox, aQuadro12) }

Local aQ9_396    := {}
Local aParQ9396  := { 0.00,0 }
Local bAddQ9_396 := {|oLstBox|	CtQ9396Add(NIL, aParQ9396, oLstBox, aQ9_396) }
Local bDelQ9_396 := {|oLstBox|	CtQ9396Del(oLstBox, aQ9_396) }

Local aQ9_397    := {}
Local aParQ9397  := { 0.00,0 }
Local bAddQ9_397 := {|oLstBox|	CtQ9397Add(NIL, aParQ9397, oLstBox, aQ9_397) }
Local bDelQ9_397 := {|oLstBox|	CtQ9397Del(oLstBox, aQ9_397) }
Local aStruct

	aVisao := GetSldPlGer( aParam[10][1]/*cSetOfBook*/, STOD(aParam[1][1])/*dDataIni*/, STOD(aParam[1][2])/*dDataFim*/, "01"/*cMoeda*/, 4000/*nTamArray*/, .T./*lAbs*/, .T./*lTdsRgs*/, "1"/*cSaldos*/, /*lNImpMov*/,;
                      /*cHeader*/, /*lImpAntLP*/, /*dDataLP*/, /*lVlrZerado*/, /*cMoedaDesc*/, /*lMovPeriodo*/, /*lPlGerSint*/, /*lConsSaldo*/)

    //criacao dos arquivos temporarios
	//Quadro 12
	aStruct := {}
	aAdd(aStruct,{"LINHA",			"N",	5,	0})
	aAdd(aStruct,{"NIPC",			"N",	9,	0})
	aAdd(aStruct,{"RETFTE",			"N",	13,	2})

    oTmpTableQ12 := FWTemporaryTable():New(cAliasQ12,aStruct)
    oTmpTableQ12:Create()

	//Quadro 09 - Campo 396
	aStruct := {}
	aAdd(aStruct,{"LINHA",			"N",	5,	0})
	aAdd(aStruct,{"PREJUIZOS",		"N",	13,	2})
	aAdd(aStruct,{"NIF",			"N",	9,	0})

    oTmpTable396 := FWTemporaryTable():New(cAlias396,aStruct)
    oTmpTable396:Create()

	//Quadro 09 - Campo 397
	aStruct := {}
	aAdd(aStruct,{"LINHA",			"N",	5,	0})
	aAdd(aStruct,{"VLRUTILIZ",		"N",	13,	2})
	aAdd(aStruct,{"NIF",			"N",	9,	0})

    oTmpTable397 := FWTemporaryTable():New(cAlias397,aStruct)
    oTmpTable397:Create()

	If aParam[12][1]=="T"
		If File(Alltrim(mv_par05)+Alltrim(mv_par04))
			CtbCarrega(aQuadro12, "23")
		EndIf
		If Len(aQuadro12) > 0
			CtbLstBM22( /*oDlg*/, "Quadro"+"12",{"Linha","Num.Identificacao","Retencao na Fonte"}, aQuadro12, bAddQ12, bDelQ12) //Quadro ##"Linha" ##"Num.Identificacao" ##"Retencao na Fonte"
		Else
			CtbLstBM22( /*oDlg*/, "Quadro"+"12",{"Linha","Num.Identificacao","Retencao na Fonte"}, {{0,0,0}}, bAddQ12, bDelQ12)//Quadro ##"Linha" ##"Num.Identificacao" ##"Retencao na Fonte"
		EndIf
		CtbPopTrb(cAliasQ12, aQuadro12)
	EndIf

	If aParam[12][2]=="T"
		If File(Alltrim(mv_par05)+Alltrim(mv_par04))
			CtbCarrega(aQ9_396, "24")
		EndIf
		If Len(aQ9_396) > 0
			CtbLstBM22( /*oDlg*/,"Quadro" + "09 - "+"Campo "+"396",{"Linha","Prejuizos","NIF"}, aQ9_396, bAddQ9_396, bDelQ9_396) //Quadro ##Campo ##Linha ##Prejuizos
		Else
			CtbLstBM22( /*oDlg*/,"Quadro" + "09 - "+"Campo "+"396",{"Linha","Prejuizos","NIF"}, {{0,0,0}}, bAddQ9_396, bDelQ9_396) //Quadro ##Campo ##Linha ##Prejuizos
		EndIf
		CtbPopTrb(cAlias396, aQ9_396)
	EndIf

	If aParam[12][3]=="T"
		If File(Alltrim(mv_par05)+Alltrim(mv_par04))
			CtbCarrega(aQ9_397, "25")
		EndIf
		If Len(aQ9_397) > 0
			CtbLstBM22( /*oDlg*/,"Quadro" + "09 - "+"Campo "+"397",{"Linha","Valor Utilizado en el Periodo","NIF"}, aQ9_397, bAddQ9_397, bDelQ9_397) //Quadro ##Campo ##Linha ##"Valor Utilizado en el Periodo"
		Else
			CtbLstBM22( /*oDlg*/,"Quadro" + "09 - "+"Campo "+"397",{"Linha","Valor Utilizado en el Periodo","NIF"}, {{0,0.00,0}}, bAddQ9_397, bDelQ9_397) //Quadro ##Campo ##Linha ##"Valor Utilizado en el Periodo"
		EndIf
		CtbPopTrb(cAlias397, aQ9_397)
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCtbLstBM22บAutor  ณMicrosiga           บ Data ณ  12/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para montar list box com informacoes quadro 12 /     บฑฑ
ฑฑบ          ณcampo 396 / campo 397                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CtbLstBM22(oDlg, cTitulo, aColunas, aLstRet, bAddLin, bDelLin, bConfirma)
Local oPanel, oBmp, oListBox, oAdiciona, oCanc, oGrava
Local lDlg := .T.
Local lOk  := .F.

Default oDlg      := NIL
Default aColunas  := {{"",""}}
Default aLstRet   := {{"",""}}
Default bAddLin   := {||.T.}
Default bDelLin   := {||.T.}
Default bConfirma := {||.T.}

	lDlg := lDlg .And. (oDlg == NIL)
	lDlg := lDlg .And. ( ValType(oDlg)!="O" )

	If lDlg
		DEFINE MSDIALOG oDlg FROM 00,00 TO 290,490 PIXEL TITLE OemToAnsi(cTitulo)
	EndIf

	oPanel       := TPanel():New(1,1,'',oDlg,oDlg:oFont, .T., .T.,,,235,125,.T.,.T. )
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT

	@ 0,0 BITMAP oBmp RESNAME "PROJETOAP" Of oDlg SIZE 100,300 NOBORDER When .F. PIXEL
	oListBox := TWBrowse():New( 20,05,235,125,,aColunas,,oPanel,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oListBox:SetArray(aLstRet)
	oListBox:bLine := { ||{aLstRet[oListBox:nAT][1],aLstRet[oListBox:nAT][2], aLstRet[oListBox:nAT][3]}}
	oListBox:bLDblClick := { ||Eval(oAdiciona:bAction)}

	@ 05,05 BUTTON oAdiciona Prompt "Adiciona Linha"  SIZE 45 ,10  FONT oDlg:oFont ACTION Eval(bAddLin,oListBox)            OF oPanel PIXEL //"Adiciona Linha"
	@ 05,75 BUTTON oCanc     Prompt "Exclui Linha"  SIZE 45 ,10  FONT oDlg:oFont ACTION Eval(bDelLin,oListBox)            OF oPanel PIXEL //"Exclui Linha"
	@ 05,175 BUTTON oGrava   Prompt "Confirma os Dados"  SIZE 65 ,10  FONT oDlg:oFont ACTION (lOk:=Eval(bConfirma),oDlg:End()) OF oPanel PIXEL //"Confirma os Dados"

	If lDlg
		ACTIVATE MSDIALOG oDlg CENTERED
	EndIf

Return(aLstRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCtbQ12Add บAutor  ณMicrosiga           บ Data ณ  12/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAdiciona linha para Quadro 12                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CtbQ12Add(oDlg, aDados, oLstBox, aQuadro12)
Local aDadosAux
Local aParam := {	{ 1 ,"Num.Identificacao", aDados[1] ,"@E 999999999",""  ,"" ,".T." ,65 ,.T. }, ; //"Num.Identificacao"
					{ 1 ,"Retencao na Fonte", aDados[2] ,"@E 9,999,999,999.99" 	 ,""  ,"" ,".T." ,65 ,.T. } } //"Retencao na Fonte"

	ParamBox(aParam ,"Quadro12", aDados,,,.F.,120,3, oDlg,,.F.,.F.)

	aDadosAux := { 0, aDados[1], aDados[2] }
	aDados := {0,0}
	If Len(aQuadro12) == 1 .And. aQuadro12[1,1]=0
		aQuadro12 := {}
	EndIf
	aAdd(aQuadro12, aClone(aDadosAux) )
	aQuadro12[Len(aQuadro12), 1] := Len(aQuadro12)

	oLstBox:SetArray(aQuadro12)
	oLstBox:bLine := { ||{oLstBox:aArray[oLstBox:nAT][1],oLstBox:aArray[oLstBox:nAT][2],oLstBox:aArray[oLstBox:nAT][3]}}
	oLstBox:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCtbQ12Del บAutor  ณMicrosiga           บ Data ณ  12/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExclui linha do Quadro 12                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CtbQ12Del(oLstBox, aQuadro12)
Local nPosAt := oLstBox:nAT
Local nX

	If Len(aQuadro12) > 1
		aDel(aQuadro12, nPosAt)
		aSize(aQuadro12, Len(aQuadro12)-1)
		For nX := 1 TO Len(aQuadro12)
			aQuadro12[nX, 1] := nX
		Next
		oLstBox:SetArray(aQuadro12)
		oLstBox:bLine := { ||{oLstBox:aArray[oLstBox:nAT][1],oLstBox:aArray[oLstBox:nAT][2],oLstBox:aArray[oLstBox:nAT][3]}}
		oLstBox:Refresh()
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCtQ9396AddบAutor  ณMicrosiga           บ Data ณ  12/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAdiciona linha para quadro referente campo 396              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CtQ9396Add(oDlg, aDados, oLstBox, aQ9_396)
Local aDadosAux
Local aParam := {	{ 1 ,"Prejuizos", aDados[2] ,"@E 9,999,999,999.99" 	 ,""  ,"" ,".T." ,65 ,.T. }, ; //"Prejuizos"
					{ 1 ,"NIF", aDados[1] ,"@E 999999999",""  ,"" ,".T." ,65 ,.T. } }

	ParamBox(aParam ,"Quadro" + "09 - "+"Campo "+"396", aDados,,,.F.,120,3, oDlg,,.F.,.F.) //"Cuadro " ##"Campo "
	aDadosAux := { 0, aDados[1], aDados[2] }
	aDados := {0,0}
	If Len(aQ9_396) == 1 .And. aQ9_396[1,1]=0
		aQ9_396 := {}
	EndIf
	aAdd(aQ9_396, aClone(aDadosAux) )
	aQ9_396[Len(aQ9_396), 1] := Len(aQ9_396)

	oLstBox:SetArray(aQ9_396)
	oLstBox:bLine := { ||{oLstBox:aArray[oLstBox:nAT][1],oLstBox:aArray[oLstBox:nAT][2],oLstBox:aArray[oLstBox:nAT][3]}}
	oLstBox:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCtQ9396DelบAutor  ณMicrosiga           บ Data ณ  12/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExclui linha do quadro referente ao campo 396               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CtQ9396Del(oLstBox, aQ9_396)
Local nPosAt := oLstBox:nAT
Local nX

	If Len(aQ9_396) > 1
		aDel(aQ9_396, nPosAt)
		aSize(aQ9_396, Len(aQ9_396)-1)
		For nX := 1 TO Len(aQ9_396)
			aQ9_396[nX, 1] := nX
		Next
		oLstBox:SetArray(aQ9_396)
		oLstBox:bLine := { ||{oLstBox:aArray[oLstBox:nAT][1],oLstBox:aArray[oLstBox:nAT][2],oLstBox:aArray[oLstBox:nAT][3]}}
		oLstBox:Refresh()
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCtQ9397AddบAutor  ณMicrosiga           บ Data ณ  12/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAdiciona linha para quadro campo 397                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CtQ9397Add(oDlg, aDados, oLstBox, aQ9_397)
Local aDadosAux

Local aParam := {	{ 1 ,"Valor Utilizado en el Periodo", aDados[2] ,"@E 9,999,999,999.99" 	 ,""  ,"" ,".T." ,65 ,.T. }, ; //"Valor Utilizado no Periodo"
					{ 1 ,"NIF", aDados[1] ,"@E 999999999",""  ,"" ,".T." ,65 ,.T. } }

	ParamBox(aParam,"Quadro" + "09 - "+"Campo "+"397" ,aDados,,,.F.,120,3,oDlg,,.F.,.F.) //"Cuadro " ##"Campo "

	aDadosAux := { 0, aDados[1], aDados[2] }
	aDados := {0.00,0.00}
	If Len(aQ9_397) == 1 .And. aQ9_397[1,1]=0
		aQ9_397 := {}
	EndIf
	aAdd(aQ9_397, aClone(aDadosAux) )
	aQ9_397[Len(aQ9_397), 1] := Len(aQ9_397)

	oLstBox:SetArray(aQ9_397)
	oLstBox:bLine := { ||{oLstBox:aArray[oLstBox:nAT][1],oLstBox:aArray[oLstBox:nAT][2],oLstBox:aArray[oLstBox:nAT][3]}}
	oLstBox:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCtQ9397DelบAutor  ณMicrosiga           บ Data ณ  12/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExcluir linha do quadro para o campo 397                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CtQ9397Del(oLstBox, aQ9_397)
Local nPosAt := oLstBox:nAT
Local nX

	If Len(aQ9_397) > 1
		aDel(aQ9_397, nPosAt)
		aSize(aQ9_397, Len(aQ9_397)-1)
		For nX := 1 TO Len(aQ9_397)
			aQ9_397[nX, 1] := nX
		Next
		oLstBox:SetArray(aQ9_397)
		oLstBox:bLine := { ||{oLstBox:aArray[oLstBox:nAT][1],oLstBox:aArray[oLstBox:nAT][2],oLstBox:aArray[oLstBox:nAT][3]}}
		oLstBox:Refresh()
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCtbCarregaบAutor  ณMicrosiga           บ Data ณ  12/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarrega os dados para registros 23/24/25                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CtbCarrega(aDados, cRegistro)
Local cArqTxt := Alltrim(mv_par05)+Alltrim(mv_par04)
Local nHandle
Local cLinha
Local aTxt := {}
Local aAux := {}
Local nX

	If (nHandle := FT_FUse(cArqTxt)) == -1
		Help(" ",1,"NOFILEIMPOR")
		Return
	EndIf

	FT_FGOTOP()
	cLinha := FT_FREADLN()
	While !FT_FEOF()
		cLinha := FT_FREADLN()
		AADD(aTxt,cLinha)
		FT_FSKIP()
	EndDo
	FT_FUSE()

	For nX := 1 TO Len(aTxt)
		If Subs(aTxt[nX],1,2) == cRegistro
			If cRegistro == "23"
				aAux := {}
				aAdd(aAux, Val(Subs(aTxt[nX],3,5)))
				aAdd(aAux, Val(Subs(aTxt[nX],8,9)))
				aAdd(aAux, Val(Subs(aTxt[nX],17,12))/100)
			ElseIf cRegistro == "24"
				aAux := {}
				aAdd(aAux, Val(Subs(aTxt[nX],3,5)))
				aAdd(aAux, Val(Subs(aTxt[nX],8,12))/100)
				aAdd(aAux, Val(Subs(aTxt[nX],20,9)))
			ElseIf cRegistro == "25"
				aAux := {}
				aAdd(aAux, Val(Subs(aTxt[nX],3,5)))
				aAdd(aAux, Val(Subs(aTxt[nX],8,12))/100)
				aAdd(aAux, Val(Subs(aTxt[nX],20,9)))
			EndIf
			aAdd(aDados, aClone(aAux))
		EndIf
	Next

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCtbLoadAcAtบAutor  ณMicrosiga          บ Data ณ  11/26/12   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega os campos dinamicos de atividade complementar      บฑฑ
ฑฑบ          ณ configurados no lan็amento padrใo.                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CtbLoadAcAt(cAliasCT2,cDBCR)
Local aArea
Local aAreaSX3

	If __lAtivComp == NIL
		aArea       := GetArea()
		aAreaSX3    := SX3->( GetArea() )
		__lAtivComp := .T.

		DbSelectArea("SX3")
		DbSetOrder(2)
		If _aAtivCT1 == NIL
			_aAtivCT1 := {}
			If DbSeek("CT1_ACAT01")
				While SX3->(! Eof() .And. Substr(SX3->X3_CAMPO,1,8)=="CT1_ACAT")
					If  SX3->X3_ARQUIVO = "CT1"  .and. Val(Substr(SX3->X3_CAMPO, 9, 2)) >= 1 .and. X3USO( SX3->X3_USADO )
						AADD(_aAtivCT1, {"CT1->CT1_AT"	+ Substr(SX3->X3_CAMPO, 9, 2) + "OB";
						,"CT1->CT1_ACAT"+ Substr(SX3->X3_CAMPO, 9, 2),cAliasCT2 + "CT2_AT" + Substr(SX3->X3_CAMPO, 9, 2) + cDBCR})
					EndIf
					SX3->(DbSkip())
				EndDo
			EndIf
		EndIf

		If _aAtivCTT == NIL
			_aAtivCTT := {}
			If DbSeek("CTT_ACAT01")
				While Substr(SX3->X3_CAMPO,1,8)=="CTT_ACAT"
					If SX3->X3_ARQUIVO = "CTT" .and. Val(Substr(SX3->X3_CAMPO, 9, 2)) >= 1 .and. X3USO( SX3->X3_USADO )
						AADD(_aAtivCTT,	{"CTT->CTT_AT"   + Substr(SX3->X3_CAMPO, 9, 2) + "OB";
						,"CTT->CTT_ACAT" + Substr(SX3->X3_CAMPO, 9, 2),cAliasCT2 + "CT2_AT" + Substr(SX3->X3_CAMPO, 9, 2) + cDBCR})
					EndIf
					SX3->(DbSkip())
				EndDo
			EndIf
		EndIf

		If _aAtivCTD == NIL
			_aAtivCTD := {}
			If DbSeek("CTD_ACAT01")
				While SX3->( !Eof() .And.Substr(SX3->X3_CAMPO,1,8) == "CTD_ACAT")
					If SX3->X3_ARQUIVO = "CTD" .and. Val(Substr(SX3->X3_CAMPO, 9, 2)) >= 1 .and. X3USO( SX3->X3_USADO )
						AADD(_aAtivCTD,	{"CTD->CTD_AT"	+ Substr(SX3->X3_CAMPO, 9, 2) + "OB";
						,"CTD->CTD_ACAT"+ Substr(SX3->X3_CAMPO, 9, 2),cAliasCT2 + "CT2_AT" + Substr(SX3->X3_CAMPO, 9, 2) + cDBCR})
					EndIf
					SX3->(DbSkip())
				EndDo
			EndIf
		EndIf

		If _aAtivCTH == NIL
			_aAtivCTH := {}
			If DbSeek("CTH_ACAT01")
				While SX3->( !Eof() .And. Substr(SX3->X3_CAMPO,1,8)=="CTH_ACAT" )
					If SX3->X3_ARQUIVO = "CTH" .and. Val(Substr(SX3->X3_CAMPO, 9, 2)) >= 1 .and.  X3USO( SX3->X3_USADO )
						AADD(_aAtivCTH,	{"CTH->CTH_AT"   + Substr(SX3->X3_CAMPO, 9, 2) + "OB";
						,"CTH->CTH_ACAT" + Substr(SX3->X3_CAMPO, 9, 2),cAliasCT2 + "CT2_AT" + Substr(SX3->X3_CAMPO, 9, 2) + cDBCR})
					EndIf
					SX3->(DbSkip())
				EndDo
			EndIf
		EndIf

		RestArea(aAreaSX3)
		RestArea(aArea)
	EndIf

Return


Function SldAntCVX(dDataIni,dDataFin,cMoeda,cTpSaldo,cEntCont,cConta,cCusto,cItem,cCLVL,c5Ent)
Local aTamSaldo  := TamSX3("CVX_SLDDEB")
Local cQryPerAn2 := ""
Local aSldAntCVx := {0,0,0}
Local aAreaCvx   := GetArea()

	If Select("SLDANT2") > 0
		SLDANT2->(dbCloseArea())
	Endif

	cQryPerAn2 := "SELECT SUM(CVX_SLDDEB) CVX_SLDDEB,SUM(CVX_SLDCRD) CVX_SLDCRD"
	cQryPerAn2 += " FROM " + RetSqlName("CVX") + " CVX"
	cQryPerAn2 += " WHERE "
	cQryPerAn2 += "	CVX_FILIAL = '"+xFilial("CVX")+"' "
	cQryPerAn2 += "  AND CVX_DATA < '"+DTOS(dDataIni)+"' "
	cQryPerAn2 += " AND CVX_NIV01 = '" + cConta + "' "

	If "2" $ cEntCont .and. !Empty(cCusto)
		cQryPerAn2 += " AND CVX_NIV02 = '" + cCusto + "' "
	EndIf	        ADMIN
	If "3" $ cEntCont .and. !Empty(cItem)
		cQryPerAn2 += " AND CVX_NIV03 = '" + cItem + "' "
	EndIf
	If "4" $ cEntCont .and. !Empty(cCLVL)
		cQryPerAn2 += " AND CVX_NIV04 = '" + cCLVL + "' "
	EndIf
	If "5" $ cEntCont .and. !Empty(c5Ent)
		cQryPerAn2 += " AND CVX_NIV05 = '" + c5Ent + "' "
	EndIf
	If cPaisLoc="COL" .and. "5" $ cEntCont
		cQryPerAn2 += " AND CVX_NIV05 <> '' "
	EndIf

	cQryPerAn2 += " AND CVX_MOEDA = '" + cMoeda + "' "
	cQryPerAn2 += " AND CVX_TPSALD = '" + cTpSaldo + "' "
	cQryPerAn2 += " AND D_E_L_E_T_ = ' ' "

	cQryPerAn2 := ChangeQuery(cQryPerAn2)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryPerAn2),"SLDANT2",.T.,.F.)

	TcSetField("SLDANT2","CVX_SLDDEB"  ,"N",aTamSaldo[1],aTamSaldo[2])
	TcSetField("SLDANT2","CVX_SLDCRD"  ,"N",aTamSaldo[1],aTamSaldo[2])

	DbSelectArea("SLDANT2")
    SLDANT2->(DbGoTop())
	    If  SLDANT2->(!EOF())
	    	aSldAntCVx[1]:= SLDANT2->CVX_SLDDEB
	    	aSldAntCVx[2]:= SLDANT2->CVX_SLDCRD
	    	aSldAntCVx[3]:= SLDANT2->CVX_SLDDEB-SLDANT2->CVX_SLDCRD
		EndIf
	SLDANT2->(DbCloseArea())

	RestArea(aAreaCvx)
Return aSldAntCVx

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSeekCte    บAutor  ณMicrosiga          บ Data ณ  11/26/12   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcion para buscar los clientes en base a la entidad      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static function SeekCte(cEntidad)
Local lRet    := .T.
Local cQryCte := ""

	cQryCte := "SELECT A1_NOMEPRI,A1_NOMEPES,A1_NOMEMAT,A1_NOMEPAT ,A1_NOME,A1_END,A1_COD_MUN,A1_EST,A1_PAIS, "
	cQryCte += "A1_TIPDOC,A1_CGC,A1_EMAIL FROM "
	cQryCte += RetSqlName("SA1") + " SA1 "
	cQryCte += " WHERE A1_FILIAL = '"+xFilial("SA1")+"' "
	cQryCte += "  AND A1_PFISICA = '" + cEntidad + "' "
	cQryCte += "  AND D_E_L_E_T_ = ' ' "
	cQryCte := ChangeQuery(cQryCte)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryCte),"QryCte",.T.,.F.)
	IF QryCte->(EOF())
	   lRet:= .f.
	ENDIF

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSeekPro    บAutor  ณMicrosiga          บ Data ณ  11/26/12   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcion para buscar los proveedores en base a la entidad   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static function SeekPro(cEntidad)
Local lRet    := .T.
Local cQryPro := ""

	cQryPro := "SELECT A2_NOMEPRI,A2_NOMEPES,A2_NOMEMAT,A2_NOMEPAT ,A2_NOME,A2_END,A2_COD_MUN, "
	cQryPro += "A2_EST,A2_PAIS,A2_TIPDOC,A2_PFISICA,A2_CGC,A2_EMAIL FROM "
	cQryPro += RetSqlName("SA2") + " SA2 "
	cQryPro += " WHERE A2_FILIAL = '"+xFilial("SA2")+"' "
	cQryPro += "  AND A2_PFISICA = '" + cEntidad + "' "
	cQryPro += "  AND D_E_L_E_T_ = ' ' "
	cQryPro := ChangeQuery(cQryPro)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryPro),"QryPro",.T.,.F.)
	IF QryPro->(EOF())
	   lRet:= .f.
	ENDIF

Return lRet
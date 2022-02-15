#INCLUDE "PROTHEUS.CH"
#INCLUDE "SPEDNFE.CH"

User Function BaixaXML()

	Local aChave	:= {}
	Local aDocs		:= {}

	Local cURL		:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local cIdEnt	:= RetIdEnti()
	Local cChave	:= ""
	Local cAlert	:= ""
	Local cSitConf	:= ""
	Local cAmbiente	:= ""

	Local dData		:= CtoD("  /  /    ")

	Local lOk       := .F.

	Local nX		:= 0

	//If ReadyTSS()
		oWs :=WSMANIFESTACAODESTINATARIO():New()
		oWs:cUserToken   := "TOTVS"
		oWs:cIDENT	     := cIdEnt
		oWs:cINDNFE		 := "0"
		oWs:cINDEMI      := "0"
		oWs:_URL         := AllTrim(cURL)+"/MANIFESTACAODESTINATARIO.apw"

		oWs :=WSMANIFESTACAODESTINATARIO():New()
		oWs:cUserToken   := "TOTVS"
		oWs:cIDENT	     := cIdEnt
		oWs:cAMBIENTE	 := ""
		oWs:cVERSAO      := ""
		oWs:_URL         := AllTrim(cURL)+"/MANIFESTACAODESTINATARIO.apw"
		oWs:CONFIGURARPARAMETROS()
		cAmbiente		 := oWs:OWSCONFIGURARPARAMETROSRESULT:CAMBIENTE

		If oWs:SINCRONIZARDOCUMENTOS()
			If Type ("oWs:OWSSINCRONIZARDOCUMENTOSRESULT:OWSDOCUMENTOS:OWSSINCDOCUMENTOINFO") <> "U"
				If Type("oWs:OWSSINCRONIZARDOCUMENTOSRESULT:OWSDOCUMENTOS:OWSSINCDOCUMENTOINFO")=="A"
					aDocs := oWs:OWSSINCRONIZARDOCUMENTOSRESULT:OWSDOCUMENTOS:OWSSINCDOCUMENTOINFO
				Else
					aDocs := {oWs:OWSSINCRONIZARDOCUMENTOSRESULT:OWSDOCUMENTOS:OWSSINCDOCUMENTOINFO}
				EndIf

				For nX := 1 To Len(aDocs)
					If Type(aDocs[nX]:CCHAVE) <> "U" .and. Type(aDocs[nX]:CSITCONF) <> "U"
						cSitConf  := aDocs[Nx]:CSITCONF
						cChave    := aDocs[Nx]:CCHAVE
						If !DbSeek( xFilial("C00") + cChave)
							RecLock("C00",.T.)
							C00->C00_FILIAL     := xFilial("C00")
							C00->C00_STATUS     := cSitConf
							C00->C00_CHVNFE		:= cChave
							dData := CtoD("01/"+Substr(cChave,5,2)+"/"+Substr(cChave,3,2))
							C00->C00_ANONFE		:= Strzero(Year(dData),4)
							C00->C00_MESNFE		:= Strzero(Month(dData),2)
							C00->C00_SERNFE		:= Substr(cChave,23,3)
							C00->C00_NUMNFE		:= Substr(cChave,26,9)
							C00->C00_CODEVE		:= Iif(cSitConf $ '0',"1","3")
							aadd(aChave,cChave)
							lOk := .T.
							MsUnLock()
						EndIf
					EndIf
				Next
				If lOk
					MonitoraManif(aChave,cAmbiente,cIdEnt,cUrl)
				EndIf
				If Empty (aDocs)
					cAlert:= "Não há documentos para serem sincronizados"
					Aviso("Sincronização",cAlert,{"OK"},3)
				EndIF
			EndIf
		Else
			Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"OK"},3)
		EndIf
	//Else
	//	Aviso("SPED","Execute o módulo de configuração do serviço, antes de utilizar esta opção!!!",{"Ok, Entendi"},3)
	//EndIf

Return .T.

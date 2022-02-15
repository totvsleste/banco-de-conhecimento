USer Function GERASC8()

	Local c_Hash	:= "1234567890"

	dbSelectArea("SC8")

	For nL := 1 To 400

		RecLock("SC8", .T.)
		SC8->C8_FILIAL	:= xFilial("SC8")
		SC8->C8_ITEM	:= StrZero( nL, 4 )
		SC8->C8_NUMPRO	:= "01"
		SC8->C8_PRODUTO	:= "31150005"
		SC8->C8_UM		:= "UN"
		SC8->C8_QTDCTR	:= 0
		SC8->C8_QUANT	:= 1
		SC8->C8_PRECO	:= 0
		SC8->C8_CODTAB	:= ""
		SC8->C8_TOTAL	:= 0
		SC8->C8_COND	:= "005"
		SC8->C8_TAXAFIN	:= 0
		SC8->C8_PRAZO	:= 5
		SC8->C8_OBS		:= ""
		SC8->C8_FORNECE	:= "000574"
		SC8->C8_LOJA	:= "0001"
		SC8->C8_CONTATO	:= "FEITOSA"
		SC8->C8_FILENT	:= "0311"
		SC8->C8_EMISSAO	:= DDATABASE
		SC8->C8_NUM		:= "000002"
		SC8->C8_ALIIPI	:= 0
		SC8->C8_TES		:= ""
		SC8->C8_PICM	:= 0
		SC8->C8_VALFRE	:= 0
		SC8->C8_VALEMB	:= 0
		SC8->C8_DESC1	:= 0
		SC8->C8_DESC2	:= 0
		SC8->C8_DESC3	:= 0
		SC8->C8_TPFRETE	:= "F"
		SC8->C8_TOTFRE	:= 0
		SC8->C8_AVISTA	:= 0
		SC8->C8_REAJUST	:= ""
		SC8->C8_DTVISTA := CTOD("  /  /  ")
		SC8->C8_VALIDA	:= DDATABASE + 30
		SC8->C8_NUMPED	:= ""
		SC8->C8_ITEMPED	:= ""
		SC8->C8_NUMSC	:= ""
		SC8->C8_ITEMSC	:= ""
		SC8->C8_DATPRF	:= DDATABASE + 30
		SC8->C8_IDENT	:= "1"
		SC8->C8_VLDESC	:= 0
		SC8->C8_SEGUM	:= ""
		SC8->C8_QTSEGUM	:= 0
		SC8->C8_MOTIVO	:= ""
		SC8->C8_GRUPCOM	:= ""
		SC8->C8_STATME	:= ""
		SC8->C8_OK    	:= ""
		SC8->C8_DESPESA	:= 0
		SC8->C8_SEGURO	:= 0
		SC8->C8_VALIPI	:= 0
		SC8->C8_VALICM	:= 0
		SC8->C8_BASEICM	:= 0
		SC8->C8_BASEIPI	:= 0
		SC8->C8_DESC	:= 0
		SC8->C8_MSG		:= ""
		SC8->C8_MOEDA	:= 1
		SC8->C8_TXMOEDA	:= 0
		SC8->C8_ORCFOR	:= ""
		SC8->C8_SEQFOR	:= ""
		SC8->C8_ITEFOR	:= ""
		SC8->C8_ITEMGRD	:= ""
		SC8->C8_ITSCGRD	:= ""
		SC8->C8_GRADE	:= ""
		SC8->C8_CODORCA	:= ""
		SC8->C8_ORIGEM	:= ""
		SC8->C8_BASESOL	:= 0
		SC8->C8_VALSOL	:= 0
		SC8->C8_ACCITEM	:= ""
		SC8->C8_ACCNUM	:= ""
		SC8->C8_CODED	:= ""
		SC8->C8_NUMPR	:= ""
		SC8->C8_RATFIN	:= ""
		SC8->C8_ZZMARCA	:= "INECOM   / TITAN"
		SC8->C8_ZZPRC2	:= 0
		SC8->C8_ZZCODCP	:= "71"
		SC8->C8_ZZDGRP	:= ""
		SC8->C8_ZZUPRC	:= 0
		SC8->C8_ZZOBS	:= ""
		SC8->C8_ZZGRUPO	:= "3115"
		SC8->C8_FSORIG	:= "W"
		SC8->C8_FSFINAL	:= ""
		SC8->C8_FSOBS	:= ""
		SC8->C8_IDAPROV	:= ""
		SC8->C8_APROVAD	:= ""
		SC8->C8_DTAPROV	:= CTOD("  /  /  ")
		SC8->C8_HORAAPR := ""
		SC8->C8_IDFLUIG	:= ""
		SC8->C8_FSHASH	:= c_Hash
		MsUnlock()

	Next nL

	Alert("Cotação gerada com sucesso!!!")

Return()
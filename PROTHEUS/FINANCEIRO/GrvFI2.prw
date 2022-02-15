User Function GrvFI2()

	/*
	±±³          ³    aItemsFI2[x][1]: Ocorrencia                             ³±±
	±±³          ³    aItemsFI2[x][2]: Titulo do campo (nao utilizado)        ³±±
	±±³          ³    aItemsFI2[x][3]: Valor anterior                         ³±±
	±±³          ³    aItemsFI2[x][4]: Novo valor                             ³±±
	±±³          ³    aItemsFI2[x][5]: Nome do campo                          ³±±
	±±³          ³    aItemsFI2[x][6]: Tipo do campo                          ³±±
	*/
	Private aItemsFI2	:= {{"02","","01","02","E1_SITUAC","C"}} //CarregaFI2(aCpos,aDados, lAbatim, lProtesto, lCancProt) //

	dbSelectArea("SE1")
	dbSetOrder(1)
	If dbSeek( "01BA0001" + "TST" +  "000031313" + "1  " + "NF " )
		Alert("Entrei")
		//Fa040AltOk({Space(10)}, {""},,.F., .F., .T.)
		//Fa040AltOk(,,.T.)
		F040GrvFI2()
	EndIf

Return()
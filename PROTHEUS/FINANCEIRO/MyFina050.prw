User Function MyFina050()

//WSMETHOD mtdInclusaoCP WSRECEIVE n_Opc, o_EmpFil, o_ParamTit, c_NumRet, c_PreRet WSSEND o_RetMtd WSSERVICE WS_FSCONTASPGAR

	Local a_Array 			:= {}
	Local d_Data			:= ""

	Local c_Banco			:= ""
	Local c_Agencia			:= ""
	Local c_Conta			:= ""

	Local c_Prefixo			:= ""
	Local c_Numero 			:= ""

	Local c_UserWS			:= ""
	Local c_PswWS			:= ""

	Local a_AuxSEV			:= {}
	Local a_Rateio			:= {}

	Local a_AuxSEZ			:= {}
	Local a_CCUSTO			:= {}
	Local cSvFilAnt	        := ""

	PRIVATE lMsErroAuto 	:= .F.

	//::o_RetMtd	:= WSCLASSNEW("strRetornMetodos")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Abertura do ambiente                                         |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RpcSetType(3)
	//RpcSetEnv(o_EmpFil:c_Empresa,o_EmpFil:c_Filial)
	RpcSetEnv("01","01")

	//if ::n_Opc == 3

		c_Prefixo	:= GetMV("FS_PRECP")
		c_Numero 	:= STRZERO( VAL( GetMV( "FS_NUMCP" ) ) + 1, 9 )

	/*else

		c_Prefixo	:= ::c_PreRet
		c_Numero 	:= ::c_NumRet

	endif*/

	PUTMV("FS_NUMCP", c_Numero)

	Begin Transaction

		//For nX:=1 To Len(o_ParamTit:c_NatRateio)

			a_AuxSEV	:= {}

			AADD( a_AuxSEV ,{"EV_NATUREZ"	, "2050108"		, Nil })//natureza a ser rateada
			AADD( a_AuxSEV ,{"EV_VALOR" 	, 1066.88		, Nil })//valor do rateio na natureza
			AADD( a_AuxSEV ,{"EV_PERC" 		, 1				, Nil })//percentual do rateio na natureza

			//IF Len(::o_ParamTit:c_NatRateio[nX]:c_CCustoRateio) > 0

				AADD( a_AuxSEV ,{"EV_RATEICC" 	, "1"										, Nil })//indicando que há rateio por centro de custo

				//For nY:=1 To Len(o_ParamTit:c_NatRateio[nX]:c_CCustoRateio)

					a_AuxSEZ	:= {}

					AADD( a_AuxSEZ ,{"EZ_CCUSTO"	, "206"	, Nil })//centro de custo da natureza
					AADD( a_AuxSEZ ,{"EZ_VALOR" 	, 723.34	, Nil })//valor do rateio neste centro de custo
					AADD( a_AuxSEZ ,{"EZ_PERC" 		, 67.80		, Nil })//valor do rateio neste centro de custo

					AADD( a_CCUSTO ,a_AuxSEZ )

					a_AuxSEZ	:= {}

					AADD( a_AuxSEZ ,{"EZ_CCUSTO"	, "503"	, Nil })//centro de custo da natureza
					AADD( a_AuxSEZ ,{"EZ_VALOR" 	, 343.54	, Nil })//valor do rateio neste centro de custo
					AADD( a_AuxSEZ ,{"EZ_PERC" 		, 32.20		, Nil })//valor do rateio neste centro de custo

					AADD( a_CCUSTO ,a_AuxSEZ )

				//Next

				AADD( a_AuxSEV ,{"AUTRATEICC"	, a_CCUSTO									, Nil })//percentual do rateio na natureza

				a_CCUSTO := {}

			/*ELSE

				AADD( a_AuxSEV ,{"EV_RATEICC" 	, "2"										, Nil })//indicando que há rateio por centro de custo

			ENDIF*/

			AADD( a_Rateio ,a_AuxSEV )

		//Next

		AADD( a_Array, { "E2_FILIAL"	, xfilial("SE2")  			,NIL })
		AADD( a_Array, { "E2_FORNECE"	, "000003"  	,NIL })
		AADD( a_Array, { "E2_LOJA"	 	, "00"  			,NIL })
		AADD( a_Array, { "E2_PREFIXO"	, "TST"					,NIL })
		AADD( a_Array, { "E2_NUM"	  	, "999999999"						,NIL })
		AADD( a_Array, { "E2_PARCELA"	, "A"						,NIL })
		AADD( a_Array, { "E2_TIPO"	 	, "FOL"			,NIL })
		AADD( a_Array, { "E2_EMISSAO" 	, CtoD("05/05/2017")								,NIL })
		AADD( a_Array, { "E2_MOEDA"  	, 1															,NIL })
		AADD( a_Array, { "E2_CC" 		, ""				,NIL })
		AADD( a_Array, { "E2_VENCTO" 	, CtoD("19/05/2017")								,NIL })
		AADD( a_Array, { "E2_VALOR"  	, 1066.88										,NIL })
		AADD( a_Array, { "E2_NATUREZ"	, "2050108"	,NIL })
		AADD( a_Array, { "E2_HIST"		, "TESTE"			,NIL })

		//IF Len(o_ParamTit:c_NatRateio) > 0

			AADD( a_Array, { "E2_MULTNAT" 	, '1'					,Nil })
			AADD( a_Array, { "AUTRATEEV"	, a_Rateio				,Nil })

		/*ELSE

			AADD( a_Array, { "E2_MULTNAT" 	, '2'					,Nil })

		ENDIF*/

		cSvFilAnt := cFilAnt
		cFilAnt   := "0401"

		MsExecAuto( { |x,y,z| FINA050(x,y,z)}, a_Array,, 3) // 3 - Inclusao, 4 - Alteração, 5 - Exclusão

		cFilAnt := cSvFilAnt

		If lMsErroAuto

			DisarmTransaction()
			//::o_RetMtd:l_Status		:= .F.
			//::o_RetMtd:c_Mensagem	:= MostraErro("\TOTVSBA_LOG\","Manutencao_Titulo.txt")
			MostraErro("\TOTVSBA_LOG\","Manutencao_Titulo.txt")

		Else

			//::o_RetMtd:l_Status		:= .T.
			//::o_RetMtd:c_Mensagem	:= c_Prefixo+"/"+c_Numero
			CONOUT( "MYFINA050:" + c_Prefixo+"/"+c_Numero )

		Endif

	End Transaction

RETURN(.T.)
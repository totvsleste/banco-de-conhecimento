/*/{Protheus.doc} FCOMM001
Programa responsavel por ajuste de impostos, TES e CFOP nas operacoes de entradas e saidas

@type function
@author francisco.ssa
@since 14/09/2016
@version 12.1.17

@return Nil, Nao esperado

@example
(examples)

@see (links_or_references)
/*/
User Function FCOMM001()

	Local c_Perg		:= "FCOMM001"
	Local c_Janela		:= "De/Para PIS/COFINS"
	Local c_Tit1		:= "Esta rotina tem a finalidade de ajustar os documentos de entrada e saída"
	Local c_Tit2		:= "conforme a parametrização feita no cadastro de DE/PARA de TES"
	Local c_Tit3		:= "Específico Eletrodata"

	Private o_Telas		:= clsTelasGen():New()


	f_ValidPerg( c_Perg )
	If !Pergunte(c_Perg,.T.)
		Return()
	EndIf

	IF o_Telas:mtdParOkCan(c_Janela, c_Tit1, c_Tit2, c_Tit3, c_Perg)


		IF AVISO(SM0->M0_NOMECOM,"Deseja realmente executar essa rotina?",{"Sim","Nao"},2,"Atencao") == 1

			LjMsgRun( "Aguarde... Processando registros....", "DE/PARA PIS/COFINS/TES", {|| f_AjustaBase() } )

		ENDIF

	ENDIF

Return()

/*/{Protheus.doc} f_AjustaBase
Funcao responsavel pela execucao dos ajustes nas tabelas SF1, SD1, SF2 e SD2

@type function
@author francisco.ssa
@since 14/09/2016
@version 11.80

@return Nil, Nao Esperado

@example
(examples)

@see (links_or_references)
/*/
Static Function f_AjustaBase()

	Local n_Aliq5	:= 7.60 //SUPERGETMV("FS_ALIQ5", .F., 7.60)
	Local n_Aliq6	:= 1.65 //SUPERGETMV("FS_ALIQ6", .F., 1.65)
	Local l_Log		:= .T.
	Local c_Chave	:= ""
	Local n_Base5	:= 0
	Local n_Base6	:= 0
	Local c_Estado	:= GETMV("MV_ESTADO")


	IF MV_PAR03 == 1

		BEGINSQL ALIAS "QRY"

			SELECT D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM, D1_TIPO,
			D1_TES, D1_CF, D1_GRUPO, F4_CODIGO, F4_CF, D1_BASIMP5, D1_BASIMP6,
			D1_TOTAL, D1_DESPESA, D1_VALFRE, D1_SEGURO ,D1_VALDESC, D1_ICMSRET, D1_ALQIMP5, D1_ALQIMP6, D1_VALIMP5, D1_VALIMP6,
			F1_BASIMP5, F1_BASIMP6, F1_VALIMP5, F1_VALIMP6, F1_VALBRUT, F1_VALIPI, F1_TIPO, F1_EST
			FROM %TABLE:SD1% SD1
			INNER JOIN %TABLE:SF1% SF1 ON (SF1.F1_FILIAL = SD1.D1_FILIAL AND SF1.F1_DOC = SD1.D1_DOC AND SF1.F1_SERIE = SD1.D1_SERIE
			AND SF1.F1_FORNECE = SD1.D1_FORNECE AND SF1.F1_LOJA = SD1.D1_LOJA AND SF1.%NOTDEL% )
			INNER JOIN %TABLE:SF4% SF4 ON (SF4.F4_CODIGO = %EXP:'015'% AND SF4.%NOTDEL%)
			WHERE SD1.%NOTDEL%
			AND SD1.D1_DTDIGIT BETWEEN %EXP:DTOS(MV_PAR01)% AND %EXP:DTOS(MV_PAR02)%
			AND SD1.D1_TES = %EXP:'001'%
			AND SD1.D1_CC IN (%EXP:'8339'%,%EXP:'8342'%,%EXP:'8350'%,%EXP:'8356'%)
			ORDER BY D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_TIPO

		ENDSQL

	ELSE

		BEGINSQL ALIAS "QRY"

			SELECT D2_EMISSAO, D2_TES, D2_ALQIMP5, D2_ALQIMP6, D2_VALIMP5, D2_VALIMP6, D2_BASIMP5, D2_BASIMP6,
			F2_BASIMP5, F2_BASIMP6, F2_VALIMP5, F2_VALIMP6, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, D2_COD, D2_ITEM,
			D2_VALBRUT, D2_VALIPI, F2_VALBRUT, F2_VALIPI
			FROM %TABLE:SD2% SD2
			INNER JOIN %TABLE:SF2% SF2 ON (SF2.F2_FILIAL = SD2.D2_FILIAL AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE
			AND SF2.F2_CLIENTE = SD2.D2_CLIENTE AND SF2.F2_LOJA = SD2.D2_LOJA AND SF2.%NOTDEL% )
			INNER JOIN %TABLE:SF4% SF4 ON(SF4.F4_CODIGO = %EXP:'506'% AND SF4.%NOTDEL%)
			WHERE SD2.%NOTDEL%
			AND SD2.D2_EMISSAO BETWEEN %EXP:DTOS(MV_PAR01)% AND %EXP:DTOS(MV_PAR02)%
			AND SD2.D2_CLIENTE = %EXP:'000672'% AND SD2.D2_LOJA = %EXP:'01'%
			ORDER BY D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA

		ENDSQL

	ENDIF

	DBSELECTAREA("QRY")
	QRY->(DBGOTOP())
	WHILE QRY->(!EOF())

		IF MV_PAR03 == 1

			IF l_Log
				l_Log	:= .F.
				c_Chave := QRY->D1_DOC + QRY->D1_SERIE + QRY->D1_FORNECE + QRY->D1_LOJA + QRY->D1_TIPO
			ENDIF

			DBSELECTAREA("SD1")
			DBSETORDER(1)
			IF DBSEEK(XFILIAL("SD1") + QRY->D1_DOC + QRY->D1_SERIE + QRY->D1_FORNECE + QRY->D1_LOJA + QRY->D1_COD + QRY->D1_ITEM, .T.)

				RECLOCK("SD1",.F.)
				SD1->D1_TES		:= "015"
				SD1->D1_CF		:= IIF( ALLTRIM( QRY->F1_EST ) == ALLTRIM( c_Estado ), "1" + SUBSTR( QRY->F4_CF, 2, 3 ), "2" + SUBSTR( QRY->F4_CF, 2, 3 ) )
				SD1->D1_BASIMP5	:= QRY->D1_TOTAL + QRY->D1_DESPESA + QRY->D1_VALFRE + QRY->D1_SEGURO - QRY->D1_VALDESC + QRY->D1_ICMSRET
				SD1->D1_BASIMP6	:= QRY->D1_TOTAL + QRY->D1_DESPESA + QRY->D1_VALFRE + QRY->D1_SEGURO - QRY->D1_VALDESC + QRY->D1_ICMSRET
				SD1->D1_ALQIMP5	:= n_Aliq5
				SD1->D1_ALQIMP6	:= n_Aliq6
				SD1->D1_VALIMP5	:= ROUND( SD1->D1_BASIMP5 * ( n_Aliq5 / 100 ), 2 )
				SD1->D1_VALIMP6	:= ROUND( SD1->D1_BASIMP6 * ( n_Aliq6 / 100 ), 2 )
				MSUNLOCK()
				n_Base5	+= SD1->D1_BASIMP5
				n_Base6	+= SD1->D1_BASIMP6

			ENDIF

		ELSE

			DBSELECTAREA("SD2")
			DBSETORDER(3)
			IF DBSEEK(XFILIAL("SD2") + QRY->D2_DOC + QRY->D2_SERIE + QRY->D2_CLIENTE + QRY->D2_LOJA + QRY->D2_COD + QRY->D2_ITEM, .T. )

				RECLOCK("SD2", .F.)
				SD2->D2_COD		:= "SERVICOS 3% TEL"
				SD2->D2_TES		:= "506"
				SD2->D2_BASIMP5	:= QRY->D2_VALBRUT - QRY->D2_VALIPI
				SD2->D2_BASIMP6	:= QRY->D2_VALBRUT - QRY->D2_VALIPI
				SD2->D2_ALQIMP5	:= n_Aliq5
				SD2->D2_ALQIMP6	:= n_Aliq6
				SD2->D2_VALIMP5	:= ROUND( SD2->D2_BASIMP5 * ( n_Aliq5 / 100 ), 2 )
				SD2->D2_VALIMP6	:= ROUND( SD2->D2_BASIMP6 * ( n_Aliq6 / 100 ), 2 )
				MSUNLOCK()

			ENDIF

			DBSELECTAREA("SF2")
			DBSETORDER(1)
			IF DBSEEK(XFILIAL("SF2") + QRY->D2_DOC + QRY->D2_SERIE + QRY->D2_CLIENTE + QRY->D2_LOJA, .T. )

				RECLOCK("SF2", .F.)
				SF2->F2_BASIMP5	:= QRY->F2_VALBRUT - QRY->F2_VALIPI
				SF2->F2_BASIMP6	:= QRY->F2_VALBRUT - QRY->F2_VALIPI
				SF2->F2_VALIMP5	:= ROUND( SF2->F2_BASIMP5 * (n_Aliq5 / 100 ), 2 )
				SF2->F2_VALIMP6	:= ROUND( SF2->F2_BASIMP6 * (n_Aliq6 / 100 ), 2 )
				MSUNLOCK()

			ENDIF

		ENDIF

		QRY->(DBSKIP())

		IF MV_PAR03 == 1

			IF c_Chave <> QRY->D1_DOC + QRY->D1_SERIE + QRY->D1_FORNECE + QRY->D1_LOJA + QRY->D1_TIPO

				DBSELECTAREA("SF1")
				DBSETORDER(1)
				IF DBSEEK(XFILIAL("SF1") + c_Chave, .T.)

					RECLOCK("SF1", .F.)
					SF1->F1_BASIMP5	:= n_Base5
					SF1->F1_BASIMP6	:= n_Base6
					SF1->F1_VALIMP5	:= ROUND( SF1->F1_BASIMP5 * (n_Aliq5 / 100 ), 2 )
					SF1->F1_VALIMP6 := ROUND( SF1->F1_BASIMP6 * (n_Aliq6 / 100 ), 2 )
					MSUNLOCK()

				ENDIF

				c_Chave := QRY->D1_DOC + QRY->D1_SERIE + QRY->D1_FORNECE + QRY->D1_LOJA + QRY->D1_TIPO
				n_Base5	:= 0
				n_Base6	:= 0

			ENDIF

		ENDIF

	ENDDO
	QRY->(DBCLOSEAREA())

Return()

/*/{Protheus.doc} f_ValidPerg
Funcao responsavel por gerar as perguntas (parametros)

@type function
@author francisco.ssa
@since 14/09/2016
@version 11.80

@param cPerg, character, Codigo do grupo de perguntas
@return Nil, Nao esperado

@example
(examples)

@see (links_or_references)
/*/
Static Function f_ValidPerg( c_Perg )

	Local o_PutSX1		:= clsComponentes():New()

	//o_PutSX1:mtdPutSX1( X1_GRUPO, X1_ORDEM, X1_PERGUNT, X1_PERSPA, X1_PERENG, X1_VARIAVL, X1_TIPO, X1_TAMANHO, X1_DECIMAL, X1_PRESEL, X1_GSC, X1_VALID, X1_VAR01, X1_DEF01, X1_DEFSPA1, X1_DEFENG1, X1_CNT01, X1_VAR02, X1_DEF02, X1_DEFSPA2, X1_DEFENG2, X1_CNT02, X1_VAR03, X1_DEF03, X1_DEFSPA3, X1_DEFENG3, X1_CNT03, X1_VAR04, X1_DEF04, X1_DEFSPA4, X1_DEFENG4, X1_CNT04, X1_VAR05, X1_DEF05, X1_DEFSPA5, X1_DEFENG5, X1_CNT05, X1_F3, X1_PYME, X1_GRPSXG, X1_HELP, X1_PICTURE, X1_IDFIL )
	o_PutSX1:mtdPutSX1( c_Perg, "01", "Data de?      ", "", "", "mv_ch0", "D", 08, 0, 0, "G", "", "MV_PAR01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" )
	o_PutSX1:mtdPutSX1( c_Perg, "02", "Data ate?     ", "", "", "mv_ch1", "D", 08, 0, 0, "G", "", "MV_PAR02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" )
	o_PutSX1:mtdPutSX1( c_Perg, "03", "Tipo?         ", "", "", "mv_ch2", "N", 01, 0, 2, "C", "", "MV_PAR03", "Entrada", "", "", "", "", "Saida", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" )

Return()

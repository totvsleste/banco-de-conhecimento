User Function ROM003()

	Local aArea			:= GetArea()
	Local cMarca		:= o_Mark:Mark()
	Local nCt			:= 0

	Local o_Model  		:= FwModelActive()
	Local o_SZ1Model 	:= o_Model:GetModel('SZ1GRID')
	Local o_SZ2Model 	:= o_Model:GetModel('SZ2GRID')
	Local o_SZ3Model 	:= o_Model:GetModel('SZ3GRID')
	Local nX			:= 1

	Local aFields 		:= {}

	//--------------------------
	//Monta os campos da tabela
	//--------------------------
	aadd( aFields,{"COD","C",15,0} )
	aadd( aFields,{"QUANT","N",9,2} )

	oTemptable:SetFields( aFields )
	oTempTable:AddIndex("indice1", {"COD"} )
	oTempTable:Create()

	SF2->( DBGOTOP() )
	While !SF2->( EOF() )
		If o_Mark:IsMark(cMarca)

			If !Empty( o_SZ1Model:GetValue( 'Z1_NF' ) )

				o_SZ1Model:AddLine()

			EndIf

			o_SZ1Model:SetValue( 'Z1_NF', SF2->F2_DOC )
			o_SZ1Model:SetValue( 'Z1_SERIE', SF2->F2_SERIE )
			o_SZ1Model:SetValue( 'Z1_VALOR', SF2->F2_VALBRUT )

			DBSELECTAREA("SD2")
			DBSETORDER(3)
			DBSEEK( XFILIAL("SD2") + SF2->F2_DOC + SF2->F2_SERIE )
			while SD2->(!EOF()) .AND. SD2->D2_FILIAL + SD2->D2_DOC + SD2->D2_SERIE == XFILIAL("SD2") + SF2->F2_DOC + SF2->F2_SERIE

				if !Empty( o_SZ2Model:GetValue( 'Z2_COD' ) )

					o_SZ2Model:AddLine()

				endif

				o_SZ2Model:SetValue( 'Z2_ITEM', SD2->D2_ITEM )
				o_SZ2Model:SetValue( 'Z2_NF', SF2->F2_DOC )
				o_SZ2Model:SetValue( 'Z2_SERIE', SF2->F2_SERIE )
				o_SZ2Model:SetValue( 'Z2_COD', SD2->D2_COD )
				o_SZ2Model:SetValue( 'Z2_QUANT', SD2->D2_QUANT )
				o_SZ2Model:SetValue( 'Z2_VLRUNIT', SD2->D2_PRCVEN )
				o_SZ2Model:SetValue( 'Z2_TOTAL', SD2->D2_TOTAL )

				DBSELECTAREA("TMP")
				DBSETORDER(1)
				if DBSEEK( SD2->D2_COD, .T. )

					Alert("Achei")
					RECLOCK("TMP",.F.)
					TMP->QUANT	+= SD2->D2_QUANT
					MSUNLOCK()

				else

					Alert("Nao Achei")
					RECLOCK("TMP",.T.)
					TMP->COD	:= SD2->D2_COD
					TMP->QUANT	:= SD2->D2_QUANT
					MSUNLOCK()

				endif

				SD2->(DBSKIP())

			enddo

		endif

		SF2->( dbSkip() )

	enddo

	dbSelectArea("TMP")
	TMP->(dbGoTop())
	Alert("registros " +Alltrim(Str(TMP->(RecCount()))))
	while TMP->(!EOF())

		If !Empty( o_SZ3Model:GetValue( 'Z3_COD' ) )

			o_SZ3Model:AddLine()

		endif

		o_SZ3Model:SetValue( 'Z3_COD', TMP->COD )
		o_SZ3Model:SetValue( 'Z3_QUANT', TMP->QUANT )

		TMP->(dbSkip())

	enddo

	o_SZ1Model:GoLine(1)
	o_SZ2Model:GoLine(1)
	o_SZ3Model:GoLine(1)

	MsgInfo( "Rotina executada com sucesso!!!", "Gestão de Serviços" )

Return()
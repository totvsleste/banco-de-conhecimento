User Function FTECA006()

	Local aArea			:= GetArea()
	Local cMarca		:= o_Mark:Mark()
	Local nCt			:= 0

	Local o_Model  		:= FwModelActive()
	Local o_ModelTFL 	:= o_Model:GetModel('TFL_LOC')
	Local nX			:= 1

	ABS->( DBGOTOP() )
	while !ABS->( EOF() )

		if !EMPTY( ABS->ABS_LOCPAI )

			//Filtro do Local de Atendimento
			if ABS->ABS_LOCAL >= MV_PAR01 .AND. ABS->ABS_LOCAL <= MV_PAR02

				//Filtro por Centro de Custo
				if ABS->ABS_CCUSTO >= MV_PAR03 .AND. ABS->ABS_CCUSTO <= MV_PAR04

					//Filtro do Local de Atendimento Pai
					if ABS->ABS_LOCPAI >= MV_PAR05 .AND. ABS->ABS_LOCPAI <= MV_PAR06

						//Pega somente os registros marcados
						if o_Mark:IsMark(cMarca)

							For nX := 1 To o_ModelTFL:Length() Step 1

								o_ModelTFL:GoLine(nX)

								//Se encontrar um Local de Atendimento existente apenas atualiza os dados
								if o_ModelTFL:GetValue( 'TFL_LOCAL' ) == ABS->ABS_LOCAL

									//o_ModelTFL:DeleteLine()
									o_ModelTFL:SetValue( 'TFL_LOCAL', ABS->ABS_LOCAL )
									o_ModelTFL:SetValue( 'TFL_DTINI', MV_PAR06 )
									o_ModelTFL:SetValue( 'TFL_DTFIM', MV_PAR07 )

									ABS->( dbSkip() )
									Loop

								endif

							Next nX

							If !Empty( o_ModelTFL:GetValue( 'TFL_LOCAL' ) )

								o_ModelTFL:AddLine()

							EndIf

							o_ModelTFL:SetValue( 'TFL_LOCAL', ABS->ABS_LOCAL )
							o_ModelTFL:SetValue( 'TFL_DTINI', MV_PAR06 )
							o_ModelTFL:SetValue( 'TFL_DTFIM', MV_PAR07 )

						endif

					endif

				endif

			endif

		endif

		ABS->( dbSkip() )

	enddo
	o_ModelTFL:GoLine(1)

	MsgInfo( "Rotina executada com sucesso!!!", "Gestão de Serviços" )

Return()e
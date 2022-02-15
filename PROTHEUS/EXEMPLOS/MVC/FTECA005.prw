#INCLUDE 'FWMVCDEF.CH'

User Function FTECA005()

	Local c_Perg	:= "FTECA001"

	Private aRotina	:= MenuDef()

	//ABSMASTER
	Private o_Mark
	Private c_Filter	:= ""

	f_ValidPerg( c_Perg )
	If !Pergunte( c_Perg, .T. )

		If Select("TRA") <> 0
			TRA->(dbCloseArea())
		EndIf
		Return()

	EndIf

	c_Filter	+= " ABS_LOCPAI <> '' "
	c_Filter	+= " .AND. ABS_LOCAL >= '" + MV_PAR01 + "' .AND. ABS_LOCAL <= '" + MV_PAR02 + "'"
	c_Filter	+= " .AND. ABS_CCUSTO >= '" + MV_PAR03 + "' .AND. ABS_CCUSTO <= '" + MV_PAR04 + "'"
	c_Filter	+= " .AND. ABS_LOCPAI >= '" + MV_PAR05 + "' .AND. ABS_LOCPAI <= '" + MV_PAR06 + "'"

	o_Mark := FWMarkBrowse():New()
	o_Mark:SetAlias('ABS')
	o_Mark:SetDescription('Locais de Atendimento')
	o_Mark:SetFieldMark( 'ABS_OK' )
	//o_Mark:AddLegend( "ALLTRIM(ZB2_SITUAC)=='1'", "BR_VERDE"		, "Ativa" )
	//o_Mark:AddLegend( "ALLTRIM(ZB2_SITUAC)=='2'", "BR_AMARELO"	, "Trancado" )
	o_Mark:SetFilterDefault( c_Filter )
	o_Mark:Activate()

Return

//-------------------------------------------------------------------
Static Function MenuDef()

	Local a_Rotina := {}
	ADD OPTION a_Rotina TITLE 'Visualizar' ACTION 'VIEWDEF.TECA160' OPERATION 2 ACCESS 0
	ADD OPTION a_Rotina TITLE 'Processar' ACTION 'U_FTECA006()' OPERATION 2 ACCESS 0

Return a_Rotina

Static Function ModelDef()

Return FWLoadModel( 'ABSMASTER' )

Static Function ViewDef()

Return FWLoadView( 'ABSMASTER' )

Static Function f_ValidPerg( c_Perg )

	Local o_PutSX1		:= clsComponentes():New()

	//o_PutSX1:mtdPutSX1( X1_GRUPO, X1_ORDEM, X1_PERGUNT, X1_PERSPA, X1_PERENG, X1_VARIAVL, X1_TIPO, X1_TAMANHO, X1_DECIMAL, X1_PRESEL, X1_GSC, X1_VALID, X1_VAR01, X1_DEF01, X1_DEFSPA1, X1_DEFENG1, X1_CNT01, X1_VAR02, X1_DEF02, X1_DEFSPA2, X1_DEFENG2, X1_CNT02, X1_VAR03, X1_DEF03, X1_DEFSPA3, X1_DEFENG3, X1_CNT03, X1_VAR04, X1_DEF04, X1_DEFSPA4, X1_DEFENG4, X1_CNT04, X1_VAR05, X1_DEF05, X1_DEFSPA5, X1_DEFENG5, X1_CNT05, X1_F3, X1_PYME, X1_GRPSXG, X1_HELP, X1_PICTURE, X1_IDFIL )
	o_PutSX1:mtdPutSX1( c_Perg, "01", "Local Atendimento de?      ", "", "", "mv_ch0", "C", 08, 0, 0, "G", "", "MV_PAR01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "ABS", "", "", "", "", "" )
	o_PutSX1:mtdPutSX1( c_Perg, "02", "Local Atendimento ate?     ", "", "", "mv_ch1", "C", 08, 0, 0, "G", "", "MV_PAR02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "ABS", "", "", "", "", "" )
	o_PutSX1:mtdPutSX1( c_Perg, "03", "Centro de Custo de?        ", "", "", "mv_ch2", "C", 09, 0, 0, "G", "", "MV_PAR03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "CTT", "", "", "", "", "" )
	o_PutSX1:mtdPutSX1( c_Perg, "04", "Centro de Custo ate?       ", "", "", "mv_ch3", "C", 09, 0, 0, "G", "", "MV_PAR04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "CTT", "", "", "", "", "" )
	o_PutSX1:mtdPutSX1( c_Perg, "05", "Local Atendimento Pai de?  ", "", "", "mv_ch4", "C", 08, 0, 0, "G", "", "MV_PAR05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "ABS", "", "", "", "", "" )
	o_PutSX1:mtdPutSX1( c_Perg, "06", "Local Atendimento Pai ate? ", "", "", "mv_ch5", "C", 08, 0, 0, "G", "", "MV_PAR06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "ABS", "", "", "", "", "" )
	o_PutSX1:mtdPutSX1( c_Perg, "07", "Periodo Inicia?            ", "", "", "mv_ch6", "D", 08, 0, 0, "G", "", "MV_PAR07", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" )
	o_PutSX1:mtdPutSX1( c_Perg, "08", "Periodo Final?             ", "", "", "mv_ch7", "D", 08, 0, 0, "G", "", "MV_PAR08", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" )

Return()
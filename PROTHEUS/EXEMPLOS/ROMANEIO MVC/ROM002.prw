#INCLUDE 'FWMVCDEF.CH'

User Function ROM002()

	Private aRotina	:= MenuDef()
	Private o_Mark
	Private c_Filter	:= ""
	Private oTempTable 	:= FWTemporaryTable():New( "TMP" )

	o_Mark := FWMarkBrowse():New()
	o_Mark:SetAlias('SF2')
	o_Mark:SetDescription('Notas Fiscais de Saída')
	o_Mark:SetFieldMark( 'F2_OK' )
	o_Mark:Activate()

	oTempTable:Delete()

Return

//-------------------------------------------------------------------
Static Function MenuDef()

	Local a_Rotina := {}
	ADD OPTION a_Rotina TITLE 'Visualizar' ACTION 'VIEWDEF.ROM004' OPERATION 2 ACCESS 0
	ADD OPTION a_Rotina TITLE 'Processar' ACTION 'U_ROM003()' OPERATION 2 ACCESS 0

Return a_Rotina

//-----------------------------------------------------------
Static Function ModelDef()

Return FWLoadModel( 'SF2MASTER' )

//-----------------------------------------------------------
Static Function ViewDef()

Return FWLoadView( 'SF2MASTER' )
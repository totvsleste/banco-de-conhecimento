#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function TST2GRI()

	Local oBrowse	:= Nil

	oBrowse	:= FWmBrowse():New()
	oBrowse:SetAlias("SA2")
	oBrowse:Activate()

Return Nil

Static Function MenuDef()

	Local a_Rotina	:= {}

	ADD OPTION a_Rotina TITLE '&Visualizar' ACTION 'VIEWDEF.TST2GRI' OPERATION 2 ACCESS 0
	ADD OPTION a_Rotina TITLE '&Incluir'    ACTION 'VIEWDEF.TST2GRI' OPERATION 3 ACCESS 0
	ADD OPTION a_Rotina TITLE '&Alterar'    ACTION 'VIEWDEF.TST2GRI' OPERATION 4 ACCESS 0
	ADD OPTION a_Rotina TITLE '&Excluir'    ACTION 'VIEWDEF.TST2GRI' OPERATION 5 ACCESS 0

Return a_Rotina

Static Function ModelDef()

	Local oModel	:= MPFormModel():New('TS2GRIM')
	Local oStruSA2	:= FWFormStruct( 1, 'SA2' )
	Local oStruSF1	:= FWFormStruct( 1, 'SF1' )
	Local oStruSD1	:= FWFormStruct( 1, 'SD1' )

	oModel:AddFields('SA2MASTER',/*cOwner*/,oStruSA2)
	oModel:AddGrid('SF1GRID','SA2MASTER',oStruSF1,/*bLinePre*/,/*bLinePost*/,/*bPre*/,/*bPos*/,/*bLoad*/)
	oModel:AddGrid('SD1GRID','SF1GRID',oStruSD1,/*bLinePre*/,/*bLinePost*/,/*bPre*/,/*bPos*/,/*bLoad*/)
	oModel:SetRelation('SF1GRID',{ { 'F1_FILIAL', 'XFILIAL("SF1")' }, { 'F1_FORNECE', 'A2_COD' }, { 'F1_LOJA', 'A2_LOJA' } }, SF1->( IndexKey( 1 ) ) )
	oModel:SetRelation('SD1GRID',{ { 'D1_FILIAL', 'XFILIAL("SD1")' }, { 'D1_DOC', 'F1_DOC' }, { 'D1_SERIE', 'F1_SERIE' }, { 'D1_FORNECE', 'A2_COD' }, { 'D1_LOJA', 'A2_LOJA' } }, SD1->( IndexKey( 1 ) ) )
	//oModel:GetModel('SF1GRID'):SetUniqueLine({'SF1_AUTOR'})
	oModel:GetModel('SA2MASTER'):SetDescription('Fornecedor')
	oModel:GetModel('SF1GRID'):SetDescription('Cabecalho')
	oModel:GetModel('SD1GRID'):SetDescription('Itens')

Return oModel

Static Function ViewDef()

	Local oView		:= FWFormView():New()
	//Local oStruSA2	:= FWFormStruct( 2, 'SA2' )
	Local oStruSF1	:= FWFormStruct( 2, 'SF1' )
	Local oStruSD1	:= FWFormStruct( 2, 'SD1' )
	Local oModel	:= FWLoadModel('TST2GRI')

	oView:SetModel(oModel)
	//oView:AddField('SA2_VIEW',oStruSA2,'SA2MASTER')
	oView:AddGrid('SF1_VIEW',oStruSF1,'SF1GRID')
	oView:AddGrid('SD1_VIEW',oStruSD1,'SD1GRID')

	//oView:CreateHorizontalBox('CABEC',20)
	oView:CreateHorizontalBox('GRID1',50)
	oView:CreateHorizontalBox('GRID2',50)

	//oView:SetOwnerView('SA2_VIEW','CABEC')
	oView:SetOwnerView('SF1_VIEW','GRID1')
	oView:SetOwnerView('SD1_VIEW','GRID2')

	//oView:AddIncrementField('SF1_VIEW','SF1_ITEM')

	//oView:EnableTitleView('SA2_VIEW','Fornecedores')
	oView:EnableTitleView('SF1_VIEW','Cabecalho de Nota')
	oView:EnableTitleView('SD1_VIEW','Itens de Nota')

Return oView

Static Function f_TDP002POS( oModel )

	Local l_Ret		:= .T.
	Local n_Opca	:= oModel:GetOperation()	//Retorna a Opcao
	Local n_Linha	:= oModel:GetLine()			//Retorna o numero da linhas posicionado
	Local a_SaveLin	:= FWSaveRows()				//Salva a posicao do cursor na linha de cada grid ativo no oModel
	Local n_QtdLin	:= oModel:Length()			//Retorna a quantidade de linhas no grid

	If n_Opca == MODEL_OPERATION_INSERT .OR. n_Opca == MODEL_OPERATION_UPDATE
		//oModel:IsDeleted()	//Verifica se a linha foi deletada
		//oModel:IsUpdated()	//Verifica se a linha foi atualizada
		//oModel:IsInserted()	//Verifica se a linha e nova
		//oModel:GoLine(nLinha)	//Vai para linha

		//oModel:SetValue('SF1_AUTOR','000002')	//Adiciona valor no campo informado na linha posicionada
		//oModel:GetValue('SF1_AUTOR')	//Retorna o conteudo do campo informado na linha posicionada

		IF oModel:GetValue("SF1_AUTOR") == '000001'
			Help("123",1,'VALDAUTOR',,"Data Maior ou Igual a data atual. Informe uma data anterior valida",1,0)
			l_Ret := .F.
		ENDIF

	ENDIF

	FWRestRows(a_SaveLin)

Return l_Ret

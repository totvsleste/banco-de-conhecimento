#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function TDPA005()
	
	Local oBrowse	:= Nil
	
	oBrowse	:= FWmBrowse():New()
	oBrowse:SetAlias("ZA3")
	oBrowse:Activate()
	
Return Nil

Static Function MenuDef()
	
	Local a_Rotina	:= {}
	
	ADD OPTION a_Rotina TITLE '&Visualizar' ACTION 'VIEWDEF.TDPA005' OPERATION 2 ACCESS 0
	ADD OPTION a_Rotina TITLE '&Incluir'    ACTION 'VIEWDEF.TDPA005' OPERATION 3 ACCESS 0
	ADD OPTION a_Rotina TITLE '&Alterar'    ACTION 'VIEWDEF.TDPA005' OPERATION 4 ACCESS 0
	ADD OPTION a_Rotina TITLE '&Excluir'    ACTION 'VIEWDEF.TDPA005' OPERATION 5 ACCESS 0
	ADD OPTION a_Rotina TITLE 'Im&primir'   ACTION 'VIEWDEF.TDPA005' OPERATION 8 ACCESS 0
	ADD OPTION a_Rotina TITLE '&Copiar'     ACTION 'VIEWDEF.TDPA005' OPERATION 9 ACCESS 0
	
Return a_Rotina

Static Function ModelDef()
	
	Local oModel	:= MPFormModel():New('TDPA005M')
	Local oStruZA3	:= FWFormStruct( 1, 'ZA3' )
	Local oStruZA4	:= FWFormStruct( 1, 'ZA4' )
	Local oStruZA5	:= FWFormStruct( 1, 'ZA5' )
	
	oModel:AddFields('ZA3CABEC',/*cOwner*/,oStruZA3)
	
	oModel:AddGrid('ZA4GRID','ZA3CABEC',oStruZA4,/*bLinePre*/,/*bLinePost*/ /*{|oModel| f_TDP002POS( oModel ) }*/,/*bPre*/,/*bPos*/,/*bLoad*/)
	oModel:SetRelation('ZA4GRID',{ { 'ZA4_FILIAL', 'XFILIAL("ZA4")' }, { 'ZA4_ALBUM', 'ZA3_ALBUM' } }, ZA4->( IndexKey( 1 ) ) )
	
	oModel:AddGrid('ZA5GRID','ZA4GRID',oStruZA5,/*bLinePre*/,/*bLinePost*/ ,/*bPre*/,/*bPos*/,/*bLoad*/)
	oModel:SetRelation('ZA5GRID',{ { 'ZA5_FILIAL', 'XFILIAL("ZA5")' }, { 'ZA5_ALBUM', 'ZA4_ALBUM' }, { 'ZA5_MUSICA', 'ZA4_MUSICA' } }, ZA5->( IndexKey( 1 ) ) )
	
	oModel:GetModel('ZA4GRID'):SetUniqueLine({'ZA4_MUSICA'})
	
	oModel:GetModel('ZA3CABEC'):SetDescription('ALBUM')
	oModel:GetModel('ZA4GRID'):SetDescription('MUSICA')
	oModel:GetModel('ZA5GRID'):SetDescription('AUTORINTERPRETE')
	
	//oStruZA4:RemoveField('ZA4_ALBUM')
	
Return oModel

Static Function ViewDef()
	
	Local oView		:= FWFormView():New()
	Local oStruZA3	:= FWFormStruct( 2, 'ZA3' )
	Local oStruZA4	:= FWFormStruct( 2, 'ZA4' )
	Local oStruZA5	:= FWFormStruct( 2, 'ZA5' )
	Local oModel	:= FWLoadModel('TDPA005')
	
	oView:SetModel(oModel)
	oView:AddField('ZA3_VIEW',oStruZA3,'ZA3CABEC')
	oView:AddGrid('ZA4_VIEW',oStruZA4,'ZA4GRID')
	oView:AddGrid('ZA5_VIEW',oStruZA5,'ZA5GRID')
	
	//oStruZA4:RemoveField('ZA4_ALBUM')
	
	oView:CreateHorizontalBox('CABEC',20)
	oView:CreateHorizontalBox('GRID1',40)
	oView:CreateHorizontalBox('GRID2',40)
	
	oView:SetOwnerView('ZA3_VIEW','CABEC')
	oView:SetOwnerView('ZA4_VIEW','GRID1')
	oView:SetOwnerView('ZA5_VIEW','GRID2')
	
	oView:AddIncrementField('ZA4_VIEW','ZA4_ITEM')
	
	oView:EnableTitleView('ZA3_VIEW','ALBUM')
	oView:EnableTitleView('ZA4_VIEW','MUSICAS DO ALBUM')
	oView:EnableTitleView('ZA5_VIEW','AUTOR/INTERPRETE')
	
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

		//oModel:SetValue('ZA4_AUTOR','000002')	//Adiciona valor no campo informado na linha posicionada
		//oModel:GetValue('ZA4_AUTOR')	//Retorna o conteudo do campo informado na linha posicionada

		IF oModel:GetValue("ZA4_AUTOR") == '000001'
			Help("123",1,'VALDAUTOR',,"Data Maior ou Igual a data atual. Informe uma data anterior valida",1,0)
			l_Ret := .F.	
		ENDIF

	ENDIF
	
	FWRestRows(a_SaveLin)
	
Return l_Ret

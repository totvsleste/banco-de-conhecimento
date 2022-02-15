#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function TDPA006()
	
	Local oBrowse	:= Nil
	
	oBrowse	:= FWmBrowse():New()
	oBrowse:SetAlias("ZA1")
	oBrowse:Activate()
	
Return Nil

Static Function MenuDef()
	
	Local a_Rotina	:= {}
	
	ADD OPTION a_Rotina TITLE '&Visualizar'	ACTION 'VIEWDEF.TDPA006' OPERATION 1 ACCESS 0
	ADD OPTION a_Rotina TITLE '&Incluir'    	ACTION 'VIEWDEF.TDPA006' OPERATION 3 ACCESS 0
	ADD OPTION a_Rotina TITLE '&Alterar'    	ACTION 'VIEWDEF.TDPA006' OPERATION 4 ACCESS 0
	ADD OPTION a_Rotina TITLE '&Excluir'    	ACTION 'VIEWDEF.TDPA006' OPERATION 5 ACCESS 0
	ADD OPTION a_Rotina TITLE 'Im&primir'   	ACTION 'VIEWDEF.TDPA006' OPERATION 8 ACCESS 0
	ADD OPTION a_Rotina TITLE '&Copiar'     	ACTION 'VIEWDEF.TDPA006' OPERATION 9 ACCESS 0
	
Return a_Rotina

Static Function ModelDef()
	
	Local oModel	:= MPFormModel():New('TDPA006M',/*bPre*/,/*bPos*/,/*bCommit*/{|oModel| F_TDP006GRV(oModel) },/*bCancel*/)
	Local oStruZA1	:= FWFormStruct( 1, 'ZA1' )
	Local oStruZA2	:= FWFormStruct( 1, 'ZA2' )
	
	oStruZA1:AddField(;
		"Valor %",;		//VALOR %;
		"Valor %",;		//VALOR %;
		"VLRPERC",;		//ID DO FIELD;
		"N",;			//TIPO DO CAMPO;
		5,;				//TAMANHO DO CAMPO;
		2,;				//TAMANHO DECIMAL DO CAMPO;
		{|| .T.},;		//CODE BLOCK DE VALIDACAO DO CAMPO;
		,;				//COD BLOCK DE VALIDACAO WHEN DO CAMPO;
		,;				//LISTA DE VALORES PERMITIDO DO CAMPO;
		.F.)			//INDICA SE O CAMPO TEM PREENCHIMENTO OBRIGATORIO;
		
	oModel:AddFields('ZA1MASTER',/*cOwner*/,oStruZA1,/*bPre*/,/*bPos*/,/*bLoad*/ /*{|oModel| F_TDPALFORM(oModel) }*/ )
	oModel:GetModel('ZA1MASTER'):SetLoad({|oModel| F_TDPALFORM(oModel) })
	oModel:AddGrid('ZA2GRID','ZA1MASTER',oStruZA2,/*bLinePre*/,/*bLinePost*/ {|oModel| f_TDP006POS( oModel ) },/*bPre*/,/*bPos*/,/*bLoad*/ /*{|oModel| F_TDPALGRID(oModel) }*/ )
	oModel:SetRelation('ZA2GRID',{ { 'ZA2_FILIAL', 'XFILIAL("ZA2")' }, { 'ZA2_MUSICA', 'ZA1_MUSICA' } }, ZA2->( IndexKey( 1 ) ) )
	oModel:GetModel('ZA2GRID'):SetUniqueLine({'ZA2_AUTOR'})
	oModel:GetModel('ZA1MASTER'):SetDescription('Musica')
	oModel:GetModel('ZA2GRID'):SetDescription('Autor/Interprete')
	
Return oModel

Static Function ViewDef()
	
	Local oView		:= FWFormView():New()
	Local oStruZA1	:= FWFormStruct( 2, 'ZA1' )
	Local oStruZA2	:= FWFormStruct( 2, 'ZA2' )
	Local oModel	:= FWLoadModel('TDPA006')
	
	oStruZA1:AddField(;
		'VLRPERC',;		//Campo;
		'ZZ',;			//Ordem;
		'Valor %',;		//Titulo;
		'Valor %',;		//Descricao;
		,;				//Hellp;
		'G',;			//Tipo do Campo COMBO, GET, CHECK;
		'@!',;			//Picture;
		,;				//PictVar;
		Nil)		//F3;
		
	
	oView:SetModel(oModel)
	oView:AddField('ZA1_VIEW',oStruZA1,'ZA1MASTER')
	oView:AddGrid('ZA2_VIEW',oStruZA2,'ZA2GRID')
	
	oView:CreateHorizontalBox('CABEC',30)
	oView:CreateHorizontalBox('GRID',70)
	
	oView:SetOwnerView('ZA1_VIEW','CABEC')
	oView:SetOwnerView('ZA2_VIEW','GRID')
	
	oView:AddIncrementField('ZA2_VIEW','ZA2_ITEM')
	
	oView:EnableTitleView('ZA1_VIEW','MUSICAS')
	oView:EnableTitleView('ZA2_VIEW','AUTOR/INTERPRETE')
	
Return oView

Static Function f_TDP006POS( oModel )
	
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
		
		//oModel:SetValue('ZA2_AUTOR','000002')	//Adiciona valor no campo informado na linha posicionada
		//oModel:GetValue('ZA2_AUTOR')	//Retorna o conteudo do campo informado na linha posicionada
		
		IF oModel:GetValue("ZA2_AUTOR") == '000001'
			Help("123",1,'VALDAUTOR',,"Data Maior ou Igual a data atual. Informe uma data anterior valida",1,0)
			l_Ret := .F.
		ENDIF
		
	ENDIF
	
	FWRestRows(a_SaveLin)
	
Return l_Ret

Static Function F_TDPALFORM(oModel)
	
	Local aRetVal	:= {}
	Local aFilCpos	:= {}
	
	AADD(aFilCpos, FWxFilial("ZA1"))
	AADD(aFilCpos, GETSXENUM("ZA1","ZA1_MUSICA"))
	AADD(aFilCpos, "Musica inserida manualmente")
	AADD(aFilCpos, DDATABASE)
	AADD(aFilCpos, '')
	AADD(aFilCpos, 9,99)
	
	aRetVal	:= {aFilCpos,0}
	
Return(aRetVal)

Static Function F_TDPALGRID(oModel)
	
	Local aRetVal	:= {}
	Local aFilCpos	:= {}
	Local cFilZA2	:= FWxFilial("ZA2")
	
	AADD(aRetVal,{0,{cFilZA2,;
		oModel:GetModel("ZA1MASTER"):GetValue("ZA1MASTER","ZA1_MUSICA"),;
		'0001',;
		'000001',;
		'',;
		'1'}})
	
Return aRetVal


Static Function F_TDP006GRV(oModel)
	
	Local l_Ret		:= .T.
	l_Ret	:= FWFormCommit(oModel)	//Funcao responsavel pela gravacao automatica do MVC
	
Return l_Ret

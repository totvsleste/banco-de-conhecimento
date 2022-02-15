#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

/*/{Protheus.doc} EXERC04
Programa responsavel pela manutencao de Turmas x Alunos x Disciplinas (Notas)

@author francisco.ssa
@since 03/06/2014
@version 1.0

@return Nil, Nao Esperado

@example
(examples)

@see (links_or_references)
/*/
User Function EXERC04()

	Local oBrowse	:= Nil

	oBrowse	:= FWmBrowse():New()
	oBrowse:SetAlias("ZB5")
	oBrowse:Activate()

Return Nil

/*/{Protheus.doc} MenuDef
Funcao responsavel por manutencao do menu de opcoes

@author francisco.ssa
@since 03/06/2014
@version 1.0

@return Array, Opcoes do menu

@example
(examples)

@see (links_or_references)
/*/
Static Function MenuDef()

	Local a_Rotina	:= {}

	ADD OPTION a_Rotina TITLE '&Visualizar'	ACTION 'VIEWDEF.EXERC04' OPERATION 2 ACCESS 0
	ADD OPTION a_Rotina TITLE '&Incluir'    	ACTION 'VIEWDEF.EXERC04' OPERATION 3 ACCESS 0
	ADD OPTION a_Rotina TITLE '&Alterar'   	ACTION 'VIEWDEF.EXERC04' OPERATION 4 ACCESS 0
	ADD OPTION a_Rotina TITLE '&Excluir'    	ACTION 'VIEWDEF.EXERC04' OPERATION 5 ACCESS 0
	ADD OPTION a_Rotina TITLE 'Im&primir'  	ACTION 'VIEWDEF.EXERC04' OPERATION 8 ACCESS 0
	ADD OPTION a_Rotina TITLE '&Copiar'     	ACTION 'VIEWDEF.EXERC04' OPERATION 9 ACCESS 0

Return a_Rotina

/*/{Protheus.doc} ModelDef
Funcao responsavel pelo modelo

@author francisco.ssa
@since 03/06/2014
@version 1.0

@return Objeto, Retorna o modelo

@example
(examples)

@see (links_or_references)
/*/
Static Function ModelDef()

	Local oModel	:= MPFormModel():New('EXERC04M')
	Local oStruZB5	:= FWFormStruct( 1, 'ZB5' )
	Local oStruZB6	:= FWFormStruct( 1, 'ZB6' )
	Local oStruZB7	:= FWFormStruct( 1, 'ZB7' )

	oModel:AddFields('ZB5MASTER',/*cOwner*/,oStruZB5, /*bPre*/ {|oModel, cAction, cIDField, xValue| f_FormOK(oModel, cAction, cIDField, xValue) } , /*bPost*/, /*bLoad*/)

	oModel:AddGrid('ZB6GRID','ZB5MASTER',oStruZB6)	//,/*bLinePre*/,/*bLinePost*/ {|oModel| f_TDP002POS( oModel ) },/*bPre*/,/*bPos*/,/*bLoad*/)
	oModel:SetRelation('ZB6GRID',{ { 'ZB6_FILIAL', 'XFILIAL("ZB6")' }, { 'ZB6_CODTUR', 'ZB5_CODTUR' } }, ZB6->( IndexKey( 1 ) ) )
	oModel:AddCalc('EXERC04CALC1', 'ZB5MASTER', 'ZB6GRID', 'ZB6_RA', 'ZB6__TOT01', 'COUNT',,,'Total de Registros:' )

	oModel:AddGrid('ZB7GRID','ZB6GRID',oStruZB7,/*bLinePre*/{|oModel, nLine, cAction, cIDField, xValue, xCurrentValue| f_PreLinOk(oModel, nLine, cAction, cIDField, xValue, xCurrentValue)},/*bLinePost*/ {|oModel| f_LinOk( oModel ) },/*bPre*/,/*bPos*/,/*bLoad*/)
	oModel:SetRelation('ZB7GRID',{ { 'ZB7_FILIAL', 'XFILIAL("ZB7")' }, { 'ZB7_CODTUR', 'ZB5_CODTUR' }, { 'ZB7_RA', 'ZB6_RA' } }, ZB7->( IndexKey( 1 ) ) )
	oModel:AddCalc('EXERC04CALC2', 'ZB6GRID', 'ZB7GRID', 'ZB7_CODDIS', 'ZB7__TOT01', 'COUNT',,,'Total de Registros:' )

	oModel:GetModel('ZB6GRID'):SetUniqueLine({'ZB6_RA'})
	oModel:GetModel('ZB7GRID'):SetUniqueLine({'ZB7_CODDIS','ZB7_BIM'})

	oModel:GetModel('ZB5MASTER'):SetDescription('Turma')
	oModel:GetModel('ZB6GRID'):SetDescription('Alunos/Turma')
	oModel:GetModel('ZB7GRID'):SetDescription('Notas')

Return oModel

/*/{Protheus.doc} ViewDef
Funcao reponsavel pela View

@author francisco.ssa
@since 03/06/2014
@version 1.0

@return Objeto, Retorna a View

@example
(examples)

@see (links_or_references)
/*/
Static Function ViewDef()

	Local oView		:= FWFormView():New()

	Local oStruZB5	:= FWFormStruct( 2, 'ZB5' )
	Local oStruZB6	:= FWFormStruct( 2, 'ZB6' )
	Local oStruZB7	:= FWFormStruct( 2, 'ZB7' )
	Local oStr3
	Local oStr4

	Local oModel	:= FWLoadModel('EXERC04')

	oStr3			:= FWCalcStruct( oModel:GetModel('EXERC04CALC1') )
	oStr4			:= FWCalcStruct( oModel:GetModel('EXERC04CALC2') )

	oView:SetModel(oModel)

	//------------- Formulario de Turmas
	oView:AddField('ZB5_VIEW',oStruZB5,'ZB5MASTER')
	oView:EnableTitleView('ZB5_VIEW','TURMAS')
	oView:CreateHorizontalBox('CABEC',20)
	oView:SetOwnerView('ZB5_VIEW','CABEC')

	//------------- Grid de Alunos
	oView:AddGrid('ZB6_VIEW',oStruZB6,'ZB6GRID')
	oView:EnableTitleView('ZB6_VIEW','ALUNOS')
	oView:CreateHorizontalBox('GRID1',30)
	oView:SetOwnerView('ZB6_VIEW','GRID1')

	//------------- Campo calculado: Contador de Registros
	oView:AddField('TOTREG1', oStr3,'EXERC04CALC1')
	oView:CreateHorizontalBox('BOXCALC1',10)
	oView:SetOwnerView('TOTREG1','BOXCALC1')

	//------------- Grid de Disciplinas (notas)
	oView:AddGrid('ZB7_VIEW',oStruZB7,'ZB7GRID')
	oView:EnableTitleView('ZB7_VIEW','NOTAS')
	oView:CreateHorizontalBox('GRID2',30)
	oView:SetOwnerView('ZB7_VIEW','GRID2')

	//------------- Campo calculado: Contador de Registros
	oView:AddField('TOTREG2', oStr4,'EXERC04CALC2')
	oView:CreateHorizontalBox('BOXCALC2',10)
	oView:SetOwnerView('TOTREG2','BOXCALC2')

Return oView

/*/{Protheus.doc} f_LinOk
Funcao responsavel pela validacao da linha apos atualizacao da mesma

@author francisco.ssa
@since 02/06/2014
@version 1.0

@param oModel, objeto, (Descrição do parâmetro)

@return Logico, Retorna True/False conforme regra de negocio

@example
(examples)

@see (links_or_references)
/*/
Static Function f_LinOk( oModel )

	Local l_Ret		:= .T.
	Local n_Opca	:= oModel:GetOperation()
	Local n_Linha	:= oModel:GetLine()
	Local a_SaveLin	:= FWSaveRows()
	Local n_QtdLin	:= oModel:Length()

	IF n_Opca == MODEL_OPERATION_INSERT .OR. n_Opca == MODEL_OPERATION_UPDATE
		IF oModel:GetValue("ZB7_NOTA") < 0 .OR. oModel:GetValue("ZB7_NOTA") > 10
			Help("123",1,'VLDNOTA',,"A nota deve ser entre 0 e 10",1,0)
			l_Ret := .F.
		ENDIF

	ENDIF

	FWRestRows(a_SaveLin)

Return l_Ret

/*/{Protheus.doc} f_PreLinOk
Funcao responsavel pela validacao da linha antes da atualizacao de um campo

@author francisco.ssa
@since 03/06/2014
@version 1.0

@param oModel, objeto, Modelo
@param nLine, numérico, Posicao da linha
@param cAction, character, Acao executada
@param cIDField, character, Campo acionado
@param xValue, variável, Valor Digitado
@param xCurrentValue, variável, Valor anterior

@return Logico, True/False conforme regra de negocio

@example
(examples)

@see (links_or_references)
/*/
Static Function f_PreLinOk(oModel, nLine, cAction, cIDField, xValue, xCurrentValue)

	Local l_Ret		:= .T.
	Local n_Opca	:= oModel:GetOperation()

	IF n_Opca == MODEL_OPERATION_UPDATE
		IF cIDField == "ZB7_NOTA" .OR. cAction == "DELETE"
			IF !oModel:IsInserted()
				ShowHelpDlg("Protheus Educacional",;
					{"Nao e permitido alterar uma nota apos sua inclusao"},5,;
					{"..."},5)
				l_Ret := .F.
			ENDIF
		ENDIF
	ENDIF

Return l_Ret

/*/{Protheus.doc} f_FormOK
Funcao responsavel pela validacao do Formulario

@author francisco.ssa
@since 03/06/2014
@version 1.0

@param oModel, objeto, Modelo
@param cAction, character, Acao executada
@param cIDField, character, Campo acionado
@param xValue, variável, Valor atual

@return Logico, True/False conforme regra de negocio

@example
(examples)

@see (links_or_references)
/*/
Static Function f_FormOK(oModel, cAction, cIDField, xValue)

	Local l_Ret		:= .T.
	Local c_Turma	:= oModel:GetValue("ZB5_CODTUR")

	DBSELECTAREA("ZB1")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("ZB1")+c_Turma,.T.)

		IF ZB1->ZB1_SITUAC <> '1'
			Help("123",1,'VLDFORM',,"Turma não ativa",1,0)
			l_Ret := .F.
		ENDIF

	ENDIF

Return(l_Ret)

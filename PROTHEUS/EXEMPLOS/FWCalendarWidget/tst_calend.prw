#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

User Function Calendario()
	Local oCalend
	Local oPanelCal

	DEFINE MSDIALOG oDlg TITLE "Teste Calendario" FROM 000, 000  TO 800, 800 COLORS 0, 16777215 PIXEL


	oPanelCal := TPanel():New(000,000,"",oDlg,,,,,, 200 ,200)

	oCalend := FWCalendarWidget():New(oPanelCal)
	oCalend:SetbNewActivity( {|dDate,cTimeIni,cTimeFin| NewTask(dDate,cTimeIni,cTimeFin) } )
	oCalend:SetbClickActivity( {|oItem| EditTask(oItem) } )
	oCalend:SetbRefresh( {|dDate| BuscaAtividades(dDate) } )
	oCalend:SetbRightClick( {|oItem| RightClick(oItem) } )
	oCalend:SetFontColor("#FF6600")
	oCalend:SetFontName("Comic Sans MS")

	oCalend:Activate()
	ACTIVATE MSDIALOG oDlg CENTERED
return



//Função executada ao criar uma nova tarefa
//recebe a data selecionada e a hora (quando o usuário clicou em algum horario especifico)
Static Function NewTask(dDate, cTimeIni, cTimeFin)
	Local oModel := FWLoadModel( "MVC_CALEND" )
	oModel:SetOperation(MODEL_OPERATION_INSERT)
	oModel:Activate()
	oModel:SetValue('MASTER', 'ZZL_DTINI', dDate)
	oModel:SetValue('MASTER', 'ZZL_DTFIN', dDate)
	oModel:SetValue('MASTER', 'ZZL_HRINI', cTimeIni)
	oModel:SetValue('MASTER', 'ZZL_HRFIN', cTimeFin)

	//abre view com alguns dados ja preenchidos acima
	FWExecView('Inclusão de atividade - Calendario','MVC_CALEND', MODEL_OPERATION_INSERT, , { || .T. } , , 50,,,,,oModel)
Return .T.

//Funcao chamada ao dar um duplo click sobre uma atividade.
//Recebe o item q o usuário clicou
Static Function EditTask(oItem)
	Local aArea     := GetArea()
	DbSelectArea('ZZL')
	DbSetOrder(1)
	If DbSeek(xFilial('ZZL') + oItem:cID)
		FWExecView("",'MVC_CALEND', MODEL_OPERATION_UPDATE,, { || .T. } , , 50 )
	EndIf
	RestArea(aArea)
Return .T.
Static Function ExcluirAtiv(cID)

	Local aArea     := GetArea()

	DbSelectArea('ZZL')
	DbSetOrder(1)
	If DbSeek(xFilial('ZZL') + cID)
		FWExecView("",'MVC_CALEND', MODEL_OPERATION_DELETE,, { || .T. } , , 50 )
	EndIf
	RestArea(aArea)
Return
//Funcao chamada ao clicar com o botao direito
Static Function RightClick(oItem)
	Local aMenu := {}
	Local cVarTeste := 'Texto qualquer'

	If oItem <> nil
		//-------------------------------------------------------
		// Quando clicou com o direito sobre algum agendamento
		//-------------------------------------------------------
		AADD(aMenu, {'Excluir', "ExcluirAtiv('" + oItem:cID + "')" } )
	Else
		//-------------------------------------------------------
		// Quando clicou com o direito sobre um horário livre
		//-------------------------------------------------------
		AADD(aMenu, {'Evento qualquer', "Alert('Teste') " } )
		AADD(aMenu, {'Outra ação', "Alert('" + cVarTeste + "') " } )

	EndIf

Return aMenu
//Funcao chamada para atualizar os dados do calendario
//Essa funcao recebe uma data e deverá retornar um array de objetos do tipo  FWCalendarActivity()
//com as atividades que devem ser exibidas no calendario
Static Function BuscaAtividades(dDate)
	Local aArea     := GetArea()
	Local aItems    := {}
	Local oItem     := nil
	Local aPrior    := {0,1,2} //{FWCALENDAR_PRIORITY_HIGH, FWCALENDAR_PRIORITY_MEDIUM, FWCALENDAR_PRIORITY_LOW}
	Local nPrior    := 0

	/*obs: é possivel definir a cor da atividade de duas formas.
	1) utilizando o metodo SetPriority(), será definida uma cor padrao de acordo com a prioridade da tarefa passada
	2) utilizando o metodo SetColor(cHexColor) e passando uma cor em hexadecimal
	Se utilizar o SetColor() não utilize o SetPriority.
	*/

	DbSelectArea('ZZL')
	DbSetOrder(2)
	ZZL->(DBGoTOP())

	While ('ZZL')->(!EOF())

		If ZZL->ZZL_DTINI <= dDate .AND. ZZL->ZZL_DTFIN >= dDate

			nPrior := IIF(Val(ZZL->ZZL_PRIOR)>0,Val(ZZL->ZZL_PRIOR),2)

			oItem := FWCalendarActivity():New()

			oItem:SetID(ZZL->ZZL_ID)
			oItem:SetTitle(ZZL->ZZL_TITULO)
			oItem:SetNotes(ZZL->ZZL_NOTAS)
			oItem:SetPriority(aPrior[nPrior])
			oItem:SetDtIni(ZZL->ZZL_DTINI)
			oItem:SetDtFin(ZZL->ZZL_DTFIN)
			oItem:SetHrIni(ZZL->ZZL_HRINI)
			oItem:SetHrFin(ZZL->ZZL_HRFIN)

			AADD(aItems,oItem)

		EndIf
		("ZZL")->(DbSkip())

	EndDo

	RestArea(aArea)
Return aItems
User Function MVC_CALEND()
	Local oBrowse
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZZL')
	oBrowse:SetDescription("Cadastro de Qualquer ")
	oBrowse:Activate()
Return
//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Definição do modelo de Dados
@author ricardo.acosta
@since 27/03/2014
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function ModelDef()
	Local oModel

	Local oStr1:= FWFormStruct(1,'ZZL')
	oModel := MPFormModel():New('MVC_CALEND')
	oModel:addFields('MASTER',,oStr1)
	oModel:getModel('MASTER'):SetDescription('Calendario')
	oModel:SetPrimaryKey({"ZZL_FILIAL" , "ZZL_ID"})

Return oModel
//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Definição do interface
@author ricardo.acosta
@since 27/03/2014
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function ViewDef()
	Local oView
	Local oModel := ModelDef()

	Local oStr1:= FWFormStruct(2, 'ZZL')
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField('CALENDAR' , oStr1,'MASTER' )
	oView:CreateHorizontalBox( 'BOXFORM1', 100)
	oView:SetOwnerView('CALENDAR','BOXFORM1')

Return oView
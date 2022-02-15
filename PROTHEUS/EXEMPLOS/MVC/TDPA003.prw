#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} TDPA001
TREINAMENTO MVC

@author francisco.ssa
@since 12/03/2014
@version P11.8

@return Nil, Nao Esperado

@example
(examples)

@see (links_or_references)
/*/

User Function TDPA003()

	Local oBrowse	:= Nil

	oBrowse := FWmBrowse():New()
	oBrowse:SetAlias("ZA2")	//Cadastro de Autor/Interprete
	//oBrowse:AddLegend( "ZA2_DTAFAL<>CTOD('')", "RED"		, "Falecido" )
	//oBrowse:AddLegend( "ZA2_DTAFAL==CTOD('')", "WHITE"	, "Vivão" )
	oBrowse:SetDescription('Auto/Interprete')
	oBrowse:Activate()

Return()

Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE '&Visualizar' ACTION 'VIEWDEF.TDPA003' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE '&Incluir'    ACTION 'VIEWDEF.TDPA003' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE '&Alterar'    ACTION 'VIEWDEF.TDPA003' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE '&Excluir'    ACTION 'VIEWDEF.TDPA003' OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Im&primir'   ACTION 'VIEWDEF.TDPA003' OPERATION 8 ACCESS 0
	ADD OPTION aRotina TITLE '&Copiar'     ACTION 'VIEWDEF.TDPA003' OPERATION 9 ACCESS 0

Return aRotina

//--------------------------------------------------------------------------------------------------------

Static Function ModelDef()

	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruZA2 := FWFormStruct(1, 'ZA2' )

	// Modelo de dados que será construído
	Local oModel

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('TDPA003MODEL')	//,{|oModel| f_TP001PREV(oModel) },{|oModel| f_TP001POSV(oModel) },/*{|oModel| f_TP001COMV(oModel) }*/,{|oModel| f_TP001CANV(oModel) })

	// Adiciona ao modelo um componente de formulário
	oModel:AddFields( 'ZA2MASTER', /*cOwner*/, oStruZA2)

	// Adiciona a descrição do Modelo de Dados
	oModel:SetDescription( 'Embarcacao' )

	// Adiciona a descrição do Componente do Modelo de Dados
	oModel:GetModel( 'ZA2MASTER' ):SetDescription( 'Embarcacao')

Return oModel

//--------------------------------------------------------------------------------------------------------
Static Function ViewDef()

	// Cria um objeto de Modelo de dados baseado no ModelDef() do fonte informado
	Local oModel := FWLoadModel( 'TDPA003' )

	// Cria a estrutura a ser usada na View
	Local oStruZA2 := FWFormStruct( 2, 'ZA2' )

	// Interface de visualização construída
	Local oView

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados será utilizado na View
	oView:SetModel( oModel )

	// Adiciona no nosso View um controle do tipo formulário
	// (antiga Enchoice)
	oView:AddField( 'VIEW_ZA2', oStruZA2, 'ZA2MASTER' )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'TELAZA2' , 100 )

	// Relaciona o identificador (ID) da View com o "box" para exibição
	oView:SetOwnerView( 'VIEW_ZA2', 'TELAZA2' )

Return oView

/*/{Protheus.doc} f_TP001PREV
(long_description)
@author francisco.ssa
@since 30/05/2014
@version 1.0
@param oModel, objeto, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/Static Function f_TP001PREV(oModel)

Local l_Ret	:= .T.

Alert("Validacao bPre")

Return(l_Ret)

/*/{Protheus.doc} f_TP001POSV
(long_description)
@author francisco.ssa
@since 30/05/2014
@version 1.0
@param oModel, objeto, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/

Static Function f_TP001POSV(oModel)

	Local l_Ret	:= .T.
	Local oModFZA2	:= oModel:GetModel("ZA2MASTER")

	IF oModFZA2:GetValue("ZA2_DTAFAL") < DDATABASE
		Help("123",1,'VALDTFAL',,"Data Maior ou Igual a data atual. Informe uma data anterior valida",1,0)
		l_Ret	:= .F.
	EndIF

	//Alert("Validacao bPost")

Return(l_Ret)


/*/{Protheus.doc} f_TP001COMV
(long_description)
@author francisco.ssa
@since 30/05/2014
@version 1.0
@param oModel, objeto, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/

Static Function f_TP001COMV(oModel)

	Local l_Ret	:= .T.

	Alert("Validacao bCommit")

Return(l_Ret)

/*/{Protheus.doc} f_TP001CANV
(long_description)
@author francisco.ssa
@since 30/05/2014
@version 1.0
@param oModel, objeto, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/

Static Function f_TP001CANV(oModel)

	Local l_Ret	:= .T.

	Alert("Validacao bCancel")

Return(l_Ret)

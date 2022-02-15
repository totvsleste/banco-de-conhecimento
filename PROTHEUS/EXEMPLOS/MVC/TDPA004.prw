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

User Function TDPA004()

	Local oBrowse	:= Nil

	oBrowse := FWmBrowse():New()
	oBrowse:SetAlias("ZA3")	//Cadastro de Autor/Interprete
	//oBrowse:AddLegend( "ZA3_DTAFAL<>CTOD('')", "RED"		, "Falecido" )
	//oBrowse:AddLegend( "ZA3_DTAFAL==CTOD('')", "WHITE"	, "Vivão" )
	oBrowse:SetDescription('Auto/Interprete')
	oBrowse:Activate()

Return()

Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE '&Visualizar' ACTION 'VIEWDEF.TDPA004' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE '&Incluir'    ACTION 'VIEWDEF.TDPA004' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE '&Alterar'    ACTION 'VIEWDEF.TDPA004' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE '&Excluir'    ACTION 'VIEWDEF.TDPA004' OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Im&primir'   ACTION 'VIEWDEF.TDPA004' OPERATION 8 ACCESS 0
	ADD OPTION aRotina TITLE '&Copiar'     ACTION 'VIEWDEF.TDPA004' OPERATION 9 ACCESS 0

Return aRotina

//--------------------------------------------------------------------------------------------------------

Static Function ModelDef()

	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruZA3 := FWFormStruct(1, 'ZA3' )

	// Modelo de dados que será construído
	Local oModel

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('TDPA004MODEL')	//,{|oModel| f_TP001PREV(oModel) },{|oModel| f_TP001POSV(oModel) },/*{|oModel| f_TP001COMV(oModel) }*/,{|oModel| f_TP001CANV(oModel) })

	// Adiciona ao modelo um componente de formulário
	oModel:AddFields( 'ZA3MASTER', /*cOwner*/, oStruZA3)

	// Adiciona a descrição do Modelo de Dados
	oModel:SetDescription( 'Embarcacao' )

	// Adiciona a descrição do Componente do Modelo de Dados
	oModel:GetModel( 'ZA3MASTER' ):SetDescription( 'Embarcacao')

Return oModel

//--------------------------------------------------------------------------------------------------------
Static Function ViewDef()

	// Cria um objeto de Modelo de dados baseado no ModelDef() do fonte informado
	Local oModel := FWLoadModel( 'TDPA004' )

	// Cria a estrutura a ser usada na View
	Local oStruZA3 := FWFormStruct( 2, 'ZA3' )

	// Interface de visualização construída
	Local oView

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados será utilizado na View
	oView:SetModel( oModel )

	// Adiciona no nosso View um controle do tipo formulário
	// (antiga Enchoice)
	oView:AddField( 'VIEW_ZA3', oStruZA3, 'ZA3MASTER' )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'TELAZA3' , 100 )

	// Relaciona o identificador (ID) da View com o "box" para exibição
	oView:SetOwnerView( 'VIEW_ZA3', 'TELAZA3' )

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
	Local oModFZA3	:= oModel:GetModel("ZA3MASTER")

	IF oModFZA3:GetValue("ZA3_DTAFAL") < DDATABASE
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

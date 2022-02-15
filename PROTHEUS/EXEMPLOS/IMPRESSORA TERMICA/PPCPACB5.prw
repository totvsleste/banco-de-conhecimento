//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include "TOPCONN.CH"
#include "vkey.ch"
#DEFINE ENTER CHR(13)+CHR(10)
 
//Variáveis Estáticas
Static cTitulo := "Cadastro de Impressoras Codigos de Barras"
 
/*/{Protheus.doc} PPCPACB5
Função para Cadastro de Impressoras de Codigos de Barras, Modelo 1 em MVC
@author Eduardo Arcieri
@since 18/11/2016
@version 1.0
    @return Nil, Função não tem retorno
    @example
    u_PPCPACB5()
/*/
 
User Function PPCPACB5()
    Local aArea   := GetArea()
    Local oBrowse
     
    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de (c)Amarração Produtos x Ean13 x Dun14
    oBrowse:SetAlias("CB5")
 
    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)
    
    //Ativa a Browse
    oBrowse:Activate()
     
    RestArea(aArea)
Return Nil
 
/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Eduardo Arcieri                                              |
 | Data:  19/07/2016                                                   |
 | Desc:  Criação do menu MVC                                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function MenuDef()
    Local aRot := {}
    //Adicionando opções
	ADD OPTION aRot Title 'Visualizar' 	Action 'VIEWDEF.PPCPACB5'	OPERATION 2 ACCESS 0
	ADD OPTION aRot Title 'Incluir' 		Action 'VIEWDEF.PPCPACB5'	OPERATION 3 ACCESS 0
	ADD OPTION aRot Title 'Alterar' 		Action 'VIEWDEF.PPCPACB5'	OPERATION 4 ACCESS 0
	ADD OPTION aRot Title 'Excluir' 		Action 'VIEWDEF.PPCPACB5'	OPERATION 5 ACCESS 0
	ADD OPTION aRot Title 'Imprimir' 		Action 'VIEWDEF.PPCPACB5'	OPERATION 8 ACCESS 0
	ADD OPTION aRot Title 'Copiar' 			Action 'VIEWDEF.PPCPACB5'	OPERATION 9 ACCESS 0
Return aRot
 
/*/{Protheus.doc} ModelDef
(Definicao do modelo do formulario)
@type function
@author Eduardo.arcieri
@since 18/11/2016
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
 /*/
Static Function ModelDef()
Local oStCB5 	:= 	FWFormStruct(1, "CB5")
Local aAuxDSProd:=	{}

Local lRet := .T.

//Criação do objeto do modelo de dados
Local oModel := Nil
     
//Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
oModel := MPFormModel():New("PPCB5MD",/*bPre*/, { |oMdl| PPCB5POS( oMdl ) },/*bCommit*/,/*bCancel*/) 
     
//Atribuindo formulários para o modelo
oModel:AddFields("FORMCB5",/*cOwner*/,oStCB5)
     
//Setando a chave primária da rotina
oModel:SetPrimaryKey({'CB5_FILIAL','CB5_CODIGO'}) //CB5_FILIAL+CB5_CODIGO
     
//Adicionando descrição ao modelo
oModel:SetDescription(cTitulo)
     
//Setando a descrição do formulário
oModel:GetModel("FORMCB5"):SetDescription("Formulario de "+cTitulo)


Return oModel
 
 
/*/{Protheus.doc} ViewDef
(Definicao da view)
@type function
@author Eduardo.arcieri
@since 18/11/2016
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function ViewDef()
//Criação do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
Local oModel := FWLoadModel("PPCPACB5")
     
//Criação da estrutura de dados utilizada na interface do cadastro de Autor
Local oStCB5 := FWFormStruct(2, "CB5")  //pode se usar um terceiro parâmetro para filtrar os campos exibidos { |cCampo| cCampo $ 'CB5_NOME|CB5_DTAFAL|'}
     
//Criando oView como nulo
Local oView := Nil
 
//Criando a view que será o retorno da função e setando o modelo da rotina
oView := FWFormView():New()
oView:SetModel(oModel)
     
//Atribuindo formulários para interface
oView:AddField("VIEW_CB5", oStCB5, "FORMCB5")
     
//Criando um container com nome tela com 100%
oView:CreateHorizontalBox("TELA",100)
     
//Colocando título do formulário
oView:EnableTitleView('VIEW_CB5', 'Dados de '+cTitulo )  
     
//Força o fechamento da janela na confirmação
oView:SetCloseOnOk({||.T.})
     
//O formulário da interface será colocado dentro do container
oView:SetOwnerView("VIEW_CB5","TELA")

Return oView
 

/*/{Protheus.doc} PPCB5POS
(Validacao de existecia de registro relacionado com outra tabela)
@type function
@author eduardo.arcieri
@since 18/11/2016
@version 1.0
@param oModel, objeto, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function PPCB5POS( oModel )
Local nOperation := oModel:GetOperation()
Local lRet := .T.
  
If nOperation == MODEL_OPERATION_DELETE
	ZF0->(dbSetOrder(3)) //FILIAL + MODELO
	If ZF0->(dbSeek(xFilial("ZF0")+ CB5->CB5_CODIGO, .T.))
      	Help( ,, 'HELP',, 'Este Registro está relacionado com o cadastro de configuracao de etiquetas, nao pode ser excluido.', 1, 0)
      	lRet := .F.      
	Endif	
EndIf

Return lRet


//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include "TOPCONN.CH"
#include "vkey.ch"
#DEFINE ENTER CHR(13)+CHR(10)

//Variáveis Estáticas
Static cTitulo := "Romaneio de Expedicao Indeba"
 
/*/{Protheus.doc} FFATA100
Função para Romaneio de Expedicao Indeba (SF2), Modelo 1 em MVC
@author Eduardo Arcieri
@since 08/04/2016
@version 1.0
    @return Nil, Função não tem retorno
    @example
    u_FFATA100()
/*/
 
User Function FFATA100()
    Local aArea   := GetArea()
    Local oBrowse
     
    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cadastro de aprovadores de SC
    oBrowse:SetAlias("SF2")
 
    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)
     
    //Legendas
    oBrowse:AddLegend( "SF2->F2_FSROM == 'S'", "GREEN", "Liberado" )
    oBrowse:AddLegend( "SF2->F2_FSROM <> 'S'", "RED",   "Bloqueado" )

    //Ativa a Browse
    oBrowse:Activate()
     
    RestArea(aArea)
Return Nil
 
/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Eduardo Arcieri                                              |
 | Data:  07/04/2016                                                   |
 | Desc:  Criação do menu MVC                                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function MenuDef()
    Local aRot := {}
     
    //Adicionando opções
	ADD OPTION aRot Title 'Visualizar' 	Action 'VIEWDEF.FFATA100'	OPERATION 2 ACCESS 0
//	ADD OPTION aRot Title 'Incluir' 		Action 'VIEWDEF.FFATA100'	OPERATION 3 ACCESS 0
	ADD OPTION aRot Title 'Expedir' 		Action 'VIEWDEF.FFATA100'	OPERATION 4 ACCESS 0
	ADD OPTION aRot Title 'Estornar' 		Action 'VIEWDEF.FFATA100'	OPERATION 4 ACCESS 0	
//	ADD OPTION aRot Title 'Excluir' 		Action 'VIEWDEF.FFATA100'	OPERATION 5 ACCESS 0
//	ADD OPTION aRot Title 'Imprimir' 		Action 'VIEWDEF.FFATA100'	OPERATION 8 ACCESS 0
//	ADD OPTION aRot Title 'Copiar' 			Action 'VIEWDEF.FFATA100'	OPERATION 9 ACCESS 0
Return aRot
 
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Eduardo Arcieri                                              |
 | Data:  07/04/2016                                                   |
 | Desc:  Criação do modelo de dados MVC                               |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function ModelDef()
    //Criação do objeto do modelo de dados
    Local oModel := Nil
     
    //Criação da estrutura de dados utilizada na interface
    Local oStSF2 := FWFormStruct(1, "SF2")
    Local oStSD2 := FWFormStruct(1, "SD2")
    Local oStSZB := FWFormStruct(1, "SZB")
     
    //Bloqueando Edicao dos campos
    oStSF2:SetProperty('*', MODEL_FIELD_WHEN,{|| .F. })
    oStSD2:SetProperty('*', MODEL_FIELD_WHEN,{|| .F. })
    oStSZB:SetProperty('*', MODEL_FIELD_WHEN,{|| .T. })
    
    
    
    //Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("FF100MD",/*bPre*/, { |oMdl| FF100POS( oMdl ) },/*bCommit*/,/*bCancel*/) 
	
    //Atribuindo formulários para o modelo
    oModel:AddFields("FORMSF2",/*cOwner*/,oStSF2)

	//Removendo obrigatoriedade de validacao dos campos do modelo
	//oModel:Getmodel('FORMSF2'):SetOptional(.T.)
	oModel:GetModel('FORMSF2'):GetStruct():SetProperty("F2_ESPECIE",MODEL_FIELD_OBRIGAT,.F.)
     
    //Adicionando ao modelo um componente de grid.
	oModel:AddGrid( 'FORMSD2', 'FORMSF2', oStSD2 )  

	//Removendo obrigatoriedade de validacao dos campos do modelo
	oModel:Getmodel('FORMSD2'):SetOptional(.T.)
    
    //Adicionando ao modelo um componente de grid.
	oModel:AddGrid( 'FORMSZB', 'FORMSF2', oStSZB )  
	
	//Adicionando relacionamento entre MASTER E DETALHE
	oModel:SetRelation( 'FORMSD2', { { 'D2_FILIAL', 'F2_FILIAL' }, {'D2_SERIE', 'F2_SERIE' }, {'D2_DOC', 'F2_DOC' }  }, SD2->( IndexKey( 1 ) ) )
	//Adicionando relacionamento entre MASTER E DETALHE
	oModel:SetRelation( 'FORMSZB', { { 'ZB_FILIAL', 'D2_FILIAL' }, {'ZB_SERIE', 'D2_SERIE' }, {'ZB_DOC', 'D2_DOC' }, {'ZB_ITEM', 'D2_ITEM' }  }, SZB->( IndexKey( 1 ) ) )
	 
    //Setando a chave primária da rotina
    oModel:SetPrimaryKey({'F2_FILIAL', 'F2_DOC', 'F2_SERIE'}) //F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_FORMUL, F2_TIPO
     
    //Validação de linha duplicada
    //oModel:GetModel( 'FORMSD2' ):SetUniqueLine( { 'SD2_FILIAL','SD2_PROD','SD2_SEQ','SD2_ITEM' } )
     
    //Adicionando descrição ao modelo
    oModel:SetDescription("Cadastro de "+cTitulo)
     
    //Setando a descrição do formulário
    oModel:GetModel("FORMSF2"):SetDescription("Cabeçalho NF - SF2")
    oModel:GetModel("FORMSD2"):SetDescription("Detalhe NF- SD2")
    oModel:GetModel("FORMSZB"):SetDescription("Rotulos Expedidos - SZB")

	//oModel:AddGrid( 'FORMSD2', 'FORMSF2', oStSD2, , /*{ |oModel| FF100LPOS(oModel) }*/ )
	//oModel:AddGrid( 'FORMSZB', 'FORMSF2', oStSZB, , /*{ |oModel| FF100LPOS(oModel) }*/ )
    
    
Return oModel
 
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Eduardo Arcieri                                              |
 | Data:  07/04/2016                                                   |
 | Desc:  Criação da visão MVC                                         |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()
    //Criação do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    Local oModel := FWLoadModel("FFATA100")
     
    //Criação da estrutura de dados utilizada na interface do cadastro de etiquetas - cabecalho
    Local oStSF2 := FWFormStruct( 2, 'SF2',  { |x| ALLTRIM(x) $ 'F2_FILIAL, F2_SERIE, F2_DOC, F2_FSCLI, F2_FSROM' } )//{|c_Campo| f_StruSF2(c_Campo)} )
    Local oStSD2 := FWFormStruct( 2, 'SD2',  { |x| ALLTRIM(x) $ 'D2_ITEM, D2_COD, D2_QUANT, D2_UM, D2_QTSEGUM, D2_SEGUM, D2_LOTECTL' } )//{|c_Campo| f_StruSD2(c_Campo)} ) 
    Local oStSZB := FWFormStruct( 2, 'SZB',  { |x| ALLTRIM(x) $ 'ZB_ITEM, ZB_CODBAR, ZB_INCONS' } )
    
    //Criando oView como nulo
    Local oView := Nil
    
    //Criando a view que será o retorno da função e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formulários para interface
    oView:AddField("VIEW_SF2", oStSF2, "FORMSF2")
    
    
    //Adicionamos na interface (View) um controle do tipo grid (antiga GetDados), para isso usamos o método AddGrid.
	oView:AddGrid( 'VIEW_SD2', oStSD2, "FORMSD2" )
	oView:AddGrid( 'VIEW_SZB', oStSZB, "FORMSZB" )

	//Não permitir alteracao nos formularios.
    oModel:GetModel( 'FORMSF2' ):SetOnlyQuery ( .T. )
    oModel:GetModel( 'FORMSD2' ):SetOnlyQuery ( .T. )
    
    //Campo Incremental (AddIncrementField)
    //oView:AddIncrementField( 'VIEW_SD2', 'SD2_ITEM' )
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("CABNF"		,25)
    oView:CreateHorizontalBox("DETNF"		,25)
    oView:CreateHorizontalBox("ROTULOS"	,50)
     
    //Colocando título do formulário
    oView:EnableTitleView('VIEW_SF2', 'Cabecalho NF' )  
    oView:EnableTitleView('VIEW_SD2', 'Detalhe - NF' )
    oView:EnableTitleView('VIEW_SZB', 'Rotulos Expedidos' )  
     
    //Força o fechamento da janela na confirmação
    oView:SetCloseOnOk({||.T.})
     
    //O formulário da interface será colocado dentro do container
    oView:SetOwnerView( 'VIEW_SF2', 'CABNF' 		)
    oView:SetOwnerView( 'VIEW_SD2', 'DETNF' 		)
    oView:SetOwnerView( 'VIEW_SZB', 'ROTULOS' 	)
    
    oView:AddUserButton( 'Leitura'	, 'Ler Codigo de Barras', {|oModel,oView| f_Expedir(oModel, oView ) 		} )
    oView:AddUserButton( 'Estornar', 'Estornar Leitura'		, {|oModel,oView| f_Estornar(oModel, oView) 		} )
    
Return oView
 
/*/{Protheus.doc} FFC100Leg
Função para mostrar a legenda das rotinas MVC com grupo de produtos
@author Eduaro Arcieri
@since 07/04/2016
@version 1.0
    @example
    u_PPC100Leg()
/*/
 
User Function FFC100Leg()
    Local aLegenda := {}
     
    //Monta as cores
    AADD(aLegenda,{"BR_VERDE",      "Liberado"  })
    AADD(aLegenda,{"BR_VERMELHO",   "Bloqueado"})
     
    BrwLegenda("Romaneio de Expedicao Indeba", "Status", aLegenda)
Return



Static Function f_Expedir()//o_Model, o_View)

SetPrvt("o_DlgTela,o_GrpNota,o_GrpCBar,oLBoxLidos,oFMSsans18")
SetPrvt("o_SSerie,o_SDoc,o_SCli,o_SItem,o_SProd")
SetPrvt("o_GSerie,o_GDoc,o_GCli,o_GItem,o_GProd,o_GCodBar")

Private o_Model	:=	FWModelActive()	 

Private O_MDLCAB := O_MODEL:GETMODEL('FORMSF2')
Private c_GSerie   	:= 	O_MDLCAB:GetValue('F2_SERIE')
Private c_GDoc     	:= 	O_MDLCAB:GetValue('F2_DOC')
Private c_Cliente		:=	POSICIONE("SF2",1,xFILIAL("SF2")+Padr(c_GDoc,TamSx3('F2_DOC')[1])+Padr(c_GSerie,TamSx3('F2_LOJA')[1]),"F2_CLIENTE")
Private c_Loja		:=	POSICIONE("SF2",1,xFILIAL("SF2")+Padr(c_GDoc,TamSx3('F2_DOC')[1])+Padr(c_GSerie,TamSx3('F2_LOJA')[1]),"F2_LOJA")
Private c_TipoNF		:=	POSICIONE("SF2",1,xFILIAL("SF2")+Padr(c_GDoc,TamSx3('F2_DOC')[1])+Padr(c_GSerie,TamSx3('F2_LOJA')[1]),"F2_TIPO")
Private c_CliNome		:=	""
If c_TipoNF $ "DB"
	c_CliNome			:=	POSICIONE("SA2",1,xFILIAL("SA2")+Padr(c_Cliente,TamSx3('A2_COD')[1])+Padr(c_Loja,TamSx3('A2_LOJA')[1]),"A2_NOME")
Else
	c_CliNome			:=	POSICIONE("SA1",1,xFILIAL("SA1")+Padr(c_Cliente,TamSx3('A1_COD')[1])+Padr(c_Loja,TamSx3('A1_LOJA')[1]),"A1_NOME")
Endif
Private c_GCli     	:= 	c_Cliente+"/"+c_Loja+" - "+c_CliNome   


Private O_MDLGRID := O_MODEL:GETMODEL('FORMSD2')
Private c_GItem    	:= 	O_MDLGRID:GetValue('D2_ITEM')
Private c_GProd    	:= 	O_MDLGRID:GetValue('D2_COD')

Private c_GCodBar  	:= 	Space(TAMSX3("ZB_CODBAR")[1])
Private a_Lidos		:=	{}
Private c_Cliente		:=	SF2->F2_CLIENTE
Private c_Loja		:=	SF2->F2_LOJA
Private a_Lidos		:=	{}


Private O_MDLGSZB := O_MODEL:GETMODEL('FORMSZB')

//ALERT(O_MDLGRID:GetValue('D2_ITEM'))


oFMSsans18	:= TFont():New( "MS Sans Serif",0,-21,,.T.,0,,700,.F.,.F.,,,,,, )

o_DlgTela 	:= MSDialog():New( 116,318,616,1013,"Expedicao - Leitura",,,.F.,,,,,,.T.,,,.T. )

o_GrpNota	:= TGroup():New( 016,004,080,336,"Dados do Documento de Saída",o_DlgTela,CLR_BLACK,CLR_WHITE,.T.,.F. )
			
o_SSerie	:= TSay():New( 026,008,{||"Serie"}				,o_GrpNota,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,015,010)
o_SDoc		:= TSay():New( 026,024,{||"Num.Doc.Fiscal"}	,o_GrpNota,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
o_SCli		:= TSay():New( 026,064,{||"Cliente"}			,o_GrpNota,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
o_SItem	:= TSay():New( 046,008,{||"Item"}				,o_GrpNota,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,015,010)
o_SProd	:= TSay():New( 046,024,{||"Produto"}			,o_GrpNota,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
			
o_GSerie	:= TGet():New( 033,008,{|u| If(PCount()>0,c_GSerie:=u,c_GSerie)}	,o_GrpNota,015,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","c_GSerie",,)
o_GDoc		:= TGet():New( 033,024,{|u| If(PCount()>0,c_GDoc:=u,c_GDoc)}		,o_GrpNota,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","c_GDoc",,)
o_GCli		:= TGet():New( 033,064,{|u| If(PCount()>0,c_GCli:=u,c_GCli)}		,o_GrpNota,264,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","c_GCli",,)

o_GItem	:= TGet():New( 053,008,{|u| If(PCount()>0,c_GItem:=u,c_GItem)}		,o_GrpNota,015,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","c_GItem",,)
o_GProd	:= TGet():New( 053,024,{|u| If(PCount()>0,c_GProd:=u,c_GProd)}		,o_GrpNota,250,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","c_GProd",,)

o_GrpCBar	:= TGroup():New( 084,004,228,336,"Leitura de Codigo de Barra",o_DlgTela,CLR_BLACK,CLR_WHITE,.T.,.F. )

o_GCodBar  := TGet():New( 092,100,{|u| If(PCount()>0,c_GCodBar:=u,c_GCodBar)},o_GrpCBar,132,014,'',,CLR_BLACK,CLR_WHITE,oFMSsans18B,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","c_GCodBar",,)
o_GCodBar:bValid := {|| f_GrvSZB() }

oLBoxLidos := TListBox():New( 112,013,,,320,109,,o_GrpCBar,,CLR_BLACK,CLR_WHITE,.T.,,,,"",,,,,,, )

o_GSerie:lactive 	:=	.F.
o_GDoc:lactive 	:=	.F.
o_GCli:lactive 	:=	.F.
o_GItem:lactive 	:=	.F.
o_GProd:lactive 	:=	.F.
//oLBoxLidos:lactive 	:=	.F.

o_DlgTela:Activate(,,,.T.)

O_MDLGSZB:DeleteLine()
O_MDLGSZB:goline(1)

Return


Static Function f_GrvSZB()
Local l_Ret	:=	.T.

If Empty(c_GCodBar) //Codigo de barras vazio - encerra operacao de leitura
	If MsgYesNo("Deseja encerrar operacao de leitura de codigo de barras?","Expedicao")
		o_DlgTela:End()
	Else
		l_Ret := .F.
	Endif
Else
	c_Lote	:=	SubStr(c_GCodBar,1,8)
	c_Alias1 := GetNextAlias()

	BEGINSQL ALIAS c_Alias1
		SELECT D2_LOTECTL, D2_SERIE , D2_DOC, D2_COD, D2_ITEM
		
		FROM %TABLE:SD2% SD2
		WHERE   
		SD2.%NOTDEL%   
		AND D2_FILIAL			=		%XFILIAL:SD2%   
		AND D2_SERIE			=		%EXP:c_GSerie%
		AND D2_DOC				=	 	%EXP:c_GDoc%
		AND D2_LOTECTL		=		%EXP:c_Lote%  
	
	ENDSQL

	a_SZB		:=	{}
	l_Incons	:=	.F.
	(c_Alias1)->(dbGoTop())
	If (c_Alias1)->(!Eof()) .And. (c_Alias1)->(!Empty(D2_LOTECTL))
		AADD(a_SZB,	(c_Alias1)->D2_SERIE		)
		AADD(a_SZB,	(c_Alias1)->D2_DOC		)
		AADD(a_SZB,	(c_Alias1)->D2_ITEM		)
		AADD(a_SZB,	(c_Alias1)->D2_COD		)
		AADD(a_SZB,	"N"							)
	Else
		AADD(a_SZB,	c_GSerie		)
		AADD(a_SZB,	c_GDoc			)
		AADD(a_SZB,	c_GItem		)
		AADD(a_SZB,	c_GProd		)
		AADD(a_SZB,	"S"				)
		l_Incons	:=	.T.
	Endif	
	(c_Alias1)->(dbCloseArea())

	l_Grava	:=	.F.
	If l_Incons //inconsistencia
		If MsgYesNo("Lote coletado no codigo de barras nao esta informado na nota fiscal, deseja continuar a gravacao da leitura?","Inconsistencia")
			l_Grava	:=	.T.
		Endif
		
	Else
		l_Grava	:=	.T.
	Endif

	If l_Grava
		O_MDLGSZB:SetValue('ZB_SERIE',a_SZB[1])
		O_MDLGSZB:SetValue('ZB_DOC',a_SZB[2])		
		O_MDLGSZB:SetValue('ZB_ITEM',a_SZB[3])
		O_MDLGSZB:SetValue('ZB_PRODUTO',a_SZB[4])		
		O_MDLGSZB:SetValue('ZB_CODBAR',c_GCodBar)
		O_MDLGSZB:SetValue('ZB_INCONS',a_SZB[5])
		O_MDLGSZB:SetValue('ZB_USR',cUserName)
		O_MDLGSZB:SetValue('ZB_DATA',dDatabase)
		O_MDLGSZB:SetValue('ZB_HORA',time())
		
		O_MDLGSZB:addLine()
		AAdd(a_Lidos				, c_GCodBar + " - " + a_SZB[4] + " - " + POSICIONE("SB1",1,xFILIAL("SB1")+a_SZB[4],"B1_DESC") )
		oLBoxLidos:aItems := a_Lidos		
		oLBoxLidos:Enable()
		dlgrefresh(o_DlgTela)
		SysRefresh()
		
	Else
		l_Ret := .F.

	Endif
	o_GCodBar:SetFocus()
	dlgrefresh(o_DlgTela)
	SysRefresh()
		
Endif

Return(l_Ret)	



Static Function f_Estornar()

Alert("ESTORNO")

Return

/*---------------------------------------------------------------------*
 | Func:  Valida Inclusão/Alteração/Exclusão                           |
 | Autor: Eduardo Arcieri                                              |
 | Data:  07/04/2016                                                   |
 | Desc:                    										   |
 | Obs.:  														       |
 |                                                            		   |
 *---------------------------------------------------------------------*/

Static Function FF100POS( oModel )
Local nOperation := oModel:GetOperation()
Local l_Ret := .T.


Return l_Ret



/*/{Protheus.doc} FF100LPOS
(Validacao de linha no grid)
@type function
@author eduardo.arcieri
@since 18/11/2016
@version 1.0
@param oModelGrid, objeto, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function FF100LPOS(oModel)

Local l_Ret	:=	.T.

Return(l_Ret)



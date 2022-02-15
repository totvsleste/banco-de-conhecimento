//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include "TOPCONN.CH"
#include "vkey.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "XMLCSVCS.CH"

#DEFINE ENTER CHR(13)+CHR(10)

//Variáveis Estáticas
Static cTitulo := "Configurador de Etiquetas"
 
/*/{Protheus.doc} PPCPA100
Função para cadastro de Aprovadores de SC (ZF0), Modelo 1 em MVC
@author Eduardo Arcieri
@since 08/04/2016
@version 1.0
    @return Nil, Função não tem retorno
    @example
    u_PPCPA100()
/*/
 
User Function PPCPA100()
    Local aArea   := GetArea()
    Local oBrowse
     
    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cadastro de aprovadores de SC
    oBrowse:SetAlias("ZF0")
 
    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)
     
    //Legendas
    oBrowse:AddLegend( "ZF0->ZF0_MSBLQL <> '1'", "GREEN", "Ativo" )
    oBrowse:AddLegend( "ZF0->ZF0_MSBLQL == '1'", "RED",   "Inativo" )

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
	ADD OPTION aRot Title 'Visualizar' 	Action 'VIEWDEF.PPCPA100'	OPERATION 2 ACCESS 0
	ADD OPTION aRot Title 'Incluir' 		Action 'VIEWDEF.PPCPA100'	OPERATION 3 ACCESS 0
	ADD OPTION aRot Title 'Alterar' 		Action 'VIEWDEF.PPCPA100'	OPERATION 4 ACCESS 0
	ADD OPTION aRot Title 'Excluir' 		Action 'VIEWDEF.PPCPA100'	OPERATION 5 ACCESS 0
	ADD OPTION aRot Title 'Imprimir' 		Action 'VIEWDEF.PPCPA100'	OPERATION 8 ACCESS 0
	ADD OPTION aRot Title 'Copiar' 			Action 'VIEWDEF.PPCPA100'	OPERATION 9 ACCESS 0
	ADD OPTION aRot TITLE 'Legenda'    	Action 'u_PPC100Leg'     	OPERATION 6 ACCESS 0
	ADD OPTION aRot Title 'Simulacao' 		Action 'u_PP100EXE'			OPERATION 4 ACCESS 0
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
    Local oStZF0 := FWFormStruct(1, "ZF0")
    Local oStZF1 := FWFormStruct(1, "ZF1")
     
    //Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("PP100MD",/*bPre*/, { |oMdl| PP100POS( oMdl ) },/*bCommit*/,/*bCancel*/) 
	     
    //Atribuindo formulários para o modelo
    oModel:AddFields("FORMZF0",/*cOwner*/,oStZF0)
     
    //Adicionando ao modelo um componente de grid.
	oModel:AddGrid( 'FORMZF1', 'FORMZF0', oStZF1 )  
	
	//Adicionando relacionamento entre MASTER E DETALHE
	oModel:SetRelation( 'FORMZF1', { { 'ZF1_FILIAL', 'xFilial( "ZF1" )' }, {'ZF1_PROD', 'ZF0_PROD' }, {'ZF1_SEQ', 'ZF0_SEQ' }  }, ZF1->( IndexKey( 1 ) ) )
	 
    //Setando a chave primária da rotina
    oModel:SetPrimaryKey({'ZF0_FILIAL','ZF0_PROD','ZF0_SEQ'}) //ZF0_FILIAL + ZF0_PROD + ZF0_SEQ
     
    //Validação de linha duplicada
    oModel:GetModel( 'FORMZF1' ):SetUniqueLine( { 'ZF1_FILIAL','ZF1_PROD','ZF1_SEQ','ZF1_ITEM' } )
     
    //Adicionando descrição ao modelo
    oModel:SetDescription("Cadastro de "+cTitulo)
     
    //Setando a descrição do formulário
    oModel:GetModel("FORMZF0"):SetDescription("Cabeçalho")
    oModel:GetModel("FORMZF1"):SetDescription("Detalhe")

	oModel:AddGrid( 'FORMZF1', 'FORMZF0', oStZF1, , { |oModel| PP100LPOS(oModel) } )

    
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
    Local oModel := FWLoadModel("PPCPA100")
     
    //Criação da estrutura de dados utilizada na interface do cadastro de etiquetas - cabecalho
    //Local oStZF0 := FWFormStruct(2, "ZF0")  //pode se usar um terceiro parâmetro para filtrar os campos exibidos { |cCampo| cCampo $ 'ZF0_NOME|ZF0_DTAFAL|'}
    Local oStZF0 := FWFormStruct( 2, 'ZF0' )
    Local oStZF1 := FWFormStruct( 2, 'ZF1' ) 
    
    //Criando oView como nulo
    Local oView := Nil
    
    //Criando a view que será o retorno da função e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formulários para interface
    oView:AddField("VIEW_ZF0", oStZF0, "FORMZF0")
    
    
    //Adicionamos na interface (View) um controle do tipo grid (antiga GetDados), para isso usamos o método AddGrid.
	oView:AddGrid( 'VIEW_ZF1', oStZF1, "FORMZF1" )
    
    //Campo Incremental (AddIncrementField)
    oView:AddIncrementField( 'VIEW_ZF1', 'ZF1_ITEM' )
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA"		,20)
    oView:CreateHorizontalBox("DETALHE"	,80)
     
     
    //Colocando título do formulário
    //oView:EnableTitleView('VIEW_ZF0', 'Dados de '+cTitulo )  
    //oView:EnableTitleView('VIEW_ZF1', 'Sequencia de impressao do '+cTitulo )  
     
    //Força o fechamento da janela na confirmação
    oView:SetCloseOnOk({||.T.})
     
    //O formulário da interface será colocado dentro do container
    //oView:SetOwnerView("VIEW_ZF0","TELA")
    oView:SetOwnerView( 'VIEW_ZF0', 'TELA' )
    oView:SetOwnerView( 'VIEW_ZF1', 'DETALHE' )
    
Return oView
 
/*/{Protheus.doc} PPC100Leg
Função para mostrar a legenda das rotinas MVC com grupo de produtos
@author Eduaro Arcieri
@since 07/04/2016
@version 1.0
    @example
    u_PPC100Leg()
/*/
 
User Function PPC100Leg()
    Local aLegenda := {}
     
    //Monta as cores
    AADD(aLegenda,{"BR_VERDE",      "Ativo"  })
    AADD(aLegenda,{"BR_VERMELHO",   "Inativo"})
     
    BrwLegenda("Configuracao Etiquetas", "Status", aLegenda)
Return

/*---------------------------------------------------------------------*
 | Func:  Valida Inclusão/Alteração/Exclusão                           |
 | Autor: Eduardo Arcieri                                              |
 | Data:  07/04/2016                                                   |
 | Desc:                    										   |
 | Obs.:  														       |
 |                                                            		   |
 *---------------------------------------------------------------------*/

Static Function PP100POS( oModel )
Local nOperation := oModel:GetOperation()
Local l_Ret := .T.

If nOperation == MODEL_OPERATION_INSERT
   If Empty( oModel:GetValue( 'FORMZF0', 'ZF0_PROD' ) )
      	Help( ,, 'HELP',, 'Informe Código do produto', 1, 0)      
      	l_Ret := .F.

   Else
      	c_Prod	:=	oModel:GetValue( 'FORMZF0', 'ZF0_PROD' )
   		If !ExistCpo("SB1", c_Prod)
   			Help( ,, 'HELP',, 'Código do produto nao cadastrado.', 1, 0)
   			l_Ret 	:=	.F.
   		Endif
		
   EndIf
   
   If Empty( oModel:GetValue( 'FORMZF0', 'ZF0_SEQ' ) )
      Help( ,, 'HELP',, 'Informe a sequencia da configuracao da etiqueta', 1, 0)      
      l_Ret := .F.
	
	Else
      c_Prod	:=	oModel:GetValue( 'FORMZF0', 'ZF0_PROD' )
      c_Seq	:=	oModel:GetValue( 'FORMZF0', 'ZF0_SEQ' )
      If !VProdSeq(c_Prod, c_Seq)
      		Help( ,, 'HELP',, 'Produto e Sequencia informado ja existe, por favor informe nova sequencia', 1, 0)
			l_Ret 	:=	.F.
      Endif
      
   EndIf

   If Empty( oModel:GetValue( 'FORMZF0', 'ZF0_DESCRI' ) )
   		Help( ,, 'HELP',, 'Informe uma descricao para esta etiqueta', 1, 0)      
   		l_Ret := .F.

   EndIf


   If Empty( oModel:GetValue( 'FORMZF0', 'ZF0_MODELO' ) )
      	Help( ,, 'HELP',, 'Informe o codigo do modelo configurado da impressora no sistema.', 1, 0)      
      	l_Ret := .F.

	Else
      	c_Modelo:=	oModel:GetValue( 'FORMZF0', 'ZF0_MODELO' )
      	If !ExistCpo("CB5", c_Modelo)
      		Help( ,, 'HELP',, 'codigo do modelo impressora nao cadastrado no sistema.', 1, 0)
      		l_Ret 	:=	.F.
      	Endif

   EndIf

EndIf

Return l_Ret

/*/{Protheus.doc} VProdSeq
(Validacao de Produto e sequencia na ZF0)
@type function
@author carlo
@since 18/11/2016
@version 1.0
@param c_Prod, character, (Descrição do parâmetro)
@param c_Seq, character, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function VProdSeq(c_Prod, c_Seq)
Local l_Ret	:=	.T.

ZF0->(dbSetOrder(1))
If ZF0->(dbSeek(xFilial("ZF0")+Padr(c_Prod,TAMSX3("ZF0_PROD")[1])+Padr(c_Seq,TAMSX3("ZF0_SEQ")[1]),.T.))
	l_Ret := .F.
Endif

Return(l_Ret)


/*/{Protheus.doc} PP100LPOS
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
Static Function PP100LPOS(oModel)

Local l_Ret	:=	.T.

Help( ,, 'HELP',, 'Linha OK', 1, 0)      
l_Ret := .F.


Return(l_Ret)


/*/{Protheus.doc} PP100VAL
(long_description)
@type function
@author Eduardo.Arcieri
@since 16/11/2016
@version 1.0
@param c_Modelo, character, (Modelo de impressora ou codigo de barras)
@param c_Fonte, character, (tamanho da fonte por modelo de impressora)
@param n_Tipo, numérico, (1=Valida modelod e impressora, 2=Valida tamanho da fonte, 3=Valida modelo de codigo de barras)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
User Function PP100VAL(c_Modelo,c_Fonte,n_Tipo)

Local l_Ret := .F.
Local c_Info:= ""

Default c_Modelo		:=	""	
Default c_Fonte		:=	""
Default n_Tipo		:=	0

If n_Tipo == 1 .Or. n_Tipo == 2 .Or. n_Tipo == 3 

	Private 	o_VldModelo	:=  clsEtiquetas():New()
	
	If n_Tipo == 1 //Validar Modelo de inmpressora 
		l_Ret := o_VldModelo:mtdVldModelo(c_Modelo,,1,.F.) 
		If !l_Ret
			c_Info += "Modelo da impressora informado nao esta homologado."
		Endif
	
	ElseIf n_Tipo == 2 //Validar tamanho da fonte por modelo de impressora
		l_Ret := o_VldModelo:mtdVldModelo(c_Modelo,c_Fonte,2,.F.) 
		If !l_Ret
			c_Info += "Tamanho da fonte para o Modelo da impressora informado invalido."
		Endif
	
	ElseIf n_Tipo == 3 //Validar modelo de codigo de barras
		l_Ret := o_VldModelo:mtdVldModelo(c_Modelo,,3,.F.) 
		If !l_Ret
			c_Info += "Modelo do codigo de barras informado invalido."
		Endif
	
	Endif

Endif

If !empty(c_Info)
	msgInfo(c_Info)

Endif

Return(l_Ret)

/*/{Protheus.doc} PP100UF
(Valida a existencia de uma user function)
@type function
@author Eduardo.Arcieri
@since 16/11/2016
@version 1.0
@param c_NomFunc, character, (nome da funcao a ser validada no R P O)
@param l_exibe, logico, informe .T. para exibir mensagens de alerta.
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
User Function PP100UF(c_NomFunc,l_Exibe)

Local l_Ret := .F.
Local c_Info:= ""

Private 	o_VldUsrFunc	:=  clsEtiquetas():New()

l_Ret := o_VldUsrFunc:mtdVldFunc(c_NomFunc,.F.) 

If !l_Ret
	c_Info += "Funcao "+c_NomFunc+" nao esta compilada no repositorio."
	If l_Exibe
		msgInfo(c_Info)
	Endif
Endif

Return(l_Ret)



/*/{Protheus.doc} PP100EXE
(Responsavel pela execucao das configuracoes da etiqueta)
@type function
@author Eduardo.arcieri
@since 17/11/2016
@version 1.0
@param c_Produto, character, (informe codigo do produto)
@param c_Seq, character, (informe sequencia a ser executada da etiqueta configurada)
@param l_exibe, logico, informe .T. para exibir mensagens de alerta.
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
user Function PP100EXE() //(c_Produto,c_Seq, l_Exibe)
Local l_Ret 		:= 	.F.
Local l_RetImagem	:=	.F.
Local c_Info		:= 	""

Local c_Produto	:=	ZF0->ZF0_PROD
Local c_Seq		:=	ZF0->ZF0_SEQ
local l_Exibe	:=	.F.

ZF0->(dbSetOrder(1))
l_Ret := ZF0->(dbSeek(xFilial("ZF0")+Padr(c_Produto,TamSx3("ZF0_PROD")[1])+Padr(c_Seq,TamSx3("ZF0_SEQ")[1]),.T.))

If l_Ret
	l_Ret	:=	ZF0->ZF0_MSBLQL <> "1"
	
	If l_Ret
	
		Private o_Etiq	:=  clsEtiquetas():New() //Instaciando classe 
		l_Ret := o_Etiq:mtdPrinter(ZF0->ZF0_MODELO, ZF0->ZF0_DENSID, ZF0->ZF0_TAM, .F.)
	
		If 	l_Ret
			ZF1->(dbsetorder(1))
			l_Ret := ZF1->(dbSeek(xFilial("ZF1")+Padr(c_Produto,TamSx3("ZF1_PROD")[1])+Padr(c_Seq,TamSx3("ZF1_SEQ")[1]),.T.))
			
			If l_Ret
				//1a passagem para carregar imagens ou graficos para impressora, se houverem					
				While	ZF1->(!Eof()) 					.And.;
						ZF1->ZF1_PROD		== 	c_Produto 	.And.;
						ZF1->ZF1_SEQ		==	c_Seq		

						If ZF1->ZF1_IDENT == "I" //Imagem
							//Metodo Method mtdLoadGraf(c_Imagem,l_Exibe) 
							If !empty(ZF1->ZF1_PASTA+ZF1->ZF1_ARQ)
								c_Imagem		:=	Alltrim(ZF1->ZF1_PASTA)+Alltrim(ZF1->ZF1_ARQ)
								l_RetImagem 	:= o_Etiq:mtdLoadGraf(c_Imagem,l_Exibe)
								aFiles := {} // O array receberá os nomes dos arquivos e do diretório
  								aSizes := {} // O array receberá os tamanhos dos arquivos e do diretorio
  								//Local nX
  								ADir(c_Imagem, aFiles, aSizes)
  								
							Endif
						Endif
						ZF1->(dbSkip())
				Enddo 

					
				l_Ret := o_Etiq:mtdBegin(ZF0->ZF0_COPIAS, ZF0->ZF0_VELOC, ZF0->ZF0_TAM, .F., .F.) //iniciando etiqueta	
		
				If l_Ret
					
					ZF1->(dbgotop())
					ZF1->(dbSeek(xFilial("ZF1")+Padr(c_Produto,TamSx3("ZF1_PROD")[1])+Padr(c_Seq,TamSx3("ZF1_SEQ")[1]),.T.))
					
					While	ZF1->(!Eof()) 					.And.;
							ZF1->ZF1_PROD		== 	c_Produto 	.And.;
							ZF1->ZF1_SEQ		==	c_Seq		
						
							If 	ZF1->ZF1_IDENT == "I" //Imagem
								//Metoto Method mtdGraphic(n_LSEmm, n_CSEmm, c_Arquivo,l_Exibe) 
								
								o_Etiq:mtdGraphic(ZF1->ZF1_LSE, ZF1->ZF1_CSE, Alltrim(ZF1->ZF1_ARQ),l_Exibe)

							//T=Texto;I=Imagem;B=Box;C=Codigo Barras;W=Conteudo Nativo Impressora                                                             
							ElseIf	ZF1->ZF1_IDENT == "T" //Texto
								//metodo mtdPsay(c_ImpCod, n_LSEmm, n_CSEmm, c_Texto, c_Rotacao, c_Fonte, c_Tam, l_Exibe)						
								
								l_RetFunc := Iif(!empty(ZF1->ZF1_FUNCAO),o_Etiq:mtdVldFunc(ZF1->ZF1_FUNCAO, l_Exibe),.F.) 
								
								If 	l_RetFunc
									c_Texto	:=	EXECBLOCK("U_"+ZF1->ZF1_FUNCAO,.F.,.F.)
								ElseIf !Empty(ZF1->ZF1_FORMULA)
									c_Texto	:= Formula(ZF1->ZF1_FORMULA)
								Else
									c_Texto	:=	ZF1->ZF1_TEXTO
								Endif
								
								c_Texto	:=	"^FD"+c_Texto+"^FS"
								
								o_Etiq:mtdPsay(ZF0->ZF0_MODELO, ZF1->ZF1_LSE/100, ZF1->ZF1_CSE/100, c_Texto, ZF1->ZF1_ROT, ZF1->ZF1_TFONT, alltrim(str(ZF1->ZF1_ALTURA))+","+Alltrim(str(ZF1->ZF1_LARG)) , l_Exibe)
								
							ElseIf ZF1->ZF1_IDENT == "B" //Box ou Linha
								//Metodo mtdPbox(n_LSEmm, n_CSEmm, n_LIDmm, n_CIDmm, n_Espessura, c_Cor,l_Exibe)
								o_Etiq:mtdPbox(ZF1->ZF1_LSE/100, ZF1->ZF1_CSE/100, ZF1->ZF1_LID/100, ZF1->ZF1_CID/100, ZF1->ZF1_ESP, ZF1->ZF1_CORBOX, l_Exibe)
								
							ElseIf ZF1->ZF1_IDENT == "W" //Conteudo Nativo Impressora
								//Metodo mtdWrite(c_texto,l_Exibe)
								l_RetFunc := Iif(!empty(ZF1->ZF1_FUNCAO),o_Etiq:mtdVldFunc(ZF1->ZF1_FUNCAO, l_Exibe),.F.) 
								c_Linmm := Alltrim(Str(ZF1->ZF1_LSE))
								c_Colmm := Alltrim(Str(ZF1->ZF1_CSE))
								c_Coord := c_Colmm+','+c_Linmm
								If 	l_RetFunc
									c_Texto	:=	EXECBLOCK(ZF1->ZF1_FUNCAO,.F.,.F.)//EXECBLOCK("U_"+ZF1->ZF1_FUNCAO,.F.,.F.)
									c_Texto	:=	"^FO"+c_Coord+"^"+c_Texto+"^FS"
								Else
									c_Texto	:=	"^FO"+c_Coord+"^"+ZF1->ZF1_TEXTO+"^FS"
								Endif
								
								o_Etiq:mtdWrite(c_texto,l_Exibe)
							Endif
							
							ZF1->(dbSkip())
					Enddo 
							
					MSCBEND() //encerrando etiqueta
				Else
					c_Info+= "Etiqueta nao inicializada, verifique se a Impressora esta preparada, verifique se ela esta devidamente conectada e com a porta de conexao mapeada."
				
				Endif
			
			Else
				c_Info+= "Nao foram encontradas linhas detalhe na configuracao da etiqueta ref. ao Produto e sequencia informada. Operacao abortada."
				
			Endif
	
			MSCBCLOSEPRINTER() //Fechando impressora
		
		Else
			c_Info+= "Impressora não preparada, verifique se ela esta devidamente conectada e com a porta de conexao mapeada."
	
		Endif
	
	Else
		c_Info+= "Registro bloqueado, favor verificar no cadastro de configurações de etiquetas"		
	
	Endif
Else
	c_Info+= "Produto e sequencia informada nao foi localizado, por favor verifique o cadastro de configuracoes de etiquetas."

Endif

If !empty(c_Info) .And. l_Exibe
	msgInfo(c_Info)

Endif
			
Return(l_Ret)



USER FUNCTION FF100IMG()

RETURN("^GFA,175,175,5,,:I07FE,I07FF8,001IFE,:001JF,007JF,:::001JF,001E79F,001870E,0018706,001878E,020C78E2,038F8FE6,03E787878,07FF879F8,001FFDF,I06FDE,I02798,I0201,I0203,I07878,01FDIFE,01F9FC7E,00EJ0C,008J04,:,:::")


Static function tstpost()
Local cUrl := "http://www.google.com"
Local nTimeOut := 120
Local aHeadOut := {}
Local cHeadRet := ""
Local sPostRet := ""
aadd(aHeadOut,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
aadd(aHeadOut,'Content-Type: application/x-www-form-urlencoded')
sPostRet := HttpPost(cUrl,"REQUEST=1212","EXAMPLEFIELD=DUMMY",nTimeOut,aHeadOut,@cHeadRet)
if !empty(sPostRet)
  conout("HttpPost Ok")
  varinfo("WebPage", sPostRet)
else
  conout("HttpPost Failed.")
  varinfo("Header", cHeadRet)
Endif
Return
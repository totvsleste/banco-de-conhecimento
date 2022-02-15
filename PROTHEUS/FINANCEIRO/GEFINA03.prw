#INCLUDE "TOTVS.CH"
#INCLUDE "FWMVCDEF.CH"

#DEFINE CRLF CHR(13)+CHR(10)
#DEFINE CSSBOTAO	"QPushButton { color: #024670; "+;
"    border-image: url(rpo:fwstd_btn_nml.png) 3 3 3 3 stretch; "+;
"    border-top-width: 3px; "+;
"    border-left-width: 3px; "+;
"    border-right-width: 3px; "+;
"    border-bottom-width: 3px }"+;
"QPushButton:pressed {	color: #FFFFFF; "+;
"    border-image: url(rpo:fwstd_btn_prd.png) 3 3 3 3 stretch; "+;
"    border-top-width: 3px; "+;
"    border-left-width: 3px; "+;
"    border-right-width: 3px; "+;
"    border-bottom-width: 3px }"
Static cArqSZH  // Arquivo temporario do MultiNaturezas por C.Custo

// -------------------------------------------------------------------------------------
/*/{Protheus.doc} GEFINA03
Solicitações de Pagamento Manual
@param: Nil
@author: MBarros
@since: 06/12/2016
@Obs: Solicitacao Pagamento Manual A Geradora
@type function
/*/

// -------------------------------------------------------------------------------------

USER Function GEFINA03()

Local oBrowse := Nil

Private aRotina := MenuDef()
PRIVATE cCadastro := "Solicitaçoes Pagamento Manual"

If Type("aColsSZG") != "A" .Or. Type("aHeaderSZG") != "A"
	PRIVATE aColsSZG	:= {} // Utilizada em MultNat2 e GrvSZGSZH
	PRIVATE aHeaderSZG  := {} // Utilizada em MultNat2 e GrvSZGSZH
Endif

if ! AliasIndic("SZF")
	Aviso("Atencao","`Para uso desta rotina deverá ser executado o Update da Tabela SZF - U_GEFINU03")
	Return .F.
Endif

oBrowse := FWMBrowse():New()
oBrowse:SetAlias('SZF')
oBrowse:SetDescription( cCadastro )

// Adiciona legendas
oBrowse:AddLegend( "ZF_STATUS=='1'", "BLUE" , "Em Aprovação")
oBrowse:AddLegend( "ZF_STATUS=='2'", "GREEN"  , "Aprovado")
oBrowse:AddLegend( "ZF_STATUS=='3'", "BLACK" , "Rejeitado")
oBrowse:AddLegend( "ZF_STATUS=='4'", "YELLOW", "PA Aprovado")
oBrowse:AddLegend( "ZF_STATUS=='5'", "GRAY"  , "PA Rejeitado")
oBrowse:AddLegend( "ZF_STATUS=='6'", "ORANGE", "PA Gerado")
oBrowse:AddLegend( "ZF_STATUS=='7'", "RED"   , "Cancelado")
//1=Em aprovação; 2=Aprovado; 3=Rejeitado; 4=PA Aprovado; 5=PA Rejeitado; 6=PA gerado; 7=Cancelado

oBrowse:Activate()

Return
// -------------------------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
Menu Padrao da Rotina Solicitação Pagamento Manual
@param: Nil
@author: MBarros
@since: 01/07/2016
@Obs: Solicitacao Pagamento Manual A Geradora
@type function
/*/
// -------------------------------------------------------------------------------------
Static Function MenuDef()

Local aRotina := {}

ADD OPTION aRotina TITLE "Pesquisar"    ACTION 'PesqBrw' 	      OPERATION 1 ACCESS 0
ADD OPTION aRotina Title "Visualizar"	ACTION 'VIEWDEF.GEFINA03' OPERATION 2 ACCESS 0
ADD OPTION aRotina Title "Incluir"	    ACTION 'VIEWDEF.GEFINA03' OPERATION 3 ACCESS 0
ADD OPTION aRotina Title "Gerar PA"		ACTION 'U_GFin03GPA'      OPERATION 4 ACCESS 0
ADD OPTION aRotina Title "Excluir"   	ACTION 'VIEWDEF.GEFINA03' OPERATION 5 ACCESS 0
ADD OPTION aRotina Title "Conhecimento"	ACTION 'MsDocument' 	  OPERATION 6 ACCESS 0

Return aRotina
// -------------------------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Modelo de Dados do Cadastro de Solicitacao Pagamento
@param: Nil
@author: MBarros
@since: 01/07/2016
@Obs: Solicitacao Pagamento Manual A Geradora
@type function
/*/
// -------------------------------------------------------------------------------------
Static Function ModelDef()

Local oModel   	:= Nil
Local oStruSZF 	:= FwFormStruct( 1, "SZF" ) //Solicitação Pagamento Manual

// Instancia o modelo de dados
oModel := MpFormModel():New( "U_GEFINA03",/*bPre*/,/*bPos*/, { |oMdl| GFin03Grv( oMdl ) }/*bCommit*/,/*bCancel*/ )

// Adiciona estrutura do cabecallho no modelo de dados
oModel:AddFields("SZFMASTER", /*cOwner*/, oStruSZF ,  , )

oModel:SetDescription( "Solicitação Pagamentos Manual" )

oModel:GetModel("SZFMASTER"):SetDescription( "Solicitação Pagamentos Manual" )

Return oModel
// -------------------------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Interface do Cadastro de Solicitação Pagamentos Manual

@param: Nil
@author: MBarros
@since: 01/07/2016
@Obs: Solicitacao Pagamento Manual A Geradora
@type function
/*/
// -------------------------------------------------------------------------------------
Static Function ViewDef()

Local oView		:= Nil
Local oModel	:= FwLoadModel( "GEFINA03" )
Local oStruSZF 	:= FwFormStruct( 2, "SZF" ) // Cadastro Solicitação Pagamentos Manual


//For nIxb := 1 To Len(oStruSZF:AFIELDS)
//    oStruSZF:aFields[nIxb,10] := .F.  // Nao Permite Edicao dos Campos
//Next    

// Instancia a View
oView := FwFormView():New()
// Seta o model
oView:SetModel( oModel )
// Adiciona os campos na estrutura da View
oView:AddField( 'VIEW_SZF', oStruSZF, 'SZFMASTER' )
// Cria o Box
oView:CreateHorizontalBox( 'TELA', 100 )
// Seta Owner
oView:SetOwnerView( 'VIEW_SZF', 'TELA' )


//oView:SetOnlyView('VIEW_SZF')  //comando para tela view ser sempre visual

// Adiciona Botão
oView:AddUserButton("Rateio Naturezas","",{|oView| IIf( (GETMV("MV_MULNATP") .And. IIF(INCLUI,M->ZF_MULTNAT == "1", SZF->ZF_MULTNAT == "1") .AND. M->ZF_TIPOSOL=="CAP" ),GE03MultNat("SZF",2,0,.F.,,,.T.),Alert("Nao Informado Multi Naturezas."))},NIL,NIL,{MODEL_OPERATION_VIEW})
oView:AddUserButton("Aprovacao","",{|oView| G03Posic("SZF",SZF->(Recno()),2,"SP",.F./*lStaus*/,/*lResid*/)},NIL,NIL,{MODEL_OPERATION_VIEW})

Return oView
// -------------------------------------------------------------------------------------
/*/{Protheus.doc} GatForn
Funcao da regra dos gatilhos do campo ZF_FORNECE.
@param: Nil
@author: MBarros
@since: 06/12/2016
@Obs: Solicitacao Pagamento Manual A Geradora
@type function
/*/
User Function GatForn(cDomin)

Local cRet

If cDomin == "ZF_NOMFOR"
	If SA2->(A2_COD) == M->(ZF_FORNECE)// .and. !Empty(M->E2_LOJA)
		cRet := SA2->A2_NOME
	Else
		cRet := Posicione("SA2", 1, xFilial("SA2")+M->ZF_FORNECE , "SA2->A2_NOME" )
	EndIf
ElseIf cDomin == "ZF_LOJA"
	cRet := SA2->A2_LOJA
EndIf

Return cRet
// -------------------------------------------------------------------------------------
/*/{Protheus.doc} GFin03Num()
Validacao dos dados do fornecedor
@param: Nil
@author: MBarros
@since: 06/12/2016
@Obs: Solicitacao Pagamento Manual A Geradora
@type function
/*/
User Function GFin03Num()

LOCAL lRetorna  := .T., nOrder, cAlias
LOCAL nRecNo	 := SZF->(RecNo())
Local cChaveSZF := ""
Local lInclTit	:= IIF(TYPE("INCLUI")<>"U",INCLUI,.F.)
Local aAreaAtu  := GetArea()

cChaveSZF := "'"+xFilial("SZF")+"'+M->ZF_NUMSOL"

nOrder := IndexOrd()
cAlias := Alias()

If (!Empty(M->ZF_FORNECE) .And. !Empty(M->ZF_LOJA))
	
	dbSelectArea("SA2")
	dbSetOrder(1)
	If dbSeek(xFilial()+M->ZF_FORNECE+M->ZF_LOJA,.T.)
		If M->ZF_LOJA != SA2->A2_LOJA .And. !Empty(M->ZF_LOJA)
			Help("Fornecedor + Loja invalido",1,"GEFINA03")
			lRetorna := .F.
		EndIf
	Else
		// Limpa o codigo da loja, se estiver editando o codigo do fornecededor e
		// a loja estiver preenchida. Isto ocorre qdo. o usu rio volta ao campo
		// com a seta.
		IF !EMPTY(M->ZF_LOJA) .AND. "ZF_FORNECE" $ READVAR()
			M->ZF_LOJA := SPACE(LEN(M->ZF_LOJA))
		ENDIF
		dbSeek(xFilial()+M->ZF_FORNECE+M->ZF_LOJA,.T.)
		If M->ZF_LOJA != SA2->A2_LOJA .And. !Empty(M->ZF_LOJA)
			Help("Fornecedor + Loja invalido",1,"GEFINA03")
			lRetorna := .F.
		EndIf
	EndIf
Endif

If lRetorna .AND. SA2->A2_MSBLQL == "1" .And. M->ZF_FORNECE == SA2->A2_COD .And. M->ZF_LOJA == SA2->A2_LOJA
	HELP(" ",1,"REGBLOQ")
	lRetorna := .F.
Endif

If ! Empty(M->ZF_NUMSOL)
	SZF->(dbSetOrder(1))
	If SZF->(dbSeek(&cChaveSZF))
		If (INCLUI)
			Help("Solicitação existente para esta numeração, por favor verifique.",1,"GEFINA03")
			lRetorna := .F.
		Endif
	EndIf
EndIf
RestArea(aAreaAtu)
Return lRetorna
// -------------------------------------------------------------------------------------
/*/{Protheus.doc} GFin03GPA()
Geração de PA para Solicitacoes Aprovadas 
@param: Nil
@author: MBarros
@since: 06/12/2016
@Obs: Solicitacao Pagamento Manual A Geradora
@type function
/*/
User Function GFin03GPA()

Local aAreaAtu := GetArea()   
Local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,"Cancelar"},{.T.,"Gerar PA"},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}
Local oView    := NIL

IF ! RetCodUsr() $ GetMV("GE_EXCLSOL",.F.,"000000") 
   Aviso("Atencao","Usuario nao Autorizado a efetuar a Geração de PA",{"Retornar"},3,"GE_EXCLSOL-Parametro Usr.Autorizados")
   RestArea(aAreaAtu)
   Return
ENDIF
   
/*
Observações
VERSAO 11
O array aEnableButtons tem por padrão 14 posições:
1 - Copiar
2 - Recortar
3 - Colar
4 - Calculadora
5 - Spool
6 - Imprimir
7 - Confirmar
8 - Cancelar
9 - WalkTrhough
10 - Ambiente
11 - Mashup
12 - Help
13 - Formulário HTML
14 - ECM
*/

IF SZF->ZF_STATUS == "4"
    //oView := FwLoadView( "GEFINA03" )
    //oView:SetOnlyView('VIEW_SZF')  //comando para tela view ser sempre visual
	nOpcPA := 0
	FWExecView("Geração de Titulos PA para Solicitação de Pagamento Aprovada", "GEFINA03", MODEL_OPERATION_VIEW,/*oDlg*/ ,/*bCloseOnOK*/ ,   /*bOk*/ ,/*nPercReducao*/ ,aButtons/*aEnableButtons*/ , {|| nOpcPA := Aviso("Atencao","Confirma a Geracao do PA?",{"Sim","Nao"},3,"Gerar PA")} /*bCancel*/ , "006",/*cToolBar*/,/*oModelAct*/)//"Superior"
    IF nOpcPa == 1
       G03GeraPA()
    Endif   
ELSE
	AVISO("Atencao","Somente Solicitacao Tipo PA com Status Liberado pode ser gerado.",{"Retornar"},3,"GERACAO PA")
ENDIF

lGeraPA := .F.
RestArea(aAreaAtu)
Return
// -------------------------------------------------------------------------------------
/*/{Protheus.doc} G03GeraPA()
Geração de PA para Solicitacoes Aprovadas 
@param: Nil
@author: MBarros
@since: 06/12/2016
@Obs: Solicitacao Pagamento Manual A Geradora
@type function
/*/
Static Function G03GeraPA()
                                          
Local aAreaAtu := GetArea()
Local aRotAuto := {}
Local cPrefixo := ""
Local cParcela := ""                                
Local cNumTit  := ""

Private lMsErroAuto  := .F.
Private lMsHelpAuto  := .T.
Private lMostraErro  := .F.

PRIVATE cBancoAdt	:= CriaVar("A6_COD")
PRIVATE cAgenciaAdt	:= CriaVar("A6_AGENCIA")
PRIVATE cNumCon	 	:= CriaVar("A6_NUMCON")
PRIVATE nMoedAdt	:= CriaVar("A6_MOEDA")
PRIVATE cChequeAdt	:= CriaVar("EF_NUM")
PRIVATE cHistor		:= CriaVar("EF_HIST")
PRIVATE cBenef		:= CriaVar("EF_BENEF")
PRIVATE cPictHist   := "@!"

Pergunte("FIN050",.F.) 
Fa050DigPa(/*cTitulo*/,1,.F.)
IF Aviso("Atencao","Deseja efetuar a Geração do PA para esta Solicitação de Pagamento?"+Chr(13)+Chr(10)+"Banco: "+cBancoAdt+Chr(13)+Chr(10)+"Agencia: "+cAgenciaAdt+Chr(13)+Chr(10)+"Conta: "+cNumCon+IIF(!Empty(cChequeAdt),Chr(13)+Chr(10)+"Cheque: "+cChequeAdt,"")+IIF(!Empty(cHistor),Chr(13)+Chr(10)+"Hitorico: "+cHistor,"")+IIF(!Empty(cBenef),Chr(13)+Chr(10)+"Beneficiario: "+cBenef,""),{"Sim","Nao"},3,"Gera PA Solicitação: "+SZF->ZF_NUMSOL)==1
	
	lMsErroAuto := .F.
	
	cPrefixo := GetMV("GE_PREFSCP",.F.,"CAP")
	cParcela := "1" 
	cNumTit	:= ProxTitulo("SE2",cPrefixo)
 	dDtVenc := IIF(dDataBase > SZF->ZF_VENCTO, dDataBase, SZF->ZF_VENCTO)
	aAdd(aRotAuto,{ "E2_FILIAL"	, xFilial("SE2")		, Nil })
	aAdd(aRotAuto,{ "E2_PREFIXO", cPrefixo              , Nil })
	aAdd(aRotAuto,{ "E2_NUM"	, cNumTit		     	,Nil })
	aAdd(aRotAuto,{ "E2_PARCELA", cParcela              , Nil })
	aAdd(aRotAuto,{ "E2_TIPO"	, SZF->ZF_TIPO         	, Nil })
	aAdd(aRotAuto,{ "E2_NATUREZ", IIF(!Empty(SZF->ZF_NATUREZ),SZF->ZF_NATUREZ,Posicione("SA2",1,xFilial("SA2")+SZF->ZF_FORNECE+SZF->ZF_LOJA,"A2_NATUREZ")), Nil })
	aAdd(aRotAuto,{ "E2_FORNECE", SZF->ZF_FORNECE 		, Nil })
	aAdd(aRotAuto,{ "E2_LOJA"   , SZF->ZF_LOJA			, Nil })
	aAdd(aRotAuto,{ "E2_VLCRUZ" , SZF->ZF_VALOR         , Nil })
	aAdd(aRotAuto,{ "E2_VALOR"  , SZF->ZF_VALOR			, Nil })
	aAdd(aRotAuto,{ "E2_LINDIG"  ,SZF->ZF_LINDIG		, Nil })
	aAdd(aRotAuto,{ "E2_CODBAR"  ,SZF->ZF_CODBAR		, Nil })
	aAdd(aRotAuto,{ "E2_MOEDA"	, IIF(! EMPTY(nMoedAdt),nMoedAdt,1),Nil })
	aAdd(aRotAuto,{ "E2_EMIS1"  , dDatabase			, Nil }) 
	aAdd(aRotAuto,{ "E2_EMISSAO", dDatabase   , Nil }) //aAdd(aRotAuto,{ "E2_EMISSAO", SZF->ZF_DATASOL   , Nil })
	aAdd(aRotAuto,{ "E2_VENCORI", IIF(dDtVenc < dDatabase, dDatabase, dDtVenc) 	, Nil })
	//aAdd(aRotAuto,{ "E2_HIST"   , IIF(! EMPTY(cHistor),cHistor,"SOLICITACAO PGTO: "+SZF->ZF_NUMSOL), Nil })
	aAdd(aRotAuto,{ "E2_ORIGEM" , "FINA050"				, Nil })
	aAdd(aRotAuto,{ "E2_VENCTO"	, IIF(dDtVenc < dDatabase, dDatabase, dDtVenc)  					, Nil })
	aAdd(aRotAuto,{ "E2_NOMFOR" , cBenef					, Nil })
	AADD(aRotAuto,{ "E2_CCUSTO"	, SZF->ZF_CCUSTO			, Nil })
	AADD(aRotAuto,{ "E2_CLVL"   , SZF->ZF_CLVL 				, Nil })
	AADD(aRotAuto,{ "E2_HIST"   , Substr(SZF->ZF_HIST,1,TamSX3("E2_HIST")[1]) 				, Nil })
	AADD(aRotAuto,{ "E2_XOBS"   , SZF->ZF_HIST 				, Nil })
	aAdd(aRotAuto,{ "AUTBANCO" 	, cBancoAdt      			, Nil })
	aAdd(aRotAuto,{ "AUTAGENCIA", cAgenciaAdt 				, Nil })
	aAdd(aRotAuto,{ "AUTCONTA" 	, cNumCon	  	   			, Nil })
	AADD(aRotAuto,{ "AUTCHEQUE" , cChequeAdt        		, Nil })
	IF SE2->(FieldPos("E2_XNUMSOL")) > 0
		AADD(aRotAuto,{ "E2_XNUMSOL", SZF->ZF_NUMSOL        , Nil })
	ENDIF                                                  
	
	MSExecAuto({|x, y| FINA050(x, y)}, aRotAuto, 3)
	
	//Em caso de erro na baixa desarma a transacao
	If lMsErroAuto
		MOSTRAERRO() // Sempre que o micro comeca a apitar esta ocorrendo um erro desta forma
	Else
		RecLock("SZF",.F.)
		SZF->ZF_STATUS  := "6"
        SZF->ZF_DTGERCP := dDataBase
        SZF->ZF_PREFIXO := cPrefixo
        SZF->ZF_PARCELA := cParcela
        SZF->ZF_NUM     := cNumTit
        SZF->ZF_HRINC	:= Substr(Time(),1,5)
		SZF->(MsUnLock())
	Endif
	
ENDIF

RestArea(aAreaAtu)
Return .T.
// -------------------------------------------------------------------------------------
/*/{Protheus.doc} GFin03Grv()
Grava Controle de Alçadas
@param: Nil
@author: MBarros
@since: 06/12/2016
@Obs: Solicitacao Pagamento Manual A Geradora
@type function
/*/
Static Function GFin03Grv(oModel)

Local aAreaAtu := GetArea()
Local cUsrLog  := ""

IF oModel:GetOperation() == 5 
	If !(M->ZF_STATUS $ "1/4")
   		Aviso("Atencao","Somente é permitido a Exclusão de Solicitações com Status em 1=Em Aprovação ou 4-PA Aprovado.",{"Retornar"},3,"Exclusão Inválida")
   		Return .F.
   	EndIf
   	cUsrLog  := RetCodUsr()
   	IF !cUsrLog $ GetMV("GE_EXCLSOL",.F.,"000000") .and. !(M->ZF_USER == cUsrLog )
   		Aviso("Atencao","Usuario nao Autorizado a excluir esta Solicitação",{"Retornar"},3,"Apenas o usuario que inseriu ou usuarios do parametro GE_EXCLSOL-Usr.Autorizados podem excluir a solicitação.")
   		Return .F.
	ENDIF
   	
ENDIF

// Apresenta tela de Rateio antes de Abrir a Transação...
If (GETMV("MV_MULNATP") .And. M->ZF_MULTNAT == "1" .AND. M->ZF_TIPOSOL=="CAP") .AND. oModel:GetOperation() == 3
	GE03MultNat("SZF",3,0,.F.,,,.T.)
Endif

BEGIN TRANSACTION
If FWFormCommit(oModel)
	If (INCLUI)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Cria alcada de aprovacao da SC ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lBloqSC := GE03EntCtb("SZF","SZH",SZF->ZF_NUMSOL,"SP",{}/*aHeader*/,{}/*aCols*/,{}/*aHeadSCX*/,{}/*aColsSCX*/,1,dDataBase)
        IF ! lBloqSC  // se nao gerou alçadas, Libero o Documento...
           IF SZF->ZF_TIPOSOL == "CAP"
              U_GeraCap()  // Gera Titulo a Pagar
           ELSE
              RecLock("SZF",.F.)
              SZF->ZF_STATUS := "4"  // Libera PA
              MsUnLock()
           ENDIF
		ELSE
			//Envia processo para o WorkFlow
			MTSoliCAT("SP",SZF->ZF_NUMSOL,"SZF", "ZF_NUMSOL")
	    ENDIF
	EndIf
	// Grava dados de rateio
	If (GETMV("MV_MULNATP") .And. M->ZF_MULTNAT == "1" .AND. M->ZF_TIPOSOL=="CAP") 
	    IF oModel:GetOperation() == 3   // Inclusao
		   GRVSZGSZH("SZF", aColsSZG, aHeaderSZG, M->ZF_VALOR )
		Elseif oModel:GetOperation() == 5  // Exclusão
		   SZG->(DbSetOrder(1))
           SZG->(MsSeek(xFilial("SZG")+SZF->ZF_NUMSOL+SZF->ZF_TIPO+SZF->ZF_FORNECE+SZF->ZF_LOJA,.F.))   		   
		   While ! SZG->(Eof()) .AND. xFilial("SZG")+SZF->ZF_NUMSOL+SZF->ZF_TIPO+SZF->ZF_FORNECE+SZF->ZF_LOJA == SZG->ZG_FILIAL+SZG->ZG_NUM+SZG->ZG_TIPO+SZG->ZG_CLIFOR+SZG->ZG_LOJA
		       RecLock("SZG",.F.)
		       SZG->(DbDelete())
		       SZG->(MsUnLock())
		       SZG->(DbSkip(+1))
		   END    
		   SZH->(DbSetOrder(1))
           SZH->(MsSeek(xFilial("SZH")+SZF->ZF_NUMSOL+SZF->ZF_TIPO+SZF->ZF_FORNECE+SZF->ZF_LOJA,.F.))   		   
		   While ! SZH->(Eof()) .AND. xFilial("SZH")+SZF->ZF_NUMSOL+SZF->ZF_TIPO+SZF->ZF_FORNECE+SZF->ZF_LOJA == SZH->ZH_FILIAL+SZH->ZH_NUM+SZH->ZH_TIPO+SZH->ZH_CLIFOR+SZH->ZH_LOJA
		       RecLock("SZH",.F.)
		       SZH->(DbDelete())
		       SZH->(MsUnLock())
		       SZH->(DbSkip(+1))
		   END    
		Endif
	Endif
    IF oModel:GetOperation() == 5	
	   MaEstAlcEC(PADR(SZF->ZF_NUMSOL,Len(SCR->CR_NUM)),"SP",SZF->ZF_DATASOL)
    ENDIF
Endif
END TRANSACTION

RestArea(aAreaAtu)
Return .T.
//-------------------------------------------------------------------
/*/{Protheus.doc} MaEstAlcEC
Funcao utilizada para estornar a liberacao do documento

@author Leandro.Moura
@since 28/08/2013
@version 1.0

@param cDoc, Caracter, Documento
@param cTpDoc, Caracter, Tipo do Documento
@param dDtDoc, Data, Data do Documento

/*/
//-------------------------------------------------------------------
Static Function MaEstAlcEC(cDocto,cTpDoc,dDtDoc)

Local aEstDoc	:= {}
Local aArea		:= GetArea()
Local cGrpApv	:= ""

BeginSQL Alias "TMPSCR"

	SELECT SCR.CR_NUM AS DOC, SCR.CR_TOTAL AS VLRDOC, SCR.CR_GRUPO AS GRPAPV
	FROM %Table:SCR% SCR
	WHERE SCR.%NotDel% AND	
		SCR.CR_FILIAL = %xFilial:SCR% AND
		SCR.CR_NUM = %Exp:cDocto% AND
		SCR.CR_TIPO = %Exp:cTpDoc% AND
		SCR.CR_EMISSAO = %Exp:DtoS(dDtDoc)%
	GROUP BY SCR.CR_NUM,SCR.CR_TOTAL,SCR.CR_GRUPO

EndSQL

While TMPSCR->(!EOF())

	cGrpApv := TMPSCR->GRPAPV

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta array para estorno do documento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aEstDoc := { TMPSCR->DOC		,; 		// Num. Documento
	  			  cTpDoc				,; 		// Tipo Doc.
				  TMPSCR->VLRDOC   	,; 		// Valor aprovac.
				  						,;		// Aprovador
				  						,;		// Cod. Usuario
				  cGrpApv				,;		// Grupo Aprovac.
				  						,;		// Aprov. Superior
	              					,;		// Moeda Docto
	              					,;		// Taxa da moeda
	              dDtDoc				}		// Data Emissao
	              						
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Chama rotina para estorno ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MaAlcDoc(aEstDoc,,3)
	
	TMPSCR->(dbSkip())
End

TMPSCR->(dbCloseArea())

RestArea(aArea)
Return
//-------------------------------------------------------------------
/*{Protheus.doc} GE03EntCtb()
Funcao utilizada para gerar a alcada de aprovacao por itens aglutinados por Entidade Ctb. e valor.
@author Leandro.Moura
@since 28/08/2013
@version 1.0
cAlias,cAlsRat,cDocto,cTpDoc,aHeader,aCols,aHeadRat,aColsRat,nOpcao,dDtDoc
@param cAlias Alias da tabela.
@param cAlsRat Alias da tabela de rateio
@param cDoc Documento
@param cTpDoc Tipo de documento na SCR
@param aHeader aHeader da rotina
@param aCols aCols da rotina
@param aHeadRat aHeader da rotina de rateio
@param aColsRat aCols da rotina de rateio
@param nOpcao Inclusao, Alteracao, Exclusao, Rejeição
@param dDtDoc Data do documento
@return lGerouApv
/*/
//-------------------------------------------------------------------

Static Function GE03EntCtb(cAlias,cAlsRat,cDocto,cTpDoc,aHeader,aCols,aHeadRat,aColsRat,nOpcao,dDtDoc)

Local oModel        := Nil
Local aItens          := {}
Local aAglut        := {}
Local aEntCtb        := {}
Local aAlcDoc        := {}
Local aGrpAprov        := {}
Local aItensDBM        := {}
Local cTpAprCtEc    := SuperGetMV("MV_CTAPREC",.F.,"0")
Local cItemPln        := ""
Local cItemDoc        := "0001" //""
Local cItemApr        := ""
Local cAlsCpo        := ""
Local cGrpAprov     := ""
Local cItAprov        := ""
Local cTipcom        := ""
Local cCpo             := ""
Local cNumDoc        := ""

Local lContinua        := .T.
Local lDelItem        := .F.
Local lDeleta        := Iif( nOpcao == 3, .T. , .F. )
Local lEstorna    := Iif( ( (nOpcao == 2) .OR. (nOpcao == 3) ) , .T. , .F. )
Local lGerouApv    := .F.
Local lFirstNiv    := .F.
Local lEntCtb        := .T.
Local lGravaB        := .F.
Local lGravaL        := .F.
Local lCtAprEc    := .F.

Local nPosIt        := 0
Local nPosQtd     := 0
Local nPosVlr        := 0
Local nPosPrd        := 0
Local nPosPln        := 0
Local nPosRev        := 0
Local nPosItCtb        := 0
Local nPosTipCom    := 0
Local nForIt        := 0
Local nVlrIt        := 0
Local nX            := 0
Local nZ            := 0

//-- Caso seja alias iniciado com S desconsidera a primeira letra
If SubStr(cAlias,1,1) == "S"
	cAlsCpo := SubStr(cAlias,2,Len(cAlias) )
Else
	cAlsCpo := cAlias
EndIf


aHeaderTmp := {}
aColsTmp   := {}

nVlrIt := SZF->ZF_VALOR
AADD(aHeaderTmp,{"Centro Custos","ZF_CCUSTO" ,"@!",TamSx3("ZF_CCUSTO")[1],0,"","","C","", "" } )
AADD(aHeaderTmp,{"Item Contabil","ZF_ITEMCTA","@!",TamSx3("E2_ITEMCTA")[1],0,"","","C","", "" } )  // 23/12/2016 Solicitdo para Buscar Grupo Aprovação considerando Item Contabil

aCOLSTmp := {}
AADD(aColsTmp,Array(Len(aHeaderTmp)+1))

aColsTmp[1,1] := SZF->ZF_CCUSTO
aColsTmp[1,2] := SZF->ZF_ITEMCTA //GetMV("GE_ITCTSOL",.F.,"CAP") 
aColsTmp[1,3] := .F.
//aEntCtb := MtGetValEC(cAlias, cAlsCpo, aHeaderTmp, aColsTmp, 1/*nForIt*/, {"ZF_CCUSTO","ZF_ITEMCTA"} )
aEntCtb :=  { {SZF->ZF_CCUSTO,Space(Len(CT1->CT1_CONTA)),SZF->ZF_ITEMCTA, SZF->ZF_CLVL}}

Aadd(aItens,{cDocto,cItemDoc,"",nVlrIt,aClone(aEntCtb[1]),cTipCom})

If lContinua
	//-- Funcao para aglutinar os itens por entidade ctb
	aAglut := MaRetAglEC( aItens , cTpDoc )
	
	//-- Gera SCR para cada entidade contabil
	For nForIt := 1 to Len(aAglut)
		
		//-- Busca grupo de aprovadores
		DbSelectArea("DBL")
		DbGoTop()
		
		aGrpAprov        := MaGrpApEC( aClone(aAglut[nForIt][4]),@lEntCtb,cTpDoc)
		cGrpAprov         := Iif( Len(aGrpAprov) >= 1 , aGrpAprov[1] , "")
		cItAprov        := Iif( Len(aGrpAprov) >= 2 , aGrpAprov[2] , "")
		
		aAlcDoc := { aAglut[nForIt][1]        ,;         // Num. Documento
		cTpDoc                ,;         // Tipo Doc.
		aAglut[nForIt][3]        ,;         // Valor aprovac.
		,;        // Aprovador
		,;        // Cod. Usuario
		cGrpAprov                ,;        // Grupo Aprovac.
		,;        // Aprov. Superior
		,;        // Moeda Docto
		,;        // Taxa da moeda
		dDtDoc                }        // Data Emissao
		
		//-- Chama rotina para controle de alcada da SC CAP/PA
		If !lDeleta .And. !lCtAprEc
			For nX := 1 To Len(aAglut[nForIt,2])
				
				lFirstNiv := MaAlcDoc(aAlcDoc,,1,,,cItAprov,aClone(aAglut[nForIt,2]),,@aItensDBM)
				//lFirstNiv := MaAlcDoc(aAlcDoc,,1,,,StrZero(nX,4,0)/*cItAprov*/,aClone(aAglut[nForIt,2]),,@aItensDBM)
				lGravaB := aScan(aItensDBM , {|x| x == PadR(aAglut[nForIt,2,nX,1],Len(DBM->DBM_ITEM))}) > 0
				lGravaL := MtGLastDBM(cTpDoc,aAglut[nForIt,1],aAglut[nForIt,2,nX,1])
				
				RecLock(cAlias,.F.)
				//SC1->C1_APROV := If(lGravaB,"B",If(lGravaL,"L",    SC1->C1_APROV))
				SZF->ZF_GRAPROV := cGrpAprov
				(cAlias)->(MsUnlock())
				
			Next nX
		EndIf
		
		If !lGerouApv .And. !lFirstNiv .And. !lCtAprEc
			lGerouApv := .T.
		EndIf
	Next nForIt
EndIf
Return lGerouApv
//-------------------------------------------------------------------
/*/{Protheus.doc} GE03MultNat
Distribui o valor do titulo em varias naturezas (FINA050).
Arquivo original: FINXFUN.PRX
@author Claudio D Souza
@since 22/05/2001
/*/
//-------------------------------------------------------------------
Static Function GE03MultNat(cAlias,nOpc,nImpostos,lRatImpostos,aColsParam, aHeaderParam,lMostraTela)

LOCAL aCampos	:= {"ZG_NATUREZ","ZG_VALOR","ZG_PERC","ZG_RATEICC" } 	// Indica quais campos serao
// exbididos na GetDados
// e na ordem que devem aparecer
LOCAL cCampo    := Right(cAlias,2)
LOCAL nX
LOCAL bTit      := { |cChave| SX3->(DbSetOrder(2)), SX3->(DbSeek(cChave)), X3Titulo() }
LOCAL oDlg
LOCAL oGet
LOCAL aArea  	:= GetArea()
LOCAL aArea1 	:= (cAlias)->(GetArea())
lOCAL aAreaSED  := SED->(GetArea())
LOCAL cPic  	:= PesqPict("SE2","E2_VALOR",19)
LOCAL nTotSZG	:= nTotSZH := nPerSZG := nPerSZH := 0
LOCAL aButton   := {}
LOCAL aCpoUsado := {"ZH_NUM","ZH_TIPO","ZH_CLIFOR","ZH_LOJA"}
LOCAL lValF050	:= .T.

PRIVATE aCols		:= {}
PRIVATE aHeader	    := {}
PRIVATE oValDist    := Nil
PRIVATE nValDist    := 0
PRIVATE nVlTit      := 0
PRIVATE aTit        := {}
PRIVATE nOpcA 	    := 0
PRIVATE oValFal     := Nil
PRIVATE oPerFal     := Nil
PRIVATE nValFal	    := 0
PRIVATE nPerFal	    := 100
PRIVATE lCC			:= .F.
PRIVATE aRegs       := {}

DEFAULT nOpc	 	:= 3
DEFAULT nImpostos	:= 0
DEFAULT lRatImpostos:= .F.
DEFAULT aColsParam	:= {}
DEFAULT aHeaderParam:= {}
DEFAULT lMostraTela	:= .T.
DEFAULT aRotina := MenuDef()


If nOpc # 3       // nao é inclusao mbarros 07/02/2016-fecha TMP
	//Se existir temporario para rateio c. custo, deleta
	If Select("SZHTMP") > 0 
		If cArqSZH <> Nil
			dbSelectArea("SZHTMP")
			dbCloseArea()
			Ferase(cArqSZH+GetDBExtension())
			Ferase(cArqSZH+OrdBagExt())
		Endif
	Endif
	Aadd(aButton, {'S4WB013N',{|| U_G03NatCC(nOpc) },"Rateio Centro de Custo","Rateio"} )
	nVlTit	:= M->&(cCampo + "_VALOR") + nImpostos // Valor do titulo
Else
	nVlTit	:= M->&(cCampo + "_VALOR") + nImpostos // Valor do titulo
Endif
nValFal 	:= M->&(cCampo + "_VALOR") + nImpostos // Valor do titulo

__OPC 	:= nOpc

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da matriz aHeader e aCampos						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SZG->(dbSetOrder(1))
If (nOpc # 3 .And. 	Len(aColsParam) = 0 .and. SZG->(MsSeek(xFilial("SZG")+(cAlias)->&(cCampo + "_NUMSOL")+(cAlias)->&(cCampo + "_TIPO")+(cAlias)->&(cCampo+"_FORNECE")+(cAlias)->&(cCampo + "_LOJA"))))
	While SZG->ZG_FILIAL+SZG->ZG_NUM+SZG->ZG_TIPO+SZG->ZG_CLIFOR+SZG->ZG_LOJA==xFilial("SZG")+(cAlias)->&(cCampo + "_NUMSOL")+(cAlias)->&(cCampo + "_TIPO")+(cAlias)->&(cCampo+"_FORNECE")+(cAlias)->&(cCampo + "_LOJA")
		Aadd(aCols,Array(Len(aCampos)+1))
		If Len(aCols) == 1
			For nX := 1 To Len(aCampos)
				SX3->(dbSeek(Pad(aCampos[nX],10)))
				Aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
				If Alltrim(aHeader[nX][2]) == "ZG_PERC" //Percentual
					aHeader[nX][6] := "U_G3VNatCalc()"   //MNatCalcV()
					// Inclui em aCols como caracter para ser possivel a visualizacao na
					// tela, por ser a ultima coluna da getdados
					aHeader[nX][8] := "C"
					aHeader[nX][5] := 2
				ElseIf Alltrim(aHeader[nX][2]) == "ZG_VALOR"
					aHeader[nX][6] := "U_G3PNatCalc()"
				ElseIf Alltrim(aHeader[nX][2]) == "ZG_NATUREZ"
					aHeader[nX][6] := 'ExistCpo("SED") .And. U_G3NatAltN()' //MNatAltN()
				Endif
			Next
		Endif
		
		aCols[Len(aCols)][1] := SZG->ZG_NATUREZ
		aCols[Len(aCols)][2] := Round(NoRound(nVlTit * SZG->ZG_PERC, 3), 2)
		aCols[Len(aCols)][3] := Trans(SZG->ZG_PERC * 100, PesqPict("SZG","ZG_PERC"))
		aCols[Len(aCols)][4] := SZG->ZG_RATEICC
		aCols[Len(aCols)][Len(aCampos)+1] := .F.
		
		nTotSZG += aCols[Len(aCols)][2]
		nPerSZG += SZG->ZG_PERC * 100
		
		Aadd(aRegs, SZG->(Recno()))
		nValDist := nVlTit
		nValFal	:= 0
		nPerFal	:= 0
		
		SZG->(DbSkip())
	EndDo
	
	If nTotSZG # nVlTit .Or. nPerSZG # 100
		aCols[Len(aCols)][2] += nVlTit - nTotSZG
		aCols[Len(aCols)][3] := Trans(Val(aCols[Len(aCols)][3]) + 100 - nPerSZG, PesqPict("SZG","ZG_PERC"))
	Endif
	
	If Select("SZHTMP") == 0
		aCposDb := {}
		aadd(aCposDB,{"ZH_NATUREZ","C",10,0})
		aadd(aCposDB,{"ZH_CCUSTO","C",TamSx3("CTT_CUSTO")[1],0})
		aadd(aCposDB,{"ZH_ITEMCTA","C",TamSx3("CTD_ITEM")[1],0})
		aadd(aCposDB,{"ZH_CLVL","C",TamSx3("CTH_CLVL")[1],0})
		aadd(aCposDB,{"ZH_VALOR","N",17,2})
		aadd(aCposDB,{"ZH_PERC","N",11,7})
		aadd(aCposDB,{"ZH_FLAG","L",1,0})
		aadd(aCposDB,{"ZH_RECNO","N",10,0})
		
		// Adiciona demais campos
		aStruSZH := SZH->(DbStruct())
		For nX := 1 To Len(aStruSZH)
			If Ascan(aCposDB, { |e| Alltrim(e[1]) == aStruSZH[nX][1] } ) == 0
				Aadd(aCposDB,{aStruSZH[nX][1],aStruSZH[nX][2],aStruSZH[nX][3],aStruSZH[nX][4]})
			Endif
		Next
		
		cArqSZH := CriaTrab(aCposDB,.T.) // Nome do arquivo temporario do SZH
		dbUseArea(.T.,__LOCALDriver,cArqSZH,"SZHTMP",.F.)
		
		cIndice := "ZH_NATUREZ+ZH_CCUSTO"
		dbSelectArea("SZHTMP")
		IndRegua ("SZHTMP",cArqSZH,cIndice,,,"Selecionando Registros...")
		#IFNDEF TOP
			dbSetIndex(cArqSZH+OrdBagExt())
		#ENDIF
		dbSetOrder(1)
		SZH->(dbSetOrder(1))
		SZH->(MsSeek(xFilial("SZH")+(cAlias)->&(cCampo + "_NUMSOL")+(cAlias)->&(cCampo + "_TIPO")+(cAlias)->&(cCampo+"_FORNECE")+(cAlias)->&(cCampo + "_LOJA")))
		
		While !SZH->(Eof()) .AND. SZH->ZH_FILIAL+SZH->ZH_NUM+SZH->ZH_TIPO+SZH->ZH_CLIFOR+SZH->ZH_LOJA==xFilial("SZH")+(cAlias)->&(cCampo + "_NUMSOL")+(cAlias)->&(cCampo + "_TIPO")+(cAlias)->&(cCampo+"_FORNECE")+(cAlias)->&(cCampo + "_LOJA")
			RecLock("SZHTMP", .T.)
			nPos := Ascan(aCols, { |x| x[1] = SZH->ZH_NATUREZ })
			SZHTMP->ZH_NATUREZ	:= SZH->ZH_NATUREZ
			SZHTMP->ZH_CCUSTO	:= SZH->ZH_CCUSTO
			SZHTMP->ZH_ITEMCTA	:= SZH->ZH_ITEMCTA
			SZHTMP->ZH_CLVL   	:= SZH->ZH_CLVL
			SZHTMP->ZH_VALOR	:= Round(NoRound(SZH->ZH_VALOR,3),2)
			SZHTMP->ZH_PERC		:= SZH->ZH_PERC
			SZHTMP->ZH_RECNO	:= SZH->(Recno())
			// Carregamento dos campos de novas entidades
			For nX:= 1 to Len(aCposDB)
				cCpoEC := aCposDB[nX][1]
				If "ZH_EC0" $ Alltrim(cCpoEC)
					SZHTMP->(&cCpoEC) := SZH->(&cCpoEC)
				EndIf
			Next nX
			nTotSZH += SZHTMP->ZH_VALOR
			nPerSZH += SZHTMP->ZH_PERC
			MsUnLock()
			SZH->(DbSkip())
		Enddo
	Endif
ElseIf nOpc # 3
	aCols 	:= AClone(aColsParam)
	aHeader := AClone(aHeaderParam)
Endif

If nOpc = 3 .Or. Len(aCols) = 0
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("SZG")
	nX := 1
	While ! SX3->(EOF()) .And. (SX3->X3_Arquivo == "SZG")
		If X3USO(SX3->X3_Usado) .And. cNivel >= SX3->X3_NIVEL
			If nX == 1
				nRecnoSx3 := SX3->(Recno())
				Aadd(aCols,Array(Len(aCampos)))
				// Adiciona os campos na ordem em que devem aparecer
				For nX := 1 To Len(aCampos)
					SX3->(DbSetOrder(2))
					SX3->(MsSeek(Pad(aCampos[nX],10)))
					Aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
					If SX3->X3_TIPO == "C"
						If Alltrim(SX3->X3_CAMPO) == "ZG_NATUREZ" .and. !('EXISTCPO("SED")'$ Upper(aHeader[nX][6])) // Natureza
							aHeader[nX][6] := "existcpo('SED').and." + aHeader[nX][6]
						Endif
						aCols[1][nX] := CriaVar(SX3->X3_CAMPO)
					Else
						If Alltrim(SX3->X3_CAMPO) == "ZG_PERC" // Percentual
							aHeader[nX][6] := "U_G3VNatCalc()"
							// Inclui em aCols como caracter para ser possivel a visualizacao na
							// tela, por ser a ultima coluna da getdados
							aHeader[nX][8]	:= "C"
							aHeader[nX][5]	:= 2
							aCols[1][nX]	:=  Trans(CriaVar("ZG_PERC"), PesPict("ZG_PERC"))
						ElseIf Alltrim(SX3->X3_CAMPO) == "ZG_VALOR"
							aCols[1][nX] := CriaVar("ZG_VALOR")
							aHeader[nX][6] := "U_G3PNatCalc()"
						Else
							aCols[1][nX] := CriaVar(SX3->X3_CAMPO)
						Endif
					EndIf
				Next
				SX3->(DbSetOrder(1))
				SX3->(DbGoto(nRecnoSx3))
				// Adiciona os demais campos
				If Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim(SX3->X3_CAMPO) } )  == 0
					Aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
					Aadd(aCols[1], CriaVar(SX3->X3_CAMPO))
				Endif
			Else
				// Adiciona os demais campos
				If Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim(SX3->X3_CAMPO) } )  == 0
					Aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
					If Alltrim(SX3->X3_CAMPO) == "ZG_NATUREZ" .and. !('EXISTCPO("SED")'$ Upper(aHeader[nX][6])) // Natureza
						aHeader[nX][6] := "existcpo('SED').and." + aHeader[nX][6]
					Endif
					Aadd(aCols[1], CriaVar(SX3->X3_CAMPO))
				Endif
			Endif
		Endif
		SX3->(DbSkip())
	End
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona mais um elemento em aCOLS, indicando se a   ³
	//³ a linha esta ou nao deletada						 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aadd(aCols[1], .F.)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mostra o corpo da rateio 									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOpca := 0

// Cria os titulos do dialogo
Aadd( aTit, Eval(bTit, cCampo + "_FORNECE"))
Aadd( aTit, Eval(bTit, cCampo + "_LOJA"))
Aadd( aTit, "   ") // Eval(bTit, cCampo + "_PREFIXO"))
Aadd( aTit, Eval(bTit, cCampo + "_NUMSOL"))
Aadd( aTit, "  ") //Eval(bTit, cCampo + "_PARCELA"))
Aadd( aTit, Eval(bTit, cCampo + "_VALOR" ))
Aadd( aTit, cAlias)


If lMostraTela
	//While .T.
	aSize := MSADVSIZE()
	DEFINE MSDIALOG oDlg TITLE OemToAnsi("Naturezas Solicitacao Pagamento") From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
	oDlg:lMaximized := .T.
	oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20,.T.,.T. )
	oPanel:Align := CONTROL_ALIGN_TOP
	@  001, 005 To  018,247 OF oPanel PIXEL
	@  001, 250 To  018,495 OF oPanel PIXEL
	@  005 , 010	Say aTit[1] +" "+M->&(cCampo + "_FORNECE")	FONT oDlg:oFont OF oPanel Pixel
	@  005 , 100	Say aTit[2] +" "+M->&(cCampo + "_LOJA")    	FONT oDlg:oFont	OF oPanel  Pixel
	@  005 , 257	Say aTit[4] +" "+M->&(cCampo + "_NUMSOL")	 	FONT oDlg:oFont	OF oPanel  Pixel
	oPanel2 := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,40,40,.T.,.T. )
	oPanel2:Align := CONTROL_ALIGN_BOTTOM
	@ 001, 005 To 035,247 OF oPanel2 PIXEL
	@ 001, 250 To 035,495 OF oPanel2 PIXEL
	@ 005, 010  Say aTit[6] FONT oDlg:oFont OF oPanel2 PIXEL SIZE 50,10
	@ 005, 076  Say nVlTit	PICTURE cPic FONT oDlg:oFont OF oPanel2 PIXEL SIZE 50,10
	@ 005, 257  Say "Valor a Distribuir" FONT oDlg:oFont OF oPanel2 PIXEL SIZE 50,10
	@ 005, 357  Say oValFal VAR nValFal PICTURE cPic	FONT oDlg:oFont OF oPanel2 PIXEL SIZE 50,10
	@ 018, 010  Say OemToAnsi("Total Distribuido: " ) FONT oDlg:oFont OF oPanel2 PIXEL SIZE 50,10
	@ 018, 076  Say oValDist VAR nValDist PICTURE cPic	FONT oDlg:oFont OF oPanel2 PIXEL SIZE 50,10
	@ 018, 257  Say "Percentual a Distribuir" FONT oDlg:oFont OF oPanel2 PIXEL SIZE 90,10
	@ 018, 357  Say oPerFal VAR nPerFal PICTURE PesPict("ZG_PERC") SIZE 50,10 FONT oDlg:oFont OF oPanel2 PIXEL //"@E 999.9999999"
	oGet := MSGetDados():New(34,5,128,315,nOpc,"U_G3NLinOk", "AllwaysTrue",,nOpc # 2) 
	IF nOpc == 2
		oGet:SetEditLine(.F.)
		oGet:lCanEditLine := .F.
		oGet:lEditLine := .F. 
		oGet:oBrowse:BLDBLCLICK := { | | AllwaysTrue() }   // Causava error log tentando editar celula mesmo que opcao era 2 = visualizar
	Endif
	oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{||nOpca:=1,If(oGet:TudoOk(),oDlg:End(),nOpca := 0)},{|| nOpcA:=0,oDlg:End()},,aButton),oPanel2:Align := CONTROL_ALIGN_BOTTOM)
	//	Loop
	//EndDo
Else
	nOpcA := 1
Endif

SX3->(DbSetOrder(1))
RestArea(aArea)
(cAlias)->(RestArea(aArea1))
SED->(RestArea(aAreaSED))
If nOpcA == 1
	aColsParam		:= AClone(aCols)
	aColsSZG		:= AClone(aCols)
	aHeaderParam	:= AClone(aHeader)
	aHeaderSZG		:= AClone(aHeader)
	For nX := 1 To Len(aColsSZG)
		If ValType(aColsSZG[nX][3]) == "N"
			aColsSZG[nX][3]	:= AllTrim(STR(aColsSZG[nX][3]))
		EndIf
	Next
Else
	aColsParam		:= {}
	aColsSZG		:= {}
	aHeaderParam	:= {}
	aHeaderSZG		:= {}
	M->ZF_MULTNAT   := "2"	//Volta o campo Multipla Natureza para o status "2-Nao"
Endif


// Zera as variaveis de contabilizacao para nao ocorrer duplicidade em outra chamada a DetProva
VALOR  := 0
VALOR2 := 0
VALOR3 := 0
VALOR4 := 0
VALOR5 := 0					// Pis
VALOR6 := 0					// Cofins
VALOR7 := 0					// Csll


Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} G3PNATCALC

Calcula o Percentual digitado para natureza (Multiplas Naturezas).
Arquivo original: FINXFUN.PRX

@author Claudio Donizete de Souza
@since 23/05/2001
/*/
//-------------------------------------------------------------------
User Function G3PNatCalc

LOCAL nX, nLen, lRet := .F., cAlias := Alias()

nValDist := 0
nValFal	:= 0
nPerFal	:= 0

If !Empty(M->ZG_VALOR)
	
	aCols[n][2] := M->ZG_VALOR
	// Calcula o percentual de acordo com o valor digitado
	aCols[n][3] := Transform((M->ZG_VALOR / nVlTit) * 100, PesPict("ZG_PERC"))
	aCols[n][3] := StrTran(aCols[n][3],",",".")
	
	If 	Select("SZHTMP") > 0 //.And. aCols[n][4] = "1"
		dbSelectArea("SZHTMP")
		
		// busca natureza no arquivo TMP de Mult Nat C.Custo
		If dbSeek(aCols[n][1])
			While !Eof() .and. SZHTMP->ZH_NATUREZ == aCols[n][1]
				SZHTMP->ZH_VALOR := m->ZG_VALOR * SZHTMP->ZH_PERC
				SZHTMP->(DbSkip())
			EndDo
		Endif
		DbSelectArea(cAlias)
	Endif
	
	nLen := Len(aCols)
	For nX := 1 To nLen
		// Se a linha nao estiver deletada, acumula o valor digitado
		If !aCols[nX][Len(aCols[nX])]
			nValDist += aCols[nX][2]	//Valor Distribuido
			nPerFal	+= Iif(Valtype(aCols[nX][3]) == "C", Val(aCols[nX][3]), aCols[nX][3]) //Percentual Distribuido
			nValFal	:= nVlTit - nValDist //Valor que falta distribuir
		EndIf
	Next
	nPerFal	:= 100 - nPerFal		//Percentual que falta distribuir
	
	//Em função de numeração flutuante na gravação do Percentual.
	//Verifico se o Percentual que falta é maior que Valor que falta.
	If nPerfal > nValFal
		nPerfal -= 0.01
	Endif
	
	oValDist:Refresh() // Atualiza o objeto na tela
	If !Type("oValFal") == "U"
		oValFal:Refresh() // Atualiza o objeto na tela
	Endif
	If !Type("oPerFal") == "U"
		oPerFal:Refresh() // Atualiza o objeto na tela
	Endif
	lRet := .T.
	
Else
	Alert("É necessario informar um valor maior que zero!")
Endif
Return lRet
//-------------------------------------------------------------------
/*/{Protheus.doc} G3PNCCCAL

Calcula o Percentual equivalente ao valor digitado para C.Custo
(Multiplas Naturezas).
Arquivo original: FINXFUN.PRX

@author Mauricio Pequim Jr.
@since 14/08/2002
/*/
//-------------------------------------------------------------------
User Function G3PnccCal()

LOCAL lRet     := .F.
LOCAL nPosPer  := aScan(aHeader,{|x| x[2] == "ZH_PERC"})
LOCAL nPosVal  := aScan(aHeader,{|x| x[2] == "ZH_VALOR"})
Local nDif := 0 //diferença
Local nVlrRateio := 0

If Type( "nValNat" ) == "N"
	nVlrRateio := nValNat
Else
	nVlrRateio := nVlTit
EndIf

If M->ZH_VALOR > 0
	// Calcula o percentual de acordo com o valor digitado
	nDif := (nVlrRateio - M->ZH_VALOR)
	aCols[n][nPosPer] := Transform(100 - ((nDif * 100)/nVlrRateio),"@E 999.9999999")
	
	// Se a linha nao estiver deletada, acumula o valor digitado
	If !aCols[n][nNumCol+1]
		nValRat -= aCols[n][nPosVal]  //Valor anterior da acols
		nValRat += M->ZH_VALOR
	EndIf
	oValRat:Refresh() // Atualiza o objeto na tela
	lRet := .T.
Else
	Alert("É necessario informar um valor maior que zero!")
Endif
Return lRet
//-------------------------------------------------------------------
/*/{Protheus.doc} G3VNATCALC

Calcula o Valor digitado para natureza (Multiplas Naturezas)
Arquivo original: FINXFUN.PRX

@author Claudio Donizete de Souza
@since 23/05/2001
/*/
//-------------------------------------------------------------------
User Function G3VNatCalc

Local nX, nLen, lRet := .F., cAlias := Alias()

nValDist := 0
nValFal	:= 0
nPerFal	:= 0

If !Empty(M->ZG_PERC)
	
	// Calcula o valor de acordo com o percentual digitado
	aCols[n][2] := Iif(Funname() <> "FINA040", Iif(Valtype(M->ZG_PERC) == "C",Round(NoRound((VAL(StrTran(M->ZG_PERC,",",".")) / 100)*nVlTit,3),2),(M->ZG_PERC / 100)*nVlTit), (M->ZG_PERC / 100)*nVlTit)
	aCols[n][3] := Iif(Funname() <> "FINA040", Iif(Valtype(M->ZG_PERC) == "C",Transform(Val(StrTran(M->ZG_PERC,",", ".")), PesPict("ZG_PERC")),M->ZG_PERC), M->ZG_PERC)
	
	If 	Select("SZHTMP") > 0 //.And. aCols[n][4] = "1"
		dbSelectArea("SZHTMP")
		
		// busca natureza no arquivo TMP de Mult Nat C.Custo
		If dbSeek(aCols[n][1])
			While !Eof() .and. SZHTMP->ZH_NATUREZ == aCols[n][1]
				SZHTMP->ZH_VALOR := aCols[n][2] * SZHTMP->ZH_PERC
				SZHTMP->(DbSkip())
			EndDo
		Endif
		DbSelectArea(cAlias)
	Endif
	
	nLen := Len(aCols)
	For nX := 1 To nLen
		// Se a linha nao estiver deletada, acumula o valor digitado
		If !aCols[nX][Len(aCols[nX])]
			nValDist += aCols[nX][2]	//Valor Distribuido
			nPerFal	+= Iif(Valtype(aCols[nX][3]) == "C", Val(aCols[nX][3]), aCols[nX][3]) //Percentual Distribuido
			nValFal  := nVlTit - nValDist //Valor que falta distribuir
		EndIf
	Next
	nPerFal	:= 100 - nPerFal		//Percentual que falta distribuir
	
	oValDist:Refresh() // Atualiza o objeto na tela
	If !Type("oValFal") == "U"
		oValFal:Refresh() // Atualiza o objeto na tela
	Endif
	If !Type("oPerFal") == "U"
		oPerFal:Refresh() // Atualiza o objeto na tela
	Endif
	lRet := .T.
	
Else
	Alert("É necessario informar um percentual maior que zero!")
Endif

Return lRet
//-------------------------------------------------------------------
/*/{Protheus.doc} G3VNCCCAL

Calcula o valor equivalente ao percentual digitado para C.Custo
(Multiplas Naturezas).
Arquivo original: FINXFUN.PRX

@author Mauricio Pequim Jr.
@since 14/08/2002
/*/
//-------------------------------------------------------------------
User Function G3VnccCal()

LOCAL lRet := .F.
LOCAL nValCus := 0
Local nCont := 0
Local nPosPer  := aScan(aHeader,{|x| x[2] == "ZH_PERC"})
Local nPosVal  := aScan(aHeader,{|x| x[2] == "ZH_VALOR"})
Local nTotPerc := 0
Local nDifTot  := 0

// Se percentual > 0
IF !Empty(M->ZH_PERC)
	// Calcula o valor de acordo com o percentual digitado
	
	If ValType(M->ZH_PERC) = "C"
		nValCus := Round(Val(StrTran(M->ZH_PERC,",","."))/100, 2)*nValNat //TamSX3("EZ_VALOR")[2])
		aCols[n][nPosPer] := Transform(Val(StrTran(M->ZH_PERC,",", ".")), "@e 999.9999999")
	Else
		nValCus := Round(M->ZH_PERC/100, 2)*nValNat //TamSX3("EZ_VALOR")[2])
		aCols[n][nPosPer] := M->ZH_PERC
	EndIf	
	// Se a linha nao estiver deletada, acumula o valor digitado
	If !aCols[n][nNumCol+1]
		nValRat -= aCols[n][nPosVal]  // diminuo o valor anterior
		nValRat += nValCus      // Somo o valor atual
		aCols[n][nPosVal] := nValCus  // Atualizo no acols o valor
	EndIf
	oValRat:Refresh() // Atualiza o objeto na tela
	lRet := .T.
	
	For nCont := 1 to Len(aCols)
		If !(aCols[nCont][nNumCol+1])
			If ValType(aCols[nCont][nPosPer]) = "C"
				nTotPerc += Val(StrTran(aCols[nCont][nPosPer],",","."))
			Else
				nTotPerc += aCols[nCont][nPosPer]
			EndIf
		Endif
	Next
	
	If nTotPerc == 100 //Atingiu 100% de percentual de rateio
		nValRat := 0
		For nCont := 1 to Len(aCols)
			If !(aCols[nCont][nNumCol+1])  // Verifica se linha esta deletada
				nValRat += aCols[ncont][nPosVal]
			Endif
		Next
		If (nDiftot := nValRat - nValNat) > 0 //Há diferença nos valores totais
			If !(aCols[Len(aCols)][nNumCol+1])
				aCols[Len(aCols)][nPosVal] := aCols[Len(aCols)][nPosVal] - nDifTot
				nValRat := 0
				For nCont := 1 to Len(aCols)
					If !(aCols[nCont][nNumCol+1])
						nValRat += aCols[ncont][nPosVal]
					Endif
				Next
				oValRat:Refresh()
			EndIf
		EndIf
	EndIf
Else
	Alert("É necessario informar um percentual maior que zero!")
Endif

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} G3NLINOK

Analisa a linha digitada (multplas naturezas).
Arquivo original: FINXFUN.PRX

@author Claudio Donizete Souza
@since 23/05/2001
/*/
//-------------------------------------------------------------------
User Function G3NLinOk()

LOCAL lRet := .T.,nX,nLen,nSoma := 0,nAscan
LOCAL cPic  := PesqPict("SZF","ZF_VALOR",19)
LOCAL aAreaSED		:= SED->( GetArea() )

// Nao permite natureza sintetica
If !aCols[n][Len(aCols[n])]
	SED->( dbSetOrder( 1 ) )
	SED->( MsSeek( xFilial( "SED" ) + aCols[n][1] ) )
	If SED->ED_TIPO == "1"	// Natureza Sintetica
		Help( " ", 1, "NATUREZ",, "Verifique se a natureza informada está classificada corretamente. Apenas naturezas do titpo analítico serão aceitas para este processo.!", 1, 0 )
		lRet := .F.
	EndIf
	SED->( RestArea( aAreaSED ) )
EndIf

// Se a natureza j  estiver registrada e nao estiver apagada, nao permite nova
// distribuicao para a mesma natureza
nAscan := Ascan( aCols, { |e| e[1] == aCols[n][1] .And. !e[len(e)] } )

If nAscan > 0 .And. n != nAscan .And. !aCols[n][Len(aCols[1])]
	Alert( "Natureza já está cadastrada!" )
	lRet := .F.
ElseIf Empty(aCols[n][1]) .And. !aCols[n][Len(aCols[1])] // Se a Natureza estiver vazia, avisa o usuário
	Alert("É necessário informar o código da natureza")
	lRet := .F.
ElseIf !aCols[n][Len(aCols[n])] .And. IF(Valtype(aCols[n][3]) == "C", Val(STRTRAN(aCols[n][3],",",".")), aCols[n][3]) <= 0		//Se o percentual estiver zerado
	Alert("Informar um valor para o rateio.")
	lRet := .F.
Else
	nLen := Len(aCols)
	For nX := 1 To nLen
		// Se a linha nao estiver deletada, soma o valor digitado
		If !aCols[nX][Len(aCols[nX])]
			nSoma += aCols[nX][2]
		EndIf
	Next
	
	// Se a soma for maior que o valor a ser distribuido ou se foi pressionado
	// Ok e a Soma for diferente do valor distribuido, avisa e invalida o valor
	// digitado
	If Val(Str(nSoma,17,2)) > Val(Str(nVlTit,17,2)) .Or. ;
		((nOpca == 1) .And. Str(nSoma,17,2) != Str(nVlTit,17,2).and. Type("aRatEvEz")=="U") .or.;
		(Type("aRatEvEz")<>"U" .and. aRatEvEz<>Nil .and. Len(aRatEvEz) == nLen .and. Str(nSoma,17,2) != Str(nVlTit,17,2))//tratando rotina automatica
		Help(" ",1,"TOTDISTRIB",, Iif(Type("aTit")=="A",Pad( aTit[6], 21 )  + Space(1) ,"");
		+ Trans(nVlTit, cPic) +;
		Chr(13)  + Pad( "Total Distribuido", 20 ) + Space(1) +;
		Trans(nSoma , cPic), 4, 0)
		lRet := .F.
	Endif
	
	//Se rateia por CC, verifica se digitou os rateios.
	If lRet .and. acols[n][4] == "1"
		If Select("SZHTMP")<= 0 .or. (Select("SZHTMP") > 0 .and. SZHTMP->(!DbSeek(acols[n][1])))
			If !(U_G03NatCC())
				lRet:= .F.
			Endif
		EndIf
	EndIf
	
EndIf

Return lRet
//-------------------------------------------------------------------
/*/{Protheus.doc} G03NATCC

Distribui o valor da multinatureza em diversos C.Custo.
Arquivo original: FINXFUN.PRX

@author Mauricio Pequim Jr.
@since 13/08/2002
/*/
//-------------------------------------------------------------------
User Function G03NatCC(nOpc)

LOCAL aCposDB := {}  // Campos para o arquivo temporario
LOCAL aSaveArea := GetArea()
LOCAL oDlg1
LOCAL cIndice := ""
LOCAL aHead := {}  // Aheader da Getdados nova
LOCAL aColsNew := {} // aCols da Getdados nova
LOCAL aHeadOld := aClone(aHeader) //Guarda dados o Aheader da Getdados de onde foi chamada
LOCAL aColsOld := aClone(aCols) // Guarda colunas da Getdados anterior
LOCAL nOldPos := n  //Guard posição da GetDados de onde foi chamada
LOCAL aAltera := {}  // Campos da Getdb
LOCAL cCampo := IIf(Type("aTit[7]") <>"U",(Right(aTit[7],2))," ")// aTit[6] == SE1 ou SE2
LOCAL nRecTmp := 0  // Recno do arquivo temporario
LOCAL nCont := 0
LOCAL lDelFirst := .F., aRegs := {}
LOCAL aStruSZH
LOCAL nPosRec :=0
LOCAL nPosArq:= n
LOCAL lConfirma := .T.
LOCAL lValF050C	:= .T.
LOCAL oPanel, oPanel2
LOCAL lConta	:= AllWaysTrue() //	 ( IsInCallStack("FINA050") .Or. IsInCallStack("FINA080") .Or. IsInCallStack("FINA090") )
LOCAL nPosCta   := 0
LOCAL nPosCus   := 0
LOCAL nPosVal   := 0
LOCAL nPosPer   := 0
LOCAL nPosItCta := 0
LOCAL nPosClVl  := 0
Local aRatCC:={}
Local nX:=0
Local nY:=0
Local lRet:=.T.
Local nPoSZG:=0
Local lAuto :=(((Type("lF040Auto")=="L" .and. lF040Auto).or. (Type("lF050Auto")=="L" .and. lF050Auto)) .and. Type ("aRatEvEz") <> "U" .and. aRatEvEz <> Nil)
Local nPosEC05		:= 0
Local nPosED05		:= 0
Local nPosEC06      := 0
Local nPosED06		:= 0
Local nPosEC07		:= 0
Local nPosED07		:= 0
Local nPosEC08		:= 0
Local nPosED08		:= 0
Local nPosEC09		:= 0
Local nPosED09		:= 0
Local lTemEnt       := .F.
Private aTELA		:= {}
Private aGETS		:= {}
Private oValRat
Private nValRat	:= 0		//Valor total rateado por C.Custo
Private nValNat   := aCols[n][2] // Valor da natureza na Getdados de MultiNat
Private cNatur		:= aCols[n][1] // Natureza
Private nOpcC := 0
Private nNumCol := 0	// Numero de colunas do aCols
Private oGetDB

DEFAULT nOpc	:= 3

// Se campos necessarios nao preenchidos
If Empty(aCols[n][1]) .or. Empty(aCols[n][2]) .or. Empty(aCols[n][3])
	aCols[n][4] := "2"
	Return .T.
Endif

__OPC := nOpc
//Campos a serem mostrados na Getdados
Aadd(aHead,{RetTitle("ZH_CCUSTO"),"ZH_CCUSTO","@!",;
TamSx3("ZH_CCUSTO")[1],0,"Ctb105Cc()","û","C","SZH" } )
Aadd(aHead,{RetTitle("ZH_VALOR"),"ZH_VALOR",PesqPict("SZH","ZH_VALOR",TamSx3("ZH_VALOR")[1]),;
TamSx3("ZH_VALOR")[1],TamSx3("ZH_VALOR")[2],"U_G3PnccCal()","û","N","SZH" } )
Aadd(aHead,{RetTitle("ZH_PERC"),"ZH_PERC",PesqPict("SZH","ZH_PERC",TamSx3("ZH_PERC")[1]),;
TamSx3("ZH_PERC")[1],TamSx3("ZH_PERC")[2],"U_G3VnccCal()","û","N","SZH" } )
If lConta
	Aadd(aHead,{RetTitle("ZH_CONTA"),"ZH_CONTA","@!",;
	TamSx3("ZH_CONTA")[1],0,"Ctb105Cta()","û","C","SZH" } )
EndIf
Aadd(aHead,{RetTitle("ZH_ITEMCTA"),"ZH_ITEMCTA","@!",;
TamSx3("ZH_ITEMCTA")[1],0,"Ctb105Item()","û","C","SZH" } )
Aadd(aHead,{RetTitle("ZH_CLVL"),"ZH_CLVL","@!",;
TamSx3("ZH_CLVL")[1],0,"Ctb105Clvl()","û","C","SZH" } )

//Campos a serem digitados
aadd(aAltera,"ZH_CCUSTO")
If lConta
	aadd(aAltera,"ZH_CONTA")
EndIf
aadd(aAltera,"ZH_ITEMCTA")
aadd(aAltera,"ZH_CLVL")
aadd(aAltera,"ZH_VALOR")
aadd(aAltera,"ZH_PERC")

// Adiciona demais campos
SX3->(DbSetOrder(1))
SX3->(MsSeek("SZH"))
While ! SX3->(EOF()) .And. (SX3->X3_Arquivo == "SZH")
	If X3USO(SX3->X3_Usado) .And. cNivel >= SX3->X3_NIVEL .And.;
		Ascan(aHead, {|e| Alltrim(e[2]) == Alltrim(SX3->X3_CAMPO) } ) == 0
		Aadd(aHead,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aAltera,SX3->X3_CAMPO)
	Endif
	SX3->(DbSkip())
End

SX3->(DbSeek("SZH_FILIAL"))
cUsado := SX3->X3_USADO
AADD( aHead, { "Alias WT","ZH_ALI_WT", "", 09, 0,, cUsado, "C", "SZH", "V"} )
AADD( aHead, { "Recno WT","ZH_REC_WT", "", 09, 0,, cUsado, "N", "SZH", "V"} )

aHeader := aHead

nPosCta   := Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim("ZH_CONTA") } )
nPosCus   := Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim("ZH_CCUSTO") } )
nPosVal   := Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim("ZH_VALOR") } )
nPosPer   := Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim("ZH_PERC") } )
nPosItCta := Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim("ZH_ITEMCTA") } )
nPosClVl  := Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim("ZH_CLVL") } )

lTemEnt := .T.

If lTemEnt .and. CtbQtdEntd() > 4
	nPosEC05  := Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim("ZH_EC05DB") } )
	nPosED05  := Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim("ZH_EC05CR") } )
	nPosEC06  := Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim("ZH_EC06DB") } )
	nPosED06  := Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim("ZH_EC06CR") } )
	nPosEC07  := Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim("ZH_EC07DB") } )
	nPosED07  := Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim("ZH_EC07CR") } )
	nPosEC08  := Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim("ZH_EC08DB") } )
	nPosED08  := Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim("ZH_EC08CR") } )
	nPosEC09  := Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim("ZH_EC09DB") } )
	nPosED09  := Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim("ZH_EC09CR") } )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona mais um elemento em aCOLS, indicando se a   ³
//³ a linha esta ou nao deletada									³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nNumCol := Len(aHeader)
Aadd(aColsNew,Array(nNumCol+1))
For nCont := 1 To nNumCol
	If !aHeader[nCont,2] $ "ZH_REC_WT|ZH_ALI_WT"
		aColsNew[1,nCont] := CriaVar(aHeader[nCont,2],.T.)
	Else
		If AllTrim(aHeader[nCont,2]) == "ZH_ALI_WT"
			aColsNew[1,nCont] := "SZH"
		ElseIf AllTrim(aHeader[nCont,2]) == "ZH_REC_WT"
			aColsNew[1,nCont]:= 0
		EndIf
	EndIf
	
Next nCntFor
aColsNew [1,(nNumCol+1)] := .F.
aColsNew [1,nPosPer] := Transform(0, PesqPict("SZH","ZH_PERC",TamSx3("ZH_PERC")[1]))

aCols := aColsNew

//Campos a serem digitados
aadd(aAltera,"ZH_CCUSTO")
If lConta
	aadd(aAltera,"ZH_CONTA")
EndIf
aadd(aAltera,"ZH_ITEMCTA")
aadd(aAltera,"ZH_CLVL")
aadd(aAltera,"ZH_VALOR")
aadd(aAltera,"ZH_PERC")

// Criacao do arquivo temporario
If Select("SZHTMP") == 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera arquivo de Trabalho      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aadd(aCposDB,{"ZH_NATUREZ","C",10,0})
	aadd(aCposDB,{"ZH_CCUSTO","C",TamSx3("ZH_CCUSTO")[1],0})
	If lConta
		aadd(aCposDB,{"ZH_CONTA","C",TamSx3("ZH_CONTA")[1],0})
	EndIf
	aadd(aCposDB,{"ZH_ITEMCTA","C",TamSx3("ZH_ITEMCTA")[1],0})
	aadd(aCposDB,{"ZH_CLVL","C",TamSx3("ZH_CLVL")[1],0})
	aadd(aCposDB,{"ZH_VALOR","N",17,2})
	aadd(aCposDB,{"ZH_PERC","N",11,7})
	aadd(aCposDB,{"ZH_FLAG","L",1,0})
	aadd(aCposDB,{"ZH_RECNO","N",10,0})
	
	// Adiciona demais campos
	aStruSZH := SZH->(DbStruct())
	For nX := 1 To Len(aStruSZH)
		If Ascan(aCposDB, { |e| Alltrim(e[1]) == aStruSZH[nX][1] } ) == 0
			Aadd(aCposDB,{aStruSZH[nX][1],aStruSZH[nX][2],aStruSZH[nX][3],aStruSZH[nX][4]})
		Endif
	Next
	cArqSZH := CriaTrab(aCposDB,.T.) // Nome do arquivo temporario do SZH
	dbUseArea(.T.,__LOCALDriver,cArqSZH,"SZHTMP",.F.)
Endif
cIndice := "ZH_NATUREZ+ZH_CCUSTO"
dbSelectArea("SZHTMP")
IndRegua ("SZHTMP",cArqSZH,cIndice,,,"Selecionando Registros...")
#IFNDEF TOP
	dbSetIndex(cArqSZH+OrdBagExt())
#ENDIF
dbSetOrder(1)
dbSeek(cNatur)
// Calcula o valor rateado anteriormente e alimenta a Getdados
nValRat := 0

nRecTmp   := Recno()
nPosRec   := Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim("ZH_REC_WT") } )
nPosArq   := Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim("ZH_ALI_WT") } )

If !Eof() .and. !Bof()
	While !Eof() .and. SZHTMP->ZH_NATUREZ == cNatur
		aCols[Len(aCols)][nPosCus]   := SZHTMP->ZH_CCUSTO  // Centro de Custo
		aCols[Len(aCols)][nPosVal]   := SZHTMP->ZH_VALOR   //
		aCols[Len(aCols)][nPosPer]   := Transform(SZHTMP->ZH_PERC * 100, Pespict("ZH_PERC"))
		If lConta
			aCols[Len(aCols)][nPosCta] := SZHTMP->ZH_CONTA  // Conta
		EndIf
		aCols[Len(aCols)][nPosItCta] := SZHTMP->ZH_ITEMCTA  // Item
		aCols[Len(aCols)][nPosClVl]	  := SZHTMP->ZH_CLVL  // Classe de Valor
		
		If lTemEnt .and. CtbQtdEntd() > 4
			If nPosEC05 > 0
				aCols[Len(aCols)][nPosEC05] := SZHTMP->ZH_EC05DB
			EndIf
			If nPosED05 > 0
				aCols[Len(aCols)][nPosED05]	:= SZHTMP->ZH_EC05CR
			EndIf
			If nPosEC06 > 0
				aCols[Len(aCols)][nPosEC06] := SZHTMP->ZH_EC06DB
			EndIf
			If nPosED06 > 0
				aCols[Len(aCols)][nPosED06]	:= SZHTMP->ZH_EC06CR
			Endif
			If nPosEC07 > 0
				aCols[Len(aCols)][nPosEC07] := SZHTMP->ZH_EC07DB
			EndIf
			If nPosED07 > 0
				aCols[Len(aCols)][nPosED07]	:= SZHTMP->ZH_EC07CR
			EndIf
			If nPosEC08 > 0
				aCols[Len(aCols)][nPosEC08] := SZHTMP->ZH_EC08DB
			EndIf
			If nPosED08 > 0
				aCols[Len(aCols)][nPosED08]	:= SZHTMP->ZH_EC08CR
			EndIf
			If nPosEC09 > 0
				aCols[Len(aCols)][nPosEC09] := SZHTMP->ZH_EC09DB
			EndIf
			If nPosED09 > 0
				aCols[Len(aCols)][nPosED09]	:= SZHTMP->ZH_EC09CR
			EndIf
		EndIf
		
		aCols[Len(aCols)][nPosRec]   := SZHTMP->(Recno())
		aCols[Len(aCols)][nPosArq]   := "SZH"
		
		//Se primeira linha for deletada, Forco o ultimo elemento da acols para .F.
		//e acerto apos a montagem da mesma
		If Len(aCols) == 1 .and. SZHTMP->ZH_FLAG
			aCols[Len(aCols)][nNumCol+1] := .F.  // Controle de delecao
			lDelFirst := .T.
		Else
			aCols[Len(aCols)][nNumCol+1] := SZHTMP->ZH_FLAG  // Controle de delecao
		Endif
		
		If !(SZHTMP->ZH_FLAG) .and. !lDelFirst
			nValRat += SZHTMP->ZH_VALOR
		Endif
		Aadd(aRegs, SZHTMP->(Recno()))
		dbSkip()
		If !Eof() .and. SZHTMP->ZH_NATUREZ == cNatur
			Aadd(aCols,Array(nNumCol+1))
			For nCont := 1 To nNumCol
				If !aHeader[nCont,2] $ "ZH_REC_WT|ZH_ALI_WT"
					aCols[Len(aCols),nCont] := CriaVar(aHeader[nCont,2],.T.)
				Else
					If AllTrim(aHeader[nCont,2]) == "ZH_ALI_WT"
						aCols[Len(aCols),nCont] := "SZH"
					ElseIf AllTrim(aHeader[nCont,2]) == "ZH_REC_WT"
						aCols[Len(aCols),nCont]:= 0
					EndIf
				EndIf
			Next nCont
			aCols [Len(aCols),(nNumCol+1)] := .F.
		Endif
	Enddo
	lNewLine := .F.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mostra o corpo da rateio 									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOpcC := 0

//While .T.


a_Buttons:= {}

AADD(a_Buttons, {'AUTOM',{|| ( AdmRatExt(aHeader, aCols,{ |x,y,z,w| G3CarrExt(x,y,@z,w)}),U_G3nccLin())},"Rateio","Escolha de Rateio Pre-Configurado"} )
AADD(a_Buttons, {'AUTOM',{|| U_ImpRateio() },"Rateio","Imp.Rateio Csv"})

DEFINE MSDIALOG oDlg1 TITLE "Multipla Natureza por C.Custo" From 00,00 To 500,800 OF oMainWnd PIXEL

oPanel := TPanel():New(0,0,'',oDlg1,, .T., .T.,, ,20,20,.T.,.T. )
oPanel:Align := CONTROL_ALIGN_TOP

@  002, 005 To  018,120 OF oPanel PIXEL
@  002, 125 To  018,398 OF oPanel PIXEL


@ 006 , 010		Say aTit[1] +" "+M->&(cCampo + "_FORNECE") FONT oDlg1:oFont OF oPanel  Pixel
@ 006 , 080		Say aTit[2] +" "+M->&(cCampo + "_LOJA")				FONT oDlg1:oFont OF oPanel  Pixel
@ 006 , 130		Say aTit[4] +" "+M->&(cCampo + "_NUMSOL")			FONT oDlg1:oFont OF oPanel  Pixel
@ 006 , 310 	Say "Natureza " + cNatur							FONT oDlg1:oFont OF oPanel  Pixel

oPanel2 := TPanel():New(0,0,'',oDlg1,, .T., .T.,, ,20,20,.T.,.T. )

@ 002, 005 To  018,200 OF oPanel2 PIXEL
@ 002, 202 To  018,398 OF oPanel2 PIXEL
@ 006 , 010 Say "Valor a Ratear "  OF oPanel2 PIXEL FONT oDlg1:oFont
@ 006 , 055 Say nValNat Picture PesqPict("SZH","ZH_VALOR",TamSx3("ZH_VALOR")[1]) FONT oDlg1:oFont	 OF oPanel2 PIXEL
@ 006 , 207 Say "Valor Rateado  "  OF oPanel2 PIXEL FONT oDlg1:oFont
@ 006 , 252 Say oValRat VAR nValRat Picture PesqPict("SZH","ZH_VALOR",TamSx3("ZH_VALOR")[1]) OF oPanel2 PIXEL

oGetDB := MSGetDados():New(34,5,128,315,nOpc,"U_G3NccLin"  ,"AllWaysTrue","",nOpc # 2,aAltera,,,200,,,,"U_G3nccCalc")
oGetDB:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

// Caso a primeira linha do acols for deletada (anteriormente), restauro
// a situação de deleção apos a montagem da Getdados
If lDelFirst
	aCols[1][nNumCol+1] := .T.
Endif
ACTIVATE MSDIALOG oDlg1 ON INIT EnchoiceBar(oDlg1,{||nOpcC:=1,if(U_G3nccTOk(),oDlg1:End(),.T.)},{||nOpcC:=2,If(lConfirma,oDlg1:End(),.T.)},,If(nOpc # 2 .And. CtbInUse(),a_Buttons,{}),oPanel2:Align := CONTROL_ALIGN_BOTTOM ) CENTERED

//Loop

//EndDo

If lRet
	//Restaura posicao e Aheader da GetDados que chamou essa funcao
	If (nOpcC == 2 .or.  nOpcC == 0)
		dbSelectArea("SZHTMP")
		dbSetOrder(1)
		RestArea(aSaveArea)
		aHeader	:= aHeadOld
		aCols	:= aColsOld
		n:= nOldPos
		If Len(aRegs) = 0
			M->ZG_RATEICC := "2"
		Endif
	Else
		// Grava a natureza no arquivo temporario
		G3nccGrv(aRegs)
		dbSelectArea("SZHTMP")
		dbSetOrder(1)
		RestArea(aSaveArea)
		aHeader	:= aHeadOld
		aCols	:= aColsOld
		n:= nOldPos
		m->ZG_RATEICC := "1"
	Endif
Endif
Return lRet
//-------------------------------------------------------------------
/*/{Protheus.doc} G3NCCGRV

Grava a Natureza no Arquivo temporario (Multiplas Naturezas por C.Custo).
Arquivo original: FINXFUN.PRX

@author Mauricio Pequim Jr.
@since 14/8/2002
/*/
//-------------------------------------------------------------------
Static Function G3nccGrv(aRegs)

LOCAL nCont := 1
LOCAL nX
Local cCampo
LOCAL nPosCta   := Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim("ZH_CONTA") } )
LOCAL nPosCus   := Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim("ZH_CCUSTO") } )
LOCAL nPosVal   := Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim("ZH_VALOR") } )
LOCAL nPosItCta := Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim("ZH_ITEMCTA") } )
LOCAL nPosClVl  := Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim("ZH_CLVL") } )

LOCAL lConta := AllWaysTrue()//IsInCallStack("FINA050")

dbselectArea("SZHTMP")
// Gravo os dados do acols
For nCont := 1 to len(aCols)
	If Len(aRegs) >= nCont
		DbGoto(aRegs[nCont])
		RecLock("SZHTMP",.F.)
	Else
		RecLock("SZHTMP",.T.)
	Endif
	// Grava todos os campos
	For nX := 1 To Len(aHeader)
		If Alltrim(aHeader[nX][2]) != "ZH_PERC"
			SZHTMP->&(aHeader[nX][2])	:= aCols[nCont][nX]
		Endif
	Next
	// Grava demais campos
	SZHTMP->ZH_NATUREZ	:= cNatur
	SZHTMP->ZH_CCUSTO	:= aCols[nCont][nPosCus]
	SZHTMP->ZH_VALOR	:= aCols[nCont][nPosVal]
	SZHTMP->ZH_PERC		:= aCols[nCont][nPosVal] / nValNat
	SZHTMP->ZH_FLAG		:= aCols[nCont][nNumCol+1]
	If lConta
		SZHTMP->ZH_CONTA:= aCols[nCont][nPosCta]
	EndIf
	SZHTMP->ZH_ITEMCTA	:= aCols[nCont][nPosItCta]
	SZHTMP->ZH_CLVL   	:= aCols[nCont][nPosClVl]
	MsUnlock()
	dbSkip()
Next

Return .T.
//-------------------------------------------------------------------
/*/{Protheus.doc} PESPICT

Pesquisa picture do campo no SX3 (ligada a MULTNAT e MultNatCC).
Arquivo original: FINXFUN.PRX

@author Marcel Borges Ferreira
@since 19/07/2007
/*/
//-------------------------------------------------------------------
Static Function PesPict(cCampo)
LOCAL aArea := GetArea()
LOCAL cPic := ""

SX3->(DbSetOrder(2))
If SX3->(DbSeek(cCampo)) .and. !Empty(SX3->X3_PICTURE)
	cPic := Trim(SX3->X3_PICTURE)
Else
	cPic := "@E 999.99"
EndIf

RestArea(aArea)
Return cPic

//-------------------------------------------------------------------
/*/{Protheus.doc} G3NCCCALC

Recalcula o total rateado quando deletar linha (multinatureza por Centro
de Custo).
Arquivo original: FINXFUN.PRX

@author Mauricio Pequim Jr.
@since 14/08/2002
/*/
//-------------------------------------------------------------------
User Function G3nccCalc()

LOCAL nPosVal  := aScan(aHeader,{|x| x[2] == "ZH_VALOR"})

If __OPC = 2
	Return .T.
Endif

If !aCols[n][nNumCol+1]  // Linha Deletada
	nValRat -= aCols[n][nPosVal]
Else
	nValRat += aCols[n][nPosVal]   // Linha Ativa
Endif
oValRat:Refresh() // Atualiza o objeto na tela
Return .T.
//-------------------------------------------------------------------
/*/{Protheus.doc} G3NCCLIN

Validação de linha OK da tela de rateio multinatureza por C.Custo.
Arquivo original: FINXFUN.PRX

@author Mauricio Pequi Jr.
@since 14/08/2002
/*/
//-------------------------------------------------------------------
User Function G3nccLin()

LOCAL lRet := .T.
LOCAL nCont := 1
Local nPosPer  := aScan(aHeader,{|x| AllTrim(x[2]) == "ZH_PERC"})
Local nPosVal  := aScan(aHeader,{|x| AllTrim(x[2]) == "ZH_VALOR"})
Local nPosCus  := aScan(aHeader,{|x| AllTrim(x[2]) == "ZH_CCUSTO"})
Local nPosItCta:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZH_ITEMCTA"})
Local nPosClVl := aScan(aHeader,{|x| AllTrim(x[2]) == "ZH_CLVL"})
Local nTotPerc := 0
Local nDifTot  := 0
Local lAuto := ((Type("lF040Auto")=="L" .and. LF040Auto).or. (Type("lF050Auto")=="L" .and. LF050Auto))
Local lTemEnt := .F.
nValRat := 0

// Atualiza soma de valores
For nCont := 1 to Len(aCols)
	If !(aCols[nCont][nNumCol+1])  // Verifica se linha esta deletada
		nValRat += Round(aCols[nCont][nPosVal],TamSX3("ZH_VALOR")[2])
		If ValType(aCols[nCont][nPosPer]) = "C"
			nTotPerc += Val(StrTran(aCols[nCont][nPosPer],",","."))
		Else
			nTotPerc += aCols[nCont][nPosPer]
		EndIf
	Endif
Next
If !lAuto
	oValRat:Refresh()
Endif

If nTotPerc == 100 //Atingiu 100% de percentual de rateio
	If (nDiftot := nValRat - nValNat) > 0 //Há diferença nos valores totais para menos
		If !(aCols[Len(aCols)][nNumCol+1])
			aCols[Len(aCols)][nPosVal] := aCols[Len(aCols)][nPosVal] - nDifTot
			nValRat := 0
			For nCont := 1 to Len(aCols)
				If !(aCols[nCont][nNumCol+1])
					nValRat += Round(aCols[ncont][nPosVal],TamSX3("ZH_VALOR")[2])
				Endif
			Next
			If !lAuto
				oValRat:Refresh()
			Endif
		EndIf
	EndIf
	If (nDiftot := nValNat - nValRat) > 0 //Há diferença nos valores totais para mais
		If !(aCols[Len(aCols)][nNumCol+1])
			aCols[Len(aCols)][nPosVal] := aCols[Len(aCols)][nPosVal] + nDifTot
			nValRat := 0
			For nCont := 1 to Len(aCols)
				If !(aCols[nCont][nNumCol+1])
					nValRat += Round(aCols[ncont][nPosVal],TamSX3("ZH_VALOR")[2])
				Endif
			Next
			If !lAuto
				oValRat:Refresh()
			Endif
		EndIf
	EndIf
EndIf

//Verifico se os campos necessários foram preenchidos e se a linha não esta deletada
If (Empty(aCols[n][nPosCus]) .or. Empty(aCols[n][nPosVal]) .or. Empty(aCols[n][nPosPer])) .and.;
	!aCols[n][nNumCol+1]
	Help(" ",1,"OBRIGAT2")
	lRet := .F.
Endif

lTemEnt := .T.
// Se o Centro de custo j  estiver registrada e nao estiver apagada, nao permite nova
// distribuicao para o mesmo centro de custo
If lTemEnt .and. CtbQtdEntd() > 4
	lRet := CTBent050()
Else
	If lRet
		nAscan := Ascan( aCols, { |e| 	e[nPosCus] == aCols[n][nPosCus] .And. e[nPosItCta] == aCols[n][nPosItCta] .And.;
		e[nPosClVl] == aCols[n][nPosClVl] .And. !e[len(e)] } )
		If nAscan > 0 .And. n != nAscan .And. !aCols[n][nNumCol+1]
			Alert("Combinação de entidades repetida")
			lRet := .F.
		Endif
	Endif
Endif
Return lRet
//-------------------------------------------------------------------
/*/{Protheus.doc} G3NCCTOK

Validação de Tudo OK da tela de rateio multinatureza por C.Custo.
Arquivo original: FINXFUN.PRX

@author Mauricio Pequi Jr.
@since 14/08/2002
/*/
//-------------------------------------------------------------------
User Function G3nccTOk()

LOCAL lRet := .T.
LOCAL nCont := 0
LOCAL nPosVal := Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim("ZH_VALOR") } )

nValRat := 0

// Atualiza soma de valores
For nCont := 1 to Len(aCols)
	If !(aCols[nCont][nNumCol+1])  // Verifica se linha esta deletada
		n := nCont
		nValRat += aCols[ncont][nPosVal]
		If ! U_G3nccLin()
			Return .F.
		Endif
	Endif
Next
oValRat:Refresh()

// Se a soma for maior que o valor a ser distribuido ou se foi pressionado
// Ok e a Soma for diferente do valor distribuido, avisa e invalida o valor
// digitado
If lRet .And.	(Val(Str(nValRat,17,2)) > Val(Str(nValNat,17,2)) .Or. (nOpcC == 1 .And. Str(nValRat,17,2) != Str(nValNat,17,2)))
	Help(	" ",1,"TOTDISTRCC",, "Total Natureza:    " + Trans(nValNat,PesqPict("SZH","ZH_VALOR",19))+Chr(13)+ "Total Distribuido: "+Trans(nValRat,PesqPict("SZH","ZH_VALOR",19)), 4, 0)
	lRet := .F.
Endif

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} GRVSZGSZH

Grava os arquivos referentes a multiplas naturezas (FINA040/FINA050).
Arquivo original: FINXFUN.PRX

@author Claudio Donizete Souza
@since 08/03/2006
/*/
//-------------------------------------------------------------------
Static Function GRVSZGSZH(cAlias, aColsSZG, aHeaderSZH, nVlrTit) //, nImpostos, lRatImpostos,	cOrigem, lContabiliza, nHdlPrv, nTotal, cArquivo, lDesdobr)

LOCAL cCampo    	:= Right(cAlias,2)
LOCAL aArea 		:= GetArea()
LOCAL aArea1 		:= (cAlias)->(GetArea())
LOCAL nRecno		:= (cAlias)->(Recno())
LOCAL nX
LOCAL aDiff 		:= {0,0,0,0,0,0}
LOCAL aPosDiff 		:= {0,0,0,0,0,0}

LOCAL nCont 		:= nCont1 := nCont2 := nCont3 := nCont4 := nCont5 := nCont6 := 0
LOCAL aDadosTit 	:= {}

LOCAL lConta		:= .F.
Local lRet			:=.T.
Local aRatRet 		:= {}

Private nVlTit := nVlrTit //utilizada dentro da validação do rateio

DbSelectArea(cAlias)
(cAlias)->(DbSetOrder(1))


// Inicia processo de gravacao das multiplas naturezas. O titulo deve estar gravado
(cAlias)->(DbGoto(nRecno))
nCont := 0

For nX := 1 To Len(aColsSZG)
	// Se a linha de aColsSZG nao estiver deletada e o registro nao for
	// encontrado no SZG
	lCtbRatCC := .F.
	If	!aColsSZG[nX][Len(aColsSZG[nX])]
		RecLock("SZG", .T. )
		
		// Grava todos os campos da tela
		aEval(aHeaderSZG, {|e,ni| If(e[8] <> "M" .And. e[10] <> "V" .And. Alltrim(e[2]) != "ZG_PERC", FieldPut(FieldPos(e[2]),aColsSZG[nX][ni]),Nil) } )
		
		SZG->ZG_FILIAL   := xFilial("SZG")
		SZG->ZG_NUM      := (cAlias)->&(cCampo + "_NUMSOL")
		SZG->ZG_CLIFOR   := (cAlias)->&(cCampo + "_FORNECE")
		SZG->ZG_LOJA     := (cAlias)->&(cCampo + "_LOJA")
		SZG->ZG_TIPO     := (cAlias)->&(cCampo + "_TIPO")
		SZG->ZG_NATUREZ  := aColsSZG[nX][1] // Grava a natureza
		SZG->ZG_VALOR    := aColsSZG[nX][2] // Grava o valor informado
		// Grava o percentual (Como indice multiplicador, por esta razao nao
		// multiplica por 100 na gravacao, apenas na exibicao)
		SZG->ZG_PERC     := (aColsSZG[nX][2] / nVlTit)
		SZG->ZG_RATEICC  := aColsSZG[nX][4]  // Identificador de Rateio C Custo
		MsUnLock()
		
		SZH->(dbSetOrder(1)) // Possui Rateio c.Custo
		If Select("SZHTMP") > 0 .And. aColsSZG[nX][4] == "1" .and. (!SZH->(MsSeek(xFilial("SZH")+(cAlias)->&(cCampo + "_NUMSOL")+(cAlias)->&(cCampo + "_TIPO")+(cAlias)->&(cCampo + "_FORNECE")+(cAlias)->&(cCampo + "_LOJA")+aColsSZG[nX][1] )))
			//Gravacao dos dados do rateio C.custo
			dbSelectArea("SZHTMP")
			
			// busca natureza no arquivo TMP de Mult Nat C.Custo
			If SZHTMP->(dbSeek(aColsSZG[nX][1]))
				nCont ++
				nCont1 := nCont2 := nCont3 := nCont4 := nCont5 := nCont6 := 0
				While !SZHTMP->(Eof()) .and. SZHTMP->ZH_NATUREZ == aColsSZG[nX][1]
					// Verifica se não foi um movimento deletado no aColsSZG Mult Nat C.Custo e
					If !(SZHTMP->ZH_FLAG)
						If SZHTMP->ZH_RECNO = 0
							SZH->(RecLock("SZH",.T.))
						Else
							SZH->(DbGoto(SZHTMP->ZH_RECNO))
							If SZH->(Deleted())			// Alteracao de natureza
								SZH->(RecLock("SZH",.T.))
							Else
								SZH->(RecLock("SZH",.F.))
							Endif
						Endif
						// Grava todos os campos do temporario no arquivo principal
						aEval(SZHTMP->(DbStruct()), { |e| If(  Alltrim(e[2]) != "ZG_PERC", SZH->(FieldPut(FieldPos(e[1]),SZHTMP->(FieldGet(FieldPos(e[1]))))), Nil) } )
						
						SZH->ZH_FILIAL		:= xFilial("SZH")
						SZH->ZH_NUM			:= (cAlias)->&(cCampo + "_NUMSOL")
						SZH->ZH_CLIFOR		:= (cAlias)->&(cCampo + If(cAlias == "SE1", "_CLIENTE","_FORNECE"))
						SZH->ZH_LOJA		:= (cAlias)->&(cCampo + "_LOJA")
						SZH->ZH_TIPO		:= (cAlias)->&(cCampo + "_TIPO")
						SZH->ZH_NATUREZ	:= aColsSZG[nX][1] // Grava a natureza
						SZH->ZH_VALOR		:= SZHTMP->ZH_VALOR // Grava o valor informado
						SZH->ZH_PERC		:= SZHTMP->ZH_PERC
						SZH->ZH_CCUSTO		:= SZHTMP->ZH_CCUSTO  // Centro de Custo
						SZH->ZH_ITEMCTA	:= SZHTMP->ZH_ITEMCTA  // Item
						SZH->ZH_CLVL   	:= SZHTMP->ZH_CLVL     // Classe de Valor
						If lConta
							SZH->ZH_CONTA := SZHTMP->ZH_CONTA
						EndIf
						SZH->(MsUnlock())
					ElseIf SZHTMP->ZH_RECNO > 0
						SZH->(DbGoto(SZHTMP->ZH_RECNO))
						SZH->(RecLock("SZH",.F.))
						SZH->(DbDelete())
						SZH->(MsUnlock())
					Endif
					dbSelectArea("SZHTMP")
					SZHTMP->(DbSkip(+1))
				Enddo
			Endif
			(cAlias)->(RestArea(aArea1))
		Endif
	Endif
Next
//Se existir temporario para rateio c. custo, deleta
If Select("SZHTMP") > 0 
	If cArqSZH <> Nil
		dbSelectArea("SZHTMP")
		dbCloseArea()
		Ferase(cArqSZH+GetDBExtension())
		Ferase(cArqSZH+OrdBagExt())
	Endif
Endif
RestArea(aArea)
(cAlias)->(RestArea(aArea1))

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} G03SolEC()
Função para preparar validaçao solicitante X entidade contábil
@author antenor.silva
@since 30/08/2013                                           
@version 1.0
@return lRet 
/*/
//-------------------------------------------------------------------
User Function G03SolEC()

Local lRet			:= .T.
Local cEC  		    := &(ReadVar())
Local cCampo 		:= "ZF_CC"    //ReadVar()  REMOVIDO READVAR POIS O CAMPO CRIADO É ZF_CCUSTO E NA DBK É DBK_CC
Local cTab			:= Substr( ReadVar() , At(">",ReadVar())+1 , At("_",ReadVar()) - At(">",ReadVar()) -1 )
Local cProd		    := "*"
Local lAPROVSP	    := GetMV("GE_VLDSOCC",.F.,.T.)   //Default TRUE

If  !(Empty(cEC)) .And. lAprovSP
	lRet := MTVLDSOLEC(cProd,cEC,cCampo)
EndIf
	
If !lRet
	Aviso("Atencao","Não existe amarração deste usuario para o Centro de Custos digitado.",{"Retornar"},3,"GE_VLDSOCC-Validacao Ativa")
	//Help(' ', 1,'SOLEC - GEFINA03')
EndIf

Return lRet
//-------------------------------------------------------------------
/*/{Protheus.doc} G03SolEC()
Função para preparar validaçao solicitante X entidade contábil
@author antenor.silva
@since 30/08/2013                                           
@version 1.0
@return lRet 
/*/
//-------------------------------------------------------------------
Static Function G03Posic(cAlias,nReg,nOpcx,cTipoDoc,lStatus,lResid)

Local aArea			:= GetArea()
Local aSavCols		:= {}
Local aSavHead		:= {}
Local cHelpApv		:= OemToAnsi("Este documento nao possui controle de aprovacao ou deve ser aprovado pelo controle de alçadas.") 
Local cAliasSCR		:= GetNextAlias()
Local cComprador	:= ""
Local cSituaca  	:= ""
Local cNumDoc		:= ""
Local cStatus		:= "Documento aprovado" 
Local cTitle		:= ""
Local cTitDoc		:= ""
Local cAddHeader	:= ""
Local cAprovador	:= ""
Local nSavN			:= 0
Local nX   			:= 0
Local oDlg			:= NIL
Local oGet			:= NIL
Local oBold			:= NIL
Local cQuery   		:= ""
Local aStruSCR 		:= SCR->(dbStruct())
Local lExAprov		:= SuperGetMV("MV_EXAPROV",.F.,.F.)

DEFAULT cTipoDoc := "PC"
DEFAULT lStatus  := .T.
DEFAULT lResid   := .F.
DEFAULT nOpcx    := 2
DEFAULT aRotina := MenuDef()

SaveInter()

Private aCols := {}
Private aHeader := {}
Private N := 1

dbSelectArea(cAlias)
MsGoto(nReg)

cTitle  	:= OemToAnsi("Aprovacao da Solicitacao Pagamento")
cTitDoc 	:= OemToAnsi("Solicitacao")
cHelpApv	:= OemToAnsi("Esta Solicitacao de Pagamento nao possui controle de aprovacao.")
cNumDoc 	:= SZF->ZF_NUMSOL
cComprador	:= UsrRetName(SZF->ZF_USER)

aHeader:= {}
aCols  := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz a montagem do aHeader com os campos fixos.               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SX3->(dbSetOrder(1))
SX3->(MsSeek("SCR"))

AADD(aHeader,{"Item","bCR_ITEM","",8,0,"","","C","",""} )	

While !SX3->(EOF()) .And. (SX3->X3_ARQUIVO == "SCR")
	IF AllTrim(SX3->X3_CAMPO)$"CR_NIVEL/CR_OBS/CR_DATALIB/" + cAddHeader
		AADD(aHeader,{	TRIM(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		If AllTrim(SX3->X3_CAMPO) == "CR_NIVEL"
			AADD(aHeader,{ OemToAnsi("Aprovador Responsável"),"bCR_NOME",   "",15,0,"","","C","",""} )	
			AADD(aHeader,{ OemToAnsi("Situação"),"bCR_SITUACA","",20,0,"","","C","",""} )	
			AADD(aHeader,{ OemToAnsi("Avaliado por"),"bCR_NOMELIB","",15,0,"","","C","",""} )	
		EndIf
	Endif
	SX3->(dbSkip())
EndDo
ADHeadRec("SCR",aHeader)

cAliasSCR := GetNextAlias()
cQuery    := "SELECT SCR.*,DBM.DBM_ITEM,DBM.DBM_ITEMRA,SCR.R_E_C_N_O_ SCRRECNO "
cQuery	   += "FROM "+RetSqlName("SCR")+" SCR INNER JOIN "
cQuery	   += RetSqlName("DBM")+" DBM ON "
cQuery	   += "DBM_FILIAL = '"+xFilial("DBM")+"' AND "
cQuery	   += "CR_TIPO=DBM_TIPO AND "
cQuery	   += "CR_NUM=DBM_NUM AND "
cQuery	   += "CR_GRUPO=DBM_GRUPO AND "
cQuery	   += "CR_ITGRP=DBM_ITGRP AND "
cQuery	   += "CR_USER=DBM_USER AND "
cQuery	   += "CR_USERORI=DBM_USEROR AND "
cQuery	   += "CR_APROV=DBM_USAPRO AND "
cQuery	   += "CR_APRORI=DBM_USAPOR "
cQuery    += "WHERE SCR.CR_FILIAL='"+xFilial("SCR")+"' AND "
cQuery    += "SCR.CR_NUM = '"+Padr(SZF->ZF_NUMSOL,Len(SCR->CR_NUM))+"' AND "
cQuery    += "SCR.CR_TIPO = 'SP' "
If !lExAprov 
	cQuery    += "AND DBM.D_E_L_E_T_=' ' "
	cQuery    += "AND SCR.D_E_L_E_T_=' ' "
EndIf
cQuery += "ORDER BY "+SqlOrder(SCR->(IndexKey()))
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSCR)

For nX := 1 To Len(aStruSCR)
	If aStruSCR[nX][2]<>"C"
		TcSetField(cAliasSCR,aStruSCR[nX][1],aStruSCR[nX][2],aStruSCR[nX][3],aStruSCR[nX][4])
	EndIf
Next nX

While !(cAliasSCR)->(Eof())
	aAdd(aCols,Array(Len(aHeader)+1))
	
	For nX := 1 to Len(aHeader)
		If IsHeadRec(aHeader[nX][2])
			aTail(aCols)[nX] := (cAliasSCR)->SCRRECNO
		ElseIf IsHeadAlias(aHeader[nX][2])
			aTail(aCols)[nX] := "SCR"
		ElseIf aHeader[nX][02] == "bCR_NOME"
			aTail(aCols)[nX] := UsrRetName((cAliasSCR)->CR_USER)
		ElseIf aHeader[nX][02] == "bCR_ITEM"
			aTail(aCols)[nX] := AllTrim((cAliasSCR)->DBM_ITEM) + IIF(!Empty((cAliasSCR)->DBM_ITEMRA),"-"+(cAliasSCR)->DBM_ITEMRA,"")
		ElseIf aHeader[nX][02] == "bCR_SITUACA"
			Do Case
				Case (cAliasSCR)->CR_STATUS == "01"
					cSituaca := OemToAnsi("Pendente em níveis anteriores") 
					If cStatus == "Documento aprovado" 
						cStatus := "Aguardando liberação(ões)"
					EndIf
				Case (cAliasSCR)->CR_STATUS $ "02|04"
					cSituaca := OemToAnsi("Pendente")
					If cStatus == "Documento aprovado"
						cStatus := "Aguardando liberação(ões)"
					EndIf
				Case (cAliasSCR)->CR_STATUS == "03"
					cSituaca := OemToAnsi("Aprovado") 
				Case (cAliasSCR)->CR_STATUS == "05"
					cSituaca := OemToAnsi("Aprovado/rejeitado pelo nível") 
				Case (cAliasSCR)->CR_STATUS == "06"
					cSituaca := "Rejeitado"
					If cStatus # "Documento rejeitado"
						cStatus := "Documento rejeitado"
					EndIf
			EndCase
			aTail(aCols)[nX] := cSituaca
		ElseIf aHeader[nX][02] == "bCR_NOMELIB"
			aTail(aCols)[nX] := UsrRetName((cAliasSCR)->CR_USERLIB)
		ElseIf Alltrim(aHeader[nX][02]) == "CR_OBS"//Posicionar para ler
			SCR->(dbGoto((cAliasSCR)->SCRRECNO))
			aTail(aCols)[nX] := SCR->CR_OBS
		ElseIf ( aHeader[nX][10] != "V")
			aTail(aCols)[nX] := FieldGet(FieldPos(aHeader[nX][2]))
		EndIf
	Next nX
	aTail(aCols)[Len(aHeader)+1] := .F.
	(cAliasSCR)->(dbSkip())
EndDo

If !Empty(aCols)
	n:=	 IIF(n > Len(aCols), Len(aCols), n)  // Feito isto p/evitar erro fatal(Array out of Bounds).
	DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
	DEFINE MSDIALOG oDlg TITLE cTitle From 109,095 To 400,600 OF oMainWnd PIXEL	 //"Aprovacao do Pedido de Compra // Contrato"
	@ 005,003 TO 032,250 LABEL "" OF oDlg PIXEL
	@ 015,007 SAY cTitDoc OF oDlg FONT oBold PIXEL SIZE 046,009 
	@ 014,041 MSGET cNumDoc PICTURE "@!" WHEN .F. PIXEL SIZE 040,009 OF oDlg FONT oBold
	@ 015,095 SAY OemToAnsi("Comprador") OF oDlg PIXEL SIZE 045,009 FONT oBold 
	@ 014,138 MSGET cComprador PICTURE "" WHEN .F. of oDlg PIXEL SIZE 103,009 FONT oBold
	@ 132,008 SAY 'Situacao :' OF oDlg PIXEL SIZE 052,009 
	@ 132,038 SAY cStatus OF oDlg PIXEL SIZE 120,009 FONT oBold
	@ 132,205 BUTTON 'Fechar' SIZE 035 ,010  FONT oDlg:oFont ACTION (oDlg:End()) OF oDlg PIXEL  
	oGet:= MSGetDados():New(038,003,120,250,nOpcx,,,"")
	oGet:Refresh()
	@ 126,002 TO 127,250 LABEL "" OF oDlg PIXEL
	ACTIVATE MSDIALOG oDlg CENTERED
Else
	Aviso("Atencao",cHelpApv,{"Voltar"},3,"GEFINA03-Consulta Aprovacao") 
EndIf

(cAliasSCR)->(dbCloseArea())

SaveInter()

dbSelectArea(cAlias)
RestArea(aArea)
Return NIL
//-------------------------------------------------------------------
/*/{Protheus.doc} CCCARREXT

Carrega definicoes do rateio externo baseado no CTJ (Multiplas Naturezas 
por C.Custo).
Arquivo original: FINXFUN.PRX 

@author Wagner Mobile Costa
@since 21/10/2002
/*/
//-------------------------------------------------------------------
Static Function G3CarrExt(aCols, aHeader, cItem, lPrimeiro)

LOCAL nPosCta   := Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim("ZH_CONTA") } )
LOCAL nPosCus   := Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim("ZH_CCUSTO") } )
LOCAL nPosVal   := Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim("ZH_VALOR") } )
LOCAL nPosPer   := Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim("ZH_PERC") } )
LOCAL nPosItCta := Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim("ZH_ITEMCTA") } )
LOCAL nPosClVl  := Ascan(aHeader, {|e| AllTrim(e[2]) == AllTrim("ZH_CLVL") } )
LOCAL lConta	:= 	AllWaysTrue() //( ( IsInCallStack("FINA050") .Or. IsInCallStack("FINA080") .Or. IsInCallStack("FINA090") ) )

LOCAL nCols
Local nX 		:= 0
Local nRatTot  := 0
Local nPercTot := 0

Local lCtbIsCube    := .T.
Local aEntidades	:= {}
Local nEnt			:= 0
Local nDeb			:= 0

If lPrimeiro
	Return .T.
Endif

// Varifica se ja existe um percentual informado, caso nao exista
// utiliza a linha atual para carregar os percentuais do CTJ. Senao
// Cria uma nova linha no aCols e le os percentuais do CTJ.
//If Val(StrTran(aCols[Len(aCols)][nPosPer],",",".")) = 0
If aCols[Len(aCols)][nPosPer] = 0
	nCols := Len(aCols)
Else
	//Cria uma nova linha e grava o flag de deleção na ultima posição.
	Aadd(aCols, Array(Len(aHeader)))
	Aadd(aCols[Len(aCols)], .F.)
	nCols := Len(aCols)
Endif

If lConta
	If ! Empty(CTJ->CTJ_DEBITO)
		aCols[nCols][nPosCta] := Padl(CTJ->CTJ_DEBITO,  Len(CTJ->CTJ_DEBITO))
	Else
		aCols[nCols][nPosCta] := Padl(CTJ->CTJ_CREDIT,  Len(CTJ->CTJ_CREDIT))
	Endif
EndIf

If ! Empty(CTJ->CTJ_CCD)
	aCols[nCols][nPosCus] := Padl(CTJ->CTJ_CCD,  Len(CTJ->CTJ_CCD))
Else
	aCols[nCols][nPosCus] := Padl(CTJ->CTJ_CCC,  Len(CTJ->CTJ_CCC))
Endif
aCols[nCols][nPosVal] := nValNat * (CTJ->CTJ_PERCEN / 100)
aCols[nCols][nPosPer] := Transform(CTJ->CTJ_PERCEN, "@E 999.99")
If ! Empty(CTJ->CTJ_ITEMD)
	aCols[nCols][nPosItCta] := Padl(CTJ->CTJ_ITEMD,  Len(CTJ->CTJ_ITEMD))
Else
	aCols[nCols][nPosItCta] := Padl(CTJ->CTJ_ITEMC,  Len(CTJ->CTJ_ITEMC))
Endif

If ! Empty(CTJ->CTJ_CLVLDB)
	aCols[nCols][nPosClVl] := Padl(CTJ->CTJ_CLVLDB,  Len(CTJ->CTJ_CLVLDB))
Else
	aCols[nCols][nPosClVl] := Padl(CTJ->CTJ_CLVLCR,  Len(CTJ->CTJ_CLVLCR))
Endif

If lCtbIsCube
	aEntidades := CtbEntArr()
	For nEnt := 1 to Len(aEntidades)
		For nDeb := 1 to 2
			cCpo := "ZH_EC"+aEntidades[nEnt]
			cCTJ := "CTJ_EC"+aEntidades[nEnt]

			If nDeb == 1
				cCpo += "DB"
				cCTJ += "DB"
			Else
				cCpo += "CR"
				cCTJ += "CR"
			EndIf

			nPosHead := aScan(aHeader,{|x| AllTrim(x[2]) == Alltrim(cCpo) } )

			If nPosHead > 0 .And. CTJ->(FieldPos(cCTJ)) > 0
				aCols[nCols][nPosHead] := CTJ->(&(cCTJ))
			EndIf

		Next nDeb
	Next nEnt
EndIf


If !lPrimeiro
	For nX := 1 To Len(aCols)
		If ValType(aCols[nX][nPosPer]) = "C"
			nPercTot += Val(StrTran(aCols[nX][nPosPer],",","."))
		Else
			nPercTot += aCols[nX][nPosPer]
		EndIf
	Next nX

	If nPercTot == 100 //Atingiu 100% de rateio
		For nX := 1 To Len(aCols)
			nRatTot += Round(aCols[nX][nPosVal],TamSX3("ZH_VALOR")[2])
		Next nX

		If nRatTot > nValNat //Há diferença para mais
			aCols[Len(aCols)][nPosVal] := aCols[Len(aCols)][nPosVal] - (nRatTot - nValNat)
		EndIf

		If nValNat > nRatTot //Há diferença para menos
			aCols[Len(aCols)][nPosVal] := aCols[Len(aCols)][nPosVal] + (nValNat - nRatTot)
		EndIf

	EndIf
EndIf
Return .T.

/*/{Protheus.doc} GEF03VNT
Validação de natureza bloqueada
@param: Nil
@author: VitorAoki
@since: 17/01/2017
@Obs: Solicitacao Pagamento Manual A Geradora
@type function
/*/
User Function GEF03VNT(cNatureza)
Local lRet:= .T.
Default cNatureza := ""

SED->(DbSetOrder(1))
If SED->(DbSeek(xFilial("SED")+cNatureza) ) .AND. !Empty(cNatureza)
	If SED->ED_MSBLQL == "1" 
		HELP(" ",1,"REGBLOQ")
		lRet := .F.
	Endif
Else
	HELP("Natureza nao encontrada",1,"GEFINA03")
	lRet := .F.
EndIf

Return lRet

/*/{Protheus.doc} GEF03Tp
Validação de Tipo
@param: Nil
@author: VitorAoki
@since: 17/01/2017
@Obs: Solicitacao Pagamento Manual A Geradora
@type function
/*/
User Function GEF03Tp()
Local lRet:= .T.

If M->ZF_TIPO="PA" .AND. Alltrim(M->ZF_TIPOSOL)<>"PA"
	HELP("Não pode ser utilizado Tipo Titulo=PA sendo que foi utilizado Tipo Pagto=CAP.",1,"GEFINA03")
	lRet := .F.
EndIf

Return lRet

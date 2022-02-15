#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOTVS.CH"
#Include "FWMVCDEF.CH"
#include 'parmtype.ch'
#include "topconn.ch"
//--------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} MOD1FRETE
Objetivo: Rotina para inserir dados do para controle do frete na aprovação o sistema gera pedido de compras.
@type function
@author Elisângela Souza
@since  26/06/2018
@version 1.0
/*/
//--------------------------------------------------------------------------------------------------------------------

User Function MOD1FRETE()

Local oBrowse	:= Nil

oBrowse := FWmBrowse():New()
oBrowse:SetAlias("SZJ")	//Cadastro de Frete
oBrowse:AddLegend( "ALLTRIM(ZJ_STATUS)=='1'", "BR_VERDE"	   , "Ativa" )
oBrowse:AddLegend( "ALLTRIM(ZJ_STATUS)=='2'", "BR_AMARELO"  , "Suspensa" )
oBrowse:AddLegend( "ALLTRIM(ZJ_STATUS)=='3'", "BR_VERMELHO" , "Encerrada" )
oBrowse:SetDescription('Cadastro de Frete')
oBrowse:Activate()

Return ()
        
//
Static Function MenuDef()

Local aRotina := {}

ADD OPTION aRotina TITLE '&Visualizar'	ACTION 'VIEWDEF.MOD1FRETE' 	OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE '&Incluir'	    ACTION 'VIEWDEF.MOD1FRETE' 	OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE '&Alterar'	    ACTION 'VIEWDEF.MOD1FRETE' 	OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE '&Excluir'	    ACTION 'VIEWDEF.MOD1FRETE' 	OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Im&primir'	ACTION 'VIEWDEF.MOD1FRETE' 	OPERATION 8 ACCESS 0
ADD OPTION aRotina TITLE '&Copiar'		ACTION 'VIEWDEF.MOD1FRETE' 	OPERATION 9 ACCESS 0
ADD OPTION aRotina Title 'Legenda'		Action 'U_EXERC01A'			OPERATION 8 ACCESS 0

Return aRotina
             
//
Static Function ModelDef()

Local oStruSZJ := FWFormStruct(1, 'SZJ' )
Local oModel   := MPFormModel():New('FRETEM')

oModel:AddFields( 'SZJMASTER', /*cOwner*/, oStruSZJ)
oModel:SetDescription( 'Frete' )
oModel:GetModel( 'SZJMASTER' ):SetDescription( 'Frete')

Return oModel

//
Static Function ViewDef()

Local oModel   := FWLoadModel( 'MOD1FRETE' )
Local oStruSZJ := FWFormStruct( 2, 'SZJ' )
Local oView	   := FWFormView():New()

oView:SetModel( oModel )
oView:AddField( 'VIEW_SZJ', oStruSZJ, 'SZJMASTER' )
oView:CreateHorizontalBox( 'TELASZJ' , 100 )
oView:SetOwnerView( 'VIEW_SZJ', 'TELASZJ' )

Return oView

/*Local aCores := {{ "ZJ_STATUS == 1",'BR_VERDE'},{ "ZJ_STATUS == 2",'BR_VERMELHO'}}

Private cCadastro	:= "Controle de Frete"
Private aRotina 	:= Menudef()

DbSelectArea("SZJ")
SZJ->( DbSetOrder(1))
SZJ->( DbGoTop())

mBrowse( 6,1,22,75,"SZJ",,,,,,aCores)

Return*/

// Função Menu
/*Static Function MenuDef()

Local aRotina := {}

aAdd( aRotina, { 'Visualizar', 'VIEWDEF.XFRETE_MVC', 0, 2, 0, NIL } )
aAdd( aRotina, { 'Incluir'   , 'VIEWDEF.XFRETE_MVC', 0, 3, 0, NIL } )
aAdd( aRotina, { 'Alterar'   , 'VIEWDEF.XFRETE_MVC', 0, 4, 0, NIL } )
aAdd( aRotina, { 'Excluir'   , 'VIEWDEF.XFRETE_MVC', 0, 5, 0, NIL } )
aAdd( aRotina, { 'Imprimir'  , 'VIEWDEF.XFRETE_MVC', 0, 8, 0, NIL } )
aAdd( aRotina, { 'Copiar'    , 'VIEWDEF.XFRETE_MVC', 0, 9, 0, NIL } )

Return aRotina
  */

/*Static Function Menudef

Local aRotina := {}

ADD OPTION aRotina Title 'Pesquisa'           Action 'AxPesqui'       OPERATION 1 ACCESS 0
ADD OPTION aRotina Title 'Visualizar'         Action 'U_telaCadFrete' OPERATION 2 ACCESS 0
ADD OPTION aRotina Title 'Incluir'            Action 'U_telaCadFrete' OPERATION 3 ACCESS 0
ADD OPTION aRotina Title 'Alterar' 	          Action 'U_telaCadFrete' OPERATION 4 ACCESS 0
ADD OPTION aRotina Title 'Excluir'            Action 'U_telaCadFrete' OPERATION 5 ACCESS 0
ADD OPTION aRotina Title 'Legenda'            Action 'U_SZJLEG'       OPERATION 6 ACCESS 0
ADD OPTION aRotina Title 'AproVar/DesaproVar' Action 'U_AprovaFrete'  OPERATION 7 ACCESS 0
ADD OPTION aRotina Title 'Conhecimento' 	  Action 'MsDocument'     OPERATION 4 ACCESS 0

Return aRotina*/

    /*
// Tela de movimentação
User Function telaCadFrete(cAlias, nReg, nOpc)

Local n_Brw1 		:= GD_UPDATE+GD_INSERT+GD_DELETE
Local aSizeAuto 	:= MsAdvSize()
Local lHasButton	:= .T.
Local UserID 		:= __cUserID
Local aacampo 		:= {"ZJ_CODIGO"}
Local cRet

cRet 			:= FWUsrGrpRule(UserID)
aGroups 		:= UsrRetGrp(cUserName, UserID)
cPosGrupoAprova	:= AsCan(aGroups, "000028")

Private cCSSGet		:= "QLineEdit{ border: 1px solid #ff0000;border-radius: 3px;selection-background-color: #3366cc;selection-color: #ffffff;padding-left:1px;}"
Private cCSSGetn	:= "QLineEdit{ border: 1px solid #d4d4d4;border-radius: 3px;selection-background-color: #3366cc;selection-color: #ffffff;padding-left:1px;}"
Private cGet1      	:= Space(50)
Private cGet2      	:= Iif(nOpc=3, GetSxeNum(cAlias,"ZJ_CODIGO"), Space(6))
Private cGet3      	:= Space(TamSx3("ZJ_TIPO")[1])
Private cGet4      	:= Space(TamSx3("ZJ_VALOR")[1])
Private cGet5      	:= Space(TamSx3("ZJ_DATA")[1])
Private cGet6      	:= Space(TamSx3("ZJ_FORNECE")[1])
Private cGet7      	:= Space(TamSx3("ZJ_LOJA")[1])
Private cGet8      	:= Space(TamSx3("ZJ_NOMFOR")[1])
Private cGet9      	:= Space(TamSx3("ZJ_CLIENTE")[1])
Private cGet10     	:= Space(TamSx3("ZJ_LOJACLI")[1])
Private cGet11     	:= Space(TamSx3("ZJ_NOMECLI")[1])
Private cGet12     	:= Space(TamSx3("ZJ_CONTRAT")[1])
Private cGet13     	:= Space(TamSx3("ZJ_FRETE")[1])
Private cGet14     	:= Space(TamSx3("ZJ_UFORI")[1])
Private cGet15     	:= Space(TamSx3("ZJ_CIDORI")[1])
Private cGet16     	:= Space(TamSx3("ZJ_UFDEST")[1])
Private cGet17     	:= Space(TamSx3("ZJ_CIDDEST")[1])
Private cGet18     	:= Space(TamSx3("ZJ_VLCOB")[1])
Private cGet19     	:= Space(TamSx3("ZJ_SALDO")[1])
Private cGet20     	:= Space(TamSx3("ZJ_DKM")[1])
Private cGet21     	:= Space(TamSx3("ZJ_TVEIC")[1])
Private cGet22     	:= Space(TamSx3("ZJ_NOMV")[1])
Private cGet23     	:= Space(TamSx3("ZJ_MESREF")[1])
Private cGet24     	:= Space(TamSx3("ZJ_NUMNF")[1])
Private cGet25     	:= Space(TamSx3("ZJ_TIPONF")[1])
Private cGet26     	:= Space(TamSx3("ZJ_SALDO")[1])
Private cGet27     	:= Space(TamSx3("ZJ_CONDPG")[1])
Private cGet28     	:= Space(TamSx3("ZJ_PRODUTO")[1])
Private cGet29     	:= Space(TamSx3("ZJ_DESCRI")[1])
Private cGet30     	:= Space(TamSx3("ZJ_CONTA")[1])
Private cGet31     	:= Space(TamSx3("ZJ_CC")[1])
Private cGet32     	:= 0 
Private cGet33     	:= Space(TamSx3("ZJ_FSPROJ")[1])
Private cGet34     	:= Space(TamSx3("ZJ_FSTPGT")[1])
Private _xSaldo		:= 0

Private aHeader 	:= {}
Private aCOLS 		:= {}
Private aREG 		:= {}
Private n_Usado 	:= 0
Private cFilialSel	:= xFilial(cAlias)

If Empty(cGet1)
	Dbselectarea("CTD")
	CTD->( Dbsetorder(1))
	If CTD->( Dbseek(xFilial("CTD")+cFilialSel))
		cGet1 := CTD->CTD_DESC01
	EndIf
EndIf

DbSelectArea( cAlias )
DbSetOrder(1)

SetPrvt("oDlg1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oSay8","oSay9","oSay10","oSay11")
SetPrvt("oSay13","oSay14","oSay15","oSay16","oSay17","oSay18","oSay19","oSay20","oSay21","oSay22","oSay23")
SetPrvt("oSay25","oSay26","oGet1","oGet2","oGet3","oGet4","oGet5","oGet6","oGet7","oGet8","oGet9","oGet10","oGet11")
SetPrvt("oGet13","oGet14","oGet15","oGet16","oGet17","oGet18","oGet19","oGet20","oGet21","oGet22","oGet23")
SetPrvt("oGet25","oGet26","oSay27","oSay28","oSay29","oGet27","oGet28","oGet29","oSay30","oGet30","oSay31","oGet31")
SetPrvt("oSay32","oGet32")

Define Dialog oDlg1 Title "Formulário de Lançamento de Frete" From aSizeAuto[7]+50, 020 To aSizeAuto[6]-20, aSizeAuto[5]-40 Pixel

oSay1      := TSay():New( 038,012,{||"Filial"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet1      := TGet():New( 046,012,{|u| If(PCount()>0,cGet1:=u,cGet1)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet1",,)
oGet1:Disable()

oSay2      := TSay():New( 038,088,{||"Código"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet2      := TGet():New( 046,084,{|u| If(PCount()>0,cGet2:=u,cGet2)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet2",,)
oGet2:Disable()

oSay3   := TSay():New( 038,164,{||"Tipo Frete"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
aGet3 	:= StrTokArr(GetMV("XZJ_TIPO"), ";")
cGet3	:= aGet3[1]
oGet3 	:= TComboBox():New(046,164,{|u|if(PCount()>0,cGet3:=u,cGet3)}, aGet3,060,008,oDlg1,,,{|| f_VldCombo(cGet3, oGet3)},,,.T.,,,,,,,,,'cGet3')

oSay23  := TSay():New( 038,240,{||"Mês Referência"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
aGet23 	:= StrTokArr(GetMV("XSZ_MES"), ";")
cGet23	:= aGet23[1]
oGet23 	:= TComboBox():New(046,240,{|u|if(PCount()>0,cGet23:=u,cGet23)}, aGet23,060,008,oDlg1,,,{|| f_VldCombo(cGet23, oGet23)},,,.T.,,,,,,,,,'cGet23')

oSay5  	:= TSay():New( 038,316,{||"Data"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
cGet5 	:= Date()
oGet5   := TGet():New( 046,316,{|u| If(PCount()>0,cGet5:=u,cGet5)},oDlg1,060,008,'',{|| f_VldCampo(cGet5,oGet5) }, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cGet4",,,,lHasButton)

oSay6   := TSay():New( 070,012,{||"Fornecedor"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
@ 078,012 MsGet oGet6 Var cGet6		F3 "FOR" Valid f_VldFornecedor(cGet6, cGet7, @cGet8, @cGet13)      Size 060,008 Of oDlg1 Hasbutton Pixel

oSay7 	:= TSay():New( 070,088,{||"Loja"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet7   := TGet():New( 078,092,{|u| If(PCount()>0,cGet7:=u,cGet7)},oDlg1,060,008,'',{|| f_VldFornecedor(cGet6, cGet7, @cGet8, @cGet13)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet7",,)

oSay8   := TSay():New( 070,164,{||"Nome Fornecedor"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
oGet8   := TGet():New( 078,164,{|u| If(PCount()>0,cGet8:=u,cGet8)},oDlg1,212,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet8",,)
oGet8:Disable()

oSay12  := TSay():New( 102,012,{||"N. Contrato"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
@ 110,012 MsGet oGet12 Var cGet12	F3 "SZJCON" Valid f_Contrato(cGet12,oGet12) Size 060,008 Of oDlg1 Hasbutton Pixel

oSay9 	:= TSay():New( 102,088,{||"Cliente"}    ,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
//@ 110,088 MsGet oGet9 Var cGet9		F3 "XCLI"   Valid f_VldCliente(cGet9,cGet10,@cGet11)  Size 060,008 Of oDlg1 Hasbutton Pixel
//@ 110,088 MsGet oGet9 Var cGet9		 Size 060,008 Of oDlg1 Hasbutton Pixel
oGet9  := TGet():New( 110,088,{|u| If(PCount()>0,cGet9:=u,cGet9)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet9",,)
oGet9:Disable()

oSay10 	:= TSay():New( 102,164,{||"Loja"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
//oGet10  := TGet():New( 110,164,{|u| If(PCount()>0,cGet10:=u,cGet10)},oDlg1,060,008,'',{|| f_VldCliente(cGet9, cGet10, @cGet11)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet10",,)
oGet10  := TGet():New( 110,164,{|u| If(PCount()>0,cGet10:=u,cGet10)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet10",,)
oGet10:Disable()

oSay11  := TSay():New( 102,240,{||"Nome Cliente"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oGet11  := TGet():New( 110,240,{|u| If(PCount()>0,cGet11:=u,cGet11)},oDlg1,212,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet11",,)
oGet11:Disable()
//
oSay13  := TSay():New( 134,012,{||"Tipo"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
aGet13	:= {'0=SELECIONE UM TIPO', '1=PROPRIO','2=TERCEIRO'}
cGet13	:= aGet13[1]
oGet13 	:= TComboBox():New(142,012,,aGet13,060,008,oDlg1,,,{|| },,,.T.,,,,,,,,,'cGet13')
//		   TComboBox():New([nRow],[ nCol],[ bSetGet],[ nItens],[ nWidth],[ nHeight],[ oWnd],[ uParam8],[ bChange],[ bValid], [ nClrBack], [ nClrText], [ lPixel], [ oFont], [ uParam15], [ uParam16], [ bWhen], [ uParam18], [ uParam19], [ uParam20], [ uParam21], [ cReadVar] )
//oGet13 	:= TComboBox():New(142,012,{|u| If(PCount()>0,cGet13:=u,cGet13)}, aGet13,060,008,oDlg1,,,{|| f_VldCombo(cGet13, oGet13)},,,.T.,,,,,,,,,'cGet13')
oGet13:Disable()

oSay4   := TSay():New( 134,088,{||"Valor Custo"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
cGet4 	:= 0
oGet4	:= TGet():New( 142,088,{|u| If(PCount()>0,cGet4:=u,cGet4)},oDlg1,060,008,"@E 999,999.99",{|| f_VldCusto(cGet4, oGet4) }, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cGet4",,,,lHasButton)

cGet18 	:= 0
oSay18  := TSay():New( 134,164,{||"Valor Venda"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
//oGet18  := TGet():New( 142,164,{|u| If(PCount()>0,cGet18:=u,cGet18)},oDlg1,060,008,'@E 999,999.99',{|| f_VldValor(cGet18,oGet18) }, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cGet18",,,,lHasButton)
oGet18  := TGet():New( 142,164,{|u| If(PCount()>0,cGet18:=u,cGet18)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet18",,)
oGet18:Disable()

cGet19 	:= 0
oSay19  := TSay():New( 134,240,{||"Saldo Venda"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
//oGet18  := TGet():New( 142,164,{|u| If(PCount()>0,cGet18:=u,cGet18)},oDlg1,060,008,'@E 999,999.99',{|| f_VldValor(cGet18,oGet18) }, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cGet18",,,,lHasButton)
oGet19  := TGet():New( 142,240,{|u| If(PCount()>0,cGet19:=u,cGet19)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet19",,)
oGet19:Disable()

oSay27  := TSay():New( 134,316,{||"Cond. Pagto"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
@ 142,316 MsGet oGet27 Var cGet27	F3 "SE4" Valid NaoVazio() .And. ExistCpo("SE4")                   Size 060,008 Of oDlg1 Hasbutton Pixel 

oSay14  := TSay():New( 166,012,{||"UF Origem"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
@ 174,012 MsGet oGet14 Var cGet14	F3 "12" Valid NaoVazio() .And. ExistCpo("SX5","12"+cGet14)        Size 060,008 Of oDlg1 Hasbutton Pixel 

oSay15  := TSay():New( 166,088,{||"Cidade Origem"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
@ 174,088 MsGet oGet15 Var cGet15	F3 "SJCC2" Valid NaoVazio() .And. ExistCpo("CC2",cGet14+cGet15,4) Size 060,008 Of oDlg1 Hasbutton Pixel 

oSay16  := TSay():New( 166,164,{||"UF Destino"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
@ 174,164 MsGet oGet16 Var cGet16	F3 "12" Valid NaoVazio() .And. ExistCpo("SX5","12"+cGet16)        Size 060,008 Of oDlg1 Hasbutton Pixel 

oSay17  := TSay():New( 166,240,{||"Cidade Destino"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
@ 174,240 MsGet oGet17 Var cGet17	F3 "ZJCC2"  Valid NaoVazio() .And. ExistCpo("CC2",cGet16+cGet17,4) Size 060,008 Of oDlg1 Hasbutton Pixel  

oSay20  := TSay():New( 166,316,{||"Distância KM"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
cGet20 	:= 0
oGet20  := TGet():New( 174,316,{|u| If(PCount()>0,cGet20:=u,cGet20)},oDlg1,060,008,'@E 9,999',{|| Positivo() .And. f_VldCampo(cGet20,oGet20) }, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cGet20",,,,lHasButton)

oSay21  := TSay():New( 198,012,{||"Tipo de Veículos"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
@ 206,012 MsGet oGet21 Var cGet21	F3 "JT" Valid f_VldNomeVeic(cGet21, @cGet22)      Size 060,008 Of oDlg1 Hasbutton Pixel

oSay22  := TSay():New( 198,088,{||"Nome Veículo"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oGet22  := TGet():New( 206,088,{|u| If(PCount()>0,cGet22:=u,cGet22)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet22",,)
oGet22:Disable()

oSay24  := TSay():New( 198,164,{||"Número NF"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet24  := TGet():New( 206,164,{|u| If(PCount()>0,cGet24:=u,cGet24)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet24",,)
oGet24:Disable()

oSay25  := TSay():New( 198,240,{||"Tipo Nota Fiscal"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
aGet25	:= {'0=SELECIONE UM TIPO', '1=CTRC','2=SERVICO'}
cGet25	:= aGet25[1]
oGet25 	:= TComboBox():New(206,240,{|u| If(PCount()>0,cGet25:=u,cGet25)}, aGet25,060,008,oDlg1,,,,,,.T.,,,,,,,,,'cGet25')
                              
oSay33  := TSay():New( 198,316,{||"Projeto"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
aGet33	:= {'0=DEFINA UM TIPO', '1=SIM', '2=NAO'}
cGet33	:= aGet33[1]
oGet33 	:= TComboBox():New(206,316,{|u| If(PCount()>0,cGet33:=u,cGet33)}, aGet33,060,008,oDlg1,,,{|| f_VldCombo(cGet33, oGet33)},,,.T.,,,,,,,,,'cGet33')

oSay34  := TSay():New( 198,392,{||"Tipo Gasto"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
aGet34	:= {'0=DEFINA UM TIPO', '1=CUSTO/DESPESA', '2=INVESTIMENTO'}
cGet34	:= aGet34[1]
oGet34 	:= TComboBox():New(206,392,{|u| If(PCount()>0,cGet34:=u,cGet34)}, aGet34,060,008,oDlg1,,,{|| f_VldCombo(cGet34, oGet34)},,,.T.,,,,,,,,,'cGet34')

oSay28  := TSay():New( 228,012,{||"Produto"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
@ 236,012 MsGet oGet28 Var cGet28	F3 "SB1FS1" Valid f_VldProd(cGet28,@cGet29,@cGet30)      Size 060,008 Of oDlg1 Hasbutton Pixel

oSay29  := TSay():New( 228,088,{||"Descrição"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oGet29  := TGet():New( 236,088,{|u| If(PCount()>0,cGet29:=u,cGet29)},oDlg1,212,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet29",,)
oGet29:Disable()

oSay30  := TSay():New( 228,316,{||"Cta Contábil"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet30  := TGet():New( 236,316,{|u| If(PCount()>0,cGet30:=u,cGet30)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGet30",,)
oGet30:Disable()

oSay31  := TSay():New( 228,392,{||"Centro de Custo"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
@ 236,392 MsGet oGet31 Var cGet31	F3 "CTT" Valid (NaoVazio() .And. ExistCpo("CTT") .And. f_VldCC(cGet30,cGet31)) Size 060,008 Of oDlg1 Hasbutton Pixel
                    
If(nOpc = 2 .Or. nOpc = 5)
	oGet3:Disable()
	oGet4:Disable()
	oGet5:Disable()
	oGet6:Disable()
	oGet7:Disable()
	oGet8:Disable()
	oGet9:Disable()
	oGet10:Disable()
	oGet11:Disable()
	oGet12:Disable()
	oGet13:Disable()
	oGet14:Disable()
	oGet15:Disable()
	oGet16:Disable()
	oGet17:Disable()
	oGet18:Disable()
	oGet19:Disable()
	oGet20:Disable()
	oGet21:Disable()
	oGet22:Disable()
	oGet23:Disable()
	oGet24:Disable()
	oGet25:Disable()
	oGet27:Disable()
	oGet28:Disable()
	oGet29:Disable()
	oGet30:Disable()
	oGet31:Disable()
Endif

If(nOpc = 2) .Or. (nOpc = 4) .Or. (nOpc = 5)
	If(nOpc = 4)    // Alterar
		If(SZJ->ZJ_STATUS = 1)
			MsgAlert("Nao é possivel alterar um lançamento já aprovado.", "Aviso")
			oDlg1:End()
		Endif
	ElseIf(nOpc = 5) // Excluir
		If !Empty(SZJ->ZJ_PEDIDO)
            DbSelectArea("SC7")
            SC7->( DbSetOrder(1) )
            If SC7->( DbSeek(xFilial("SC7")+SZJ->ZJ_PEDIDO))
            	If SC7->C7_CONAPRO ='L' .Or. SC7->C7_QUJE <> 0 .Or. f_VerScr(SZJ->ZJ_PEDIDO)
					MsgAlert("Nao é possível excluir, o pedido vinculado já foi movimentado.", "Aviso")
					oDlg1:End()
				Endif
			Endif	
		Endif
	
	Endif
	
	cGet2   := SZJ->ZJ_CODIGO
	cGet3   := SZJ->ZJ_TIPO
	cGet4   := SZJ->ZJ_VALOR
	cGet5   := SZJ->ZJ_DATA
	cGet6	:= SZJ->ZJ_FORNECE
	cGet7	:= SZJ->ZJ_LOJA
	
	If !Empty(cGet6) .And. !Empty(cGet7)
		DbSelectArea("SA2")
		SA2->( DbSetOrder(1) )
		
		If SA2->( Dbseek(xFilial("SA2")+cGet6+cGet7))
			cGet8 := SA2->A2_NOME
		EndIf
	EndIf
	
	cGet9   := SZJ->ZJ_CLIENTE
	cGet10	:= SZJ->ZJ_LOJACLI
	
	If !Empty(cGet9) .And. !Empty(cGet10)
		Dbselectarea("SA1")
		SA1->( Dbsetorder(1) )
		
		If SA1->( Dbseek(xFilial("SA1")+cGet9+cGet10))
			cGet11 := SA1->A1_NOME
		EndIf
	EndIf

	cGet12  := SZJ->ZJ_CONTRAT
	cGet13  := SZJ->ZJ_FRETE
	cGet14  := SZJ->ZJ_UFORI
	cGet15  := SZJ->ZJ_CIDORI
	cGet16  := SZJ->ZJ_UFDEST
	cGet17  := SZJ->ZJ_CIDDEST
	cGet18  := SZJ->ZJ_VLCOB
	cGet19  := SZJ->ZJ_SALDO
	cGet20  := SZJ->ZJ_DKM
	cGet21	:= SZJ->ZJ_TVEIC

	If !Empty(cGet21)
		Dbselectarea("SX5")
		SX5->( Dbsetorder(1))
		
		If SX5->( Dbseek(xFilial("SX5")+"JT"+cGet21))
			cGet22 := SX5->X5_DESCRI
		EndIf
	EndIf
	
	cGet23	:= SZJ->ZJ_MESREF
	cGet24  := SZJ->ZJ_NUMNF
	cGet25  := SZJ->ZJ_TIPONF
	cGet27	:= SZJ->ZJ_CONDPG
	cGet28	:= SZJ->ZJ_PRODUTO
	cGet29	:= SZJ->ZJ_DESCRI
	cGet30	:= SZJ->ZJ_CONTA
	cGet31	:= SZJ->ZJ_CC
	cGet32	:= SZJ->ZJ_SISLOC
	cGet33	:= SZJ->ZJ_FSPROJ
	cGet34 	:= SZJ->ZJ_FSTPGT

	If (nOpc <> 4)
		n_Brw1 := 0
	Endif
	
Endif

Activate MsDialog oDlg1 Center On Init EnchoiceBar(oDlg1,{|| Iif(F_Vld_Tudo(), (U_Gravar(nOpc), oDlg1:End()),.F.)},{|| F_butao_cancel(oDlg1) })

Return

// Função de validar
Static Function F_Vld_Tudo()

Local l_Ret := .T.

If Empty(cGet3) .Or. cGet3 = '0'
	MsgAlert("Tipo de Frete não informado!", "Aviso")
	l_Ret := .F.
ElseIf cGet4 <= 0
	MsgAlert("Valor não informado!", "Aviso")
	l_Ret := .F.
ElseIf Empty(cGet5)
	MsgAlert("Data não informada!", "Aviso")
	l_Ret := .F.
ElseIf Empty(cGet6) // Fornecedor
	MsgAlert("Fornecedor não informado!", "Aviso")
	l_Ret := .F.
ElseIf Empty(cGet7) // Loja
	MsgAlert("Loja do Fornecedor não informada!", "Aviso")
	l_Ret := .F.
ElseIf Empty(cGet9) // Cliente
	If cGet3 = '1' .Or. cGet3 = '2' // Tipo de Movimentação 
		MsgAlert("Cliente não informado!", "Aviso")
		l_Ret := .F.
	Endif	
ElseIf Empty(cGet10) // Loja
	MsgAlert("Loja do Cliente não informada!", "Aviso")
	l_Ret := .F.
ElseIf Empty(cGet12) // Contrato
	If cGet3 = '1' .Or. cGet3 = '2' // Tipo de Movimentação 
		MsgAlert("Contrato não informado!", "Aviso")
		l_Ret := .F.
	Endif	
ElseIf Empty(cGet13)  .Or. cGet13 = '0' // Tipo
	MsgAlert("Tipo não informado!", "Aviso")
	l_Ret := .F.
ElseIf cGet18 <= 0  // Valor Cobrado
	MsgAlert("Valor Cobrado não informado!", "Aviso")
	l_Ret := .F.
ElseIf Empty(cGet27) // Condição de Pagamento
	MsgAlert("Condição de Pagamento não informado!", "Aviso")
	l_Ret := .F.
ElseIf Empty(cGet14) // UF origem
	MsgAlert("UF Origem não informado!", "Aviso")
	l_Ret := .F.
ElseIf Empty(cGet15) // Cidade Origem
	MsgAlert("Cidade Origem não informado!", "Aviso")
	l_Ret := .F.
ElseIf Empty(cGet16) // UF Destino
	MsgAlert("UF Destino não informado!", "Aviso")
	l_Ret := .F.
ElseIf Empty(cGet17) // Cidade Destino
	MsgAlert("Cidade Destino não informado!", "Aviso")
	l_Ret := .F.
ElseIf cGet20 <= 0 // Distancia
	MsgAlert("Distância não informada!", "Aviso")
	l_Ret := .F.
ElseIf Empty(cGet21) // Tipo veiculo
	MsgAlert("Tipo de Veículo não informado!", "Aviso")
	l_Ret := .F.
ElseIf Empty(cGet23) // Mes Referencia
	MsgAlert("Mês Referência não informado!", "Aviso")
	l_Ret := .F.
ElseIf Empty(cGet25) .Or. cGet25 = '0'// Tipo NF
	MsgAlert("Tipo de Nota não informado!", "Aviso")
	l_Ret := .F.
ElseIf Empty(cGet28) // Produto
	MsgAlert("Produto não informado!", "Aviso")
	l_Ret := .F.
ElseIf Empty(cGet30) // Conta Contábil
	MsgAlert("Conta Contábil não informada!", "Aviso")
	l_Ret := .F.
ElseIf Empty(cGet31) // Centro Custo
	MsgAlert("Centro de Custo não informado!", "Aviso")
	l_Ret := .F.
ElseIf Empty(cGet33) .Or. cGet33 = '0'// Projeto
	MsgAlert("Projeto não informado!", "Aviso")
	l_Ret := .F.
ElseIf Empty(cGet34) .Or. cGet34 = '0'// Gasto
	MsgAlert("Tipo de Gasto não informado!", "Aviso")
	l_Ret := .F.
Endif

Return(l_Ret)

// Botão cancelar
Static Function F_butao_cancel(oForm)

RollbackSx8()
oForm:End()

Return

// Função Gravar
User Function Gravar(nOpc)

Local cCodUser 	:= RetCodUsr() //Retorna o Codigo do Usuario
Local cNamUser 	:= UsrRetName( cCodUser )//Retorna o nome do usuario
Local cMensagem	:= Iif(nOpc=3, "Cadastrado Realizado com Sucesso.", "Alteração Realizada com Sucesso.")

If(nOpc = 3) // Inclusão
	DbSelectArea("SZJ")
	If RecLock("SZJ", .T.)
		SZJ->ZJ_FILIAL 	:= xFilial("SZJ")
		SZJ->ZJ_CODIGO 	:= cGet2
		SZJ->ZJ_TIPO 	:= cGet3
		SZJ->ZJ_VALOR 	:= cGet4
		SZJ->ZJ_DATA 	:= cGet5
		SZJ->ZJ_FORNECE	:= cGet6
		SZJ->ZJ_LOJA 	:= cGet7
		SZJ->ZJ_CLIENTE := cGet9
		SZJ->ZJ_LOJACLI := cGet10
		SZJ->ZJ_CONTRAT := cGet12
		SZJ->ZJ_FRETE 	:= cGet13
		SZJ->ZJ_UFORI 	:= cGet14
		SZJ->ZJ_CIDORI 	:= cGet15
		SZJ->ZJ_UFDEST 	:= cGet16
		SZJ->ZJ_CIDDEST := cGet17
		SZJ->ZJ_VLCOB 	:= cGet18
		SZJ->ZJ_SALDO 	:= cGet19
		SZJ->ZJ_DKM 	:= cGet20
		SZJ->ZJ_TVEIC 	:= cGet21
		SZJ->ZJ_MESREF 	:= cGet23
		SZJ->ZJ_NUMNF 	:= cGet24
		SZJ->ZJ_TIPONF 	:= cGet25
		SZJ->ZJ_STATUS 	:= 2
		SZJ->ZJ_DATALAN := Date()
		SZJ->ZJ_USUARIO := cNamUser
		SZJ->ZJ_CONDPG 	:= cGet27
		SZJ->ZJ_PRODUTO	:= cGet28
		SZJ->ZJ_DESCRI 	:= cGet29
		SZJ->ZJ_CONTA	:= cGet30
		SZJ->ZJ_CC 		:= cGet31
		SZJ->ZJ_SISLOC	:= cGet32		
		SZJ->ZJ_FSPROJ  := cGet33
		SZJ->ZJ_FSTPGT	:= cGet34
		MsUnLock()
		ConfirmSx8()
	Else
		RollbackSx8()
	Endif
     	
ElseIf (nOpc = 4) // Alteração
	DbSelectArea("SZJ")
	SZJ->( DbSetOrder(1) )
	If SZJ->( Dbseek(xFilial("SZJ")+cGet2))
		RecLock("SZJ", .F.)
		SZJ->ZJ_TIPO 	:= cGet3
		SZJ->ZJ_VALOR 	:= cGet4
		SZJ->ZJ_DATA 	:= cGet5
		SZJ->ZJ_FORNECE	:= cGet6
		SZJ->ZJ_LOJA 	:= cGet7
		SZJ->ZJ_CLIENTE := cGet9
		SZJ->ZJ_LOJACLI := cGet10
		SZJ->ZJ_CONTRAT := cGet12
		SZJ->ZJ_FRETE 	:= cGet13
		SZJ->ZJ_UFORI 	:= cGet14
		SZJ->ZJ_CIDORI 	:= cGet15
		SZJ->ZJ_UFDEST 	:= cGet16
		SZJ->ZJ_CIDDEST := cGet17
		SZJ->ZJ_VLCOB 	:= cGet18
		SZJ->ZJ_SALDO 	:= cGet19
		SZJ->ZJ_DKM 	:= cGet20
		SZJ->ZJ_TVEIC 	:= cGet21
		SZJ->ZJ_MESREF 	:= cGet23
		SZJ->ZJ_NUMNF 	:= cGet24
		SZJ->ZJ_TIPONF 	:= cGet25
		SZJ->ZJ_CONDPG 	:= cGet27
		SZJ->ZJ_PRODUTO	:= cGet28
		SZJ->ZJ_DESCRI 	:= cGet29
		SZJ->ZJ_CONTA	:= cGet30
		SZJ->ZJ_CC 		:= cGet31
		SZJ->ZJ_SISLOC	:= cGet32
		SZJ->ZJ_FSPROJ	:= cGet33
		SZJ->ZJ_FSTPGT	:= cGet34
		MsUnLock()
	Endif

ElseIf (nOpc = 5) //Exclusão
	DbSelectArea("SZJ")
	SZJ->( DbSetOrder(1))
	If SZJ->( Dbseek(xFilial("SZJ")+cGet2))
		U_FSWPCE01(SZJ->ZJ_PEDIDO)// Gravacao pedido de compras
		
		DbSelectArea("SZJ")
		RecLock("SZJ", .F.)
			dbDelete()
		MsUnLock()
	Endif
	
	cMensagem := "Exclusão Realizada com Sucesso."
Endif

If (nOpc <> 2)
	MsgAlert(cMensagem, "Aviso")  
Endif

Return()
 
// Aprovacao Frete
User Function AprovaFrete()

If SZJ->ZJ_STATUS = 1 // Desaprova 
	If !Empty(SZJ->ZJ_PEDIDO)
		DbSelectArea("SC7")
        SC7->( DbSetOrder(1) )
		If SC7->( DbSeek(xFilial("SC7")+SZJ->ZJ_PEDIDO))
           	If SC7->C7_CONAPRO ='L' .Or. SC7->C7_QUJE <> 0 .Or. f_VerScr(SZL->ZL_PEDIDO)
				MsgInfo("Nao é possivel desaprovar, pedido vinculado já foi movimentado.", "Aviso")
			Else
				U_FSWPCE01(SZJ->ZJ_PEDIDO)// Gravacao pedido de compras
				DbSelectArea("SZJ")
				RecLock("SZJ", .F.)
					SZJ->ZJ_STATUS	:= 2	
					SZJ->ZJ_PEDIDO	:= Space(6)
				MsUnLock()
				
				MsgInfo("Registro Desaprovado com Sucesso.", "Aviso")
			Endif	
		Else
			MsgInfo("Pedido de Compra: " + Alltrim(SZJ->ZJ_PEDIDO) + " não localizado.", "Aviso")
			
			DbSelectArea("SZJ")
			RecLock("SZJ", .F.)
				SZJ->ZJ_STATUS	:= 2	
				SZJ->ZJ_PEDIDO	:= Space(6)
			MsUnLock()
			
			MsgInfo("Registro Desaprovado com Sucesso.", "Aviso")
		Endif	
    Else
		DbSelectArea("SZJ")
		RecLock("SZJ", .F.)
			SZJ->ZJ_STATUS	:= 2	
		MsUnLock()
		
		MsgInfo("Registro Desaprovado com Sucesso.", "Aviso")
	Endif
			
ElseIf SZJ->ZJ_STATUS = 2
    DbSelectArea("SM0")
	SM0->( DbGoTop() )
	c_CGCEMP := Substr(SM0->M0_CGC,1,8)
	
	DbSelectArea("SA2")
	SA2->( DbSetOrder(1) )
	SA2->( DbSeek(xFilial("SA2")+SZJ->ZJ_FORNECE+SZJ->ZJ_LOJA ))
	c_CGCFOR := Substr(SA2->A2_CGC,1,8)
    
    If c_CGCFOR = c_CGCEMP // Fornecedor é a Própria Geradora
		DbSelectArea("SZJ")
		RecLock("SZJ", .F.)
			SZJ->ZJ_STATUS	:= 1	
		MsUnLock()

		MsgInfo("Registro Aprovado com Sucesso. Fornecedor não gera Pedido de Compras.", "Aviso")	
    Else 
		xPed := U_FSWPCI01("F")// Gravacao pedido de compras - Parâmetro Para Frete
		DbSelectArea("SZJ")
		RecLock("SZJ", .F.)
			SZJ->ZJ_STATUS	:= 1	
			SZJ->ZJ_PEDIDO	:= xPed	
		MsUnLock()
	
		MsgInfo("Registro Aprovado com Sucesso.", "Aviso")
	Endif	
Endif

Return

// Função que valida fornecedor
Static Function f_VldFornecedor(cCodigo, cLoja, cNome, cTipo)

Local l_Ret:= .T.

DbSelectArea("SM0")
SM0->( DbGoTop() )
c_CGCEMP := Substr(SM0->M0_CGC,1,8)

If Empty(cCodigo)
	MsgAlert("Informe o Código do Fornecedor.", "Aviso")
	oGet6:SetFocus()
	oGet6:SetCss(cCSSGet)
	l_Ret:= .F.
ElseIf Empty(cLoja)
	MsgAlert("Informe o Código da Loja.", "Aviso")
	oGet7:SetFocus()
	oGet7:SetCss(cCSSGet)
	l_Ret:= .F.
Else
	DbSelectArea("SA2")
	SA2->( DbSetOrder(1))
	If SA2->( Dbseek(xFilial("SA2")+cCodigo+cLoja))
		cNome:= Alltrim(SA2->A2_NOME)
		oGet6:SetCss(cCSSGetn)
		oGet7:SetCss(cCSSGetn)

		c_CGCFOR := Substr(SA2->A2_CGC,1,8)

		If c_CGCFOR = c_CGCEMP // Fornecedor é a Própria Geradora
			cTipo	:= aGet13[2]
			cGet13	:= aGet13[2]
			oGet13:Select(2)
		Else
			cTipo	:= aGet13[3]
			cGet13	:= aGet13[3]
			oGet13:Select(3)
		Endif	
		oGet13:Refresh()
	Else
		MsgAlert("Código do Fornecedor ou Loja não encontrado!", "Aviso")
		
		cGet6  := Space(TamSx3("ZJ_FORNECE")[1])
		cGet7  := Space(TamSx3("ZJ_LOJA")[1])
		cGet8  := Space(TamSx3("ZJ_NOMFOR")[1])
		cGet13 := Space(TamSx3("ZJ_FRETE")[1])
		oGet6:Refresh()
		oGet7:Refresh()
		oGet8:Refresh()
		oGet13:Refresh()
		oGet6:SetCss(cCSSGet)
		oGet7:SetCss(cCSSGet)
		oGet6:SetFocus()
		l_Ret:= .F.
	EndIf
EndIf

Return()

// Função Valida Veículo
Static Function f_VldNomeVeic(cCodigo, cNome)

Local l_Ret:= .T.

If Empty(cCodigo)
	MsgAlert("Informe o código do Tipo de Veículo.", "Aviso")
	oGet21:SetFocus()
	oGet21:SetCss(cCSSGet)
	l_Ret:= .F.
Else
	DbSelectArea("SX5")
	DbSetOrder(1)
	If SX5->( Dbseek(xFilial("SX5")+"JT"+cCodigo))
		cNome:= Alltrim(SX5->X5_DESCRI)
		oGet21:SetCss(cCSSGetn)
	Else
		MsgAlert("Código não existe. ", "Aviso")
		cCodigo := ""
		oGet21:SetFocus()
		oGet21:SetCss(cCSSGet)
	EndIf
EndIf

Return()
      */
/*
// Função Valida Cliente
Static Function f_VldCliente(cCodigo, cLoja, cNome)

Local l_Ret:= .T.

If Empty(cCodigo)
	If cGet3 = '1' .Or. cGet3 = '2' // Tipo de Movimentação 
		MsgAlert("Informe o Código do Cliente.", "Aviso")
		oGet9:SetFocus()
		oGet9:SetCss(cCSSGet)
		l_Ret:= .F.
	Endif	
ElseIf Empty(cLoja)
	If cGet3 = '1' .Or. cGet3 = '2' // Tipo de Movimentação 
		MsgAlert("Informe o Código da Loja.", "Aviso")
		oGet10:SetFocus()
		oGet10:SetCss(cCSSGet)
		l_Ret:= .F.
	Endif	
Else
	DbSelectArea("SA1")
	SA1->( DbSetOrder(1))
	If SA1->( Dbseek(xFilial("SA1")+cCodigo+cLoja))
		cNome:= Alltrim(SA1->A1_NOME)
		oGet9:SetCss(cCSSGetn)
		oGet10:SetCss(cCSSGetn)
	Else
		MsgAlert("Código do Cliente ou Loja não encontrado!", "Aviso")
		
		cGet9  := Space(TamSx3("ZJ_CLIENTE")[1])
		cGet10 := Space(TamSx3("ZJ_LOJACLI")[1])
		cGet11 := Space(TamSx3("ZJ_NOMECLI")[1])
		
		oGet9:Refresh()
		oGet10:Refresh()
		oGet11:Refresh()
		oGet9:SetFocus()
		oGet9:SetCss(cCSSGet)
		oGet10:SetCss(cCSSGet)
		l_Ret:= .F.
	EndIf
EndIf

Return()
  */  
// Função Valida Produto
/*Static Function f_VldProd(cCodigo, cDesc, cConta)

Local l_Ret  := .T.
Local pConta := GetMv("FS_CTFRETE")

If Empty(cCodigo)
	MsgAlert("Informe o Código do Produto.", "Aviso")
	oGet28:SetFocus()
	oGet28:SetCss(cCSSGet)
	l_Ret:= .F.
Else	
	DbSelectArea("SB1")
	SB1->( DbSetOrder(1))
	If SB1->( Dbseek(xFilial("SB1")+cCodigo))
		If Alltrim(SB1->B1_CONTA) $ pConta
			DbSelectArea("SB5")
			SB5->( DbSetOrder(1))
			If SB5->( Dbseek(xFilial("SB5")+SB1->B1_COD))
				cDesc 	:= Alltrim(SB5->B5_CEME)
			Else
				cDesc 	:= Alltrim(SB1->B1_DESC)
			Endif	
		
			cConta 	:= Alltrim(SB1->B1_CONTA)
			oGet28:SetCss(cCSSGetn)
		Else
			MsgAlert("Código não pode ser utilizado. Possui conta fora da regra!", "Aviso")
			cGet28 := Space(TamSx3("ZJ_PRODUTO")[1])
			cGet29 := Space(TamSx3("ZJ_DESCRI")[1])
			cGet30 := Space(TamSx3("ZJ_CONTA")[1])
			
			oGet28:Refresh()
			oGet29:Refresh()
			oGet30:Refresh()
			oGet28:SetFocus()
			oGet28:SetCss(cCSSGet)
			oGet29:SetCss(cCSSGet)
			oGet30:SetCss(cCSSGet)
			l_Ret:= .F.
		Endif	
	Else
		MsgAlert("Código do Produto não encontrado!", "Aviso")
		
		cGet28 := Space(TamSx3("ZJ_PRODUTO")[1])
		cGet29 := Space(TamSx3("ZJ_DESCRI")[1])
		cGet30 := Space(TamSx3("ZJ_CONTA")[1])
		
		oGet28:Refresh()
		oGet29:Refresh()
		oGet30:Refresh()
		oGet28:SetFocus()
		oGet28:SetCss(cCSSGet)
		oGet29:SetCss(cCSSGet)
		oGet30:SetCss(cCSSGet)
		l_Ret:= .F.
	EndIf
EndIf

Return()

// Valida Campo
Static Function f_VldCampo(cValue, obj)
         
Local l_Ret:= .T.

If Empty(cValue)
	MsgAlert("Campo não pode ser vazio.", "Aviso")
	obj:SetFocus()
	obj:SetCss(cCSSGet)
	
	l_Ret:= .F.
Else
	obj:SetCss(cCSSGetn)
EndIf

Return()

// Valida Custo
Static Function f_VldCusto(cValue, obj)
         
Local l_Ret   := .T.
Local nPMarg  := GetMv("FS_FRTMARG")
Local nPImp   := GetMv("FS_FRTIMP")
Local nMargem := 0
Local nImpost := 0

If Empty(cValue)
	MsgAlert("Campo não pode ser vazio.", "Aviso")
	obj:SetFocus()
	obj:SetCss(cCSSGet)
	
	l_Ret:= .F.
Else
	nMargem := ((nPMarg/100)) * cValue
	nImpost := ((nPImp/100)) *cValue

	cGet18 := (cValue + nMargem + nImpost) 

	oGet18:Refresh()
	obj:SetCss(cCSSGetn)
//	oGet18:SetCss(cCSSGet)
  */
/*	If nValor >= _xVlrCtr  // Valor cobrado é maior do que o valor do serviço
		obj:SetCss(cCSSGetn)
    Else // Valor cobrado é menor
		MsgAlert("Valor Cobrado é menor do que o Valor do Serviço.", "Aviso")		
		obj:SetFocus()
		obj:SetCss(cCSSGet)	    
    Endif
	*/
/*EndIf

Return()

// Valida Valor Cobrado
Static Function f_VldValor(nValor, obj)
         
Local l_Ret:= .T.

If Empty(nValor)
	If cGet3 = '1' .Or. cGet3 = '2' // Tipo de Movimentação 
		MsgAlert("Campo não pode ser vazio.", "Aviso")
		obj:SetFocus()
		obj:SetCss(cCSSGet)
	
		l_Ret:= .F.
	Endif	
Else
	nMargem := ((nPMarg/100)) * cGet4
	nImpost := ((nPImp/100)) * cGet4

	_xVlrCtr := (cGet4 + nMargem + nImpost) 
	
	If nValor >= _xVlrCtr  // Valor cobrado é maior do que o valor do serviço
		obj:SetCss(cCSSGetn)
    Else // Valor cobrado é menor
		MsgAlert("Valor Cobrado é menor do que o Valor do Serviço.", "Aviso")		
		obj:SetFocus()
		obj:SetCss(cCSSGet)	    
    Endif
  */  
/*	cQry := " SELECT valor as VALOR FROM [dbo].[v_sisloc_servico_extra] "
	cQry += " WHERE cd_controle = " + Str(cGet32,15,0) //cGet32 
	cQry += " AND cod_filial    = '" + xFilial("SZJ") + "'"
	cQry += " AND tipo_servico  = '1' " 
		
	TcQuery cQry New Alias "TRBSRV"
        	
	DbSelectArea("TRBSRV")
	TRBSRV->( DbGoTop() )
		
	If TRBSRV->( !Eof() ) // Senão for final de arquivo

		cQry := " SELECT SUM(ZJ_VALOR) AS ZJ_VALOR "
		cQry += " FROM " + RetSqlName("SZJ")
		cQry += " WHERE ZJ_FILIAL = '" + xFilial("SZJ") + "'" 
		cQry += " AND ZJ_SISLOC   = " + Str(cGet32,15,0) //cGet32 
		cQry += " AND D_E_L_E_T_ <> '*' "

		TcQuery cQry New Alias "TRBSZJ"
	
		DbSelectArea("TRBSZJ")
		TRBSZJ->( DbGoTop() )

		nMargem := ((nPMarg/100)) * TRBSRV->VALOR
		nImpost := ((nPImp/100)) * TRBSRV->VALOR
			
		_xSldCtr := TRBSRV->VALOR - TRBSZJ->ZJ_VALOR  // Saldo do Contrato - Saldo dos Processo

		TRBSZJ->( DbCloseArea() )
	Endif
        
	TRBSRV->( DbCloseArea())

	If cVlrInf >= _xSaldo
		MsgAlert("Contrato sem saldo para prosseguir com lançamento.", "Aviso")		
		obj:SetFocus()
		obj:SetCss(cCSSGet)	
	Endif
	*/	
  /*
EndIf

Return()
                      
// Valida Combo
Static Function f_VldCombo(cValue, obj)

Local l_Ret:= .T.

If (cValue == '0')
	MsgAlert("Campo não pode ser vazio.", "Aviso")
	obj:SetFocus()
	obj:SetCss(cCSSGet)
	l_Ret:= .F.
Else
	obj:SetCss(cCSSGetn)
EndIf

Return()

// Valida amarraçao conta contabil x centro de custo
Static Function f_VldCC(cConta, cCodigo)

Local l_Ret:= .T.

If !Empty(cCodigo)
	cQry := " SELECT * FROM " + RetSqlName("CTA")
	cQry += " WHERE CTA_FILIAL = '" + xFilial("CTA") + "'"
	cQry += " AND CTA_CONTA    = '" + cConta  + "'"
	cQry += " AND CTA_CUSTO    = '" + cCodigo + "'"
	cQry += " AND D_E_L_E_T_ <> '*' "
                                
	cQry  := ChangeQuery(cQry)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"TRBCTA",.F.,.T.)
	                    
	DbSelectArea("TRBCTA")
	TRBCTA->( DbGoTop() )
	If TRBCTA->( Eof() ) // Se for final de arquivo não localizou nenhuma amarração conta x centro de custo
		MsgAlert("Não existe amarração Conta Contabil x Centro de Custo!", "Aviso")
		oGet31:SetFocus()
		oGet31:SetCss(cCSSGet)
		cGet31 := Space(TamSx3("ZJ_CC")[1])
		l_Ret:= .F.
	Else
		oGet31:SetCss(cCSSGetn)
	Endif
	
	TRBCTA->( DbCloseArea() )
EndIf

Return()

// Função de Legenda
User Function SZJLEG()

BrwLegenda(cCadastro,"Legenda",{{"BR_VERDE", "Aprovado"},{"BR_VERMELHO", "Nao Aprovado"  }})

Return(.T.)


// Consulta se o pedido de compras já sofreu alguma liberação.
Static Function f_VerScr(xPedido)

cQry := " SELECT TOP 1 CR_NUM "
cQry += " FROM " + RetSqlName("SCR") 
cQry += " WHERE CR_FILIAL = '" + xFilial("SCR") + "'"
cQry += " AND CR_TIPO     IN ('PC','IP') "
cQry += " AND CR_NUM      = '" + xPedido + "'"
cQry += " AND D_E_L_E_T_ <> '*' "
cQry += " AND CR_STATUS NOT IN ('01','02') "

cQry  := ChangeQuery(cQry)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"TRBSCR",.F.,.T.)
	                    
DbSelectArea("TRBSCR")
TRBSCR->( DbGoTop() )
If TRBSCR->( Eof() ) // Se for final de arquivo ainda não foi liberado.
	l_Ret:= .F.
Else
	l_Ret:= .T.
Endif

TRBSCR->( DbCloseArea() )

Return l_Ret

// Consulta Contrato
Static Function f_Contrato(cValue, obj)

Local l_Ret	  := .T.

If Empty(cValue)
	If cGet3 = '1' .Or. cGet3 = '2' // Tipo de Movimentação 
		MsgAlert("Campo não pode ser vazio.", "Aviso")
		obj:SetFocus()
		obj:SetCss(cCSSGet)
	
		l_Ret:= .F.
	Endif	
Else
	cQry := " SELECT NUMERO, CD_CONTROLE FROM [dbo].[view_fich_to_protheus] "
	cQry += " WHERE NUMERO = '" + cValue + "'"

	TcQuery cQry New Alias "TRBCTR"

	DbSelectArea("TRBCTR")
	TRBCTR->( DbGoTop() )

	If TRBCTR->( !Eof() ) // Se for final de arquivo ainda não foi liberado.
		cGet32 := TRBCTR->CD_CONTROLE

		cQry := " SELECT valor as VALOR FROM [dbo].[v_sisloc_servico_extra] "
		cQry += " WHERE cd_controle = " + Str(cGet32,15,0) //cGet32 
		cQry += " AND cod_filial    = '" + xFilial("SZJ") + "'"
		cQry += " AND tipo_servico  = '1' " 
		
		TcQuery cQry New Alias "TRBSRV"
        	
		DbSelectArea("TRBSRV")
		TRBSRV->( DbGoTop() )
		
		If TRBSRV->( !Eof() )
			obj:SetCss(cCSSGetn)
		Else
			MsgAlert("Contrato não possui Serviço Extra de Frete.", "Aviso")
			obj:SetFocus()
			obj:SetCss(cCSSGet)					
		Endif
		
		TRBSRV->( DbCloseArea() )
	Else
		MsgAlert("Contrato não vinculado no Sisloc.", "Aviso")
		obj:SetFocus()
		obj:SetCss(cCSSGet)	
	Endif	
	
	TRBCTR->( DbCloseArea() )
	
EndIf

Return*/
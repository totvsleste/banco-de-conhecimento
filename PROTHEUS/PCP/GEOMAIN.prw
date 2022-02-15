#include "Protheus.ch"
#include "Restful.ch"
#include "TBIConn.ch"
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include 'TopConn.ch'

//Variáveis Estáticas
Static cTitulo := "Especificações do concreto dosado em central(CDC)"
/*
------------------------------------------------------------------------------------------------------------
Função		: GEOMAIN.PRW
Tipo		: Programa
Descrição	: Programa em MVC para cadastramento e geração dos CDC's Geomix 
Chamado     : 
Parâmetros	: 
Retorno		:
------------------------------------------------------------------------------------------------------------
Atualizações:
- 04/02/2021 - Fabio A. Moraes - Construção inicial do Fonte
------------------------------------------------------------------------------------------------------------
*/
User Function GEOMAIN()

    Local aArea   := GetArea()
	Local oBrowse
	Private lMsErroAuto := .F.
	Private nOpc := 0

	//Instânciando FWMBrowse - Somente com dicionário de dados
	oBrowse := FWMBrowse():New()
	
	//Setando a tabela de cadastro de Autor/Interprete
	oBrowse:SetAlias("ZG1")
	//Setando a descrição da rotina
	oBrowse:SetDescription(cTitulo)
	
	//Legendas
	//oBrowse:AddLegend( "SBM->BM_PROORI == '1'", "GREEN",	"Original" )
	//oBrowse:AddLegend( "SBM->BM_PROORI == '0'", "RED",	"Não Original" )
	
	//Ativa a Browse
	oBrowse:Activate()
	
	RestArea(aArea)
Return

Static Function MenuDef()
	Local aRot := {}
	
	//Adicionando opções
	ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.GEOMAIN' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE 'CDC'        ACTION 'u_RELCDC()'      OPERATION 6                      ACCESS 0 //OPERATION X
	ADD OPTION aRot TITLE 'Gerar OP'   ACTION 'u_GEOMAINA()'      OPERATION 6                      ACCESS 0 //OPERATION X
	ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.GEOMAIN' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.GEOMAIN' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.GEOMAIN' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
    
Return aRot

Static Function ModelDef()
	Local oModel 		:= Nil
	Local oStPai 		:= FWFormStruct(1, 'ZG1')
	Local oStFilho 	    := FWFormStruct(1, 'ZG2')
	Local aZG2Rel		:= {}
	
	//Criando o modelo e os relacionamentos
	oModel := MPFormModel():New('MD_GEOMAIN',, /*{|oModel|GeomainV(oModel)}*/,/*{||commit()}*/,/*{||cancel()}*/)
	oModel:AddFields('ZG1MASTER',/*cOwner*/,oStPai,{|oModel|GeomainU(oModel)},,)
	oModel:AddGrid('ZG2DETAIL','ZG1MASTER',oStFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner é para quem pertence
	
	//Fazendo o relacionamento entre o Pai e Filho
	aAdd(aZG2Rel, {'ZG2_FILIAL','FWxFilial("ZG2")'})
	aAdd(aZG2Rel, {'ZG2_FSCONT',	'ZG1_FSCONT'}) 
	
	oModel:SetRelation('ZG2DETAIL', aZG2Rel, ZG2->(IndexKey(1))) //IndexKey -> quero a ordenação e depois filtrado
	oModel:GetModel('ZG2DETAIL'):SetUniqueLine({"ZG2_FILIAL","ZG2_FSCONT","ZG2_FSVIAG"})	//Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
	oModel:SetPrimaryKey({})
	
	//Setando as descrições
	oModel:SetDescription("CDC")
	oModel:GetModel('ZG1MASTER'):SetDescription('Modelo Cabeçalho')
	oModel:GetModel('ZG2DETAIL'):SetDescription('Modelo Itens')

	//oStPai:SetProperty("ZG1_FSDPRD",8,{|oModel|Lock(oModel)})
	//oStPai:SetProperty("ZG1_FSLCLI",8,{|oModel|Lock(oModel)})
	//oStPai:SetProperty("ZG1_FSDCLI",8,{|oModel|Lock(oModel)})
	//FwFormModelStruct():SetProperty.)

Return oModel


Static Function ViewDef()
	Local oView		:= Nil
	Local oModel	:= FWLoadModel('GEOMAIN')
	Local oStPai	:= FWFormStruct(2, 'ZG1')
	Local oStFilho	:= FWFormStruct(2, 'ZG2')
	
	
	//Criando a View
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	//Adicionando os campos do cabeçalho e o grid dos filhos
	oView:AddField('VIEW_ZG1',oStPai,'ZG1MASTER')
	oView:AddGrid('VIEW_ZG2',oStFilho,'ZG2DETAIL')
	
	//Setando o dimensionamento de tamanho
	oView:CreateHorizontalBox('CABEC',30)
	oView:CreateHorizontalBox('GRID',70)
	
	//Amarrando a view com as box
	oView:SetOwnerView('VIEW_ZG1','CABEC')
	oView:SetOwnerView('VIEW_ZG2','GRID')
	
	//Habilitando título
	oView:EnableTitleView('VIEW_ZG1','Cabeçalho')
	oView:EnableTitleView('VIEW_ZG2','Viagens')

	//oStPai:SetProperty("ZG1_FSDPRD",9,{||.F.})
	//oStPai:SetProperty("ZG1_FSLCLI",9,{||.F.})
	//oStPai:SetProperty("ZG1_FSDCLI",9,{||.F.})
	//FWFORMVIEWSTRUCT():SetProperty("ZG1_FSCONT",9,.F.)
Return oView


Static Function GeomainU(oModel)
//Valida os campos na carga do modelo
Local lRet      := .T.
Local cCCont    := ""
Local oModelZG1 := oModel:GetModel('ZG1MASTER')
Local oModelZG2 := oModel:GetModel('ZG2DETAIL')
	
	cCCont := oModelZG1:GetValue("ZG1MASTER","ZG1_FSCONT")
	lOK    := oModelZG2:SetValue("ZG2DETAIL","ZG2_FSCONT",cCCont)
	

Return(lRet)


Static Function GeomainV(oModel)
//Validações de campos na gravação ou atualização - 3 inclusão - 4 Atualização
Local nOperation  := oModel:GetOperation()
Local lRet        := .T.
Local nCont       := 0
Local nApont      := 0
Local lOp         := .F.
Local lResp       := .F.
Local aOPs        := {}
Private cOp       := ""
Private cOpN      := ""
Private cOpB      := ""
Private cOpT      := ""
Private cOpApon   := ""
Private cControle := ""
Private cCodPrd   := ""
Private cCodTPrd  := ""
Private nQuant    := 0
Private nQtdApon  := 0
Private nQLin     := 0
Private cOpera    := ""
Private cRecurso  := ""
Private cHIni     := ""
Private cHFim     := ""
Private cViagem   := ""
Private cPT       := ""
Private dDtApon   
Private dDtFim
Private dDtIni
Private aProdutos := {}

	nOpc := 3

	If nOperation == 3
		//Cria OP para o produto
		If !Empty(FWFldGet("ZG1_FSCPRD"))
			aAdd(aProdutos,{FWFldGet("ZG1_FSCPRD"),FWFldGet("ZG1_FSPROD"),FWFldGet("ZG1_FSCONT"),'N'})
			//aAdd(aProdutos,{"CR010003",M->ZG1_FSPROD,M->ZG1_FSCONT,'N'})
		EndIf
		//Cria OP para produto transporte, se existir
		If !Empty(FWFldGet("ZG1_FSCDT"))
			aAdd(aProdutos,{FWFldGet("ZG1_FSCDT"),FWFldGet("ZG1_FSPROD"),FWFldGet("ZG1_FSCONT"),'T'})
			//aAdd(aProdutos,{"CR010006",M->ZG1_FSPROD,M->ZG1_FSCONT,'T'})
		EndIf
		//Cria OP para produto bombeado, se existir.
		If !Empty(FWFldGet("ZG1_FSCDPB"))
			aAdd(aProdutos,{FWFldGet("ZG1_FSCDPB"),FWFldGet("ZG1_FSPROD"),FWFldGet("ZG1_FSCONT"),'B'})
			//aAdd(aProdutos,{"CR010009",M->ZG1_FSPROD,M->ZG1_FSCONT},'B')
		EndIf

		aOPs := u_GERAOPS(aProdutos)

		//Com as OP's criadas, faz os apontamentos
		If Len(aOPs) >= 1
			//Verifica se existem registros na grid
			If oModel:GetModel("ZG2DETAIL"):Length() >= 1
				//Pergunta se deseja fazer os apontamentos
				lResp := MsgBox("Deseja realizar os apontamentos para as OP's criadas?","Geomix - CDC","YESNO")
				If lResp
					//Reúne as informações para o apontamento
					For nApont := 1 to Len(aOPs)
						nQLin    := oModel:GetModel("ZG2DETAIL"):Length()
						cOp      := aOPs[nApont][1]
						cCodPrd  := aOPs[nApont][2]
						cCodTPrd := aOPs[nApont][3]
						For nCont := 1 To nQlin
							cOpApon  := cOP + "01001"
							cOpera   := FWFldGet("ZG2_FSOPER",nCont,oModel,)
							cRecurso := FWFldGet("ZG2_FSRECU",nCont,oModel,)
							cHIni    := FWFldGet("ZG2_FSHINI",nCont,oModel,)
							cHFim    := FWFldGet("ZG2_FSHFIM",nCont,oModel,)
							cViagem  := FWFldGet("ZG2_FSVIAG",nCont,oModel,)
							dDtApon  := FWFldGet("ZG2_FSDTAP",nCont,oModel,)
							dDtIni   := FWFldGet("ZG2_FSDINI",nCont,oModel,)
							dDtFim   := FWFldGet("ZG2_FSDFIM",nCont,oModel,)
							dDtFim   := FWFldGet("ZG2_FSDFIM",nCont,oModel,)
							nQtdApon := FWFldGet("ZG2_FSQAPO",nCont,oModel,)
							lAponta := Aponta()
							If lAponta = .T.
								//Grava OP e Produto no Detail
								If cCodTPrd == 'N'
									oModel:GetModel("ZG2DETAIL"):SetValue("ZG2_FSOP"  ,AllTrim(cOpApon))
									oModel:GetModel("ZG2DETAIL"):SetValue("ZG2_FSCPRD",AllTrim(cCodPrd))
								ElseIf cCodTPrd == 'T'
									oModel:GetModel("ZG2DETAIL"):SetValue("ZG2_FSOPT"  ,AllTrim(cOpApon))
									oModel:GetModel("ZG2DETAIL"):SetValue("ZG2_FSCDPT" ,AllTrim(cCodPrd))
								ElseIf cCodTPrd == 'B'
									oModel:GetModel("ZG2DETAIL"):SetValue("ZG2_FSOPB"  ,AllTrim(cOpApon))
									oModel:GetModel("ZG2DETAIL"):SetValue("ZG2_FSCDPB" ,AllTrim(cCodPrd))
								EndIf
							Else
								MsgBox("Não foi possível realizar o apontamento da OP "+cOPApon+" ","Geomix - CDC","Alert")
							EndIf
						Next
					Next
				EndIf
			EndIf
		EndIf

	ElseIf nOperation == 4
		aOPs := {}
		cCCont := oModelZG1:GetValue("ZG1MASTER","ZG1_FSCONT")
		//Busca as OP's relativas ao CDC
		cSql := "Select       "
		cSql += " C2_NUM,     "
		cSql += " C2_PRODUTO, "
		cSql += " C2_FSTPROD  "
		cSql += "From         "
		cSql += " "+RetSqlName('SC2')+" SC2 "
		cSql += "where       "
		cSql += " C2_FSCONT = '"+cCCont+"'"
		cSql += "and D_E_L_E_T_ = ' ' "
		TcQuery cSql New Alias 'OPS'
		DbSelectArea('OPS')
		Do While OPS->(!Eof())
			aAdd(aOPs,{OPS->C2_NUM    ,;
					   OPS->C2_PRODUTO,;
					   OPS->C2_FSTPROD})
			OPS->(DbSkip())
		EndDo
		OPS->(DbCloseArea())

		//Verifica se existem registros na grid
		If oModel:GetModel("ZG2DETAIL"):Length() >= 1
			//Pergunta se deseja fazer os apontamentos
			lResp := MsgBox("Deseja realizar os apontamentos para as OP's criadas?","Geomix - CDC","YESNO")
			If lResp
				//Reúne as informações para o apontamento
				For nApont := 1 to Len(aOPs)
					nQLin    := oModel:GetModel("ZG2DETAIL"):Length()
					cOp      := aOPs[nApont][1]
					cCodPrd  := aOPs[nApont][2]
					cCodTPrd := aOPs[nApont][3]
					For nCont := 1 To nQlin
						cOpApon  := FWFldGet("ZG2_FSOP"  ,nCont,oModel,)
						cOpera   := FWFldGet("ZG2_FSOPER",nCont,oModel,)
						cRecurso := FWFldGet("ZG2_FSRECU",nCont,oModel,)
						cHIni    := FWFldGet("ZG2_FSHINI",nCont,oModel,)
						cHFim    := FWFldGet("ZG2_FSHFIM",nCont,oModel,)
						cViagem  := FWFldGet("ZG2_FSVIAG",nCont,oModel,)
						dDtApon  := FWFldGet("ZG2_FSDTAP",nCont,oModel,)
						dDtIni   := FWFldGet("ZG2_FSDINI",nCont,oModel,)
						dDtFim   := FWFldGet("ZG2_FSDFIM",nCont,oModel,)
						dDtFim   := FWFldGet("ZG2_FSDFIM",nCont,oModel,)
						nQtdApon := FWFldGet("ZG2_FSQAPO",nCont,oModel,)
						If AllTrim(cOpApon) == ""
							cOpApon := AllTrim(cOp) + "01001"
							lAponta := Aponta()
							If lAponta = .T.
								//Grava OP e Produto no Detail
								If cCodTPrd == "N"
									oModel:GetModel("ZG2DETAIL"):SetValue("ZG2_FSOP"  ,AllTrim(cOpApon))
									oModel:GetModel("ZG2DETAIL"):SetValue("ZG2_FSCPRD",AllTrim(cCodPrd))
								ElseIf cCodTPrd == "T"
									oModel:GetModel("ZG2DETAIL"):SetValue("ZG2_FSOPT"  ,AllTrim(cOpApon))
									oModel:GetModel("ZG2DETAIL"):SetValue("ZG2_FSCDPT" ,AllTrim(cCodPrd))
								ElseIf cCodTPrd == "B"
									oModel:GetModel("ZG2DETAIL"):SetValue("ZG2_FSOPB"  ,AllTrim(cOpApon))
									oModel:GetModel("ZG2DETAIL"):SetValue("ZG2_FSCDPB" ,AllTrim(cCodPrd))
								EndIf
							Else
								MsgBox("Não foi possível realizar o apontamento da OP "+cOPApon+" ","Geomix - CDC","Alert")
							EndIf
						EndIf
					Next
				Next
			EndIf
		EndIf	
	EndIf
Return lRet

Static Function aponta() 
Local aAponta    := {}
Local aTSD3      := {}
Local dData       
Local lRet       := .T.   
Local cIndexKey  := ""         
Local cIndexName := ""	
Local cFilter    := ""
Local bFilter
Local cSql       := ""
Local nQuant     := 0
Local nCont      := 0
	
	
	//Verifica o tipo de apontamento
	nQuant := oModelZG1:GetValue("ZG1MASTER","ZG1_FSPROD")
	If nQtApon > nQuant
		cPT := "P"
	Else
		cPT := "T"
	EndIf 
	
	nOpc := 3 
    lMsErroAuto := .F.
    dData  := dDataBase
    aAponta := {{"H6_OP"	  ,cOpApon           ,NIL},;
                {"H6_PRODUTO" ,AllTrim(cCodPrd)  ,NIL},;
                {"H6_OPERAC"  ,AllTrim(cOpera)   ,NIL},;
                {"H6_RECURSO" ,AllTrim(cRecurso) ,NIL},;
                {"H6_DTAPONT" ,dDtApon           ,NIL},;
                {"H6_DATAINI" ,dDtIni            ,NIL},;
                {"H6_HORAINI" ,cHIni             ,NIL},;
                {"H6_DATAFIN" ,dDtFim            ,NIL},;
                {"H6_HORAFIN" ,cHFim             ,NIL},;
                {"H6_LOCAL"   ,"08"              ,NIL},;
                {"H6_PT"      ,AllTrim(cPT)      ,NIL},;
                {"H6_QTDPROD" ,nQtdApon          ,NIL},;
                {"H6_FSCONT"  ,AllTrim(cControle),NIL},;
                {"H6_FSVIAG"  ,AllTrim(cViagem)  ,NIL}}

   	MSExecAuto({|x| Mata681(x)},aAponta, nOpc)  // inclusão
    
    If lMsErroAuto    
        Mostraerro()
        lRet := .F.
    Else    
        ConOut("Apontamento concluído")
        //Grava informações da viagem nas movimentações internas
		cSql := "Select      "
		cSql += " R_E_C_N_O_ "
		cSql += "From        "
		cSql += " "+RetSqlName('SD3')+" SD3"
		cSql += "Where       "
		cSql += " D3_FILIAL = '"+FWxFilial('SD3')+"' and "
		cSql += " D3_OP = '"+cOpApon+"' and "
		cSql += " D_E_L_E_T_ = ' ' "
		TcQuery cSql New Alias "TSD3"
		DbSelectArea('TSD3')
		Do While TSD3->(!Eof())
			aAdd(aTSD3,TSD3->R_E_C_N_O_)
			TSD3->(DbSkip())
		EndDo
		TSD3->(DbCloseArea())

		For nCont := 1 To Len(aTSD3)
			//Atualiza informações na SD3
			cSql := "Update "+RetSqlName('SD3')+" SD3 set D3_FSCONT = '"+cControle+"', D3_FSVIAG = '"+cViagem+"' where R_E_C_N_O_ = '"+AllTrim(Str(aSD3[nCont]))+"' "
			TcSqlExec(cSql)
		Next
    Endif
    
Return lRet


Static Function commit()
Return

Static Function cancel()
Return


function u_GEOMAINA()

	LoCAL c_NumOp	:= ""
	
	If !Empty(ZG1->ZG1_FSCPRD)
			c_NumOp	:= GETNUMSC2()
			u_GeraOPS(ZG1->ZG1_FSCPRD, ZG1->ZG1_FSPROD, ZG1->ZG1_FSCONT,"N",c_NumOp)
			ALERT("PRIMEIRA OP INCLUIDA COM SUCESSO!!!")
		EndIf
		
		//Cria OP para produto transporte, se existir
		If !Empty(ZG1->ZG1_FSCPT)
			c_NumOp	:= GETNUMSC2()
			u_GeraOPS(ZG1->ZG1_FSCPT, ZG1->ZG1_FSPROD, ZG1->ZG1_FSCONT,"T",c_NumOp)
			ALERT("SEGUNDA OP INCLUIDA COM SUCESSO!!!")
		EndIf
		
		//Cria OP para produto bombeado, se existir.
		If !Empty(ZG1->ZG1_FSCDPB)
			c_NumOp	:= GETNUMSC2()
			u_GeraOPS(ZG1->ZG1_FSCDPB, ZG1->ZG1_FSPROD, ZG1->ZG1_FSCONT,"B",c_NumOp)
			ALERT("TERCEIRA OP INCLUIDA COM SUCESSO!!!")
		EndIf
		
return()


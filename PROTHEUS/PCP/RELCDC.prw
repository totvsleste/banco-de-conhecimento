#Include 'Protheus.CH'
#Include 'RWMake.CH'
#Include 'RptDef.CH'
#Include 'FWPrintSetup.CH'
/*
------------------------------------------------------------------------------------------------------------
Função		: GEOMAIN.PRW
Tipo		: Programa
Descrição	: Programa em MVC 3 para 
Chamado     : 
Parâmetros	: 
Retorno		:
------------------------------------------------------------------------------------------------------------
Atualizações:
- 05/02/2021 - Fabio A. Moraes - Construção inicial do Fonte
------------------------------------------------------------------------------------------------------------
*/

User Function RELCDC()
Private aDados     := {}
Private cCodUsu    := RetCodUsr()
Private cUsuario   := UsrRetName(cCodUsu)
Private cPerg      := 'RELCDC'
Private cViagem    := ""
Private cVolume    := ""
Private cHMistura  := ""
Private cIdade     := "" 
Private cFck       := ""
Private cAbat      := ""
Private cTempo     := ""
Private cDim       := ""
Private cAplica    := ""
Private cCliente   := ""
Private cMotorista := ""
Private cData      := ""
Private cLacre     := ""
Private cCaminhao  := ""
Private cPlaca     := ""
Private cSObra     := ""
Private cCObra     := ""
Private cSGeo      := ""
Private cCGeo      := ""
Private cControle  := ""
Private nRegs      := 0
Private nNro       := 0
Private oPrint
Private dDataIni   
Private dDataFim



	oLogo      := TFont():New('Andale Mono',,10,,.F.)
	oCabecalho := TFont():New('Andale Mono',,14,,.T.)
	oTitle     := TFont():New('Andale Mono',,10,,.T.)		 
	oCorpoN    := TFont():New('Andale Mono',,09,,.T.)			
	oTexto     := TFont():New('Andale Mono',,08,,.F.)
	oCorpo     := TFont():New('Andale Mono',,09,,.F.)
	
	oPrint := FWMsPrinter():New("Especificações do Concreto Dosado em Central - CDC",,,,,,,,,,.F.,,)
	oPrint:SetPortrait()
	oPrint:SetPapersize(9,210,297)
	
	If !Pergunte(cPerg,.T.)
		Return
	Else
		//Variaveis públicas das perguntas
        cViagem   := MV_PAR01
		cVolume   := MV_PAR02
		cHMistura := MV_PAR03
		cIdade    := MV_PAR04
		cFck      := MV_PAR05
		cAbat     := MV_PAR06
        cTempo    := MV_PAR07
        cDim      := MV_PAR08
        cAplica   := MV_PAR09
	
		If Empty(cVolume) .or. Empty(cVolume) .or. Empty(cHMistura) .or. Empty(cIdade) .or. Empty(cFck) .or. Empty(cAbat) .or. Empty(cTempo) .or. Empty(cDim) .or. Empty(cAplica)
			MsgBox("Favor verificar os parâmetros","Relatório CDC","INFO")
		Else
            cCliente  := AllTrim(ZG1->ZG1_FSDCLI)
            cData     := dTOc(ZG1->ZG1_FSDATA)
            cControle := AllTrim(ZG1->ZG1_FSCONT)

            DbSelectArea('ZG2')
            DbSetOrder(2)
            DbSeek(FWxFilial('ZG2')+ZG1->ZG1_FSCONT+cViagem)
            If Found()
                cMotorista := AllTrim(ZG2->ZG2_FSMOT)
                cLacre     := AllTrim(ZG2->ZG2_FSLAC)
                cCaminhao  := AllTrim(ZG2->ZG2_FSDCAM)
                cPlaca     := AllTrim(ZG2->ZG2_FSPCAM)
                cSGeo      := AllTrim(ZG2->ZG2_FSSAIG)
                cCObra     := AllTrim(ZG2->ZG2_FSCHEO)
                cSObra     := AllTrim(ZG2->ZG2_FSSAIO)
                cCGeo      := AllTrim(ZG2->ZG2_FSCHEG)
                BuscaDados()
			    Imprime() 
                //Processa({|| Imprime() }, "Aguarde...", "Imprimindo...",.F.)
            Else
                MsgBox("Dados não encontrados para os parâmetros selecionados","Relatório CDC","INFO")
            EndIf
		EndIf
	EndIf
Return


Static Function Imprime()

Local nCont     := 0
Local nRow      := 0100
Local nRow2	    := 0100
Local nRow3     := 0
Local nTotFrete	:= 0
Local nTotICMS  := 0
Local nPagina   := 0
Local oBrush1   := TBrush():New(,CLR_BLACK)
Local oFont1    := TFont():New('Andale Mono',,12,,.T.)
Local oFont2    := TFont():New('Andale Mono',,08,,.T.)
Local oFont3    := TFont():New('Andale Mono',,14,,.T.)
Local oFont4    := TFont():New('Andale Mono',,12,,.T.)

    oFont1:Underline  := .T.

    oPrint:StartPage()

    //Cabeçalho
    oPrint:Box(nRow2,0050,0400,1000,"-4")
    //oPrint:Box(nRow2,1000,0400,2000,"-4")
	oPrint:FillRect({nRow2,1000,0400,2000},oBrush1,"-4") 
    oPrint:SayBitmap(nRow,0155,"C:\totvs\Protheus\protheus_data\system\Geomix.png",0700,0290)
    oPrint:SayAlign(nRow+0050,1000,"LABORATÓRIO DE CONTROLE TECNOLÓGICO DO CONCRETO",oFont1,1000,0050,CLR_WHITE,2,0)
    oPrint:SayAlign(nRow+0110,1000,"BR 122 - KM 03 - SAÍDA PARA PINDAÍ - GUANAMBI/BA",oFont2,1000,0050,CLR_WHITE,2,0)
    oPrint:SayAlign(nRow+0160,1000,"Telefone:(77)34512936-vendas@concretogeomix.com.br",oFont2,1000,0050,CLR_WHITE,2,0)
    nRow  := 0400
    nRow2 := 0400
    oPrint:FillRect({nRow2,0050,nRow2+0050,1998},oBrush1,"-4") 
    oPrint:SayAlign(nRow,0050,"ESPECIFICAÇÕES DO CONCRETO DOSADO EM CENTRAL(CDC)",oFont3,2000,0050,CLR_WHITE,2,0)
    oPrint:Box(nRow2+0060,0050,nRow2+0120,1050,"-4")
    oPrint:SayAlign(nRow+0060,0055,"CONTRATANTE:",oFont4,0300,0050,CLR_BLACK,0,0)
    //oPrint:Box(nRow2+0060,0340,nRow2+0120,1050,"-4")
    oPrint:SayAlign(nRow+0060,0350,cCliente,oFont4,0700,0050,CLR_BLACK,2,0)
    oPrint:Box(nRow2+0060,1040,nRow2+0120,1998,"-4")
    oPrint:SayAlign(nRow+0060,1050,"MOTORISTA:",oFont4,0300,0050,CLR_BLACK,0,0)
    //oPrint:Box(nRow2+0060,1340,nRow2+0120,1998,"-4")
    oPrint:SayAlign(nRow+0060,1350,cMotorista,oFont4,0650,0050,CLR_BLACK,2,0)
    oPrint:Box(nRow2+0120,0050,nRow2+0180,0540,"-4")
    oPrint:SayAlign(nRow+0120,0055,"DATA:",oFont4,0150,0050,CLR_BLACK,0,0)
    oPrint:SayAlign(nRow+0120,0200,cData,oFont4,0200,0050,CLR_BLACK,2,0)
    oPrint:Box(nRow2+0120,0540,nRow2+0180,1040,"-4")
    oPrint:SayAlign(nRow+0120,0550,"LACRE:",oFont4,0150,0050,CLR_BLACK,1,0)
    oPrint:SayAlign(nRow+0120,0700,cLacre,oFont4,0200,0050,CLR_BLACK,2,0)
    oPrint:Box(nRow2+0120,1040,nRow2+0180,1540,"-4")
    oPrint:SayAlign(nRow+0120,1050,"CAMINHÃO:",oFont4,0200,0050,CLR_BLACK,1,0)
    oPrint:SayAlign(nRow+0120,1250,cCaminhao,oFont4,0300,0050,CLR_BLACK,2,0)
    oPrint:Box(nRow2+0120,1540,nRow2+0180,1998,"-4")
    oPrint:SayAlign(nRow+0120,1550,"PLACA:",oFont4,0200,0050,CLR_BLACK,1,0)
    oPrint:SayAlign(nRow+0120,1750,cPlaca,oFont4,0300,0050,CLR_BLACK,2,0)
    oPrint:Box(nRow2+0180,0050,nRow2+0240,1570,"-4")
    oPrint:SayAlign(nRow+0180,0055,"HR SAÍDA:",oFont2,0150,0050,CLR_BLACK,0,0)
    oPrint:SayAlign(nRow+0180,0200,cSGeo,oFont2,0150,0050,CLR_BLACK,2,0)
    oPrint:SayAlign(nRow+0180,0350,"HR CHEGADA OBRA:",oFont2,0250,0050,CLR_BLACK,1,0)
    oPrint:SayAlign(nRow+0180,0600,cCObra,oFont2,0150,0050,CLR_BLACK,2,0)
    oPrint:SayAlign(nRow+0180,0750,"HR SAIDA OBRA:",oFont2,0230,0050,CLR_BLACK,1,0)
    oPrint:SayAlign(nRow+0180,0980,cSObra,oFont2,0150,0050,CLR_BLACK,2,0)
    oPrint:SayAlign(nRow+0180,1130,"HR CHEGADA GEOMIX:",oFont2,0300,0050,CLR_BLACK,1,0)
    oPrint:SayAlign(nRow+0180,1430,cCGeo,oFont2,0140,0050,CLR_BLACK,2,0)
    oPrint:Box(nRow2+0180,1540,nRow2+0240,1998,"-4")
    oPrint:SayAlign(nRow+0180,1560,"CONTROLE:",oFont4,0200,0050,CLR_BLACK,1,0)
    oPrint:SayAlign(nRow+0180,1780,cControle,oFont4,0270,0050,CLR_BLACK,2,0)
    oPrint:FillRect({nRow2+0240,0050,nRow2+0290,1998},oBrush1,"-4") 
    oPrint:SayAlign(nRow+0240,0050,"ESPECIFICAÇÕES OBRIGATÓRIAS",oFont3,2000,0050,CLR_WHITE,2,0)
    oPrint:Box(nRow2+0300,0050,nRow2+0360,1040,"-4")
    oPrint:SayAlign(nRow+0300,0055,"Volume de Concreto(m3)",oFont4,1040,0050,CLR_BLACK,2,0)
    oPrint:Box(nRow2+0300,1040,nRow2+0360,1998,"-4")
    oPrint:SayAlign(nRow+0300,1050,AllTrim(cVolume),oFont4,0950,0050,CLR_BLACK,2,0)
    oPrint:Box(nRow2+0360,0050,nRow2+0420,1040,"-4")
    oPrint:SayAlign(nRow+0360,0055,"Hora de início da mistura",oFont4,1040,0050,CLR_BLACK,2,0)
    oPrint:Box(nRow2+0360,1040,nRow2+0420,1998,"-4")
    oPrint:SayAlign(nRow+0360,1050,AllTrim(cHMistura),oFont4,0950,0050,CLR_BLACK,2,0)
    oPrint:Box(nRow2+0420,0050,nRow2+0480,1040,"-4")
    oPrint:SayAlign(nRow+0420,0055,"Idade de controle",oFont4,1040,0050,CLR_BLACK,2,0)
    oPrint:Box(nRow2+0420,1040,nRow2+0480,1998,"-4")
    oPrint:SayAlign(nRow+0420,1050,AllTrim(cIdade),oFont4,0950,0050,CLR_BLACK,2,0)
    oPrint:Box(nRow2+0480,0050,nRow2+0540,1040,"-4")
    oPrint:SayAlign(nRow+0480,0055,"Fck(MPa)",oFont4,1040,0050,CLR_BLACK,2,0)
    oPrint:Box(nRow2+0480,1040,nRow2+0540,1998,"-4")
    oPrint:SayAlign(nRow+0480,1050,AllTrim(cFck),oFont4,0950,0050,CLR_BLACK,2,0)
    oPrint:Box(nRow2+0540,0050,nRow2+0600,1040,"-4")
    oPrint:SayAlign(nRow+0540,0055,"Abatimento(mm)",oFont4,1040,0050,CLR_BLACK,2,0)
    oPrint:Box(nRow2+0540,1040,nRow2+0600,1998,"-4")
    oPrint:SayAlign(nRow+0540,1050,AllTrim(cAbat),oFont4,0950,0050,CLR_BLACK,2,0)
    oPrint:Box(nRow2+0600,0050,nRow2+0660,1040,"-4")
    oPrint:SayAlign(nRow+0600,0055,"Tempo para consumo",oFont4,1040,0050,CLR_BLACK,2,0)
    oPrint:Box(nRow2+0600,1040,nRow2+0660,1998,"-4")
    oPrint:SayAlign(nRow+0600,1050,AllTrim(cTempo),oFont4,0950,0050,CLR_BLACK,2,0)
    oPrint:Box(nRow2+0660,0050,nRow2+0720,1040,"-4")
    oPrint:SayAlign(nRow+0660,0055,"Dim. máx. car. do agregado graúdo(mm)",oFont4,1040,0050,CLR_BLACK,2,0)
    oPrint:Box(nRow2+0660,1040,nRow2+0720,1998,"-4")
    oPrint:SayAlign(nRow+0660,1050,AllTrim(cDim),oFont4,0950,0050,CLR_BLACK,2,0)
    oPrint:Box(nRow2+0720,0050,nRow2+0780,1040,"-4")
    oPrint:SayAlign(nRow+0720,0055,"Aplicação",oFont4,1040,0050,CLR_BLACK,2,0)
    oPrint:Box(nRow2+0720,1040,nRow2+0780,1998,"-4")
    If cAplica == 1
        oPrint:SayAlign(nRow+0720,1050,"[X] Convencional   [ ] Bombeado",oFont4,0950,0050,CLR_BLACK,2,0)
    ElseIf cAplica == 2
        oPrint:SayAlign(nRow+0720,1050,"[ ] Convencional   [X] Bombeado",oFont4,0950,0050,CLR_BLACK,2,0)
    EndIf
    oPrint:FillRect({nRow2+0780,0050,nRow2+0830,1998},oBrush1,"-4") 
    oPrint:SayAlign(nRow+0780,0050,"CARREGAMENTO DO CARRO",oFont3,1040,0050,CLR_WHITE,2,0)
    oPrint:SayAlign(nRow+0780,1050,"QUANTIDADE",oFont3,475,0050,CLR_WHITE,2,0)
    oPrint:SayAlign(nRow+0780,1525,"UNIDADE",oFont3,475,0050,CLR_WHITE,2,0)
    nRow  := nRow + 0780
    nRow2 := nRow + 0780
    For nCont := 1 To Len(aDados)
        nRow  += 0060
        oPrint:Box(nRow,0050,nRow+0060,1050,"-4")
        oPrint:Box(nRow,1050,nRow+0060,1525,"-4")
        oPrint:Box(nRow,1525,nRow+0060,2000,"-4")
        oPrint:SayAlign(nRow,0050,aDados[nCont][1],oFont4,1040,0050,CLR_BLACK,2,0)    
        oPrint:SayAlign(nRow,1050,AllTrim(Str(aDados[nCont][2])),oFont4,475,0050,CLR_BLACK,2,0)
        oPrint:SayAlign(nRow,1525,aDados[nCont][3],oFont4,475,0050,CLR_BLACK,2,0)

    Next

    

    oPrint:EndPage()
	oPrint:Print()
Return



Static Function BuscaDados()
Local cDescPrd := ""
Local cFilter  := ""
Local bFilter  := ""

    aDados := {}

    DbSelectArea('SD3')
    cIndexName := Criatrab(Nil,.F.)
    cIndexKey  := "D3_FILIAL+D3_FSCONT+D3_FSVIAG"
    bFilter    := {|| D3_FILIAL == FWxFilial('SD3') .AND. D3_FSCONT == AllTrim(cControle) .AND. D3_FSVIAG == AllTrim(cViagem)}
    cFilter    := "D3_FILIAL == '"+FWxFilial('SD3')+"' .AND. D3_FSCONT == '"+AllTrim(cControle)+"' .AND. D3_FSVIAG == '"+AllTrim(cViagem)+"'  "
    DbSetOrder(18)
    DbSetFilter(bFilter, cFilter)
    SD3->(DbGoTop())
    Do While SD3->(!Eof())
        DbSelectArea('SB1')
        DbSetOrder(1)
        DbSeek(FWxFilial('SB1')+AllTrim(SD3->D3_COD))
        cDescPrd := SB1->B1_DESC
        SB1->(DbCloseArea())
        aAdd(aDados,{cDescPrd      ,;
                     SD3->D3_QUANT ,;
                     SD3->D3_UM    ,;
                     SD3->D3_FSCONT,;
                     SD3->D3_FSVIAG})
        SD3->(DbSkip())
    EndDo
    SD3->(DbCloseArea())

Return

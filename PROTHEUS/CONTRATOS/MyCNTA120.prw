#include "protheus.ch"
#include "tbiconn.ch"

User Function MyCNTA120()

    Local aCabec := {}
    Local aItem  := {}
    Local cDoc   := ""
    Local cArqTrb:= ""
    Local cContra := ""
    Local cRevisa := ""
    Local dData    := date()//Data Atual
    Local dDataI   := dData-0//Data de inicio

    Private lMsHelpAuto := .T.
    PRIVATE lMsErroAuto := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Abertura do ambiente                                         |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    ConOut(Repl("-",80))
    ConOut(PadC("Rotina Automática para a Medição do Contrato de Compras e Vendas",80))

//PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "GCT" 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Verificacao do ambiente para teste                           |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    dbSelectArea("CN9")
    dbgoto(Recno())

    cContra := CN9->CN9_NUMERO
    cRevisa := CN9->CN9_REVISA

    ConOut("Inicio: "+Time())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Teste de Inclusao                                            |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    dbSelectArea("CN9")
    dbSetOrder(1)

    If !dbSeek(xFilial("CN9")+cContra+cRevisa)
        ConOut("Cadastrar contrato: "+cContra)
    EndIf	aCabec := {}aItens := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra parcelas de contratos automaticos ³
//³ pendentes para a data atual              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙc

    ArqTrb	:= CriaTrab( nil, .F. )
    cQuery := "SELECT CNF.CNF_COMPET,CNF.CNF_CONTRA,CNF.CNF_REVISA,CNA.CNA_NUMERO,CNF.CNF_PARCEL,CN9.CN9_FILIAL FROM " + RetSQLName("CNF") + " CNF, " + RetSQLName("CNA") + " CNA, "+ RetSQLName("CN9") +" CN9 WHERE "
    cQuery += "CNF.CNF_FILIAL = '"+ xFilial("CNF") +"' AND "
    cQuery += "CNA.CNA_FILIAL = '"+ xFilial("CNA") +"' AND "
    cQuery += "CN9.CN9_FILIAL = '"+ xFilial("CN9") +"' AND "
    cQuery += "CN9.CN9_NUMERO = '"+cContra+"' AND "
    cQuery += "CN9.CN9_REVISA = '"+cRevisa+"' AND "
    cQuery += "CNF.CNF_NUMERO = CNA.CNA_CRONOG AND "
    cQuery += "CNF.CNF_CONTRA = CNA.CNA_CONTRA AND "
    cQuery += "CNF.CNF_REVISA = CNA.CNA_REVISA AND "
    cQuery += "CNF.CNF_CONTRA = CN9.CN9_NUMERO AND "
    cQuery += "CNF.CNF_REVISA = CN9.CN9_REVISA AND "
    cQuery += "CN9.CN9_SITUAC =  '05' AND "
    cQuery += "CNF.CNF_PRUMED >= '"+ DTOS(dDataI) +"' AND "
    cQuery += "CNF.CNF_PRUMED <= '"+ DTOS(dData) +"' AND "
    cQuery += "CNF.CNF_SALDO  > 0 AND "
    cQuery += "CNA.CNA_SALDO  > 0 AND "
    cQuery += "CNF.D_E_L_E_T_ = ' ' AND "
    cQuery += "CNA.D_E_L_E_T_ = ' '"
    cQuery := ChangeQuery( cQuery )

    dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cArqTrb, .T., .T. )
    If (cArqTrb)->(Eof())
        ConOut("Nao e possivel medir esse contrato! "+cContra)
    EndIf

    While !(cArqTrb)->(Eof())
        cDoc := CriaVar("CND_NUMMED")
        aAdd(aCabec,{"CND_CONTRA",(cArqTrb)->CNF_CONTRA,NIL})
        aAdd(aCabec,{"CND_REVISA",(cArqTrb)->CNF_REVISA,NIL})
        aAdd(aCabec,{"CND_COMPET",(cArqTrb)->CNF_COMPET,NIL})
        aAdd(aCabec,{"CND_NUMERO",(cArqTrb)->CNA_NUMERO,NIL})
        aAdd(aCabec,{"CND_NUMMED",cDoc,NIL})

        If !Empty(CND->( FieldPos( "CND_PARCEL" ) ))
            aAdd(aCabec,{"CND_PARCEL",(cArqTrb)->CNF_PARCEL,NIL})
        EndIf
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Executa rotina automatica para gerar as medicoes ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

        CNTA120(aCabec,aItem,3,.F.)

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Executa rotina automatica para encerrar as medicoes ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

        CNTA120(aCabEC,aItem,6,.F.)
        If !lMsErroAuto
            ConOut("Incluido com sucesso! "+cDoc)
        Else		ConOut("Erro na inclusao!")
        EndIf
        (cArqTrb)->(dbSkip())
    EndDo
    (cArqTrb)->(dbCloseArea())

    //RESET ENVIRONMENT

Return(.T.)
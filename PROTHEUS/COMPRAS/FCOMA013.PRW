#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"

Function u_FCOMA013()

    Local c_Num     := SC8->C8_NUM
    Local c_Produto := SC8->C8_PRODUTO
    Local c_Objeto  := ""
    Local c_DescObj := ""
    Local c_CodObj	:= ""
    Local n_TamKye  := TamSX3("C8_FILIAL")[1] + TamSX3("C8_NUM")[1] + TamSX3("C8_ITEM")[1] + TamSX3("C8_ITEMGRD")[1] + TamSX3("C8_FORNECE")[1] + TamSX3("C8_LOJA")[1]
    Local c_Chave   := ""
    Local c_Query   := ""

    If !MsgYesNo("Confirma réplica dos documentos da cotação?" , "FJC")

        RETURN()

    ENDIF

    c_Query := " SELECT "
    c_Query += "     AC9_CODOBJ "
    c_Query += " FROM "
    c_Query += "     " + RETSQLNAME("SC8") + " C8 "
    c_Query += " INNER JOIN "
    c_Query += "     " + RETSQLNAME("AC9") + " C9 "
    c_Query += " ON "
    c_Query += "     C9.D_E_L_E_T_ = '' "
    c_Query += "     AND C9.AC9_CODENT LIKE C8.C8_FILIAL + C8.C8_NUM + C8.C8_ITEM + C8.C8_ITEMGRD + C8.C8_FORNECE + C8.C8_LOJA + '%' "
    c_Query += " WHERE "
    c_Query += "     C8.D_E_L_E_T_ = '' "
    c_Query += "     AND C8.C8_NUM = '" + SC8->C8_NUM + "' "
    c_Query += "     AND C8.C8_PRODUTO = '" + SC8->C8_PRODUTO + "' "

    TcQuery c_Query New Alias "QRY1"
    dbSelectArea("QRY1")
    c_CodObj    := QRY1->AC9_CODOBJ
    QRY1->( dbCloseArea() )

    c_Query := " SELECT "
    c_Query += "      C8_FORNECE, C8_LOJA, C8_FILIAL, C8_NUM, C8_ITEM, C8_ITEMGRD, C8_FORNECE, C8_LOJA "
    c_Query += " FROM
    c_Query += "     " + RETSQLNAME("SC8") + " C8 "
    c_Query += " WHERE "
    c_Query += "     C8.D_E_L_E_T_ ='' "
    c_Query += "     AND C8.C8_NUM = '" + SC8->C8_NUM + "' "
    c_Query += "     AND C8.C8_PRODUTO = '" + SC8->C8_PRODUTO + "'
    c_Query += "     AND NOT EXISTS "
    c_Query += "         (
    c_Query += "             SELECT AC9_CODOBJ FROM " + RETSQLNAME("AC9") + " C9 WHERE C9.D_E_L_E_T_ = '' AND C9.AC9_CODENT LIKE C8.C8_FILIAL + C8.C8_NUM + C8.C8_ITEM + C8.C8_ITEMGRD + C8.C8_FORNECE + C8.C8_LOJA + '%' "
    c_Query += "         ) "

    TcQuery c_Query New Alias "QRY2"

    dbSelectArea("QRY2")
    While QRY2->( !EOF() )

        dbSelectArea("SA2")
        dbSetOrder(1)
        dbSeek( xFilial("SA2") + QRY2->C8_FORNECE + QRY2->C8_LOJA )

        dbSelectArea("AC9")
        RecLock("AC9",.T.)
        AC9->AC9_FILIAL := xFilial("AC9")
        AC9->AC9_FILENT := xFilial("SC8")
        AC9->AC9_ENTIDA := "SC8"
        AC9->AC9_CODENT := QRY2->C8_FILIAL + QRY2->C8_NUM + QRY2->C8_ITEM + QRY2->C8_ITEMGRD + QRY2->C8_FORNECE + QRY2->C8_LOJA + SA2->A2_NOME
        AC9->AC9_CODOBJ := c_CodObj
        MsUnLock()

        QRY2->( dbSkip() )

    EndDo
    QRY2->( dbCloseArea() )

    MsgInfo("Rotina executada com sucesso!!!")

Return()

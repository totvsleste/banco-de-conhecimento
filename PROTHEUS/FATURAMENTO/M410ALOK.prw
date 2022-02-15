function u_M410ALOK()

    Local a_SC5Area := SC5->(GetArea())
    Local a_SC6Area := SC6->(GetArea())
    Local a_SE1Area := SE1->(GetArea())

    Local c_Num     := SC5->C5_NUM

    If IsInCallStack("A410Deleta")

        Public a_Dados  := {}

        dbSelectArea("SC6")
        dbSetOrder(1)
        dbSeek( xFilial("SC6") + c_Num )
        While SC6->(!EOF()) .AND. SC6->(C6_FILIAL+C6_NUM) == xFilial("SC6") + c_Num

            Aadd(a_Dados,{SC6->C6_NUM, SC6->C6_ITEM})

            SC6->( dbSkip() )

        EndDo

    EndIf

    RestArea(a_SC5Area)
    RestArea(a_SC6Area)
    RestArea(a_SE1Area)

Return(.T.)

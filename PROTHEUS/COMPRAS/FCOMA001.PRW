Function u_FCOMA001()

    Local c_Num     := SC8->C8_NUM
    Local c_Produto := SC8->C8_PRODUTO
    Local c_Objeto  := ""
    Local c_DescObj := ""
    
    dbSelectArea( "SC8" )
    dbSetOrder( 3 )
    dbSeek( xFilial("SC8") + c_Num + c_Produto )
    
    While SC8->( !eof()) .And.  SC8->C8_FILIAL + SC8->C8_NUM + SC8->C8_PRODUTO == xFilial("SC8") + c_Num + c_Produto

        BeginSQL Alias "QRY"

            SELECT 
                *
            FROM
                AC9990 AC9
            WHERE
                AC9.D_E_L_E_T_ = ''
                AND AC9.AC9_CODENT LIKE %exp:SC8->C8_FILIAL + SC8->C8_NUM + SC8->C8_ITEM + SC8->C8_ITEMGRD + SC8->C8_FORNECE + SC8->C8_LOJA%

         EndSQL

         dbSelectArea("QRY")
         If QRY->( !eof() )

            dbSelectArea("ACB")
            dbSetOrder(1)
            dbSeek( xFilial("ACB") + QRY->AC9_CODOBJ )
            c_Objeto  := ACB->ACB_OBJETO
            c_DescObj := ACB->ACB_DESCRI

        Else
            
            dbSelectArea("SA2")
            dbSetOrder(1)
            dbSeek( xFilial("SA2") + SC8->C8_FORNECE + SC8->C8_LOJA )
            
            dbSelectArea("AC9")
            RecLock("AC9",.T.)
            AC9->AC9_FILIAL := xFilial("AC9")
            AC9->AC9_FILENT := xFilial("SC8")
            AC9->AC9_ENTIDA := "SC8"
            AC9->AC9_CODENT := SC8->C8_FILIAL + SC8->C8_NUM + SC8->C8_ITEM + SC8->C8_ITEMGRD + SC8->C8_FORNECE + SC8->C8_LOJA + SA2->A2_NOME                                   
            //AC9->AC9_CODOBJ := --SELECT MAX NO AC9_CODOBJ
            MsUnLock()

            dbSelectArea("ACB")
            RecLock("ACB",.T.)
            ACB->ACB_FILIAL := xFilial("AC9")
            ACB->ACB_CODOBJ := AC9->AC9_CODOBJ
            ACB->ACB_OBJETO := c_Objeto
            ACB->ACB_DESCRI := c_DescObj
            MsUnLock()


         EndIf
        
        SC8->( dbSkip() )

    EndDo

Return()

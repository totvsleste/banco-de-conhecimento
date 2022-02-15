function u_MT150GRV()

    Local n_Opcx    := ParamIxb[1]

    if n_Opcx == 2  //Novo Participante

        Alert("Passei")
        
        Reclock("SC8",.F.)
        SC8->C8_FSHASH  := ""
        MsUnlock()

    endif

Return()

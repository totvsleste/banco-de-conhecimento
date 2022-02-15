Function u_MT150ROT()

    Local a_Rotina  := ParamIxb

    AAdd(a_Rotina,{ "Replicar Anexo", "u_FCOMA013"  , 0 , 6, 0, .F.})
    AAdd(a_Rotina,{ "Enviar p/ Portal", "u_FCOMA013"  , 0 , 6, 0, .F.})

Return( a_Rotina )
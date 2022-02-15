function u_MTA410()

    Local l_Ret := .T.
    
    If !INCLUI .AND. !ALTERA
        u_FFATA01B() 
    EndIf

return( l_Ret )

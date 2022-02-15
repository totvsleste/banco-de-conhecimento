/*/{Protheus.doc} u_M410STTS
    (long_description)
    @type  Function
    @author francisco.ssa
    @since 24/08/2020
    @version 12.1.17
    @return Nil, Nil, Nil
    @example
    (examples)
    @see (links_or_references)
    /*/
Function u_M410STTS()

    Local a_SC5Area := SC5->(GetArea())
    Local a_SC6Area := SC6->(GetArea())
    Local a_SE1Area := SE1->(GetArea())

    If INCLUI
        u_FFATA01A()
    ElseIf !INCLUI .And. !ALTERA
        if len( a_Dados ) > 0
            u_FFATA01B()
        endif
    EndIf

    RestArea(a_SC5Area)
    RestArea(a_SC6Area)
    RestArea(a_SE1Area)
    
Return()

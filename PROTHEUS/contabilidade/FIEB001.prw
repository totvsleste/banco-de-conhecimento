/*/{Protheus.doc} FIEB001
    (long_description)
    @type  Function
    @author francisco.ssa
    @since 21/08/2020
    @version 12.1.17
    @example
    (examples)
    @see (links_or_references)
    /*/
Function u_FIEB001()

    Local o_Fieb    := clsFieb():New()


    Alert(o_Fieb:mtdContaMotBx( "", "ACS", "DAC", "2" ))
    Alert(o_Fieb:mtdContaMotBx( "TST", "ACS", "DAC", "2" ))

Return()

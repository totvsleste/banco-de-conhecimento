
#INCLUDE "PROTHEUS.CH"
#Include "RwMake.ch"

Function u_MSD2460()

    Local a_SC5Area := SC5->( GetArea() )
    Local a_SC6Area := SC6->( GetArea() )
    Local a_SE1Area := SE1->( GetArea() )

    Private a_Dados := {}

    Aadd( a_Dados, { SD2->D2_PEDIDO , SD2->D2_ITEMPV } )

    u_FFATA01B()

    RestArea( a_SC5Area )
    RestArea( a_SC6Area )
    RestArea( a_SE1Area )

Return()



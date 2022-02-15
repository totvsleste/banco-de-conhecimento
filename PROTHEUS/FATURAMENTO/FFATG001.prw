#INCLUDE "TOTVS.CH"

function u_FFATG001()

    Local n_Preco   := aCols[ n ][ aScan( aHeader , { | x | AllTrim( x[ 2 ] ) == "C6_PRCVEN" } ) ]
    Local c_Prod    := aCols[ n ][ aScan( aHeader , { | x | AllTrim( x[ 2 ] ) == "C6_PRODUTO" } ) ]

    dbSelectArea("SB1")
    dbSetOrder(1)
    if dbSeek( FwxFilial("SB1") + c_Prod, .t. )

        if n_Preco < SB1->B1_FSMINPR

            Alert("O menor preço para este produto é: " + Alltrim( Str( SB1->B1_FSMINPR ) ) + " Por favor, corrija o preço" )
            n_Preco := 0

        endif

    endif

return( n_Preco )

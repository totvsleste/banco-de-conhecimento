#INCLUDE "TOTVS.CH"

#DEFINE ENTER CHR(13) + CHR(10)

Function u_FCFGA001()

    Local nx
    Local aAllusers     := FWSFALLUSERS()

    Local c_String	    := "ID;NOME;BLOQUEADO" + ENTER
    Local c_Bloq        := ""

    For nx := 1 To Len(aAllusers)

        PswOrder(1)
        PswSeek( aAllusers[nx][2], .T. )

        a_Ret	    := PswRet(1)
        if a_Ret[1][17]
            c_Bloq      := "Bloqueado"
        else
            c_Bloq      := "Liberado"
        EndIf
        c_String    += aAllusers[nx][2] + ";" + aAllusers[nx][4] + ";" + c_Bloq + ENTER

    Next

    MemoWrite("c:\temp\usuarios.csv",c_String)

Return()

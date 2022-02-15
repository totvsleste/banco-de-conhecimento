#INCLUDE "TOTVS.CH"
#INCLUDE "XMLXFUN.CH"

function u_LetArqUse()

    //nHandle := FT_FUse("C:\temp\tsj\20210324105941sascar_obterpacoteposicoesmotorista.xml")

    if nHandle = -1
        return
    endif

    FT_FGoTop()
    // Retorna o número de linhas do arquivo
    nLast := FT_FLastRec()
    MsgAlert( nLast )
    While !FT_FEOF()
        cLine  := FT_FReadLn()
        // Retorna a linha corrente
        nRecno := FT_FRecno()
        // Retorna o recno da Linha
        MsgAlert( "Linha: " + cLine + " - Recno: " + StrZero(nRecno,3) )
        // Pula para próxima linha
        FT_FSKIP()
    End
    // Fecha o Arquivo
    FT_FUSE()

return

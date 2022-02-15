#Include 'Protheus.ch'
 
User Function MNTA4351()
 
    aBtn := {"NG_ICO_ALTBEMM",{|| u_FMNTA001()},"Cancelamento OS","Cancelamento OS"}
     
Return aBtn

Function u_FMNTA001()

    Local c_Usuario := RetCodUsr()
    Local c_UserPar := SuperGetMV("FS_USRCANI",.F.,"000000|000001")

    If c_Usuario $ c_UserPar
        If MsgYesNo("Deseja realamente cancelar essa OS? Tá certo disso? Não tem volta!" , "[PE: MNTA4351]")
            RecLock("STJ",.F.)
            STJ->TJ_SITUACA := "C"
            MsUnlock()
        endif
    endif

Return()

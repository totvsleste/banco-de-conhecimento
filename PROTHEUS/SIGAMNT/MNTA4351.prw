#Include 'Protheus.ch'
 
User Function MNTA4351()
 
    aBtn := {"NG_ICO_ALTBEMM",{|| u_FMNTA001()},"Cancelamento OS","Cancelamento OS"}
     
Return aBtn

Function u_FMNTA001()

    Local c_Usuario := RetCodUsr()
    Local c_UserPar := SuperGetMV("FS_USRCANI",.F.,"000000|000001")
    Local nPosAnt   := oOS:nAt

    If c_Usuario $ c_UserPar
        If MsgYesNo("Deseja realamente cancelar essa OS? Tá certo disso? Não tem volta!" , "[PE: MNTA4351]")
            RecLock("STJ",.F.)
            STJ->TJ_SITUACA := "C"
            MsUnlock()

            //Remove a O.S. da tela de retorno mod. 2
            aAdd( aVetorCan , {STJ->TJ_ORDEM,STJ->TJ_PLANO} )
            aDel(aOS,oOS:nAt)
            aSize(aOS,Len(aOS)-1)
            If Len(aOS) == 0
                fEmptyOS(.T.)
            EndIf
            If nPosAnt > Len(aOS)
                nPosAnt := Len(aOS)
            EndIf
            oOS:nAt := nPosAnt
            fRefreshOS( aOS[oOS:nAt,nPosOS], aOS[oOS:nAt,nPosPL] , oOS:nAt, 1 )
        endif
    endif

Return()

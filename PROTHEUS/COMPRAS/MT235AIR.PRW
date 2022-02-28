function u_MT235AIR()

    Local n_TpAlias := ParamIXB[2]

    /*
    Local oServico	:= WSECMWorkflowEngineServiceService():New()
	Local cUsername	:= "eletrodata"
	Local cPassword	:= "totvs"
	Local nCompanyId	:= 1
	Local cProcessId	:= val(SC7->C7_FSFLUIG)
	Local nCancelText	:= "Processo cancelado automaticamente por eliminação de resíduo."
    */

    if n_TpAlias == 1

        /*
        if oServico:cancelInstance(cUsername,cPassword,nCompanyId,cProcessId,cUsername,nCancelText)
            if oServico:cresult <> "OK"
                alert("Falha no Fluig ->"+ oServico:cresult)
            endif
        else
            alert("Erro de Execução ->"+GetWSCError())
        endif
        */

    endif

return

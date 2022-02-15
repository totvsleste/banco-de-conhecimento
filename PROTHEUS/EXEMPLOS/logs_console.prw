function u_logconsoletst()

    nBegin := Seconds()
    aMessage := {}
    cMsg := ""
    nQtdMsg := 1
    nI := 1

   //Informações adicionais
    aAdd(aMessage, {"Date", Date()})
    aAdd(aMessage, {"Hour", Time()})
 
    if getRemoteType() != NO_REMOTE
        aAdd(aMessage, {"Computer", GetClientIP()})
        aAdd(aMessage, {"IP", GetClientIP()})
    endif
 
    //Quando enviado o parâmetro de aMessage, o parâmetro cMessage não é exibido no console
    //FWLogMsg("INFO", "LAST", "MeuGrupo", "MinhaCategoria", cValToChar(nI +1) , "MeuID", cMsg, nQtdMsg, Seconds() - nBegin, aMessage)
    FWLogMsg("INFO", /*cTransactionId*/, "CP114JOB", /*cCategory*/, /*cStep*/, /*cMsgId*/, "### CP114JOB: FIM "+DTOC(DATE())+" "+TIME(), /*nMensure*/, /*nElapseTime*/, /*aMessage*/)

return()


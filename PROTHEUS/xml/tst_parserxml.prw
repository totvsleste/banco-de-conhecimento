function u_tstparserxml()

    local c_Xml := "<env:Envelope xmlns:env='http://schemas.xmlsoap.org/soap/envelope/'><env:Header></env:Header><env:Body><ns1:startProcessResponse xmlns:ns1='http://ws.workflow.webdesk.technology.datasul.com/'><result><item><item>iTask</item><item>2</item></item><item><item>WDNrVersao</item><item>1000</item></item><item><item>iProcess</item><item>304135</item></item><item><item>cDestino</item><item>[Pool:Role:22]</item></item><item><item>WDNrDocto</item><item>976960</item></item></result></ns1:startProcessResponse></env:Body></env:Envelope>"

    Local cError   := ""
    Local cWarning := ""
    Local oXml := NIL

    //Gera o Objeto XML
    oXml := XmlParser( c_Xml, "_", @cError, @cWarning )
    If (oXml == NIL )
        conout("Falha ao gerar Objeto XML : "+cError+" / "+cWarning)
        Return
    Endif

    conout("teste")

return()
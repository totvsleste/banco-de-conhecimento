function u_FFABA002()

	Local o_Wsdl as object
	Local cError      := ""
	Local cWarning    := ""

	o_Wsdl := TWsdlManager():New()
    o_Wsdl:lSSLInsecure := .T.
	o_Wsdl:lVerbose := .t.

	o_Wsdl:ParseURL("http://localhost:1978/FWAUTHENTICATION.apw?WSDL")
	o_Wsdl:SetOperation("TOKEN")

	o_Wsdl:SetValue(0, "password")
	o_Wsdl:SetValue(3, "totvs") //usuario
	o_Wsdl:SetValue(4, "totvs") //senha

	o_Wsdl:SendSoapMsg()

	cSoapResponse := o_Wsdl:GetSoapResponse()
	oXml := XmlParser(cSoapResponse, "_", @cError, @cWarning )

	FreeObj(o_Wsdl)
	o_Wsdl := nil

	o_Wsdl := TWsdlManager():New()
    o_Wsdl:lSSLInsecure := .T.

	//Verifica o endereço, se existe algum serviço disponível e se existe o serviço que quero utilizar
	o_Wsdl:ParseURL("http://localhost:1978/FWAUTHENTICATION.apw?WSDL")
	o_Wsdl:SetOperation("TOKEN")

	o_Wsdl:SetValue(0, "refresh_token")
	o_Wsdl:SetValue(5, oXml:_SOAP_ENVELOPE:_SOAP_BODY:_TOKENRESPONSE:_TOKENRESULT:_REFRESH_TOKEN:Text)

	o_Wsdl:SendSoapMsg()

	FWFreeVar(@oXml)

	cError := ""
	cWarning := ""

	cSoapResponse := o_Wsdl:GetSoapResponse()
	oXml := XmlParser(cSoapResponse, "_", @cError, @cWarning )

	FreeObj(o_Wsdl)
	o_Wsdl := nil

//Consome um serviço autenticado
	o_Wsdl := TWsdlManager():New()

	o_Wsdl:ParseURL("http://localhost:1978/FFABA001.apw?WSDL")
	o_Wsdl:SetOperation("GETTABLELIST")

	o_Wsdl:AddHttpHeader("Authorization", "Bearer " + oXml:_SOAP_ENVELOPE:_SOAP_BODY:_TOKENRESPONSE:_TOKENRESULT:_ACCESS_TOKEN:Text)

	o_Wsdl:SetValue(0, "SED")

	o_Wsdl:SendSoapMsg()

	ConOut("GetSoapResponse:", o_Wsdl:GetSoapResponse())

	FreeObj(o_Wsdl)
	o_Wsdl := nil

return()

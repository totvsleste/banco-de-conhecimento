#INCLUDE "TOPCONN.CH
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "TBICONN.CH"
#DEFINE ENTER CHR(13)+CHR(10)

WSSERVICE WS_FSWS123 Description "<span style='color:red;'>Fábrica de Software - TOTVS BA</span><br/>&nbsp;&nbsp;&nbsp;<span style='color:red;'> WS para <b>Controle de Documentos</b>.</span>"

	WSDATA o_EmpFil	 			AS strEmp_Fil
	WSDATA o_RetMtd				AS strRet_Metodo
	WSDATA o_BancoConhecimento 	AS strBancoConhecimento

	WSMETHOD mtdGravaBancoConhecimento
	WSMETHOD mtdExcluiBancoConhecimento

ENDWSSERVICE

WSSTRUCT strBancoConhecimento

	WSDATA a_Banco AS ARRAY OF strBanco

ENDWSSTRUCT

WSSTRUCT strBanco

	WSDATA AC9_FILENT AS STRING
    WSDATA AC9_ENTIDA AS STRING
    WSDATA AC9_CODENT AS STRING
    
	WSDATA ACB_OBJETO AS STRING
	WSDATA ACB_DESCRI AS STRING

	WSDATA LINK_OBJ	  AS STRING
	WSDATA NOME_OBJ	  AS STRING

	WSDATA ID_FLUIG	  AS STRING

ENDWSSTRUCT

//Estrutura de Empresa e Filial
WSSTRUCT strEmp_Fil

	WSDATA c_Empresa 	AS STRING
	WSDATA c_Filial		AS STRING

ENDWSSTRUCT

//Estrutura de Retorno dos Metodos
WSSTRUCT strRet_Metodo

	WSDATA l_Status			AS BOOLEAN
	WSDATA c_Mensagem		AS STRING

ENDWSSTRUCT

WSMETHOD mtdExcluiBancoConhecimento WSRECEIVE o_EmpFil, o_BancoConhecimento WSSEND o_RetMtd WSSERVICE WS_FSWS123

	Local a_DadosBC	:= o_BancoConhecimento:a_Banco
	Local nX		:= 0
	Local c_Query	:= ""
	Local c_Update	:= ""
	Local c_Objeto	:= ""

	RpcSetType(3)
	RpcSetEnv(o_EmpFil:c_Empresa,o_EmpFil:c_Filial)

	For nX:=1 To Len( a_DadosBC ) Step 1

		c_Query		:= "SELECT AC9_CODOBJ FROM " + RETSQLNAME("AC9") + " WHERE D_E_L_E_T_ = '' AND AC9_CODENT LIKE '%" + a_DadosBC[nX]:ID_FLUIG + "' " //AC9_FSIDFL = '" + a_DadosBC[nX]:ID_FLUIG + "' "
		TcQuery c_Query New Alias "QRY"

		dbSelectArea("QRY")
		c_Objeto := QRY->AC9_CODOBJ
		QRY->( dbCloseArea() )

		c_Update	:= ""
		c_Update	+= " UPDATE " + RETSQLNAME("AC9") + " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ WHERE AC9_CODOBJ = '' "
		TCSqlExec( c_Update )
		
		c_Update	:= ""
		c_Update	+= " UPDATE " + RETSQLNAME("ACB") + " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ WHERE ACB_CODOBJ = '' "
		TCSqlExec( c_Update )

	Next nX

Return(.T.)

WSMETHOD mtdGravaBancoConhecimento WSRECEIVE o_EmpFil, o_BancoConhecimento WSSEND o_RetMtd WSSERVICE WS_FSWS123

	Local c_Objeto	:= ""
	Local a_DadosBC	:= o_BancoConhecimento:a_Banco
	Local nX		:= 0
	Local cURL    	:= "http://www2.fjc.org.br:8080/volume/stream/Rmx1aWc="                      // URL DO SERVIÇO
    Local cPath   	:= "" //"/P3Q9MSZ2b2w9ZGVmYXVsdCZpZD0yNjM4ODUmdmVyPTEwMDAmZmlsZT1GbHVpZystK0FjZXNzbythbytSZWZlaXQlQzMlQjNyaW8ucGRmJmNyYz0zMTU0NjU0OTIyJnNpemU9MC4wMTE0NTUmdUlkPTE1MyZmU0lkPTEmdVNJZD0xJmQ9ZmFsc2UmdGtuPSZwdWJsaWNVcmw9ZmFsc2U=.pdf" // RECURSO DA URI
    Local aHeader 	:= {}                                           // CABEÇALHO DE INFORMAÇÕ?ES DA REQUISIÇÃO
    Local oRest   	:= NIL                                          // CLIENTE PARA CONSUMO
    Local nHandle 	:= 00                                           // CÓDIGO DE SUPORTE AO ARQUIVO
	Local c_Caminho	:= ""

	RpcSetType(3)
	RpcSetEnv(o_EmpFil:c_Empresa,o_EmpFil:c_Filial)

	c_Caminho	:= "\dirdoc\co" + Alltrim( SM0->M0_CODIGO ) + "\shared\"
	cFilAnt := o_EmpFil:c_Filial
	
	
	For nX := 1 To Len( a_DadosBC ) Step 1

		c_Objeto	:= GetSXENum( "ACB", "ACB_CODOBJ" )

		dbSelectArea("ACB")
		RecLock("ACB",.T.)
		ACB->ACB_FILIAL	:= XFILIAL("ACB")
		ACB->ACB_CODOBJ	:= c_Objeto
		ACB->ACB_OBJETO	:= a_DadosBC[nX]:ACB_OBJETO
		ACB->ACB_DESCRI	:= a_DadosBC[nX]:ACB_DESCRI
		MsUnlock()

		dbSelectArea("AC9")
		RecLock("AC9",.T.)
		AC9->AC9_FILIAL	:= XFILIAL("AC9")
		AC9->AC9_FILENT	:= a_DadosBC[nX]:AC9_FILENT
   	 	AC9->AC9_ENTIDA	:= a_DadosBC[nX]:AC9_ENTIDA
    	AC9->AC9_CODENT	:= a_DadosBC[nX]:AC9_CODENT + "-" + a_DadosBC[nX]:ID_FLUIG
    	AC9->AC9_CODOBJ	:= c_Objeto
		//AC9->AC9_IDFSFL	:= a_DadosBC[nX]:ID_FLUIG
		MsUnlock()

		// INSTANCIA O CLIENTE REST
        oRest := FwRest():New(cURL)

		 // INFORMA O RECURSO E O BODY
        oRest:SetPath( a_DadosBC[nX]:LINK_OBJ )

		// ENVIA A REQUISIÇÃO E VALIDA O RESULTADO
        If (oRest:Get(aHeader))

            // CRIA O NOME DO ARQUIVO (FUNÇÕES UTILIZADAS PARA EVITAR CONFLITO DE NOME)
            nHandle := FCreate( c_Caminho + a_DadosBC[nX]:NOME_OBJ )
            FWrite(nHandle, oRest:GetResult())
            FClose(nHandle)

            // VERIFICA SE O ARQUIVO FOI CRIADO CORRETAMENTE
            If (!File( c_Caminho + a_DadosBC[nX]:NOME_OBJ ) )
                ConOut("@ADVPL: Couldn't generate *.PDF file")
            EndIf
        Else
            ConOut("@ADVPL: Couldn't consume API")
        EndIf

		ConfirmSX8()

	Next nX

	

	::o_RetMtd:l_Status		:= .T.
	::o_RetMtd:c_Mensagem	:= "Processo executado!!!"

Return(.T.)

#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} F150NOGRV
//TODO 
@description Ponto de Entrada para desprezar a gravação de títulos no arquivo de remessa conforme condição
@author Willian Kaneta
@since 09/10/2018
@version 1.0
@type function
/*/
user function F150NOGRV()
	
	Local lRet := .T.
	
	IF TYPE ("_cOcorre") == "C"
		//Função para verificar tipo de ocorrência para gerar arquivo de remessa
		//1-Bol.Nao Registrado 	- Ocorrencia Campo E1_XOCORR - 2
		//2-Rejeitados		 	- Ocorrencia Campo E1_XOCORR - 5
	   lRet := U_GAFIN2WK()
	Else
		//Função que inicia variável _cOcorre
		U_GAFIN1WK()
		//Função para verificar tipo de ocorrência para gerar arquivo de remessa
		//1-Bol.Nao Registrado 	- Ocorrencia Campo E1_XOCORR - 2
		//2-Rejeitados		 	- Ocorrencia Campo E1_XOCORR - 5
		IF TYPE ("_cOcorre") == "C"		
			lRet := U_GAFIN2WK()
		Else
			lRet := .F.
		EndIf
	EndIf
	
return lRet
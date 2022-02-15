#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} GAFIN2WK
//TODO
@description Função chamada no Ponto de Entrada F150NOGRV
@description para validar o tipo de ocorrência do titulo 
@description para gerar o arquivo de remessa.
@description 1-Bol.Nao Registrado - Ocorrencia Campo E1_XOCORR - 2 
@description 2-Rejeitados         - Ocorrencia Campo E1_XOCORR - 5
@author Willian Kaneta
@since 09/10/2018
@version 1.0
@type function
/*/
user function GAFIN2WK()

	Local lRet := .T.
	
	//Variavel Private _nOcorre declarada na função GAFIN1WK
	//1-Bol.Nao Registrado - Ocorrencia Campo E1_XOCORR - 2
	If _cOcorre == "1" 
		If SE1->E1_XOCORR == "2"
			lRet := .T.
		Else 
			lRet := .F.
		EndIf 
	//2-Rejeitados - Ocorrencia Campo E1_XOCORR - 5
	ElseIf _cOcorre == "2"
		If SE1->E1_XOCORR == "5"
			lRet := .T.
		Else 
			lRet := .F.
		EndIf 	
	EndIf
		
return lRet
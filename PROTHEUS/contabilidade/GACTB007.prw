#include 'protheus.ch'

/*/{Protheus.doc} GACTB007
//LP 500-001 para validar o campo valor
@author pablo.regis
@since 10/09/2018
@version 1.0
@return  numero, Valor da Contabilização
@type function
/*/

/*Matheus Vieira - 04-10-2018 LINHA 21 - Alterado para nao contabilizar os impostos pela 510*/
User Function GACTB007()
Local aArea    := GetArea()
Local cFunBkp  := FunName()
Local n_Valor  := 0


n_Valor:= IIF(SE2->E2_PREFIXO<>"RM ", IF(ISINCALLSTACK("FINA565").OR.ALLTRIM(SE2->E2_TIPO)$"CAU|PR|FT".OR.SE2->E2_XDISTR=="S".OR.SE2->E2_PREFIXO="EMP",0,IF(SE2->E2_MULTNAT<>"1" .AND. SE2->E2_PREFIXO<>"TRF".AND. EMPTY(SE2->E2_XIDWBC),SE2->E2_VALOR,0)),0)

If (ALLTRIM(SE2->E2_ORIGEM) == "MATA100" .AND. (ALLTRIM(SE2->E2_TIPO)$("NF|NFS|NSA")) .OR. ALLTRIM(SE2->E2_TITPAI) <> '') /*Matheus Vieira - Alterado para nao contabilizar os impostos pela 510*/ 
	n_Valor := 0
Endif

SetFunName(cFunBkp)
RestArea(aArea)                                                         	


Return(n_Valor)
       
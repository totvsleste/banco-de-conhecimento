#INCLUDE "RWMAKE.CH"

//############################################################################
//## Data: 		30/09/09
//## Autor: 	Tiago Rossini Coradini
//## Função: 	Ponto de entrada antes da montagem da tela de seleção dos títulos
//## 				 	para filtrar quais títulos deverão compor o borderô de pagamentos
//## Retorno: Expressão caracter (filtro)
//############################################################################

User Function F240FIL()
Local aArea  := GetArea()
Local cFiltro := ""
Local cPar01 := MV_PAR01
Local cPar02 := MV_PAR02
Local cPar03 := MV_PAR03
Local cPar04 := MV_PAR04
Local cPar05 := MV_PAR05
Local cPar06 := MV_PAR06

	Pergunte("FINA240",.T.)

	cFiltro := "E2_PREFIXO>='"+MV_PAR01+"'.AND."
	cFiltro += "E2_PREFIXO<='"+MV_PAR02+"'.AND."

	cFiltro += "E2_TIPO>='"+MV_PAR03+"'.AND."
	cFiltro += "E2_TIPO<='"+MV_PAR04+"'.AND."

	cFiltro += "E2_PORTADO>='"+MV_PAR05+"'.AND."
	cFiltro += "E2_PORTADO<='"+MV_PAR06+"'"

	//Adicionado para contemplar as regras do orcamento
	//Braulio - 27 de abril de 2017
	cFiltro += " .AND. SE2->E2_FSSTAT <> '1' "


MV_PAR01 := cPar01
MV_PAR02 := cPar02
MV_PAR03 := cPar03
MV_PAR04 := cPar04
MV_PAR05 := cPar05
MV_PAR06 := cPar06

RestArea(aArea)
Return(cFiltro)
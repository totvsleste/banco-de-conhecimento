#INCLUDE "PROTHEUS.CH"
CLASS Records

	// Declaracao das propriedades da Classe
	DATA aRecords
	// Declaracao das propriedades da Classe
	METHOD New() CONSTRUCTOR

ENDCLASS

// Criação do construtor, onde atribuimos os valores default
// para as propriedades e retornamos Self
METHOD New() CLASS Records

	::aRecords := {}

	::aRecords := {{"PRODUTO A","10","100"},;
		{"PRODUTO B","10","200"}}

Return()

#include "protheus.ch"
user function tstclassarray()

	Local oArray 	:= Records():New()
	Local nX		:= 1
	Local c_Alert	:= ""

	for nX:=1 to len( oArray:aRecords )

		c_Alert	:= "Produto : " + oArray:aRecords[nX][1] + chr(13) + chr(10) + "Quantidade: " + oArray:aRecords[nX][2] + chr(13) + chr(10) + "Total: "  + oArray:aRecords[nX][3]

		alert( c_Alert )

	next

return

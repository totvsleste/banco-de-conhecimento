#INCLUDE "TOTVS.CH"

#DEFINE ENTER CHR(13) + CHR(10)

User Function GeraLog( c_Filial, c_Pedido, c_PontoEntrada )

	Local o_Explorer 	:= clsExplorer():New()
	Local c_Arquivo		:= c_PontoEntrada + "_" + Alltrim( c_Filial ) + "_" + Alltrim( c_Pedido ) + ".log"
	Local c_ArqOrig		:= ""
	Local c_Log			:= ""
	Local c_Caminho		:= "\LOGNFSAIDA\"

	c_Log	:= "********************************************" + ENTER
	c_Log	+= "* Ponto de Entrada: " + c_PontoEntrada + " *" + ENTER
	c_Log	+= "* Data: " + DTOC( DATE() ) + " " + TIME() + " *" + ENTER
	c_Log	+= "********************************************" + ENTER

	If !File( c_Caminho + c_Arquivo )

		If !o_Explorer:mtdExistePasta( c_Caminho )
			If !o_Explorer:mtdCriaPasta( c_Caminho )
				Alert( "ERRO GeraLog: Nao foi possivel criar a pasta" )
			EndIf
		EndIf

		c_ArqOrig := o_Explorer:mtdGravaLog( c_Log, ".log" )

		o_Explorer:mtdCopyFile( c_ArqOrig, c_Caminho + c_Arquivo, .T. )

	Else

		o_Explorer:mtdEditaLog( c_Caminho + c_Arquivo, c_Log )

	Endif

Return()
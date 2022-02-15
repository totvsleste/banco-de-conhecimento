#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

User Function ROTMATA105()

	Local dEMISSAO:=DATE()
	Local cPRODUTO:= '1'
	Local nQUANT  := 6
	Local cITEM   := '01'
	Local aCabec	:= {}
	Local aItens	:= {}
	PRIVATE lMsErroAuto := .F.
	//------------------------
	//| Abertura do ambiente |
	//------------------------

	PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "EST" TABLES "SCP","SB1"

	dEMISSAO:= dDataBase

	ConOut(Repl("-",80))
	ConOut(PadC("Teste - SOLICITACAO AO ARMAZEM",80))
	ConOut("Inicio: "+Time())

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//| Teste de Inclusao                                            |
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

	aCabec := {}

	aadd(aCabec,{"CP_PRODUTO" ,cPRODUTO ,})
	aadd(aCabec,{"CP_EMISSAO" ,dEMISSAO ,})
	aItens := {}
	aAdd(aItens,{})
	aadd(aItens[len(aItens)],{"CP_PRODUTO" ,cPRODUTO,})
	aadd(aItens[len(aItens)],{"CP_QUANT"   ,nQUANT,})
	aadd(aItens[len(aItens)],{"CP_ITEM"    ,cITEM,})

	MSExecAuto({|x,y,z| MATA105(x,y,z)},aCabec,aItens,3)

	If !lMsErroAuto
		ConOut("Incluido com sucesso! ")
	Else
		ConOut("Erro na inclusao!")
	EndIf
	ConOut("Fim  : "+Time())

Return Nil
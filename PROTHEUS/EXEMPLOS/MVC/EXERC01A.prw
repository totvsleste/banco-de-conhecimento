/*/{Protheus.doc} EXERC01A
Rotina para apresentacao da Legenda da tela de Turmas

@author francisco.ssa
@since 04/03/2014
@version 1.0

@return Logico, Verdadeiro

@example
(examples)

@see (links_or_references)
/*/
User Function EXERC01A()

	Local a_Cores 		:= {}
	Private cCadastro	:= "Legenda de Turmas"

	a_Cores := {{"BR_VERDE","Turma Ativa"},;
				{"BR_AMARELO","Turma Suspensa"},;
				{"BR_VERMELHO","Turma Encerrada"}}


	BrwLegenda(cCadastro,"Legenda",a_Cores)

Return(.T.)
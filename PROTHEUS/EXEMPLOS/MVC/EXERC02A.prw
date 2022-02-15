/*/{Protheus.doc} EXERC02A
Rotina para apresentacao da Legenda da tela de Alunos

@author francisco.ssa
@since 04/03/2014
@version 1.0

@return Logico, Verdadeiro

@example
(examples)

@see (links_or_references)
/*/
User Function EXERC02A()

	Local a_Cores 		:= {}
	Private cCadastro	:= "Legenda de Turmas"

	a_Cores := {{"BR_VERDE","Aluno Ativa"},;
				{"BR_AMARELO","Aluno Trancado"}}


	BrwLegenda(cCadastro,"Legenda",a_Cores)

Return(.T.)
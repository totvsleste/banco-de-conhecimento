
//Exemplo de como chamar a tela padrao de saldos em um grid ou browse

//Cria a tecla de atalho
SetKey(VK_F5,{|| f_RetSaldo()})

//Função chamada na tecla F5
Static Function f_RetSaldo()

Local c_CodProd              := “000000001”
Local cFilBkp                      := cFilAnt 

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(XFILIAL("SB1") + c_CodProd )

Set Key VK_F5 TO
If FWModeAccess("SB1")=="E"
			   cFilAnt := SB1->B1_FILIAL
EndIf     

MaViewSB2(SB1->B1_COD)
cFilAnt := cFilBkp
Set Key VK_F5 TO f_RetSaldo()

Return()

//Ao sair da rotina, desativa a tecla de atalho
SetKey(VK_F5,{||})
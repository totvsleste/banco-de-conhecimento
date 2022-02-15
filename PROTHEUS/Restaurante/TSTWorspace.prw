#include "totvs.ch"

USER FUNCTION TSTWorkSpace()

DEFINE DIALOG oDlg TITLE "Exemplo TWorkSpace" FROM 180,180 TO 550,700 PIXEL
oWSpaceFolder := TWorkspaceFolder():New(oDlg,0,0,260,184)

oWSpace1 := TWorkSpace():New( " Totvs 10-Aba 01 ", oWSpaceFolder)
oWSpace1:SetStatusBarText("Texto da barra de status 01")

oWSpace2 := TWorkSpace():New( " Totvs 10-Aba 02 ", oWSpaceFolder )
oWSpace2:SetStatusBarText("Texto da barra de status 02")

ACTIVATE DIALOG oDlg CENTERED ON INIT LoadForm()

RETURN


STATIC FUNCTION LoadForm()

oDlg1 := TDialog():New(0,0,200,200,"Window1",,,,,,,,oWSpace2,.T.)
oDlg1:Activate(,,,.T.,{||.T.},,{||} )

oDlg2 := TDialog():New(0,0,200,200,"Window2",,,,,,,,oWSpace2,.T.)
oDlg2:Activate(,,,.T.,{||.T.},,{||} )

RETURN
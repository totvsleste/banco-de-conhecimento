#INCLUDE "PROTHEUS.CH"
#DEFINE ID         1 // Id do Celula
#DEFINE OBJETO     2 // Objeto de Tela
#DEFINE DATADIA    3 // Data Completa da Celula
#DEFINE DIA        4 // Dia Ref. Data da Celula
#DEFINE MES        5 // Mes Ref. Data da Celula
#DEFINE ANO        6 // Ano Ref. Data da Celula
#DEFINE NSEMANO    7 // Semana do Ano Ref. Data da Celula
#DEFINE NSEMMES    8 // Semana do Mes Ref. Data da Celula
#DEFINE ATIVO      9 // É celula referente a um dia ativo
#DEFINE FOOTER    10 // É celula referente ao rodape
#DEFINE HEADER    11 // É celula referente ao Header
#DEFINE SEMANA    12 // É celula referente a semana
#DEFINE BGDefault 13 // Cod de BackGround da Celula

User Function TestCalend()

Local oDlg
Local cMes    
Local cAno    
Local cMesAno 
Local oCalend
Local nI
Local aList
Local aItems := {'item1','item2','item3'}
Local cRet := ''

Private dDatabase
cMes    := StrZero( Month( Date() ) , 2 )
cAno    := StrZero( Year( Date() )  , 4 )
cMesAno := AllTrim( cMes ) + '/' + AllTrim( cAno )
dDatabase := Date()

Define MsDialog oDlg Title 'Calendário ' + StrTran( cMesAno, '/', ' / ' )  From 0, 0 To 768,1024 Pixel

oTela := FWFormContainer():New( oDlg )
cIdCalen  := oTela:createHorizontalBox( 92 )
cIdRodape := oTela:createHorizontalBox(  8 )
cIcoCalen := oTela:createVerticalBox(  5, cIdRodape )
cIcoBotoes:= oTela:createVerticalBox( 95, cIdRodape )
oTela:Activate( oDlg, .F. )

oTelaCaled := oTela:GetPanel( cIdCalen   )
oTelaIcoCa := oTela:GetPanel( cIcoCalen  )
oTelaIcoBt := oTela:GetPanel( cIcoBotoes )

oCalend := FWCalendar():New( VAL(cMes), VAL(cAno) )
oCalend:blDblClick  := { | aInfo | DuploClick( oDlg, oTelaCaled, oCalend, aInfo ) }
oCalend:bRClicked   := { | aInfo, oObj, nRow, nCol | Direita(  'Botao da Direita ['  + aInfo[1] + ']', oObj, nRow, nCol    ) }
oCalend:aNomeCol    := { 'Domingo', 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Semana' }
oCalend:lWeekColumn := .F. // Exibe ou nao a coluna de semana
oCalend:lFooterLine := .F. // Exibe ou nao o rodape
oCalend:Activate( oTelaCaled )//Atribuindo conteúdo as datas

aList = Array(Len( oCalend:aCell ))
For nI := 1 To Len( oCalend:aCell )	
	If oCalend:aCell[nI][ATIVO]		
		oCalend:SetInfo( oCalend:aCell[nI][ID], aItems )	
	ElseIf oCalend:aCell[nI][SEMANA]	
	ElseIf oCalend:aCell[nI][FOOTER]		
		oCalend:SetInfo( oCalend:aCell[nI][ID], 'Rodapé' )	
	EndIf
Next

@ 0, 0 BTNBMP oButCal Resource "BTCALEND" Size 24, 24 Of oTelaIcoCa Pixel

oButCal:cToolTip := "Alterar calendário..."
oButCal:bAction := { || dDiaSel := TrocaCalend( oDlg, CTod( '01/' + oCalend:cRef ) ) , oCalend:SetCalendar( oTelaCaled, Month( dDiaSel ) , Year( dDiaSel ) ) , oDlg:cTitle := 'Calendário ' + oCalend:cRef, JogaTexto( oCalend ) }
oButCal:Align := CONTROL_ALIGN_ALLCLIENToCalend:SetInfo( oCalend:IdDay( 20 ), '<td>10</td><td>30</td><td>20</td>', .T.)
oCalend:SetInfo( oCalend:IdDay( 21 ), '<td><tr><td>10</td><td>30</td><td>20</td></tr><tr><td>30</td><td>30</td><td>30</td></tr></td>', .T.)
oCalend:SetInfo( oCalend:IdDay( 22 ), '<td>10</td><td>30</td><td>20</td>', .T.)@ oTelaIcoBt:nTop+05, oTelaIcoBt:nLeft+015 Button oBtn Prompt '01/2011' Size 25, 10 Of oTelaIcoBt Pixel Action ( oCalend:SetCalendar( oTelaCaled, '01', '2011' ) , oDlg:cTitle := 'Calendário ' + oCalend:cRef )@ oTelaIcoBt:nTop+05, oTelaIcoBt:nLeft+040 Button oBtn Prompt '02/2011' Size 25, 10 Of oTelaIcoBt Pixel Action ( oCalend:SetCalendar( oTelaCaled, '02', '2011' ) , oDlg:cTitle := 'Calendário ' + oCalend:cRef )@ oTelaIcoBt:nTop+05, oTelaIcoBt:nLeft+065 Button oBtn Prompt '03/2011' Size 25, 10 Of oTelaIcoBt Pixel Action ( oCalend:SetCalendar( oTelaCaled, '03', '2011' ) , oDlg:cTitle := 'Calendário ' + oCalend:cRef )@ oTelaIcoBt:nTop+05, oTelaIcoBt:nLeft+090 Button oBtn Prompt '04/2011' Size 25, 10 Of oTelaIcoBt Pixel Action ( oCalend:SetCalendar( oTelaCaled, '04', '2011' ) , oDlg:cTitle := 'Calendário ' + oCalend:cRef )@ oTelaIcoBt:nTop+05, oTelaIcoBt:nLeft+115 Button oBtn Prompt '05/2011' Size 25, 10 Of oTelaIcoBt Pixel Action ( oCalend:SetCalendar( oTelaCaled, '05', '2011' ) , oDlg:cTitle := 'Calendário ' + oCalend:cRef )@ oTelaIcoBt:nTop+05, oTelaIcoBt:nLeft+140 Button oBtn Prompt '06/2011' Size 25, 10 Of oTelaIcoBt Pixel Action ( oCalend:SetCalendar( oTelaCaled, '06', '2011' ) , oDlg:cTitle := 'Calendário ' + oCalend:cRef )@ oTelaIcoBt:nTop+15, oTelaIcoBt:nLeft+015 Button oBtn Prompt '07/2011' Size 25, 10 Of oTelaIcoBt Pixel Action ( oCalend:SetCalendar( oTelaCaled, '07', '2011' ) , oDlg:cTitle := 'Calendário ' + oCalend:cRef )@ oTelaIcoBt:nTop+15, oTelaIcoBt:nLeft+040 Button oBtn Prompt '08/2011' Size 25, 10 Of oTelaIcoBt Pixel Action ( oCalend:SetCalendar( oTelaCaled, '08', '2011' ) , oDlg:cTitle := 'Calendário ' + oCalend:cRef )@ oTelaIcoBt:nTop+15, oTelaIcoBt:nLeft+065 Button oBtn Prompt '09/2011' Size 25, 10 Of oTelaIcoBt Pixel Action ( oCalend:SetCalendar( oTelaCaled, '09', '2011' ) , oDlg:cTitle := 'Calendário ' + oCalend:cRef )@ oTelaIcoBt:nTop+15, oTelaIcoBt:nLeft+090 Button oBtn Prompt '10/2011' Size 25, 10 Of oTelaIcoBt Pixel Action ( oCalend:SetCalendar( oTelaCaled, '10', '2011' ) , oDlg:cTitle := 'Calendário ' + oCalend:cRef )@ oTelaIcoBt:nTop+15, oTelaIcoBt:nLeft+115 Button oBtn Prompt '11/2011' Size 25, 10 Of oTelaIcoBt Pixel Action ( oCalend:SetCalendar( oTelaCaled, '11', '2011' ) , oDlg:cTitle := 'Calendário ' + oCalend:cRef )@ oTelaIcoBt:nTop+15, oTelaIcoBt:nLeft+140 Button oBtn Prompt '12/2011' Size 25, 10 Of oTelaIcoBt Pixel Action ( oCalend:SetCalendar( oTelaCaled, '12', '2011' ) , oDlg:cTitle := 'Calendário ' + oCalend:cRef )oDlg:lMaximized := .T.Activate MsDialog oDlg CenteredReturn NIL

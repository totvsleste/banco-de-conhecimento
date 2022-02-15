#include 'PARMTYPE.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*/{Protheus.doc} GAFIN1WK
//TODO 
@description Tela para escolher ocorrencia para gerar Arquivo de Remessa CNAB de Cobrança
@description Função Executada no Ponto de entrada F150NOGRV.
@author Willian Kaneta
@since 09/10/2018
@version 1.0
@type function
/*/
user function GAFIN1WK()
	
	//Altera parametro da ocorrencia
	RETOCORRE()

Return

/*/{Protheus.doc} AjustaSX1
//TODO Função para informar o tipo de ocorrencia para gerar o arquivo de remessa cnab de cobrança
@author Willian Kaneta
@since 09/10/2018
@version 1.0
@param cPerg, characters, descricao
@type function
/*/
Static Function RETOCORRE()
	
	Local aItems	:= {"1=Bol.Nao Registrado","2=Rejeitados"}
	
	Private  oDlg1	   := Nil
	Private  oSay1     := Nil
	Private  oSay2     := Nil
	Private  oSay3     := Nil
	Private  oCBox1    := Nil
	Private  oBtn1     := Nil
	Private  oBtn2     := Nil	
	Private  cOcorre   := aItems[1]	
	
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	oDlg1      := MSDialog():New( 090,226,362,525,"Tipo Ocorrência",,,.F.,,,,,,.T.,,,.T. )
	oSay1      := TSay():New( 020,020,{||"Informe o tipo de ocorrência para gerar"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,104,008)
	oSay2      := TSay():New( 032,020,{||"o arquivo de remessa:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
	oSay3      := TSay():New( 072,012,{||"Ocorrência ?"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oCBox1     := TComboBox():New( 068,060,{|u|if(PCount()>0,cOcorre:=u,cOcorre)},aItems,072,010,oDlg1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	oBtn1      := TButton():New( 104,016,"Cancelar",oDlg1,{ || oDlg1:End() },037,012,,,,.T.,,,,,, )
	oBtn2      := TButton():New( 104,094,"OK"      ,oDlg1,{ || oDlg1:End() },037,012,,,,.T.,,,,,, ) 
	
	oDlg1:Activate(,,,.T.)
	
	_SetNamedPrvt( "_cOcorre" , cOcorre , "fA150Ger" )
	
Return
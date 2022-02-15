#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณnil010    บ Autor ณ 			         บ Data ณ  20/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo P10 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Excel de agendas                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function NIL010()
Local lRet	   := .T.
Local cDesc1   := "Esta rotina gera um arquivo em excel contendo as agendas"
Local cDesc2   := " "
Local cDesc3   := " "
Local cDesc3   := " "
Local aSay     := {}
Local aButton  := {}
Local nOpc     := 0
Local _cRegiao := "  "
Local cTitulo := "Agendas Marcadas e sem Aloca็ใo"
Private cPerg    := "NIL010"
Private cPathLoc := ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica as perguntas selecionadas                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Pergunte(cPerg,.F.)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ   * * * * * * * * * *  MONTAGEM DA TELA  * * * * * * * * * * * *    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

@ 200,1 TO 380,380 DIALOG oDlg TITLE OemToAnsi("Gerao de Arquivo Excel")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ir  gerar um arquivo excel
@ 20,018 Say " no diretorio C:\AGENDA conforme os"
@ 30,018 Say " parametros definidos pelo usuario, no formato xls. "

@ 60,90  BMPBUTTON TYPE 1 ACTION SelReg()
@ 60,120 BMPBUTTON TYPE 2 ACTION Close(oDlg)
@ 60,150 BMPBUTTON TYPE 5 ACTION Pergunte(cPerg,.T.)

Activate Dialog oDlg Centered

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSelReg    บAutor  ณ                    บ Data ณ  20/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Seleciona Registros                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ						                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SelReg()

Local cSql, ctrabalho
Private adia := {}
Pergunte(cPerg,.f.)

csql := "SELECT ZSP_TECNIC,ZSP_DATA,ZSP_CLIENT,A9_NOME,A1_NOME,ZSP_OBSERV,ZSP_PRJCFP"
csql +=" FROM " + RetSqlName("ZSP")+" ZSP,"+RetSqlName("SA9")+" SA9,"+RetSqlName("SA1")+" SA1 "
csql +=" WHERE ZSP.D_E_L_E_T_ <> '*'"
csql +=" AND SA9.D_E_L_E_T_ <> '*'"
csql +=" AND SA1.D_E_L_E_T_ <> '*'"
csql +=" AND SA9.A9_TECNICO = ZSP.ZSP_TECNIC "
csql +=" AND SA1.A1_COD = ZSP.ZSP_CLIENT "
csql +=" AND ZSP_FILIAL = '"+xFilial("ZSP")+"'"
csql +=" AND ZSP_DATA BETWEEN '"+DtoS(mv_par01)+"' And '"+DtoS(mv_par02)+"'"
csql +=" AND SA1.A1_COD BETWEEN '"+mv_par05+"' And '"+mv_par07+"'"
If Alltrim(cempant) == "03"
	If mv_par09 == 1
		csql += " AND SA1.A1_EST = 'RJ'"
	EndIf
EndIf
csql +=" ORDER BY ZSP_TECNIC"
TCQUERY cSql NEW ALIAS "ctrabalho"
DbSelectArea("ctrabalho")

_aStru:={}
aadd( _aStru , {"_TECNICO"   , "C" , 06 , 00 } )
aadd( _aStru , {"_NOMET"     , "C" , 40 , 00 } )
aadd( _aStru , {"_CLIENTE"   , "C" , 06 , 00 } )
aadd( _aStru , {"_NOMEC"     , "C" , 40 , 00 } )
aadd( _aStru , {"_CFP"       , "C" , 14 , 00 } )
aadd( _aStru , {"_DCFP"      , "C" , 50 , 00 } )
aadd( _aStru , {"_DATA"      , "D" , 08 , 00 } )
aadd( _aStru , {"_OBS"       , "C" , 40 , 00 } )
//	_cTemp := CriaTrab(_aStru, .T.)
_ctemp :="SC"+SubStr( time(), 1, 2 )+SubStr( time(), 4, 2 )+SubStr( time(), 7, 2 )
DBCREATE(_ctemp, _aStru, "DBFCDXADS" )
DbUseArea(.T.,"DBFCDXADS",_cTemp,"TRB",.F.,.F.)
dbCreateInd(_cTemp,"_TECNICO",{||_TECNICO})

DbSelectArea("ctrabalho")
DbGotop()
Do While .not. eof()
	ZCT->(DbSetOrder(1))
	ZCT->(DbSeek(xFilial("ZCT")+ctrabalho->ZSP_CLIENT+ctrabalho->ZSP_PRJCFP))
	DbSelectArea("TRB")
	Reclock("TRB",.T.)
	TRB->_TECNICO   := ctrabalho->ZSP_TECNIC
	TRB->_NOMET     := ctrabalho->A9_NOME
	TRB->_CLIENTE   := ctrabalho->ZSP_CLIENT
	TRB->_NOMEC     := ctrabalho->A1_NOME
	TRB->_DATA      := Stod(ctrabalho->ZSP_DATA)
	TRB->_OBS       := ctrabalho->ZSP_OBSERV
	TRB->_CFP       := ctrabalho->ZSP_PRJCFP
	TRB->_DCFP      := ZCT->ZCT_DESPRO
	MsUnlock()
	DbSelectarea("ctrabalho")
	DbSkip()
Enddo
DbSelectArea("TRB")

Private adia := {}
dta_tmp := mv_par01
For x := 0 to (mv_par02 - mv_par01)
	Aadd(adia,dta_tmp)
	dta_tmp++
Next

cPathLoc := "C:\AGENDA\"
If LJDIRECT("C:\AGENDA\",.T.) == .F.
	Alert("Nใo foi possํvel criar o diret๓rio "+cpatchloc)
	TRB->(DbCloseArea())
	ctrabalho->(DbCloseArea())
	Return
EndIf
Processa({|| ProcInt()}, "Gerando integracao...")
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcInt   บAutor  ณCecilia             บ Data ณ  02/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para gerar um arquivo com extensใo .xls com os      บฑฑ
ฑฑบ          ณ dados filtrados.                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ProcInt()
Local _aArea    := GetArea()
Local cPath     := cPathLoc
Local nHandle   := 0
Local cArqPesq 	:= cPath + "agenda_"+cempant+".xls"
Local cCabHtml  := ""
Local cLinFile  := ""
Local cFileCont := ""
Local nPedTotal
Local nQTDETot
Local nQTDSTot
Local nSaldTot
Private nCt      := 0
//Private cPathLoc := ""

ProcRegua( nCt )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria um arquivo do tipo *.xls	                                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nHandle := FCREATE(cArqPesq, 0)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se o arquivo pode ser criado, caso contrario um alerta sera exibido      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If FERROR() != 0
	Alert("Nใo foi possํvel abrir ou criar o arquivo: " + cArqPesq )
	Close(odlg)
	Return
EndIf
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤิ
//ณCriar ARRAY com analistas                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤิ
aanalis:={}
DbSelectArea("SA9")
DbSetOrder(2)
DbGotop()
Do while !eof()
	If A9_ATIVO == "S" .and. (Alltrim(A9_TIPO) == "AE" .or. Alltrim(A9_TIPO) == "AN" )
		If A9_TECNICO >= mv_par03 .and. A9_TECNICO <= mv_par04
			If !Empty(mv_par07) //Avaliar se o cliente inicial diferente de branco, para trazer apenas os tecnicos agendados
				If TRB->(DbSeek(SA9->A9_TECNICO))
					Aadd(aanalis,A9_TECNICO)
				EndIf
			EndIf
		EndIf
	EndIf
	DbSkip()
EndDo
DbSelectArea("TRB")
dbCreateInd(_cTemp,"Dtos(_DATA)+_TECNICO",{||Dtos(_DATA)+_TECNICO})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤิ
//ณmonta cabe็alho de pagina HTML para posterior utiliza็ใoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤิ
cCabHtml := "<!-- Created with AEdiX by Kirys Tech 2000,http://www.kt2k.com --> "
cCabHtml += "<!DOCTYPE html PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>"
cCabHtml += "<html>"
cCabHtml += "<head>"
cCabHtml += "  <title></title>"
cCabHtml += "  <meta name='GENERATOR' content='AEdiX by Kirys Tech 2000,http://www.kt2k.com'>"
cCabHtml += "</head>"
cCabHtml += "<body bgcolor='#FFFFFF'>"
cCabHtml += ""


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤHง
//ณMonta Rodape Html para posterior utiliza็aoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤHง

cRodHtml := "</body>"
cRodHtml += "</html>"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAqui come็a a montagem da pagina html propriamente ditaณ
//ณ	 acrescenta o cabe็alho                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cFileCont := cCabHtml

cLinFile := "<Table style='background: #FFFFFF; width: 100%;' border='1' cellpadding='2' cellspacing='2'>"

//Primeira linha da tabela
cLinFile += "<TR>"
cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold; '><p align=center><b> Nome </b></TD>"
cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold; '><p align=center><b>    Produto Atua็ใo    </b></TD>"
If mv_par10 == 1
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold; width: 1500px;'><p align=center><b> M๓dulos Atua็ใo </b></TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'><p align=center><b> Qte de Agendas </b></TD>"
EndIf

For x:=1 to Len(adia)
	If Alltrim(FG_cdow(adia[x]))=="Sabado" .or. Alltrim(FG_cdow(adia[x]))=="Domingo"
		cLinFile += "<TD style='Background: #8DB4E3; font-style: Bold; ' ><p align=center><b>"+Dtoc(adia[x])+" - "+FG_cdow(adia[x])+" </b></TD>"
	Elseif ZU6->(DbSeek(xFilial("ZU6")+DtoS(adia[x]) ))
		cLinFile += "<TD style='Background: #8DB4E3; font-style: Bold; ' ><p align=center><b>"+Dtoc(adia[x])+" - "+FG_cdow(adia[x])+" </b></TD>"
	Else
		cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold; ' ><p align=center><b>"+Dtoc(adia[x])+" - "+FG_cdow(adia[x])+" </b></TD>"
	EndIf
Next
cLinFile += "</TR>"

// anexa a linha montada ao corpo da tabela
cFileCont += cLinFile
cLinFile := ""
(FWRITE(nHandle, cFileCont) )
cLinFile := ""

DbSelectArea("TRB")
For x:=1 to len(aanalis)
	IncProc()
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xfilial("SA1")+TRB->_CLIENTE))
	SA9->(DbSetOrder(1))
	SA9->(DbSeek(xfilial("SA9")+aanalis[x]))
	cLinFile := "<TR><TD>"+Left(SA9->A9_NOME,30)+"</TD>"
	cLinFile += "<TD style='Background: #FFFFC0; font-style: normal; color: blue;'>"+fprod()
	If mv_par10 == 1
		cLinFile += "<TD style='Background: #FFFFC0; font-style: normal; color: blue; width: 1500px;'>"+fmod()
		cLinFile += "<TD style='Background: #FFFFFF; font-style: normal; '><p align=center><b>=CONT.VALORES(E"+Strzero(x+1,2)+":ZZ"+StrZero(x+1,2)+")</b></TD>"
	EndIf
	For y:=1 to Len(adia)
		If DbSeek(Dtos(adia[y])+aanalis[x])
			SA1->(DbSetOrder(1))
			SA1->(DbSeek(xfilial("SA1")+TRB->_CLIENTE))
			If Alltrim(FG_cdow(adia[y]))=="Sabado" .or. Alltrim(FG_cdow(adia[y]))=="Domingo"
				If Alltrim(TRB->_OBS) == "AC"
					cLinFile += "<TD style='Background: #8DB4E3; font-style: normal; color: red;'>"+Iif(mv_par10 == 2,Iif(mv_par11==1,Left(TRB->_NOMEC,30),Left(TRB->_DCFP,50))," ")
				Else
					If Alltrim(SA1->A1_EST)=="RJ"
						If Alltrim(TRB->_OBS) == "RT"
							cLinFile += "<TD style='Background: #8BEC8B; font-style: normal; color: blue;'>"+Iif(mv_par10 == 2,Iif(mv_par11==1,Left(TRB->_NOMEC,30),Left(TRB->_DCFP,50))," ")
						ElseIf Alltrim(TRB->_OBS) == "PA"
							cLinFile += "<TD style='Background: #8BEC8B; font-style: normal; color: #FF5412;'>"+Iif(mv_par10 == 2,Iif(mv_par11==1,Left(TRB->_NOMEC,30),Left(TRB->_DCFP,50)), " ")
						Else
							cLinFile += "<TD style='Background: #8BEC8B; font-style: normal;'>"+Iif(mv_par10 == 2,Iif(mv_par11==1,Left(TRB->_NOMEC,30),Left(TRB->_DCFP,50))," ")
						EndIf
					Else
						If Alltrim(TRB->_OBS) == "RT"
							cLinFile += "<TD style='Background: #8DB4E3; font-style: normal;color: blue;'>"+Iif(mv_par10 == 2,Iif(mv_par11==1,Left(TRB->_NOMEC,30),Left(TRB->_DCFP,50))," ")
						ElseIf Alltrim(TRB->_OBS) == "PA"
							cLinFile += "<TD style='Background: #8DB4E3; font-style: normal;color: #FF5412;'>"+Iif(mv_par10 == 2,Iif(mv_par11==1,Left(TRB->_NOMEC,30),Left(TRB->_DCFP,50))," ")
						Else
							cLinFile += "<TD style='Background: #8DB4E3; font-style: normal;'>"+Iif(mv_par10 == 2,Iif(mv_par11==1,Left(TRB->_NOMEC,30),Left(TRB->_DCFP,50))," ")
						EndIf
					EndIf
				EndIf
			Elseif ZU6->(DbSeek(xFilial("ZU6")+DtoS(adia[y]) ))
				If Alltrim(TRB->_OBS) == "AC"
					cLinFile += "<TD style='Background: #8DB4E3; font-style: normal; color: red;'>"+Iif(mv_par10 == 2,Iif(mv_par11==1,Left(TRB->_NOMEC,30),Left(TRB->_DCFP,50))," ")
				Else
					If Alltrim(SA1->A1_EST)=="RJ"
						If Alltrim(TRB->_OBS) == "RT"
							cLinFile += "<TD style='Background: #8BEC8B; font-style: normal; color: blue;'>"+Iif(mv_par10 == 2,Iif(mv_par11==1,Left(TRB->_NOMEC,30),Left(TRB->_DCFP,50))," ")
						ElseIf Alltrim(TRB->_OBS) == "PA"
							cLinFile += "<TD style='Background: #8BEC8B; font-style: normal; color: #FF5412;'>"+Iif(mv_par10 == 2,Iif(mv_par11==1,Left(TRB->_NOMEC,30),Left(TRB->_DCFP,50))," ")
						Else
							cLinFile += "<TD style='Background: #8BEC8B; font-style: normal;'>"+Iif(mv_par10 == 2,Iif(mv_par11==1,Left(TRB->_NOMEC,30),Left(TRB->_DCFP,50))," ")
						EndIf
					Else
						If Alltrim(TRB->_OBS) == "RT"
							cLinFile += "<TD style='Background: #8DB4E3; font-style: normal; color: blue;'>"+Iif(mv_par10 == 2,Iif(mv_par11==1,Left(TRB->_NOMEC,30),Left(TRB->_DCFP,50))," ")
						ElseIf Alltrim(TRB->_OBS) == "RT"
							cLinFile += "<TD style='Background: #8DB4E3; font-style: normal; color: #FF5412;'>"+Iif(mv_par10 == 2,Iif(mv_par11==1,Left(TRB->_NOMEC,30),Left(TRB->_DCFP,50))," ")
						Else
							cLinFile += "<TD style='Background: #8DB4E3; font-style: normal;'>"+Iif(mv_par10 == 2,Iif(mv_par11==1,Left(TRB->_NOMEC,30),Left(TRB->_DCFP,50))," ")
						EndIf
					EndIf
				EndIf
			Else
				If Alltrim(TRB->_OBS) == "AC"
					cLinFile += "<TD style='color: red; '>"+Iif(mv_par10 == 2,Iif(mv_par11==1,Left(TRB->_NOMEC,30),Left(TRB->_DCFP,50))," ")
				Else
					If Alltrim(SA1->A1_EST)=="RJ"
						If Alltrim(TRB->_OBS) == "RT"
							cLinFile += "<TD style='Background: #8BEC8B; font-style: normal; color: blue;'>"+Iif(mv_par10 == 2,Iif(mv_par11==1,Left(TRB->_NOMEC,30),Left(TRB->_DCFP,50))," ")
						ElseIf Alltrim(TRB->_OBS) == "PA"
							cLinFile += "<TD style='Background: #8BEC8B; font-style: normal; color: #FF5412;'>"+Iif(mv_par10 == 2,Iif(mv_par11==1,Left(TRB->_NOMEC,30),Left(TRB->_DCFP,50))," ")
						Else
							cLinFile += "<TD style='Background: #8BEC8B; font-style: normal;'>"+Iif(mv_par10 == 2,Iif(mv_par11==1,Left(TRB->_NOMEC,30),Left(TRB->_DCFP,50))," ")
						EndIf
					Else
						If Alltrim(TRB->_OBS) == "RT"
							cLinFile +=  "<TD style='color: blue; '>"+Iif(mv_par10 == 2,Iif(mv_par11==1,Left(TRB->_NOMEC,30),Left(TRB->_DCFP,50))," ")
						ElseIf Alltrim(TRB->_OBS) == "PA"
							cLinFile +=  "<TD style='color: #FF5412; '>"+Iif(mv_par10 == 2,Iif(mv_par11==1,Left(TRB->_NOMEC,30),Left(TRB->_DCFP,50))," ")
						Else
							cLinFile += "<TD> "+Iif(mv_par10 == 2,Iif(mv_par11==1,Left(TRB->_NOMEC,30),Left(TRB->_DCFP,50))," ")
						EndIf
					EndIf
				EndIf
			EndIf
			DbSelectArea("TRB")
			DbSetOrder(1)
			DbSkip()
			If TRB->_DATA == adia[y] .and. TRB->_TECNICO == aanalis[x]
				cLinFile += " / "+Iif(mv_par10 == 2,Iif(mv_par11==1,Left(TRB->_NOMEC,30),Left(TRB->_DCFP,50))," ")
			Endif
			cLinFile += "</TD>"
			
		Else
			If Alltrim(FG_cdow(adia[y]))=="Sabado" .or. Alltrim(FG_cdow(adia[y]))=="Domingo"
				cLinFile += "<TD style='Background: #8DB4E3; font-style: normal;'><b> "+space(30)+" </b></TD>"
			Elseif ZU6->(DbSeek(xFilial("ZU6")+DtoS(adia[y]) ))
				cLinFile += "<TD style='Background: #8DB4E3; font-style: normal;'>"+"FERIADO"
			Else
				cLinFile += "<TD style='Background: #FF0000; font-style: normal;'><b> "+Iif(mv_par10 == 2,space(30),"AGENDA LIVRE")+" </b></TD>"
			EndIf
		EndIf
	Next y
	cLinFile += "</TR>"
	(FWRITE(nHandle, cLinFile))
	CLinFile := ""
Next x
If mv_par10 = 2
	For y:= 1 to 11
		CLinFile := ""
		cLinFile += "</TR>"
		If y == 1
			cLinFile += "<TD style='Background: #262626; font-style: normal; color: white; text-align: center;'>Legenda"
		ElseIf y == 2
			cLinFile += "<TD style='Background: white; font-style: normal; color: black; text-align: left;'>AGENDA PRESENCIAL"
		ElseIf y == 3
			cLinFile += "<TD style='Background: white; font-style: normal; color: blue; text-align: left;'>AGENDA REMOTO"
		ElseIf y == 4
			cLinFile += "<TD style='Background: white; font-style: normal; color: #FF5412; text-align: left;'>PRษ AGENDA (A SER CONFIRMADA)"
		ElseIf y == 5
			cLinFile += "<TD style='Background: white; font-style: normal; color: RED; text-align: left;'>ANALISTA ACOMPANHANDO"
		ElseIf y == 6
			cLinFile += "<TD style='Background: #8BEC8B; font-style: normal; color: BLACK; text-align: left;'>AGENDA PRESENCIAL NORTE FLUMINENSE"
		ElseIf y == 7
			cLinFile += "<TD style='Background: #8BEC8B; font-style: normal; color: BLUE; text-align: left;'>AGENDA REMOTA NORTE FLUMINENSE"
		ElseIf y == 8
			cLinFile += "<TD style='Background: #8BEC8B; font-style: normal; color: #FF5412; text-align: left;'>PRษ AGENDA NORTE FLUMINENSE (A SER CONFIRMADO)"
		ElseIf y == 9
			cLinFile += "<TD style='Background: #8BEC8B; font-style: normal; color: RED; text-align: left;'>ANALISTA ACOMPANHANDO NORTE FLUMINENSE"
		ElseIf y == 10
			cLinFile += "<TD style='Background: RED; font-style: normal; color: BLACK; text-align: left;'>AGENDA LIVRE"
		ElseIf y == 11
			cLinFile += "<TD style='Background: #8DB4E3; font-style: normal; color: BLACK; text-align: left;'>FINAL DE SEMANA E FERIADO"
		EndIf
		(FWRITE(nHandle, cLinFile))
	Next
EndIf


cLinFile := "</Table>"

//Acrescenta o rodap้ html
(FWRITE(nHandle, cRodHtml))

// fecha a tabela aberta no inicio do arquivo

TRB->(DbCloseArea())
ctrabalho->(DbCloseArea())

fCLose(nHandle)
//ApmsgAlert("Abra o arquivo " + cArqPesq + " atrav้s do Excel!")
ShellExecute("open",cArqPesq,"","",1)
RestArea( _aArea )
Close(oDlg)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNIL010    บAutor  ณMicrosiga           บ Data ณ  12/18/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Avalia produtos que atua                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fprod()
Local aArea := GetArea()
Local aProd := {}
Local cret := ""
Local ncont
DbSelectArea("Y70")
DbSetOrder(1)
DbSeek(xFilial("Y70")+aanalis[x])
Do while !eof() .and. Y70_FILIAL ==xFilial("Y70") .and. Y70->Y70_TECNIC == aanalis[x]
	If Ascan(aProd,Y70->Y70_PRODUT) == 0
		Aadd(aProd,Y70->Y70_PRODUT)
	EndIf
	DbSkip()
EndDo
For ncont:=1 to len(aProd)
	If aProd[ncont]="01"
		cret+="01-Microsiga/"
	ElseIf aProd[ncont]="02"
		cret+="02-Logix/"
	ElseIf aProd[ncont]="03"
		cret+="03-RM/"
	ElseIf aProd[ncont]="04"
		cret+="04-Datasul/"
	ElseIf aProd[ncont]="40"
		cret+="40-RMS/"
	ElseIf aProd[ncont]="50"
		cret+="50-V.Age/"
	ElseIf aProd[ncont]="60"
		cret+="60-PC/"
	EndIf
Next
If Len(aProd)==0
	cret+="Mapa nใo encontrado!"
EndIf
RestArea(Aarea)
Return(cRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNIL010    บAutor  ณMicrosiga           บ Data ณ  12/18/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Avalia produtos que atua                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fmod()
Local aArea := GetArea()
Local cret := ""
Local aProd := {}
Local ncont
DbSelectArea("Y70")
DbSetOrder(1)
DbSeek(xFilial("Y70")+aanalis[x])
Do while !eof() .and. Y70_FILIAL ==xFilial("Y70") .and. Y70->Y70_TECNIC == aanalis[x]
	If Alltrim(Y70->Y70_STATUS) $ "3,4,5,6"
		If Ascan(aProd,Alltrim(Y70->Y70_DESMOD)) == 0
			Aadd(aProd,Alltrim(Y70->Y70_DESMOD))
		EndIf
	EndIf
	DbSkip()
EndDo
For ncont:=1 to len(aProd)
	cret+=Alltrim(aProd[ncont])+","
Next
If Len(aProd)==0
	cret:="Mapa nใo encontrado!"
EndIf
RestArea(Aarea)
Return(cRet) 

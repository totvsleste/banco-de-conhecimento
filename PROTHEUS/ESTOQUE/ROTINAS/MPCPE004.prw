#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#INCLUDE 'MATA261.CH'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPCPE004  บ Autor ณ ANTONIO NETO       บ Data ณ  12/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao principal. Explode o aCols com os produtos a serem  บฑฑ
ฑฑบ          ณdistribuidos entre as unidades baseado no Empenho da OP.	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObservacaoณ O tamanho do aCols varia conforme versao do Protheus.      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAEST :: ESPECIFICO MFX			                      บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A T U A L I Z A C O E S                           บฑฑ
ฑฑฬออออออออออหอออออออออออออออออออหออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      บANALISTA           บALTERACOES                              บฑฑ
ฑฑบ          บ                   บ                                        บฑฑ
ฑฑศออออออออออสอออออออออออออออออออสออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function MPCPE004()
Private n_Usado		:= Len(aHeader)	//Quantidade de campos
Private n_NewTam	:= 0			//Refaz o tamanho do array (acols)
Private n_PosCODOri	:= aScan(aHeader,{|x| AllTrim(x[1]+x[2])==STR0006+'D3_COD'})	  	//Codigo do Produto Origem
Private n_PosDOri	:= aScan(aHeader,{|x| AllTrim(x[1]+x[2])==STR0007+'D3_DESCRI'}) 	//Descricao do Produto Origem
Private n_PosUMOri	:= aScan(aHeader,{|x| AllTrim(x[1]+x[2])==STR0008+'D3_UM'})  	 	//Unidade de Medida Origem
Private n_PosLOCOri := aScan(aHeader,{|x| AllTrim(x[1]+x[2])==STR0009+'D3_LOCAL'})	//Armazem Origem
Private n_PosLcZOri := aScan(aHeader,{|x| AllTrim(x[1]+x[2])==STR0010+'D3_LOCALIZ'})	//Localizacao Origem
Private n_PosCODDes := aScan(aHeader,{|x| AllTrim(x[1]+x[2])==STR0011+'D3_COD'})		//Codigo do Produto Destino
Private n_PosDDes	:= aScan(aHeader,{|x| AllTrim(x[1]+x[2])==STR0012+'D3_DESCRI'})	//Descricao do Produto Destino
Private n_PosUMDes	:= aScan(aHeader,{|x| AllTrim(x[1]+x[2])==STR0013+'D3_UM'})		//Unidade de Medida Destino
Private n_PosLOCDes := aScan(aHeader,{|x| AllTrim(x[1]+x[2])==STR0014+'D3_LOCAL'})	//Armazem Destino
Private n_PosLcZDes := aScan(aHeader,{|x| AllTrim(x[1]+x[2])==STR0015+'D3_LOCALIZ'})	//Localizacao Destino
Private n_PosNSer	:= aScan(aHeader,{|x| AllTrim(x[1]+x[2])==STR0016+'D3_NUMSERI'})	//Numero de Serie
Private n_PosLoTCTL := aScan(aHeader,{|x| AllTrim(x[1]+x[2])==STR0018+'D3_LOTECTL'})	//Lote de Controle
Private n_PosNLOTE	:= aScan(aHeader,{|x| AllTrim(x[1]+x[2])==STR0017+'D3_NUMLOTE'})	//Numero do Lote
Private n_PosDTVAL	:= aScan(aHeader,{|x| AllTrim(x[1]+x[2])==STR0019+'D3_DTVALID'})	//Data Valida
Private n_PosPotenc := aScan(aHeader,{|x| AllTrim(x[1]+x[2])==STR0039+'D3_POTENCI'})	//Potencia
Private n_PosQUANT	:= aScan(aHeader,{|x| AllTrim(x[1]+x[2])==STR0020+'D3_QUANT'})	//Quantidade
Private n_PosQTSEG	:= aScan(aHeader,{|x| AllTrim(x[1]+x[2])==STR0021+'D3_QTSEGUM'})	//Quantidade na 2a. Unidade de Medida
Private n_PosEstor  := aScan(aHeader,{|x| AllTrim(x[1]+x[2])==STR0022+'D3_ESTORNO'})	//Estornado
Private n_PosNumSeq := aScan(aHeader,{|x| AllTrim(x[1]+x[2])==STR0028+'D3_NUMSEQ'})	//Sequencia
Private n_PosLotDes := aScan(aHeader,{|x| AllTrim(x[1]+x[2])==STR0044+'D3_LOTECTL'})	//Lote Destino
Private n_PosDtVldD := aScan(aHeader,{|x| AllTrim(x[1]+x[2])==STR0046+'D3_DTVALID'})	//Data Valida de Destino
Private n_PosOPTrns := aScan(aHeader,{|x| AllTrim(x[2])=='D3_TBOP'})	//OP p/ Transferencia ao Armazem de Processo
Private n_PosALIWT  := aScan(aHeader,{|x| AllTrim(x[2])=='D3_ALI_WT'})	//Alias Walkthru
Private n_PosRECWT  := aScan(aHeader,{|x| AllTrim(x[2])=='D3_REC_WT'})	//RECNO Walkthru
//Private c_LocProc	:= GETMV("MX_LOCPROC")
Private c_LocProc	:= GETMV("MV_LOCPROC")
Private a_Produtos	:= {}			//Array com os produtos do aCols
Private c_Perg		:= "M26101"		//Grupo de perguntas da customizacao
Private c_op 		:= SPACE( (TAMSX3("C2_NUM")[1])+ (TAMSX3("C2_ITEM")[1]) + (TAMSX3("C2_SEQUEN")[1]) )
Private o_Font1
Private o_Dlg1
Private o_Say1
Private o_Get1
Private o_SBtn1
Private o_SBtn2

If !Empty(aCols[1][1])
	Aviso(SM0->M0_NOMECOM,"Para utilizar essa fun็ใo nใo pode haver nenhum produto preenchendo o Quadro de Transfer๊ncia(s).",{"Ok"},2,"Aten็ใo!")
	Return()
ENDIF

o_Font1 := TFont():New( "Verdana",0,-21,,.F.,0,,400,.F.,.F.,,,,,, )
o_Dlg1  := MSDialog():New( 091,232,184,602,"Selecione a OP",,,.F.,,,,,,.T.,,,.T. )
o_Say1  := TSay():New( 004,004,{||"OP:"},o_Dlg1,,o_Font1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,012)
o_Get1  := TGet():New( 004,036,{|u| IIF(pcount() > 0,c_op:=u,c_op)},o_Dlg1,140,014,'',,CLR_BLACK,CLR_WHITE,o_Font1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SC2","",,)
o_SBtn1 := SButton():New( 024,149,1,{||_fPROCACOLS()},o_Dlg1,,"", )
o_SBtn2 := SButton():New( 024,121,2,{||o_Dlg1:end()},o_Dlg1,,"", )
o_Dlg1:Activate(,,,.T.)

Return()
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_fValidPerบ Autor ณ ANTONIO NETO		 บ Data ณ  12/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao responsavel pela geracao dos dados da distribuicao  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAEST - Especifico MFX                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A T U A L I Z A C O E S                           บฑฑ
ฑฑฬออออออออออหอออออออออออออออออออหออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      บANALISTA           บALTERACOES                              บฑฑ
ฑฑบ          บ                   บ                                        บฑฑ
ฑฑศออออออออออสอออออออออออออออออออสออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function _fGeraDistr()
Local n_QtdDis		:= 0
Local c_Qry			:= ""
                         
c_Qry += "SELECT * "
c_Qry += "FROM "+RETSQLNAME("SD4")+" SD4 "
c_Qry += "JOIN "+RETSQLNAME("SB1")+" SB1 ON SB1.B1_COD = SD4.D4_COD "
c_Qry += "WHERE SD4.D_E_L_E_T_ <> '*'  AND SB1.D_E_L_E_T_ <> '*' "   
c_Qry += "AND D4_FILIAL = '"+XFILIAL("SD4")+"' "
c_Qry += "AND D4_OP = '"+c_op+"' "
c_Qry += "AND D4_LOCAL = '"+c_LocProc+"' "                          
c_Qry += "AND SB1.B1_LOCPAD <> '"+c_LocProc+"' "
c_Qry += "AND D4_QUANT > 0 "
c_Qry += "ORDER BY D4_COD, D4_LOTECTL, D4_QUANT "
TCQUERY c_Qry NEW ALIAS "QRY"

DBSELECTAREA("QRY")
QRY->(DBGOTOP())

While QRY->(!Eof())

	DBSELECTAREA("SB1")
	DBSETORDER(1)
	DBSEEK(XFILIAL("SB1")+QRY->D4_COD,.T.)
	
	IF EMPTY(QRY->D4_LOTECTL)
		DBSELECTAREA("SB2")
		DBSETORDER(1)
		DBSEEK(XFILIAL("SB2")+QRY->D4_COD+SB1->B1_LOCPAD,.T.)
		IF FOUND()
			n_QtdDis := SB2->B2_QATU
		ENDIF
	ELSE
		DBSELECTAREA("SB8")
		DBSETORDER(1)      
		DBSEEK(XFILIAL("SB8")+QRY->D4_COD+SB1->B1_LOCPAD+QRY->D4_LOTECTL,.T.)
		IF FOUND()
			n_QtdDis := SB8->B8_SALDO
		ENDIF	
	ENDIF	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCaso nao haja saldo ou necessidade o Get ficara como deletado.     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	IF n_QtdDis <= 0
		AADD(a_Produtos,{QRY->D4_COD,SB1->B1_DESC,SB1->B1_UM,SB1->B1_LOCPAD,Space(15),QRY->D4_COD,SB1->B1_DESC,SB1->B1_UM,QRY->D4_LOCAL,Space(15),Space(20),Space(10),Space(06),Ctod("  /  /  "),0,0,0,"",	"",Space(1),Ctod("  /  /  "),.T.})
	ELSE
		AADD(a_Produtos,{QRY->D4_COD,SB1->B1_DESC,SB1->B1_UM,SB1->B1_LOCPAD,Space(15),QRY->D4_COD,SB1->B1_DESC,SB1->B1_UM,QRY->D4_LOCAL,Space(15),Space(20),Space(10),Space(06),Ctod("  /  /  "),0,n_QtdDis,0,"",	"",Space(1),Ctod("  /  /  "),.F.})
	ENDIF
	
	aAdd(aCols, Array(Len(aHeader)+1))
	
	QRY->(DBSKIP())
ENDDO
QRY->(DBCLOSEAREA())

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_fPROCACOLSบ Autor ณ ANTONIO NETO		 บ Data ณ  12/04/10   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Preenchimento do ACOLS baseado na OP informada             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAEST - Especifico MFX                                   บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A T U A L I Z A C O E S                           บฑฑ
ฑฑฬออออออออออหอออออออออออออออออออหออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      บANALISTA           บALTERACOES                              บฑฑ
ฑฑบ          บ                   บ                                        บฑฑ
ฑฑศออออออออออสอออออออออออออออออออสออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function _fPROCACOLS()
Local n_TamACols := Len(aCols) - 1

_fGeraDistr()	//Gera Distribuicao de material

IF !(LEN(a_Produtos) > 0)
	Aviso(SM0->M0_NOMECOM,"Nใo foram Encontrados Saldos nos Empenhos para o Armaz้m: " + ALLTRIM(c_LocProc) + " na OP: " + ALLTRIM(c_op) + ".",{"Ok"},2,"Aten็ใo!")
	Return()
ELSE
	o_Dlg1:end()
ENDIF

n_NewTam := Len(aCols) - 1
aSize(aDel(aCols,Len(aCols)),n_NewTam)                               

FOR nX:= 1 + n_TamACols TO (LEN(a_Produtos) + n_TamACols)
	
	FOR nY:=1 To Len(aHeader)
		aCols[nX][nY] := CriaVar(aHeader[nY][2])
	Next nY
	
	aCols[nX+n_TamACols][n_PosCODOri]	:= a_Produtos[nX+n_TamACols][01]	//Produto Origem
	aCols[nX+n_TamACols][n_PosDOri] 	:= a_Produtos[nX+n_TamACols][02]	//Descricao do Produto Origem
	aCols[nX+n_TamACols][n_PosUMOri]	:= a_Produtos[nX+n_TamACols][03]	//Unidade de Medida do Produto Origem
	aCols[nX+n_TamACols][n_PosLOCOri]	:= a_Produtos[nX+n_TamACols][04]	//Armazem do Produto Origem
	aCols[nX+n_TamACols][n_PosLcZOri]	:= a_Produtos[nX+n_TamACols][05]	//Endereco do Produto Origem (nao carregado)
	aCols[nX+n_TamACols][n_PosCODDes]	:= a_Produtos[nX+n_TamACols][06]	//Produto Destino
	aCols[nX+n_TamACols][n_PosDDes]		:= a_Produtos[nX+n_TamACols][07]	//Descricao do Produto Destino
	aCols[nX+n_TamACols][n_PosUMDes]	:= a_Produtos[nX+n_TamACols][08]	//Unidade de Medida do Produto Destino
	aCols[nX+n_TamACols][n_PosLOCDes]	:= a_Produtos[nX+n_TamACols][09]	//Armazem do Produto Destino
	aCols[nX+n_TamACols][n_PosLcZDes]  	:= a_Produtos[nX+n_TamACols][10]	//Endereco do Produto Destino (nao carregado)
	aCols[nX+n_TamACols][n_PosNSer]	  	:= a_Produtos[nX+n_TamACols][11]	//Numero de serie (nao carregado)
	aCols[nX+n_TamACols][n_PosLoTCTL]  	:= a_Produtos[nX+n_TamACols][12]	//Lote (nao carregado)
	aCols[nX+n_TamACols][n_PosNLOTE]	:= a_Produtos[nX+n_TamACols][13]	//Sub-Lote (nao carregado)
	aCols[nX+n_TamACols][n_PosDTVAL]  	:= a_Produtos[nX+n_TamACols][14]	//Data de Validade do Lote (nao carregado)
	aCols[nX+n_TamACols][n_PosPotenc]  	:= a_Produtos[nX+n_TamACols][15]	//Potencia do Lote (nao carregado)
	aCols[nX+n_TamACols][n_PosQUANT]	:= a_Produtos[nX+n_TamACols][16]	//Quantidade (sugerida)
	aCols[nX+n_TamACols][n_PosQTSEG]	:= a_Produtos[nX+n_TamACols][17]	//Quantidade na 2a Unidade de Medida (sugerida)
	aCols[nX+n_TamACols][n_PosEstor]   	:= a_Produtos[nX+n_TamACols][18]	//Estorno  (nao carregado)
	aCols[nX+n_TamACols][n_PosNumSeq]  	:= a_Produtos[nX+n_TamACols][19]	//Numero de sequencia do lancamento (nao carregado)
	aCols[nX+n_TamACols][n_PosLotDes]  	:= a_Produtos[nX+n_TamACols][20]	//Lote Destino (nao carregado)
	aCols[nX+n_TamACols][n_PosDtVldD]  	:= a_Produtos[nX+n_TamACols][21]	//Data de Validade (nao carregado)	
	aCols[nX+n_TamACols][n_PosOPTrns]  	:= c_op	 //OP p/ Transferencia ao Armazem de Processo
	aCols[nX+n_TamACols][n_PosALIWT]  	:= "SD3" //Alias Walkthru
	aCols[nX+n_TamACols][n_PosRECWT]  	:= 	0 	 //RECNO Walkthru	
	aCols[nX+n_TamACols][n_Usado+1]		:= a_Produtos[nX+n_TamACols][22]	//Flag de delecao
	ADHeadRec("SD3",aHeader)	
	
NEXT nX

oGet:ForceRefresh()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRecupera o grupo de perguntas padrao da rotina  ณ
//|Necessario ja que foi utilizado um grupo de per-|
//|guntas customizado.                             |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Pergunte("MTA260",.F.)

Return

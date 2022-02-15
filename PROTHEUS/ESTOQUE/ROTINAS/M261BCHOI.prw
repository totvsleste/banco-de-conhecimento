#include "rwmake.ch"
#include "topconn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM261BCHOI บ Autor ณ FRANCISCO REZENDE  บ Data ณ  12/08/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de entrada para adicionar botoes na tela de transfe- บฑฑ
ฑฑบ          ณrencia modelo 2                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAEST - Especifico Leme                                  บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A T U A L I Z A C O E S                           บฑฑ
ฑฑฬออออออออออหอออออออออออออออออออหออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      บANALISTA           บALTERACOES                              บฑฑ
ฑฑบ          บ                   บ                                        บฑฑ
ฑฑศออออออออออสอออออออออออออออออออสออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function M261BCHOI()

Local _aArea	:= GetArea()
Local _aBtUser	:= {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณApenas na opcao incluir habilita o botaoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IF !INCLUI
	RestArea(_aArea)
	RETURN(_aBtUser)
ENDIF

AADD(_aBtUser,{"AVGARMAZEM",{||U_LEMA0001()},"Distribuir"})

RestArea(_aArea)

Return(_aBtUser)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLEMA0001  บ Autor ณ FRANCISCO REZENDE  บ Data ณ  12/08/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao principal. Explode o aCols com os produtos a serem  บฑฑ
ฑฑบ          ณdistribuidos entre as unidades.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObservacaoณ O tamanho do aCols varia conforme versao do Protheus.      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAEST :: ESPECIFICO LABORATORIOS LEME                    บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A T U A L I Z A C O E S                           บฑฑ
ฑฑฬออออออออออหอออออออออออออออออออหออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      บANALISTA           บALTERACOES                              บฑฑ
ฑฑบ          บ                   บ                                        บฑฑ
ฑฑศออออออออออสอออออออออออออออออออสออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function LEMA0001()

Local _nUsado		:= Len(aHeader)	//Quantidade de campos
Local _nNewTam		:= 0			//Refaz o tamanho do array (acols)
Local _nPosCODOri	:= 1			//Codigo do Produto Origem
Local _nPosDOri	  	:= 2			//Descricao do Produto Origem
Local _nPosUMOri	:= 3			//Unidade de Medida Origem
Local _nPosLOCOri  	:= 4			//Armazem Origem
Local _nPosLcZOri  	:= 5			//Localizacao Origem
Local _nPosCODDes  	:= 6 			//Codigo do Produto Destino
Local _nPosDDes	  	:= 7			//Descricao do Produto Destino
Local _nPosUMDes	:= 8			//Unidade de Medida Destino
Local _nPosLOCDes  	:= 9			//Armazem Destino
Local _nPosLcZDes  	:= 10			//Localizacao Destino
Local _nPosNSer	  	:= 11			//Numero de Serie
Local _nPosLoTCTL  	:= 12			//Lote de Controle
Local _nPosNLOTE	:= 13	 		//Numero do Lote
Local _nPosDTVAL	:= 14			//Data Valida
Local _nPosPotenc  	:= 15			//Potencia
Local _nPosQUANT	:= 16			//Quantidade
Local _nPosQTSEG	:= 17			//Quantidade na 2a. Unidade de Medida
Local _nPosEstor   	:= 18			//Estornado
Local _nPosNumSeq  	:= 19			//Sequencia
Local _nPosLotDes  	:= 20  			//Lote Destino
Local _nPosDtVldD  	:= 21 			//Data Valida de Destino

Private _aProdutos	:= {}			//Array com os produtos do aCols
Private _cPerg		:= "M26101"		//Grupo de perguntas da customizacao

If !Empty(aCols[1][1])
	Aviso(SM0->M0_NOMECOM,"Para utilizar essa fun็ใo nใo pode haver nenhum produto no Get",{"Ok"},2,"Aten็ใo!")
	Return()
ENDIF

_fValidPerg()
If !Pergunte(_cPerg,.T.)
	Return()
EndIf

_fGeraDistr()	//Gera Distribuicao de material

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRefaz o aCols antes de iniciar a nova gravacao.                   ณ
//ณIsto foi necessario ja que a rotina padrao de transferencia iniciaณ
//ณcom um elemento no aCols e ao adicionar novos elementos a         ณ
//ณvariavel _aProduto ficava menor que aCols.                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_nNewTam := Len(aCols) - 1
aSize(aDel(aCols,Len(aCols)),_nNewTam)

FOR nX:=1 TO LEN(_aProdutos)
	
	FOR nY:=1 To Len(aHeader)
		aCols[nX][nY] := CriaVar(aHeader[nY][2])
	Next nY
	
	aCols[nX][_nPosCODOri]		:= _aProdutos[nX][01]	//Produto Origem
	aCols[nX][_nPosDOri] 		:= _aProdutos[nX][02]	//Descricao do Produto Origem
	aCols[nX][_nPosUMOri]		:= _aProdutos[nX][03]	//Unidade de Medida do Produto Origem
	aCols[nX][_nPosLOCOri]		:= _aProdutos[nX][04]	//Armazem do Produto Origem
	aCols[nX][_nPosLcZOri]		:= _aProdutos[nX][05]	//Endereco do Produto Origem (nao carregado)
	aCols[nX][_nPosCODDes]		:= _aProdutos[nX][06]	//Produto Destino
	aCols[nX][_nPosDDes]		:= _aProdutos[nX][07]	//Descricao do Produto Destino
	aCols[nX][_nPosUMDes]		:= _aProdutos[nX][08]	//Unidade de Medida do Produto Destino
	aCols[nX][_nPosLOCDes]		:= _aProdutos[nX][09]	//Armazem do Produto Destino
	aCols[nX][_nPosLcZDes]  	:= _aProdutos[nX][10]	//Endereco do Produto Destino (nao carregado)
	aCols[nX][_nPosNSer]	  	:= _aProdutos[nX][11]	//Numero de serie (nao carregado)
	aCols[nX][_nPosLoTCTL]  	:= _aProdutos[nX][12]	//Lote (nao carregado)
	aCols[nX][_nPosNLOTE]		:= _aProdutos[nX][13]	//Sub-Lote (nao carregado)
	aCols[nX][_nPosDTVAL]  		:= _aProdutos[nX][14]	//Data de Validade do Lote (nao carregado)
	aCols[nX][_nPosPotenc]  	:= _aProdutos[nX][15]	//Potencia do Lote (nao carregado)
	aCols[nX][_nPosQUANT]		:= _aProdutos[nX][16]	//Quantidade (sugerida)
	aCols[nX][_nPosQTSEG]		:= _aProdutos[nX][17]	//Quantidade na 2a Unidade de Medida (sugerida)
	aCols[nX][_nPosEstor]   	:= _aProdutos[nX][18]	//Estorno  (nao carregado)
	aCols[nX][_nPosNumSeq]  	:= _aProdutos[nX][19]	//Numero de sequencia do lancamento (nao carregado)
	aCols[nX][_nPosLotDes]  	:= _aProdutos[nX][20]	//Lote Destino (nao carregado)
	aCols[nX][_nPosDtVldD]  	:= _aProdutos[nX][21]	//Data de Validade (nao carregado)
	aCols[nX][_nUsado+1]		:= _aProdutos[nX][22]	//Flag de delecao
	
NEXT nX

oGet:ForceRefresh()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRecupera o grupo de perguntas padrao da rotina  ณ
//|Necessario ja que foi utilizado um grupo de per-|
//|guntas customizado.                             |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Pergunte("MTA260",.F.)

Return()
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_fGeraDistบ Autor ณ FRANCISCO REZENDE  บ Data ณ  19/08/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao responsavel pela geracao dos dados da distribuicao  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAEST - Especifico Leme                                  บฑฑ
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

Local _nQtdSB2		:= 0
Local _nQtdDis		:= 0
Local _cDescProd	:= ""
Local _cUM			:= ""
Local _cQry			:= ""
                         
_cQry += "SELECT * "
_cQry += "FROM "+RETSQLNAME("SZ2")+" "
_cQry += "WHERE D_E_L_E_T_ <> '*' "
_cQry += "AND Z2_PRODUTO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
_cQry += "AND Z2_LOCAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
_cQry += "ORDER BY Z2_PRODUTO, Z2_LOCAL "

TCQUERY _cQry NEW ALIAS "QRY"

DBSELECTAREA("QRY")
QRY->(DBGOTOP())

While QRY->(!Eof())
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณArmazem padrao de saida dos materiais e sempre o '01'ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DBSELECTAREA("SB2")
	DBSETORDER(1)
	DBSEEK(XFILIAL("SB2")+QRY->Z2_PRODUTO+"01",.T.)
	IF FOUND()
		_nQtdSB2 := SB2->B2_QATU
	ENDIF
	
	DBSEEK(XFILIAL("SB2")+QRY->Z2_PRODUTO+QRY->Z2_LOCAL,.T.)
	IF FOUND()
		
		_nQtdDis := QRY->Z2_QUANT - SB2->B2_QATU
		
		IF _nQtdDis > _nQtdSB2
			_nQtdDis := _nQtdSB2
		ENDIF
	ENDIF
	
	DBSELECTAREA("SB1")
	DBSETORDER(1)
	DBSEEK(XFILIAL("SB1")+QRY->Z2_PRODUTO,.T.)
	_cDescProd	:= SB1->B1_DESC
	_cUM		:= SB1->B1_UM
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCaso nao haja saldo ou necessidade o Get ficara como deletado.     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	IF _nQtdSB2 <= 0 .OR. _nQtdDis <= 0
		AADD(_aProdutos,{QRY->Z2_PRODUTO,_cDescProd,_cUM,"01",Space(15),QRY->Z2_PRODUTO,_cDescProd,_cUM,QRY->Z2_LOCAL,Space(15),Space(20),Space(10),Space(06),Ctod("  /  /  "),0,0,0,"",	"",Space(1),Ctod("  /  /  "),.T.})
	ELSE
		AADD(_aProdutos,{QRY->Z2_PRODUTO,_cDescProd,_cUM,"01",Space(15),QRY->Z2_PRODUTO,_cDescProd,_cUM,QRY->Z2_LOCAL,Space(15),Space(20),Space(10),Space(06),Ctod("  /  /  "),0,_nQtdDis,0,"",	"",Space(1),Ctod("  /  /  "),.F.})
	ENDIF
	
	aAdd(aCols, Array(Len(aHeader)+1))
	
	QRY->(DBSKIP())
ENDDO
QRY->(DBCLOSEAREA())
Return()
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_fValidPerบ Autor ณ FRANCISCO REZENDE  บ Data ณ  19/08/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cria dicionario de perguntas                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAEST - Especifico Leme                                  บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                     A T U A L I Z A C O E S                           บฑฑ
ฑฑฬออออออออออหอออออออออออออออออออหออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDATA      บANALISTA           บALTERACOES                              บฑฑ
ฑฑบ          บ                   บ                                        บฑฑ
ฑฑศออออออออออสอออออออออออออออออออสออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function _fValidPerg()

_aMV_PAR01 := {}
_aMV_PAR02 := {}
_aMV_PAR03 := {}
_aMV_PAR04 := {}

Aadd(_aMV_PAR01, "Informe o codigo inicial do produto")
Aadd(_aMV_PAR02, "Informe o codigo final do produto")
Aadd(_aMV_PAR03, "Informe o armazem incial de transferencia")
Aadd(_aMV_PAR04, "Informe o armazem final de transferencia")

//PutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3, cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)

PutSx1(_cPerg,"01","Produto de?       ","","","mv_ch1","C",15,0,0,"G","","SB1","","","mv_par01","","","","","","","","","","","","","","","","",_aMV_PAR01)
PutSx1(_cPerg,"02","Produto ate?      ","","","mv_ch2","C",15,0,0,"G","","SB1","","","mv_par02","","","","","","","","","","","","","","","","",_aMV_PAR02)
PutSx1(_cPerg,"03","Armazem de?       ","","","mv_ch3","C",02,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",_aMV_PAR03)
PutSx1(_cPerg,"04","Armazem ate?      ","","","mv_ch4","C",02,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",_aMV_PAR04)

Return()

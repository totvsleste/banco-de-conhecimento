#INCLUDE "rwmake.ch"
#include "topconn.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*

ROTINA PARA ELIMINACAO DAS VENDAS
DATA: 18/02/2020

*/

User Function FINTM004()
Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := "Eliminação Vendas"
Local cDesc1  := " ***   Rotina de eliminação das Vendas"
Local cDesc2  := " ***   Tabelas envolvidas: SL1,SL2,SL4,SF2,SD2,SE1,SE5,FKS "
Local cDesc3  := " ***   Especifico para Vendas originadas do TOTVSCHEF"
Local cDesc4  := " ***   "

AADD( aSay, cDesc1 )
AADD( aSay, cDesc2 )
AADD( aSay, cDesc3 )
AADD( aSay, cDesc4 )
AADD( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() }} )
AADD( aButton, { 2, .T., {|| FechaBatch()            }} )

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1
	Return Nil
Endif

Processa( {|lEnd| RunProc(@lEnd)}, "Aguarde...","Executando rotina.", .T. )

Return()
/*/
+-----------------------------------------------------------------------------
| Função	| RUNPROC    | Autor | TOTVS                  | Data |15/03/2017 |
+-----------------------------------------------------------------------------
| Descrição	| Função de processamento executada através da FormBatch()   	 |
+-----------------------------------------------------------------------------
/*/
Static Function RunProc(lEnd)
Local nCnt 	   		:= 0
Local a_Parametro	:= {}
Local c_FilAux		:= cFilAnt
Local l_Diferente	:= .F.
Local l_Continua	:= .T.
Local c_Filial		:= ""
Local c_MsgErr		:= ""
Local i				:= 0
Local l_Erro		:= .F.

Private c_Perg		:= "FINTM004"
f_ValidPerg()

If !Pergunte( c_Perg, .T. )
	Return(.F.)
EndIf

cFilini				:= mv_par01
cFilfim             := mv_par02
dDataini 			:= mv_par03
dDatafim 			:= mv_par04
cSerini             := mv_par05
cSerfim             := mv_par06
cDocini             := mv_par07
cDocfim             := mv_par08


ProcRegua(nCnt)
IncProc("Processando... ")

//Deleta os registro na SL4 conforme filtro
/*
c_Qry := " UPDATE SL4 SET SL4.D_E_L_E_T_ = '*', SL4.R_E_C_D_E_L_ = SL4.R_E_C_N_O_ "
c_Qry += " FROM  "+RetSqlName("SL4")+" SL4 "
c_Qry += " INNER JOIN  "+RetSqlName("SL1")+" SL1 ON ( L4_FILIAL = L1_FILIAL AND L4_NUM = L1_NUM AND SL1.D_E_L_E_T_ = ' ' "
c_Qry += " AND L1_EMISSAO BETWEEN '" + DTOS(dDataini)+"' AND '"+ DTOS(dDatafim)+"' "
c_Qry += " AND L1_SERIE 	BETWEEN '" + cSerini+"' AND '"+ cSerfim+"' "
c_Qry += " AND L1_FILIAL 	BETWEEN '" + cFilini+"' AND '"+ cFilfim+"' "
c_Qry += " AND L1_DOC 	BETWEEN '" + cDocini+"' AND '"+ cDocfim+"') "
c_Qry += " WHERE SL4.D_E_L_E_T_ = '' "
*/

c_Qry := " UPDATE SL4010 SL4 "
c_Qry += " SET SL4.D_E_L_E_T_ = '*', "
c_Qry += " SL4.R_E_C_D_E_L_ = SL4.R_E_C_N_O_ "
c_Qry += " WHERE EXISTS (SELECT SL1.* "
c_Qry += " FROM " + RETSQLNAME("SL1") + " SL1 "
c_Qry += " WHERE SL4.L4_FILIAL = SL1.L1_FILIAL "
c_Qry += " AND SL4.L4_NUM = SL1.L1_NUM "
c_Qry += " AND SL1.D_E_L_E_T_ = ' ' "
c_Qry += " AND SL1.L1_EMISSAO BETWEEN '" + DTOS(dDataini)+"' AND '"+ DTOS(dDatafim)+"' "
c_Qry += " AND SL1.L1_SERIE 	BETWEEN '" + cSerini+"' AND '"+ cSerfim+"' "
c_Qry += " AND SL1.L1_FILIAL 	BETWEEN '" + cFilini+"' AND '"+ cFilfim+"' "
c_Qry += " AND SL1.L1_DOC 	BETWEEN '" + cDocini+"' AND '"+ cDocfim+"') "
c_Qry += " AND SL4.D_E_L_E_T_ <> '*' "

MEMOWRIT("C:\Temp\FINTM004_L4.sql",c_Qry)

// SE HOUVER ERRO NO INSERT, MOSTRA NA TELA E INTERROMPE A EXECUÇÃO DA ROTINA
If (TCSQLExec(c_Qry) < 0)
	
	c_MsgErr:= TCSQLError()
	MSGSTOP("TCSQLError() - SL4 " + c_MsgErr)
	l_Erro:= .T.
	
Else
	
	c_Qry := "commit"
	TCSQLExec(c_Qry)
	
Endif

//Deleta os registro na SL2 conforme filtro
c_Qry := " UPDATE SL2010 SL2 "
c_Qry += " SET SL2.D_E_L_E_T_ = '*', "
c_Qry += " SL2.R_E_C_D_E_L_ = SL2.R_E_C_N_O_ "
c_Qry += " WHERE EXISTS (SL1.* " 
c_Qry += " FROM "+RetSqlName("SL1")+" SL1 "
c_Qry += " WHERE SL2.SL2_FILIAL = SL1.L1_FILIAL AND SL2.L2_NUM = SL1.L1_NUM AND SL1.D_E_L_E_T_ = ' ' "
c_Qry += " AND SL1.L1_EMISSAO BETWEEN '" + DTOS(dDataini)+"' AND '"+ DTOS(dDatafim)+"' "
c_Qry += " AND SL1.L1_SERIE 	BETWEEN '" + cSerini+"' AND '"+ cSerfim+"' "
c_Qry += " AND SL1.L1_FILIAL 	BETWEEN '" + cFilini+"' AND '"+ cFilfim+"' "
c_Qry += " AND SL1.L1_DOC 	BETWEEN '" + cDocini+"' AND '"+ cDocfim+"') "
c_Qry += " WHERE SL2.D_E_L_E_T_ = '' "



MEMOWRIT("C:\Temp\FINTM004_L2.sql",c_Qry)

// SE HOUVER ERRO NO INSERT, MOSTRA NA TELA E INTERROMPE A EXECUÇÃO DA ROTINA
If (TCSQLExec(c_Qry) < 0)
	
	c_MsgErr:= TCSQLError()
	MSGSTOP("TCSQLError() - SL2 " + c_MsgErr)
	l_Erro:= .T.
	
Else
	
	c_Qry := "commit"
	TCSQLExec(c_Qry)
	
Endif

//Deleta os registro na SL1 conforme filtro
c_Qry:= "UPDATE "+RetSqlName("SL1")+" SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ "
c_Qry+= "WHERE D_E_L_E_T_ = '' "
c_Qry+= "AND L1_EMISSAO BETWEEN '" + DTOS(dDataini)+"' AND '"+ DTOS(dDatafim)+"' "
c_Qry+= "AND L1_SERIE 	BETWEEN '" + cSerini+"' AND '"+ cSerfim+"' "
c_Qry+= "AND L1_FILIAL 	BETWEEN '" + cFilini+"' AND '"+ cFilfim+"' "
c_Qry+= "AND L1_DOC 	BETWEEN '" + cDocini+"' AND '"+ cDocfim+"' "


MEMOWRIT("C:\Temp\FINTM004_L1.sql",c_Qry)

// SE HOUVER ERRO NO INSERT, MOSTRA NA TELA E INTERROMPE A EXECUÇÃO DA ROTINA
If (TCSQLExec(c_Qry) < 0)
	
	c_MsgErr:= TCSQLError()
	MSGSTOP("TCSQLError() - SL1 " + c_MsgErr)
	l_Erro:= .T.
	
Else
	
	c_Qry := "commit"
	TCSQLExec(c_Qry)
	
Endif

//Deleta os registro na SF2 conforme filtro
c_Qry:= "UPDATE "+RetSqlName("SF2")+" SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ "
c_Qry+= "WHERE D_E_L_E_T_ <> '*' "
c_Qry+= "AND F2_EMISSAO BETWEEN '" + DTOS(dDataini)+"' AND '"+ DTOS(dDatafim)+"' "
c_Qry+= "AND F2_SERIE 	BETWEEN '" + cSerini+"' AND '"+ cSerfim+"' "
c_Qry+= "AND F2_FILIAL 	BETWEEN '" + cFilini+"' AND '"+ cFilfim+"' "
c_Qry+= "AND F2_DOC 	BETWEEN '" + cDocini+"' AND '"+ cDocfim+"' "


MEMOWRIT("C:\Temp\FINTM004_F2.sql",c_Qry)

// SE HOUVER ERRO NO INSERT, MOSTRA NA TELA E INTERROMPE A EXECUÇÃO DA ROTINA
If (TCSQLExec(c_Qry) < 0)
	
	c_MsgErr:= TCSQLError()
	MSGSTOP("TCSQLError() - SF2 " + c_MsgErr)
	l_Erro:= .T.
	
Else
	
	c_Qry := "commit"
	TCSQLExec(c_Qry)
	
Endif

//Deleta os registro na SD2 conforme filtro
c_Qry:= "UPDATE "+RetSqlName("SD2")+" SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ "
c_Qry+= "WHERE D_E_L_E_T_ <> '*' "
c_Qry+= "AND D2_EMISSAO BETWEEN '" + DTOS(dDataini)+"' AND '"+ DTOS(dDatafim)+"' "
c_Qry+= "AND D2_SERIE 	BETWEEN '" + cSerini+"' AND '"+ cSerfim+"' "
c_Qry+= "AND D2_FILIAL 	BETWEEN '" + cFilini+"' AND '"+ cFilfim+"' "
c_Qry+= "AND D2_DOC 	BETWEEN '" + cDocini+"' AND '"+ cDocfim+"' "


MEMOWRIT("C:\Temp\FINTM004_D2.sql",c_Qry)

// SE HOUVER ERRO NO INSERT, MOSTRA NA TELA E INTERROMPE A EXECUÇÃO DA ROTINA
If (TCSQLExec(c_Qry) < 0)
	
	c_MsgErr:= TCSQLError()
	MSGSTOP("TCSQLError() - SD2 " + c_MsgErr)
	l_Erro:= .T.
	
Else
	
	c_Qry := "commit"
	TCSQLExec(c_Qry)
	
Endif

//Deleta os registro na SF3 conforme filtro
c_Qry:= "UPDATE "+RetSqlName("SF3")+" SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ "
c_Qry+= "WHERE D_E_L_E_T_ <> '*' "
c_Qry+= "AND F3_EMISSAO BETWEEN '" + DTOS(dDataini)+"' AND '"+ DTOS(dDatafim)+"' "
c_Qry+= "AND F3_SERIE 	BETWEEN '" + cSerini+"' AND '"+ cSerfim+"' "
c_Qry+= "AND F3_FILIAL 	BETWEEN '" + cFilini+"' AND '"+ cFilfim+"' "
c_Qry+= "AND F3_NFISCAL	BETWEEN '" + cDocini+"' AND '"+ cDocfim+"' "


MEMOWRIT("C:\Temp\FINTM004_F3.sql",c_Qry)

// SE HOUVER ERRO NO INSERT, MOSTRA NA TELA E INTERROMPE A EXECUÇÃO DA ROTINA
If (TCSQLExec(c_Qry) < 0)
	
	c_MsgErr:= TCSQLError()
	MSGSTOP("TCSQLError() - SF3 " + c_MsgErr)
	l_Erro:= .T.
	
Else
	
	c_Qry := "commit"
	TCSQLExec(c_Qry)
	
Endif

//Deleta os registro na SFT conforme filtro
c_Qry:= "UPDATE "+RetSqlName("SFT")+" SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ "
c_Qry+= "WHERE D_E_L_E_T_ <> '*' "
c_Qry+= "AND FT_EMISSAO BETWEEN '" + DTOS(dDataini)+"' AND '"+ DTOS(dDatafim)+"' "
c_Qry+= "AND FT_SERIE 	BETWEEN '" + cSerini+"' AND '"+ cSerfim+"' "
c_Qry+= "AND FT_FILIAL 	BETWEEN '" + cFilini+"' AND '"+ cFilfim+"' "
c_Qry+= "AND FT_NFISCAL	BETWEEN '" + cDocini+"' AND '"+ cDocfim+"' "


MEMOWRIT("C:\Temp\FINTM004_FT.sql",c_Qry)

// SE HOUVER ERRO NO INSERT, MOSTRA NA TELA E INTERROMPE A EXECUÇÃO DA ROTINA
If (TCSQLExec(c_Qry) < 0)
	
	c_MsgErr:= TCSQLError()
	MSGSTOP("TCSQLError() - SFT " + c_MsgErr)
	l_Erro:= .T.
	
Else
	
	c_Qry := "commit"
	TCSQLExec(c_Qry)
	
Endif

//Deleta os registro na SE1 conforme filtro
c_Qry:= "UPDATE "+RetSqlName("SE1")+" SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ "
c_Qry+= "WHERE D_E_L_E_T_ <> '*' "
c_Qry+= "AND E1_EMISSAO BETWEEN '" + DTOS(dDataini)+"' AND '"+ DTOS(dDatafim)+"' "
c_Qry+= "AND E1_PREFIXO	BETWEEN '" + cSerini+"' AND '"+ cSerfim+"' "
c_Qry+= "AND E1_FILIAL 	BETWEEN '" + cFilini+"' AND '"+ cFilfim+"' "
c_Qry+= "AND E1_NUM		BETWEEN '" + cDocini+"' AND '"+ cDocfim+"' "


MEMOWRIT("C:\Temp\FINTM004_E1.sql",c_Qry)

// SE HOUVER ERRO NO INSERT, MOSTRA NA TELA E INTERROMPE A EXECUÇÃO DA ROTINA
If (TCSQLExec(c_Qry) < 0)
	
	c_MsgErr:= TCSQLError()
	MSGSTOP("TCSQLError() - SE1 " + c_MsgErr)
	l_Erro:= .T.
	
Else
	
	c_Qry := "commit"
	TCSQLExec(c_Qry)
	
Endif

//Deleta os registro na FK1 conforme filtro
c_Qry := " UPDATE FK1010 FK1 "
c_Qry += " SET FK1.D_E_L_E_T_ = '*', "
c_Qry += " FK1.R_E_C_D_E_L_ = FK1.R_E_C_N_O_ "
c_Qry += " WHERE EXISTS ( SE5.* "
c_Qry += " FROM " +RetSqlName("SE5")+" SE5 "
c_Qry += " WHERE SE5.E5_IDORIG = FK1.FK1_IDFK1 AND SE5.D_E_L_E_T_ = ' ' "
c_Qry += " AND SE5.E5_DATA	BETWEEN '" + DTOS(dDataini)+"' AND '"+ DTOS(dDatafim)+"' "
c_Qry += " AND SE5.E5_PREFIXO	BETWEEN '" + cSerini+"' AND '"+ cSerfim+"' "
c_Qry += " AND SE5.E5_FILIAL 	BETWEEN '" + cFilini+"' AND '"+ cFilfim+"' "
c_Qry += " AND SE5.E5_NUMERO	BETWEEN '" + cDocini+"' AND '"+ cDocfim+"' ) "
c_Qry +=  "WHERE FK1.D_E_L_E_T_ = '' "

MEMOWRIT("C:\Temp\FINTM004_FK1.sql",c_Qry)

// SE HOUVER ERRO NO INSERT, MOSTRA NA TELA E INTERROMPE A EXECUÇÃO DA ROTINA
If (TCSQLExec(c_Qry) < 0)
	
	c_MsgErr:= TCSQLError()
	MSGSTOP("TCSQLError() - FK1 " + c_MsgErr)
	l_Erro:= .T.
	
Else
	
	c_Qry := "commit"
	TCSQLExec(c_Qry)
	
Endif
//Deleta os registro na SE5 conforme filtro
c_Qry:= "UPDATE "+RetSqlName("SE5")+" SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ "
c_Qry+= "WHERE D_E_L_E_T_ <> '*' "
c_Qry+= "AND E5_DATA	BETWEEN '" + DTOS(dDataini)+"' AND '"+ DTOS(dDatafim)+"' "
c_Qry+= "AND E5_PREFIXO	BETWEEN '" + cSerini+"' AND '"+ cSerfim+"' "
c_Qry+= "AND E5_FILIAL 	BETWEEN '" + cFilini+"' AND '"+ cFilfim+"' "
c_Qry+= "AND E5_NUMERO	BETWEEN '" + cDocini+"' AND '"+ cDocfim+"' "


MEMOWRIT("C:\Temp\FINTM004_E5.sql",c_Qry)

// SE HOUVER ERRO NO INSERT, MOSTRA NA TELA E INTERROMPE A EXECUÇÃO DA ROTINA
If (TCSQLExec(c_Qry) < 0)
	
	c_MsgErr:= TCSQLError()
	MSGSTOP("TCSQLError() - SE5 " + c_MsgErr)
	l_Erro:= .T.
	
Else
	
	c_Qry := "commit"
	TCSQLExec(c_Qry)
	
Endif


Return()

/*/{Protheus.doc} f_ValidPerg
Cria o arquivo de perguntas
@since 03/01/2020
@version 1.0
/*/
Static Function f_ValidPerg()

Local cValid   := ""
Local cF3      := ""
Local cPicture := ""
Local cDef01   := ""
Local cDef02   := ""
Local cDef03   := ""
Local cDef04   := ""
Local cDef05   := ""

zPutSX1(c_Perg, "01","Filial De		    ","MV_PAR01","MV_CH0","C",TAMSX3("L1_FILIAL")[1] 	,0,"G",cValid,''		,cPicture,cDef01,cDef02,cDef03,cDef04,cDef05,"Informe Codigo Filial.")
zPutSX1(c_Perg, "02","Filial Ate		","MV_PAR02","MV_CH1","C",TAMSX3("L1_FILIAL")[1]	,0,"G",cValid,''		,cPicture,cDef01,cDef02,cDef03,cDef04,cDef05,"Informe Codigo Filial.")
zPutSX1(c_Perg, "03","Emissao De		","MV_PAR03","MV_CH2","D",TAMSX3("L1_EMISSAO")[1] 	,0,"G",cValid,cF3		,cPicture,cDef01,cDef02,cDef03,cDef04,cDef05,"Informe a emissao inicial.")
zPutSX1(c_Perg, "04","Emissao Ate		","MV_PAR04","MV_CH3","D",TAMSX3("L1_EMISSAO")[1] 	,0,"G",cValid,cF3		,cPicture,cDef01,cDef02,cDef03,cDef04,cDef05,"Informe a emissao final.")
zPutSX1(c_Perg, "05","Serie De		    ","MV_PAR05","MV_CH4","C",TAMSX3("L1_SERIE")[1] 	,0,"G",cValid,''		,cPicture,cDef01,cDef02,cDef03,cDef04,cDef05,"Informe Serie Fiscal.")
zPutSX1(c_Perg, "06","Serie Ate			","MV_PAR06","MV_CH5","C",TAMSX3("L1_SERIE")[1]		,0,"G",cValid,''		,cPicture,cDef01,cDef02,cDef03,cDef04,cDef05,"Informe Serie Fiscal.")
zPutSX1(c_Perg, "07","Doc De		    ","MV_PAR07","MV_CH6","C",TAMSX3("L1_DOC")[1]	 	,0,"G",cValid,''		,cPicture,cDef01,cDef02,cDef03,cDef04,cDef05,"Informe Doc Fiscal.")
zPutSX1(c_Perg, "08","Doc Ate			","MV_PAR08","MV_CH7","C",TAMSX3("L1_DOC")[1]		,0,"G",cValid,''		,cPicture,cDef01,cDef02,cDef03,cDef04,cDef05,"Informe Doc Fiscal.")

Return()
/*/{Protheus.doc} zPutSX1
Função para criar Grupo de Perguntas
@version 1.0
@type function
@param cGrupo,    characters, Grupo de Perguntas       (ex.: X_TESTE)
@param cOrdem,    characters, Ordem da Pergunta        (ex.: 01, 02, 03, ...)
@param cTexto,    characters, Texto da Pergunta        (ex.: Produto De, Produto Até, Data De, ...)
@param cMVPar,    characters, MV_PAR?? da Pergunta     (ex.: MV_PAR01, MV_PAR02, MV_PAR03, ...)
@param cVariavel, characters, Variável da Pergunta     (ex.: MV_CH0, MV_CH1, MV_CH2, ...)
@param cTipoCamp, characters, Tipo do Campo            (C = Caracter, N = Numérico, D = Data)
@param nTamanho,  numeric,    Tamanho da Pergunta      (Máximo de 60)
@param nDecimal,  numeric,    Tamanho de Decimais      (Máximo de 9)
@param cTipoPar,  characters, Tipo do Parâmetro        (G = Get, C = Combo, F = Escolha de Arquivos, K = Check Box)
@param cValid,    characters, Validação da Pergunta    (ex.: Positivo(), u_SuaFuncao(), ...)
@param cF3,       characters, Consulta F3 da Pergunta  (ex.: SB1, SA1, ...)
@param cPicture,  characters, Máscara do Parâmetro     (ex.: @!, @E 999.99, ...)
@param cDef01,    characters, Primeira opção do combo
@param cDef02,    characters, Segunda opção do combo
@param cDef03,    characters, Terceira opção do combo
@param cDef04,    characters, Quarta opção do combo
@param cDef05,    characters, Quinta opção do combo
@param cHelp,     characters, Texto de Help do parâmetro
@obs Função foi criada, pois a partir de algumas versões do Protheus 12, a função padrão PutSX1 não funciona (por medidas de segurança)
@example Abaixo um exemplo de como criar um grupo de perguntas

c_Perg    := "X_TST"

cValid   := ""
cF3      := ""
cPicture := ""
cDef01   := ""
cDef02   := ""
cDef03   := ""
cDef04   := ""
cDef05   := ""

zPutSX1(c_Perg, "01", "Produto De?",       "MV_PAR01", "MV_CH0", "C", TamSX3('B1_COD')[01], 0, "G", cValid,       "SB1", cPicture,        cDef01,  cDef02,        cDef03,        cDef04,    cDef05, "Informe o produto inicial")
zPutSX1(c_Perg, "02", "Produto Até?",      "MV_PAR02", "MV_CH1", "C", TamSX3('B1_COD')[01], 0, "G", cValid,       "SB1", cPicture,        cDef01,  cDef02,        cDef03,        cDef04,    cDef05, "Informe o produto final")
zPutSX1(c_Perg, "03", "A partir da Data?", "MV_PAR03", "MV_CH2", "D", 08,                   0, "G", cValid,       cF3,   cPicture,        cDef01,  cDef02,        cDef03,        cDef04,    cDef05, "Informe a data inicial a ser considerada")
zPutSX1(c_Perg, "04", "Média maior que?",  "MV_PAR04", "MV_CH3", "N", 09,                   2, "G", "Positivo()", cF3,   "@E 999,999.99", cDef01,  cDef02,        cDef03,        cDef04,    cDef05, "Informe a média de atraso que será considerada")
zPutSX1(c_Perg, "05", "Tipo de Saldos?",   "MV_PAR05", "MV_CH4", "N", 01,                   0, "C", cValid,       cF3,   cPicture,        "Todos", "Maior que 0", "Menor que 0", "Zerados", cDef05, "Informe o tipo de saldo a ser considerado")
zPutSX1(c_Perg, "06", "Tipos de Produto?", "MV_PAR06", "MV_CH5", "C", 60,                   0, "K", cValid,       cF3,   cPicture,        "PA",    "PI",          "MP",          cDef04,    cDef05, "Informe os tipos de produto que serão considerados")
zPutSX1(c_Perg, "07", "Caminho de Log?",   "MV_PAR07", "MV_CH6", "C", 60,                   0, "F", cValid,       cF3,   cPicture,        cDef01,  cDef02,        cDef03,        cDef04,    cDef05, "Informe o caminho para geração do log")
/*/
Static Function zPutSX1(cGrupo, cOrdem, cTexto, cMVPar, cVariavel, cTipoCamp, nTamanho, nDecimal, cTipoPar, cValid, cF3, cPicture, cDef01, cDef02, cDef03, cDef04, cDef05, cHelp)
Local aArea       := GetArea()
Local cChaveHelp  := ""
Local nPreSel     := 0
Default cGrupo    := Space(10)
Default cOrdem    := Space(02)
Default cTexto    := Space(30)
Default cMVPar    := Space(15)
Default cVariavel := Space(6)
Default cTipoCamp := Space(1)
Default nTamanho  := 0
Default nDecimal  := 0
Default cTipoPar  := "G"
Default cValid    := Space(60)
Default cF3       := Space(6)
Default cPicture  := Space(40)
Default cDef01    := Space(15)
Default cDef02    := Space(15)
Default cDef03    := Space(15)
Default cDef04    := Space(15)
Default cDef05    := Space(15)
Default cHelp     := ""

//Se tiver Grupo, Ordem, Texto, Parâmetro, Variável, Tipo e Tamanho, continua para a criação do parâmetro
If !Empty(cGrupo) .And. !Empty(cOrdem) .And. !Empty(cTexto) .And. !Empty(cMVPar) .And. !Empty(cVariavel) .And. !Empty(cTipoCamp) .And. nTamanho != 0
	
	//Definição de variáveis
	cGrupo     := PadR(cGrupo, Len(SX1->X1_GRUPO), " ")           //Adiciona espaços a direita para utilização no DbSeek
	cChaveHelp := "P." + AllTrim(cGrupo) + AllTrim(cOrdem) + "."  //Define o nome da pergunta
	cMVPar     := Upper(cMVPar)                                   //Deixa o MV_PAR tudo em maiúsculo
	nPreSel    := Iif(cTipoPar == "C", 1, 0)                      //Se for Combo, o pré-selecionado será o Primeiro
	cDef01     := Iif(cTipoPar == "F", "56", cDef01)              //Se for File, muda a definição para ser tanto Servidor quanto Local
	nTamanho   := Iif(nTamanho > 60, 60, nTamanho)                //Se o tamanho for maior que 60, volta para 60 - Limitação do Protheus
	nDecimal   := Iif(nDecimal > 9,  9,  nDecimal)                //Se o decimal for maior que 9, volta para 9
	nDecimal   := Iif(cTipoPar == "N", nDecimal, 0)               //Se não for parâmetro do tipo numérico, será 0 o Decimal
	cTipoCamp  := Upper(cTipoCamp)                                //Deixa o tipo do Campo em maiúsculo
	cTipoCamp  := Iif(! cTipoCamp $ 'C;D;N;', 'C', cTipoCamp)     //Se o tipo do Campo não estiver entre Caracter / Data / Numérico, será Caracter
	cTipoPar   := Upper(cTipoPar)                                 //Deixa o tipo do Parâmetro em maiúsculo
	cTipoPar   := Iif(Empty(cTipoPar), 'G', cTipoPar)             //Se o tipo do Parâmetro estiver em branco, será um Get
	nTamanho   := Iif(cTipoPar == "C", 1, nTamanho)               //Se for Combo, o tamanho será 1
	
	DbSelectArea('SX1')
	SX1->(DbSetOrder(1)) // Grupo + Ordem
	//Se não conseguir posicionar, a pergunta será criada
	If ! SX1->(DbSeek(cGrupo + cOrdem))
		RecLock('SX1', .T.)
		X1_GRUPO   := cGrupo
		X1_ORDEM   := cOrdem
		X1_PERGUNT := cTexto
		X1_PERSPA  := cTexto
		X1_PERENG  := cTexto
		X1_VAR01   := cMVPar
		X1_VARIAVL := cVariavel
		X1_TIPO    := cTipoCamp
		X1_TAMANHO := nTamanho
		X1_DECIMAL := nDecimal
		X1_GSC     := cTipoPar
		X1_VALID   := cValid
		X1_F3      := cF3
		X1_PICTURE := cPicture
		X1_DEF01   := cDef01
		X1_DEFSPA1 := cDef01
		X1_DEFENG1 := cDef01
		X1_DEF02   := cDef02
		X1_DEFSPA2 := cDef02
		X1_DEFENG2 := cDef02
		X1_DEF03   := cDef03
		X1_DEFSPA3 := cDef03
		X1_DEFENG3 := cDef03
		X1_DEF04   := cDef04
		X1_DEFSPA4 := cDef04
		X1_DEFENG4 := cDef04
		X1_DEF05   := cDef05
		X1_DEFSPA5 := cDef05
		X1_DEFENG5 := cDef05
		X1_PRESEL  := nPreSel
		//Se tiver Help da Pergunta
		If !Empty(cHelp)
			X1_HELP    := ""
			fPutHelp(cChaveHelp, cHelp, .T.)
		EndIf
		SX1->(MsUnlock())
	EndIf
EndIf
RestArea(aArea)
Return
/*---------------------------------------------------*
| Função: fPutHelp                                  |
| Desc:   Função que insere o Help do Parametro     |
*---------------------------------------------------*/
Static Function fPutHelp(cKey, cHelp, lUpdate)
Local cFilePor  := "SIGAHLP.HLP"
Local cFileEng  := "SIGAHLE.HLE"
Local cFileSpa  := "SIGAHLS.HLS"
Local nRet      := 0
Default cKey    := ""
Default cHelp   := ""
Default lUpdate := .F.

//Se a Chave ou o Help estiverem em branco
If Empty(cKey) .Or. Empty(cHelp)
	Return
EndIf

//**************************** Português
nRet := SPF_SEEK(cFilePor, cKey, 1)

//Se não encontrar, será inclusão
If nRet < 0
	SPF_INSERT(cFilePor, cKey, , , cHelp)
	
	//Senão, será atualização
Else
	If lUpdate
		SPF_UPDATE(cFilePor, nRet, cKey, , , cHelp)
	EndIf
EndIf
//**************************** Inglês
nRet := SPF_SEEK(cFileEng, cKey, 1)

//Se não encontrar, será inclusão
If nRet < 0
	SPF_INSERT(cFileEng, cKey, , , cHelp)
	
	//Senão, será atualização
Else
	If lUpdate
		SPF_UPDATE(cFileEng, nRet, cKey, , , cHelp)
	EndIf
EndIf

//**************************** Espanhol
nRet := SPF_SEEK(cFileSpa, cKey, 1)

//Se não encontrar, será inclusão
If nRet < 0
	SPF_INSERT(cFileSpa, cKey, , , cHelp)
	
	//Senão, será atualização
Else
	If lUpdate
		SPF_UPDATE(cFileSpa, nRet, cKey, , , cHelp)
	EndIf
EndIf
Return

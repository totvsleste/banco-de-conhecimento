#Include 'Protheus.ch'
#include "topconn.ch"
#include "tbiconn.ch
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCTBR010  บAutor  ณTI1970-APENHA       บ Data ณ  10/31/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera planilha excel com as NFs dos clientes que abatem o   บฑฑ
ฑฑบ          ณ INSS.                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEmpresas 00/07/16/17/18/19/20/53/75                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user Function RCTBR010()

	Local aRegs		:= {}
	Local aCampos 	:= {}
	Local cPerg		:= 'RCTB10'

	Private nConexao := 0
	Private nConMain := 0

	Private lLogocenter := cEmpAnt=='20'
	Private lRMO		:= cEmpAnt=='40'

	Aadd(aCampos,{'NOTA'		,'C',09,0})
	Aadd(aCampos,{'PARCELA'		,'C',15,0})
	Aadd(aCampos,{'VENCREA'		,'D',08,0})
	Aadd(aCampos,{'EMISSAO'		,'D',08,0})
	Aadd(aCampos,{'VALFAT'		,'N',15,2})
	Aadd(aCampos,{'VALIMP'		,'N',15,2})
	Aadd(aCampos,{'ANALISTA'	,'C',255,0})
	Aadd(aCampos,{'CLIENTE'		,'C',25,0})
	Aadd(aCampos,{'ENDERECO'	,'C',25,0})
	Aadd(aCampos,{'BAIRRO'		,'C',25,0})
	Aadd(aCampos,{'CIDADE'		,'C',25,0})
	Aadd(aCampos,{'ESTADO'		,'C',15,0})
	Aadd(aCampos,{'CEP'			,'C',15,0})
	Aadd(aCampos,{'CNPJ'		,'C',25,0})
	Aadd(aCampos,{'DESCRICAO'	,'C',40,0})

	cArqTRB := CriaTrab(aCampos,.T.)
	//dbUseArea( .T. ,__LocalDriver ,cArqTRB,"TRB",.T.,.F.)
	dbUseArea(.T., "DBFCDX", cArqTRB, "TRB", .T., .F.)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria os parametros da rotina                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	AAdd(aRegs,{cPerg,"01","Nota Fiscal de       		?","","","mv_ch1","C",09,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(aRegs,{cPerg,"02","Nota Fiscal ate      		?","","","mv_ch2","C",09,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(aRegs,{cPerg,"03","Serie                		?","","","mv_ch3","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aRegs,{cPerg,"04","Tipo de Filtro   	  		?","","","mv_ch4","N",01,0,2,"C","","MV_PAR04","Por Nota","","","","","Por Emissao","","","","","","","","","","","","","","","","","","","","","",	"","" })
	AAdd(aRegs,{cPerg,"05","Emissao de       	  		?","","","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(aRegs,{cPerg,"06","Emissao ate      	  		?","","","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	CriaSX1(cPerg,aRegs)

	If !(Pergunte(cPerg,.T.))
		Return
	EndIf

	nConMain		:= AdvConnection() //retorna a conexao principal (Protheus)

	If lLogocenter

		nConexao	:= LOGOConect()

		TcSetConn(nConMain)

		If nConexao < 0
			Alert("Nao foi possivel conectar no Logix.")
			Return
		EndIf

	EndIf

	Processa({|| Processamento()},'Processando...')

	If lLogocenter
		TcUnLink(nConexao)
	EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcessameบAutor  ณTI1970-APENHA       บ Data ณ  11/05/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Processamento()

	Local cNotaSerie
	Local cQuery		:= ''
	Local nX			:= 0
	Local c_Body 		:= ""

	cQuery := " SELECT DISTINCT	SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_VALFAT,"                                        		//Campos do SF2
	cQuery += " SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_EMISSAO, SD2.D2_GRUPO,"	                                            //Campos do SD2
	cQuery += " SA1.A1_COD,  SA1.A1_NOME, SA1.A1_END, SA1.A1_BAIRRO, SA1.A1_MUN, SA1.A1_EST, SA1.A1_CEP, SA1.A1_CGC," 	//Campos do SA1
	cQuery += " SE1.E1_VENCREA, SE1.E1_VALOR, SE1.E1_PARCELA, SE1.E1_TIPO,"												//Campos do SE1

	If lLogocenter
		cQuery += " SC6.C6_OSLOGO, SC6.C6_DESCRI"																	//Campos do SC6
	EndIf

	If !lLogocenter                                                                                                                       																						//Campos do SC6
		cQuery += " SA9.A9_TECNICO, SA9.A9_NOME"						   												//Campos do SA9
	EndIF

	cQuery += " FROM"

	//F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL
	cQuery += " "+RetSqlName("SF2")+" SF2"
	cQuery += " INNER JOIN "+RetSqlName("SD2")+" SD2 ON ( SF2.F2_FILIAL 		= '"+xFilial("SF2")+"'"
	cQuery += " 										   AND SF2.F2_DOC 		=   SD2.D2_DOC"
	cQuery += "                                            AND SF2.F2_SERIE 	=   SD2.D2_SERIE"
	cQuery += "                                            AND SF2.D_E_L_E_T_	=   ' ')"

	//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	cQuery += " INNER JOIN "+RetSqlName("SE1")+" SE1 ON ( SE1.E1_FILIAL 	    ='"+xFilial("SE1")+"'"
	cQuery += "                                            AND SE1.E1_PREFIXO	=	SD2.D2_SERIE"
	cQuery += " 										   AND SE1.E1_NUM 		= 	SD2.D2_DOC"
	cQuery += "                                            AND SE1.D_E_L_E_T_	=   ' ' )"

	//C6_FILIAL+C6_NOTA+C6_SERIE
	cQuery += " LEFT JOIN "+RetSqlName("SC6")+" SC6 ON ( SC6.C6_FILIAL 			= '"+xFilial("SC6")+"'"
	cQuery += "                                        	  AND SC6.C6_NOTA		= 	SD2.D2_DOC"
	cQuery += " 										  AND SC6.C6_SERIE		=	SD2.D2_SERIE"
	cQuery += " 										  AND SC6.D_E_L_E_T_	=	' ')"

	If !lLogocenter

		//ZCT_FILIAL + ZCT_CLIENT + ZCT_PROJET + ZCT_ITEM + ZCT_VERSAO
		cQuery += " LEFT JOIN "+RetSqlName("ZCT")+" ZCT ON ( ZCT.ZCT_FILIAL	        = '"+xFilial("ZCT")+"'"
		cQuery += " 										  AND ZCT.ZCT_CLIENT	=	SC6.C6_CLI"
		cQuery += " 										  AND ( ZCT.ZCT_PROJET||ZCT.ZCT_ITEM||ZCT.ZCT_VERSAO ) = SC6.C6_PROJETO"
		cQuery += "											  AND ZCT.D_E_L_E_T_=' ' )"

		//CA_FILIAL+CA_CLIENTE+CA_PROJETO+CA_ITEMPRJ+CA_VRSPRJ
		cQuery += "	LEFT JOIN "+RetSqlName("SCA")+" SCA ON ( (SCA.CA_FILIAL			= '"+xFilial("SCA")+"'"
		cQuery += " 										  AND SCA.CA_CLIENTE    =  ZCT.ZCT_CLIENT"
		cQuery += "	                               			  AND SCA.CA_PROJETO	=  ZCT.ZCT_PROJET"
		cQuery += "		                             		  AND SCA.CA_ITEMPRJ	=  ZCT.ZCT_ITEM"
		cQuery += "		                               		  AND SCA.CA_VRSPRJ		=  ZCT.ZCT_VERSAO"
		cQuery += "											  AND SCA.D_E_L_E_T_=  ' ')

		cQuery += "											  OR ( SCA.CA_FILIAL	= '"+xFilial("SCA")+"'"
		cQuery += " 										  AND SCA.CA_CLIENTE    =  ZCT.ZCT_CLIENT"
		cQuery += "		                                      AND SCA.CA_PROJETO||SCA.CA_ITEMPRJ||SCA.CA_VRSPRJ = ZCT.ZCT_PRJFAT"
		cQuery += "											  AND SCA.D_E_L_E_T_=  ' ')

		cQuery += "											  OR ( SCA.CA_FILIAL	= '"+xFilial("SCA")+"'"
		cQuery += " 										  AND SCA.CA_CLIENTE    =  SC6.C6_CLI"
		cQuery += "											  AND SCA.CA_PEDIDO		=  SC6.C6_NUM "
		cQuery += "											  AND SCA.D_E_L_E_T_=  ' ') )"

		//A9_FILIAL+A9_TECNICO
		cQuery += " LEFT JOIN "+RetSqlName("SA9")+" SA9 ON ( SA9.A9_FILIAL			= '"+xFilial("SA9")+"'"
		cQuery += "                                           AND SA9.A9_TECNICO	=  SCA.CA_TECNICO"
		cQuery += "		                                   	  AND SA9.D_E_L_E_T_=' ')"

	EndIf

	//A1_FILIAL+A1_COD+A1_LOJA
	cQuery += "	INNER JOIN "+RetSqlName("SA1")+" SA1 ON ( SA1.A1_FILIAL 		= '"+xFilial("SA1")+"'"
	cQuery += "                                           AND SA1.A1_COD		=  SD2.D2_CLIENTE"
	cQuery += "					                          AND SA1.A1_LOJA       =  SD2.D2_LOJA"
	cQuery += " 										  AND SA1.D_E_L_E_T_ 	= ' ')"

	If MV_PAR04 == 1 //Filtro por NF
		cQuery += " WHERE SD2.D2_DOC BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
	Else   //Filtro por data de Emissao
		cQuery += " WHERE SD2.D2_EMISSAO BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"'"
	EndIf

	If !lRMO
		cQuery += "	AND SD2.D2_GRUPO BETWEEN '0200' AND '0301'"
	EndIf

	If cEmpAnt $ "00/75"
		cQuery += "	AND SA1.A1_RECINSS = 'S'"
	Else
		cQuery += " AND SE1.E1_TIPO = 'IN-'"
	EndIf

	cQuery += "	ORDER BY SD2.D2_DOC"

	cQuery  := ChangeQuery(cQuery)
	TCQUERY cQuery NEW ALIAS "QUERY"

	//         TABELA , CAMPO		, TIPO(D,N)	 ,TAMANHO	             	, DECIMAIS
	TcSetField("QUERY","E1_VENCREA"	,"D"		,TamSX3("E1_VENCREA")[1]	,TamSX3("E1_VENCREA")[2])
	TcSetField("QUERY","E1_VALOR"	,"N"		,TamSX3("E1_VALOR")[1]	 	,TamSX3("E1_VALOR")[2])
	TcSetField("QUERY","D2_EMISSAO"	,"D"		,TamSX3("D2_EMISSAO")[1]	,TamSX3("D2_EMISSAO")[2])
	TcSetField("QUERY","F2_VALFAT"	,"N"		,TamSX3("F2_VALFAT")[1]	 	,TamSX3("F2_VALFAT")[2])

	dbSelectArea("QUERY")
	dbGoTop()

	c_Body += "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>"
	c_Body += "<html xmlns='http://www.w3.org/1999/xhtml'>"
	c_Body += "	<head>"
	c_Body += "		<meta http-equiv='Content-Type' content='text/html; charset=ISO-8859-1' />"
	c_Body += "		<title>Comunicado - TOTVS</title>"
	c_Body += "	</head>"
	c_Body += "	<body bgcolor='#c7e4ec' style='padding:0px; margin:0px; '>"
	c_Body += "		<table width='100%' border='0' cellspacing='0' cellpadding='0'>"
	c_Body += "			<tr bgcolor='#c7e4ec'>"
	c_Body += "				<td>NOTA</td> "
	c_Body += "				<td>PARCELA</td> "
	c_Body += "				<td>VENCREA</td> "
	c_Body += "				<td>EMISSAO</td> "
	c_Body += "				<td>VALFAT</td> "
	c_Body += "				<td>VALIMP</td> "
	c_Body += "				<td>ANALISTA</td> "
	c_Body += "				<td>CLIENTE</td> "
	c_Body += "				<td>ENDERECO</td> "
	c_Body += "				<td>BAIRRO</td> "
	c_Body += "				<td>CIDADE</td> "
	c_Body += "				<td>ESTADO</td> "
	c_Body += "				<td>CEP</td> "
	c_Body += "				<td>CNPJ</td> "
	c_Body += "				<td>DESCRICAO</td>"
	c_Body += "			</tr>"

	ProcRegua(RecCount())

	While QUERY->(!Eof())

		cAnalistas 	:= ''
		aAnalistas  := {}
		cNotaSerie	:= QUERY->(D2_DOC+D2_SERIE)

		IncProc('Processando NF: '+cNotaSerie+' - Emissao: '+DTOC(QUERY->D2_EMISSAO))

		//TRB->(RecLock('TRB',.T.))

		//TRB->NOTA		:= cNotaSerie
		//TRB->PARCELA 	:= QUERY->E1_PARCELA
		//TRB->EMISSAO	:= QUERY->D2_EMISSAO
		//TRB->VALFAT		:= QUERY->F2_VALFAT
		//TRB->CLIENTE	:= Alltrim(QUERY->A1_COD)+'-'+Alltrim(QUERY->A1_NOME)
		//TRB->ENDERECO	:= QUERY->A1_END
		//TRB->BAIRRO		:= QUERY->A1_BAIRRO
		//TRB->CIDADE		:= QUERY->A1_MUN
		//TRB->ESTADO		:= QUERY->A1_EST
		//TRB->CEP		:= QUERY->A1_CEP
		//TRB->CNPJ		:= QUERY->A1_CGC

		c_Body += "			<tr bgcolor='#c7e4fc'>"
		c_Body += "				<td>" + cNotaSerie + "</td> "
		c_Body += "				<td>" + QUERY->E1_PARCELA + "</td> "
		c_Body += "				<td>" + DTOC( QUERY->D2_EMISSAO ) + "</td> "
		c_Body += "				<td></td> "
		c_Body += "				<td>" + Transform( QUERY->F2_VALFAT, "@e 999,999,999.999" ) + "</td> "
		c_Body += "				<td>" + Alltrim(QUERY->A1_COD)+'-'+Alltrim(QUERY->A1_NOME) + "</td> "
		c_Body += "				<td>" + QUERY->A1_END + "</td> "
		c_Body += "				<td>" + QUERY->A1_BAIRRO + "</td> "
		c_Body += "				<td>" + QUERY->A1_MUN + "</td> "
		c_Body += "				<td>" + QUERY->A1_EST + "</td> "
		c_Body += "				<td>" + QUERY->A1_CEP + "</td> "
		c_Body += "				<td>" + QUERY->A1_CGC + "</td> "

		If lLogocenter

			If !Empty(QUERY->C6_DESCRI)
				//TRB->DESCRICAO	:= QUERY->C6_DESCRI
				c_Body += "				<td>" + QUERY->C6_DESCRI + "</td>"
			EndIf

			If !Empty(QUERY->C6_OSLOGO)
				cAnalistas := fConsultaLogix(Alltrim(QUERY->C6_OSLOGO))
			EndIf

		EndIf

		While QUERY->(!Eof()) .And. QUERY->(D2_DOC+D2_SERIE)==cNotaSerie

			If !lLogocenter
				If aScan( aAnalistas, {|x|x[1] == QUERY->A9_TECNICO })== 0
					Aadd(aAnalistas, {QUERY->A9_TECNICO, Alltrim(QUERY->A9_NOME)} )
				EndIf
			EndIf

			If QUERY->E1_TIPO == 'IN-'
				//TRB->VENCREA	:= QUERY->E1_VENCREA
				//TRB->VALIMP		:= QUERY->E1_VALOR

				c_Body += "				<td>" + Transform( QUERY->E1_VENCREA, "@e 999,999,999.999" ) + "</td> "
				c_Body += "				<td>" + Transform( QUERY->E1_VALOR, "@e 999,999,999.999" ) + "</td> "

			EndIf

			QUERY->(dbSkip())

		EndDo

		If Len(aAnalistas) > 0

			For nX := 1 To Len(aAnalistas)

				cAnalistas += aAnalistas[nX][2]+"; "

			Next nX

		EndIf

		//TRB->ANALISTA	:= cAnalistas
		c_Body += "				<td>" + cAnalistas + "</td> "
		c_Body += "			</tr>"

		//TRB->(MsUnlock())

	EndDo

	c_Body += "		</table>"
	c_Body += "	</body>"
	c_Body += "</html>"

	MemoWrite( "C:\Temp\UNIDADE_ES_" + DTOS( MV_PAR05 ) + ".xls", c_Body )


	//-- Exporta arquivo trabalho
	//If u_CRF01Z( cArqTRB , 'TRB' )
	/*If __CopyFile( "\SYSTEM\" + cArqTRB + ".DBF" , 'C:\INSS_RETIDO_'+'UNIDADE_ES_'+DTOS(MV_PAR05)+'.XLS'  )
	Alert( 'Planilha gerada em: C:\INSS_RETIDO_'+ 'UNIDADE_ES'+'_'+DTOS(MV_PAR05)+'.XLS'  )
	Ferase(cArqTrb+GetDBExtension())
	Ferase(cArqTrb+'.dbf')
	EndIf*/
	//EndIf

	QUERY->(dbCloseArea())
	TRB->(dbCloseArea())
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfConsultaLบAutor  ณTI1970-APENHA       บ Data ณ  11/05/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que retorna o nome do analista do pedido.           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fConsultaLogix(cOSLogo)

	Local cQuery, cAnalista := ''

	//Conexao com o Logix
	TcSetConn(nConexao)

	cQuery 	:= 'SELECT d.cod_funci, d.nom_funci'
	cQuery  += ' FROM pasa@cslpasasoc:gil_atend_cli_web a,'
	cQuery  += ' logix@admlogixsoc:rhu_funcio c,'
	cQuery  += ' pasa@cslpasasoc:funci d'

	cQuery  += ' WHERE a.num_atend_cli ='+cOSLogo
	cQuery  += ' AND a.empresa_funcio = c.empresa'
	cQuery  += ' AND a.filial_funcio = c.filial'
	cQuery  += ' AND a.matricula_funcio = c.matricula'
	cQuery  += ' AND d.num_matricula = c.matricula'

	cQuery  += ' UNION'

	cQuery  += ' SELECT d.cod_funci,d.nom_funci'
	cQuery  += ' FROM pasa@cslpasasoc:gil_atend_cli_web a,'
	cQuery  += '      logix@admlogixsoc:gil_fun_parceiro c,'
	cQuery  += '      pasa@cslpasasoc:funci d'

	cQuery  += ' WHERE a.num_atend_cli    ='+cOSLogo
	cQuery  += ' AND a.empresa_funcio     = c.parceiro'
	cQuery  += ' AND a.filial_funcio      = c.filial'
	cQuery  += ' AND a.matricula_funcio   = c.matricula'
	cQuery  += ' AND d.num_matricula      = c.matricula'
	cQuery  += ' AND NOT EXISTS (SELECT *              '
	cQuery  += '                     FROM rhu_funcio e'
	cQuery  += '                     WHERE e.empresa  = c.parceiro'
	cQuery  += '                     AND e.filial     = c.filial'
	cQuery  += '                     AND e.matricula  = c.matricula)'

	cQuery  += ' UNION'

	cQuery  += ' SELECT d.cod_funci,d.nom_funci'
	cQuery  += ' FROM logix@admlogixsoc:rhu_funcio b,'
	cQuery  += '       logix@admlogixsoc:gil_atend_cli c,'
	cQuery  += '       pasa@cslpasasoc:funci d'

	cQuery  += ' WHERE c.num_atend_cli     ='+cOSLogo
	cQuery  += ' AND c.empresa_funcio     = b.empresa'
	cQuery  += ' AND c.filial_funcio      = b.filial'
	cQuery  += ' AND c.matricula_funcio   = b.matricula'
	cQuery  += ' AND d.num_matricula      = b.matricula'

	cQuery  += ' UNION'

	cQuery  += ' SELECT d.cod_funci,d.nom_funci'
	cQuery  += ' FROM logix@admlogixsoc:gil_fun_parceiro b,'
	cQuery  += '       logix@admlogixsoc:gil_atend_cli c,'
	cQuery  += '       pasa@cslpasasoc:funci d'

	cQuery  += ' WHERE c.num_atend_cli    ='+cOSLogo
	cQuery  += ' AND c.empresa_funcio     = b.parceiro'
	cQuery  += ' AND c.filial_funcio      = b.filial'
	cQuery  += ' AND c.matricula_funcio   = b.matricula'
	cQuery  += ' AND d.num_matricula      = b.matricula'
	cQuery  += ' AND NOT EXISTS (SELECT *			   '
	cQuery  += '                 FROM rhu_funcio e'
	cQuery  += '                 WHERE e.empresa   	= b.parceiro'
	cQuery  += '                 AND e.filial    	= b.filial'
	cQuery  += '                 AND e.matricula 	= b.matricula)'

	cQuery  := ChangeQuery(cQuery)

	TCQUERY cQuery NEW ALIAS "LOGO"

	LOGO->(dbGoTop())

	While LOGO->(!Eof())
		cAnalista += LOGO->nom_funci+"; "
		LOGO->(dbSkip())
	EndDo

	LOGO->(dbCloseArea())

	//Volto a Conexao do DB2 (Totvs)
	TcSetConn(nConMain)

Return(cAnalista)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCriaSx1   บAutor  ณTI1970-APENHA       บ Data ณ  11/05/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaSx1(cPerg,aRegs)

	Local aAreaAtu	:= GetArea()
	Local aAreaSX1	:= SX1->(GetArea())
	Local nJ		:= 0
	Local nY		:= 0

	dbSelectArea("SX1")
	dbSetOrder(1)

	For nY := 1 To Len(aRegs)
		If !MsSeek(Padr(aRegs[nY,1],Len(X1_GRUPO))+aRegs[nY,2])
			RecLock("SX1",.T.)
			For nJ := 1 To FCount()
				If nJ <= Len(aRegs[nY])
					FieldPut(nJ,aRegs[nY,nJ])
				EndIf
			Next nJ
			MsUnlock()
		EndIf
	Next nY

	RestArea(aAreaSX1)
	RestArea(aAreaAtu)

Return

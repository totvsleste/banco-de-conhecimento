#Include "Protheus.ch"
#Include "Ctbxload.ch"
Static lFWCodFil := .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBLoad   ºAutor  ³ALvaro Camillo Neto º Data ³  26/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função de carregamento das configuracoes módulo CTB        º±±
±±º          ³ executada na primeira vez que o usuário entra no módulo    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CTBLoad()
Local lRet	:= .T.
Local aDados := {}
//-------------Para uso com o release 12.1.17--------------------------------
// Esta alteração permite que o campo CTK_HAGLUT ao ser editado possa alterar o campo tamanho (x3_tamanho)
aAdd( aDados, { { 'CTK_HAGLUT' 	}, { { 'X3_RESERV', 'Ö€', 'Æ€' 	} } } )

aAdd( aDados, { { 'CTS_CODPLA' 	}, { { 'X3_WHEN'	, 'INCLUI .or. If(FunName() $ "CTBA160|CTBA161",.F.,.T.)' } } } )
aAdd( aDados, { { 'CTS_ORDEM' 	}, { { 'X3_WHEN'	, 'INCLUI .and. If(FunName() $ "CTBA160|CTBA161",.T.,.F.)' } } } )
aAdd( aDados, { { 'CTS_CONTAG' 	}, { { 'X3_WHEN'	, 'INCLUI .or. If(FunName() $ "CTBA160|CTBA161",.F.,.T.)' } } } )
aAdd( aDados, { { 'CTS_DESCCG' 	}, { { 'X3_WHEN'	, 'If(FunName() $ "CTBA160|CTBA161",.T.,.F.)' } } } )
aAdd( aDados, { { 'CTS_NOME' 	}, { { 'X3_WHEN'	, 'If(FunName() $ "CTBA160|CTBA161",.T.,.F.)' } } } )


//----------------------------------------------------------------------------
// Esta alteração permite que o campo CT8_DESC ao ser editado possa alterar o campo tamanho (x3_tamanho)
aDados := {}

aAdd( aDados, { { 'CT8_DESC' 	}, { { 'X3_RESERV', 'Ö€', '‚€' 	} } } )

EngSX3117( aDados )

//----------------------------------------------------------------------------
aDados := {}

//Retirado a obrigatoriedade do campo - Atendimento Issue DSERCTR1-9439
aAdd( aDados, { { 'CSO_VLRFAT' 	}, { { 'X3_RESERV', 'Ö€', 		} } } )

EngSX3117( aDados )

//----------------------------------------------------------------------------
aDados := {}

//Retirado a obrigatoriedade do campo - Atendimento Issue DSERCTR1-10158
aAdd( aDados, { { 'CQR_PERCON' 	}, { { 'X3_RESERV', 'Ö€', 		} } } )

EngSX3117( aDados )

//----------------------------------------------------------------------------
aDados := {}

//Retirado a obrigatoriedade do campo - Atendimento Issue DSERCTR1-10158
aAdd( aDados, { { 'CQR_PERPAR' 	}, { { 'X3_RESERV', 'Ö€', 		} } } )

EngSX3117( aDados )

//----------------------------------------------------------------------------

ValidCQ()

MsgRun(OemToAnsi(STR0001),OemToAnsi(STR0002),{|| CtbTabelas() }) // "Carregando as configurações do Módulo Contabilidade Gerencial" ## "Aguarde"

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CtbTabelas ºAutor  ³Alvaro Camillo Neto º Data ³  01/12/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza o carregamento das tabelas auxiliares CTB           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CtbTabelas()
Local aArea      := GetArea()
Local cCtbLimc   := GetNewPar( "MV_CTBLIMC", "")
Local cCtbCenc   := GetNewPar( "MV_CTBCENC", "" )
Local aCtbCenc   := {}
Local aLimitDif  := {}
Local nX         := 0

aLimitDif := QuebraParam(cCtbLimc,";")

//Validar conteúdo do parâmetro MV_CTBCENC
If !Empty(aLimitDif)
	If !Empty(cCtbCenc)
		aCtbCenc := QuebraParam(cCtbCenc)
	Else
  		Help( " ", 1, "MV_CTBENC" )//"Favor informar o parâmetro MV_CTBCENC com as entidades contábeis!"
	EndIf

	CtbBenc(aCtbCenc)
EndIf

// Carrega a tabela CVJ
CTBAtuCVJ( xFilial("CVJ") , .F. ) // Fonte CTB.PRW

// Carrega a tabela CVG
ChkCVA() //FONTE CTBA080A

// Carrega a tabela CVA
CTBAtuCVG( xFilial("CVG") , .F. ) // Fonte CTB.PRW

// Carrega a tabela CW0
CW0Load()

// Carrega a tabela CW0
If CtLPCW0Tab()
	CW0LPLoad()
EndIf

CtbIncCV0() // Fonte CTB050

CtbIncCT0() // Fonte CTB0005

// Ajuste pontual do SXB em função de problemas na ferramenta ATUSX
// Deverá ser removido deste ponto após normalizacao da ferramenta
CTBAtuSX5()

//Atualiza campos versão e status das tabelas CVN e CVD.
CtbCVNCVD()	//Fonte CTBA025

RestArea(aArea)
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CW0Load  ºAutor  ³Alvaro Camillo Neto º Data ³  11/19/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcção que realiza a carga da tabela de dados auxiliares   º±±
±±º          ³CTB                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CW0Load()
Local aDados 	:= {}
Local aArea		:= GetArea()
Local nX		:= 0
Local lSeqCorr 	:= UsaSeqCor("CT2/CT5/CTK")
Local cSegofi  	:= GetMv( "MV_SEGOFI" , .F. , "0" )
Local aLivros	  := {}
Local cFilX		:= cFilAnt
Local aSM0 		:= Iif( FindFunction( "AdmAbreSM0" ) , AdmAbreSM0() , {} )
Local nContFil	:= 0
Local cFilProc	:= NIL // Variavel de controle

dbSelectArea("CW0")
CW0->( dbSetOrder( 1 ) ) // CW0_FILIAL + CW0_TABELA + CW0_CHAVE

If cPaisLoc == "PER"
	aAdd(aDados, {"00","P1",STR0113,STR0113,STR0113,STR0113,STR0113})//Peru: Livros Contábeis pré-cadastrados
	aAdd(aDados, {'P1','05',STR0003,STR0003,STR0003,STR0003,STR0003})//'LIVRO DIARIO'
	aAdd(aDados, {'P1','5A',STR0004,STR0004,STR0004,STR0004,STR0004})//'LIVRO DIARIO DE  FORMATO SIMPLIFICADO'
	aAdd(aDados, {'P1','06',STR0005,STR0005,STR0005,STR0005,STR0005})//'LIVRO MAIOR'
	aAdd(aDados, {'P1','07',STR0006,STR0006,STR0006,STR0006,STR0006})//'REGISTRO DE ATIVOS FIXOS'
	aAdd(aDados, {'P1','08',STR0007,STR0007,STR0007,STR0007,STR0007})//'REGISTRO DE COMPRAS'
	aAdd(aDados, {'P1','09',STR0008,STR0008,STR0008,STR0008,STR0008})//'REGISTRO DE CONSIGNACOES'
	aAdd(aDados, {'P1','10',STR0009,STR0009,STR0009,STR0009,STR0009})//'REGISTRO DE CUSTOS'
	aAdd(aDados, {'P1','11',STR0010,STR0010,STR0010,STR0010,STR0010})//'REGISTRO DE HÓSPEDES'
	aAdd(aDados, {'P1','12',STR0011,STR0011,STR0011,STR0011,STR0011})//'REGISTRO DE INVENTARIO PERMANENTE EM UNIDADES FÍSICAS'
	aAdd(aDados, {'P1','13',STR0012,STR0012,STR0012,STR0012,STR0012})//'REGISTRO DE INVENTARIO PERMANENTE VALORIZADO'
	aAdd(aDados, {'P1','14',STR0013,STR0013,STR0013,STR0013,STR0013})//'REGISTRO DE VENDAS E ENTRADA'
	aAdd(aDados, {'P1','15',STR0014,STR0014,STR0014,STR0014,STR0014})//'REGISTRO DE VENTAS E ENTRADA - ARTIGO 23° RESOLUCAO DE SUPERINTENDENCIA N° 266-2004/SUNAT'
	aAdd(aDados, {'P1','16',STR0015,STR0015,STR0015,STR0015,STR0015})//'REGISTRO DE REGIME DE PERCEPCOES'
	aAdd(aDados, {'P1','17',STR0016,STR0016,STR0016,STR0016,STR0016})//'REGISTRO DE REGIME DE RETENCAO'
	aAdd(aDados, {'P1','18',STR0017,STR0017,STR0017,STR0017,STR0017})//'REGISTRO DE RETENCOES ARTIGO 77-DA LEI DE IMPOSTO DE RENDA'
	aAdd(aDados, {'P1','19',STR0018,STR0018,STR0018,STR0018,STR0018})//'REGISTRO IVAP'
	aAdd(aDados, {'P1','20',STR0019,STR0019,STR0019,STR0019,STR0019})//'REGISTRO(S) AUXILIAR(ES) DE AQUISICOES - ARTIGO 8° RESOLUCAO DA SUPERINTENDENCIA N° 022-98/SUNAT'
	aAdd(aDados, {'P1','21',STR0020,STR0020,STR0020,STR0020,STR0020})//'REGISTRO(S) AUXILIAR(ES) DE AQUISICOES - INCISO A) PRIMEIRO PÁRAGRAFO ARTIGO 5° RESOLUCÃO DE SUPERINTENDENCIA N° 021-99/SUNAT'
	aAdd(aDados, {'P1','22',STR0021,STR0021,STR0021,STR0021,STR0021})//'REGISTRO(S) AUXILIAR(ES) DE AQUISICÕES - INCISO A) PRIMEIRO PÁRAGRAFO ARTIGO 5° RESOLUCAODE SUPERINTENDENCIA N° 142-2001/SUNAT'
	aAdd(aDados, {'P1','23',STR0022,STR0022,STR0022,STR0022,STR0022})//'REGISTRO(S) AUXILIAR(ES) DE AQUISICÕES - INCISO C) PRIMEIRO PÁRAGRAFO ARTIGO 5° RESOLUCAODE SUPERINTENDENCIA N° 256-2004/SUNAT'
	aAdd(aDados, {'P1','24',STR0023,STR0023,STR0023,STR0023,STR0023})//'REGISTRO(S) AUXILIAR(ES) DE AQUISICÕES - INCISO A) PRIMEIRO PÁRAGRAFO ARTIGO 5° RESOLUCAODE SUPERINTENDENCIA N° 257-2004/SUNAT'
	aAdd(aDados, {'P1','25',STR0024,STR0024,STR0024,STR0024,STR0024})//'REGISTRO(S) AUXILIAR(ES)  DE AQUISICÕES - INCISO C) PRIMEIRO PÁRAGRAFO ARTIGO 5° RESOLUCAO DE SUPERINTENDENCIA N° 258-2004/SUNAT'
	aAdd(aDados, {'P1','26',STR0025,STR0025,STR0025,STR0025,STR0025})//'REGISTRO(S) AUXILIAR(ES)  DE AQUISICÕES - INCISO A) PRIMEIRO PÁRAGRAFO ARTIGO 5° RESOLUCAO DE SUPERINTENDENCIA N° 259-2004/SUNAT'
	aAdd(aDados, {'P1','27',STR0026,STR0026,STR0026,STR0026,STR0026})//'LIVRO DE ATAS DA EMPRESA INDIVIDUAL DE RESPONSABILIDADE LIMITADA'
	aAdd(aDados, {'P1','28',STR0027,STR0027,STR0027,STR0027,STR0027})//'LIVRO DE ATAS DA JUNTA GERAL DE ACIONISTAS'
	aAdd(aDados, {'P1','29',STR0028,STR0028,STR0028,STR0028,STR0028})//'LIVRO DE ATAS DO DIRETORIO'
	aAdd(aDados, {'P1','30',STR0029,STR0029,STR0029,STR0029,STR0029})//'LIVRO DE MATRÍCULA DE ACOES'
	aAdd(aDados, {'P1','31',STR0030,STR0030,STR0030,STR0030,STR0030})//'LIVRO DE PLANILHAS'

	aAdd(aDados, {"00","P2",STR0031,STR0031,STR0031,STR0031,STR0031}) //Peru: Livros Contábeis x Processos
	aAdd(aDados, {'P2','07',"010/020/030/040/050/060/070/080/090","010/020/030/040/050/060/070/080/090","010/020/030/040/050/060/070/080/090","010/020/030/040/050/060/070/080/090","010/020/030/040/050/060/070/080/090"})
	aAdd(aDados, {'P2','08',"400","400","400","400","400"})
	aAdd(aDados, {'P2','10',"100/110/130","100/110/130","100/110/130","100/110/130","100/110/130"})
	aAdd(aDados, {'P2','14',"410/440","410/440","410/440","410/440","410/440"})

	aAdd(aDados, {"00","P3",STR0125,STR0125,STR0125,STR0125,STR0125})  //Peru - TABLA 3: ENTIDAD FINANCIERA
	aAdd(aDados, {'P3','00',STR0126,STR0126,STR0126,STR0126,STR0126})
	aAdd(aDados, {'P3','02',STR0127,STR0127,STR0127,STR0127,STR0127})
	aAdd(aDados, {'P3','03',STR0128,STR0128,STR0128,STR0128,STR0128})
	aAdd(aDados, {'P3','05',STR0129,STR0129,STR0129,STR0129,STR0129})
	aAdd(aDados, {'P3','07',STR0130,STR0130,STR0130,STR0130,STR0130})
	aAdd(aDados, {'P3','08',STR0131,STR0131,STR0131,STR0131,STR0131})
	aAdd(aDados, {'P3','09',STR0132,STR0132,STR0132,STR0132,STR0132})
	aAdd(aDados, {'P3','11',STR0133,STR0133,STR0133,STR0133,STR0133})
	aAdd(aDados, {'P3','12',STR0134,STR0134,STR0134,STR0134,STR0134})
	aAdd(aDados, {'P3','16',STR0135,STR0135,STR0135,STR0135,STR0135})
	aAdd(aDados, {'P3','18',STR0136,STR0136,STR0136,STR0136,STR0136})
	aAdd(aDados, {'P3','22',STR0137,STR0137,STR0137,STR0137,STR0137})
	aAdd(aDados, {'P3','23',STR0138,STR0138,STR0138,STR0138,STR0138})
	aAdd(aDados, {'P3','25',STR0139,STR0139,STR0139,STR0139,STR0139})
	aAdd(aDados, {'P3','26',STR0140,STR0140,STR0140,STR0140,STR0140})
	aAdd(aDados, {'P3','29',STR0141,STR0141,STR0141,STR0141,STR0141})
	aAdd(aDados, {'P3','35',STR0142,STR0142,STR0142,STR0142,STR0142})
	aAdd(aDados, {'P3','37',STR0143,STR0143,STR0143,STR0143,STR0143})
	aAdd(aDados, {'P3','38',STR0144,STR0144,STR0144,STR0144,STR0144})
	aAdd(aDados, {'P3','39',STR0145,STR0145,STR0145,STR0145,STR0145})
	aAdd(aDados, {'P3','40',STR0146,STR0146,STR0146,STR0146,STR0146})
	aAdd(aDados, {'P3','41',STR0147,STR0147,STR0147,STR0147,STR0147})
	aAdd(aDados, {'P3','42',STR0148,STR0148,STR0148,STR0148,STR0148})
	aAdd(aDados, {'P3','43',STR0149,STR0149,STR0149,STR0149,STR0149})
	aAdd(aDados, {'P3','44',STR0150,STR0150,STR0150,STR0150,STR0150})
	aAdd(aDados, {'P3','45',STR0151,STR0151,STR0151,STR0151,STR0151})
	aAdd(aDados, {'P3','46',STR0152,STR0152,STR0152,STR0152,STR0152})
	aAdd(aDados, {'P3','47',STR0153,STR0153,STR0153,STR0153,STR0153})
	aAdd(aDados, {'P3','48',STR0154,STR0154,STR0154,STR0154,STR0154})
	aAdd(aDados, {'P3','49',STR0155,STR0155,STR0155,STR0155,STR0155})
	aAdd(aDados, {'P3','50',STR0156,STR0156,STR0156,STR0156,STR0156})
	aAdd(aDados, {'P3','51',STR0157,STR0157,STR0157,STR0157,STR0157})
	aAdd(aDados, {'P3','52',STR0158,STR0158,STR0158,STR0158,STR0158})
	aAdd(aDados, {'P3','53',STR0159,STR0159,STR0159,STR0159,STR0159})
	aAdd(aDados, {'P3','54',STR0160,STR0160,STR0160,STR0160,STR0160})
	aAdd(aDados, {'P3','55',STR0161,STR0161,STR0161,STR0161,STR0161})
	aAdd(aDados, {'P3','56',STR0162,STR0162,STR0162,STR0162,STR0162})
	aAdd(aDados, {'P3','57',STR0163,STR0163,STR0163,STR0163,STR0163})
	aAdd(aDados, {'P3','58',STR0164,STR0164,STR0164,STR0164,STR0164})
	aAdd(aDados, {'P3','59',STR0165,STR0165,STR0165,STR0165,STR0165})
	aAdd(aDados, {'P3','60',STR0166,STR0166,STR0166,STR0166,STR0166})
	aAdd(aDados, {'P3','61',STR0167,STR0167,STR0167,STR0167,STR0167})
	aAdd(aDados, {'P3','62',STR0168,STR0168,STR0168,STR0168,STR0168})
	aAdd(aDados, {'P3','63',STR0169,STR0169,STR0169,STR0169,STR0169})
	aAdd(aDados, {'P3','64',STR0170,STR0170,STR0170,STR0170,STR0170})
	aAdd(aDados, {'P3','65',STR0171,STR0171,STR0171,STR0171,STR0171})
	aAdd(aDados, {'P3','66',STR0172,STR0172,STR0172,STR0172,STR0172})
	aAdd(aDados, {'P3','67',STR0173,STR0173,STR0173,STR0173,STR0173})
	aAdd(aDados, {'P3','68',STR0174,STR0174,STR0174,STR0174,STR0174})
	aAdd(aDados, {'P3','69',STR0175,STR0175,STR0175,STR0175,STR0175})
	aAdd(aDados, {'P3','70',STR0176,STR0176,STR0176,STR0176,STR0176})
	aAdd(aDados, {'P3','71',STR0177,STR0177,STR0177,STR0177,STR0177})
	aAdd(aDados, {'P3','72',STR0178,STR0178,STR0178,STR0178,STR0178})
	aAdd(aDados, {'P3','73',STR0179,STR0179,STR0179,STR0179,STR0179})
	aAdd(aDados, {'P3','74',STR0180,STR0180,STR0180,STR0180,STR0180})
	aAdd(aDados, {'P3','75',STR0181,STR0181,STR0181,STR0181,STR0181})
	aAdd(aDados, {'P3','76',STR0182,STR0182,STR0182,STR0182,STR0182})
	aAdd(aDados, {'P3','77',STR0183,STR0183,STR0183,STR0183,STR0183})
	aAdd(aDados, {'P3','78',STR0184,STR0184,STR0184,STR0184,STR0184})
	aAdd(aDados, {'P3','79',STR0185,STR0185,STR0185,STR0185,STR0185})
	aAdd(aDados, {'P3','80',STR0186,STR0186,STR0186,STR0186,STR0186})
	aAdd(aDados, {'P3','81',STR0187,STR0187,STR0187,STR0187,STR0187})
	aAdd(aDados, {'P3','82',STR0188,STR0188,STR0188,STR0188,STR0188})
	aAdd(aDados, {'P3','99',STR0189,STR0189,STR0189,STR0189,STR0189})

	aAdd(aDados, {"00","P4",STR0121,STR0121,STR0121,STR0121,STR0121}) //Peru TABLA 4: TIPO DE MONEDA
	aAdd(aDados, {'P4','1',STR0122,STR0122,STR0122,STR0122,STR0122})
	aAdd(aDados, {'P4','2',STR0123,STR0123,STR0123,STR0123,STR0123})
	aAdd(aDados, {'P4','9',STR0124,STR0124,STR0124,STR0124,STR0124})

	aAdd(aDados, {"00","P5",STR0115,STR0115,STR0115,STR0115,STR0115}) //Peru TABLA 2:TIPO DE DOCUMENTO DE IDENTIDAD
	aAdd(aDados, {'P5','0',STR0116,STR0116,STR0116,STR0116,STR0116})
	aAdd(aDados, {'P5','1',STR0117,STR0117,STR0117,STR0117,STR0117})
	aAdd(aDados, {'P5','4',STR0118,STR0118,STR0118,STR0118,STR0118})
	aAdd(aDados, {'P5','6',STR0119,STR0119,STR0119,STR0119,STR0119})
	aAdd(aDados, {'P5','7',STR0120,STR0120,STR0120,STR0120,STR0120})


	//Prenche o array para criar os livros contábeis
	aAdd(aLivros,{'07',STR0006})
	aAdd(aLivros,{'08',STR0007})
	aAdd(aLivros,{'10',STR0009})
	aAdd(aLivros,{'14',STR0013})

EndIf

aAdd(aDados, {"00","01",STR0112,STR0112,STR0112,STR0112,STR0112})// Módulos do Sistema
aAdd(aDados, {'01','01',STR0032,STR0032,STR0032,STR0032,STR0032})//'Ativo Fixo'
aAdd(aDados, {'01','02',STR0033,STR0033,STR0033,STR0033,STR0033})//'Compras'
aAdd(aDados, {'01','03',STR0034,STR0034,STR0034,STR0034,STR0034})//'Contabilidade'
aAdd(aDados, {'01','04',STR0035,STR0035,STR0035,STR0035,STR0035})//'Estoque'
aAdd(aDados, {'01','05',STR0036,STR0036,STR0036,STR0036,STR0036})//'Faturamento'
aAdd(aDados, {'01','06',STR0037,STR0037,STR0037,STR0037,STR0037})//'Financeiro'
aAdd(aDados, {'01','07',STR0038,STR0038,STR0038,STR0038,STR0038})//'Gest„o de Pessoal'
aAdd(aDados, {'01','08',STR0039,STR0039,STR0039,STR0039,STR0039})//'Faturamento de Servi‡o'
aAdd(aDados, {'01','08',STR0040,STR0040,STR0040,STR0040,STR0040})//'Livros Fiscais'
aAdd(aDados, {'01','10',STR0041,STR0041,STR0041,STR0041,STR0041})//'Planejamento e Controle de Produ‡„o'
aAdd(aDados, {'01','11',STR0042,STR0042,STR0042,STR0042,STR0042})//'Veiculos'
aAdd(aDados, {'01','12',STR0043,STR0043,STR0043,STR0043,STR0043})//'Controle de Lojas'
aAdd(aDados, {'01','13',STR0044,STR0044,STR0044,STR0044,STR0044})//'Telemarketing'
aAdd(aDados, {'01','14',STR0045,STR0045,STR0045,STR0045,STR0045})//'Oficina'
aAdd(aDados, {'01','15',STR0046,STR0046,STR0046,STR0046,STR0046})//'Protheus Report Utility'
aAdd(aDados, {'01','16',STR0047,STR0047,STR0047,STR0047,STR0047})//'Ponto Eletronico'
aAdd(aDados, {'01','17',STR0048,STR0048,STR0048,STR0048,STR0048})//'Controle de Importa‡„o'
aAdd(aDados, {'01','18',STR0049,STR0049,STR0049,STR0049,STR0049})//'Gest„o de Recursos Humanos'
aAdd(aDados, {'01','19',STR0050,STR0050,STR0050,STR0050,STR0050})//'Manuten‡„o Industrial'
aAdd(aDados, {'01','20',STR0051,STR0051,STR0051,STR0051,STR0051})//'Recrutamento e Sele‡„o Pessoal'
aAdd(aDados, {'01','21',STR0052,STR0052,STR0052,STR0052,STR0052})//'Inspeção de Entradas'
aAdd(aDados, {'01','22',STR0053,STR0053,STR0053,STR0053,STR0053})//'Metrologia'
aAdd(aDados, {'01','23',STR0054,STR0054,STR0054,STR0054,STR0054})//'Front Loja'
aAdd(aDados, {'01','24',STR0055,STR0055,STR0055,STR0055,STR0055})//'Controle de Documentos'
aAdd(aDados, {'01','25',STR0056,STR0056,STR0056,STR0056,STR0056})//'Inspecao de Processos'
aAdd(aDados, {'01','26',STR0057,STR0057,STR0057,STR0057,STR0057})//'Treinamento'
aAdd(aDados, {'01','27',STR0058,STR0058,STR0058,STR0058,STR0058})//'Importa‡„o - Financeiro'
aAdd(aDados, {'01','28',STR0059,STR0059,STR0059,STR0059,STR0059})//'Assistˆncia T‚cnica'
aAdd(aDados, {'01','29',STR0060,STR0060,STR0060,STR0060,STR0060})//'Easy Export Control'
aAdd(aDados, {'01','30',STR0061,STR0061,STR0061,STR0061,STR0061})//'Easy Financing'
aAdd(aDados, {'01','31',STR0062,STR0062,STR0062,STR0062,STR0062})//'Easy Accounting'
aAdd(aDados, {'01','32',STR0063,STR0063,STR0063,STR0063,STR0063})//'Administracao de forca de vendas'
aAdd(aDados, {'01','33',STR0064,STR0064,STR0064,STR0064,STR0064})//'Plano de Saude'
aAdd(aDados, {'01','34',STR0065,STR0065,STR0065,STR0065,STR0065})//'Contabilidade Gerencial'
aAdd(aDados, {'01','35',STR0066,STR0066,STR0066,STR0066,STR0066})//'Medicina e Segurança do Trabalho'
aAdd(aDados, {'01','36',STR0067,STR0067,STR0067,STR0067,STR0067})//'Controle de nao conformidade'
aAdd(aDados, {'01','37',STR0068,STR0068,STR0068,STR0068,STR0068})//'Controle de auditoria'
aAdd(aDados, {'01','38',STR0069,STR0069,STR0069,STR0069,STR0069})//'Controle estatistico de processos'
aAdd(aDados, {'01','39',STR0070,STR0070,STR0070,STR0070,STR0070})//'Distribution'
aAdd(aDados, {'01','40',STR0071,STR0071,STR0071,STR0071,STR0071})//'Cargos e Salario'
aAdd(aDados, {'01','41',STR0072,STR0072,STR0072,STR0072,STR0072})//'Auto Pecas'
aAdd(aDados, {'01','42',STR0073,STR0073,STR0073,STR0073,STR0073})//'WMS - Gestao de armazenagem'
aAdd(aDados, {'01','43',STR0074,STR0074,STR0074,STR0074,STR0074})//'TMS - Gestao de Transporte'
aAdd(aDados, {'01','44',STR0075,STR0075,STR0075,STR0075,STR0075})//'TMS - Gestao de Transporte'
aAdd(aDados, {'01','45',STR0076,STR0076,STR0076,STR0076,STR0076})//'TMS - Gestao de Transporte'
aAdd(aDados, {'01','46',STR0077,STR0077,STR0077,STR0077,STR0077})//'Automacao coleta de dados'
aAdd(aDados, {'01','47',STR0078,STR0078,STR0078,STR0078,STR0078})//'PPAP'
aAdd(aDados, {'01','48',STR0079,STR0079,STR0079,STR0079,STR0079})//'REPLICA'
aAdd(aDados, {'01','49',STR0080,STR0080,STR0080,STR0080,STR0080})//'Gestao Educacional'
aAdd(aDados, {'01','50',STR0081,STR0081,STR0081,STR0081,STR0081})//'Easy Drawback Control'
aAdd(aDados, {'01','51',STR0082,STR0082,STR0082,STR0082,STR0082})//'Gestao Hospitalar'
aAdd(aDados, {'01','52',STR0083,STR0083,STR0083,STR0083,STR0083})//'Viewer'
aAdd(aDados, {'01','53',STR0084,STR0084,STR0084,STR0084,STR0084})//'Avaliacao e Pesquisa de desempenho'
aAdd(aDados, {'01','54',STR0085,STR0085,STR0085,STR0085,STR0085})//'Gestao de Prefeituras'
aAdd(aDados, {'01','55',STR0086,STR0086,STR0086,STR0086,STR0086})//'Sistema de Fidelização e Análise de Crédito'
aAdd(aDados, {'01','56',STR0087,STR0087,STR0087,STR0087,STR0087})//'Sistema de Gestão Ambiental'
aAdd(aDados, {'01','57',STR0088,STR0088,STR0088,STR0088,STR0088})//'Planejamento e Controle Orcamentario.'
aAdd(aDados, {'01','58',STR0089,STR0089,STR0089,STR0089,STR0089})//'Gerenciamento de Pesquisa e Resultado'
aAdd(aDados, {'01','59',STR0090,STR0090,STR0090,STR0090,STR0090})//'Gestão de Acervos '
aAdd(aDados, {'01','60',STR0091,STR0091,STR0091,STR0091,STR0091})//'SIGAHEO'
aAdd(aDados, {'01','61',STR0092,STR0092,STR0092,STR0092,STR0092})//'SIGAHGP'
aAdd(aDados, {'01','62',STR0093,STR0093,STR0093,STR0093,STR0093})//'SIGAHHG'
aAdd(aDados, {'01','63',STR0094,STR0094,STR0094,STR0094,STR0094})//'SIGAHPL'
aAdd(aDados, {'01','64',STR0095,STR0095,STR0095,STR0095,STR0095})//'Processos Trabalhistas'
aAdd(aDados, {'01','65',STR0096,STR0096,STR0096,STR0096,STR0096})//'Gestao Advocaticia'
aAdd(aDados, {'01','66',STR0097,STR0097,STR0097,STR0097,STR0097})//'Gestão de Riscos e Sarbanes-Oxley'
aAdd(aDados, {'01','67',STR0098,STR0098,STR0098,STR0098,STR0098})//'Gestao Agricola'
aAdd(aDados, {'01','68',STR0099,STR0099,STR0099,STR0099,STR0099})//'Gestao de Armazens Gerais'
aAdd(aDados, {'01','69',STR0100,STR0100,STR0100,STR0100,STR0100})//'Gestão de Contratos'
aAdd(aDados, {'01','70',STR0101,STR0101,STR0101,STR0101,STR0101})//'Arquitetura Organizacional'
aAdd(aDados, {'01','71',STR0102,STR0102,STR0102,STR0102,STR0102})//'Locação de Veículos'
aAdd(aDados, {'01','72',STR0103,STR0103,STR0103,STR0103,STR0103})//'Photo'
aAdd(aDados, {'01','73',STR0104,STR0104,STR0104,STR0104,STR0104})//'CRM'
aAdd(aDados, {'01','74',STR0105,STR0105,STR0105,STR0105,STR0105})//'BPM'
aAdd(aDados, {'01','75',STR0106,STR0106,STR0106,STR0106,STR0106})//'Apontamento'
aAdd(aDados, {'01','76',STR0107,STR0107,STR0107,STR0107,STR0107})//'Gestão Jurídica'
aAdd(aDados, {'01','77',STR0108,STR0108,STR0108,STR0108,STR0108})//'Pré faturamento de serviço'
aAdd(aDados, {'01','97',STR0109,STR0109,STR0109,STR0109,STR0109})//'Espec¡ficos'
aAdd(aDados, {'01','98',STR0110,STR0110,STR0110,STR0110,STR0110})//'Espec¡ficos I'
aAdd(aDados, {'01','96',STR0111,STR0111,STR0111,STR0111,STR0111})//'Espec¡ficos II '

If cPaisLoc == "COL"
	//Tabelas para idenficação de Terceiros (Conforme a resolução DIAN 004837/2008, artigo 23)
	aAdd(aDados, {"00","C1",STR0190,STR0190,STR0190,STR0190,STR0190})// Tipo de Terceiro
	aAdd(aDados, {'C1','01',STR0191,STR0191,STR0191,STR0191,STR0191})//'Clientes'
	aAdd(aDados, {'C1','02',STR0192,STR0192,STR0192,STR0192,STR0192})//'Fornecedores'
	aAdd(aDados, {'C1','03',STR0193,STR0193,STR0193,STR0193,STR0193})//'Funcionários'
	aAdd(aDados, {'C1','04',STR0194,STR0194,STR0194,STR0194,STR0194})//'Sócios'
EndIf

//Tabela de apuração de resultado
aAdd(aDados, {"00","LP","APURACAO DE LUCROS E PERDAS","APURACAO DE LUCROS E PERDAS","APURACAO DE LUCROS E PERDAS","APURACAO DE LUCROS E PERDAS","APURACAO DE LUCROS E PERDAS"})// Tipo de Terceiro

For nContFil := 1 to Len(aSM0)
	If aSM0[nContFil][SM0_GRPEMP] != cEmpAnt
		Loop
	EndIf

	cFilAnt := aSM0[nContFil][SM0_CODFIL]

	// Tratativa para a gestão corporativa
	If cFilProc==NIL .or. Alltrim(cFilProc) != Alltrim(xFilial("CW0"))
		cFilProc:= xFilial("CW0")
	Else
		Loop
	EndIf

	// Realiza a gravação das tabelas
  	For nX := 1 to Len(aDados)
		If !CW0->( MsSeek( xFilial("CW0") + aDados[nx][1] + aDados[nx][2] ) )
			RecLock("CW0",.T.)
				CW0->CW0_FILIAL :=  xFilial("CW0")
				CW0->CW0_TABELA :=  aDados[nx][1]
				CW0->CW0_CHAVE  :=  aDados[nx][2]
				CW0->CW0_DESC01 :=  aDados[nx][3]
				CW0->CW0_DESC02 :=  aDados[nx][4]
				CW0->CW0_DESC03 :=  aDados[nx][5]
				CW0->CW0_DESC04 :=  aDados[nx][6]
				CW0->CW0_DESC05 :=  aDados[nx][7]
			MsUnlock()
		EndIf
	Next

	If lSeqCorr .And. !Empty(aLivros) .And. cSegOfi == '7'
		CVMIncProc(aLivros)
	EndIf
Next nContFil

cFilAnt := cFilX
RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CVMIncProcºAutor  ³Alvaro Camillo Neto º Data ³  19/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inclui os livros Diarios por processo                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CVMIncProc(aLivros)
Local aArea 	:= GetArea()
Local aDiarios := {}
Local aCVM		:= {}
Local cSeqIni 	:= STRZERO(1,TamSX3("CVM_SEQULT")[1])
Local cSeqFim	:= ""
Local dDtIni	:= Stod( cValtoChar(Year(dDataBase) ) + "0101" )
Local dDtFim	:= Stod( cValtoChar(Year(dDataBase) ) + "1231" )
Local cSegOfi 	:= "07"
Local cRad 		:= "01"
Local cCalend 	:= ""
Local nX			:= 0

For nX := 1 to Len(aLivros)
	aCVM := { xFilial( "CVM" );
				, aLivros[nX][1] ;
				, aLivros[nX][2] ;
				, cSegOfi ;
				, dDtIni;
				, dDtFim;
				, StoD( "  /  /  " );
				, cSeqIni;
				, cSeqFim;
				, 1;
				, cRad;
				, cCalend;
				}
	aAdd(aDiarios,aCVM)
Next nX

// Livro Diversos - 99
aCVM := { xFilial( "CVM" );
			, "99" ;
			, STR0114; // Livro Diário
			, cSegOfi ;
			, dDtIni;
			, dDtFim;
			, StoD( "  /  /  " );
			, cSeqIni;
			, cSeqFim;
			, 1;
			, cRad;
			, cCalend;
			}

aAdd(aDiarios,aCVM)

//Grava os Livros Contábeis
For nX:= 1 to Len(aDiarios)
	CreateCvm( aDiarios[nX] )
Next nX

RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CTBAtuSX5ºAutor  ³ José Lucas         º Data ³  20/07/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função que realiza a carga da tabela SX5 para a tabela TB. º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CTBAtuSX5()
Local aDados 	:= {}
Local aArea		:= GetArea()
Local nX		:= 0

SX5->(dbSelectArea("SX5"))
SX5->(dbSetOrder(1)) 		// SX5->X5_FILIAL + SX5->X5_TABELA + SX5->X5_CHAVE

If cPaisLoc == "COL"
	//Tabela para idenficação do Tipo de Documento de Terceiros (Conforme a resolução DIAN 004837/2008, artigo 23)
	AADD(aDados,{"00","TB","TIPOS DE DOCUMENTO"  		    ,"TIPOS DE DOCUMENTO" 		  		,"DOCUMENT TYPES"  })
	AADD(aDados,{"TB","11","Registro Civil de Nascimento"  	,"Registro Civil de Nascimiento"	,"Record Born Date"    })
	AADD(aDados,{"TB","12","Cartão de Identidade"		    ,"Cedula de Identidad"	      		,"Id. Card"  })
	AADD(aDados,{"TB","13","Cédula de Cidadania"		    ,"Cedula de Ciudadania"	      		,"Citizen Card"    })
	AADD(aDados,{"TB","21","Cartão Id. de Estrageiros"     	,"Tarjeta de Extranjeria" 	  		,"Foreigen Id. Card"   })
	AADD(aDados,{"TB","22","Cédula para Id. de Estrangeios"	,"Cedula de Extranjeria"	  		,"Foreigen Id. Document"   })
	AADD(aDados,{"TB","31","N.I.T."						    ,"N.I.T." 					  		,"N.I.T."   })
	AADD(aDados,{"TB","41","Passaporte"						,"Pasaporte"			 	 		,"Passport"   })
	AADD(aDados,{"TB","42","Documento Estrangeiro"		    ,"Documento Extranjero" 	  		,"Foreigen Document"   })
	AADD(aDados,{"TB","43","Sem identificação do Exterior" 	,"Sin identificación del Exterior"	,"No Foreigen Id. Document"   })
EndIf
If cPaisLoc == "PER"
	//Tabela para idenficação do Tipo de Documento de Terceiros , incluir somente o "06" e "00" .
	AADD(aDados,{"00","TB","TIPOS DE DOCUMENTO","TIPOS DE DOCUMENTO","DOCUMENT TYPES" })
	AADD(aDados,{"TB","06","Registro Unico de Contribuinte","Registro Unico de Contribuyente" ,"R.U.C" })
	AADD(aDados,{"TB","00","Outros Tipos de Documentos","Otros Tipos de Documentos","Others Documents Type" })
EndIf

// Realiza a gravação na tabela SX5.
For nX := 1 to Len(aDados)
	If ! SX5->( MsSeek( xFilial("SX5") + aDados[nx][1] + aDados[nx][2] ) )
		RecLock("SX5",.T.)
			SX5->X5_FILIAL  :=  xFilial("SX5")
			SX5->X5_TABELA  :=  aDados[nX][1]
			SX5->X5_CHAVE   :=  aDados[nX][2]
			SX5->X5_DESCRI  :=  aDados[nX][3]
			SX5->X5_DESCSPA :=  aDados[nX][4]
			SX5->X5_DESCENG :=  aDados[nX][5]
		MsUnlock()
	EndIf
Next
RestArea(aArea)
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} CtbBenc
Valida a informação do parametro.

@author David Moraes

@Param aRet Array com a informação do parâmetro MV_CTBLIMC

@Return lRet Retorna se efetua a gravação
@since 11/02/2014
@version 1.0
/*/
//-------------------------------------------------------------------
Function CtbBenc(aEntCont)
Local aArea      := GetArea()
Local lRet       := .T.
Local nX         := 0
Local nEntidades := CtbQtdEntd()

//Ajusta o array
If Len(aEntCont) < 9
	For nX := Len(aEntCont)+1 To 9
		AADD(aEntCont,"")
	Next nX
EndIf

CT1->(DbSelectArea( "CT1" ))
CT1->(DbSetOrder( 1 ))//Conta Contabil
If !CT1->(DbSeek(xFilial('CT1')+aEntCont[1])) .Or. Empty(aEntCont)
	Help( " ", 1, "CONTACONT" )//Informe uma Conta Contábil válida no parâmetro MV_CTBCENC.
	Return .F.
EndIf

If !Empty(Alltrim(aEntCont[2])) .Or. CT1->CT1_CCOBRG == "1"
	CTT->(DbSelectArea( "CTT" ))
	CTT->(DbSetOrder( 1 ))//Centro de Custo
	If !CTT->(DbSeek(xFilial('CTT')+Alltrim(aEntCont[2])))
		Help( " ", 1, "CENTROCUSTO" )//Informe uma Centro de Custo válido no parâmetro MV_CTBCENC.
		Return .F.
	EndIf
EndIf

If !Empty(Alltrim(aEntCont[3])) .Or. CT1->CT1_ITOBRG == "1"
	CTD->(DbSelectArea( "CTD" ))
	CTD->(DbSetOrder( 1 ))//Item Contabil
	If !CTD->(DbSeek(xFilial('CTD')+Alltrim(aEntCont[3])))
		Help( " ", 1, "ITEMCONTABIL" )//Informe um Item Contábil válido no parâmetro MV_CTBCENC.
		Return .F.
	EndIf
EndIf

If !Empty(Alltrim(aEntCont[4])).Or. CT1->CT1_CLOBRG == "1"
	CTH->(DbSelectArea( "CTH" ))
	CTH->(DbSetOrder( 1 ))//Classe de valor
	If !CTH->(DbSeek(xFilial('CTH')+Alltrim(aEntCont[4])))
		Help( " ", 1, "CLASSEVALOR" )//Informe uma Classe de Valor válida no parâmetro MV_CTBCENC!
		Return .F.
	EndIf
EndIf

If nEntidades >= 5
	If !Empty(aEntCont[5]) .Or. CT1->CT1_05OBRG	== "1"//Obrigatório
		CV0->(DbSelectArea( "CV0" ))
		CV0->(DbSetOrder( 2 ))//Codigo
		If !CV0->(DbSeek(xFilial("CV0")+Alltrim(aEntCont[5])))
			Help( " ", 1, "ENTIDADECONT" )//Informe uma Entidade Contábil válida no parâmetro MV_CTBCENC!
			Return .F.
		EndIf
	EndIf
EndIf

If nEntidades >= 6
	If !Empty(aEntCont[6]) .Or. CT1->CT1_06OBRG	== "1"//Obrigatório
		CV0->(DbSelectArea( "CV0" ))
		CV0->(DbSetOrder( 2 ))//Codigo
		If !CV0->(DbSeek(xFilial("CV0")+Alltrim(aEntCont[6])))
			Help( " ", 1, "ENTIDADECONT" )//Informe uma Entidade Contábil válida no parâmetro MV_CTBCENC!
			Return .F.
		EndIf
	EndIf
EndIf

If nEntidades >= 7
	If !Empty(aEntCont[7]) .Or. CT1->CT1_07OBRG	== "1"//Obrigatório
		CV0->(DbSelectArea( "CV0" ))
		CV0->(DbSetOrder( 2 ))//Codigo
		If !CV0->(DbSeek(xFilial("CV0")+Alltrim(aEntCont[7])))
			Help( " ", 1, "ENTIDADECONT" )//Informe uma Entidade Contábil válida no parâmetro MV_CTBCENC!
			Return .F.
		EndIf
	EndIf
EndIf

If nEntidades >= 8
	If !Empty(aEntCont[8]) .Or. CT1->CT1_08OBRG	== "1"//Obrigatório
		CV0->(DbSelectArea( "CV0" ))
		CV0->(DbSetOrder( 2 ))//Codigo
		If !CV0->(DbSeek(xFilial("CV0")+Alltrim(aEntCont[8])))
			Help( " ", 1, "ENTIDADECONT" )//Informe uma Entidade Contábil válida no parâmetro MV_CTBCENC!
			Return .F.
		EndIf
	EndIf
EndIf

If nEntidades >= 9
	If !Empty(aEntCont[9]) .Or. CT1->CT1_09OBRG	== "1"//Obrigatório
		CV0->(DbSelectArea( "CV0" ))
		CV0->(DbSetOrder( 2 ))//Codigo
		If !CV0->(DbSeek(xFilial("CV0")+Alltrim(aEntCont[9])))
			Help( " ", 1, "ENTIDADECONT" )//Informe uma Entidade Contábil válida no parâmetro MV_CTBCENC!
			Return .F.
		EndIf
	EndIf
EndIf

RestArea(aArea)

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} ValidCQ
Valida se existe lançamentos contábeis mas não existe saldo, indicando o reprocessamento de saldo


@author  Alvaro Camillo Neto
@since   07/04/2014
@version 12
/*/
//-------------------------------------------------------------------
Static Function ValidCQ()


If CT2->(DbSeek(xFilial("CT2")))
	If CQ0->(!DbSeek(xFilial("CQ0")))
		Help(" ",1,"TABELACQ",,STR0196,1,0) //"Por favor, execute o reprocessamento de saldos contábeis."
	EndIf
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄ7ÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ CTBAtuCVJ ³ Autor ³ Totvs                   ³ Data ³ 07/10/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao para atualizar a tabela de processos CVJ               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATUALIZACAO SIGACTB                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CTBAtuCVJ( cCodFil , lIncProc )
Local aCVJ		:= {}
Local aEstrut	:= {}
Local nInc		:= 0
Local nCol		:= 0
Local cTexto	:= "CVJ"

Default lIncProc := .T.

aEstrut := { "CVJ_FILIAL", "CVJ_MODULO", "CVJ_PROCES", "CVJ_DESCRI" }

// Modulo, Processo e Descricao
// Itens a serem incluidos

aAdd( aCVJ,{cCodFil,"05","440","DOCUMENTO DE SAIDA"/*STR0145*/}) //"DOCUMENTO DE SAIDA"
aAdd( aCVJ,{cCodFil,"02","400","PEDIDO DE COMPRAS"	/*STR0146*/}) //"PEDIDO DE COMPRAS"
aAdd( aCVJ,{cCodFil,"02","410","DOCUMENTO DE ENTRADA"/*STR0147*/}) //"DOCUMENTO DE ENTRADA"
aAdd( aCVJ,{cCodFil,"06","200","CONTAS A RECEBER"/*STR0148*/}) //"CONTAS A RECEBER"
aAdd( aCVJ,{cCodFil,"69","520","RETENCAO"/*STR0149*/}) //"RETENCAO"
aAdd( aCVJ,{cCodFil,"69","510","CONTRATO"/*STR0150*/}) //"CONTRATO"
aAdd( aCVJ,{cCodFil,"01","010","AQUISICAO"/*STR0071*/}) //"AQUISICAO"
aAdd( aCVJ,{cCodFil,"06","330","COMPENSACAO ENTRE CARTEIRAS"/*STR0118*/}) //"COMPENSACAO ENTRE CARTEIRAS"
aAdd( aCVJ,{cCodFil,"69","500","CAUCIONAMENTO"/*STR0151*/}) //"CAUCIONAMENTO"
aAdd( aCVJ,{cCodFil,"06","300","CONTAS A PAGAR"/*STR0152*/}) //"CONTAS A PAGAR"
aAdd( aCVJ,{cCodFil,"06","350","MOVIMENTO BANCARIO"/*STR0153*/}) //"MOVIMENTO BANCARIO"
aAdd( aCVJ,{cCodFil,"06","370","MOVIMENTO CAIXINHA"/*STR0154*/}) //"MOVIMENTO CAIXINHA"
aAdd( aCVJ,{cCodFil,"06","250","APLICACOES E EMPRESTIMOS"/*STR0155*/}) //"APLICACOES E EMPRESTIMOS"
aAdd( aCVJ,{cCodFil,"01","020","AMPLIACAO"/*STR0073*/}) //"AMPLIACAO"
aAdd( aCVJ,{cCodFil,"01","030","BAIXA AQUISICAO"/*STR0075*/}) //"BAIXA AQUISICAO"
aAdd( aCVJ,{cCodFil,"01","040","CALCULO DE DEPRECIACAO"/*STR0156*/}) //"CALCULO DE DEPRECIACAO"
aAdd( aCVJ,{cCodFil,"01","050","AJUSTE DE INVENTARIO"/*STR0157*/}) //"AJUSTE DE INVENTARIO"
aAdd( aCVJ,{cCodFil,"04","100","ENTRADA DE PRODUTOS"/*STR0085*/}) //"ENTRADA DE PRODUTOS"
aAdd( aCVJ,{cCodFil,"04","130","RECALCULO DE CUSTO"/*STR0094*/}) //"RECALCULO DE CUSTO"
aAdd( aCVJ,{cCodFil,"04","110","SAIDA DE PRODUTOS"/*STR0089*/}) //"SAIDA DE PRODUTOS"
aAdd( aCVJ,{cCodFil,"04","120","TRANSFERENCIA DE ALMOXARIFADO"/*STR0158*/}) //"TRANSFERENCIA DE ALMOXARIFADO"
aAdd( aCVJ,{cCodFil,"09","150","APURACAO DE IMPOSTOS"/*STR0159*/}) //"APURACAO DE IMPOSTOS"
aAdd( aCVJ,{cCodFil,"07","700","FOLHA DE PAGAMENTO"/*STR0137*/}) //"FOLHA DE PAGAMENTO"
aAdd( aCVJ,{cCodFil,"65","800","FATURAMENTO"/*STR0160*/}) //"FATURAMENTO"
aAdd( aCVJ,{cCodFil,"65","810","DESPESAS"/*STR0161*/}) //"DESPESAS"
aAdd( aCVJ,{cCodFil,"34","750","LANCAMENTOS PADROES"/*STR0138*/}) //"LANCAMENTOS PADROES"
aAdd( aCVJ,{cCodFil,"43","490","DOCUMENTO"/*STR0162*/}) //"DOCUMENTO"

aAdd( aCVJ, { cCodFil, "01", "060" ,"CALCULOS"/*STR0163*/} ) // 01-Ativo Fixo //"CALCULOS"
aAdd( aCVJ, { cCodFil, "01", "070" ,"TRANSFERENCIA CONTABIL"/*STR0164*/} ) //"TRANSFERENCIA CONTABIL"
aAdd( aCVJ, { cCodFil, "01", "080" ,"AQUISICAO POR TRANSFERENCIA"/*STR0165*/} ) //"AQUISICAO POR TRANSFERENCIA"
aAdd( aCVJ, { cCodFil, "01", "090" ,"AJUSTE POR INFLACAO"/*STR0166*/} ) //"AJUSTE POR INFLACAO"

aAdd( aCVJ, { cCodFil, "04", "130" ,"CUSTO DA MERCADORIA VENDIDA"/*STR0167*/} ) // 04-Estoque/Custos //"CUSTO DA MERCADORIA VENDIDA"

aAdd( aCVJ, { cCodFil, "06", "380" ,"VARIACAO MONETARIA A PAGAR"/*STR0168*/} ) // 06-Financeiro //"VARIACAO MONETARIA A PAGAR"
aAdd( aCVJ, { cCodFil, "06", "390" ,"VARIACAO MONETARIA A RECEBER"/*STR0169*/} ) //"VARIACAO MONETARIA A RECEBER"

aAdd( aCVJ, { cCodFil, "17", "910" ,"DOCUMENTO DE ENTRADA"/*STR0147*/} ) // 17-Easy Import Control //"DOCUMENTO DE ENTRADA"
aAdd( aCVJ, { cCodFil, "45", "980" ,"APROPRIACAO DE DIREITOS AUTORAIS"/*STR0170*/} ) // 45-Controle de Direitos Autorais //"APROPRIACAO DE DIREITOS AUTORAIS"

aAdd( aCVJ, { cCodFil, "05", "430" ,"PEDIDO DE VENDA"/*STR0171*/} )  //"PEDIDO DE VENDA"

aAdd( aCVJ, { cCodFil, "33", "9A0" ,"PLANO DE SAUDE"/*STR0172*/} )  //"PLANO DE SAUDE"

aAdd( aCVJ, { cCodFil, "76", "9D0" ,"PROVISÃO"/*STR0179*/} )  //"PROVISÃO"

aAdd( aCVJ, { cCodFil, "89", "T00" ,"REGISTRO DE VENDA"/*STR0179*/} )  //"REGISTRO DE VENDA"

aAdd( aCVJ, { cCodFil, "89", "T30" ,"CONCILIAÇÃO"/*STR0179*/} )  //"CONCILIAÇÃO"

aAdd( aCVJ, { cCodFil, "89", "T40" ,"APURAÇÃO"/*STR0179*/} )  //"APURAÇÃO"

aAdd( aCVJ, { cCodFil, "89", "T20" ,"FATURAMENTO DE RECEITA/VENDA"/*STR0179*/} )  //"FATURAMENTO DE RECEITA/VENDA"

DbSelectArea( "CVJ" )
DbSetOrder( 2 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³inclusao dos novos itens na tabela³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcRegua( Len( aCVJ ) )
For nInc := 1 To Len( aCVJ )
	If !CVJ->( DbSeek( aCVJ[nInc][1] + aCVJ[nInc][2] + aCVJ[nInc][3] ) )
		RecLock( "CVJ", .T. )
		For nCol := 1 To Len( aCVJ[nInc] )
			If FieldPos( aEstrut[nCol] ) > 0
				FieldPut( FieldPos( aEstrut[nCol] ), aCVJ[nInc][nCol] )
			EndIf
		Next
		DbCommit()
		MsUnLock()

		If lIncProc
			IncProc( STR0053 ) //"Atualizando Tabela de Processos..."
		EndIf
	EndIf
Next

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ CTBAtuCVG ³ Autor ³ Totvs                   ³ Data ³ 07/10/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao para atualizar a tabela de processos CVG               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ATUALIZACAO SIGACTB                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function CTBAtuCVG( cCodFil , lIncProc )
Local aCVG		:= {}
Local aEstrut	:= {}
Local nInc		:= 0
Local nCol		:= 0
Local cTexto	:= "CVG"

Default lIncProc := .T.

aEstrut := { "CVG_FILIAL","CVG_PROCES","CVG_OPER","CVG_DESCRI"}

// Processo, Operação, Descrição
// Itens a serem incluidos
aAdd( aCVG,{cCodFil,"010","005",STR0071}) //"AQUISICAO"
aAdd( aCVG,{cCodFil,"010","010",STR0072}) //"EXCLUSAO"
aAdd( aCVG,{cCodFil,"020","005",STR0073}) //"AMPLIACAO"
aAdd( aCVG,{cCodFil,"020","010",STR0074}) //"CANCELAMENTO"
aAdd( aCVG,{cCodFil,"030","005",STR0075}) //"BAIXA AQUISICAO"
aAdd( aCVG,{cCodFil,"030","010",STR0074}) //"CANCELAMENTO"
aAdd( aCVG,{cCodFil,"040","005",STR0076}) //"CALCULO"
aAdd( aCVG,{cCodFil,"040","010",STR0077}) //"DESCALCULO"
aAdd( aCVG,{cCodFil,"050","005",STR0078}) //"AJUSTE INVENTARIO"
aAdd( aCVG,{cCodFil,"050","010",STR0079}) //"AQUISICAO  LEI 8.200 (TIPO DO ATIVO )"
aAdd( aCVG,{cCodFil,"050","015",STR0080}) //"EXCLUSAO  LEI 8.200 (TIPO DO ATIVO )"
aAdd( aCVG,{cCodFil,"050","020",STR0081}) //"BAIXA LEI 8.200 (TIPO DO ATIVO )"
aAdd( aCVG,{cCodFil,"050","025",STR0082}) //"CANCELAMENTO DA BAIXA (TIPO DO ATIVO )"
aAdd( aCVG,{cCodFil,"070","005",STR0083}) //"ATF-TRANSFERENCIA CONTABIL"
aAdd( aCVG,{cCodFil,"080","005",STR0084}) //"ATF-AQUISICAO POR TRANSFERENCIA"
aAdd( aCVG,{cCodFil,"100","005",STR0085}) //"ENTRADA DE PRODUTOS"
aAdd( aCVG,{cCodFil,"100","010",STR0086}) //"ENTRADA ANTES DE ATUALIZAR CUSTO"
aAdd( aCVG,{cCodFil,"100","015",STR0087}) //"ENTRADA POR APROPRIACAOINDIRETA"
aAdd( aCVG,{cCodFil,"100","020",STR0088}) //"ENTRADA INVENTARIO"
aAdd( aCVG,{cCodFil,"110","005",STR0089}) //"SAIDA DE PRODUTOS"
aAdd( aCVG,{cCodFil,"110","010",STR0090}) //"SAIDA ANTES DE ATUALIZAR CUSTO"
aAdd( aCVG,{cCodFil,"110","015",STR0091}) //"SAIDA POR APROPRIACAO INDIRETA"
aAdd( aCVG,{cCodFil,"110","020",STR0092}) //"SAIDA INVENTARIO"
aAdd( aCVG,{cCodFil,"120","005",STR0093}) //"TRANSFERENCIA"
aAdd( aCVG,{cCodFil,"130","005",STR0094}) //"RECALCULO DE CUSTO"
aAdd( aCVG,{cCodFil,"150","005",STR0095}) //"APURACAO"
aAdd( aCVG,{cCodFil,"150","010",STR0096}) //"ESTORNO"
aAdd( aCVG,{cCodFil,"200","001",STR0097}) //"INCLUSAO DE TITULOS"
aAdd( aCVG,{cCodFil,"200","010",STR0098}) //"SUBSTITUICAO DE TITULOS PROVISORIOS"
aAdd( aCVG,{cCodFil,"200","015",STR0099}) //"EXCLUSAO DE TITULOS"
aAdd( aCVG,{cCodFil,"200","020",STR0100}) //"GERACAO DE BORDERO"
aAdd( aCVG,{cCodFil,"200","025",STR0101}) //"EXCLUSAO DE BORDERO"
aAdd( aCVG,{cCodFil,"200","030",STR0102}) //"GERACAO DE FATURAS"
aAdd( aCVG,{cCodFil,"200","035",STR0103}) //"EXCLUSAO DE FATURA"
aAdd( aCVG,{cCodFil,"200","040",STR0104}) //"COMPENSACAO"
aAdd( aCVG,{cCodFil,"200","045",STR0105}) //"CANCELAMENTO DE COMPENSACAO"
aAdd( aCVG,{cCodFil,"200","060",STR0106}) //"BAIXAS"
aAdd( aCVG,{cCodFil,"200","065",STR0107}) //"CANCELAMENTO DE BAIXA"
aAdd( aCVG,{cCodFil,"200","070",STR0108}) //"TRANSFERENCIAS"
aAdd( aCVG,{cCodFil,"250","005",STR0109}) //"INCLUSAO"
aAdd( aCVG,{cCodFil,"250","010",STR0110}) //"APROPRIACAO/RESGATE"
aAdd( aCVG,{cCodFil,"250","015",STR0111}) //"ESTORNO DE APROPRIACAO/RESGATE"
aAdd( aCVG,{cCodFil,"250","020",STR0112}) //"EXCLUSAO DE APLICACAO/EMPRESTIMO"
aAdd( aCVG,{cCodFil,"300","001",STR0109}) //"INCLUSAO"
aAdd( aCVG,{cCodFil,"300","005",STR0098}) //"SUBSTITUICAO DE TITULOS PROVISORIOS"
aAdd( aCVG,{cCodFil,"300","010",STR0099}) //"EXCLUSAO DE TITULOS"
aAdd( aCVG,{cCodFil,"300","015",STR0102}) //"GERACAO DE FATURAS"
aAdd( aCVG,{cCodFil,"300","020",STR0113}) //"EXCLUSAO DE FATURAS"
aAdd( aCVG,{cCodFil,"300","025",STR0114}) //"CHEQUES"
aAdd( aCVG,{cCodFil,"300","030",STR0115}) //"EXCLUSAO DE CHEQUES"
aAdd( aCVG,{cCodFil,"300","035",STR0104}) //"COMPENSACAO"
aAdd( aCVG,{cCodFil,"300","040",STR0105}) //"CANCELAMENTO DE COMPENSACAO"
aAdd( aCVG,{cCodFil,"300","055",STR0116}) //"BAIXA DE TITULOS"
aAdd( aCVG,{cCodFil,"300","060",STR0117}) //"CANCELAMENTO DE BAIXAS"
aAdd( aCVG,{cCodFil,"330","005",STR0118}) //"COMPENSACAO ENTRE CARTEIRAS"
aAdd( aCVG,{cCodFil,"350","005",STR0119}) //"INCLUSAO DE SAIDA"
aAdd( aCVG,{cCodFil,"350","010",STR0120}) //"EXCLUSAO DE SAIDA"
aAdd( aCVG,{cCodFil,"350","015",STR0121}) //"INCLUSAO DE ENTRADA"
aAdd( aCVG,{cCodFil,"350","020",STR0122}) //"EXCLUSAO DE ENTRADA"
aAdd( aCVG,{cCodFil,"350","025",STR0093}) //"TRANSFERENCIA"
aAdd( aCVG,{cCodFil,"370","005",STR0123}) //"MOVIMENTO DE CAIXIHA"
aAdd( aCVG,{cCodFil,"370","010",STR0124}) //"ESTORNO DE MOVIMENTO"
aAdd( aCVG,{cCodFil,"370","015",STR0125}) //"REPOSICAO"
aAdd( aCVG,{cCodFil,"380","005",STR0109}) //"VARIAÇÃO MONETARIA - CP - INCLUIR"
aAdd( aCVG,{cCodFil,"380","010",STR0096}) //"VARIAÇÃO MONETARIA - CP - ESTORNO"
aAdd( aCVG,{cCodFil,"390","005",STR0109}) //"VARIAÇÃO MONETARIA - CR - INCLUIR"
aAdd( aCVG,{cCodFil,"390","010",STR0096}) //"VARIAÇÃO MONETARIA - CR - ESTORNO"
aAdd( aCVG,{cCodFil,"400","005",STR0109}) //"INCLUSAO"
aAdd( aCVG,{cCodFil,"400","010",STR0072}) //"EXCLUSAO"
aAdd( aCVG,{cCodFil,"410","005",STR0126}) //"INCLUSAO DE DOC. DE ENTRADA"
aAdd( aCVG,{cCodFil,"410","010",STR0127}) //"INCLUSAO DE DOC. DEV/BENEF."
aAdd( aCVG,{cCodFil,"410","015",STR0128}) //"EXCLUSAO DE DOC. DE ENTRADA"
aAdd( aCVG,{cCodFil,"440","005",STR0129}) //"INCLUSAO DE DOC. DE SAIDA"
aAdd( aCVG,{cCodFil,"440","010",STR0130}) //"EXCLUSAO DE DOC.DE SAIDA"
aAdd( aCVG,{cCodFil,"490","005",STR0131}) //"INCLUSAO DE NOTA"
aAdd( aCVG,{cCodFil,"490","010",STR0132}) //"EXCUSAO DE NOTA"
aAdd( aCVG,{cCodFil,"500","005",STR0109}) //"INCLUSAO"
aAdd( aCVG,{cCodFil,"500","010",STR0072}) //"EXCLUSAO"
aAdd( aCVG,{cCodFil,"500","015",STR0133}) //"BAIXA"
aAdd( aCVG,{cCodFil,"510","005",STR0134}) //"CRONOGRAMA CONTABIL"
aAdd( aCVG,{cCodFil,"510","010",STR0135}) //"INCLUSAO DO CONTRATO"
aAdd( aCVG,{cCodFil,"510","015",STR0174}) //"OPERAÇÕES DO CONTRATO"
aAdd( aCVG,{cCodFil,"520","005",STR0136}) //"RETENCAO DO CONTRATO"
aAdd( aCVG,{cCodFil,"700","005",STR0137}) //"FOLHA DE PAGAMENTO"
aAdd( aCVG,{cCodFil,"750","005",STR0138}) //"LANCAMENTOS PADROES"
aAdd( aCVG,{cCodFil,"800","005",STR0139}) //"GERACAO DE FATURA"
aAdd( aCVG,{cCodFil,"800","010",STR0140}) //"ESTORNO DE FATURA"
aAdd( aCVG,{cCodFil,"810","005",STR0141}) //"GERACAO"
aAdd( aCVG,{cCodFil,"810","010",STR0096}) //"ESTORNO"
aAdd( aCVG,{cCodFil,"430","005",STR0142})                                            //"INCLUSAO DE PEDIDO DE VENDA"
aAdd( aCVG,{cCodFil,"430","010",STR0143}) //"EXCLUSAO DE PEDIDO DE VENDA"
aAdd( aCVG,{cCodFil,"9A0","005",STR0144})                                            //"MANUTENCAO DE PLANO DE SAUDE"

aAdd( aCVG,{cCodFil,"9D0","005",STR0176}) //"INCLUSAO DE VALORES DE PROVISAO"
aAdd( aCVG,{cCodFil,"9D0","010",STR0177}) //"CANELAMENTO DE VALORES DE PROVISAO"
aAdd( aCVG,{cCodFil,"9D0","015",STR0178}) //"REDUCAO DE VALORES DE PROVISAO"

aAdd( aCVG, { cCodFil, "200", "050" ,STR0197} )		//"RECEBIMENTOS DIVERSOS"
aAdd( aCVG, { cCodFil, "300", "045" ,STR0198} ) 	//"ORDEM DE PAGO"

aAdd( aCVG, { cCodFil, "410", "020" ,STR0199} )		//"INCLUSÃO DE NOTA MAN/AUT."
aAdd( aCVG, { cCodFil, "410", "025" ,STR0200} )		//"INCLUSÃO DE NOTA DE CRED/DEB"
aAdd( aCVG, { cCodFil, "410", "030" ,STR0201} )		//"INCLUSÃO DE REMITO DE ENTRADA"
aAdd( aCVG, { cCodFil, "410", "035" ,STR0202} )		//"EXCLUSÃO DE NOTA MAN/AUT."
aAdd( aCVG, { cCodFil, "410", "040" ,STR0203} )		//"EXCLUSÃO DE NOTA DE CRE/DEB."
aAdd( aCVG, { cCodFil, "410", "045" ,STR0204} )		//"EXCLUSÃO DE REMITO"
//Itens
aAdd( aCVG, { cCodFil, "410", "050" ,STR0199 + " - " + STR0205} )  	//"INCLUSÃO DE NOTA MAN/AUT." ###ITENS"
aAdd( aCVG, { cCodFil, "410", "055" ,STR0200 + " - " + STR0205} )	//"INCLUSÃO DE NOTA DE CRED/DEB" ###ITENS
aAdd( aCVG, { cCodFil, "410", "060" ,STR0201 + " - " + STR0205} )	//"INCLUSÃO DE REMITO DE ENTRADA" ###ITENS"
aAdd( aCVG, { cCodFil, "410", "065" ,STR0202 + " - " + STR0205} ) 	//"INCLUSÃO DE REMITO DE ENTRADA" ###ITENS"
aAdd( aCVG, { cCodFil, "410", "070" ,STR0203 + " - " + STR0205} )	//"EXCLUSÃO DE NOTA DE CRE/DEB." ###ITENS"
aAdd( aCVG, { cCodFil, "410", "075" ,STR0204 + " - " + STR0205} )	//"EXCLUSÃO DE REMITO" ###ITENS"
//Vendas
//Cabec
aAdd( aCVG, { cCodFil, "440", "015" ,STR0199} )		//"INCLUSÃO DE NOTA MAN/AUT."
aAdd( aCVG, { cCodFil, "440", "020" ,STR0200} )		//"INCLUSÃO DE NOTA DE CRED/DEB"
aAdd( aCVG, { cCodFil, "440", "025" ,STR0201} )		//"INCLUSÃO DE REMITO DE ENTRADA"
aAdd( aCVG, { cCodFil, "440", "030" ,STR0202} )		//"EXCLUSÃO DE NOTA MAN/AUT."
aAdd( aCVG, { cCodFil, "440", "035" ,STR0203} )		//"EXCLUSÃO DE NOTA DE CRE/DEB."
aAdd( aCVG, { cCodFil, "440", "040" ,STR0204} )		//"EXCLUSÃO DE REMITO"
//Itens
aAdd( aCVG, { cCodFil, "440", "045" ,STR0199 + " - " + STR0205} )  	//"INCLUSÃO DE NOTA MAN/AUT." ###ITENS"
aAdd( aCVG, { cCodFil, "440", "050" ,STR0200 + " - " + STR0205} )	//"INCLUSÃO DE NOTA DE CRED/DEB" ###ITENS
aAdd( aCVG, { cCodFil, "440", "055" ,STR0201 + " - " + STR0205} )	//"INCLUSÃO DE REMITO DE ENTRADA" ###ITENS"
aAdd( aCVG, { cCodFil, "440", "060" ,STR0202 + " - " + STR0205} ) 	//"INCLUSÃO DE REMITO DE ENTRADA" ###ITENS"
aAdd( aCVG, { cCodFil, "440", "065" ,STR0203 + " - " + STR0205} )	//"EXCLUSÃO DE NOTA DE CRE/DEB." ###ITENS"
aAdd( aCVG, { cCodFil, "440", "070" ,STR0204 + " - " + STR0205} )	//"EXCLUSÃO DE REMITO" ###ITENS"

//Turismo
aAdd( aCVG, { cCodFil, "T00", "005" ,"ITENS FINANCEIROS"} )		//"ITENS FINANCEIROS"
aAdd( aCVG, { cCodFil, "T20", "005" ,"ITENS FINANCEIROS"} )		//"ITENS FINANCEIROS"
aAdd( aCVG, { cCodFil, "T30", "005" ,"ITENS FINANCEIROS"} )		//"ITENS FINANCEIROS"
aAdd( aCVG, { cCodFil, "T40", "005" ,"ITENS FINANCEIROS"} )		//"ITENS FINANCEIROS"
aAdd( aCVG, { cCodFil, "T40", "010" ,"TOTAL APURAÇÃO"} )		//"TOTAL APURAÇÃO"
aAdd( aCVG, { cCodFil, "T50", "005" ,"ITENS DA FATURA"} )		//"ITENS DA FATURA"


DbSelectArea( "CVG" )
DbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³inclusao dos novos itens na tabela³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcRegua( Len( aCVG ) )
For nInc := 1 To Len( aCVG )
	If !CVG->( DbSeek( aCVG[nInc][1] + aCVG[nInc][2] + aCVG[nInc][3] ) )
		RecLock( "CVG", .T. )
		For nCol := 1 To Len( aCVG[nInc] )
			If FieldPos( aEstrut[nCol] ) > 0
				FieldPut( FieldPos( aEstrut[nCol] ), aCVG[nInc][nCol] )
			EndIf
		Next
		DbCommit()
		MsUnLock()
		If lIncProc
			IncProc( STR0056 ) //"Atualizando Tabela de Processos..."
		EndIf
	EndIf
Next

Return cTexto
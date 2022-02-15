//Bibliotecas
#INCLUDE 'TOTVS.CH'
#Include 'Protheus.ch'
#INCLUDE 'RWMAKE.CH'
#Include 'FWMVCDef.ch'
#Include "TOPCONN.CH"
#include "vkey.ch"
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

#DEFINE ENTER CHR(13)+CHR(10)

/*/{Protheus.doc} clsEtiquetas
Classe para impressao de etiquetas de codigos de barras

@author eduardo.arcieri
@since 16/11/2016
@version 11.80

@example
(examples)

@see (links_or_references)
/*/
CLASS clsEtiquetas

	Method New() CONSTRUCTOR
	Method mtdPrinter(c_ImpCod, n_Densidade, n_Tamanho,l_Exibe)
	Method mtdBegin(n_xQtde,n_Veloc,n_Tamanho,l_Salva,l_Exibe)
	Method mtdPsay(n_LSEmm, n_CSEmm, c_Texto, c_Rotacao, c_Fonte, c_Tam,l_Exibe)
	Method mtdPbox(n_LSEmm, n_CSEmm, n_LIDmm, n_CIDmm, n_Espessura, c_Cor,l_Exibe)
	Method mtdSayBar(n_LSEmm, n_CSEmm, c_Conteudo, c_Rotacao, c_TypePrt, n_Altura,c_SubSetIni, n_Largura,l_Exibe)
	Method mtdLoadGraf(c_Imagem,l_Exibe)
	Method mtdGraphic(n_LSEmm, n_CSEmm, c_Arquivo,l_Exibe)
	Method mtdWrite(c_texto,l_Exibe)
	Method mtdVldModelo(c_Modelo,l_Exibe)
	Method mtdVldFunc(c_NomFunc,l_Exibe)
ENDCLASS

/*/{Protheus.doc} New
Method Construtor

@author eduardo.arcieri
@since 16/01/2016
@version 11.80

@example
(examples)

@see (links_or_references)
/*/
METHOD New() CLASS clsEtiquetas
Return Self


/*/{Protheus.doc} mtdPrinter
Method para coletar configuracao de impressao de Etiquetas

@author eduardo.arcieri
@since 16/11/2016
@version 11.80

@param c_ImpCod, character, código da impressora cadastrada na tabela CB5
@param n_Densidade, numerico, densidade de impressao
@param n_Tamanho, numerico, tamanho do formulario da etiqueta
@param l_Exibe, logico, informe .T. para exibir mensagens de alerta.

@example
(examples)

@see (links_or_references)

/*/
Method mtdPrinter(c_ImpCod, n_Densidade, n_Tamanho, l_Exibe,c_ModPrt, c_Porta, l_Srv) Class clsEtiquetas


	Local		c_Info			:=	""

	Default 	c_ImpCod		:=	Space(6)
	Default 	n_Densidade	:=	0
	Default 	n_Tamanho		:=	0
	Default 	c_ModPrt		:=	"ZEBRA"
	Default 	c_Porta		:=	"LPT1"
	Default 	l_Srv			:=	.F.

	If Empty(c_ImpCod)
		c_Info	+=	"Impressora não informada"

	Endif

	If Empty(n_Densidade)
		c_Info	+=	"Densidade não informada"

	Endif

	If Empty(n_Tamanho)
		c_Info	+=	"Tamanho não informado"

	Endif

	If !empty(c_Info)
		c_Info	+=	"Impressora não pode ser Configurada."

		If l_Exibe
			msgInfo(c_Info)
		Endif

		Return(.F.)
	Endif

	CB5->(dbSetOrder(1))
	If CB5->(dbSeek(xFilial("CB5")+c_ImpCod,.T.))

		c_ModPrt	:= 	alltrim(CB5->CB5_MODELO)
		l_Srv		:=	Iif( !Empty(alltrim(CB5->CB5_SERVER)), .T., .F. )

		c_Info		:=	""
		If Empty(c_ModPrt)
			c_Info	+=	"Modelo da impressora não informado no cadastro."
		Endif

		If CB5->CB5_PORTA <> "0"
			c_Porta		:=	"COM"+alltrim(CB5->CB5_PORTA)+":"+alltrim(CB5->CB5_SETSER)
		ElseIf CB5->CB5_LPT <> "0"
			c_Porta := "LPT"+alltrim(CB5->CB5_LPT)
		ElseIf CB5->CB5_DRVWIN <> "0"
			c_Porta := alltrim("")
		Else
			c_Info	+=	"Configuração de Impressora inválida. Verifique o cadastro de impressoras"
		EndIf

		If !Empty(c_Info)
			c_Info	+=	"Impressora não pode ser Configurada."
			If l_Exibe
				msgInfo(c_Info)
			Endif
			Return(.F.)
		Endif

	Else
		c_Info	+=	"Impressora não cadastrada. Operação abortada."
		If l_Exibe
			msgInfo(c_Info)
		Endif
		Return(.F.)
	Endif

	MSCBPRINTER(	c_ModPrt	, c_Porta	,n_Densidade	,n_Tamanho	,l_Srv)
	MSCBCHKSTATUS(.F.)

Return(.T.)


/*/{Protheus.doc} mtdBegin
Method para configuracao de impressao da velocidade e densidade de Etiquetas

@author eduardo.arcieri
@since 16/11/2016
@version 11.80

@param n_xQtde, numerico, quantidade de copias impressas por etiqueta
@param n_Veloc, numerico, velocidade da impressao em polegadas por seguido, de 1 a 6.
@param n_Tamanho, numerico, tamanho do formulario da etiqueta,
@param l_Salva, logico, Variavel utilizada somente para definicao de form's
@param l_Exibe, logico, informe .T. para exibir mensagens de alerta.
@example
(examples)

@see (links_or_references)
/*/

Method mtdBegin(n_xQtde,n_Veloc,n_Tamanho,l_Salva,l_Exibe) Class clsEtiquetas

	Local		c_Info		:=	""

	Default 	n_xQtde	:=	0
	Default 	n_Veloc	:=	0
	Default 	n_Tamanho	:=	0
	Default 	l_Salva	:=	.F.

	If empty(n_xQtde)
		c_Info	+=	"Quantidade de copias nao informada, favor informar no minimo 1(um)."
	Endif

	If empty(n_Veloc)
		c_Info	+=	"Velocidade da impressao nao informadfa, favor informar no minimo 1(um)."
	Endif

	If !Empty(c_Info)
		c_Info += "Configuração de etiqueta inválida. Verifique o cadastro da etiqueta"
		If l_Exibe
			msgInfo(c_Info)
		Endif
		Return(.F.)
	Endif
	MSCBBEGIN(1,1)
	//MSCBBEGIN(n_xQtde, n_Veloc)
	/*
	If n_Tamanho == 0
	MSCBBEGIN(n_xQtde, n_Veloc,,l_Salva)
	Else
	MSCBBEGIN(n_xQtde, n_Veloc, n_Tamanho, l_Salva)
	Endif
	*/
Return(.T.)

/*/{Protheus.doc} mtdPsay
Method para impressao de texto ou comandos de formatação para etiquetas de codigo de barras

@author eduardo.arcieri
@since 16/11/2016
@version 11.80

@param c_ImpCod, Character, codigo do modelo da impressora cadastrado na tabela CB5:
@param n_LSEmm, numerico, coordenada superior esquerda - Linha
@param n_CSEmm, numerico, coordenada superior esquerda - Coluna
@param c_Texto, character,Texto ou comando de formação a ser impresso/enviado
@param c_Rotacao, character, String com o tipo de Rotação (N,R,I,B):N - Normal, R - Cima para baixo, I - Invertido, B - Baixo para cima
@param c_Fonte,character, String com os tipos de Fonte:Zebra - (A,B,C,D,E,F,G,H,0) 0(zero)- fonte escalar | Datamax - (0,1,2,3,4,5,6,7,8,9) 9 – fonte escalar | Eltron - (0,1,2,3,4,5) | Intermec - (0,1,7,20,21,22,27)
@param c_Tam,character, String com o tamanho da Fonte
@param l_Exibe, logico, informe .T. para exibir mensagens de alerta.
@example
(examples)

@see (links_or_references)
/*/

Method mtdPsay(c_ImpCod, n_LSEmm, n_CSEmm, c_Texto, c_Rotacao, c_Fonte, c_Tam, l_Exibe, c_ModPrt) Class clsEtiquetas

	Local		c_Info		:=	""

	Default	n_LSEmm	:=	0
	Default	n_CSEmm	:=	0
	Default	c_Texto	:=	""
	Default	c_Rotacao	:=	"N"
	Default	c_Fonte	:=	"A"
	Default	c_Tam		:=	"10,10"
	Default	c_ModPrt	:=	"ZEBRA"

	//Private 	o_VldModelo	:=  clsEtiquetas():New()


	CB5->(dbSetOrder(1))
	If CB5->(dbSeek(xFilial("CB5")+c_ImpCod,.T.))

		c_ModPrt	:= 	alltrim(CB5->CB5_MODELO)
		/* Modelos homologados no TDN até o momento
		String com o modelo de impressora:
		Datamax - ALLEGRO, ALLEGRO 2, PRODIGY, DMX, DESTINY, URANO, DATAMAX, OS 214, OS 314, PRESTIGE, ARGOX
		Eltron - ELTRON, TLP 2722, TLP 2742, TLP 2844, TLP 3742, C4-8
		Intermec - INTERMEC, 3400-8, 3400-16, 3600-8, 4440-16, 7421C-8
		Zebra - S300, S400, S500-6, S500-8, Z105S-6, Z105S-8, Z160S-6, Z160S-8, Z140XI, S600, Z4M, Z90XI, Z170XI, ZEBRA
		*/

	Endif

	If Empty(n_LSEmm)
		c_Info	+=	"Linha superior direita nao informada."
	Endif

	If Empty(n_CSEmm)
		c_Info	+=	"Coluna superior direita nao informada."
	Endif

	If Empty(c_Texto)
		c_Info	+=	"texto a ser impresso nao informado."
	Endif

	If !(Alltrim(c_Rotacao) $ "NRIB")
		c_Info += "Rotacao invalida."
	Endif

	l_Ret := self:mtdVldModelo(c_ModPrt,,1,.F.) //Validacao de modelo de impressora

	If !l_Ret
		c_Info += "Modelo de impressora não homologado."
	Endif

	l_Ret := self:mtdVldModelo(c_ModPrt,c_Fonte,2,.F.) //Validacao de fonte por modelo de impressora

	If !l_Ret
		c_Info += "Fonte não informada ou divergente do modelo da impressora selecionado, favor verificar."
	Endif

	If !Empty(c_Info)
		c_Info += "Impressao do texto não será realizada."
		If l_Exibe
			msgInfo(c_Info)
		Endif
		Return(.F.)
	Endif

	MSCBSAY(n_CSEmm,n_LSEmm,c_Texto, c_Rotacao, c_Fonte, c_Tam)

Return(.T.)

/*/{Protheus.doc} mtdPbox
Method para impressao de texto ou comandos de formatação para etiquetas de codigo de barras

@author eduardo.arcieri
@since 16/11/2016
@version 11.80

@param n_LSEmm, numerico, coordenada superior esquerda - Linha
@param n_CSEmm, numerico, coordenada superior esquerda - Coluna
@param n_LIDmm, numerico, coordenada inferior direita - Linha
@param n_CIDmm, numerico, coordenada  inferior direita - Coluna
@param n_Espessura, numerico, tamanho da espessura da linha do box em mm
@param c_Cor, Character, String com a Cor Branca ou Preta ("W" ou "B")


@param c_Texto, character,Texto ou comando de formação a ser impresso/enviado
@param c_Rotacao, character, String com o tipo de Rotação (N,R,I,B):N - Normal, R - Cima para baixo, I - Invertido, B - Baixo para cima
@param c_Fonte,character, String com os tipos de Fonte:Zebra - (A,B,C,D,E,F,G,H,0) 0(zero)- fonte escalar | Datamax - (0,1,2,3,4,5,6,7,8,9) 9 – fonte escalar | Eltron - (0,1,2,3,4,5) | Intermec - (0,1,7,20,21,22,27)
@param c_Tam,character, String com o tamanho da Fonte
@param l_Exibe, logico, informe .T. para exibir mensagens de alerta.

@example
(examples)

@see (links_or_references)
/*/
Method mtdPbox(n_LSEmm, n_CSEmm, n_LIDmm, n_CIDmm, n_Espessura, c_Cor, l_Exibe) Class clsEtiquetas

	Local		c_Info		:=	""

	Default	n_LSEmm		:=	0
	Default	n_CSEmm		:=	0
	Default	n_LIDmm		:=	0
	Default	n_CIDmm		:=	0
	Default	n_Espessura	:=	0
	Default	c_Cor			:=	"B"

	If Empty(n_LSEmm) .or. Empty(n_CSEmm) .or. Empty(n_LIDmm) .or. Empty(n_CIDmm)
		c_Info	+=	"Coordenadas incompletas, favor informar as quatro coordenadas do box ou linha."
	Endif

	If !Empty(c_Info)
		c_Info += "Impressao do box não será realizado."

		If l_Exibe
			msgInfo(c_Info)
		Endif
		Return(.F.)
	Endif

	If n_Espessura == 0
		MSCBBOX(n_LSEmm,n_CSEmm,n_LIDmm,n_CIDmm,,c_Cor)
	Else
		MSCBBOX(n_LSEmm,n_CSEmm,n_LIDmm,n_CIDmm,n_Espessura,c_Cor)
	Endif

Return(.T.)


/*/{Protheus.doc} mtdSayBar
Method para impressao de codigos de barras, pode ser usado linguagem nativa da impressora com os comandos MSCBSAY OU MSCBWRITE

@author eduardo.arcieri
@since 16/11/2016
@version 11.80

@param n_LSEmm, numerico, coordenada superior esquerda - Linha
@param n_CSEmm, numerico, coordenada superior esquerda - Coluna
@param a_Conteudo, array, String a ser impressa especificando uma variável "@" ou array somente quando o parâmetro cTypePrt for igual á MB07. cConteudo :={{"01","07893316010411"},; {"10","0000970100"+MSCB128B()+"1"+MSCB128C()},; {"37","0004"},; {"21","000494"}} • A possição 1 do array (ex: “01”) informa o AI utilizadado (que será visto no item 3.6.1. “Utilização do código de barras 128”).• Já a possição 2 do array (ex: "07893316010411”) é o conteúdo do AI.
@param c_Rotacao, character, String com o tipo de Rotação (N,R,I,B):N - Normal, R - Cima para baixo, I - Invertido, B - Baixo para cima
@param c_TypePrt,character, String com o Modelo de Código de Barras: MB01 - Interleaved 2 of 5 / EAN14 | MB02 - Code 39 | MB03 - EAN 8 | MB04 - EAN 13 | MB05 - UPC A | MB06 - UPC E | MB07 - CODE 128 | Obs: Caso o leitor queira utilizar o modelo do padrão de programação da impressora, o mesmo deverá consultar documentação do fabricante
@param n_Altura, numerico, Altura do codigo de barras em milimetros
@param c_SubSetIni,character, Utilizado no code128
@param n_Altura, numerico, Largura da barra mais fina em pontos default 3
@param l_Exibe, logico, informe .T. para exibir mensagens de alerta.

@example
(examples)

@see (links_or_references)
/*/
Method mtdSayBar(n_LSEmm, n_CSEmm, a_Conteudo, c_Rotacao, c_TypePrt, n_Altura,c_SubSetIni, n_Largura, l_Exibe) Class clsEtiquetas

	local		l_Ret 			:= .F.
	Local		c_Info			:=	""

	//Private 	o_VldModelo	:=  clsEtiquetas():New()

	Default	n_LSEmm		:=	0
	Default	n_CSEmm		:=	0
	Default	a_Conteudo		:=	{}
	Default	c_Rotacao		:=	"N"
	Default	c_TypePrt		:=	"MB04" //EAN-13
	Default	n_Altura		:=	0
	Default	c_SubSetIni	:=	"C"
	Default	n_Largura		:=	3
	Default	n_Relacao		:=	2

	If Empty(n_LSEmm)
		c_Info	+=	"Linha superior direita nao informada."
	Endif

	If Empty(n_CSEmm)
		c_Info	+=	"Coluna superior direita nao informada."
	Endif

	If !(Alltrim(c_Rotacao) $ "NRIB")
		c_Info += "Rotacao invalida."
	Endif

	l_Ret := self:mtdVldModelo(c_TypePrt,,3,.F.) //Validacao de modelo de codigo de barras

	If !l_Ret
		c_Info += "Tipo de codigo de barras invalido, favor usar um tipo válido de acordo com o que estiver homologado no TDN."
	Endif

	If Empty(n_Altura)
		c_Info	+=	"Altura do codigo de barras não informado nao informada."
	Endif

	If Empty(n_Largura)
		c_Info	+=	"Largura do codigo de barras não informado nao informada."
	Endif

	If !Empty(c_Info)
		c_Info += "Impressao do codigo de barras não será realizado."
		If l_Exibe
			msgInfo(c_Info)
		Endif
		Return(.F.)
	Endif

	If UPPER(Alltrim(c_TypePrt)) ==  "MB07"
		MSCBSAYBAR(n_LSEmm,n_CSEmm,a_Conteudo		,c_Rotacao,c_TypePrt,n_Altura,.F.,.T.,Nil,c_SubSetIni	,n_Largura,n_Relacao  ,.F.)
	Else
		MSCBSAYBAR(n_LSEmm,n_CSEmm,a_Conteudo[1]	,c_Rotacao,c_TypePrt,n_Altura,.F.,.T.,Nil,				,n_Largura,n_Relacao  ,.F.)
	Endif

Return(.T.)


/*/{Protheus.doc} mtdLoadGraf
Method para carregar imagens ou graficos para impressora de codigo de barras

@author eduardo.arcieri
@since 16/11/2016
@version 11.80

@param c_Imagem, character, Nome do arquivo que será carregado, incluso o path + nome completo + extensão
@param l_Exibe, logico, informe .T. para exibir mensagens de alerta.

@example
(examples)

@see (links_or_references)
/*/
Method mtdLoadGraf(c_Imagem, l_Exibe) Class clsEtiquetas

	Local		c_Info			:=	""
	Default	c_Imagem		:=	""

	If Empty(c_Imagem)
		c_Info	+=	"Pasta e arquivo de imagens ou gráfico não informado"
	Endif

	If !Empty(c_Info)
		c_Info += "Carregamento da imagem ou grafico não será realizado."
		If l_Exibe
			msgInfo(c_Info)
		Endif
		Return(.F.)
	Endif

	MSCBLOADGRF(c_Imagem)

Return(.T.)


/*/{Protheus.doc} mtdGraphic
Method para carregar imagens ou graficos para impressora de codigo de barras

@author eduardo.arcieri
@since 16/11/2016
@version 11.80

@param n_LSEmm, numerico, coordenada superior esquerda - Linha
@param n_CSEmm, numerico, coordenada superior esquerda - Coluna
@param c_Arquivo, character, Nome do arquivo da imagem ou grafico que será impresso sem extenção.

@example
(examples)

@see (links_or_references)
/*/
Method mtdGraphic(n_LSEmm, n_CSEmm, c_Arquivo, l_Exibe) Class clsEtiquetas

	Local		c_Info			:=	""

	Default	n_LSEmm		:=	0
	Default	n_CSEmm		:=	0
	Default	c_Arquivo		:=	""

	If Empty(n_LSEmm) .or. Empty(n_CSEmm) //.or. Empty(n_LIDmm) .or. Empty(n_CIDmm)
		c_Info	+=	"Coordenadas incompletas, favor informar as quatro coordenadas do box ou linha."
	Endif

	If Empty(c_Arquivo)
		c_Info	+=	"Pasta e arquivo de imagens ou gráfico não informado"
	Else
		c_Arquivo	:=	Substr(c_Arquivo,1,At(".",c_Arquivo)-1)
	Endif

	If !Empty(c_Info)
		c_Info += "Impressao da imagem ou grafico não será realizada."
		If l_Exibe
			msgInfo(c_Info)
		Endif
		Return(.F.)
	Endif

	MSCBGRAFIC(n_LSEmm,n_CSEmm,c_Arquivo)

Return(.T.)



/*/{Protheus.doc} mtdWrite
Method para imprimir codigo nativo da impressora de codigo de barras.

@author eduardo.arcieri
@since 16/11/2016
@version 11.80

@param c_texto, character, conteudo com linguagem de programacao da impressora que estiver sendo utilizada.
@param l_Exibe, logico, informe .T. para exibir mensagens de alerta.

@example
(examples)

@see (links_or_references)

/*/
Method mtdWrite(c_texto, l_Exibe) Class clsEtiquetas

	Local		c_Info			:=	""
	Default	c_texto		:=	""

	If Empty(c_texto)
		c_Info	+=	"nao ha informacao para impressao."
	Endif

	If !Empty(c_Info)
		c_Info += "sem conteudo informado, impressao não será realizada."
		If l_Exibe
			msgInfo(c_Info)
		Endif
		Return(.F.)
	Endif

	MSCBWrite(c_texto)

Return(.T.)


/*/{Protheus.doc} mtdVldModelo
Method para validar modelo de impressora, fontes e codigo de barras

@author eduardo.arcieri
@since 16/11/2016
@version 11.80

@param c_Modelo, character, informe o modelo homologado da impressora ou do codigo de barras para validação
@param c_Fonte, character, informe o tamanho homologado da fonte por modelo de impressora para validação
@param n_Tipo, numerico, 1=valida modelos de impressora, 2=valida tamanho de fonte por modelo de impressora, 3 = valida modelo de codio de barras
@param l_Exibe, logico, informe .T. para exibir mensagens de alerta.
@example
(examples)

@see (links_or_references)

/*/
Method mtdVldModelo(c_Modelo,c_Fonte,n_Tipo, l_Exibe) Class clsEtiquetas
	Local		l_Ret 		:= .F.
	Local		c_Info		:=	""
	Local		a_Modelos	:=	{}
	Local		a_TipBar	:=	{}

	//Modelos Homologados
	AAdd(a_Modelos,{"DATAMAX"	,"ALLEGRO"		,"0,1,2,3,4,5,6,7,8,9"})
	AAdd(a_Modelos,{"DATAMAX"	,"ALLEGRO 2"	,"0,1,2,3,4,5,6,7,8,9"})
	AAdd(a_Modelos,{"DATAMAX"	,"PRODIGY"		,"0,1,2,3,4,5,6,7,8,9"})
	AAdd(a_Modelos,{"DATAMAX"	,"DMX"			,"0,1,2,3,4,5,6,7,8,9"})
	AAdd(a_Modelos,{"DATAMAX"	,"DESTINY"		,"0,1,2,3,4,5,6,7,8,9"})
	AAdd(a_Modelos,{"DATAMAX"	,"URANO"		,"0,1,2,3,4,5,6,7,8,9"})
	AAdd(a_Modelos,{"DATAMAX"	,"DATAMAX"		,"0,1,2,3,4,5,6,7,8,9"})
	AAdd(a_Modelos,{"DATAMAX"	,"OS 214"		,"0,1,2,3,4,5,6,7,8,9"})
	AAdd(a_Modelos,{"DATAMAX"	,"OS 314"		,"0,1,2,3,4,5,6,7,8,9"})
	AAdd(a_Modelos,{"DATAMAX"	,"PRESTIGE"	,"0,1,2,3,4,5,6,7,8,9"})
	AAdd(a_Modelos,{"DATAMAX"	,"ARGOX"		,"0,1,2,3,4,5,6,7,8,9"})
	AAdd(a_Modelos,{"ELTRON"		,"ELTRON"		,"0,1,2,3,4,5"})
	AAdd(a_Modelos,{"ELTRON"		,"TLP 2722"	,"0,1,2,3,4,5"})
	AAdd(a_Modelos,{"ELTRON"		,"TLP 2742"	,"0,1,2,3,4,5"})
	AAdd(a_Modelos,{"ELTRON"		,"TLP 2844"	,"0,1,2,3,4,5"})
	AAdd(a_Modelos,{"ELTRON"		,"TLP 3742"	,"0,1,2,3,4,5"})
	AAdd(a_Modelos,{"ELTRON"		,"C4-8"		,"0,1,2,3,4,5"})
	AAdd(a_Modelos,{"INTERMEC"	,"INTERMEC"	,"0,1,7,20,21,22,27"})
	AAdd(a_Modelos,{"INTERMEC"	,"3400-8"		,"0,1,7,20,21,22,27"})
	AAdd(a_Modelos,{"INTERMEC"	,"3400-16"		,"0,1,7,20,21,22,27"})
	AAdd(a_Modelos,{"INTERMEC"	,"3600-8"		,"0,1,7,20,21,22,27"})
	AAdd(a_Modelos,{"INTERMEC"	,"4440-16"		,"0,1,7,20,21,22,27"})
	AAdd(a_Modelos,{"INTERMEC"	,"7421C-8"		,"0,1,7,20,21,22,27"})
	AAdd(a_Modelos,{"ZEBRA"		,"S300"		,"A,B,C,D,E,F,G,H,0"})
	AAdd(a_Modelos,{"ZEBRA"		,"S400"		,"A,B,C,D,E,F,G,H,0"})
	AAdd(a_Modelos,{"ZEBRA"		,"S500-6"		,"A,B,C,D,E,F,G,H,0"})
	AAdd(a_Modelos,{"ZEBRA"		,"S500-8"		,"A,B,C,D,E,F,G,H,0"})
	AAdd(a_Modelos,{"ZEBRA"		,"Z105S-6"		,"A,B,C,D,E,F,G,H,0"})
	AAdd(a_Modelos,{"ZEBRA"		,"Z105S-8"		,"A,B,C,D,E,F,G,H,0"})
	AAdd(a_Modelos,{"ZEBRA"		,"Z160S-6"		,"A,B,C,D,E,F,G,H,0"})
	AAdd(a_Modelos,{"ZEBRA"		,"Z160S-8"		,"A,B,C,D,E,F,G,H,0"})
	AAdd(a_Modelos,{"ZEBRA"		,"Z140XI"		,"A,B,C,D,E,F,G,H,0"})
	AAdd(a_Modelos,{"ZEBRA"		,"S600"		,"A,B,C,D,E,F,G,H,0"})
	AAdd(a_Modelos,{"ZEBRA"		,"Z4M"			,"A,B,C,D,E,F,G,H,0"})
	AAdd(a_Modelos,{"ZEBRA"		,"Z90XI"		,"A,B,C,D,E,F,G,H,0"})
	AAdd(a_Modelos,{"ZEBRA"		,"Z170XI"		,"A,B,C,D,E,F,G,H,0"})
	AAdd(a_Modelos,{"ZEBRA"		,"ZEBRA"		,"A,B,C,D,E,F,G,H,0"})

	//Modelos de codigo de barras homologados
	AAdd(a_TipBar	,{"MB01","Interleaved 2 of 5 / EAN14"	})
	AAdd(a_TipBar	,{"MB02","Code 39"						})
	AAdd(a_TipBar	,{"MB03","EAN 8"							})
	AAdd(a_TipBar	,{"MB04","EAN 13"							})
	AAdd(a_TipBar	,{"MB05","UPC A"							})
	AAdd(a_TipBar	,{"MB06","UPC E"							})
	AAdd(a_TipBar	,{"MB07","CODE 128"						})

	Default	c_Modelo	:=	""
	Default	c_Fonte	:=	""
	Default	n_Tipo		:=	0

	If Empty(c_Modelo) .or. Empty(n_Tipo)
		c_Info	+=	"Parâmetros da funcao incompletos"
	Endif

	If !Empty(c_Info)
		If l_Exibe
			msgInfo(c_Info)
		Endif
		Return(.F.)
	Endif

	If n_Tipo == 1 //Validar modelo de impressora

		For Nx := 1 to len(a_Modelos)
			If UPPER(Alltrim(c_Modelo)) == Alltrim(a_Modelos[Nx][1]) .Or. UPPER(Alltrim(c_Modelo)) == Alltrim(a_Modelos[Nx][2])
				l_Ret := .T.
				Exit
			Endif
		Next

	Endif

	If n_Tipo == 1 //Validar modelo de impressora

		For Nx := 1 to len(a_Modelos)
			If UPPER(Alltrim(c_Modelo)) == Alltrim(a_Modelos[Nx][1]) .Or. UPPER(Alltrim(c_Modelo)) == Alltrim(a_Modelos[Nx][2])
				l_Ret := .T.
				Exit
			Endif
		Next

	ElseIf n_Tipo == 2 //Valida fontes por modelo de impressora
		If !Empty(c_Fonte)
			For Nx := 1 to len(a_Modelos)
				If UPPER(Alltrim(c_Modelo)) == Alltrim(a_Modelos[Nx][1]) .Or. UPPER(Alltrim(c_Modelo)) == Alltrim(a_Modelos[Nx][2])
					If UPPER(Alltrim(c_Fonte)) $ Alltrim(a_Modelos[Nx][3])
						l_Ret := .T.
						Exit
					Endif
				Endif
			Next
		Endif


	ElseIf n_Tipo == 3 //Valida modelos de codigos de barras
		For Nx := 1 to len(a_TipBar)
			If UPPER(Alltrim(c_Modelo)) == Alltrim(a_TipBar[Nx][1])
				l_Ret := .T.
				Exit
			Endif
		Next

	Endif


Return(l_Ret)


/*/{Protheus.doc} mtdVldFunc
Method para validar funcao compilada no R P O

@author eduardo.arcieri
@since 17/11/2016
@version 11.80

@param c_NomFunc, character, informe nome da funcao a ser validada
@param l_Exibe, logico, informe .T. para exibir mensagens de alerta.
@example
(examples)

@see (links_or_references)

/*/
Method mtdVldFunc(c_NomFunc, l_Exibe) Class clsEtiquetas
	Local c_Info:= ""
	Local l_Ret := .T.
	Local a_Type, a_File, a_Line, a_Date, a_BType
	Local a_Func := GetFuncArray("u_"+c_NomFunc, a_Type, a_File, a_Line, a_Date, a_BType)

	If Valtype(a_File) <> "A"
		c_Info += 'Funcao nao encontrada no  R P O."
		l_Ret := .F.
	ElseIf len(a_File) == 0
		c_Info += 'Funcao nao encontrada no  R P O."
		l_Ret := .F.
	Endif

	If !Empty(c_Info)
		If l_Exibe
			msgInfo(c_Info)
		Endif
	Endif

Return(l_Ret)




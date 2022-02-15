#INCLUDE "TOTVS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "DBINFO.CH"
#Include 'Protheus.ch'
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "finxapi.ch"

#DEFINE CR_VLRABAT 01
#DEFINE CMP_VLABAT 3
#DEFINE ENTER CHR( 13 ) + CHR( 10 )
/*/{Protheus.doc} FFIEBW01
Web Service de Integracao com o Financeiro - FIEB
@author Totvs-BA
@since 01/10/2017
@version 1.0
/*/
WSSERVICE FFIEBW01 Description "<span style='color:red;'>Fabrica de Software - TOTVS BA</span><br/>&nbsp;&nbsp;&nbsp;<span style='color:red;'> WS de Integracao do sistema legado com ERP Microsiga Protheus</b>.</span>"

	//------------------------------------------------
	//Estrutura declarada no WS Fabrica (WSFABRICA.PRW)

	WSDATA o_Empresa	AS strEmpresa
	WSDATA o_Retorno	AS strRetorno
	WSDATA o_Seguranca	AS strSeguranca
	//-------------------------------------

	WSDATA Operacao			AS STRING
	WSDATA NumLiq			AS STRING
	WSDATA Banco			AS STRING
	WSDATA Agencia			AS STRING
	WSDATA Conta			AS STRING
	WSDATA o_TitOrigem		AS strBxOriLiq
	WSDATA o_TitDestino		AS strBxDesLiq

	WSDATA o_Clientes 		AS strClientes
	WSDATA o_Fornecedores 	AS strFornecedores
	WSDATA o_Produtos 		AS strProdutos
	WSDATA o_TitReceber 	AS strTitReceber
	WSDATA o_TitPagar 		AS strTitPagar
	WSDATA o_BxParam		AS strBxParam
	WSDATA o_TitRA			AS strRAS
	WSDATA o_PedidoVenda	AS strPedidoVenda
	WSDATA o_PedidoCompra	AS strPedidoCompra
	WSDATA o_Contabiliza	AS strContabiliza
	WSDATA o_GravaPedido	AS strGravaPedido
	WSDATA o_MovBancaria	AS strMovBancaria
	WSDATA o_TransBancaria	AS strTransBancaria
	WSDATA o_EstoTrBancaria	AS strEstoTransBancaria
	WSDATA o_MovBLote		AS strLotes
	WSDATA o_DocEntr		AS strDoc
	WSDATA o_BxPag			AS strBxPag
	WSDATA o_TitPA			AS strPAS
	
	//PROPRIEDADES DO METODO mtdTitulosProv
	WSDATA CNPJ 	 	AS STRING
	WSDATA TITULOS		AS ARRAY OF strTitulosProv

	WSDATA o_TitulosVeloz	AS ARRAY OF strTitulosVeloz
	WSDATA o_AtualizaVeloz	AS strAtualizaVeloz

	WSMETHOD mtdCliente			//Metodo que inclui/altera/exclui clientes
	WSMETHOD mtdFornecedores	//Metodo que inclui/altera/exclui fornecedores
	WSMETHOD mtdProdutos		//Metodo que inclui/altera/exclui produtos
	WSMETHOD mtdTitReceber		//Metodo que inclui/altera/exclui Titulos a Receber
	WSMETHOD mtdTitPagar		//Metodo que inclui/altera/exclui Titulos a Pagar
	WSMETHOD mtdBaixaTit		//Metodo de Baixa do Titulo a Receber
	WSMETHOD mtdGravaPV			//Metodo que inclui/altera/exclui pedido de venda
	WSMETHOD mtdGravaPC			//Metodo que inclui/altera/exclui pedido de compra
	WSMETHOD mtdContabiliza		//Metodo que inclui/exclui a contabilizacao
	WSMETHOD mtdGrvPedidoTit	//Metodo que grava o numero do pedido no titulo
	WSMETHOD mtdMovBancaria		//Metodo que grava a movimentacao bancaria
	WSMETHOD mtdTransBancaria	//Metodo que grava a transferencia bancaria
	WSMETHOD mtdEstoTrBancaria	//Metodo que estorna a transferencia bancaria
	WSMETHOD mtdLiquidacao		//Metodo que liquidacao
	WSMETHOD mtdBaixaPorLote	//Metodo de baixa por lote
	WSMETHOD mtdDocEntrada		//Metodo que inclui/altera/exclui documento de entrada
	WSMETHOD mtdBxPagar			//Metodo de Baixa do titulo a Pagar
	WSMETHOD mtdTitulosProv		//Metodo que retorna os titulos de provisao

	WSMETHOD mtdTitulosVeloz	//Metodo de Consulta da empresa de cobranca Veloz
	WSMETHOD mtdAtualizaVeloz	//Metodo de Atualizacao da empresa de cobranca Veloz

ENDWSSERVICE

WSSTRUCT strAtualizaVeloz

	WSDATA A1_CGC 		AS STRING
	WSDATA E1_PREFIXO 	AS STRING
	WSDATA E1_TIPO 		AS STRING
	WSDATA E1_NUM		AS STRING
	WSDATA E1_PARCELA	AS STRING
	WSDATA E1_STATUS	AS STRING
	WSDATA E1_ACORDOS	AS ARRAY OF strAcordosVeloz	OPTIONAL

ENDWSSTRUCT

WSSTRUCT strAcordosVeloz

	WSDATA Z06_VENCTO	AS STRING
	WSDATA Z06_VALOR	AS FLOAT
	WSDATA Z06_DATA		AS STRING
	WSDATA Z06_VACORD	AS FLOAT
	WSDATA Z06_TPPGTO	AS STRING
	WSDATA Z06_ACORDO	AS STRING
	
ENDWSSTRUCT

WSSTRUCT strTitulosVeloz

	WSDATA E1_FILIAL   AS STRING OPTIONAL
	WSDATA M0_NOMECOM  AS STRING OPTIONAL
	WSDATA M0_CGC 	   AS STRING OPTIONAL
	WSDATA E1_X_NOME   AS STRING OPTIONAL
	WSDATA A1_NOME     AS STRING OPTIONAL
	WSDATA A1_EMAIL    AS STRING OPTIONAL
	
	WSDATA A1_TEL	   AS STRING OPTIONAL
	WSDATA A1_DDD 	   AS STRING OPTIONAL

	WSDATA A1_XTELCOM  AS STRING OPTIONAL
	WSDATA A1_XDDCOM   AS STRING OPTIONAL

	WSDATA A1_XTELCEL  AS STRING OPTIONAL
	WSDATA A1_XDDDCEL  AS STRING OPTIONAL

	WSDATA A1_END	   AS STRING OPTIONAL
	WSDATA A1_COMPLEM  AS STRING OPTIONAL
	WSDATA A1_BAIRRO   AS STRING OPTIONAL
	WSDATA A1_MUN	   AS STRING OPTIONAL
	WSDATA A1_CEP	   AS STRING OPTIONAL
	WSDATA A1_EST	   AS STRING OPTIONAL
	WSDATA E1_PREFIXO  AS STRING OPTIONAL
	WSDATA E1_TIPO     AS STRING OPTIONAL
	WSDATA E1_NUM 	   AS STRING OPTIONAL
	WSDATA E1_PARCELA  AS STRING OPTIONAL
	WSDATA E1_EMISSAO  AS STRING OPTIONAL
	WSDATA E1_VENCTO   AS STRING OPTIONAL
	WSDATA E1_ATRASO   AS INTEGER OPTIONAL
	WSDATA E1_SALDO    AS FLOAT OPTIONAL
	WSDATA E1_XSTTTCB  AS STRING OPTIONAL
	WSDATA E1_XIDTIT   AS STRING OPTIONAL
	WSDATA ED_DESCRIC  AS STRING OPTIONAL
	WSDATA E1_XDESSIT  AS STRING OPTIONAL
	WSDATA E1_FSENVCB  AS STRING OPTIONAL
	WSDATA E1_FSHORCB  AS STRING OPTIONAL
	
	WSDATA l_Status1 	AS BOOLEAN OPTIONAL
	WSDATA c_Mensagem1	AS STRING OPTIONAL

ENDWSSTRUCT

/*/{Protheus.doc} strClientes
Atributos do metodo de clientes
@author Totvs-BA
@since 01/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strClientes

	WSDATA A1_CGC		AS STRING
	WSDATA A1_NOME		AS STRING
	WSDATA A1_NREDUZ	AS STRING
	WSDATA A1_TIPO		AS STRING
	WSDATA A1_PESSOA	AS STRING
	WSDATA A1_END		AS STRING
	WSDATA A1_EST		AS STRING
	WSDATA A1_MUN		AS STRING
	WSDATA A1_BAIRRO	AS STRING
	WSDATA A1_CEP		AS STRING
	WSDATA A1_EMAIL		AS STRING
	WSDATA A1_DDD		AS STRING
	WSDATA A1_TEL		AS STRING
	WSDATA A1_COD_MUN	AS STRING
	WSDATA A1_INSCR		AS STRING
	WSDATA A1_INSCRM	AS STRING
	WSDATA A1_RG		AS STRING
	WSDATA A1_COMPLEM	AS STRING
	WSDATA A1_CONTA		AS STRING
	WSDATA A1_CONTATO 	AS STRING
	WSDATA A1_TELEX 	AS STRING
	WSDATA A1_CODPAIS 	AS STRING OPTIONAL
	WSDATA A1_DTNASC 	AS STRING
	WSDATA XCONTATOS	AS ARRAY OF strContatos	OPTIONAL

ENDWSSTRUCT
/*/{Protheus.doc} strContatos
Estrutura dos contatos amarrados ao cliente
@author Totvs-BA
@since 08/06/2018
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strContatos

	WSDATA ZZS_NOMECONTATO	AS STRING
	WSDATA ZZS_EMAILCONTATO	AS STRING
	WSDATA ZZS_TELCONTATO	AS STRING
	
ENDWSSTRUCT
/*/{Protheus.doc} strFornecedores
Atributos do metodo de fornecedores
@author Totvs-BA
@since 01/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strFornecedores

	WSDATA A2_CGC		AS STRING
	WSDATA A2_NOME		AS STRING
	WSDATA A2_NREDUZ	AS STRING
	WSDATA A2_TIPO		AS STRING
	WSDATA A2_END		AS STRING
	WSDATA A2_EST		AS STRING
	WSDATA A2_MUN		AS STRING
	WSDATA A2_BAIRRO	AS STRING
	WSDATA A2_CEP		AS STRING
	WSDATA A2_EMAIL		AS STRING
	WSDATA A2_DDD		AS STRING
	WSDATA A2_TEL		AS STRING
	WSDATA A2_BANCO		AS STRING
	WSDATA A2_AGENCIA	AS STRING
	WSDATA A2_NUMCON	AS STRING
	WSDATA A2_XTPCONT	AS STRING
	WSDATA A2_COD_MUN	AS STRING
	WSDATA A2_XDVAGE	AS STRING
	WSDATA A2_XDVCTA	AS STRING
	WSDATA A2_INSCR		AS STRING
	WSDATA A2_INSCRM	AS STRING
	WSDATA A2_CODPAIS	AS STRING
	WSDATA A2_RECISS	AS STRING
	WSDATA A2_RECINSS	AS STRING
	WSDATA A2_RECPIS 	AS STRING
	WSDATA A2_RECCSLL	AS STRING
	WSDATA A2_RECCOFI	AS STRING
	WSDATA A2_CALCIRF	AS STRING
	WSDATA A2_CNAE		AS STRING
	WSDATA A2_COMPLEM	AS STRING
	WSDATA A2_CONTA		AS STRING
	WSDATA A2_CONTATO 	AS STRING
	WSDATA A2_TELEX 	AS STRING
	WSDATA MULBANCOS	AS ARRAY OF strBancos 	OPTIONAL

ENDWSSTRUCT
/*/{Protheus.doc} strBancos
Estrutura de multiplos bancos no cadatro de fornecedor
@author Totvs-BA
@since 08/06/2018
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strBancos

	WSDATA FIL_BANCO	AS STRING
	WSDATA FIL_AGENCIA	AS STRING
	WSDATA FIL_CONTA	AS STRING
	WSDATA FIL_TIPO		AS STRING
	WSDATA FIL_MOVCTO	AS STRING
	WSDATA FIL_DVAGE	AS STRING
	WSDATA FIL_DVCTA	AS STRING
	WSDATA FIL_TIPCTA	AS STRING

ENDWSSTRUCT
/*/{Protheus.doc} strProdutos
Atributos do metodo de produtos
@author Totvs-BA
@since 01/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strProdutos

	WSDATA B1_FILIAL	AS STRING
	WSDATA B1_COD		AS STRING
	WSDATA B1_DESC		AS STRING
	WSDATA B1_TIPO		AS STRING
	WSDATA B1_UM		AS STRING
	WSDATA B1_LOCPAD	AS STRING
	WSDATA B1_GRUPO		AS STRING
	WSDATA B1_RASTRO	AS STRING
	WSDATA B1_CONTA		AS STRING

ENDWSSTRUCT
/*/{Protheus.doc} strTitReceber
Atributos do metodo de titulos a receber
@author Totvs-BA
@since 01/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strTitReceber

	WSDATA E1_PREFIXO	AS STRING
	WSDATA E1_NUM    	AS STRING
	WSDATA E1_PARCELA	AS STRING
	WSDATA E1_TIPO   	AS STRING
	WSDATA CGC			AS STRING
	WSDATA E1_NATUREZ	AS STRING
	WSDATA E1_EMISSAO	AS STRING
	WSDATA E1_VENCTO 	AS STRING
	WSDATA E1_VALOR  	AS FLOAT
	WSDATA E1_HIST		AS STRING
	WSDATA E1_CONTA		AS STRING
	WSDATA E1_CCC		AS STRING
	WSDATA E1_ITEMC		AS STRING
	WSDATA E1_CLVLCR	AS STRING
	WSDATA E1_MULTA		AS FLOAT
	WSDATA E1_JUROS		AS FLOAT
	WSDATA E1_DESCONT	AS FLOAT
	WSDATA E1_XTITEMS	AS STRING
	WSDATA E1_XCONTR	AS STRING
	WSDATA E1_LA		AS STRING
	WSDATA DTCAN		AS STRING OPTIONAL //DATA DO CANCELAMENTO DO RA. Usado somente para o tipo RA e Se for exclusao do titulo de RA ITEM 10
	WSDATA E5_XNUMRM	AS STRING OPTIONAL //NUM DO RM PARA OS CASOS DO RM QUE GERA O SE5 NA INCLUSAO ITEM 14
	WSDATA RABANCO		AS STRING OPTIONAL
	WSDATA RAAGENC		AS STRING OPTIONAL
	WSDATA RACONTA		AS STRING OPTIONAL
	WSDATA OD_TIPO		AS STRING OPTIONAL //Comentado 25/09 ATENCAO PARA DESCOMENTAR A CUSTOMIZACAO DO OD, PROCURAR O TEXTO '//Comentado 25/09'
	WSDATA E1_FSCODAU	AS STRING OPTIONAL
	WSDATA E1_FSDTCOM	AS STRING OPTIONAL
	WSDATA NATRATEIO	AS ARRAY OF strMultNaturezas 	OPTIONAL

ENDWSSTRUCT
/*/{Protheus.doc} strTitPagar
Atributos do metodo de titulos a pagar
@author Totvs-BA
@since 01/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strTitPagar

	WSDATA E2_PREFIXO	AS STRING
	WSDATA E2_NUM    	AS STRING
	WSDATA E2_PARCELA	AS STRING
	WSDATA E2_TIPO   	AS STRING
	WSDATA CGC			AS STRING
	WSDATA E2_NATUREZ	AS STRING
	WSDATA E2_EMISSAO	AS STRING
	WSDATA E2_VENCTO 	AS STRING
	WSDATA E2_HIST		AS STRING
	WSDATA E2_VALOR  	AS FLOAT
	WSDATA E2_LA 		AS STRING
	WSDATA E2_XIDWBC	AS STRING
	WSDATA E2_RATEIO	AS STRING
	WSDATA E2_XTITEMS	AS STRING
	WSDATA E2_XPABCO	AS STRING
	WSDATA E2_XPAAGE	AS STRING
	WSDATA E2_XPACTA 	AS STRING
	WSDATA E2_ZBANCO	AS STRING
	WSDATA E2_ZAGENCI	AS STRING
	WSDATA E2_ZCONTA	AS STRING
	WSDATA E2_XMODELO	AS STRING
	WSDATA E2_CCD		AS STRING
	WSDATA E2_ITEMD		AS STRING
	WSDATA E2_CLVLDB	AS STRING
	WSDATA ESTRANGEIRO	AS STRING
	WSDATA E2_EMIS1		AS STRING
	WSDATA E2_FSNTFOL	AS STRING OPTIONAL
	WSDATA PABANCO		AS STRING OPTIONAL
	WSDATA PAAGENC		AS STRING OPTIONAL
	WSDATA PACONTA		AS STRING OPTIONAL
	WSDATA NATRATEIO	AS ARRAY OF strMultNaturezas 	OPTIONAL
	WSDATA ITENZJY		AS ARRAY OF strZJY		OPTIONAL
	WSDATA PAFUNC		AS ARRAY OF strPAFunc	OPTIONAL
	WSDATA TIT_ORQUEST	AS STRING OPTIONAL

ENDWSSTRUCT
/*/{Protheus.doc} strMultNaturezas
Atributos do metodo de multiplas naturezas
@author Totvs-BA
@since 01/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strMultNaturezas

	WSDATA EV_NATUREZ		AS STRING
	WSDATA EV_VALOR    		AS FLOAT
	WSDATA EV_PERC			AS FLOAT
	WSDATA CCUSTORATEIO		AS ARRAY OF strMultCCustos	OPTIONAL

ENDWSSTRUCT
/*/{Protheus.doc} strMultCCustos
Atributos do metodo de multiplas centro de custos
@author Totvs-BA
@since 01/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strMultCCustos

	WSDATA EZ_CCUSTO	AS STRING
	WSDATA EZ_VALOR    	AS FLOAT
	WSDATA EZ_PERC    	AS FLOAT
	WSDATA EZ_ITEMCTA	AS STRING

ENDWSSTRUCT

/*/{Protheus.doc} strZJY
Atributos da estrutura do rateio ZJY
@author Totvs-BA
@since 10/06/2019
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strZJY

	WSDATA ZJY_LINHA	AS STRING
	WSDATA ZJY_PERC		AS FLOAT
	WSDATA ZJY_FILDES	AS STRING
	WSDATA ZJY_CONTA	AS STRING
	WSDATA ZJY_VALOR	AS FLOAT
	WSDATA ZJY_ITEM		AS STRING
	WSDATA ZJY_CC		AS STRING
	WSDATA ZJY_CLVL		AS STRING

ENDWSSTRUCT

WSSTRUCT strPAFunc

	WSDATA E2_PREFIXO AS STRING
	WSDATA E2_NUM     AS STRING
	WSDATA E2_PARCELA AS STRING
	WSDATA E2_TIPO    AS STRING
	//WSDATA CGCPA	  AS STRING OPTIONAL

ENDWSSTRUCT


/*/{Protheus.doc} strCV4
Atributos da estrutura do ratieo CV4
@author Totvs-BA
@since 01/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strCV4

	WSDATA CV4_CONTAD		AS STRING
	WSDATA CV4_CONTAC  		AS STRING
	WSDATA CV4_VALOR		AS FLOAT
	WSDATA CV4_HIST  		AS STRING
	WSDATA CV4_CCD  		AS STRING
	WSDATA CV4_ITEMD  		AS STRING
	WSDATA CV4_CLVLDB  		AS STRING

ENDWSSTRUCT
/*/{Protheus.doc} strBxParam
Atributos da estrutura de baixa do titulo
@author Totvs-BA
@since 01/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strBxParam

	WSDATA AUTACRESC	AS FLOAT
	WSDATA AUTAGENCIA	AS STRING
	WSDATA AUTBANCO		AS STRING
	WSDATA AUTCONTA		AS STRING
	WSDATA AUTDECRESC	AS FLOAT
	WSDATA AUTDESCONT	AS FLOAT
	WSDATA AUTDTBAIXA	AS STRING
	WSDATA AUTDTCREDITO	AS STRING
	WSDATA AUTHIST		AS STRING
	WSDATA AUTJUROS		AS FLOAT
	WSDATA AUTMOTBX		AS STRING
	WSDATA AUTMULTA		AS FLOAT
	WSDATA AUTVALREC	AS FLOAT
	WSDATA SEQBAIXA		AS INTEGER
	WSDATA CGC			AS STRING
	WSDATA E1_NUM		AS STRING
	WSDATA E1_PARCELA	AS STRING
	WSDATA E1_PREFIXO	AS STRING
	WSDATA E1_TIPO		AS STRING
	WSDATA E5_XNUMRM	AS STRING
	WSDATA XIDBAIXARM	AS STRING

ENDWSSTRUCT
/*/{Protheus.doc} strRAS
Atributos da estrutura dos titulos por antecipacao
@author Totvs-BA
@since 05/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strRAS

	WSDATA TITRAS		AS ARRAY OF strTitRAS OPTIONAL

ENDWSSTRUCT
/*/{Protheus.doc} strTitRAS
Atributos da estrutura dos titulos de RA
@author Totvs-BA
@since 05/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strTitRAS

	WSDATA E1_FILIAL	AS STRING
	WSDATA E1_NUM		AS STRING
	WSDATA E1_PARCELA	AS STRING
	WSDATA E1_PREFIXO	AS STRING
	WSDATA E1_TIPO		AS STRING
	WSDATA VALORRA  	AS FLOAT

ENDWSSTRUCT
/*/{Protheus.doc} strPedidoVenda
Atributos da estrutura do pedido de venda
@author Totvs-BA
@since 09/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strPedidoVenda

	WSDATA C5_EMISSAO	AS STRING
	WSDATA C5_NATUREZ	AS STRING
	WSDATA C5_TIPO		AS STRING
	WSDATA CGC			AS STRING
	WSDATA C5_CONDPAG	AS STRING
	WSDATA C5_XMENNOTA	AS STRING
	WSDATA C5_TPFRETE	AS STRING
	WSDATA C5_FRETE		AS FLOAT
	WSDATA C5_PARC1		AS FLOAT
	WSDATA C5_DATA1		AS STRING
	WSDATA C5_XNS1		AS STRING
	WSDATA C5_PARC2		AS FLOAT
	WSDATA C5_DATA2		AS STRING
	WSDATA C5_XNS2		AS STRING
	WSDATA C5_PARC3		AS FLOAT
	WSDATA C5_DATA3		AS STRING
	WSDATA C5_XNS3		AS STRING
	WSDATA C5_PARC4		AS FLOAT
	WSDATA C5_DATA4		AS STRING
	WSDATA C5_XNS4		AS STRING
	WSDATA C5_XOS		AS STRING
	WSDATA C5_XCONV		AS STRING
	WSDATA C5_XIDESB	AS STRING
	WSDATA C5_XORIGEM	AS STRING
	WSDATA C5_XCLIDA	AS STRING
	WSDATA C5_XLOJDA	AS STRING
	WSDATA C5_XCONTRA	AS STRING
	WSDATA C5_XNOMES	AS STRING
	WSDATA PEDIDO		AS STRING OPTIONAL
	WSDATA FATAUT		AS STRING OPTIONAL
	WSDATA SERIE		AS STRING OPTIONAL
	WSDATA ITENPV		AS ARRAY OF strItensPV

ENDWSSTRUCT
/*/{Protheus.doc} strItensPV
Atributos da estrutura dos itens do pedido de venda
@author Totvs-BA
@since 09/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strItensPV

	WSDATA C6_ITEM		AS STRING
	WSDATA C6_PRODUTO	AS STRING
	WSDATA C6_QTDVEN	AS FLOAT
	WSDATA C6_PRCVEN	AS FLOAT
	WSDATA C6_VALOR		AS FLOAT
	WSDATA C6_QTDLIB	AS FLOAT
	WSDATA C6_TES		AS STRING
	WSDATA C6_CC		AS STRING
	WSDATA C6_CCUSTO	AS STRING
	WSDATA C6_ITEMCTA	AS STRING
	WSDATA C6_RATEIO	AS STRING
	WSDATA C6_ENTREG	AS STRING
	WSDATA NATRATEIO	AS ARRAY OF strAGG 	OPTIONAL

ENDWSSTRUCT

/*/{Protheus.doc} strAGG
Atributos da estrutura do rateio AGG
@author Totvs-BA
@since 01/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strAGG

	WSDATA AGG_ITEM		AS STRING
	WSDATA AGG_FILIAL	AS STRING
	WSDATA AGG_PERC		AS FLOAT
	WSDATA AGG_CONTA 	AS STRING
	WSDATA AGG_CC		AS STRING
	WSDATA AGG_ITEMCT	AS STRING
	WSDATA AGG_CLVL		AS STRING

ENDWSSTRUCT
/*/{Protheus.doc} strPedidoCompra
Atributos da estrutura do pedido de compra
@author Totvs-BA
@since 24/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strPedidoCompra

	WSDATA C7_EMISSAO	AS STRING
	WSDATA CGC			AS STRING
	WSDATA C7_COND		AS STRING
	WSDATA C7_CONTATO	AS STRING
	WSDATA C7_FILENT	AS STRING
	WSDATA C7_TPFRETE	AS STRING
	WSDATA C7_FRETE		AS FLOAT
	WSDATA C7_DESPESA	AS FLOAT
	WSDATA C7_SEGURO	AS FLOAT
	WSDATA C7_DESC1		AS FLOAT
	WSDATA C7_DESC2		AS FLOAT
	WSDATA C7_DESC3		AS FLOAT
	WSDATA C7_VLDESC	AS FLOAT
	WSDATA C7_MOEDA		AS STRING
	WSDATA C7_TXMOEDA	AS FLOAT
	WSDATA PEDIDO		AS STRING OPTIONAL
	WSDATA ITENPC		AS ARRAY OF strItensPC

ENDWSSTRUCT
/*/{Protheus.doc} strItensPC
Atributos da estrutura dos itens do pedido de compra
@author Totvs-BA
@since 09/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strItensPC

	WSDATA C7_ITEM		AS STRING
	WSDATA C7_PRODUTO	AS STRING
	WSDATA C7_QUANT		AS FLOAT
	WSDATA C7_PRECO		AS FLOAT
	WSDATA C7_TOTAL		AS FLOAT
	WSDATA C7_IPI		AS FLOAT
	WSDATA C7_DATPRF	AS STRING
	WSDATA C7_OBS		AS STRING
	WSDATA C7_CONTA		AS STRING
	WSDATA C7_TES		AS STRING
	WSDATA C7_RATEIO	AS STRING
	WSDATA C7_XPCWBC	AS STRING
	//WSDATA C7_XIDWBC	AS STRING
	WSDATA NATRATEIO	AS ARRAY OF strCH 	OPTIONAL

ENDWSSTRUCT
/*/{Protheus.doc} strCH
Atributos da estrutura do rateio AGG
@author Totvs-BA
@since 01/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strCH

	WSDATA CH_ITEM		AS STRING
	WSDATA CH_FILIAL	AS STRING
	WSDATA CH_PERC		AS FLOAT
	WSDATA CH_CONTA 	AS STRING
	WSDATA CH_CC		AS STRING
	WSDATA CH_ITEMCTA	AS STRING
	WSDATA CH_CLVL		AS STRING

ENDWSSTRUCT
/*/{Protheus.doc} strContabiliza
Atributos da estrutura da contabilizacao
@author Totvs-BA
@since 01/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strContabiliza

	WSDATA DDATALANC	AS STRING
	WSDATA CLOTE		AS STRING
	WSDATA CSUBLOTE		AS STRING
	WSDATA AGRAVADIRETO	AS STRING
	WSDATA ITENCT2		AS ARRAY OF strItensCT2

ENDWSSTRUCT
/*/{Protheus.doc} strItensCT2
Atributos da estrutura da contabilizacao
@author Totvs-BA
@since 01/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strItensCT2

	WSDATA REFLANC		AS STRING OPTIONAL
	WSDATA REFERENCIA	AS STRING OPTIONAL
	WSDATA PREFIXO		AS STRING OPTIONAL
	WSDATA NUMERO  		AS STRING OPTIONAL
	WSDATA PARCELA		AS STRING OPTIONAL
	WSDATA TIPO   		AS STRING OPTIONAL
	WSDATA PEDIDO  		AS STRING OPTIONAL
	WSDATA CGC			AS STRING
	WSDATA CT2_LINHA	AS STRING
	WSDATA CT2_MOEDLC	AS STRING
	WSDATA CT2_DC		AS STRING
	WSDATA CT2_DEBITO	AS STRING
	WSDATA CT2_CREDIT	AS STRING
	WSDATA CT2_VALOR	AS FLOAT
	WSDATA CT2_HIST		AS STRING
	WSDATA CT2_TPSALD	AS STRING
	WSDATA CT2_CCD		AS STRING
	WSDATA CT2_CCC		AS STRING
	WSDATA CT2_ITEMD	AS STRING
	WSDATA CT2_ITEMC	AS STRING
	WSDATA CT2_CLVLDB	AS STRING
	WSDATA CT2_CLVLCR	AS STRING
	WSDATA CT2_AT01DB	AS STRING
	WSDATA CT2_AT01CR	AS STRING
	WSDATA CT2_FSIDRM	AS STRING OPTIONAL

ENDWSSTRUCT
/*/{Protheus.doc} strGravaPedido
Atributos da estrutura para gravar o pedido no titulo
@author Totvs-BA
@since 01/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strGravaPedido

	WSDATA E1_PREFIXO	AS STRING
	WSDATA E1_NUM    	AS STRING
	WSDATA E1_PARCELA	AS STRING
	WSDATA E1_TIPO   	AS STRING
	WSDATA CGC			AS STRING
	WSDATA PEDIDO		AS STRING

ENDWSSTRUCT
/*/{Protheus.doc} strMovBancaria
Atributos da estrutura para gravar a movimentacao bancaria
@author Totvs-BA
@since 31/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strMovBancaria

	WSDATA E5_DATA		AS STRING
	WSDATA E5_MOEDA		AS STRING
	WSDATA E5_VALOR		AS FLOAT
	WSDATA E5_NATUREZ	AS STRING
	WSDATA E5_BANCO		AS STRING
	WSDATA E5_AGENCIA	AS STRING
	WSDATA E5_CONTA		AS STRING
	WSDATA E5_NUMCHEQ	AS STRING
	WSDATA E5_DOCUMEN	AS STRING
	WSDATA E5_BENEF		AS STRING
	WSDATA E5_HISTOR	AS STRING
	WSDATA E5_DEBITO	AS STRING
	WSDATA E5_CREDITO	AS STRING
	WSDATA E5_CCD		AS STRING
	WSDATA E5_CCC		AS STRING
	WSDATA E5_ITEMD		AS STRING
	WSDATA E5_ITEMC		AS STRING
	WSDATA E5_CLVLDB	AS STRING
	WSDATA E5_CLVLCR	AS STRING
	WSDATA REC			AS INTEGER

ENDWSSTRUCT
/*/{Protheus.doc} strTransBancaria
Atributos do metodo de transferncia bancaria
@author Totvs-BA
@since 31/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strTransBancaria

	WSDATA CBCOORIG		AS STRING
	WSDATA CAGENORIG	AS STRING
	WSDATA CCTAORIG		AS STRING
	WSDATA CNATURORI	AS STRING
	WSDATA CBCODEST		AS STRING
	WSDATA CAGENDEST	AS STRING
	WSDATA CCTADEST		AS STRING
	WSDATA CNATURDES	AS STRING
	WSDATA CTIPOTRAN	AS STRING
	WSDATA CDOCTRAN		AS STRING
	WSDATA NVALORTRAN	AS FLOAT
	WSDATA CHIST100		AS STRING
	WSDATA CBENEF100	AS STRING
	WSDATA AUTDTMOV		AS STRING
	WSDATA XIDTRANSRM	AS STRING

ENDWSSTRUCT
/*/{Protheus.doc} strEstoTransBancaria
Atributos do metodo de estorno da transferncia bancaria
@author Totvs-BA
@since 31/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strEstoTransBancaria

	WSDATA AUTNRODOC	AS STRING
	WSDATA AUTDTMOV		AS STRING
	WSDATA AUTBANCO		AS STRING
	WSDATA AUTAGENCIA	AS STRING
	WSDATA AUTCONTA		AS STRING
	WSDATA DATAESTORNO	AS STRING

ENDWSSTRUCT
/*/{Protheus.doc} strBxOriLiq
Atributos da estrutura de baixa do titulo pela liquidacao
@author Totvs-BA
@since 01/12/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strBxOriLiq

	WSDATA TITULOS	AS ARRAY OF strBxTitOrigem

ENDWSSTRUCT
/*/{Protheus.doc} strBxTitOrigem
Atributos da estrutura de baixa do titulo pela liquidacao
@author Totvs-BA
@since 01/12/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strBxTitOrigem

	WSDATA AUTACRESC	AS FLOAT
	WSDATA AUTAGENCIA	AS STRING
	WSDATA AUTBANCO		AS STRING
	WSDATA AUTCONTA		AS STRING
	WSDATA AUTDECRESC	AS FLOAT
	WSDATA AUTDESCONT	AS FLOAT
	WSDATA AUTDTBAIXA	AS STRING
	WSDATA AUTDTCREDITO	AS STRING
	WSDATA AUTHIST		AS STRING
	WSDATA AUTJUROS		AS FLOAT
	WSDATA AUTMOTBX		AS STRING
	WSDATA AUTMULTA		AS FLOAT
	WSDATA AUTVALREC	AS FLOAT
	WSDATA CGC			AS STRING
	WSDATA E1_FILIAL	AS STRING
	WSDATA E1_NUM		AS STRING
	WSDATA E1_PARCELA	AS STRING
	WSDATA E1_PREFIXO	AS STRING
	WSDATA E1_TIPO		AS STRING
	WSDATA E5_XNUMRM	AS STRING
	WSDATA XIDBAIXARM	AS STRING

ENDWSSTRUCT
/*/{Protheus.doc} strBxDesLiq
Atributos da estrutura de baixa do titulo pela liquidacao
@author Totvs-BA
@since 01/12/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strBxDesLiq

	WSDATA TITULOS	AS ARRAY OF strTitReceber

ENDWSSTRUCT
/*/{Protheus.doc} strLotes
Atributos da estrutura da baixa por lote
@author Totvs-BA
@since 0/04/2018
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strLotes

	WSDATA BAIXASTIT	AS ARRAY OF strBxLote
	WSDATA MOVBANCA		AS ARRAY OF strMovBLote

ENDWSSTRUCT
/*/{Protheus.doc} strMovBLote
Atributos da estrutura para gravar a movimentacao bancarias da baixa por lote
@author Totvs-BA
@since 30/04/2018
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strMovBLote

	WSDATA E5_DATA		AS STRING
	WSDATA E5_VALOR		AS FLOAT
	WSDATA E5_NATUREZ	AS STRING
	WSDATA E5_BANCO		AS STRING
	WSDATA E5_AGENCIA	AS STRING
	WSDATA E5_CONTA		AS STRING
	WSDATA E5_MOEDA		AS STRING
	WSDATA E5_DOCUMEN	AS STRING
	WSDATA E5_NUMCHEQ	AS STRING
	WSDATA E5_BENEF		AS STRING
	WSDATA E5_HISTOR	AS STRING
	WSDATA E5_DEBITO	AS STRING
	WSDATA E5_CREDITO	AS STRING
	WSDATA E5_CCD		AS STRING
	WSDATA E5_CCC		AS STRING
	WSDATA E5_ITEMD		AS STRING
	WSDATA E5_ITEMC		AS STRING
	WSDATA E5_CLVLDB	AS STRING
	WSDATA E5_CLVLCR	AS STRING
	WSDATA E5_LOTE 		AS STRING
	WSDATA E5_FSLORM	AS STRING

ENDWSSTRUCT
/*/{Protheus.doc} strBxLote
Atributos da estrutura de baixa do titulo na baixa por lote
@author Totvs-BA
@since 01/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strBxLote

	WSDATA AUTACRESC	AS FLOAT
	WSDATA AUTAGENCIA	AS STRING
	WSDATA AUTBANCO		AS STRING
	WSDATA AUTCONTA		AS STRING
	WSDATA AUTDECRESC	AS FLOAT
	WSDATA AUTDESCONT	AS FLOAT
	WSDATA AUTDTBAIXA	AS STRING
	WSDATA AUTDTCREDITO	AS STRING
	WSDATA AUTHIST		AS STRING
	WSDATA AUTJUROS		AS FLOAT
	WSDATA AUTMOTBX		AS STRING
	WSDATA AUTMULTA		AS FLOAT
	WSDATA AUTVALREC	AS FLOAT
	WSDATA CGC			AS STRING
	WSDATA E1_FILIAL	AS STRING
	WSDATA E1_NUM		AS STRING
	WSDATA E1_PARCELA	AS STRING
	WSDATA E1_PREFIXO	AS STRING
	WSDATA E1_TIPO		AS STRING
	WSDATA E1_LOTE 		AS STRING
	WSDATA E1_FSLORM	AS STRING
	WSDATA E5_XNUMRM	AS STRING
	WSDATA XIDBAIXARM	AS STRING

ENDWSSTRUCT
/*/{Protheus.doc} strDoc
Atributos da estrutura do documento de entrada
@author Totvs-BA
@since 14/05/2018
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strDoc

	WSDATA F1_TIPO		AS STRING
	WSDATA F1_DOC		AS STRING
	WSDATA F1_SERIE		AS STRING
	WSDATA F1_EMISSAO	AS STRING
	WSDATA F1_ESPECIE	AS STRING
	WSDATA F1_COND		AS STRING
	//WSDATA VALOR_CAUCAO	AS FLOAT - Descomentar Item caucao Planilha
	WSDATA XPORTADO		AS STRING
	WSDATA XAGENCIA		AS STRING
	WSDATA XCCORRENT	AS STRING
	WSDATA XMULTARQ		AS ARRAY OF strMultArqs
	WSDATA CGC			AS STRING
	WSDATA NATUREZA		AS STRING
	WSDATA xESTISS		AS STRING	OPTIONAL
	WSDATA xIBGEISS		AS STRING	OPTIONAL
	WSDATA XHISTORICO	AS STRING
	WSDATA ITEND1		AS ARRAY OF strItensD1
	WSDATA NATRATEIO	AS ARRAY OF strD1MultNat 	OPTIONAL

ENDWSSTRUCT
/*/{Protheus.doc} strItensD1
Atributos da estrutura dos itens do documento de entrada
@author Totvs-BA
@since 14/05/2018
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strItensD1

	WSDATA D1_ITEM		AS STRING
	WSDATA D1_COD		AS STRING
	WSDATA D1_TES		AS STRING
	WSDATA D1_QUANT		AS FLOAT
	WSDATA D1_VUNIT		AS FLOAT
	WSDATA D1_TOTAL		AS FLOAT
	WSDATA D1_CONTA 	AS STRING
	WSDATA D1_CC		AS STRING
	WSDATA D1_ITEMCTA	AS STRING
	WSDATA D1_BASEISS	AS FLOAT	OPTIONAL
	WSDATA D1_ALIQISS	AS FLOAT	OPTIONAL
	WSDATA D1_BASEIRR	AS FLOAT	OPTIONAL
	WSDATA D1_ALIQIRR	AS FLOAT	OPTIONAL
	WSDATA D1_BASEINS	AS FLOAT	OPTIONAL
	WSDATA D1_ALIQINS	AS FLOAT	OPTIONAL
	WSDATA ITENZJW		AS ARRAY OF strZJW		OPTIONAL

ENDWSSTRUCT

/*/{Protheus.doc} strZJW
Atributos da estrutura do rateio ZJW
@author Totvs-BA
@since 25/05/2018 -> 05/07/2018
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strZJW

	WSDATA ZJW_LINHA	AS STRING
	WSDATA ZJW_PERC		AS FLOAT
	WSDATA ZJW_FILDES	AS STRING
	WSDATA ZJW_CONTA	AS STRING
	WSDATA ZJW_VALOR	AS FLOAT
	WSDATA ZJW_ITEM		AS STRING
	WSDATA ZJW_CC		AS STRING
	WSDATA ZJW_CLVL		AS STRING

ENDWSSTRUCT
/*/{Protheus.doc} strD1MultNat
Atributos do metodo de multiplas naturezas no documento de entrada
@author Totvs-BA
@since 25/05/2018
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strD1MultNat

	WSDATA EV_NATUREZ		AS STRING
	//WSDATA EV_VALOR    		AS FLOAT
	WSDATA EV_PERC			AS FLOAT

ENDWSSTRUCT
/*/{Protheus.doc} strD1MultNat
Estrutura de multiplos arquivos para anexar no documento de entrada
@author Totvs-BA
@since 23/07/2018
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strMultArqs

	WSDATA XNOMEARQ			AS STRING

ENDWSSTRUCT

/*/{Protheus.doc} strBxPag
Atributos da estrutura de baixa do titulo a pagar
@author Totvs-BA
@since 21/03/2019
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strBxPag

	WSDATA AUTMOTBX		AS STRING
	WSDATA AUTBANCO		AS STRING
	WSDATA AUTAGENCIA	AS STRING
	WSDATA AUTCONTA		AS STRING
	WSDATA AUTDTBAIXA	AS STRING
	WSDATA AUTDTCREDITO	AS STRING
	WSDATA AUTHIST		AS STRING
	WSDATA AUTVLRPG		AS FLOAT
	WSDATA AUTDESCONT	AS FLOAT
	WSDATA AUTJUROS		AS FLOAT
	WSDATA E2_PREFIXO	AS STRING
	WSDATA E2_NUM		AS STRING
	WSDATA E2_PARCELA	AS STRING
	WSDATA E2_TIPO		AS STRING
	WSDATA CGC			AS STRING

ENDWSSTRUCT

/*/{Protheus.doc} strPAS
Atributos da estrutura dos titulos de PA
@author Totvs-BA
@since 22/03/2019
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strPAS

	WSDATA TITPAS		AS ARRAY OF strTitPAS OPTIONAL

ENDWSSTRUCT
/*/{Protheus.doc} strTitPAS
Atributos da estrutura dos titulos de RA
@author Totvs-BA
@since 22/03/2019
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSSTRUCT strTitPAS

	WSDATA E2_NUM		AS STRING
	WSDATA E2_PARCELA	AS STRING
	WSDATA E2_PREFIXO	AS STRING
	WSDATA E2_TIPO		AS STRING
	WSDATA VALORPA  	AS FLOAT

ENDWSSTRUCT

//TIPO DO RETORNO
WSSTRUCT strTitulosProv

	WSDATA E2_FILIAL 	AS STRING OPTIONAL
	WSDATA E2_PREFIXO 	AS STRING OPTIONAL
	WSDATA E2_NUM	    AS STRING OPTIONAL
	WSDATA E2_PARCELA	AS STRING OPTIONAL
	WSDATA E2_TIPO	    AS STRING OPTIONAL
	WSDATA E2_NATUREZ	AS STRING OPTIONAL
	WSDATA E2_FORNECE	AS STRING OPTIONAL
	WSDATA E2_LOJA	    AS STRING OPTIONAL
	WSDATA A2_NREDUZ	AS STRING OPTIONAL
	WSDATA E2_HIST		AS STRING OPTIONAL
	WSDATA E2_EMISSAO	AS STRING OPTIONAL
	WSDATA E2_VENCTO	AS STRING OPTIONAL
	WSDATA E2_VENCREA	AS STRING OPTIONAL
	WSDATA E2_VALOR	    AS FLOAT OPTIONAL
	WSDATA E2_SALDO 	AS FLOAT OPTIONAL
    WSDATA STATUS       AS BOOLEAN OPTIONAL
    WSDATA MENSAGEM     AS STRING OPTIONAL
	
ENDWSSTRUCT

WSMETHOD mtdAtualizaVeloz WSRECEIVE o_Seguranca, o_Empresa, o_AtualizaVeloz WSSEND o_Retorno WSSERVICE FFIEBW01

	Local c_UserWS		:= ""
	Local c_PswWS		:= ""

	//Loga na filial solicitada
	RpcSetType(3)
	RpcSetEnv(o_Empresa:c_Empresa,o_Empresa:c_Filial, "integracao", "fieb123")

	c_UserWS	:= Upper(ALLTRIM(SUPERGETMV("FS_FIUSRWS",,"totvs_fieb")))
	c_PswWS		:= Upper(ALLTRIM(SUPERGETMV("FS_FIPSWWS",,"totvs@123")))

	//Validando o usuario e senha
	If ( Upper( o_Seguranca:c_Usuario ) <> Upper( c_UserWS ) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem1		:= "Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdAtualizaVeloz: Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido.")
		Return(.T.)
	Endif

	If ( Upper( o_Seguranca:c_Senha ) <> Upper( c_PswWS ) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem1	:= "Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdAtualizaVeloz: Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida.")
		Return(.T.)
	endif

	If !( f_VldFilEmp( o_Empresa:c_Empresa,o_Empresa:c_Filial ) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Codigo de Empresa/Filial nao existe."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdAtualizaVeloz: Codigo de Empresa/Filial nao existe.")
		Return(.T.)
	EndIf

	dbSelectArea("SA1")
	dbSetOrder(3)
	if !dbSeek( xFilial("SA1") + o_AtualizaVeloz:A1_CGC, .T.)
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "CNPJ " + Alltrim( o_AtualizaVeloz:A1_CGC ) + " nao encontrado na base de dados"+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdAtualizaVeloz: CNPJ " + Alltrim( o_AtualizaVeloz:A1_CGC ) + " nao encontrado na base de dados")
		Return(.T.)
	endif

	//E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
	//PADR(c_CodX, TAMSX3("A2_COD")[1])
	dbSelectArea("SE1")
	dbSetOrder(1)
	if !dbSeek( o_Empresa:c_Filial + PADR( o_AtualizaVeloz:E1_PREFIXO, TAMSX3("E1_PREFIXO")[1] ) + PADR( o_AtualizaVeloz:E1_NUM, TAMSX3("E1_NUM")[1] ) + PADR( o_AtualizaVeloz:E1_PARCELA, TAMSX3("E1_PARCELA")[1] ) + PADR( o_AtualizaVeloz:E1_TIPO, TAMSX3("E1_TIPO")[1] ) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "O titulo informado nao encontrado na base de dados"+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdAtualizaVeloz: O titulo informado nao encontrado na base de dados.")
		Return(.T.)
	else
		
		RecLock("SE1",.F.)
		SE1->E1_XSTTTCB := o_AtualizaVeloz:E1_STATUS
		MsUnlock()

		if !Empty( o_AtualizaVeloz:E1_ACORDOS[1]:Z06_ACORDO )

			dbSelectArea("Z06")
			dbSetOrder(2)
			if DbSeek( o_Empresa:c_Filial + o_AtualizaVeloz:E1_ACORDOS[1]:Z06_ACORDO, .T. )
				While Z06->( !EOF() ) .And.  Z06->(Z06_FILIAL + Z06_ACORDO ) == xFilial("Z06") + o_AtualizaVeloz:E1_ACORDOS[1]:Z06_ACORDO

					RecLock("Z06", .T.)
					dbDelete()
					MsUnlock()

					Z06->( dbSkip() )

				enddo
			endif

			for nX := 1 to Len(o_AtualizaVeloz:E1_ACORDOS)

				RecLock("Z06", .T.)
				Z06->Z06_FILIAL	:= o_Empresa:c_Filial
				Z06->Z06_PREFIX	:= o_AtualizaVeloz:E1_PREFIXO
				Z06->Z06_TIPO	:= o_AtualizaVeloz:E1_TIPO
				Z06->Z06_NUM	:= o_AtualizaVeloz:E1_NUM
				Z06->Z06_PARCEL	:= o_AtualizaVeloz:E1_PARCELA
				Z06->Z06_VENCTO	:= CTOD( o_AtualizaVeloz:E1_ACORDOS[nX]:Z06_VENCTO )
				Z06->Z06_VALOR	:= o_AtualizaVeloz:E1_ACORDOS[nX]:Z06_VALOR
				Z06->Z06_DATA	:= CTOD( o_AtualizaVeloz:E1_ACORDOS[nX]:Z06_DATA )
				Z06->Z06_VACORD	:= o_AtualizaVeloz:E1_ACORDOS[nX]:Z06_VACORD
				Z06->Z06_TPPGTO	:= o_AtualizaVeloz:E1_ACORDOS[nX]:Z06_TPPGTO
				Z06->Z06_ACORDO	:= o_AtualizaVeloz:E1_ACORDOS[nX]:Z06_ACORDO
				MsUnlock()

			next

		endif

		::o_Retorno:l_Status		:= .T.
		::o_Retorno:c_Mensagem		:= "O titulo atualizado com sucesso!!!"+CHR(13)+CHR(10)
		
		Conout("FFIEBW01 - mtdAtualizaVeloz: O titulo atualizado com sucesso!!!")

		Return(.T.)

	endif

Return(.T.)

WSMETHOD mtdTitulosVeloz WSRECEIVE o_Seguranca, o_Empresa WSSEND o_TitulosVeloz WSSERVICE FFIEBW01

	Local o_Retorno
	Local c_UserWS		:= ""
	Local c_PswWS		:= ""
	Local c_Query		:= ""
	Local c_NomEmp 		:= ""
	Local c_NomFil 		:= ""
	Local c_DescSitCB	:= ""

	//Loga na filial solicitada
	RpcSetType(3)
	RpcSetEnv(o_Empresa:c_Empresa,o_Empresa:c_Filial, "integracao", "fieb123")

	c_UserWS	:= Upper(ALLTRIM(SUPERGETMV("FS_FIUSRWS",,"totvs_fieb")))
	c_PswWS		:= Upper(ALLTRIM(SUPERGETMV("FS_FIPSWWS",,"totvs@123")))

	o_Retorno := WSCLASSNEW("strTitulosVeloz")

	//Validando o usuario e senha
	If ( Upper( o_Seguranca:c_Usuario ) <> Upper( c_UserWS ) )
		o_Retorno:l_Status1		:= .F.
		o_Retorno:c_Mensagem1		:= "Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdTitulosVeloz: Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido.")
		Return(.T.)
	Endif

	If ( Upper( o_Seguranca:c_Senha ) <> Upper( c_PswWS ) )
		o_Retorno:l_Status1		:= .F.
		o_Retorno:c_Mensagem1	:= "Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida."+CHR(13)+CHR(10)
		AADD(Self:o_TitulosVeloz,o_Retorno)
		Conout("FFIEBW01 - mtdTitulosVeloz: Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida.")
		Return(.T.)
	endif

	If !( f_VldFilEmp( o_Empresa:c_Empresa,o_Empresa:c_Filial ) )
		o_Retorno:l_Status1		:= .F.
		o_Retorno:c_Mensagem1		:= "Codigo de Empresa/Filial nao existe."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdTitulosVeloz: Codigo de Empresa/Filial nao existe.")
		Return(.T.)
	EndIf

	dbSelectArea("SM0")
	dbSeek( o_Empresa:c_Empresa + o_Empresa:c_Filial )

	c_Query := " SELECT TOP 1000 "
	c_Query += " 	E1_FILIAL, "
	c_Query += "	E1_X_NOME, "
	c_Query += "	A1_NOME, "
	c_Query += "	A1_EMAIL, "
	c_Query += "	A1_DDD, "
	c_Query += "	A1_TEL,	"
	c_Query += "	A1_XDDCOM, "
	c_Query += "	A1_XTELCOM, "
	c_Query += "	A1_XDDDCEL,	"
	c_Query += "	A1_XTELCEL,	"
	c_Query += "	A1_END, "	 
	c_Query += "	A1_COMPLEM, " 
	c_Query += "	A1_BAIRRO, "
	c_Query += "	A1_MUN, "
	c_Query += "	A1_CEP, "
	c_Query += "	A1_EST, "
	c_Query += "	E1_PREFIXO, "
	c_Query += "	E1_TIPO, "
	c_Query += "	E1_NUM, "
	c_Query += "	E1_PARCELA, "
	c_Query += "	E1_EMISSAO, "
	c_Query += "	E1_VENCTO, "
	c_Query += "	E1_VENCTO, "
	c_Query += "	E1_SALDO, "
	c_Query += "	E1_XIDTIT, "
	c_Query += "	E1_XSTTTCB, "
	c_Query += "	ED_DESCRIC, "
	c_Query += "	E1_FSENVCB, "
	c_Query += "	E1_FSHORCB, "
	c_Query += "	E1.R_E_C_N_O_ "
	c_Query += " FROM "
	c_Query += "	" + RETSQLNAME("SE1") + " E1 WITH (NOLOCK) "
	c_Query += " INNER JOIN  "
	c_Query += "	" + RETSQLNAME("SA1") + " A1 WITH (NOLOCK) "
	c_Query += " ON "
	c_Query += "	A1.D_E_L_E_T_ = '' "
	c_Query += "	AND E1.E1_CLIENTE = A1.A1_COD "
	c_Query += "	AND E1.E1_LOJA = A1.A1_LOJA "
	c_Query += " INNER JOIN  "
	c_Query += "	" + RETSQLNAME("SED") + " ED WITH (NOLOCK) "
	c_Query += " ON "
	c_Query += "	ED.D_E_L_E_T_ = '' "
	c_Query += "	AND ED.ED_CODIGO = E1.E1_NATUREZ "
	c_Query += "WHERE  "
	c_Query += "	E1.D_E_L_E_T_ = '' "
	c_Query += "	AND SUBSTRING(E1.E1_FILIAL,1,4) = '" + o_Empresa:c_Filial + "' "
	c_Query += "	AND E1.E1_SALDO > 0 "
	c_Query += "	AND E1.E1_VENCTO > 90 "
	c_Query += "	AND E1.E1_FSENVCB = '' "
	c_Query += "	AND E1.E1_XSTTTCB IN ('2', '7', '9', '13') "
	
	TCQUERY c_Query New ALIAS "QRY"

	DBSELECTAREA("QRY")
	WHILE QRY->( !EOF() )

		if Alltrim( QRY->E1_XSTTTCB ) == "0"
			c_DescSitCB := "Sem Status"
		elseif Alltrim( QRY->E1_XSTTTCB ) == "1"
			c_DescSitCB := "Enviado para Aprovacao"
		elseif Alltrim( QRY->E1_XSTTTCB ) == "2"
			c_DescSitCB := "Aprovado"
		elseif Alltrim( QRY->E1_XSTTTCB ) == "3"
			c_DescSitCB := "Recusado"
		elseif Alltrim( QRY->E1_XSTTTCB ) == "4"
			c_DescSitCB := "Renegociado"
		elseif Alltrim( QRY->E1_XSTTTCB ) == "5"
			c_DescSitCB := " Perda"
		elseif Alltrim( QRY->E1_XSTTTCB ) == "7"
			c_DescSitCB := "Enviado para Cobranca"
		elseif Alltrim( QRY->E1_XSTTTCB ) == "9"
			c_DescSitCB := "Inconsistente"
		elseif Alltrim( QRY->E1_XSTTTCB ) == "11"
			c_DescSitCB := "Prescrito"
		elseif Alltrim( QRY->E1_XSTTTCB ) == "12"
			c_DescSitCB := "Sem Exito"
		elseif Alltrim( QRY->E1_XSTTTCB ) == "13"
			c_DescSitCB := "Lib.Rec.Manual
		elseif Alltrim( QRY->E1_XSTTTCB ) == "14"
			c_DescSitCB := "Bx.Emp.Cob"
		else
			c_DescSitCB := "Nao identificado"
		endif

		o_Retorno := WSCLASSNEW("strTitulosVeloz")

		o_Retorno:E1_FILIAL		:= QRY->E1_FILIAL
		o_Retorno:M0_NOMECOM	:= SM0->M0_FILIAL
		o_Retorno:M0_CGC 		:= SM0->M0_CGC
		o_Retorno:A1_NOME 		:= QRY->A1_NOME
		o_Retorno:E1_X_NOME 	:= QRY->E1_X_NOME
		o_Retorno:A1_EMAIL  	:= QRY->A1_EMAIL
		o_Retorno:A1_DDD 		:= QRY->A1_DDD
		o_Retorno:A1_TEL		:= QRY->A1_TEL
		o_Retorno:A1_XDDCOM    	:= QRY->A1_XDDCOM
		o_Retorno:A1_XTELCOM 	:= QRY->A1_XTELCOM
		o_Retorno:A1_XDDDCEL	:= QRY->A1_XDDDCEL
		o_Retorno:A1_XTELCEL	:= QRY->A1_XTELCEL
		o_Retorno:A1_END		:= QRY->A1_END
		o_Retorno:A1_COMPLEM  	:= QRY->A1_COMPLEM
		o_Retorno:A1_BAIRRO 	:= QRY->A1_BAIRRO
		o_Retorno:A1_MUN		:= QRY->A1_MUN
		o_Retorno:A1_CEP		:= QRY->A1_CEP
		o_Retorno:A1_EST		:= QRY->A1_EST
		o_Retorno:E1_PREFIXO	:= QRY->E1_PREFIXO
		o_Retorno:E1_TIPO   	:= QRY->E1_TIPO
		o_Retorno:E1_NUM 		:= QRY->E1_NUM
		o_Retorno:E1_PARCELA	:= QRY->E1_PARCELA
		o_Retorno:E1_EMISSAO	:= DTOC(STOD(QRY->E1_EMISSAO))
		o_Retorno:E1_VENCTO 	:= DTOC(STOD(QRY->E1_EMISSAO))
		o_Retorno:E1_ATRASO 	:= DDATABASE - STOD(QRY->E1_VENCTO)
		o_Retorno:E1_SALDO  	:= QRY->E1_SALDO
		o_Retorno:E1_XIDTIT		:= QRY->E1_XIDTIT
		o_Retorno:ED_DESCRIC	:= QRY->ED_DESCRIC
		o_Retorno:E1_XSTTTCB 	:= QRY->E1_XSTTTCB
		o_Retorno:E1_XDESSIT 	:= c_DescSitCB
		o_Retorno:E1_FSENVCB 	:= QRY->E1_FSENVCB
		o_Retorno:E1_FSHORCB	:= QRY->E1_FSHORCB

		AADD(Self:o_TitulosVeloz,o_Retorno)

		dbSelectArea("SE1")
		dbSetOrder(1)
		if dbSeek( QRY->E1_FILIAL + QRY->E1_PREFIXO + QRY->E1_NUM + QRY->E1_PARCELA + QRY->E1_TIPO )
			RecLock("SE1",.F.)
			SE1->E1_FSENVCB	:= Date()
			SE1->E1_FSHORCB	:= Subst(Time(),1,5)
			MsUnlock()
		endif

		QRY->(DBSKIP())

	ENDDO

	QRY->(DBCLOSEAREA())

RETURN(.T.)

/*/{Protheus.doc} mtdCliente
metodo de clientes
@author Totvs-BA
@since 01/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSMETHOD mtdCliente WSRECEIVE o_Seguranca, o_Empresa, o_Clientes, Operacao WSSEND o_Retorno WSSERVICE FFIEBW01

	Local c_Cod			:= ""
	Local c_Loja		:= ""
	Local i				:= 0
	Local n_Operacao	:= Val(::Operacao)
	Local c_Item      	:= ""
	Local c_Codigo    	:= ""
	Local c_Descricao 	:= ""
	Local a_Vetor		:= {}
	Local l_ErrEnt		:= .F.
	Local n_OperEnt		:= 3
	Local c_EmailZZS	:= ""
	Local p				:= 0

	PRIVATE lMsErroAuto := .F.

	::o_Retorno	:= WSCLASSNEW("strRetorno")

	If !(f_VldFilEmp(o_Empresa:c_Empresa,o_Empresa:c_Filial))
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Codigo de Empresa/Filial nao existe."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdCliente: Codigo de Empresa/Filial nao existe.")
		Return(.T.)
	EndIf

	//Loga na filial solicitada
	RpcSetType(3)
	RpcSetEnv(o_Empresa:c_Empresa,o_Empresa:c_Filial, "integracao", "fieb123")

	//Posiciona na empresa e filial passada
	dbSelectArea("SM0")
	dbSeek(o_Empresa:c_Empresa+o_Empresa:c_Filial)

	cFilAnt	:= o_Empresa:c_Filial

	//__cUserId:= "000359"
	//cusuario:= "******Integracao WebSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN"

	c_UserWS	:= Upper(ALLTRIM(SUPERGETMV("FS_FIUSRWS",,"totvs_fieb")))
	c_PswWS		:= Upper(ALLTRIM(SUPERGETMV("FS_FIPSWWS",,"totvs@123")))

	//Validando o usuario e senha
	If ( Upper(o_Seguranca:c_Usuario) <> Upper(c_UserWS) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdCliente: Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido.")
		Return(.T.)
	ElseIf ( Upper(o_Seguranca:c_Senha) <> Upper(c_PswWS) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdCliente: Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida.")
		Return(.T.)
	ElseIf (n_Operacao < 3) .Or. (n_Operacao > 5)
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Valor passado no parametro Operacao ("+cValToChar(n_Operacao)+") invalido. Informar (3=Inclusao; 4=Alteracao; 5=Exclusao)."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdCliente: Valor passado no parametro Operacao ("+cValToChar(n_Operacao)+") invalido. Informar (3=Inclusao; 4=Alteracao; 5=Exclusao).")
		Return(.T.)
	Else
		If Empty(o_Clientes:A1_CGC)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "CNPJ ou CPF nao foi informado."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdCliente: CNPJ ou CPF nao foi informado.")
			Return(.T.)
		ElseIf (Upper(Alltrim(o_Clientes:A1_TIPO)) <> "F") .And. (Upper(Alltrim(o_Clientes:A1_TIPO)) <> "L") .And. (Upper(Alltrim(o_Clientes:A1_TIPO)) <> "R") .And. (Upper(Alltrim(o_Clientes:A1_TIPO)) <> "S") .And. (Upper(Alltrim(o_Clientes:A1_TIPO)) <> "X")
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Tipo "+Upper(Alltrim(o_Clientes:A1_TIPO))+" invalido. Informar: (F ou L ou R ou S ou X)."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdCliente: Tipo "+Upper(Alltrim(o_Clientes:A1_TIPO))+" invalido. Informar: (F ou L ou R ou S ou X).")
			Return(.T.)
		ElseIf (Upper(Alltrim(o_Clientes:A1_PESSOA)) <> "F") .And. (Upper(Alltrim(o_Clientes:A1_PESSOA)) <> "J") .And. ( Upper(Alltrim(o_Clientes:A1_TIPO)) <> "X" )
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Pessoa "+Upper(Alltrim(o_Clientes:A1_PESSOA))+" invalida. Informar: (F ou J)."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdCliente: Pessoa "+Upper(Alltrim(o_Clientes:A1_PESSOA))+" invalida. Informar: (F ou J).")
			Return(.T.)
		Else
			DBSELECTAREA("CC2")
			DBSETORDER(1)
			IF !DBSEEK(xFilial("CC2")+Upper(o_Clientes:A1_EST)+o_Clientes:A1_COD_MUN)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "O codigo do municipio ("+Alltrim(o_Clientes:A1_COD_MUN)+") nao existe para o estado "+ o_Clientes:A1_EST +"."
				Conout("FFIEBW01 - mtdCliente: O codigo do municipio ("+Alltrim(o_Clientes:A1_COD_MUN)+") nao existe para o estado "+ o_Clientes:A1_EST +".")
				Return(.T.)
			EndIf
			//Validando a conta contabil
			If !Empty(o_Clientes:A1_CONTA)
				DBSELECTAREA("CT1")
				DBSETORDER(1)
				IF !DBSEEK(xFilial("CT1")+Alltrim(o_Clientes:A1_CONTA))
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_Clientes:A1_CONTA)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+"."
					Conout("FFIEBW01 - mtdCliente: Codigo da conta contabil ("+Alltrim(o_Clientes:A1_CONTA)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+".")
					Return(.T.)
				ElseIf CT1->CT1_CLASSE == "1"
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_Clientes:A1_CONTA)+") nao pode ser sintetica."
					Conout("FFIEBW01 - mtdCliente: Codigo da conta contabil ("+Alltrim(o_Clientes:A1_CONTA)+") nao pode ser sintetica.")
					Return(.T.)
				ElseIf CT1->CT1_BLOQ == "1"
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_Clientes:A1_CONTA)+") esta bloqueada para uso."
					Conout("FFIEBW01 - mtdCliente: Codigo da conta contabil ("+Alltrim(o_Clientes:A1_CONTA)+")  esta bloqueada para uso.")
					Return(.T.)
				EndIf
			EndIf
			//Cliente Estrangeiro
			If( Upper( Alltrim( o_Clientes:A1_TIPO ) ) == "X" )
				If (n_Operacao = 3)
					/*c_CodX:= GETSXENUM("SA1","A1_COD")
					c_CodX:= PADR(c_CodX, TAMSX3("A1_COD")[1])
					c_LojX:= SUBSTR(c_CodX,6,4)
					c_LojX:= PADR(c_LojX, TAMSX3("A1_LOJA")[1])
					DBSELECTAREA("SA1")
					DBSETORDER(1)
					If DBSEEK(XFILIAL("SA1")+c_CodX+c_LojX)
						::o_Retorno:l_Status		:= .F.
						::o_Retorno:c_Mensagem	:= "Cliente do tipo Estrangeiro ja existe com este codigo: "+c_CodX+"-"+c_LojX+". Utilize a operacao 4 = Alterar."
						Conout("FFIEBW01 - mtdCliente: Cliente do tipo Estrangeiro ja existe com este codigo: "+c_CodX+"-"+c_LojX+". Utilize a operacao 4 = Alterar.")
						Return(.T.)
					Else
						//nao faz nada
					EndIf*/
				Else //(n_Operacao = 4) .Or. (n_Operacao = 5)
					c_Qry:= "SELECT A1_FSESTR, A1_COD, A1_LOJA, R_E_C_N_O_"+chr(13)+chr(10)
					c_Qry+= "FROM "+RETSQLNAME("SA1")+" A1"+chr(13)+chr(10)
					c_Qry+= "WHERE A1_FILIAL = '"+xFilial("SA1")+"' "+chr(13)+chr(10)
					c_Qry+= "AND A1.D_E_L_E_T_ <> '*' "+chr(13)+chr(10)
					c_Qry+= "AND A1_FSESTR = '"+Alltrim(o_Clientes:A1_CGC)+"' "+chr(13)+chr(10)
					TCQUERY c_Qry ALIAS QRY NEW
					dbSelectArea("QRY")
					If (QRY->(Eof()))
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "Cliente do tipo Estrangeiro nao encontrado com o codigo: "+Alltrim(o_Clientes:A1_CGC)+" para realizar a alteracao/exclusao."
						Conout("FFIEBW01 - mtdCliente: Cliente do tipo Estrangeiro nao encontrado com o codigo: "+Alltrim(o_Clientes:A1_CGC)+" para realizar a alteracao/exclusao.")
						dbSelectArea("QRY")
						QRY->(dbCloseArea())
						Return(.T.)
					Else
						c_Cod	:= QRY->A1_COD
						c_Loja	:= QRY->A1_LOJA
						DBSELECTAREA("SA1")
						DBSETORDER(1)
						DBSEEK(XFILIAL("SA1")+c_Cod+c_Loja)
					EndIf
					dbSelectArea("QRY")
					QRY->(dbCloseArea())
				EndIf
				If( Empty( o_Clientes:A1_CODPAIS ) )
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Para cliente do tipo estrangeiro o codigo de pais deve ser informado."
					Conout("FFIEBW01 - mtdCliente: Para cliente do tipo estrangeiro o codigo de pais deve ser informado.")
					Return(.T.)
				ElseIf( Alltrim( o_Clientes:A1_CODPAIS ) == '01058' )
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Nao e permitido utilizar o codigo de pais do Brasil para cliente do tipo Estrangeiro."
					Conout("FFIEBW01 - mtdCliente: Nao e permitido utilizar o codigo de pais do Brasil para cliente do tipo Estrangeiro.")
					Return(.T.)
				EndIf
			Else //Cliente Normal
				DBSELECTAREA("SA1")
				DBSETORDER(3)
				If DBSEEK(XFILIAL("SA1")+Alltrim(o_Clientes:A1_CGC))
					c_Cod	:= SA1->A1_COD
					c_Loja	:= SA1->A1_LOJA
					If (n_Operacao = 3)
						n_Operacao := 4
						/* Alterar para operacao igual a 4 em caso do cliente j� existir no protheus
						::o_Retorno:l_Status		:= .F.
						::o_Retorno:c_Mensagem	:= "CNPJ ou CPF ja existe cadatrado. Utilize a operacao 4 = Alterar."
						Conout("FFIEBW01 - mtdCliente: CNPJ ou CPF ja existe cadatrado. Utilize a operacao 4 = Alterar.")
						Return(.T.)
						*/
					EndIf
				EndIf
			EndIf

			If Upper(Alltrim(o_Clientes:A1_PESSOA)) = 'J'
				c_RecInss:= 'S'
			Else //Pessoa fisica
				c_RecInss:= 'N'
			EndIf
			d_TesteData	:=	StoD(o_Clientes:A1_DTNASC)
			If valtype(d_TesteData) == "D"
				If Empty(d_TesteData)
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Informe Data de nascimento no formato [AAAAMMDD]."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdCliente: Informe Data de nascimento no formato [AAAAMMDD].")
					Return(.T.)
				EndIf
			Else
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe Data de nascimento no formato [AAAAMMDD]."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdCliente: Informe Data de nascimento no formato [AAAAMMDD].")
				Return(.T.)
			EndIf
			//Ja existe um gatilho na FIEB para preencher o codigo e a loja
			If (n_Operacao = 3)
				/*
				{"A1_COD"       ,c_CodX									,Nil},;
				{"A1_LOJA"	    ,c_LojX									,Nil},;
				*/
				If( Upper( Alltrim( o_Clientes:A1_TIPO ) ) == "X" ) //Estrangeiro
					//A1_FSESTR - Guarda o codigo do cliente no sistema que esta enviando, passado no campo CGC. Para os casos de alteracao, ter como achar o cliente.
					aVetor:={	{"A1_TIPO"      ,Upper(Alltrim(o_Clientes:A1_TIPO))		,Nil},;
								{"A1_PESSOA"    ,Upper(Alltrim(o_Clientes:A1_PESSOA))	,Nil},;
								{"A1_CGC"       ,o_Clientes:A1_CGC						,Nil},;
								{"A1_NOME"      ,Upper(Alltrim(o_Clientes:A1_NOME))  	,Nil},;
								{"A1_NREDUZ"    ,Upper(Alltrim(o_Clientes:A1_NREDUZ))	,Nil},;
								{"A1_END"       ,Upper(Alltrim(o_Clientes:A1_END))		,Nil},;
								{"A1_EST"       ,Upper(Alltrim(o_Clientes:A1_EST))	    ,Nil},;
								{"A1_MUN"       ,Upper(Alltrim(o_Clientes:A1_MUN))		,Nil},;
								{"A1_BAIRRO"    ,Upper(Alltrim(o_Clientes:A1_BAIRRO))	,Nil},;
								{"A1_DDD"       ,o_Clientes:A1_DDD						,Nil},;
								{"A1_CEP"       ,o_Clientes:A1_CEP						,Nil},;
								{"A1_TEL"       ,o_Clientes:A1_TEL						,Nil},;
								{"A1_EMAIL"     ,Upper(Alltrim(o_Clientes:A1_EMAIL))	,Nil},;
								{"A1_RECINSS"   ,c_RecInss								,Nil},;
								{"A1_COD_MUN"   ,Alltrim(o_Clientes:A1_COD_MUN)			,Nil},;
								{"A1_INSCR"     ,UPPER(Alltrim(o_Clientes:A1_INSCR))	,Nil},;
								{"A1_INSCRM"    ,Alltrim(o_Clientes:A1_INSCRM)			,Nil},;
								{"A1_PFISICA"  	,Alltrim(o_Clientes:A1_RG)				,Nil},;
								{"A1_COMPLEM"   ,Alltrim(o_Clientes:A1_COMPLEM)			,Nil},;
								{"A1_CONTA"     ,Alltrim(o_Clientes:A1_CONTA)			,Nil},;
								{"A1_CONTATO"   ,Alltrim(o_Clientes:A1_CONTATO)			,Nil},;
								{"A1_TELEX"     ,Alltrim(o_Clientes:A1_TELEX)			,Nil},;
								{"A1_DTNASC"	,STOD(o_Clientes:A1_DTNASC)				,Nil},;
								{"A1_CODPAIS"	,Alltrim( o_Clientes:A1_CODPAIS )		,Nil},;
								{"A1_FSESTR"	,Alltrim(o_Clientes:A1_CGC)				,Nil},;
								{"A1_MUNC"      ,Upper(Alltrim(o_Clientes:A1_MUN))	    ,Nil}}
				Else
					aVetor:={	{"A1_TIPO"      ,Upper(Alltrim(o_Clientes:A1_TIPO))		,Nil},;
								{"A1_PESSOA"    ,Upper(Alltrim(o_Clientes:A1_PESSOA))	,Nil},;
								{"A1_CGC"       ,o_Clientes:A1_CGC						,Nil},;
								{"A1_NOME"      ,Upper(Alltrim(o_Clientes:A1_NOME))  	,Nil},;
								{"A1_NREDUZ"    ,Upper(Alltrim(o_Clientes:A1_NREDUZ))	,Nil},;
								{"A1_END"       ,Upper(Alltrim(o_Clientes:A1_END))		,Nil},;
								{"A1_EST"       ,Upper(Alltrim(o_Clientes:A1_EST))	    ,Nil},;
								{"A1_MUN"       ,Upper(Alltrim(o_Clientes:A1_MUN))		,Nil},;
								{"A1_BAIRRO"    ,Upper(Alltrim(o_Clientes:A1_BAIRRO))	,Nil},;
								{"A1_DDD"       ,o_Clientes:A1_DDD						,Nil},;
								{"A1_CEP"       ,o_Clientes:A1_CEP						,Nil},;
								{"A1_TEL"       ,o_Clientes:A1_TEL						,Nil},;
								{"A1_EMAIL"     ,Upper(Alltrim(o_Clientes:A1_EMAIL))	,Nil},;
								{"A1_RECINSS"   ,c_RecInss								,Nil},;
								{"A1_COD_MUN"   ,Alltrim(o_Clientes:A1_COD_MUN)			,Nil},;
								{"A1_INSCR"     ,UPPER(Alltrim(o_Clientes:A1_INSCR))	,Nil},;
								{"A1_INSCRM"    ,Alltrim(o_Clientes:A1_INSCRM)			,Nil},;
								{"A1_PFISICA"  	,Alltrim(o_Clientes:A1_RG)				,Nil},;
								{"A1_COMPLEM"   ,Alltrim(o_Clientes:A1_COMPLEM)			,Nil},;
								{"A1_CONTA"     ,Alltrim(o_Clientes:A1_CONTA)			,Nil},;
								{"A1_CONTATO"   ,Alltrim(o_Clientes:A1_CONTATO)			,Nil},;
								{"A1_TELEX"     ,Alltrim(o_Clientes:A1_TELEX)			,Nil},;
								{"A1_DTNASC"	,STOD(o_Clientes:A1_DTNASC)				,Nil},;
								{"A1_CODPAIS"	,"01058"								,Nil},;
								{"A1_MUNC"      ,Upper(Alltrim(o_Clientes:A1_MUN))	    ,Nil}}
				EndIf
			Else //Alteracao ou Exclusao
				If( Upper( Alltrim( o_Clientes:A1_TIPO ) ) == "X" ) //Estrangeiro
					aVetor:={	{"A1_COD"       ,c_Cod									,Nil},;
								{"A1_LOJA"	    ,c_Loja									,Nil},;
								{"A1_TIPO"      ,Upper(Alltrim(o_Clientes:A1_TIPO))		,Nil},;
								{"A1_PESSOA"    ,Upper(Alltrim(o_Clientes:A1_PESSOA))	,Nil},;
								{"A1_NOME"      ,Upper(Alltrim(o_Clientes:A1_NOME))  	,Nil},;
								{"A1_NREDUZ"    ,Upper(Alltrim(o_Clientes:A1_NREDUZ))	,Nil},;
								{"A1_END"       ,Upper(Alltrim(o_Clientes:A1_END))		,Nil},;
								{"A1_EST"       ,Upper(Alltrim(o_Clientes:A1_EST))	    ,Nil},;
								{"A1_MUN"       ,Upper(Alltrim(o_Clientes:A1_MUN))		,Nil},;
								{"A1_BAIRRO"    ,Upper(Alltrim(o_Clientes:A1_BAIRRO))	,Nil},;
								{"A1_DDD"       ,o_Clientes:A1_DDD						,Nil},;
								{"A1_CEP"       ,o_Clientes:A1_CEP						,Nil},;
								{"A1_TEL"       ,o_Clientes:A1_TEL						,Nil},;
								{"A1_EMAIL"     ,Upper(Alltrim(o_Clientes:A1_EMAIL))	,Nil},;
								{"A1_RECINSS"   ,c_RecInss								,Nil},;
								{"A1_COD_MUN"   ,Alltrim(o_Clientes:A1_COD_MUN)			,Nil},;
								{"A1_INSCR"     ,UPPER(Alltrim(o_Clientes:A1_INSCR))	,Nil},;
								{"A1_INSCRM"    ,Alltrim(o_Clientes:A1_INSCRM)			,Nil},;
								{"A1_PFISICA"  	,Alltrim(o_Clientes:A1_RG)				,Nil},;
								{"A1_COMPLEM"   ,Alltrim(o_Clientes:A1_COMPLEM)			,Nil},;
								{"A1_CONTA"     ,Alltrim(o_Clientes:A1_CONTA)			,Nil},;
								{"A1_CONTATO"   ,Alltrim(o_Clientes:A1_CONTATO)			,Nil},;
								{"A1_TELEX"     ,Alltrim(o_Clientes:A1_TELEX)			,Nil},;
								{"A1_DTNASC"	,STOD(o_Clientes:A1_DTNASC)				,Nil},;
								{"A1_CODPAIS"	,Alltrim( o_Clientes:A1_CODPAIS )		,Nil},;
								{"A1_FSESTR"	,Alltrim(o_Clientes:A1_CGC)				,Nil},;
								{"A1_MUNC"      ,Alltrim(o_Clientes:A1_MUN)	    		,Nil}}
				Else
					aVetor:={	{"A1_COD"       ,c_Cod									,Nil},;
								{"A1_LOJA"	    ,c_Loja									,Nil},;
								{"A1_TIPO"      ,Upper(Alltrim(o_Clientes:A1_TIPO))		,Nil},;
								{"A1_PESSOA"    ,Upper(Alltrim(o_Clientes:A1_PESSOA))	,Nil},;
								{"A1_NOME"      ,Upper(Alltrim(o_Clientes:A1_NOME))  	,Nil},;
								{"A1_NREDUZ"    ,Upper(Alltrim(o_Clientes:A1_NREDUZ))	,Nil},;
								{"A1_END"       ,Upper(Alltrim(o_Clientes:A1_END))		,Nil},;
								{"A1_EST"       ,Upper(Alltrim(o_Clientes:A1_EST))	    ,Nil},;
								{"A1_MUN"       ,Upper(Alltrim(o_Clientes:A1_MUN))		,Nil},;
								{"A1_BAIRRO"    ,Upper(Alltrim(o_Clientes:A1_BAIRRO))	,Nil},;
								{"A1_DDD"       ,o_Clientes:A1_DDD						,Nil},;
								{"A1_CEP"       ,o_Clientes:A1_CEP						,Nil},;
								{"A1_TEL"       ,o_Clientes:A1_TEL						,Nil},;
								{"A1_EMAIL"     ,Upper(Alltrim(o_Clientes:A1_EMAIL))	,Nil},;
								{"A1_RECINSS"   ,c_RecInss								,Nil},;
								{"A1_COD_MUN"   ,Alltrim(o_Clientes:A1_COD_MUN)			,Nil},;
								{"A1_INSCR"     ,UPPER(Alltrim(o_Clientes:A1_INSCR))	,Nil},;
								{"A1_INSCRM"    ,Alltrim(o_Clientes:A1_INSCRM)			,Nil},;
								{"A1_PFISICA"  	,Alltrim(o_Clientes:A1_RG)				,Nil},;
								{"A1_COMPLEM"   ,Alltrim(o_Clientes:A1_COMPLEM)			,Nil},;
								{"A1_CONTA"     ,Alltrim(o_Clientes:A1_CONTA)			,Nil},;
								{"A1_CONTATO"   ,Alltrim(o_Clientes:A1_CONTATO)			,Nil},;
								{"A1_TELEX"     ,Alltrim(o_Clientes:A1_TELEX)			,Nil},;
								{"A1_DTNASC"	,STOD(o_Clientes:A1_DTNASC)				,Nil},;
								{"A1_CODPAIS"	,"01058"								,Nil},;
								{"A1_MUNC"      ,Alltrim(o_Clientes:A1_MUN)	    		,Nil}}
				EndIf
			EndIf

			//Exclusivo para a versao 12
			If (GetVersao(.F.) == "12")
				aAdd(aVetor, {"A1_XDDCOM"   ,Alltrim(o_Clientes:A1_DDD)	    		,Nil})
				aAdd(aVetor, {"A1_XDDDCEL"  ,Alltrim(o_Clientes:A1_DDD)	    		,Nil})
				aAdd(aVetor, {"A1_XTELCEL"  ,Alltrim(o_Clientes:A1_TEL)	    		,Nil})
			EndIf

			lMsErroAuto		:= .F.
			lMsHelpAuto		:= .T.
			lAutoErrNoFile	:= .T.

			Begin Transaction
				//Este tratamento foi para os casos esporadicos de erro na alteracao do cliente quando mudava o estado e a inscricao estava preenchida. 
				If (n_Operacao = 4)
					DBSELECTAREA("SA1")
					DBSETORDER(3)
					If DBSEEK( XFILIAL("SA1")+Alltrim( o_Clientes:A1_CGC ) )
						If( !Empty( SA1->A1_INSCR ) )
							RecLock("SA1",.F.)
							SA1->A1_INSCR := ''
							MsUnLock()
						EndIf
					EndIf
				EndIf
				
				MSExecAuto({|x,y| Mata030(x,y)},aVetor,n_Operacao) //3- Inclusao, 4- Alteracao, 5- Exclusao
				If lMsErroAuto
					//Regra do fonte SIESBA01 da FIEB
					If (__lSX8)
						RollBackSX8()
					EndIf

					// Tratamento da Mensagem de erro do MSExecAuto
					aLogErr  := GetAutoGRLog()
					aLogErr2 := f_TrataErro(aLogErr)
					_cMotivo := ""

					For i := 1 to Len(aLogErr2)
						_cMotivo += aLogErr2[i]
					Next

					//Exclusivo para a versao 12
					If (GetVersao(.F.) == "12")
						_cMotivo:=  NoAcentoESB(_cMotivo)
						SetSoapFault('Erro',_cMotivo)
					EndIf

					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= NoAcentoESB(_cMotivo)
					Conout("FFIEBW01 - mtdCliente: "+NoAcentoESB(_cMotivo))
					DisarmTransaction()
					Break
				Else
					If (n_Operacao = 3)
						If (__lSX8)
							ConfirmSX8()
						EndIf
						
						/*------------------------------------------ I N I C I O ----------------------------------------------------------------------
						Por			: Adriano Moreira
						Solicitante	: Micheline
						Motivo		: Gravacao dos contatos amarrados ao clientes.
						Data		: 23/06/2020										
						*/
						cFilAnt		:= o_Empresa:c_Filial
						c_FilZZS	:= o_Empresa:c_Filial
						c_CliZZS	:= SA1->A1_COD
						c_LojZZS	:= SA1->A1_LOJA
						c_NCliZZS	:= SA1->A1_NOME
						c_CGCZZS	:= Alltrim( o_Clientes:A1_CGC )
						
						If( Len( o_Clientes:XCONTATOS ) > 0 )
							If !Empty( o_Clientes:XCONTATOS[1]:ZZS_EMAILCONTATO ) .And. !Empty( o_Clientes:XCONTATOS[1]:ZZS_NOMECONTATO )
								For p:= 1 To Len( o_Clientes:XCONTATOS )
									c_EmailZZS	:= Alltrim( o_Clientes:XCONTATOS[p]:ZZS_EMAILCONTATO )
									c_NomeZZS	:= Alltrim( o_Clientes:XCONTATOS[p]:ZZS_NOMECONTATO )
									c_TelZZS	:= Alltrim( o_Clientes:XCONTATOS[p]:ZZS_TELCONTATO )									
									If( !Empty( o_Clientes:XCONTATOS[p]:ZZS_EMAILCONTATO ) .And. ( "@" $ Alltrim( o_Clientes:XCONTATOS[p]:ZZS_EMAILCONTATO ) ) )
										dbSelectArea( "ZZS" )
										dbSetOrder(1)
										If dbSeek( c_FilZZS + c_CliZZS + c_LojZZS + c_CGCZZS )
											If( c_EmailZZS <> Alltrim( ZZS->ZZS_EMAIL ) )
												RecLock( "ZZS",.T.)
											Else
												RecLock( "ZZS",.F.)
											EndIf
										Else
											RecLock( "ZZS",.T.)
										EndIf	
										ZZS->ZZS_FILIAL	:= c_FilZZS
										ZZS->ZZS_COD	:= c_CliZZS
										ZZS->ZZS_LOJA	:= c_LojZZS
										ZZS->ZZS_CGCSA1	:= c_CGCZZS
										ZZS->ZZS_NOMCLI	:= c_NCliZZS
										ZZS->ZZS_NOME	:= c_NomeZZS
										ZZS->ZZS_EMAIL	:= c_EmailZZS
										ZZS->ZZS_TEL	:= c_TelZZS	
										MsUnlock()
									EndIf
								Next
							EndIf
						EndIf
						/*----------------------------------------------- F I M --------------------------------------------------------------------*/
						
						//------------------------------------------ I N I C I O ----------------------------------------------------------------------
						//Por: Francisco Rezende
						//Solicitante: Paula Nolasco
						//Motivo: Gravacao da Entidade Contabil
						//Data: 31/07/2019
						//-----------------------------------------------------------------------------------------------------------------------------
						c_Item      := GetSxeNum( "CV0" , "CV0_ITEM" )
						c_Codigo    := "C"+ Alltrim(o_Clientes:A1_CGC)
						c_Descricao := Upper(Alltrim(o_Clientes:A1_NOME))

						a_Vetor := { { "CV0_PLANO"  , "05"       			, Nil } , ;
						            { "CV0_ITEM"   , c_Item 	   		 	, Nil } , ;
						            { "CV0_CODIGO" , c_Codigo    			, Nil } , ;
						            { "CV0_DESC"   , c_Descricao			, Nil } , ;
						            { "CV0_CLASSE" , "2"    				, Nil } , ;
						            { "CV0_NORMAL" , "1"       				, Nil } , ;
						            { "CV0_ENTSUP" , "C" 					, Nil } , ;
						            { "CV0_DTIEXI" , CtoD( "01/01/2000" )	, Nil } }

						MSExecAuto( { | x , y | CTBA800( x , y ) } , a_Vetor , 3 ) //3 - Inclusao, 4 - Alteracao, 5 - Exclusao

						If( lMsErroAuto )
						   RollBackSX8()
						   //MostraErro()
						   l_ErrEnt := .T.
						Else
							ConfirmSX8()
						Endif
						//----------------------------------------------- F I M --------------------------------------------------------------------

						::o_Retorno:l_Status		:= .T.
						If l_ErrEnt
							::o_Retorno:c_Mensagem	:= "Cliente/Loja "+SA1->A1_COD+"/"+SA1->A1_LOJA+" incluido com sucesso. Erro ao gravar a Entidade 05"
							Conout("FFIEBW01 - mtdCliente: Cliente/Loja "+SA1->A1_LOJA+"/"+c_Loja+" incluido com sucesso. Erro ao gravar a Entidade 05")
						Else
							::o_Retorno:c_Mensagem	:= "Cliente/Loja "+SA1->A1_COD+"/"+SA1->A1_LOJA+" incluido com sucesso. Entidade 05 gravada com sucesso!!!"
							Conout("FFIEBW01 - mtdCliente: Cliente/Loja "+SA1->A1_LOJA+"/"+c_Loja+" incluido com sucesso. Entidade 05 gravada com sucesso!!!")
						EndIf

					ElseIf (n_Operacao = 4)
						
						/*------------------------------------------ I N I C I O ----------------------------------------------------------------------
						Por			: Adriano Moreira
						Solicitante	: Micheline
						Motivo		: Gravacao dos contatos amarrados ao clientes.
						Data		: 23/06/2020										
						*/
						cFilAnt		:= o_Empresa:c_Filial
						c_FilZZS	:= o_Empresa:c_Filial
						c_CliZZS	:= SA1->A1_COD
						c_LojZZS	:= SA1->A1_LOJA
						c_NCliZZS	:= SA1->A1_NOME
						c_CGCZZS	:= Alltrim( o_Clientes:A1_CGC )
						
						If( Len( o_Clientes:XCONTATOS ) > 0 )
							If !Empty( o_Clientes:XCONTATOS[1]:ZZS_EMAILCONTATO ) .And. !Empty( o_Clientes:XCONTATOS[1]:ZZS_NOMECONTATO )
								For p:= 1 To Len( o_Clientes:XCONTATOS )
									c_EmailZZS	:= Alltrim( o_Clientes:XCONTATOS[p]:ZZS_EMAILCONTATO )
									c_NomeZZS	:= Alltrim( o_Clientes:XCONTATOS[p]:ZZS_NOMECONTATO )
									c_TelZZS	:= Alltrim( o_Clientes:XCONTATOS[p]:ZZS_TELCONTATO )									
									If( !Empty( o_Clientes:XCONTATOS[p]:ZZS_EMAILCONTATO ) .And. ( "@" $ Alltrim( o_Clientes:XCONTATOS[p]:ZZS_EMAILCONTATO ) ) )
										dbSelectArea( "ZZS" )
										dbSetOrder(1)
										If dbSeek( c_FilZZS + c_CliZZS + c_LojZZS + c_CGCZZS )
											If( c_EmailZZS <> Alltrim( ZZS->ZZS_EMAIL ) )
												RecLock( "ZZS",.T.)
											Else
												RecLock( "ZZS",.F.)
											EndIf
										Else
											RecLock( "ZZS",.T.)
										EndIf	
										ZZS->ZZS_FILIAL	:= c_FilZZS
										ZZS->ZZS_COD	:= c_CliZZS
										ZZS->ZZS_LOJA	:= c_LojZZS
										ZZS->ZZS_CGCSA1	:= c_CGCZZS
										ZZS->ZZS_NOMCLI	:= c_NCliZZS
										ZZS->ZZS_NOME	:= c_NomeZZS
										ZZS->ZZS_EMAIL	:= c_EmailZZS
										ZZS->ZZS_TEL	:= c_TelZZS	
										MsUnlock()
									EndIf
								Next
							EndIf
						EndIf
						/*----------------------------------------------- F I M --------------------------------------------------------------------*/
						
						//------------------------------------------ I N I C I O ----------------------------------------------------------------------
						//Por: Francisco Rezende
						//Solicitante: Paula Nolasco
						//Motivo: Gravacao da Entidade Contabil
						//Data: 31/07/2019
						//-----------------------------------------------------------------------------------------------------------------------------
						c_Item      := GetSxeNum( "CV0" , "CV0_ITEM" )
						c_Codigo    := "C"+ Alltrim(o_Clientes:A1_CGC)
						c_Descricao := Upper(Alltrim(o_Clientes:A1_NOME))

						dbSelectArea("CV0")
						dbSetOrder(1)
						If dbSeek(xFilial("CV0") + "05" + c_Codigo, .T. )
							n_OperEnt := 4
						EndIf

						a_Vetor := { { "CV0_PLANO"  , "05"       			, Nil } , ;
						            { "CV0_ITEM"   , c_Item 	   		 	, Nil } , ;
						            { "CV0_CODIGO" , c_Codigo    			, Nil } , ;
						            { "CV0_DESC"   , c_Descricao			, Nil } , ;
						            { "CV0_CLASSE" , "2"    				, Nil } , ;
						            { "CV0_NORMAL" , "1"       				, Nil } , ;
						            { "CV0_ENTSUP" , "C" 					, Nil } , ;
						            { "CV0_DTIEXI" , CtoD( "01/01/2000" )	, Nil } }

						MSExecAuto( { | x , y | CTBA800( x , y ) } , a_Vetor , n_OperEnt ) //3 - Inclusao, 4 - Alteracao, 5 - Exclusao

						If( lMsErroAuto )
						   RollBackSX8()
						   //MostraErro()
						   l_ErrEnt := .T.
						Else
							ConfirmSX8()
						Endif

						//----------------------------------------------- F I M --------------------------------------------------------------------

						::o_Retorno:l_Status		:= .T.
						If l_ErrEnt
							::o_Retorno:c_Mensagem	:= "Cliente/Loja "+c_Cod+"/"+c_Loja+" alterado com sucesso. Erro ao gravar a Entidade 05"
							Conout("FFIEBW01 - mtdCliente: Cliente/Loja "+c_Cod+"/"+c_Loja+" alterado com sucesso. Erro ao gravar a Entidade 05")
						Else
							::o_Retorno:c_Mensagem	:= "Cliente/Loja "+c_Cod+"/"+c_Loja+" alterado com sucesso. Entidade 05 gravada com sucesso!!!"
							Conout("FFIEBW01 - mtdCliente: Cliente/Loja "+c_Cod+"/"+c_Loja+" alterado com sucesso. Entidade 05 gravada com sucesso!!!")
						EndIf
					Else
						::o_Retorno:l_Status		:= .T.
						::o_Retorno:c_Mensagem	:= "Cliente/Loja "+c_Cod+"/"+c_Loja+" excluido com sucesso."
						Conout("FFIEBW01 - mtdCliente: Cliente/Loja "+c_Cod+"/"+c_Loja+" excluido com sucesso.")
					EndIf
				Endif
			End Transaction
		EndIf
	EndIf
	//RpcClearEnv() //Limpa o ambiente, liberando a licensa e fechando as conexoes

RETURN(.T.)
/*/{Protheus.doc} mtdFornecedores
metodo de fornecedores
@author Totvs-BA
@since 01/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSMETHOD mtdFornecedores WSRECEIVE o_Seguranca, o_Empresa, o_Fornecedores, Operacao WSSEND o_Retorno WSSERVICE FFIEBW01

	Local c_Cod			:= ""
	Local c_Loja		:= ""
	Local i,p			:= 0
	Local n_Operacao	:= Val(::Operacao)
	Local c_Item      	:= ""
	Local c_Codigo    	:= ""
	Local c_Descricao 	:= ""
	Local a_Vetor		:= {}
	Local l_ErrEnt		:= .F.
	Local n_OperEnt 	:= 3

	PRIVATE lMsErroAuto := .F.

	::o_Retorno	:= WSCLASSNEW("strRetorno")

	If !(f_VldFilEmp(o_Empresa:c_Empresa,o_Empresa:c_Filial))
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Codigo de Empresa/Filial nao existe."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdFornecedores: Codigo de Empresa/Filial nao existe.")
		Return(.T.)
	EndIf

	//Loga na filial solicitada
	RpcSetType(3)
	RpcSetEnv(o_Empresa:c_Empresa,o_Empresa:c_Filial, "integracao", "fieb123")

	//Posiciona na empresa e filial passada
	dbSelectArea("SM0")
	dbSeek(o_Empresa:c_Empresa+o_Empresa:c_Filial)

	cFilAnt:= o_Empresa:c_Filial

	c_UserWS	:= Upper(ALLTRIM(SUPERGETMV("FS_FIUSRWS",,"totvs_fieb")))
	c_PswWS		:= Upper(ALLTRIM(SUPERGETMV("FS_FIPSWWS",,"totvs@123")))

	//Validando o usuario e senha
	If ( Upper(o_Seguranca:c_Usuario) <> Upper(c_UserWS) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdFornecedores: Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido.")
		Return(.T.)
	ElseIf ( Upper(o_Seguranca:c_Senha) <> Upper(c_PswWS) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdFornecedores: Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida.")
		Return(.T.)
	ElseIf (n_Operacao < 3) .Or. (n_Operacao > 5)
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Valor passado no parametro Operacao ("+cValToChar(n_Operacao)+") invalido. Informar (3=Inclusao; 4=Alteracao; 5=Exclusao)."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdFornecedores: Valor passado no parametro Operacao ("+cValToChar(n_Operacao)+") invalido. Informar (3=Inclusao; 4=Alteracao; 5=Exclusao).")
		Return(.T.)
	Else
		If Empty(o_Fornecedores:A2_CGC)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "CNPJ ou CPF nao foi informado."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdFornecedores: CNPJ ou CPF nao foi informado.")
			Return(.T.)
		ElseIf (Upper(Alltrim(o_Fornecedores:A2_TIPO)) <> "F") .And. (Upper(Alltrim(o_Fornecedores:A2_TIPO)) <> "J") .And. (Upper(Alltrim(o_Fornecedores:A2_TIPO)) <> "X")
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Tipo "+Upper(Alltrim(o_Fornecedores:A2_TIPO))+" invalido. Informar: (F ou J ou X)."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdFornecedores: Tipo "+Upper(Alltrim(o_Fornecedores:A2_TIPO))+" invalido. Informar: (F ou J ou X).")
			Return(.T.)
		/*
		ElseIf (Upper(Alltrim(o_Fornecedores:A2_XTPCONT)) <> "1") .And. (Upper(Alltrim(o_Fornecedores:A2_XTPCONT)) <> "2") .And. (Upper(Alltrim(o_Fornecedores:A2_XTPCONT)) <> "3")
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Tipo "+Upper(Alltrim(o_Fornecedores:A2_XTPCONT))+" invalido. Informar: (1 ou 2 ou 3)."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdFornecedores: Tipo "+Upper(Alltrim(o_Fornecedores:A2_XTPCONT))+" invalido. Informar: (1 ou 2 ou 3).")
			Return(.T.)
		*/
		ElseIf (Upper(Alltrim(o_Fornecedores:A2_RECISS)) <> "S") .And. (Upper(Alltrim(o_Fornecedores:A2_RECISS)) <> "N")
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Campo Rec.ISS "+Upper(Alltrim(o_Fornecedores:A2_RECISS))+" invalido. Informar: (S ou N)."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdFornecedores: Campo Rec.ISS "+Upper(Alltrim(o_Fornecedores:A2_RECISS))+" invalido. Informar: (S ou N).")
			Return(.T.)
		ElseIf (Upper(Alltrim(o_Fornecedores:A2_RECINSS)) <> "S") .And. (Upper(Alltrim(o_Fornecedores:A2_RECINSS)) <> "N")
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Campo Rec.INSS "+Upper(Alltrim(o_Fornecedores:A2_RECINSS))+" invalido. Informar: (S ou N)."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdFornecedores: Campo Rec.INSS "+Upper(Alltrim(o_Fornecedores:A2_RECINSS))+" invalido. Informar: (S ou N).")
			Return(.T.)
		ElseIf (Upper(Alltrim(o_Fornecedores:A2_RECPIS)) <> "1") .And. (Upper(Alltrim(o_Fornecedores:A2_RECPIS)) <> "2")
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Campo Rec.PIS "+Upper(Alltrim(o_Fornecedores:A2_RECPIS))+" invalido. Informar: (1=Sim ou 2=Nao)."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdFornecedores: Campo Rec.PIS "+Upper(Alltrim(o_Fornecedores:A2_RECPIS))+" invalido. Informar: (1=Sim ou 2=Nao).")
			Return(.T.)
		ElseIf (Upper(Alltrim(o_Fornecedores:A2_RECCSLL)) <> "1") .And. (Upper(Alltrim(o_Fornecedores:A2_RECCSLL)) <> "2")
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Campo Rec.CSLL "+Upper(Alltrim(o_Fornecedores:A2_RECCSLL))+" invalido. Informar: (1=Sim ou 2=Nao)."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdFornecedores: Campo Rec.CSLL "+Upper(Alltrim(o_Fornecedores:A2_RECCSLL))+" invalido. Informar: (1=Sim ou 2=Nao).")
			Return(.T.)
		ElseIf (Upper(Alltrim(o_Fornecedores:A2_RECCOFI)) <> "1") .And. (Upper(Alltrim(o_Fornecedores:A2_RECCOFI)) <> "2")
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Campo Rec.COFINS "+Upper(Alltrim(o_Fornecedores:A2_RECCOFI))+" invalido. Informar: (1=Sim ou 2=Nao)."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdFornecedores: Campo Rec.COFINS "+Upper(Alltrim(o_Fornecedores:A2_RECCOFI))+" invalido. Informar: (1=Sim ou 2=Nao).")
			Return(.T.)
		Else
			//Validando a conta contabil
			If !Empty(o_Fornecedores:A2_CONTA)
				DBSELECTAREA("CT1")
				DBSETORDER(1)
				IF !DBSEEK(xFilial("CT1")+Alltrim(o_Fornecedores:A2_CONTA))
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_Fornecedores:A2_CONTA)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+"."
					Conout("FFIEBW01 - mtdFornecedores: Codigo da conta contabil ("+Alltrim(o_Fornecedores:A2_CONTA)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+".")
					Return(.T.)
				ElseIf CT1->CT1_CLASSE == "1"
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_Fornecedores:A2_CONTA)+") nao pode ser sintetica."
					Conout("FFIEBW01 - mtdFornecedores: Codigo da conta contabil ("+Alltrim(o_Fornecedores:A2_CONTA)+") nao pode ser sintetica.")
					Return(.T.)
				ElseIf CT1->CT1_BLOQ == "1"
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_Fornecedores:A2_CONTA)+") esta bloqueada para uso."
					Conout("FFIEBW01 - mtdFornecedores: Codigo da conta contabil ("+Alltrim(o_Fornecedores:A2_CONTA)+")  esta bloqueada para uso.")
					Return(.T.)
				EndIf
			EndIf
			If (Upper(Alltrim(o_Fornecedores:A2_TIPO)) == "F") .Or. (Upper(Alltrim(o_Fornecedores:A2_TIPO)) == "J")
				DBSELECTAREA("SA2")
				DBSETORDER(3)
				If DBSEEK(XFILIAL("SA2")+Alltrim(o_Fornecedores:A2_CGC))
					c_Cod	:= SA2->A2_COD
					c_Loja	:= SA2->A2_LOJA
					If (n_Operacao = 3)
						::o_Retorno:l_Status		:= .F.
						::o_Retorno:c_Mensagem	:= "CNPJ ou CPF ja existe cadatrado. Utilize a operacao 4 = Alterar."
						Conout("FFIEBW01 - mtdFornecedores: CNPJ ou CPF ja existe cadatrado. Utilize a operacao 4 = Alterar.")
						Return(.T.)
					EndIf
				EndIf
			Else
				c_CodX:= SubStr(Alltrim(o_Fornecedores:A2_CGC),1,Len(Alltrim(o_Fornecedores:A2_CGC))-4)
				c_CodX:= PADR(c_CodX, TAMSX3("A2_COD")[1])
				c_LojX:= SubStr(Alltrim(o_Fornecedores:A2_CGC),Len(Alltrim(o_Fornecedores:A2_CGC))-3,4)
				c_LojX:= PADR(c_LojX, TAMSX3("A2_LOJA")[1])
				DBSELECTAREA("SA2")
				DBSETORDER(1)
				If DBSEEK(XFILIAL("SA2")+c_CodX+c_LojX)
					c_Cod	:= SA2->A2_COD
					c_Loja	:= SA2->A2_LOJA
					If (n_Operacao = 3)
						::o_Retorno:l_Status		:= .F.
						::o_Retorno:c_Mensagem	:= "Fornecedor do tipo Outros ja existe com este codigo. Utilize a operacao 4 = Alterar."
						Conout("FFIEBW01 - mtdFornecedores: Fornecedor do tipo Outros ja existe com este codigo. Utilize a operacao 4 = Alterar.")
						Return(.T.)
					EndIf
				Else
					If (n_Operacao = 4) .Or. (n_Operacao = 5)
						::o_Retorno:l_Status		:= .F.
						::o_Retorno:c_Mensagem	:= "Fornecedor do tipo Outros nao existe com este codigo. Utilize a operacao 3 = Incluir."
						Conout("FFIEBW01 - mtdFornecedores: Fornecedor do tipo Outros nao existe com este codigo. Utilize a operacao 3 = Incluir.")
						Return(.T.)
					EndIf
				EndIf
			EndIf
			//Exclusivo para a versao 12
			/*If (GetVersao(.F.) == "12")
				If Empty(Alltrim(o_Fornecedores:A2_BANCO)) .Or. Empty(Alltrim(o_Fornecedores:A2_AGENCIA)) .Or. Empty(Alltrim(o_Fornecedores:A2_NUMCON)) .Or. Empty(Alltrim(o_Fornecedores:A2_XDVCTA))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Banco/Agencia/Conta/Digito Verificador da Agencia nao informados."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdFornecedores: Banco/Agencia/Conta/Digito Verificador da Agencia nao informados.")
					Return(.T.)
				EndIf
			EndIf*/

			If Len(o_Fornecedores:MULBANCOS) > 0
				If !Empty(o_Fornecedores:MULBANCOS[1]:FIL_BANCO) .And. !Empty(o_Fornecedores:MULBANCOS[1]:FIL_AGENCIA) .And. !Empty(o_Fornecedores:MULBANCOS[1]:FIL_CONTA)
					n_QtdPrincipal:= 0
					For p:= 1 To Len(o_Fornecedores:MULBANCOS)
						If Empty(o_Fornecedores:MULBANCOS[p]:FIL_TIPCTA)
							::o_Retorno:l_Status	:= .F.
							::o_Retorno:c_Mensagem	:= "Informe o tipo de conta nos parametros de multiplos bancos."+CHR(13)+CHR(10)
							Conout("FFIEBW01 - mtdFornecedores: Informe o tipo de conta nos parametros de multiplos bancos")
							Return(.T.)
						ElseIf (Alltrim(o_Fornecedores:MULBANCOS[p]:FIL_TIPCTA) <> '1' ) .And. (Alltrim(o_Fornecedores:MULBANCOS[p]:FIL_TIPCTA) <> '2' ) .And. (Alltrim(o_Fornecedores:MULBANCOS[p]:FIL_TIPCTA) <> '3' )
							::o_Retorno:l_Status	:= .F.
							::o_Retorno:c_Mensagem	:= "O tipo de conta nos parametros de multiplos bancos deve ser (1=Corrente;2=Poupanca;3=ContaFacil)."+CHR(13)+CHR(10)
							Conout("FFIEBW01 - mtdFornecedores: O tipo de conta nos parametros de multiplos bancos deve ser (1=Corrente;2=Poupanca;3=ContaFacil).")
							Return(.T.)
						EndIf
						If Empty(o_Fornecedores:MULBANCOS[p]:FIL_TIPO)
							::o_Retorno:l_Status	:= .F.
							::o_Retorno:c_Mensagem	:= "Informe o tipo nos parametros de multiplos bancos."+CHR(13)+CHR(10)
							Conout("FFIEBW01 - mtdFornecedores: Informe o tipo nos parametros de multiplos bancos")
							Return(.T.)
						ElseIf (Alltrim(o_Fornecedores:MULBANCOS[p]:FIL_TIPO) <> '1' ) .And. (Alltrim(o_Fornecedores:MULBANCOS[p]:FIL_TIPO) <> '2' )
							::o_Retorno:l_Status	:= .F.
							::o_Retorno:c_Mensagem	:= "O tipo nos parametros de multiplos bancos deve ser (1=Principal;2=Normal)."+CHR(13)+CHR(10)
							Conout("FFIEBW01 - mtdFornecedores: O tipo nos parametros de multiplos bancos deve ser (1=Principal;2=Normal).")
							Return(.T.)
						ElseIf (Alltrim(o_Fornecedores:MULBANCOS[p]:FIL_TIPO) = '1')
							n_QtdPrincipal++
							If (Alltrim(o_Fornecedores:MULBANCOS[p]:FIL_MOVCTO) = '2')
								::o_Retorno:l_Status	:= .F.
								::o_Retorno:c_Mensagem	:= "A conta principal deve permitir movimentacao (FIL_MOVCTO='1')."+CHR(13)+CHR(10)
								Conout("FFIEBW01 - mtdFornecedores: A conta principal deve permitir movimentacao (FIL_MOVCTO='1').")
								Return(.T.)
							EndIf
						EndIf
					Next
					If (n_QtdPrincipal > 1)
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "So eh permitido passar uma unica conta do tipo 'Principal'."+CHR(13)+CHR(10)
						Conout("FFIEBW01 - mtdFornecedores: So eh permitido passar uma unica conta do tipo 'Principal'.")
						Return(.T.)
					EndIf
				EndIf
			EndIf
			//Ja existe um gatilho na FIEB para preencher o codigo e a loja
			If (n_Operacao = 3)
				If (Upper(Alltrim(o_Fornecedores:A2_TIPO)) == 'X') //Fornecedor Outros
					aVetor:={	{"A2_TIPO"      ,Upper(Alltrim(o_Fornecedores:A2_TIPO))		,Nil},;
								{"A2_COD"       ,c_CodX										,Nil},;
								{"A2_LOJA"      ,c_LojX										,Nil},;
								{"A2_NOME"      ,Upper(Alltrim(o_Fornecedores:A2_NOME))  	,Nil},;
								{"A2_NREDUZ"    ,Upper(Alltrim(o_Fornecedores:A2_NREDUZ))	,Nil},;
								{"A2_END"       ,Upper(Alltrim(o_Fornecedores:A2_END))		,Nil},;
								{"A2_EST"       ,Upper(Alltrim(o_Fornecedores:A2_EST))		,Nil},;
								{"A2_MUN"       ,Upper(Alltrim(o_Fornecedores:A2_MUN))		,Nil},;
								{"A2_BAIRRO"    ,Upper(Alltrim(o_Fornecedores:A2_BAIRRO))	,Nil},;
								{"A2_DDD"       ,Alltrim(o_Fornecedores:A2_DDD)				,Nil},;
								{"A2_CEP"       ,Alltrim(o_Fornecedores:A2_CEP)				,Nil},;
								{"A2_TEL"       ,Alltrim(o_Fornecedores:A2_TEL)				,Nil},;
								{"A2_EMAIL"     ,Upper(Alltrim(o_Fornecedores:A2_EMAIL))	,Nil},;
								{"A2_BANCO"     ,Alltrim(o_Fornecedores:A2_BANCO)			,Nil},;
								{"A2_AGENCIA"   ,Alltrim(o_Fornecedores:A2_AGENCIA)			,Nil},;
								{"A2_NUMCON"    ,Alltrim(o_Fornecedores:A2_NUMCON)			,Nil},;
								{"A2_XTPCONT"   ,Alltrim(o_Fornecedores:A2_XTPCONT)			,Nil},;
								{"A2_COD_MUN"	,Alltrim(o_Fornecedores:A2_COD_MUN)			,Nil},;
								{"A2_XDVAGE"	,Alltrim(o_Fornecedores:A2_XDVAGE)			,Nil},;
								{"A2_XDVCTA"	,Alltrim(o_Fornecedores:A2_XDVCTA)			,Nil},;
								{"A2_INSCR"		,Alltrim(o_Fornecedores:A2_INSCR)			,Nil},;
								{"A2_INSCRM"	,Alltrim(o_Fornecedores:A2_INSCRM)			,Nil},;
								{"A2_CODPAIS"	,Alltrim(o_Fornecedores:A2_CODPAIS)			,Nil},;
								{"A2_RECISS"	,Alltrim(o_Fornecedores:A2_RECISS)			,Nil},;
								{"A2_RECINSS"	,Alltrim(o_Fornecedores:A2_RECINSS)			,Nil},;
								{"A2_RECPIS"	,Alltrim(o_Fornecedores:A2_RECPIS)			,Nil},;
								{"A2_RECCSLL"	,Alltrim(o_Fornecedores:A2_RECCSLL)			,Nil},;
								{"A2_RECCOFI"	,Alltrim(o_Fornecedores:A2_RECCOFI)			,Nil},;
								{"A2_CALCIRF"	,Alltrim(o_Fornecedores:A2_CALCIRF)			,Nil},;
								{"A2_COMPLEM"	,Upper(Alltrim(o_Fornecedores:A2_COMPLEM))	,Nil},;
								{"A2_CONTATO"   ,Alltrim(o_Fornecedores:A2_CONTATO)			,Nil},;
								{"A2_TELEX"     ,Alltrim(o_Fornecedores:A2_TELEX)			,Nil},;
								{"A2_CONTA"		,Alltrim(o_Fornecedores:A2_CONTA)			,Nil}}
				Else
					aVetor:={	{"A2_TIPO"      ,Upper(Alltrim(o_Fornecedores:A2_TIPO))		,Nil},;
								{"A2_CGC"       ,Alltrim(o_Fornecedores:A2_CGC)				,Nil},;
								{"A2_NOME"      ,Upper(Alltrim(o_Fornecedores:A2_NOME))  	,Nil},;
								{"A2_NREDUZ"    ,Upper(Alltrim(o_Fornecedores:A2_NREDUZ))	,Nil},;
								{"A2_END"       ,Upper(Alltrim(o_Fornecedores:A2_END))		,Nil},;
								{"A2_EST"       ,Upper(Alltrim(o_Fornecedores:A2_EST))		,Nil},;
								{"A2_MUN"       ,Upper(Alltrim(o_Fornecedores:A2_MUN))		,Nil},;
								{"A2_BAIRRO"    ,Upper(Alltrim(o_Fornecedores:A2_BAIRRO))	,Nil},;
								{"A2_DDD"       ,Alltrim(o_Fornecedores:A2_DDD)				,Nil},;
								{"A2_CEP"       ,Alltrim(o_Fornecedores:A2_CEP)				,Nil},;
								{"A2_TEL"       ,Alltrim(o_Fornecedores:A2_TEL)				,Nil},;
								{"A2_EMAIL"     ,Upper(Alltrim(o_Fornecedores:A2_EMAIL))	,Nil},;
								{"A2_BANCO"     ,Alltrim(o_Fornecedores:A2_BANCO)			,Nil},;
								{"A2_AGENCIA"   ,Alltrim(o_Fornecedores:A2_AGENCIA)			,Nil},;
								{"A2_NUMCON"    ,Alltrim(o_Fornecedores:A2_NUMCON)			,Nil},;
								{"A2_XTPCONT"   ,Alltrim(o_Fornecedores:A2_XTPCONT)			,Nil},;
								{"A2_COD_MUN"	,Alltrim(o_Fornecedores:A2_COD_MUN)			,Nil},;
								{"A2_XDVAGE"	,Alltrim(o_Fornecedores:A2_XDVAGE)			,Nil},;
								{"A2_XDVCTA"	,Alltrim(o_Fornecedores:A2_XDVCTA)			,Nil},;
								{"A2_INSCR"		,Alltrim(o_Fornecedores:A2_INSCR)			,Nil},;
								{"A2_INSCRM"	,Alltrim(o_Fornecedores:A2_INSCRM)			,Nil},;
								{"A2_CODPAIS"	,Alltrim(o_Fornecedores:A2_CODPAIS)			,Nil},;
								{"A2_RECISS"	,Alltrim(o_Fornecedores:A2_RECISS)			,Nil},;
								{"A2_RECINSS"	,Alltrim(o_Fornecedores:A2_RECINSS)			,Nil},;
								{"A2_RECPIS"	,Alltrim(o_Fornecedores:A2_RECPIS)			,Nil},;
								{"A2_RECCSLL"	,Alltrim(o_Fornecedores:A2_RECCSLL)			,Nil},;
								{"A2_RECCOFI"	,Alltrim(o_Fornecedores:A2_RECCOFI)			,Nil},;
								{"A2_CALCIRF"	,Alltrim(o_Fornecedores:A2_CALCIRF)			,Nil},;
								{"A2_COMPLEM"	,Upper(Alltrim(o_Fornecedores:A2_COMPLEM))	,Nil},;
								{"A2_CONTATO"   ,Alltrim(o_Fornecedores:A2_CONTATO)			,Nil},;
								{"A2_TELEX"     ,Alltrim(o_Fornecedores:A2_TELEX)			,Nil},;
								{"A2_CONTA"		,Alltrim(o_Fornecedores:A2_CONTA)			,Nil}}
				EndIf
			Else //Alteracao ou exclusao
				aVetor:={	{"A2_COD"       ,c_Cod						,Nil},;
							{"A2_LOJA"	    ,c_Loja						,Nil},;
							{"A2_TIPO"      ,Upper(Alltrim(o_Fornecedores:A2_TIPO))		,Nil},;
							{"A2_NOME"      ,Upper(Alltrim(o_Fornecedores:A2_NOME))  	,Nil},;
							{"A2_NREDUZ"    ,Upper(Alltrim(o_Fornecedores:A2_NREDUZ))	,Nil},;
							{"A2_END"       ,Upper(Alltrim(o_Fornecedores:A2_END))		,Nil},;
							{"A2_EST"       ,Upper(Alltrim(o_Fornecedores:A2_EST))		,Nil},;
							{"A2_MUN"       ,Upper(Alltrim(o_Fornecedores:A2_MUN))		,Nil},;
							{"A2_BAIRRO"    ,Upper(Alltrim(o_Fornecedores:A2_BAIRRO))	,Nil},;
							{"A2_DDD"       ,Alltrim(o_Fornecedores:A2_DDD)				,Nil},;
							{"A2_CEP"       ,Alltrim(o_Fornecedores:A2_CEP)				,Nil},;
							{"A2_TEL"       ,Alltrim(o_Fornecedores:A2_TEL)				,Nil},;
							{"A2_EMAIL"     ,Upper(Alltrim(o_Fornecedores:A2_EMAIL))	,Nil},;
							{"A2_BANCO"     ,Alltrim(o_Fornecedores:A2_BANCO)			,Nil},;
							{"A2_AGENCIA"   ,Alltrim(o_Fornecedores:A2_AGENCIA)			,Nil},;
							{"A2_NUMCON"    ,Alltrim(o_Fornecedores:A2_NUMCON)			,Nil},;
							{"A2_XTPCONT"   ,Alltrim(o_Fornecedores:A2_XTPCONT)			,Nil},;
							{"A2_COD_MUN"	,Alltrim(o_Fornecedores:A2_COD_MUN)			,Nil},;
							{"A2_XDVAGE"	,Alltrim(o_Fornecedores:A2_XDVAGE)			,Nil},;
							{"A2_XDVCTA"	,Alltrim(o_Fornecedores:A2_XDVCTA)			,Nil},;
							{"A2_INSCR"		,Alltrim(o_Fornecedores:A2_INSCR)			,Nil},;
							{"A2_INSCRM"	,Alltrim(o_Fornecedores:A2_INSCRM)			,Nil},;
							{"A2_CODPAIS"	,Alltrim(o_Fornecedores:A2_CODPAIS)			,Nil},;
							{"A2_RECISS"	,Alltrim(o_Fornecedores:A2_RECISS)			,Nil},;
							{"A2_RECINSS"	,Alltrim(o_Fornecedores:A2_RECINSS)			,Nil},;
							{"A2_RECPIS"	,Alltrim(o_Fornecedores:A2_RECPIS)			,Nil},;
							{"A2_RECCSLL"	,Alltrim(o_Fornecedores:A2_RECCSLL)			,Nil},;
							{"A2_RECCOFI"	,Alltrim(o_Fornecedores:A2_RECCOFI)			,Nil},;
							{"A2_CALCIRF"	,Alltrim(o_Fornecedores:A2_CALCIRF)			,Nil},;
							{"A2_COMPLEM"	,Upper(Alltrim(o_Fornecedores:A2_COMPLEM))	,Nil},;
							{"A2_CONTATO"   ,Alltrim(o_Fornecedores:A2_CONTATO)			,Nil},;
							{"A2_TELEX"     ,Alltrim(o_Fornecedores:A2_TELEX)			,Nil},;
							{"A2_CONTA"		,Alltrim(o_Fornecedores:A2_CONTA)			,Nil}}
			EndIf

			//Exclusivo para a versao 12
			If (GetVersao(.F.) == "12")
				If (Upper(Alltrim(o_Fornecedores:A2_TIPO)) <> "F") .And. !(Empty(o_Fornecedores:A2_CNAE))
					aAdd(aVetor, {"A2_CNAE"		,Alltrim(o_Fornecedores:A2_CNAE)			,Nil})
				EndIf
			Else
				aAdd(aVetor, {"A2_CNAE"		,Alltrim(o_Fornecedores:A2_CNAE)			,Nil})
			EndIf

			lMsErroAuto		:= .F.
			lMsHelpAuto		:= .T.
			lAutoErrNoFile	:= .T.
			l_Ret			:= .T.
			Begin Transaction
				MSExecAuto({|x,y| Mata020(x,y)},aVetor,n_Operacao) //3- Inclusao, 4- Alteracao, 5- Exclusao
				If lMsErroAuto
					//Regra do fonte SIESBA01 da FIEB
					If (__lSX8)
						RollBackSX8()
					EndIf
					l_Ret			:= .F.
					// Tratamento da Mensagem de erro do MSExecAuto
					aLogErr  := GetAutoGRLog()
					aLogErr2 := f_TrataErro(aLogErr)
					_cMotivo := ""

					For i := 1 to Len(aLogErr2)
						_cMotivo += aLogErr2[i]
					Next

					//Exclusivo para a versao 12
					If (GetVersao(.F.) == "12")
						_cMotivo:=  NoAcentoESB(_cMotivo)
						SetSoapFault('Erro',_cMotivo)
					EndIf

					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= NoAcentoESB(_cMotivo)
					Conout("FFIEBW01 - mtdFornecedores: "+NoAcentoESB(_cMotivo))
					DisarmTransaction()
					Break
				Else
					If (n_Operacao = 3) .Or. (n_Operacao = 4)
						If (Upper(Alltrim(o_Fornecedores:A2_TIPO)) == 'X') //Fornecedor Outros
							DBSELECTAREA("SA2")
							DBSETORDER(1)
							DBSEEK(XFILIAL("SA2")+c_CodX+c_LojX)
						Else
							DBSELECTAREA("SA2")
							DBSETORDER(3)
							DBSEEK(XFILIAL("SA2")+Alltrim(o_Fornecedores:A2_CGC))
						EndIf
						//Gravacao dos multiplos bancos
						If Len(o_Fornecedores:MULBANCOS) > 0
							If !Empty(o_Fornecedores:MULBANCOS[1]:FIL_BANCO) .And. !Empty(o_Fornecedores:MULBANCOS[1]:FIL_AGENCIA) .And. !Empty(o_Fornecedores:MULBANCOS[1]:FIL_CONTA) .And. !Empty(o_Fornecedores:MULBANCOS[1]:FIL_TIPCTA)
								//Coloca todas as contas existentes como Normal (segundaria) para depois gravar ou atualizar tanto a conta principal quanto as secundarias
								DBSELECTAREA("FIL")
								DBSETORDER(1)
								If (DBSEEK(XFILIAL("FIL")+SA2->A2_COD+SA2->A2_LOJA))
									While !(FIL->(Eof())) .And. (FIL->FIL_FILIAL+FIL->FIL_FORNEC+FIL->FIL_LOJA == XFILIAL("FIL")+SA2->A2_COD+SA2->A2_LOJA)
										RecLock("FIL",.F.)
										FIL->FIL_TIPO:= '2'
										MsUnLock()
										FIL->(DbSkip())
									EndDo
								EndIf
								//Atualiza as contas
								For p:= 1 To Len(o_Fornecedores:MULBANCOS)
									c_Ban:= Padr(Alltrim(o_Fornecedores:MULBANCOS[p]:FIL_BANCO),TamSX3("FIL_BANCO")[1])
									c_Age:= Padr(Alltrim(o_Fornecedores:MULBANCOS[p]:FIL_AGENCIA),TamSX3("FIL_AGENCI")[1])
									c_Con:= Padr(Alltrim(o_Fornecedores:MULBANCOS[p]:FIL_CONTA),TamSX3("FIL_CONTA")[1])
									DBSELECTAREA("FIL")
									DBSETORDER(1)
									If (DBSEEK(XFILIAL("FIL")+SA2->A2_COD+SA2->A2_LOJA+Alltrim(o_Fornecedores:MULBANCOS[p]:FIL_TIPO)+c_Ban+c_Age+c_Con))
										RecLock("FIL",.F.)
										FIL->FIL_FILIAL	:= xFilial("FIL")
										FIL->FIL_FORNEC	:= SA2->A2_COD
										FIL->FIL_LOJA	:= SA2->A2_LOJA
										FIL->FIL_BANCO	:= c_Ban
										FIL->FIL_AGENCI := c_Age
										FIL->FIL_CONTA	:= c_Con
										FIL->FIL_TIPO	:= Alltrim(o_Fornecedores:MULBANCOS[p]:FIL_TIPO)
										FIL->FIL_DETRAC	:= "0"
										FIL->FIL_MOEDA	:= 1
										FIL->FIL_MOVCTO	:= Alltrim(o_Fornecedores:MULBANCOS[p]:FIL_MOVCTO)
										FIL->FIL_DVAGE	:= Alltrim(o_Fornecedores:MULBANCOS[p]:FIL_DVAGE)
										FIL->FIL_DVCTA	:= Alltrim(o_Fornecedores:MULBANCOS[p]:FIL_DVCTA)
										FIL->FIL_TIPCTA	:= Alltrim(o_Fornecedores:MULBANCOS[p]:FIL_TIPCTA)
										MsUnLock()
									Else
										l_Achei:= .F.
										DBSELECTAREA("FIL")
										DBSETORDER(1)
										If (DBSEEK(XFILIAL("FIL")+SA2->A2_COD+SA2->A2_LOJA))
											While !(FIL->(Eof())) .And. (FIL->FIL_FILIAL+FIL->FIL_FORNEC+FIL->FIL_LOJA == XFILIAL("FIL")+SA2->A2_COD+SA2->A2_LOJA)
												If (FIL->FIL_BANCO = c_Ban) .And. (FIL->FIL_AGENCI = c_Age) .And. (FIL->FIL_CONTA = c_Con)
													RecLock("FIL",.F.)
													FIL->FIL_FILIAL	:= xFilial("FIL")
													FIL->FIL_FORNEC	:= SA2->A2_COD
													FIL->FIL_LOJA	:= SA2->A2_LOJA
													FIL->FIL_BANCO	:= c_Ban
													FIL->FIL_AGENCI := c_Age
													FIL->FIL_CONTA	:= c_Con
													FIL->FIL_TIPO	:= Alltrim(o_Fornecedores:MULBANCOS[p]:FIL_TIPO)
													FIL->FIL_DETRAC	:= "0"
													FIL->FIL_MOEDA	:= 1
													FIL->FIL_MOVCTO	:= Alltrim(o_Fornecedores:MULBANCOS[p]:FIL_MOVCTO)
													FIL->FIL_DVAGE	:= Alltrim(o_Fornecedores:MULBANCOS[p]:FIL_DVAGE)
													FIL->FIL_DVCTA	:= Alltrim(o_Fornecedores:MULBANCOS[p]:FIL_DVCTA)
													FIL->FIL_TIPCTA	:= Alltrim(o_Fornecedores:MULBANCOS[p]:FIL_TIPCTA)
													MsUnLock()
													l_Achei:= .T.
													Exit
												EndIf
												FIL->(DbSkip())
											EndDo
										EndIf
										If !(l_Achei)
											DBSELECTAREA("FIL")
											RecLock("FIL",.T.)
											FIL->FIL_FILIAL	:= xFilial("FIL")
											FIL->FIL_FORNEC	:= SA2->A2_COD
											FIL->FIL_LOJA	:= SA2->A2_LOJA
											FIL->FIL_BANCO	:= c_Ban
											FIL->FIL_AGENCI := c_Age
											FIL->FIL_CONTA	:= c_Con
											FIL->FIL_TIPO	:= Alltrim(o_Fornecedores:MULBANCOS[p]:FIL_TIPO)
											FIL->FIL_DETRAC	:= "0"
											FIL->FIL_MOEDA	:= 1
											FIL->FIL_MOVCTO	:= Alltrim(o_Fornecedores:MULBANCOS[p]:FIL_MOVCTO)
											FIL->FIL_DVAGE	:= Alltrim(o_Fornecedores:MULBANCOS[p]:FIL_DVAGE)
											FIL->FIL_DVCTA	:= Alltrim(o_Fornecedores:MULBANCOS[p]:FIL_DVCTA)
											FIL->FIL_TIPCTA	:= Alltrim(o_Fornecedores:MULBANCOS[p]:FIL_TIPCTA)
											MsUnLock()
										EndIf
									EndIf
								Next
								//Atualiza o banco no cadastro do fornecedor
								DbSelectArea("SA2")
								RecLock("SA2",.F.)
								SA2->A2_BANCO	:= SPACE(TAMSX3("A2_BANCO")[1])
								SA2->A2_AGENCIA	:= SPACE(TAMSX3("A2_AGENCIA")[1])
								SA2->A2_NUMCON	:= SPACE(TAMSX3("A2_NUMCON")[1])
								SA2->A2_XTPCONT	:= SPACE(TAMSX3("A2_XTPCONT")[1])
								SA2->A2_XDVAGE	:= SPACE(TAMSX3("A2_XDVAGE")[1])
								SA2->A2_XDVCTA	:= SPACE(TAMSX3("A2_XDVCTA")[1])
								SA2->A2_DVAGE	:= SPACE(TAMSX3("A2_DVAGE")[1])
								SA2->A2_DVCTA	:= SPACE(TAMSX3("A2_DVCTA")[1])
								MsUnLock()

								DBSELECTAREA("FIL")
								DBSETORDER(1)
								If (DBSEEK(XFILIAL("FIL")+SA2->A2_COD+SA2->A2_LOJA))
									While !(FIL->(Eof())) .And. (FIL->FIL_FILIAL+FIL->FIL_FORNEC+FIL->FIL_LOJA == XFILIAL("FIL")+SA2->A2_COD+SA2->A2_LOJA)
										If (Alltrim(FIL->FIL_TIPO) = '1') .And. (Alltrim(FIL->FIL_MOVCTO) = '1')
											DbSelectArea("SA2")
											RecLock("SA2",.F.)
											SA2->A2_BANCO	:= FIL->FIL_BANCO
											SA2->A2_AGENCIA	:= FIL->FIL_AGENCIA
											SA2->A2_NUMCON	:= FIL->FIL_CONTA
											SA2->A2_XTPCONT	:= FIL->FIL_TIPCTA
											SA2->A2_XDVAGE	:= FIL->FIL_DVAGE
											SA2->A2_XDVCTA	:= FIL->FIL_DVCTA
											SA2->A2_DVAGE	:= FIL->FIL_DVAGE
											SA2->A2_DVCTA	:= FIL->FIL_DVCTA
											MsUnLock()
											Exit
										EndIf
										FIL->(DbSkip())
									EndDo
								EndIf
							EndIf
						EndIf
					Else
						//Exclusao dos multiplos bancos
						DBSELECTAREA("FIL")
						DBSETORDER(1)
						If (DBSEEK(XFILIAL("FIL")+c_Cod+c_Loja))
							While !(FIL->(Eof())) .And. (FIL->FIL_FILIAL+FIL->FIL_FORNEC+FIL->FIL_LOJA == XFILIAL("FIL")+c_Cod+c_Loja)
								RecLock("FIL",.F.)
								DbDelete()
								MsUnLock()
								FIL->(DbSkip())
							EndDo
						EndIf
					EndIf
					If (n_Operacao = 3)
						If (__lSX8)
							ConfirmSX8()
						EndIf
						If (Upper(Alltrim(o_Fornecedores:A2_TIPO)) == 'X') //Fornecedor Outros
							DBSELECTAREA("SA2")
							DBSETORDER(1)
							DBSEEK(XFILIAL("SA2")+c_CodX+c_LojX)
						Else
							DBSELECTAREA("SA2")
							DBSETORDER(3)
							DBSEEK(XFILIAL("SA2")+Alltrim(o_Fornecedores:A2_CGC))
						EndIf

						//------------------------------------------ I N I C I O ----------------------------------------------------------------------
						//Por: Francisco Rezende
						//Solicitante: Paula Nolasco
						//Motivo: Gravacao da Entidade Contabil
						//Data: 31/07/2019
						//-----------------------------------------------------------------------------------------------------------------------------
						c_Item      := GetSxeNum( "CV0" , "CV0_ITEM" )
						c_Codigo    := "F"+ Alltrim(o_Fornecedores:A2_CGC)
						c_Descricao := Upper(Alltrim(o_Fornecedores:A2_NOME))

						a_Vetor := { { "CV0_PLANO"  , "05"       			, Nil } , ;
						            { "CV0_ITEM"   , c_Item 	   		 	, Nil } , ;
						            { "CV0_CODIGO" , c_Codigo    			, Nil } , ;
						            { "CV0_DESC"   , c_Descricao			, Nil } , ;
						            { "CV0_CLASSE" , "2"    				, Nil } , ;
						            { "CV0_NORMAL" , "1"       				, Nil } , ;
						            { "CV0_ENTSUP" , "C" 					, Nil } , ;
						            { "CV0_DTIEXI" , CtoD( "01/01/2000" )	, Nil } }

						MSExecAuto( { | x , y | CTBA800( x , y ) } , a_Vetor , 3 ) //3 - Inclusao, 4 - Alteracao, 5 - Exclusao

						If( lMsErroAuto )
						   RollBackSX8()
						   //MostraErro()
						   l_ErrEnt := .T.
						Else
							ConfirmSX8()
						Endif
						//----------------------------------------------- F I M --------------------------------------------------------------------

						::o_Retorno:l_Status		:= .T.
						If l_ErrEnt
							::o_Retorno:c_Mensagem	:= "Fornecedor "+SA2->A2_COD+"/"+SA2->A2_LOJA+" incluido com sucesso. Erro ao gravar a Entidade 05"
							Conout("FFIEBW01 - mtdFornecedores: Fornecedor "+SA2->A2_COD+"/"+SA2->A2_LOJA+" incluido com sucesso. Erro ao gravar a Entidade 05")
						Else
							::o_Retorno:c_Mensagem	:= "Fornecedor "+SA2->A2_COD+"/"+SA2->A2_LOJA+" incluido com sucesso. Entidade 05 gravada com sucesso!!!"
							Conout("FFIEBW01 - mtdFornecedores: Fornecedor "+SA2->A2_COD+"/"+SA2->A2_LOJA+" incluido com sucesso. Entidade 05 gravada com sucesso!!!")
						EndIf
					ElseIf (n_Operacao = 4)

						//------------------------------------------ I N I C I O ----------------------------------------------------------------------
						//Por: Francisco Rezende
						//Solicitante: Paula Nolasco
						//Motivo: Gravacao da Entidade Contabil
						//Data: 31/07/2019
						//-----------------------------------------------------------------------------------------------------------------------------
						c_Item      := GetSxeNum( "CV0" , "CV0_ITEM" )
						c_Codigo    := "F"+ Alltrim(o_Fornecedores:A2_CGC)
						c_Descricao := Upper(Alltrim(o_Fornecedores:A2_NOME))
						dbSelectArea("CV0")
						dbSetOrder(1)
						If dbSeek(xFilial("CV0") + "05" + c_Codigo, .T. )
							n_OperEnt := 4
						EndIf

						a_Vetor := { { "CV0_PLANO"  , "05"       			, Nil } , ;
						            { "CV0_ITEM"   , c_Item 	   		 	, Nil } , ;
						            { "CV0_CODIGO" , c_Codigo    			, Nil } , ;
						            { "CV0_DESC"   , c_Descricao			, Nil } , ;
						            { "CV0_CLASSE" , "2"    				, Nil } , ;
						            { "CV0_NORMAL" , "1"       				, Nil } , ;
						            { "CV0_ENTSUP" , "C" 					, Nil } , ;
						            { "CV0_DTIEXI" , CtoD( "01/01/2000" )	, Nil } }

						MSExecAuto( { | x , y | CTBA800( x , y ) } , a_Vetor , n_OperEnt ) //3 - Inclusao, 4 - Alteracao, 5 - Exclusao

						If( lMsErroAuto )
						   RollBackSX8()
						   //MostraErro()
						   l_ErrEnt := .T.
						Else
							ConfirmSX8()
						Endif
						//----------------------------------------------- F I M --------------------------------------------------------------------

						::o_Retorno:l_Status		:= .T.
						If l_ErrEnt
							::o_Retorno:c_Mensagem	:= "Fornecedor "+c_Cod+"/"+c_Loja+" alterado com sucesso.  Erro ao gravar a Entidade 05"
							Conout("FFIEBW01 - mtdFornecedores: Fornecedor "+c_Cod+"/"+c_Loja+" alterado com sucesso.  Erro ao gravar a Entidade 05")
						Else
							::o_Retorno:c_Mensagem	:= "Fornecedor "+c_Cod+"/"+c_Loja+" alterado com sucesso. Entidade 05 gravada com sucesso!!!"
							Conout("FFIEBW01 - mtdFornecedores: Fornecedor "+c_Cod+"/"+c_Loja+" alterado com sucesso. Entidade 05 gravada com sucesso!!!")
						EndIf
					Else
						::o_Retorno:l_Status		:= .T.
						::o_Retorno:c_Mensagem	:= "Fornecedor "+c_Cod+"/"+c_Loja+" excluido com sucesso."
						Conout("FFIEBW01 - mtdFornecedores: Fornecedor "+c_Cod+"/"+c_Loja+" excluido com sucesso.")
					EndIf
				Endif
			End Transaction
		EndIf
	EndIf
	//RpcClearEnv() //Limpa o ambiente, liberando a licenca e fechando as conexoes

RETURN(l_Ret)
/*/{Protheus.doc} mtdProdutos
metodo de produtos
@author Totvs-BA
@since 01/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSMETHOD mtdProdutos WSRECEIVE o_Seguranca, o_Empresa, o_Produtos, Operacao WSSEND o_Retorno WSSERVICE FFIEBW01

	Local c_Cod			:= ""
	Local n_Operacao	:= Val(::Operacao)
	Local i				:= 0
	PRIVATE lMsErroAuto := .F.

	::o_Retorno	:= WSCLASSNEW("strRetorno")

	If !(f_VldFilEmp(o_Empresa:c_Empresa,o_Empresa:c_Filial))
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Codigo de Empresa/Filial nao existe."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdProdutos: Codigo de Empresa/Filial nao existe.")
		Return(.T.)
	EndIf

	//Loga na filial solicitada
	RpcSetType(3)
	RpcSetEnv(o_Empresa:c_Empresa,o_Empresa:c_Filial, "integracao", "fieb123")

	//Posiciona na empresa e filial passada
	dbSelectArea("SM0")
	dbSeek(o_Empresa:c_Empresa+o_Empresa:c_Filial)

	cFilAnt:= o_Empresa:c_Filial

	c_UserWS	:= Upper(ALLTRIM(SUPERGETMV("FS_FIUSRWS",,"totvs_fieb")))
	c_PswWS		:= Upper(ALLTRIM(SUPERGETMV("FS_FIPSWWS",,"totvs@123")))

	//Validando o usuario e senha
	If ( Upper(o_Seguranca:c_Usuario) <> Upper(c_UserWS) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdProdutos: Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido.")
		Return(.T.)
	ElseIf ( Upper(o_Seguranca:c_Senha) <> Upper(c_PswWS) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdProdutos: Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida.")
		Return(.T.)
	ElseIf (n_Operacao < 3) .Or. (n_Operacao > 5)
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Valor passado no parametro Operacao ("+cValToChar(n_Operacao)+") invalido. Informar (3=Inclusao; 4=Alteracao; 5=Exclusao)."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdProdutos: Valor passado no parametro Operacao ("+cValToChar(n_Operacao)+") invalido. Informar (3=Inclusao; 4=Alteracao; 5=Exclusao).")
		Return(.T.)
	//ElseIf (Alltrim(o_Produtos:B1_FILIAL) <> Alltrim(o_Empresa:c_Filial))
	//	::o_Retorno:l_Status		:= .F.
	//	::o_Retorno:c_Mensagem	:= "A filial informada no produto eh diferente da filial passada no objeto O_Empresa."+CHR(13)+CHR(10)
	//	Conout("FFIEBW01 - mtdProdutos: A filial informada no produto eh diferente da filial passada no objeto O_Empresa.")
	//	Return(.T.)
	ElseIf (Upper(Alltrim(o_Produtos:B1_RASTRO)) <> "S") .And. (Upper(Alltrim(o_Produtos:B1_RASTRO)) <> "L") .And. (Upper(Alltrim(o_Produtos:B1_RASTRO)) <> "N")
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Rastro "+Upper(Alltrim(o_Produtos:B1_RASTRO))+" invalido. Informar: (S=SubLote ou L=Lote ou N=NaoUtiliza)."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdProdutos: Rastro "+Upper(Alltrim(o_Produtos:B1_RASTRO))+" invalido. Informar: (S=SubLote ou L=Lote ou N=NaoUtiliza).")
		Return(.T.)
	Else
		dbSelectArea("SX5")
		dbSetOrder(1)
		If !(dbSeek(xfilial("SX5")+"02"+Alltrim(o_Produtos:B1_TIPO)))
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Tipo "+Alltrim(o_Produtos:B1_TIPO)+" invalido."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdProdutos: Tipo "+Alltrim(o_Produtos:B1_TIPO)+" invalido.")
			Return(.T.)
		Else
			dbSelectArea("SAH")
			dbSetOrder(1)
			If !(dbSeek(xfilial("SAH")+Alltrim(o_Produtos:B1_UM)))
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Unidade de Medida "+Alltrim(o_Produtos:B1_UM)+" invalida."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdProdutos: Unidade de Medida "+Alltrim(o_Produtos:B1_UM)+" invalida.")
				Return(.T.)
			Else
				dbSelectArea("NNR")
				dbSetOrder(1)
				If !(dbSeek(xfilial("NNR")+Alltrim(o_Produtos:B1_LOCPAD)))
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Armazem "+Alltrim(o_Produtos:B1_LOCPAD)+" invalido."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdProdutos: Armazem "+Alltrim(o_Produtos:B1_LOCPAD)+" invalido.")
					Return(.T.)
				Else
					dbSelectArea("SBM")
					dbSetOrder(1)
					If !(dbSeek(xfilial("SBM")+Alltrim(o_Produtos:B1_GRUPO)))
						::o_Retorno:l_Status		:= .F.
						::o_Retorno:c_Mensagem	:= "Grupo de Produto "+Alltrim(o_Produtos:B1_GRUPO)+" nao encontrado no protheus."+CHR(13)+CHR(10)
						Conout("FFIEBW01 - mtdProdutos: Grupo de Produto "+Alltrim(o_Produtos:B1_GRUPO)+" nao encontrado no protheus.")
						Return(.T.)
					Else
						//Validando a conta contabil
						If !Empty(o_Produtos:B1_CONTA)
							DBSELECTAREA("CT1")
							DBSETORDER(1)
							IF !DBSEEK(xFilial("CT1")+Alltrim(o_Produtos:B1_CONTA))
								::o_Retorno:l_Status		:= .F.
								::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_Produtos:B1_CONTA)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+"."
								Conout("FFIEBW01 - mtdProdutos: Codigo da conta contabil ("+Alltrim(o_Produtos:B1_CONTA)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+".")
								Return(.T.)
							ElseIf CT1->CT1_CLASSE == "1"
								::o_Retorno:l_Status		:= .F.
								::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_Produtos:B1_CONTA)+") nao pode ser sintetica."
								Conout("FFIEBW01 - mtdProdutos: Codigo da conta contabil ("+Alltrim(o_Produtos:B1_CONTA)+") nao pode ser sintetica.")
								Return(.T.)
							ElseIf CT1->CT1_BLOQ == "1"
								::o_Retorno:l_Status		:= .F.
								::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_Produtos:B1_CONTA)+") esta bloqueada para uso."
								Conout("FFIEBW01 - mtdProdutos: Codigo da conta contabil ("+Alltrim(o_Produtos:B1_CONTA)+")  esta bloqueada para uso.")
								Return(.T.)
							EndIf
						EndIf
						DBSELECTAREA("SB1")
						DBSETORDER(1)
						If DBSEEK(XFILIAL("SB1")+Alltrim(o_Produtos:B1_COD))
							c_Cod	:= SB1->B1_COD
						Else//Se nao achou o produto
							If (n_Operacao = 4) .OR. (n_Operacao = 5)
								::o_Retorno:l_Status	:= .F.
								::o_Retorno:c_Mensagem	:= "Produto "+Alltrim(o_Produtos:B1_COD)+" nao encontrado."+CHR(13)+CHR(10)
								Conout("Produto "+Alltrim(o_Produtos:B1_COD)+" nao encontrado para fazer alteracao.")
								Return(.T.)
							EndIf
						EndIf

						If (n_Operacao = 3)
							If (Upper(Alltrim(o_Produtos:B1_TIPO)) == "SV") //Servico
								aVetor:={	{"B1_COD"       ,Upper(Alltrim(o_Produtos:B1_COD))		,Nil},;
											{"B1_DESC"      ,Upper(Alltrim(o_Produtos:B1_DESC))		,Nil},;
											{"B1_TIPO"      ,Upper(Alltrim(o_Produtos:B1_TIPO))		,Nil},;
											{"B1_UM"        ,Upper(Alltrim(o_Produtos:B1_UM))  		,Nil},;
											{"B1_GRUPO"     ,Upper(Alltrim(o_Produtos:B1_GRUPO))  	,Nil},;
											{"B1_LOCPAD"    ,Upper(Alltrim(o_Produtos:B1_LOCPAD))   ,Nil},;
											{"B1_RASTRO"    ,Upper(Alltrim(o_Produtos:B1_RASTRO))  	,Nil},;
											{"B1_CODISS"    ,"9.99" ,Nil},;
											{"B1_INSS"    	,"S"	,Nil},;
											{"B1_PIS"    	,"1"	,Nil},;
											{"B1_COFINS"    ,"1"	,Nil},;
											{"B1_CSLL"    	,"1"	,Nil},;
											{"B1_IRRF"    	,"S"	,Nil},;
											{"B1_CONTA"     ,Upper(Alltrim(o_Produtos:B1_CONTA))  	,Nil}}
							Else// (Upper(Alltrim(o_Produtos:B1_TIPO)) == "PA") //Produto acabado
								aVetor:={	{"B1_COD"       ,Upper(Alltrim(o_Produtos:B1_COD))		,Nil},;
											{"B1_DESC"      ,Upper(Alltrim(o_Produtos:B1_DESC))		,Nil},;
											{"B1_TIPO"      ,Upper(Alltrim(o_Produtos:B1_TIPO))		,Nil},;
											{"B1_UM"        ,Upper(Alltrim(o_Produtos:B1_UM))  		,Nil},;
											{"B1_GRUPO"     ,Upper(Alltrim(o_Produtos:B1_GRUPO))  	,Nil},;
											{"B1_LOCPAD"    ,Upper(Alltrim(o_Produtos:B1_LOCPAD))   ,Nil},;
											{"B1_RASTRO"    ,Upper(Alltrim(o_Produtos:B1_RASTRO))  	,Nil},;
											{"B1_INSS"    	,"N"	,Nil},;
											{"B1_PIS"    	,"2"	,Nil},;
											{"B1_COFINS"    ,"2"	,Nil},;
											{"B1_CSLL"    	,"2"	,Nil},;
											{"B1_IRRF"    	,"N"	,Nil},;
											{"B1_CONTA"     ,Upper(Alltrim(o_Produtos:B1_CONTA))  	,Nil}}
							EndIf
						ElseIf (n_Operacao = 5) //exclusao
							aVetor:={	{"B1_DESC"      ,Upper(Alltrim(o_Produtos:B1_DESC))		,Nil},;
										{"B1_TIPO"      ,Upper(Alltrim(o_Produtos:B1_TIPO))		,Nil},;
										{"B1_UM"        ,Upper(Alltrim(o_Produtos:B1_UM))  		,Nil},;
										{"B1_GRUPO"     ,Upper(Alltrim(o_Produtos:B1_GRUPO))  	,Nil},;
										{"B1_LOCPAD"    ,Upper(Alltrim(o_Produtos:B1_LOCPAD))   ,Nil},;
										{"B1_RASTRO"    ,Upper(Alltrim(o_Produtos:B1_RASTRO))  	,Nil},;
										{"B1_CONTA"     ,Upper(Alltrim(o_Produtos:B1_CONTA))  	,Nil}}

						Else //Alteracao
							DBSELECTAREA("SB1")
							DBSETORDER(1)
							If DBSEEK(XFILIAL("SB1")+Alltrim(o_Produtos:B1_COD))
								RecLock("SB1", .F. )
								SB1->B1_DESC	:= Upper(Alltrim(o_Produtos:B1_DESC))
								SB1->B1_TIPO	:= Upper(Alltrim(o_Produtos:B1_TIPO))
								SB1->B1_UM		:= Upper(Alltrim(o_Produtos:B1_UM))
								SB1->B1_GRUPO	:= Upper(Alltrim(o_Produtos:B1_GRUPO))
								SB1->B1_LOCPAD	:= Upper(Alltrim(o_Produtos:B1_LOCPAD))
								SB1->B1_RASTRO	:= Upper(Alltrim(o_Produtos:B1_RASTRO))
								SB1->B1_CONTA	:= Upper(Alltrim(o_Produtos:B1_CONTA))
								If (Upper(Alltrim(o_Produtos:B1_TIPO)) == "SV") //Servico
									SB1->B1_CODISS	:= "9.99"
									SB1->B1_INSS	:= "S"
									SB1->B1_PIS		:= "1"
									SB1->B1_COFINS	:= "1"
									SB1->B1_CSLL	:= "1"
									SB1->B1_IRRF	:= "S"
								Else
									SB1->B1_INSS	:= "N"
									SB1->B1_PIS		:= "2"
									SB1->B1_COFINS	:= "2"
									SB1->B1_CSLL	:= "2"
									SB1->B1_IRRF	:= "N"
								EndIf
								MsUnlock()
								Self:o_Retorno:l_Status		:= .T.
								Self:o_Retorno:c_Mensagem	:= "Produto "+Alltrim(c_Cod)+" alterado com sucesso."
								Conout("FFIEBW01 - mtdProdutos: Produto "+Alltrim(c_Cod)+" alterado com sucesso.")
								Return( .T. )
							Else
								Self:o_Retorno:l_Status	:= .F.
								Self:o_Retorno:c_Mensagem	:= "Produto "+Alltrim(o_Produtos:B1_COD)+" nao encontrado."+CHR(13)+CHR(10)
								Conout("Produto "+Alltrim(o_Produtos:B1_COD)+" nao encontrado para fazer alteracao.")
								Return( .T. )
							EndIf
						EndIf
						If (n_Operacao = 3) .Or.  (n_Operacao = 5)
							lMsErroAuto		:= .F.
							lMsHelpAuto		:= .T.
							lAutoErrNoFile	:= .T.
							MSExecAuto({|x,y| Mata010(x,y)},aVetor,n_Operacao) //3- Inclusao, 4- Alteracao, 5- Exclusao
							If lMsErroAuto
								//Regra do fonte SIESBA01 da FIEB
								If (__lSX8)
									RollBackSX8()
								EndIf

								// Tratamento da Mensagem de erro do MSExecAuto
								aLogErr  := GetAutoGRLog()
								aLogErr2 := f_TrataErro(aLogErr)
								_cMotivo := ""

								For i := 1 to Len(aLogErr2)
									_cMotivo += aLogErr2[i]
								Next

								//Exclusivo para a versao 12
								If (GetVersao(.F.) == "12")
									_cMotivo:=  NoAcentoESB(_cMotivo)
									SetSoapFault('Erro',_cMotivo)
								EndIf

								::o_Retorno:l_Status	:= .F.
								::o_Retorno:c_Mensagem	:= NoAcentoESB(_cMotivo)
								Conout("FFIEBW01 - mtdProdutos: "+NoAcentoESB(_cMotivo))
								DisarmTransaction()
								Break
							Else
								If (n_Operacao = 3)
									If (__lSX8)
										ConfirmSX8()
									EndIf
									::o_Retorno:l_Status		:= .T.
									::o_Retorno:c_Mensagem	:= "Produto "+Alltrim(SB1->B1_COD)+" incluido com sucesso."
									Conout("FFIEBW01 - mtdProdutos: Produto "+Alltrim(SB1->B1_COD)+" incluido com sucesso.")
								ElseIf (n_Operacao = 4)
									::o_Retorno:l_Status		:= .T.
									::o_Retorno:c_Mensagem	:= "Produto "+Alltrim(c_Cod)+" alterado com sucesso."
									Conout("FFIEBW01 - mtdProdutos: Produto "+Alltrim(c_Cod)+" alterado com sucesso.")
								Else
									::o_Retorno:l_Status		:= .T.
									::o_Retorno:c_Mensagem	:= "Produto "+Alltrim(c_Cod)+" excluido com sucesso."
									Conout("FFIEBW01 - mtdProdutos: Produto "+Alltrim(c_Cod)+" excluido com sucesso.")
								EndIf
							Endif
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	//RpcClearEnv() //Limpa o ambiente, liberando a licenca e fechando as conexoes

RETURN(.T.)
/*/{Protheus.doc} mtdTitReceber
metodo de titulos a receber
@author Totvs-BA
@since 01/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSMETHOD mtdTitReceber WSRECEIVE o_Seguranca, o_Empresa, o_TitReceber, Operacao WSSEND o_Retorno WSSERVICE FFIEBW01

	Local c_Cliente		:= ""
	Local c_Loja		:= ""
	Local c_Fornecedor	:= ""
	Local c_LjFor		:= ""
	Local c_NatFor		:= ""
	Local c_CR			:= ""
	Local a_Banco		:= {}
	Local c_MsgRet		:= ""
	Local c_Tipo		:= ""
	Local c_Natureza	:= ""
	Local c_TemRatCC	:= ""
	Local n_Valor		:= 0
	Local n_PercNat		:= 0
	Local n_ValNat		:= 0
	Local n_ValCC		:= 0
	Local d_VencRea		:= CTOD("  /  /  ")
	Local a_RatNat		:= {}
	Local a_RatCC		:= {}
	Local a_RatEvEz		:= {}
	Local a_Rateio		:= {}
	Local aVetor		:= {}
	Local n_Operacao	:= Val(::Operacao)
	Local i				:= 0
	Local c_MsgVldRat	:= ""
	Local c_CCGatilho	:= ""
	Local c_ErrMsg		:= ""
	Local d_DataBk		:= DDATABASE
	Local l_GravE2		:= .F.
	Local c_CgcFil		:= ""
	Local o_Fieb		:= clsFieb():New()
	Local aRatEvEz		:= ""
	Local l_TemEvEz		:= .F.
	//--//
	d_BkDtBase			:=	dDatabase //Bakcup database no inicio do processo
	//--//
	PRIVATE lMsErroAuto := .F.

	::o_Retorno	:= WSCLASSNEW("strRetorno")

	If !(f_VldFilEmp(o_Empresa:c_Empresa,o_Empresa:c_Filial))
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Codigo de Empresa/Filial nao existe."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdTitReceber: Codigo de Empresa/Filial nao existe.")
		Return(.T.)
	EndIf

	//Loga na filial solicitada
	RpcSetType(3)
	RpcSetEnv(o_Empresa:c_Empresa,o_Empresa:c_Filial, "integracao", "fieb123")

	//Posiciona na empresa e filial passada
	dbSelectArea("SM0")
	dbSeek(o_Empresa:c_Empresa+o_Empresa:c_Filial)

	cFilAnt:= o_Empresa:c_Filial

	c_UserWS	:= Upper(ALLTRIM(SUPERGETMV("FS_FIUSRWS",,"totvs_fieb")))
	c_PswWS		:= Upper(ALLTRIM(SUPERGETMV("FS_FIPSWWS",,"totvs@123")))

	__cUserId:= "000359"
	cusuario:= "******Integracao WebSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN"

	//Validando o usuario e senha
	If ( Upper(o_Seguranca:c_Usuario) <> Upper(c_UserWS) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdTitReceber: Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido.")
		Return(.T.)
	ElseIf ( Upper(o_Seguranca:c_Senha) <> Upper(c_PswWS) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdTitReceber: Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida.")
		Return(.T.)
	ElseIf (n_Operacao < 3) .Or. (n_Operacao > 5)
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Valor passado no parametro Operacao ("+cValToChar(n_Operacao)+") invalido. Informar (3=Inclusao; 4=Alteracao; 5=Exclusao)."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdTitReceber: Valor passado no parametro Operacao ("+cValToChar(n_Operacao)+") invalido. Informar (3=Inclusao; 4=Alteracao; 5=Exclusao).")
		Return(.T.)
	Else
		If Empty(o_TitReceber:E1_NUM)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe o numero do titulo."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdTitReceber: Informe o numero do titulo.")
			Return(.T.)
		ElseIf Empty(o_TitReceber:E1_TIPO)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe o tipo do titulo."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdTitReceber: Informe o tipo do titulo.")
			Return(.T.)
		ElseIf Empty(o_TitReceber:E1_NATUREZ)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe a natureza do titulo."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdTitReceber: Informe a natureza do titulo.")
			Return(.T.)
		ElseIf Empty(o_TitReceber:CGC)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe o CNPJ/CPF do cliente do titulo."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdTitReceber: Informe o CNPJ/CPF do cliente do titulo.")
			Return(.T.)
		ElseIf Empty(o_TitReceber:E1_EMISSAO)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe a data de emissao titulo."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdTitReceber: Informe a data de emissao do titulo.")
			Return(.T.)
		ElseIf Empty(o_TitReceber:E1_VENCTO)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe a data de vencimento titulo."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdTitReceber: Informe a data de vencimento do titulo.")
			Return(.T.)
		Else
			DBSELECTAREA("SA1")
			DBSETORDER(3)
			If !(DBSEEK(XFILIAL("SA1")+Alltrim(o_TitReceber:CGC)))
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "CNPJ/CPF "+Alltrim(o_TitReceber:CGC)+" nao encontrado na base de dados do protheus."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdTitReceber: CNPJ/CPF "+Alltrim(o_TitReceber:CGC)+" nao encontrado na base de dados do protheus.")
				Return(.T.)
			Else
				c_Cliente	:= SA1->A1_COD
				c_Loja		:= SA1->A1_LOJA
			EndIf

			//Valida o tipo
			dbSelectArea("SX5")
			dbSetOrder(1)
			If !(dbSeek(xfilial("SX5")+"05"+Alltrim(o_TitReceber:E1_TIPO)))
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Tipo "+Alltrim(o_TitReceber:E1_TIPO)+" nao encontrado na base de dados do protheus."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdTitReceber: Tipo "+Alltrim(o_TitReceber:E1_TIPO)+" nao encontrado na base de dados do protheus.")
				Return(.T.)
			Else
				c_Tipo	:= SX5->X5_CHAVE
			EndIf

			//Valida se o numero do titulo possui caracter especiais, com excessao do prefixo RM
			If ( Alltrim(o_TitReceber:E1_PREFIXO) <> 'RM')
				//Valida se tem caracter especial. 05/02/2019
				If !f_VldCaracter( Alltrim(o_TitReceber:E1_NUM) )
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "O numero do titulo nao pode conter caracteres especiais.( "+Alltrim(o_TitReceber:E1_NUM)+" )"+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdTitReceber: O numero do titulo nao pode conter caracteres especiais.")
					Return(.T.)
				EndIf
			EndIf
			
			If !Empty( Alltrim( o_TitReceber:OD_TIPO ) ) 
				If !( Alltrim( o_TitReceber:OD_TIPO ) $ "1|2" )
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "O tipo de OD quando preenchido deve conter 1=Subsidio ou 2=Desconto Folha."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdTitReceber: O tipo de OD quando preenchido deve conter 1=Subsidio ou 2=Desconto Folha.")
					Return(.T.)
				Else
					//CGC da filial do titulo a receber que sera fornecedor 
					c_CgcFil		:= SM0->M0_CGC 
					dbSelectArea("SA2")
					dbSetOrder(3)
					If !dbSeek( xFilial("SA2") + Alltrim(c_CgcFil) )
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "Para subsidio o CNPJ " + Alltrim(c_CgcFil) + " nao foi encontrado no cadastro de Fornecedores."+CHR(13)+CHR(10)
						Conout("FFIEBW01 - mtdTitReceber: Para subsidio o CNPJ " + Alltrim(c_CgcFil) + " nao foi encontrado no cadastro de Fornecedores.")
						Return(.T.)
					Else
						 c_Fornecedor	:= SA2->A2_COD
						 c_LjFor		:= SA2->A2_LOJA
						 c_FilBkp		:= SM0->M0_CODFIL						 
						 //Busca o codigo da filial do titulo a pagar
						 dbSelectArea("SM0")
						 dbGotop()
						 While( !SM0->( Eof() ) ) 
						 	If( Alltrim( SM0->M0_CGC ) == Alltrim( o_TitReceber:CGC ) )
						 		c_FilTitOd:= SM0->M0_CODFIL
						 		Exit
						 	EndIf
						 	SM0->( DbSkip() )
						 EndDo
						 dbSelectArea("SM0")
						 dbSeek( o_Empresa:c_Empresa + c_FilBkp )					 
					EndIf
				EndIf
			EndIf
			
			c_Pre:= PADR(Alltrim(o_TitReceber:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1])
			c_Num:= PADR(Alltrim(o_TitReceber:E1_NUM), TAMSX3("E1_NUM")[1])
			c_Par:= PADR(Alltrim(o_TitReceber:E1_PARCELA), TAMSX3("E1_PARCELA")[1])
			c_Tip:= PADR(Alltrim(o_TitReceber:E1_TIPO), TAMSX3("E1_TIPO")[1])

			DBSELECTAREA("SE1")
			DBSETORDER(1)
			If (DBSEEK(XFILIAL("SE1")+c_Pre+c_Num+c_Par+c_Tip+c_Cliente+c_Loja))
				If (n_Operacao = 3)
					//Tratamento para retornar .T. a pedido de Rafael. 03/12/2018
					d_TesteData	:=	StoD(o_TitReceber:E1_EMISSAO)
					n_Valor		:= o_TitReceber:E1_VALOR
					If (d_TesteData = SE1->E1_EMISSAO) .And. (n_Valor = SE1->E1_VALOR)
						::o_Retorno:l_Status	:= .T.
						::o_Retorno:c_Mensagem	:= "###Titulo de numero "+Alltrim(SE1->E1_NUM)+" ja incluido com sucesso na filial "+o_Empresa:c_Filial+"."
						Conout("FFIEBW01 - mtdTitReceber: ###Titulo de numero "+Alltrim(SE1->E1_NUM)+" ja incluido com sucesso na filial "+o_Empresa:c_Filial+".")
						Return(.T.)
					Else
						::o_Retorno:l_Status		:= .F.
						::o_Retorno:c_Mensagem	:= "Titulo ja existe. Utilize a opcao 4= Alterar ou 5=Excluir."+CHR(13)+CHR(10)
						Conout("FFIEBW01 - mtdTitReceber: Titulo ja existe. Utilize a opcao 4= Alterar ou 5=Excluir.")
						Return(.T.)
					EndIf
				ElseIf (n_Operacao = 4)
					//Tratamento para gravar apenas a data da competencia quando o titulo ja estiver baixado
					If( SE1->E1_SALDO = 0 ) .Or. (SE1->E1_SALDO < SE1->E1_VALOR)
						If( SE1->E1_VENCTO <> STod(o_TitReceber:E1_VENCTO) )
							//NADA E DEIXA O EXECAUTO EXECUTAR. VAI RETORNAR ERRO. 
						ElseIf( SE1->E1_FSDTCOM <> STOD(o_TitReceber:E1_FSDTCOM) )
							DbSelectArea("SE1")
							RecLock("SE1",.F.)
							SE1->E1_FSDTCOM:= STOD(o_TitReceber:E1_FSDTCOM)
							MsUnLock()
							::o_Retorno:l_Status	:= .T.
							::o_Retorno:c_Mensagem	:= "Titulo de numero "+Alltrim(SE1->E1_NUM)+" ja estava baixado porem apenas a data da competencia foi alterada."
							Conout("FFIEBW01 - mtdTitReceber: Titulo de numero "+Alltrim(SE1->E1_NUM)+" ja estava baixado porem apenas a data da competencia foi alterada.")
							Return(.T.)
						ElseIf Alltrim(SE1->E1_PREFIXO) == "RM" .And. ( SE1->E1_VENCTO == STod(o_TitReceber:E1_VENCTO) ) .And.  ( SE1->E1_FSDTCOM == STOD(o_TitReceber:E1_FSDTCOM) )
							//Condicao adicionada em 22/09/2020 por Solicitacao de Rafael para tratar chamada de alteracao duplicada do rm no barramento - inicio
							::o_Retorno:l_Status	:= .T.
							::o_Retorno:c_Mensagem	:= "###Titulo de numero "+Alltrim(SE1->E1_NUM)+" ja alterado com sucesso na filial "+o_Empresa:c_Filial+"."
							Conout("FFIEBW01 - mtdTitReceber: ###Titulo de numero "+Alltrim(SE1->E1_NUM)+" ja alterado com sucesso na filial "+o_Empresa:c_Filial+".")
							Return(.T.)
							//Condicao adicionada em 22/09/2020 por Solicitacao de Rafael para tratar chamada de alteracao duplicada do rm no barramento - fim
						EndIf
					ElseIf Alltrim(SE1->E1_PREFIXO) == "RM" .And. ( SE1->E1_VENCTO == STod(o_TitReceber:E1_VENCTO) ) .And.  ( SE1->E1_FSDTCOM == STOD(o_TitReceber:E1_FSDTCOM) )
						//Condicao adicionada em 22/09/2020 por Solicitacao de Rafael para tratar chamada de alteracao duplicada do rm no barramento - inicio
						::o_Retorno:l_Status	:= .T.
						::o_Retorno:c_Mensagem	:= "###Titulo de numero "+Alltrim(SE1->E1_NUM)+" ja alterado com sucesso na filial "+o_Empresa:c_Filial+"."
						Conout("FFIEBW01 - mtdTitReceber: ###Titulo de numero "+Alltrim(SE1->E1_NUM)+" ja alterado com sucesso na filial "+o_Empresa:c_Filial+".")
						Return(.T.)
						//Condicao adicionada em 22/09/2020 por Solicitacao de Rafael para tratar chamada de alteracao duplicada do rm no barramento - fim
					ElseIf Alltrim(SE1->E1_PREFIXO) == "RM" .And. ( SE1->E1_VENCTO == STod(o_TitReceber:E1_VENCTO) ) .And.  ( SE1->E1_FSDTCOM <> STOD(o_TitReceber:E1_FSDTCOM) )
						//Nova Condicao adicionada em 30/11/2020 por Solicitacao de Rafael para tratar chamada de alteracao de data de competencia do rm no barramento - inicio
						DbSelectArea("SE1")
						RecLock("SE1",.F.)
						SE1->E1_FSDTCOM:= STOD(o_TitReceber:E1_FSDTCOM)
						MsUnLock()
						::o_Retorno:l_Status	:= .T.
						::o_Retorno:c_Mensagem	:= "Titulo de numero "+Alltrim(SE1->E1_NUM)+" em aberto porem apenas a data da competencia foi alterada."
						Conout("FFIEBW01 - mtdTitReceber: Titulo de numero "+Alltrim(SE1->E1_NUM)+" em aberto porem apenas a data da competencia foi alterada.")
						Return(.T.)
						//Nova Condicao adicionada em 30/11/2020 por Solicitacao de Rafael para tratar chamada de alteracao de data de competencia do rm no barramento - fim
					EndIf
				EndIf
			Else
				If (n_Operacao = 4)
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Titulo nao existe. Utilize a opcao 3=Incluir."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdTitReceber: Titulo nao existe. Utilize a opcao 3=Incluir.")
					Return(.T.)
				ElseIf(n_Operacao = 5)
					::o_Retorno:l_Status	:= .T.
					::o_Retorno:c_Mensagem	:= "###Titulo de numero "+Alltrim(c_Num)+" ja excluido com sucesso na filial "+o_Empresa:c_Filial+"."
					Conout("FFIEBW01 - mtdTitReceber: ###Titulo de numero "+Alltrim(c_Num)+" ja excluido com sucesso na filial "+o_Empresa:c_Filial+".")
					Return(.T.)
				EndIf
			EndIf

			//Valida a natureza
			dbSelectArea("SED")
			dbSetOrder(1)
			If !(dbSeek(xfilial("SED")+Alltrim(o_TitReceber:E1_NATUREZ)))
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Natureza "+Alltrim(o_TitReceber:E1_NATUREZ)+" nao encontrada na base de dados do protheus."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdTitReceber: Natureza "+Alltrim(o_TitReceber:E1_NATUREZ)+" nao encontrada na base de dados do protheus.")
				Return(.T.)
			Else
				c_Natureza	:= SED->ED_CODIGO
			EndIf
			
			//Valida a amarracao entre Prefixo x Tipo x Natureza
			If 	!o_Fieb:mtdVldNatImplant(c_Pre, c_Tip, Alltrim(o_TitReceber:E1_NATUREZ), "2" )
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Amarracao dessa Serie/Prefixo (" + Alltrim( c_Pre ) + ") com Tipo (" + Alltrim( c_Tip ) + ") e Natureza (" + Alltrim( o_TitReceber:E1_NATUREZ ) + ") nao encontrada na base de dados do protheus."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdTitReceber: Amarracao dessa Serie/Prefixo (" + Alltrim( c_Pre ) + ") com Tipo (" + Alltrim( c_Tip ) + ") e Natureza (" + Alltrim( o_TitReceber:E1_NATUREZ ) + ") nao encontrada na base de dados do protheus.")
				Return(.T.)
			Endif


			If !Empty(o_TitReceber:E1_CONTA)
				//Validando a conta contabil
				DBSELECTAREA("CT1")
				DBSETORDER(1)
				IF !DBSEEK(xFilial("CT1")+Alltrim(o_TitReceber:E1_CONTA))
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_TitReceber:E1_CONTA)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+"."
					Conout("FFIEBW01 - mtdTitReceber: Codigo da conta contabil ("+Alltrim(o_TitReceber:E1_CONTA)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+".")
					Return(.T.)
				ElseIf CT1->CT1_CLASSE == "1"
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_TitReceber:E1_CONTA)+") nao pode ser sintetica."
					Conout("FFIEBW01 - mtdTitReceber: Codigo da conta contabil ("+Alltrim(o_TitReceber:E1_CONTA)+") nao pode ser sintetica.")
					Return(.T.)
				ElseIf CT1->CT1_BLOQ == "1"
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_TitReceber:E1_CONTA)+") esta bloqueada para uso."
					Conout("FFIEBW01 - mtdTitReceber: Codigo da conta contabil ("+Alltrim(o_TitReceber:E1_CONTA)+")  esta bloqueada para uso.")
					Return(.T.)
				EndIf
			EndIf

			If !Empty(o_TitReceber:E1_CCC)
				//Validando o centro de custo
				DbSelectArea("CTT")
				CTT->(dbSetOrder(1))
				If !(CTT->(dbSeek(xFilial("CTT")+Alltrim(o_TitReceber:E1_CCC))))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Centro de Custo informado para o campo E1_CCC invalido ("+Alltrim(o_TitReceber:E1_CCC)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdTitReceber: Centro de Custo informado para o campo E1_CCC invalido ("+Alltrim(o_TitReceber:E1_CCC)+").")
					Return(.T.)
				Elseif CTT->CTT_CLASSE == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Centro de Custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_TitReceber:E1_CCC)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdTitReceber: Centro de Custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_TitReceber:E1_CCC)+").")
					Return(.T.)
				Elseif CTT->CTT_BLOQ == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Centro de Custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_TitReceber:E1_CCC)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdTitReceber: Centro de Custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_TitReceber:E1_CCC)+").")
					Return(.T.)
				Endif
			EndIf

			//Validando o item contabil
			If !Empty(o_TitReceber:E1_ITEMC )
				DbSelectArea("CTD")
				CTD->(dbSetOrder(1))
				If !(CTD->(dbSeek(xFilial("CTD")+Alltrim(o_TitReceber:E1_ITEMC))))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil informado para o campo E1_ITEMC invalido ("+Alltrim(o_TitReceber:E1_ITEMC)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdTitReceber: Item contabil informado para o campo E1_ITEMC invalido ("+Alltrim(o_TitReceber:E1_ITEMC)+").")
					Return(.T.)
				Elseif CTD->CTD_CLASSE == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_TitReceber:E1_ITEMC)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdTitReceber: Item contabil invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_TitReceber:E1_ITEMC)+").")
					Return(.T.)
				Elseif CTD->CTD_BLOQ == "1" .or. (!Empty(CTD->CTD_DTEXSF) .and. CTD->CTD_DTEXSF < dDatabase)
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_TitReceber:E1_ITEMC)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdTitReceber: Item contabil invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_TitReceber:E1_ITEMC)+").")
					Return(.T.)
				ElseIf (!Empty(CTD->CTD_DTEXIS) .and. dDatabase < CTD->CTD_DTEXIS)
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil ("+Alltrim(o_TitReceber:E1_ITEMC)+") esta com data de inicio de existencia superior a data base."+CHR(13)+CHR(10)
					Return(.T.)
				Endif
			EndIf

			If !Empty(o_TitReceber:E1_CLVLCR)
				//Validando a classe de valor
				DbSelectArea("CTH")
				CTH->(dbSetOrder(1))
				If !(CTH->(dbSeek(xFilial("CTH")+Alltrim(o_TitReceber:E1_CLVLCR))))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Classe de valor informado para o campo E1_CLVLCR invalido ("+Alltrim(o_TitReceber:E1_CLVLCR)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdTitReceber: Classe de valor informado para o campo E1_CLVLCR invalido ("+Alltrim(o_TitReceber:E1_CLVLCR)+").")
					Return(.T.)
				Elseif CTH->CTH_CLASSE == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Classe de valor invalido. O Classe de valor nao pode ser sintetico ("+Alltrim(o_TitReceber:E1_CLVLCR)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdTitReceber: Classe de valor invalido. O Classe de valor nao pode ser sintetico ("+Alltrim(o_TitReceber:E1_CLVLCR)+").")
					Return(.T.)
				Elseif CTH->CTH_BLOQ == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Classe de valor invalido. o Classe de valor esta bloqueado para uso ("+Alltrim(o_TitReceber:E1_CLVLCR)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdTitReceber: Classe de valor invalido. o Classe de valor esta bloqueado para uso ("+Alltrim(o_TitReceber:E1_CLVLCR)+").")
					Return(.T.)
				Endif
			EndIf

			If (o_TitReceber:E1_MULTA < 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "O valor da multa nao pode ser menor do que zero."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdTitReceber: O valor da multa nao pode ser menor do que zero.")
				Return(.T.)
			EndIf

			If (o_TitReceber:E1_JUROS < 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "O valor de juros nao pode ser menor do que zero."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdTitReceber: O valor de juros nao pode ser menor do que zero.")
				Return(.T.)
			EndIf

			If (o_TitReceber:E1_DESCONT < 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "O valor de desconto nao pode ser menor do que zero."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdTitReceber: O valor de desconto nao pode ser menor do que zero.")
				Return(.T.)
			EndIf

			//Valida se a conta comeca com 3 OU 4 e obriga o UO (E1_CCC) e CR (E1_ITEMC)
			If (Substr( Alltrim(o_TitReceber:E1_CONTA),1,1 ) $ '3,4') .And. Empty(Alltrim(o_TitReceber:E1_ITEMC))
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Para contas que comecam com 3 ou 4 ("+Alltrim(o_TitReceber:E1_CONTA)+") o CR devem ser preenchidos."
				Conout("FFIEBW01 - mtdTitReceber: Para contas que comecam com 3 ou 4 ("+Alltrim(o_TitReceber:E1_CONTA)+") o CR devem ser preenchidos.")
				Return(.T.)
			Else
				//Verifica se existe amarracao Filial + CR + UO - 11/09/2018
				If !(Empty(Alltrim(o_TitReceber:E1_ITEMC)))
					If !(VerAmarrCTA(Alltrim(o_Empresa:c_Filial), "", Alltrim(o_TitReceber:E1_ITEMC))) //No contas a receber o CCC nao vem , apenas o ITEMC
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "Nao existe amarracao (Tabela CTA) entre Filial: ("+Alltrim(o_Empresa:c_Filial)+"), CR: ("+Alltrim(o_TitReceber:E1_ITEMC)+")."
						Conout("FFIEBW01 - mtdTitReceber: Nao existe amarracao (Tabela CTA) entre Filial: ("+Alltrim(o_Empresa:c_Filial)+"), CR: ("+Alltrim(o_TitReceber:E1_ITEMC)+").")
						Return(.T.)
					Else
						//Busca o E1_CCC
						If FindFunction("u_ONECTA2()")
							c_CCGatilho := u_ONECTA2(1,Padr(Alltrim(o_TitReceber:E1_ITEMC),TamSx3("E1_ITEMC")[1]))
						EndIf
						If Empty(c_CCGatilho)
							::o_Retorno:l_Status	:= .F.
							::o_Retorno:c_Mensagem	:= "A funcao u_ONECTA2() nao retornou o CR para o E1_ITEMC: "+Alltrim(o_TitReceber:E1_ITEMC)
							Return(.T.)
						EndIf
					EndIf
					//Valida se a conta comeca com 32 e o Cr possui o campo CTD_XRTADM = 2=Consumo;3=Corporativo;4=Unid. Compartilhadas 11/02/2019
					c_ErrMsg:= ""
					If !( f_VldCnInvest( Alltrim( o_TitReceber:E1_CONTA ), Alltrim( o_TitReceber:E1_ITEMC ), @c_ErrMsg ) )
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= c_ErrMsg
						Conout("FFIEBW01 - mtdTitReceber: "+c_ErrMsg)
						Return(.T.)
					EndIf
				EndIf
			EndIf

			//Valida o array do rateio
			If Len(o_TitReceber:NATRATEIO) > 0
				If !Empty(o_TitReceber:NATRATEIO[1]:EV_NATUREZ) .And. (o_TitReceber:NATRATEIO[1]:EV_VALOR > 0)
					c_MsgVldRat	:= ""
					If !f_VldRateio("R", o_Empresa:c_Filial, @c_MsgVldRat)
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= c_MsgVldRat
						Conout("FFIEBW01 - mtdTitReceber: "+c_MsgVldRat)
						Return(.T.)//Sai da rotina
					EndIf
				EndIf
			EndIf
			d_TesteData	:=	StoD(o_TitReceber:E1_EMISSAO)
			If valtype(d_TesteData) == "D"
				If Empty(d_TesteData)
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Informe Data de emissao no formato [AAAAMMDD]."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdTitReceber: Informe Data de emissao no formato [AAAAMMDD].")
					Return(.T.)
				EndIf
			Else
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe Data de emissao no formato [AAAAMMDD]."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdTitReceber: Informe Data de emissao no formato [AAAAMMDD].")
				Return(.T.)
			EndIf
			d_TesteData	:=	StoD(o_TitReceber:E1_VENCTO)
			If valtype(d_TesteData) == "D"
				If Empty(d_TesteData)
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Informe Data de vencimento no formato [AAAAMMDD]."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdTitReceber: Informe Data de vencimento no formato [AAAAMMDD].")
					Return(.T.)
				EndIf
			Else
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe Data de vencimento no formato [AAAAMMDD]."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdTitReceber: Informe Data de vencimento no formato [AAAAMMDD].")
				Return(.T.)
			EndIf
			If (n_Operacao = 3)
				//Valida se o periodo esta bloqueado.
				c_Err:= ""
				d_TesteData	:=	StoD(o_TitReceber:E1_EMISSAO)
				If !( f_VldDtMov( "FIN", d_TesteData, @c_Err, "R" ) )
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= c_Err
					Conout("FFIEBW01 - mtdTitReceber: "+c_Err)
					Return(.T.)
				EndIf
			EndIf
			//Tratamento para a data de vencimento real
			d_VencRea	:= DataValida(STOD(o_TitReceber:E1_VENCTO),.T.)
			n_Valor		:= o_TitReceber:E1_VALOR

			aAdd( aVetor, { "E1_PREFIXO"	,PADR(Alltrim(o_TitReceber:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1]),Nil})
			aAdd( aVetor, { "E1_NUM"		,PADR(Alltrim(o_TitReceber:E1_NUM), TAMSX3("E1_NUM")[1])		,Nil})
			aAdd( aVetor, { "E1_PARCELA"	,PADR(Alltrim(o_TitReceber:E1_PARCELA), TAMSX3("E1_PARCELA")[1]),Nil})
			aAdd( aVetor, { "E1_TIPO"		,PADR(c_Tipo, TAMSX3("E1_TIPO")[1])  		,Nil})
			aAdd( aVetor, { "E1_CLIENTE"	,PADR(c_Cliente, TAMSX3("E1_CLIENTE")[1])	,Nil})
			aAdd( aVetor, { "E1_LOJA"		,PADR(c_Loja, TAMSX3("E1_LOJA")[1])			,Nil})
			aAdd( aVetor, { "E1_NATUREZ"	,PADR(c_Natureza, TAMSX3("E1_NATUREZ")[1])	,Nil})
			aAdd( aVetor, { "E1_EMISSAO"	,STOD(o_TitReceber:E1_EMISSAO)				,Nil})
			aAdd( aVetor, { "E1_VENCTO"		,STOD(o_TitReceber:E1_VENCTO)				,Nil})
			aAdd( aVetor, { "E1_VENCREA"	,d_VencRea									,Nil})
			If (n_Operacao <> 4)
				aAdd( aVetor, { "E1_VALOR"		,n_Valor									,Nil})
			EndIf
			aAdd( aVetor, { "E1_HIST"		,PADR(Alltrim(o_TitReceber:E1_HIST), TAMSX3("E1_HIST")[1])		,Nil})
			//12/09/2019 - So grava esse campo se tiver preenchido a conta, pois o gatilho da natureza ja preenche o E1_CREDIT
			If( !Empty( Alltrim( o_TitReceber:E1_CONTA ) ) )
				aAdd( aVetor, { "E1_CREDIT"		,PADR(Alltrim(o_TitReceber:E1_CONTA), TAMSX3("E1_CREDIT")[1])	,Nil})
			EndIf
			aAdd( aVetor, { "E1_ITEMC"		,PADR(Alltrim(o_TitReceber:E1_ITEMC), TAMSX3("E1_ITEMC")[1])	,Nil})
			aAdd( aVetor, { "E1_CCC"		,PADR(c_CCGatilho, TAMSX3("E1_CCC")[1])		,Nil})
			aAdd( aVetor, { "E1_CLVLCR"		,PADR(Alltrim(o_TitReceber:E1_CLVLCR), TAMSX3("E1_CLVLCR")[1])	,Nil})
			aAdd( aVetor, { "E1_HIST"		,PADR(Alltrim(o_TitReceber:E1_HIST), TAMSX3("E1_HIST")[1])		,Nil})
			aAdd( aVetor, { "E1_MULTA"		,o_TitReceber:E1_MULTA						,Nil})
			aAdd( aVetor, { "E1_JUROS"		,o_TitReceber:E1_JUROS						,Nil})
			aAdd( aVetor, { "E1_DESCONT"	,o_TitReceber:E1_DESCONT					,Nil})
			aAdd( aVetor, { "E1_DESCONT"	,o_TitReceber:E1_DESCONT					,Nil})
			aAdd( aVetor, { "E1_LA"			,Alltrim(o_TitReceber:E1_LA)				,Nil})
			aAdd( aVetor, { "E1_XTITEMS"	,PADR(Alltrim(o_TitReceber:E1_XTITEMS), TAMSX3("E1_XTITEMS")[1]),Nil})
			
			//21/08/2019 - Gravar o codigo de autorizacao solicitado por Bruno
			If( !Empty( Alltrim(o_TitReceber:E1_FSCODAU) ) )
				aAdd( aVetor, { "E1_FSCODAU",Alltrim(o_TitReceber:E1_FSCODAU)			,Nil})
			EndIf
			
			//26/05/2020 - Gravar a competencia do RM 
			If( !Empty( Alltrim(o_TitReceber:E1_FSDTCOM) ) )
				aAdd( aVetor, { "E1_FSDTCOM",STOD(o_TitReceber:E1_FSDTCOM)				,Nil})
			EndIf
			
			If Alltrim(c_Tipo) == "RA"
				c_Ban:= Padr(o_TitReceber:RABANCO,TamSX3("E5_BANCO")[1])
				c_Age:= Padr(o_TitReceber:RAAGENC,TamSX3("E5_AGENCIA")[1])
				c_Con:= Padr(o_TitReceber:RACONTA,TamSX3("E5_CONTA")[1])

				DBSELECTAREA("SA6")
				DBSETORDER(1)
				If !DBSEEK(xFilial("SA6")+c_Ban+c_Age+c_Con)
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Para o tipo RA o banco/agencia/conta devem ser informados: "+c_Ban+"/"+c_Age+"/"+c_Con+". Portanto os dados informados nao foram encontrados para a filial logada."
					Conout("FFIEBW01 - mtdTitReceber: Para o tipo RA o banco/agencia/conta devem ser informados: "+c_Ban+"/"+c_Age+"/"+c_Con+". Portanto os dados informados nao foram encontrados para a filial logada.")
					Return(.T.)
				EndIf

				aAdd( aVetor, { "CBCOAUTO"		,Alltrim(o_TitReceber:RABANCO)				,Nil})
				aAdd( aVetor, { "CAGEAUTO"		,Alltrim(o_TitReceber:RAAGENC)				,Nil})
				aAdd( aVetor, { "CCTAAUTO"		,Alltrim(o_TitReceber:RACONTA)				,Nil})
			EndIf

			lMsErroAuto		:= .F.
			lMsHelpAuto		:= .T.
			lAutoErrNoFile	:= .T.

			c_PreBx:= PADR(Alltrim(o_TitReceber:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1])
			c_NumBx:= PADR(Alltrim(o_TitReceber:E1_NUM), TAMSX3("E1_NUM")[1])
			c_ParBx:= PADR(Alltrim(o_TitReceber:E1_PARCELA), TAMSX3("E1_PARCELA")[1])
			c_TipBx:= PADR(Alltrim(o_TitReceber:E1_TIPO), TAMSX3("E1_TIPO")[1])

			If (Alltrim(c_PreBx) == 'RM') .And. (n_Operacao = 5)
				DBSELECTAREA("SE1")
				DBSETORDER(1)
				If (DBSEEK(XFILIAL("SE1")+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_Cliente+c_Loja))
					If (SE1->E1_LA = 'S')
						RecLock("SE1",.F.)
						SE1->E1_LA:= 'N'
						MsUnLock()
					EndIf
				EndIf
				
				//Se for RA muda a data para gravar o E5 com a data passada quando for cancelamento. ITEM 10
				If Alltrim(c_Tipo) == "RA"
					d_TesteData	:=	StoD(o_TitReceber:DTCAN)
					If valtype(d_TesteData) == "D"
						If Empty(d_TesteData)
							::o_Retorno:l_Status		:= .F.
							::o_Retorno:c_Mensagem	:= "Informe Data de cancelamento do RA no formato [AAAAMMDD]."+CHR(13)+CHR(10)
							Conout("FFIEBW01 - mtdTitReceber: Informe Data de cancelamento do RA no formato [AAAAMMDD].")
							Return(.T.)
						Else
							DDATABASE:= Stod(o_TitReceber:DTCAN)
						EndIf					
					EndIf
				EndIf//Fim do ITEM 10
				
			EndIf
			//ITEM 14
			If (Alltrim(c_PreBx) == 'RM') .And. (n_Operacao = 3)
				If Alltrim(c_Tipo) == "RA"
					If Empty( Alltrim(o_TitReceber:E5_XNUMRM) )
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "Para titulo do tipo RA, o numero do RM deve ser informado."
						Conout("FFIEBW01 - mtdTitReceber: Para titulo do tipo RA, o numero do RM deve ser informado.")
						Return(.T.)
					EndIf
				EndIf
			EndIf
			//Fim do ITEM 14
			l_TemEvEz:= .F.
			If Len(o_TitReceber:NATRATEIO) > 0
				If !Empty(o_TitReceber:NATRATEIO[1]:EV_NATUREZ) .And. (o_TitReceber:NATRATEIO[1]:EV_VALOR > 0)
					aRatEvEz:= {}
					aRatEvEz:= f_MntRateio( o_TitReceber:NATRATEIO )
					l_TemEvEz:= .T.
					aAdd( aVetor, { "E1_MULTNAT","1",Nil})
				EndIf
			EndIf	
			l_RollBack := .F.	
			Begin Transaction

				//Implementando alteração de database - ativando - inicio
				d_BkDtBase	:=	dDatabase
				dDatabase	:=	StoD(o_TitReceber:E1_EMISSAO) 
				//Implementando alteração de database - ativando - fim

				If( l_TemEvEz )
					MsExecAuto( { |x,y,z,a| FINA040(x,y,z,a)} , aVetor, 3,,aRatEvEz)
				Else
					MSExecAuto({|x,y| Fina040(x,y)},aVetor,n_Operacao) //3- Inclusao, 4- Alteracao, 5- Exclusao
				EndIf
				If lMsErroAuto
					DisarmTransaction()
					l_RollBack	:=	.T.
					//Break //desabilitado para atender a requisito de desabilitacao de alteracao de database
				Else
					If (n_Operacao = 3)
						If !(Empty(o_TitReceber:E1_XCONTR))
							DbSelectArea("SE1")
							RecLock("SE1",.F.)
							SE1->E1_XCONTR:= Alltrim(o_TitReceber:E1_XCONTR)
							//SE1->E1_XCONTR:= Alltrim(o_TitReceber:E1_XCONTR)
							MsUnLock()
						EndIf
						/*If Len(o_TitReceber:NATRATEIO) > 0
							If !Empty(o_TitReceber:NATRATEIO[1]:EV_NATUREZ) .And. (o_TitReceber:NATRATEIO[1]:EV_VALOR > 0)
								f_GravaEVEZ(c_Cliente, c_Loja, c_Tipo, "R", Alltrim(o_TitReceber:E1_PREFIXO), Alltrim(o_TitReceber:E1_NUM), Alltrim(o_TitReceber:E1_PARCELA), "", 0, SE1->E1_VALOR)
								DbSelectArea("SE1")
								RecLock("SE1",.F.)
								SE1->E1_MULTNAT:= '1'
								MsUnLock()
							EndIf
						EndIf*/
						//30-01-19 -> Solicitado por Paula que a data para contabilizacao fosse igual a data da emissao
						dbSelectArea("SE1")
						RecLock("SE1",.F.)
						SE1->E1_EMIS1	:= STOD( o_TitReceber:E1_EMISSAO )
						SE1->E1_FSTPOD	:= Alltrim( o_TitReceber:OD_TIPO )
						MsUnlock()

						//Desenvolvido por: Francisco Rezende
						//Em: 17/07/2019
						//Solicitado por: Micheline
						//Motivo: Gravar os dados bancarios de originados do OD
						c_Motivo	:= ""
						If SE1->E1_PREFIXO == "ODE"

							U_FINA026O()
							l_GravE2:= .F.
							If( Empty( o_TitReceber:OD_TIPO ) )
								l_GravE2:= .F.
							ElseIf( Alltrim( o_TitReceber:OD_TIPO ) = '1' )
								l_GravE2:= .T.
							ElseIf ( Alltrim( c_Cliente ) <> Alltrim( SuperGetMV("FS_ODCLIEN",,"03795086") ) ) //Nesse caso o tipo e 2
								l_GravE2:= .T.
							EndIf
							
							If ( l_GravE2 )
								
								//Fornecedor do titulo de OD
								dbSelectArea("SA2")
								dbSetOrder(3)
								dbSeek( xFilial("SA2") + Alltrim(c_CgcFil) )	
								
								dbSelectArea("SE1")
								RecLock("SE1",.F.)
								SE1->E1_FSPAI	:= c_FilTitOd + SA2->A2_COD + SA2->A2_LOJA
								MsUnlock()
								
								//GRAVA CONTAS A PAGAR
								c_FilBkp		:= SM0->M0_CODFIL	
								dbSelectArea("SM0")
								dbSeek( o_Empresa:c_Empresa + c_FilTitOd )
								cFilAnt:= c_FilTitOd
								
								If( Alltrim( o_TitReceber:OD_TIPO ) = '1' )
									c_NatFor 	:= SuperGetMV("FS_ODNATSB",,"31010302")
								Else
									c_NatFor 	:= SuperGetMV("FS_ODNATDF",,"13129904")
								EndIf
								d_VencRea	:= DataValida(STOD(o_TitReceber:E1_VENCTO),.T.)
								
								If( Substr(Alltrim(cFilAnt),1,2) = '01' )
									c_CR	:= SuperGetMV("FS_ODCRCP",,"40101010010004")
									a_Banco	:= &( SuperGetMV("FS_ODBCOCP",,'{"104","3351","1384-8"}') )
								ElseIf( Substr(Alltrim(cFilAnt),1,2) = '02' )
									c_CR	:= SuperGetMV("FS_ODCRCP",,"40101010010004")
									a_Banco	:= &( SuperGetMV("FS_ODBCOCP",,'{"104","3351","1386-4"}') )
								ElseIf( Substr(Alltrim(cFilAnt),1,2) = '03' )
									c_CR	:= SuperGetMV("FS_ODCRCP",,"40101010010005")
									a_Banco	:= &( SuperGetMV("FS_ODBCOCP",,'{"104","3351","1385-6"}') )
								ElseIf( Substr(Alltrim(cFilAnt),1,2) = '04' )
									c_CR	:= SuperGetMV("FS_ODCRCP",,"40101010010004")
									a_Banco	:= &( SuperGetMV("FS_ODBCOCP",,'{"104","3351","1390-2"}') )
								Else
									c_CR	:= SuperGetMV("FS_ODCRCP",,"4010101003")
									a_Banco	:= &( SuperGetMV("FS_ODBCOCP",,'{"104","3351","1397-0"}') )
								EndIf
								c_MsgRet	:= ""

								//Busca o E1_CCC
								If FindFunction("u_ONECTA2()")
									c_CCGatilho := u_ONECTA2( 1, c_CR )
								EndIf

								aVetor 		:= {}
								lMsErroAuto	:= .F.
								
								//Fornecedor do titulo de OD
								dbSelectArea("SA2")
								dbSetOrder(3)
								dbSeek( xFilial("SA2") + Alltrim(c_CgcFil) )								
								
								aAdd( aVetor, { "E2_PREFIXO"	,PADR( Alltrim( o_TitReceber:E1_PREFIXO )	, TAMSX3("E2_PREFIXO")[1])	,Nil})
								aAdd( aVetor, { "E2_NUM"		,PADR( Alltrim( o_TitReceber:E1_NUM )		, TAMSX3("E2_NUM")[1])		,Nil})
								aAdd( aVetor, { "E2_PARCELA"	,PADR( Alltrim( o_TitReceber:E1_PARCELA )	, TAMSX3("E2_PARCELA")[1])	,Nil})
								aAdd( aVetor, { "E2_TIPO"		,PADR( Alltrim( o_TitReceber:E1_TIPO )		, TAMSX3("E2_TIPO")[1])  	,Nil})
								aAdd( aVetor, { "E2_FORNECE"	,PADR( SA2->A2_COD							, TAMSX3("E2_FORNECE")[1])	,Nil})
								aAdd( aVetor, { "E2_LOJA"		,PADR( SA2->A2_LOJA							, TAMSX3("E2_LOJA")[1])		,Nil})
								aAdd( aVetor, { "E2_NATUREZ"	,PADR( c_NatFor								, TAMSX3("E2_NATUREZ")[1])	,Nil})
								aAdd( aVetor, { "E2_EMISSAO"	,STOD( o_TitReceber:E1_EMISSAO )										,Nil})
								aAdd( aVetor, { "E2_VENCTO"		,STOD( o_TitReceber:E1_VENCTO )											,Nil})
								aAdd( aVetor, { "E2_VENCREA"	,d_VencRea																,Nil})
								aAdd( aVetor, { "E2_VALOR"		,n_Valor																,Nil})
								aAdd( aVetor, { "E2_HIST"		,PADR( Alltrim( o_TitReceber:E1_HIST )		, TAMSX3("E2_HIST")[1])		,Nil})
								aAdd( aVetor, { "E2_XHIST"		,PADR( Alltrim( o_TitReceber:E1_HIST )		, TAMSX3("E2_XHIST")[1])	,Nil})
								aAdd( aVetor, { "E2_LA"			,Alltrim( o_TitReceber:E1_LA)											,Nil})
								aAdd( aVetor, { "E2_ITEMD"		,PADR( c_CR									, TAMSX3("E2_ITEMD")[1])	,Nil})
								aAdd( aVetor, { "E2_CCD"		,PADR( c_CCGatilho							, TAMSX3("E2_CCD")[1])		,Nil})
								aAdd( aVetor, { "E2_CLVLDB"		,PADR( Alltrim( o_TitReceber:E1_CLVLCR)		, TAMSX3("E1_CLVLDB")[1])	,Nil})
								aAdd( aVetor, { "E2_ZBANCO"		,PADR( a_Banco[1]							, TAMSX3("E2_ZBANCO")[1])	,Nil})
								aAdd( aVetor, { "E2_ZAGENCI" 	,PADR( a_Banco[2]							, TAMSX3("E2_ZAGENCI")[1])	,Nil})
								aAdd( aVetor, { "E2_ZCONTA"		,PADR( a_Banco[3]							, TAMSX3("E2_ZCONTA")[1])	,Nil})
								aAdd( aVetor, { "E2_XMODELO"	,PADR( "01"									, TAMSX3("E2_XMODELO")[1])	,Nil})
								aAdd( aVetor, { "E2_FSCONTR"	,o_TitReceber:E1_XCONTR													,Nil})
								aAdd( aVetor, { "E2_FSPAI"		,c_FilBkp + c_Cliente + c_Loja											,Nil})
								
								MsExecAuto({|x,y,z| FINA050(x,y,z)}, aVetor,, 3) // 3 - Inclusao, 4 - Alteracao, 5 - Exclusao
								If lMsErroAuto
									DisarmTransaction()
									//Break //desabilitando para atender a requisito de desabilitacao de alteracao de database
								Else
									c_Motivo	:= "Titulo a Pagar referente ao subsidio gravado com sucesso!!!"
								EndIf
								dbSelectArea("SM0")
								dbSeek( o_Empresa:c_Empresa + c_FilBkp )
								cFilAnt:= c_FilBkp
							EndIf	
							
						EndIf

						If (__lSX8)
							ConfirmSX8()
						EndIf
					Endif
					//21/09/2020 - Retirando - inicio
						//::o_Retorno:l_Status	:= 	.T.
						//::o_Retorno:c_Mensagem	:=  "Titulo de numero "+Alltrim(SE1->E1_NUM)+" incluido com sucesso na filial "+o_Empresa:c_Filial+". "+ c_Motivo //Comentado 25/09
						//Conout("FFIEBW01 - mtdTitReceber: Titulo de numero "+Alltrim(SE1->E1_NUM)+" incluido com sucesso "+o_Empresa:c_Filial+". "+ c_Motivo ) //Comentado 25/09
					//ElseIf (n_Operacao = 4)
					//	::o_Retorno:l_Status	:= .T.
					//	::o_Retorno:c_Mensagem	:= "Titulo de numero "+Alltrim(SE1->E1_NUM)+" alterado com sucesso "+o_Empresa:c_Filial+"."
					//	Conout("FFIEBW01 - mtdTitReceber: Titulo de numero "+Alltrim(SE1->E1_NUM)+" alterado com sucesso "+o_Empresa:c_Filial+".")
					//Else
					//	::o_Retorno:l_Status	:= .T.
					//	::o_Retorno:c_Mensagem	:= "Titulo de numero "+Alltrim(SE1->E1_NUM)+" excluido com sucesso "+o_Empresa:c_Filial+"."
					//	Conout("FFIEBW01 - mtdTitReceber: Titulo de numero "+Alltrim(SE1->E1_NUM)+" excluido com sucesso "+o_Empresa:c_Filial+".")
					//EndIf
				//21/09/2020 - Retirando - Final
				Endif

				//Implementando alteração de database - desativando - inicio
				dDatabase	:=	d_BkDtBase
				//Implementando alteração de database - desativando - fim

			End Transaction
			
			If !lMsErroAuto .And. !l_RollBack
				If (n_Operacao == 3) //.And. (__lSX8)
					::o_Retorno:l_Status	:= 	.T.
					::o_Retorno:c_Mensagem	:=  "Titulo de numero "+Alltrim(SE1->E1_NUM)+" incluido com sucesso na filial "+o_Empresa:c_Filial+". "+ c_Motivo //Comentado 25/09
					Conout("FFIEBW01 - mtdTitReceber: Titulo de numero "+Alltrim(SE1->E1_NUM)+" incluido com sucesso "+o_Empresa:c_Filial+". "+ c_Motivo ) //Comentado 25/09
				ElseIf (n_Operacao == 4)
					::o_Retorno:l_Status	:= .T.
					::o_Retorno:c_Mensagem	:= "Titulo de numero "+Alltrim(SE1->E1_NUM)+" alterado com sucesso "+o_Empresa:c_Filial+"."
					Conout("FFIEBW01 - mtdTitReceber: Titulo de numero "+Alltrim(SE1->E1_NUM)+" alterado com sucesso "+o_Empresa:c_Filial+".")
				Else
					::o_Retorno:l_Status	:= .T.
					::o_Retorno:c_Mensagem	:= "Titulo de numero "+Alltrim(SE1->E1_NUM)+" excluido com sucesso "+o_Empresa:c_Filial+"."
					Conout("FFIEBW01 - mtdTitReceber: Titulo de numero "+Alltrim(SE1->E1_NUM)+" excluido com sucesso "+o_Empresa:c_Filial+".")
				EndIf
			Else
				If l_RollBack
					If (n_Operacao == 3) //.And. (__lSX8)
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "Titulo de numero "+Alltrim(o_TitReceber:E1_NUM)+" RollBack Executado na transacao de inclusao enviada. "+o_Empresa:c_Filial+"."
						Conout("FFIEBW01 - mtdTitReceber: Titulo de numero "+Alltrim(o_TitReceber:E1_NUM)+" RollBack Executado na transacao de inclusao enviada. "+o_Empresa:c_Filial+".")
					ElseIf (n_Operacao == 4)
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "Titulo de numero "+Alltrim(o_TitReceber:E1_NUM)+" RollBack Executado na transacao de alteracao enviada. "+o_Empresa:c_Filial+"."
						Conout("FFIEBW01 - mtdTitReceber: Titulo de numero "+Alltrim(o_TitReceber:E1_NUM)+" RollBack Executado na transacao de alteracao enviada. "+o_Empresa:c_Filial+".")
					Else
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "Titulo de numero "+Alltrim(o_TitReceber:E1_NUM)+" RollBack Executado na transacao de exclusao enviada. "+o_Empresa:c_Filial+"."
						Conout("FFIEBW01 - mtdTitReceber: Titulo de numero "+Alltrim(o_TitReceber:E1_NUM)+" RollBack Executado na transacao de exclusao enviada. "+o_Empresa:c_Filial+".")
					Endif
				Else
					If (n_Operacao == 3) //.And. (__lSX8)
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "Titulo de numero "+Alltrim(o_TitReceber:E1_NUM)+" MSExecauto nao executado e RollBack nao executado na transacao de inclusao enviada. "+o_Empresa:c_Filial+"."
						Conout("FFIEBW01 - mtdTitReceber: Titulo de numero "+Alltrim(o_TitReceber:E1_NUM)+" MSExecauto nao executado e RollBack nao executado na transacao de inclusao enviada. "+o_Empresa:c_Filial+".")
					ElseIf (n_Operacao == 4)
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "Titulo de numero "+Alltrim(o_TitReceber:E1_NUM)+" MSExecauto nao executado e RollBack nao executado na transacao de alteracao enviada. "+o_Empresa:c_Filial+"."
						Conout("FFIEBW01 - mtdTitReceber: Titulo de numero "+Alltrim(o_TitReceber:E1_NUM)+" MSExecauto nao executado e RollBack nao executado na transacao de alteracao enviada. "+o_Empresa:c_Filial+".")
					Else
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "Titulo de numero "+Alltrim(o_TitReceber:E1_NUM)+" MSExecauto nao executado e RollBack nao executado na transacao de exclusao enviada. "+o_Empresa:c_Filial+"."
						Conout("FFIEBW01 - mtdTitReceber: Titulo de numero "+Alltrim(o_TitReceber:E1_NUM)+" MSExecauto nao executado e RollBack nao executado na transacao de exclusao enviada. "+o_Empresa:c_Filial+".")
					Endif
				Endif
			Endif

			//Se deu erro no Execauto
			If lMsErroAuto
				//Regra do fonte SIESBA01 da FIEB
				If (__lSX8)
					RollBackSX8()
					Conout("FFIEBW01 - mtdTitReceber: Titulo de numero "+Alltrim(o_TitReceber:E1_NUM)+" RollBack Executado na transacao enviada. "+o_Empresa:c_Filial+".")					
				EndIf

				// Tratamento da Mensagem de erro do MSExecAuto
				aLogErr  := GetAutoGRLog()
				aLogErr2 := f_TrataErro(aLogErr)
				_cMotivo := ""

				For i := 1 to Len(aLogErr2)
					_cMotivo += aLogErr2[i]
				Next
				If Empty(_cMotivo)
					_cMotivo:= MostraErro("\TOTVSBA_LOG\","Titulo_receber.txt")
				EndIf
				//Exclusivo para a versao 12
				If (GetVersao(.F.) == "12")
					_cMotivo:=  NoAcentoESB(_cMotivo)
					SetSoapFault('Erro',_cMotivo)
				EndIf

				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= NoAcentoESB(_cMotivo)
				Conout("FFIEBW01 - mtdTitReceber: "+NoAcentoESB(_cMotivo))
			Else
				If(::o_Retorno:l_Status == .T.) .And. !l_RollBack
					//Verifica se realmente gravou o Titulo
					c_Pre:= PADR(Alltrim(o_TitReceber:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1])
					c_Num:= PADR(Alltrim(o_TitReceber:E1_NUM), TAMSX3("E1_NUM")[1])
					c_Par:= PADR(Alltrim(o_TitReceber:E1_PARCELA), TAMSX3("E1_PARCELA")[1])
					c_Tip:= PADR(Alltrim(o_TitReceber:E1_TIPO), TAMSX3("E1_TIPO")[1])

					If (n_Operacao = 3) //inclusao
						DBSELECTAREA("SE1")
						DBSETORDER(1)
						If (DBSEEK(XFILIAL("SE1")+c_Pre+c_Num+c_Par+c_Tip+c_Cliente+c_Loja))
							//Titulo gravado
							
							//Grava o E5_XNUMRM no RA - ITEM 14
							If( (Alltrim( c_Pre ) == 'RM') .And. Alltrim( c_Tip ) == "RA" )
								//Busca o recno do RA que eh gearado na inclusao
								c_Qry:= "SELECT max(R_E_C_N_O_) AS REC "+chr(13)+chr(10)
								c_Qry+= "FROM "+RETSQLNAME("SE5")+" (NOLOCK) "+chr(13)+chr(10)
								c_Qry+= "WHERE E5_FILIAL 	= '"+XFILIAL("SE5")+"' "+chr(13)+chr(10)
								c_Qry+= "AND D_E_L_E_T_ 	= '' "+chr(13)+chr(10)
								c_Qry+= "AND E5_RECPAG 		= 'R' AND E5_MOTBX = 'NOR' "+chr(13)+chr(10)
								c_Qry+= "AND E5_PREFIXO 	= '"+c_Pre+"' "+chr(13)+chr(10) 	//PREFIXO DO RA
								c_Qry+= "AND E5_NUMERO 		= '"+c_Num+"'"+chr(13)+chr(10)		//NUMERO DO RA
								c_Qry+= "AND E5_PARCELA 	= '"+c_Par+"' "+chr(13)+chr(10)		//PARCELA DO RA
								c_Qry+= "AND E5_TIPO 		= '"+c_Tip+"' "+chr(13)+chr(10)		//TIPO DO RA
								c_Qry+= "AND E5_CLIFOR 		= '"+c_Cliente+"' "+chr(13)+chr(10)	//CLIENTE DO RA
								c_Qry+= "AND E5_LOJA		= '"+c_Loja+"' "+chr(13)+chr(10)	//LOJA DO RA
								c_Qry+= "AND E5_DATA 		= '"+o_TitReceber:E1_EMISSAO+"' "+chr(13)+chr(10)
								TCQUERY c_Qry ALIAS QRY NEW
								dbSelectArea("QRY")
								If !(QRY->(Eof()))
									DbSelectArea("SE5")
									DbGoto(QRY->REC)
									//Garante que posicionou no registro do RA
									If (SE5->(Recno()) = QRY->REC)
										RecLock("SE5",.F.)
										SE5->E5_XNUMRM	:= PADR(Alltrim(o_TitReceber:E5_XNUMRM), TAMSX3("E5_XNUMRM")[1])
										MsUnLock()
									EndIf
								EndIf
								dbSelectArea("QRY")
								QRY->(dbCloseArea())
							EndIf //Fim do ITEM 14														
						Else
							::o_Retorno:l_Status		:= .F.
							::o_Retorno:c_Mensagem	:= "### TITRECEBER -Titulo "+c_Num+" na filial "+o_Empresa:c_Filial+" nao encontrado apos o processo de inclusao. Possivelmente ocorreu algum rollback na transacao. Necessario enviar a inclusao novamente. ###"+CHR(13)+CHR(10)
						EndIf
					ElseIf (n_Operacao = 5) //Exclusao
						DBSELECTAREA("SE1")
						DBSETORDER(1)
						If (DBSEEK(XFILIAL("SE1")+c_Pre+c_Num+c_Par+c_Tip+c_Cliente+c_Loja))
							::o_Retorno:l_Status		:= .F.
							::o_Retorno:c_Mensagem	:= "### TITRECEBER - Titulo "+c_Num+" na filial "+o_Empresa:c_Filial+" encontrado apos o processo de exclusao. Possivelmente ocorreu algum rollback na transacao. Necessario enviar a inclusao novamente. ###"+CHR(13)+CHR(10)
						Else
							//Titulo excluido
							//Grava no historico a chave do titulo do RA - ITEM 14 19/09/2019
							If( ( Alltrim( c_Pre ) == 'RM' ) .And. ( Alltrim( c_Tip ) == "RA" ) .And. ( !Empty( o_TitReceber:E5_XNUMRM ) ) )
								//Busca o recno do RA que eh gerado na inclusao
								c_Qry:= "SELECT R_E_C_N_O_ AS REC, E5_XNUMRM, E5_SITUACA, E5_TIPODOC, E5_MOTBX, E5_HISTOR, E5_KEY AS CHVTIT "+chr(13)+chr(10)
								c_Qry+= "FROM "+RETSQLNAME("SE5")+" (NOLOCK) "+chr(13)+chr(10)
								c_Qry+= "WHERE E5_FILIAL 	= '"+XFILIAL("SE5")+"' "+chr(13)+chr(10)
								c_Qry+= "AND D_E_L_E_T_ 	= '' "+chr(13)+chr(10)
								c_Qry+= "AND E5_XNUMRM 		= '"+Alltrim( o_TitReceber:E5_XNUMRM )+"' "+chr(13)+chr(10)
								c_Qry+= "AND E5_KEY 		= '"+c_Pre+c_Num+c_Par+c_Tip+c_Cliente+c_Loja+"'"+chr(13)+chr(10)
								TCQUERY c_Qry ALIAS QRY NEW
								dbSelectArea("QRY")
								While !(QRY->(Eof()))
									DbSelectArea("SE5")
									DbGoto(QRY->REC)
									//Garante que posicionou no registro do RA
									If (SE5->(Recno()) = QRY->REC)
										RecLock("SE5",.F.)
										If( Alltrim( QRY->E5_TIPODOC ) == 'RA' ) //Linha do RA na exclusao 											 											
											SE5->E5_HISTOR	:= "RA: "+ Alltrim( QRY->CHVTIT )
										Else
											//Nesse caso o historico fica 'Exclusao de Titulo' no padrao e o TIPODOC e ES.
										EndIf
										MsUnLock()
									EndIf
									dbSelectArea("QRY")
									QRY->( DbSkip() )
								EndDo
								dbSelectArea("QRY")
								QRY->(dbCloseArea())
							EndIf //Fim do ITEM 14
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	__cUserId:= ""
	cusuario:= ""
	//Volta a database
	DDATABASE:= d_DataBk
RETURN(.T.)
/*/{Protheus.doc} mtdTitPagar
metodo de titulos a pagar
@author Totvs-BA
@since 01/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSMETHOD mtdTitPagar WSRECEIVE o_Seguranca, o_Empresa, o_TitPagar, Operacao WSSEND o_Retorno WSSERVICE FFIEBW01

	Local c_Fornece		:= ""
	Local c_Loja		:= ""
	Local c_Tipo		:= ""
	Local c_Natureza	:= ""
	Local c_TemRatCC	:= ""
	Local n_Valor		:= 0
	Local n_PercNat		:= 0
	Local n_ValNat		:= 0
	Local n_ValCC		:= 0
	Local d_VencRea		:= CTOD("  /  /  ")
	Local a_RatNat		:= {}
	Local a_RatCC		:= {}
	Local a_RatEvEz		:= {}
	Local a_Rateio		:= {}
	Local aVetor		:= {}
	Local a_Itens 		:= {}
	Local i				:= 0
	Local x				:= 0
	Local d_DataBk		:= ""
	Local c_MsgVldRat	:= ""
	//Local _lRateio		:= .F.
	Local n_Operacao	:= Val(::Operacao)

	Local l_Contabiliza	:= .T.
	Local l_Aglutina	:= .F.
	Local l_Digita		:= .F.
	Local l_Juros		:= .F.
	Local l_Desconto	:= .F.
	Local l_Comissao	:= .F.

	Local nRecnoE2		:= 0
	Local a_RecSE2		:= {}
	Local a_RecPA		:= {}
	Local c_LogAdto		:= ""

	Local c_PrfAdto		:= ""
	Local c_NumAdto		:= ""
	Local c_ParAdto		:= ""
	Local c_TipAdto		:= ""
	//Local c_ForPA		:= ""
	//Local c_LojPA		:= ""
	Local o_Fieb		:= clsFieb():New()

	PRIVATE lMsErroAuto := .F.
	PRIVATE _aTotRat 	:= {}
	PRIVATE l_WebService:= .F.
	//Private cNature	 := ''

	::o_Retorno	:= WSCLASSNEW("strRetorno")

	ConOut("001 - Antes da validacao de empresas/filiais")

    If !(f_VldFilEmp(o_Empresa:c_Empresa,o_Empresa:c_Filial))
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Codigo de Empresa/Filial nao existe."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdTitpagar: Codigo de Empresa/Filial nao existe.")
		Return(.T.)
	EndIf

    ConOut("002 - Antes da abertura de empresas/filiais")
	//Loga na filial solicitada
	RpcSetType(3)
	RpcSetEnv(o_Empresa:c_Empresa,o_Empresa:c_Filial, "integracao", "fieb123")

	//Posiciona na empresa e filial passada
	dbSelectArea("SM0")
	dbSeek(o_Empresa:c_Empresa+o_Empresa:c_Filial)

	cFilAnt:= o_Empresa:c_Filial

	c_UserWS	:= Upper(ALLTRIM(SUPERGETMV("FS_FIUSRWS",,"totvs_fieb")))
	c_PswWS		:= Upper(ALLTRIM(SUPERGETMV("FS_FIPSWWS",,"totvs@123")))

	ConOut("003 - Antes da validacao de usuario e senha")
    //Validando o usuario e senha
	If ( Upper(o_Seguranca:c_Usuario) <> Upper(c_UserWS) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdTitPagar: Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido.")
		Return(.T.)
	ElseIf ( Upper(o_Seguranca:c_Senha) <> Upper(c_PswWS) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdTitPagar: Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida.")
		Return(.T.)
	ElseIf (n_Operacao < 3) .Or. (n_Operacao > 5)
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Valor passado no parametro Operacao ("+cValToChar(n_Operacao)+") invalido. Informar (3=Inclusao; 4=Alteracao; 5=Exclusao)."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdTitPagar: Valor passado no parametro Operacao ("+cValToChar(n_Operacao)+") invalido. Informar (3=Inclusao; 4=Alteracao; 5=Exclusao).")
		Return(.T.)
	Else
		If Empty(o_TitPagar:E2_NUM)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe o numero do titulo."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdTitPagar: Informe o numero do titulo.")
			Return(.T.)
		ElseIf Empty(o_TitPagar:E2_TIPO)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe o tipo do titulo."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdTitPagar: Informe o tipo do titulo.")
			Return(.T.)
		ElseIf Empty(o_TitPagar:E2_NATUREZ)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe a natureza do titulo."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdTitPagar: Informe a natureza do titulo.")
			Return(.T.)
		ElseIf Empty(o_TitPagar:CGC)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe o CNPJ/CPF do fornecedor do titulo."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdTitPagar: Informe o CNPJ/CPF do fornecedor do titulo.")
			Return(.T.)
		ElseIf Empty(o_TitPagar:E2_EMISSAO)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe a data de emissao titulo."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdTitPagar: Informe a data de emissao do titulo.")
			Return(.T.)
		ElseIf Empty(o_TitPagar:E2_VENCTO)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe a data de vencimento titulo."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdTitPagar: Informe a data de vencimento do titulo.")
			Return(.T.)
		Else
			If (Upper(Alltrim(o_TitPagar:ESTRANGEIRO)) == 'X') //Busca pelo codigo quando o fornecedor do titulo for outros
				c_CodFX:= SubStr(Alltrim(o_TitPagar:CGC),1,Len(Alltrim(o_TitPagar:CGC))-4)
				c_CodFX:= PADR(c_CodFX, TAMSX3("A2_COD")[1])
				c_LojFX:= SubStr(Alltrim(o_TitPagar:CGC),Len(Alltrim(o_TitPagar:CGC))-3,4)
				c_LojFX:= PADR(c_LojFX, TAMSX3("A2_LOJA")[1])
				DBSELECTAREA("SA2")
				DBSETORDER(1)
				If !DBSEEK(XFILIAL("SA2")+c_CodFX+c_LojFX)
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Codigo do Fornecedor Outros nao encontrado."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdTitPagar: Codigo do Fornecedor Outros nao encontrado.")
					Return(.T.)
				Else
					c_Fornece	:= SA2->A2_COD
					c_Loja		:= SA2->A2_LOJA
				EndIf
			Else
				DBSELECTAREA("SA2")
				DBSETORDER(3)
				If !(DBSEEK(XFILIAL("SA2")+Alltrim(o_TitPagar:CGC)))
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "CNPJ/CPF "+Alltrim(o_TitPagar:CGC)+" nao encontrado na base de dados do protheus."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdTitPagar: CNPJ/CPF "+Alltrim(o_TitPagar:CGC)+" nao encontrado na base de dados do protheus.")
					Return(.T.)
				Else
					c_Fornece	:= SA2->A2_COD
					c_Loja		:= SA2->A2_LOJA
				EndIf
				
				//Testa o fornecedor do PA para os casos do Orquestra
				/*If( Len( o_TitPagar:PAFUNC) > 0 )
					If( !Empty( o_TitPagar:PAFUNC[1]:CGCPA ) )
						DBSELECTAREA("SA2")
						DBSETORDER(3)
						If !(DBSEEK(XFILIAL("SA2")+Alltrim(o_TitPagar:PAFUNC[1]:CGCPA)))
							::o_Retorno:l_Status		:= .F.
							::o_Retorno:c_Mensagem	:= "CNPJ/CPF DO PA "+Alltrim(o_TitPagar:PAFUNC[1]:CGCPA)+" nao encontrado na base de dados do protheus."+CHR(13)+CHR(10)
							Conout("FFIEBW01 - mtdTitPagar: CNPJ/CPF DO PA "+Alltrim(o_TitPagar:PAFUNC[1]:CGCPA)+" nao encontrado na base de dados do protheus.")
							Return(.T.)
						Else
							c_ForPA	:= SA2->A2_COD
							c_LojPA	:= SA2->A2_LOJA
						EndIf
					EndIf
				EndIf*/
			EndIf
			//Valida o tipo
			dbSelectArea("SX5")
			dbSetOrder(1)
			If !(dbSeek(xfilial("SX5")+"05"+Alltrim(o_TitPagar:E2_TIPO)))
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Tipo "+Alltrim(o_TitPagar:E2_TIPO)+" nao encontrado na base de dados do protheus."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdTitPagar: Tipo "+Alltrim(o_TitPagar:E2_TIPO)+" nao encontrado na base de dados do protheus.")
				Return(.T.)
			Else
				c_Tipo	:= SX5->X5_CHAVE
			EndIf

			//Valida se tem caracter especial. 05/02/2019
			If !f_VldCaracter( Alltrim(o_TitPagar:E2_NUM) )
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "O numero do titulo nao pode conter caracteres especiais.( "+Alltrim(o_TitPagar:E2_NUM)+" )"+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdTitReceber: O numero do titulo nao pode conter caracteres especiais.")
				Return(.T.)
			EndIf

            ConOut("004 - Preparando as variaveis de chave")

			c_Pre:= PADR(Alltrim(o_TitPagar:E2_PREFIXO), TAMSX3("E2_PREFIXO")[1])
			c_Num:= PADR(Alltrim(o_TitPagar:E2_NUM), TAMSX3("E2_NUM")[1])
			c_Par:= PADR(Alltrim(o_TitPagar:E2_PARCELA), TAMSX3("E2_PARCELA")[1])
			c_Tip:= PADR(Alltrim(o_TitPagar:E2_TIPO), TAMSX3("E2_TIPO")[1])
			c_CCD:= PADR(Alltrim(o_TitPagar:E2_CCD), TAMSX3("E2_CCD")[1])
			c_ITEMD:= PADR(Alltrim(o_TitPagar:E2_ITEMD), TAMSX3("E2_ITEMD")[1])

			DBSELECTAREA("SE2")
			DBSETORDER(1)
			c_FilTit := XFILIAL("SE2")
			If (DBSEEK(XFILIAL("SE2")+c_Pre+c_Num+c_Par+c_Tip+c_Fornece+c_Loja))
				If (n_Operacao = 3)
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Titulo ja existe. Utilize a opcao 4= Alterar ou 5=Excluir."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdTitPagar: Titulo ja existe. Utilize a opcao 4= Alterar ou 5=Excluir.")
					Return(.T.)
				EndIf
			Else
				If (n_Operacao = 4) .Or.(n_Operacao = 5)
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Titulo nao existe. Utilize a opcao 3=Incluir."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdTitPagar: Titulo nao existe. Utilize a opcao 3=Incluir.")
					Return(.T.)
				EndIf
			EndIf

            ConOut("005 - ajustando centro de custo")
			If !Empty(c_CCD)
				//Validando o centro de custo
				DbSelectArea("CTT")
				CTT->(dbSetOrder(1))
				If !(CTT->(dbSeek(xFilial("CTT")+c_CCD)))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Centro de Custo informado para o campo E2_CCD invalido ("+Alltrim(o_TitPagar:E2_CCD)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdTitPagar: Centro de Custo informado para o campo E2_CCD invalido ("+Alltrim(o_TitPagar:E2_CCD)+").")
					Return(.T.)
				Elseif CTT->CTT_CLASSE == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Centro de Custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_TitPagar:E2_CCD)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdTitPagar: Centro de Custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_TitPagar:E2_CCD)+").")
					Return(.T.)
				Elseif CTT->CTT_BLOQ == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Centro de Custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_TitPagar:E2_CCD)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdTitPagar: Centro de Custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_TitPagar:E2_CCD)+").")
					Return(.T.)
				Endif
			EndIf

			//Validando o item contabil
			If !Empty(c_ITEMD)
				DbSelectArea("CTD")
				CTD->(dbSetOrder(1))
				If !(CTD->(dbSeek(xFilial("CTD")+Alltrim(c_ITEMD))))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil informado para o campo E2_ITEMD invalido ("+Alltrim(o_TitPagar:E2_ITEMD)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdTitPagar: Item contabil informado para o campo E2_ITEMD invalido ("+Alltrim(o_TitPagar:E2_ITEMD)+").")
					Return(.T.)
				Elseif CTD->CTD_CLASSE == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_TitPagar:E2_ITEMD)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdTitPagar: Item contabil invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_TitPagar:E2_ITEMD)+").")
					Return(.T.)
				Elseif CTD->CTD_BLOQ == "1" .or. (!Empty(CTD->CTD_DTEXSF) .and. CTD->CTD_DTEXSF < dDatabase)
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_TitPagar:E2_ITEMD)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdTitPagar: Item contabil invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_TitPagar:E2_ITEMD)+").")
					Return(.T.)	
				ElseIf (!Empty(CTD->CTD_DTEXIS) .and. dDatabase < CTD->CTD_DTEXIS)
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil ("+Alltrim(c_ITEMD)+") esta com data de inicio de existencia superior a data base."+CHR(13)+CHR(10)
					Return(.T.)								
				ElseIf ( Alltrim(CTD->CTD_XRTADM) $ '3|4' )
					If !( u_RtVigente( Alltrim( cFilAnt ), Alltrim( c_ITEMD ) ) )							
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "O CR por ser do tipo corporativo ou compartilhado, deve existir no rateio vigente. Filial: (" + Alltrim( cFilAnt ) + "), CR: (" + Alltrim( c_ITEMD ) + ")"
						Conout("FFIEBW01 - mtdTitPagar: O CR por ser do tipo corporativo ou compartilhado, deve existir no rateio vigente. Filial: (" + Alltrim( cFilAnt ) + "), CR: (" + Alltrim( c_ITEMD ) + ")")
						Return(.T.)
					EndIf
				Endif
			EndIf

			If !Empty(o_TitPagar:E2_CLVLDB)
				//Validando a classe de valor
				DbSelectArea("CTH")
				CTH->(dbSetOrder(1))
				If !(CTH->(dbSeek(xFilial("CTH")+Alltrim(o_TitPagar:E2_CLVLDB))))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Classe de valor informado para o campo E2_CLVLDB invalido ("+Alltrim(o_TitPagar:E2_CLVLDB)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdTitPagar: Classe de valor informado para o campo E2_CLVLDB invalido ("+Alltrim(o_TitPagar:E2_CLVLDB)+").")
					Return(.T.)
				Elseif CTH->CTH_CLASSE == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Classe de valor invalido. O Classe de valor nao pode ser sintetico ("+Alltrim(o_TitPagar:E2_CLVLDB)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdTitPagar: Classe de valor invalido. O Classe de valor nao pode ser sintetico ("+Alltrim(o_TitPagar:E2_CLVLDB)+").")
					Return(.T.)
				Elseif CTH->CTH_BLOQ == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Classe de valor invalido. o Classe de valor esta bloqueado para uso ("+Alltrim(o_TitPagar:E2_CLVLDB)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdTitPagar: Classe de valor invalido. o Classe de valor esta bloqueado para uso ("+Alltrim(o_TitPagar:E2_CLVLDB)+").")
					Return(.T.)
				Endif
			EndIf

			//Valida a natureza
			dbSelectArea("SED")
			dbSetOrder(1)
			If !(dbSeek(xfilial("SED")+Alltrim(o_TitPagar:E2_NATUREZ)))
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Natureza "+Alltrim(o_TitPagar:E2_NATUREZ)+" nao encontrada na base de dados do protheus."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdTitPagar: Natureza "+Alltrim(o_TitPagar:E2_NATUREZ)+" nao encontrada na base de dados do protheus.")
				Return(.T.)
			Else
				c_Natureza	:= SED->ED_CODIGO
			EndIf
			
			//Valida a amarracao entre Prefixo x Tipo x Natureza
			If 	!o_Fieb:mtdVldNatImplant(c_Pre, c_Tip, Alltrim(o_TitPagar:E2_NATUREZ), "1" )
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Amarracao dessa Serie/Prefixo (" + Alltrim( c_Pre ) + ") com Tipo (" + Alltrim( c_Tip ) + ") e Natureza (" + Alltrim( o_TitPagar:E2_NATUREZ ) + ") nao encontrada na base de dados do protheus."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdTitPagar: Amarracao dessa Serie/Prefixo (" + Alltrim( c_Pre ) + ") com Tipo (" + Alltrim( c_Tip ) + ") e Natureza (" + Alltrim( o_TitPagar:E2_NATUREZ ) + ") nao encontrada na base de dados do protheus.")
				Return(.T.)
			Endif
			
            ConOut("006 - verificando rateios de natureza")
			//Valida o array do rateio
			If Len(o_TitPagar:NATRATEIO) > 0
				If !Empty(o_TitPagar:NATRATEIO[1]:EV_NATUREZ) .And. (o_TitPagar:NATRATEIO[1]:EV_VALOR > 0)
					c_MsgVldRat	:= ""
					If !f_VldRateio("P", o_Empresa:c_Filial, @c_MsgVldRat)
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= c_MsgVldRat
						Conout("FFIEBW01 - mtdTitPagar: "+c_MsgVldRat)
						Return(.T.)//Sai da rotina
					EndIf
				EndIf
			EndIf
			d_TesteData	:=	StoD(o_TitPagar:E2_EMISSAO)
			If valtype(d_TesteData) == "D"
				If Empty(d_TesteData)
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Informe Data de emissao no formato [AAAAMMDD]."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdTitPagar: Informe Data de emissao no formato [AAAAMMDD].")
					Return(.T.)
				EndIf
			Else
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe Data de emissao no formato [AAAAMMDD]."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdTitPagar: Informe Data de emissao no formato [AAAAMMDD].")
				Return(.T.)
			EndIf
			d_TesteData	:=	StoD(o_TitPagar:E2_VENCTO)
			If valtype(d_TesteData) == "D"
				If Empty(d_TesteData)
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Informe Data de vencimento no formato [AAAAMMDD]."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdTitPagar: Informe Data de vencimento no formato [AAAAMMDD].")
					Return(.T.)
				EndIf
			Else
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe Data de vencimento no formato [AAAAMMDD]."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdTitPagar: Informe Data de vencimento no formato [AAAAMMDD].")
				Return(.T.)
			EndIf

			If (n_Operacao = 3)
				//Valida se o periodo esta bloqueado.
				c_Err:= ""
				d_TesteData	:=	StoD(o_TitPagar:E2_EMISSAO)
				If !( f_VldDtMov( "FIN", d_TesteData, @c_Err, "P" ) )
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= c_Err
					Conout("FFIEBW01 - mtdTitPagar: "+c_Err)
					Return(.T.)
				EndIf
			EndIf
			If Empty(o_TitPagar:E2_ZBANCO) .Or. Empty(o_TitPagar:E2_ZAGENCI) .Or. Empty(o_TitPagar:E2_ZCONTA) .Or. Empty(o_TitPagar:E2_XMODELO)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Informe o Banco/Agencia/Conta e modalidade para pagamento."
				Conout("FFIEBW01 - mtdTitPagar: Informe o Banco/Agencia/Conta e modalidade para pagamento.")
				Return(.T.)
			EndIf

			//Tratamento para a data de vencimento real
			d_VencRea	:= DataValida(STOD(o_TitPagar:E2_VENCTO),.T.)
			n_Valor		:= o_TitPagar:E2_VALOR

			If (n_Operacao = 4) .Or.(n_Operacao = 5)
				DBSELECTAREA("SE2")
				DBSETORDER(1)
				DBSEEK(XFILIAL("SE2")+c_Pre+c_Num+c_Par+c_Tip+c_Fornece+c_Loja)
			EndIf
			
            ConOut("007 - INICIO VALIDACAO DA DISTRIBUICAO POR FILIAL - TABELA CUSTOMIZADA ZJY")
			//=====================================================================================================================
			// ================= INICIO VALIDACAO DA DISTRIBUICAO POR FILIAL - TABELA CUSTOMIZADA ZJY ===========================
			If (n_Operacao = 3)
				_nItRat := Len(o_TitPagar:ITENZJY)
				n_TVlrDisIt:= 0 //total do valor a distribuicao
				n_TPerDisIt:= 0 //total do percentual da distribuicao
				a_Itens := {}
				l_TemDistrib:= .F.
				For x := 1 to _nItRat
					If !Empty(o_TitPagar:ITENZJY[x]:ZJY_FILDES) .And. ((o_TitPagar:ITENZJY[x]:ZJY_VALOR > 0) .Or. (o_TitPagar:ITENZJY[x]:ZJY_PERC > 0))
						//Validando a conta contabil
						If !Empty(Alltrim(o_TitPagar:ITENZJY[x]:ZJY_CONTA))
							DBSELECTAREA("CT1")
							DBSETORDER(1)
							IF !DBSEEK(xFilial("CT1")+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_CONTA))
								::o_Retorno:l_Status		:= .F.
								::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_CONTA)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+"."
								Conout("FFIEBW01 - mtdTitPagar: Codigo da conta contabil ("+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_CONTA)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+".")
								Return(.T.)
							ElseIf CT1->CT1_CLASSE == "1"
								::o_Retorno:l_Status		:= .F.
								::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_CONTA)+") nao pode ser sintetica."
								Conout("FFIEBW01 - mtdTitPagar: Codigo da conta contabil ("+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_CONTA)+") nao pode ser sintetica.")
								Return(.T.)
							ElseIf CT1->CT1_BLOQ == "1"
								::o_Retorno:l_Status		:= .F.
								::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_CONTA)+") esta bloqueada para uso."
								Conout("FFIEBW01 - mtdTitPagar: Codigo da conta contabil ("+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_CONTA)+")  esta bloqueada para uso.")
								Return(.T.)
							EndIf
						Else
							::o_Retorno:l_Status		:= .F.
							::o_Retorno:c_Mensagem	:= "Informe a Conta contabil da distribuicao."
							Conout("FFIEBW01 - mtdTitPagar: Informe a Conta contabil da distribuicao.")
							Return(.T.)
						EndIf
						//Valida o centro de custo
						If !Empty(Alltrim(o_TitPagar:ITENZJY[x]:ZJY_CC))
							DbSelectArea("CTT")
							CTT->(dbSetOrder(1))
							If !(CTT->(dbSeek(xFilial("CTT")+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_CC))))
								::o_Retorno:l_Status	:= .F.
								::o_Retorno:c_Mensagem	:= "Centro de custo nao encontrado ("+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_CC)+")."+CHR(13)+CHR(10)
								Conout("FFIEBW01 - mtdTitPagar: Centro de custo nao encontrado  ("+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_CC)+").")
								Return(.T.)
							Elseif CTT->CTT_CLASSE == "1"
								::o_Retorno:l_Status	:= .F.
								::o_Retorno:c_Mensagem	:= "Centro de custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_CC)+")."+CHR(13)+CHR(10)
								Conout("FFIEBW01 - mtdTitPagar: Centro de custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_CC)+").")
								Return(.T.)
							Elseif CTT->CTT_BLOQ == "1"
								::o_Retorno:l_Status	:= .F.
								::o_Retorno:c_Mensagem	:= "Centro de custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_CC)+")."+CHR(13)+CHR(10)
								Conout("FFIEBW01 - mtdTitPagar: Centro de custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_CC)+").")
								Return(.T.)
							Endif
						EndIf
						//valida o item
						If !Empty(Alltrim(o_TitPagar:ITENZJY[x]:ZJY_ITEM))
							DbSelectArea("CTD")
							CTD->(dbSetOrder(1))
							If !(CTD->(dbSeek(xFilial("CTD")+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_ITEM))))
								::o_Retorno:l_Status	:= .F.
								::o_Retorno:c_Mensagem	:= "Item contabil invalido ("+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_ITEM)+")."+CHR(13)+CHR(10)
								Conout("FFIEBW01 - mtdTitPagar: Item contabil invalido ("+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_ITEM)+").")
								Return(.T.)
							Elseif CTD->CTD_CLASSE == "1"
								::o_Retorno:l_Status	:= .F.
								::o_Retorno:c_Mensagem	:= "Item contabil invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_ITEM)+")."+CHR(13)+CHR(10)
								Conout("FFIEBW01 - mtdTitPagar: Item contabil invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_ITEM)+").")
								Return(.T.)
							Elseif CTD->CTD_BLOQ == "1" .or. (!Empty(CTD->CTD_DTEXSF) .and. CTD->CTD_DTEXSF < dDatabase)
								::o_Retorno:l_Status	:= .F.
								::o_Retorno:c_Mensagem	:= "Item contabil invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_ITEM)+")."+CHR(13)+CHR(10)
								Conout("FFIEBW01 - mtdTitPagar: Item contabil invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_ITEM)+").")
								Return(.T.)
							ElseIf (!Empty(CTD->CTD_DTEXIS) .and. dDatabase < CTD->CTD_DTEXIS)
								::o_Retorno:l_Status	:= .F.
								::o_Retorno:c_Mensagem	:= "Item contabil ("+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_ITEM)+") esta com data de inicio de existencia superior a data base."+CHR(13)+CHR(10)
								Return(.T.)
							ElseIf ( Alltrim(CTD->CTD_XRTADM) $ '3|4' ) //Valida o rateio vigente: 11/09/2019.
								If !( u_RtVigente( Alltrim( o_TitPagar:ITENZJY[x]:ZJY_FILDES ), Alltrim( o_TitPagar:ITENZJY[x]:ZJY_ITEM ) ) )							
									::o_Retorno:l_Status	:= .F.
									::o_Retorno:c_Mensagem	:= "O CR por ser do tipo corporativo ou compartilhado, deve existir no rateio vigente. Filial: (" + Alltrim( o_TitPagar:ITENZJY[x]:ZJY_FILDES ) + "), CR: (" + Alltrim( o_TitPagar:ITENZJY[x]:ZJY_ITEM ) + ")"
									Return(.T.)
								EndIf
							Endif
						EndIf
						//Valida se a filial na distribuicao e diferente da empresa da digitacao da nota
						If ( Substr(Alltrim(o_TitPagar:ITENZJY[x]:ZJY_FILDES),1,4) <> Substr(Alltrim(o_Empresa:c_Filial),1,4) )
							::o_Retorno:l_Status	:= .F.
							::o_Retorno:c_Mensagem	:= "A filial da distribuicao nao pode ser diferente da empresa da digitacao da nota ("+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_FILDES)+")."+CHR(13)+CHR(10)
							Conout("FFIEBW01 - mtdTitPagar: A filial da distribuicao nao pode ser diferente da empresa da digitacao da nota ("+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_FILDES)+").")
							Return(.T.)
						EndIf
						//VALIDA SE A CONTA COMECA COM 3 OU 4 E OBRIGA O UO (ZJW_CC) E CR (ZJW_ITEMCTA)
						If (Substr( Alltrim(o_TitPagar:ITENZJY[x]:ZJY_CONTA),1,1 ) $ '3,4') .And. (Empty(o_TitPagar:ITENZJY[x]:ZJY_CC) .Or. Empty(o_TitPagar:ITENZJY[x]:ZJY_ITEM))
							::o_Retorno:l_Status	:= .F.
							::o_Retorno:c_Mensagem	:= "Para contas que comecam com 3 ou 4 ("+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_CONTA)+") o CR e Uo devem ser preenchidos."
							Conout("FFIEBW01 - mtdTitPagar: Para contas que comecam com 3 ou 4 ("+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_CONTA)+") o CR e Uo devem ser preenchidos.")
							Return(.T.)
						Else
							l_TemDistrib:= .F.
							//VERIFICA SE A AMARRACAO ENTRE O CR E UO EXISTE
							If !(Empty(Alltrim(o_TitPagar:ITENZJY[x]:ZJY_CC))) .Or. !(Empty(Alltrim(o_TitPagar:ITENZJY[x]:ZJY_ITEM))) .Or. ( Substr( Alltrim( o_TitPagar:ITENZJY[x]:ZJY_CONTA ),1,1 ) $ '1|2' ) //Contas que comecao com 1 ou 2 nao tem Cr e UO
								If( Substr( Alltrim( o_TitPagar:ITENZJY[x]:ZJY_CONTA ),1,1 ) $ '1|2' ) //Nao faz validacao de Amarracao pois nao tem Cr e Uo quando a conta comeca com 1 ou 2
									l_TemDistrib:= .T. //Informa que tem distribuicao no item
									Aadd(a_Itens,{Strzero(Val(o_TitPagar:ITENZJY[x]:ZJY_LINHA),4), o_TitPagar:ITENZJY[x]:ZJY_FILDES, Alltrim(o_TitPagar:ITENZJY[x]:ZJY_CONTA), o_TitPagar:ITENZJY[x]:ZJY_VALOR, o_TitPagar:ITENZJY[x]:ZJY_PERC, Alltrim(o_TitPagar:ITENZJY[x]:ZJY_ITEM), Alltrim(o_TitPagar:ITENZJY[x]:ZJY_CC), Alltrim(o_TitPagar:ITENZJY[x]:ZJY_CLVL)})
									n_TVlrDisIt+= o_TitPagar:ITENZJY[x]:ZJY_VALOR
									n_TPerDisIt+= o_TitPagar:ITENZJY[x]:ZJY_PERC
								ElseIf (VerAmarrCTA(Alltrim(o_TitPagar:ITENZJY[x]:ZJY_FILDES), Alltrim(o_TitPagar:ITENZJY[x]:ZJY_CC), Alltrim(o_TitPagar:ITENZJY[x]:ZJY_ITEM)))
									l_TemDistrib:= .T. //Informa que tem distribuicao no item
									Aadd(a_Itens,{Strzero(Val(o_TitPagar:ITENZJY[x]:ZJY_LINHA),4), o_TitPagar:ITENZJY[x]:ZJY_FILDES, Alltrim(o_TitPagar:ITENZJY[x]:ZJY_CONTA), o_TitPagar:ITENZJY[x]:ZJY_VALOR, o_TitPagar:ITENZJY[x]:ZJY_PERC, Alltrim(o_TitPagar:ITENZJY[x]:ZJY_ITEM), Alltrim(o_TitPagar:ITENZJY[x]:ZJY_CC), Alltrim(o_TitPagar:ITENZJY[x]:ZJY_CLVL)})
									n_TVlrDisIt+= o_TitPagar:ITENZJY[x]:ZJY_VALOR
									n_TPerDisIt+= o_TitPagar:ITENZJY[x]:ZJY_PERC
								Else
									::o_Retorno:l_Status	:= .F.
									::o_Retorno:c_Mensagem	:= "Nao existe amarracao (Tabela CTA) entre Filial: ("+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_FILDES)+"), CR: ("+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_ITEM)+") e Uo: ("+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_CC)+")."
									Conout("FFIEBW01 - mtdTitPagar: Nao existe amarracao (Tabela CTA) entre Filial: ("+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_FILDES)+"), CR: ("+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_ITEM)+") e Uo: ("+Alltrim(o_TitPagar:ITENZJY[x]:ZJY_CC)+").")
									Return(.T.)
								EndIf
								//Valida se a conta comeca com 32 e o Cr possui o campo CTD_XRTADM = 2=Consumo;3=Corporativo;4=Unid. Compartilhadas 11/02/2019
								c_ErrMsg:= ""
								If !( f_VldCnInvest( Alltrim(o_TitPagar:ITENZJY[x]:ZJY_CONTA), Alltrim( o_TitPagar:ITENZJY[x]:ZJY_ITEM ), @c_ErrMsg ) )
									::o_Retorno:l_Status	:= .F.
									::o_Retorno:c_Mensagem	:= c_ErrMsg
									Conout("FFIEBW01 - mtdTitPagar: "+c_ErrMsg)
									Return(.T.)
								EndIf
							EndIf
						EndIf
					Endif
				Next
				If ( n_TVlrDisIt > 0 ) //Se informou valor
					If ( ROUND(n_TVlrDisIt,2) <> ROUND((o_TitPagar:E2_VALOR),2) )
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "O total da distribuicao: "+Alltrim(Str(ROUND(n_TVlrDisIt,2)))+" eh diferente do total do item: "+Alltrim(Str(ROUND((o_TitPagar:E2_VALOR),2)))
						Conout("FFIEBW01 - mtdTitPagar: O total da distribuicao : "+Alltrim(Str(ROUND(n_TVlrDisIt,2)))+" eh diferente do total do item: "+Alltrim(Str(ROUND((o_TitPagar:E2_VALOR),2))))
						Return(.T.)
					EndIf
				ElseIf ( n_TPerDisIt > 0 ) //Se informou percentual
					If ( n_TPerDisIt <> 100 )
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "O percentual total da distribuicao nao bate 100%: "+Alltrim(Str(n_TPerDisIt))
						Conout("FFIEBW01 - mtdTitPagar: O percentual total da distribuicao nao bate 100%: "+Alltrim(Str(n_TPerDisIt)))
						Return(.T.)
					EndIf
				EndIf
			EndIf
			// =================== FIM VALIDACAO/GRAVACAO NO VETOR DA DISTRIBUICAO - TABELA CUSTOMIZADA ZJY========================
			//=====================================================================================================================

            ConOut("008 -  carga no vertor de gravacao do titulo pai")

			aAdd( aVetor, { "E2_PREFIXO"	,PADR(Alltrim(o_TitPagar:E2_PREFIXO), TAMSX3("E2_PREFIXO")[1])	,Nil})
			aAdd( aVetor, { "E2_NUM"		,PADR(Alltrim(o_TitPagar:E2_NUM), TAMSX3("E2_NUM")[1])			,Nil})
			aAdd( aVetor, { "E2_PARCELA"	,PADR(Alltrim(o_TitPagar:E2_PARCELA), TAMSX3("E2_PARCELA")[1])	,Nil})
			aAdd( aVetor, { "E2_TIPO"		,PADR(c_Tipo, TAMSX3("E2_TIPO")[1])  		,Nil})
			aAdd( aVetor, { "E2_FORNECE"	,PADR(c_Fornece, TAMSX3("E2_FORNECE")[1])	,Nil})
			aAdd( aVetor, { "E2_LOJA"		,PADR(c_Loja, TAMSX3("E2_LOJA")[1])			,Nil})
			aAdd( aVetor, { "E2_NATUREZ"	,PADR(c_Natureza, TAMSX3("E2_NATUREZ")[1])	,Nil})
			aAdd( aVetor, { "E2_EMISSAO"	,STOD(o_TitPagar:E2_EMISSAO)				,Nil})
			aAdd( aVetor, { "E2_VENCTO"		,STOD(o_TitPagar:E2_VENCTO)					,Nil})
			aAdd( aVetor, { "E2_VENCREA"	,d_VencRea									,Nil})
			aAdd( aVetor, { "E2_VALOR"		,n_Valor									,Nil})
			aAdd( aVetor, { "E2_HIST"		,PADR(Alltrim(o_TitPagar:E2_HIST), TAMSX3("E2_HIST")[1])		,Nil})
			//Add em 28/02/2019 o campo obrigatorio da FIEB
			aAdd( aVetor, { "E2_XHIST"		,PADR(Alltrim(o_TitPagar:E2_HIST), TAMSX3("E2_XHIST")[1])		,Nil})

			aAdd( aVetor, { "E2_LA"			,Alltrim(o_TitPagar:E2_LA)					,Nil})
			aAdd( aVetor, { "E2_XIDWBC"		,PADR(Alltrim(o_TitPagar:E2_XIDWBC), TAMSX3("E2_XIDWBC")[1])	,Nil})
			aAdd( aVetor, { "E2_XTITEMS"	,PADR(Alltrim(o_TitPagar:E2_XTITEMS), TAMSX3("E2_XTITEMS")[1])	,Nil})
			aAdd( aVetor, { "E2_RATEIO"		,PADR(Alltrim(o_TitPagar:E2_RATEIO), TAMSX3("E2_RATEIO")[1])	,Nil})

			If !Empty(Alltrim(o_TitPagar:E2_XPABCO))
				aAdd( aVetor, { "E2_XPABCO"		,PADR(Alltrim(o_TitPagar:E2_XPABCO), TAMSX3("E2_XPABCO")[1])	,Nil})
			EndIf
			If !Empty(Alltrim(o_TitPagar:E2_XPAAGE))
				aAdd( aVetor, { "E2_XPAAGE" 	,PADR(Alltrim(o_TitPagar:E2_XPAAGE), TAMSX3("E2_XPAAGE")[1])	,Nil})
			EndIf
			If !Empty(Alltrim(o_TitPagar:E2_XPACTA))
				aAdd( aVetor, { "E2_XPACTA"		,PADR(Alltrim(o_TitPagar:E2_XPACTA), TAMSX3("E2_XPACTA")[1])	,Nil})
			EndIf

			aAdd( aVetor, { "E2_ITEMD"		,PADR(Alltrim(o_TitPagar:E2_ITEMD), TAMSX3("E1_ITEMD")[1])	,Nil})
			aAdd( aVetor, { "E2_CCD"		,PADR(Alltrim(o_TitPagar:E2_CCD), TAMSX3("E1_CCD")[1])		,Nil})
			aAdd( aVetor, { "E2_CLVLDB"		,PADR(Alltrim(o_TitPagar:E2_CLVLDB), TAMSX3("E1_CLVLDB")[1])	,Nil})
			aAdd( aVetor, { "E2_ZBANCO"		,PADR(Alltrim(o_TitPagar:E2_ZBANCO), TAMSX3("E2_ZBANCO")[1])	,Nil})
			aAdd( aVetor, { "E2_ZAGENCI" 	,PADR(Alltrim(o_TitPagar:E2_ZAGENCI), TAMSX3("E2_ZAGENCI")[1])	,Nil})
			aAdd( aVetor, { "E2_ZCONTA"		,PADR(Alltrim(o_TitPagar:E2_ZCONTA), TAMSX3("E2_ZCONTA")[1])	,Nil})
			aAdd( aVetor, { "E2_XMODELO"	,PADR(Alltrim(o_TitPagar:E2_XMODELO), TAMSX3("E2_XMODELO")[1])	,Nil})

			If !Empty( Alltrim(o_TitPagar:E2_FSNTFOL) )
				aAdd( aVetor, { "E2_FSNTFOL"	,PADR(Alltrim(o_TitPagar:E2_FSNTFOL), TAMSX3("E2_FSNTFOL")[1])	,Nil})
			EndIf
			
			If( l_TemDistrib )
				aAdd( aVetor, { "E2_XDISTR"	,'S'	,Nil})
			EndIf
			
			CUSUARIO:= "123456integracao"
			DbSelectArea("SX1")
			DbSetOrder(1)
			If DbSeek("FIN050    "+"04")
				RecLock("SX1",.F.)
				SX1->X1_PRESEL:= 1
				MsUnLock()
			EndIf
			
			If Alltrim(c_Tipo) == "PA"
				c_Ban:= Padr(o_TitPagar:PABANCO,TamSX3("E5_BANCO")[1])
				c_Age:= Padr(o_TitPagar:PAAGENC,TamSX3("E5_AGENCIA")[1])
				c_Con:= Padr(o_TitPagar:PACONTA,TamSX3("E5_CONTA")[1])

				DBSELECTAREA("SA6")
				DBSETORDER(1)
				If !DBSEEK(xFilial("SA6")+c_Ban+c_Age+c_Con)
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Para o tipo PA o banco/agencia/conta devem ser informados: "+c_Ban+"/"+c_Age+"/"+c_Con+". Portanto os dados informados nao foram encontrados para a filial logada."
					Conout("FFIEBW01 - mtdTitPagar: Para o tipo PA o banco/agencia/conta devem ser informados: "+c_Ban+"/"+c_Age+"/"+c_Con+". Portanto os dados informados nao foram encontrados para a filial logada.")
					Return(.T.)
				EndIf

				aAdd( aVetor, { "AUTBANCO"		,Alltrim(o_TitPagar:PABANCO),Nil})
				aAdd( aVetor, { "AUTAGENCIA"	,Alltrim(o_TitPagar:PAAGENC),Nil})
				aAdd( aVetor, { "AUTCONTA"		,Alltrim(o_TitPagar:PACONTA),Nil})
							
				If (n_Operacao = 3)
					l_PreSel:= .F.
					DbSelectArea("SX1")
					DbSetOrder(1)
					If DbSeek("FIN050    "+"09")
						If( Upper( Alltrim( o_TitPagar:TIT_ORQUEST ) ) == 'S' ) //Titulo do Orquestra
							If ( SX1->X1_PRESEL = 2 )
								l_PreSel:= .T.
								RecLock("SX1",.F.)
								SX1->X1_PRESEL:= 1
								MsUnLock()
							EndIf
						Else
							If ( SX1->X1_PRESEL = 1 )
								l_PreSel:= .T.
								RecLock("SX1",.F.)
								SX1->X1_PRESEL:= 2
								MsUnLock()
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf

			//INCLUI         := .T.
			lMsErroAuto    := .F.
			lMsHelpAuto    := .T.
			lAutoErrNoFile := .T.

			l_WebService	:= .T.

			c_PreBx:= PADR(Alltrim(o_TitPagar:E2_PREFIXO), TAMSX3("E1_PREFIXO")[1])
			c_NumBx:= PADR(Alltrim(o_TitPagar:E2_NUM), TAMSX3("E1_NUM")[1])
			c_ParBx:= PADR(Alltrim(o_TitPagar:E2_PARCELA), TAMSX3("E1_PARCELA")[1])
			c_TipBx:= PADR(Alltrim(o_TitPagar:E2_TIPO), TAMSX3("E1_TIPO")[1])

			If (Alltrim(c_PreBx) == 'RM') .And. (n_Operacao = 5)
				DBSELECTAREA("SE2")
				DBSETORDER(1)
				If (DBSEEK(XFILIAL("SE2")+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_Fornece+c_Loja))
					If (SE2->E2_LA = 'S')
						RecLock("SE2",.F.)
						SE2->E2_LA:= 'N'
						MsUnLock()
					EndIf
				EndIf
			EndIf

			//Valida a data EMIS1 antes de mudar a data base.
			c_Err:= ""
			d_TesteData	:=	StoD(o_TitPagar:E2_EMIS1)
			If !( f_VldDtMov( "FIN", d_TesteData, @c_Err, "P" ) )
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= c_Err
				Conout("FFIEBW01 - mtdTitPagar: "+c_Err)
				Return(.T.)
			EndIf

			d_DataBk		:= DDATABASE
			DDATABASE:= STOD( o_TitPagar:E2_EMIS1 )

			Begin Transaction
				If( n_Operacao = 5 )
					DBSELECTAREA("SE2")
					DBSETORDER(1)
					DBSEEK( XFILIAL("SE2")+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_Fornece+c_Loja )
					// =================== Estorno da Contabilizacao OnLine da Distribuicao 13/06/2019 ============================
					l_DistOnline:= SuperGetMV("FS_CONDIST",.F.,.F.) //Infoma se contabiliza OnLine a distribuicao. 13/06/2019
					c_Fil 	:= SE2->E2_FILIAL
					cPre 	:= SE2->E2_PREFIXO
					cNum  	:= SE2->E2_NUM
					cParc	:= SE2->E2_PARCELA
					cTipo 	:= SE2->E2_TIPO
					cForn	:= SE2->E2_FORNECE
					cLoja	:= SE2->E2_LOJA

					//Verifica se existe a rotina de estorno da contabilizacao da distribuicao
					If(ExistBlock('FCTBA009'))
						//Verifica se a distribuicao foi contabilizada
						DbSelectArea("ZJY")
						DbSetOrder(1)
						If DbSeek(SE2->E2_FILIAL + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE +SE2->E2_LOJA)
							If !Empty(ZJY->ZJY_LA)
								//Verifica se foi contabilizada pela nova rotina
								c_Qry2:= "SELECT CT2.R_E_C_N_O_ AS RECCT2, CT2_HIST, CT2_LINHA, CT2_FILIAL, CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_DEBITO, CT2_CREDIT, CT2_VALOR, CT2_KEY "+ CHR(13)+CHR(10)
								c_Qry2+= "FROM " + RetSQLName("CT2") + " CT2 WITH (NOLOCK) "+ CHR(13)+CHR(10)
								c_Qry2+= "WHERE CT2.D_E_L_E_T_ <> '*' " +CHR(13)+CHR(10)
								c_Qry2+= "AND CT2_DATA = '"+Dtos(ZJY->ZJY_EMISSA)+"' "+ CHR(13)+CHR(10)
								c_Qry2+= "AND CT2_KEY = '"+ZJY_FILIAL+ZJY_PREFIX+ZJY_TITULO+ZJY_PARCEL+ZJY_TIPO+ZJY_FORNEC+ZJY_LOJA+ZJY_FILDES+"' "+ CHR(13)+CHR(10)
								c_Qry2+= "AND CT2_DC <> '4' "+ CHR(13)+CHR(10)
								c_Qry2+= "AND CT2_ROTINA IN ('FCTBA004','FCTBA014') "+ CHR(13)+CHR(10)
								c_Qry2+= "AND CT2_LOTE = 'DIS002' "+ CHR(13)+CHR(10)
								TCQUERY c_Qry2 ALIAS QRY2 NEW
								If !(QRY2->(Eof()))
									//Chama a rotina de estorno da contabilizacao
									If( l_DistOnline ) //Se contabiliza OnLine a Distribuicao.
										CUSUARIO:= "123456WS" //Fiz isso para gravar WS no LP pois eh usado a variavel cusuario nos LP's de contabilizacao
										u_FCTBA009( "ZJY" )
									EndIf
								EndIf
								DbSelectArea("QRY2")
								QRY2->(DbCloseArea())
							EndIf
						EndIf
					EndIf

					//Excluir a distribuicao, caso exista
					If( SE2->E2_XDISTR == "S" )
						DbSelectArea("ZJY")
						ZJY->(DbSetOrder(1))
						If DbSeek(xFilial("ZJY")+SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA)
							While (ZJY->(!Eof())) .And. (ZJY->ZJY_FILIAL + ZJY->ZJY_PREFIX + ZJY->ZJY_TITULO + ZJY->ZJY_PARCEL + ZJY->ZJY_TIPO + ZJY->ZJY_FORNEC + ZJY->ZJY_LOJA == xFilial("ZJY")+SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA )
								RecLock("ZJY",.F.)
								ZJY->(DbDelete())
								ZJY->(MsUnLock())
								ZJY->(DbSkip())
							EndDo
						EndIf
					EndIf
					// =================== Estorno da Contabilizacao OnLine da Distribuicao 13/06/2019 ============================
				EndIf

                ConOut("009 - gravando titulo pai")

				MsExecAuto({|x,y,z| FINA050(x,y,z)}, aVetor,, n_Operacao) // 3 - Inclusao, 4 - Alteracao, 5 - Exclusao
				//MSExecAuto( {|a,b,c,d,e,f,g,h,i,j| FINA050(a,b,c,d,e,f,g,h,i,j)}, aVetor , , n_Operacao,,,,,If(_lRateio,_aTotRat,),,)
				If lMsErroAuto
					DisarmTransaction()
					Break
				Else
					If (n_Operacao = 3)
						nRecnoE2 := SE2->( Recno() )
						If Len(o_TitPagar:NATRATEIO) > 0
							If !Empty(o_TitPagar:NATRATEIO[1]:EV_NATUREZ) .And. (o_TitPagar:NATRATEIO[1]:EV_VALOR > 0)
								f_GravaEVEZ(c_Fornece, c_Loja, c_Tipo, "P", Alltrim(o_TitPagar:E2_PREFIXO), Alltrim(o_TitPagar:E2_NUM), Alltrim(o_TitPagar:E2_PARCELA), "", 0, SE2->E2_VALOR)
								DbSelectArea("SE2")
								RecLock("SE2",.F.)
								SE2->E2_MULTNAT:= '1'
								MsUnLock()
							EndIf
						EndIf
						//Solicitado por Paula que a data para contabilizacao fosse ajustada conforme necessidade do legado.
						dbSelectArea("SE2")
						RecLock("SE2",.F.)
						SE2->E2_EMIS1	:= STOD( o_TitPagar:E2_EMIS1 )
						MsUnlock()
						If (__lSX8)
							ConfirmSX8()
						EndIf
						//Volta a pergunta para o estado anterior no caso de PA.
						If Alltrim(c_Tipo) == "PA"
							If ( l_PreSel )
								DbSelectArea("SX1")
								DbSetOrder(1)
								If DbSeek("FIN050    "+"09")
									If( Upper( Alltrim( o_TitPagar:TIT_ORQUEST ) ) == 'S' ) //Titulo do Orquestra
										If ( SX1->X1_PRESEL = 1 )
											RecLock("SX1",.F.)
											SX1->X1_PRESEL:= 2
											MsUnLock()
										EndIf
									Else								
										If ( SX1->X1_PRESEL = 2 )
											RecLock("SX1",.F.)
											SX1->X1_PRESEL:= 1
											MsUnLock()
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
						//=====================================================================================================================
						// ================= INICIO GRAVACAO DA DISTRIBUICAO DO RATEIO - TABELA CUSTOMIZADA ZJY ===========================
						l_RetZJY:= f_GrvZJY(.T., XFILIAL("SE2"), c_Pre, c_Num, c_Par, c_Tip, STOD(o_TitPagar:E2_EMISSAO), STOD(o_TitPagar:E2_EMIS1), c_Fornece, c_Loja, o_TitPagar:E2_VALOR, a_Itens)
						If (l_RetZJY)
							RecLock("SE2",.F.)
							SE2->E2_XDISTR := "S"
							MsUnLock()
						Endif
						// =================== FIM GRAVACAO DA DISTRIBUICAO DO RATEIO - TABELA CUSTOMIZADA J2A ZJW ============================
						//=====================================================================================================================

						// =================== Contabilizacao OnLine da Distribuicao 13/06/2019 ============================
						l_DistOnline:= SuperGetMV("FS_CONDIST",.F.,.F.) //Infoma se contabiliza OnLine a distribuicao. 13/06/2019
						If( l_DistOnline ) //Se contabiliza OnLine a Distribuicao.
							//Variaveis usadas no fonte abaixo.
							c_Fil 	:= SE2->E2_FILIAL
							cPre 	:= SE2->E2_PREFIXO
							cNum  	:= SE2->E2_NUM
							cParc	:= SE2->E2_PARCELA
							cTipo 	:= SE2->E2_TIPO
							cForn	:= SE2->E2_FORNECE
							cLoja	:= SE2->E2_LOJA
							CUSUARIO:= "123456WS" //Fiz isso para gravar WS no LP pois eh usado a variavel cusuario nos LP's de contabilizacao
							u_FCTBA014( "ZJY" )
						EndIf
						// =================== Contabilizacao OnLine da Distribuicao 13/06/2019 ============================

						//Solicitante: Paula Nolasco
						//Desenvolvedor: Francisco Rezende
						//Data: 16/07/2019
						//Motivo: Atender a prestacao de Contas do Orquestra

                        ConOut("010 - preparando a compensacao")

						If Len(o_TitPagar:PAFUNC) > 0

							c_PrfAdto	:= PADR( Alltrim( o_TitPagar:PAFUNC[1]:E2_PREFIXO ), TAMSX3("E2_PREFIXO")[1] )
							c_NumAdto	:= PADR( Alltrim( o_TitPagar:PAFUNC[1]:E2_NUM ), TAMSX3("E2_NUM")[1] )
							c_ParAdto	:= PADR( Alltrim( o_TitPagar:PAFUNC[1]:E2_PARCELA ), TAMSX3("E2_PARCELA")[1] )
							c_TipAdto	:= PADR( Alltrim( o_TitPagar:PAFUNC[1]:E2_TIPO ), TAMSX3("E2_TIPO")[1] )
							
							//Fornecedor do Orquestra que e diferente do fornecedor do titulo a pagar 06/11/2019
							/*If( !Empty( c_ForPA ) ) .And. ( !Empty( c_LojPA ) )
								c_Fornece	:= c_ForPA
								c_Loja		:= c_LojPA
							EndIf*/
							
							If( !Empty( c_NumAdto ) ) .And. ( !Empty( c_TipAdto ) )
								dbSelectArea("SE2")
								dbSetOrder(1)	//E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, R_E_C_N_O_, D_E_L_E_T_
								If dbSeek( xFilial("SE2") + c_PrfAdto + c_NumAdto + c_ParAdto + c_TipAdto + c_Fornece + c_Loja )
									a_RecSE2�	:= { nRecnoE2 }
									a_RecPA		:= { SE2->( Recno() ) }
									ConOut("011 - antes de gravar a compensacao")
                                    If MaIntBxCP(2,a_RecSE2,,a_RecPA,,{ l_Contabiliza, l_Aglutina, l_Digita, l_Juros, l_Desconto, l_Comissao },,,,,dDataBase )
										c_LogAdto	:= "  Compensado adiantamento com sucesso!!!"
                                        ConOut("012 - compensacao ok")
									Else
										c_LogAdto	:= " Porem houve uma falha na compensacao do titulo. Proceder de forma manual."
										Conout( "FFIEBW01 - Falha ao compensar adto. " + xFilial("SE2") + c_PrfAdto + c_NumAdto + c_ParAdto + c_ParAdto + c_Fornece + c_Loja + "." )
                                        ConOut("013 - compensacao error")
									EndIf
								EndIf
							EndIf
						EndIf
						SE2->( dbGoTo( nRecnoE2 ) )
                        ConOut("014 - fim")
						//------------------------------------------- FIM ------------------------------------------------------------

						::o_Retorno:l_Status		:= .T.
						::o_Retorno:c_Mensagem	:= "Titulo de numero " + Alltrim( SE2->E2_NUM ) + " incluido com sucesso na filial " + o_Empresa:c_Filial + "." + c_LogAdto
						Conout("FFIEBW01 - mtdTitPagar: Titulo de numero " + Alltrim( SE2->E2_NUM ) + " incluido com sucesso na filial " + o_Empresa:c_Filial + "." + c_LogAdto )
					ElseIf (n_Operacao = 4)
						::o_Retorno:l_Status		:= .T.
						::o_Retorno:c_Mensagem	:= "Titulo de numero "+Alltrim( SE2->E2_NUM )+" alterado com sucesso na filial "+o_Empresa:c_Filial+"."
						Conout("FFIEBW01 - mtdTitPagar: Titulo de numero "+Alltrim( SE2->E2_NUM )+" alterado com sucesso na filial "+o_Empresa:c_Filial+".")
					Else
						::o_Retorno:l_Status		:= .T.
						::o_Retorno:c_Mensagem	:= "Titulo de numero "+Alltrim( SE2->E2_NUM )+" excluido com sucesso na filial "+o_Empresa:c_Filial+"."
						Conout("FFIEBW01 - mtdTitPagar: Titulo de numero "+Alltrim( SE2->E2_NUM )+" excluido com sucesso na filial "+o_Empresa:c_Filial+".")
					EndIf
				Endif
			End Transaction
			//Se due erro no Execauto
			If lMsErroAuto
				//Regra do fonte SIESBA01 da FIEB
				If (__lSX8)
					RollBackSX8()
				EndIf

				// Tratamento da Mensagem de erro do MSExecAuto
				aLogErr  := GetAutoGRLog()
				aLogErr2 := f_TrataErro(aLogErr)
				_cMotivo := ""

				For i := 1 to Len(aLogErr2)
					_cMotivo += aLogErr2[i]
				Next
				If Empty(_cMotivo)
					_cMotivo:= MostraErro("\TOTVSBA_LOG\","Titulo_pagar.txt")
				EndIf
				//Exclusivo para a versao 12
				If (GetVersao(.F.) == "12")
					_cMotivo:=  NoAcentoESB(_cMotivo)
					SetSoapFault('Erro',_cMotivo)
				EndIf

				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= NoAcentoESB(_cMotivo)
				Conout("FFIEBW01 - mtdTitPagar: "+NoAcentoESB(_cMotivo))
			EndIf
		EndIf
	EndIf
	DDATABASE:= d_DataBk

RETURN(.T.)
/*/{Protheus.doc} mtdBaixaTit
Metodo de baixa
@author Totvs-BA
@since 05/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
//metodo de baixa
WSMETHOD mtdBaixaTit WSRECEIVE o_Seguranca, o_Empresa, o_BxParam, o_TitRA, Operacao WSSEND o_Retorno WSSERVICE FFIEBW01

	Local a_Baixa 	:= {}
	Local c_CliBx	:= ""
	Local c_LojBX	:= ""
	Local n_Operacao:= Val(::Operacao)
	Local l_Compensou:= .F.
	Local l_Sobrou	:= .T.
	Local c_NRas:= ""
	Local aTxMoeda 	:= {}
	Local a_RasRec	:= {}
	Local i,p,u		:= 0
	Local c_Lote	:= ""
	Local a_MotsBx	:= {}
	Local n_PosBx	:= 0
	Local d_DataBk	:= DDATABASE
	Local c_xNumRM	:= ""
	Local l_Encont	:= .F.
	Local l_IdBxSe5 := .F. //incrementdo para validar existencia do id da baixa na se5
	Local l_LotRmBx	:= .F.
	Local aDtMov	:=	{}
	Local aSE1		:= {}
	Local aEstorno	:= {}
	
	Private nRecnoRA
	Private nRecnoE1

	PRIVATE lMsErroAuto 	:= .F.
	Private lNoMbrowse		:= .F. //Variavel logica que informa se deve ou nao ser apresentado o Browse da rotina baixas a receber.
	Private nOpbaixa		:= IIF(o_BxParam:SEQBAIXA=0,1,o_BxParam:SEQBAIXA) //Passar 1 pq no cancelamento essa variavel eh usada.

	::o_Retorno	:= WSCLASSNEW("strRetorno")

	If !(f_VldFilEmp(o_Empresa:c_Empresa,o_Empresa:c_Filial))
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Codigo de Empresa/Filial nao existe."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdBaixaTit: Codigo de Empresa/Filial nao existe.")
		Return(.T.)
	EndIf

	//Loga na filial solicitada
	RpcSetType(3)
	RpcSetEnv(o_Empresa:c_Empresa,o_Empresa:c_Filial, "integracao", "fieb123")

	//Posiciona na empresa e filial passada
	dbSelectArea("SM0")
	dbSeek(o_Empresa:c_Empresa+o_Empresa:c_Filial)

	cFilAnt:= o_Empresa:c_Filial

	c_UserWS	:= Upper(ALLTRIM(SUPERGETMV("FS_FIUSRWS",,"totvs_fieb")))
	c_PswWS		:= Upper(ALLTRIM(SUPERGETMV("FS_FIPSWWS",,"totvs@123")))

	//Validando o usuario e senha
	If ( Upper(o_Seguranca:c_Usuario) <> Upper(c_UserWS) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdBaixaTit: Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido.")
		Return(.T.)
	ElseIf ( Upper(o_Seguranca:c_Senha) <> Upper(c_PswWS) )
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdBaixaTit: Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida.")
		Return(.T.)
	EndIf
	If (n_Operacao <> 3) .And. (n_Operacao <> 5) .And. (n_Operacao <> 6)
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Valor passado no parametro Operacao ("+cValToChar(n_Operacao)+") invalido. Informar (3=Baixa; 5=Cancelamento; 6=Exclusao)."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdBaixaTit: Valor passado no parametro Operacao ("+cValToChar(n_Operacao)+") invalido. Informar (3=Baixa; 5=Cancelamento; 6=Exclusao).")
		Return(.T.)
	EndIf

	If Empty(o_BxParam:CGC)
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Informe o CNPJ/CPF do cliente do titulo."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdBaixaTit: Informe o CNPJ/CPF do cliente do titulo.")
		Return(.T.)
	EndIf
	If( Alltrim( o_BxParam:AUTMOTBX ) <> "CAR") //BAIXA DE CARTAO NAO MOVIMENTA BANCO (CASOS DO TEATRO SESI QUE NAO MANDA OS DADOS DO BANCO)
		If Empty(o_BxParam:AUTBANCO) .Or. Empty(o_BxParam:AUTAGENCIA) .Or. Empty(o_BxParam:AUTCONTA)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Banco/Agencia/Conta nao informados."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdBaixaTit: Banco/Agencia/Conta nao informados.")
			Return(.T.)
		EndIf
	EndIf
	If (n_Operacao = 3)
		//Conforme Rafael falou, a data da baixa tem que ser a data que o RM manda.
		DDATABASE:= Stod(o_BxParam:AUTDTBAIXA)
		If	(STOD(o_BxParam:AUTDTBAIXA) > dDatabase)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "A data da baixa e maior que a data atual. Baixa nao permitida. AUTDTBAIXA: "+o_BxParam:AUTDTBAIXA+". dDatabase: "+ dtos(dDatabase)+"."
			Conout("FFIEBW01 - mtdBaixaTit: A data da baixa e maior que a data atual. Baixa nao permitida. AUTDTBAIXA: "+o_BxParam:AUTDTBAIXA+". dDatabase: "+ dtos(dDatabase)+".")
			//Volta a database
			DDATABASE:= d_DataBk
			Return(.T.)
		Endif
		/*If	(STOD(o_BxParam:AUTDTCREDITO) > dDatabase)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "A data de credito e maior que a data atual. Baixa nao permitida."
			Conout("FFIEBW01 - mtdBaixaTit: A data de credito e maior que a data atual. Baixa nao permitida.")
			//Volta a database
			DDATABASE:= d_DataBk
			Return(.T.)
		Endif
		*/
		If Empty(o_BxParam:AUTMOTBX)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Motivo da baixa nao foi informado."
			Conout("FFIEBW01 - mtdBaixaTit: Motivo da baixa nao foi informado.")
			//Volta a database
			DDATABASE:= d_DataBk
			Return(.T.)
		EndIf
	EndIf
	If (o_BxParam:AUTVALREC < 0) //.Or. (o_BxParam:AUTVALREC = 0)
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Valor recebido informado nao pode ser menor do que zero."
		Conout("FFIEBW01 - mtdBaixaTit: Valor recebido informado pode ser menor do que zero.")
		//Volta a database
		DDATABASE:= d_DataBk
		Return(.T.)
	EndIf
	If (o_BxParam:AUTMULTA < 0)
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Valor de multa informado nao eh valido."
		Conout("FFIEBW01 - mtdBaixaTit: Valor de multa informado nao eh valido.")
		//Volta a database
		DDATABASE:= d_DataBk
		Return(.T.)
	EndIf
	If (o_BxParam:AUTJUROS < 0)
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Valor de juros informado nao eh valido."
		Conout("FFIEBW01 - mtdBaixaTit: Valor de juros informado nao eh valido.")
		//Volta a database
		DDATABASE:= d_DataBk
		Return(.T.)
	EndIf
	If (o_BxParam:AUTDESCONT < 0)
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Valor de desconto informado nao eh valido."
		Conout("FFIEBW01 - mtdBaixaTit: Valor de desconto informado nao eh valido.")
		//Volta a database
		DDATABASE:= d_DataBk
		Return(.T.)
	EndIf
	If (o_BxParam:AUTACRESC < 0)
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Valor de acrescimo informado nao eh valido."
		Conout("FFIEBW01 - mtdBaixaTit: Valor de desconto informado nao eh valido.")
		//Volta a database
		DDATABASE:= d_DataBk
		Return(.T.)
	EndIf
	If (o_BxParam:AUTDECRESC < 0)
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Valor de descrescimo informado nao eh valido."
		Conout("FFIEBW01 - mtdBaixaTit: Valor de desconto informado nao eh valido.")
		//Volta a database
		DDATABASE:= d_DataBk
		Return(.T.)
	EndIf
	DBSELECTAREA("SA1")
	DBSETORDER(3)
	If !(DBSEEK(XFILIAL("SA1")+Alltrim(o_BxParam:CGC)))
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "CNPJ/CPF "+Alltrim(o_BxParam:CGC)+" nao encontrado na base de dados do protheus."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdBaixaTit: CNPJ/CPF "+Alltrim(o_BxParam:CGC)+" nao encontrado na base de dados do protheus.")
		//Volta a database
		DDATABASE:= d_DataBk
		Return(.T.)
	Else
		c_CliBx	:= SA1->A1_COD
		c_LojBx	:= SA1->A1_LOJA
	EndIf

	c_PreBx		:= PADR(Alltrim(o_BxParam:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1])
	c_NumBx		:= PADR(Alltrim(o_BxParam:E1_NUM), TAMSX3("E1_NUM")[1])
	c_ParBx		:= PADR(Alltrim(o_BxParam:E1_PARCELA), TAMSX3("E1_PARCELA")[1])
	c_TipBx		:= PADR(Alltrim(o_BxParam:E1_TIPO), TAMSX3("E1_TIPO")[1])
	c_xNumRM	:= PADR(Alltrim(o_BxParam:E5_XNUMRM), TAMSX3("E5_XNUMRM")[1])

	l_BancoValida:= .T.

	DBSELECTAREA("SE1")
	DBSETORDER(1)
	If !(DBSEEK(XFILIAL("SE1")+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx))
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Titulo nao encontrado com os parametros passados."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdBaixaTit: Titulo nao encontrado com os parametros passados.")
		//Volta a database
		DDATABASE:= d_DataBk
		Return(.T.)
	Else
		//Se o titulo foi baixado pela rotina de baixa por lote e a opercao eh de cancelamento ou exclusao
		//Nao valida o banco pq na baixa por lote, nao movimenta banco e os cammpo E5_BANCO, E5_AGENCIA e E5_CONTA ficam em branco.
		If !Empty(SE1->E1_FSLORM) .And. ((n_Operacao = 6) .OR. (n_Operacao = 5))
			l_BancoValida	:= .F.
			l_EncBxLo		:= .F. 
			l_LotRmBx		:= .F.
			//Verifica se a baixa a ser cancelada possui o Lote, para que a rotina gere o movimento no SE5 no valor correspondente. 04/11/2019			
			If !Empty(o_BxParam:XIDBAIXARM) //Se mandou o Id da baixa do Rm
				DBSELECTAREA("SE5")
				DBSETORDER(7)
				If Dbseek(xFilial("SE5")+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx)
					While !(SE5->(Eof())) .And. (SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA == xFilial("SE5")+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx)
						If (Alltrim(SE5->E5_FSBXRM) == Alltrim(o_BxParam:XIDBAIXARM)) //id da baixa do RM
							If (Alltrim(SE5->E5_ORIGEM) = 'RPC') 
								If( !Empty( SE5->E5_FSLORM ) ) //Significa que a baixa a ser cancelada foi originada por uma baixa por lote.
									l_EncBxLo:= .T.
									Exit
								EndIf
							EndIf
						EndIf
						SE5->(DbSkip())
					EndDo
					If (l_EncBxLo)
						l_LotRmBx:= .T. //Variavel que informa se vai gerar o registro no SE5 la embaixo.
					Else
						l_BancoValida	:= .T.
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

	c_Ban:= Padr(o_BxParam:AUTBANCO,TamSX3("E1_PORTADO")[1])
	c_Age:= Padr(o_BxParam:AUTAGENCIA,TamSX3("E5_AGENCIA")[1])
	c_Con:= Padr(o_BxParam:AUTCONTA,TamSX3("E5_CONTA")[1])
	
	If( Alltrim( o_BxParam:AUTMOTBX ) <> "CAR") //BAIXA DE CARTAO NAO MOVIMENTA BANCO (CASOS DO TEATRO SESI QUE NAO MANDA OS DADOS DO BANCO)
		If (l_BancoValida)
			DBSELECTAREA("SA6")
			DBSETORDER(1)
			If !DBSEEK(xFilial("SA6")+c_Ban+c_Age+c_Con)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "O banco/agencia/conta informado nao existe no cadastro de bancos: "+c_Ban+"/"+c_Age+"/"+c_Con
				Conout("FFIEBW01 - mtdBaixaTit: O banco/agencia/conta informado nao existe no cadastro de bancos: "+c_Ban+"/"+c_Age+"/"+c_Con)
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
		EndIf
	EndIf
	If (n_Operacao = 3) //BAIXA
		If !Empty(o_BxParam:XIDBAIXARM)
			//Validacao adicional da baixa
			l_IdBxSe5 := f_IDSE5(o_Empresa:c_Filial, Alltrim(o_BxParam:XIDBAIXARM), c_PreBx, c_NumBx, c_ParBx, c_TipBx, c_CliBx, c_LojBx, .F., "") //incrementdo para validar existencia do id da baixa na se5
			If l_IdBxSe5
				::o_Retorno:l_Status	:= .T.
				::o_Retorno:c_Mensagem	:= "ID RM("+Alltrim(o_BxParam:XIDBAIXARM)+") ja foi processado."
				Conout("FFIEBW01 - mtdBaixaTit: ID RM("+Alltrim(o_BxParam:XIDBAIXARM)+") ja foi processado.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			Else
				If (SE1->E1_SALDO = 0)
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "O titulo ("+SE1->E1_FILIAL+"-"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+"-"+SE1->E1_TIPO+"-"+SE1->E1_CLIENTE+"-"+SE1->E1_LOJA+") ja foi totalmente baixado."
					Conout("FFIEBW01 - mtdBaixaTit: O titulo ("+SE1->E1_FILIAL+"-"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+"-"+SE1->E1_TIPO+"-"+SE1->E1_CLIENTE+"-"+SE1->E1_LOJA+") ja foi totalmente baixado.")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				EndIf
			Endif
		Else
			If (SE1->E1_SALDO = 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "O titulo ("+SE1->E1_FILIAL+"-"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+"-"+SE1->E1_TIPO+"-"+SE1->E1_CLIENTE+"-"+SE1->E1_LOJA+") ja foi totalmente baixado."
				Conout("FFIEBW01 - mtdBaixaTit: O titulo ("+SE1->E1_FILIAL+"-"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+"-"+SE1->E1_TIPO+"-"+SE1->E1_CLIENTE+"-"+SE1->E1_LOJA+") ja foi totalmente baixado.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
		EndIf
		//Valida o desconto com o saldo do titulo 24/09/2019.
		If( o_BxParam:AUTVALREC > 0 )
			If( ( o_BxParam:AUTVALREC - ( o_BxParam:AUTMULTA + o_BxParam:AUTJUROS ) ) > ( SE1->E1_SALDO - o_BxParam:AUTDESCONT ) )
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "O Valor a ser baixado maior do que o valor pendente no titulo. ("+SE1->E1_FILIAL+"-"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+"-"+SE1->E1_TIPO+"-"+SE1->E1_CLIENTE+"-"+SE1->E1_LOJA+"). Saldo: "+ Alltrim( Str( SE1->E1_SALDO ) ) +". Valor informado: "+ Alltrim( Str( o_BxParam:AUTVALREC ) ) +" .Desconto: "+ Alltrim( Str( o_BxParam:AUTDESCONT ) ) +"."
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
		EndIf
	ElseIf (n_Operacao = 6) .OR. (n_Operacao = 5)  //EXCLUSAO
		If !Empty(o_BxParam:XIDBAIXARM) //ITEM 15 Valida se a baixa ja foi processada para retornar .T.
			c_Pre:= PADR(Alltrim(o_BxParam:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1])
			c_Num:= PADR(Alltrim(o_BxParam:E1_NUM), TAMSX3("E1_NUM")[1])
			c_Par:= PADR(Alltrim(o_BxParam:E1_PARCELA), TAMSX3("E1_PARCELA")[1])
			c_Tip:= PADR(Alltrim(o_BxParam:E1_TIPO), TAMSX3("E1_TIPO")[1])
			l_IdBxSe5 := f_IDSE5(o_Empresa:c_Filial, Alltrim(o_BxParam:XIDBAIXARM), c_Pre, c_Num, c_Par, c_Tip, c_CliBx, c_LojBx, .T., "")
			If ( l_IdBxSe5 ) //Retorna .T. se a baixa ja foi processada.
				::o_Retorno:l_Status	:= .T.
				::o_Retorno:c_Mensagem	:= "### A baixa do titulo (" + Alltrim( o_Empresa:c_Filial ) +'-'+ Alltrim( c_Pre ) +'-'+ Alltrim( c_Num ) +'-'+ Alltrim( c_Par ) +'-'+ Alltrim( c_Tip ) +'-'+ Alltrim( c_CliBx ) +'-'+ Alltrim( c_LojBx ) + ") ja foi processada. Id Bx Rm: " + Alltrim( o_BxParam:XIDBAIXARM ) +"###"
				Conout("FFIEBW01 - mtdBaixaTit: ### A baixa do titulo (" + Alltrim( o_Empresa:c_Filial ) +'-'+ Alltrim( c_Pre ) +'-'+ Alltrim( c_Num ) +'-'+ Alltrim( c_Par ) +'-'+ Alltrim( c_Tip ) +'-'+ Alltrim( c_CliBx ) +'-'+ Alltrim( c_LojBx ) + ") ja foi processada. Id Bx Rm: " + Alltrim( o_BxParam:XIDBAIXARM ) +"###")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			Endif//Fim do ITEM 15
		Else
			If (SE1->E1_SALDO == SE1->E1_VALOR)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "O titulo ("+SE1->E1_FILIAL+"-"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+"-"+SE1->E1_TIPO+"-"+SE1->E1_CLIENTE+"-"+SE1->E1_LOJA+") nao esta baixado, portanto nao podera realizar a exclusao da baixa."
				Conout("FFIEBW01 - mtdBaixaTit: O titulo ("+SE1->E1_FILIAL+"-"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+"-"+SE1->E1_TIPO+"-"+SE1->E1_CLIENTE+"-"+SE1->E1_LOJA+") nao esta baixado, portanto nao podera realizar a exclusao da baixa.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
		EndIf
	EndIf
	d_TesteData	:=	StoD(o_BxParam:AUTDTBAIXA)
	If valtype(d_TesteData) == "D"
		If Empty(d_TesteData)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe Data da baixa no formato [AAAAMMDD]."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdBaixaTit: Informe Data de emissao no formato [AAAAMMDD].")
			//Volta a database
			DDATABASE:= d_DataBk
			Return(.T.)
		EndIf
	Else
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Informe Data da baixa no formato [AAAAMMDD]."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdBaixaTit: Informe Data de emissao no formato [AAAAMMDD].")
		//Volta a database
		DDATABASE:= d_DataBk
		Return(.T.)
	EndIf
	d_TesteData	:=	StoD(o_BxParam:AUTDTCREDITO)
	If valtype(d_TesteData) == "D"
		If Empty(d_TesteData)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe Data do credito no formato [AAAAMMDD]."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdBaixaTit: Informe Data do credito no formato [AAAAMMDD].")
			//Volta a database
			DDATABASE:= d_DataBk
			Return(.T.)
		EndIf
	Else
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Informe Data do credito no formato [AAAAMMDD]."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdBaixaTit: Informe Data do credito no formato [AAAAMMDD].")
		//Volta a database
		DDATABASE:= d_DataBk
		Return(.T.)
	EndIf

	//Valida se o periodo esta bloqueado.
	c_Err:= ""
	d_TesteData	:=	StoD(o_BxParam:AUTDTBAIXA)
	If !( f_VldDtMov( "FIN", d_TesteData, @c_Err, "R" ) )
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= c_Err
		Conout("FFIEBW01 - mtdBaixaTit: "+c_Err)
		Return(.T.)
	EndIf
	l_TemRA:= .F.
	//If (n_Operacao = 3) //BAIXA
	DBSELECTAREA("SA1")
	DBSETORDER(3)
	If !(DBSEEK(XFILIAL("SA1")+Alltrim(o_BxParam:CGC)))
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "CNPJ/CPF "+Alltrim(o_BxParam:CGC)+" nao encontrado na base de dados do protheus."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdBaixaTit: CNPJ/CPF "+Alltrim(o_BxParam:CGC)+" nao encontrado na base de dados do protheus.")
		//Volta a database
		DDATABASE:= d_DataBk
		Return(.T.)
	Else
		c_CliBx	:= SA1->A1_COD
		c_LojBx	:= SA1->A1_LOJA
	EndIf

	c_PreBx:= PADR(Alltrim(o_BxParam:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1])
	c_NumBx:= PADR(Alltrim(o_BxParam:E1_NUM), TAMSX3("E1_NUM")[1])
	c_ParBx:= PADR(Alltrim(o_BxParam:E1_PARCELA), TAMSX3("E1_PARCELA")[1])
	c_TipBx:= PADR(Alltrim(o_BxParam:E1_TIPO), TAMSX3("E1_TIPO")[1])

	DBSELECTAREA("SE1")
	DBSETORDER(1)
	If !(DBSEEK(XFILIAL("SE1")+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx))
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Titulo da baixa nao encontrado com os parametros passados."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdBaixaTit: Titulo da baixa nao encontrado com os parametros passados.")
		//Volta a database
		DDATABASE:= d_DataBk
		Return(.T.)
	EndIf
	/* Comentado pois ja existe essa validacao logo acima!!!!!!
	If (n_Operacao = 3) //BAIXA
		If (SE1->E1_SALDO = 0)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "O titulo ("+SE1->E1_FILIAL+"-"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+"-"+SE1->E1_TIPO+"-"+SE1->E1_CLIENTE+"-"+SE1->E1_LOJA+") ja foi totalmente baixado."
			Conout("FFIEBW01 - mtdBaixaTit: O titulo ("+SE1->E1_FILIAL+"-"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+"-"+SE1->E1_TIPO+"-"+SE1->E1_CLIENTE+"-"+SE1->E1_LOJA+") ja foi totalmente baixado.")
			//Volta a database
			DDATABASE:= d_DataBk
			Return(.T.)
		EndIf
	Else	// (n_Operacao = 6) .OR. (n_Operacao = 5)  //EXCLUSAO ou CANCELAMENTO
		If(SE1->E1_SALDO == SE1->E1_VALOR)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "O titulo ("+SE1->E1_FILIAL+"-"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+"-"+SE1->E1_TIPO+"-"+SE1->E1_CLIENTE+"-"+SE1->E1_LOJA+") nao esta baixado, portanto nao podera realizar a exclusao da baixa."
			Conout("FFIEBW01 - mtdBaixaTit: O titulo ("+SE1->E1_FILIAL+"-"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+"-"+SE1->E1_TIPO+"-"+SE1->E1_CLIENTE+"-"+SE1->E1_LOJA+") nao esta baixado, portanto nao podera realizar a exclusao da baixa.")
			//Volta a database
			DDATABASE:= d_DataBk
			Return(.T.)
		EndIf			
	EndIf*/
	l_TemRA:= .F.
	//Testa se tem RA
	For p:= 1 To Len(o_TitRA:TITRAS)
		If !(Empty(o_TitRA:TITRAS[p]:E1_NUM)) .And. !(Empty(o_TitRA:TITRAS[p]:E1_TIPO))
			l_TemRA:= .T.
			Exit
		EndIf
	Next
	If (n_Operacao = 3)
		n_VrRA:= 0
		If (l_TemRA)
			//nao testa nada//
		Else
		 	If (o_BxParam:AUTVALREC = 0) .And. (o_BxParam:AUTDESCONT = 0) .And. (o_BxParam:AUTMULTA = 0) .And. (o_BxParam:AUTJUROS = 0)
			 	::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Nao e permitida a operacao pois nao foram informados valores para baixa."
				Conout("FFIEBW01 - mtdBaixaTit: Nao e permitida a operacao pois nao foram informados valores para baixa.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
		 	EndIf
		EndIf
		n_VrRA:= 0

		//Verifica se o motivo de baixa existe
		a_MotsBx:= ReadMotBx() //Carrega os motivos de baixas - Funcao padrao. Fonte FinxBx - fA070Grv()
		n_PosBx := Ascan(a_MotsBx, {|x| AllTrim(SubStr(x,1,3)) == AllTrim(Upper(o_BxParam:AUTMOTBX))})
		If n_PosBx > 0
			//Existe o motivo de baixa. Nao faz nada
		Else
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Motivo de baixa nao encontrado: "+Alltrim(o_BxParam:AUTMOTBX)+". Verficar o arquivo sigaadv.mot"
			Conout("FFIEBW01 - mtdBaixaTit: Motivo de baixa nao encontrado: "+Alltrim(o_BxParam:AUTMOTBX)+". Verficar o arquivo sigaadv.mot")
			//Volta a database
			DDATABASE:= d_DataBk
			Return(.T.)
		EndIf
	EndIf
	If (l_TemRA)//Se nao tem RA Verifica se o titulo teve baixa por compensacao
		If (n_Operacao = 6) .OR. (n_Operacao = 5)  //EXCLUSAO ou CANCELAMENTO
			//Verifica se o titulo teve baixa por compensacao
			c_Qry:= "SELECT TOP 1 E5_DOCUMEN, E5_RECPAG, R_E_C_N_O_, E5_TIPODOC"+chr(13)+chr(10)
			c_Qry+= "FROM "+RETSQLNAME("SE5")+" E5"+chr(13)+chr(10)
			c_Qry+= "WHERE E5_FILIAL = '"+CFILANT+"' "+chr(13)+chr(10)
			c_Qry+= "AND E5.D_E_L_E_T_ <> '*' "+chr(13)+chr(10)
			c_Qry+= "AND E5_RECPAG IN ('P') AND E5_MOTBX = 'CMP' "+chr(13)+chr(10)
			c_Qry+= "AND E5_DOCUMEN = '"+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_LOJA+"' ORDER BY R_E_C_N_O_ DESC "+chr(13)+chr(10)

			TCQUERY c_Qry ALIAS QRY NEW
			dbSelectArea("QRY")
			If !(QRY->(Eof())) .And. (Alltrim(QRY->E5_RECPAG) <> 'P') .And. (Alltrim(QRY->E5_TIPODOC) <> 'ES') //Quando o ultimo registro for P e ES eh pq houve o estorno da compenscao. Se houve o estorno, nao exibe a mensagem abaixo
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "O titulo ("+SE1->E1_FILIAL+"-"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+"-"+SE1->E1_TIPO+"-"+SE1->E1_CLIENTE+"-"+SE1->E1_LOJA+") sofreu baixa por compensacao porem nao foi informado o RA. Informe o RA para proceder com a exclusao da baixa do titulo."
				Conout("FFIEBW01 - mtdBaixaTit: O titulo ("+SE1->E1_FILIAL+"-"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+"-"+SE1->E1_TIPO+"-"+SE1->E1_CLIENTE+"-"+SE1->E1_LOJA+") sofreu baixa por compensacao porem nao foi informado o RA. Informe o RA para proceder com a exclusao da baixa do titulo.")
				dbSelectArea("QRY")
				QRY->(dbCloseArea())
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
			dbSelectArea("QRY")
			QRY->(dbCloseArea())
		EndIf
	EndIf
	c_Lote	:= ""
	If (l_TemRA)
		For p:= 1 To Len(o_TitRA:TITRAS)
			If Empty(o_TitRA:TITRAS[p]:E1_FILIAL)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe a filial do titulo de RA."
				Conout("FFIEBW01 - mtdBaixaTit: Informe a filial do titulo de RA.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
				Exit
			ElseIf Empty(o_TitRA:TITRAS[p]:E1_NUM)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe o numero do titulo de RA."
				Conout("FFIEBW01 - mtdBaixaTit: Informe o numero do titulo de RA.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
				Exit
			ElseIf Empty(o_TitRA:TITRAS[p]:E1_TIPO)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe o tipo do titulo de RA."
				Conout("FFIEBW01 - mtdBaixaTit: Informe o tipo do titulo de RA.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
				Exit
			ElseIf (o_TitRA:TITRAS[p]:VALORRA <= 0)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe o valor do titulo de RA."
				Conout("FFIEBW01 - mtdBaixaTit: Informe o valor do titulo de RA.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
				Exit
			EndIf
			If (Upper(Alltrim(o_TitRA:TITRAS[p]:E1_TIPO)) <> "RA") .And. (Upper(Alltrim(o_TitRA:TITRAS[p]:E1_TIPO)) <> "NCC")
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Tipo invalido. Informar RA ou NCC"
				Conout("FFIEBW01 - mtdBaixaTit: Tipo invalido. Informar RA ou NCC")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
				Exit
			EndIf
			c_Pre:= PADR(Alltrim(o_TitRA:TITRAS[p]:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1])
			c_Num:= PADR(Alltrim(o_TitRA:TITRAS[p]:E1_NUM), TAMSX3("E1_NUM")[1])
			c_Par:= PADR(Alltrim(o_TitRA:TITRAS[p]:E1_PARCELA), TAMSX3("E1_PARCELA")[1])
			c_Tip:= PADR(Alltrim(o_TitRA:TITRAS[p]:E1_TIPO), TAMSX3("E1_TIPO")[1])

			DBSELECTAREA("SE1")
			DBSETORDER(1)
			If !(DBSEEK(Alltrim(o_TitRA:TITRAS[p]:E1_FILIAL)+c_Pre+c_Num+c_Par+c_Tip+c_CliBx+c_LojBX))
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Titulo de RA ou NCC ("+Alltrim(o_TitRA:TITRAS[p]:E1_FILIAL)+c_Pre+c_Num+c_Par+c_Tip+c_CliBx+c_LojBX+") nao encontrado com os parametros passados."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdBaixaTit: Titulo de RA ou NCC ("+Alltrim(o_TitRA:TITRAS[p]:E1_FILIAL)+c_Pre+c_Num+c_Par+c_Tip+c_CliBx+c_LojBX+") nao encontrado com os parametros passados.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			Else
				If (n_Operacao = 3) //BAIXA
					If (SE1->E1_SALDO = 0)
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "O titulo de RA ("+SE1->E1_FILIAL+"-"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+"-"+SE1->E1_TIPO+"-"+SE1->E1_CLIENTE+"-"+SE1->E1_LOJA+") ja foi totalmente baixado."
						Conout("FFIEBW01 - mtdBaixaTit: O titulo de RA ("+SE1->E1_FILIAL+"-"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+"-"+SE1->E1_TIPO+"-"+SE1->E1_CLIENTE+"-"+SE1->E1_LOJA+") ja foi totalmente baixado.")
						//Volta a database
						DDATABASE:= d_DataBk
						Return(.T.)
					ElseIf ( o_TitRA:TITRAS[p]:VALORRA > SE1->E1_SALDO)
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "O valor informado para compensacao eh superior ao saldo do RA ("+SE1->E1_FILIAL+"-"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+"-"+SE1->E1_TIPO+"-"+SE1->E1_CLIENTE+"-"+SE1->E1_LOJA+")."
						Conout("FFIEBW01 - mtdBaixaTit: O valor informado para compensacao eh superior ao saldo do RA ("+SE1->E1_FILIAL+"-"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+"-"+SE1->E1_TIPO+"-"+SE1->E1_CLIENTE+"-"+SE1->E1_LOJA+").")
						//Volta a database
						DDATABASE:= d_DataBk
						Return(.T.)
					EndIf
				Else// (n_Operacao = 6) .OR. (n_Operacao = 5)
					If (SE1->E1_SALDO == SE1->E1_VALOR)
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "O titulo de RA ("+SE1->E1_FILIAL+"-"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+"-"+SE1->E1_TIPO+"-"+SE1->E1_CLIENTE+"-"+SE1->E1_LOJA+") nao sofreu baixa para ser utilizado na rotina de exclusao da compensacao."
						Conout("FFIEBW01 - mtdBaixaTit: O titulo de RA ("+SE1->E1_FILIAL+"-"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+"-"+SE1->E1_TIPO+"-"+SE1->E1_CLIENTE+"-"+SE1->E1_LOJA+") nao sofreu baixa para ser utilizado na rotina de exclusao da compensacao.")
						//Volta a database
						DDATABASE:= d_DataBk
						Return(.T.)
					Else
						DbSelectArea("SE5")
						DbSetOrder(10) //E5_FILIAL, E5_DOCUMEN (CFILANT)
						//If !(DbSeek(Alltrim(o_TitRA:TITRAS[p]:E1_FILIAL)+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_LOJA)) //Quando o RA eh compensado, a rotina grava no E5_DOCUMEN essa chave SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+E1->E1_LOJA
						If !(DbSeek(o_Empresa:c_Filial+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_LOJA)) //Quando o RA eh compensado, a rotina grava no E5_DOCUMEN essa chave SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+E1->E1_LOJA
							::o_Retorno:l_Status	:= .F.
							::o_Retorno:c_Mensagem	:= "O titulo de RA ("+SE1->E1_FILIAL+"-"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+"-"+SE1->E1_TIPO+"-"+SE1->E1_CLIENTE+"-"+SE1->E1_LOJA+") nao sofreu baixa por este titulo: "+SE1->E1_FILIAL+"-"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+"-"+SE1->E1_TIPO+"-"+SE1->E1_CLIENTE+"-"+SE1->E1_LOJA
							Conout("FFIEBW01 - mtdBaixaTit: O titulo de RA ("+SE1->E1_FILIAL+"-"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+"-"+SE1->E1_TIPO+"-"+SE1->E1_CLIENTE+"-"+SE1->E1_LOJA+") nao sofreu baixa por este titulo: "+SE1->E1_FILIAL+"-"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+"-"+SE1->E1_TIPO+"-"+SE1->E1_CLIENTE+"-"+SE1->E1_LOJA)
							//Volta a database
							DDATABASE:= d_DataBk
							Return(.T.)
						EndIf
					EndIf
				EndIf
			EndIf
		Next
		a_RasRec	:= {}
		If (n_Operacao = 3) //BAIXA
			d_Aux:= DDATABASE
			//FAZ A BAIXA DOS RAS
			For p:= 1 To Len(o_TitRA:TITRAS)
				l_Erro	:= .F.
				aRecRA	:= {}
				aTxMoeda:= {}
				aRecSE1	:= {}
				n_ValRa	:= 0

				c_Pre:= PADR(Alltrim(o_TitRA:TITRAS[p]:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1])
				c_Num:= PADR(Alltrim(o_TitRA:TITRAS[p]:E1_NUM), TAMSX3("E1_NUM")[1])
				c_Par:= PADR(Alltrim(o_TitRA:TITRAS[p]:E1_PARCELA), TAMSX3("E1_PARCELA")[1])
				c_Tip:= PADR(Alltrim(o_TitRA:TITRAS[p]:E1_TIPO), TAMSX3("E1_TIPO")[1])

				dbSelectArea("SE1")
				dbSetOrder(2) // E1_FILIAL, E1_CLIENTE, E1_LOJA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
				IF dbSeek(Alltrim(o_TitRA:TITRAS[p]:E1_FILIAL)+c_CliBx+c_LojBx+c_Pre+c_Num+c_Par+c_Tip) //Posiciona no RA NA FILIAL PASSADA
					nRecnoRA�:= RECNO()
					aAdd(aRecRA,nRecnoRA)
					aAdd(a_RasRec,nRecnoRA)
					//aAdd(a_ValRa,o_TitRA:TITRAS[p]:VALORRA) //SE1->E1_SALDO
					n_ValRa:= o_TitRA:TITRAS[p]:VALORRA
				EndIf

				dbSelectArea("SE1")
				dbSetOrder(2)�// E1_FILIAL, E1_CLIENTE, E1_LOJA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
				dbSeek(XFILIAL("SE1")+c_CliBx+c_LojBx+c_PreBx+c_NumBx+c_ParBx+c_TipBx)//Posiciona no titulo a ser baixado
				nRecnoE1�	:= RECNO()

				PERGUNTE("AFI340",.F.)
				lContabiliza:= MV_PAR11 == 1
				lAglutina� �:= MV_PAR08 == 1
				lDigita���	:= MV_PAR09 == 1
				nTaxaCM 	:= RecMoeda(dDataBase,SE1->E1_MOEDA)
				aAdd(aTxMoeda, {1, 1} )
				aAdd(aTxMoeda, {2, nTaxaCM} )

				SE1->(dbSetOrder(1))�//E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_FORNECE+E1_LOJA
				��
				aRecSE1�:= { nRecnoE1 }
				DDATABASE:= Stod(o_BxParam:AUTDTBAIXA) //Grava a compenscao com a data da baixa.
				If !MaIntBxCR(3,aRecSE1,,aRecRA,,{lContabiliza,lAglutina,lDigita,.F.,.F.,.F.},,,,,n_ValRa )
					l_Erro:= .T.
					Exit
				Else

					/*INICIO Grava o numero do Rm e o ID da baixa quando existe uma baixa por compensacao.*/

					//Busca o recno do RA da compensacao para gravar o numero do id da baixa do RM
					c_Qry:= "SELECT max(R_E_C_N_O_) AS REC "+chr(13)+chr(10)
					c_Qry+= "FROM "+RETSQLNAME("SE5")+" E5"+chr(13)+chr(10)
					c_Qry+= "WHERE E5_FILIAL = '"+o_Empresa:c_Filial+"' "+chr(13)+chr(10)
					c_Qry+= "AND E5.D_E_L_E_T_ = '' "+chr(13)+chr(10)
					c_Qry+= "AND E5_RECPAG = 'R' AND E5_MOTBX = 'CMP' AND E5_TIPODOC = 'BA' "+chr(13)+chr(10)
					c_Qry+= "AND E5_PREFIXO = '"+c_Pre+"' "+chr(13)+chr(10) //PREFIXO DO RA
					c_Qry+= "AND E5_NUMERO = '"+c_Num+"'"+chr(13)+chr(10)	//NUMERO DO RA
					c_Qry+= "AND E5_PARCELA = '"+c_Par+"' "+chr(13)+chr(10)	//PARCELA DO RA
					c_Qry+= "AND E5_TIPO = '"+c_Tip+"' "+chr(13)+chr(10)	//TIPO DO RA
					c_Qry+= "AND E5_DOCUMEN = '"+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_LojBx+"' "+chr(13)+chr(10) //chave do titulo que foi compensado
					c_Qry+= "AND E5_DATA = '"+o_BxParam:AUTDTBAIXA+"' "+chr(13)+chr(10)
					TCQUERY c_Qry ALIAS QRY NEW
					dbSelectArea("QRY")
					If !(QRY->(Eof()))
						DbSelectArea("SE5")
						DbGoto(QRY->REC)
						//Garante que posicionou no registro da compensacao
						If (SE5->(Recno()) = QRY->REC) .And. (SE5->E5_RECPAG = 'R') .And. (SE5->E5_MOTBX = 'CMP') .And. (SE5->E5_TIPODOC = 'BA') .And. (SE5->E5_PREFIXO = c_Pre) .And. (SE5->E5_NUMERO = c_Num) .And. (SE5->E5_PARCELA = c_Par) .And. (SE5->E5_TIPO = c_Tip) .And. (Alltrim(SE5->E5_DOCUMEN) = Alltrim(c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_LojBx)) .And. (SE5->E5_DATA = Stod(o_BxParam:AUTDTBAIXA))
							RecLock("SE5",.F.)
							SE5->E5_XNUMRM	:= PADR( c_xNumRM, TAMSX3( "E5_XNUMRM" )[ 1 ] )
							SE5->E5_FSBXRM	:= Alltrim(o_BxParam:XIDBAIXARM)//id da baixa do RM
							MsUnLock()
						EndIf
					EndIf
					dbSelectArea("QRY")
					QRY->(dbCloseArea())

					//Busca o recno do Titulo da compensacao para gravar o numero do id da baixa do RM
					c_Qry:= "SELECT max(R_E_C_N_O_) AS REC "+chr(13)+chr(10)
					c_Qry+= "FROM "+RETSQLNAME("SE5")+" E5"+chr(13)+chr(10)
					c_Qry+= "WHERE E5_FILIAL = '"+o_Empresa:c_Filial+"' "+chr(13)+chr(10)
					c_Qry+= "AND E5.D_E_L_E_T_ = '' "+chr(13)+chr(10)
					c_Qry+= "AND E5_RECPAG = 'R' AND E5_MOTBX = 'CMP' AND E5_TIPODOC = 'CP' "+chr(13)+chr(10)
					c_Qry+= "AND E5_PREFIXO = '"+c_PreBx+"' "+chr(13)+chr(10) //PREFIXO DO TITULO
					c_Qry+= "AND E5_NUMERO = '"+c_NumBx+"'"+chr(13)+chr(10)	//NUMERO DO TITULO
					c_Qry+= "AND E5_PARCELA = '"+c_ParBx+"' "+chr(13)+chr(10)	//PARCELA DO TITULO
					c_Qry+= "AND E5_TIPO = '"+c_TipBx+"' "+chr(13)+chr(10)	//TIPO DO TITULO
					c_Qry+= "AND E5_DOCUMEN = '"+c_Pre+c_Num+c_Par+c_Tip+c_LojBx+"' "+chr(13)+chr(10) //chave do RA que foi compensado
					c_Qry+= "AND E5_DATA = '"+o_BxParam:AUTDTBAIXA+"' "+chr(13)+chr(10)
					TCQUERY c_Qry ALIAS QRY NEW
					dbSelectArea("QRY")
					If !(QRY->(Eof()))
						DbSelectArea("SE5")
						DbGoto(QRY->REC)
						//Garante que posicionou no registro da compensacao
						If (SE5->(Recno()) = QRY->REC) .And. (SE5->E5_RECPAG = 'R') .And. (SE5->E5_MOTBX = 'CMP') .And. (SE5->E5_TIPODOC = 'CP') .And. (SE5->E5_PREFIXO = c_PreBx) .And. (SE5->E5_NUMERO = c_NumBx) .And. (SE5->E5_PARCELA = c_ParBx) .And. (SE5->E5_TIPO = c_TipBx) .And. (Alltrim(SE5->E5_DOCUMEN) = Alltrim(c_Pre+c_Num+c_Par+c_Tip+c_LojBx)) .And. (SE5->E5_DATA = Stod(o_BxParam:AUTDTBAIXA))
							RecLock("SE5",.F.)
							SE5->E5_XNUMRM	:= PADR( c_xNumRM, TAMSX3( "E5_XNUMRM" )[ 1 ] )
							SE5->E5_FSBXRM	:= Alltrim(o_BxParam:XIDBAIXARM)//id da baixa do RM
							MsUnLock()
						EndIf
					EndIf
					dbSelectArea("QRY")
					QRY->(dbCloseArea())

					/*FIM  Grava o numero do Rm e o ID da baixa quando existe uma baixa por compensacao.*/
				EndIf
			Next
			If (l_Erro)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Nao foi possivel a compensacao do titulo do adiantamento"
				Conout("FFIEBW01 - mtdBaixaTit: Nao foi possivel a compensacao do titulo do adiantamento.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			Else
				l_Compensou:= .T.
				//Verifica se ainda sobrou saldo no titulo.
				DBSELECTAREA("SE1")
				DBSETORDER(1)
				DBSEEK(XFILIAL("SE1")+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx)
				If (SE1->E1_SALDO > 0)
					l_Sobrou:= .T.
				Else
					l_Sobrou:= .F.
				EndIf
			EndIf
		Else // (n_Operacao = 6) .OR. (n_Operacao = 5)
			For p:= 1 To Len(o_TitRA:TITRAS)
				c_Pre:= PADR(Alltrim(o_TitRA:TITRAS[p]:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1])
				c_Num:= PADR(Alltrim(o_TitRA:TITRAS[p]:E1_NUM), TAMSX3("E1_NUM")[1])
				c_Par:= PADR(Alltrim(o_TitRA:TITRAS[p]:E1_PARCELA), TAMSX3("E1_PARCELA")[1])
				c_Tip:= PADR(Alltrim(o_TitRA:TITRAS[p]:E1_TIPO), TAMSX3("E1_TIPO")[1])
				dbSelectArea("SE1")
				dbSetOrder(2)�// E1_FILIAL, E1_CLIENTE, E1_LOJA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
				IF dbSeek(Alltrim(o_TitRA:TITRAS[p]:E1_FILIAL)+c_CliBx+c_LojBx+c_Pre+c_Num+c_Par+c_Tip) //Posiciona no RA NA FILIAL PASSADA
					aAdd(a_RasRec,RECNO())
				EndIf
			Next
			c_PreBx:= PADR(Alltrim(o_BxParam:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1])
			c_NumBx:= PADR(Alltrim(o_BxParam:E1_NUM), TAMSX3("E1_NUM")[1])
			c_ParBx:= PADR(Alltrim(o_BxParam:E1_PARCELA), TAMSX3("E1_PARCELA")[1])
			c_TipBx:= PADR(Alltrim(o_BxParam:E1_TIPO), TAMSX3("E1_TIPO")[1])

			//DBSELECTAREA("SE1")
			//DBSETORDER(1)
			//DBSEEK(XFILIAL("SE1")+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx)
			
			Begin Transaction
				For p:= 1 To Len(o_TitRA:TITRAS)
					n_CmpRecSE5:= 0
					c_Pre:= PADR(Alltrim(o_TitRA:TITRAS[p]:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1])
					c_Num:= PADR(Alltrim(o_TitRA:TITRAS[p]:E1_NUM), TAMSX3("E1_NUM")[1])
					c_Par:= PADR(Alltrim(o_TitRA:TITRAS[p]:E1_PARCELA), TAMSX3("E1_PARCELA")[1])
					c_Tip:= PADR(Alltrim(o_TitRA:TITRAS[p]:E1_TIPO), TAMSX3("E1_TIPO")[1])
					
					//Busca o recno do Titulo da compensacao para verificar se a data da compensacao esta fechada o periodo
					c_Qry:= "SELECT max(R_E_C_N_O_) AS REC "+chr(13)+chr(10)
					c_Qry+= "FROM "+RETSQLNAME("SE5")+" E5"+chr(13)+chr(10)
					c_Qry+= "WHERE E5_FILIAL = '"+o_Empresa:c_Filial+"' "+chr(13)+chr(10)
					c_Qry+= "AND E5.D_E_L_E_T_ = '' "+chr(13)+chr(10)
					c_Qry+= "AND E5_RECPAG = 'R' AND E5_MOTBX = 'CMP' AND E5_TIPODOC = 'CP' "+chr(13)+chr(10)
					c_Qry+= "AND E5_PREFIXO = '"+c_PreBx+"' "+chr(13)+chr(10) //PREFIXO DO TITULO
					c_Qry+= "AND E5_NUMERO = '"+c_NumBx+"'"+chr(13)+chr(10)	//NUMERO DO TITULO
					c_Qry+= "AND E5_PARCELA = '"+c_ParBx+"' "+chr(13)+chr(10)	//PARCELA DO TITULO
					c_Qry+= "AND E5_TIPO = '"+c_TipBx+"' "+chr(13)+chr(10)	//TIPO DO TITULO
					c_Qry+= "AND E5_DOCUMEN = '"+c_Pre+c_Num+c_Par+c_Tip+c_LojBx+"' "+chr(13)+chr(10) //chave do RA que foi compensado
					TCQUERY c_Qry ALIAS QRY NEW
					dbSelectArea("QRY")
					If !(QRY->(Eof()))
						DbSelectArea("SE5")
						DbGoto(QRY->REC)
						n_CmpRecSE5:= SE5->( Recno() ) 
						aDtMov	:=	{}
						aDtMov	:= {'','','','','',Dtoc( Stod( o_BxParam:AUTDTBAIXA ) ) }
						If( !Fa330VldDt( aDtMov,5 ) ) //Funcao no fonte FINA330 que chama DtMovFin no FINXFIN. Este tratamento e feito na rotina padrao. Eu passo 5 pq 4 = excluir e nessa opcao o mv_datafin bloqueia pela data do se5
							dbSelectArea("QRY")
							QRY->(dbCloseArea())				
							::o_Retorno:l_Status	:= .F.
							::o_Retorno:c_Mensagem	:= "Processo ou periodo financeiro bloqueado para movimentacoes nesta data "+Substr( o_BxParam:AUTDTBAIXA, 7 , 2 )+"/"+Substr( o_BxParam:AUTDTBAIXA, 5 , 2 )+"/"+Substr( o_BxParam:AUTDTBAIXA, 1 , 4 ) +" (data do estorno da compensacao informada)."
							Conout("FFIEBW01 - mtdBaixaTit: "+c_Err)
							Return(.T.)
						Else
							dbSelectArea("QRY")
							QRY->(dbCloseArea())
							//posiciona no titulo principal
							dbSelectArea("SE1")
							dbSetOrder(2)�// E1_FILIAL, E1_CLIENTE, E1_LOJA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
							dbSeek(XFILIAL("SE1")+c_CliBx+c_LojBx+c_PreBx+c_NumBx+c_ParBx+c_TipBx)//Posiciona no titulo a ser baixado
							aSE1 := {}
							aSE1 := { SE1->( Recno() ) }
							
							DbSelectArea("SE5")
							DbGoto( n_CmpRecSE5 )
							aEstorno:= {}
							aAdd(aEstorno, {{SE5->E5_DOCUMEN},SE5->E5_SEQ, Alltrim(o_TitRA:TITRAS[p]:E1_FILIAL)})
							//Cancela a compensacao
							DDATABASE:= STOD(o_BxParam:AUTDTBAIXA)
							If u_xMaIntBxCR( 3 , aSE1,,,, {.T.,.F.,.F.,.F.,.F.,.F.},, aEstorno )
								l_Ret:= .T.
							Else
								l_Ret:= .F.
								DisarmTransaction()
								Exit
							EndIf
						EndIf
					Else
						dbSelectArea("QRY")
						QRY->(dbCloseArea())
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "Nao foi possivel encontrar de registro SE5 a ser estoanado."
						//Volta a database
						DDATABASE:= d_DataBk
						Return(.T.)
					EndIf			
					/*
					c_Pre:= PADR(Alltrim(o_TitRA:TITRAS[p]:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1])
					c_Num:= PADR(Alltrim(o_TitRA:TITRAS[p]:E1_NUM), TAMSX3("E1_NUM")[1])
					c_Par:= PADR(Alltrim(o_TitRA:TITRAS[p]:E1_PARCELA), TAMSX3("E1_PARCELA")[1])
					c_Tip:= PADR(Alltrim(o_TitRA:TITRAS[p]:E1_TIPO), TAMSX3("E1_TIPO")[1])
					dbSelectArea("SE1")
					dbSetOrder(2)�// E1_FILIAL, E1_CLIENTE, E1_LOJA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
					IF dbSeek(Alltrim(o_TitRA:TITRAS[p]:E1_FILIAL)+c_CliBx+c_LojBx+c_Pre+c_Num+c_Par+c_Tip) //Posiciona no RA NA FILIAL PASSADA
						l_Ret:= Fina330(4,.T.)
					EndIf
					*/
				Next
			End Transaction
			If (l_Ret)
				l_Compensou:= .T.
				//Verifica se ainda sobrou saldo no titulo.
				DBSELECTAREA("SE1")
				DBSETORDER(1)
				DBSEEK(XFILIAL("SE1")+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx)
				If (SE1->E1_SALDO > 0) .And. (SE1->E1_SALDO < SE1->E1_VALOR)
					l_Sobrou:= .T.
				Else
					l_Sobrou:= .F.
				EndIf
			Else
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Nao foi possivel o estorno da compensacao do titulo do adiantamento"
				Conout("FFIEBW01 - mtdBaixaTit: Nao foi possivel o estorno da compensacao do titulo do adiantamento.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
		EndIf
	EndIf

	If !(l_Sobrou)
		c_NRas:= ""
		For u:= 1 To Len(a_RasRec)
			DbSelectArea("SE1")
			DbGoto(a_RasRec[u])
			c_NRas+= Alltrim(SE1->E1_NUM)+"-"
		Next
		c_NRas:= Substr(c_NRas,1,Len(c_NRas)-1)
		If (n_Operacao = 3)
			c_Mens:= "Titulo compensado totalmente ("+c_PreBx+"-"+c_NumBx+"-"+c_TipBx+"-"+c_ParBx+"-"+c_CliBx+"-"+c_LojBx+") na filial "+o_Empresa:c_Filial+" pelos RAs ("+c_NRas+")."
		ElseIf (n_Operacao = 6)
			c_Mens:= "Exclusao da compensacao do titulo ("+c_PreBx+"-"+c_NumBx+"-"+c_TipBx+"-"+c_ParBx+"-"+c_CliBx+"-"+c_LojBx+") na filial "+o_Empresa:c_Filial+" pelos RAs ("+c_NRas+")."
		Else
			c_Mens:= "Cancelamento da compensacao do titulo ("+c_PreBx+"-"+c_NumBx+"-"+c_TipBx+"-"+c_ParBx+"-"+c_CliBx+"-"+c_LojBx+") na filial "+o_Empresa:c_Filial+" pelos RAs ("+c_NRas+")."
		EndIf
		::o_Retorno:l_Status	:= .T.
		::o_Retorno:c_Mensagem	:= c_Mens
		Conout("FFIEBW01 - mtdBaixaTit: "+c_Mens)
		//Grava o E5_LA = S 03/09/2020. Esse ponto e a parte quanto tem compensacao 100%.
		f_GravaLA( o_Empresa:c_Filial, PADR(Alltrim(o_BxParam:E1_NUM), TAMSX3("E1_NUM")[1]), Alltrim(o_BxParam:XIDBAIXARM) )
		//Chama a funcao tambem quanto tiver RA (compensacao)
		c_NumRA:= ""
		For p:= 1 To Len(o_TitRA:TITRAS)
			c_NumRA:= PADR(Alltrim(o_TitRA:TITRAS[p]:E1_NUM), TAMSX3("E1_NUM")[1])
			f_GravaLA( o_Empresa:c_Filial, c_NumRA, Alltrim(o_BxParam:XIDBAIXARM) ) //Passa a filial do titulo pois quando o Ra esta em outra filial, o E5_FILIAL fica com a filail do titulo. E o E5_FILORIG com a filial do RA
		Next
	Else
		If (n_Operacao = 3) .And. (o_BxParam:AUTVALREC = 0) .And. (o_BxParam:AUTDESCONT = 0) .And. (o_BxParam:AUTMULTA = 0) .And. (o_BxParam:AUTJUROS = 0) //se nao passou o valor da baixa. Para os casos de baixar com ra apenas
			If Len(a_RasRec) = 0
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Para baixa com valor recebido igual a zero, e obrigatorio informar os dados do RA."
				Conout("FFIEBW01 - mtdBaixaTit: Para baixa com valor recebido igual a zero, e obrigatorio informar os dados do RA.")
			Else
				For u:= 1 To Len(a_RasRec)
					DbSelectArea("SE1")
					DbGoto(a_RasRec[u])
					c_NRas+= Alltrim(SE1->E1_NUM)+"-"
				Next
				c_NRas:= Substr(c_NRas,1,Len(c_NRas)-1)
				::o_Retorno:l_Status	:= .T.
				::o_Retorno:c_Mensagem	:= "Titulo ("+c_PreBx+"-"+c_NumBx+"-"+c_TipBx+"-"+c_ParBx+"-"+c_CliBx+"-"+c_LojBx+") baixado parcialmente na filial "+o_Empresa:c_Filial+" com compensacao dos RAs ("+c_NRas+")."
				Conout("FFIEBW01 - mtdBaixaTit: Titulo ("+c_PreBx+"-"+c_NumBx+"-"+c_TipBx+"-"+c_ParBx+"-"+c_CliBx+"-"+c_LojBx+") baixado parcialmente na filial "+o_Empresa:c_Filial+" com compensacao dos RAs ("+c_NRas+")")
			EndIf

			f_GravaLA( o_Empresa:c_Filial, PADR(Alltrim(o_BxParam:E1_NUM), TAMSX3("E1_NUM")[1]), Alltrim(o_BxParam:XIDBAIXARM) )
			//Chama a funcao tambem quanto tiver RA (compensacao)
			c_NumRA:= ""
			For p:= 1 To Len(o_TitRA:TITRAS)
				c_NumRA:= PADR(Alltrim(o_TitRA:TITRAS[p]:E1_NUM), TAMSX3("E1_NUM")[1])
				f_GravaLA( o_Empresa:c_Filial, c_NumRA, Alltrim(o_BxParam:XIDBAIXARM) ) //Passa a filial do titulo pois quando o Ra esta em outra filial, o E5_FILIAL fica com a filail do titulo. E o E5_FILORIG com a filial do RA
			Next

		ElseIf (n_Operacao = 5) .And. (o_BxParam:AUTVALREC = 0) .And. (o_BxParam:AUTDESCONT = 0) .And. (o_BxParam:AUTMULTA = 0) .And. (o_BxParam:AUTJUROS = 0) //se nao passou o valor da baixa. Para os casos de cancelamento da baixar com ra apenas
		 	If Len(a_RasRec) = 0
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Para cancelamento da baixa com valor recebido igual a zero, e obrigatorio informar os dados do RA."
				Conout("FFIEBW01 - mtdBaixaTit: Para cancelamento da baixa com valor recebido igual a zero, e obrigatorio informar os dados do RA.")
			Else
			 	For u:= 1 To Len(a_RasRec)
					DbSelectArea("SE1")
					DbGoto(a_RasRec[u])
					c_NRas+= Alltrim(SE1->E1_NUM)+"-"
				Next
				c_NRas:= Substr(c_NRas,1,Len(c_NRas)-1)
				::o_Retorno:l_Status	:= .T.
				::o_Retorno:c_Mensagem	:= "Cancelamento da compensacao do titulo ("+c_PreBx+"-"+c_NumBx+"-"+c_TipBx+"-"+c_ParBx+"-"+c_CliBx+"-"+c_LojBx+") na filial "+o_Empresa:c_Filial+" pelos RAs ("+c_NRas+")."
				Conout("FFIEBW01 - mtdBaixaTit: Cancelamento da compensacao do titulo ("+c_PreBx+"-"+c_NumBx+"-"+c_TipBx+"-"+c_ParBx+"-"+c_CliBx+"-"+c_LojBx+") na filial "+o_Empresa:c_Filial+" pelos RAs ("+c_NRas+").")
			EndIf

			f_GravaLA( o_Empresa:c_Filial, PADR(Alltrim(o_BxParam:E1_NUM), TAMSX3("E1_NUM")[1]), Alltrim(o_BxParam:XIDBAIXARM) )
			//Chama a funcao tambem quanto tiver RA (compensacao)
			c_NumRA:= ""
			For p:= 1 To Len(o_TitRA:TITRAS)
				c_NumRA:= PADR(Alltrim(o_TitRA:TITRAS[p]:E1_NUM), TAMSX3("E1_NUM")[1])
				f_GravaLA( o_Empresa:c_Filial, c_NumRA, Alltrim(o_BxParam:XIDBAIXARM) ) //Passa a filial do titulo pois quando o Ra esta em outra filial, o E5_FILIAL fica com a filail do titulo. E o E5_FILORIG com a filial do RA
			Next
		Else
			If (n_Operacao = 3) .And. (l_TemRA)//BAIXA
				DDATABASE:= d_Aux
			ElseIf (n_Operacao = 5) .Or. (n_Operacao = 6)//Cancelamento ou estorno da baixa
				DDATABASE:= STOD(o_BxParam:AUTDTBAIXA)

				//Verifica se o titulo foi baixado pela rotina de baixa por lote, para gerar o movimento bancario a pagar
				DBSELECTAREA("SE1")
				DBSETORDER(1)
				If (DBSEEK(XFILIAL("SE1")+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx))
					If !Empty(SE1->E1_FSLORM) .And. (l_LotRmBx)
						c_Lote:= SE1->E1_FSLORM
					EndIf
				EndIf

			EndIf
			c_MotBx   := Alltrim(o_BxParam:AUTMOTBX)
			d_DtBaixa := STOD(o_BxParam:AUTDTBAIXA)
			d_DtCred  := STOD(o_BxParam:AUTDTCREDITO)
			c_Hist    := PADR(Alltrim(o_BxParam:AUTHIST), TAMSX3("E5_HISTOR")[1])
			n_Descont := o_BxParam:AUTDESCONT
			n_Multa   := o_BxParam:AUTMULTA
			n_Juros   := o_BxParam:AUTJUROS
			n_ValRec  := o_BxParam:AUTVALREC
			n_Acres   := o_BxParam:AUTACRESC
			n_Decres  := o_BxParam:AUTDECRESC

			a_Baixa := {{"E1_PREFIXO"  	,PADR(c_PreBx	, TAMSX3("E1_PREFIXO")[1])	,Nil},;
						{"E1_NUM"		,PADR(c_NumBx	, TAMSX3("E1_NUM")[1])		,Nil},;
						{"E1_PARCELA"	,PADR(c_ParBx	, TAMSX3("E1_PARCELA")[1])	,Nil},;
						{"E1_TIPO"		,PADR(c_TipBx	, TAMSX3("E1_TIPO")[1])		,Nil},;
						{"E1_CLIENTE"	,PADR(c_CliBx	, TAMSX3("E1_CLIENTE")[1])	,Nil},;
						{"E1_LOJA"		,PADR(c_LojBx	, TAMSX3("E1_LOJA")[1])		,Nil},;
						{"AUTMOTBX"		,PADR(c_MotBx	, TAMSX3("E5_MOTBX")[1])	,Nil},;
						{"AUTBANCO"		,c_Ban		,Nil},;
						{"AUTAGENCIA"	,c_Age		,Nil},;
						{"AUTCONTA"		,c_Con		,Nil},;
						{"AUTDTBAIXA"	,d_DtBaixa	,Nil},;
						{"AUTDTCREDITO"	,d_DtCred	,Nil},;
						{"AUTHIST"		,c_Hist		,Nil},;
						{"AUTDESCONT"  	,n_Descont	,Nil,.T.},;
						{"AUTMULTA"  	,n_Multa	,Nil,.T.},;
						{"AUTJUROS"  	,n_Juros	,Nil,.T.},;
						{"AUTACRESC"  	,n_Acres	,Nil,.T.},;
						{"AUTDECRESC"  	,n_Decres	,Nil,.T.},;
						{"AUTVALREC"	,n_ValRec	,Nil}}

			lMsErroAuto    := .F.
			lMsHelpAuto    := .T.
			lAutoErrNoFile := .T.
			
			//13/08/2019 - Busca o seq baixa pelo Id do RM apenas no cancelamento e apenas de for RM - ITEM 13
			If (n_Operacao = 5) .Or. (n_Operacao = 6)
				If (Alltrim(c_PreBx) = 'RM')
					If( Empty( o_BxParam:XIDBAIXARM ) )
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "O Id da baixa do Rm nao foi informado. Logo, o cancelamento da baixa nao pode ser realizado sem o Id da baixa do RM. Titulo: "+cFilAnt+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx					
						//Volta a database
						DDATABASE:= d_DataBk
						Return(.T.)
					Else
						l_NaoAchei	:= .F.
						n_SeqBx		:= 0
						a_E5Area	:= SE5->( GetArea() )
						c_Qry:= "SELECT E5_SEQ, R_E_C_N_O_ REC, E5_FSBXRM, E5_SEQ, E5_SITUACA, E5_TIPODOC, E5_VALOR, E5_DTCANBX, E5_ORIGEM "+chr(13)+chr(10)
						c_Qry+= "FROM "+RETSQLNAME("SE5")+" E5"+chr(13)+chr(10)
						c_Qry+= "WHERE E5_FILIAL = '"+o_Empresa:c_Filial+"' "+chr(13)+chr(10)
						c_Qry+= "AND E5.D_E_L_E_T_ = '' "+chr(13)+chr(10)
						c_Qry+= "AND E5_RECPAG = 'R' AND E5_TIPODOC IN ('BA','VL') AND E5_SITUACA = ' ' AND E5_ORIGEM = 'RPC' AND E5_DTCANBX = '' "+chr(13)+chr(10)
						c_Qry+= "AND E5_PREFIXO = '"+c_PreBx+"' "+chr(13)+chr(10) 
						c_Qry+= "AND E5_NUMERO  = '"+c_NumBx+"'"+chr(13)+chr(10)	
						c_Qry+= "AND E5_PARCELA = '"+c_ParBx+"' "+chr(13)+chr(10)
						c_Qry+= "AND E5_TIPO    = '"+c_TipBx+"' "+chr(13)+chr(10)
						c_Qry+= "AND E5_CLIFOR  = '"+c_CliBx+"' "+chr(13)+chr(10)
						c_Qry+= "AND E5_LOJA    = '"+c_LojBx+"' "+chr(13)+chr(10)
						c_Qry+= "ORDER BY R_E_C_N_O_ "						
						TCQUERY c_Qry ALIAS QRY NEW
						dbSelectArea("QRY")
						If !(QRY->(Eof()))
							While !(QRY->(Eof()))
								n_SeqBx++
								DbSelectArea("SE5")
								DbGoto(QRY->REC)
								//Garante que posicionou no registro da compensacao
								If (SE5->(Recno()) = QRY->REC) .And. (SE5->E5_RECPAG = 'R') .And. (SE5->E5_TIPODOC = 'BA' .OR. SE5->E5_TIPODOC = 'VL') .And. (SE5->E5_PREFIXO = c_PreBx) .And. (SE5->E5_NUMERO = c_NumBx) .And. (SE5->E5_PARCELA = c_ParBx) .And. (SE5->E5_TIPO = c_TipBx) .And. (SE5->E5_CLIFOR = c_CliBx) .And. (SE5->E5_LOJA = c_LojBx)
									If( Alltrim(SE5->E5_FSBXRM)	== Alltrim(o_BxParam:XIDBAIXARM) )//id da baixa do RM
										l_NaoAchei:= .T.
										Exit
									EndIf
								EndIf
								dbSelectArea("QRY")
								QRY->(DbSkip())
							EndDo
						EndIf						
						dbSelectArea("QRY")
						QRY->(dbCloseArea())
						RestArea( a_E5Area )
						If !( l_NaoAchei )
							::o_Retorno:l_Status	:= .F.
							::o_Retorno:c_Mensagem	:= "O Id da baixa do Rm "+Alltrim(o_BxParam:XIDBAIXARM)+" nao foi encontrado. Logo, o cancelamento da baixa nao pode ser realizado. Titulo: "+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx					
							//Volta a database
							DDATABASE:= d_DataBk
							Return(.T.)
						Else
							nOpbaixa:= n_SeqBx
						EndIf
					EndIf
				EndIf
			EndIf//fim do ITEM 13
			
			Begin Transaction
				//3 - Baixa de Titulo, 5 - Cancelamento de baixa, 6 - Exclusao de Baixa.
				MSExecAuto( {|n,x,y,z| Fina070(n,x,y,z)}, a_Baixa, n_Operacao, lNoMbrowse, nOpbaixa )
				If lMsErroAuto
				   DisarmTransaction()
				   Break //Um Break, para que o fluxo seja desviado para depois do proximo comando END TRANSACTION ou a finalizacao da thread.
				Else
					DBSELECTAREA("SE1")
					DBSETORDER(1)
					DBSEEK(XFILIAL("SE1")+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx)
					If (SE1->E1_SALDO > 0)
						l_Parcial:= .T.
					Else
						l_Parcial:= .F.
					EndIf

					::o_Retorno:l_Status:= .T.
					If (n_Operacao == 3)
						c_SeqBai:= SE5->E5_SEQ
						//Grava o numero do Rm no campo customizado
						DBSELECTAREA("SE5")
						DBSETORDER(7)
						If Dbseek(xFilial("SE5")+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx)
							While !(SE5->(Eof())) .And. (SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA == xFilial("SE5")+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx)
								If Alltrim(SE5->E5_SEQ) == Alltrim(c_SeqBai)
									If (Alltrim(SE5->E5_PREFIXO) = 'RM') .AND. (Alltrim(SE5->E5_ORIGEM) = 'RPC')// .AND. E5_TIPO $ 'BRM|CRM'
										Reclock("SE5",.F.)
										SE5->E5_XNUMRM	:= PADR( c_xNumRM, TAMSX3( "E5_XNUMRM" )[ 1 ] )
										SE5->E5_FSBXRM 	:= Alltrim(o_BxParam:XIDBAIXARM) //id da baixa do RM
										SE5->E5_LA  	:= "S"
										MsUnlock()
								
								        dbSelectArea("FK1")
								        dbSetOrder(1)
										dbSeek(xFilial("FK1")+SE5->E5_IDORIG)

									    If !Eof()
										   Reclock("FK1",.F.)
										   FK1->FK1_LA := "S"
										   MsUnlock()
										EndIf
										
										dbSelectArea("SE5")
									EndIf
								EndIf
								SE5->(DbSkip())
							EndDo
						EndIf

						c_NRas:= ""
						If (l_Parcial)
							If (l_Compensou)
								For u:= 1 To Len(a_RasRec)
									DbSelectArea("SE1")
									DbGoto(a_RasRec[u])
									c_NRas+= Alltrim(SE1->E1_NUM)+"-"
								Next
								c_NRas:= Substr(c_NRas,1,Len(c_NRas)-1)
								c_Mens:= "Titulo ("+c_PreBx+"-"+c_NumBx+"-"+c_TipBx+"-"+c_ParBx+"-"+c_CliBx+"-"+c_LojBx+") baixado parcialmente na filial "+o_Empresa:c_Filial+" com compensacao dos RAs ("+c_NRas+"). SEQBAIXA: "+Alltrim(c_SeqBai)
							Else
								c_Mens:= "Titulo ("+c_PreBx+"-"+c_NumBx+"-"+c_TipBx+"-"+c_ParBx+"-"+c_CliBx+"-"+c_LojBx+") baixado parcialmente na filial "+o_Empresa:c_Filial+". SEQBAIXA: "+Alltrim(c_SeqBai)
							EndIf
						Else
							If (l_Compensou)
								For u:= 1 To Len(a_RasRec)
									DbSelectArea("SE1")
									DbGoto(a_RasRec[u])
									c_NRas+= Alltrim(SE1->E1_NUM)+"-"
								Next
								c_NRas:= Substr(c_NRas,1,Len(c_NRas)-1)
								c_Mens:= "Titulo ("+c_PreBx+"-"+c_NumBx+"-"+c_TipBx+"-"+c_ParBx+"-"+c_CliBx+"-"+c_LojBx+") baixado totalmente na filial "+o_Empresa:c_Filial+" com compensacao dos RAs ("+c_NRas+"). SEQBAIXA: "+Alltrim(c_SeqBai)
							Else
								c_Mens:= "Titulo ("+c_PreBx+"-"+c_NumBx+"-"+c_TipBx+"-"+c_ParBx+"-"+c_CliBx+"-"+c_LojBx+") baixado totalmente na filial "+o_Empresa:c_Filial+". SEQBAIXA: "+Alltrim(c_SeqBai)
							EndIf
						EndIf
						//23/04/2019 - Para os titulos do RM verifica se esta no status de perda e chama a contabilizacao reversa - Fluxo de Cobranca
						If (Alltrim(c_PreBx) = "RM") //Apenas para os titulos com prefixo RM, pq vem o ID da baixa do RM
							DBSELECTAREA("SE1")
							DBSETORDER(1)
							DBSEEK(XFILIAL("SE1")+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx)
							//Adriano 29/03/2019 - Tratamento para gerar a contabilizacao reversa de titulos de perda - Fluxo de Cobranca.
							//Para funcionar tem que compilar o fonte FINA09O
							If ExistBlock("FINA09O") .And. ( Alltrim(SE1->E1_XSTTTCB) == '5' ) //Perda
								//O LP 230 foi criado especificamente para essa finalidade.
								CUSUARIO:= "123456WS " //Fiz isso para gravar WS no LP pois eh usado a variavel cusuario no LP 230
								u_GrvCtbReversa("230") //Funcao declarada no PRW FINA09O - Rotina de Fluxo de Cobranca
							Endif
						EndIf
						::o_Retorno:c_Mensagem	:= c_Mens
						Conout("FFIEBW01 - mtdBaixaTit: "+c_Mens)
					ElseIf (n_Operacao == 5)
						//23/04/2019 - Para os titulos do RM verifica se esta no status de perda e chama a contabilizacao reversa - Fluxo de Cobranca
						If (Alltrim(c_PreBx) = "RM") //Apenas para os titulos com prefixo RM, pq vem o ID da baixa do RM
							DBSELECTAREA("SE1")
							DBSETORDER(1)
							DBSEEK(XFILIAL("SE1")+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx)
							//Adriano 29/03/2019 - Tratamento para gerar a contabilizacao reversa de titulos de perda - Fluxo de Cobranca.
							//Para funcionar tem que compilar o fonte FINA09O
							If ExistBlock("FINA09O") .And. ( Alltrim(SE1->E1_XSTTTCB) == '5' ) //Perda
								//O LP 231 foi criado especificamente para essa finalidade.
								CUSUARIO:= "123456WS " //Fiz isso para gravar WS no LP pois eh usado a variavel cusuario no LP 230
								u_GrvCtbReversa("231") //Funcao declarada no PRW FINA09O - Rotina de Fluxo de Cobranca
							Endif
						EndIf
						//Chama a funcao apenas quando passar a opcao 5 = cancelamento de baixa e o titulo possuir o lote RM.
						c_MvMsg:= ""
						If !Empty(c_Lote) .And. (l_LotRmBx)
							/* ATENCAOOOOOOOOOOOOOOOOOOOOOO 
							comentado dia 17/08/2020 - No estorno de uma baixa de um titulo que possui lote (mesmo que o motivo de baixa nao 
							alimente banco), o sistem j� gera a linha RECPAG P e TIPODOC ES no SE5, por estar preenchido o BANCO/AGE/CONTA 
							na mao para esses casos. Portanto, decidiu-se que nao precisa gerar esse mov a pagar na filial da sede. 
							Limpa somente o lote do SE1							
							*/					
							//Limpa o lote RM do titulo
							DBSELECTAREA("SE1")
							DBSETORDER(1)
							If (DBSEEK(o_Empresa:c_Filial+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx))
								If !Empty(SE1->E1_FSLORM)
									RecLock("SE1",.F.)
									SE1->E1_LOTE	:= ""
									SE1->E1_FSLORM	:= ""
									MsUnLock()
								EndIf
							EndIf
							/*
							//============================================================================================================================================
							//Gera o movimento bancario a pagar quando cancelar a baixa de um titulo que foi baixado pela rotina de baixa por lote
							//Busca a filial do movimento bancario totalizador
							c_Qry:= "SELECT E5_FILIAL, E5_MOEDA, E5_NATUREZ, E5_BANCO, E5_AGENCIA, E5_CONTA, E5_NUMCHEQ, E5_DOCUMEN, E5_BENEF, E5_DEBITO, "
							c_Qry+= "E5_CREDITO, E5_CCD, E5_CCC, E5_ITEMD, E5_ITEMC, E5_CLVLDB, E5_CLVLCR FROM "+RETSQLNAME("SE5")+" WHERE D_E_L_E_T_ <> '*' "
							c_Qry+= "AND E5_FSLORM = '"+c_Lote+"' AND E5_BANCO = '"+c_Ban+"' AND E5_AGENCIA = '"+c_Age+"' AND E5_CONTA = '"+c_Con+"' AND SUBSTRING(E5_FILIAL, 5,4) = '0001'" //O MOV TOTALIZADOR ESTAR NA FILIAL SEDE SEMPRE
							TCQUERY c_Qry ALIAS QRY NEW
							If !(QRY->(Eof()))
								c_MovFil:= QRY->E5_FILIAL

								//Posiciona na empresa e filial de destino
								dbSelectArea("SM0")
								dbSeek(o_Empresa:c_Empresa+Alltrim(c_MovFil))
								cFilAnt:= Alltrim(c_MovFil)

								aVetor		:= {}
								aAdd( aVetor, {"E5_FILIAL"	,c_MovFil	,Nil})
								aAdd( aVetor, {"E5_DATA" 	,DDATABASE , Nil}) //Ja estou posicionado na database passado no parametro
								aAdd( aVetor, {"E5_MOEDA" 	,PADR(Alltrim(QRY->E5_MOEDA)	, TAMSX3("E5_MOEDA")[1]) 	,Nil})
								aAdd( aVetor, {"E5_VALOR" 	,n_ValRec,Nil})
								aAdd( aVetor, {"E5_NATUREZ"	,PADR(Alltrim(QRY->E5_NATUREZ)	, TAMSX3("E5_NATUREZ")[1])	,Nil})
								aAdd( aVetor, {"E5_BANCO" 	,PADR(Alltrim(QRY->E5_BANCO)	, TAMSX3("E5_BANCO")[1]) 	,Nil})
								aAdd( aVetor, {"E5_AGENCIA" ,PADR(Alltrim(QRY->E5_AGENCIA)	, TAMSX3("E5_AGENCIA")[1]) 	,Nil})
								aAdd( aVetor, {"E5_CONTA" 	,PADR(Alltrim(QRY->E5_CONTA)	, TAMSX3("E5_CONTA")[1]) 	,Nil})
								aAdd( aVetor, {"E5_NUMCHEQ" ,PADR(Alltrim(QRY->E5_NUMCHEQ)	, TAMSX3("E5_NUMCHEQ")[1]) 	,Nil})
								aAdd( aVetor, {"E5_DOCUMEN" ,PADR(Alltrim(QRY->E5_DOCUMEN), TAMSX3("E5_DOCUMENT")[1]) ,Nil})
								aAdd( aVetor, {"E5_BENEF" 	,PADR(Alltrim(QRY->E5_BENEF)	, TAMSX3("E5_BENEF")[1]) 	,Nil})
								aAdd( aVetor, {"E5_HISTOR" 	,PADR("Canc. "+Alltrim(c_PreBx)+"-"+Alltrim(c_NumBx)+"-"+Alltrim(c_TipBx)+"-"+Alltrim(c_ParBx)+"-"+Alltrim(c_CliBx)+"-"+Alltrim(c_LojBx), TAMSX3("E5_HISTOR")[1]) 	,Nil})
								aAdd( aVetor, {"E5_LA"   	,"S",Nil})
								If !Empty(QRY->E5_DEBITO)
									aAdd( aVetor, {"E5_DEBITO" 	,PADR(Alltrim(QRY->E5_DEBITO)	, TAMSX3("E5_DEBITO")[1]) 	,Nil})
								EndIf
								If !Empty(QRY->E5_CREDITO)
									aAdd( aVetor, {"E5_CREDITO" ,PADR(Alltrim(QRY->E5_CREDITO)	, TAMSX3("E5_CREDITO")[1]) 	,Nil})
								EndIf
								If !Empty(QRY->E5_CCD)
									aAdd( aVetor, {"E5_CCD" 	,PADR(Alltrim(QRY->E5_CCD)		, TAMSX3("E5_CCD")[1]) 		,Nil})
								EndIf
								If !Empty(QRY->E5_CCC)
									aAdd( aVetor, {"E5_CCC" 	,PADR(Alltrim(QRY->E5_CCC)		, TAMSX3("E5_CCC")[1]) 		,Nil})
								EndIf
								If !Empty(QRY->E5_ITEMD)
									aAdd( aVetor, {"E5_ITEMD" 	,PADR(Alltrim(QRY->E5_ITEMD)	, TAMSX3("E5_ITEMD")[1]) 	,Nil})
								EndIf
								If !Empty(QRY->E5_ITEMC)
									aAdd( aVetor, {"E5_ITEMC" 	,PADR(Alltrim(QRY->E5_ITEMC)	, TAMSX3("E5_ITEMC")[1]) 	,Nil})
								EndIf
								If !Empty(QRY->E5_CLVLDB)
									aAdd( aVetor, {"E5_CLVLDB" 	,PADR(Alltrim(QRY->E5_CLVLDB)	, TAMSX3("E5_CLVLDB")[1]) 	,Nil})
								EndIf
								If !Empty(QRY->E5_CLVLCR)
									aAdd( aVetor, {"E5_CLVLCR" 	,PADR(Alltrim(QRY->E5_CLVLCR)	, TAMSX3("E5_CLVLCR")[1]) 	,Nil})
								EndIf

								//dbSelectArea("QRY")
								//QRY->(dbCloseArea())

								lMsErroAuto		:= .F.
								lMsHelpAuto		:= .T.
								lAutoErrNoFile	:= .T.

								aLogErr			:= {}
								aLogErr2		:= {}

								MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aVetor,3) //3= Mov. a Pagar

								If lMsErroAuto
									DisarmTransaction()
									Break
								Else
									//Limpa o lote RM do titulo
									DBSELECTAREA("SE1")
									DBSETORDER(1)
									If (DBSEEK(o_Empresa:c_Filial+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx))
										If !Empty(SE1->E1_FSLORM)
											RecLock("SE1",.F.)
											SE1->E1_LOTE	:= ""
											SE1->E1_FSLORM	:= ""
											MsUnLock()
										EndIf
									EndIf
									c_MvMsg:= "Gerado o mov. a pagar na filial: "+c_MovFil+" e data "+Dtoc(ddatabase)
								EndIf
							Else
								c_MvMsg:= "Nao foi gerado o mov. a pagar, pois nao foi encontrado o registro do movimento totalizador no SE5."
							EndIf
							dbSelectArea("QRY")
							QRY->(dbCloseArea())
							*/
							//============================================================================================================================================
						Else
						   c_SeqBai:= SE5->E5_SEQ
						   //Grava o E5_LA e o FK1_LA do cancelamento da baixa como S para impedir contabilizacao
						   DBSELECTAREA("SE5")
						   DBSETORDER(7)
						   If Dbseek(xFilial("SE5")+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx)
							  While !(SE5->(Eof())) .And. (SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA == xFilial("SE5")+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx)
							  	    If Alltrim(SE5->E5_SEQ) == Alltrim(c_SeqBai)
									   If (Alltrim(SE5->E5_PREFIXO) = 'RM') .AND. (Alltrim(SE5->E5_ORIGEM) = 'RPC')// .AND. E5_TIPO $ 'BRM|CRM'
										  Reclock("SE5",.F.)
										  SE5->E5_LA := "S"
										  MsUnlock()
								
								          dbSelectArea("FK1")
								          dbSetOrder(1)
										  dbSeek(FwFilial("FK1")+SE5->E5_IDORIG)

									      If !Eof()
										     Reclock("FK1",.F.)
											 FK1->FK1_LA := "S"
										     MsUnlock()
										  EndIf
										
										  dbSelectArea("SE5")
									   EndIf
								    EndIf
								    SE5->(DbSkip())
							  EndDo
						   EndIf	
						EndIf
						If (l_Compensou)
							For u:= 1 To Len(a_RasRec)
								DbSelectArea("SE1")
								DbGoto(a_RasRec[u])
								c_NRas+= Alltrim(SE1->E1_NUM)+"-"
							Next
							c_NRas:= Substr(c_NRas,1,Len(c_NRas)-1)
							::o_Retorno:c_Mensagem	:= "Baixa do titulo ("+c_PreBx+"-"+c_NumBx+"-"+c_TipBx+"-"+c_ParBx+"-"+c_CliBx+"-"+c_LojBx+") cancelada na filial "+o_Empresa:c_Filial+" com compensacao dos RAs ("+c_NRas+"). "+c_MvMsg
							Conout("FFIEBW01 - mtdBaixaTit: Baixa do titulo ("+c_PreBx+"-"+c_NumBx+"-"+c_TipBx+"-"+c_ParBx+"-"+c_CliBx+"-"+c_LojBx+") cancelada na filial "+o_Empresa:c_Filial+" com compensacao dos RAs ("+c_NRas+"). "+c_MvMsg)
						Else
							::o_Retorno:c_Mensagem	:= "Baixa do titulo ("+c_PreBx+"-"+c_NumBx+"-"+c_TipBx+"-"+c_ParBx+"-"+c_CliBx+"-"+c_LojBx+") cancelada na filial "+o_Empresa:c_Filial+". "+c_MvMsg
							Conout("FFIEBW01 - mtdBaixaTit: Baixa do titulo ("+c_PreBx+"-"+c_NumBx+"-"+c_TipBx+"-"+c_ParBx+"-"+c_CliBx+"-"+c_LojBx+") cancelada na filial "+o_Empresa:c_Filial+". "+c_MvMsg)
						EndIf
					Else
						//23/04/2019 - Para os titulos do RM verifica se esta no status de perda e chama a contabilizacao reversa - Fluxo de Cobranca
						If (Alltrim(c_PreBx) = "RM") //Apenas para os titulos com prefixo RM, pq vem o ID da baixa do RM
							DBSELECTAREA("SE1")
							DBSETORDER(1)
							DBSEEK(XFILIAL("SE1")+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx)
							//Adriano 29/03/2019 - Tratamento para gerar a contabilizacao reversa de titulos de perda - Fluxo de Cobranca.
							//Para funcionar tem que compilar o fonte FINA09O
							If ExistBlock("FINA09O") .And. ( Alltrim(SE1->E1_XSTTTCB) == '5' ) //Perda
								//O LP 231 foi criado especificamente para essa finalidade.
								CUSUARIO:= "123456WS " //Fiz isso para gravar WS no LP pois eh usado a variavel cusuario no LP 230
								u_GrvCtbReversa("231") //Funcao declarada no PRW FINA09O - Rotina de Fluxo de Cobranca
							Endif
						EndIf
						If (l_Compensou)
							For u:= 1 To Len(a_RasRec)
								DbSelectArea("SE1")
								DbGoto(a_RasRec[u])
								c_NRas+= Alltrim(SE1->E1_NUM)+"-"
							Next
							c_NRas:= Substr(c_NRas,1,Len(c_NRas)-1)
							::o_Retorno:c_Mensagem	:= "Baixa do titulo ("+c_PreBx+"-"+c_NumBx+"-"+c_TipBx+"-"+c_ParBx+"-"+c_CliBx+"-"+c_LojBx+") excluida na filial "+o_Empresa:c_Filial+" com compensacao dos RAs ("+c_NRas+")."
							Conout("FFIEBW01 - mtdBaixaTit: Baixa do titulo ("+c_PreBx+"-"+c_NumBx+"-"+c_TipBx+"-"+c_ParBx+"-"+c_CliBx+"-"+c_LojBx+") excluida na filial "+o_Empresa:c_Filial+" com compensacao dos RAs ("+c_NRas+").")
						Else
							::o_Retorno:c_Mensagem	:= "Baixa do titulo ("+c_PreBx+"-"+c_NumBx+"-"+c_TipBx+"-"+c_ParBx+"-"+c_CliBx+"-"+c_LojBx+") excluida na filial "+o_Empresa:c_Filial+"."
							Conout("FFIEBW01 - mtdBaixaTit: Baixa do titulo ("+c_PreBx+"-"+c_NumBx+"-"+c_TipBx+"-"+c_ParBx+"-"+c_CliBx+"-"+c_LojBx+") excluida na filial "+o_Empresa:c_Filial+".")
						EndIf
					EndIf
					//Grava o E5_LA = S 03/09/2020
					f_GravaLA( o_Empresa:c_Filial, PADR(Alltrim(o_BxParam:E1_NUM), TAMSX3("E1_NUM")[1]), Alltrim(o_BxParam:XIDBAIXARM) )
					//Chama a funcao tambem quanto tiver RA (compensacao)
					c_NumRA:= ""
					For p:= 1 To Len(o_TitRA:TITRAS)
						c_NumRA:= PADR(Alltrim(o_TitRA:TITRAS[p]:E1_NUM), TAMSX3("E1_NUM")[1])
						f_GravaLA( o_Empresa:c_Filial, c_NumRA, Alltrim(o_BxParam:XIDBAIXARM) )
					Next
				EndIf
			End Transaction
			//Se deu erro no Execauto
			If lMsErroAuto
				//Regra do fonte SIESBA01 da FIEB
				If (__lSX8)
					RollBackSX8()
				EndIf

				// Tratamento da Mensagem de erro do MSExecAuto
				aLogErr  := GetAutoGRLog()
				aLogErr2 := f_TrataErro(aLogErr)
				_cMotivo := ""

				For i := 1 to Len(aLogErr2)
					_cMotivo += aLogErr2[i]
				Next

				//Exclusivo para a versao 12
				If (GetVersao(.F.) == "12")
					_cMotivo:=  NoAcentoESB(_cMotivo)
					SetSoapFault('Erro',_cMotivo)
				EndIf

				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= NoAcentoESB(_cMotivo)
				Conout("FFIEBW01 - mtdBaixaTit: "+NoAcentoESB(_cMotivo))
			Else
				If(::o_Retorno:l_Status == .T.)
					If !Empty(o_BxParam:XIDBAIXARM) //Se mandou o Id da baixa do Rm
						c_PreBx:= PADR(Alltrim(o_BxParam:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1])
						c_NumBx:= PADR(Alltrim(o_BxParam:E1_NUM), TAMSX3("E1_NUM")[1])
						c_ParBx:= PADR(Alltrim(o_BxParam:E1_PARCELA), TAMSX3("E1_PARCELA")[1])
						c_TipBx:= PADR(Alltrim(o_BxParam:E1_TIPO), TAMSX3("E1_TIPO")[1])
						DBSELECTAREA("SA1")
						DBSETORDER(3)
						If (DBSEEK(XFILIAL("SA1")+Alltrim(o_BxParam:CGC)))
							c_CliBx	:= SA1->A1_COD
							c_LojBx	:= SA1->A1_LOJA
						EndIf
						If (Alltrim(c_PreBx) = "RM") //Apenas para os titulos com prefixo RM, pq vem o ID da baixa do RM
							If (n_Operacao = 3) //inclusao
								l_Encont:= .F.
								//Verifica se a baixa existe
								DBSELECTAREA("SE5")
								DBSETORDER(7)
								If Dbseek(xFilial("SE5")+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx)
									While !(SE5->(Eof())) .And. (SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA == xFilial("SE5")+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx)
										If (Alltrim(SE5->E5_FSBXRM) == Alltrim(o_BxParam:XIDBAIXARM)) //id da baixa do RM
											If Empty(SE5->E5_DTCANBX) .And. Empty(SE5->E5_SITUACA) //Retira os movimentos cancelados
												If (Alltrim(SE5->E5_ORIGEM) = 'RPC')
													l_Encont:= .T.
													Exit
												EndIf
											EndIf
										EndIf
										SE5->(DbSkip())
									EndDo
									If !(l_Encont)
										::o_Retorno:l_Status	:= .F.
										::o_Retorno:c_Mensagem	:= "### BAIXA -  Id da baixa "+Alltrim(o_BxParam:XIDBAIXARM)+" do titulo "+Alltrim(c_NumBx)+" na filial "+o_Empresa:c_Filial+" nao encontrado apos o processo de baixa. Possivelmente ocorreu algum rollback na transacao. Necessario enviar a baixa novamente. ###"+CHR(13)+CHR(10)
									EndIf
								EndIf
							Else //Cancelamento: Opcao 5 ou Opcao 6 Exclusao
								l_Encont:= .F.
								//Verifica se a baixa foi realmente cancelada. Nesse caso a linha da baixa fica com E5_DTCANBX preenchido e uma nova linha com RECPAG = P e criada.
								DBSELECTAREA("SE5")
								DBSETORDER(7)
								If Dbseek(xFilial("SE5")+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx)
									While !(SE5->(Eof())) .And. (SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA == xFilial("SE5")+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx)
										If (Alltrim(SE5->E5_FSBXRM) == Alltrim(o_BxParam:XIDBAIXARM)) //id da baixa do RM
											//Adicionado em 15/09/2020 a condicao .And. SE5->E5_TIPODOC $ "VL/DC" para resolver situacao 
											//identificada por micheline onde o estorno esta concluido com sucesso, porem alguns registros 
											//marcados como estornados nao gravam os campos de  data do cancelamento e nem o campo situacao 
											//como previsto inicialmente.
											If Empty(SE5->E5_DTCANBX) .And. Empty(SE5->E5_SITUACA) .And. SE5->E5_TIPODOC $ "VL/DC" 
												If (Alltrim(SE5->E5_ORIGEM) = 'RPC')
													l_Encont:= .T.
													Exit
												EndIf
											EndIf
										EndIf
										SE5->(DbSkip())
									EndDo
									If (l_Encont)
										::o_Retorno:l_Status	:= .F.
										::o_Retorno:c_Mensagem	:= "### Id da baixa "+Alltrim(o_BxParam:XIDBAIXARM)+" do titulo "+Alltrim(c_NumBx)+" na filial "+o_Empresa:c_Filial+" encontrado ativo apos o processo de cancelamento da baixa. Verificar se o ID da Baixa foi enviado mais de uma vez em outra baixa ou ocorreu algum rollback na transacao. ###"+CHR(13)+CHR(10)
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

	//Volta a database
	DDATABASE:= d_DataBk
RETURN(.T.)
/*/{Protheus.doc} mtdGravaPV
Metodo de gravacao do pedido de venda
@author Totvs-BA
@since 05/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSMETHOD mtdGravaPV WSRECEIVE o_Seguranca, o_Empresa, o_PedidoVenda, Operacao WSSEND o_Retorno WSSERVICE FFIEBW01

	Local a_CabSC5		:= {}
	Local a_IteSC6		:= {}
	Local c_CF			:= ""
	Local I				:= 0
	Local n_Ite			:= 0
	Local c_Cliente		:= ""
	Local c_Loja		:= ""
	Local n_Operacao	:= Val(::Operacao)
	Local _aItem    	:= {}
	Local _aTotItem 	:= {}
	Local _lRateio  	:= .f.
	Local _aTotRat  	:= {}
	Local _aRateio 		:= {}
	Local i,x,p			:= 0
	Local c_PVTes		:= ""
	PRIVATE lMsErroAuto := .F.

	::o_Retorno	:= WSCLASSNEW("strRetorno")

	If !(f_VldFilEmp(o_Empresa:c_Empresa,o_Empresa:c_Filial))
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Codigo de Empresa/Filial nao existe."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGravaPV: Codigo de Empresa/Filial nao existe.")
		Return(.T.)
	EndIf

	//Loga na filial solicitada
	RpcSetType(3)
	RpcSetEnv(o_Empresa:c_Empresa,o_Empresa:c_Filial, "integracao", "fieb123")

	//Posiciona na empresa e filial passada
	dbSelectArea("SM0")
	dbSeek(o_Empresa:c_Empresa+o_Empresa:c_Filial)

	cFilAnt:= o_Empresa:c_Filial

	c_UserWS	:= Upper(ALLTRIM(SUPERGETMV("FS_FIUSRWS",,"totvs_fieb")))
	c_PswWS		:= Upper(ALLTRIM(SUPERGETMV("FS_FIPSWWS",,"totvs@123")))

	//Validando o usuario e senha
	If ( Upper(o_Seguranca:c_Usuario) <> Upper(c_UserWS) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGravaPV: Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido.")
		Return(.T.)
	ElseIf ( Upper(o_Seguranca:c_Senha) <> Upper(c_PswWS) )
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGravaPV: Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida.")
		Return(.T.)
	EndIf
	If (n_Operacao <> 3) .And. (n_Operacao <> 4) .And. (n_Operacao <> 5)
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Valor passado no parametro Operacao ("+cValToChar(n_Operacao)+") invalido. Informar (3=Inclusao; 4=Alteracao; 5=Exclusao)."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGravaPV: Valor passado no parametro Operacao ("+cValToChar(n_Operacao)+") invalido. Informar (3=Inclusao; 4=Alteracao; 5=Exclusao).")
		Return(.T.)
	EndIf
	DBSELECTAREA("SA1")
	DBSETORDER(3)
	If !(DBSEEK(XFILIAL("SA1")+Alltrim(o_PedidoVenda:CGC)))
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "CNPJ/CPF "+Alltrim(o_PedidoVenda:CGC)+" nao encontrado na base de dados do protheus."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGravaPV: CNPJ/CPF "+Alltrim(o_PedidoVenda:CGC)+" nao encontrado na base de dados do protheus.")
		Return(.T.)
	Else
		c_Cliente	:= SA1->A1_COD
		c_Loja		:= SA1->A1_LOJA
		c_Nome		:= SA1->A1_NOME
		c_TipoCli	:= SA1->A1_TIPO
	EndIf
	If Empty(o_PedidoVenda:C5_TIPO)
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Informe o tipo de pedido de venda."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGravaPV: Informe o tipo de pedido de venda.")
		Return(.T.)
	EndIf
	If (Alltrim(o_PedidoVenda:C5_TIPO) <> 'N')
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "O tipo do pedido de venda tem que ser 'N'."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGravaPV: O tipo do pedido de venda tem que ser 'N'.")
		Return(.T.)
	EndIf
	If Empty(o_PedidoVenda:C5_CONDPAG)
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Informe a condicao de pagamento"+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGravaPV: Informe a condicao de pagamento.")
		Return(.T.)
	EndIf
	DBSELECTAREA("SE4")
	DBSETORDER(1)
	If !(DBSEEK(XFILIAL("SE4")+Padr(Alltrim(o_PedidoVenda:C5_CONDPAG),TamSx3("C5_CONDPAG")[1])))
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Condicao de pagamento "+Alltrim(o_PedidoVenda:C5_CONDPAG)+" nao encontrada na base de dados do protheus."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGravaPV: Condicao de pagamento "+Alltrim(o_PedidoVenda:C5_CONDPAG)+" nao encontrada na base de dados do protheus.")
		Return(.T.)
	EndIf
	If Empty(o_PedidoVenda:C5_EMISSAO)
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Informe a data de emissao."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGravaPV: Informe a data de emissao.")
		Return(.T.)
	EndIf
	If !Empty(o_PedidoVenda:C5_NATUREZ)
		//Valida a natureza
		dbSelectArea("SED")
		dbSetOrder(1)
		If !(dbSeek(xfilial("SED")+Alltrim(o_PedidoVenda:C5_NATUREZ)))
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Natureza "+Alltrim(o_PedidoVenda:C5_NATUREZ)+" nao encontrada na base de dados do protheus."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdGravaPV: Natureza "+Alltrim(o_PedidoVenda:C5_NATUREZ)+" nao encontrada na base de dados do protheus.")
			Return(.T.)
		EndIf
	EndIf
	If !Empty(o_PedidoVenda:C5_TPFRETE)
		If (Upper(Alltrim(o_PedidoVenda:C5_TPFRETE)) <> 'C') .And. (Upper(Alltrim(o_PedidoVenda:C5_TPFRETE)) <> 'F') .And. (Upper(Alltrim(o_PedidoVenda:C5_TPFRETE)) <> 'T') .And. (Upper(Alltrim(o_PedidoVenda:C5_TPFRETE)) <> 'S')
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Tipo de frete "+Upper(Alltrim(o_PedidoVenda:C5_TPFRETE))+" invalido. Informar: (C ou F ou T ou S)."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdGravaPV: Tipo de frete "+Upper(Alltrim(o_PedidoVenda:C5_TPFRETE))+" invalido. Informar: (C ou F ou T ou S).")
			Return(.T.)
		EndIf
	EndIf
	If (n_Operacao = 4) .Or. (n_Operacao = 5)
		If Empty(o_PedidoVenda:PEDIDO)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Para operacao de alteracao ou exclusao o numero do pedido tem que ser informado."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdGravaPV: Para operacao de alteracao ou exclusao o numero do pedido tem que ser informado.")
			Return(.T.)
		Else
			DBSELECTAREA("SC5")
			DBSETORDER(1)
			If !(DBSEEK(XFILIAL("SC5")+Alltrim(o_PedidoVenda:PEDIDO)))
				//Validacao da exclusao do pedido a pedido de Rafael 03/12/2018
				If (n_Operacao = 5)
					::o_Retorno:l_Status	:= .T.
					::o_Retorno:c_Mensagem	:= "###Pedido "+Alltrim(o_PedidoVenda:PEDIDO)+" ja excluido."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdGravaPV: ###Pedido "+Alltrim(o_PedidoVenda:PEDIDO)+" ja excluido.")
					Return(.T.)
				Else
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Pedido "+Alltrim(o_PedidoVenda:PEDIDO)+" nao localizado."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdGravaPV: Pedido "+Alltrim(o_PedidoVenda:PEDIDO)+" nao localizado.")
					Return(.T.)
				EndIf
			Else
				If !Empty(SC5->C5_NOTA)
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Pedido "+Alltrim(o_PedidoVenda:PEDIDO)+" ja possui nota gerada."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdGravaPV: Pedido "+Alltrim(o_PedidoVenda:PEDIDO)+" ja possui nota gerada.")
					Return(.T.)
				EndIf
			EndIf
		EndIf
	EndIf
	_lFatAuto := .F.
	_cSerie   := ""
	c_FatAut  := ""
	If (Upper(Alltrim(o_PedidoVenda:FATAUT)) == "S") //Se gera nota
		If (n_Operacao = 3)//Inclusao
			If Empty(o_PedidoVenda:SERIE)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "O parametro FATAUT esta configurado como "+Upper(Alltrim(o_PedidoVenda:FATAUT))+", logo a serie tem que ser informada."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdGravaPV: O parametro FATAUT esta configurado como "+Upper(Alltrim(o_PedidoVenda:FATAUT))+", logo a serie tem que ser informada")
				Return(.T.)
			Else
				_lFatAuto := .T.
				_cSerie   := Padr(Alltrim(o_PedidoVenda:SERIE),TamSx3("F2_SERIE")[1])
				//Verifica se a serie existe para a filial
				dbSelectArea("SX5")
				dbSetOrder(1)
				If(	!( dbSeek( o_Empresa:c_Filial+"01"+_cSerie ) ) )
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Serie "+Alltrim(_cSerie)+" nao encontrada para a filial "+Alltrim( o_Empresa:c_Filial )+"."
					Conout("FFIEBW01 - mtdGravaPV: Serie "+Alltrim(_cSerie)+" nao encontrada para a filial "+Alltrim( o_Empresa:c_Filial )+".")
					Return(.T.)
				EndIf
			EndIf
			c_FatAut  := Upper( Alltrim( o_PedidoVenda:FATAUT ) )
		EndIf
	Else
		If (n_Operacao = 3)//Inclusao
			c_FatAut  := 'N'
		EndIF
	EndIf 
	d_TesteData	:=	StoD(o_PedidoVenda:C5_EMISSAO)
	If valtype(d_TesteData) == "D"
		If Empty(d_TesteData)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe a Data de emissao do pedido no formato [AAAAMMDD]."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdGravaPV: Informe a Data de emissao do pedido no formato [AAAAMMDD].")
			Return(.T.)
		EndIf
	Else
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Informe a Data de emissao do pedido no formato [AAAAMMDD]."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGravaPV: Informe a Data de emissao do pedido no formato [AAAAMMDD].")
		Return(.T.)
	EndIf
	If (n_Operacao = 3) .Or. (n_Operacao = 5)
		//Valida se o periodo esta bloqueado.
		c_Err:= ""
		d_TesteData	:=	StoD(o_PedidoVenda:C5_EMISSAO)
		If !( f_VldDtMov( "FAT", d_TesteData, @c_Err, "" ) )
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= c_Err
			Conout("FFIEBW01 - mtdGravaPV: "+c_Err)
			Return(.T.)
		EndIf
	EndIf
	If !Empty(o_PedidoVenda:C5_DATA1)
		d_TesteData	:=	StoD(o_PedidoVenda:C5_DATA1)
		If valtype(d_TesteData) == "D"
			If Empty(d_TesteData)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe a Data1 do pedido no formato [AAAAMMDD]."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdGravaPV: Informe a Data1 do pedido no formato [AAAAMMDD].")
				Return(.T.)
			EndIf
		Else
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe a Data1 do pedido no formato [AAAAMMDD]."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdGravaPV: Informe a Data1 do pedido no formato [AAAAMMDD].")
			Return(.T.)
		EndIf
	EndIf
	If !Empty(o_PedidoVenda:C5_DATA2)
		d_TesteData	:=	StoD(o_PedidoVenda:C5_DATA2)
		If valtype(d_TesteData) == "D"
			If Empty(d_TesteData)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe a Data2 do pedido no formato [AAAAMMDD]."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdGravaPV: Informe a Data2 do pedido no formato [AAAAMMDD].")
				Return(.T.)
			EndIf
		Else
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe a Data2 do pedido no formato [AAAAMMDD]."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdGravaPV: Informe a Data2 do pedido no formato [AAAAMMDD].")
			Return(.T.)
		EndIf
	EndIf
	If !Empty(o_PedidoVenda:C5_DATA3)
		d_TesteData	:=	StoD(o_PedidoVenda:C5_DATA3)
		If valtype(d_TesteData) == "D"
			If Empty(d_TesteData)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe a Data3 do pedido no formato [AAAAMMDD]."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdGravaPV: Informe a Data3 do pedido no formato [AAAAMMDD].")
				Return(.T.)
			EndIf
		Else
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe a Data3 do pedido no formato [AAAAMMDD]."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdGravaPV: Informe a Data3 do pedido no formato [AAAAMMDD].")
			Return(.T.)
		EndIf
	EndIf
	If !Empty(o_PedidoVenda:C5_DATA4)
		d_TesteData	:=	StoD(o_PedidoVenda:C5_DATA4)
		If valtype(d_TesteData) == "D"
			If Empty(d_TesteData)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe a Data4 do pedido no formato [AAAAMMDD]."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdGravaPV: Informe a Data4 do pedido no formato [AAAAMMDD].")
				Return(.T.)
			EndIf
		Else
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe a Data4 do pedido no formato [AAAAMMDD]."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdGravaPV: Informe a Data4 do pedido no formato [AAAAMMDD].")
			Return(.T.)
		EndIf
	EndIf
	//PREENCHE AS VARIAVEIS PARA O PEDIDO DE VENDA
	a_CabSC5	:= {}
	a_IteSC6	:= {}

	aAdd( a_CabSC5, { "C5_FILIAL", o_Empresa:c_Filial ,Nil})

	If (n_Operacao = 4) .Or. (n_Operacao = 5)
		If !Empty(o_PedidoVenda:PEDIDO)
			aAdd( a_CabSC5, { "C5_NUM", Padr(Alltrim(o_PedidoVenda:PEDIDO),TamSx3("C5_NUM")[1]) ,Nil})
		EndIf
	EndIf

	//14/11/2019 - Tratamento para gravar a data de emissao do pedido. Os pedidos vem com emissao ultimo dia do mes
	//se tiver dentro do mes, grava a data base. Senao grava a emissao do pedido
	If( Month( Stod( o_PedidoVenda:C5_EMISSAO) ) == Month( dDatabase ) )
		d_EmisPed:= dDatabase
	Else
		d_EmisPed:= Stod( o_PedidoVenda:C5_EMISSAO)
	EndIf
	
	aAdd( a_CabSC5, { "C5_TIPO" 	, Alltrim(o_PedidoVenda:C5_TIPO)   			,NIL})
	aAdd( a_CabSC5, { "C5_CLIENTE"	, c_Cliente									,NIL})
	aAdd( a_CabSC5, { "C5_LOJACLI"	, c_Loja									,NIL})
	aAdd( a_CabSC5, { "C5_NOMCLI" 	, c_Nome									,NIL})
	aAdd( a_CabSC5, { "C5_TIPOCLI"	, c_TipoCli									,NIL})
	aAdd( a_CabSC5, { "C5_CONDPAG"	, Alltrim(o_PedidoVenda:C5_CONDPAG)			,NIL})
	aAdd( a_CabSC5, { "C5_EMISSAO"	, d_EmisPed									,NIL})
	aAdd( a_CabSC5, { "C5_MOEDA"  	, 1											,NIL})
	
	If (n_Operacao = 3)// 30/08/3019 - guarda os dados da nota para depois gerar automaticamente a nota.
		aAdd( a_CabSC5, { "C5_FSNFAUT"  , Iif( c_FatAut == 'S', '1', '2' )	,NIL})
		aAdd( a_CabSC5, { "C5_FSSERAT"  , _cSerie	,NIL})
	EndIf
	
	If !Empty(o_PedidoVenda:C5_NATUREZ)
		aAdd( a_CabSC5, { "C5_NATUREZ", Padr(Alltrim(o_PedidoVenda:C5_NATUREZ),TamSx3("C5_NATUREZ")[1]),Nil})
	EndIf
	If Empty(o_PedidoVenda:C5_XMENNOTA) //05/08/2019 - incluido a obrigatoridade da mensagem para nota.
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Informe a mensagem para a nota. Parametro C5_XMENNOTA."
		Conout("FFIEBW01 - mtdGravaPV: Informe a mensagem para a nota. Parametro C5_XMENNOTA.")
		Return(.T.)
	Else
		aAdd( a_CabSC5, {"C5_MENNOTA"	, Alltrim(o_PedidoVenda:C5_XMENNOTA),NIL})
	EndIf
	If !Empty(o_PedidoVenda:C5_TPFRETE)
		aAdd( a_CabSC5, {"C5_TPFRETE"	, Alltrim(o_PedidoVenda:C5_TPFRETE)	,NIL})
	EndIf
	If (o_PedidoVenda:C5_FRETE > 0)
		aAdd( a_CabSC5, {"C5_FRETE"		, o_PedidoVenda:C5_FRETE			,NIL})
	EndIf
	If !Empty(o_PedidoVenda:C5_PARC1)
		aAdd( a_CabSC5, {"C5_PARC1"		, o_PedidoVenda:C5_PARC1			,NIL})
	EndIf
	If !Empty(o_PedidoVenda:C5_DATA1)
		aAdd( a_CabSC5, {"C5_DATA1"		, STOD(o_PedidoVenda:C5_DATA1)		,NIL})
	EndIf
	If !Empty(o_PedidoVenda:C5_XNS1)
		aAdd( a_CabSC5, {"C5_XNS_1"		, Alltrim(o_PedidoVenda:C5_XNS1)	,NIL})
	EndIf
	If !Empty(o_PedidoVenda:C5_PARC2)
		aAdd( a_CabSC5, {"C5_PARC2"		, o_PedidoVenda:C5_PARC2			,NIL})
	EndIf
	If !Empty(o_PedidoVenda:C5_DATA2)
		aAdd( a_CabSC5, {"C5_DATA2"		, STOD(o_PedidoVenda:C5_DATA2)		,NIL})
	EndIf
	If !Empty(o_PedidoVenda:C5_XNS2)
		aAdd( a_CabSC5, {"C5_XNS_2"		, Alltrim(o_PedidoVenda:C5_XNS2)	,NIL})
	EndIf
	If !Empty(o_PedidoVenda:C5_PARC3)
		aAdd( a_CabSC5, {"C5_PARC3"		, o_PedidoVenda:C5_PARC3			,NIL})
	EndIf
	If !Empty(o_PedidoVenda:C5_DATA3)
		aAdd( a_CabSC5, {"C5_DATA3"		, STOD(o_PedidoVenda:C5_DATA3)		,NIL})
	EndIf
	If !Empty(o_PedidoVenda:C5_XNS3)
		aAdd( a_CabSC5, {"C5_XNS_3"		, Alltrim(o_PedidoVenda:C5_XNS3)	,NIL})
	EndIf
	If !Empty(o_PedidoVenda:C5_PARC4)
		aAdd( a_CabSC5, {"C5_PARC4"		, o_PedidoVenda:C5_PARC4			,NIL})
	EndIf
	If !Empty(o_PedidoVenda:C5_DATA4)
		aAdd( a_CabSC5, {"C5_DATA4"		, STOD(o_PedidoVenda:C5_DATA4)		,NIL})
	EndIf
	If !Empty(o_PedidoVenda:C5_XNS4)
		aAdd( a_CabSC5, {"C5_XNS_4"		, Alltrim(o_PedidoVenda:C5_XNS4)	,NIL})
	EndIf
	If !Empty(o_PedidoVenda:C5_XOS)
		aAdd( a_CabSC5, {"C5_XOS"		, Alltrim(o_PedidoVenda:C5_XOS)		,NIL})
	EndIf
	If !Empty(o_PedidoVenda:C5_XCONV)
		aAdd( a_CabSC5, {"C5_XCONV"		, Alltrim(o_PedidoVenda:C5_XCONV)	,NIL})
	EndIf
	If !Empty(o_PedidoVenda:C5_XIDESB)
		aAdd( a_CabSC5, {"C5_XIDESB"	, Alltrim(o_PedidoVenda:C5_XIDESB)	,NIL})
	EndIf
	If !Empty(o_PedidoVenda:C5_XORIGEM)
		aAdd( a_CabSC5, {"C5_XORIGEM"		, Alltrim(o_PedidoVenda:C5_XORIGEM)	,NIL})
	EndIf
	If !Empty(o_PedidoVenda:C5_XCLIDA)
		aAdd( a_CabSC5, {"C5_XCLIDA"	, Alltrim(o_PedidoVenda:C5_XCLIDA)	,NIL})
	EndIf
	If !Empty(o_PedidoVenda:C5_XLOJDA)
		aAdd( a_CabSC5, {"C5_XLOJDA"	, Alltrim(o_PedidoVenda:C5_XLOJDA)	,NIL})
	EndIf
	If !Empty(o_PedidoVenda:C5_XCONTRA)
		aAdd( a_CabSC5, {"C5_XCONTRA"	, Alltrim(o_PedidoVenda:C5_XCONTRA)	,NIL})
	EndIf
	If !Empty(o_PedidoVenda:C5_XNOMES)
		aAdd( a_CabSC5, {"C5_XNOMES"	, Alltrim(o_PedidoVenda:C5_XNOMES)	,NIL})
	EndIf
	If Len(o_PedidoVenda:ITENPV) > 0
		For p:= 1 To Len(o_PedidoVenda:ITENPV)
			DBSELECTAREA("SF4")
			DBSETORDER(1)
			If !(DBSEEK(XFILIAL("SF4")+Alltrim(o_PedidoVenda:ITENPV[p]:C6_TES)))
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "A TES "+Alltrim(o_PedidoVenda:ITENPV[p]:C6_TES)+" nao encontrada na base de dados do protheus."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdGravaPV: A TES "+Alltrim(o_PedidoVenda:ITENPV[p]:C6_TES)+" nao encontrada na base de dados do protheus.")
				Return(.T.)
			EndIf
			If Empty(o_PedidoVenda:ITENPV[p]:C6_PRODUTO)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Informe o codigo do produto."
				Conout("FFIEBW01 - mtdGravaPV: Informe o codigo do produto.")
				Return(.T.)
			EndIf
			DBSELECTAREA("SB1")
			DBSETORDER(1)
			If !(DBSEEK(XFILIAL("SB1")+Alltrim(o_PedidoVenda:ITENPV[p]:C6_PRODUTO)))
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Codigo do produto nao encontrado no Protheus."
				Conout("FFIEBW01 - mtdGravaPV: Codigo do produto nao encontrado no Protheus.")
				Return(.T.)
			EndIf
			If (o_PedidoVenda:ITENPV[p]:C6_QTDVEN <= 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Informe a quantidade do pedido de venda."
				Conout("FFIEBW01 - mtdGravaPV: Informe a quantidade do pedido de venda.")
				Return(.T.)
			EndIf
			If (o_PedidoVenda:ITENPV[p]:C6_PRCVEN <= 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Informe o preco do pedido de venda."
				Conout("FFIEBW01 - mtdGravaPV: Informe o preco do pedido de venda.")
				Return(.T.)
			EndIf
			If (o_PedidoVenda:ITENPV[p]:C6_VALOR <= 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Informe o valor do pedido de venda."
				Conout("FFIEBW01 - mtdGravaPV: Informe o valor do pedido de venda.")
				Return(.T.)
			EndIf
			If !Empty(Alltrim(o_PedidoVenda:ITENPV[p]:C6_CC))
				DbSelectArea("CTT")
				CTT->(dbSetOrder(1))
				If !(CTT->(dbSeek(xFilial("CTT")+Alltrim(o_PedidoVenda:ITENPV[p]:C6_CC))))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Centro de custo nao encontrado ("+Alltrim(o_PedidoVenda:ITENPV[p]:C6_CC)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdGravaPV: Centro de custo nao encontrado  ("+Alltrim(o_PedidoVenda:ITENPV[p]:C6_CC)+").")
					Return(.T.)
				Elseif CTT->CTT_CLASSE == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Centro de custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_PedidoVenda:ITENPV[p]:C6_CC)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdGravaPV: Centro de custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_PedidoVenda:ITENPV[p]:C6_CC)+").")
					Return(.T.)
				Elseif CTT->CTT_BLOQ == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Centro de custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_PedidoVenda:ITENPV[p]:C6_CC)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdGravaPV: Centro de custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_PedidoVenda:ITENPV[p]:C6_CC)+").")
					Return(.T.)
				Endif
			EndIf
			//valida o item
			If !Empty(Alltrim(o_PedidoVenda:ITENPV[p]:C6_ITEMCTA))
				DbSelectArea("CTD")
				CTD->(dbSetOrder(1))
				If !(CTD->(dbSeek(xFilial("CTD")+Alltrim(o_PedidoVenda:ITENPV[p]:C6_ITEMCTA))))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil invalido ("+Alltrim(o_PedidoVenda:ITENPV[p]:C6_ITEMCTA)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdGravaPV: Item contabil invalido ("+Alltrim(o_PedidoVenda:ITENPV[p]:C6_ITEMCTA)+").")
					Return(.T.)
				Elseif CTD->CTD_CLASSE == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_PedidoVenda:ITENPV[p]:C6_ITEMCTA)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdGravaPV: Item contabil invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_PedidoVenda:ITENPV[p]:C6_ITEMCTA)+").")
					Return(.T.)
				Elseif CTD->CTD_BLOQ == "1" .or. (!Empty(CTD->CTD_DTEXSF) .and. CTD->CTD_DTEXSF < dDatabase)
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_PedidoVenda:ITENPV[p]:C6_ITEMCTA)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdGravaPV: Item contabil invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_PedidoVenda:ITENPV[p]:C6_ITEMCTA)+").")
					Return(.T.)
				ElseIf (!Empty(CTD->CTD_DTEXIS) .and. dDatabase < CTD->CTD_DTEXIS)
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil ("+Alltrim(o_PedidoVenda:ITENPV[p]:C6_ITEMCTA)+") esta com data de inicio de existencia superior a data base."+CHR(13)+CHR(10)
					Return(.T.)
				Endif
			EndIf
			If (Alltrim(o_PedidoVenda:ITENPV[p]:C6_RATEIO) <> '1') .And. (Alltrim(o_PedidoVenda:ITENPV[p]:C6_RATEIO) <> '2')
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Valor passado no parametro C6_RATEIO invalido. Informar (1=Tem Rateio; 2=Nao tem rateio)."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdGravaPV: Valor passado no parametro C6_RATEIO invalido. Informar (1=Tem Rateio; 2=Nao tem rateio).")
				Return(.T.)
			EndIf
			c_PVTes:= ""
			//Busca a TES pelo indicador de produtos caso exista para a filial + produto. 05/11/2019
			/*DBSELECTAREA("SBZ")
			DBSETORDER(1)
			If( DBSEEK( o_Empresa:c_Filial + Alltrim( o_PedidoVenda:ITENPV[p]:C6_PRODUTO ) ) )
				c_PVTes:= SBZ->BZ_TS
			Else
				c_PVTes:= Alltrim(o_PedidoVenda:ITENPV[p]:C6_TES)
			EndIf*/
			
			aAdd(a_IteSC6,{ {"C6_FILIAL" 	, o_Empresa:c_Filial							,NIL},;
							{"C6_ITEM"	 	, PADR(Alltrim(StrZero(Val(Alltrim(o_PedidoVenda:ITENPV[p]:C6_ITEM)),TAMSX3("C6_ITEM")[1])), TAMSX3("C6_ITEM")[1])	,NIL},;
							{"C6_PRODUTO"	, Alltrim(o_PedidoVenda:ITENPV[p]:C6_PRODUTO)	,NIL},;
							{"C6_DESCRI" 	, Alltrim(SB1->B1_DESC) 						,NIL},;
							{"C6_UM"  	 	, Alltrim(SB1->B1_UM)			 				,NIL},;
							{"C6_CLI"  		, c_Cliente										,NIL},;
							{"C6_LOJA" 		, c_Loja										,NIL},;
							{"C6_TES" 		, Alltrim(o_PedidoVenda:ITENPV[p]:C6_TES)		,NIL},;
							{"C6_ENTREG" 	, STOD(o_PedidoVenda:ITENPV[p]:C6_ENTREG)		,NIL},;
							{"C6_QTDVEN" 	, o_PedidoVenda:ITENPV[p]:C6_QTDVEN				,NIL},;
							{"C6_PRCVEN" 	, o_PedidoVenda:ITENPV[p]:C6_PRCVEN				,NIL},;
							{"C6_VALOR " 	, ROUND((o_PedidoVenda:ITENPV[p]:C6_VALOR),2)	,NIL},;
							{"C6_CC"		, Alltrim(o_PedidoVenda:ITENPV[p]:C6_CC)		,NIL},;
							{"C6_CCUSTO"	, Alltrim(o_PedidoVenda:ITENPV[p]:C6_CCUSTO)	,NIL},;
							{"C6_RATEIO"	, Alltrim(o_PedidoVenda:ITENPV[p]:C6_RATEIO)	,NIL},;
							{"C6_ITEMCTA"	, Alltrim(o_PedidoVenda:ITENPV[p]:C6_ITEMCTA)	,NIL}})

			// Verifica se te rateio no item
			If Len(o_PedidoVenda:ITENPV[p]:NATRATEIO) > 0
				If (Alltrim(o_PedidoVenda:ITENPV[p]:C6_RATEIO) == '1') //Tem rateio
				//valida se tem o array do rateio para gravar. Se a tag vier em branco, nao grava o array de rateio.
				//If !Empty(o_PedidoVenda:ITENPV[p]:NATRATEIO[1]:AGG_ITEM) .And. !Empty(o_PedidoVenda:ITENPV[p]:NATRATEIO[1]:AGG_CONTA) .And. !Empty(o_PedidoVenda:ITENPV[p]:NATRATEIO[1]:AGG_ITEMCT) .And. (o_PedidoVenda:ITENPV[p]:NATRATEIO[1]:AGG_PERC > 0)
					_cItemPV	:= PADR(Alltrim(StrZero(Val(Alltrim(o_PedidoVenda:ITENPV[p]:C6_ITEM)),TAMSX3("C6_ITEM")[1])), TAMSX3("C6_ITEM")[1])
					_nItRat 	:= Len(o_PedidoVenda:ITENPV[p]:NATRATEIO)
					lFirst 		:= .T.
					Aadd(_aTotRat,{_cItemPV})
					For x := 1 to _nItRat
						_aRateio := {}
						// Carrega vetor do rateio para rotina automatica
						Aadd(_aRateio,{"AGG_FILIAL"	,Alltrim(o_PedidoVenda:ITENPV[p]:NATRATEIO[x]:AGG_FILIAL),NIL} )
						Aadd(_aRateio,{"AGG_ITEM"	,PADR(Alltrim(StrZero(Val(Alltrim(o_PedidoVenda:ITENPV[p]:NATRATEIO[x]:AGG_ITEM)),TAMSX3("AGG_ITEM")[1])), TAMSX3("AGG_ITEM")[1]),NIL} )
						Aadd(_aRateio,{"AGG_PERC"	,o_PedidoVenda:ITENPV[p]:NATRATEIO[x]:AGG_PERC,NIL} )
						Aadd(_aRateio,{"AGG_CONTA"	,Alltrim(o_PedidoVenda:ITENPV[p]:NATRATEIO[x]:AGG_CONTA),NIL} )
						Aadd(_aRateio,{"AGG_CC"		,Alltrim(o_PedidoVenda:ITENPV[p]:NATRATEIO[x]:AGG_CC),NIL} )
						Aadd(_aRateio,{"AGG_ITEMCT"	,Alltrim(o_PedidoVenda:ITENPV[p]:NATRATEIO[x]:AGG_ITEMCT),NIL} )
						Aadd(_aRateio,{"AGG_CLVL"	,Alltrim(o_PedidoVenda:ITENPV[p]:NATRATEIO[x]:AGG_CLVL),NIL} )
						If lFirst
							Aadd(_aTotRat[Len(_aTotRat)],{_aRateio})
							lFirst := .F.
						Else
							Aadd(_aTotRat[Len(_aTotRat)][Len(_aTotRat[Len(_aTotRat)])],{})
						   	_aTotRat[Len(_aTotRat)][Len(_aTotRat[Len(_aTotRat)])][x]:=_aRateio
						Endif
						_lRateio := .T.
					Next
				EndIf
			EndIf
		Next
		//{"C6_QTDLIB" 	, o_PedidoVenda:ITENPV[p]:C6_QTDLIB 			,NIL},;
	EndIf

	BEGIN TRANSACTION

		//GRAVACAO DO PEDIDO DE VENDA
		lMsHelpAuto 	:= .T.
		lMsErroAuto 	:= .F.
		INCLUI 			:= .T.
		ALTERA 			:= .F.

		MSExecAuto( {|a,b,c,d,e,f,g,h,i,j| MATA410(a,b,c,d,e,f,g,h,i,j)}, a_CabSC5 , a_IteSC6 , n_Operacao,,,,,If(_lRateio,_aTotRat,),,)

		IF lMsErroAuto
			//Regra do fonte SIESBA01 da FIEB
			If (__lSX8)
				RollBackSX8()
			EndIf

			// Tratamento da Mensagem de erro do MSExecAuto
			aLogErr  := GetAutoGRLog()
			aLogErr2 := f_TrataErro(aLogErr)
			_cMotivo := ""

			For i := 1 to Len(aLogErr2)
				_cMotivo += aLogErr2[i]
			Next
			If Empty(_cMotivo)
				_cMotivo:= MostraErro("\TOTVSBA_LOG\","pedido_de_venda.txt")
			EndIf
			//Exclusivo para a versao 12
			If (GetVersao(.F.) == "12")
				_cMotivo:=  NoAcentoESB(_cMotivo)
				SetSoapFault('Erro',_cMotivo)
			EndIf

			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= NoAcentoESB(_cMotivo)
			Conout("FFIEBW01 - mtdGravaPV: "+NoAcentoESB(_cMotivo))
			DisarmTransaction()
			Break
		ELSE
			//Chama a funcao de liberacao de pedido
			If (n_Operacao = 3)
				c_NumPed:= SC5->C5_NUM
				/* 28/08/2019 - Retirado a gravacao automatica da nota.
				If _lFatAuto // geracao da nota fiscal de saida					
					// Retorna numero da nota fiscal para o arquivo de Tabelas
					If	SX5->(dbSeek(o_Empresa:c_Filial+"01"+_cSerie))
						_aRetFat := SIESB08Fat(_cSerie)
						IF !_aRetFat[1] //Erro na emissao da nota
							::o_Retorno:l_Status	:= .F.
							::o_Retorno:c_Mensagem	:= _aRetFat[2]
							Conout("FFIEBW01 - mtdGravaPV: "+_aRetFat[2])
						ELSE
							::o_Retorno:l_Status	:= .T.
							::o_Retorno:c_Mensagem	:= "Pedido de Venda e nota incluido com sucesso. Num Pedido: "+SC5->C5_NUM+" - Nota: "+_aRetFat[3]
							Conout("FFIEBW01 - mtdGravaPV: Pedido de Venda e nota incluido com sucesso. Num Pedido: "+SC5->C5_NUM+" - Nota: "+_aRetFat[3])
						ENDIF
					Else
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "Numero de Serie nao encontrado para a filial passada."
						Conout("FFIEBW01 - mtdGravaPV: Numero de Serie nao encontrado")
					Endif
				Else*/
				//Atualiza o campo de total no cabecalho do pedido de venda - 10/09/2020
				n_Total:= 0
				a_C6Area:= SC6->( GetArea() )
				dbSelectArea("SC6")
				dbSetOrder(1)
			    dbSeek( xFilial("SC6") + c_NumPed )
			    While( SC6->( !Eof() ) ) .And. ( SC6->C6_FILIAL + SC6->C6_NUM == xFilial("SC6") + c_NumPed )
			        n_Total += SC6->C6_VALOR
			        SC6->( dbSkip() )
			    EndDo
			    RestArea( a_C6Area )
			    dbSelectArea("SC5")
			    If( SC5->( FieldPos( "C5_FSTOTAL" ) ) > 0 )
				    RecLock("SC5",.F.)
				    SC5->C5_FSTOTAL := n_Total
				    MsUnlock()
				EndIf
				::o_Retorno:l_Status	:= .T.
				::o_Retorno:c_Mensagem	:= "Pedido de Venda incluido com sucesso. Num Pedido: "+SC5->C5_NUM
				Conout("FFIEBW01 - mtdGravaPV: Pedido de Venda incluido com sucesso. Num Pedido: "+SC5->C5_NUM)
				//EndIf
			Else
				If (n_Operacao = 4)
					::o_Retorno:l_Status	:= .T.
					::o_Retorno:c_Mensagem	:= "Pedido de Venda de numero "+SC5->C5_NUM+" alterado com sucesso."
					Conout("FFIEBW01 - mtdGravaPV: Pedido de Venda de numero "+SC5->C5_NUM+" alterado com sucesso.")
				Else
					::o_Retorno:l_Status	:= .T.
					::o_Retorno:c_Mensagem	:= "Pedido de Venda de numero "+SC5->C5_NUM+" excluido com sucesso."
					Conout("FFIEBW01 - mtdGravaPV: Pedido de Venda de numero "+SC5->C5_NUM+" excluido com sucesso.")
				EndIf
			EndIf
		ENDIF

	END TRANSACTION
	//RpcClearEnv() //Limpa o ambiente, liberando a licenca e fechando as conexoes
Return(.T.)
/*/{Protheus.doc} mtdGravaPC
Metodo de gravacao do pedido de compra
@author Totvs-BA
@since 05/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSMETHOD mtdGravaPC WSRECEIVE o_Seguranca, o_Empresa, o_PedidoCompra, Operacao WSSEND o_Retorno WSSERVICE FFIEBW01

	Local a_CabSC7		:= {}
	Local a_IteSC7		:= {}
	Local c_CF			:= ""
	Local I				:= 0
	Local n_Ite			:= 0
	Local c_Fornece		:= ""
	Local c_Loja		:= ""
	Local n_Operacao	:= Val(::Operacao)
	Local _aItem    	:= {}
	Local _aTotItem 	:= {}
	Local _lRateio  	:= .f.
	Local _aTotRat  	:= {}
	Local i,x,p				:= 0
	Local lFirst 		:= .F.

	PRIVATE lMsErroAuto 	:= .F.

	::o_Retorno	:= WSCLASSNEW("strRetorno")

	If !(f_VldFilEmp(o_Empresa:c_Empresa,o_Empresa:c_Filial))
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Codigo de Empresa/Filial nao existe."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGravaPC: Codigo de Empresa/Filial nao existe.")
		Return(.T.)
	EndIf

	//Loga na filial solicitada
	RpcSetType(3)
	RpcSetEnv(o_Empresa:c_Empresa,o_Empresa:c_Filial, "integracao", "fieb123")

	//Posiciona na empresa e filial passada
	dbSelectArea("SM0")
	dbSeek(o_Empresa:c_Empresa+o_Empresa:c_Filial)

	cFilAnt:= o_Empresa:c_Filial

	c_UserWS	:= Upper(ALLTRIM(SUPERGETMV("FS_FIUSRWS",,"totvs_fieb")))
	c_PswWS		:= Upper(ALLTRIM(SUPERGETMV("FS_FIPSWWS",,"totvs@123")))

	//Validando o usuario e senha
	If ( Upper(o_Seguranca:c_Usuario) <> Upper(c_UserWS) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGravaPC: Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido.")
		Return(.T.)
	ElseIf ( Upper(o_Seguranca:c_Senha) <> Upper(c_PswWS) )
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGravaPC: Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida.")
		Return(.T.)
	EndIf
	//If (n_Operacao <> 3) .And. (n_Operacao <> 4) .And. (n_Operacao <> 5)
	If (n_Operacao <> 3) .And. (n_Operacao <> 5)
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Valor passado no parametro Operacao ("+cValToChar(n_Operacao)+") invalido. Informar (3=Inclusao; 5=Exclusao)."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGravaPC: Valor passado no parametro Operacao ("+cValToChar(n_Operacao)+") invalido. Informar (3=Inclusao; 5=Exclusao).")
		Return(.T.)
	EndIf
	If Empty(o_PedidoCompra:CGC)
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Informe o CNPJ/CPF."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGravaPC: Informe o CNPJ/CPF.")
		Return(.T.)
	EndIf
	DBSELECTAREA("SA2")
	DBSETORDER(3)
	If !(DBSEEK(XFILIAL("SA2")+Alltrim(o_PedidoCompra:CGC)))
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "CNPJ/CPF "+Alltrim(o_PedidoCompra:CGC)+" nao encontrado na base de dados do protheus."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGravaPC: CNPJ/CPF "+Alltrim(o_PedidoCompra:CGC)+" nao encontrado na base de dados do protheus.")
		Return(.T.)
	Else
		c_Fornece	:= SA2->A2_COD
		c_Loja		:= SA2->A2_LOJA
	EndIf
	DBSELECTAREA("SE4")
	DBSETORDER(1)
	If !(DBSEEK(XFILIAL("SE4")+Alltrim(o_PedidoCompra:C7_COND)))
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Condicao de pagamento "+Alltrim(o_PedidoCompra:C7_COND)+" nao encontrada na base de dados do protheus."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGravaPC: Condicao de pagamento "+Alltrim(o_PedidoCompra:C7_COND)+" nao encontrada na base de dados do protheus.")
		Return(.T.)
	EndIf
	If Empty(o_PedidoCompra:C7_EMISSAO)
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Informe a data de emissao."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGravaPC: Informe a data de emissao.")
		Return(.T.)
	EndIf
	If !Empty(o_PedidoCompra:C7_TPFRETE)
		If (Upper(Alltrim(o_PedidoCompra:C7_TPFRETE)) <> 'C') .And. (Upper(Alltrim(o_PedidoCompra:C7_TPFRETE)) <> 'F') .And. (Upper(Alltrim(o_PedidoCompra:C7_TPFRETE)) <> 'T') .And. (Upper(Alltrim(o_PedidoCompra:C7_TPFRETE)) <> 'S')
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Tipo de frete "+Upper(Alltrim(o_PedidoCompra:C7_TPFRETE))+" invalido. Informar: (C ou F ou T ou S)."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdGravaPC: Tipo de frete "+Upper(Alltrim(o_PedidoCompra:C7_TPFRETE))+" invalido. Informar: (C ou F ou T ou S).")
			Return(.T.)
		EndIf
	EndIf
	If (Alltrim(o_PedidoCompra:C7_FILENT) <> Alltrim(o_Empresa:c_Filial))
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "A filial informada no campo C7_FILENT eh diferente da filial passada no objeto O_Empresa."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGravaPC: A filial informada no campo C7_FILENT eh diferente da filial passada no objeto O_Empresa.")
		Return(.T.)
	EndIf
	If (o_PedidoCompra:C7_FRETE < 0)
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "O valor do frete nao pode ser menor do que zero."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGravaPC: O valor do frete nao pode ser menor do que zero.")
		Return(.T.)
	EndIf
	If (o_PedidoCompra:C7_SEGURO < 0)
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "O valor do seguro nao pode ser menor do que zero."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGravaPC: O valor do seguro nao pode ser menor do que zero.")
		Return(.T.)
	EndIf
	If (o_PedidoCompra:C7_DESPESA < 0)
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "O valor da despesa nao pode ser menor do que zero."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGravaPC: O valor da despesa nao pode ser menor do que zero.")
		Return(.T.)
	EndIf
	If (Val(o_PedidoCompra:C7_MOEDA) <> 1) .And. (Val(o_PedidoCompra:C7_MOEDA) <> 2)
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Informe a moeda. 1=Real; 2=Dolar."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGravaPC: Informe a moeda. 1=Real; 2=Dolar.")
		Return(.T.)
	EndIf
	If (n_Operacao = 5) //(n_Operacao = 4) .Or.
		If Empty(o_PedidoCompra:PEDIDO)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Para operacao de alteracao ou exclusao o numero do pedido tem que ser informado."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdGravaPC: Para operacao de alteracao ou exclusao o numero do pedido tem que ser informado.")
			Return(.T.)
		Else
			DBSELECTAREA("SC7")
			DBSETORDER(1)
			If !(DBSEEK(XFILIAL("SC7")+Alltrim(o_PedidoCompra:PEDIDO)))
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Pedido "+Alltrim(o_PedidoCompra:PEDIDO)+" nao localizado."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdGravaPC: Pedido "+Alltrim(o_PedidoCompra:PEDIDO)+" nao localizado.")
				Return(.T.)
			Else
				If (SC7->C7_QUJE > 0) .And. (n_Operacao = 5)
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Pedido "+Alltrim(o_PedidoCompra:PEDIDO)+" ja foi movimentado no protheus. Exclusao nao permitida."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdGravaPC: Pedido "+Alltrim(o_PedidoCompra:PEDIDO)+" ja foi movimentado no protheus. Exclusao nao permitida")
					Return(.T.)
				EndIf
			EndIf
		EndIf
	EndIf
	d_TesteData	:=	StoD(o_PedidoCompra:C7_EMISSAO)
	If valtype(d_TesteData) == "D"
		If Empty(d_TesteData)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe a Data de emissao do pedido no formato [AAAAMMDD]."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdGravaPC: Informe a Data de emissao do pedido no formato [AAAAMMDD].")
			Return(.T.)
		EndIf
	Else
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Informe a Data de emissao do pedido no formato [AAAAMMDD]."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGravaPC: Informe a Data de emissao do pedido no formato [AAAAMMDD].")
		Return(.T.)
	EndIf
	If (n_Operacao = 3)
		//Valida se o periodo esta bloqueado.
		c_Err:= ""
		d_TesteData	:=	StoD(o_PedidoCompra:C7_EMISSAO)
		If !( f_VldDtMov( "COM", d_TesteData, @c_Err, "C" ) )
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= c_Err
			Conout("FFIEBW01 - mtdGravaPC: "+c_Err)
			Return(.T.)
		EndIf
	EndIf
	//PREENCHE AS VARIAVEIS PARA O PEDIDO DE compra
	a_CabSC7	:= {}
	a_IteSC7	:= {}

	aAdd( a_CabSC7, { "C7_FILIAL", o_Empresa:c_Filial ,Nil})
	If (n_Operacao = 4) .Or. (n_Operacao = 5)
		If !Empty(o_PedidoCompra:PEDIDO)
			aAdd( a_CabSC7, { "C7_NUM", Padr(Alltrim(o_PedidoCompra:PEDIDO),TamSx3("C7_NUM")[1]) ,Nil})
		EndIf
	EndIf

	aAdd( a_CabSC7, { "C7_EMISSAO"	, STOD(o_PedidoCompra:C7_EMISSAO)	,NIL})
	aAdd( a_CabSC7, { "C7_FORNECE"	, c_Fornece							,NIL})
	aAdd( a_CabSC7, { "C7_LOJA"		, c_Loja							,NIL})
	aAdd( a_CabSC7, { "C7_COND"		, Alltrim(o_PedidoCompra:C7_COND)	,NIL})
	aAdd( a_CabSC7, { "C7_CONTATO"	, Alltrim(o_PedidoCompra:C7_CONTATO),NIL})
	aAdd( a_CabSC7, { "C7_FILENT"	, Alltrim(o_PedidoCompra:C7_FILENT)	,NIL})
	aAdd( a_CabSC7, { "C7_MOEDA"	, Val(o_PedidoCompra:C7_MOEDA)		,NIL})
	aAdd( a_CabSC7, { "C7_TXMOEDA"	, o_PedidoCompra:C7_TXMOEDA			,NIL})

	If !Empty(o_PedidoCompra:C7_TPFRETE)
		aAdd( a_CabSC7, {"C7_TPFRETE"	, Alltrim(o_PedidoCompra:C7_TPFRETE),NIL})
	EndIf
	If (o_PedidoCompra:C7_FRETE > 0)
		aAdd( a_CabSC7, {"C7_FRETE"		, o_PedidoCompra:C7_FRETE			,NIL})
	EndIf
	If (o_PedidoCompra:C7_DESPESA > 0)
		aAdd( a_CabSC7, {"C7_DESPESA"	, o_PedidoCompra:C7_DESPESA			,NIL})
	EndIf
	If (o_PedidoCompra:C7_DESC1 > 0)
		aAdd( a_CabSC7, {"C7_DESC1"		, o_PedidoCompra:C7_DESC1			,NIL})
	EndIf
	If (o_PedidoCompra:C7_DESC2 > 0)
		aAdd( a_CabSC7, {"C7_DESC2"		, o_PedidoCompra:C7_DESC2			,NIL})
	EndIf
	If (o_PedidoCompra:C7_DESC3 > 0)
		aAdd( a_CabSC7, {"C7_DESC3"		, o_PedidoCompra:C7_DESC3			,NIL})
	EndIf
	If (o_PedidoCompra:C7_VLDESC > 0)
		aAdd( a_CabSC7, {"C7_VLDESC"		, o_PedidoCompra:C7_VLDESC		,NIL})
	EndIf
	If Len(o_PedidoCompra:ITENPC) > 0
		For p:= 1 To Len(o_PedidoCompra:ITENPC)
			d_TesteData	:=	StoD(o_PedidoCompra:ITENPC[p]:C7_DATPRF)
			If valtype(d_TesteData) == "D"
				If Empty(d_TesteData)
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Informe o campo C7_DATPRF do pedido no formato [AAAAMMDD]."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdGravaPC: Informe o campo C7_DATPRF do pedido no formato [AAAAMMDD].")
					Return(.T.)
				EndIf
			Else
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe o campo C7_DATPRF do pedido no formato [AAAAMMDD]."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdGravaPC: Informe o campo C7_DATPRF do pedido no formato [AAAAMMDD].")
				Return(.T.)
			EndIf
			//validando a conta debito
			If !Empty(o_PedidoCompra:ITENPC[p]:C7_CONTA)
				DBSELECTAREA("CT1")
				DBSETORDER(1)
				IF !DBSEEK(xFilial("CT1")+Alltrim(o_PedidoCompra:ITENPC[p]:C7_CONTA))
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_PedidoCompra:ITENPC[p]:C7_CONTA)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+"."
					Conout("FFIEBW01 - mtdGravaPC: Codigo da conta contabil ("+Alltrim(o_PedidoCompra:ITENPC[p]:C7_CONTA)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+".")
					Return(.T.)
				ElseIf CT1->CT1_CLASSE == "1"
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_PedidoCompra:ITENPC[p]:C7_CONTA)+") nao pode ser sintetica."
					Conout("FFIEBW01 - mtdGravaPC: Codigo da conta contabil ("+Alltrim(o_PedidoCompra:ITENPC[p]:C7_CONTA)+") nao pode ser sintetica.")
					Return(.T.)
				ElseIf CT1->CT1_BLOQ == "1"
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_PedidoCompra:ITENPC[p]:C7_CONTA)+") esta bloqueada para uso."
					Conout("FFIEBW01 - mtdGravaPC: Codigo da conta contabil ("+Alltrim(o_PedidoCompra:ITENPC[p]:C7_CONTA)+")  esta bloqueada para uso.")
					Return(.T.)
				EndIf
			EndIf
			If (o_PedidoCompra:ITENPC[p]:C7_IPI < 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "O valor do IPI nao pode ser menor do que zero."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdGravaPC: O valor do IPI nao pode ser menor do que zero.")
				Return(.T.)
			EndIf
			If (o_PedidoCompra:ITENPC[p]:C7_PRECO <= 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "O preco nao pode ser menor ou igual a zero."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdGravaPC: O preco nao pode ser menor ou igual a zero.")
				Return(.T.)
			EndIf
			If (o_PedidoCompra:ITENPC[p]:C7_QUANT <= 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "A quantidade nao pode ser menor ou igual a zero."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdGravaPC: A quantidade nao pode ser menor ou igual a zero.")
				Return(.T.)
			EndIf
			If (Upper(Alltrim(o_PedidoCompra:ITENPC[p]:C7_RATEIO)) <> "1") .And. (Upper(Alltrim(o_PedidoCompra:ITENPC[p]:C7_RATEIO)) <> "2")
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Rateio "+Upper(Alltrim(o_PedidoCompra:ITENPC[p]:C7_RATEIO))+" invalido. Informar: (1=Sim ou 2=Nao)."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdGravaPC: Rateio "+Upper(Alltrim(o_PedidoCompra:ITENPC[p]:C7_RATEIO))+" invalido. Informar: (1=Sim ou 2=Nao).")
				Return(.T.)
			EndIf
			If !Empty(o_PedidoCompra:ITENPC[p]:C7_TES)
				DBSELECTAREA("SF4")
				DBSETORDER(1)
				If !(DBSEEK(XFILIAL("SF4")+Alltrim(o_PedidoCompra:ITENPC[p]:C7_TES)))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "A TES "+Alltrim(o_PedidoCompra:ITENPC[p]:C7_TES)+" nao encontrada na base de dados do protheus."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdGravaPC: A TES "+Alltrim(o_PedidoCompra:ITENPC[p]:C7_TES)+" nao encontrada na base de dados do protheus.")
					Return(.T.)
				EndIf
			EndIf
			If Empty(o_PedidoCompra:ITENPC[p]:C7_ITEM)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Informe o item."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdGravaPC: Informe o item.")
				Return(.T.)
			EndIf
			If Empty(o_PedidoCompra:ITENPC[p]:C7_PRODUTO)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Informe o codigo do produto"+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdGravaPC: Informe o codigo do produto")
				Return(.T.)
			Else
				DBSELECTAREA("SB1")
				DBSETORDER(1)
				If !(DBSEEK(XFILIAL("SB1")+Alltrim(o_PedidoCompra:ITENPC[p]:C7_PRODUTO)))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Codigo do produto "+Alltrim(o_PedidoCompra:ITENPC[p]:C7_PRODUTO)+" nao encontrado no Protheus."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdGravaPC: Codigo do produto "+Alltrim(o_PedidoCompra:ITENPC[p]:C7_PRODUTO)+" nao encontrado no Protheus.")
					Return(.T.)
				Else
					//c_Local		:= SB1->B1_LOCPAD
					c_Produto	:= SB1->B1_COD
				EndIf
			EndIf
			If !Empty(o_PedidoCompra:ITENPC[p]:C7_XPCWBC)
				DBSELECTAREA("SC7")
				DBSETORDER(25)
				If (DBSEEK(Alltrim(o_PedidoCompra:ITENPC[p]:C7_XPCWBC)))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Numero PC WBC informado. "+Alltrim(o_PedidoCompra:ITENPC[p]:C7_XPCWBC)+" ja existe gravado."
					Conout("FFIEBW01 - mtdGravaPC: Numero PC WBC informado. "+Alltrim(o_PedidoCompra:ITENPC[p]:C7_XPCWBC)+" ja existe gravado.")
					Return(.T.)
				EndIf
				c_xPcWbc:= Padr(Alltrim(o_PedidoCompra:ITENPC[p]:C7_XPCWBC),TamSx3("C7_XPCWBC")[1])
			Else
				c_xPcWbc:= " "//Padr(Alltrim(o_PedidoCompra:ITENPC[p]:C7_XPCWBC),TamSx3("C7_XPCWBC")[1])
			EndIf
			/*If !Empty(o_PedidoCompra:ITENPC[p]:C7_XIDWBC)
				c_xIdWbc:= Padr(Alltrim(o_PedidoCompra:ITENPC[p]:C7_XIDWBC),TamSx3("C7_XIDWBC")[1])
			Else
				c_xIdWbc:= " "//Padr(Alltrim(o_PedidoCompra:ITENPC[p]:C7_XIDWBC),TamSx3("C7_XIDWBC")[1])
			EndIf*/
			If (n_Operacao <> 3)
				DBSELECTAREA("SC7")
				DBSETORDER(1)
				If !(DBSEEK(XFILIAL("SC7")+Alltrim(o_PedidoCompra:PEDIDO)+Alltrim(o_PedidoCompra:ITENPC[p]:C7_ITEM)))
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Pedido "+Alltrim(o_PedidoCompra:PEDIDO)+" nao localizado."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdGravaPC: Pedido "+Alltrim(o_PedidoCompra:PEDIDO)+" nao localizado.")
					Return(.T.)
				Else
					If (SC7->C7_QUJE > 0) .And. (n_Operacao = 5)
						::o_Retorno:l_Status		:= .F.
						::o_Retorno:c_Mensagem	:= "Pedido "+Alltrim(o_PedidoCompra:PEDIDO)+" ja foi movimentado no protheus. Exclusao nao permitida."+CHR(13)+CHR(10)
						Conout("FFIEBW01 - mtdGravaPC: Pedido "+Alltrim(o_PedidoCompra:PEDIDO)+" ja foi movimentado no protheus. Exclusao nao permitida")
						Return(.T.)
					EndIf
				EndIf
			EndIf
			//DBSELECTAREA("SC7")
			//DBSETORDER(1)
			//DBSEEK(XFILIAL("SC7")+Alltrim(o_PedidoCompra:PEDIDO)+Alltrim(o_PedidoCompra:ITENPC[p]:C7_ITEM))
			aAdd(a_IteSC7,{ {"C7_ITEM"		, PADR(Alltrim(StrZero(Val(Alltrim(o_PedidoCompra:ITENPC[p]:C7_ITEM)),TAMSX3("C7_ITEM")[1])), TAMSX3("C7_ITEM")[1]),Nil},;
							{"C7_PRODUTO"	, c_Produto	,NIL},;
							{"C7_QUANT" 	, o_PedidoCompra:ITENPC[p]:C7_QUANT				,NIL},;
							{"C7_PRECO" 	, o_PedidoCompra:ITENPC[p]:C7_PRECO				,NIL},;
							{"C7_TOTAL" 	, o_PedidoCompra:ITENPC[p]:C7_TOTAL				,NIL},;
							{"C7_XPCWBC"	, c_xPcWbc	,NIL},;
							{"C7_IPI" 		, o_PedidoCompra:ITENPC[p]:C7_IPI				,NIL},;
							{"C7_DATPRF" 	, STOD(o_PedidoCompra:ITENPC[p]:C7_DATPRF)		,NIL},;
							{"C7_TES" 		, Alltrim(o_PedidoCompra:ITENPC[p]:C7_TES)		,NIL},;
							{"C7_OBS"		, Alltrim(o_PedidoCompra:ITENPC[p]:C7_OBS)		,NIL},;
							{"C7_CONTA"		, Alltrim(o_PedidoCompra:ITENPC[p]:C7_CONTA)	,NIL},;
							{"C7_RATEIO"	, Alltrim(o_PedidoCompra:ITENPC[p]:C7_RATEIO)	,NIL}})
							//{"C7_XIDWBC"	, c_xIdWbc	,NIL}})

			//Se for opcao Alteracao ou Exclusao, o campo C7_REC_WT tem que estar preenchido com o numero do Registro (Recno())
			/*
				Retirei alteracao (Operacao = 4) por que nao estava funcionando.
				27/10/2017 - Adriano.
			*/
			If (n_Operacao = 5) //(n_Operacao = 4) .Or.
				DBSELECTAREA("SC7")
				DBSETORDER(1)
				If (DBSEEK(XFILIAL("SC7")+Alltrim(o_PedidoCompra:PEDIDO)+Alltrim(o_PedidoCompra:ITENPC[p]:C7_ITEM)))
					aAdd(a_IteSC7[Len(a_IteSC7)],{"C7_REC_WT" ,SC7->(RECNO()) ,Nil})
				Else
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item "+Alltrim(o_PedidoCompra:ITENPC[p]:C7_ITEM)+" nao existe neste pedido de compra "+Alltrim(o_PedidoCompra:PEDIDO)+"."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdGravaPC: Item "+Alltrim(o_PedidoCompra:ITENPC[p]:C7_ITEM)+" nao existe neste pedido de compra "+Alltrim(o_PedidoCompra:PEDIDO)+".")
					Return(.T.)
				EndIf
			EndIf
			/*
				Retirei alteracao (Operacao = 4) por que nao estava funcionando.
				27/10/2017 - Adriano.
			*/
			If (n_Operacao = 3) //.Or. (n_Operacao = 4)
				// Verifica se te rateio no item
				If Len(o_PedidoCompra:ITENPC[p]:NATRATEIO) > 0
					//valida se tem o array do rateio para gravar. Se a tag vier em branco, nao grava o array de rateio.
					If !Empty(o_PedidoCompra:ITENPC[p]:NATRATEIO[1]:CH_ITEM) .And. !Empty(o_PedidoCompra:ITENPC[p]:NATRATEIO[1]:CH_CONTA) .And. !Empty(o_PedidoCompra:ITENPC[p]:NATRATEIO[1]:CH_ITEMCTA) .And. (o_PedidoCompra:ITENPC[p]:NATRATEIO[1]:CH_PERC > 0)
						_cItemPV	:= PADR(Alltrim(StrZero(Val(Alltrim(o_PedidoCompra:ITENPC[p]:C7_ITEM)),4)), TAMSX3("C7_ITEM")[1])
						_nItRat 	:= Len(o_PedidoCompra:ITENPC[p]:NATRATEIO)
						lFirst 		:= .T.
						Aadd(_aTotRat,{_cItemPV})
						n_TotPerc:= 0
						For x := 1 to _nItRat
							//Validando a conta contabil
							If !Empty(Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CONTA))
								DBSELECTAREA("CT1")
								DBSETORDER(1)
								IF !DBSEEK(xFilial("CT1")+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CONTA))
									::o_Retorno:l_Status		:= .F.
									::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CONTA)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+"."
									Conout("FFIEBW01 - mtdGravaPC: Codigo da conta contabil ("+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CONTA)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+".")
									Return(.T.)
								ElseIf CT1->CT1_CLASSE == "1"
									::o_Retorno:l_Status		:= .F.
									::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CONTA)+") nao pode ser sintetica."
									Conout("FFIEBW01 - mtdGravaPC: Codigo da conta contabil ("+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CONTA)+") nao pode ser sintetica.")
									Return(.T.)
								ElseIf CT1->CT1_BLOQ == "1"
									::o_Retorno:l_Status		:= .F.
									::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CONTA)+") esta bloqueada para uso."
									Conout("FFIEBW01 - mtdGravaPC: Codigo da conta contabil ("+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CONTA)+")  esta bloqueada para uso.")
									Return(.T.)
								EndIf
							EndIf
							//Validando o centro de custo
							If !Empty(Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CC))
								c_CHCTT:= Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CC)
								DbSelectArea("CTT")
								CTT->(dbSetOrder(1))
								If !(CTT->(dbSeek(xFilial("CTT")+c_CHCTT)))
									::o_Retorno:l_Status	:= .F.
									::o_Retorno:c_Mensagem	:= "Centro de Custo invalido ("+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CC)+")."+CHR(13)+CHR(10)
									Conout("FFIEBW01 - mtdGravaPC: Centro de Custo invalido ("+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CC)+").")
									Return(.T.)
								Elseif CTT->CTT_CLASSE == "1"
									::o_Retorno:l_Status	:= .F.
									::o_Retorno:c_Mensagem	:= "Centro de Custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CC)+")."+CHR(13)+CHR(10)
									Conout("FFIEBW01 - mtdGravaPC: Centro de Custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CC)+").")
									Return(.T.)
								Elseif CTT->CTT_BLOQ == "1"
									::o_Retorno:l_Status	:= .F.
									::o_Retorno:c_Mensagem	:= "Centro de Custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CC)+")."+CHR(13)+CHR(10)
									Conout("FFIEBW01 - mtdGravaPC: Centro de Custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CC)+").")
									Return(.T.)
								Endif
							EndIf

							//valida o item
							If !Empty(Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_ITEMCTA))
								DbSelectArea("CTD")
								CTD->(dbSetOrder(1))
								If !(CTD->(dbSeek(xFilial("CTD")+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_ITEMCTA))))
									::o_Retorno:l_Status	:= .F.
									::o_Retorno:c_Mensagem	:= "Item contabil invalido ("+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_ITEMCTA)+")."+CHR(13)+CHR(10)
									Conout("FFIEBW01 - mtdGravaPC: Item contabil invalido ("+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_ITEMCTA)+").")
									Return(.T.)
								Elseif CTD->CTD_CLASSE == "1"
									::o_Retorno:l_Status	:= .F.
									::o_Retorno:c_Mensagem	:= "Item contabil invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_ITEMCTA)+")."+CHR(13)+CHR(10)
									Conout("FFIEBW01 - mtdGravaPC: Item contabil invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_ITEMCTA)+").")
									Return(.T.)
								Elseif CTD->CTD_BLOQ == "1" .or. (!Empty(CTD->CTD_DTEXSF) .and. CTD->CTD_DTEXSF < dDatabase)
									::o_Retorno:l_Status	:= .F.
									::o_Retorno:c_Mensagem	:= "Item contabil invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_ITEMCTA)+")."+CHR(13)+CHR(10)
									Conout("FFIEBW01 - mtdGravaPC: Item contabil invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_ITEMCTA)+").")
									Return(.T.)
								ElseIf (!Empty(CTD->CTD_DTEXIS) .and. dDatabase < CTD->CTD_DTEXIS)
									::o_Retorno:l_Status	:= .F.
									::o_Retorno:c_Mensagem	:= "Item contabil ("+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_ITEMCTA)+") esta com data de inicio de existencia superior a data base."+CHR(13)+CHR(10)			
									Return(.T.)
								Endif
							EndIf
							//valida a classe de valor
							If !Empty(Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CLVL))
								//Validando a classe de valor
								DbSelectArea("CTH")
								CTH->(dbSetOrder(1))
								If !(CTH->(dbSeek(xFilial("CTH")+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CLVL))))
									::o_Retorno:l_Status	:= .F.
									::o_Retorno:c_Mensagem	:= "Classe de valor invalido ("+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CLVL)+")."+CHR(13)+CHR(10)
									Conout("FFIEBW01 - mtdGravaPC: Classe de valor invalido ("+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CLVL)+").")
									Return(.T.)
								Elseif CTH->CTH_CLASSE == "1"
									::o_Retorno:l_Status	:= .F.
									::o_Retorno:c_Mensagem	:= "Classe de valor invalido. O Classe de valor nao pode ser sintetico ("+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CLVL)+")."+CHR(13)+CHR(10)
									Conout("FFIEBW01 - mtdGravaPC: Classe de valor invalido. O Classe de valor nao pode ser sintetico ("+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CLVL)+").")
									Return(.T.)
								Elseif CTH->CTH_BLOQ == "1"
									::o_Retorno:l_Status	:= .F.
									::o_Retorno:c_Mensagem	:= "Classe de valor invalido. o Classe de valor esta bloqueado para uso ("+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CLVL)+")."+CHR(13)+CHR(10)
									Conout("FFIEBW01 - mtdGravaPC: Classe de valor invalido. o Classe de valor esta bloqueado para uso ("+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CLVL)+").")
									Return(.T.)
								Endif
							EndIf

							//Valida se a conta comeca com 3 OU 4 e obriga o UO (CH_CC) e CR (CH_ITEMCTA)
							/* Comentado em 12/09/18 caso precise ativar!
							If (Substr( Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CONTA),1,1 ) $ '3,4') .And. (Empty(Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CC)) .Or. Empty(Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_ITEMCTA)))
								::o_Retorno:l_Status	:= .F.
								::o_Retorno:c_Mensagem	:= "Para conta que comecam com 3 ou 4 ("+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CONTA)+") o CR e Uo devem ser preenchidos."
								Conout("FFIEBW01 - mtdGravaPC: Para conta que comecam com 3 ou 4 ("+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CONTA)+") o CR e Uo devem ser preenchidos.")
								Return(.T.)
							Else
								//Verifica se existe amarracao Filial + CR + UO - 11/09/2018
								If !(VerAmarrCTA(Alltrim(o_Empresa:c_Filial), Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CC), Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_ITEMCTA)))
									::o_Retorno:l_Status	:= .F.
									::o_Retorno:c_Mensagem	:= "Nao existe amarracao (Tabela CTA) entre Filial: ("+Alltrim(o_Empresa:c_Filial)+"), CR: ("+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_ITEMCTA)+") e Uo: ("+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CC)+")."
									Conout("FFIEBW01 - mtdGravaPC: Nao existe amarracao (Tabela CTA) entre Filial: ("+Alltrim(o_Empresa:c_Filial)+"), CR: ("+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_ITEMCTA)+") e Uo: ("+Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CC)+").")
									Return(.T.)
								EndIf
							EndIf*/
							_aRateio := {}
							// Carrega vetor do rateio para rotina automatica
							Aadd(_aRateio,{"CH_FILIAL"	,Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_FILIAL),NIL} )
							Aadd(_aRateio,{"CH_ITEM"	,PADR(Alltrim(StrZero(Val(Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_ITEM)),TAMSX3("CH_ITEM")[1])), TAMSX3("CH_ITEM")[1]),NIL} )
							Aadd(_aRateio,{"CH_PERC"	,o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_PERC,NIL} )
							Aadd(_aRateio,{"CH_CC"		,Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CC),NIL} )
							Aadd(_aRateio,{"CH_CONTA"	,Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CONTA),NIL} )
							Aadd(_aRateio,{"CH_ITEMCTA"	,Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_ITEMCTA),NIL} )
							Aadd(_aRateio,{"CH_CLVL"	,Alltrim(o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_CLVL),NIL} )
							If lFirst
								Aadd(_aTotRat[Len(_aTotRat)],{_aRateio})
								lFirst := .F.
							Else
								Aadd(_aTotRat[Len(_aTotRat)][Len(_aTotRat[Len(_aTotRat)])],{})
							   	_aTotRat[Len(_aTotRat)][Len(_aTotRat[Len(_aTotRat)])][x]:=_aRateio
							Endif
							_lRateio := .T.
							n_TotPerc+= o_PedidoCompra:ITENPC[p]:NATRATEIO[x]:CH_PERC
						Next
						If (n_TotPerc <> 100)
							::o_Retorno:l_Status	:= .F.
							::o_Retorno:c_Mensagem	:= "A soma do percentual do rateio para o item "+_cItemPV+" nao bate 100%."+CHR(13)+CHR(10)
							Conout("FFIEBW01 - mtdGravaPC: A soma do percentual do rateio para o item "+_cItemPV+" nao bate 100%.")
							Return(.T.)
						EndIf
					EndIf
				EndIf
			EndIf
		Next
	EndIf
	/*
		Retirei alteracao (Operacao = 4) por que nao estava funcionando.
		27/10/2017 - Adriano.
	*/
	BEGIN TRANSACTION

		//GRAVACAO DO PEDIDO DE COMPRA
		lMsHelpAuto 	:= .T.
		lMsErroAuto 	:= .F.
		If (n_Operacao = 3)
			INCLUI 			:= .T.
			ALTERA 			:= .F.
		//ElseIf (n_Operacao = 4)
		//	INCLUI 			:= .F.
		//	ALTERA 			:= .T.
		EndIf

		MSExecAuto( {|u,v,w,x,y,z| MATA120(u,v,w,x,y,z)},1,a_CabSC7,a_IteSC7,n_Operacao,,/*Array do Rateio*/Iif(_lRateio,_aTotRat,Nil))

		IF lMsErroAuto
			//Regra do fonte SIESBA01 da FIEB
			If (__lSX8)
				RollBackSX8()
			EndIf

			// Tratamento da Mensagem de erro do MSExecAuto
			aLogErr  := GetAutoGRLog()
			aLogErr2 := f_TrataErro(aLogErr)
			_cMotivo := ""

			For i := 1 to Len(aLogErr2)
				_cMotivo += aLogErr2[i]
			Next

			//Exclusivo para a versao 12
			If (GetVersao(.F.) == "12")
				_cMotivo:=  NoAcentoESB(_cMotivo)
				SetSoapFault('Erro',_cMotivo)
			EndIf

			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= NoAcentoESB(_cMotivo)
			Conout("FFIEBW01 - mtdGravaPC: "+NoAcentoESB(_cMotivo))
			DisarmTransaction()
			Break
		ELSE
			If (n_Operacao = 3)
				::o_Retorno:l_Status	:= .T.
				::o_Retorno:c_Mensagem	:= "Pedido de compra de numero "+SC7->C7_NUM+" incluido com sucesso."
				Conout("FFIEBW01 - mtdGravaPC: Pedido de compra de numero "+SC7->C7_NUM+" incluido com sucesso.")
			Else
				//If (n_Operacao = 4)
				//	::o_Retorno:l_Status	:= .T.
				//	::o_Retorno:c_Mensagem	:= "Pedido de compra de numero "+SC7->C7_NUM+" alterado com sucesso."
				//	Conout("FFIEBW01 - mtdGravaPC: Pedido de compra de numero "+SC7->C7_NUM+" alterado com sucesso.")
				//Else
				::o_Retorno:l_Status	:= .T.
				::o_Retorno:c_Mensagem	:= "Pedido de compra de numero "+SC7->C7_NUM+" excluido com sucesso."
				Conout("FFIEBW01 - mtdGravaPC: Pedido de compra de numero "+SC7->C7_NUM+" excluido com sucesso.")
				//EndIf
			EndIf
		ENDIF

	END TRANSACTION
	//RpcClearEnv() //Limpa o ambiente, liberando a licenca e fechando as conexoes

Return(.T.)
/*/{Protheus.doc} mtdContabiliza
Metodo de contabilizacao
@author Totvs-BA
@since 13/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSMETHOD mtdContabiliza WSRECEIVE o_Seguranca, o_Empresa, o_Contabiliza, Operacao WSSEND o_Retorno WSSERVICE FFIEBW01

	//Local n_Linha	 	:= 1
	Local aItens 		:= {}
	Local aCab 			:= {}
	Local c_Cod			:= ""
	Local c_Loja		:= ""
	Local n_Operacao	:= Val(::Operacao)
	//Local c_FSTIT		:= ""
	Local i,c,u			:= 0
	Local n_RegExist	:= 0
	Local n_RegNExist	:= 0
	Local c_ErrMsg		:= ""
	Local l_TemLtRM		:= .F.
	Local a_LoteRM		:= {}
	Local c_NumsLtRM	:= ""
	Local c_RmDoc		:= ""
	PRIVATE lMsErroAuto := .F.
	
	STATIC __lHasCTKSxe 
	
	::o_Retorno	:= WSCLASSNEW("strRetorno")

	If !(f_VldFilEmp(o_Empresa:c_Empresa,o_Empresa:c_Filial))
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Codigo de Empresa/Filial nao existe."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdContabiliza: Codigo de Empresa/Filial nao existe.")
		Return(.T.)
	EndIf

	//Loga na filial solicitada
	RpcSetType(3)
	RpcSetEnv(o_Empresa:c_Empresa,o_Empresa:c_Filial, "integracao", "fieb123")

	//Posiciona na empresa e filial passada
	dbSelectArea("SM0")
	dbSeek(o_Empresa:c_Empresa+o_Empresa:c_Filial)

	cFilAnt:= o_Empresa:c_Filial

	c_UserWS	:= Upper(ALLTRIM(SUPERGETMV("FS_FIUSRWS",,"totvs_fieb")))
	c_PswWS		:= Upper(ALLTRIM(SUPERGETMV("FS_FIPSWWS",,"totvs@123")))

	//Validando o usuario e senha
	If ( Upper(o_Seguranca:c_Usuario) <> Upper(c_UserWS) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdContabiliza: Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido.")
		Return(.T.)
	ElseIf ( Upper(o_Seguranca:c_Senha) <> Upper(c_PswWS) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdContabiliza: Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida.")
		Return(.T.)
	ElseIf (n_Operacao <> 3)
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Valor passado no parametro Operacao ("+cValToChar(n_Operacao)+") invalido. Informar (3=Inclusao de contabilizacao)."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdContabiliza: Valor passado no parametro Operacao ("+cValToChar(n_Operacao)+") invalido. Informar (3=Inclusao de contabilizacao).")
		Return(.T.)
	EndIf
	d_TesteData	:=	StoD(o_Contabiliza:DDATALANC)
	If valtype(d_TesteData) == "D"
		If Empty(d_TesteData)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe a Data do lancamento no formato [AAAAMMDD]."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdContabiliza: Informe a Data do lancamento no formato [AAAAMMDD].")
			Return(.T.)
		EndIf
	Else
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Informe a Data do lancamento no formato [AAAAMMDD]."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdContabiliza: Informe a Data do lancamento no formato [AAAAMMDD].")
		Return(.T.)
	EndIf
	If (n_Operacao = 3)
		//Valida se o periodo esta bloqueado.
		c_Err:= ""
		d_TesteData	:=	StoD(o_Contabiliza:DDATALANC)
		If !( f_VldDtMov( "CTB", d_TesteData, @c_Err, "B" ) )
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= c_Err
			Conout("FFIEBW01 - mtdContabiliza: "+c_Err)
			Return(.T.)
		EndIf
	EndIf

	d_Data   := STOD(Alltrim(o_Contabiliza:DDATALANC))
	c_Lote   := Alltrim(o_Contabiliza:CLOTE)
	c_SbLote := Alltrim(o_Contabiliza:CSUBLOTE)
	c_Doc    := "000001"//Alltrim(o_Contabiliza:CDOC) a rotina incrementa como a funcao abaixo

	//Verifica se a chave existe e sugere o proximo lote - retirado do fonte padrao
	CTF_LOCK	:= 0
	//Verifica o Numero do Proximo documento contabil
	Do While !ProxDoc(d_Data,c_Lote,c_SbLote,@c_Doc,@CTF_LOCK)
		//Caso o Nao do Doc estourou, incrementa o lote
		c_Lote := Soma1(c_Lote)
		DbSelectArea("SX5")
		MsSeek(xFilial("SX5")+"09"+"CON")
		RecLock("SX5")
		SX5->X5_DESCRI := Substr(c_Lote,3,4)
		MsUnlock()
	Enddo

	If Empty(d_Data) .Or. Empty(c_Lote) .Or. Empty(c_SbLote) .Or. Empty(c_Doc)
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Alguns campos do cabecalho nao foram informados."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdContabiliza: Alguns campos do cabecalho nao foram informados.")
		Return(.T.)
	EndIf

	aCab 	:= {{'DDATALANC'	,d_Data			,NIL},;
				{'CLOTE' 		,c_Lote 		,NIL},;
				{'CSUBLOTE' 	,c_SbLote 		,NIL},;
				{'CDOC' 		,c_Doc	 		,NIL},;
				{'CPADRAO'		,'' �� ��� ��� �,NIL},;
			�� �{'NTOTINF'		,0 �� ��� ��� ��,NIL},;
			�� �{'NTOTINFLOT'	,0 �� ��� ��� ��,NIL}}

	aItens	:= {}

	//INICIO - Tratamento para verificar se ja foi gravado os IDs da contabilizacao do RM. Para os casos de envio mais de uma vez.
	n_RegExist	:=	0
	n_RegNExist	:=	0
	l_TemLtRM	:= .F.
	If(Upper(Alltrim(o_Contabiliza:AGRAVADIRETO)) <> 'S') //Usa MSExecAuto
		//Verifica se a contabilizacao tem lote Rm
		For c:= 1 To Len(o_Contabiliza:ITENCT2)
			If !Empty(Alltrim(o_Contabiliza:ITENCT2[c]:CT2_FSIDRM))
				l_TemLtRM:= .T.
				Exit
			EndIf
		Next
		If (l_TemLtRM)			
			c_RmDoc		:= ""
			For c:= 1 To Len(o_Contabiliza:ITENCT2)
				//Verifica se ja existe o id do lancamento do Rm no CT2. Passa o IDRM e o CT2_DC pq para cada linha (debito ou credito) e complemento de historico o IDRM
				//eh unico. Logo, para um documento/lote/data/sublote com varias linhas, eh enviado varios IDRM.
				cQuery := ""
				cQuery += "SELECT CT2_FSIDRM, CT2_DOC FROM " + RetSqlName( "CT2" ) + " CT2 (NOLOCK) "+CHR(13)+CHR(10)
				cQuery += "WHERE "+CHR(13)+CHR(10)
				cQuery += "CT2_FILIAL 	= '" + o_Empresa:c_Filial + "' AND "+CHR(13)+CHR(10)
				cQuery += "CT2_FSIDRM 	= '" + Alltrim(o_Contabiliza:ITENCT2[c]:CT2_FSIDRM)+"' AND "+CHR(13)+CHR(10)
				cQuery += "CT2_DATA		= '" + Alltrim(o_Contabiliza:DDATALANC)+"' AND "+CHR(13)+CHR(10)
				cQuery += "CT2_LOTE		= '" + Alltrim(o_Contabiliza:CLOTE)+"' AND "+CHR(13)+CHR(10)
				cQuery += "CT2_SBLOTE	= '" + Alltrim(o_Contabiliza:CSUBLOTE)+"' AND "+CHR(13)+CHR(10)
				cQuery += "CT2_ORIGEM	= 'FFIEBW01' AND "+CHR(13)+CHR(10)
				cQuery += "CT2_ROTINA	IN ('CTBA102','INTEGRARM') AND "+CHR(13)+CHR(10)
				cQuery += "CT2_DC		= '"+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_DC)+"' AND "+CHR(13)+CHR(10)
				cQuery += "D_E_L_E_T_ = ' '
				TCQUERY cQuery ALIAS QRY NEW
				If (QRY->(!Eof()))
					n_RegExist++
					c_RmDoc:= Alltrim( QRY->CT2_DOC )
				Else
					n_RegNExist++
				EndIf
				DbSelectArea("QRY")
				QRY->(DbCloseArea())
			Next
			If( n_RegExist == Len( o_Contabiliza:ITENCT2 ) )
			  	::o_Retorno:l_Status	:= .T. //- Ajustado para nao retornar Erro na integracao conforme solicitacao de Rafael.
			  	::o_Retorno:c_Mensagem	:= "### Movimento contabil ja gravado na contabilidade. ("+o_Empresa:c_Filial+"-"+Dtoc(d_Data)+"-"+c_Lote+"-"+c_SbLote+"-"+c_RmDoc+")."+CHR(13)+CHR(10)
			  	RETURN .T.
			ElseIf( n_RegNExist > 0 ) .And. ( n_RegNExist < Len( o_Contabiliza:ITENCT2 ) )
			  	::o_Retorno:l_Status	:= .F. //- Ajustado para nao retornar Erro na integracao conforme solicitacao de Rafael.
			  	::o_Retorno:c_Mensagem	:= "Identificado no movimento ("+o_Empresa:c_Filial+"-"+Dtoc(d_Data)+"-"+c_Lote+"-"+c_SbLote+") uma inconsistencia nos ids do RM. Reprocesse o lancamento."+CHR(13)+CHR(10)
			  	//Conout("FFIEBW01 - mtdContabiliza - Idetificado que no lote processado existem alguns id s RM ja inseridos na base do Protheus. O lote esta contabilizado incorretamente.")
			  	RETURN .T.
			Endif
		EndIf
	EndIf
	//FIM - Tratamento para verificar se ja foi gravado os IDs da contabilizacao do RM. Para os casos de envio mais de uma vez.
	
	//=======================================================================================================
	lAchouCTK 	:= .T.
	cSeqChave	:= ""
	If ( __lHasCTKSxe == NIL )
		__lHasCTKSxe := FindFunction('HASCTKSXE')
	EndIf
	// Gerar o codigo para a sequencia do lancamento. Se o codigo gerado ja foi utilizado, 
	// despreza-lo e continuar gerando ate encontrar um que nao exista no CTK.
	While lAchouCTK			
		If ( ! __lHasCTKSxe )
			cSeqChave := GetSx8Num("CTK","CTK_SEQUEN",,1)	
		Else
			cSeqChave := GetSx8Num("_CT")	
		EndIf
	
		lAchouCTK := CTK->( MsSeek( xFilial("CTK")+cSeqChave,.F. ) )
	End
	//=======================================================================================================
	
	For c:= 1 To Len(o_Contabiliza:ITENCT2)

		If !Empty(o_Contabiliza:ITENCT2[c]:REFERENCIA) //Se esta contabilizando titulo ou pedido de venda, para gravar os dados do mesmo no CT2
			If (Alltrim(o_Contabiliza:ITENCT2[c]:CT2_DC) <> '4') //Complemento de historico
				If (Upper(Alltrim(o_Contabiliza:ITENCT2[c]:REFERENCIA)) <> "R") .And. (Upper(Alltrim(o_Contabiliza:ITENCT2[c]:REFERENCIA)) <> "P") .And. (Upper(Alltrim(o_Contabiliza:ITENCT2[c]:REFERENCIA)) <> "V")
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Referencia "+Upper(Alltrim(o_Contabiliza:ITENCT2[c]:REFERENCIA))+" invalida. Informar: (P, R ou V)."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdContabiliza: Referencia "+Upper(Alltrim(o_Contabiliza:ITENCT2[c]:REFERENCIA))+" invalida. Informar: (P, R ou V).")
					Return(.T.)
				EndIf
				If (Upper(Alltrim(o_Contabiliza:ITENCT2[c]:REFERENCIA)) == "R") //Contas a Receber
					If Empty(o_Contabiliza:ITENCT2[c]:CGC)
						::o_Retorno:l_Status		:= .F.
						::o_Retorno:c_Mensagem	:= "Para a referencia R ou P, o CNPJ ou CPF deve ser informado."+CHR(13)+CHR(10)
						Conout("FFIEBW01 - mtdContabiliza: Para a referencia R ou P, o CNPJ ou CPF deve ser informado.")
						Return(.T.)
					EndIf				
					c_Pre:= PADR(Alltrim(o_Contabiliza:ITENCT2[c]:PREFIXO), TAMSX3("E1_PREFIXO")[1])
					c_Num:= PADR(Alltrim(o_Contabiliza:ITENCT2[c]:NUMERO), TAMSX3("E1_NUM")[1])
					c_Par:= PADR(Alltrim(o_Contabiliza:ITENCT2[c]:PARCELA), TAMSX3("E1_PARCELA")[1])
					c_Tip:= PADR(Alltrim(o_Contabiliza:ITENCT2[c]:TIPO), TAMSX3("E1_TIPO")[1])
					DBSELECTAREA("SA1")
					DBSETORDER(3)
					If !(DBSEEK(XFILIAL("SA1")+Alltrim(o_Contabiliza:ITENCT2[c]:CGC)))
						::o_Retorno:l_Status		:= .F.
						::o_Retorno:c_Mensagem	:= "CNPJ/CPF "+Alltrim(o_Contabiliza:ITENCT2[c]:CGC)+" nao encontrado na base de dados do protheus."+CHR(13)+CHR(10)
						Conout("FFIEBW01 - mtdContabiliza: CNPJ/CPF "+Alltrim(o_Contabiliza:ITENCT2[c]:CGC)+" nao encontrado na base de dados do protheus.")
						Return(.T.)
					Else
						c_Cod	:= SA1->A1_COD
						c_Loj	:= SA1->A1_LOJA
						//Verifica se a contabilizacao se refere a um titulo ativo e verifica se o titulo existe
						If (Alltrim(o_Contabiliza:ITENCT2[c]:REFLANC) == "A") //Ativo
							/* Retirado a validacao em 29/07. A por conta dos pedidos do datasul que nao vieram para o protheus.
							DBSELECTAREA("SE1")
							DBSETORDER(1)
							If !(DBSEEK(XFILIAL("SE1")+c_Pre+c_Num+c_Par+c_Tip+c_Cod+c_Loj))
								::o_Retorno:l_Status	:= .F.
								::o_Retorno:c_Mensagem	:= "A referecia do lancamento eh 'A' porem os dados do titulo nao foram encontrados no Contas a Receber."+CHR(13)+CHR(10)
								Conout("FFIEBW01 - mtdContabiliza: A referecia do lancamento eh 'A' porem os dados do titulo nao foram encontrados no Contas a Receber.")
								Return(.T.)
							EndIf*/
						ElseIf (Alltrim(o_Contabiliza:ITENCT2[c]:REFLANC) == "E") //Estorno
							DBSELECTAREA("SE1")
							DBSETORDER(1)
							If !(DBSEEK(XFILIAL("SE1")+c_Pre+c_Num+c_Par+c_Tip+c_Cod+c_Loj))
								//Verifica se o titulo ja foi deletado
								c_Qry:= "SELECT E1_NUM "+chr(13)+chr(10)
								c_Qry+= "FROM "+RETSQLNAME("SE1")+" "+chr(13)+chr(10)
								c_Qry+= "WHERE D_E_L_E_T_ = '*' "+chr(13)+chr(10)
								c_Qry+= "AND E1_FILIAL = '"+XFILIAL("SE1")+"'"+chr(13)+chr(10)
								c_Qry+= "AND E1_PREFIXO = '"+c_Pre+"'"+chr(13)+chr(10)
								c_Qry+= "AND E1_NUM 	= '"+c_Num+"'"+chr(13)+chr(10)
								c_Qry+= "AND E1_PARCELA = '"+c_Par+"'"+chr(13)+chr(10)
								c_Qry+= "AND E1_TIPO 	= '"+c_Tip+"'"+chr(13)+chr(10)
								c_Qry+= "AND E1_CLIENTE = '"+c_Cod+"'"+chr(13)+chr(10)
								c_Qry+= "AND E1_LOJA 	= '"+c_Loj+"'"+chr(13)+chr(10)
								TCQUERY c_Qry ALIAS QRY NEW
								If (QRY->(Eof()))
									::o_Retorno:l_Status	:= .F.
									::o_Retorno:c_Mensagem	:= "O titulo: "+XFILIAL("SE1")+c_Pre+c_Num+c_Par+c_Tip+c_Cod+c_Loj+" nunca existiu na base."
									Conout("FFIEBW01 - mtdContabiliza: O titulo: "+XFILIAL("SE1")+c_Pre+c_Num+c_Par+c_Tip+c_Cod+c_Loj+" nunca existiu na base.")
									dbSelectArea("QRY")
									QRY->(dbCloseArea())
									Return(.T.)
								Else
									//nao faz nada
									dbSelectArea("QRY")
									QRY->(dbCloseArea())
								EndIf
							EndIf
						EndIf
					EndIf
				ElseIf (Upper(Alltrim(o_Contabiliza:ITENCT2[c]:REFERENCIA)) == "P") //Contas a Pagar
					If Empty(o_Contabiliza:ITENCT2[c]:CGC)
						::o_Retorno:l_Status		:= .F.
						::o_Retorno:c_Mensagem	:= "CNPJ ou CPF nao foi informado."+CHR(13)+CHR(10)
						Conout("FFIEBW01 - mtdContabiliza: CNPJ ou CPF nao foi informado.")
						Return(.T.)
					EndIf
					c_Pre:= PADR(Alltrim(o_Contabiliza:ITENCT2[c]:PREFIXO), TAMSX3("E2_PREFIXO")[1])
					c_Num:= PADR(Alltrim(o_Contabiliza:ITENCT2[c]:NUMERO), TAMSX3("E2_NUM")[1])
					c_Par:= PADR(Alltrim(o_Contabiliza:ITENCT2[c]:PARCELA), TAMSX3("E2_PARCELA")[1])
					c_Tip:= PADR(Alltrim(o_Contabiliza:ITENCT2[c]:TIPO), TAMSX3("E2_TIPO")[1])
					DBSELECTAREA("SA2")
					DBSETORDER(3)
					If !(DBSEEK(XFILIAL("SA2")+Alltrim(o_Contabiliza:ITENCT2[c]:CGC)))
						::o_Retorno:l_Status		:= .F.
						::o_Retorno:c_Mensagem	:= "CNPJ/CPF "+Alltrim(o_Contabiliza:ITENCT2[c]:CGC)+" nao encontrado na base de dados do protheus."+CHR(13)+CHR(10)
						Conout("FFIEBW01 - mtdContabiliza: CNPJ/CPF "+Alltrim(o_Contabiliza:ITENCT2[c]:CGC)+" nao encontrado na base de dados do protheus.")
						Return(.T.)
					Else
						c_Cod	:= SA2->A2_COD
						c_Loj	:= SA2->A2_LOJA
						//Verifica se a contabilizacao se refere a um titulo ativo e verifica se o titulo existe
						If (Alltrim(o_Contabiliza:ITENCT2[c]:REFLANC) == "A") //Ativo
							DBSELECTAREA("SE2")
							DBSETORDER(1)
							If !(DBSEEK(XFILIAL("SE2")+c_Pre+c_Num+c_Par+c_Tip+c_Cod+c_Loj))
								::o_Retorno:l_Status	:= .F.
								::o_Retorno:c_Mensagem	:= "Os dados do titulo nao foram encontrados no Contas a Pagar."+CHR(13)+CHR(10)
								Conout("FFIEBW01 - mtdContabiliza: Os dados do titulo nao foram encontrados no Contas a Pagar.")
								Return(.T.)
							EndIf
						ElseIf (Alltrim(o_Contabiliza:ITENCT2[c]:REFLANC) == "E") //Estorno
							DBSELECTAREA("SE2")
							DBSETORDER(1)
							If !(DBSEEK(XFILIAL("SE2")+c_Pre+c_Num+c_Par+c_Tip+c_Cod+c_Loj))
								//Verifica se o titulo ja foi deletado
								c_Qry:= "SELECT E2_NUM "+chr(13)+chr(10)
								c_Qry+= "FROM "+RETSQLNAME("SE2")+" "+chr(13)+chr(10)
								c_Qry+= "WHERE D_E_L_E_T_ = '*' "+chr(13)+chr(10)
								c_Qry+= "AND E2_FILIAL = '"+XFILIAL("SE2")+"'"+chr(13)+chr(10)
								c_Qry+= "AND E2_PREFIXO = '"+c_Pre+"'"+chr(13)+chr(10)
								c_Qry+= "AND E2_NUM 	= '"+c_Num+"'"+chr(13)+chr(10)
								c_Qry+= "AND E2_PARCELA = '"+c_Par+"'"+chr(13)+chr(10)
								c_Qry+= "AND E2_TIPO 	= '"+c_Tip+"'"+chr(13)+chr(10)
								c_Qry+= "AND E2_FORNECE = '"+c_Cod+"'"+chr(13)+chr(10)
								c_Qry+= "AND E2_LOJA 	= '"+c_Loj+"'"+chr(13)+chr(10)
								TCQUERY c_Qry ALIAS QRY NEW
								If (QRY->(Eof()))
									::o_Retorno:l_Status	:= .F.
									::o_Retorno:c_Mensagem	:= "O titulo: "+XFILIAL("SE2")+c_Pre+c_Num+c_Par+c_Tip+c_Cod+c_Loj+" nunca existiu na base."
									Conout("FFIEBW01 - mtdContabiliza: O titulo: "+XFILIAL("SE2")+c_Pre+c_Num+c_Par+c_Tip+c_Cod+c_Loj+" nunca existiu na base.")
									dbSelectArea("QRY")
									QRY->(dbCloseArea())
									Return(.T.)
								Else
									//nao faz nada
									dbSelectArea("QRY")
									QRY->(dbCloseArea())
								EndIf
							EndIf
						EndIf
					EndIf
				ElseIf (Upper(Alltrim(o_Contabiliza:ITENCT2[c]:REFERENCIA)) == "V") //Pedido de Venda
					If Empty(o_Contabiliza:ITENCT2[c]:PEDIDO)
						::o_Retorno:l_Status		:= .F.
						::o_Retorno:c_Mensagem	:= "Foi informado o tipo V no parametro REFERENCIA, logo o numero do pedido de venda deve der informado."+CHR(13)+CHR(10)
						Conout("FFIEBW01 - mtdContabiliza:Foi informado o tipo V no parametro REFERENCIA, logo o numero do pedido de venda deve der informado.")
						Return(.T.)
					EndIf
					DBSELECTAREA("SC5")
					DBSETORDER(1)
					If !(DBSEEK(XFILIAL("SC5")+Alltrim(o_Contabiliza:ITENCT2[c]:PEDIDO)))
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "Numero do pedido de venda ("+Alltrim(o_Contabiliza:ITENCT2[c]:PEDIDO)+") nao encontrado."+CHR(13)+CHR(10)
						Conout("FFIEBW01 - mtdContabiliza: Numero do pedido de venda ("+Alltrim(o_Contabiliza:ITENCT2[c]:PEDIDO)+") nao encontrado.")
						Return(.T.)
					EndIf
				EndIf
			EndIf
		Else //Quando nao passar o campo referencia, verifica se preencheu os campos de chave do titulo ou pedido. Nao deve preencher esses campos quando a referencia for em branco			
			If (Alltrim(o_Contabiliza:ITENCT2[c]:CT2_DC) <> '4') //Complemento de historico
				c_Par1:= Alltrim( o_Contabiliza:ITENCT2[c]:PREFIXO )
				c_Par2:= Alltrim( o_Contabiliza:ITENCT2[c]:NUMERO )
				c_Par3:= Alltrim( o_Contabiliza:ITENCT2[c]:PARCELA )
				c_Par4:= Alltrim( o_Contabiliza:ITENCT2[c]:TIPO )				
				c_Par5:= Alltrim( o_Contabiliza:ITENCT2[c]:CGC )
				c_Par6:= Alltrim( o_Contabiliza:ITENCT2[c]:PEDIDO )				
				If( !Empty( c_Par1 ) .Or. !Empty( c_Par2 )  .Or. !Empty( c_Par3 ) .Or. !Empty( c_Par4 ) .Or. !Empty( c_Par5 ) .Or. !Empty( c_Par6 ) )
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Nesta integracao foi informado os dados do titulo ou pedido de venda, portanto o parametro REFERENCIA deve ser preenchido ou deixado em branco."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdContabiliza: Nesta integracao foi informado os dados do titulo ou pedido de venda, portanto o parametro REFERENCIA  deve ser preenchido ou deixado em branco.")
					Return(.T.)
				EndIf
			EndIf
		EndIf
		If (Alltrim(o_Contabiliza:ITENCT2[c]:CT2_DC) <> "1") .And. (Alltrim(o_Contabiliza:ITENCT2[c]:CT2_DC) <> "2") .And. (Alltrim(o_Contabiliza:ITENCT2[c]:CT2_DC) <> "3") .And. (Alltrim(o_Contabiliza:ITENCT2[c]:CT2_DC) <> "4")
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "O tipo do lancamento (CT2_DC) invalido. Informar 1=Debito;2=Credito;3=Partida dobrada;4=Complemento de Historico."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdContabiliza: O tipo do lancamento (CT2_DC) invalido. Informar 1=Debito;2=Credito;3=Partida dobrada;4=Complemento de Historico.")
			Return(.T.)
		EndIf
		If (Alltrim(o_Contabiliza:ITENCT2[c]:CT2_DC) = "3")
			If Empty(o_Contabiliza:ITENCT2[c]:CT2_DEBITO) .Or. Empty(o_Contabiliza:ITENCT2[c]:CT2_CREDIT)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Para o tipo do lancamento 3(partida dobrada) deve-se informar a conta credito e debito."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdContabiliza: Para o tipo do lancamento 3(partida dobrada) deve-se informar a conta credito e debito.")
				Return(.T.)
			EndIf
		ElseIf (Alltrim(o_Contabiliza:ITENCT2[c]:CT2_DC) = "1")
			If Empty(o_Contabiliza:ITENCT2[c]:CT2_DEBITO)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Para o tipo do lancamento 1(debito) deve-se informar a conta debito."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdContabiliza: Para o tipo do lancamento 1(debito) deve-se informar a conta debito.")
				Return(.T.)
			EndIf
		ElseIf (Alltrim(o_Contabiliza:ITENCT2[c]:CT2_DC) = "2")
			If Empty(o_Contabiliza:ITENCT2[c]:CT2_CREDIT)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Para o tipo do lancamento 2(credito) deve-se informar a conta credito."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdContabiliza: Para o tipo do lancamento 2(credito) deve-se informar a conta credito.")
				Return(.T.)
			EndIf
		EndIf
		If (Alltrim(o_Contabiliza:ITENCT2[c]:CT2_DC) = "1") //Debito
			//validando a conta debito
			If Empty(o_Contabiliza:ITENCT2[c]:CT2_DEBITO)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Conta contabil de debito nao informada nos itens."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdContabiliza: Conta contabil de debito nao informada nos itens.")
				Return(.T.)
			Else
				DBSELECTAREA("CT1")
				DBSETORDER(1)
				IF !DBSEEK(xFilial("CT1")+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_DEBITO))
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_DEBITO)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+"."
					Conout("FFIEBW01 - mtdContabiliza: Codigo da conta contabil ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_DEBITO)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+".")
					Return(.T.)
				ElseIf CT1->CT1_CLASSE == "1"
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_DEBITO)+") nao pode ser sintetica."
					Conout("FFIEBW01 - mtdContabiliza: Codigo da conta contabil ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_DEBITO)+") nao pode ser sintetica.")
					Return(.T.)
				ElseIf CT1->CT1_BLOQ == "1"
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_DEBITO)+") esta bloqueada para uso."
					Conout("FFIEBW01 - mtdContabiliza: Codigo da conta contabil ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_DEBITO)+")  esta bloqueada para uso.")
					Return(.T.)
				EndIf
			EndIf
		EndIf
		If (Alltrim(o_Contabiliza:ITENCT2[c]:CT2_DC) = "2") //Credito
			//validando a conta credito
			If Empty(o_Contabiliza:ITENCT2[c]:CT2_CREDIT)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Conta contabil de credito nao informada nos itens."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdContabiliza: Conta contabil de credito nao informada nos itens.")
				Return(.T.)
			Else
				DBSELECTAREA("CT1")
				DBSETORDER(1)
				IF !DBSEEK(xFilial("CT1")+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CREDIT))
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CREDIT)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+"."
					Conout("FFIEBW01 - mtdContabiliza: Codigo da conta contabil ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CREDIT)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+".")
					Return(.T.)
				ElseIf CT1->CT1_CLASSE == "1"
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CREDIT)+") nao pode ser sintetica."
					Conout("FFIEBW01 - mtdContabiliza: Codigo da conta contabil ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CREDIT)+") nao pode ser sintetica.")
					Return(.T.)
				ElseIf CT1->CT1_BLOQ == "1"
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CREDIT)+") esta bloqueada para uso."
					Conout("FFIEBW01 - mtdContabiliza: Codigo da conta contabil ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CREDIT)+")  esta bloqueada para uso.")
					Return(.T.)
				EndIf
			EndIf
		EndIf
		If Empty(o_Contabiliza:ITENCT2[c]:CT2_HIST)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "O historico deve ser informado."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdContabiliza: O historico deve ser informado.")
			Return(.T.)
		EndIf
		If (Alltrim(o_Contabiliza:ITENCT2[c]:CT2_DC) <> '4') //Complemento de historico
			If (o_Contabiliza:ITENCT2[c]:CT2_VALOR < 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "O valor do movimento nao pode ser menor ou igual a zero."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdContabiliza: O valor do movimento nao pode ser menor  ou igual a zero.")
				Return(.T.)
			EndIf
			If (Alltrim(o_Contabiliza:ITENCT2[c]:CT2_MOEDLC) <> "01")
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "A moeda nao pode ser diferente de 01."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdContabiliza: A moeda nao pode ser diferente de 01.")
				Return(.T.)
			EndIf
			If (Alltrim(o_Contabiliza:ITENCT2[c]:CT2_TPSALD) <> "1")
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "O tipo de saldo nao pode ser diferente de 1."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdContabiliza: O tipo de saldo nao pode ser diferente de 1.")
				Return(.T.)
			EndIf
			If !Empty(o_Contabiliza:ITENCT2[c]:CT2_CCD)
				DbSelectArea("CTT")
				CTT->(dbSetOrder(1))
				If !(CTT->(dbSeek(xFilial("CTT")+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CCD))))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Centro de Custo de debito invalido ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CCD)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdContabiliza: Centro de Custo de debito invalido ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CCD)+").")
					Return(.T.)
				Elseif CTT->CTT_CLASSE == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Centro de Custo de debito invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CCD)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdContabiliza: Centro de Custo de debito invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CCD)+").")
					Return(.T.)
				Elseif CTT->CTT_BLOQ == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Centro de Custo de debitoinvalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CCD)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdContabiliza: Centro de Custo de debito invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CCD)+").")
					Return(.T.)
				Endif
			EndIf
			If !Empty(o_Contabiliza:ITENCT2[c]:CT2_CCC)
				DbSelectArea("CTT")
				CTT->(dbSetOrder(1))
				If !(CTT->(dbSeek(xFilial("CTT")+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CCC))))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Centro de Custo de credito invalido ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CCC)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdContabiliza: Centro de Custo de credito invalido ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CCC)+").")
					Return(.T.)
				Elseif CTT->CTT_CLASSE == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Centro de Custo de credito invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CCC)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdContabiliza: Centro de Custo de credito invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CCC)+").")
					Return(.T.)
				Elseif CTT->CTT_BLOQ == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Centro de Custo de credito invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CCC)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdContabiliza: Centro de Custo de credito invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CCC)+").")
					Return(.T.)
				Endif
			EndIf
			If !Empty(o_Contabiliza:ITENCT2[c]:CT2_ITEMD)
				DbSelectArea("CTD")
				CTD->(dbSetOrder(1))
				If !(CTD->(dbSeek(xFilial("CTD")+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMD))))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil de debito invalido ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMD)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdContabiliza: Item contabil de debito invalido ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMD)+").")
					Return(.T.)
				Elseif CTD->CTD_CLASSE == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil de debito invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMD)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdContabiliza: Item contabil de debito invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMD)+").")
					Return(.T.)
				Elseif CTD->CTD_BLOQ == "1" .or. (!Empty(CTD->CTD_DTEXSF) .and. CTD->CTD_DTEXSF < dDatabase)
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil de debito invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMD)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdContabiliza: Item contabil de debito invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMD)+").")
					Return(.T.)
				ElseIf (!Empty(CTD->CTD_DTEXIS) .and. dDatabase < CTD->CTD_DTEXIS)
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMD)+") esta com data de inicio de existencia superior a data base."+CHR(13)+CHR(10)
					Return(.T.)
				Endif
			EndIf
			If !Empty(o_Contabiliza:ITENCT2[c]:CT2_ITEMC)
				DbSelectArea("CTD")
				CTD->(dbSetOrder(1))
				If !(CTD->(dbSeek(xFilial("CTD")+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMC))))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil de credito invalido ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMC)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdContabiliza: Item contabil de credito invalido ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMC)+").")
					Return(.T.)
				Elseif CTD->CTD_CLASSE == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil de credito invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMC)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdContabiliza: Item contabil de credito invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMC)+").")
					Return(.T.)
				Elseif CTD->CTD_BLOQ == "1" .or. (!Empty(CTD->CTD_DTEXSF) .and. CTD->CTD_DTEXSF < dDatabase)
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil de credito invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMC)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdContabiliza: Item contabil de credito invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMC)+").")
					Return(.T.)
				ElseIf (!Empty(CTD->CTD_DTEXIS) .and. dDatabase < CTD->CTD_DTEXIS)
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMC)+") esta com data de inicio de existencia superior a data base."+CHR(13)+CHR(10)
					Return(.T.)
				Endif
			EndIf
			If !Empty(o_Contabiliza:ITENCT2[c]:CT2_CLVLDB)
				//Validando a classe de valor
				DbSelectArea("CTH")
				CTH->(dbSetOrder(1))
				If !(CTH->(dbSeek(xFilial("CTH")+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CLVLDB))))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Classe de valor de debito invalido ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CLVLDB)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdContabiliza: Classe de valor de debito invalido ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CLVLDB)+").")
					Return(.T.)
				Elseif CTH->CTH_CLASSE == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Classe de valor de debito invalido. O Classe de valor nao pode ser sintetico ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CLVLDB)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdContabiliza: Classe de valor de debito invalido. O Classe de valor nao pode ser sintetico ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CLVLDB)+").")
					Return(.T.)
				Elseif CTH->CTH_BLOQ == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Classe de valor de debito invalido. o Classe de valor esta bloqueado para uso ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CLVLDB)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdContabiliza: Classe de valor de debito invalido. o Classe de valor esta bloqueado para uso ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CLVLDB)+").")
					Return(.T.)
				Endif
			EndIf
			If !Empty(o_Contabiliza:ITENCT2[c]:CT2_CLVLCR)
				//Validando a classe de valor
				DbSelectArea("CTH")
				CTH->(dbSetOrder(1))
				If !(CTH->(dbSeek(xFilial("CTH")+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CLVLCR))))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Classe de valor de credito invalido ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CLVLCR)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdContabiliza: Classe de valor de credito invalido ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CLVLCR)+").")
					Return(.T.)
				Elseif CTH->CTH_CLASSE == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Classe de valor de credito invalido. O Classe de valor nao pode ser sintetico ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CLVLCR)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdContabiliza: Classe de valor de credito invalido. O Classe de valor nao pode ser sintetico ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CLVLCR)+").")
					Return(.T.)
				Elseif CTH->CTH_BLOQ == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Classe de valor de credito invalido. o Classe de valor esta bloqueado para uso ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CLVLCR)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdContabiliza: Classe de valor de credito invalido. o Classe de valor esta bloqueado para uso ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CLVLCR)+").")
					Return(.T.)
				Endif
			EndIf

			//Valida a amarracao das contas - 13/12/2018
			If (Alltrim(o_Contabiliza:ITENCT2[c]:CT2_DC) = "1") //Debito
				//Valida a amarracao de Filial+Cr+Uo 13/12/2018
				If (SubStr(AllTrim(o_Contabiliza:ITENCT2[c]:CT2_DEBITO),1,1) $ '3,4') .AND. !(VerAmarrCTA(Alltrim(o_Empresa:c_Filial),Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CCD), Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMD)))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Nao existe amarracao (Tabela CTA) entre Filial: ("+Alltrim(o_Empresa:c_Filial)+"), CR: ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMD)+") e Uo: ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CCD)+")."
					Conout("FFIEBW01 - mtdContabiliza: Nao existe amarracao (Tabela CTA) entre Filial: ("+Alltrim(o_Empresa:c_Filial)+"), CR: ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMD)+") e Uo: ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CCD)+").")
					Return(.T.)
					/* Deixar comentado case precise futuramente
					Else
					//Valida se a conta e de investimeto e se o CR possui 2,3,4 no campo CTD_XRTADM - 13/02/2019
					c_ErrMsg:= ""
					If !( f_VldCnInvest( AllTrim(o_Contabiliza:ITENCT2[c]:CT2_DEBITO), Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMD), @c_ErrMsg ) )
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= c_ErrMsg
						Conout("FFIEBW01 - mtdContabiliza: "+c_ErrMsg)
						Return(.T.)
					EndIf
					*/
				EndIf
			ElseIf (Alltrim(o_Contabiliza:ITENCT2[c]:CT2_DC) = "2") //Credito
				//Valida a amarracao de Filial+Cr+Uo 13/12/2018
				If (SubStr(AllTrim(o_Contabiliza:ITENCT2[c]:CT2_CREDIT),1,1) $ '3,4') .AND. !(VerAmarrCTA(Alltrim(o_Empresa:c_Filial),Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CCC), Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMC)))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Nao existe amarracao (Tabela CTA) entre Filial: ("+Alltrim(o_Empresa:c_Filial)+"), CR: ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMC)+") e Uo: ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CCC)+")."
					Conout("FFIEBW01 - mtdContabiliza: Nao existe amarracao (Tabela CTA) entre Filial: ("+Alltrim(o_Empresa:c_Filial)+"), CR: ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMC)+") e Uo: ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CCC)+").")
					Return(.T.)
					/* Deixar comentado case precise futuramente
					Else
					//Valida se a conta e de investimeto e se o CR possui 2,3,4 no campo CTD_XRTADM - 13/02/2019
					c_ErrMsg:= ""
					If !( f_VldCnInvest( AllTrim(o_Contabiliza:ITENCT2[c]:CT2_CREDIT), Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMC), @c_ErrMsg ) )
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= c_ErrMsg
						Conout("FFIEBW01 - mtdContabiliza: "+c_ErrMsg)
						Return(.T.)
					EndIf
					*/
				EndIf
			ElseIf (Alltrim(o_Contabiliza:ITENCT2[c]:CT2_DC) = "3") //Partida dobrada
				//Valida a amarracao de Filial+Cr+Uo 13/12/2018
				If (SubStr(AllTrim(o_Contabiliza:ITENCT2[c]:CT2_DEBITO),1,1) $ '3,4') .AND. !(VerAmarrCTA(Alltrim(o_Empresa:c_Filial),Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CCD), Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMD)))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Nao existe amarracao (Tabela CTA) entre Filial: ("+Alltrim(o_Empresa:c_Filial)+"), CR: ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMD)+") e Uo: ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CCD)+")."
					Conout("FFIEBW01 - mtdContabiliza: Nao existe amarracao (Tabela CTA) entre Filial: ("+Alltrim(o_Empresa:c_Filial)+"), CR: ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMD)+") e Uo: ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CCD)+").")
					Return(.T.)
					/* Deixar comentado case precise futuramente
					Else
					//Valida se a conta e de investimeto e se o CR possui 2,3,4 no campo CTD_XRTADM - 13/02/2019
					c_ErrMsg:= ""
					If !( f_VldCnInvest( AllTrim(o_Contabiliza:ITENCT2[c]:CT2_DEBITO), Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMD), @c_ErrMsg ) )
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= c_ErrMsg
						Conout("FFIEBW01 - mtdContabiliza: "+c_ErrMsg)
						Return(.T.)
					EndIf
					*/
				EndIf
				//Valida a amarracao de Filial+Cr+Uo 13/12/2018
				If (SubStr(AllTrim(o_Contabiliza:ITENCT2[c]:CT2_CREDIT),1,1) $ '3,4') .AND. !(VerAmarrCTA(Alltrim(o_Empresa:c_Filial),Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CCC), Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMC)))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Nao existe amarracao (Tabela CTA) entre Filial: ("+Alltrim(o_Empresa:c_Filial)+"), CR: ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMC)+") e Uo: ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CCC)+")."
					Conout("FFIEBW01 - mtdContabiliza: Nao existe amarracao (Tabela CTA) entre Filial: ("+Alltrim(o_Empresa:c_Filial)+"), CR: ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMC)+") e Uo: ("+Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CCC)+").")
					Return(.T.)
					/* Deixar comentado case precise futuramente
					Else
					//Valida se a conta e de investimeto e se o CR possui 2,3,4 no campo CTD_XRTADM - 13/02/2019
					c_ErrMsg:= ""
					If !( f_VldCnInvest( AllTrim(o_Contabiliza:ITENCT2[c]:CT2_CREDIT), Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMC), @c_ErrMsg ) )
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= c_ErrMsg
						Conout("FFIEBW01 - mtdContabiliza: "+c_ErrMsg)
						Return(.T.)
					EndIf
					*/
				EndIf
			EndIf			
		EndIf
		//{'CT2_LINHA'  	,STRZERO(Val(o_Contabiliza:ITENCT2[c]:CT2_LINHA),3)	, NIL},;
		//CT2_FSIDRM - CAMPO QUE GUARDA O ID DA CONTABILIZACAO DO RM
		AADD(aItens,{{'CT2_FILIAL' 	,o_Empresa:c_Filial  	, NIL},;
					 {'CT2_LINHA'  	,Alltrim(o_Contabiliza:ITENCT2[c]:CT2_LINHA)	, NIL},;
					 {'CT2_MOEDLC' 	,Alltrim(o_Contabiliza:ITENCT2[c]:CT2_MOEDLC)	, NIL},;
					 {'CT2_DC'   	,Alltrim(o_Contabiliza:ITENCT2[c]:CT2_DC) 		, NIL},;
					 {'CT2_DEBITO' 	,Alltrim(o_Contabiliza:ITENCT2[c]:CT2_DEBITO)	, NIL},;
					 {'CT2_CREDIT' 	,Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CREDIT)	, NIL},;
					 {'CT2_VALOR'  	,o_Contabiliza:ITENCT2[c]:CT2_VALOR				, NIL},;
					 {'CT2_HIST'    ,Alltrim(o_Contabiliza:ITENCT2[c]:CT2_HIST)		, NIL},;
					 {'CT2_CCD' 	,Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CCD)		, NIL},;
      				 {'CT2_CCC' 	,Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CCC)		, NIL},;
					 {'CT2_ITEMD' 	,Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMD)	, NIL},;
					 {'CT2_ITEMC' 	,Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMC)	, NIL},;
					 {'CT2_CLVLDB' 	,Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CLVLDB)	, NIL},;
					 {'CT2_CLVLCR' 	,Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CLVLCR)	, NIL},;
					 {'CT2_AT01DB' 	,Alltrim(o_Contabiliza:ITENCT2[c]:CT2_AT01DB)	, NIL},;
					 {'CT2_AT01CR' 	,Alltrim(o_Contabiliza:ITENCT2[c]:CT2_AT01CR)	, NIL},;
					 {'CT2_TPSALD' 	,Alltrim(o_Contabiliza:ITENCT2[c]:CT2_TPSALD)	, NIL},;
					 {'CT2_FSIDRM' 	,Alltrim(o_Contabiliza:ITENCT2[c]:CT2_FSIDRM)	, NIL},;				 					 		
					 {'CT2_ORIGEM' 	,'FFIEBW01'	, NIL}})
	Next

	If (Upper(Alltrim(o_Contabiliza:AGRAVADIRETO)) <> 'S') //Usa MSExecAuto
		//INCLUI         := .T.
		lMsErroAuto    := .F.
		lMsHelpAuto    := .T.
		lAutoErrNoFile := .T.
		CT2->( dbSetOrder( 1 ) )

		Begin Transaction
			MSExecAuto( {|X,Y,Z| CTBA102(X,Y,Z)}, aCab , aItens , n_Operacao )
			If lMsErroAuto
				DisarmTransaction()
				Break
			Else
				//So grava a CV3 se for RM
				l_VeriRM:= .F. 
				For c:= 1 To Len(o_Contabiliza:ITENCT2)
					If !Empty(Alltrim(o_Contabiliza:ITENCT2[c]:CT2_FSIDRM))	
						If (Alltrim(o_Contabiliza:ITENCT2[c]:CT2_DC) <> '4') //Complemento de historico
							If (Upper(Alltrim(o_Contabiliza:ITENCT2[c]:REFERENCIA)) == "R")
								l_VeriRM:= .T.
								c_Pre:= PADR(Alltrim(o_Contabiliza:ITENCT2[c]:PREFIXO), TAMSX3("E1_PREFIXO")[1])
								c_Num:= PADR(Alltrim(o_Contabiliza:ITENCT2[c]:NUMERO), TAMSX3("E1_NUM")[1])
								c_Par:= PADR(Alltrim(o_Contabiliza:ITENCT2[c]:PARCELA), TAMSX3("E1_PARCELA")[1])
								c_Tip:= PADR(Alltrim(o_Contabiliza:ITENCT2[c]:TIPO), TAMSX3("E1_TIPO")[1])
								DBSELECTAREA("SA1")
								DBSETORDER(3)
								DBSEEK(XFILIAL("SA1")+Alltrim(o_Contabiliza:ITENCT2[c]:CGC))							
								c_Cod	:= SA1->A1_COD
								c_Loj	:= SA1->A1_LOJA											
								Exit
							EndIf
						EndIf
					EndIf
				Next
				If( l_VeriRM )
					DbSelectArea("CT2")
					DbSetOrder(1)
					If( DbSeek( o_Empresa:c_Filial + Alltrim(o_Contabiliza:DDATALANC) + Alltrim(o_Contabiliza:CLOTE) + Alltrim(o_Contabiliza:CSUBLOTE) + c_Doc ) )
						While( !CT2->( Eof() ) ) .And. ( CT2->CT2_FILIAL+Dtos(CT2->CT2_DATA)+CT2->CT2_LOTE+CT2->CT2_SBLOTE+CT2->CT2_DOC == o_Empresa:c_Filial + Alltrim(o_Contabiliza:DDATALANC) + Alltrim(o_Contabiliza:CLOTE) + Alltrim(o_Contabiliza:CSUBLOTE) + c_Doc )
							If( !Empty( CT2->CT2_FSIDRM ) ) //Lote do RM 
								RecLock("CT2",.F.)
								CT2->CT2_ROTINA	:= 'INTEGRARM'
								CT2->CT2_LP		:= 'RM'
								CT2->CT2_DTCV3	:= CT2->CT2_DATA
								CT2->CT2_MANUAL	:= '2'
								CT2->CT2_SEQUEN	:= cSeqChave
								MsUnLock()
								//GRAVA CV3 PARA CADA LINHA DO CT2
								//==================INI=======================
								RecLock("CV3",.T.)
								CV3->CV3_FILIAL	:=	o_Empresa:c_Filial
								CV3->CV3_DTSEQ	:=	CT2->CT2_DATA
								CV3->CV3_SEQUEN	:=	cSeqChave
								CV3->CV3_DC		:=	CT2->CT2_DC
								CV3->CV3_LP		:= 	CT2->CT2_LP
								CV3->CV3_LPSEQ	:=	CT2->CT2_SEQLAN
								CV3->CV3_KEY	:=	o_Empresa:c_Filial+c_Pre+c_Num+c_Par+c_Tip+c_Cod+c_Loj
								CV3->CV3_DEBITO	:=	CT2->CT2_DEBITO
								CV3->CV3_CREDIT	:= 	CT2->CT2_CREDIT
								CV3->CV3_VLR01	:=	CT2->CT2_VLR01
								CV3->CV3_VLR02	:= 	CT2->CT2_VLR02
								CV3->CV3_VLR03	:=	CT2->CT2_VLR03
								CV3->CV3_VLR04	:= 	CT2->CT2_VLR04
								CV3->CV3_VLR05	:=	CT2->CT2_VLR05
								CV3->CV3_HIST	:=	CT2->CT2_HIST
								CV3->CV3_CCC	:=	CT2->CT2_CCC
								CV3->CV3_CCD	:=	CT2->CT2_CCD
								CV3->CV3_ITEMC	:= 	CT2->CT2_ITEMC
								CV3->CV3_ITEMD	:=	CT2->CT2_ITEMD
								CV3->CV3_CLVLDB	:=	CT2->CT2_CLVLDB
								CV3->CV3_CLVLCR	:= 	CT2->CT2_CLVLCR
								CV3->CV3_MOEDLC	:=	CT2->CT2_MOEDLC
								CV3->CV3_TABORI	:= 	"SE1"
								
								DBSELECTAREA("SE1")
								DBSETORDER(1)
								DBSEEK( o_Empresa:c_Filial + c_Pre + c_Num + c_Par + c_Tip + c_Cod + c_Loj )
													
								CV3->CV3_RECORI	:= 	cValToChar( SE1->( Recno() ) )
								CV3->CV3_RECDES := 	cValToChar( CT2->( Recno() ) )		
								CV3->(MsUnlock())
								//==================FIM=======================
							EndIf
							DbSelectArea("CT2")
							CT2->( DbSkip() )
						EndDo
					EndIf
				EndIf
			EndIf
		End Transaction
		//Se deu erro no Execauto
		If lMsErroAuto
			//Regra do fonte SIESBA01 da FIEB
			If (__lSX8)
				RollBackSX8()
			EndIf

			// Tratamento da Mensagem de erro do MSExecAuto
			aLogErr  := GetAutoGRLog()
			aLogErr2 := f_TrataErro(aLogErr)
			_cMotivo := ""

			For i := 1 to Len(aLogErr2)
				_cMotivo += aLogErr2[i]
			Next

			//Exclusivo para a versao 12
			If (GetVersao(.F.) == "12")
				_cMotivo:=  NoAcentoESB(_cMotivo)
				SetSoapFault('Erro',_cMotivo)
			EndIf

			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= NoAcentoESB(_cMotivo)
			Conout("FFIEBW01 - mtdContabiliza: "+ NoAcentoESB(_cMotivo))
		Else
			If (__lSX8)
				ConfirmSX8()
			EndIf
			//23/09/2019
			//tratamento para verificar se foi gravado realmente a contabilizacao
			//Guarda os lotes do RM
			a_LoteRM	:= {}
			l_TemLtRM	:= .F.
			For c:= 1 To Len( o_Contabiliza:ITENCT2 )
				If !Empty( Alltrim( o_Contabiliza:ITENCT2[c]:CT2_FSIDRM ) )
					l_TemLtRM:= .T.			
					Aadd( a_LoteRM, Alltrim( o_Contabiliza:ITENCT2[c]:CT2_FSIDRM ) )
				EndIf
			Next
			c_NumsLtRM:= ""
			For u:= 1 To Len( a_LoteRM )
				c_NumsLtRM+= "'"+a_LoteRM[u]+"',"
			Next
			c_NumsLtRM	:= Substr(c_NumsLtRM,1,Len(c_NumsLtRM)-1)
			
			If( l_TemLtRM )
				cQuery := ""
				cQuery += "SELECT CT2_FSIDRM, CT2_DOC FROM " + RetSqlName( "CT2" ) + " CT2 (NOLOCK) "+CHR(13)+CHR(10)
				cQuery += "WHERE "+CHR(13)+CHR(10)
				cQuery += "CT2_FILIAL 	= '" + o_Empresa:c_Filial + "' AND "+CHR(13)+CHR(10)	
				cQuery += "CT2_DATA		= '" + Alltrim(o_Contabiliza:DDATALANC)+"' AND "+CHR(13)+CHR(10)
				cQuery += "CT2_LOTE		= '" + Alltrim(o_Contabiliza:CLOTE)+"' AND "+CHR(13)+CHR(10)
				cQuery += "CT2_SBLOTE	= '" + Alltrim(o_Contabiliza:CSUBLOTE)+"' AND "+CHR(13)+CHR(10)
				cQuery += "CT2_FSIDRM	IN (" + c_NumsLtRM +") AND "+CHR(13)+CHR(10)								
				cQuery += "CT2_ORIGEM	= 'FFIEBW01' AND "+CHR(13)+CHR(10)
				cQuery += "CT2_ROTINA	IN ('CTBA102','INTEGRARM') AND "+CHR(13)+CHR(10)			
				cQuery += "D_E_L_E_T_ = ' ' ORDER BY CT2_LINHA "+CHR(13)+CHR(10)
				TCQUERY cQuery ALIAS QRY NEW
				n_CtCt2:= 0
				c_RMDoc:= ""
				While( !QRY->( Eof() ) ) 
					n_CtCt2++
					c_RmDoc:= Alltrim( QRY->CT2_DOC )									
					QRY->( DbSkip() )
				EndDo 
				DbSelectArea("QRY")
				QRY->(DbCloseArea())
				If( n_CtCt2 = Len( a_LoteRM ) )	
					::o_Retorno:l_Status:= .T.
					::o_Retorno:c_Mensagem	:= "Movimento contabil do RM gravado ("+o_Empresa:c_Filial+"-"+Dtoc(d_Data)+"-"+c_Lote+"-"+c_SbLote+"-"+c_RmDoc+")."
				Else
					::o_Retorno:l_Status:= .F.
					::o_Retorno:c_Mensagem	:= "### Ocorreu um erro desconhecido ou alguns Id's do Rm desta contabilizacao nao foram encontrados. Favor reprocessar. ###"
				EndIf				
			Else //Quando nao tiver Lote do RM
				::o_Retorno:l_Status:= .T.
				::o_Retorno:c_Mensagem	:= "Movimento contabil gravado ("+o_Empresa:c_Filial+"-"+Dtoc(d_Data)+"-"+c_Lote+"-"+c_SbLote+")."
			EndIf
		EndIf
	Else//GRAVA VIA RECLOCK APENAS QUANDO O PARAMETRO AGRAVADIRETO FOR 'S'
		Begin Transaction
			For c:= 1 To Len(o_Contabiliza:ITENCT2)
				DbSelectArea("CT2")
				RecLock("CT2",.T.)
				CT2->CT2_FILIAL	:= o_Empresa:c_Filial
				CT2->CT2_DATA	:= d_Data
				CT2->CT2_LOTE	:= c_Lote
				CT2->CT2_SBLOTE	:= c_SbLote
				CT2->CT2_DOC	:= c_Doc
				CT2->CT2_LINHA	:= Alltrim(o_Contabiliza:ITENCT2[c]:CT2_LINHA)
				CT2->CT2_MOEDLC	:= Alltrim(o_Contabiliza:ITENCT2[c]:CT2_MOEDLC)
				CT2->CT2_DC		:= Alltrim(o_Contabiliza:ITENCT2[c]:CT2_DC)
				CT2->CT2_DEBITO	:= Alltrim(o_Contabiliza:ITENCT2[c]:CT2_DEBITO)
				CT2->CT2_CREDIT	:= Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CREDIT)
				CT2->CT2_VALOR	:= o_Contabiliza:ITENCT2[c]:CT2_VALOR
				CT2->CT2_HIST	:= Alltrim(o_Contabiliza:ITENCT2[c]:CT2_HIST)
				CT2->CT2_CCD	:= Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CCD)
				CT2->CT2_CCC	:= Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CCC)
				CT2->CT2_ITEMD	:= Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMD)
				CT2->CT2_ITEMC	:= Alltrim(o_Contabiliza:ITENCT2[c]:CT2_ITEMC)
				CT2->CT2_CLVLDB	:= Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CLVLDB)
				CT2->CT2_CLVLCR	:= Alltrim(o_Contabiliza:ITENCT2[c]:CT2_CLVLCR)
				CT2->CT2_AT01DB	:= Alltrim(o_Contabiliza:ITENCT2[c]:CT2_AT01DB)
				CT2->CT2_AT01CR	:= Alltrim(o_Contabiliza:ITENCT2[c]:CT2_AT01CR)
				CT2->CT2_TPSALD	:= Alltrim(o_Contabiliza:ITENCT2[c]:CT2_TPSALD)
				CT2->CT2_ORIGEM	:= 'FFIEBW01'
				//CT2->CT2_FSTIT	:= c_FSTIT

				CT2->CT2_EMPORI	:= cEmpAnt
				CT2->CT2_FILORI	:= o_Empresa:c_Filial
				CT2->CT2_ROTINA := "CTBA102"
				CT2->CT2_AGLUT  := "2"
				CT2->CT2_INTERC	:= '1'
				CT2->CT2_TPSALD	:= '9'
				CT2->CT2_MANUAL := '1'
				CT2->CT2_SEQHIS := '001'
				CT2->CT2_SEQLAN := '001'
				If (Alltrim(o_Contabiliza:ITENCT2[c]:CT2_DC) <> '4')
					CT2->CT2_CRCONV	:= '1'
				EndIf
				CT2->CT2_DTCONF	:= d_Data
				CT2->CT2_CTLSLD	:= '0'
				MsUnLock()
			Next
			::o_Retorno:l_Status:= .T.
			::o_Retorno:c_Mensagem	:= "Movimento contabil gravado (direto) na contabilidade ("+Dtoc(d_Data)+"-"+c_Lote+"-"+c_SbLote+"-"+c_Doc+"). Obs.: Executar a rotina de Refaz Saldos!!!!!"
		End Transaction
	EndIf
	//RpcClearEnv() //Limpa o ambiente, liberando a licenca e fechando as conexoes

Return(.T.)
/*/{Protheus.doc} mtdGrvPedidoTit
Gravacao do pedido no titulo
@author Totvs-BA
@since 25/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSMETHOD mtdGrvPedidoTit WSRECEIVE o_Seguranca, o_Empresa, o_GravaPedido, Operacao WSSEND o_Retorno WSSERVICE FFIEBW01

	Local n_Operacao	:= Val(::Operacao)
	::o_Retorno	:= WSCLASSNEW("strRetorno")

	If !(f_VldFilEmp(o_Empresa:c_Empresa,o_Empresa:c_Filial))
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Codigo de Empresa/Filial nao existe."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGrvPedidoTit: Codigo de Empresa/Filial nao existe.")
		Return(.T.)
	EndIf

	//Loga na filial solicitada
	RpcSetType(3)
	RpcSetEnv(o_Empresa:c_Empresa,o_Empresa:c_Filial, "integracao", "fieb123")

	//Posiciona na empresa e filial passada
	dbSelectArea("SM0")
	dbSeek(o_Empresa:c_Empresa+o_Empresa:c_Filial)

	cFilAnt:= o_Empresa:c_Filial

	c_UserWS	:= Upper(ALLTRIM(SUPERGETMV("FS_FIUSRWS",,"totvs_fieb")))
	c_PswWS		:= Upper(ALLTRIM(SUPERGETMV("FS_FIPSWWS",,"totvs@123")))

	//Validando o usuario e senha
	If ( Upper(o_Seguranca:c_Usuario) <> Upper(c_UserWS) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGrvPedidoTit: Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido.")
		Return(.T.)
	ElseIf ( Upper(o_Seguranca:c_Senha) <> Upper(c_PswWS) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGrvPedidoTit: Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida.")
		Return(.T.)
	ElseIf Empty(o_GravaPedido:E1_PREFIXO)
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Informe o prefixo do titulo."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGrvPedidoTit: Informe o prefixo do titulo.")
		Return(.T.)
	ElseIf Empty(o_GravaPedido:E1_NUM)
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Informe o numero do titulo."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGrvPedidoTit: Informe o numero do titulo.")
		Return(.T.)
	ElseIf Empty(o_GravaPedido:E1_TIPO)
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Informe o tipo do titulo."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGrvPedidoTit: Informe o tipo do titulo.")
		Return(.T.)
	ElseIf Empty(o_GravaPedido:CGC)
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Informe o CNPJ/CPF do cliente do titulo."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGrvPedidoTit: Informe o CNPJ/CPF do cliente do titulo.")
		Return(.T.)
	ElseIf Empty(o_GravaPedido:PEDIDO)
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Informe o numero do pedido."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdGrvPedidoTit: Informe o numero do pedido")
		Return(.T.)
	Else
		If (n_Operacao <> 3) .And. (n_Operacao <> 5)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Valor passado no parametro Operacao ("+cValToChar(n_Operacao)+") invalido. Informar (3=Gravacao do Nr.Pedido; 5=Exclusao do Nr. Pedido)."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdGrvPedidoTit: Valor passado no parametro Operacao ("+cValToChar(n_Operacao)+") invalido. Informar (3=Gravacao do Nr.Pedido; 5=Exclusao do Nr. Pedido).")
			Return(.T.)
		EndIf
		If (n_Operacao = 3)
			DBSELECTAREA("SC5")
			DBSETORDER(1)
			If !(DBSEEK(XFILIAL("SC5")+Alltrim(o_GravaPedido:PEDIDO)))
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Pedido "+Alltrim(o_GravaPedido:PEDIDO)+" nao localizado."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdGrvPedidoTit: Pedido "+Alltrim(o_GravaPedido:PEDIDO)+" nao localizado.")
				Return(.T.)
			EndIf
		ElseIf (n_Operacao = 5) //Para remover do pedido do campo E1_PEDIDO, o pedido ja deve ter sido excluido da base.
			DBSELECTAREA("SC5")
			DBSETORDER(1)
			If (DBSEEK(XFILIAL("SC5")+Alltrim(o_GravaPedido:PEDIDO)))
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Para desvincular um pedido do titulo, o mesmo ja deve ter sido cancelado(excluido). Pedido: "+Alltrim(o_GravaPedido:PEDIDO)+"."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdGrvPedidoTit: Para desvincular um pedido do titulo, o mesmo ja deve ter sido cancelado(excluido). Pedido: "+Alltrim(o_GravaPedido:PEDIDO)+".")
				Return(.T.)
			EndIf
		EndIf
		DBSELECTAREA("SA1")
		DBSETORDER(3)
		If !(DBSEEK(XFILIAL("SA1")+Alltrim(o_GravaPedido:CGC)))
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "CNPJ/CPF "+Alltrim(o_GravaPedido:CGC)+" nao encontrado na base de dados do protheus."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdGrvPedidoTit: CNPJ/CPF "+Alltrim(o_GravaPedido:CGC)+" nao encontrado na base de dados do protheus.")
			Return(.T.)
		Else
			c_Cli	:= SA1->A1_COD
			c_Loj	:= SA1->A1_LOJA
			//Valida o tipo
			dbSelectArea("SX5")
			dbSetOrder(1)
			If !(dbSeek(xfilial("SX5")+"05"+Alltrim(o_GravaPedido:E1_TIPO)))
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Tipo "+Alltrim(o_GravaPedido:E1_TIPO)+" nao encontrado na base de dados do protheus."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdGrvPedidoTit: Tipo "+Alltrim(o_GravaPedido:E1_TIPO)+" nao encontrado na base de dados do protheus.")
				Return(.T.)
			Else
				c_Tipo	:= SX5->X5_CHAVE
			EndIf

			c_Pre:= PADR(Alltrim(o_GravaPedido:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1])
			c_Num:= PADR(Alltrim(o_GravaPedido:E1_NUM), TAMSX3("E1_NUM")[1])
			c_Par:= PADR(Alltrim(o_GravaPedido:E1_PARCELA), TAMSX3("E1_PARCELA")[1])
			c_Tip:= PADR(Alltrim(o_GravaPedido:E1_TIPO), TAMSX3("E1_TIPO")[1])

			If (n_Operacao = 3) //Gravacao
				DBSELECTAREA("SE1")
				DBSETORDER(1)
				If !(DBSEEK(XFILIAL("SE1")+c_Pre+c_Num+c_Par+c_Tip+c_Cli+c_Loj))
					::o_Retorno:l_Status	:= .T. //03/12/2018 - retornar .T. a pedido de RAfael
					::o_Retorno:c_Mensagem	:= "###Titulo nao encontrado com os parametros passados para associar o PV."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdGrvPedidoTit: Titulo nao encontrado com os parametros passados para associar o PV")
					Return(.T.)
				Else
					DBSELECTAREA("SE1")
					RECLOCK("SE1",.F.)
					SE1->E1_PEDIDO:= o_GravaPedido:PEDIDO
					MSUNLOCK()
					::o_Retorno:l_Status	:= .T.
					::o_Retorno:c_Mensagem	:= "Pedido "+o_GravaPedido:PEDIDO+" gravado no titulo: "+XFILIAL("SE1")+c_Pre+c_Num+c_Par+c_Tip+c_Cli+c_Loj+"."
					Conout("FFIEBW01 - mtdGrvPedidoTit: Pedido "+o_GravaPedido:PEDIDO+" gravado no titulo: "+XFILIAL("SE1")+c_Pre+c_Num+c_Par+c_Tip+c_Cli+c_Loj+".")
				EndIf
			Else//Exclusao
				//verifica se o titulo existe
				DBSELECTAREA("SE1")
				DBSETORDER(1)
				If (DBSEEK(XFILIAL("SE1")+c_Pre+c_Num+c_Par+c_Tip+c_Cli+c_Loj))
					DBSELECTAREA("SE1")
					RECLOCK("SE1",.F.)
					SE1->E1_PEDIDO:= ""
					MSUNLOCK()
					::o_Retorno:l_Status	:= .T.
					::o_Retorno:c_Mensagem	:= "Pedido "+o_GravaPedido:PEDIDO+" excluido do titulo: "+XFILIAL("SE1")+c_Pre+c_Num+c_Par+c_Tip+c_Cli+c_Loj+"."
					Conout("FFIEBW01 - mtdGrvPedidoTit: Pedido "+o_GravaPedido:PEDIDO+" excluido do titulo: "+XFILIAL("SE1")+c_Pre+c_Num+c_Par+c_Tip+c_Cli+c_Loj+".")
				Else
					//Verifica se o titulo ja foi deletado
					c_Qry:= "SELECT E1_NUM "+chr(13)+chr(10)
					c_Qry+= "FROM "+RETSQLNAME("SE1")+" "+chr(13)+chr(10)
					c_Qry+= "WHERE D_E_L_E_T_ = '*' "+chr(13)+chr(10)
					c_Qry+= "AND E1_FILIAL = '"+XFILIAL("SE1")+"'"+chr(13)+chr(10)
					c_Qry+= "AND E1_PREFIXO = '"+c_Pre+"'"+chr(13)+chr(10)
					c_Qry+= "AND E1_NUM 	= '"+c_Num+"'"+chr(13)+chr(10)
					c_Qry+= "AND E1_PARCELA = '"+c_Par+"'"+chr(13)+chr(10)
					c_Qry+= "AND E1_TIPO 	= '"+c_Tip+"'"+chr(13)+chr(10)
					c_Qry+= "AND E1_CLIENTE = '"+c_Cli+"'"+chr(13)+chr(10)
					c_Qry+= "AND E1_LOJA 	= '"+c_Loj+"'"+chr(13)+chr(10)
					TCQUERY c_Qry ALIAS QRY NEW
					If (QRY->(!Eof()))
						::o_Retorno:l_Status	:= .T.
						::o_Retorno:c_Mensagem	:= "O titulo: "+XFILIAL("SE1")+c_Pre+c_Num+c_Par+c_Tip+c_Cli+c_Loj+" ja encontra-se deletado. Nao ha necessidade de limpar o campo."
						Conout("FFIEBW01 - mtdGrvPedidoTit: O titulo: "+XFILIAL("SE1")+c_Pre+c_Num+c_Par+c_Tip+c_Cli+c_Loj+" ja encontra-se deletado. Nao ha necessidade de limpar o campo.")
					Else
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "O titulo: "+XFILIAL("SE1")+c_Pre+c_Num+c_Par+c_Tip+c_Cli+c_Loj+" nunca existiu na base."
						Conout("FFIEBW01 - mtdGrvPedidoTit: O titulo: "+XFILIAL("SE1")+c_Pre+c_Num+c_Par+c_Tip+c_Cli+c_Loj+" nunca existiu na base.")
					EndIf
					dbSelectArea("QRY")
					QRY->(dbCloseArea())
				EndIf
			EndIf
		EndIf
	EndIf
	//RpcClearEnv() //Limpa o ambiente, liberando a licenca e fechando as conexoes

RETURN(.T.)
/*/{Protheus.doc} mtdMovBancaria
metodo da movimentacao bancaria
@author Totvs-BA
@since 31/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSMETHOD mtdMovBancaria WSRECEIVE o_Seguranca, o_Empresa, o_MovBancaria, Operacao WSSEND o_Retorno WSSERVICE FFIEBW01

	Local aVetor		:= {}
	Local n_Operacao	:= Val(::Operacao)

	//Variaveis da rotina de exclusao
	Local l_Padrao	:= 0
	Local c_Padrao	:= 0
	Local n_HdlPrv	:= 0
	Local nTotal	:= 0
	Local l_Mostra
	Local l_Aglutina
	Local l_MovBco 	:= .T.
	Local aFlagCTB	:= {}
	Local lUsaFlag	:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*c_Padrao*/)
	LOCAL cTipoLan
	Local c_Sinal 	:= Iif(SE5->E5_RECPAG=="P","+","-")
	Local l_BxConc  	:= GetNewPar("MV_BXCONC","2") == "1"
	Local a_Diario	:= {}
	Local l_FindITF	:= FindFunction("FinProcITF")
	Local l_AtuSldNat:= FindFunction("AtuSldNat") .AND. AliasInDic("FIV") .AND. AliasInDic("FIW")
	LOCAL c_Debito
	LOCAL c_Credito
	LOCAL c_RecPag
	LOCAL c_La
	Local c_CCC
	Local c_CCD
	Local c_ItemD
	Local c_ItemC
	Local c_ClVlDB
	Local c_ClVlCR
	Local l_Ret := .T.
	Local i
	Local c_ErrMsg	:= ""

	PRIVATE cLote 		:= ""
	PRIVATE cCodDiario  := ""
	PRIVATE cArquivo := " "
	//Fim das variaveis da rotina de exclusao
	PRIVATE lMsErroAuto := .F.

	::o_Retorno	:= WSCLASSNEW("strRetorno")

	If !(f_VldFilEmp(o_Empresa:c_Empresa,o_Empresa:c_Filial))
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Codigo de Empresa/Filial nao existe."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdMovBancaria: Codigo de Empresa/Filial nao existe.")
		Return(.T.)
	EndIf

	//Loga na filial solicitada
	RpcSetType(3)
	RpcSetEnv(o_Empresa:c_Empresa,o_Empresa:c_Filial, "integracao", "fieb123")

	//Posiciona na empresa e filial passada
	dbSelectArea("SM0")
	dbSeek(o_Empresa:c_Empresa+o_Empresa:c_Filial)

	cFilAnt:= o_Empresa:c_Filial

	c_UserWS	:= Upper(ALLTRIM(SUPERGETMV("FS_FIUSRWS",,"totvs_fieb")))
	c_PswWS		:= Upper(ALLTRIM(SUPERGETMV("FS_FIPSWWS",,"totvs@123")))

	//Validando o usuario e senha
	If ( Upper(o_Seguranca:c_Usuario) <> Upper(c_UserWS) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdMovBancaria: Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido.")
		Return(.T.)
	ElseIf ( Upper(o_Seguranca:c_Senha) <> Upper(c_PswWS) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdMovBancaria: Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida.")
		Return(.T.)
	ElseIf (n_Operacao < 3) .Or. (n_Operacao > 6)
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Valor passado no parametro Operacao ("+cValToChar(n_Operacao)+") invalido. Informar (3=Mov. a Pagar; 4=Mov. a Receber; 5=Exclusao; 6= Cancelamento)."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdMovBancaria: Valor passado no parametro Operacao ("+cValToChar(n_Operacao)+") invalido. Informar (3=Mov. a Pagar; 4=Mov. a Receber; 5=Exclusao; 6=Cancelamento).")
		Return(.T.)
	Else
		d_TesteData	:=	StoD(o_MovBancaria:E5_DATA)
		If valtype(d_TesteData) == "D"
			If Empty(d_TesteData)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe Data do movimento no formato [AAAAMMDD]."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdMovBancaria: Informe Data do movimento no formato [AAAAMMDD].")
				Return(.T.)
			EndIf
		Else
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe Data do movimento no formato [AAAAMMDD]."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdMovBancaria: Informe Data do movimento no formato [AAAAMMDD].")
			Return(.T.)
		EndIf
		If (d_TesteData < DDatabase)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Nao eh permitido que seja feita movimentacao em dados anteriores a data base."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdMovBancaria: Nao eh permitido que seja feita movimentacao em dados anteriores a data base.")
			Return(.T.)
		EndIf
		//Valida se o periodo esta bloqueado.
		c_Err:= ""
		d_TesteData	:=	StoD(o_MovBancaria:E5_DATA)
		If !( f_VldDtMov( "FIN", d_TesteData, @c_Err, "" ) )
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= c_Err
			Conout("FFIEBW01 - mtdMovBancaria: "+c_Err)
			Return(.T.)
		EndIf
		If Empty(o_MovBancaria:E5_MOEDA)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe a moeda (M1)."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdMovBancaria: Informe a moeda (M1).")
			Return(.T.)
		ElseIf Empty(o_MovBancaria:E5_VALOR)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "O valor do movimento nao pode ser vazio."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdMovBancaria: O valor do movimento nao pode ser vazio.")
			Return(.T.)
		ElseIf (o_MovBancaria:E5_VALOR < 0)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "O valor do movimento nao pode ser menor do que zero."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdMovBancaria: O valor do movimento nao pode ser menor do que zero.")
			Return(.T.)
		ElseIf Empty(o_MovBancaria:E5_NATUREZ)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe a natureza."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdMovBancaria: Informe a natureza.")
			Return(.T.)
		EndIf
		//Valida a natureza
		dbSelectArea("SED")
		dbSetOrder(1)
		If !(dbSeek(xfilial("SED")+Alltrim(o_MovBancaria:E5_NATUREZ)))
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Natureza "+Alltrim(o_MovBancaria:E5_NATUREZ)+" nao encontrada na base de dados do protheus."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdMovBancaria: Natureza "+Alltrim(o_MovBancaria:E5_NATUREZ)+" nao encontrada na base de dados do protheus.")
			Return(.T.)
		EndIf
		If Empty(o_MovBancaria:E5_BANCO) .Or. Empty(o_MovBancaria:E5_AGENCIA) .Or. Empty(o_MovBancaria:E5_CONTA)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Banco/Agencia/Conta nao informados."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdMovBancaria: Banco/Agencia/Conta nao informados.")
			Return(.T.)
		EndIf
		c_Ban:= Padr(o_MovBancaria:E5_BANCO,TamSX3("E5_BANCO")[1])
		c_Age:= Padr(o_MovBancaria:E5_AGENCIA,TamSX3("E5_AGENCIA")[1])
		c_Con:= Padr(o_MovBancaria:E5_CONTA,TamSX3("E5_CONTA")[1])
		DBSELECTAREA("SA6")
		DBSETORDER(1)
		If !DBSEEK(xFilial("SA6")+c_Ban+c_Age+c_Con)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "O banco/agencia/conta informado nao existe no cadastro de bancos: "+c_Ban+"/"+c_Age+"/"+c_Con
			Conout("FFIEBW01 - mtdMovBancaria: O banco/agencia/conta informado nao existe no cadastro de bancos: "+c_Ban+"/"+c_Age+"/"+c_Con)
			Return(.T.)
		EndIf
		If Empty(o_MovBancaria:E5_DOCUMEN)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe o documento."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdMovBancaria: Informe o documento.")
			Return(.T.)
		ElseIf Empty(o_MovBancaria:E5_BENEF)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe o beneficiario."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdMovBancaria: Informe o beneficiario.")
			Return(.T.)
		EndIf
		If !Empty(o_MovBancaria:E5_DEBITO)
			//Validando a conta contabil
			DBSELECTAREA("CT1")
			DBSETORDER(1)
			IF !DBSEEK(xFilial("CT1")+Alltrim(o_MovBancaria:E5_DEBITO))
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_MovBancaria:E5_DEBITO)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+"."
				Conout("FFIEBW01 - mtdMovBancaria: Codigo da conta contabil ("+Alltrim(o_MovBancaria:E5_DEBITO)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+".")
				Return(.T.)
			ElseIf CT1->CT1_CLASSE == "1"
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_MovBancaria:E5_DEBITO)+") nao pode ser sintetica."
				Conout("FFIEBW01 - mtdMovBancaria: Codigo da conta contabil ("+Alltrim(o_MovBancaria:E5_DEBITO)+") nao pode ser sintetica.")
				Return(.T.)
			ElseIf CT1->CT1_BLOQ == "1"
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_MovBancaria:E5_DEBITO)+") esta bloqueada para uso."
				Conout("FFIEBW01 - mtdMovBancaria: Codigo da conta contabil ("+Alltrim(o_MovBancaria:E5_DEBITO)+")  esta bloqueada para uso.")
				Return(.T.)
			EndIf
		EndIf
		If !Empty(o_MovBancaria:E5_CREDITO)
			//Validando a conta contabil
			DBSELECTAREA("CT1")
			DBSETORDER(1)
			IF !DBSEEK(xFilial("CT1")+Alltrim(o_MovBancaria:E5_CREDITO))
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_MovBancaria:E5_CREDITO)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+"."
				Conout("FFIEBW01 - mtdMovBancaria: Codigo da conta contabil ("+Alltrim(o_MovBancaria:E5_CREDITO)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+".")
				Return(.T.)
			ElseIf CT1->CT1_CLASSE == "1"
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_MovBancaria:E5_CREDITO)+") nao pode ser sintetica."
				Conout("FFIEBW01 - mtdMovBancaria: Codigo da conta contabil ("+Alltrim(o_MovBancaria:E5_CREDITO)+") nao pode ser sintetica.")
				Return(.T.)
			ElseIf CT1->CT1_BLOQ == "1"
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_MovBancaria:E5_CREDITO)+") esta bloqueada para uso."
				Conout("FFIEBW01 - mtdMovBancaria: Codigo da conta contabil ("+Alltrim(o_MovBancaria:E5_CREDITO)+")  esta bloqueada para uso.")
				Return(.T.)
			EndIf
		EndIf
		If !Empty(o_MovBancaria:E5_CCD)
			//Validando o centro de custo
			DbSelectArea("CTT")
			CTT->(dbSetOrder(1))
			If !(CTT->(dbSeek(xFilial("CTT")+Alltrim(o_MovBancaria:E5_CCD))))
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Centro de Custo informado para o campo E5_CCD invalido ("+Alltrim(o_MovBancaria:E5_CCD)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdMovBancaria: Centro de Custo informado para o campo E5_CCD invalido ("+Alltrim(o_MovBancaria:E5_CCD)+").")
				Return(.T.)
			Elseif CTT->CTT_CLASSE == "1"
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Centro de Custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_MovBancaria:E5_CCD)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdMovBancaria: Centro de Custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_MovBancaria:E5_CCD)+").")
				Return(.T.)
			Elseif CTT->CTT_BLOQ == "1"
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Centro de Custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_MovBancaria:E5_CCD)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdMovBancaria: Centro de Custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_MovBancaria:E5_CCD)+").")
				Return(.T.)
			Endif
		EndIf
		If !Empty(o_MovBancaria:E5_CCC)
			//Validando o centro de custo
			DbSelectArea("CTT")
			CTT->(dbSetOrder(1))
			If !(CTT->(dbSeek(xFilial("CTT")+Alltrim(o_MovBancaria:E5_CCC))))
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Centro de Custo informado para o campo E5_CCC invalido ("+Alltrim(o_MovBancaria:E5_CCC)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdMovBancaria: Centro de Custo informado para o campo E5_CCC invalido ("+Alltrim(o_MovBancaria:E5_CCC)+").")
				Return(.T.)
			Elseif CTT->CTT_CLASSE == "1"
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Centro de Custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_MovBancaria:E5_CCC)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdMovBancaria: Centro de Custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_MovBancaria:E5_CCC)+").")
				Return(.T.)
			Elseif CTT->CTT_BLOQ == "1"
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Centro de Custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_MovBancaria:E5_CCC)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdMovBancaria: Centro de Custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_MovBancaria:E5_CCC)+").")
				Return(.T.)
			Endif
		EndIf
		//Validando o item contabil
		If !Empty(o_MovBancaria:E5_ITEMD)
			DbSelectArea("CTD")
			CTD->(dbSetOrder(1))
			If !(CTD->(dbSeek(xFilial("CTD")+Alltrim(o_MovBancaria:E5_ITEMD))))
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Item contabil informado para o campo E5_ITEMD invalido ("+Alltrim(o_MovBancaria:E5_ITEMD)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdMovBancaria: Item contabil informado para o campo E5_ITEMD invalido ("+Alltrim(o_MovBancaria:E5_ITEMD)+").")
				Return(.T.)
			Elseif CTD->CTD_CLASSE == "1"
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Item contabil invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_MovBancaria:E5_ITEMD)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdMovBancaria: Item contabil invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_MovBancaria:E5_ITEMD)+").")
				Return(.T.)
			Elseif CTD->CTD_BLOQ == "1" .or. (!Empty(CTD->CTD_DTEXSF) .and. CTD->CTD_DTEXSF < dDatabase)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Item contabil invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_MovBancaria:E5_ITEMD)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdMovBancaria: Item contabil invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_MovBancaria:E5_ITEMD)+").")
				Return(.T.)
			ElseIf (!Empty(CTD->CTD_DTEXIS) .and. dDatabase < CTD->CTD_DTEXIS)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Item contabil ("+Alltrim(o_MovBancaria:E5_ITEMD)+") esta com data de inicio de existencia superior a data base."+CHR(13)+CHR(10)
				Return(.T.)
			Endif
		EndIf
		//Validando o item contabil
		If !Empty(o_MovBancaria:E5_ITEMC)
			DbSelectArea("CTD")
			CTD->(dbSetOrder(1))
			If !(CTD->(dbSeek(xFilial("CTD")+Alltrim(o_MovBancaria:E5_ITEMC))))
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Item contabil informado para o campo E5_ITEMC invalido ("+Alltrim(o_MovBancaria:E5_ITEMC)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdMovBancaria: Item contabil informado para o campo E5_ITEMC invalido ("+Alltrim(o_MovBancaria:E5_ITEMC)+").")
				Return(.T.)
			Elseif CTD->CTD_CLASSE == "1"
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Item contabil invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_MovBancaria:E5_ITEMC)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdMovBancaria: Item contabil invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_MovBancaria:E5_ITEMC)+").")
				Return(.T.)
			Elseif CTD->CTD_BLOQ == "1" .or. (!Empty(CTD->CTD_DTEXSF) .and. CTD->CTD_DTEXSF < dDatabase)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Item contabil invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_MovBancaria:E5_ITEMC)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdMovBancaria: Item contabil invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_MovBancaria:E5_ITEMC)+").")
				Return(.T.)
			ElseIf (!Empty(CTD->CTD_DTEXIS) .and. dDatabase < CTD->CTD_DTEXIS)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Item contabil ("+Alltrim(o_MovBancaria:E5_ITEMC)+") esta com data de inicio de existencia superior a data base."+CHR(13)+CHR(10)
				Return(.T.)
			Endif
		EndIf
		If !Empty(o_MovBancaria:E5_CLVLDB)
			//Validando a classe de valor
			DbSelectArea("CTH")
			CTH->(dbSetOrder(1))
			If !(CTH->(dbSeek(xFilial("CTH")+Alltrim(o_MovBancaria:E5_CLVLDB))))
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Classe de valor informado para o campo E5_CLVLDB invalido ("+Alltrim(o_MovBancaria:E5_CLVLDB)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdMovBancaria: Classe de valor informado para o campo E5_CLVLDB invalido ("+Alltrim(o_MovBancaria:E5_CLVLDB)+").")
				Return(.T.)
			Elseif CTH->CTH_CLASSE == "1"
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Classe de valor invalido. O Classe de valor nao pode ser sintetico ("+Alltrim(o_MovBancaria:E5_CLVLDB)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdMovBancaria: Classe de valor invalido. O Classe de valor nao pode ser sintetico ("+Alltrim(o_MovBancaria:E5_CLVLDB)+").")
				Return(.T.)
			Elseif CTH->CTH_BLOQ == "1"
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Classe de valor invalido. o Classe de valor esta bloqueado para uso ("+Alltrim(o_MovBancaria:E5_CLVLDB)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdMovBancaria: Classe de valor invalido. o Classe de valor esta bloqueado para uso ("+Alltrim(o_MovBancaria:E5_CLVLDB)+").")
				Return(.T.)
			Endif
		EndIf
		If !Empty(o_MovBancaria:E5_CLVLCR)
			//Validando a classe de valor
			DbSelectArea("CTH")
			CTH->(dbSetOrder(1))
			If !(CTH->(dbSeek(xFilial("CTH")+Alltrim(o_MovBancaria:E5_CLVLCR))))
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Classe de valor informado para o campo E5_CLVLCR invalido ("+Alltrim(o_MovBancaria:E5_CLVLCR)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdMovBancaria: Classe de valor informado para o campo E5_CLVLCR invalido ("+Alltrim(o_MovBancaria:E5_CLVLCR)+").")
				Return(.T.)
			Elseif CTH->CTH_CLASSE == "1"
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Classe de valor invalido. O Classe de valor nao pode ser sintetico ("+Alltrim(o_MovBancaria:E5_CLVLCR)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdMovBancaria: Classe de valor invalido. O Classe de valor nao pode ser sintetico ("+Alltrim(o_MovBancaria:E5_CLVLCR)+").")
				Return(.T.)
			Elseif CTH->CTH_BLOQ == "1"
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Classe de valor invalido. o Classe de valor esta bloqueado para uso ("+Alltrim(o_MovBancaria:E5_CLVLCR)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdMovBancaria: Classe de valor invalido. o Classe de valor esta bloqueado para uso ("+Alltrim(o_MovBancaria:E5_CLVLCR)+").")
				Return(.T.)
			Endif
		EndIf
		If (n_Operacao = 3) .Or. (n_Operacao = 4)

			//Valida se a natureza comeca com 3 OU 4 e obriga o UO - DEBITO
			If (Substr( Alltrim( o_MovBancaria:E5_DEBITO ),1,1 ) $ '3,4') .And. Empty(Alltrim( o_MovBancaria:E5_ITEMD ))
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Para Contas que comecam com 3 ou 4 ("+Alltrim( o_MovBancaria:E5_DEBITO )+") o CR devem ser preenchido."
				Conout("FFIEBW01 - mtdMovBancaria: Para Contas que comecam com 3 ou 4 ("+Alltrim( o_MovBancaria:E5_DEBITO )+") o CR devem ser preenchido.")
				Return(.T.)
			Else
				//Verifica se existe amarracao Filial + CR + UO - 11/09/2018
				If !(Empty(Alltrim( o_MovBancaria:E5_ITEMD )))
					If !(VerAmarrCTA(Alltrim(o_Empresa:c_Filial), "", Alltrim( o_MovBancaria:E5_ITEMD )))
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "Nao existe amarracao (Tabela CTA) entre Filial: ("+Alltrim(o_Empresa:c_Filial)+"), CR: ("+Alltrim( o_MovBancaria:E5_ITEMD )+")."
						Conout("FFIEBW01 - mtdMovBancaria: Nao existe amarracao (Tabela CTA) entre Filial: ("+Alltrim(o_Empresa:c_Filial)+"), CR: ("+Alltrim( o_MovBancaria:E5_ITEMD )+").")
						Return(.T.)
					Else
						//Busca o E5_CCD
						If FindFunction("u_ONECTA2()")
							c_CCGatilho := u_ONECTA2(1,Padr(Alltrim( o_MovBancaria:E5_ITEMD ),TamSx3("E5_ITEMD")[1]))
						EndIf
						If Empty(c_CCGatilho)
							::o_Retorno:l_Status	:= .F.
							::o_Retorno:c_Mensagem	:= "A funcao u_ONECTA2() nao retornou o CR para o E1_ITEMC: "+Alltrim( o_MovBancaria:E5_ITEMD )
							Return(.T.)
						EndIf
						//Valida se a conta comeca com 32 e o Cr possui o campo CTD_XRTADM = 2=Consumo;3=Corporativo;4=Unid. Compartilhadas 11/02/2019
						c_ErrMsg:= ""
						If !( f_VldCnInvest( Alltrim( o_MovBancaria:E5_DEBITO ), Alltrim( o_MovBancaria:E5_ITEMD ), @c_ErrMsg ) )
							::o_Retorno:l_Status	:= .F.
							::o_Retorno:c_Mensagem	:= c_ErrMsg
							Conout("FFIEBW01 - mtdMovBancaria: "+c_ErrMsg)
							Return(.T.)
						EndIf
					EndIf
				EndIf
			EndIf
			If (Substr( Alltrim( o_MovBancaria:E5_CREDITO ),1,1 ) $ '3,4') .And. Empty(Alltrim( o_MovBancaria:E5_ITEMC ))
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Para Contas que comecam com 3 ou 4 ("+Alltrim( o_MovBancaria:E5_CREDITO )+") o CR devem ser preenchido."
				Conout("FFIEBW01 - mtdMovBancaria: Para Contas que comecam com 3 ou 4 ("+Alltrim( o_MovBancaria:E5_CREDITO )+") o CR devem ser preenchido.")
				Return(.T.)
			Else
				//Verifica se existe amarracao Filial + CR + UO - 11/09/2018
				If !(Empty(Alltrim( o_MovBancaria:E5_ITEMC )))
					If !(VerAmarrCTA(Alltrim(o_Empresa:c_Filial), "", Alltrim( o_MovBancaria:E5_ITEMC )))
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "Nao existe amarracao (Tabela CTA) entre Filial: ("+Alltrim(o_Empresa:c_Filial)+"), CR: ("+Alltrim( o_MovBancaria:E5_ITEMC )+")."
						Conout("FFIEBW01 - mtdMovBancaria: Nao existe amarracao (Tabela CTA) entre Filial: ("+Alltrim(o_Empresa:c_Filial)+"), CR: ("+Alltrim( o_MovBancaria:E5_ITEMC )+").")
						Return(.T.)
					Else
						//Busca o E5_CCD
						If FindFunction("u_ONECTA2()")
							c_CCGatilho := u_ONECTA2(1,Padr(Alltrim( o_MovBancaria:E5_ITEMC ),TamSx3("E5_ITEMD")[1]))
						EndIf
						If Empty(c_CCGatilho)
							::o_Retorno:l_Status	:= .F.
							::o_Retorno:c_Mensagem	:= "A funcao u_ONECTA2() nao retornou o CR para o E1_ITEMC: "+Alltrim( o_MovBancaria:E5_ITEMC )
							Return(.T.)
						EndIf
						//Valida se a conta comeca com 32 e o Cr possui o campo CTD_XRTADM = 2=Consumo;3=Corporativo;4=Unid. Compartilhadas 11/02/2019
						c_ErrMsg:= ""
						If !( f_VldCnInvest( Alltrim( o_MovBancaria:E5_CREDITO ), Alltrim( o_MovBancaria:E5_ITEMC ), @c_ErrMsg ) )
							::o_Retorno:l_Status	:= .F.
							::o_Retorno:c_Mensagem	:= c_ErrMsg
							Conout("FFIEBW01 - mtdMovBancaria: "+c_ErrMsg)
							Return(.T.)
						EndIf
					EndIf
				EndIf
			EndIf
			//Valida se a conta comeca com 32 e o Cr possui o campo CTD_XRTADM = 2=Consumo;3=Corporativo;4=Unid. Compartilhadas 14/02/2019
			If !Empty( o_MovBancaria:E5_DEBITO ) .And. !Empty( o_MovBancaria:E5_ITEMD )
				c_ErrMsg:= ""
				If !( f_VldCnInvest( Alltrim( o_MovBancaria:E5_DEBITO ), Alltrim( o_MovBancaria:E5_ITEMD ), @c_ErrMsg ) )
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= c_ErrMsg
					Conout("FFIEBW01 - mtdMovBancaria: "+c_ErrMsg)
					Return(.T.)
				EndIf
			EndIf
			//Valida se a conta comeca com 32 e o Cr possui o campo CTD_XRTADM = 2=Consumo;3=Corporativo;4=Unid. Compartilhadas 14/02/2019
			If !Empty(o_MovBancaria:E5_CREDITO) .And. !Empty(o_MovBancaria:E5_ITEMC)
				c_ErrMsg:= ""
				If !( f_VldCnInvest( Alltrim( o_MovBancaria:E5_CREDITO ), Alltrim( o_MovBancaria:E5_ITEMC ), @c_ErrMsg ) )
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= c_ErrMsg
					Conout("FFIEBW01 - mtdMovBancaria: "+c_ErrMsg)
					Return(.T.)
				EndIf
			EndIf
			//Valida o rateio vigente: 12/09/2019.
			If( !Empty( o_MovBancaria:E5_ITEMC ) )
				DbSelectArea("CTD")
				CTD->(dbSetOrder(1))
				If (CTD->(dbSeek(xFilial("CTD")+o_MovBancaria:E5_ITEMC)))
					If ( Alltrim(CTD->CTD_XRTADM) $ '3|4' )
						If !( u_RtVigente( Alltrim( cFilAnt ), Alltrim( o_MovBancaria:E5_ITEMC ) ) )										
							::o_Retorno:l_Status	:= .F.
							::o_Retorno:c_Mensagem	:= "O CR por ser do tipo corporativo ou compartilhado, deve existir no rateio vigente. Filial: (" + Alltrim( cFilAnt ) + "), CR: (" + Alltrim( o_MovBancaria:E5_ITEMC ) + ")"
							Return(.T.)
						EndIf
					EndIf
				EndIf
			EndIf
			//Valida o rateio vigente: 11/09/2019.
			If( !Empty(o_MovBancaria:E5_ITEMD) )
				DbSelectArea("CTD")
				CTD->(dbSetOrder(1))
				If (CTD->(dbSeek(xFilial("CTD")+o_MovBancaria:E5_ITEMD)))
					If ( Alltrim(CTD->CTD_XRTADM) $ '3|4' )
						If !( u_RtVigente( Alltrim( cFilAnt ), Alltrim( o_MovBancaria:E5_ITEMD ) ) )							
							::o_Retorno:l_Status	:= .F.
							::o_Retorno:c_Mensagem	:= "O CR por ser do tipo corporativo ou compartilhado, deve existir no rateio vigente. Filial: (" + Alltrim( cFilAnt ) + "), CR: (" + Alltrim( o_MovBancaria:E5_ITEMD ) + ")"
							Return(.T.)
						EndIf
					EndIf
				EndIf
			EndIf
			
		EndIf
		If (n_Operacao = 5) .Or. (n_Operacao = 6)
			If Empty(o_MovBancaria:REC)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Para as operacoes 5 e 6 o recno (REC) deve ser informado."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdMovBancaria: Para as operacoes 5 e 6 o recno (REC) deve ser informado.")
				Return(.T.)
			ElseIf(o_MovBancaria:REC < 1)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Para as operacoes 5 e 6 o recno (REC) deve ser informado."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdMovBancaria: Para as operacoes 5 e 6 o recno (REC) deve ser informado.")
				Return(.T.)
			Else
				DbSelectArea("SE5")
		  		SE5->(DbGoto(o_MovBancaria:REC))
		  		If (SE5->(Recno()) <> o_MovBancaria:REC)
			  		::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Recno passado nao encontrado."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdMovBancaria: Recno passado nao encontrado.")
					Return(.T.)
				Else
					If (SE5->E5_SITUACA = 'C')
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "O registro informado ja foi cancelado. Recno: "+cValToChar(o_MovBancaria:REC)
						Conout("FFIEBW01 - mtdMovBancaria: O registro informado ja foi cancelado. Recno: "+cValToChar(o_MovBancaria:REC))
						Return(.T.)
					ElseIf (SE5->E5_SITUACA <> ' ')
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "O situacao do registro nao permite este tipo de operacao. Situacao: "+Alltrim(SE5->E5_SITUACA)+" Recno: "+cValToChar(o_MovBancaria:REC)
						Conout("FFIEBW01 - mtdMovBancaria: O situacao do registro nao permite este tipo de operacao. Situacao: "+Alltrim(SE5->E5_SITUACA)+" Recno: "+cValToChar(o_MovBancaria:REC))
						Return(.T.)
					ElseIf (SE5->E5_TIPODOC = 'TR') .Or. (SE5->E5_TIPODOC = 'TE')
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "O tipodoc deste registro nao permite este tipo de operacao. TIPODOC: "+Alltrim(SE5->E5_TIPODOC)+" Recno: "+cValToChar(o_MovBancaria:REC)
						Conout("FFIEBW01 - mtdMovBancaria: O tipodoc deste registro nao permite este tipo de operacao. TIPODOC: "+Alltrim(SE5->E5_TIPODOC)+" Recno: "+cValToChar(o_MovBancaria:REC))
						Return(.T.)
					EndIf
		  		EndIf
			EndIf
		EndIf
		//o_ParamMov:n_Oper
		//3= Mov. a Pagar
		//4= Mov. a Receber
		//5= Exclusao
		//6= Cancelamento
		//7= Transferncia
		//8= Estorno da transferencia
		If (n_Operacao = 3) .Or. (n_Operacao = 4) .Or. (n_Operacao = 6)

		  	If (n_Operacao = 6) //Cancelamento
		  		DbSelectArea("SE5")
		  		SE5->(DbGoto(o_MovBancaria:REC))
		  	EndIf

			aAdd( aVetor, {"E5_FILIAL"	,o_Empresa:c_Filial	,Nil})
			aAdd( aVetor, {"E5_DATA" 	,StoD(o_MovBancaria:E5_DATA) , Nil})
			aAdd( aVetor, {"E5_MOEDA" 	,PADR(Alltrim(o_MovBancaria:E5_MOEDA)	, TAMSX3("E5_MOEDA")[1]) 	,Nil})
			aAdd( aVetor, {"E5_VALOR" 	,o_MovBancaria:E5_VALOR,Nil})
			aAdd( aVetor, {"E5_NATUREZ"	,PADR(Alltrim(o_MovBancaria:E5_NATUREZ)	, TAMSX3("E5_NATUREZ")[1])	,Nil})
			aAdd( aVetor, {"E5_BANCO" 	,PADR(Alltrim(o_MovBancaria:E5_BANCO)	, TAMSX3("E5_BANCO")[1]) 	,Nil})
			aAdd( aVetor, {"E5_AGENCIA" ,PADR(Alltrim(o_MovBancaria:E5_AGENCIA)	, TAMSX3("E5_AGENCIA")[1]) 	,Nil})
			aAdd( aVetor, {"E5_CONTA" 	,PADR(Alltrim(o_MovBancaria:E5_CONTA)	, TAMSX3("E5_CONTA")[1]) 	,Nil})
			aAdd( aVetor, {"E5_NUMCHEQ" ,PADR(Alltrim(o_MovBancaria:E5_NUMCHEQ)	, TAMSX3("E5_NUMCHEQ")[1]) 	,Nil})
			aAdd( aVetor, {"E5_DOCUMEN" ,PADR(Alltrim(o_MovBancaria:E5_DOCUMEN), TAMSX3("E5_DOCUMENT")[1]) ,Nil})
			aAdd( aVetor, {"E5_BENEF" 	,PADR(Alltrim(o_MovBancaria:E5_BENEF)	, TAMSX3("E5_BENEF")[1]) 	,Nil})
			aAdd( aVetor, {"E5_HISTOR" 	,PADR(Alltrim(o_MovBancaria:E5_HISTOR)	, TAMSX3("E5_HISTOR")[1]) 	,Nil})
			aAdd( aVetor, {"E5_LA" 		,"S" 	,Nil})
			If !Empty(o_MovBancaria:E5_DEBITO)
				aAdd( aVetor, {"E5_DEBITO" 	,PADR(Alltrim(o_MovBancaria:E5_DEBITO)	, TAMSX3("E5_DEBITO")[1]) 	,Nil})
			EndIf
			If !Empty(o_MovBancaria:E5_CREDITO)
				aAdd( aVetor, {"E5_CREDITO" ,PADR(Alltrim(o_MovBancaria:E5_CREDITO)	, TAMSX3("E5_CREDITO")[1]) 	,Nil})
			EndIf
			If !Empty(o_MovBancaria:E5_CCD)
				aAdd( aVetor, {"E5_CCD" 	,PADR(Alltrim(o_MovBancaria:E5_CCD)		, TAMSX3("E5_CCD")[1]) 		,Nil})
			EndIf
			If !Empty(o_MovBancaria:E5_CCC)
				aAdd( aVetor, {"E5_CCC" 	,PADR(Alltrim(o_MovBancaria:E5_CCC)		, TAMSX3("E5_CCC")[1]) 		,Nil})
			EndIf
			If !Empty(o_MovBancaria:E5_ITEMD)
				aAdd( aVetor, {"E5_ITEMD" 	,PADR(Alltrim(o_MovBancaria:E5_ITEMD)	, TAMSX3("E5_ITEMD")[1]) 	,Nil})
			EndIf
			If !Empty(o_MovBancaria:E5_ITEMC)
				aAdd( aVetor, {"E5_ITEMC" 	,PADR(Alltrim(o_MovBancaria:E5_ITEMC)	, TAMSX3("E5_ITEMC")[1]) 	,Nil})
			EndIf
			If !Empty(o_MovBancaria:E5_CLVLDB)
				aAdd( aVetor, {"E5_CLVLDB" 	,PADR(Alltrim(o_MovBancaria:E5_CLVLDB)	, TAMSX3("E5_CLVLDB")[1]) 	,Nil})
			EndIf
			If !Empty(o_MovBancaria:E5_CLVLCR)
				aAdd( aVetor, {"E5_CLVLCR" 	,PADR(Alltrim(o_MovBancaria:E5_CLVLCR)	, TAMSX3("E5_CLVLCR")[1]) 	,Nil})
			EndIf

			Pergunte ("AFI100",.F.)
			MV_PAR01:= 2
			MV_PAR02:= 2
			MV_PAR03:= 2
			MV_PAR04:= 2

			lMsErroAuto		:= .F.
			lMsHelpAuto		:= .T.
			lAutoErrNoFile	:= .T.

			Begin Transaction
				MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aVetor,n_Operacao)
				If lMsErroAuto
					DisarmTransaction()
					Break
				Else
					IF (n_Operacao = 3)
						::o_Retorno:l_Status	:= .T.
						::o_Retorno:c_Mensagem	:= "Movimento bancario a pagar incluido com sucesso na filial "+o_Empresa:c_Filial+". RECNO: "+cValToChar(SE5->(RECNO()))
						Conout("FFIEBW01 - mtdMovBancaria: Movimento bancario a pagar incluido com sucesso na filial "+o_Empresa:c_Filial+". RECNO: "+cValToChar(SE5->(RECNO())))
					ELSEIF (n_Operacao = 4)
						::o_Retorno:l_Status	:= .T.
						::o_Retorno:c_Mensagem	:= "Movimento bancario a receber incluido com sucesso na filial "+o_Empresa:c_Filial+". RECNO: "+cValToChar(SE5->(RECNO()))
						Conout("FFIEBW01 - mtdMovBancaria: Movimento bancario a receber incluido com sucesso na filial "+o_Empresa:c_Filial+". RECNO: "+cValToChar(SE5->(RECNO())))
					ELSEIF (n_Operacao = 6)
						::o_Retorno:l_Status	:= .T.
						::o_Retorno:c_Mensagem	:= "Cancelamento do movimento bancario realizada com sucesso na filial "+o_Empresa:c_Filial+"."
						Conout("FFIEBW01 - mtdMovBancaria: Cancelamento do movimento bancario realizada com sucesso na filial "+o_Empresa:c_Filial+".")
					ENDIF
				EndIf
		   	End Transaction
			//Se deu erro no execauto
			If lMsErroAuto
				//Regra do fonte SIESBA01 da FIEB
				If (__lSX8)
					RollBackSX8()
				EndIf

				// Tratamento da Mensagem de erro do MSExecAuto
				aLogErr  := GetAutoGRLog()
				aLogErr2 := f_TrataErro(aLogErr)
				_cMotivo := ""

				For i := 1 to Len(aLogErr2)
					_cMotivo += aLogErr2[i]
				Next

				//Exclusivo para a versao 12
				If (GetVersao(.F.) == "12")
					_cMotivo:=  NoAcentoESB(_cMotivo)
					SetSoapFault('Erro',_cMotivo)
				EndIf
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= NoAcentoESB(_cMotivo)
				Conout("FFIEBW01 - mtdMovBancaria: "+NoAcentoESB(_cMotivo))
			EndIf
		Else
			//Exclusao - trecho retirado do fonte padrao
			DBSELECTAREA("SE5")
			DBGOTO(o_MovBancaria:REC)
			c_Doc		:= SE5->E5_DOCUMENT
			c_Debito	:= SE5->E5_DEBITO
			c_Credito	:= SE5->E5_CREDITO
			c_RecPag	:= SE5->E5_RECPAG
			c_La		:= SE5->E5_LA
			c_CCC		:= SE5->E5_CCC
			c_CCD		:= SE5->E5_CCD
			c_ItemD		:= SE5->E5_ITEMD
			c_ItemC		:= SE5->E5_ITEMC
			c_ClVlDB	:= SE5->E5_CLVLDB
			c_ClVlCR	:= SE5->E5_CLVLCR

			IF	SE5->E5_TIPOLAN $ "DC"		// Inverte o tipo de lancamento
				If cTipoLan == "D"
				   cTipolan := "C"
				Else
					cTipoLan := "D"
				Endif
			Endif

			LoteCont( "FIN" )

			While l_Ret

				dbSelectArea( "SE5" )
				nOpcA:=0

				If !DtMovFin(SE5->E5_DATA)
					l_Ret := .F.
					Loop
				Endif

				IF SE5->E5_SITUACA $ "C/E/X"
					Help(" ",1,"JA-CANCEL")
					l_Ret := .F.
					Loop
				Endif
				//Nao permito cancelamento de baixa se a mesma foi conciliada e se
				//o parametro MV_BXCONC estiver como 2(Padrao) - Nao permite
				If !Empty(SE5->E5_RECONC) .And. !l_BxConc
					Help(" ",1,"MOVRECONC")
					l_Ret := .F.
					Loop
				Endif

				//Verifica bloqueio da conta
				If CCBLOCKED(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA)
					l_Ret := .F.
					Loop
				Endif

				IF !SoftLock( "SE5")
					l_Ret := .F.
					Loop
				EndIf
				dbSelectArea( "SE5" )

				nOpcA:=1
				bCampo := {|nCPO| Field(nCPO) }
				FOR i := 1 TO FCount()
					M->&(EVAL(bCampo,i)) := FieldGet(i)
				NEXT i
				//aSize := MSADVSIZE()

				Begin Transaction
					dbSelectArea( "SED" )
					dbSeek( xFilial("SED") + SE5->E5_NATUREZ )
					dbSelectArea("SA6")
					dbSeek(o_Empresa:c_Filial+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA)

					IF SE5->E5_VENCTO > SE5->E5_DATA
						l_MovBco := .f.
					ElseIf SE5->E5_MOEDA$"C1/C2/C3/C4/C5/CH".and.;
							(Empty(SE5->E5_NUMCHEQ) .or. Substr(SE5->E5_NUMCHEQ,1,1)=="*")
						l_MovBco := .f.
					Endif

					If l_MovBco
						AtuSalBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,dDataBase,SE5->E5_VALOR,c_Sinal)
					EndIf

					If l_AtuSldNat
						AtuSldNat(SE5->E5_NATUREZ, SE5->E5_DATA, "01", "3", c_RecPag, SE5->E5_VALOR,, "-",,FunName(),"SE5", SE5->(Recno()),5)
					Endif

					c_Padrao := IIF ( c_RecPag ="P","564","565" )

					l_Padrao  := VerPadrao( c_Padrao )

					RecLock("SE5",.F.)
					Replace E5_SITUACA  With "C"		//identificacao de um movimento cancelado
					//Somente na Exclusao
					//Os valores de credito e debito sao
					//invertidos para o lancamento contabil
					Replace E5_DEBITO   With c_Credito	// inverter
					Replace E5_CREDITO  With c_Debito	// inverter
					Replace E5_CCC		With c_CCD		// Inverter
					Replace E5_CCD      With c_CCC		// Inverter
					Replace E5_ITEMC	With c_ItemD		// Inverter
					Replace E5_ITEMD    With c_ItemC		// Inverter
					Replace E5_CLVLCR	With c_ClVlDB	// Inverter
					Replace E5_CLVLDB	With c_ClVlCR	// Inverter
					MsUnlock()
										
					//Lancamento Contabil
					l_Padrao := VerPadrao( c_Padrao )
					If l_Padrao .and. SubStr(c_La,1,1) == "S"		// Contabiliza apenas se a origem foi contabilizada						
						//Inicializa Lancamento Contabil
						n_HdlPrv := HeadProva( cLote,;
				                      "FINA100" /*cPrograma*/,;
				                      Substr( cUsuario, 7, 6 ),;
				                      @cArquivo )

						
						//Prepara Lancamento Contabil
						If lUsaFlag  // Armazena em aFlagCTB para atualizar no modulo Contabil
							aAdd( aFlagCTB, {"E5_LA", "S", "SE5", SE5->( Recno() ), 0, 0, 0} )
						Endif
						nTotal += DetProva( n_HdlPrv,;
						                    c_Padrao,;
						                    "FINA100" /*cPrograma*/,;
						                    cLote,;
						                    /*nLinha*/,;
						                    /*lExecuta*/,;
						                    /*cCriterio*/,;
						                    /*lRateio*/,;
						                    /*cChaveBusca*/,;
						                    /*aCT5*/,;
						                    /*lPosiciona*/,;
						                    @aFlagCTB,;
						                    /*aTabRecOri*/,;
						                    /*aDadosProva*/ )

						If c_RecPag == "P" .And. l_FindITF .And. FinProcITF( SE5->( Recno() ),1 )
							FinProcITF( SE5->( Recno() ), 5, , .F.,{ n_HdlPrv, c_Padrao, "", "FINA100", cLote }, @aFlagCTB)
						EndIf

						If ( FindFunction( "UsaSeqCor" ) .And. UsaSeqCor() )
							a_Diario := {{"SE5",SE5->(RECNO()),cCodDiario,"E5_NODIA","E5_DIACTB"}}
						Else
							a_Diario := {}
						Endif
						
						//Efetiva Lan‡amento Contabil
						l_Mostra   := .F.
						l_Aglutina := .F.

						RodaProva( n_HdlPrv,;
									  nTotal )
						cA100Incl( cArquivo,;
							           n_HdlPrv,;
							           3 /*nOpcx*/,;
							           cLote,;
							           l_Mostra /*lDigita*/,;
							           l_Aglutina /*lAglut*/,;
							           /*cOnLine*/,;
							           /*dData*/,;
							           /*dReproc*/,;
							           @aFlagCTB,;
							           /*aDadosProva*/,;
							           a_Diario )
						aFlagCTB := {}  // Limpa o coteudo apos a efetivacao do lancamento

						If !lUsaFlag
							Reclock("SE5")
								SE5->E5_LA := "S" + SubStr( E5_LA,2,1 )
							MsUnLock()
						Endif
					Endif
					
					// Somente na Exclusao                       
					// ----------------------------------        
					// A inversao dos valores de credito e debito
					// e' corrigida depois do lancamento contabil
					If ( E5_SITUACA == "C" )
						RecLock("SE5",.F.)
						Replace E5_DEBITO   With c_Debito	// Corrige Inversao
						Replace E5_CREDITO  With c_Credito	// Corrige Inversao
						Replace E5_CCC		With c_CCC		// Corrige Inversao
						Replace E5_CCD      With c_CCD		// Corrige Inversao
						Replace E5_ITEMC	With c_ItemC		// Corrige Inversao
						Replace E5_ITEMD    With c_ItemD		// Corrige Inversao
						Replace E5_CLVLCR	With c_ClVlCR	// Corrige Inversao
						Replace E5_CLVLDB	With c_ClVlDB	// Corrige Inversao
						MsUnlock()
					Endif
				End Transaction
				Exit
			Enddo

			If	l_Ret
				::o_Retorno:l_Status	:= .T.
				::o_Retorno:c_Mensagem	:= "Exclusao do movimento bancario realizada com sucesso na filial "+o_Empresa:c_Filial+"."
				Conout("FFIEBW01 - mtdMovBancaria: Exclusao do movimento bancario realizada com sucesso na filial "+o_Empresa:c_Filial+".")
			Else
				// Tratamento da Mensagem de erro do MSExecAuto
				aLogErr  := GetAutoGRLog()
				aLogErr2 := f_TrataErro(aLogErr)
				_cMotivo := ""

				For i := 1 to Len(aLogErr2)
					_cMotivo += aLogErr2[i]
				Next
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= NoAcentoESB(_cMotivo)
				Conout("FFIEBW01 - mtdMovBancaria: "+NoAcentoESB(_cMotivo))
				DisarmTransaction()
				Break
			ENDIF

		EndIf
	EndIf
	//RpcClearEnv() //Limpa o ambiente, liberando a licenca e fechando as conexoes

RETURN(.T.)
/*/{Protheus.doc} mtdTransBancaria
metodo da movimentacao bancaria
@author Totvs-BA
@since 31/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSMETHOD mtdTransBancaria WSRECEIVE o_Seguranca, o_Empresa, o_TransBancaria WSSEND o_Retorno WSSERVICE FFIEBW01

	Local aVetor		:= {}
	Local i
	PRIVATE lMsErroAuto := .F.

	::o_Retorno	:= WSCLASSNEW("strRetorno")

	If !(f_VldFilEmp(o_Empresa:c_Empresa,o_Empresa:c_Filial))
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Codigo de Empresa/Filial nao existe."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdTransBancaria: Codigo de Empresa/Filial nao existe.")
		Return(.T.)
	EndIf

	//Loga na filial solicitada
	RpcSetType(3)
	RpcSetEnv(o_Empresa:c_Empresa,o_Empresa:c_Filial, "integracao", "fieb123")

	//Posiciona na empresa e filial passada
	dbSelectArea("SM0")
	dbSeek(o_Empresa:c_Empresa+o_Empresa:c_Filial)

	cFilAnt:= o_Empresa:c_Filial

	c_UserWS	:= Upper(ALLTRIM(SUPERGETMV("FS_FIUSRWS",,"totvs_fieb")))
	c_PswWS		:= Upper(ALLTRIM(SUPERGETMV("FS_FIPSWWS",,"totvs@123")))

	//Validando o usuario e senha
	If ( Upper(o_Seguranca:c_Usuario) <> Upper(c_UserWS) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdTransBancaria: Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido.")
		Return(.T.)
	ElseIf ( Upper(o_Seguranca:c_Senha) <> Upper(c_PswWS) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdTransBancaria: Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida.")
		Return(.T.)
	Else
		If Empty(o_TransBancaria:CBCOORIG) .Or. Empty(o_TransBancaria:CAGENORIG) .Or. Empty(o_TransBancaria:CCTAORIG)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Banco/Agencia/Conta de origem nao informados."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdTransBancaria: Banco/Agencia/Conta de origem nao informados.")
			Return(.T.)
		EndIf
		c_Ban:= Padr(o_TransBancaria:CBCOORIG,TamSX3("E5_BANCO")[1])
		c_Age:= Padr(o_TransBancaria:CAGENORIG,TamSX3("E5_AGENCIA")[1])
		c_Con:= Padr(o_TransBancaria:CCTAORIG,TamSX3("E5_CONTA")[1])
		DBSELECTAREA("SA6")
		DBSETORDER(1)
		If !DBSEEK(xFilial("SA6")+c_Ban+c_Age+c_Con)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "O banco/agencia/conta de origem informado nao existe no cadastro de bancos: "+c_Ban+"/"+c_Age+"/"+c_Con
			Conout("FFIEBW01 - mtdTransBancaria: O banco/agencia/conta de origem informado nao existe no cadastro de bancos: "+c_Ban+"/"+c_Age+"/"+c_Con)
			Return(.T.)
		EndIf
		If Empty(o_TransBancaria:CNATURORI)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe a natureza de origem."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdTransBancaria: Informe a natureza de origem.")
			Return(.T.)
		EndIf
		dbSelectArea("SED")
		dbSetOrder(1)
		If !(dbSeek(xfilial("SED")+Alltrim(o_TransBancaria:CNATURORI)))
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Natureza de origem "+Alltrim(o_TransBancaria:CNATURORI)+" nao encontrada na base de dados do protheus."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdTransBancaria: Natureza de origem "+Alltrim(o_TransBancaria:CNATURORI)+" nao encontrada na base de dados do protheus.")
			Return(.T.)
		EndIf
		If Empty(o_TransBancaria:CBCODEST) .Or. Empty(o_TransBancaria:CAGENDEST) .Or. Empty(o_TransBancaria:CCTADEST)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Banco/Agencia/Conta de destino nao informados."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdTransBancaria: Banco/Agencia/Conta de destino nao informados.")
			Return(.T.)
		EndIf
		c_Ban:= Padr(o_TransBancaria:CBCODEST,TamSX3("E5_BANCO")[1])
		c_Age:= Padr(o_TransBancaria:CAGENDEST,TamSX3("E5_AGENCIA")[1])
		c_Con:= Padr(o_TransBancaria:CCTADEST,TamSX3("E5_CONTA")[1])
		DBSELECTAREA("SA6")
		DBSETORDER(1)
		If !DBSEEK(xFilial("SA6")+c_Ban+c_Age+c_Con)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "O banco/agencia/conta de destino informado nao existe no cadastro de bancos: "+c_Ban+"/"+c_Age+"/"+c_Con
			Conout("FFIEBW01 - mtdTransBancaria: O banco/agencia/conta de destino informado nao existe no cadastro de bancos: "+c_Ban+"/"+c_Age+"/"+c_Con)
			Return(.T.)
		EndIf
		If Empty(o_TransBancaria:CNATURDES)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe a natureza de destino."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdTransBancaria: Informe a natureza de destino.")
			Return(.T.)
		EndIf
		dbSelectArea("SED")
		dbSetOrder(1)
		If !(dbSeek(xfilial("SED")+Alltrim(o_TransBancaria:CNATURDES)))
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Natureza de destino "+Alltrim(o_TransBancaria:CNATURDES)+" nao encontrada na base de dados do protheus."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdTransBancaria: Natureza de destino "+Alltrim(o_TransBancaria:CNATURDES)+" nao encontrada na base de dados do protheus.")
			Return(.T.)
		EndIf
		If Empty(o_TransBancaria:CTIPOTRAN)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe o tipo de lancamento."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdTransBancaria: Informe o tipo de lancamento.")
			Return(.T.)
		EndIf
		dbSelectArea("SX5")
		dbSetOrder(1)
		If !(dbSeek(xfilial("SX5")+"14"+Alltrim(o_TransBancaria:CTIPOTRAN)))
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Tipo "+Alltrim(o_TransBancaria:CTIPOTRAN)+" invalido. Informar: (CC, CD, CH, CO, DOC, FI, R$, TB, TC, VL)"+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdTransBancaria: Tipo "+Alltrim(o_TransBancaria:CTIPOTRAN)+" invalido.  Informar: (CC, CD, CH, CO, DOC, FI, R$, TB, TC, VL)")
			Return(.T.)
		EndIf
		If Empty(o_TransBancaria:CDOCTRAN)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe o documento."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdTransBancaria: Informe o documento.")
			Return(.T.)
		EndIf
		If Empty(o_TransBancaria:NVALORTRAN)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "O valor do transferencia nao pode ser vazio."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdTransBancaria: O valor do transferencia nao pode ser vazio.")
			Return(.T.)
		ElseIf (o_TransBancaria:NVALORTRAN < 0)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "O valor do transferencia nao pode ser menor do que zero."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdTransBancaria: O valor do transferencia nao pode ser menor do que zero.")
			Return(.T.)
		EndIf
		If Empty(o_TransBancaria:CHIST100)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe o historico."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdTransBancaria: Informe o historico.")
			Return(.T.)
		ElseIf Empty(o_TransBancaria:CBENEF100)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe o beneficiario."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdTransBancaria: Informe o beneficiario.")
			Return(.T.)
		EndIf

		d_TesteData	:=	StoD(o_TransBancaria:AUTDTMOV)
		If valtype(d_TesteData) == "D"
			If Empty(d_TesteData)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe Data do movimento no formato [AAAAMMDD]."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdTransBancaria: Informe Data do movimento no formato [AAAAMMDD].")
				Return(.T.)
			EndIf
		Else
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe Data do movimento no formato [AAAAMMDD]."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdTransBancaria: Informe Data do movimento no formato [AAAAMMDD].")
			Return(.T.)
		EndIf

		//Valida se o periodo esta bloqueado.
		c_Err:= ""
		d_TesteData	:=	StoD(o_TransBancaria:AUTDTMOV)
		If !( f_VldDtMov( "FIN", d_TesteData, @c_Err, "" ) )
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= c_Err
			Conout("FFIEBW01 - mtdTransBancaria: "+c_Err)
			Return(.T.)
		EndIf
		
		//Id da transferencia do Rm - 13/09/2019
		
		If Empty(o_TransBancaria:XIDTRANSRM)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe Id da transferencia do RM."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdTransBancaria: Informe Id da transferencia do RM.")
			Return(.T.)
		EndIf
		
		aVetor := { {"CBCOORIG" 	,Alltrim(o_TransBancaria:CBCOORIG)	,Nil},;
					{"CAGENORIG" 	,Alltrim(o_TransBancaria:CAGENORIG)	,Nil},;
					{"CCTAORIG" 	,Alltrim(o_TransBancaria:CCTAORIG)	,Nil},;
					{"CNATURORI" 	,Alltrim(o_TransBancaria:CNATURORI)	,Nil},;
					{"CBCODEST" 	,Alltrim(o_TransBancaria:CBCODEST)	,Nil},;
					{"CAGENDEST" 	,Alltrim(o_TransBancaria:CAGENDEST)	,Nil},;
					{"CCTADEST" 	,Alltrim(o_TransBancaria:CCTADEST)	,Nil},;
					{"CNATURDES" 	,Alltrim(o_TransBancaria:CNATURDES)	,Nil},;
					{"CTIPOTRAN" 	,Alltrim(o_TransBancaria:CTIPOTRAN)	,Nil},;
					{"CDOCTRAN" 	,Alltrim(o_TransBancaria:CDOCTRAN)	,Nil},;
					{"NVALORTRAN" 	,o_TransBancaria:NVALORTRAN			,Nil},;
					{"CHIST100" 	,Alltrim(o_TransBancaria:CHIST100)	,Nil},;
					{"CBENEF100" 	,Alltrim(o_TransBancaria:CBENEF100)	,Nil}}

		lMsErroAuto		:= .F.
		lMsHelpAuto		:= .T.
		lAutoErrNoFile	:= .T.

		Begin Transaction

			DDATABASE:= Stod(o_TransBancaria:AUTDTMOV) //Grava a transferencia com a data passada.

			MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aVetor,7)

			If lMsErroAuto
				DisarmTransaction()
				Break
			Else
				//ITEM 11
				c_Fil:= Alltrim(o_Empresa:c_Filial)
				d_Dat:= Alltrim(o_TransBancaria:AUTDTMOV)
				c_Doc:= Padr(Alltrim(o_TransBancaria:CDOCTRAN),TamSX3("E5_DOCUMEN")[1])				
							
				//Busca o lancamento no banco de origem para gravar o Id da transferencia
				c_Nat:= Padr(Alltrim(o_TransBancaria:CNATURORI),TamSX3("E5_NATUREZ")[1])
				c_Ban:= Padr(Alltrim(o_TransBancaria:CBCOORIG),TamSX3("E5_BANCO")[1])
				c_Age:= Padr(Alltrim(o_TransBancaria:CAGENORIG),TamSX3("E5_AGENCIA")[1])
				c_Con:= Padr(Alltrim(o_TransBancaria:CCTAORIG),TamSX3("E5_CONTA")[1])								
				c_Qry	:=	"" 										+ENTER
				c_Qry	+=	"SELECT TOP 1 E5_FSIDTRA, R_E_C_N_O_"	+ENTER
				c_Qry	+=	"FROM "+RetSqlName("SE5")+" E5 "		+ENTER
				c_Qry	+=	"WHERE "								+ENTER
				c_Qry	+=	"		E5.D_E_L_E_T_ 	= '' "			+ENTER
				c_Qry	+=	"AND 	E5_FSIDTRA 		= '' "			+ENTER
				c_Qry	+=	"AND 	E5_FILIAL		= '"+c_Fil+"' "	+ENTER
				c_Qry	+=  "AND 	E5_NATUREZ 		= '"+c_Nat+"' "	+ENTER
				c_Qry	+=  "AND 	E5_BANCO 		= '"+c_Ban+"' "	+ENTER
				c_Qry	+=  "AND 	E5_AGENCIA 		= '"+c_Age+"' "	+ENTER
				c_Qry	+=  "AND 	E5_CONTA 		= '"+c_Con+"' "	+ENTER
				c_Qry	+=  "AND 	E5_DATA 		= '"+d_Dat+"' "	+ENTER
				c_Qry	+=  "AND 	E5_NUMCHEQ		= '"+c_Doc+"' "	+ENTER //Na origem o documento fica no NUMCHEQ
				c_Qry	+=	"AND 	E5_RECPAG 		= 'P' "			+ENTER //Na oritem o recpag = P
				c_Qry	+=  "AND 	E5_TIPODOC 		= 'TR' "		+ENTER
				c_Qry	+=  "AND 	E5_MOEDA 		= 'TB' "		+ENTER
				c_Qry	+=  "ORDER BY R_E_C_N_O_ DESC "				+ENTER
							
				TCQUERY c_Qry ALIAS QRYTR NEW
				If !(QRYTR->(Eof()))					
					//Grava o ID da transferencia
					DbSelectArea("SE5")
					DbGoTo(QRYTR->R_E_C_N_O_)
					Reclock("SE5",.F.)
					SE5->E5_FSIDTRA 	:= Alltrim(o_TransBancaria:XIDTRANSRM) //id da transferencia do RM
					MsUnlock()
				EndIf
				DbSelectArea("QRYTR")
				QRYTR->(DbCloseArea())				
				
				//Busca o lancamento no banco de destino para gravar o Id da transferencia
				c_Nat:= Padr(Alltrim(o_TransBancaria:CNATURDES),TamSX3("E5_NATUREZ")[1])
				c_Ban:= Padr(Alltrim(o_TransBancaria:CBCODEST),TamSX3("E5_BANCO")[1])
				c_Age:= Padr(Alltrim(o_TransBancaria:CAGENDEST),TamSX3("E5_AGENCIA")[1])
				c_Con:= Padr(Alltrim(o_TransBancaria:CCTADEST),TamSX3("E5_CONTA")[1])								
				c_Qry	:=	"" 										+ENTER
				c_Qry	+=	"SELECT TOP 1 E5_FSIDTRA, R_E_C_N_O_"	+ENTER
				c_Qry	+=	"FROM "+RetSqlName("SE5")+" E5 "		+ENTER
				c_Qry	+=	"WHERE "								+ENTER
				c_Qry	+=	"		E5.D_E_L_E_T_ 	= '' "			+ENTER
				c_Qry	+=	"AND 	E5_FSIDTRA 		= '' "			+ENTER
				c_Qry	+=	"AND 	E5_FILIAL		= '"+c_Fil+"' "	+ENTER
				c_Qry	+=  "AND 	E5_NATUREZ 		= '"+c_Nat+"' "	+ENTER
				c_Qry	+=  "AND 	E5_BANCO 		= '"+c_Ban+"' "	+ENTER
				c_Qry	+=  "AND 	E5_AGENCIA 		= '"+c_Age+"' "	+ENTER
				c_Qry	+=  "AND 	E5_CONTA		= '"+c_Con+"' "	+ENTER
				c_Qry	+=  "AND 	E5_DATA 		= '"+d_Dat+"' "	+ENTER
				c_Qry	+=  "AND 	E5_DOCUMEN		= '"+c_Doc+"' "	+ENTER
				c_Qry	+=	"AND 	E5_RECPAG 		= 'R' "			+ENTER
				c_Qry	+=  "AND 	E5_TIPODOC 		= 'TR' "		+ENTER
				c_Qry	+=  "AND 	E5_MOEDA 		= 'TB' "		+ENTER
				c_Qry	+=  "ORDER BY R_E_C_N_O_ DESC "				+ENTER
			
				TCQUERY c_Qry ALIAS QRYTR NEW
				If !(QRYTR->(Eof()))					
					//Grava o ID da transferencia
					DbSelectArea("SE5")
					DbGoTo(QRYTR->R_E_C_N_O_)
					Reclock("SE5",.F.)
					SE5->E5_FSIDTRA 	:= Alltrim(o_TransBancaria:XIDTRANSRM) //id da transferencia do RM
					MsUnlock()
				EndIf
				DbSelectArea("QRYTR")
				QRYTR->(DbCloseArea())
				//Fim do ITEM 11
				::o_Retorno:l_Status	:= .T.
				::o_Retorno:c_Mensagem	:= "Transferencia bancaria incluida com sucesso na filial "+o_Empresa:c_Filial+". Id da transferencia: " + Alltrim(o_TransBancaria:XIDTRANSRM)
				Conout("FFIEBW01 - mtdTransBancaria: Transferencia bancaria incluida com sucesso na filial "+o_Empresa:c_Filial+". Id da transferencia: " + Alltrim(o_TransBancaria:XIDTRANSRM)+".")
			EndIf
		End Transaction
		//Se deu erro no Execauto
		If lMsErroAuto
			//Regra do fonte SIESBA01 da FIEB
			If (__lSX8)
				RollBackSX8()
			EndIf

			// Tratamento da Mensagem de erro do MSExecAuto
			aLogErr  := GetAutoGRLog()
			aLogErr2 := f_TrataErro(aLogErr)
			_cMotivo := ""

			For i := 1 to Len(aLogErr2)
				_cMotivo += aLogErr2[i]
			Next

			//Exclusivo para a versao 12
			If (GetVersao(.F.) == "12")
				_cMotivo:=  NoAcentoESB(_cMotivo)
				SetSoapFault('Erro',_cMotivo)
			EndIf

			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= NoAcentoESB(_cMotivo)
			Conout("FFIEBW01 - mtdTransBancaria: "+NoAcentoESB(_cMotivo))
		EndIf
	EndIf
	//RpcClearEnv() //Limpa o ambiente, liberando a licenca e fechando as conexoes

RETURN(.T.)
/*/{Protheus.doc} mtdEstoTrBancaria
metodo do estorno da movimentacao bancaria
@author Totvs-BA
@since 31/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSMETHOD mtdEstoTrBancaria WSRECEIVE o_Seguranca, o_Empresa, o_EstoTrBancaria WSSEND o_Retorno WSSERVICE FFIEBW01

	Local aVetor		:= {}
	Local i
	PRIVATE lMsErroAuto := .F.

	::o_Retorno	:= WSCLASSNEW("strRetorno")

	If !(f_VldFilEmp(o_Empresa:c_Empresa,o_Empresa:c_Filial))
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Codigo de Empresa/Filial nao existe."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdEstoTrBancaria: Codigo de Empresa/Filial nao existe.")
		Return(.T.)
	EndIf

	//Loga na filial solicitada
	RpcSetType(3)
	RpcSetEnv(o_Empresa:c_Empresa,o_Empresa:c_Filial, "integracao", "fieb123")

	//Posiciona na empresa e filial passada
	dbSelectArea("SM0")
	dbSeek(o_Empresa:c_Empresa+o_Empresa:c_Filial)

	cFilAnt:= o_Empresa:c_Filial

	c_UserWS	:= Upper(ALLTRIM(SUPERGETMV("FS_FIUSRWS",,"totvs_fieb")))
	c_PswWS		:= Upper(ALLTRIM(SUPERGETMV("FS_FIPSWWS",,"totvs@123")))

	//Validando o usuario e senha
	If ( Upper(o_Seguranca:c_Usuario) <> Upper(c_UserWS) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdEstoTrBancaria: Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido.")
		Return(.T.)
	ElseIf ( Upper(o_Seguranca:c_Senha) <> Upper(c_PswWS) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdEstoTrBancaria: Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida.")
		Return(.T.)
	Else
		If Empty(o_EstoTrBancaria:AUTBANCO) .Or. Empty(o_EstoTrBancaria:AUTAGENCIA) .Or. Empty(o_EstoTrBancaria:AUTCONTA)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Banco/Agencia/Conta de origem nao informados."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdEstoTrBancaria: Banco/Agencia/Conta de origem nao informados.")
			Return(.T.)
		EndIf
		c_Ban:= Padr(o_EstoTrBancaria:AUTBANCO,TamSX3("E5_BANCO")[1])
		c_Age:= Padr(o_EstoTrBancaria:AUTAGENCIA,TamSX3("E5_AGENCIA")[1])
		c_Con:= Padr(o_EstoTrBancaria:AUTCONTA,TamSX3("E5_CONTA")[1])
		DBSELECTAREA("SA6")
		DBSETORDER(1)
		If !DBSEEK(xFilial("SA6")+c_Ban+c_Age+c_Con)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "O banco/agencia/conta de origem informado nao existe no cadastro de bancos: "+c_Ban+"/"+c_Age+"/"+c_Con
			Conout("FFIEBW01 - mtdEstoTrBancaria: O banco/agencia/conta de origem informado nao existe no cadastro de bancos: "+c_Ban+"/"+c_Age+"/"+c_Con)
			Return(.T.)
		EndIf
		If Empty(o_EstoTrBancaria:AUTNRODOC)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe o documento."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdEstoTrBancaria: Informe o documento.")
			Return(.T.)
		EndIf
		d_TesteData	:=	StoD(o_EstoTrBancaria:AUTDTMOV)
		If valtype(d_TesteData) == "D"
			If Empty(d_TesteData)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe Data do movimento no formato [AAAAMMDD]."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdEstoTrBancaria: Informe Data do movimento no formato [AAAAMMDD].")
				Return(.T.)
			EndIf
		Else
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe Data do movimento no formato [AAAAMMDD]."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdEstoTrBancaria: Informe Data do movimento no formato [AAAAMMDD].")
			Return(.T.)
		EndIf

		d_TesteData	:=	StoD(o_EstoTrBancaria:DATAESTORNO)
		If valtype(d_TesteData) == "D"
			If Empty(d_TesteData)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe Data de estorno no formato [AAAAMMDD]."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdEstoTrBancaria: Informe Data do estorno no formato [AAAAMMDD].")
				Return(.T.)
			EndIf
		Else
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe Data do estorno no formato [AAAAMMDD]."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdEstoTrBancaria: Informe Data do estorno no formato [AAAAMMDD].")
			Return(.T.)
		EndIf

		//Valida se o periodo esta bloqueado.
		c_Err:= ""
		d_TesteData	:=	StoD(o_EstoTrBancaria:DATAESTORNO)
		If !( f_VldDtMov( "FIN", d_TesteData, @c_Err, "" ) )
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= c_Err
			Conout("FFIEBW01 - mtdEstoTrBancaria: "+c_Err)
			Return(.T.)
		EndIf

		aVetor := { {"AUTNRODOC" 	,Alltrim(o_EstoTrBancaria:AUTNRODOC),Nil},;
					{"AUTDTMOV" 	,Stod(o_EstoTrBancaria:AUTDTMOV)	,Nil},;
					{"AUTBANCO" 	,Alltrim(o_EstoTrBancaria:AUTBANCO)	,Nil},;
					{"AUTAGENCIA" 	,Alltrim(o_EstoTrBancaria:AUTAGENCIA),Nil},;
					{"AUTCONTA" 	,Alltrim(o_EstoTrBancaria:AUTCONTA)	,Nil}}

		lMsErroAuto		:= .F.
		lMsHelpAuto		:= .T.
		lAutoErrNoFile	:= .T.

		Begin Transaction

			DDATABASE:= Stod(o_EstoTrBancaria:DATAESTORNO) //Grava o estorno com a data passada.

			MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aVetor,8)

			If lMsErroAuto
				DisarmTransaction()
				Break
			Else
				::o_Retorno:l_Status	:= .T.
				::o_Retorno:c_Mensagem	:= "Cancelamento da transferencia bancaria realizada com sucesso na filial "+o_Empresa:c_Filial+"."
				Conout("FFIEBW01 - mtdEstoTrBancaria: Cancelamento da transferencia bancaria realizada com sucesso na filial "+o_Empresa:c_Filial+".")
			EndIf
		End Transaction
		//Se deu erro no Execauto
		If lMsErroAuto
			//Regra do fonte SIESBA01 da FIEB
			If (__lSX8)
				RollBackSX8()
			EndIf

			// Tratamento da Mensagem de erro do MSExecAuto
			aLogErr  := GetAutoGRLog()
			aLogErr2 := f_TrataErro(aLogErr)
			_cMotivo := ""

			For i := 1 to Len(aLogErr2)
				_cMotivo += aLogErr2[i]
			Next

			//Exclusivo para a versao 12
			If (GetVersao(.F.) == "12")
				_cMotivo:=  NoAcentoESB(_cMotivo)
				SetSoapFault('Erro',_cMotivo)
			EndIf

			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= NoAcentoESB(_cMotivo)
			Conout("FFIEBW01 - mtdEstoTrBancaria: "+NoAcentoESB(_cMotivo))
		EndIf
	EndIf
	//RpcClearEnv() //Limpa o ambiente, liberando a licenca e fechando as conexoes

RETURN(.T.)
/*/{Protheus.doc} mtdLiquidacao
metodo que faz a liquidacao
@author Totvs-BA
@since 01/12/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSMETHOD mtdLiquidacao WSRECEIVE o_Seguranca, o_Empresa, o_TitOrigem, o_TitDestino, Operacao, NumLiq WSSEND o_Retorno WSSERVICE FFIEBW01

	Local a_Itens		:= {}
	//Local a_TitOri		:= {}
	//Local a_TitDes		:= {}
	//Local a_Cab			:= {}
	//Local aParcelas		:= {}
	//Local n_Opc			:= 0
	//Local p,k,nZ		:= 0
	Local n_Valor 		:= 0
	//Local n_QtdTitulos	:= 0
	//Local c_Filtro		:= ""
	Local n_Operacao	:= Val(::Operacao)
	Local l_Erro		:= .F.
	Local i,n,p,c
	Local nOpbaixa		:= 0
	Local a_MotsBx		:= {}
	Local n_PosBx		:= 0
	Local d_DataBk		:= DDATABASE
	Local c_xNumRM		:= ""
	Local l_Encont		:= .F.
	Local l_TemBxRm		:= .F.
	Local c_ErrMsg		:= ""
	//Local c_SeqBai		:= ""
	//Local n_Contseq		:= 1
	//Local l_AcheiSeq	:= .T.
	PRIVATE lMsErroAuto 	:= .F.
	Private lNoMbrowse		:= .F. //Variavel logica que informa se deve ou nao ser apresentado o Browse da rotina baixas a receber.

	::o_Retorno	:= WSCLASSNEW("strRetorno")

	If !(f_VldFilEmp(o_Empresa:c_Empresa,o_Empresa:c_Filial))
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Codigo de Empresa/Filial nao existe."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdLiquidacao: Codigo de Empresa/Filial nao existe.")
		Return(.T.)
	EndIf

	//Loga na filial solicitada
	RpcSetType(3)
	RpcSetEnv(o_Empresa:c_Empresa,o_Empresa:c_Filial, "integracao", "fieb123")

	//Posiciona na empresa e filial passada
	dbSelectArea("SM0")
	dbSeek(o_Empresa:c_Empresa+o_Empresa:c_Filial)

	cFilAnt:= o_Empresa:c_Filial

	c_UserWS	:= Upper(ALLTRIM(SUPERGETMV("FS_FIUSRWS",,"totvs_fieb")))
	c_PswWS		:= Upper(ALLTRIM(SUPERGETMV("FS_FIPSWWS",,"totvs@123")))

	//Validando o usuario e senha
	If ( Upper(o_Seguranca:c_Usuario) <> Upper(c_UserWS) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdLiquidacao: Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido.")
		Return(.T.)
	ElseIf ( Upper(o_Seguranca:c_Senha) <> Upper(c_PswWS) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdLiquidacao: Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida.")
		Return(.T.)
	EndIf
	If (n_Operacao <> 1) .And. (n_Operacao <> 2)
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Valor passado no parametro Operacao ("+cValToChar(n_Operacao)+") invalido. Informar (1=Liquidar; 2=Cancelar)."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdLiquidacao: Valor passado no parametro Operacao ("+cValToChar(n_Operacao)+") invalido. Informar (1=Liquidar; 2=Cancelar).")
		Return(.T.)
	EndIf
	If Empty(::NumLiq)
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Informe o numero da liquidacao"
		Conout("FFIEBW01 - mtdLiquidacao: Informe o numero da liquidacao")
		Return(.T.)
	EndIf
	If (n_Operacao == 1) //Liquidacao
		//Valida os titulos de origem
		For p:= 1 To Len(o_TitOrigem:TITULOS)
			If Empty(o_TitOrigem:TITULOS[p]:E1_FILIAL)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe a filial do titulo de origem."
				Conout("FFIEBW01 - mtdLiquidacao: Informe a filial do titulo de origem.")
				Return(.T.)
			EndIf

			//Valida a filial de origem
			If !(f_VldFilEmp(o_Empresa:c_Empresa,Alltrim(o_TitOrigem:TITULOS[p]:E1_FILIAL)))
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem		:= "Filial "+Alltrim(o_TitOrigem:TITULOS[p]:E1_FILIAL)+" de origem nao foi encontrada."
				Conout("FFIEBW01 - mtdLiquidacao: Filial "+Alltrim(o_TitOrigem:TITULOS[p]:E1_FILIAL)+" de origem nao foi encontrada.")
				Return(.T.)
			EndIf

			//Posiciona na empresa e filial de origem
			dbSelectArea("SM0")
			dbSeek(o_Empresa:c_Empresa+Alltrim(o_TitOrigem:TITULOS[p]:E1_FILIAL))
			cFilAnt:= Alltrim(o_TitOrigem:TITULOS[p]:E1_FILIAL)

			If Empty(o_TitOrigem:TITULOS[p]:CGC)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe o CGC do cliente."
				Conout("FFIEBW01 - mtdLiquidacao: Informe o CGC do cliente.")
				Return(.T.)
			EndIf
			DBSELECTAREA("SA1")
			DBSETORDER(3)
			If !(DBSEEK(XFILIAL("SA1")+Alltrim(o_TitOrigem:TITULOS[p]:CGC)))
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "CNPJ/CPF "+Alltrim(o_TitOrigem:TITULOS[p]:CGC)+" nao encontrado na base de dados do protheus."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: CNPJ/CPF "+Alltrim(o_TitOrigem:TITULOS[p]:CGC)+" nao encontrado na base de dados do protheus.")
				Return(.T.)
			Else
				c_Cliente	:= SA1->A1_COD
				c_Loja		:= SA1->A1_LOJA
			EndIf

			c_Pre:= PADR(Alltrim(o_TitOrigem:TITULOS[p]:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1])
			c_Num:= PADR(Alltrim(o_TitOrigem:TITULOS[p]:E1_NUM), TAMSX3("E1_NUM")[1])
			c_Par:= PADR(Alltrim(o_TitOrigem:TITULOS[p]:E1_PARCELA), TAMSX3("E1_PARCELA")[1])
			c_Tip:= PADR(Alltrim(o_TitOrigem:TITULOS[p]:E1_TIPO), TAMSX3("E1_TIPO")[1])

			DBSELECTAREA("SE1")
			DBSETORDER(1)
			If !(DBSEEK(XFILIAL("SE1")+c_Pre+c_Num+c_Par+c_Tip+c_Cliente+c_Loja))
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Titulo nao encontrado com os parametros passados. "+XFILIAL("SE1")+c_Pre+c_Num+c_Par+c_Tip+c_Cliente+c_Loja+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: Titulo nao encontrado com os parametros passados. "+XFILIAL("SE1")+c_Pre+c_Num+c_Par+c_Tip+c_Cliente+c_Loja)
				Return(.T.)
			//Quando vem do RM valida se ja foi baixado no trecho logo abaixo, fora deste FOR.
			ElseIf (SE1->E1_SALDO = 0) .And. Empty(o_TitOrigem:TITULOS[p]:XIDBAIXARM)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "O titulo informado: "+XFILIAL("SE1")+"-"+c_Pre+"-"+c_Num+"-"+c_Par+"-"+c_Tip+"-"+c_Cliente+"-"+c_Loja+" ja esta totalmente baixado."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: O titulo informado: "+XFILIAL("SE1")+"-"+c_Pre+"-"+c_Num+"-"+c_Par+"-"+c_Tip+"-"+c_Cliente+"-"+c_Loja+" ja esta totalmente baixado.")
				Return(.T.)
			Else
				If (o_TitOrigem:TITULOS[p]:AUTVALREC <>  SE1->E1_SALDO) .And. Empty(o_TitOrigem:TITULOS[p]:XIDBAIXARM)
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "O valor informado no titulo : "+XFILIAL("SE1")+"-"+c_Pre+"-"+c_Num+"-"+c_Par+"-"+c_Tip+"-"+c_Cliente+"-"+c_Loja+" ja esta totalmente baixado."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdLiquidacao: O titulo informado: "+XFILIAL("SE1")+"-"+c_Pre+"-"+c_Num+"-"+c_Par+"-"+c_Tip+"-"+c_Cliente+"-"+c_Loja+" ja esta totalmente baixado.")
					Return(.T.)
				EndIf
			EndIf

			If Empty(o_TitOrigem:TITULOS[p]:AUTBANCO) .Or. Empty(o_TitOrigem:TITULOS[p]:AUTAGENCIA) .Or. Empty(o_TitOrigem:TITULOS[p]:AUTCONTA)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Banco/Agencia/Conta nao informados. "+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: Banco/Agencia/Conta nao informados. ")
				Return(.T.)
			EndIf
			DDATABASE:= Stod(o_TitOrigem:TITULOS[p]:AUTDTBAIXA)
			If	(STOD(o_TitOrigem:TITULOS[p]:AUTDTBAIXA) > dDatabase)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "A data da baixa e maior que a data atual. Baixa nao permitida. AUTDTBAIXA: "+o_TitOrigem:TITULOS[p]:AUTDTBAIXA+". dDatabase: "+ dtos(dDatabase)+"."
				Conout("FFIEBW01 - mtdLiquidacao: A data da baixa e maior que a data atual. Baixa nao permitida. AUTDTBAIXA: "+o_TitOrigem:TITULOS[p]:AUTDTBAIXA+". dDatabase: "+ dtos(dDatabase)+".")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			Endif
			/*If	(STOD(o_TitOrigem:TITULOS[p]:AUTDTCREDITO) > dDatabase)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "A data de credito e maior que a data atual. Baixa nao permitida."
				Conout("FFIEBW01 - mtdLiquidacao: A data de credito e maior que a data atual. Baixa nao permitida.")
				Return(.T.)
			Endif*/
			If Empty(o_TitOrigem:TITULOS[p]:AUTMOTBX)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Motivo da baixa nao foi informado."
				Conout("FFIEBW01 - mtdLiquidacao: Motivo da baixa nao foi informado.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			Else
				//Verifica se o motivo de baixa existe
				a_MotsBx:= ReadMotBx() //Carrega os motivos de baixas - Funcao padrao. Fonte FinxBx - fA070Grv()
				n_PosBx := Ascan(a_MotsBx, {|x| AllTrim(SubStr(x,1,3)) == AllTrim(Upper(o_TitOrigem:TITULOS[p]:AUTMOTBX))})
				If n_PosBx > 0
					//Existe o motivo de baixa. Nao faz nada
				Else
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Motivo de baixa nao encontrado: "+Alltrim(o_TitOrigem:TITULOS[p]:AUTMOTBX)+". Verficar o arquivo sigaadv.mot"
					Conout("FFIEBW01 - mtdLiquidacao: Motivo de baixa nao encontrado: "+Alltrim(o_TitOrigem:TITULOS[p]:AUTMOTBX)+". Verficar o arquivo sigaadv.mot")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				EndIf
			EndIf
			If (o_TitOrigem:TITULOS[p]:AUTVALREC < 0) .Or. (o_TitOrigem:TITULOS[p]:AUTVALREC = 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Valor recebido informado nao eh valido."
				Conout("FFIEBW01 - mtdLiquidacao: Valor recebido informado nao eh valido.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
			If (o_TitOrigem:TITULOS[p]:AUTMULTA < 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Valor de multa informado nao eh valido."
				Conout("FFIEBW01 - mtdLiquidacao: Valor de multa informado nao eh valido.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
			If (o_TitOrigem:TITULOS[p]:AUTJUROS < 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Valor de juros informado nao eh valido."
				Conout("FFIEBW01 - mtdLiquidacao: Valor de juros informado nao eh valido.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
			If (o_TitOrigem:TITULOS[p]:AUTDESCONT < 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Valor de desconto informado nao eh valido."
				Conout("FFIEBW01 - mtdLiquidacao: Valor de desconto informado nao eh valido.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
			If (o_TitOrigem:TITULOS[p]:AUTACRESC < 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Valor de acrescimo informado nao eh valido."
				Conout("FFIEBW01 - mtdLiquidacao: Valor de desconto informado nao eh valido.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
			If (o_TitOrigem:TITULOS[p]:AUTDECRESC < 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Valor de descrescimo informado nao eh valido."
				Conout("FFIEBW01 - mtdLiquidacao: Valor de desconto informado nao eh valido.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf

			c_Ban:= Padr(o_TitOrigem:TITULOS[p]:AUTBANCO,TamSX3("E1_PORTADO")[1])
			c_Age:= Padr(o_TitOrigem:TITULOS[p]:AUTAGENCIA,TamSX3("E5_AGENCIA")[1])
			c_Con:= Padr(o_TitOrigem:TITULOS[p]:AUTCONTA,TamSX3("E5_CONTA")[1])

			DBSELECTAREA("SA6")
			DBSETORDER(1)
			If !DBSEEK(xFilial("SA6")+c_Ban+c_Age+c_Con)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "O banco/agencia/conta informado nao existe no cadastro de bancos: "+c_Ban+"/"+c_Age+"/"+c_Con
				Conout("FFIEBW01 - mtdLiquidacao: O banco/agencia/conta informado nao existe no cadastro de bancos: "+c_Ban+"/"+c_Age+"/"+c_Con)
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf

			d_TesteData	:=	StoD(o_TitOrigem:TITULOS[p]:AUTDTBAIXA)
			If valtype(d_TesteData) == "D"
				If Empty(d_TesteData)
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Informe Data da baixa no formato [AAAAMMDD]."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdLiquidacao: Informe Data de emissao no formato [AAAAMMDD].")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				EndIf
			Else
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe Data da baixa no formato [AAAAMMDD]."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: Informe Data de emissao no formato [AAAAMMDD].")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
			d_TesteData	:=	StoD(o_TitOrigem:TITULOS[p]:AUTDTCREDITO)
			If valtype(d_TesteData) == "D"
				If Empty(d_TesteData)
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Informe Data do credito no formato [AAAAMMDD]."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdLiquidacao: Informe Data do credito no formato [AAAAMMDD].")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				EndIf
			Else
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe Data do credito no formato [AAAAMMDD]."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: Informe Data do credito no formato [AAAAMMDD].")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
			//Valida se o periodo esta bloqueado.
			c_Err:= ""
			d_TesteData	:=	StoD(o_TitOrigem:TITULOS[p]:AUTDTBAIXA)
			If !( f_VldDtMov( "FIN", d_TesteData, @c_Err, "R" ) )
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= c_Err
				Conout("FFIEBW01 - mtdLiquidacao: "+c_Err)
				Return(.T.)
			EndIf
		Next

		//INICIO  - Validacao adicional do id da baixa.
		l_TemBxRm:= .F.
		For p:= 1 To Len(o_TitOrigem:TITULOS)
			If !Empty(o_TitOrigem:TITULOS[p]:XIDBAIXARM)
				l_TemBxRm:= .T.
				Exit
			EndIf
		Next
		If (l_TemBxRm)
			n_RegExist	:=	0
			n_RegNExist	:=	0
			For p:= 1 To Len(o_TitOrigem:TITULOS)
				DBSELECTAREA("SA1")
				DBSETORDER(3)
				DBSEEK(XFILIAL("SA1")+Alltrim(o_TitOrigem:TITULOS[p]:CGC))
				c_CliBx		:= SA1->A1_COD
				c_LojBx		:= SA1->A1_LOJA
				c_PreBx		:= PADR(Alltrim(o_TitOrigem:TITULOS[p]:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1])
				c_NumBx		:= PADR(Alltrim(o_TitOrigem:TITULOS[p]:E1_NUM), TAMSX3("E1_NUM")[1])
				c_ParBx		:= PADR(Alltrim(o_TitOrigem:TITULOS[p]:E1_PARCELA), TAMSX3("E1_PARCELA")[1])
				c_TipBx		:= PADR(Alltrim(o_TitOrigem:TITULOS[p]:E1_TIPO), TAMSX3("E1_TIPO")[1])
				l_IdBxSe5 	:= f_IDSE5(Alltrim(o_TitOrigem:TITULOS[p]:E1_FILIAL), Alltrim(o_TitOrigem:TITULOS[p]:XIDBAIXARM), c_PreBx, c_NumBx, c_ParBx, c_TipBx, c_CliBx, c_LojBx, .F., "") //incrementdo para validar existencia do id da baixa na se5
				If l_IdBxSe5
					n_RegExist++
				Else
					n_RegNExist++
				Endif
			Next

			If n_RegExist == Len(o_TitOrigem:TITULOS)
				::o_Retorno:l_Status	:= .T.
				::o_Retorno:c_Mensagem	:= "###Liquidacao ("+Alltrim(::NumLiq)+") ja processada com sucesso."
				Conout("FFIEBW01 - mtdLiquidacao: ###Liquidacao ("+Alltrim(::NumLiq)+") ja processada com sucesso.")
				Return(.T.)
			ElseIf n_RegNExist > 0 .And. n_RegNExist < Len(o_TitOrigem:TITULOS)
				::o_Retorno:l_Status	:= 	.F.
				::o_Retorno:c_Mensagem	:= 	"###Liquidacao ("+Alltrim(::NumLiq)+") inconsistente na base, o mesmo deve ser excluido no protheus e reprocessado."
				Conout("FFIEBW01 - mtdLiquidacao: ###Liquidacao ("+Alltrim(::NumLiq)+") inconsistente na base, o mesmo deve ser excluido no protheus e reprocessado.")
				Return(.T.)
			Endif
		EndIf
		//FIM  - Validacao adicional do id da baixa.

		//Posiciona na empresa e filial de destino
		dbSelectArea("SM0")
		dbSeek(o_Empresa:c_Empresa+o_Empresa:c_Filial)
		cFilAnt:= o_Empresa:c_Filial

		//Valida os titulos de Destino
		For p:= 1 To Len(o_TitDestino:TITULOS)
			If Empty(o_TitDestino:TITULOS[p]:E1_NUM)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe o numero do titulo."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: Informe o numero do titulo.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			ElseIf Empty(o_TitDestino:TITULOS[p]:E1_TIPO)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe o tipo do titulo."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: Informe o tipo do titulo.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			ElseIf Empty(o_TitDestino:TITULOS[p]:E1_NATUREZ)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe a natureza do titulo."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: Informe a natureza do titulo.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			ElseIf Empty(o_TitDestino:TITULOS[p]:CGC)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe o CNPJ/CPF do cliente do titulo."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: Informe o CNPJ/CPF do cliente do titulo.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			ElseIf Empty(o_TitDestino:TITULOS[p]:E1_EMISSAO)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe a data de emissao titulo."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: Informe a data de emissao do titulo.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			ElseIf Empty(o_TitDestino:TITULOS[p]:E1_VENCTO)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe a data de vencimento titulo."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: Informe a data de vencimento do titulo.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
			DBSELECTAREA("SA1")
			DBSETORDER(3)
			If !(DBSEEK(XFILIAL("SA1")+Alltrim(o_TitDestino:TITULOS[p]:CGC)))
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "CNPJ/CPF "+Alltrim(o_TitDestino:TITULOS[p]:CGC)+" nao encontrado na base de dados do protheus."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: CNPJ/CPF "+Alltrim(o_TitDestino:TITULOS[p]:CGC)+" nao encontrado na base de dados do protheus.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
			//Valida o tipo
			dbSelectArea("SX5")
			dbSetOrder(1)
			If !(dbSeek(xfilial("SX5")+"05"+Alltrim(o_TitDestino:TITULOS[p]:E1_TIPO)))
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Tipo "+Alltrim(o_TitDestino:TITULOS[p]:E1_TIPO)+" nao encontrado na base de dados do protheus."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: Tipo "+Alltrim(o_TitDestino:TITULOS[p]:E1_TIPO)+" nao encontrado na base de dados do protheus.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf

			c_Pre:= PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1])
			c_Num:= PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_NUM), TAMSX3("E1_NUM")[1])
			c_Par:= PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_PARCELA), TAMSX3("E1_PARCELA")[1])
			c_Tip:= PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_TIPO), TAMSX3("E1_TIPO")[1])

			DBSELECTAREA("SE1")
			DBSETORDER(1)
			If (DBSEEK(XFILIAL("SE1")+c_Pre+c_Num+c_Par+c_Tip+c_Cliente+c_Loja))
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Chave do titulo de destino ja existe ("+c_Pre+c_Num+c_Par+c_Tip+c_Cliente+c_Loja+")."
				Conout("FFIEBW01 - mtdLiquidacao: Chave("+c_Pre+c_Num+c_Par+c_Tip+c_Cliente+c_Loja+") do titulo de destino ja existe.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf

			//Valida a natureza
			dbSelectArea("SED")
			dbSetOrder(1)
			If !(dbSeek(xfilial("SED")+Alltrim(o_TitDestino:TITULOS[p]:E1_NATUREZ)))
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Natureza "+Alltrim(o_TitDestino:TITULOS[p]:E1_NATUREZ)+" nao encontrada na base de dados do protheus."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: Natureza "+Alltrim(o_TitDestino:TITULOS[p]:E1_NATUREZ)+" nao encontrada na base de dados do protheus.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf

			If !Empty(o_TitDestino:TITULOS[p]:E1_CONTA)
				//Validando a conta contabil
				DBSELECTAREA("CT1")
				DBSETORDER(1)
				IF !DBSEEK(xFilial("CT1")+Alltrim(o_TitDestino:TITULOS[p]:E1_CONTA))
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CONTA)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+"."
					Conout("FFIEBW01 - mtdLiquidacao: Codigo da conta contabil ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CONTA)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+".")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				ElseIf CT1->CT1_CLASSE == "1"
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CONTA)+") nao pode ser sintetica."
					Conout("FFIEBW01 - mtdLiquidacao: Codigo da conta contabil ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CONTA)+") nao pode ser sintetica.")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				ElseIf CT1->CT1_BLOQ == "1"
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CONTA)+") esta bloqueada para uso."
					Conout("FFIEBW01 - mtdLiquidacao: Codigo da conta contabil ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CONTA)+")  esta bloqueada para uso.")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				EndIf
			EndIf

			If !Empty(o_TitDestino:TITULOS[p]:E1_CCC)
				//Validando o centro de custo
				DbSelectArea("CTT")
				CTT->(dbSetOrder(1))
				If !(CTT->(dbSeek(xFilial("CTT")+Alltrim(o_TitDestino:TITULOS[p]:E1_CCC))))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Centro de Custo informado para o campo E1_CCC invalido ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CCC)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdLiquidacao: Centro de Custo informado para o campo E1_CCC invalido ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CCC)+").")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				Elseif CTT->CTT_CLASSE == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Centro de Custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CCC)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdLiquidacao: Centro de Custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CCC)+").")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				Elseif CTT->CTT_BLOQ == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Centro de Custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CCC)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdLiquidacao: Centro de Custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CCC)+").")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				Endif
			EndIf

			//Validando o item contabil
			If !Empty(o_TitDestino:TITULOS[p]:E1_ITEMC)
				DbSelectArea("CTD")
				CTD->(dbSetOrder(1))
				If !(CTD->(dbSeek(xFilial("CTD")+Alltrim(o_TitDestino:TITULOS[p]:E1_ITEMC))))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil informado para o campo E1_ITEMC invalido ("+Alltrim(o_TitDestino:TITULOS[p]:E1_ITEMC)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdLiquidacao: Item contabil informado para o campo E1_ITEMC invalido ("+Alltrim(o_TitDestino:TITULOS[p]:E1_ITEMC)+").")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				Elseif CTD->CTD_CLASSE == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_TitDestino:TITULOS[p]:E1_ITEMC)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdLiquidacao: Item contabil invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_TitDestino:TITULOS[p]:E1_ITEMC)+").")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				Elseif CTD->CTD_BLOQ == "1" .or. (!Empty(CTD->CTD_DTEXSF) .and. CTD->CTD_DTEXSF < dDatabase)
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_TitDestino:TITULOS[p]:E1_ITEMC)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdLiquidacao: Item contabil invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_TitDestino:TITULOS[p]:E1_ITEMC)+").")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				ElseIf (!Empty(CTD->CTD_DTEXIS) .and. dDatabase < CTD->CTD_DTEXIS)
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil ("+Alltrim(o_TitDestino:TITULOS[p]:E1_ITEMC)+") esta com data de inicio de existencia superior a data base."+CHR(13)+CHR(10)
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				Endif
			EndIf

			If !Empty(o_TitDestino:TITULOS[p]:E1_CLVLCR)
				//Validando a classe de valor
				DbSelectArea("CTH")
				CTH->(dbSetOrder(1))
				If !(CTH->(dbSeek(xFilial("CTH")+Alltrim(o_TitDestino:TITULOS[p]:E1_CLVLCR))))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Classe de valor informado para o campo E1_CLVLCR invalido ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CLVLCR)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdLiquidacao: Classe de valor informado para o campo E1_CLVLCR invalido ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CLVLCR)+").")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				Elseif CTH->CTH_CLASSE == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Classe de valor invalido. O Classe de valor nao pode ser sintetico ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CLVLCR)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdLiquidacao: Classe de valor invalido. O Classe de valor nao pode ser sintetico ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CLVLCR)+").")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				Elseif CTH->CTH_BLOQ == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Classe de valor invalido. o Classe de valor esta bloqueado para uso ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CLVLCR)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdLiquidacao: Classe de valor invalido. o Classe de valor esta bloqueado para uso ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CLVLCR)+").")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				Endif
			EndIf

			If (o_TitDestino:TITULOS[p]:E1_MULTA < 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "O valor da multa nao pode ser menor do que zero."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: O valor da multa nao pode ser menor do que zero.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf

			If (o_TitDestino:TITULOS[p]:E1_JUROS < 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "O valor de juros nao pode ser menor do que zero."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: O valor de juros nao pode ser menor do que zero.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf

			If (o_TitDestino:TITULOS[p]:E1_DESCONT < 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "O valor de desconto nao pode ser menor do que zero."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: O valor de desconto nao pode ser menor do que zero.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf

			a_RatNat:= {}
			a_RatCC	:= {}

			//Valida o array do rateio
			If Len(o_TitDestino:TITULOS[p]:NATRATEIO) > 0
				If !Empty(o_TitDestino:TITULOS[p]:NATRATEIO[1]:EV_NATUREZ) .And. (o_TitDestino:TITULOS[p]:NATRATEIO[1]:EV_VALOR > 0)

					o_ObjRateio:= o_TitDestino:TITULOS[p]:NATRATEIO

					//Valida se tem rateio por naturezas informado
					For n:= 1 To Len(o_ObjRateio)
						If Empty(o_ObjRateio[n]:EV_NATUREZ) .Or. Empty(o_ObjRateio[n]:EV_PERC) .Or. Empty(o_ObjRateio[n]:EV_VALOR)
							::o_Retorno:l_Status	:= .F.
							::o_Retorno:c_Mensagem	:= "Algum campo do rateio de multiplas naturezas nao foi preenchido."+CHR(13)+CHR(10)
							Conout("FFIEBW01 - mtdLiquidacao: Algum campo do rateio de multiplas naturezas nao foi preenchido.")
							//Volta a database
							DDATABASE:= d_DataBk
							Return(.T.)
						EndIf
					Next

					For n:= 1 To Len(o_ObjRateio)
						//Valida a natureza
						dbSelectArea("SED")
						dbSetOrder(1)
						If !(dbSeek(xfilial("SED")+Alltrim(o_ObjRateio[n]:EV_NATUREZ)))
							::o_Retorno:l_Status		:= .F.
							::o_Retorno:c_Mensagem	:= "Natureza do rateio "+Alltrim(o_ObjRateio[n]:EV_NATUREZ)+" nao encontrada na base de dados do protheus."+CHR(13)+CHR(10)
							Conout("FFIEBW01 - mtdLiquidacao: Natureza do rateio "+Alltrim(o_ObjRateio[n]:EV_NATUREZ)+" nao encontrada na base de dados do protheus.")
							//Volta a database
							DDATABASE:= d_DataBk
							Return(.T.)
						EndIf

						//Validacao para nao permitir a inclusao da mesma Natureza em mais de um item.
						If aScan(a_RatNat,Alltrim(o_ObjRateio[n]:EV_NATUREZ)) > 0
							::o_Retorno:l_Status	:= .F.
							::o_Retorno:c_Mensagem	:= "A Natureza "+Alltrim(o_ObjRateio[n]:EV_NATUREZ)+" ja esta cadastrada em outro item da Tabela SEV)."+CHR(13)+CHR(10)
							Conout("FFIEBW01 - mtdLiquidacao: A Natureza "+Alltrim(o_ObjRateio[n]:EV_NATUREZ)+" ja esta cadastrada em outro item da Tabela SEV).")
							//Volta a database
							DDATABASE:= d_DataBk
							Return(.T.)
						Else
							Aadd(a_RatNat,Alltrim(o_ObjRateio[n]:EV_NATUREZ))
				        Endif

				        If (o_ObjRateio[n]:EV_PERC < 0)
							::o_Retorno:l_Status	:= .F.
							::o_Retorno:c_Mensagem	:= "O valor do percentual nao pode ser menor do que zero."+CHR(13)+CHR(10)
							Conout("FFIEBW01 - mtdLiquidacao: O valor do percentual nao pode ser menor do que zero.")
							//Volta a database
							DDATABASE:= d_DataBk
							Return(.T.)
						EndIf

						If (o_ObjRateio[n]:EV_VALOR < 0)
							::o_Retorno:l_Status	:= .F.
							::o_Retorno:c_Mensagem	:= "O valor do rateio por natureza nao pode ser menor do que zero."+CHR(13)+CHR(10)
							Conout("FFIEBW01 - mtdLiquidacao: O valor do rateio por natureza nao pode ser menor do que zero.")
							//Volta a database
							DDATABASE:= d_DataBk
							Return(.T.)
						EndIf

						a_RatCC:= {}
						If Len(o_ObjRateio[n]:CCUSTORATEIO) > 0

							//Valida se tem rateio por CC
							For c:= 1 To Len(o_ObjRateio[n]:CCUSTORATEIO)
								If Empty(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO) .Or. Empty(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_VALOR)
									::o_Retorno:l_Status	:= .F.
									::o_Retorno:c_Mensagem	:= "Algum campo do rateio de multiplos CC nao foi preenchido."+CHR(13)+CHR(10)
									Conout("FFIEBW01 - mtdLiquidacao: Algum campo do rateio de multiplos CC nao foi preenchido.")
									//Volta a database
									DDATABASE:= d_DataBk
									Return(.T.)
								EndIf
							Next

							For c:= 1 To Len(o_ObjRateio[n]:CCUSTORATEIO)

								DbSelectArea("CTT")
								CTT->(dbSetOrder(1))
								If !(CTT->(dbSeek(xFilial("CTT")+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO))))
									::o_Retorno:l_Status	:= .F.
									::o_Retorno:c_Mensagem	:= "Centro de Custo informado para o campo EZ_CCUSTO invalido ("+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO)+")."+CHR(13)+CHR(10)
									Conout("FFIEBW01 - mtdLiquidacao: Centro de Custo informado para o campo EZ_CCUSTO invalido ("+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO)+").")
									//Volta a database
									DDATABASE:= d_DataBk
									Return(.T.)
								Elseif CTT->CTT_CLASSE == "1"
									::o_Retorno:l_Status	:= .F.
									::o_Retorno:c_Mensagem	:= "Centro de Custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO)+")."+CHR(13)+CHR(10)
									Conout("FFIEBW01 - mtdLiquidacao: Centro de Custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO)+").")
									//Volta a database
									DDATABASE:= d_DataBk
									Return(.T.)
								Elseif CTT->CTT_BLOQ == "1"
									::o_Retorno:l_Status	:= .F.
									::o_Retorno:c_Mensagem	:= "Centro de Custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO)+")."+CHR(13)+CHR(10)
									Conout("FFIEBW01 - mtdLiquidacao: Centro de Custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO)+").")
									//Volta a database
									DDATABASE:= d_DataBk
									Return(.T.)
								Endif

								//Validacao para nao permitir a inclusao da mesma CC em mais de um item.
								If aScan(a_RatCC, Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO)) > 0
									::o_Retorno:l_Status		:= .F.
									::o_Retorno:c_Mensagem	:= "O CC "+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO)+" ja esta cadastrado em outro item da Tabela SEZ)."+CHR(13)+CHR(10)
									Conout("FFIEBW01 - mtdLiquidacao: O CC "+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO)+" ja esta cadastrado em outro item da Tabela SEZ).")
									//Volta a database
									DDATABASE:= d_DataBk
									Return(.T.)
								Else
									Aadd(a_RatCC, Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO))
				                Endif

				                If (o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_VALOR < 0)
									::o_Retorno:l_Status	:= .F.
									::o_Retorno:c_Mensagem	:= "O valor do percentual nao pode ser menor do que zero."+CHR(13)+CHR(10)
									Conout("FFIEBW01 - mtdLiquidacao: O valor do percentual nao pode ser menor do que zero.")
									//Volta a database
									DDATABASE:= d_DataBk
									Return(.T.)
								EndIf

								If (o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_PERC < 0)
									::o_Retorno:l_Status	:= .F.
									::o_Retorno:c_Mensagem	:= "O valor do rateio por natureza nao pode ser menor do que zero."+CHR(13)+CHR(10)
									Conout("FFIEBW01 - mtdLiquidacao: O valor do rateio por natureza nao pode ser menor do que zero.")
									//Volta a database
									DDATABASE:= d_DataBk
									Return(.T.)
								EndIf

								//Valida se a conta comeca com 32 e o Cr possui o campo CTD_XRTADM = 2=Consumo;3=Corporativo;4=Unid. Compartilhadas 11/02/2019
								c_ErrMsg:= ""
								If !( f_VldCnInvest( Alltrim( o_ObjRateio[n]:EV_NATUREZ ), Alltrim( o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_ITEMCTA ), @c_ErrMsg ) )
									::o_Retorno:l_Status	:= .F.
									::o_Retorno:c_Mensagem	:= c_ErrMsg
									Conout("FFIEBW01 - mtdLiquidacao: "+c_ErrMsg)
									DDATABASE:= d_DataBk
									Return(.T.)
								EndIf
							Next
						EndIf
					Next
				EndIf
			EndIf
			d_TesteData	:=	StoD(o_TitDestino:TITULOS[p]:E1_EMISSAO)
			If valtype(d_TesteData) == "D"
				If Empty(d_TesteData)
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Informe Data de emissao no formato [AAAAMMDD]."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdLiquidacao: Informe Data de emissao no formato [AAAAMMDD].")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				EndIf
			Else
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe Data de emissao no formato [AAAAMMDD]."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: Informe Data de emissao no formato [AAAAMMDD].")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
			//Valida se o periodo esta bloqueado.
			c_Err:= ""
			d_TesteData	:=	StoD(o_TitDestino:TITULOS[p]:E1_EMISSAO)
			If !( f_VldDtMov( "FIN", d_TesteData, @c_Err, "R" ) )
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= c_Err
				Conout("FFIEBW01 - mtdLiquidacao: "+c_Err)
				Return(.T.)
			EndIf
			d_TesteData	:=	StoD(o_TitDestino:TITULOS[p]:E1_VENCTO)
			If valtype(d_TesteData) == "D"
				If Empty(d_TesteData)
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Informe Data de vencimento no formato [AAAAMMDD]."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdLiquidacao: Informe Data de vencimento no formato [AAAAMMDD].")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				EndIf
			Else
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe Data de vencimento no formato [AAAAMMDD]."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: Informe Data de vencimento no formato [AAAAMMDD].")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
		Next

		Begin Transaction
			//Gravacao da baixas
			For p:= 1 To Len(o_TitOrigem:TITULOS)

				//Posiciona na empresa e filial de origem
				dbSelectArea("SM0")
				dbSeek(o_Empresa:c_Empresa+Alltrim(o_TitOrigem:TITULOS[p]:E1_FILIAL))
				cFilAnt:= Alltrim(o_TitOrigem:TITULOS[p]:E1_FILIAL)

				c_Cli	:= ""
				c_Loj	:= ""

				DBSELECTAREA("SA1")
				DBSETORDER(3)
				DBSEEK(XFILIAL("SA1")+Alltrim(o_TitOrigem:TITULOS[p]:CGC))
				c_Cli	:= SA1->A1_COD
				c_Loj	:= SA1->A1_LOJA

				c_Pre	:= PADR(Alltrim(o_TitOrigem:TITULOS[p]:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1])
				c_Num	:= PADR(Alltrim(o_TitOrigem:TITULOS[p]:E1_NUM), TAMSX3("E1_NUM")[1])
				c_Par	:= PADR(Alltrim(o_TitOrigem:TITULOS[p]:E1_PARCELA), TAMSX3("E1_PARCELA")[1])
				c_Tip	:= PADR(Alltrim(o_TitOrigem:TITULOS[p]:E1_TIPO), TAMSX3("E1_TIPO")[1])
				c_xNumRM:= PADR(Alltrim(o_TitOrigem:TITULOS[p]:E5_XNUMRM), TAMSX3("E5_XNUMRM")[1])

				DBSELECTAREA("SE1")
				DBSETORDER(1)
				DBSEEK(XFILIAL("SE1")+c_Pre+c_Num+c_Par+c_Tip+c_Cli+c_Loj)

				c_Ban	:= Padr(o_TitOrigem:TITULOS[p]:AUTBANCO,TamSX3("E1_PORTADO")[1])
				c_Age	:= Padr(o_TitOrigem:TITULOS[p]:AUTAGENCIA,TamSX3("E5_AGENCIA")[1])
				c_Con	:= Padr(o_TitOrigem:TITULOS[p]:AUTCONTA,TamSX3("E5_CONTA")[1])

				c_MotBx   := Alltrim(o_TitOrigem:TITULOS[p]:AUTMOTBX)
				d_DtBaixa := STOD(o_TitOrigem:TITULOS[p]:AUTDTBAIXA)
				d_DtCred  := STOD(o_TitOrigem:TITULOS[p]:AUTDTCREDITO)
				c_Hist    := PADR(Alltrim(o_TitOrigem:TITULOS[p]:AUTHIST), TAMSX3("E5_HISTOR")[1])
				n_Descont := o_TitOrigem:TITULOS[p]:AUTDESCONT
				n_Multa   := o_TitOrigem:TITULOS[p]:AUTMULTA
				n_Juros   := o_TitOrigem:TITULOS[p]:AUTJUROS
				n_ValRec  := o_TitOrigem:TITULOS[p]:AUTVALREC
				n_Acres   := o_TitOrigem:TITULOS[p]:AUTACRESC
				n_Decres  := o_TitOrigem:TITULOS[p]:AUTDECRESC

				If (n_Multa>0)
					n_ValRec+=n_Multa
				EndIf
				If (n_Juros>0)
					n_ValRec+=n_Juros
				EndIf
				If (n_Descont>0)
					n_ValRec-=n_Descont
				EndIf

				a_Baixa	  := {}
				a_Baixa := {{"E1_PREFIXO"  	,PADR(c_Pre	, TAMSX3("E1_PREFIXO")[1])	,Nil},;
							{"E1_NUM"		,PADR(c_Num	, TAMSX3("E1_NUM")[1])		,Nil},;
							{"E1_PARCELA"	,PADR(c_Par	, TAMSX3("E1_PARCELA")[1])	,Nil},;
							{"E1_TIPO"		,PADR(c_Tip	, TAMSX3("E1_TIPO")[1])		,Nil},;
							{"E1_CLIENTE"	,PADR(c_Cli	, TAMSX3("E1_CLIENTE")[1])	,Nil},;
							{"E1_LOJA"		,PADR(c_Loj	, TAMSX3("E1_LOJA")[1])		,Nil},;
							{"AUTMOTBX"		,PADR(c_MotBx, TAMSX3("E5_MOTBX")[1])	,Nil},;
							{"AUTBANCO"		,c_Ban		,Nil},;
							{"AUTAGENCIA"	,c_Age		,Nil},;
							{"AUTCONTA"		,c_Con		,Nil},;
							{"AUTDTBAIXA"	,d_DtBaixa	,Nil},;
							{"AUTDTCREDITO"	,d_DtCred	,Nil},;
							{"AUTHIST"		,c_Hist		,Nil},;
							{"AUTDESCONT"  	,n_Descont	,Nil,.T.},;
							{"AUTMULTA"  	,n_Multa	,Nil,.T.},;
							{"AUTJUROS"  	,n_Juros	,Nil,.T.},;
							{"AUTACRESC"  	,n_Acres	,Nil,.T.},;
							{"AUTDECRESC"  	,n_Decres	,Nil,.T.},;
							{"AUTVALREC"	,n_ValRec	,Nil}}

				//INCLUI         := .T.
				lMsErroAuto    := .F.
				lMsHelpAuto    := .T.
				lAutoErrNoFile := .T.

				//3 - Baixa de Titulo
				MSExecAuto( {|n,x,y,z| Fina070(n,x,y,z)}, a_Baixa, 3)
				If lMsErroAuto
					l_Erro:= .T.
					Exit
				Else
					c_SeqBai:= SE5->E5_SEQ
					//Grava o numero da liquidacao na baixa
					DBSELECTAREA("SE5")
					DBSETORDER(7)
					If Dbseek(xFilial("SE5")+c_Pre+c_Num+c_Par+c_Tip+c_Cli+c_Loj)
						While !(SE5->(Eof())) .And. (SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA == xFilial("SE5")+c_Pre+c_Num+c_Par+c_Tip+c_Cli+c_Loj)
							If Alltrim(SE5->E5_SEQ) == Alltrim(c_SeqBai)
								If (SE5->E5_SITUACA = ' ') .And. (SE5->E5_RECPAG = 'R') .And. ( (Alltrim(SE5->E5_TIPODOC) = 'VL') .OR. (Alltrim(SE5->E5_TIPODOC) = 'BA') ) .And. (Alltrim(SE5->E5_MOTBX) == Alltrim(c_MotBx))
									Reclock("SE5",.F.)
									SE5->E5_FSIDACO	:= ::NumLiq
									SE5->E5_XNUMRM	:= PADR( c_xNumRM, TAMSX3( "E5_XNUMRM" )[ 1 ] ) //Grava o numero do RM na baixa por renegociacao/liquidacao
									SE5->E5_FSBXRM 	:= Alltrim(o_TitOrigem:TITULOS[p]:XIDBAIXARM) //id da baixa do RM
                                    SE5->E5_LA      := "S"
									MsUnlock()
									
									dbSelectArea("FK1")
								    dbSetOrder(1)
									dbSeek(xFilial("FK1")+SE5->E5_IDORIG)

									If !Eof()
									   Reclock("FK1",.F.)
									   FK1->FK1_LA := "S"
									   MsUnlock()
									EndIf
										
									dbSelectArea("SE5")
								EndIf
							EndIf

							//Inserido para forcar gravacao do LA para titulos do Tipo RM
							If Alltrim(SE5->E5_PREFIXO) == "RM" .And. SE5->E5_LA <> "S"
								f_GravaLA( SE5->E5_FILIAL, SE5->E5_NUMERO, SE5->E5_FSBXRM )	
							Endif

							SE5->(DbSkip())
						EndDo
					EndIf
					//grava o numero da liquidacao no titulos de origem
					DBSELECTAREA("SE1")
					DBSETORDER(1)
					If DBSEEK(XFILIAL("SE1")+c_Pre+c_Num+c_Par+c_Tip+c_Cli+c_Loj)
						Reclock("SE1",.F.)
						SE1->E1_FSNUMLI:= ::NumLiq
						MsUnlock()

						//23/04/2019 - Para os titulos do RM verifica se esta no status de perda e chama a contabilizacao reversa - Fluxo de Cobranca
						If (Alltrim(c_Pre) = "RM") //Apenas para os titulos com prefixo RM, pq vem o ID da baixa do RM
							//Adriano 29/03/2019 - Tratamento para gerar a contabilizacao reversa de titulos de perda - Fluxo de Cobranca.
							//Para funcionar tem que compilar o fonte FINA09O
							If ExistBlock("FINA09O") .And. ( Alltrim(SE1->E1_XSTTTCB) == '5' ) //Perda
								//O LP 230 foi criado especificamente para essa finalidade.
								CUSUARIO:= "123456WS " //Fiz isso para gravar WS no LP pois eh usado a variavel cusuario no LP 230
								u_GrvCtbReversa("230") //Funcao declarada no PRW FINA09O - Rotina de Fluxo de Cobranca
							Endif
						EndIf

					EndIf
				EndIf
			Next
			//Se deu erro no execauto, desarma a transacao
			If (lMsErroAuto) .And. (l_Erro)
				DisarmTransaction()
				Break
			Else

				//Posiciona na empresa e filial de destino
				dbSelectArea("SM0")
				dbSeek(o_Empresa:c_Empresa+o_Empresa:c_Filial)
				cFilAnt:= o_Empresa:c_Filial

				//Gravacao dos novos titulos
				For p:= 1 To Len(o_TitDestino:TITULOS)

					c_Cliente	:= ""
					c_Loja		:= ""
					c_Tipo		:= ""
					DBSELECTAREA("SA1")
					DBSETORDER(3)
					If !(DBSEEK(XFILIAL("SA1")+Alltrim(o_TitDestino:TITULOS[p]:CGC)))
						::o_Retorno:l_Status		:= .F.
						::o_Retorno:c_Mensagem	:= "CNPJ/CPF "+Alltrim(o_TitDestino:TITULOS[p]:CGC)+" nao encontrado na base de dados do protheus."+CHR(13)+CHR(10)
						Conout("FFIEBW01 - mtdLiquidacao: CNPJ/CPF "+Alltrim(o_TitDestino:TITULOS[p]:CGC)+" nao encontrado na base de dados do protheus.")
						//Volta a database
						DDATABASE:= d_DataBk
						Return(.T.)
					Else
						c_Cliente	:= SA1->A1_COD
						c_Loja		:= SA1->A1_LOJA
					EndIf
					//Valida o tipo
					dbSelectArea("SX5")
					dbSetOrder(1)
					If !(dbSeek(xfilial("SX5")+"05"+Alltrim(o_TitDestino:TITULOS[p]:E1_TIPO)))
						::o_Retorno:l_Status		:= .F.
						::o_Retorno:c_Mensagem	:= "Tipo "+Alltrim(o_TitDestino:TITULOS[p]:E1_TIPO)+" nao encontrado na base de dados do protheus."+CHR(13)+CHR(10)
						Conout("FFIEBW01 - mtdLiquidacao: Tipo "+Alltrim(o_TitDestino:TITULOS[p]:E1_TIPO)+" nao encontrado na base de dados do protheus.")
						//Volta a database
						DDATABASE:= d_DataBk
						Return(.T.)
					Else
						c_Tipo	:= SX5->X5_CHAVE
					EndIf

					dbSelectArea("SED")
					dbSetOrder(1)
					dbSeek(xfilial("SED")+Alltrim(o_TitDestino:TITULOS[p]:E1_NATUREZ))
					c_Natureza:= SED->ED_CODIGO

					//Tratamento para a data de vencimento real
					d_VencRea	:= DataValida(STOD(o_TitDestino:TITULOS[p]:E1_VENCTO),.T.)
					n_Valor		:= o_TitDestino:TITULOS[p]:E1_VALOR
					aVetor		:= {}
					aAdd( aVetor, { "E1_PREFIXO"	,PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1]),Nil})
					aAdd( aVetor, { "E1_NUM"		,PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_NUM), TAMSX3("E1_NUM")[1])		,Nil})
					aAdd( aVetor, { "E1_PARCELA"	,PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_PARCELA), TAMSX3("E1_PARCELA")[1]),Nil})
					aAdd( aVetor, { "E1_TIPO"		,PADR(c_Tipo, TAMSX3("E1_TIPO")[1])  		,Nil})
					aAdd( aVetor, { "E1_CLIENTE"	,PADR(c_Cliente, TAMSX3("E1_CLIENTE")[1])	,Nil})
					aAdd( aVetor, { "E1_LOJA"		,PADR(c_Loja, TAMSX3("E1_LOJA")[1])			,Nil})
					aAdd( aVetor, { "E1_NATUREZ"	,PADR(c_Natureza, TAMSX3("E1_NATUREZ")[1])	,Nil})
					aAdd( aVetor, { "E1_EMISSAO"	,STOD(o_TitDestino:TITULOS[p]:E1_EMISSAO)				,Nil})
					aAdd( aVetor, { "E1_VENCTO"		,STOD(o_TitDestino:TITULOS[p]:E1_VENCTO)				,Nil})
					aAdd( aVetor, { "E1_VENCREA"	,d_VencRea									,Nil})
					aAdd( aVetor, { "E1_VALOR"		,n_Valor									,Nil})
					aAdd( aVetor, { "E1_HIST"		,PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_HIST), TAMSX3("E1_HIST")[1])		,Nil})
					aAdd( aVetor, { "E1_CREDIT"		,PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_CONTA), TAMSX3("E1_CREDIT")[1])	,Nil})
					aAdd( aVetor, { "E1_ITEMC"		,PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_ITEMC), TAMSX3("E1_ITEMC")[1])	,Nil})
					aAdd( aVetor, { "E1_CCC"		,PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_CCC), TAMSX3("E1_CCC")[1])		,Nil})
					aAdd( aVetor, { "E1_CLVLCR"		,PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_CLVLCR), TAMSX3("E1_CLVLCR")[1])	,Nil})
					aAdd( aVetor, { "E1_HIST"		,PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_HIST), TAMSX3("E1_HIST")[1])		,Nil})
					aAdd( aVetor, { "E1_MULTA"		,o_TitDestino:TITULOS[p]:E1_MULTA						,Nil})
					aAdd( aVetor, { "E1_JUROS"		,o_TitDestino:TITULOS[p]:E1_JUROS						,Nil})
					aAdd( aVetor, { "E1_DESCONT"	,o_TitDestino:TITULOS[p]:E1_DESCONT					,Nil})
					aAdd( aVetor, { "E1_XTITEMS"	,PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_XTITEMS), TAMSX3("E1_XTITEMS")[1]),Nil})
					aAdd( aVetor, { "E1_LA"			,Alltrim(o_TitDestino:TITULOS[p]:E1_LA)				,Nil})
					aAdd( aVetor, { "E1_FSNUMLI"	,PADR(Alltrim(::NumLiq), TAMSX3("E1_FSNUMLI")[1]),Nil}) //Grava o numero da liquidacao

					lMsErroAuto		:= .F.
					lMsHelpAuto		:= .T.
					lAutoErrNoFile	:= .T.

					MSExecAuto({|x,y| Fina040(x,y)},aVetor,3) //3- Inclusao, 4- Alteracao, 5- Exclusao
					If lMsErroAuto
						l_Erro:= .T.
						Exit
					Else
						o_ObjRateio:= o_TitDestino:TITULOS[p]:NATRATEIO
						If Len(o_TitDestino:TITULOS[p]:NATRATEIO) > 0
							If !Empty(o_TitDestino:TITULOS[p]:NATRATEIO[1]:EV_NATUREZ) .And. (o_TitDestino:TITULOS[p]:NATRATEIO[1]:EV_VALOR > 0)
								f_GravaEVEZ(c_Cliente, c_Loja, c_Tipo, "R", Alltrim(o_TitDestino:TITULOS[p]:E1_PREFIXO), Alltrim(o_TitDestino:TITULOS[p]:E1_NUM), Alltrim(o_TitDestino:TITULOS[p]:E1_PARCELA), "LIQ", p, SE1->E1_VALOR)
								DbSelectArea("SE1")
								RecLock("SE1",.F.)
								SE1->E1_MULTNAT:= '1'
								MsUnLock()
							EndIf
						EndIf
					Endif
				Next
				If !(l_Erro)
					::o_Retorno:l_Status	:= .T.
					::o_Retorno:c_Mensagem	:= "Gravacao da liquidacao de numero "+::NumLiq+" finalizada."
					Conout("FFIEBW01 - mtdLiquidacao: Gravacao da liquidacao de numero "+::NumLiq+" finalizada.")
				Else
					//Se deu erro no execauto da criacao do novo titulo, desarma atransacao
					DisarmTransaction()
					Break
				EndIf
			EndIf
		End Transaction
		//Se deu erro no Execauto
		If (lMsErroAuto) .And. (l_Erro)
			//Regra do fonte SIESBA01 da FIEB
			If (__lSX8)
				RollBackSX8()
			EndIf

			// Tratamento da Mensagem de erro do MSExecAuto
			aLogErr  := GetAutoGRLog()
			aLogErr2 := f_TrataErro(aLogErr)
			_cMotivo := ""

			For i := 1 to Len(aLogErr2)
				_cMotivo += aLogErr2[i]
			Next

			//Exclusivo para a versao 12
			If (GetVersao(.F.) == "12")
				_cMotivo:=  NoAcentoESB(_cMotivo)
				SetSoapFault('Erro',_cMotivo)
			EndIf

			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= NoAcentoESB(_cMotivo)
			Conout("FFIEBW01 - mtdLiquidacao: "+NoAcentoESB(_cMotivo))
		EndIf
	Else
		//Exclusao da liquidacao
		
		//INICIO  - Valida se ja foi processado o estorno
		l_TemBxRm:= .F.
		For p:= 1 To Len(o_TitOrigem:TITULOS)
			If !Empty(o_TitOrigem:TITULOS[p]:XIDBAIXARM)
				l_TemBxRm:= .T.
				Exit
			EndIf
		Next
		If (l_TemBxRm)
			n_RegExist	:=	0
			n_RegNExist	:=	0
			For p:= 1 To Len(o_TitOrigem:TITULOS)
				DBSELECTAREA("SA1")
				DBSETORDER(3)
				DBSEEK(XFILIAL("SA1")+Alltrim(o_TitOrigem:TITULOS[p]:CGC))
				c_CliBx		:= SA1->A1_COD
				c_LojBx		:= SA1->A1_LOJA
				c_PreBx		:= PADR(Alltrim(o_TitOrigem:TITULOS[p]:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1])
				c_NumBx		:= PADR(Alltrim(o_TitOrigem:TITULOS[p]:E1_NUM), TAMSX3("E1_NUM")[1])
				c_ParBx		:= PADR(Alltrim(o_TitOrigem:TITULOS[p]:E1_PARCELA), TAMSX3("E1_PARCELA")[1])
				c_TipBx		:= PADR(Alltrim(o_TitOrigem:TITULOS[p]:E1_TIPO), TAMSX3("E1_TIPO")[1])
				l_IdBxSe5 	:= f_IDSE5(Alltrim(o_TitOrigem:TITULOS[p]:E1_FILIAL), Alltrim(o_TitOrigem:TITULOS[p]:XIDBAIXARM), c_PreBx, c_NumBx, c_ParBx, c_TipBx, c_CliBx, c_LojBx, .T., Alltrim( ::NumLiq ) ) //incrementdo para validar existencia do id da baixa na se5
				If l_IdBxSe5
					n_RegExist++
				Else
					n_RegNExist++
				Endif
			Next

			If n_RegExist == Len(o_TitOrigem:TITULOS)
				::o_Retorno:l_Status	:= .T.
				::o_Retorno:c_Mensagem	:= "###Estorno da Liquidacao ("+Alltrim(::NumLiq)+") ja processado com sucesso."
				Conout("FFIEBW01 - mtdLiquidacao: ###Estorno da Liquidacao ("+Alltrim(::NumLiq)+") ja processado com sucesso.")
				Return(.T.)
			ElseIf n_RegNExist > 0 .And. n_RegNExist < Len(o_TitOrigem:TITULOS)
				::o_Retorno:l_Status	:= 	.F.
				::o_Retorno:c_Mensagem	:= 	"###Estorno da Liquidacao ("+Alltrim(::NumLiq)+") inconsistente na base, o mesmo deve ser excluido no protheus e reprocessado."
				Conout("FFIEBW01 - mtdLiquidacao: ###Estorno da Liquidacao ("+Alltrim(::NumLiq)+") inconsistente na base, o mesmo deve ser excluido no protheus e reprocessado.")
				Return(.T.)
			Endif
		EndIf
		//FIM  - Valida se ja foi processado o estorno
		
		//Valida os titulos de origem
		For p:= 1 To Len(o_TitOrigem:TITULOS)

			If Empty(o_TitOrigem:TITULOS[p]:E1_FILIAL)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe a filial do titulo de origem."
				Conout("FFIEBW01 - mtdLiquidacao: Informe a filial do titulo de origem.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf

			//Valida a filial de origem
			If !(f_VldFilEmp(o_Empresa:c_Empresa,Alltrim(o_TitOrigem:TITULOS[p]:E1_FILIAL)))
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem		:= "Filial "+Alltrim(o_TitOrigem:TITULOS[p]:E1_FILIAL)+" de origem nao foi encontrada."
				Conout("FFIEBW01 - mtdLiquidacao: Filial "+Alltrim(o_TitOrigem:TITULOS[p]:E1_FILIAL)+" de origem nao foi encontrada.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf

			//Posiciona na empresa e filial de origem
			dbSelectArea("SM0")
			dbSeek(o_Empresa:c_Empresa+Alltrim(o_TitOrigem:TITULOS[p]:E1_FILIAL))
			cFilAnt:= Alltrim(o_TitOrigem:TITULOS[p]:E1_FILIAL)

			If Empty(o_TitOrigem:TITULOS[p]:CGC)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe o CGC do cliente."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: Informe o CGC do cliente.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
			DBSELECTAREA("SA1")
			DBSETORDER(3)
			If !(DBSEEK(XFILIAL("SA1")+Alltrim(o_TitOrigem:TITULOS[p]:CGC)))
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "CNPJ/CPF "+Alltrim(o_TitOrigem:TITULOS[p]:CGC)+" nao encontrado na base de dados do protheus."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: CNPJ/CPF "+Alltrim(o_TitOrigem:TITULOS[p]:CGC)+" nao encontrado na base de dados do protheus.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			Else
				c_Cliente	:= SA1->A1_COD
				c_Loja		:= SA1->A1_LOJA
			EndIf

			c_Pre:= PADR(Alltrim(o_TitOrigem:TITULOS[p]:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1])
			c_Num:= PADR(Alltrim(o_TitOrigem:TITULOS[p]:E1_NUM), TAMSX3("E1_NUM")[1])
			c_Par:= PADR(Alltrim(o_TitOrigem:TITULOS[p]:E1_PARCELA), TAMSX3("E1_PARCELA")[1])
			c_Tip:= PADR(Alltrim(o_TitOrigem:TITULOS[p]:E1_TIPO), TAMSX3("E1_TIPO")[1])

			DBSELECTAREA("SE1")
			DBSETORDER(1)
			If !(DBSEEK(XFILIAL("SE1")+c_Pre+c_Num+c_Par+c_Tip+c_Cliente+c_Loja))
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Titulo nao encontrado com os parametros passados. "+XFILIAL("SE1")+c_Pre+c_Num+c_Par+c_Tip+c_Cliente+c_Loja+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: Titulo nao encontrado com os parametros passados. "+XFILIAL("SE1")+c_Pre+c_Num+c_Par+c_Tip+c_Cliente+c_Loja)
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			ElseIf (SE1->E1_SALDO = SE1->E1_VALOR)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "O titulo informado: "+XFILIAL("SE1")+"-"+c_Pre+"-"+c_Num+"-"+c_Par+"-"+c_Tip+"-"+c_Cliente+"-"+c_Loja+" nao encontra-se baixado."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: O titulo informado: "+XFILIAL("SE1")+"-"+c_Pre+"-"+c_Num+"-"+c_Par+"-"+c_Tip+"-"+c_Cliente+"-"+c_Loja+" nao encontra-se baixado.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			ElseIf (Alltrim(SE1->E1_FSNUMLI) <> Alltrim(::NumLiq))
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Nao eh permitido cancelar a baixa pois o titulo informado: "+XFILIAL("SE1")+"-"+c_Pre+"-"+c_Num+"-"+c_Par+"-"+c_Tip+"-"+c_Cliente+"-"+c_Loja+" nao pertence a liquidacao de numero "+Alltrim(::NumLiq)+". Numero da liquidacao do titulo: "+Alltrim(SE1->E1_FSNUMLI)
				Conout("FFIEBW01 - mtdLiquidacao: Nao eh permitido cancelar a baixa pois o titulo informado "+XFILIAL("SE1")+"-"+c_Pre+"-"+c_Num+"-"+c_Par+"-"+c_Tip+"-"+c_Cliente+"-"+c_Loja+" nao pertence a liquidacao de numero "+Alltrim(::NumLiq)+". Numero da liquidacao do titulo: "+Alltrim(SE1->E1_FSNUMLI))
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
			/* Adriano - Comentei 22/08/18 e coloquei o tratamento acima
			//veririca se o titulo percente a liquidacao passada
			l_E5Achei:= .F.
			DBSELECTAREA("SE5")
			DBSETORDER(7)
			If Dbseek(xFilial("SE5")+c_Pre+c_Num+c_Par+c_Tip+c_Cliente+c_Loja)
				While !(SE5->(Eof())) .And. (SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA == xFilial("SE5")+c_Pre+c_Num+c_Par+c_Tip+c_Cliente+c_Loja)
					If (SE5->E5_SITUACA = ' ') .And. (SE5->E5_RECPAG = 'R') .And. ( (Alltrim(SE5->E5_TIPODOC) = 'VL') .OR. (Alltrim(SE5->E5_TIPODOC) = 'BA') )
						If (Alltrim(SE5->E5_DOCUMEN) == ALltrim(::NumLiq))
							l_E5Achei:= .T.
							Exit
						EndIf
					EndIf
					SE5->(DbSkip())
				EndDo
				If !(l_E5Achei)
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Nao eh permitido cancelar a baixa pois o titulo informado: "+XFILIAL("SE1")+"-"+c_Pre+"-"+c_Num+"-"+c_Par+"-"+c_Tip+"-"+c_Cliente+"-"+c_Loja+" nao pertence a liquidacao de numero "+Alltrim(::NumLiq)+". Numero da liquidacao do titulo: "+Alltrim(SE5->E5_DOCUMEN)
					Conout("FFIEBW01 - mtdLiquidacao: Nao eh permitido cancelar a baixa pois o titulo informado "+XFILIAL("SE1")+"-"+c_Pre+"-"+c_Num+"-"+c_Par+"-"+c_Tip+"-"+c_Cliente+"-"+c_Loja+" nao pertence a liquidacao de numero "+Alltrim(::NumLiq)+". Numero da liquidacao do titulo: "+Alltrim(SE5->E5_DOCUMEN))
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				EndIf
			EndIf
			*/
			If Empty(o_TitOrigem:TITULOS[p]:AUTBANCO) .Or. Empty(o_TitOrigem:TITULOS[p]:AUTAGENCIA) .Or. Empty(o_TitOrigem:TITULOS[p]:AUTCONTA)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Banco/Agencia/Conta nao informados. "+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: Banco/Agencia/Conta nao informados. ")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
			DDATABASE:= Stod(o_TitOrigem:TITULOS[p]:AUTDTBAIXA)
			If	(STOD(o_TitOrigem:TITULOS[p]:AUTDTBAIXA) > dDatabase)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "A data da baixa e maior que a data atual. Baixa nao permitida. AUTDTBAIXA: "+o_TitOrigem:TITULOS[p]:AUTDTBAIXA+". dDatabase: "+ dtos(dDatabase)+"."
				Conout("FFIEBW01 - mtdLiquidacao: A data da baixa e maior que a data atual. Baixa nao permitida. AUTDTBAIXA: "+o_TitOrigem:TITULOS[p]:AUTDTBAIXA+". dDatabase: "+ dtos(dDatabase)+".")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			Endif
			/*If	(STOD(o_TitOrigem:TITULOS[p]:AUTDTCREDITO) > dDatabase)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "A data de credito e maior que a data atual. Baixa nao permitida."
				Conout("FFIEBW01 - mtdLiquidacao: A data de credito e maior que a data atual. Baixa nao permitida.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			Endif*/
			If Empty(o_TitOrigem:TITULOS[p]:AUTMOTBX)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Motivo da baixa nao foi informado."
				Conout("FFIEBW01 - mtdLiquidacao: Motivo da baixa nao foi informado.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
			If (o_TitOrigem:TITULOS[p]:AUTVALREC < 0) .Or. (o_TitOrigem:TITULOS[p]:AUTVALREC = 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Valor recebido informado nao eh valido."
				Conout("FFIEBW01 - mtdLiquidacao: Valor recebido informado nao eh valido.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
			If (o_TitOrigem:TITULOS[p]:AUTMULTA < 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Valor de multa informado nao eh valido."
				Conout("FFIEBW01 - mtdLiquidacao: Valor de multa informado nao eh valido.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
			If (o_TitOrigem:TITULOS[p]:AUTJUROS < 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Valor de juros informado nao eh valido."
				Conout("FFIEBW01 - mtdLiquidacao: Valor de juros informado nao eh valido.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
			If (o_TitOrigem:TITULOS[p]:AUTDESCONT < 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Valor de desconto informado nao eh valido."
				Conout("FFIEBW01 - mtdLiquidacao: Valor de desconto informado nao eh valido.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
			If (o_TitOrigem:TITULOS[p]:AUTACRESC < 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Valor de acrescimo informado nao eh valido."
				Conout("FFIEBW01 - mtdLiquidacao: Valor de desconto informado nao eh valido.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
			If (o_TitOrigem:TITULOS[p]:AUTDECRESC < 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Valor de descrescimo informado nao eh valido."
				Conout("FFIEBW01 - mtdLiquidacao: Valor de desconto informado nao eh valido.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf

			c_Ban:= Padr(o_TitOrigem:TITULOS[p]:AUTBANCO,TamSX3("E1_PORTADO")[1])
			c_Age:= Padr(o_TitOrigem:TITULOS[p]:AUTAGENCIA,TamSX3("E5_AGENCIA")[1])
			c_Con:= Padr(o_TitOrigem:TITULOS[p]:AUTCONTA,TamSX3("E5_CONTA")[1])

			DBSELECTAREA("SA6")
			DBSETORDER(1)
			If !DBSEEK(xFilial("SA6")+c_Ban+c_Age+c_Con)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "O banco/agencia/conta informado nao existe no cadastro de bancos: "+c_Ban+"/"+c_Age+"/"+c_Con
				Conout("FFIEBW01 - mtdLiquidacao: O banco/agencia/conta informado nao existe no cadastro de bancos: "+c_Ban+"/"+c_Age+"/"+c_Con)
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf

			d_TesteData	:=	StoD(o_TitOrigem:TITULOS[p]:AUTDTBAIXA)
			If valtype(d_TesteData) == "D"
				If Empty(d_TesteData)
					::o_Retorno:l_Status		:= .F.
					::o_Retorno:c_Mensagem	:= "Informe Data da baixa no formato [AAAAMMDD]."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdLiquidacao: Informe Data de emissao no formato [AAAAMMDD].")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				EndIf
			Else
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe Data da baixa no formato [AAAAMMDD]."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: Informe Data de emissao no formato [AAAAMMDD].")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
			d_TesteData	:=	StoD(o_TitOrigem:TITULOS[p]:AUTDTCREDITO)
			If valtype(d_TesteData) == "D"
				If Empty(d_TesteData)
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Informe Data do credito no formato [AAAAMMDD]."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdLiquidacao: Informe Data do credito no formato [AAAAMMDD].")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				EndIf
			Else
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Informe Data do credito no formato [AAAAMMDD]."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: Informe Data do credito no formato [AAAAMMDD].")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
		Next
		//Posiciona na empresa e filial de destino
		dbSelectArea("SM0")
		dbSeek(o_Empresa:c_Empresa+o_Empresa:c_Filial)
		cFilAnt:= o_Empresa:c_Filial

		//Valida os titulos de Destino
		For p:= 1 To Len(o_TitDestino:TITULOS)
			If Empty(o_TitDestino:TITULOS[p]:E1_NUM)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Informe o numero do titulo."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: Informe o numero do titulo.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			ElseIf Empty(o_TitDestino:TITULOS[p]:E1_TIPO)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Informe o tipo do titulo."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: Informe o tipo do titulo.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			ElseIf Empty(o_TitDestino:TITULOS[p]:E1_NATUREZ)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Informe a natureza do titulo."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: Informe a natureza do titulo.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			ElseIf Empty(o_TitDestino:TITULOS[p]:CGC)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Informe o CNPJ/CPF do cliente do titulo."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: Informe o CNPJ/CPF do cliente do titulo.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			ElseIf Empty(o_TitDestino:TITULOS[p]:E1_EMISSAO)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Informe a data de emissao titulo."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: Informe a data de emissao do titulo.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			ElseIf Empty(o_TitDestino:TITULOS[p]:E1_VENCTO)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Informe a data de vencimento titulo."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: Informe a data de vencimento do titulo.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
			DBSELECTAREA("SA1")
			DBSETORDER(3)
			If !(DBSEEK(XFILIAL("SA1")+Alltrim(o_TitDestino:TITULOS[p]:CGC)))
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "CNPJ/CPF "+Alltrim(o_TitDestino:TITULOS[p]:CGC)+" nao encontrado na base de dados do protheus."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: CNPJ/CPF "+Alltrim(o_TitDestino:TITULOS[p]:CGC)+" nao encontrado na base de dados do protheus.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
			//Valida o tipo
			dbSelectArea("SX5")
			dbSetOrder(1)
			If !(dbSeek(xfilial("SX5")+"05"+Alltrim(o_TitDestino:TITULOS[p]:E1_TIPO)))
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Tipo "+Alltrim(o_TitDestino:TITULOS[p]:E1_TIPO)+" nao encontrado na base de dados do protheus."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: Tipo "+Alltrim(o_TitDestino:TITULOS[p]:E1_TIPO)+" nao encontrado na base de dados do protheus.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf

			c_Pre:= PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1])
			c_Num:= PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_NUM), TAMSX3("E1_NUM")[1])
			c_Par:= PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_PARCELA), TAMSX3("E1_PARCELA")[1])
			c_Tip:= PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_TIPO), TAMSX3("E1_TIPO")[1])

			DBSELECTAREA("SE1")
			DBSETORDER(1)
			If !(DBSEEK(XFILIAL("SE1")+c_Pre+c_Num+c_Par+c_Tip+c_Cliente+c_Loja))
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Chave do titulo de destino nao encontrada ("+c_Pre+c_Num+c_Par+c_Tip+c_Cliente+c_Loja+")."
				Conout("FFIEBW01 - mtdLiquidacao: Chave do titulo de destino nao encontrada ("+c_Pre+c_Num+c_Par+c_Tip+c_Cliente+c_Loja+").")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			ElseIf (SE1->E1_SALDO <> SE1->E1_VALOR)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "O titulo informado: "+XFILIAL("SE1")+"-"+c_Pre+"-"+c_Num+"-"+c_Par+"-"+c_Tip+"-"+c_Cliente+"-"+c_Loja+" ja sofreu baixa."
				Conout("FFIEBW01 - mtdLiquidacao: O titulo informado: "+XFILIAL("SE1")+"-"+c_Pre+"-"+c_Num+"-"+c_Par+"-"+c_Tip+"-"+c_Cliente+"-"+c_Loja+" ja sofreu baixa.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			ElseIf (Alltrim(SE1->E1_FSNUMLI) <> Alltrim(::NumLiq))
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "O titulo informado: "+XFILIAL("SE1")+"-"+c_Pre+"-"+c_Num+"-"+c_Par+"-"+c_Tip+"-"+c_Cliente+"-"+c_Loja+" nao pertence a liquidacao de numero "+Alltrim(::NumLiq)+". Numero da liquidacao do titulo: "+Alltrim(SE1->E1_FSNUMLI)
				Conout("FFIEBW01 - mtdLiquidacao: O titulo informado: "+XFILIAL("SE1")+"-"+c_Pre+"-"+c_Num+"-"+c_Par+"-"+c_Tip+"-"+c_Cliente+"-"+c_Loja+" nao pertence a liquidacao de numero "+Alltrim(::NumLiq)+". Numero da liquidacao do titulo: "+Alltrim(SE1->E1_FSNUMLI))
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf

			//Valida a natureza
			dbSelectArea("SED")
			dbSetOrder(1)
			If !(dbSeek(xfilial("SED")+Alltrim(o_TitDestino:TITULOS[p]:E1_NATUREZ)))
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Natureza "+Alltrim(o_TitDestino:TITULOS[p]:E1_NATUREZ)+" nao encontrada na base de dados do protheus."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: Natureza "+Alltrim(o_TitDestino:TITULOS[p]:E1_NATUREZ)+" nao encontrada na base de dados do protheus.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf

			If !Empty(o_TitDestino:TITULOS[p]:E1_CONTA)
				//Validando a conta contabil
				DBSELECTAREA("CT1")
				DBSETORDER(1)
				IF !DBSEEK(xFilial("CT1")+Alltrim(o_TitDestino:TITULOS[p]:E1_CONTA))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CONTA)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+"."
					Conout("FFIEBW01 - mtdLiquidacao: Codigo da conta contabil ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CONTA)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+".")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				ElseIf CT1->CT1_CLASSE == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CONTA)+") nao pode ser sintetica."
					Conout("FFIEBW01 - mtdLiquidacao: Codigo da conta contabil ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CONTA)+") nao pode ser sintetica.")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				ElseIf CT1->CT1_BLOQ == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CONTA)+") esta bloqueada para uso."
					Conout("FFIEBW01 - mtdLiquidacao: Codigo da conta contabil ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CONTA)+")  esta bloqueada para uso.")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				EndIf
			EndIf

			If !Empty(o_TitDestino:TITULOS[p]:E1_CCC)
				//Validando o centro de custo
				DbSelectArea("CTT")
				CTT->(dbSetOrder(1))
				If !(CTT->(dbSeek(xFilial("CTT")+Alltrim(o_TitDestino:TITULOS[p]:E1_CCC))))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Centro de Custo informado para o campo E1_CCC invalido ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CCC)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdLiquidacao: Centro de Custo informado para o campo E1_CCC invalido ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CCC)+").")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				Elseif CTT->CTT_CLASSE == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Centro de Custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CCC)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdLiquidacao: Centro de Custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CCC)+").")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				Elseif CTT->CTT_BLOQ == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Centro de Custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CCC)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdLiquidacao: Centro de Custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CCC)+").")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				Endif
			EndIf

			//Validando o item contabil
			If !Empty(o_TitDestino:TITULOS[p]:E1_ITEMC)
				DbSelectArea("CTD")
				CTD->(dbSetOrder(1))
				If !(CTD->(dbSeek(xFilial("CTD")+Alltrim(o_TitDestino:TITULOS[p]:E1_ITEMC))))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil informado para o campo E1_ITEMC invalido ("+Alltrim(o_TitDestino:TITULOS[p]:E1_ITEMC)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdLiquidacao: Item contabil informado para o campo E1_ITEMC invalido ("+Alltrim(o_TitDestino:TITULOS[p]:E1_ITEMC)+").")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				Elseif CTD->CTD_CLASSE == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_TitDestino:TITULOS[p]:E1_ITEMC)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdLiquidacao: Item contabil invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_TitDestino:TITULOS[p]:E1_ITEMC)+").")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				Elseif CTD->CTD_BLOQ == "1" .or. (!Empty(CTD->CTD_DTEXSF) .and. CTD->CTD_DTEXSF < dDatabase)
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_TitDestino:TITULOS[p]:E1_ITEMC)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdLiquidacao: Item contabil invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_TitDestino:TITULOS[p]:E1_ITEMC)+").")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				ElseIf (!Empty(CTD->CTD_DTEXIS) .and. dDatabase < CTD->CTD_DTEXIS)
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil ("+Alltrim(o_TitDestino:TITULOS[p]:E1_ITEMC)+") esta com data de inicio de existencia superior a data base."+CHR(13)+CHR(10)
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				Endif
			EndIf

			If !Empty(o_TitDestino:TITULOS[p]:E1_CLVLCR)
				//Validando a classe de valor
				DbSelectArea("CTH")
				CTH->(dbSetOrder(1))
				If !(CTH->(dbSeek(xFilial("CTH")+Alltrim(o_TitDestino:TITULOS[p]:E1_CLVLCR))))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Classe de valor informado para o campo E1_CLVLCR invalido ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CLVLCR)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdLiquidacao: Classe de valor informado para o campo E1_CLVLCR invalido ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CLVLCR)+").")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				Elseif CTH->CTH_CLASSE == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Classe de valor invalido. O Classe de valor nao pode ser sintetico ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CLVLCR)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdLiquidacao: Classe de valor invalido. O Classe de valor nao pode ser sintetico ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CLVLCR)+").")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				Elseif CTH->CTH_BLOQ == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Classe de valor invalido. o Classe de valor esta bloqueado para uso ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CLVLCR)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdLiquidacao: Classe de valor invalido. o Classe de valor esta bloqueado para uso ("+Alltrim(o_TitDestino:TITULOS[p]:E1_CLVLCR)+").")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				Endif
			EndIf

			If (o_TitDestino:TITULOS[p]:E1_MULTA < 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "O valor da multa nao pode ser menor do que zero."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: O valor da multa nao pode ser menor do que zero.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf

			If (o_TitDestino:TITULOS[p]:E1_JUROS < 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "O valor de juros nao pode ser menor do que zero."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: O valor de juros nao pode ser menor do que zero.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf

			If (o_TitDestino:TITULOS[p]:E1_DESCONT < 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "O valor de desconto nao pode ser menor do que zero."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: O valor de desconto nao pode ser menor do que zero.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf

			a_RatNat:= {}
			a_RatCC	:= {}

			//Valida o array do rateio
			If Len(o_TitDestino:TITULOS[p]:NATRATEIO) > 0
				If !Empty(o_TitDestino:TITULOS[p]:NATRATEIO[1]:EV_NATUREZ) .And. (o_TitDestino:TITULOS[p]:NATRATEIO[1]:EV_PERC > 0) .And. (o_TitDestino:TITULOS[p]:NATRATEIO[1]:EV_VALOR > 0)

					o_ObjRateio:= o_TitDestino:TITULOS[p]:NATRATEIO

					//Valida se tem rateio por naturezas informado
					For n:= 1 To Len(o_ObjRateio)
						If Empty(o_ObjRateio[n]:EV_NATUREZ) .Or. Empty(o_ObjRateio[n]:EV_PERC) .Or. Empty(o_ObjRateio[n]:EV_VALOR)
							o_Retorno:l_Status		:= .F.
							o_Retorno:c_Mensagem	:= "Algum campo do rateio de multiplas naturezas nao foi preenchido."+CHR(13)+CHR(10)
							Conout("FFIEBW01 - mtdLiquidacao: Algum campo do rateio de multiplas naturezas nao foi preenchido.")
							//Volta a database
							DDATABASE:= d_DataBk
							Return(.T.)
						EndIf
					Next

					For n:= 1 To Len(o_ObjRateio)
						//Valida a natureza
						dbSelectArea("SED")
						dbSetOrder(1)
						If !(dbSeek(xfilial("SED")+Alltrim(o_ObjRateio[n]:EV_NATUREZ)))
							o_Retorno:l_Status		:= .F.
							o_Retorno:c_Mensagem	:= "Natureza do rateio "+Alltrim(o_ObjRateio[n]:EV_NATUREZ)+" nao encontrada na base de dados do protheus."+CHR(13)+CHR(10)
							Conout("FFIEBW01 - mtdLiquidacao: Natureza do rateio "+Alltrim(o_ObjRateio[n]:EV_NATUREZ)+" nao encontrada na base de dados do protheus.")
							//Volta a database
							DDATABASE:= d_DataBk
							Return(.T.)
						EndIf

						//Validacao para nao permitir a inclusao da mesma Natureza em mais de um item.
						If aScan(a_RatNat,Alltrim(o_ObjRateio[n]:EV_NATUREZ)) > 0
							o_Retorno:l_Status	:= .F.
							o_Retorno:c_Mensagem	:= "A Natureza "+Alltrim(o_ObjRateio[n]:EV_NATUREZ)+" ja esta cadastrada em outro item da Tabela SEV)."+CHR(13)+CHR(10)
							Conout("FFIEBW01 - mtdLiquidacao: A Natureza "+Alltrim(o_ObjRateio[n]:EV_NATUREZ)+" ja esta cadastrada em outro item da Tabela SEV).")
							//Volta a database
							DDATABASE:= d_DataBk
							Return(.T.)
						Else
							Aadd(a_RatNat,Alltrim(o_ObjRateio[n]:EV_NATUREZ))
				        Endif

				        If (o_ObjRateio[n]:EV_PERC < 0)
							o_Retorno:l_Status	:= .F.
							o_Retorno:c_Mensagem	:= "O valor do percentual nao pode ser menor do que zero."+CHR(13)+CHR(10)
							Conout("FFIEBW01 - mtdLiquidacao: O valor do percentual nao pode ser menor do que zero.")
							//Volta a database
							DDATABASE:= d_DataBk
							Return(.T.)
						EndIf

						If (o_ObjRateio[n]:EV_VALOR < 0)
							o_Retorno:l_Status	:= .F.
							o_Retorno:c_Mensagem	:= "O valor do rateio por natureza nao pode ser menor do que zero."+CHR(13)+CHR(10)
							Conout("FFIEBW01 - mtdLiquidacao: O valor do rateio por natureza nao pode ser menor do que zero.")
							//Volta a database
							DDATABASE:= d_DataBk
							Return(.T.)
						EndIf

						a_RatCC:= {}
						If Len(o_ObjRateio[n]:CCUSTORATEIO) > 0

							//Valida se tem rateio por CC
							For c:= 1 To Len(o_ObjRateio[n]:CCUSTORATEIO)
								If Empty(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO) .Or. Empty(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_VALOR)
									o_Retorno:l_Status	:= .F.
									o_Retorno:c_Mensagem	:= "Algum campo do rateio de multiplos CC nao foi preenchido."+CHR(13)+CHR(10)
									Conout("FFIEBW01 - mtdLiquidacao: Algum campo do rateio de multiplos CC nao foi preenchido.")
									//Volta a database
									DDATABASE:= d_DataBk
									Return(.T.)
								EndIf
							Next

							For c:= 1 To Len(o_ObjRateio[n]:CCUSTORATEIO)

								DbSelectArea("CTT")
								CTT->(dbSetOrder(1))
								If !(CTT->(dbSeek(xFilial("CTT")+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO))))
									o_Retorno:l_Status	:= .F.
									o_Retorno:c_Mensagem	:= "Centro de Custo informado para o campo EZ_CCUSTO invalido ("+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO)+")."+CHR(13)+CHR(10)
									Conout("FFIEBW01 - mtdLiquidacao: Centro de Custo informado para o campo EZ_CCUSTO invalido ("+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO)+").")
									//Volta a database
									DDATABASE:= d_DataBk
									Return(.T.)
								Elseif CTT->CTT_CLASSE == "1"
									o_Retorno:l_Status	:= .F.
									o_Retorno:c_Mensagem	:= "Centro de Custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO)+")."+CHR(13)+CHR(10)
									Conout("FFIEBW01 - mtdLiquidacao: Centro de Custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO)+").")
									//Volta a database
									DDATABASE:= d_DataBk
									Return(.T.)
								Elseif CTT->CTT_BLOQ == "1"
									o_Retorno:l_Status	:= .F.
									o_Retorno:c_Mensagem	:= "Centro de Custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO)+")."+CHR(13)+CHR(10)
									Conout("FFIEBW01 - mtdLiquidacao: Centro de Custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO)+").")
									//Volta a database
									DDATABASE:= d_DataBk
									Return(.T.)
								Endif

								//Validacao para nao permitir a inclusao da mesma CC em mais de um item.
								If aScan(a_RatCC, Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO)) > 0
									o_Retorno:l_Status		:= .F.
									o_Retorno:c_Mensagem	:= "O CC "+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO)+" ja esta cadastrado em outro item da Tabela SEZ)."+CHR(13)+CHR(10)
									Conout("FFIEBW01 - mtdLiquidacao: O CC "+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO)+" ja esta cadastrado em outro item da Tabela SEZ).")
									//Volta a database
									DDATABASE:= d_DataBk
									Return(.T.)
								Else
									Aadd(a_RatCC, Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO))
				                Endif

				                If (o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_VALOR < 0)
									o_Retorno:l_Status	:= .F.
									o_Retorno:c_Mensagem	:= "O valor do percentual nao pode ser menor do que zero."+CHR(13)+CHR(10)
									Conout("FFIEBW01 - mtdLiquidacao: O valor do percentual nao pode ser menor do que zero.")
									//Volta a database
									DDATABASE:= d_DataBk
									Return(.T.)
								EndIf

								If (o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_PERC < 0)
									o_Retorno:l_Status	:= .F.
									o_Retorno:c_Mensagem	:= "O valor do rateio por natureza nao pode ser menor do que zero."+CHR(13)+CHR(10)
									Conout("FFIEBW01 - mtdLiquidacao: O valor do rateio por natureza nao pode ser menor do que zero.")
									//Volta a database
									DDATABASE:= d_DataBk
									Return(.T.)
								EndIf
							Next
						EndIf
					Next
				EndIf
			EndIf
			d_TesteData	:=	StoD(o_TitDestino:TITULOS[p]:E1_EMISSAO)
			If valtype(d_TesteData) == "D"
				If Empty(d_TesteData)
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Informe Data de emissao no formato [AAAAMMDD]."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdLiquidacao: Informe Data de emissao no formato [AAAAMMDD].")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				EndIf
			Else
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Informe Data de emissao no formato [AAAAMMDD]."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: Informe Data de emissao no formato [AAAAMMDD].")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
			d_TesteData	:=	StoD(o_TitDestino:TITULOS[p]:E1_VENCTO)
			If valtype(d_TesteData) == "D"
				If Empty(d_TesteData)
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Informe Data de vencimento no formato [AAAAMMDD]."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdLiquidacao: Informe Data de vencimento no formato [AAAAMMDD].")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				EndIf
			Else
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Informe Data de vencimento no formato [AAAAMMDD]."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdLiquidacao: Informe Data de vencimento no formato [AAAAMMDD].")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
		Next
		l_Erro:= .F.
		Begin Transaction
			//Exclusao das baixas
			For p:= 1 To Len(o_TitOrigem:TITULOS)
				c_Cli	:= ""
				c_Loj	:= ""

				//Posiciona na empresa e filial de origem
				dbSelectArea("SM0")
				dbSeek(o_Empresa:c_Empresa+Alltrim(o_TitOrigem:TITULOS[p]:E1_FILIAL))
				cFilAnt:= Alltrim(o_TitOrigem:TITULOS[p]:E1_FILIAL)

				DBSELECTAREA("SA1")
				DBSETORDER(3)
				DBSEEK(XFILIAL("SA1")+Alltrim(o_TitOrigem:TITULOS[p]:CGC))
				c_Cli	:= SA1->A1_COD
				c_Loj	:= SA1->A1_LOJA

				c_Pre	:= PADR(Alltrim(o_TitOrigem:TITULOS[p]:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1])
				c_Num	:= PADR(Alltrim(o_TitOrigem:TITULOS[p]:E1_NUM), TAMSX3("E1_NUM")[1])
				c_Par	:= PADR(Alltrim(o_TitOrigem:TITULOS[p]:E1_PARCELA), TAMSX3("E1_PARCELA")[1])
				c_Tip	:= PADR(Alltrim(o_TitOrigem:TITULOS[p]:E1_TIPO), TAMSX3("E1_TIPO")[1])

				DBSELECTAREA("SE1")
				DBSETORDER(1)
				DBSEEK(XFILIAL("SE1")+c_Pre+c_Num+c_Par+c_Tip+c_Cli+c_Loj)

				c_Ban	:= Padr(o_TitOrigem:TITULOS[p]:AUTBANCO,TamSX3("E1_PORTADO")[1])
				c_Age	:= Padr(o_TitOrigem:TITULOS[p]:AUTAGENCIA,TamSX3("E5_AGENCIA")[1])
				c_Con	:= Padr(o_TitOrigem:TITULOS[p]:AUTCONTA,TamSX3("E5_CONTA")[1])

				c_MotBx   := Alltrim(o_TitOrigem:TITULOS[p]:AUTMOTBX)
				d_DtBaixa := STOD(o_TitOrigem:TITULOS[p]:AUTDTBAIXA)
				d_DtCred  := STOD(o_TitOrigem:TITULOS[p]:AUTDTCREDITO)
				c_Hist    := PADR(Alltrim(o_TitOrigem:TITULOS[p]:AUTHIST), TAMSX3("E5_HISTOR")[1])
				n_Descont := o_TitOrigem:TITULOS[p]:AUTDESCONT
				n_Multa   := o_TitOrigem:TITULOS[p]:AUTMULTA
				n_Juros   := o_TitOrigem:TITULOS[p]:AUTJUROS
				n_ValRec  := o_TitOrigem:TITULOS[p]:AUTVALREC
				n_Acres   := o_TitOrigem:TITULOS[p]:AUTACRESC
				n_Decres  := o_TitOrigem:TITULOS[p]:AUTDECRESC

				a_Baixa	  := {}
				a_Baixa := {{"E1_PREFIXO"  	,PADR(c_Pre	, TAMSX3("E1_PREFIXO")[1])	,Nil},;
							{"E1_NUM"		,PADR(c_Num	, TAMSX3("E1_NUM")[1])		,Nil},;
							{"E1_PARCELA"	,PADR(c_Par	, TAMSX3("E1_PARCELA")[1])	,Nil},;
							{"E1_TIPO"		,PADR(c_Tip	, TAMSX3("E1_TIPO")[1])		,Nil},;
							{"E1_CLIENTE"	,PADR(c_Cli	, TAMSX3("E1_CLIENTE")[1])	,Nil},;
							{"E1_LOJA"		,PADR(c_Loj	, TAMSX3("E1_LOJA")[1])		,Nil},;
							{"AUTMOTBX"		,PADR(c_MotBx, TAMSX3("E5_MOTBX")[1])	,Nil},;
							{"AUTBANCO"		,c_Ban		,Nil},;
							{"AUTAGENCIA"	,c_Age		,Nil},;
							{"AUTCONTA"		,c_Con		,Nil},;
							{"AUTDTBAIXA"	,d_DtBaixa	,Nil},;
							{"AUTDTCREDITO"	,d_DtCred	,Nil},;
							{"AUTHIST"		,c_Hist		,Nil},;
							{"AUTDESCONT"  	,n_Descont	,Nil,.T.},;
							{"AUTMULTA"  	,n_Multa	,Nil,.T.},;
							{"AUTJUROS"  	,n_Juros	,Nil,.T.},;
							{"AUTACRESC"  	,n_Acres	,Nil,.T.},;
							{"AUTDECRESC"  	,n_Decres	,Nil,.T.},;
							{"AUTVALREC"	,n_ValRec	,Nil}}

				//INCLUI         := .T.
				lMsErroAuto    := .F.
				lMsHelpAuto    := .T.
				lAutoErrNoFile := .T.
				//ITEM 13 - Ajuste na busca do seq baixa na exclusao da liquidacao (renegociacao) 18/09/2019
				l_NaoAchei	:= .F.
				n_SeqBx		:= 0
				a_E5Area	:= SE5->( GetArea() )
				c_Qry:= "SELECT E5_SEQ, R_E_C_N_O_ REC, E5_FSBXRM, E5_SEQ, E5_SITUACA, E5_TIPODOC, E5_VALOR, E5_DTCANBX, E5_ORIGEM, E5_FSIDACO "+chr(13)+chr(10)
				c_Qry+= "FROM "+RETSQLNAME("SE5")+" E5"+chr(13)+chr(10)
				c_Qry+= "WHERE E5_FILIAL = '"+Alltrim(o_TitOrigem:TITULOS[p]:E1_FILIAL)+"' "+chr(13)+chr(10)
				c_Qry+= "AND E5.D_E_L_E_T_ = '' "+chr(13)+chr(10)
				c_Qry+= "AND E5_RECPAG = 'R' AND E5_TIPODOC IN ('BA','VL') AND E5_SITUACA = ' ' AND E5_ORIGEM = 'RPC' AND E5_DTCANBX = '' "+chr(13)+chr(10)
				c_Qry+= "AND E5_PREFIXO = '"+c_Pre+"' "+chr(13)+chr(10) 
				c_Qry+= "AND E5_NUMERO  = '"+c_Num+"'"+chr(13)+chr(10)	
				c_Qry+= "AND E5_PARCELA = '"+c_Par+"' "+chr(13)+chr(10)
				c_Qry+= "AND E5_TIPO    = '"+c_Tip+"' "+chr(13)+chr(10)
				c_Qry+= "AND E5_CLIFOR  = '"+c_Cli+"' "+chr(13)+chr(10)
				c_Qry+= "AND E5_LOJA    = '"+c_Loj+"' "+chr(13)+chr(10)
				c_Qry+= "ORDER BY R_E_C_N_O_ "						
				TCQUERY c_Qry ALIAS QRY NEW
				dbSelectArea("QRY")
				If !(QRY->(Eof()))
					While !(QRY->(Eof()))
						n_SeqBx++
						DbSelectArea("SE5")
						DbGoto(QRY->REC)
						//Garante que posicionou no registro da compensacao
						If (SE5->(Recno()) = QRY->REC) .And. (SE5->E5_RECPAG = 'R') .And. (SE5->E5_TIPODOC = 'BA' .OR. SE5->E5_TIPODOC = 'VL') .And. (SE5->E5_PREFIXO = c_Pre) .And. (SE5->E5_NUMERO = c_Num) .And. (SE5->E5_PARCELA = c_Par) .And. (SE5->E5_TIPO = c_Tip) .And. (SE5->E5_CLIFOR = c_Cli) .And. (SE5->E5_LOJA = c_Loj)
							If( Alltrim( SE5->E5_FSIDACO ) == Alltrim( ::NumLiq ) )
								l_NaoAchei:= .T.
								Exit
							EndIf
						EndIf
						dbSelectArea("QRY")
						QRY->(DbSkip())
					EndDo
				EndIf						
				dbSelectArea("QRY")
				QRY->(dbCloseArea())
				RestArea( a_E5Area )
				If !( l_NaoAchei )
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Nao foi encontrado na tabela SE5, o registro relacionado ao estorno da renegciacao "+::NumLiq+". O cancelamento da baixa nao pode ser realizado. Titulo: "+c_Pre+c_Num+c_Par+c_Tip+c_Cli+c_Loj					
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				Else
					nOpbaixa:= n_SeqBx
				EndIf
				//Fim do ITEM 13
				//6 - Exclusao da baixa; 5 - Cancelamento
				//Foi alterado para 5 em 05/06/2019 por conta do bloqueio do mv_datafin
				MSExecAuto( {|n,x,y,z| Fina070(n,x,y,z)}, a_Baixa, 5, lNoMbrowse, nOpbaixa)
				If lMsErroAuto
					l_Erro:= .T.
					Exit
				Else
					//Limpa o numero da liquidacao na baixa - NAO PRECISA PQ A ROTINA FAZ A EXCLUSAO DO SE5
					/*
					DBSELECTAREA("SE5")
					DBSETORDER(7)
					If Dbseek(xFilial("SE5")+c_Pre+c_Num+c_Par+c_Tip+c_Cli+c_Loj)
						While !(SE5->(Eof())) .And. (SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA == xFilial("SE5")+c_Pre+c_Num+c_Par+c_Tip+c_Cli+c_Loj)
							If (SE5->E5_SITUACA = 'C')
								Reclock("SE5",.F.)
								SE5->E5_DOCUMEN:= ""
								MsUnlock()
							EndIf
							SE5->(DbSkip())
						EndDo
					EndIf
					*/
					//Limpa o numero da liquidacao no titulos de origem
					DBSELECTAREA("SE1")
					DBSETORDER(1)
					If DBSEEK(XFILIAL("SE1")+c_Pre+c_Num+c_Par+c_Tip+c_Cli+c_Loj)
						Reclock("SE1",.F.)
						SE1->E1_FSNUMLI:= ""
						MsUnlock()

						//23/04/2019 - Para os titulos do RM verifica se esta no status de perda e chama a contabilizacao reversa - Fluxo de Cobranca
						If (Alltrim(c_Pre) = "RM") //Apenas para os titulos com prefixo RM, pq vem o ID da baixa do RM
							//Adriano 29/03/2019 - Tratamento para gerar a contabilizacao reversa de titulos de perda - Fluxo de Cobranca.
							//Para funcionar tem que compilar o fonte FINA09O
							If ExistBlock("FINA09O") .And. ( Alltrim(SE1->E1_XSTTTCB) == '5' ) //Perda
								//O LP 231 foi criado especificamente para essa finalidade.
								CUSUARIO:= "123456WS " //Fiz isso para gravar WS no LP pois eh usado a variavel cusuario no LP 230
								u_GrvCtbReversa("231") //Funcao declarada no PRW FINA09O - Rotina de Fluxo de Cobranca
							Endif
						EndIf

					EndIf
				EndIf
			Next
			//Se deu erro no execauto, desarma a transacao
			If (lMsErroAuto) .And. (l_Erro)
				DisarmTransaction()
				Break
			Else
				//Posiciona na empresa e filial de destino
				dbSelectArea("SM0")
				dbSeek(o_Empresa:c_Empresa+o_Empresa:c_Filial)
				cFilAnt:= o_Empresa:c_Filial

				//Gravacao dos novos titulos
				For p:= 1 To Len(o_TitDestino:TITULOS)

					c_Cliente	:= ""
					c_Loja		:= ""
					c_Tipo		:= ""
					DBSELECTAREA("SA1")
					DBSETORDER(3)
					If !(DBSEEK(XFILIAL("SA1")+Alltrim(o_TitDestino:TITULOS[p]:CGC)))
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "CNPJ/CPF "+Alltrim(o_TitDestino:TITULOS[p]:CGC)+" nao encontrado na base de dados do protheus."+CHR(13)+CHR(10)
						Conout("FFIEBW01 - mtdLiquidacao: CNPJ/CPF "+Alltrim(o_TitDestino:TITULOS[p]:CGC)+" nao encontrado na base de dados do protheus.")
						//Volta a database
						DDATABASE:= d_DataBk
						Return(.T.)
					Else
						c_Cliente	:= SA1->A1_COD
						c_Loja		:= SA1->A1_LOJA
					EndIf
					//Valida o tipo
					dbSelectArea("SX5")
					dbSetOrder(1)
					If !(dbSeek(xfilial("SX5")+"05"+Alltrim(o_TitDestino:TITULOS[p]:E1_TIPO)))
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "Tipo "+Alltrim(o_TitDestino:TITULOS[p]:E1_TIPO)+" nao encontrado na base de dados do protheus."+CHR(13)+CHR(10)
						Conout("FFIEBW01 - mtdLiquidacao: Tipo "+Alltrim(o_TitDestino:TITULOS[p]:E1_TIPO)+" nao encontrado na base de dados do protheus.")
						//Volta a database
						DDATABASE:= d_DataBk
						Return(.T.)
					Else
						c_Tipo	:= SX5->X5_CHAVE
					EndIf

					dbSelectArea("SED")
					dbSetOrder(1)
					dbSeek(xfilial("SED")+Alltrim(o_TitDestino:TITULOS[p]:E1_NATUREZ))
					c_Natureza:= SED->ED_CODIGO

					//Tratamento para a data de vencimento real
					d_VencRea	:= DataValida(STOD(o_TitDestino:TITULOS[p]:E1_VENCTO),.T.)
					n_Valor		:= o_TitDestino:TITULOS[p]:E1_VALOR
					aVetor		:= {}
					aAdd( aVetor, { "E1_PREFIXO"	,PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1]),Nil})
					aAdd( aVetor, { "E1_NUM"		,PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_NUM), TAMSX3("E1_NUM")[1])		,Nil})
					aAdd( aVetor, { "E1_PARCELA"	,PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_PARCELA), TAMSX3("E1_PARCELA")[1]),Nil})
					aAdd( aVetor, { "E1_TIPO"		,PADR(c_Tipo, TAMSX3("E1_TIPO")[1])  		,Nil})
					aAdd( aVetor, { "E1_CLIENTE"	,PADR(c_Cliente, TAMSX3("E1_CLIENTE")[1])	,Nil})
					aAdd( aVetor, { "E1_LOJA"		,PADR(c_Loja, TAMSX3("E1_LOJA")[1])			,Nil})
					aAdd( aVetor, { "E1_NATUREZ"	,PADR(c_Natureza, TAMSX3("E1_NATUREZ")[1])	,Nil})
					aAdd( aVetor, { "E1_EMISSAO"	,STOD(o_TitDestino:TITULOS[p]:E1_EMISSAO)				,Nil})
					aAdd( aVetor, { "E1_VENCTO"		,STOD(o_TitDestino:TITULOS[p]:E1_VENCTO)				,Nil})
					aAdd( aVetor, { "E1_VENCREA"	,d_VencRea									,Nil})
					aAdd( aVetor, { "E1_VALOR"		,n_Valor									,Nil})
					aAdd( aVetor, { "E1_HIST"		,PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_HIST), TAMSX3("E1_HIST")[1])		,Nil})
					aAdd( aVetor, { "E1_CREDIT"		,PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_CONTA), TAMSX3("E1_CREDIT")[1])	,Nil})
					aAdd( aVetor, { "E1_ITEMC"		,PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_ITEMC), TAMSX3("E1_ITEMC")[1])	,Nil})
					aAdd( aVetor, { "E1_CCC"		,PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_CCC), TAMSX3("E1_CCC")[1])		,Nil})
					aAdd( aVetor, { "E1_CLVLCR"		,PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_CLVLCR), TAMSX3("E1_CLVLCR")[1])	,Nil})
					aAdd( aVetor, { "E1_HIST"		,PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_HIST), TAMSX3("E1_HIST")[1])		,Nil})
					aAdd( aVetor, { "E1_MULTA"		,o_TitDestino:TITULOS[p]:E1_MULTA						,Nil})
					aAdd( aVetor, { "E1_JUROS"		,o_TitDestino:TITULOS[p]:E1_JUROS						,Nil})
					aAdd( aVetor, { "E1_DESCONT"	,o_TitDestino:TITULOS[p]:E1_DESCONT					,Nil})
					aAdd( aVetor, { "E1_XTITEMS"	,PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_XTITEMS), TAMSX3("E1_XTITEMS")[1]),Nil})

					lMsErroAuto		:= .F.
					lMsHelpAuto		:= .T.
					lAutoErrNoFile	:= .T.

					c_PreBx:= PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1])
					c_NumBx:= PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_NUM), TAMSX3("E1_NUM")[1])
					c_ParBx:= PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_PARCELA), TAMSX3("E1_PARCELA")[1])

					If (Alltrim(c_PreBx) == 'RM')
						DBSELECTAREA("SE1")
						DBSETORDER(1)
						If (DBSEEK(XFILIAL("SE1")+c_PreBx+c_NumBx+c_ParBx+c_Tipo+c_Cliente+c_Loja))
							If (SE1->E1_LA = 'S')
								RecLock("SE1",.F.)
								SE1->E1_LA:= 'N'
								MsUnLock()
							EndIf
						EndIf
					EndIf

					MSExecAuto({|x,y| Fina040(x,y)},aVetor,5) //3- Inclusao, 4- Alteracao, 5- Exclusao
					If lMsErroAuto
						l_Erro:= .T.
						Exit
					Endif
				Next
				If !(l_Erro)
					::o_Retorno:l_Status	:= .T.
					::o_Retorno:c_Mensagem	:= "Exclusao da liquidacao de numero "+::NumLiq+" finalizada."
					Conout("FFIEBW01 - mtdLiquidacao: Exclusao da liquidacao de numero "+::NumLiq+" finalizada.")
				Else
					//Se deu erro no execauto da criacao do novo titulo, desarma atransacao
					DisarmTransaction()
					Break
				EndIf
			EndIf
		End Transaction
		//Se deu erro no Execauto
		If (lMsErroAuto) .And. (l_Erro)
			//Regra do fonte SIESBA01 da FIEB
			If (__lSX8)
				RollBackSX8()
			EndIf

			// Tratamento da Mensagem de erro do MSExecAuto
			aLogErr  := GetAutoGRLog()
			aLogErr2 := f_TrataErro(aLogErr)
			_cMotivo := ""

			For i := 1 to Len(aLogErr2)
				_cMotivo += aLogErr2[i]
			Next

			//Exclusivo para a versao 12
			If (GetVersao(.F.) == "12")
				_cMotivo:=  cFilAnt+"/"+c_Pre+"/"+c_Num+"/"+c_Par+"/"+c_Tip+"/"+c_Cli+"/"+c_Loj+": "+NoAcentoESB(_cMotivo)
				SetSoapFault('Erro',_cMotivo)
			EndIf
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= cFilAnt+"/"+c_Pre+"/"+c_Num+"/"+c_Par+"/"+c_Tip+"/"+c_Cli+"/"+c_Loj+": "+NoAcentoESB(_cMotivo)
			Conout("FFIEBW01 - mtdLiquidacao: "+cFilAnt+"/"+c_Pre+"/"+c_Num+"/"+c_Par+"/"+c_Tip+"/"+c_Cli+"/"+c_Loj+": "+NoAcentoESB(_cMotivo))
		Else
			//Verifica se houveram as baixas
			If(::o_Retorno:l_Status == .T.)
				For p:= 1 To Len(o_TitOrigem:TITULOS)
					If !Empty(o_TitOrigem:TITULOS[p]:XIDBAIXARM) //Se mandou o Id da baixa do Rm
						c_PreBx	:= PADR(Alltrim(o_TitOrigem:TITULOS[p]:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1])
						c_NumBx	:= PADR(Alltrim(o_TitOrigem:TITULOS[p]:E1_NUM), TAMSX3("E1_NUM")[1])
						c_ParBx	:= PADR(Alltrim(o_TitOrigem:TITULOS[p]:E1_PARCELA), TAMSX3("E1_PARCELA")[1])
						c_TipBx	:= PADR(Alltrim(o_TitOrigem:TITULOS[p]:E1_TIPO), TAMSX3("E1_TIPO")[1])
						DBSELECTAREA("SA1")
						DBSETORDER(3)
						If (DBSEEK(XFILIAL("SA1")+Alltrim(o_TitOrigem:TITULOS[p]:CGC)))
							c_CliBx	:= SA1->A1_COD
							c_LojBx	:= SA1->A1_LOJA
						EndIf
						If (Alltrim(c_PreBx) = "RM") //Apenas para os titulos com prefixo RM, pq vem o ID da baixa do RM
							If (n_Operacao = 1) //Liquidacao
								l_Encont:= .F.
								//Verifica se a baixa existe
								DBSELECTAREA("SE5")
								DBSETORDER(7)
								If Dbseek(xFilial("SE5")+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx)
									While !(SE5->(Eof())) .And. (SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA == xFilial("SE5")+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx)
										If (Alltrim(SE5->E5_FSBXRM) == Alltrim(o_TitOrigem:TITULOS[p]:XIDBAIXARM)) //id da baixa do RM
											If Empty(SE5->E5_DTCANBX) .And. Empty(SE5->E5_SITUACA) //Retira os movimentos cancelados
												If (Alltrim(SE5->E5_ORIGEM) = 'RPC')
													l_Encont:= .T.
													Exit
												EndIf
											EndIf
										EndIf
										
										//Inserido para forcar gravacao do LA para titulos do Tipo RM
										If Alltrim(SE5->E5_PREFIXO) == "RM" .And. SE5->E5_LA <> "S"
											f_GravaLA( SE5->E5_FILIAL, SE5->E5_NUMERO, SE5->E5_FSBXRM )	
										Endif

										SE5->(DbSkip())
									EndDo
									If !(l_Encont)
										::o_Retorno:l_Status	:= .F.
										::o_Retorno:c_Mensagem	:= "### LIQUIDACAO - Id da baixa "+Alltrim(o_TitOrigem:TITULOS[p]:XIDBAIXARM)+" do titulo "+Alltrim(c_NumBx)+" na filial "+o_Empresa:c_Filial+" nao encontrado apos o processo de baixa. Possivelmente ocorreu algum rollback na transacao. Necessario enviar a baixa novamente. ###"+CHR(13)+CHR(10)
										Exit
									EndIf
								EndIf
							Else //Cancelamento da liquidacao
								l_Encont:= .F.
								//Verifica se a baixa foi realmente cancelada. Nesse caso a linha da baixa fica com E5_DTCANBX preenchido e uma nova linha com RECPAG = P e criada.
								DBSELECTAREA("SE5")
								DBSETORDER(7)
								If Dbseek(xFilial("SE5")+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx)
									While !(SE5->(Eof())) .And. (SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA == xFilial("SE5")+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx)
										If (Alltrim(SE5->E5_FSBXRM) == Alltrim(o_TitOrigem:TITULOS[p]:XIDBAIXARM)) //id da baixa do RM
											If Empty(SE5->E5_DTCANBX) .And. Empty(SE5->E5_SITUACA)
												If (Alltrim(SE5->E5_ORIGEM) = 'RPC')
													l_Encont:= .T.
													Exit
												EndIf
											EndIf
										EndIf

										//Inserido para for�ar grava��o do LA para titulos do Tipo RM
										If Alltrim(SE5->E5_PREFIXO) == "RM" .And. SE5->E5_LA <> "S"
											f_GravaLA( SE5->E5_FILIAL, SE5->E5_NUMERO, SE5->E5_FSBXRM )	
										Endif

										SE5->(DbSkip())
									EndDo
									If (l_Encont)
										::o_Retorno:l_Status	:= .F.
										::o_Retorno:c_Mensagem	:= "### LIQUIDACAO Id da baixa "+Alltrim(o_TitOrigem:TITULOS[p]:XIDBAIXARM)+" do titulo "+Alltrim(c_NumBx)+" na filial "+o_Empresa:c_Filial+" encontrado ativo apos o processo de cancelamento da baixa. Verificar se o ID da Baixa foi enviado mais de uma vez em outra baixa ou ocorreu algum rollback na transacao. ###"+CHR(13)+CHR(10)
										Exit
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				Next
				//Verifica se o titulo criado existe para inclusao e se foi excluido para cancelamento da liquidacao
				If(::o_Retorno:l_Status == .T.)
					For p:= 1 To Len(o_TitDestino:TITULOS)
						//Verifica se realmente gravou o Titulo
						c_Pre:= PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1])
						c_Num:= PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_NUM), TAMSX3("E1_NUM")[1])
						c_Par:= PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_PARCELA), TAMSX3("E1_PARCELA")[1])
						c_Tip:= PADR(Alltrim(o_TitDestino:TITULOS[p]:E1_TIPO), TAMSX3("E1_TIPO")[1])

						DBSELECTAREA("SA1")
						DBSETORDER(3)
						DBSEEK(XFILIAL("SA1")+Alltrim(o_TitDestino:TITULOS[p]:CGC))
						c_Cliente	:= SA1->A1_COD
						c_Loja		:= SA1->A1_LOJA

						If (n_Operacao = 1) //inclusao da liquidacao
							DBSELECTAREA("SE1")
							DBSETORDER(1)
							If (DBSEEK(XFILIAL("SE1")+c_Pre+c_Num+c_Par+c_Tip+c_Cliente+c_Loja))
								//Titulo gravado
							Else
								::o_Retorno:l_Status		:= .F.
								::o_Retorno:c_Mensagem	:= "### LIQUIDACAO - Titulo "+c_Num+" na filial "+o_Empresa:c_Filial+" nao encontrado apos o processo de inclusao. Possivelmente ocorreu algum rollback na transacao. Necessario enviar a inclusao novamente. ###"+CHR(13)+CHR(10)
								Exit
							EndIf
						Else //Cancelamento da liquidacao
							DBSELECTAREA("SE1")
							DBSETORDER(1)
							If (DBSEEK(XFILIAL("SE1")+c_Pre+c_Num+c_Par+c_Tip+c_Cliente+c_Loja))
								::o_Retorno:l_Status		:= .F.
								::o_Retorno:c_Mensagem	:= "### LIQUIDACAO - Titulo "+c_Num+" na filial "+o_Empresa:c_Filial+" encontrado apos o processo de exclusao. Possivelmente ocorreu algum rollback na transacao. Necessario enviar a inclusao novamente. ###"+CHR(13)+CHR(10)
								Exit
							Else
								//Titulo excluido
							EndIf
						EndIf
					Next
				EndIf
			EndIf
		EndIf
	Endif
	//RpcClearEnv() //Limpa o ambiente, liberando a licenca e fechando as conexoes
	DDATABASE:= d_DataBk
RETURN(.T.)
/*/{Protheus.doc} mtdBaixaPorLote
Metodo de baixa
@author Totvs-BA
@since 30/04/2018
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
//metodo de baixa por lote
WSMETHOD mtdBaixaPorLote WSRECEIVE o_Seguranca, o_Empresa, o_MovBLote WSSEND o_Retorno WSSERVICE FFIEBW01

	//Local a_Recs	:= {}
	//Local c_Histor	:= ""
	Local c_Lote	:= ""
	Local h
	Local a_Baixa 	:= {}
	Local c_CliBx	:= ""
	Local c_LojBX	:= ""
	Local aTxMoeda 	:= {}
	Local i,p,u		:= 0
	Local l_Continua:= .T.
	Local a_MotsBx	:= {}
	Local n_PosBx	:= 0
	Local c_xNumRM	:= ""
	Local l_Encont		:= .F.
	Local n_RegExist	:= 0
	Local n_RegNExist	:= 0
	Local l_TemBxRm:= .F.
	Local c_FilError	:= ""
	Local c_SeqBai		:= ""
	PRIVATE lMsErroAuto 	:= .F.
	Private lNoMbrowse		:= .F. //Variavel logica que informa se deve ou nao ser apresentado o Browse da rotina.
	Private nOpbaixa		:= 1

	::o_Retorno	:= WSCLASSNEW("strRetorno")

	If !(f_VldFilEmp(o_Empresa:c_Empresa,o_Empresa:c_Filial))
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Codigo de Empresa/Filial nao existe."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdBaixaPorLote: Codigo de Empresa/Filial nao existe.")
		Return(.T.)
	EndIf

	//Loga na filial solicitada
	RpcSetType(3)
	RpcSetEnv(o_Empresa:c_Empresa,o_Empresa:c_Filial, "integracao", "fieb123")

	//Posiciona na empresa e filial passada
	dbSelectArea("SM0")
	dbSeek(o_Empresa:c_Empresa+o_Empresa:c_Filial)

	cFilAnt		:= o_Empresa:c_Filial

	c_UserWS	:= Upper(ALLTRIM(SUPERGETMV("FS_FIUSRWS",,"totvs_fieb")))
	c_PswWS		:= Upper(ALLTRIM(SUPERGETMV("FS_FIPSWWS",,"totvs@123")))

	//Validando o usuario e senha
	If ( Upper(o_Seguranca:c_Usuario) <> Upper(c_UserWS) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdBaixaPorLote: Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido.")
		Return(.T.)
	ElseIf ( Upper(o_Seguranca:c_Senha) <> Upper(c_PswWS) )
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdBaixaPorLote: Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida.")
		Return(.T.)
	EndIf
	For i:= 1 To Len(o_MovBLote:BAIXASTIT)
		dDatabase	:= STOD(o_MovBLote:BAIXASTIT[i]:AUTDTBAIXA)
		If Empty(o_MovBLote:BAIXASTIT[i]:CGC)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Informe o CNPJ/CPF do cliente do titulo."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdBaixaPorLote: Informe o CNPJ/CPF do cliente do titulo.")
			l_Continua:= .F.
			Exit
		EndIf
		If Empty(o_MovBLote:BAIXASTIT[i]:AUTBANCO) .Or. Empty(o_MovBLote:BAIXASTIT[i]:AUTAGENCIA) .Or. Empty(o_MovBLote:BAIXASTIT[i]:AUTCONTA)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Banco/Agencia/Conta nao informados."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdBaixaPorLote: Banco/Agencia/Conta nao informados.")
			l_Continua:= .F.
			Exit
		EndIf
		If	(STOD(o_MovBLote:BAIXASTIT[i]:AUTDTBAIXA) > dDatabase)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "A data da baixa e maior que a data atual. Baixa nao permitida. AUTDTBAIXA: "+o_MovBLote:BAIXASTIT[i]:AUTDTBAIXA+". dDatabase: "+ dtos(dDatabase)+"."
			Conout("FFIEBW01 - mtdBaixaPorLote: A data da baixa e maior que a data atual. Baixa nao permitida. AUTDTBAIXA: "+o_MovBLote:BAIXASTIT[i]:AUTDTBAIXA+". dDatabase: "+ dtos(dDatabase)+".")
			l_Continua:= .F.
			Exit
		Endif
		/*
		If	(STOD(o_MovBLote:BAIXASTIT[i]:AUTDTCREDITO) > dDatabase)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "A data de credito e maior que a data atual. Baixa nao permitida."
			Conout("FFIEBW01 - mtdBaixaPorLote: A data de credito e maior que a data atual. Baixa nao permitida.")
			l_Continua:= .F.
			Exit
		Endif*/
		If Empty(o_MovBLote:BAIXASTIT[i]:AUTMOTBX)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Motivo da baixa nao foi informado."
			Conout("FFIEBW01 - mtdBaixaPorLote: Motivo da baixa nao foi informado.")
			l_Continua:= .F.
			Exit
		Else
			//Verifica se o motivo de baixa existe
			a_MotsBx:= ReadMotBx() //Carrega os motivos de baixas - Funcao padrao. Fonte FinxBx - fA070Grv()
			n_PosBx := Ascan(a_MotsBx, {|x| AllTrim(SubStr(x,1,3)) == AllTrim(Upper(o_MovBLote:BAIXASTIT[i]:AUTMOTBX))})
			If n_PosBx > 0
				//Existe o motivo de baixa. Nao faz nada
			Else
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Motivo de baixa nao encontrado: "+Alltrim(o_MovBLote:BAIXASTIT[i]:AUTMOTBX)+". Verficar o arquivo sigaadv.mot"
				Conout("FFIEBW01 - mtdBaixaPorLote: Motivo de baixa nao encontrado: "+Alltrim(o_MovBLote:BAIXASTIT[i]:AUTMOTBX)+". Verficar o arquivo sigaadv.mot")
				Return(.T.)
			EndIf
		EndIf
		If (o_MovBLote:BAIXASTIT[i]:AUTVALREC < 0) .Or. (o_MovBLote:BAIXASTIT[i]:AUTVALREC = 0)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Valor recebido informado nao pode ser menor do que zero."
			Conout("FFIEBW01 - mtdBaixaPorLote: Valor recebido informado pode ser menor do que zero.")
			l_Continua:= .F.
			Exit
		EndIf
		If (o_MovBLote:BAIXASTIT[i]:AUTMULTA < 0)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Valor de multa informado nao eh valido."
			Conout("FFIEBW01 - mtdBaixaPorLote: Valor de multa informado nao eh valido.")
			l_Continua:= .F.
			Exit
		EndIf
		If (o_MovBLote:BAIXASTIT[i]:AUTJUROS < 0)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Valor de juros informado nao eh valido."
			Conout("FFIEBW01 - mtdBaixaPorLote: Valor de juros informado nao eh valido.")
			l_Continua:= .F.
			Exit
		EndIf
		If (o_MovBLote:BAIXASTIT[i]:AUTDESCONT < 0)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Valor de desconto informado nao eh valido."
			Conout("FFIEBW01 - mtdBaixaPorLote: Valor de desconto informado nao eh valido.")
			l_Continua:= .F.
			Exit
		EndIf
		If (o_MovBLote:BAIXASTIT[i]:AUTACRESC < 0)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Valor de acrescimo informado nao eh valido."
			Conout("FFIEBW01 - mtdBaixaPorLote: Valor de desconto informado nao eh valido.")
			l_Continua:= .F.
			Exit
		EndIf
		If (o_MovBLote:BAIXASTIT[i]:AUTDECRESC < 0)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Valor de descrescimo informado nao eh valido."
			Conout("FFIEBW01 - mtdBaixaPorLote: Valor de desconto informado nao eh valido.")
			l_Continua:= .F.
			Exit
		EndIf

		c_Ban:= Padr(o_MovBLote:BAIXASTIT[i]:AUTBANCO,TamSX3("E1_PORTADO")[1])
		c_Age:= Padr(o_MovBLote:BAIXASTIT[i]:AUTAGENCIA,TamSX3("E5_AGENCIA")[1])
		c_Con:= Padr(o_MovBLote:BAIXASTIT[i]:AUTCONTA,TamSX3("E5_CONTA")[1])

		DBSELECTAREA("SA6")
		DBSETORDER(1)
		If !DBSEEK(xFilial("SA6")+c_Ban+c_Age+c_Con)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "O banco/agencia/conta informado nao existe no cadastro de bancos: "+c_Ban+"/"+c_Age+"/"+c_Con
			Conout("FFIEBW01 - mtdBaixaPorLote: O banco/agencia/conta informado nao existe no cadastro de bancos: "+c_Ban+"/"+c_Age+"/"+c_Con)
			l_Continua:= .F.
			Exit
		EndIf
		d_TesteData	:=	StoD(o_MovBLote:BAIXASTIT[i]:AUTDTBAIXA)
		If valtype(d_TesteData) == "D"
			If Empty(d_TesteData)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Informe Data da baixa no formato [AAAAMMDD]."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdBaixaPorLote: Informe Data de emissao no formato [AAAAMMDD].")
				l_Continua:= .F.
				Exit
			EndIf
		Else
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Informe Data da baixa no formato [AAAAMMDD]."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdBaixaPorLote: Informe Data de emissao no formato [AAAAMMDD].")
			l_Continua:= .F.
			Exit
		EndIf
		d_TesteData	:=	StoD(o_MovBLote:BAIXASTIT[i]:AUTDTCREDITO)
		If valtype(d_TesteData) == "D"
			If Empty(d_TesteData)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Informe Data do credito no formato [AAAAMMDD]."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdBaixaPorLote: Informe Data do credito no formato [AAAAMMDD].")
				l_Continua:= .F.
				Exit
			EndIf
		Else
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Informe Data do credito no formato [AAAAMMDD]."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdBaixaPorLote: Informe Data do credito no formato [AAAAMMDD].")
			l_Continua:= .F.
			Exit
		EndIf
		//Valida se o periodo esta bloqueado.
		c_Err:= ""
		d_TesteData	:=	StoD(o_MovBLote:BAIXASTIT[i]:AUTDTBAIXA)
		If !( f_VldDtMov( "FIN", d_TesteData, @c_Err, "R" ) )
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= c_Err
			Conout("FFIEBW01 - mtdBaixaPorLote: "+c_Err)
			Return(.T.)
		EndIf
		DBSELECTAREA("SA1")
		DBSETORDER(3)
		If !(DBSEEK(XFILIAL("SA1")+Alltrim(o_MovBLote:BAIXASTIT[i]:CGC)))
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "CNPJ/CPF "+Alltrim(o_MovBLote:BAIXASTIT[i]:CGC)+" nao encontrado na base de dados do protheus."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdBaixaPorLote: CNPJ/CPF "+Alltrim(o_MovBLote:BAIXASTIT[i]:CGC)+" nao encontrado na base de dados do protheus.")
			l_Continua:= .F.
			Exit
		Else
			c_CliBx	:= SA1->A1_COD
			c_LojBx	:= SA1->A1_LOJA
		EndIf

		c_PreBx:= PADR(Alltrim(o_MovBLote:BAIXASTIT[i]:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1])
		c_NumBx:= PADR(Alltrim(o_MovBLote:BAIXASTIT[i]:E1_NUM), TAMSX3("E1_NUM")[1])
		c_ParBx:= PADR(Alltrim(o_MovBLote:BAIXASTIT[i]:E1_PARCELA), TAMSX3("E1_PARCELA")[1])
		c_TipBx:= PADR(Alltrim(o_MovBLote:BAIXASTIT[i]:E1_TIPO), TAMSX3("E1_TIPO")[1])

		//Busca o titulo na filial correta
		DBSELECTAREA("SE1")
		DBSETORDER(1)
		If !(DBSEEK(Alltrim(o_MovBLote:BAIXASTIT[i]:E1_FILIAL)+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx))
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "O titulo ("+Alltrim(o_MovBLote:BAIXASTIT[i]:E1_FILIAL)+"-"+c_PreBx+"-"+c_NumBx+"-"+c_ParBx+"-"+c_TipBx+"-"+c_CliBx+"-"+c_LojBx+") da baixa nao encontrado com os parametros passados."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdBaixaPorLote: O titulo ("+Alltrim(o_MovBLote:BAIXASTIT[i]:E1_FILIAL)+"-"+c_PreBx+"-"+c_NumBx+"-"+c_ParBx+"-"+c_TipBx+"-"+c_CliBx+"-"+c_LojBx+") da baixa nao encontrado com os parametros passados.")
			l_Continua:= .F.
			Exit
		EndIf

		//Quando vem do RM valida se ja foi baixado no trecho logo abaixo, fora deste FOR.
		If (SE1->E1_SALDO = 0) .And. Empty(o_MovBLote:BAIXASTIT[i]:XIDBAIXARM)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "O titulo ("+SE1->E1_FILIAL+"-"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+"-"+SE1->E1_TIPO+"-"+SE1->E1_CLIENTE+"-"+SE1->E1_LOJA+") ja foi totalmente baixado."
			Conout("FFIEBW01 - mtdBaixaPorLote: O titulo ("+SE1->E1_FILIAL+"-"+SE1->E1_PREFIXO+"-"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+"-"+SE1->E1_TIPO+"-"+SE1->E1_CLIENTE+"-"+SE1->E1_LOJA+") ja foi totalmente baixado.")
			l_Continua:= .F.
			Exit
		EndIf
	Next

	If (l_Continua == .F.)
		Return(.T.)
	EndIf

	//INICIO  - Validacao adicional do id da baixa.
	l_TemBxRm:= .F.
	For i:= 1 To Len(o_MovBLote:BAIXASTIT)
		If !Empty(o_MovBLote:BAIXASTIT[i]:XIDBAIXARM)
			l_TemBxRm:= .T.
			Exit
		EndIf
	Next
	If (l_TemBxRm)
		c_FSLORM	:=	""
		n_RegExist	:=	0
		n_RegNExist	:=	0
		For i:= 1 To Len(o_MovBLote:BAIXASTIT)
			DBSELECTAREA("SA1")
			DBSETORDER(3)
			DBSEEK(XFILIAL("SA1")+Alltrim(o_MovBLote:BAIXASTIT[i]:CGC))
			c_CliBx		:= SA1->A1_COD
			c_LojBx		:= SA1->A1_LOJA
			c_PreBx		:= PADR(Alltrim(o_MovBLote:BAIXASTIT[i]:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1])
			c_NumBx		:= PADR(Alltrim(o_MovBLote:BAIXASTIT[i]:E1_NUM), TAMSX3("E1_NUM")[1])
			c_ParBx		:= PADR(Alltrim(o_MovBLote:BAIXASTIT[i]:E1_PARCELA), TAMSX3("E1_PARCELA")[1])
			c_TipBx		:= PADR(Alltrim(o_MovBLote:BAIXASTIT[i]:E1_TIPO), TAMSX3("E1_TIPO")[1])
			l_IdBxSe5 	:= f_IDSE5(Alltrim(o_MovBLote:BAIXASTIT[i]:E1_FILIAL), Alltrim(o_MovBLote:BAIXASTIT[i]:XIDBAIXARM), c_PreBx, c_NumBx, c_ParBx, c_TipBx, c_CliBx, c_LojBx, .F., "") //incrementdo para validar existencia do id da baixa na se5
			c_FSLORM	:= PADR(Alltrim(o_MovBLote:BAIXASTIT[i]:E1_FSLORM), TAMSX3("E1_FSLORM")[1])
			If l_IdBxSe5
				n_RegExist++
			Else
				n_RegNExist++
			Endif
		Next

		If n_RegExist == Len(o_MovBLote:BAIXASTIT)
			::o_Retorno:l_Status	:= .T.
			::o_Retorno:c_Mensagem	:= "Lote RM("+Alltrim(c_FSLORM)+") ja existe e ja foi totalmente processado no protheus."
			Conout("FFIEBW01 - mtdBaixaPorLote: Lote RM("+Alltrim(c_FSLORM)+") ja existe e ja foi totalmente processado no protheus.")
			Return(.T.)
		ElseIf n_RegNExist > 0 .And. n_RegNExist < Len(o_MovBLote:BAIXASTIT)
			::o_Retorno:l_Status	:= 	.F.
			::o_Retorno:c_Mensagem	:= 	"Lote RM("+Alltrim(c_FSLORM)+") ja existe mas a baixa esta incompleta, o mesmo deve ser excluido no protheus e reprocessado."
			Conout("FFIEBW01 - mtdBaixaPorLote: Lote RM("+Alltrim(c_FSLORM)+") ja existe mas a baixa esta incompleta, o mesmo deve ser excluido no protheus e reprocessado.")
			Return(.T.)
		Endif
	EndIf
	//FIM  - Validacao adicional do id da baixa.

	//=============================================================== VALIDA OS DADOS DO ARRAY DA MOVIMENTACAO BANCARIA ====================================================
	For i:= 1 To Len(o_MovBLote:MOVBANCA)
		DDATABASE 	:=  StoD(o_MovBLote:MOVBANCA[i]:E5_DATA)
		d_TesteData	:=	StoD(o_MovBLote:MOVBANCA[i]:E5_DATA)
		If valtype(d_TesteData) == "D"
			If Empty(d_TesteData)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Informe Data do movimento no formato [AAAAMMDD]."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdBaixaPorLote: Informe Data do movimento no formato [AAAAMMDD].")
				Return(.T.)
			EndIf
		Else
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Informe Data do movimento no formato [AAAAMMDD]."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdBaixaPorLote: Informe Data do movimento no formato [AAAAMMDD].")
			Return(.T.)
		EndIf
		If (d_TesteData < DDatabase)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Nao eh permitido que seja feita movimentacao em dados anteriores a data base."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdBaixaPorLote: Nao eh permitido que seja feita movimentacao em dados anteriores a data base.")
			Return(.T.)
		EndIf
		//Valida se o periodo esta bloqueado.
		c_Err:= ""
		d_TesteData	:=	StoD(o_MovBLote:MOVBANCA[i]:E5_DATA)
		If !( f_VldDtMov( "FIN", d_TesteData, @c_Err, "" ) )
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= c_Err
			Conout("FFIEBW01 - mtdBaixaPorLote: "+c_Err)
			Return(.T.)
		EndIf
		If Empty(o_MovBLote:MOVBANCA[i]:E5_MOEDA)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Informe a moeda (M1)."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdBaixaPorLote: Informe a moeda (M1).")
			Return(.T.)
		ElseIf Empty(o_MovBLote:MOVBANCA[i]:E5_VALOR)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "O valor do movimento nao pode ser vazio."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdBaixaPorLote: O valor do movimento nao pode ser vazio.")
			Return(.T.)
		ElseIf (o_MovBLote:MOVBANCA[i]:E5_VALOR < 0)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "O valor do movimento nao pode ser menor do que zero."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdBaixaPorLote: O valor do movimento nao pode ser menor do que zero.")
			Return(.T.)
		ElseIf Empty(o_MovBLote:MOVBANCA[i]:E5_NATUREZ)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Informe a natureza."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdBaixaPorLote: Informe a natureza.")
			Return(.T.)
		EndIf
		//Valida a natureza
		dbSelectArea("SED")
		dbSetOrder(1)
		If !(dbSeek(xfilial("SED")+Alltrim(o_MovBLote:MOVBANCA[i]:E5_NATUREZ)))
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Natureza "+Alltrim(o_MovBLote:MOVBANCA[i]:E5_NATUREZ)+" nao encontrada na base de dados do protheus."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdBaixaPorLote: Natureza "+Alltrim(o_MovBLote:MOVBANCA[i]:E5_NATUREZ)+" nao encontrada na base de dados do protheus.")
			Return(.T.)
		EndIf
		If Empty(o_MovBLote:MOVBANCA[i]:E5_BANCO) .Or. Empty(o_MovBLote:MOVBANCA[i]:E5_AGENCIA) .Or. Empty(o_MovBLote:MOVBANCA[i]:E5_CONTA)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Banco/Agencia/Conta nao informados."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdBaixaPorLote: Banco/Agencia/Conta nao informados.")
			Return(.T.)
		EndIf
		c_Ban:= Padr(o_MovBLote:MOVBANCA[i]:E5_BANCO,TamSX3("E5_BANCO")[1])
		c_Age:= Padr(o_MovBLote:MOVBANCA[i]:E5_AGENCIA,TamSX3("E5_AGENCIA")[1])
		c_Con:= Padr(o_MovBLote:MOVBANCA[i]:E5_CONTA,TamSX3("E5_CONTA")[1])
		DBSELECTAREA("SA6")
		DBSETORDER(1)
		If !DBSEEK(xFilial("SA6")+c_Ban+c_Age+c_Con)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "O banco/agencia/conta informado nao existe no cadastro de bancos: "+c_Ban+"/"+c_Age+"/"+c_Con
			Conout("FFIEBW01 - mtdBaixaPorLote: O banco/agencia/conta informado nao existe no cadastro de bancos: "+c_Ban+"/"+c_Age+"/"+c_Con)
			Return(.T.)
		EndIf
		If Empty(o_MovBLote:MOVBANCA[i]:E5_DOCUMEN)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe o documento."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdBaixaPorLote: Informe o documento.")
			Return(.T.)
		ElseIf Empty(o_MovBLote:MOVBANCA[i]:E5_BENEF)
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe o beneficiario."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdBaixaPorLote: Informe o beneficiario.")
			Return(.T.)
		EndIf
		If !Empty(o_MovBLote:MOVBANCA[i]:E5_DEBITO)
			//Validando a conta contabil
			DBSELECTAREA("CT1")
			DBSETORDER(1)
			IF !DBSEEK(xFilial("CT1")+Alltrim(o_MovBLote:MOVBANCA[i]:E5_DEBITO))
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_DEBITO)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+"."
				Conout("FFIEBW01 - mtdBaixaPorLote: Codigo da conta contabil ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_DEBITO)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+".")
				Return(.T.)
			ElseIf CT1->CT1_CLASSE == "1"
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_DEBITO)+") nao pode ser sintetica."
				Conout("FFIEBW01 - mtdBaixaPorLote: Codigo da conta contabil ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_DEBITO)+") nao pode ser sintetica.")
				Return(.T.)
			ElseIf CT1->CT1_BLOQ == "1"
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_DEBITO)+") esta bloqueada para uso."
				Conout("FFIEBW01 - mtdBaixaPorLote: Codigo da conta contabil ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_DEBITO)+")  esta bloqueada para uso.")
				Return(.T.)
			EndIf
		EndIf
		If !Empty(o_MovBLote:MOVBANCA[i]:E5_CREDITO)
			//Validando a conta contabil
			DBSELECTAREA("CT1")
			DBSETORDER(1)
			IF !DBSEEK(xFilial("CT1")+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CREDITO))
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CREDITO)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+"."
				Conout("FFIEBW01 - mtdBaixaPorLote: Codigo da conta contabil ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CREDITO)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+".")
				Return(.T.)
			ElseIf CT1->CT1_CLASSE == "1"
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CREDITO)+") nao pode ser sintetica."
				Conout("FFIEBW01 - mtdBaixaPorLote: Codigo da conta contabil ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CREDITO)+") nao pode ser sintetica.")
				Return(.T.)
			ElseIf CT1->CT1_BLOQ == "1"
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CREDITO)+") esta bloqueada para uso."
				Conout("FFIEBW01 - mtdBaixaPorLote: Codigo da conta contabil ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CREDITO)+")  esta bloqueada para uso.")
				Return(.T.)
			EndIf
		EndIf
		If !Empty(o_MovBLote:MOVBANCA[i]:E5_CCD)
			//Validando o centro de custo
			DbSelectArea("CTT")
			CTT->(dbSetOrder(1))
			If !(CTT->(dbSeek(xFilial("CTT")+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CCD))))
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Centro de Custo informado para o campo E5_CCD invalido ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CCD)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdBaixaPorLote: Centro de Custo informado para o campo E5_CCD invalido ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CCD)+").")
				Return(.T.)
			Elseif CTT->CTT_CLASSE == "1"
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Centro de Custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CCD)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdBaixaPorLote: Centro de Custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CCD)+").")
				Return(.T.)
			Elseif CTT->CTT_BLOQ == "1"
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Centro de Custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CCD)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdBaixaPorLote: Centro de Custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CCD)+").")
				Return(.T.)
			Endif
		EndIf
		If !Empty(o_MovBLote:MOVBANCA[i]:E5_CCC)
			//Validando o centro de custo
			DbSelectArea("CTT")
			CTT->(dbSetOrder(1))
			If !(CTT->(dbSeek(xFilial("CTT")+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CCC))))
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Centro de Custo informado para o campo E5_CCC invalido ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CCC)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdBaixaPorLote: Centro de Custo informado para o campo E5_CCC invalido ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CCC)+").")
				Return(.T.)
			Elseif CTT->CTT_CLASSE == "1"
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Centro de Custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CCC)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdBaixaPorLote: Centro de Custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CCC)+").")
				Return(.T.)
			Elseif CTT->CTT_BLOQ == "1"
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Centro de Custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CCC)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdBaixaPorLote: Centro de Custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CCC)+").")
				Return(.T.)
			Endif
		EndIf
		//Validando o item contabil
		If !Empty(o_MovBLote:MOVBANCA[i]:E5_ITEMD)
			DbSelectArea("CTD")
			CTD->(dbSetOrder(1))
			If !(CTD->(dbSeek(xFilial("CTD")+Alltrim(o_MovBLote:MOVBANCA[i]:E5_ITEMD))))
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Item contabil informado para o campo E5_ITEMD invalido ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_ITEMD)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdBaixaPorLote: Item contabil informado para o campo E5_ITEMD invalido ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_ITEMD)+").")
				Return(.T.)

			Elseif CTD->CTD_CLASSE == "1"
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Item contabil invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_ITEMD)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdBaixaPorLote: Item contabil invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_ITEMD)+").")
				Return(.T.)
			Elseif CTD->CTD_BLOQ == "1" .or. (!Empty(CTD->CTD_DTEXSF) .and. CTD->CTD_DTEXSF < dDatabase)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Item contabil invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_ITEMD)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdBaixaPorLote: Item contabil invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_ITEMD)+").")
				Return(.T.)
			ElseIf (!Empty(CTD->CTD_DTEXIS) .and. dDatabase < CTD->CTD_DTEXIS)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Item contabil ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_ITEMD)+") esta com data de inicio de existencia superior a data base."+CHR(13)+CHR(10)
				Return(.T.)
			Endif
		EndIf
		//Validando o item contabil
		If !Empty(o_MovBLote:MOVBANCA[i]:E5_ITEMC)
			DbSelectArea("CTD")
			CTD->(dbSetOrder(1))
			If !(CTD->(dbSeek(xFilial("CTD")+Alltrim(o_MovBLote:MOVBANCA[i]:E5_ITEMC))))
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Item contabil informado para o campo E5_ITEMC invalido ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_ITEMC)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdBaixaPorLote: Item contabil informado para o campo E5_ITEMC invalido ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_ITEMC)+").")
				Return(.T.)
			Elseif CTD->CTD_CLASSE == "1"
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Item contabil invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_ITEMC)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdBaixaPorLote: Item contabil invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_ITEMC)+").")
				Return(.T.)
			Elseif CTD->CTD_BLOQ == "1" .or. (!Empty(CTD->CTD_DTEXSF) .and. CTD->CTD_DTEXSF < dDatabase)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Item contabil invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_ITEMC)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdBaixaPorLote: Item contabil invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_ITEMC)+").")
				Return(.T.)
			ElseIf (!Empty(CTD->CTD_DTEXIS) .and. dDatabase < CTD->CTD_DTEXIS)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Item contabil ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_ITEMC)+") esta com data de inicio de existencia superior a data base."+CHR(13)+CHR(10)
				Return(.T.)
			Endif
		EndIf
		If !Empty(o_MovBLote:MOVBANCA[i]:E5_CLVLDB)
			//Validando a classe de valor
			DbSelectArea("CTH")
			CTH->(dbSetOrder(1))
			If !(CTH->(dbSeek(xFilial("CTH")+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CLVLDB))))
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Classe de valor informado para o campo E5_CLVLDB invalido ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CLVLDB)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdBaixaPorLote: Classe de valor informado para o campo E5_CLVLDB invalido ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CLVLDB)+").")
				Return(.T.)
			Elseif CTH->CTH_CLASSE == "1"
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Classe de valor invalido. O Classe de valor nao pode ser sintetico ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CLVLDB)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdBaixaPorLote: Classe de valor invalido. O Classe de valor nao pode ser sintetico ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CLVLDB)+").")
				Return(.T.)
			Elseif CTH->CTH_BLOQ == "1"
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Classe de valor invalido. o Classe de valor esta bloqueado para uso ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CLVLDB)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdBaixaPorLote: Classe de valor invalido. o Classe de valor esta bloqueado para uso ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CLVLDB)+").")
				Return(.T.)
			Endif
		EndIf
		If !Empty(o_MovBLote:MOVBANCA[i]:E5_CLVLCR)
			//Validando a classe de valor
			DbSelectArea("CTH")
			CTH->(dbSetOrder(1))
			If !(CTH->(dbSeek(xFilial("CTH")+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CLVLCR))))
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Classe de valor informado para o campo E5_CLVLCR invalido ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CLVLCR)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdBaixaPorLote: Classe de valor informado para o campo E5_CLVLCR invalido ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CLVLCR)+").")
				Return(.T.)
			Elseif CTH->CTH_CLASSE == "1"
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Classe de valor invalido. O Classe de valor nao pode ser sintetico ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CLVLCR)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdBaixaPorLote: Classe de valor invalido. O Classe de valor nao pode ser sintetico ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CLVLCR)+").")
				Return(.T.)
			Elseif CTH->CTH_BLOQ == "1"
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Classe de valor invalido. o Classe de valor esta bloqueado para uso ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CLVLCR)+")."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdBaixaPorLote: Classe de valor invalido. o Classe de valor esta bloqueado para uso ("+Alltrim(o_MovBLote:MOVBANCA[i]:E5_CLVLCR)+").")
				Return(.T.)
			Endif
		EndIf
		//Valida se a conta comeca com 32 e o Cr possui o campo CTD_XRTADM = 2=Consumo;3=Corporativo;4=Unid. Compartilhadas 14/02/2019
		If !Empty( o_MovBLote:MOVBANCA[i]:E5_DEBITO ) .And. !Empty( o_MovBLote:MOVBANCA[i]:E5_ITEMD )
			c_ErrMsg:= ""
			If !( f_VldCnInvest( Alltrim( o_MovBLote:MOVBANCA[i]:E5_DEBITO ), Alltrim( o_MovBLote:MOVBANCA[i]:E5_ITEMD ), @c_ErrMsg ) )
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= c_ErrMsg
				Conout("FFIEBW01 - mtdBaixaPorLote: "+c_ErrMsg)
				Return(.T.)
			EndIf
		EndIf
		//Valida se a conta comeca com 32 e o Cr possui o campo CTD_XRTADM = 2=Consumo;3=Corporativo;4=Unid. Compartilhadas 14/02/2019
		If !Empty( o_MovBLote:MOVBANCA[i]:E5_CREDITO ) .And. !Empty( o_MovBLote:MOVBANCA[i]:E5_ITEMC )
			c_ErrMsg:= ""
			If !( f_VldCnInvest( Alltrim( o_MovBLote:MOVBANCA[i]:E5_CREDITO ), Alltrim( o_MovBLote:MOVBANCA[i]:E5_ITEMC ), @c_ErrMsg ) )
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= c_ErrMsg
				Conout("FFIEBW01 - mtdBaixaPorLote: "+c_ErrMsg)
				Return(.T.)
			EndIf
		EndIf
	Next
	//====================================================== FIM DA VALIDACAO DOS DADOS DO ARRAY DA MOVIMENTACAO BANCARIA ====================================================
	If (l_Continua)
		l_Erro:= .F.
		//c_Baixados:= ""

		Begin Transaction
			For i:= 1 To Len(o_MovBLote:BAIXASTIT)
				c_CliBx	:= ""
				c_LojBx	:= ""
				a_Baixa	:= {}

				//Posiciona na empresa e filial de destino
				dbSelectArea("SM0")
				dbSeek(o_Empresa:c_Empresa+Alltrim(o_MovBLote:BAIXASTIT[i]:E1_FILIAL))
				cFilAnt:= Alltrim(o_MovBLote:BAIXASTIT[i]:E1_FILIAL)

				DBSELECTAREA("SA1")
				DBSETORDER(3)
				If DBSEEK(XFILIAL("SA1")+Alltrim(o_MovBLote:BAIXASTIT[i]:CGC))
					c_CliBx	:= SA1->A1_COD
					c_LojBx	:= SA1->A1_LOJA
				EndIf

				c_PreBx		:= PADR(Alltrim(o_MovBLote:BAIXASTIT[i]:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1])
				c_NumBx		:= PADR(Alltrim(o_MovBLote:BAIXASTIT[i]:E1_NUM), TAMSX3("E1_NUM")[1])
				c_ParBx		:= PADR(Alltrim(o_MovBLote:BAIXASTIT[i]:E1_PARCELA), TAMSX3("E1_PARCELA")[1])
				c_TipBx		:= PADR(Alltrim(o_MovBLote:BAIXASTIT[i]:E1_TIPO), TAMSX3("E1_TIPO")[1])
				c_xNumRM	:= PADR(Alltrim(o_MovBLote:BAIXASTIT[i]:E5_XNUMRM), TAMSX3("E5_XNUMRM")[1])

				//Busca o titulo na filial correta
				DBSELECTAREA("SE1")
				DBSETORDER(1)
				DBSEEK(Alltrim(o_MovBLote:BAIXASTIT[i]:E1_FILIAL)+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx)

				c_Ban		:= Padr(o_MovBLote:BAIXASTIT[i]:AUTBANCO,TamSX3("E1_PORTADO")[1])
				c_Age		:= Padr(o_MovBLote:BAIXASTIT[i]:AUTAGENCIA,TamSX3("E5_AGENCIA")[1])
				c_Con		:= Padr(o_MovBLote:BAIXASTIT[i]:AUTCONTA,TamSX3("E5_CONTA")[1])

				DDATABASE 	:= STOD(o_MovBLote:BAIXASTIT[i]:AUTDTBAIXA)
				c_MotBx   	:= Alltrim(o_MovBLote:BAIXASTIT[i]:AUTMOTBX)
				d_DtBaixa 	:= STOD(o_MovBLote:BAIXASTIT[i]:AUTDTBAIXA)
				d_DtCred  	:= STOD(o_MovBLote:BAIXASTIT[i]:AUTDTCREDITO)
				c_Hist    	:= PADR(Alltrim(o_MovBLote:BAIXASTIT[i]:AUTHIST), TAMSX3("E5_HISTOR")[1])
				n_Descont 	:= o_MovBLote:BAIXASTIT[i]:AUTDESCONT
				n_Multa   	:= o_MovBLote:BAIXASTIT[i]:AUTMULTA
				n_Juros   	:= o_MovBLote:BAIXASTIT[i]:AUTJUROS
				n_ValRec  	:= o_MovBLote:BAIXASTIT[i]:AUTVALREC
				n_Acres   	:= o_MovBLote:BAIXASTIT[i]:AUTACRESC
				n_Decres  	:= o_MovBLote:BAIXASTIT[i]:AUTDECRESC

				a_Baixa := {{"E1_PREFIXO"  	,PADR(c_PreBx	, TAMSX3("E1_PREFIXO")[1])	,Nil},;
							{"E1_NUM"		,PADR(c_NumBx	, TAMSX3("E1_NUM")[1])		,Nil},;
							{"E1_PARCELA"	,PADR(c_ParBx	, TAMSX3("E1_PARCELA")[1])	,Nil},;
							{"E1_TIPO"		,PADR(c_TipBx	, TAMSX3("E1_TIPO")[1])		,Nil},;
							{"E1_CLIENTE"	,PADR(c_CliBx	, TAMSX3("E1_CLIENTE")[1])	,Nil},;
							{"E1_LOJA"		,PADR(c_LojBx	, TAMSX3("E1_LOJA")[1])		,Nil},;
							{"AUTMOTBX"		,PADR(c_MotBx	, TAMSX3("E5_MOTBX")[1])	,Nil},;
							{"AUTBANCO"		,c_Ban		,Nil},;
							{"AUTAGENCIA"	,c_Age		,Nil},;
							{"AUTCONTA"		,c_Con		,Nil},;
							{"AUTDTBAIXA"	,d_DtBaixa	,Nil},;
							{"AUTDTCREDITO"	,d_DtCred	,Nil},;
							{"AUTHIST"		,c_Hist		,Nil},;
							{"AUTDESCONT"  	,n_Descont	,Nil,.T.},;
							{"AUTMULTA"  	,n_Multa	,Nil,.T.},;
							{"AUTJUROS"  	,n_Juros	,Nil,.T.},;
							{"AUTACRESC"  	,n_Acres	,Nil,.T.},;
							{"AUTDECRESC"  	,n_Decres	,Nil,.T.},;
							{"AUTVALREC"	,n_ValRec	,Nil}}

				//INCLUI         := .T.
				lMsErroAuto    := .F.
				lMsHelpAuto    := .T.
				lAutoErrNoFile := .T.

				//3 - Baixa de Titulo
				MSExecAuto( {|n,x,y,z| Fina070(n,x,y,z)}, a_Baixa, 3, lNoMbrowse, nOpbaixa )
				If lMsErroAuto
					l_Erro:= .T.
					Exit
				Else
					c_SeqBai:= SE5->E5_SEQ
					c_FilError := PADR( Alltrim(o_MovBLote:BAIXASTIT[i]:E1_FILIAL), TAMSX3("E1_FILIAL")[1] )
					//Grava o lote
					DBSELECTAREA("SE1")
					DBSETORDER(1)
					If (DBSEEK(c_FilError+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx))
						RecLock("SE1",.F.)
						SE1->E1_LOTE	:= PADR(Alltrim(o_MovBLote:BAIXASTIT[i]:E1_LOTE), TAMSX3("E1_LOTE")[1])
						SE1->E1_FSLORM	:= PADR(Alltrim(o_MovBLote:BAIXASTIT[i]:E1_FSLORM), TAMSX3("E1_FSLORM")[1])
						MsUnLock()

						//23/04/2019 - Para os titulos do RM verifica se esta no status de perda e chama a contabilizacao reversa - Fluxo de Cobranca
						If (Alltrim(c_PreBx) = "RM") //Apenas para os titulos com prefixo RM, pq vem o ID da baixa do RM
							//Adriano 29/03/2019 - Tratamento para gerar a contabilizacao reversa de titulos de perda - Fluxo de Cobranca.
							//Para funcionar tem que compilar o fonte FINA09O
							If ExistBlock("FINA09O") .And. ( Alltrim(SE1->E1_XSTTTCB) == '5' ) //Perda
								//O LP 230 foi criado especificamente para essa finalidade.
								CUSUARIO:= "123456WS " //Fiz isso para gravar WS no LP pois eh usado a variavel cusuario no LP 230
								u_GrvCtbReversa("230") //Funcao declarada no PRW FINA09O - Rotina de Fluxo de Cobranca
							Endif
						EndIf

					EndIf
					//Grava o lote
					DBSELECTAREA("SE5")
					DBSETORDER(7)
					If Dbseek(Alltrim(o_MovBLote:BAIXASTIT[i]:E1_FILIAL)+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx)
						While !(SE5->(Eof())) .And. (SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA == Alltrim(o_MovBLote:BAIXASTIT[i]:E1_FILIAL)+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx)
							If Alltrim(SE5->E5_SEQ) == Alltrim(c_SeqBai)
								If Empty(SE5->E5_SITUACA) .And. (Alltrim(SE5->E5_RECPAG) = 'R') .And. ( (Alltrim(SE5->E5_TIPODOC) = 'VL') .OR. (Alltrim(SE5->E5_TIPODOC) = 'BA') .OR. (Alltrim(SE5->E5_TIPODOC) = 'MT') .OR. (Alltrim(SE5->E5_TIPODOC) = 'JR') .OR. (SE5->E5_TIPODOC = 'DC') )
									Reclock("SE5",.F.)
									SE5->E5_LOTE	:= PADR(Alltrim(o_MovBLote:BAIXASTIT[i]:E1_LOTE), TAMSX3("E1_LOTE")[1])
									SE5->E5_FSLORM	:= PADR(Alltrim(o_MovBLote:BAIXASTIT[i]:E1_FSLORM), TAMSX3("E1_FSLORM")[1])
									SE5->E5_DOCUMEN	:= Alltrim(c_NumBx)
									SE5->E5_XNUMRM	:= PADR( c_xNumRM, TAMSX3( "E5_XNUMRM" )[ 1 ] ) //Grava o numero do RM na baixa por lote
									SE5->E5_FSBXRM 	:= Alltrim(o_MovBLote:BAIXASTIT[i]:XIDBAIXARM) //id da baixa do RM
                                    SE5->E5_LA   	:= "S"
                                    
                                    //Solicitacao em 12/05/2020 - Gravar o ban/age/conta mesmo que o motivo de baixao mov. banco
                                    //Item da planilha que Bruno Bouzas passou
                                    SE5->E5_BANCO	:= c_Ban
                                    SE5->E5_AGENCIA	:= c_Age
                                    SE5->E5_CONTA	:= c_Con
									MsUnlock()
								
									dbSelectArea("FK1")
								    dbSetOrder(1)
									dbSeek(xFilial("FK1")+SE5->E5_IDORIG)

									If !Eof()
									   Reclock("FK1",.F.)
									   FK1->FK1_LA := "S"
									   MsUnlock()
									EndIf
										
									dbSelectArea("SE5")
								EndIf
							EndIf
							
							//Inserido para forcar gravacao do LA para titulos do Tipo RM
							If Alltrim(SE5->E5_PREFIXO) == "RM" .And. SE5->E5_LA <> "S"
								f_GravaLA( SE5->E5_FILIAL, SE5->E5_NUMERO, SE5->E5_FSBXRM )	
							Endif
							
							SE5->(DbSkip())
						EndDo
					EndIf
					//c_Baixados+= Alltrim(o_MovBLote:BAIXASTIT[i]:E1_FILIAL)+"-"+c_PreBx+"-"+c_NumBx+"-"+c_ParBx+"-"+c_TipBx+"-"+c_CliBx+"-"+c_LojBx
				EndIf
			Next
			If (lMsErroAuto) .And. (l_Erro)
				//Se deu erro no execauto, desarma a transacao
				DisarmTransaction()
				Break
			Else
				For i:= 1 To Len(o_MovBLote:MOVBANCA)
					//Posiciona na empresa e filial de destino
					dbSelectArea("SM0")
					dbSeek(o_Empresa:c_Empresa+Alltrim(o_Empresa:c_Filial))
					cFilAnt:= Alltrim(o_Empresa:c_Filial)
					DDATABASE 	:= StoD(o_MovBLote:MOVBANCA[i]:E5_DATA)

					aVetor		:= {}
					aAdd( aVetor, {"E5_FILIAL"	,o_Empresa:c_Filial	,Nil})
					aAdd( aVetor, {"E5_DATA" 	,StoD(o_MovBLote:MOVBANCA[i]:E5_DATA) , Nil})
					aAdd( aVetor, {"E5_MOEDA" 	,PADR(Alltrim(o_MovBLote:MOVBANCA[i]:E5_MOEDA)	, TAMSX3("E5_MOEDA")[1]) 	,Nil})
					aAdd( aVetor, {"E5_VALOR" 	,o_MovBLote:MOVBANCA[i]:E5_VALOR,Nil})
					aAdd( aVetor, {"E5_NATUREZ"	,PADR("NATMOVR"	, TAMSX3("E5_NATUREZ")[1])	,Nil})
					aAdd( aVetor, {"E5_BANCO" 	,PADR(Alltrim(o_MovBLote:MOVBANCA[i]:E5_BANCO)	, TAMSX3("E5_BANCO")[1]) 	,Nil})
					aAdd( aVetor, {"E5_AGENCIA" ,PADR(Alltrim(o_MovBLote:MOVBANCA[i]:E5_AGENCIA)	, TAMSX3("E5_AGENCIA")[1]) 	,Nil})
					aAdd( aVetor, {"E5_CONTA" 	,PADR(Alltrim(o_MovBLote:MOVBANCA[i]:E5_CONTA)	, TAMSX3("E5_CONTA")[1]) 	,Nil})
					aAdd( aVetor, {"E5_NUMCHEQ" ,PADR(Alltrim(o_MovBLote:MOVBANCA[i]:E5_NUMCHEQ)	, TAMSX3("E5_NUMCHEQ")[1]) 	,Nil})
					aAdd( aVetor, {"E5_DOCUMEN" ,PADR(Alltrim(o_MovBLote:MOVBANCA[i]:E5_DOCUMEN), TAMSX3("E5_DOCUMENT")[1]) ,Nil})
					aAdd( aVetor, {"E5_BENEF" 	,PADR(Alltrim(o_MovBLote:MOVBANCA[i]:E5_BENEF)	, TAMSX3("E5_BENEF")[1]) 	,Nil})
					aAdd( aVetor, {"E5_HISTOR" 	,PADR(Alltrim(o_MovBLote:MOVBANCA[i]:E5_HISTOR)	, TAMSX3("E5_HISTOR")[1]) 	,Nil})
					aAdd( aVetor, {"E5_LA" 		,"S" 	,Nil})
					If !Empty(o_MovBLote:MOVBANCA[i]:E5_DEBITO)
						aAdd( aVetor, {"E5_DEBITO" 	,PADR(Alltrim(o_MovBLote:MOVBANCA[i]:E5_DEBITO)	, TAMSX3("E5_DEBITO")[1]) 	,Nil})
					EndIf
					If !Empty(o_MovBLote:MOVBANCA[i]:E5_CREDITO)
						aAdd( aVetor, {"E5_CREDITO" ,PADR(Alltrim(o_MovBLote:MOVBANCA[i]:E5_CREDITO)	, TAMSX3("E5_CREDITO")[1]) 	,Nil})
					EndIf
					If !Empty(o_MovBLote:MOVBANCA[i]:E5_CCD)
						aAdd( aVetor, {"E5_CCD" 	,PADR(Alltrim(o_MovBLote:MOVBANCA[i]:E5_CCD)		, TAMSX3("E5_CCD")[1]) 		,Nil})
					EndIf
					If !Empty(o_MovBLote:MOVBANCA[i]:E5_CCC)
						aAdd( aVetor, {"E5_CCC" 	,PADR(Alltrim(o_MovBLote:MOVBANCA[i]:E5_CCC)		, TAMSX3("E5_CCC")[1]) 		,Nil})
					EndIf
					If !Empty(o_MovBLote:MOVBANCA[i]:E5_ITEMD)
						aAdd( aVetor, {"E5_ITEMD" 	,PADR(Alltrim(o_MovBLote:MOVBANCA[i]:E5_ITEMD)	, TAMSX3("E5_ITEMD")[1]) 	,Nil})
					EndIf
					If !Empty(o_MovBLote:MOVBANCA[i]:E5_ITEMC)
						aAdd( aVetor, {"E5_ITEMC" 	,PADR(Alltrim(o_MovBLote:MOVBANCA[i]:E5_ITEMC)	, TAMSX3("E5_ITEMC")[1]) 	,Nil})
					EndIf
					If !Empty(o_MovBLote:MOVBANCA[i]:E5_CLVLDB)
						aAdd( aVetor, {"E5_CLVLDB" 	,PADR(Alltrim(o_MovBLote:MOVBANCA[i]:E5_CLVLDB)	, TAMSX3("E5_CLVLDB")[1]) 	,Nil})
					EndIf
					If !Empty(o_MovBLote:MOVBANCA[i]:E5_CLVLCR)
						aAdd( aVetor, {"E5_CLVLCR" 	,PADR(Alltrim(o_MovBLote:MOVBANCA[i]:E5_CLVLCR)	, TAMSX3("E5_CLVLCR")[1]) 	,Nil})
					EndIf
					If !Empty(o_MovBLote:MOVBANCA[i]:E5_LOTE)
						aAdd( aVetor, {"E5_LOTE" 	,PADR(Alltrim(o_MovBLote:MOVBANCA[i]:E5_LOTE)	, TAMSX3("E5_LOTE")[1]) 	,Nil})
					EndIf
					If !Empty(o_MovBLote:MOVBANCA[i]:E5_FSLORM)
						aAdd( aVetor, {"E5_FSLORM" 	,PADR(Alltrim(o_MovBLote:MOVBANCA[i]:E5_FSLORM)	, TAMSX3("E5_FSLORM")[1]) 	,Nil})
					EndIf

					Pergunte ("AFI100",.F.)
					MV_PAR01:= 2
					MV_PAR02:= 2
					MV_PAR03:= 2
					MV_PAR04:= 2

					lMsErroAuto		:= .F.
					lMsHelpAuto		:= .T.
					lAutoErrNoFile	:= .T.

					aLogErr			:= {}
					aLogErr2		:= {}

					MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aVetor,4) //4= Mov. a Receber

					If lMsErroAuto
						l_Erro:= .T.
						Exit
					Else
						//
					EndIf
				Next
				If !(l_Erro)
					::o_Retorno:l_Status	:= .T.
					::o_Retorno:c_Mensagem	:= "Titulos baixados e movimento bancario no valor total, criado."
					Conout("FFIEBW01 - mtdBaixaPorLote: Titulos baixados e movimento bancario no valor total, criado.")
				Else
					//Se deu erro no execauto da criacao do novo titulo, desarma atransacao
					DisarmTransaction()
					Break
				EndIf
			EndIf
		End Transaction
		//Se deu erro no Execauto
		If (lMsErroAuto) .And. (l_Erro)
			//Regra do fonte SIESBA01 da FIEB
			If (__lSX8)
				RollBackSX8()
			EndIf

			// Tratamento da Mensagem de erro do MSExecAuto
			aLogErr  := GetAutoGRLog()
			aLogErr2 := f_TrataErro(aLogErr)
			_cMotivo := ""

			For i := 1 to Len(aLogErr2)
				_cMotivo += aLogErr2[i]
			Next

			_cMotivo += chr(13) + chr(10)
			_cMotivo += "Chave do Titulo: " + c_FilError + c_PreBx + c_NumBx + c_ParBx + c_TipBx + c_CliBx + c_LojBx

			//Exclusivo para a versao 12
			If (GetVersao(.F.) == "12")
				_cMotivo:=  NoAcentoESB(_cMotivo)
				SetSoapFault('Erro',_cMotivo)
			EndIf
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= NoAcentoESB(_cMotivo)
			Conout("FFIEBW01 - mtdBaixaPorLote: "+NoAcentoESB(_cMotivo))
		Else
			//Verifica se houveram as baixas
			If(::o_Retorno:l_Status == .T.)
				For p:= 1 To Len(o_MovBLote:BAIXASTIT)
					If !Empty(o_MovBLote:BAIXASTIT[p]:XIDBAIXARM) //Se mandou o Id da baixa do Rm
						c_PreBx	:= PADR(Alltrim(o_MovBLote:BAIXASTIT[p]:E1_PREFIXO), TAMSX3("E1_PREFIXO")[1])
						c_NumBx	:= PADR(Alltrim(o_MovBLote:BAIXASTIT[p]:E1_NUM), TAMSX3("E1_NUM")[1])
						c_ParBx	:= PADR(Alltrim(o_MovBLote:BAIXASTIT[p]:E1_PARCELA), TAMSX3("E1_PARCELA")[1])
						c_TipBx	:= PADR(Alltrim(o_MovBLote:BAIXASTIT[p]:E1_TIPO), TAMSX3("E1_TIPO")[1])
						DBSELECTAREA("SA1")
						DBSETORDER(3)
						If (DBSEEK(XFILIAL("SA1")+Alltrim(o_MovBLote:BAIXASTIT[p]:CGC)))
							c_CliBx	:= SA1->A1_COD
							c_LojBx	:= SA1->A1_LOJA
						EndIf
						If (Alltrim(c_PreBx) = "RM") //Apenas para os titulos com prefixo RM, pq vem o ID da baixa do RM
							l_Encont:= .F.
							//Verifica se a baixa existe
							DBSELECTAREA("SE5")
							DBSETORDER(7)
							If Dbseek(xFilial("SE5")+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx)
								While !(SE5->(Eof())) .And. (SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA == xFilial("SE5")+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_CliBx+c_LojBx)
									If (Alltrim(SE5->E5_FSBXRM) == Alltrim(o_MovBLote:BAIXASTIT[p]:XIDBAIXARM)) //id da baixa do RM
										If Empty(SE5->E5_DTCANBX) .And. Empty(SE5->E5_SITUACA) //Retira os movimentos cancelados
											If (Alltrim(SE5->E5_ORIGEM) = 'RPC')
												l_Encont:= .T.
												Exit
											EndIf
										EndIf
									EndIf
									SE5->(DbSkip())
								EndDo
								If !(l_Encont)
									::o_Retorno:l_Status	:= .F.
									::o_Retorno:c_Mensagem	:= "### BAIXA POR LOTE - Id da baixa "+Alltrim(o_MovBLote:BAIXASTIT[p]:XIDBAIXARM)+" do titulo "+Alltrim(c_NumBx)+" na filial "+o_Empresa:c_Filial+" nao encontrado apos o processo de baixa. Possivelmente ocorreu algum rollback na transacao. Necessario enviar a baixa novamente. ###"+CHR(13)+CHR(10)
									Exit
								EndIf
							EndIf
						EndIf
					EndIf
				Next
			EndIf
		EndIf
	EndIf
	//RpcClearEnv() //Limpa o ambiente, liberando a licenca e fechando as conexoes

RETURN(.T.)
/*/{Protheus.doc} mtdDocEntrada
Metodo de gravacao do documento de entrada
@author Totvs-BA
@since 14/05/2018
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSMETHOD mtdDocEntrada WSRECEIVE o_Seguranca, o_Empresa, o_DocEntr, Operacao WSSEND o_Retorno WSSERVICE FFIEBW01

	Local n_Operacao	:= Val(::Operacao)
	Local aCabec 		:= {}
	Local aItens 		:= {}
	Local aLinha 		:= {}
	Local aColsCC 		:= {}
	//Local c_TES			:= ""
	Local c_CF			:= ""
	Local p,i,nX,x
	Local _aTotRat		:= {}
	Local _aRateio		:= {}
	Local _cItemPV		:= ""
	Local _lRateio		:= .F.
	Local d_Emissao		:= ""
	Local d_DtLan		:= ""
	Local d_DtDig		:= ""
    Local n_VlrNf		:= 0
	Local cMsgError		:= ""
	Local a_Itens		:= {}
	Local l_RetZJW		:= .T.
	Local c_Objeto		:= ""
	Local c_Entida		:= ""
	Local c_CodObj		:= ""
	Local l_ForISS		:= .F.
	Local l_NatISS		:= .F.
	Local l_TESISS		:= .F.
	Local l_ProISS		:= .F.
	//Local c_ErrWS		:= ""
	Local c_Tipo		:= ""
	Local d_Emis		:= ""
	Local l_TemDistrib	:= .F.
	Local n_TotItens	:= 0
	Local n_TDisItens	:= 0
	Local n_TVlrDisIt	:= 0 //total do valor do item da distribuicao
	Local n_TPerDisIt	:= 0 //total do percentual do item da distribuicao
	Local c_ErrMsg		:= ""

	Private c_Fil		:= ""
	Private c_Doc		:= ""
	Private c_Ser		:= ""
	Private c_Esp		:= ""
	Private c_For		:= ""
	Private c_Loj		:= ""
	Private l_TemISS	:= .F.
	Private d_EmiNota	:= ""
	Private c_WSEst		:= ""
	Private c_WSCodMun	:= ""
	Private lMsHelpAuto := .T.
	Private lMsErroAuto := .F.
	PRIVATE l_WebService:= .T.
	Private a_SEVWs		:= {}

	::o_Retorno	:= WSCLASSNEW("strRetorno")

	If !(f_VldFilEmp(o_Empresa:c_Empresa,o_Empresa:c_Filial))
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Codigo de Empresa/Filial nao existe."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdDocEntrada: Codigo de Empresa/Filial nao existe.")
		Return(.T.)
	EndIf
	//Loga na filial solicitada
	RpcSetType(3)
	RpcSetEnv(o_Empresa:c_Empresa,o_Empresa:c_Filial, "integracao", "fieb123")

	//Posiciona na empresa e filial passada
	dbSelectArea("SM0")
	dbSeek(o_Empresa:c_Empresa+o_Empresa:c_Filial)

	cFilAnt:= o_Empresa:c_Filial

	c_UserWS	:= Upper(ALLTRIM(SUPERGETMV("FS_FIUSRWS",,"totvs_fieb")))
	c_PswWS		:= Upper(ALLTRIM(SUPERGETMV("FS_FIPSWWS",,"totvs@123")))

	//Validando o usuario e senha
	If ( Upper(o_Seguranca:c_Usuario) <> Upper(c_UserWS) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdDocEntrada: Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido.")
		Return(.T.)
	ElseIf ( Upper(o_Seguranca:c_Senha) <> Upper(c_PswWS) )
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdDocEntrada: Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida.")
		Return(.T.)
	EndIf
	If (n_Operacao <> 3) //.And. (n_Operacao <> 5)
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Valor passado no parametro Operacao ("+cValToChar(n_Operacao)+") invalido. Informar (3=Inclusao)."//; 5=Exclusao)."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdDocEntrada: Valor passado no parametro Operacao ("+cValToChar(n_Operacao)+") invalido. Informar (3=Inclusao).")//; 5=Exclusao).")
		Return(.T.)
	EndIf
	If Empty(o_DocEntr:F1_DOC)
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Informe o numero da nota."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdDocEntrada: Informe o numero da nota.")
		Return(.T.)
	Else
		//Valida se tem caracter especial. 05/02/2019
		If !f_VldCaracter( Alltrim(o_DocEntr:F1_DOC) )
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "O numero da nota nao pode conter caracteres especiais.( "+Alltrim(o_DocEntr:F1_DOC)+" )"+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdDocEntrada: Informe o numero da nota.")
			Return(.T.)
		EndIf
	EndIf
	If Empty(o_DocEntr:F1_SERIE)
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Informe a serie da nota."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdDocEntrada: Informe a serie da nota.")
		Return(.T.)
	EndIf
	If Empty(o_DocEntr:CGC)
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Informe o CGC."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdDocEntrada: Informe o CGC.")
		Return(.T.)
	EndIf
	DBSELECTAREA("SA2")
	DBSETORDER(3)
	If !(DBSEEK(XFILIAL("SA2")+Alltrim(o_DocEntr:CGC)))
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "CNPJ/CPF "+Alltrim(o_DocEntr:CGC)+" nao encontrado na base de dados do protheus."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdDocEntrada: CNPJ/CPF "+Alltrim(o_DocEntr:CGC)+" nao encontrado na base de dados do protheus.")
		Return(.T.)
	Else
		l_ForISS:= .F.
		c_For	:= SA2->A2_COD
		c_Loj	:= SA2->A2_LOJA
		If (Alltrim(SA2->A2_RECISS) = 'N') //Verifica se o fonecedor nao recolhe ISS
			l_ForISS:= .T.
		EndIf
	EndIf
	c_Doc:= PADR(Alltrim(o_DocEntr:F1_DOC), TAMSX3("F1_DOC")[1])
	c_Ser:= PADR(Alltrim(o_DocEntr:F1_SERIE), TAMSX3("F1_SERIE")[1])

	If (n_Operacao = 3)
		DBSELECTAREA("SF1")
		DBSETORDER(1)
		If (DBSEEK(XFILIAL("SF1")+c_Doc+c_Ser+c_For+c_Loj))
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Nota/Serie "+Alltrim(o_DocEntr:F1_DOC)+"/"+Alltrim(o_DocEntr:F1_SERIE)+"/"+c_For+"/"+c_Loj+" ja existe na filial: "+o_Empresa:c_Filial+"."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdDocEntrada: Nota/Serie "+Alltrim(o_DocEntr:F1_DOC)+"/"+Alltrim(o_DocEntr:F1_SERIE)+"/"+c_For+"/"+c_Loj+" ja existe na filial: "+o_Empresa:c_Filial+".")
			Return(.T.)
		EndIf
	EndIf
	If Empty(o_DocEntr:F1_TIPO)
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Informe o tipo de nota."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdDocEntrada: Informe o tipo de nota.")
		Return(.T.)
	EndIf
	If (Upper(Alltrim(o_DocEntr:F1_TIPO)) <> 'N')
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "O tipo da nota tem que ser 'N'."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdDocEntrada: O tipo da nota tem que ser 'N'.")
		Return(.T.)
	EndIf
	If Empty(o_DocEntr:F1_EMISSAO)
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Informe a data de emissao."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdDocEntrada: Informe a data de emissao.")
		Return(.T.)
	EndIf
	If Empty(o_DocEntr:F1_ESPECIE)
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Informe a especie da nota."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdDocEntrada: Informe a especie da nota.")
		Return(.T.)
	EndIf
	/*
	If (n_Operacao = 5)
		If (Empty(o_DocEntr:F1_DOC) .OR. Empty(o_DocEntr:F1_SERIE))
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Para operacao de exclusao o numero da nota/serie tem que ser informado."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdDocEntrada: Para operacao de exclusao o numero da nota/serie tem que ser informado.")
			Return(.T.)
		Else
			DBSELECTAREA("SF1")
			DBSETORDER(1)
			If !(DBSEEK(XFILIAL("SF1")+c_Doc+c_Ser+c_For+c_Loj))
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Nota/Serie "+Alltrim(o_DocEntr:F1_DOC)+"/"+Alltrim(o_DocEntr:F1_SERIE)+"/"+c_For+"/"+c_Loj+" nao localizada na filial: "+o_Empresa:c_Filial+"."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdDocEntrada: Nota/Serie "+Alltrim(o_DocEntr:F1_DOC)+"/"+Alltrim(o_DocEntr:F1_SERIE)+"/"+c_For+"/"+c_Loj+" nao localizadoa na filial: "+o_Empresa:c_Filial+".")
				Return(.T.)
			EndIf
		EndIf
	EndIf
	*/
	d_TesteData	:=	StoD(o_DocEntr:F1_EMISSAO)
	If valtype(d_TesteData) == "D"
		If Empty(d_TesteData)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Informe a Data de emissao do pedido no formato [AAAAMMDD]."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdDocEntrada: Informe a Data de emissao do pedido no formato [AAAAMMDD].")
			Return(.T.)
		EndIf
	Else
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Informe a Data de emissao do pedido no formato [AAAAMMDD]."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdDocEntrada: Informe a Data de emissao do pedido no formato [AAAAMMDD].")
		Return(.T.)
	EndIf

	//Valida se o periodo esta bloqueado.
	c_Err:= ""
	d_TesteData	:=	StoD(o_DocEntr:F1_EMISSAO)
	If !( f_VldDtMov( "COM", dDatabase, @c_Err, "C" ) )
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= c_Err
		Conout("FFIEBW01 - mtdDocEntrada: "+c_Err)
		Return(.T.)
	EndIf

	If (n_Operacao = 3)
		/*
		c_Ban		:= Padr(o_DocEntr:XPORTADO,TamSX3("E1_PORTADO")[1])
		c_Age		:= Padr(o_DocEntr:XAGENCIA,TamSX3("E5_AGENCIA")[1])
		c_Con		:= Padr(o_DocEntr:XCCORRENT,TamSX3("E5_CONTA")[1])

		If Empty(c_Ban) .And. Empty(c_Age) .And. Empty(c_Con)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Banco/agencia/conta nao foram preenchidos."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdDocEntrada: Banco/agencia/conta nao foram preenchidos.")
			Return(.T.)
		EndIf

		DBSELECTAREA("SA6")
		DBSETORDER(1)
		If !DBSEEK(xFilial("SA6")+c_Ban+c_Age+c_Con)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Banco/agencia/conta devem ser informados: "+c_Ban+"/"+c_Age+"/"+c_Con
			Conout("FFIEBW01 - mtdDocEntrada: Banco/agencia/conta devem ser informados: "+c_Ban+"/"+c_Age+"/"+c_Con)
			Return(.T.)
		EndIf
		*/
	EndIf
	//PREENCHE AS VARIAVEIS PARA A NOTA DE ENTRADA
	aCabec 		:= {}
	aItens 		:= {}
	aLinha 		:= {}
	aColsCC 	:= {}

	//Validacao da aliquiota se existe e gravacao na tabela SF7 caso nao exista
	/*If ( o_DocEntr:F1_ALIQISS > 0 )
		n_Aliq:= o_DocEntr:F1_ALIQISS
	Else
		n_Aliq:= 0
	EndIf
	*/
	aadd(aCabec,{"F1_TIPO" 		,Upper(Alltrim(o_DocEntr:F1_TIPO))})
	aadd(aCabec,{"F1_FORMUL" 	,"N"})
	aadd(aCabec,{"F1_DOC" 		,PADR(Alltrim(o_DocEntr:F1_DOC), TAMSX3("F1_DOC")[1])})
	aadd(aCabec,{"F1_SERIE" 	,PADR(Alltrim(o_DocEntr:F1_SERIE), TAMSX3("F1_SERIE")[1])})
	aadd(aCabec,{"F1_EMISSAO"	,StoD(o_DocEntr:F1_EMISSAO)})
	aadd(aCabec,{"F1_FORNECE"	,c_For})
	aadd(aCabec,{"F1_LOJA" 		,c_Loj})
	aadd(aCabec,{"F1_ESPECIE"	,Alltrim(o_DocEntr:F1_ESPECIE)})
	aadd(aCabec,{"E2_NATUREZ"	,Alltrim(o_DocEntr:NATUREZA)})

	/* A CONDICAO DE PAGAMENTO, EH PASSADA NO ARRAY LA EM BAIXO */
	If Len(o_DocEntr:ITEND1) <= 0
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem	:= "Informe os itens da nota."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdDocEntrada: Informe os itens da nota.")
		Return(.T.)
	Else
		For p:= 1 To Len(o_DocEntr:ITEND1)
			aLinha := {}
			n_TotItens++ //total de itens da nota
			If Empty(Alltrim(o_DocEntr:ITEND1[p]:D1_TES))
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Informe a TES."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdDocEntrada: Informe a TES.")
				Return(.T.)
			EndIf
			DBSELECTAREA("SF4")
			DBSETORDER(1)
			If !(DBSEEK(XFILIAL("SF4")+Alltrim(o_DocEntr:ITEND1[p]:D1_TES)))
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "A TES "+Alltrim(o_DocEntr:ITEND1[p]:D1_TES)+" nao encontrada na base de dados do protheus."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdDocEntrada: A TES "+Alltrim(o_DocEntr:ITEND1[p]:D1_TES)+" nao encontrada na base de dados do protheus.")
				Return(.T.)
			ElseIf (Alltrim(SF4->F4_TIPO) <> "E")
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "O tipo da TES nao eh permitido para inclusao de nota de entrada."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdDocEntrada: O tipo da TES nao eh permitido para inclusao de nota de entrada.")
				Return(.T.)
			ElseIf (Alltrim(SF4->F4_DUPLIC) = 'S')
				If Empty(o_DocEntr:F1_COND)
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "A TES informada, obriga o preenchimento da condicao de pagamento."
					Conout("FFIEBW01 - mtdDocEntrada: A TES informada, obriga o preenchimento da condicao de pagamento.")
					Return(.T.)
				Else
					DBSELECTAREA("SE4")
					DBSETORDER(1)
					If !(DBSEEK(XFILIAL("SE4")+Alltrim(o_DocEntr:F1_COND)))
						::o_Retorno:l_Status		:= .F.
						::o_Retorno:c_Mensagem	:= "Condicao de pagamento "+Alltrim(o_DocEntr:F1_COND)+" nao encontrada na base de dados do protheus."+CHR(13)+CHR(10)
						Conout("FFIEBW01 - mtdGravaPV: Condicao de pagamento "+Alltrim(o_DocEntr:F1_COND)+" nao encontrada na base de dados do protheus.")
						Return(.T.)
					Else
						aadd(aCabec,{"F1_COND"	,Alltrim(o_DocEntr:F1_COND)})
					EndIf
					If Empty(Alltrim(o_DocEntr:NATUREZA))
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "A TES informada esta configurada para gerar titulo a pagar, portanto e necessario informar a natureza."
						Conout("FFIEBW01 - mtdDocEntrada: A TES informada esta configurada para gerar titulo a pagar, portanto e necessario informar a natureza.")
						Return(.T.)
					Else
						//Valida a natureza
						dbSelectArea("SED")
						dbSetOrder(1)
						If !(dbSeek(xfilial("SED")+Alltrim(o_DocEntr:NATUREZA)))
							::o_Retorno:l_Status		:= .F.
							::o_Retorno:c_Mensagem	:= "Natureza "+Alltrim(o_DocEntr:NATUREZA)+" nao encontrada na base de dados do protheus."+CHR(13)+CHR(10)
							Conout("FFIEBW01 - mtdDocEntrada: Natureza "+Alltrim(o_DocEntr:NATUREZA)+" nao encontrada na base de dados do protheus.")
							Return(.T.)
						Else
							l_NatISS:= .F.
							If (Alltrim(SED->ED_CALCISS) = 'S') //Verifica se a natureza calcula ISS
								l_NatISS:= .T.
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			If Empty(o_DocEntr:ITEND1[p]:D1_COD)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Informe o codigo do produto."
				Conout("FFIEBW01 - mtdDocEntrada: Informe o codigo do produto.")
				Return(.T.)
			EndIf
			DBSELECTAREA("SB1")
			DBSETORDER(1)
			If !(DBSEEK(XFILIAL("SB1")+Alltrim(o_DocEntr:ITEND1[p]:D1_COD)))
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Codigo do produto "+Alltrim(o_DocEntr:ITEND1[p]:D1_COD)+" nao encontrado no Protheus."
				Conout("FFIEBW01 - mtdDocEntrada: Codigo do produto nao encontrado no Protheus.")
				Return(.T.)
			Else
				l_ProISS:= .F.
				If !Empty((SB1->B1_CODISS)) .Or. (SB1->B1_ALIQISS > 0) //Verifica se o produto eh de servico
					l_ProISS:= .T.
				EndIf
				//Quando o tipo de produto for servico, grava o grupo de tributacao 001 gerado na tabela SF7(excessoes fiscais).
				//Se passar a aliquita de ISS, faz a gravacao na SF7 (excessoes fiscais), grava o grupo de tributacao no fornecedor e no produto mais abaixo.
				/*
				If ( SB1->B1_TIPO = 'SV' )
					If ( n_Aliq > 0 )
						l_OkF7		:= .F.
						c_MsgError	:= ""
						c_GrpCli	:= ""
						l_OkF7:= u_GrvSF7(n_Aliq, @c_MsgError, @c_GrpCli)

						If !( l_OkF7 )
							::o_Retorno:l_Status	:= .F.
							::o_Retorno:c_Mensagem	:= c_MsgError
							Return(.T.)
						Else
							//Grava o grupo de tributacao no fornecedor
							If ( SA2->A2_GRPTRIB <> c_GrpCli )

								DbSelectArea("SA2")
								RecLock("SA2",.F.)
								SA2->A2_GRPTRIB:= c_GrpCli
								MsUnLock()

							EndIf
							//Grava o grupo de tibutacao no produto
							If ( SB1->B1_GRTRIB <> '001' )
								RecLock("SB1",.F.)
								SB1->B1_GRTRIB:= "001"
								MsUnLock()
							EndIf
						EndIf
					Else
						//Limpa o grupo de tibutacao no produto
						If ( SB1->B1_GRTRIB = '001' )
							RecLock("SB1",.F.)
							SB1->B1_GRTRIB:= ""
							MsUnLock()
						EndIf
						//Limpa o grupo de tibutacao no fornecedor
						If ( SA2->A2_GRPTRIB <> '' )
							DbSelectArea("SA2")
							RecLock("SA2",.F.)
							SA2->A2_GRPTRIB:= ""
							MsUnLock()
						EndIf
					EndIf
				EndIf*/
			EndIf
			If (o_DocEntr:ITEND1[p]:D1_QUANT < 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Informe a quantidade do pedido de venda."
				Conout("FFIEBW01 - mtdDocEntrada: Informe a quantidade do pedido de venda.")
				Return(.T.)
			EndIf
			If (o_DocEntr:ITEND1[p]:D1_VUNIT < 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Informe o preco do pedido de venda."
				Conout("FFIEBW01 - mtdDocEntrada: Informe o preco do pedido de venda.")
				Return(.T.)
			EndIf
			If (o_DocEntr:ITEND1[p]:D1_TOTAL < 0)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Informe o valor do pedido de venda."
				Conout("FFIEBW01 - mtdDocEntrada: Informe o valor do pedido de venda.")
				Return(.T.)
			EndIf
			//Validando a conta contabil
			If !Empty(Alltrim(o_DocEntr:ITEND1[p]:D1_CONTA))
				DBSELECTAREA("CT1")
				DBSETORDER(1)
				IF !DBSEEK(xFilial("CT1")+Alltrim(o_DocEntr:ITEND1[p]:D1_CONTA))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_DocEntr:ITEND1[p]:D1_CONTA)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+"."
					Conout("FFIEBW01 - mtdDocEntrada: Codigo da conta contabil ("+Alltrim(o_DocEntr:ITEND1[p]:D1_CONTA)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+".")
					Return(.T.)
				ElseIf CT1->CT1_CLASSE == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_DocEntr:ITEND1[p]:D1_CONTA)+") nao pode ser sintetica."
					Conout("FFIEBW01 - mtdDocEntrada: Codigo da conta contabil ("+Alltrim(o_DocEntr:ITEND1[p]:D1_CONTA)+") nao pode ser sintetica.")
					Return(.T.)
				ElseIf CT1->CT1_BLOQ == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_DocEntr:ITEND1[p]:D1_CONTA)+") esta bloqueada para uso."
					Conout("FFIEBW01 - mtdDocEntrada: Codigo da conta contabil ("+Alltrim(o_DocEntr:ITEND1[p]:D1_CONTA)+")  esta bloqueada para uso.")
					Return(.T.)
				EndIf
			Else
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Informe a Conta contabil nos itens da nota."
				Conout("FFIEBW01 - mtdDocEntrada: Informe a Conta contabil nos itens da nota.")
				Return(.T.)
			EndIf
			If !Empty(Alltrim(o_DocEntr:ITEND1[p]:D1_CC))
				DbSelectArea("CTT")
				CTT->(dbSetOrder(1))
				If !(CTT->(dbSeek(xFilial("CTT")+Alltrim(o_DocEntr:ITEND1[p]:D1_CC))))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Centro de custo nao encontrado ("+Alltrim(o_DocEntr:ITEND1[p]:D1_CC)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdDocEntrada: Centro de custo nao encontrado  ("+Alltrim(o_DocEntr:ITEND1[p]:D1_CC)+").")
					Return(.T.)
				Elseif CTT->CTT_CLASSE == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Centro de custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_DocEntr:ITEND1[p]:D1_CC)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdDocEntrada: Centro de custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_DocEntr:ITEND1[p]:D1_CC)+").")
					Return(.T.)
				Elseif CTT->CTT_BLOQ == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Centro de custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_DocEntr:ITEND1[p]:D1_CC)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdDocEntrada: Centro de custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_DocEntr:ITEND1[p]:D1_CC)+").")
					Return(.T.)
				Endif
			EndIf
			//valida o item
			If !Empty(Alltrim(o_DocEntr:ITEND1[p]:D1_ITEMCTA))
				DbSelectArea("CTD")
				CTD->(dbSetOrder(1))
				If !(CTD->(dbSeek(xFilial("CTD")+PADR(Alltrim(o_DocEntr:ITEND1[p]:D1_ITEMCTA), TAMSX3("D1_ITEMCTA")[1]))))
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil invalido ("+Alltrim(o_DocEntr:ITEND1[p]:D1_ITEMCTA)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdDocEntrada: Item contabil invalido ("+Alltrim(o_DocEntr:ITEND1[p]:D1_ITEMCTA)+").")
					Return(.T.)
				Elseif CTD->CTD_CLASSE == "1"
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_DocEntr:ITEND1[p]:D1_ITEMCTA)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdDocEntrada: Item contabil invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_DocEntr:ITEND1[p]:D1_ITEMCTA)+").")
					Return(.T.)
				Elseif CTD->CTD_BLOQ == "1" .or. (!Empty(CTD->CTD_DTEXSF) .and. CTD->CTD_DTEXSF < dDatabase)
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_DocEntr:ITEND1[p]:D1_ITEMCTA)+")."+CHR(13)+CHR(10)
					Conout("FFIEBW01 - mtdDocEntrada: Item contabil invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_DocEntr:ITEND1[p]:D1_ITEMCTA)+").")
					Return(.T.)
				ElseIf (!Empty(CTD->CTD_DTEXIS) .and. dDatabase < CTD->CTD_DTEXIS)
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Item contabil ("+Alltrim(o_DocEntr:ITEND1[p]:D1_ITEMCTA)+") esta com data de inicio de existencia superior a data base."+CHR(13)+CHR(10)
					Return(.T.)
				ElseIf ( Alltrim(CTD->CTD_XRTADM) $ '3|4' ) //Valida o rateio vigente: 11/09/2019.
					If !( u_RtVigente( Alltrim( cFilAnt ), Alltrim( o_DocEntr:ITEND1[p]:D1_ITEMCTA ) ) )							
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "O CR por ser do tipo corporativo ou compartilhado, deve existir no rateio vigente. Filial: (" + Alltrim( cFilAnt ) + "), CR: (" + Alltrim( o_DocEntr:ITEND1[p]:D1_ITEMCTA ) + ")"
						Return(.T.)
					EndIf
				Endif
			EndIf

			DBSELECTAREA("SB1")
			DBSETORDER(1)
			DBSEEK(XFILIAL("SB1")+Alltrim(o_DocEntr:ITEND1[p]:D1_COD))

			l_TESISS:= .F.
			DBSELECTAREA("SF4")
			DBSETORDER(1)
			DBSEEK(XFILIAL("SF4")+Alltrim(o_DocEntr:ITEND1[p]:D1_TES))
			If (Alltrim(SF4->F4_ISS) = 'S') .And. (Alltrim(SF4->F4_LFISS) = 'T') //Verifica se a TES calcula ISS
				l_TESISS:= .T.
			EndIf
			aadd(aLinha,{"D1_ITEM" 	,Strzero(Val(Alltrim(o_DocEntr:ITEND1[p]:D1_ITEM)),4),Nil})
			aadd(aLinha,{"D1_COD" 	,SB1->B1_COD,Nil})
			aadd(aLinha,{"D1_UM" 	,SB1->B1_UM,Nil})
			aadd(aLinha,{"D1_QUANT"	,o_DocEntr:ITEND1[p]:D1_QUANT,Nil})
			aadd(aLinha,{"D1_VUNIT"	,o_DocEntr:ITEND1[p]:D1_VUNIT,Nil})
			aadd(aLinha,{"D1_TOTAL"	,ROUND((o_DocEntr:ITEND1[p]:D1_TOTAL),2),Nil})
			aadd(aLinha,{"D1_TES" 	,SF4->F4_CODIGO,Nil})
			If !Empty(Alltrim(o_DocEntr:ITEND1[p]:D1_CONTA))
				Aadd(aLinha,{"D1_CONTA"	,Alltrim(o_DocEntr:ITEND1[p]:D1_CONTA),NIL} )
			EndIf
			If !Empty(Alltrim(o_DocEntr:ITEND1[p]:D1_CC))
				Aadd(aLinha,{"D1_CC"	,Alltrim(o_DocEntr:ITEND1[p]:D1_CC),NIL} )
			EndIf
			If !Empty(Alltrim(o_DocEntr:ITEND1[p]:D1_ITEMCTA))
				Aadd(aLinha,{"D1_ITEMCTA",Alltrim(o_DocEntr:ITEND1[p]:D1_ITEMCTA),NIL} )
			EndIf

			//Bases e aliquotas dos impostos
			If ( o_DocEntr:ITEND1[p]:D1_BASEIRR <> Nil ) .And. ( o_DocEntr:ITEND1[p]:D1_ALIQIRR <> Nil )
				If ( o_DocEntr:ITEND1[p]:D1_BASEIRR > 0 ) .And. ( o_DocEntr:ITEND1[p]:D1_ALIQIRR > 0 )
					aadd(aLinha,{"D1_BASEIRR" 	,o_DocEntr:ITEND1[p]:D1_BASEIRR,Nil})
					aadd(aLinha,{"D1_ALIQIRR" 	,o_DocEntr:ITEND1[p]:D1_ALIQIRR,Nil})
				EndIf
			EndIf

			If ( o_DocEntr:ITEND1[p]:D1_BASEINS <> Nil ) .And. ( o_DocEntr:ITEND1[p]:D1_ALIQINS <> Nil )
				If ( o_DocEntr:ITEND1[p]:D1_BASEINS > 0 ) .And. ( o_DocEntr:ITEND1[p]:D1_ALIQINS > 0 )
					aadd(aLinha,{"D1_BASEINS" 	,o_DocEntr:ITEND1[p]:D1_BASEINS,Nil})
					aadd(aLinha,{"D1_ALIQINS" 	,o_DocEntr:ITEND1[p]:D1_ALIQINS,Nil})
				EndIf
			EndIf

			If ( o_DocEntr:ITEND1[p]:D1_BASEISS <> Nil ) .And. ( o_DocEntr:ITEND1[p]:D1_ALIQISS <> Nil )
				If ( o_DocEntr:ITEND1[p]:D1_BASEISS > 0 ) .And. ( o_DocEntr:ITEND1[p]:D1_ALIQISS > 0 )
					aadd(aLinha,{"D1_BASEISS" 	,o_DocEntr:ITEND1[p]:D1_BASEISS,Nil})
					aadd(aLinha,{"D1_ALIQISS" 	,o_DocEntr:ITEND1[p]:D1_ALIQISS,Nil})
				EndIf
			EndIf

			//Valida se a conta comeca com 32 e o Cr possui o campo CTD_XRTADM = 2=Consumo;3=Corporativo;4=Unid. Compartilhadas 11/02/2019
			If !Empty(Alltrim(o_DocEntr:ITEND1[p]:D1_CONTA)) .And. !Empty(Alltrim(o_DocEntr:ITEND1[p]:D1_ITEMCTA))
				c_ErrMsg:= ""
				If !( f_VldCnInvest( Alltrim(o_DocEntr:ITEND1[p]:D1_CONTA), Alltrim(o_DocEntr:ITEND1[p]:D1_ITEMCTA), @c_ErrMsg ) )
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= c_ErrMsg
					Conout("FFIEBW01 - mtdDocEntrada: "+c_ErrMsg)
					Return(.T.)
				EndIf
			EndIf
			//Se passou o numero do pedido WBC
			//If !Empty(o_DocEntr:ITEND1[p]:D1_XPCWBC)
			/*cQuery := ""
			cQuery += "SELECT C7_NUM, C7_PRODUTO, C7_ITEM, C7_QUANT, C7_QUJE, C7_XPCWBC FROM " + RetSqlName( "SC7" ) + " SC7 "+chr(13)+chr(10)
			cQuery += "WHERE D_E_L_E_T_ = ' ' "+chr(13)+chr(10)
			cQuery += "AND C7_FILIAL = '" + o_Empresa:c_Filial + "' "+chr(13)+chr(10)
			cQuery += "AND C7_QUJE < C7_QUANT" //ITEM DO PEDIDO COM SALDO
			cQuery += "AND C7_PRODUTO = '" + SB1->B1_COD + "' "+chr(13)+chr(10)
			cQuery += "AND C7_XPCWBC = '" + Alltrim(o_DocEntr:ITEND1[p]:D1_XPCWBC) + "' ORDER BY C7_XPCWBC "+chr(13)+chr(10)
			TCQUERY cQuery ALIAS QRY NEW
			If !(QRY->(Eof()))
				c_AuxBan:= QRY->ZZK_BANCO
				c_AuxAge:= QRY->ZZK_AGENCI
				c_AuxCon:= QRY->ZZK_CONTA
			EndIf
			DbSelectArea("QRY")
			QRY->(DbCloseArea())

			AADD(aLinha,{"D1_PEDIDO"	,o_ZF4Grid:GetValue("ZF4_PEDIDO")	,Nil ,Nil})
			AADD(a_Item,{"D1_ITEMPC"	,o_ZF4Grid:GetValue("ZF4_ITEMPC")	,Nil ,Nil})

			*/
			aadd(aItens,aLinha)
			//=====================================================================================================================
			// ================= INICIO VALIDACAO/GRAVACAO NO VETOR DA DISTRIBUICAO DO RATEIO - TABELA CUSTOMIZADA J2A ZJW ===========================
			cMsgError	:= ""
			_cItemD1	:= Strzero(Val(Alltrim(o_DocEntr:ITEND1[p]:D1_ITEM)),4)
			If Len(o_DocEntr:ITEND1[p]:ITENZJW) > 0
				_nItRat:= 0
				If !Empty(o_DocEntr:ITEND1[p]:ITENZJW[1]:ZJW_FILDES) .And. ((o_DocEntr:ITEND1[p]:ITENZJW[1]:ZJW_VALOR > 0) .Or. (o_DocEntr:ITEND1[p]:ITENZJW[1]:ZJW_PERC > 0))
					_nItRat 	:= Len(o_DocEntr:ITEND1[p]:ITENZJW)
					n_TDisItens++ //Itens da nota com distribuicao
					n_TVlrDisIt:= 0 //total do valor do item da distribuicao
					n_TPerDisIt:= 0 //total do percentual do item da distribuicao
					For x := 1 to _nItRat
						//Validando a conta contabil
						If !Empty(Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_CONTA))
							DBSELECTAREA("CT1")
							DBSETORDER(1)
							IF !DBSEEK(xFilial("CT1")+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_CONTA))
								::o_Retorno:l_Status		:= .F.
								::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_CONTA)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+"."
								Conout("FFIEBW01 - mtdDocEntrada: Codigo da conta contabil ("+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_CONTA)+") nao encontrada para a filial "+Alltrim(xFilial("CT1"))+".")
								Return(.T.)
							ElseIf CT1->CT1_CLASSE == "1"
								::o_Retorno:l_Status		:= .F.
								::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_CONTA)+") nao pode ser sintetica."
								Conout("FFIEBW01 - mtdDocEntrada: Codigo da conta contabil ("+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_CONTA)+") nao pode ser sintetica.")
								Return(.T.)
							ElseIf CT1->CT1_BLOQ == "1"
								::o_Retorno:l_Status		:= .F.
								::o_Retorno:c_Mensagem	:= "Codigo da conta contabil ("+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_CONTA)+") esta bloqueada para uso."
								Conout("FFIEBW01 - mtdDocEntrada: Codigo da conta contabil ("+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_CONTA)+")  esta bloqueada para uso.")
								Return(.T.)
							EndIf
						Else
							::o_Retorno:l_Status		:= .F.
							::o_Retorno:c_Mensagem	:= "Informe a Conta contabil no item da distribuicao."
							Conout("FFIEBW01 - mtdDocEntrada: Informe a Conta contabil no item da distribuicao.")
							Return(.T.)
						EndIf
						//Valida o centro de custo
						If !Empty(Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_CC))
							DbSelectArea("CTT")
							CTT->(dbSetOrder(1))
							If !(CTT->(dbSeek(xFilial("CTT")+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_CC))))
								::o_Retorno:l_Status	:= .F.
								::o_Retorno:c_Mensagem	:= "Centro de custo nao encontrado ("+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_CC)+")."+CHR(13)+CHR(10)
								Conout("FFIEBW01 - mtdDocEntrada: Centro de custo nao encontrado  ("+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_CC)+").")
								Return(.T.)
							Elseif CTT->CTT_CLASSE == "1"
								::o_Retorno:l_Status	:= .F.
								::o_Retorno:c_Mensagem	:= "Centro de custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_CC)+")."+CHR(13)+CHR(10)
								Conout("FFIEBW01 - mtdDocEntrada: Centro de custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_CC)+").")
								Return(.T.)
							Elseif CTT->CTT_BLOQ == "1"
								::o_Retorno:l_Status	:= .F.
								::o_Retorno:c_Mensagem	:= "Centro de custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_CC)+")."+CHR(13)+CHR(10)
								Conout("FFIEBW01 - mtdDocEntrada: Centro de custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_CC)+").")
								Return(.T.)
							Endif
						EndIf
						//valida o item
						If !Empty(Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_ITEM))
							DbSelectArea("CTD")
							CTD->(dbSetOrder(1))
							If !(CTD->(dbSeek(xFilial("CTD")+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_ITEM))))
								::o_Retorno:l_Status	:= .F.
								::o_Retorno:c_Mensagem	:= "Item contabil invalido ("+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_ITEM)+")."+CHR(13)+CHR(10)
								Conout("FFIEBW01 - mtdDocEntrada: Item contabil invalido ("+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_ITEM)+").")
								Return(.T.)
							Elseif CTD->CTD_CLASSE == "1"
								::o_Retorno:l_Status	:= .F.
								::o_Retorno:c_Mensagem	:= "Item contabil invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_ITEM)+")."+CHR(13)+CHR(10)
								Conout("FFIEBW01 - mtdDocEntrada: Item contabil invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_ITEM)+").")
								Return(.T.)
							Elseif CTD->CTD_BLOQ == "1" .or. (!Empty(CTD->CTD_DTEXSF) .and. CTD->CTD_DTEXSF < dDatabase)
								::o_Retorno:l_Status	:= .F.
								::o_Retorno:c_Mensagem	:= "Item contabil invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_ITEM)+")."+CHR(13)+CHR(10)
								Conout("FFIEBW01 - mtdDocEntrada: Item contabil invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_ITEM)+").")
								Return(.T.)
							ElseIf (!Empty(CTD->CTD_DTEXIS) .and. dDatabase < CTD->CTD_DTEXIS)
								::o_Retorno:l_Status	:= .F.
								::o_Retorno:c_Mensagem	:= "Item contabil ("+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_ITEM)+") esta com data de inicio de existencia superior a data base."+CHR(13)+CHR(10)
								Return(.T.)
							ElseIf ( Alltrim(CTD->CTD_XRTADM) $ '3|4' ) //Valida o rateio vigente: 11/09/2019.
								If !( u_RtVigente( Alltrim( o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_FILDES ), Alltrim( o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_ITEM ) ) )							
									::o_Retorno:l_Status	:= .F.
									::o_Retorno:c_Mensagem	:= "O CR por ser do tipo corporativo ou compartilhado, deve existir no rateio vigente. Filial: (" + Alltrim( o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_FILDES ) + "), CR: (" + Alltrim( o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_ITEM ) + ")"
									Return(.T.)
								EndIf
							Endif
						EndIf
						//Valida se a filial na distribuicao e diferente da empresa da digitacao da nota
						If ( Substr(Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_FILDES),1,4) <> Substr(Alltrim(o_Empresa:c_Filial),1,4) )
							::o_Retorno:l_Status	:= .F.
							::o_Retorno:c_Mensagem	:= "A filial da distribuicao nao pode ser diferente da empresa da digitacao da nota ("+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_FILDES)+")."+CHR(13)+CHR(10)
							Conout("FFIEBW01 - mtdDocEntrada: A filial da distribuicao nao pode ser diferente da empresa da digitacao da nota ("+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_FILDES)+").")
							Return(.T.)
						EndIf
						//VALIDA SE A CONTA COMECA COM 3 OU 4 E OBRIGA O UO (ZJW_CC) E CR (ZJW_ITEMCTA)
						If (Substr( Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_CONTA),1,1 ) $ '3,4') .And. (Empty(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_CC) .Or. Empty(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_ITEM))
							::o_Retorno:l_Status	:= .F.
							::o_Retorno:c_Mensagem	:= "Para contas que comecam com 3 ou 4 ("+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_CONTA)+") o CR e Uo devem ser preenchidos."
							Conout("FFIEBW01 - mtdDocEntrada: Para contas que comecam com 3 ou 4 ("+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_CONTA)+") o CR e Uo devem ser preenchidos.")
							Return(.T.)
						Else
							//VERIFICA SE A AMARRACAO ENTRE O CR E UO EXISTE
							If !(Empty(Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_CC))) .Or. !(Empty(Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_ITEM)))
								If (VerAmarrCTA(Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_FILDES), Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_CC), Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_ITEM)))
									Aadd(a_Itens,{_cItemD1, o_DocEntr:ITEND1[p]:D1_COD, o_DocEntr:ITEND1[p]:D1_TOTAL, Strzero(Val(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_LINHA),4), o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_FILDES, Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_CONTA), o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_VALOR, o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_PERC, Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_ITEM), Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_CC), Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_CLVL)})
									l_TemDistrib:= .T. //Informa que tem distribuicao no item
									n_TVlrDisIt+= o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_VALOR
									n_TPerDisIt+= o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_PERC
								Else
									::o_Retorno:l_Status	:= .F.
									::o_Retorno:c_Mensagem	:= "Nao existe amarracao (Tabela CTA) entre Filial: ("+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_FILDES)+"), CR: ("+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_ITEM)+") e Uo: ("+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_CC)+")."
									Conout("FFIEBW01 - mtdDocEntrada: Nao existe amarracao (Tabela CTA) entre Filial: ("+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_FILDES)+"), CR: ("+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_ITEM)+") e Uo: ("+Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_CC)+").")
									Return(.T.)
								EndIf
								//Valida se a conta comeca com 32 e o Cr possui o campo CTD_XRTADM = 2=Consumo;3=Corporativo;4=Unid. Compartilhadas 11/02/2019
								c_ErrMsg:= ""
								If !( f_VldCnInvest( Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_CONTA), Alltrim( o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_ITEM ), @c_ErrMsg ) )
									::o_Retorno:l_Status	:= .F.
									::o_Retorno:c_Mensagem	:= c_ErrMsg
									Conout("FFIEBW01 - mtdDocEntrada: "+c_ErrMsg)
									Return(.T.)
								EndIf
							EndIf
						EndIf
					Next
					If ( n_TVlrDisIt > 0 ) //Se informou valor
						If ( ROUND(n_TVlrDisIt,2) <> ROUND((o_DocEntr:ITEND1[p]:D1_TOTAL),2) )
							::o_Retorno:l_Status	:= .F.
							::o_Retorno:c_Mensagem	:= "O total da distribuicao do produto "+Alltrim(SB1->B1_COD)+": "+Alltrim(Str(ROUND(n_TVlrDisIt,2)))+" eh diferente do total do item: "+Alltrim(Str(ROUND((o_DocEntr:ITEND1[p]:D1_TOTAL),2)))
							Conout("FFIEBW01 - mtdDocEntrada: O total da distribuicao do produto "+Alltrim(SB1->B1_COD)+": "+Alltrim(Str(ROUND(n_TVlrDisIt,2)))+" eh diferente do total do item: "+Alltrim(Str(ROUND((o_DocEntr:ITEND1[p]:D1_TOTAL),2))))
							Return(.T.)
						EndIf
					ElseIf ( n_TPerDisIt > 0 ) //Se informou percentual
						If ( n_TPerDisIt <> 100 )
							::o_Retorno:l_Status	:= .F.
							::o_Retorno:c_Mensagem	:= "O percentual total da distribuicao do produto "+Alltrim(SB1->B1_COD)+" nao bate 100%: "+Alltrim(Str(n_TPerDisIt))
							Conout("FFIEBW01 - mtdDocEntrada: O percentual total da distribuicao do produto "+Alltrim(SB1->B1_COD)+" nao bate 100%: "+Alltrim(Str(n_TPerDisIt)))
							Return(.T.)
						EndIf
					EndIf
				EndIf
			EndIf
			// =================== FIM VALIDACAO/GRAVACAO NO VETOR DA DISTRIBUICAO DO RATEIO - TABELA CUSTOMIZADA J2A ZJW ============================
			//=====================================================================================================================
		Next

		//Valida se houve distribuicao em todos os itens da nota. So deixa gravar se fizer distribuicao em todos ou em nenhum
		If ( l_TemDistrib ) //Se tem itens com distribuicao
			If ( n_TDisItens <> n_TotItens ) //Se o total de itens com distribuicao e igual ao total de itens da nota
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Pelas regras da FIEB se informar a distribuicao em um item da nota, tera que informar em todos os itens."
				Conout("FFIEBW01 - mtdDocEntrada: Pelas regras da FIEB se informar a distribuicao em um item da nota, tera que informar em todos os itens.")
				Return(.T.)
			EndIf
		Else//Quando nenhum item tem distribuicao, valida a conta
			For p:= 1 To Len(o_DocEntr:ITEND1)
				//VALIDA SE A CONTA COMECA COM 3 OU 4 E OBRIGA O UO (D1_CC) E CR (D1_ITEMCTA)
				If (Substr( Alltrim(o_DocEntr:ITEND1[p]:D1_CONTA),1,1 ) $ '3,4') .And. (Empty(o_DocEntr:ITEND1[p]:D1_CC) .Or. Empty(o_DocEntr:ITEND1[p]:D1_ITEMCTA))
					If !(l_TemDistrib) //Quando o item da nota nao tem distribuicao, obriga o Cr e Uo.
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= "Para contas que comecam com 3 ou 4 ("+Alltrim(o_DocEntr:ITEND1[p]:D1_CONTA)+") o CR e Uo devem ser preenchidos."
						Conout("FFIEBW01 - mtdDocEntrada: Para contas que comecam com 3 ou 4 ("+Alltrim(o_DocEntr:ITEND1[p]:D1_CONTA)+") o CR e Uo devem ser preenchidos.")
						Return(.T.)
					EndIf
				Else
					//VERIFICA SE A AMARRACAO ENTRE O CR E UO EXISTE
					If !(Empty(Alltrim(o_DocEntr:ITEND1[p]:D1_CC))) .Or. !(Empty(Alltrim(o_DocEntr:ITEND1[p]:D1_ITEMCTA)))
						If (VerAmarrCTA(Alltrim(o_Empresa:c_Filial), Alltrim(o_DocEntr:ITEND1[p]:D1_CC), Alltrim(o_DocEntr:ITEND1[p]:D1_ITEMCTA)))
							//nao faz nada
						Else
							::o_Retorno:l_Status	:= .F.
							::o_Retorno:c_Mensagem	:= "Nao existe amarracao (Tabela CTA) entre Filial: ("+Alltrim(o_Empresa:c_Filial)+"), CR: ("+Alltrim(o_DocEntr:ITEND1[p]:D1_ITEMCTA)+") e Uo: ("+Alltrim(o_DocEntr:ITEND1[p]:D1_CC)+")."
							Conout("FFIEBW01 - mtdDocEntrada: Nao existe amarracao (Tabela CTA) entre Filial: ("+Alltrim(o_Empresa:c_Filial)+"), CR: ("+Alltrim(o_DocEntr:ITEND1[p]:D1_ITEMCTA)+") e Uo: ("+Alltrim(o_DocEntr:ITEND1[p]:D1_CC)+").")
							Return(.T.)
						EndIf
					EndIf
				EndIf
			Next
		EndIf

		_aTotRat	:= {}
		_lRateio	:= .F.
		//Preenche o array do rateio por natureza - SEV
		If Len(o_DocEntr:NATRATEIO) > 0
			If !Empty(o_DocEntr:NATRATEIO[1]:EV_NATUREZ) .And. (o_DocEntr:NATRATEIO[1]:EV_PERC > 0)
				For p:= 1 To Len(o_DocEntr:NATRATEIO)
					Aadd(_aTotRat,{50, Alltrim(o_DocEntr:NATRATEIO[p]:EV_NATUREZ), o_DocEntr:NATRATEIO[p]:EV_PERC, "1", PADR(" ", TAMSX3("EV_IDDOC")[1]), "SEV", 0, .F.})
					_lRateio := .T.
				Next
			EndIf
		EndIf
		//O array a_SEVWs sera usado no P.E. MT103MNT para gravacao do rateio por natureza - SEV
		If (_lRateio)
			a_SEVWs:= aClone(_aTotRat)
		EndIf
	EndIf

	If (n_Operacao = 3) //Inclusao
		l_TemISS	:= .F.
		d_EmiNota	:= Alltrim(o_DocEntr:F1_EMISSAO)
		//Tratamento para enviar para o PE MT103ISS que devera busca na tabela CC2 o codigo do fornecedor de ISS e a data de vencimento
		If (l_ForISS) .And. (l_NatISS) .And. (l_TESISS) .And. (l_ProISS)
			l_TemISS:= .T.
			If Empty(o_DocEntr:xESTISS) .Or. Empty(o_DocEntr:xIBGEISS)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Informe o Estado do ISS e o Codigo do IGBE , pois esta nota possui as condiguracoes de geracao de ISS."
				Conout("FFIEBW01 - mtdDocEntrada: Informe o Estado do ISS e o Codigo do IGBE , pois esta nota possui as condiguracoes de geracao de ISS.")
				Return(.T.)
			EndIf
			c_WSEst		:= Alltrim(o_DocEntr:xESTISS)
			c_WSCodMun	:= Alltrim(o_DocEntr:xIBGEISS)
			//Verifica se foi feito a amarracao do fornecedor de ISS no cadastros de municipios
			DbSelectArea( "CC2" )
			DbSetOrder(1)
			If DbSeek(XFILIAL( "CC2" )+c_WSEst+c_WSCodMun )
				If Empty(CC2->CC2_FSFORN) .Or. Empty(CC2->CC2_FSLOJA)
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "A nota gerara ISS, realize a amarracao do fornecedor de ISS com o estado ("+c_WSEst+") + codigo do IBGE ("+c_WSCodMun+") na tabela de municipios."
					Conout("FFIEBW01 - mtdDocEntrada: A nota gerara ISS, realize a amarracao do fornecedor de ISS com o estado ("+c_WSEst+") + codigo do IBGE ("+c_WSCodMun+") na tabela de municipios.")
					Return(.T.)
				ElseIf Empty(CC2->CC2_TPDIA)
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Informe o tipo de dias de vencimento do ISS no cadastro de municipios para o Estado e IGBE informados."
					Conout("FFIEBW01 - mtdDocEntrada: Informe o tipo de dias de vencimento do ISS no cadastro de municipios para o Estado e IGBE informados.")
					Return(.T.)
				ElseIf (CC2->CC2_DTRECO = 0)
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Informe o dia de recolhimento de ISS no cadastro de municipios para o Estado e IGBE informados."
					Conout("FFIEBW01 - mtdDocEntrada: Informe o dia de recolhimento de ISS no cadastro de municipios para o Estado e IGBE informados.")
					Return(.T.)
				EndIf
			Else
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Estado do ISS e o Codigo do IGBE nao encontrados na tabela de municipios (CC2)."
				Conout("FFIEBW01 - mtdDocEntrada: Estado do ISS e o Codigo do IGBE nao encontrados na tabela de municipios (CC2).")
				Return(.T.)
			EndIf

		EndIf
	EndIf

	//Informacoes adicionais do ISS
	//aadd(aCabec,{"A2_COD_MUN"	,'33307'})
	//aadd(aCabec,{"CC2_MUN"		,'VITORIA DA CONQUISTA                                        '})
	//aadd(aCabec,{"CC2_EST"		,'BA'})

	Begin TRANSACTION

		//GRAVACAO DO PEDIDO DE VENDA
		lMsHelpAuto 	:= .T.
		lMsErroAuto 	:= .F.
		MSExecAuto({|x,y,z| MATA103(x,y,z)},aCabec,aItens,n_Operacao)
		If lMsErroAuto
			// Tratamento da Mensagem de erro do MSExecAuto
			aLogErr  := GetAutoGRLog()
			aLogErr2 := f_TrataErro(aLogErr)
			_cMotivo := ""

			For i := 1 to Len(aLogErr2)
				_cMotivo += aLogErr2[i]
			Next
			If Empty(_cMotivo)
				_cMotivo:= MostraErro("\TOTVSBA_LOG\","documento_entrada.txt")
			EndIf
			//Exclusivo para a versao 12
			If (GetVersao(.F.) == "12")
				_cMotivo:=  NoAcentoESB(_cMotivo)
				SetSoapFault('Erro',_cMotivo)
			EndIf

			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= NoAcentoESB(_cMotivo)
			Conout("FFIEBW01 - mtdDocEntrada: "+NoAcentoESB(_cMotivo))
			DisarmTransaction()
			Break
		Else
			If (n_Operacao = 3)
				//GRAVA OS DADOS EXPECIFICO FIEB - Campos gravados pela customizacao da J2A
				DBSELECTAREA("SF1")
				DBSETORDER(1)
				If (DBSEEK(XFILIAL("SF1")+c_Doc+c_Ser+c_For+c_Loj))
					c_Fil		:= SF1->F1_FILIAL
					c_Esp		:= SF1->F1_ESPECIE
					d_Emissao	:= SF1->F1_EMISSAO
					d_DtLan		:= SF1->F1_DTLANC
					n_VlrNf		:= SF1->F1_VALBRUT
					c_Tipo		:= SF1->F1_TIPO
					d_Emis		:= SF1->F1_EMISSAO
					d_DtDig		:= SF1->F1_DTDIGIT
				EndIf
				
				//30/09/2019 - Chama a funcao de substituicao da provisao.
				//f_SubstituiProvisao( c_Doc, c_Ser, c_For, c_Loj, n_VlrNf, c_Tipo )
				
				If ( l_TemDistrib ) //Se tem itens com distribuicao 22/03/2019
					//=====================================================================================================================
					// ================= INICIO GRAVACAO DA DISTRIBUICAO DO RATEIO - TABELA CUSTOMIZADA J2A ZJW ===========================
					l_RetZJW:= f_GrvZJW(c_Fil, c_Doc, c_Ser, c_Esp, d_Emissao, d_DtDig, c_For, c_Loj, n_VlrNf, d_DtLan, a_Itens, @cMsgError)
					// =================== FIM GRAVACAO DA DISTRIBUICAO DO RATEIO - TABELA CUSTOMIZADA J2A ZJW ============================
					//=====================================================================================================================
					If (l_RetZJW)
						RecLock("SF1",.F.)
						SF1->F1_XDISTR := "S"
						MsUnLock()
						//Grava o campo S no campo D1_XRATFIE
						dbSelectArea("SD1")
						dbSetOrder(1)
						If (dbSeek( xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA ))
							While SD1->(!Eof() ) .And. ( SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA == xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA )
								RecLock("SD1",.F.)
								SD1->D1_XRATFIE := "S"
								/* - Descomentar Item caucao Planilha
								If ( o_DocEntr:VALOR_CAUCAO > 0 )
									SD1->D1_FSCAUCA:= o_DocEntr:VALOR_CAUCAO
								EndIf
								*/
								MsUnLock()
								SD1->( dbSkip() )
							EndDo
						EndIf

						// =================== Contabilizacao OnLine da Distribuicao 17/06/2019 ============================
						l_DistOnline:= SuperGetMV("FS_CONDIST",.F.,.F.) //Infoma se contabiliza OnLine a distribuicao. 13/06/2019
						//Variaveis que serao usadas no fonte fctba014
						c_Fil		:= SF1->F1_FILIAL
						c_Doc		:= SF1->F1_DOC
						c_Serie		:= SF1->F1_SERIE
						c_Fornece	:= SF1->F1_FORNECE
						c_Loja		:= SF1->F1_LOJA
						c_Esp		:= SF1->F1_ESPECIE
						If( l_DistOnline ) //Se contabiliza OnLine a Distribuicao.
							DbSelectArea("ZJW")
							DbSetOrder(1)
							If( DbSeek( c_Fil + c_Doc + c_Serie + c_Esp + c_Fornece + c_Loja ) ) //VERIFICA SE EXISTE DISTRIBUICAO - ZJW
								CUSUARIO:= "123456WS" //Fiz isso para gravar WS no LP pois eh usado a variavel cusuario nos LP's de contabilizacao
								u_FCTBA014( "ZJW" )
							EndIf
						EndIf
						// =================== Contabilizacao OnLine da Distribuicao 17/06/2019 ============================

						//Regra para buscar o banco/agencia/conta baseado no Centro de custo e Item contabil e gravar no SE2
						c_AuxBan:= ""
						c_AuxAge:= ""
						c_AuxCon:= ""
						p		:= 1
						If ( Len(o_DocEntr:ITEND1[p]:ITENZJW) > 0 )
							_nItRat:= 0
							c_AuxCC:= ""
							c_AuxIt:= ""
							l_TemBanco:= .F.
							If !Empty(o_DocEntr:ITEND1[p]:ITENZJW[1]:ZJW_CC) .Or. !Empty(o_DocEntr:ITEND1[p]:ITENZJW[1]:ZJW_ITEM)
								_nItRat 	:= Len(o_DocEntr:ITEND1[p]:ITENZJW)
								For x := 1 to _nItRat
									c_AuxCC:= PADR(Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_CC), TAMSX3("ZZK_CC")[1])
									c_AuxIt:= PADR(Alltrim(o_DocEntr:ITEND1[p]:ITENZJW[x]:ZJW_ITEM), TAMSX3("ZZK_ITEM")[1])
									DbSelectArea("ZZK")
									DbSetOrder(2)
									If DbSeek(xFilial("ZZK")+c_AuxCC+c_AuxIt) //Pega o primeiro banco para o Cr e Item
										c_AuxBan:= ZZK->ZZK_BANCO
										c_AuxAge:= ZZK->ZZK_AGENCI
										c_AuxCon:= ZZK->ZZK_CONTA
										l_TemBanco:= .T.
										Exit
									EndIf
								Next
								If !(l_TemBanco) //Se nao achou a amarracao para Cr e Item, pega o banco que estiver como principal na empresa
									cQuery := ""
									cQuery += "SELECT ZZK_BANCO, ZZK_AGENCI, ZZK_CONTA FROM " + RetSqlName( "ZZK" ) + " ZZK "
									cQuery += "WHERE "
									cQuery += "ZZK_FILIAL = '" + xFilial( "ZZK" ) + "' AND "
									cQuery += "ZZK_PRINCI = '1' AND "
									cQuery += "D_E_L_E_T_ = ' '
									TCQUERY cQuery ALIAS QRY NEW
									If !(QRY->(Eof()))
										c_AuxBan:= QRY->ZZK_BANCO
										c_AuxAge:= QRY->ZZK_AGENCI
										c_AuxCon:= QRY->ZZK_CONTA
									EndIf
									DbSelectArea("QRY")
									QRY->(DbCloseArea())
								EndIf
							EndIf
						EndIf
					Else
						::o_Retorno:l_Status	:= .F.
						::o_Retorno:c_Mensagem	:= cMsgError
						Return(.T.)
					EndIf
				Else //Quando nao tem distribuicao
					c_AuxBan:= ""
					c_AuxAge:= ""
					c_AuxCon:= ""
					p		:= 1
					_nItRat:= 0
					c_AuxCC:= ""
					c_AuxIt:= ""
					l_TemBanco:= .F.
					If !Empty(o_DocEntr:ITEND1[p]:D1_CC) .Or. !Empty(o_DocEntr:ITEND1[p]:D1_ITEMCTA)
						_nItRat 	:= Len(o_DocEntr:ITEND1)
						For x := 1 to _nItRat
							c_AuxCC:= PADR(Alltrim(o_DocEntr:ITEND1[p]:D1_CC), TAMSX3("ZZK_CC")[1])
							c_AuxIt:= PADR(Alltrim(o_DocEntr:ITEND1[p]:D1_ITEMCTA), TAMSX3("ZZK_ITEM")[1])
							DbSelectArea("ZZK")
							DbSetOrder(2)
							If DbSeek(xFilial("ZZK")+c_AuxCC+c_AuxIt) //Pega o primeiro banco para o Cr e Item
								c_AuxBan:= ZZK->ZZK_BANCO
								c_AuxAge:= ZZK->ZZK_AGENCI
								c_AuxCon:= ZZK->ZZK_CONTA
								l_TemBanco:= .T.
								Exit
							EndIf
						Next
						If !(l_TemBanco) //Se nao achou a amarracao para Cr e Item, pega o banco que estiver como principal na empresa
							cQuery := ""
							cQuery += "SELECT ZZK_BANCO, ZZK_AGENCI, ZZK_CONTA FROM " + RetSqlName( "ZZK" ) + " ZZK "
							cQuery += "WHERE "
							cQuery += "ZZK_FILIAL = '" + xFilial( "ZZK" ) + "' AND "
							cQuery += "ZZK_PRINCI = '1' AND "
							cQuery += "D_E_L_E_T_ = ' '
							TCQUERY cQuery ALIAS QRY NEW
							If !(QRY->(Eof()))
								c_AuxBan:= QRY->ZZK_BANCO
								c_AuxAge:= QRY->ZZK_AGENCI
								c_AuxCon:= QRY->ZZK_CONTA
							EndIf
							DbSelectArea("QRY")
							QRY->(DbCloseArea())
						EndIf
					EndIf
				EndIf

				//Preenche a natureza do titulo
				DBSELECTAREA("SE2")
				DBSETORDER(6)
				If (DBSEEK(XFILIAL("SE2")+c_For+c_Loj+c_Ser+c_Doc))
					While !(SE2->(Eof())) .And. (SE2->E2_FILIAL+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM == XFILIAL("SE2")+c_For+c_Loj+c_Ser+c_Doc)
						RecLock("SE2",.F.)
						SE2->E2_ZBANCO  := c_AuxBan
						SE2->E2_ZAGENCI := c_AuxAge
						SE2->E2_ZCONTA  := c_AuxCon
						SE2->E2_XBANCO  := Posicione("SA2",1,xFilial("SA2")+c_For+c_Loj,"A2_BANCO")
						SE2->E2_XAGENCI := SA2->A2_AGENCIA
						SE2->E2_XCONTA  := SA2->A2_NUMCON
						SE2->E2_XTPCONT	:= SA2->A2_XTPCONT
						//Se o banco de pagamento for igual ao banco do fornecedor, o modelo sera 01, caso contrario 41
						If (Alltrim(c_AuxBan) == Alltrim(SE2->E2_XBANCO))
							SE2->E2_XMODELO := "01"
						Else
							SE2->E2_XMODELO := "41"
						EndIf
						MsUnLock()
						SE2->(DbSkip())
					EndDo
				EndIf
				//Preenche o historico no titulo principal e nos titulos de impostos
				DBSELECTAREA("SE2")
				DBSETORDER(1)
				If (DBSEEK(XFILIAL("SE2")+c_Ser+c_Doc))
					While !(SE2->(Eof())) .And. (SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM == XFILIAL("SE2")+c_Ser+c_Doc)
						RecLock("SE2",.F.)
						SE2->E2_HIST	:= Alltrim(o_DocEntr:XHISTORICO)
						SE2->E2_XHIST	:= Alltrim(o_DocEntr:XHISTORICO)
						MsUnLock()
						SE2->(DbSkip())
					EndDo
				EndIf
				//Grava o anexo no banco de conhecimento
				If Len(o_DocEntr:XMULTARQ) > 0
					For p:= 1 To Len(o_DocEntr:XMULTARQ)
						If !(Empty(o_DocEntr:XMULTARQ[p]:XNOMEARQ))
							cDirDocs := MsDocPath()
							c_Objeto:= Alltrim(o_DocEntr:XMULTARQ[p]:XNOMEARQ)//+".pdf"
							If File( cDirDocs + "\" + c_Objeto )
								c_Entida:= c_Doc+c_Ser+c_For+c_Loj
								//Grava o documento no banco de conhecimento caso nao exista e retorna o codigo do objeto
								c_CodObj:= f_GrvConhecimento(c_Objeto)
								c_CodObj:= PADR(Alltrim(c_CodObj), TAMSX3("AC9_CODOBJ")[1])
								cQuery := ""
								cQuery += "SELECT * FROM " + RetSqlName( "AC9" ) + " AC9 "
								cQuery += "WHERE "
								cQuery += "AC9_FILIAL='" + xFilial( "AC9" )     + "' AND "
								cQuery += "AC9_FILENT='" + o_Empresa:c_Filial   + "' AND "
								cQuery += "AC9_CODENT='" + c_CodObj             + "' AND "
								cQuery += "AC9_ENTIDA= 'SF1' AND "
								cQuery += "D_E_L_E_T_=' '
								TCQUERY cQuery ALIAS QRY NEW
								If (QRY->(Eof()))
									DbSelectArea("AC9")
									RecLock("AC9",.T.)
									AC9->AC9_FILIAL := xFilial( "AC9" )
									AC9->AC9_FILENT := o_Empresa:c_Filial
									AC9->AC9_ENTIDA := "SF1"
									AC9->AC9_CODENT := c_Entida
									AC9->AC9_CODOBJ	:= c_CodObj
									MsUnLock()
								EndIf
								DbSelectArea("QRY")
								QRY->(DbCloseArea())
							EndIf
						EndIf
					Next
				EndIf

				//Gravacao do titulo de caucao - 18/04/2019
				/* - Descomentar Item caucao Planilha
				If ( o_DocEntr:VALOR_CAUCAO > 0 )
					a_Ret:= {}
					DBSELECTAREA("SE2")
					DBSETORDER(6)
					If (DBSEEK(XFILIAL("SE2")+c_For+c_Loj+c_Ser+c_Doc))
						a_Ret:= u_FCOMA006(o_DocEntr:VALOR_CAUCAO)
						If( a_Ret[1][1] = .F. )
							::o_Retorno:l_Status	:= .F.
							::o_Retorno:c_Mensagem	:= a_Ret[2]
							Conout("FFIEBW01 - mtdDocEntrada: "+a_Ret[2])
							Return(.T.)
						EndIf
					EndIf
				EndIf
				*/
				::o_Retorno:l_Status	:= .T.
				::o_Retorno:c_Mensagem	:= "Nota de entrada: "+o_Empresa:c_Filial+"/"+Alltrim(c_Doc)+"/"+c_Ser+"/"+c_For+"/"+Alltrim(c_Loj)+" gravada com sucesso."
				Conout("FFIEBW01 - mtdDocEntrada: Nota de entrada: "+o_Empresa:c_Filial+"/"+c_Doc+"/"+c_Ser+"/"+c_For+"/"+Alltrim(c_Loj)+" gravada com sucesso.")
				/* Comentado 22/03/2019. POr conta do ajuste das notas que nao tem distribuicao.
				//O fonte u_CTBA03R precisa dos registros da tabela ZJW gravados, por isso coloquei a chamada apos a transacao da gravacao da nota.
				If (l_RetZJW)
					//Inicio do Trecho copiado do fonte MT100TOK da J2A =====================================
					CNFISCAL:= c_Doc
					CSERIE	:= c_Ser
					CESPECIE:= c_Esp
					CA100FOR:= c_For
					CLOJA	:= c_Loj
					CTIPO	:= c_Tipo
					DDEMISSAO:= d_Emis
					l_03Ret:= .T.
					//15/10/2018 - Comentado a chamada do fonte abaixo que fazia a contabilziacao da nota. A contabilizacao sera off por outra rotina a ser desenvolvida.
					//If FindFunction("u_CTBA03R")  //Contabilizacao da distribuicao do rateio - FOnte da J2A
						//l_03Ret:= u_CTBA03R(.T., @c_ErrWS)
					//Endif
					//Fim do trecho copiado do fonte MT100TOK da J2A =====================================
				EndIf
				//If (l_03Ret)
				*/
				/*Else
					c_ErrWS:=  NoAcentoESB(c_ErrWS)
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "Ocorreu um erro na contabilizacao dessa nota. Mensagem: "+c_ErrWS
				EndIf*/
				/*Else
				DbSelectArea("ZJW") //RATEIO PELO COMPRAS
				ZJW->(DbSetOrder(1))
				If DbSeek(o_Empresa:c_Filial + c_Doc + c_Ser + Padr(Alltrim(o_DocEntr:F1_ESPECIE),TamSX3("F1_ESPECIE")[1]) + c_For+c_Loj) // FECHOU SEM SALVAR E ENCONTROU RATEIO REALIZADO
					While ZJW->(!EOF())
						If (o_Empresa:c_Filial + c_Doc + c_Ser + Padr(Alltrim(o_DocEntr:F1_ESPECIE),TamSX3("F1_ESPECIE")[1]) + c_For + c_Loj) == (ZJW->ZJW_FILIAL + ZJW->ZJW_DOC + ZJW->ZJW_SERIE + ZJW->ZJW_ESPECI + ZJW->ZJW_FORNEC + ZJW->ZJW_LOJA)
							RecLock("ZJW",.F.)
							ZJW->(DbDelete())
							ZJW->(MsUnLock())
						End
						ZJW->(DbSkip())
					EndDo
				EndIf
				::o_Retorno:l_Status	:= .T.
				::o_Retorno:c_Mensagem	:= "Nota de entrada: "+o_Empresa:c_Filial+"/"+c_Doc+"/"+c_Ser+"/"+c_For+"/"+Alltrim(c_Loj)+" excluida com sucesso."
				Conout("FFIEBW01 - mtdDocEntrada: Nota de entrada: "+o_Empresa:c_Filial+"/"+c_Doc+"/"+c_Ser+"/"+c_For+"/"+Alltrim(c_Loj)+" excluida com sucesso.")
				*/
			EndIf
		EndIf

	End TRANSACTION
	//RpcClearEnv() //Limpa o ambiente, liberando a licenca e fechando as conexoes

Return(.T.)
/*/{Protheus.doc} f_GrvZJW
Funcao que grava a distribuicao do rateio - tabela ZJW
@author Totvs-BA
@since 05/07/2018
@version 1.0
@return Nil, Funcao nao tem retorno
@param c_Ret tem que ser uma variavel passada por referencia. Sera a variavel que retornara a mensagem de retorno
/*/
Static Function f_GrvZJW(c_Fil, c_Doc, c_Ser, c_Esp, d_Emissao, d_DtDig, c_For, c_Loj, n_VlrNf, d_DtLan, a_Itens, cMsgError)
	Local lOk	:= .F.
	Local c_It	:=""
	Local m		:= 0
	For m:= 1 To Len(a_Itens)
		If (c_It <> a_Itens[m][1])
			c_ZJWCod:= GETSXENUM('ZJW','ZJW_COD')
			c_It:= a_Itens[m][1]
		EndIf
		RecLock("ZJW",.T.)
		ZJW->ZJW_FILIAL		:= c_Fil 						//Filial
		ZJW->ZJW_COD		:= c_ZJWCod					 	//Codigo Chave
		ZJW->ZJW_DOC		:= c_Doc 						//No Documento
		ZJW->ZJW_SERIE		:= c_Ser 						//Serie NF
		ZJW->ZJW_ESPECI		:= c_Esp 						//Especie Doc
		ZJW->ZJW_EMISSA		:= d_Emissao					//Data Emissao
		ZJW->ZJW_FORNEC		:= c_For 						//Cod Fornec
		ZJW->ZJW_LOJA		:= c_Loj 						//Loja
		ZJW->ZJW_VLRNF		:= n_VlrNf 						//Vlr Tot NF
		//ZJW->ZJW_DTLANC		:= d_DtLan 						//Data do Lancamnto
		ZJW->ZJW_ITNF	:= a_Itens[m][1] 					//Item NF
		ZJW->ZJW_CODPRO	:= a_Itens[m][2]					//Cod. Produto
		ZJW->ZJW_VLRITE	:= a_Itens[m][3] 					//Vlr Item(R$)
		ZJW->ZJW_LINHA	:= a_Itens[m][4]					//Item
		ZJW->ZJW_FILDES	:= a_Itens[m][5] 					//Fil. Destino
		ZJW->ZJW_CONTA	:= a_Itens[m][6] 					//C. Contabil

		//Quando o valor for zerado, faz o calculo do percentual
		If (a_Itens[m][7] = 0)
			ZJW->ZJW_VALOR	:= ((a_Itens[m][3]*a_Itens[m][8])/100)//Valor
		Else
			ZJW->ZJW_VALOR	:= a_Itens[m][7] 				//Valor
		EndIf
		//Quando o percentual for zerado, faz o calculo do valor
		If (a_Itens[m][8] = 0)
			ZJW->ZJW_PERC	:= ((ZJW->ZJW_VALOR*100)/a_Itens[m][3])//(%) Rateio
		Else
			ZJW->ZJW_PERC	:= a_Itens[m][8] 					//(%) Rateio
		EndIf
		ZJW->ZJW_ITEM	:= a_Itens[m][9] 					//Cr - Item Contabil
		ZJW->ZJW_CC		:= a_Itens[m][10] 					//Uo - Centro de Custo
		ZJW->ZJW_CLVL	:= a_Itens[m][11] 					//Projeto - Classe de Valor
		ZJW->ZJW_DTDIG	:= d_DtDig
		MsUnLock()
		lOk		:= .T.
	Next

	If( lOk )
		//Verifica se o valor calculado ficou com diferenca de centavos
		c_Qry1:= "SELECT * " + CHR(13)+CHR(10)
		c_Qry1+= "FROM " + RetSQLName("ZJW") + " ZJW " + CHR(13)+CHR(10)
		c_Qry1+= "WHERE ZJW.D_E_L_E_T_ = '' " + CHR(13)+CHR(10)
		c_Qry1+= "AND ZJW_FILIAL = '"+c_Fil+"' "+ CHR(13)+CHR(10)
		c_Qry1+= "AND ZJW_DOC 	 = '"+c_Doc+"' "+ CHR(13)+CHR(10)
		c_Qry1+= "AND ZJW_SERIE  = '"+c_Ser+"' "+ CHR(13)+CHR(10)
		c_Qry1+= "AND ZJW_ESPECI = '"+c_Esp+"' "+ CHR(13)+CHR(10)
		c_Qry1+= "AND ZJW_FORNEC = '"+c_For+"' "+ CHR(13)+CHR(10)
		c_Qry1+= "AND ZJW_LOJA   = '"+c_Loj+"' "+ CHR(13)+CHR(10)
		c_Qry1+= "ORDER BY ZJW_FILIAL, ZJW_DOC, ZJW_SERIE, ZJW_ESPECI, ZJW_FORNEC, ZJW_LOJA, ZJW_ITNF
		TCQUERY c_Qry1 ALIAS QRY1 NEW
		DBSELECTAREA("QRY1")

		While ( QRY1->(!Eof()) )
			n_VlrDist	:= 0
			n_VlrItem	:= 0
			c_It		:= QRY1->ZJW_ITNF
			c_CodPr		:= ""
			While ( c_It == QRY1->ZJW_ITNF )
				n_VlrDist+= QRY1->ZJW_VALOR
				n_VlrItem:= QRY1->ZJW_VLRITE
				c_CodPr	 := QRY1->ZJW_CODPRO
				QRY1->( DbSkip() )
			EndDo
			If ( n_VlrDist <> n_VlrItem )
				n_DifCen:= (n_VlrItem - n_VlrDist)
				If ( n_DifCen = 0)
					//nao faz nada
				Else
					DbSelectArea("ZJW")
					ZJW->(DbSetOrder(1))
					If DbSeek(c_Fil + c_Doc + c_Ser + c_Esp + c_For + c_Loj + c_CodPr + c_It)
						If ( n_DifCen > 0) //Para os casos que a lancou a mais ou a menos.
							RecLock("ZJW",.F.)
							ZJW->ZJW_VALOR+= n_DifCen
							MsUnLock()
						Else
							RecLock("ZJW",.F.)
							ZJW->ZJW_VALOR-= (n_DifCen * -1)
							MsUnLock()
						EndIf
					EndIf
				EndIf
			EndIf
		EndDo
		DBSELECTAREA("QRY1")
		QRY1->( DbCloseArea() )
	EndIf

Return(lOk)

/*/{Protheus.doc} mtdBxPagar
Metodo de baixa
@author Totvs-BA
@since 05/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
//metodo de baixa do contas a pagar
WSMETHOD mtdBxPagar WSRECEIVE o_Seguranca, o_Empresa, o_BxPag, o_TitPA WSSEND o_Retorno WSSERVICE FFIEBW01

	Local a_Baixa 		:= {}
	Local a_PasRec		:= {}
	Local a_RecSE2		:= {}
	Local a_RecPA		:= {}
	Local l_Contabiliza	:= .T.
	Local l_Aglutina	:= .F.
	Local l_Digita		:= .F.
	Local l_Juros		:= .F.
	Local l_Desconto	:= .F.
	Local l_Comissao	:= .F.
	Local d_DtBaixa		:= dDataBase
	Local c_NPas		:= ""
	Local l_TemPA		:= .F.
	Local c_ForBx		:= ""
	Local c_LojBx		:= ""
	Local a_Motsbx		:= {}
	Local l_Compensou	:= .F.
	Local i,p,u			:= 0
	Local d_DataBk		:= DDATABASE
	Local l_Erro		:= .F.
	Local n_ValPa		:= 0

	PRIVATE lMsErroAuto 	:= .F.
	Private lNoMbrowse		:= .F. //Variavel logica que informa se deve ou nao ser apresentado o Browse da rotina baixas a receber.

	::o_Retorno	:= WSCLASSNEW("strRetorno")

	If !(f_VldFilEmp(o_Empresa:c_Empresa,o_Empresa:c_Filial))
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Codigo de Empresa/Filial nao existe."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdBxPagar: Codigo de Empresa/Filial nao existe.")
		Return(.T.)
	EndIf

	//Loga na filial solicitada
	RpcSetType(3)
	RpcSetEnv(o_Empresa:c_Empresa,o_Empresa:c_Filial, "integracao", "fieb123")

	//Posiciona na empresa e filial passada
	dbSelectArea("SM0")
	dbSeek(o_Empresa:c_Empresa+o_Empresa:c_Filial)

	cFilAnt:= o_Empresa:c_Filial

	c_UserWS	:= Upper(ALLTRIM(SUPERGETMV("FS_FIUSRWS",,"totvs_fieb")))
	c_PswWS		:= Upper(ALLTRIM(SUPERGETMV("FS_FIPSWWS",,"totvs@123")))

	//Validando o usuario e senha
	If ( Upper(o_Seguranca:c_Usuario) <> Upper(c_UserWS) )
		::o_Retorno:l_Status		:= .F.
		::o_Retorno:c_Mensagem		:= "Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdBxPagar: Tentativa de acesso ao WS nao permitida. Usuario de acesso ao WS invalido.")
		Return(.T.)
	ElseIf ( Upper(o_Seguranca:c_Senha) <> Upper(c_PswWS) )
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdBxPagar: Tentativa de acesso ao WS nao permitida. Senha de validacao de acesso ao WS invalida.")
		Return(.T.)
	EndIf

	l_TemPA:= .F.
	//Testa se tem PA
	For p:= 1 To Len(o_TitPA:TITPAS)
		If !(Empty(o_TitPA:TITPAS[p]:E2_NUM)) .Or. !(Empty(o_TitPA:TITPAS[p]:E2_PARCELA)) .Or. !(Empty(o_TitPA:TITPAS[p]:E2_PREFIXO)) .Or. !(Empty(o_TitPA:TITPAS[p]:E2_TIPO))
			l_TemPA:= .T.
			Exit
		EndIf
	Next

	If Empty(o_BxPag:CGC)
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Informe o CNPJ/CPF do fornecedor do titulo."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdBxPagar: Informe o CNPJ/CPF do fornecedor do titulo.")
		Return(.T.)
	EndIf

	DBSELECTAREA("SA2")
	DBSETORDER(3)
	If !(DBSEEK(XFILIAL("SA2")+Alltrim(o_BxPag:CGC)))
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "CNPJ/CPF "+Alltrim(o_BxPag:CGC)+" nao encontrado na base de dados do protheus."+CHR(13)+CHR(10)
		Conout("FFIEBW01 - mtdBxPagar: CNPJ/CPF "+Alltrim(o_BxPag:CGC)+" nao encontrado na base de dados do protheus.")
		//Volta a database
		DDATABASE:= d_DataBk
		Return(.T.)
	Else
		c_ForBx	:= SA2->A2_COD
		c_LojBx	:= SA2->A2_LOJA
	EndIf

	//Verifica se tem PA para fazer a baixa por compensacao.
	If ( l_TemPA )
		For p:= 1 To Len(o_TitPA:TITPAS)
			If Empty(o_TitPA:TITPAS[p]:E2_NUM)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe o numero do titulo de PA."
				Conout("FFIEBW01 - mtdBxPagar: Informe o numero do titulo de PA.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
				Exit
			ElseIf Empty(o_TitPA:TITPAS[p]:E2_TIPO)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe o tipo do titulo de PA."
				Conout("FFIEBW01 - mtdBxPagar: Informe o tipo do titulo de PA.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
				Exit
			ElseIf (o_TitPA:TITPAS[p]:VALORPA <= 0)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe o valor do titulo de PA."
				Conout("FFIEBW01 - mtdBxPagar: Informe o valor do titulo de PA.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
				Exit
			EndIf
			If (Upper(Alltrim(o_TitPA:TITPAS[p]:E2_TIPO)) <> "PA")
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Tipo invalido. Informar PA."
				Conout("FFIEBW01 - mtdBxPagar: Tipo invalido. Informar PA.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
				Exit
			EndIf
			c_Pre:= PADR(Alltrim(o_TitPA:TITPAS[p]:E2_PREFIXO), TAMSX3("E2_PREFIXO")[1])
			c_Num:= PADR(Alltrim(o_TitPA:TITPAS[p]:E2_NUM), TAMSX3("E2_NUM")[1])
			c_Par:= PADR(Alltrim(o_TitPA:TITPAS[p]:E2_PARCELA), TAMSX3("E2_PARCELA")[1])
			c_Tip:= PADR(Alltrim(o_TitPA:TITPAS[p]:E2_TIPO), TAMSX3("E2_TIPO")[1])

			DBSELECTAREA("SE2")
			DBSETORDER(1)
			If !(DBSEEK(o_Empresa:c_Filial+c_Pre+c_Num+c_Par+c_Tip+c_ForBx+c_LojBx))
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Titulo de PA ("+o_Empresa:c_Filial+c_Pre+c_Num+c_Par+c_Tip+c_ForBx+c_LojBx+") nao encontrado com os parametros passados."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdBxPagar: Titulo de PA ("+o_Empresa:c_Filial+c_Pre+c_Num+c_Par+c_Tip+c_ForBx+c_LojBx+") nao encontrado com os parametros passados.")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			Else
				If (SE2->E2_SALDO = 0)
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "O titulo de PA ("+SE2->E2_FILIAL+"-"+SE2->E2_PREFIXO+"-"+SE2->E2_NUM+"-"+SE2->E2_PARCELA+"-"+SE2->E2_TIPO+"-"+SE2->E2_FORNECE+"-"+SE2->E2_LOJA+") ja foi totalmente baixado."
					Conout("FFIEBW01 - mtdBxPagar: O titulo de PA ("+SE2->E2_FILIAL+"-"+SE2->E2_PREFIXO+"-"+SE2->E2_NUM+"-"+SE2->E2_PARCELA+"-"+SE2->E2_TIPO+"-"+SE2->E2_FORNECE+"-"+SE2->E2_LOJA+") ja foi totalmente baixado.")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				ElseIf ( o_TitPA:TITPAS[p]:VALORPA > SE2->E2_SALDO)
					::o_Retorno:l_Status	:= .F.
					::o_Retorno:c_Mensagem	:= "O valor informado para compensacao eh superior ao saldo do PA ("+SE2->E2_FILIAL+"-"+SE2->E2_PREFIXO+"-"+SE2->E2_NUM+"-"+SE2->E2_PARCELA+"-"+SE2->E2_TIPO+"-"+SE2->E2_FORNECE+"-"+SE2->E2_LOJA+")."
					Conout("FFIEBW01 - mtdBxPagar: O valor informado para compensacao eh superior ao saldo do PA ("+SE2->E2_FILIAL+"-"+SE2->E2_PREFIXO+"-"+SE2->E2_NUM+"-"+SE2->E2_PARCELA+"-"+SE2->E2_TIPO+"-"+SE2->E2_FORNECE+"-"+SE2->E2_LOJA+").")
					//Volta a database
					DDATABASE:= d_DataBk
					Return(.T.)
				EndIf
			EndIf
		Next
	EndIf
	a_PasRec	:= {}

	c_PreBx:= PADR(Alltrim(o_BxPag:E2_PREFIXO), TAMSX3("E2_PREFIXO")[1])
	c_NumBx:= PADR(Alltrim(o_BxPag:E2_NUM), TAMSX3("E2_NUM")[1])
	c_ParBx:= PADR(Alltrim(o_BxPag:E2_PARCELA), TAMSX3("E2_PARCELA")[1])
	c_TipBx:= PADR(Alltrim(o_BxPag:E2_TIPO), TAMSX3("E2_TIPO")[1])

	//FAZ A BAIXA DOS PAS
	For p:= 1 To Len(o_TitPA:TITPAS)
		l_Erro	:= .F.
		a_RecPA	:= {}
		a_RecSE2:= {}

		c_Pre:= PADR(Alltrim(o_TitPA:TITPAS[p]:E2_PREFIXO), TAMSX3("E2_PREFIXO")[1])
		c_Num:= PADR(Alltrim(o_TitPA:TITPAS[p]:E2_NUM), TAMSX3("E2_NUM")[1])
		c_Par:= PADR(Alltrim(o_TitPA:TITPAS[p]:E2_PARCELA), TAMSX3("E2_PARCELA")[1])
		c_Tip:= PADR(Alltrim(o_TitPA:TITPAS[p]:E2_TIPO), TAMSX3("E2_TIPO")[1])

		dbSelectArea("SE2")
		dbSetOrder(6)�// E2_FILIAL, E2_CLIENTE, E2_LOJA, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, R_E_C_N_O_, D_E_L_E_T_
		IF dbSeek(Alltrim(o_Empresa:c_Filial)+c_ForBx+c_LojBx+c_Pre+c_Num+c_Par+c_Tip) //Posiciona no RA NA FILIAL PASSADA
			nRecnoPA�:= RECNO()
			aAdd(a_RecPA,nRecnoPA)
			aAdd(a_PasRec,nRecnoPA)
			n_ValPa:= SE2->E2_SALDO
		EndIf

		dbSelectArea("SE2")
		dbSetOrder(6)�// E2_FILIAL, E2_CLIENTE, E2_LOJA, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, R_E_C_N_O_, D_E_L_E_T_
		dbSeek(XFILIAL("SE2")+c_ForBx+c_LojBx+c_PreBx+c_NumBx+c_ParBx+c_TipBx)//Posiciona no titulo a ser baixado
		nRecnoE2�	:= RECNO()

		SE2->(dbSetOrder(1))�//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
		��
		a_RecSE2�:= { nRecnoE2 }
		If MaIntBxCP(2,a_RecSE2,,a_RecPA,,{l_Contabiliza,l_Aglutina,l_Digita,l_Juros,l_Desconto,l_Comissao},,,,,d_DtBaixa)
			//Compensou
		Else
			l_Erro:= .T.
			Exit
		EndIf
	Next
	If (l_Erro)
		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= "Nao foi possivel a compensacao do titulo do adiantamento"
		Conout("FFIEBW01 - mtdBxPagar: Nao foi possivel a compensacao do titulo do adiantamento.")
		//Volta a database
		DDATABASE:= d_DataBk
		Return(.T.)
	Else
		l_Compensou:= .T.
		//Verifica se ainda sobrou saldo no titulo.
		DBSELECTAREA("SE2")
		DBSETORDER(1)
		DBSEEK(XFILIAL("SE2")+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_ForBx+c_LojBx)
		If (SE2->E2_SALDO > 0)
			l_Sobrou:= .T.
		Else
			l_Sobrou:= .F.
		EndIf
	EndIf
	If !(l_Sobrou)
		c_NPas:= ""
		For u:= 1 To Len(a_PasRec)
			DbSelectArea("SE2")
			DbGoto(a_PasRec[u])
			c_NPas+= Alltrim(SE2->E2_NUM)+"-"
		Next
		c_NPas:= Substr(c_NPas,1,Len(c_NPas)-1)
		c_Mens:= "Titulo compensado ("+c_PreBx+"-"+c_NumBx+"-"+c_TipBx+"-"+c_ParBx+"-"+c_ForBx+"-"+c_LojBx+") na filial "+o_Empresa:c_Filial+" pelos PA ("+c_NPas+")."
		::o_Retorno:l_Status	:= .T.
		::o_Retorno:c_Mensagem	:= c_Mens
		Conout("FFIEBW01 - mtdBaixaTit: "+c_Mens)
	Else
		//DDATABASE:= Stod(o_BxPag:AUTDTBAIXA)
		If	(STOD(o_BxPag:AUTDTBAIXA) > dDatabase)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "A data da baixa e maior que a data atual. Baixa nao permitida. AUTDTBAIXA: "+o_BxPag:AUTDTBAIXA+". dDatabase: "+ dtos(dDatabase)+"."
			Conout("FFIEBW01 - mtdBxPagar: A data da baixa e maior que a data atual. Baixa nao permitida. AUTDTBAIXA: "+o_BxPag:AUTDTBAIXA+". dDatabase: "+ dtos(dDatabase)+".")
			//Volta a database
			DDATABASE:= d_DataBk
			Return(.T.)
		Endif
		If	(STOD(o_BxPag:AUTDTCREDITO) > dDatabase)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "A data de credito e maior que a data atual. Baixa nao permitida. AUTDTCREDITO: "+o_BxPag:AUTDTCREDITO+". dDatabase: "+ dtos(dDatabase)+"."
			Conout("FFIEBW01 - mtdBxPagar: A data de credito e maior que a data atual. Baixa nao permitida. AUTDTCREDITO: "+o_BxPag:AUTDTCREDITO+". dDatabase: "+ dtos(dDatabase)+".")
			//Volta a database
			DDATABASE:= d_DataBk
			Return(.T.)
		Endif
		If Empty(o_BxPag:AUTMOTBX)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Motivo da baixa nao foi informado."
			Conout("FFIEBW01 - mtdBxPagar: Motivo da baixa nao foi informado.")
			//Volta a database
			DDATABASE:= d_DataBk
			Return(.T.)
		EndIf
		If( Alltrim( o_BxPag:AUTMOTBX ) <> "PRV") //PROVISAO NAO MOVIMENTA BANCO 
			//Se tem saldo ainda faz a baixa normal
			If Empty(o_BxPag:AUTBANCO) .Or. Empty(o_BxPag:AUTAGENCIA) .Or. Empty(o_BxPag:AUTCONTA)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "Banco/Agencia/Conta nao informados."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdBxPagar: Banco/Agencia/Conta nao informados.")
				Return(.T.)
			EndIf
		EndIf
		If (o_BxPag:AUTJUROS < 0)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Valor de juros informado nao eh valido."
			Conout("FFIEBW01 - mtdBxPagar: Valor de juros informado nao eh valido.")
			//Volta a database
			DDATABASE:= d_DataBk
			Return(.T.)
		EndIf
		If (o_BxPag:AUTDESCONT < 0)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Valor de desconto informado nao eh valido."
			Conout("FFIEBW01 - mtdBxPagar: Valor de desconto informado nao eh valido.")
			//Volta a database
			DDATABASE:= d_DataBk
			Return(.T.)
		EndIf

		c_Ban:= Padr(o_BxPag:AUTBANCO,TamSX3("E5_BANCO")[1])
		c_Age:= Padr(o_BxPag:AUTAGENCIA,TamSX3("E5_AGENCIA")[1])
		c_Con:= Padr(o_BxPag:AUTCONTA,TamSX3("E5_CONTA")[1])
		
		If( Alltrim( o_BxPag:AUTMOTBX ) <> "PRV") //PROVISAO NAO MOVIMENTA BANCO 
			DBSELECTAREA("SA6")
			DBSETORDER(1)
			If !DBSEEK(xFilial("SA6")+c_Ban+c_Age+c_Con)
				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= "O banco/agencia/conta informado nao existe no cadastro de bancos: "+c_Ban+"/"+c_Age+"/"+c_Con
				Conout("FFIEBW01 - mtdBxPagar: O banco/agencia/conta informado nao existe no cadastro de bancos: "+c_Ban+"/"+c_Age+"/"+c_Con)
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
		EndIf
		
		d_TesteData	:=	StoD(o_BxPag:AUTDTBAIXA)
		If valtype(d_TesteData) == "D"
			If Empty(d_TesteData)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe Data da baixa no formato [AAAAMMDD]."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdBxPagar: Informe Data de emissao no formato [AAAAMMDD].")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
		Else
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe Data da baixa no formato [AAAAMMDD]."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdBxPagar: Informe Data de emissao no formato [AAAAMMDD].")
			//Volta a database
			DDATABASE:= d_DataBk
			Return(.T.)
		EndIf
		d_TesteData	:=	StoD(o_BxPag:AUTDTCREDITO)
		If valtype(d_TesteData) == "D"
			If Empty(d_TesteData)
				::o_Retorno:l_Status		:= .F.
				::o_Retorno:c_Mensagem	:= "Informe Data do credito no formato [AAAAMMDD]."+CHR(13)+CHR(10)
				Conout("FFIEBW01 - mtdBxPagar: Informe Data do credito no formato [AAAAMMDD].")
				//Volta a database
				DDATABASE:= d_DataBk
				Return(.T.)
			EndIf
		Else
			::o_Retorno:l_Status		:= .F.
			::o_Retorno:c_Mensagem	:= "Informe Data do credito no formato [AAAAMMDD]."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdBxPagar: Informe Data do credito no formato [AAAAMMDD].")
			//Volta a database
			DDATABASE:= d_DataBk
			Return(.T.)
		EndIf

		//Valida se o periodo esta bloqueado.
		c_Err:= ""
		d_TesteData	:=	StoD(o_BxPag:AUTDTBAIXA)
		If !( f_VldDtMov( "FIN", d_TesteData, @c_Err, "P" ) )
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= c_Err
			Conout("FFIEBW01 - mtdBxPagar: "+c_Err)
			Return(.T.)
		EndIf

		c_PreBx		:= PADR(Alltrim(o_BxPag:E2_PREFIXO), TAMSX3("E2_PREFIXO")[1])
		c_NumBx		:= PADR(Alltrim(o_BxPag:E2_NUM), TAMSX3("E2_NUM")[1])
		c_ParBx		:= PADR(Alltrim(o_BxPag:E2_PARCELA), TAMSX3("E2_PARCELA")[1])
		c_TipBx		:= PADR(Alltrim(o_BxPag:E2_TIPO), TAMSX3("E2_TIPO")[1])

		DBSELECTAREA("SE2")
		DBSETORDER(1)
		If !(DBSEEK(XFILIAL("SE2")+c_PreBx+c_NumBx+c_ParBx+c_TipBx+c_ForBx+c_LojBx))
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Titulo nao encontrado com os parametros passados: ("+Alltrim( o_Empresa:c_Filial )+"-"+c_PreBx+"-"+c_NumBx+"-"+c_ParBx+"-"+c_TipBx+"-"+c_ForBx+"-"+c_LojBx+")."+CHR(13)+CHR(10)
			Conout("FFIEBW01 - mtdBxPagar: Titulo nao encontrado com os parametros passados: ("+Alltrim( o_Empresa:c_Filial )+"-"+c_PreBx+"-"+c_NumBx+"-"+c_ParBx+"-"+c_TipBx+"-"+c_ForBx+"-"+c_LojBx+").")
			//Volta a database
			DDATABASE:= d_DataBk
			Return(.T.)
		EndIf
		If (SE2->E2_SALDO = 0)
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "O titulo ("+SE2->E2_FILIAL+"-"+SE2->E2_PREFIXO+"-"+SE2->E2_NUM+"-"+SE2->E2_PARCELA+"-"+SE2->E2_TIPO+"-"+SE2->E2_FORNECE+"-"+SE2->E2_LOJA+") ja foi totalmente baixado."
			Conout("FFIEBW01 - mtdBxPagar: O titulo ("+SE2->E2_FILIAL+"-"+SE2->E2_PREFIXO+"-"+SE2->E2_NUM+"-"+SE2->E2_PARCELA+"-"+SE2->E2_TIPO+"-"+SE2->E2_FORNECE+"-"+SE2->E2_LOJA+") ja foi totalmente baixado.")
			//Volta a database
			DDATABASE:= d_DataBk
			Return(.T.)
		EndIf

		If (o_BxPag:AUTVLRPG = 0) //.And. (o_BxPag:AUTDESCONT = 0) .And. (o_BxPag:AUTJUROS = 0)
		 	::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Nao e permitida a operacao pois nao foram informados valores para baixa."
			Conout("FFIEBW01 - mtdBxPagar: Nao e permitida a operacao pois nao foram informados valores para baixa.")
			//Volta a database
			DDATABASE:= d_DataBk
			Return(.T.)
	 	EndIf
	 	If (o_BxPag:AUTVLRPG > SE2->E2_SALDO)
		 	::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "O valor do pagamento ("+cValToChar( o_BxPag:AUTVLRPG )+") nao pode ser maior do que o saldo ("+cValToChar( SE2->E2_SALDO )+") do titulo ("+SE2->E2_FILIAL+"-"+SE2->E2_PREFIXO+"-"+SE2->E2_NUM+"-"+SE2->E2_PARCELA+"-"+SE2->E2_TIPO+"-"+SE2->E2_FORNECE+"-"+SE2->E2_LOJA+")"
			Conout("FFIEBW01 - mtdBxPagar: Nao e permitida a operacao pois nao foram informados valores para baixa.")
			//Volta a database
			DDATABASE:= d_DataBk
			Return(.T.)
	 	EndIf
	 	//Verifica se o motivo de baixa existe
		a_MotsBx:= ReadMotBx() //Carrega os motivos de baixas - Funcao padrao. Fonte FinxBx - fA070Grv()
		n_PosBx := Ascan(a_MotsBx, {|x| AllTrim(SubStr(x,1,3)) == AllTrim(Upper(o_BxPag:AUTMOTBX))})
		If n_PosBx > 0
			//Existe o motivo de baixa. Nao faz nada
		Else
			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= "Motivo de baixa nao encontrado: "+Alltrim(o_BxPag:AUTMOTBX)+". Verficar o arquivo sigaadv.mot"
			Conout("FFIEBW01 - mtdBxPagar: Motivo de baixa nao encontrado: "+Alltrim(o_BxPag:AUTMOTBX)+". Verficar o arquivo sigaadv.mot")
			//Volta a database
			DDATABASE:= d_DataBk
			Return(.T.)
		EndIf

		c_MotBx   := Alltrim(o_BxPag:AUTMOTBX)
		d_DtBaixa := STOD(o_BxPag:AUTDTBAIXA)
		d_DtCred  := STOD(o_BxPag:AUTDTCREDITO)
		c_Hist    := PADR(Alltrim(o_BxPag:AUTHIST), TAMSX3("E5_HISTOR")[1])
		n_Descont := o_BxPag:AUTDESCONT
		n_Juros   := o_BxPag:AUTJUROS
		n_ValPag  := o_BxPag:AUTVLRPG

		a_Baixa := {{"E2_PREFIXO"  	,PADR(c_PreBx	, TAMSX3("E2_PREFIXO")[1])	,Nil},;
					{"E2_NUM"		,PADR(c_NumBx	, TAMSX3("E2_NUM")[1])		,Nil},;
					{"E2_PARCELA"	,PADR(c_ParBx	, TAMSX3("E2_PARCELA")[1])	,Nil},;
					{"E2_TIPO"		,PADR(c_TipBx	, TAMSX3("E2_TIPO")[1])		,Nil},;
					{"E2_FORNECE"	,PADR(c_ForBx	, TAMSX3("E2_FORNECE")[1])	,Nil},;
					{"E2_LOJA"		,PADR(c_LojBx	, TAMSX3("E2_LOJA")[1])		,Nil},;
					{"AUTMOTBX"		,PADR(c_MotBx	, TAMSX3("E5_MOTBX")[1])	,Nil},;
					{"AUTBANCO"		,c_Ban		,Nil},;
					{"AUTAGENCIA"	,c_Age		,Nil},;
					{"AUTCONTA"		,c_Con		,Nil},;
					{"AUTDTBAIXA"	,d_DtBaixa	,Nil},;
					{"AUTDTCREDITO"	,d_DtCred	,Nil},;
					{"AUTHIST"		,c_Hist		,Nil},;
					{"AUTDESCONT"  	,n_Descont	,Nil},;
					{"AUTJUROS"  	,n_Juros	,Nil},;
					{"AUTVLRPG"		,n_ValPag	,Nil}}

		lMsErroAuto    := .F.
		lMsHelpAuto    := .T.
		lAutoErrNoFile := .T.

		ACESSAPERG("FIN080", .F.)
		
		CUSUARIO:= "123456integracao"
		DbSelectArea("SX1")
		DbSetOrder(1)
		If DbSeek("FIN080    "+"03")
			RecLock("SX1",.F.)
			SX1->X1_PRESEL:= 1
			MsUnLock()
		EndIf

		Begin Transaction

			MSEXECAUTO({|x,y| FINA080(x,y)}, a_Baixa, 3)

			If lMsErroAuto
				DisarmTransaction()
				Break //Um Break, para que o fluxo seja desviado para depois do proximo comando END TRANSACTION ou a finalizacao da thread.
			Else
				::o_Retorno:l_Status:= .T.
				c_Mens:= "Titulo ("+c_PreBx+"-"+c_NumBx+"-"+c_TipBx+"-"+c_ParBx+"-"+c_ForBx+"-"+c_LojBx+") baixado na filial "+o_Empresa:c_Filial
				::o_Retorno:c_Mensagem	:= c_Mens
				Conout("FFIEBW01 - mtdBxPagar: "+c_Mens)
			EndIf

		End Transaction

		//Se deu erro no Execauto
		If lMsErroAuto
			//Regra do fonte SIESBA01 da FIEB
			If (__lSX8)
				RollBackSX8()
			EndIf

			// Tratamento da Mensagem de erro do MSExecAuto
			aLogErr  := GetAutoGRLog()
			aLogErr2 := f_TrataErro(aLogErr)
			_cMotivo := ""

			For i := 1 to Len(aLogErr2)
				_cMotivo += aLogErr2[i]
			Next

			//Exclusivo para a versao 12
			If (GetVersao(.F.) == "12")
				_cMotivo:=  NoAcentoESB(_cMotivo)
				SetSoapFault('Erro',_cMotivo)
			EndIf

			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= NoAcentoESB(_cMotivo)
			Conout("FFIEBW01 - mtdBxPagar: "+NoAcentoESB(_cMotivo))
		EndIf
	EndIf

	//Volta a database
	DDATABASE:= d_DataBk
RETURN(.T.)

/*/{Protheus.doc} f_GrvConhecimento
Funcao que grava o documento na rotina de conhecimento
@author Totvs-BA
@since 20/06/2018
@version 1.0
@return Nil, Funcao nao tem retorno
@param c_Ret tem que ser uma variavel passada por referencia. Sera a variavel que retornara a mensagem de retorno
/*/
Static Function f_GrvConhecimento(c_Objeto)
	Local c_CodObj:= ""
	DbSelectArea("ACB")
	DbSetOrder(2)
	If (DbSeek(xFilial("ACB")+c_Objeto))
		c_CodObj:= ACB->ACB_CODOBJ
	Else
		RecLock("ACB",.T.)
		ACB->ACB_FILIAL := xFilial( "ACB" )
		ACB->ACB_CODOBJ := GetSxeNum("ACB","ACB_CODOBJ")
		ACB->ACB_OBJETO := c_Objeto
		ACB->ACB_DESCRI := c_Objeto
		MsUnLock()
		c_CodObj:= ACB->ACB_CODOBJ
	EndIf
Return(c_CodObj)
/*/{Protheus.doc} f_VldRateio
funcao que valida os dados para gravacao na SEV e SEZ
@author Totvs-BA
@since 01/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
Static Function f_VldRateio(c_Tipo, c_FilTit, c_MsgVldRat)
	Local a_RatNat	:= {}
	Local a_RatCC	:= {}
	Local c_ErrMsg	:= ""
	Local o_ObjRateio
	Local c,n

	If c_Tipo = "P" //Pagar
		o_ObjRateio:= o_TitPagar:NATRATEIO

		//Valida se tem rateio por naturezas informado
		For n:= 1 To Len(o_ObjRateio)
			If Empty(o_ObjRateio[n]:EV_NATUREZ) .Or. Empty(o_ObjRateio[n]:EV_PERC) .Or. Empty(o_ObjRateio[n]:EV_VALOR)
				c_MsgVldRat:=  "Algum campo do rateio de multiplas naturezas nao foi preenchido."
				Return(.F.)
			EndIf
		Next

		For n:= 1 To Len(o_ObjRateio)

			//Valida a natureza
			dbSelectArea("SED")
			dbSetOrder(1)
			If !(dbSeek(xfilial("SED")+Alltrim(o_ObjRateio[n]:EV_NATUREZ)))
				c_MsgVldRat:= "Natureza do rateio "+Alltrim(o_ObjRateio[n]:EV_NATUREZ)+" nao encontrada na base de dados do protheus."
				Return(.F.)
			EndIf

			//Validacao para nao permitir a inclusao da mesma Natureza em mais de um item.
			If aScan(a_RatNat,Alltrim(o_ObjRateio[n]:EV_NATUREZ)) > 0
				c_MsgVldRat:= "A Natureza "+Alltrim(o_ObjRateio[n]:EV_NATUREZ)+" ja esta cadastrada em outro item da Tabela SEV)."
				Return(.F.)
			Else
				Aadd(a_RatNat,Alltrim(o_ObjRateio[n]:EV_NATUREZ))
	        Endif

	        If (o_ObjRateio[n]:EV_PERC < 0)
				c_MsgVldRat:= "O valor do percentual nao pode ser menor do que zero."
				Return(.F.)
			EndIf

			If (o_ObjRateio[n]:EV_VALOR < 0)
				c_MsgVldRat:="O valor do rateio por natureza nao pode ser menor do que zero."
				Return(.F.)
			EndIf

			a_RatCC:= {}
			If Len(o_ObjRateio[n]:CCUSTORATEIO) > 0

				//Valida se tem rateio por CC

				For c:= 1 To Len(o_ObjRateio[n]:CCUSTORATEIO)
					If !Empty(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_ITEMCTA) .And. (Empty(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_VALOR) .Or. Empty(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_PERC))
						c_MsgVldRat:= "Algum campo do rateio de multiplos CC nao foi preenchido."
						Return(.F.)
					EndIf
				Next

				For c:= 1 To Len(o_ObjRateio[n]:CCUSTORATEIO)

					//Validando o item Centro de Custo
					If !Empty(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO)
						DbSelectArea("CTT")
						CTT->(dbSetOrder(1))
						If !(CTT->(dbSeek(xFilial("CTT")+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO))))
							c_MsgVldRat:= "Centro de Custo informado para o campo EZ_CCUSTO invalido ("+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO)+")."
							Return(.F.)
						Elseif CTT->CTT_CLASSE == "1"
							c_MsgVldRat:= "Centro de Custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO)+")."
							Return(.F.)
						Elseif CTT->CTT_BLOQ == "1"
							c_MsgVldRat:= "Centro de Custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO)+")."
							Return(.F.)
						Endif
					EndIf
					//Validando o item contabil
					If !Empty(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_ITEMCTA)
						DbSelectArea("CTD")
						CTD->(dbSetOrder(1))
						If !(CTD->(dbSeek(xFilial("CTD")+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_ITEMCTA))))
							c_MsgVldRat:= "Item contabil informado para o campo EZ_ITEMCTA invalido ("+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_ITEMCTA)+")."
							Return(.F.)
						Elseif CTD->CTD_CLASSE == "1"
							c_MsgVldRat:= "Item contabil invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_ITEMCTA)+")."
							Return(.F.)
						Elseif CTD->CTD_BLOQ == "1" .or. (!Empty(CTD->CTD_DTEXSF) .and. CTD->CTD_DTEXSF < dDatabase)
							c_MsgVldRat:= "Item contabil invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_ITEMCTA)+")."
							Return(.F.)
						ElseIf (!Empty(CTD->CTD_DTEXIS) .and. dDatabase < CTD->CTD_DTEXIS)
							::o_Retorno:l_Status	:= .F.
							::o_Retorno:c_Mensagem	:= "Item contabil ("+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_ITEMCTA)+") esta com data de inicio de existencia superior a data base."+CHR(13)+CHR(10)
							Return(.T.)
						Endif
					EndIf
					//Validacao para nao permitir a inclusao da mesma CC em mais de um item.
					If !Empty(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO)
						If aScan(a_RatCC, Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO)) > 0
							c_MsgVldRat:= "O CC "+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO)+" ja esta cadastrado em outro item da Tabela SEZ)."
							Return(.F.)
						Else
							Aadd(a_RatCC, Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO))
		                Endif
		            EndIf

	                If (o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_VALOR < 0)
						c_MsgVldRat:= "O valor do percentual nao pode ser menor do que zero."
						Return(.F.)
					EndIf

					If (o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_PERC < 0)
						c_MsgVldRat:= "O valor do rateio por natureza nao pode ser menor do que zero."
						Return(.F.)
					EndIf

					//Valida se a natureza comeca com 3 OU 4 e obriga o CR (EZ_ITEMCTA)
					If (Substr( Alltrim(o_ObjRateio[n]:EV_NATUREZ),1,1 ) $ '3,4') .And. Empty(Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_ITEMCTA))
						c_MsgVldRat:= "Para naturezas que comecam com 3 ou 4 ("+Alltrim(o_ObjRateio[n]:EV_NATUREZ)+") o CR deve ser preenchido."
						Return(.F.)
					Else
						//Verifica se existe amarracao Filial + CR + UO - 11/09/2018. No conta a pagar o CC vem em branco e o item gatilha o CC na funcao de gravacao de Ev e Ez.
						If !(Empty(Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_ITEMCTA)))
							If !(VerAmarrCTA(Alltrim(c_FilTit), "", Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_ITEMCTA)))
								c_MsgVldRat:= "Nao existe amarracao (Tabela CTA) entre Filial: ("+Alltrim(c_FilTit)+"), CR: ("+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_ITEMCTA)+")."
								Return(.F.)
							EndIf
							//Valida se a conta comeca com 32 e o Cr possui o campo CTD_XRTADM = 2=Consumo;3=Corporativo;4=Unid. Compartilhadas 11/02/2019
							c_ErrMsg:= ""
							If !( f_VldCnInvest( Alltrim( o_ObjRateio[n]:EV_NATUREZ ), Alltrim( o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_ITEMCTA ), @c_ErrMsg ) )
								c_MsgVldRat:= c_ErrMsg
								Return(.F.)
							EndIf
						EndIf
					EndIf
				Next

			EndIf

		Next
	Else //Receber
		o_ObjRateio:= o_TitReceber:NATRATEIO

		//Valida se tem rateio por naturezas informado
		For n:= 1 To Len(o_ObjRateio)
			If Empty(o_ObjRateio[n]:EV_NATUREZ) .Or. Empty(o_ObjRateio[n]:EV_PERC) .Or. Empty(o_ObjRateio[n]:EV_VALOR)
				c_MsgVldRat:= "Algum campo do rateio de multiplas naturezas nao foi preenchido."
				Return(.F.)
			EndIf
		Next

		For n:= 1 To Len(o_ObjRateio)

			//Valida a natureza
			dbSelectArea("SED")
			dbSetOrder(1)
			If !(dbSeek(xfilial("SED")+Alltrim(o_ObjRateio[n]:EV_NATUREZ)))
				c_MsgVldRat:= "Natureza do rateio "+Alltrim(o_ObjRateio[n]:EV_NATUREZ)+" nao encontrada na base de dados do protheus."
				Return(.F.)
			EndIf

			//Validacao para nao permitir a inclusao da mesma Natureza em mais de um item.
			If aScan(a_RatNat,Alltrim(o_ObjRateio[n]:EV_NATUREZ)) > 0
				c_MsgVldRat:= "A Natureza "+Alltrim(o_ObjRateio[n]:EV_NATUREZ)+" ja esta cadastrada em outro item da Tabela SEV)."
				Return(.T.)
			Else
				Aadd(a_RatNat,Alltrim(o_ObjRateio[n]:EV_NATUREZ))
	        Endif

	        If (o_ObjRateio[n]:EV_PERC < 0)
				c_MsgVldRat:= "O valor do percentual nao pode ser menor do que zero."
				Return(.F.)
			EndIf

			If (o_ObjRateio[n]:EV_VALOR < 0)
				c_MsgVldRat:= "O valor do rateio por natureza nao pode ser menor do que zero."
				Return(.F.)
			EndIf

			a_RatCC:= {}
			If Len(o_ObjRateio[n]:CCUSTORATEIO) > 0
				//Valida se tem rateio por CC
				For c:= 1 To Len(o_ObjRateio[n]:CCUSTORATEIO)
					If !Empty(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_ITEMCTA) .And. (Empty(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_VALOR) .Or. Empty(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_PERC))
						c_MsgVldRat:= "Algum campo do rateio de multiplos CC nao foi preenchido."
						Return(.F.)
					EndIf
				Next

				For c:= 1 To Len(o_ObjRateio[n]:CCUSTORATEIO)

					//Validando o centro de Custo
					If !Empty(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO)
						DbSelectArea("CTT")
						CTT->(dbSetOrder(1))
						If !(CTT->(dbSeek(xFilial("CTT")+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO))))
							c_MsgVldRat:= "Centro de Custo informado para o campo EZ_CCUSTO invalido ("+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO)+")."+CHR(13)+CHR(10)
							Return(.F.)
						Elseif CTT->CTT_CLASSE == "1"
							c_MsgVldRat:= "Centro de Custo invalido. O Centro de Custo nao pode ser sintetico ("+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO)+")."+CHR(13)+CHR(10)
							Return(.F.)
						Elseif CTT->CTT_BLOQ == "1"
							c_MsgVldRat:= "Centro de Custo invalido. o Centro de Custo esta bloqueado para uso ("+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO)+")."+CHR(13)+CHR(10)
							Return(.F.)
						Endif
					EndIf
					//Validando o item contabil
					If !Empty(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_ITEMCTA)
						DbSelectArea("CTD")
						CTD->(dbSetOrder(1))
						If !(CTD->(dbSeek(xFilial("CTD")+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_ITEMCTA))))
							c_MsgVldRat:= "Item contabil informado para o campo E1_ITEMC invalido ("+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_ITEMCTA)+")."+CHR(13)+CHR(10)
							Return(.F.)
						Elseif CTD->CTD_CLASSE == "1"
							c_MsgVldRat:= "Item contabil invalido. O Item contabil nao pode ser sintetico ("+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_ITEMCTA)+")."+CHR(13)+CHR(10)
							Return(.F.)
						Elseif CTD->CTD_BLOQ == "1" .or. (!Empty(CTD->CTD_DTEXSF) .and. CTD->CTD_DTEXSF < dDatabase)
							c_MsgVldRat:= "Item contabil invalido. o Item contabil esta bloqueado para uso ("+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_ITEMCTA)+")."+CHR(13)+CHR(10)
							Return(.F.)
						ElseIf (!Empty(CTD->CTD_DTEXIS) .and. dDatabase < CTD->CTD_DTEXIS)
							::o_Retorno:l_Status	:= .F.
							::o_Retorno:c_Mensagem	:= "Item contabil ("+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_ITEMCTA)+") esta com data de inicio de existencia superior a data base."+CHR(13)+CHR(10)
							Return(.T.)
						Endif
					EndIf

					//Validacao para nao permitir a inclusao da mesma CC em mais de um item.
					If aScan(a_RatCC, Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO)) > 0
						c_MsgVldRat:= "O CC "+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO)+" ja esta cadastrado em outro item da Tabela SEZ)."+CHR(13)+CHR(10)
						Return(.F.)
					Else
						Aadd(a_RatCC, Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO))
	                Endif

	                If (o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_VALOR < 0)
						c_MsgVldRat:= "O valor do percentual nao pode ser menor do que zero."+CHR(13)+CHR(10)
						Return(.F.)
					EndIf

					If (o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_PERC < 0)
						c_MsgVldRat:= "O valor do rateio por natureza nao pode ser menor do que zero."+CHR(13)+CHR(10)
						Return(.F.)
					EndIf

					//Valida se a natureza comeca com 3 OU 4 e obriga o CR (EZ_ITEMCTA)
					If (Substr( Alltrim(o_ObjRateio[n]:EV_NATUREZ),1,1 ) $ '3,4') .And. Empty(Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_ITEMCTA))
						c_MsgVldRat:= "Para naturezas que comecam com 3 ou 4 ("+Alltrim(o_ObjRateio[n]:EV_NATUREZ)+") o CR e Uo devem ser preenchidos."
						Return(.F.)
					Else
						//Verifica se existe amarracao Filial + CR + UO - 11/09/2018
						If !(Empty(Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_ITEMCTA))) //No conta a receber o CC vem em branco e o item gatilha o CC na funcao de gravacao de Ev e Ez.
							If !(VerAmarrCTA(Alltrim(c_FilTit), "", Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_ITEMCTA)))
								c_MsgVldRat:= "Nao existe amarracao (Tabela CTA) entre Filial: ("+Alltrim(c_FilTit)+"), CR: ("+Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_ITEMCTA)+")."
								Return(.F.)
							EndIf
							//Valida se a conta comeca com 32 e o Cr possui o campo CTD_XRTADM = 2=Consumo;3=Corporativo;4=Unid. Compartilhadas 11/02/2019
							c_ErrMsg:= ""
							If !( f_VldCnInvest( Alltrim( o_ObjRateio[n]:EV_NATUREZ ), Alltrim( o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_ITEMCTA ), @c_ErrMsg ) )
								c_MsgVldRat:= c_ErrMsg
								Return(.F.)
							EndIf
						EndIf
					EndIf
				Next

			EndIf

		Next

	EndIf

Return(.T.)
/*/{Protheus.doc} mtdTitulosProv
Retorna os titulos de provisao para um determinado fornecedor
@author Totvs-BA
@since 20/05/2020
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
WSMETHOD mtdTitulosProv WSRECEIVE o_Empresa, o_Seguranca, CNPJ WSSEND TITULOS WSSERVICE FFIEBW01

	Local o_Retorno
    //Local c_Alias       := GetNextAlias()
    Local c_UserWS      := ""
    Local c_PswWS       := ""

	RpcSetType(3)
	RpcSetEnv(::o_Empresa:c_Empresa,::o_Empresa:c_Filial)

    c_UserWS	:= SUPERGETMV("FS_GEUSRWS",,"totvs_fieb")
	c_PswWS		:= SUPERGETMV("FS_GEPSWWS",,"totvs@123")

	IF ( ::o_Seguranca:c_Usuario <> c_UserWS ) .OR. ( ::o_Seguranca:c_Senha <> c_PswWS )

		o_Retorno := WSCLASSNEW("strTitulosProv")

        o_Retorno:STATUS  	:= .F.
		o_Retorno:MENSAGEM	:= "Tentativa de acesso ao WS nao permitida!"

        AADD( Self:TITULOS, o_Retorno )

		Return(.T.)

	ENDIF

	c_Qry:= "SELECT A2_NREDUZ,E2_FILIAL,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_NATUREZ,E2_PORTADO,E2_HIST,E2_FORNECE,E2_LOJA,E2_EMISSAO,E2_VENCTO,E2_VENCREA,E2_VALOR,E2_SALDO " +CHR(13)+CHR(10)
	c_Qry+= "FROM " + RetSQLName("SE2") + " E2 WITH (NOLOCK) " +CHR(13)+CHR(10)
    c_Qry+= "INNER JOIN " + RetSqlName("SA2") + " A2 (NOLOCK) ON ( A2.A2_COD = E2.E2_FORNECE AND A2.A2_LOJA = E2.E2_LOJA AND A2.A2_CGC = '"+ Alltrim( ::CNPJ ) +"' AND A2.D_E_L_E_T_ = ' ' ) " +CHR(13)+CHR(10)
    c_Qry+= "WHERE E2.D_E_L_E_T_ = ' ' AND E2_SALDO > 0  AND E2_FILIAL = '"+Alltrim( ::o_Empresa:c_Filial )+"' " +CHR(13)+CHR(10)
    MemoWrit("C:\Temp\mtdTitulosProv.sql",c_Qry)
	TCQuery c_Qry New Alias "QRY"
	
	DBSELECTAREA( "QRY" )
	While( QRY->( !Eof() ) )

		o_Retorno := WSCLASSNEW("strTitulosProv")

		o_Retorno:E2_FILIAL     := QRY->E2_FILIAL
        o_Retorno:E2_PREFIXO    := QRY->E2_PREFIXO
        o_Retorno:E2_NUM        := QRY->E2_NUM
        o_Retorno:E2_PARCELA    := QRY->E2_PARCELA
        o_Retorno:E2_TIPO	    := QRY->E2_TIPO    
        o_Retorno:E2_NATUREZ    := QRY->E2_NATUREZ	
        o_Retorno:E2_FORNECE    := QRY->E2_FORNECE	
        o_Retorno:E2_LOJA	    := QRY->E2_LOJA    
        o_Retorno:A2_NREDUZ	    := QRY->A2_NREDUZ
        o_Retorno:E2_HIST	    := QRY->E2_HIST
        o_Retorno:E2_EMISSAO    := DTOC( STOD( QRY->E2_EMISSAO ) )
        o_Retorno:E2_VENCTO	    := DTOC( STOD( QRY->E2_VENCTO ) ) 
        o_Retorno:E2_VENCREA    := DTOC( STOD( QRY->E2_VENCREA ) )	
        o_Retorno:E2_VALOR	    := QRY->E2_VALOR
        o_Retorno:E2_SALDO      := QRY->E2_SALDO
        o_Retorno:STATUS  	    := .T.
		o_Retorno:MENSAGEM	    := ""

		AADD( Self:TITULOS, o_Retorno )

		QRY->(DBSKIP())

	EndDo

QRY->(DBCLOSEAREA())

RETURN(.T.)

Static Function f_VldFilEmp(c_Emp, c_Fil)
	dbSelectArea("SM0")
	If!dbSeek(c_Emp+c_Fil)
		Return(.F.)
	EndIf

Return(.T.)
/*/{Protheus.doc} f_GravaEVEZ
funcao que grava o reteio na SEV e SEZ
@author Totvs-BA
@since 01/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
Static Function f_GravaEVEZ(c_Cliente, c_Loja, c_Tipo, c_Rot, c_Pre, c_Num, c_Par, c_Metodo, p, n_ValTitulo)
	Local o_ObjRateio
	Local c,n
	Local c_RatCC:= "2" //Nao

	If c_Rot = "R"
		If (c_Metodo == "LIQ")
			o_ObjRateio:= o_TitDestino:TITULOS[p]:NATRATEIO
		Else
			o_ObjRateio:= o_TitReceber:NATRATEIO
		EndIf
	Else
		o_ObjRateio:= o_TitPagar:NATRATEIO
	EndIf

	//Verifica se tem rateio por CC
	For n:= 1 To Len(o_ObjRateio)
		For c:= 1 To Len(o_ObjRateio[n]:CCUSTORATEIO)
			If !Empty(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO) .Or. !Empty(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_ITEMCTA) .Or. !Empty(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_VALOR) .Or. !Empty(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_PERC)
				c_RatCC:= "1" //Sim
				Exit
			EndIf
		Next
		If (c_RatCC = "1")
			Exit
		EndIf
	Next

	For n:= 1 To Len(o_ObjRateio)
		DbSelectArea("SEV")
		RecLock("SEV",.T.)
		SEV->EV_FILIAL	:= xFilial("SEV")
		SEV->EV_PREFIXO	:= PADR(Alltrim(c_Pre), TAMSX3("E1_PREFIXO")[1])
		SEV->EV_NUM		:= PADR(Alltrim(c_Num), TAMSX3("E1_NUM")[1])
		SEV->EV_PARCELA	:= PADR(Alltrim(c_Par), TAMSX3("E1_PARCELA")[1])
		SEV->EV_CLIFOR	:= PADR(c_Cliente, TAMSX3("E1_CLIENTE")[1])
		SEV->EV_LOJA	:= PADR(c_Loja, TAMSX3("E1_LOJA")[1])
		SEV->EV_TIPO	:= PADR(c_Tipo, TAMSX3("E1_TIPO")[1])
		SEV->EV_VALOR	:= o_ObjRateio[n]:EV_VALOR
		SEV->EV_NATUREZ	:= Padr(Alltrim(o_ObjRateio[n]:EV_NATUREZ),TamSx3("EV_NATUREZ")[1])
		SEV->EV_RECPAG	:= c_Rot
		If (o_ObjRateio[n]:EV_PERC = 0)
			SEV->EV_PERC	:= ((o_ObjRateio[n]:EV_VALOR*100) / n_ValTitulo)
		Else
			SEV->EV_PERC	:= o_ObjRateio[n]:EV_PERC/100
		EndIf
		SEV->EV_RATEICC	:= c_RatCC
		SEV->EV_IDENT	:= '1'
		MsUnLock()

		If (c_RatCC = "1")
			For c:= 1 To Len(o_ObjRateio[n]:CCUSTORATEIO)
				DbSelectArea("SEZ")
				RecLock("SEZ",.T.)
				SEZ->EZ_FILIAL	:= xFilial("SEZ")
				SEZ->EZ_PREFIXO	:= PADR(Alltrim(c_Pre), TAMSX3("E1_PREFIXO")[1])
				SEZ->EZ_NUM		:= PADR(Alltrim(c_Num), TAMSX3("E1_NUM")[1])
				SEZ->EZ_PARCELA	:= PADR(Alltrim(c_Par), TAMSX3("E1_PARCELA")[1])
				SEZ->EZ_CLIFOR	:= PADR(c_Cliente, TAMSX3("E1_CLIENTE")[1])
				SEZ->EZ_LOJA	:= PADR(c_Loja, TAMSX3("E1_LOJA")[1])
				SEZ->EZ_TIPO	:= PADR(c_Tipo, TAMSX3("E1_TIPO")[1])
				SEZ->EZ_VALOR	:= o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_VALOR
				SEZ->EZ_NATUREZ	:= Padr(Alltrim(o_ObjRateio[n]:EV_NATUREZ),TamSx3("EV_NATUREZ")[1])
				//SEZ->EZ_CCUSTO	:= Padr(Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_CCUSTO),TamSx3("EZ_CCUSTO")[1])

				If FindFunction("u_ONECTA2()")
					SEZ->EZ_CCUSTO := u_ONECTA2(1,Padr(Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_ITEMCTA),TamSx3("EZ_ITEMCTA")[1]))
				EndIf

				SEZ->EZ_ITEMCTA	:= Padr(Alltrim(o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_ITEMCTA),TamSx3("EZ_ITEMCTA")[1])
				SEZ->EZ_RECPAG	:= c_Rot
				If (o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_PERC = 0)
					SEZ->EZ_PERC	:= ((o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_VALOR*100) / o_ObjRateio[n]:EV_VALOR)
				Else
					SEZ->EZ_PERC	:= o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_PERC/100
				EndIf
				SEZ->EZ_IDENT	:= '1'
				MsUnLock()
			Next
		EndIf
	Next

Return()
/*/{Protheus.doc} SIESB08Fat
Emite a nota fiscal de saida
@author Totvs-BA
@since 10/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
/*Static Function SIESB08Fat(_cSerie)
	Local aPvlNfs   := {}
	Local aBloqueio := {}
	Local _cMens    := ""
	Local _aRet     := {.f.,"",""}
	Local _cArea    := GetArea()

	// Liberacao de pedido
	Ma410LbNfs(2,@aPvlNfs,@aBloqueio)

	// Checa itens liberados
	Ma410LbNfs(1,@aPvlNfs,@aBloqueio)
	// restaura SX1 da rotina de transf.

	If Empty(aBloqueio) .And. !Empty(aPvlNfs)
		// parametros da nota fiscal
		lMostraCtb := .F.
		lAglutCtb  := .F.
		lCtbOnLine := .F.
		lCtbCusto  := .F.
		lReajuste  := .F.
		lAtuSA7    := .F.
		lECF       := .F.

		// Gera nota fiscal de saida
		_cNota := MaPvlNfs(aPvlNfs,_cSerie,lMostraCtb,lAglutCtb,lCtbOnLine,lCtbCusto,lReajuste,1,1,lAtuSA7,lECF)

		// Nota gerada
		IF !Empty(_cNota)
			_aRet[1] := .t.
			_aRet[3] := _cNota
		ELSE // nao gerou a nota fiscal
			_aRet[2] := "Ocorreu um erro na geracao da nota fiscal. Verifique problema no ERP"
		ENDIF

	ELSE
		IF SC5->C5_BLQ$("1/2")
			_cMens := "Bloqueio de Regra/Verba"
		ELSEIF !Empty(SC5->C5_LIBEROK) .and. Empty(SC5->C5_NOTA) .and. Empty(SC5->C5_BLQ) .and. SIESB08BLQ(2)
			_cMens := "Bloqueio de Credito"
		ELSEIF  !Empty(SC5->C5_LIBEROK) .and. Empty(SC5->C5_NOTA) .and. Empty(SC5->C5_BLQ) .and. SIESB08BLQ(4)
			_cMens := "Bloqueio de Estoque"
		ENDIF
		_aRet[2] := _cMens
	ENDIF

	RestArea(_cArea)
Return(_aRet)*/
/*/{Protheus.doc} SIESB08BLQ
Verifica status dos pedidos com SC9
@author Totvs-BA
@since 10/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
/*Static Function SIESB08BLQ(_nOpc)
	Local _lRet    := .F.
	Local _cQuery  := ""
	Local _cArqTRB := CriaTrab(nil,.f.)
	Local _cArea   := GetArea()
	ConOut( "FFIEBW01 - " + DTOC( Date() ) + " " + Time() + " " + "Verifica Bloqueio " )
	ConOut( "FFIEBW01 - database " + DTOC(ddatabase) )
	IF _nOpc == 1 // liberado
		_cQuery := "SELECT C9_PEDIDO FROM "+RetSqlName("SC9")+" WHERE D_E_L_E_T_ = ' ' AND C9_FILIAL = '"+SC5->C5_FILIAL+"' AND C9_PEDIDO = '"+SC5->C5_NUM+"' AND C9_BLCRED = '  ' AND C9_BLEST = '  '"
	ELSEIF _nOpc == 2 // credito
		_cQuery := "SELECT C9_PEDIDO FROM "+RetSqlName("SC9")+" WHERE D_E_L_E_T_ = ' ' AND C9_FILIAL = '"+SC5->C5_FILIAL+"' AND C9_PEDIDO = '"+SC5->C5_NUM+"' AND C9_BLCRED <> '  ' AND C9_BLCRED NOT IN('10','09')"
	ELSEIF _nOpc == 3 // rejeitado
		_cQuery := "SELECT C9_PEDIDO FROM "+RetSqlName("SC9")+" WHERE D_E_L_E_T_ = ' ' AND C9_FILIAL = '"+SC5->C5_FILIAL+"' AND C9_PEDIDO = '"+SC5->C5_NUM+"' AND C9_BLCRED = '09'"
	ELSE // rejeitado
		_cQuery := "SELECT C9_PEDIDO FROM "+RetSqlName("SC9")+" WHERE D_E_L_E_T_ = ' ' AND C9_FILIAL = '"+SC5->C5_FILIAL+"' AND C9_PEDIDO = '"+SC5->C5_NUM+"' AND C9_BLEST <> '  ' AND C9_BLEST <> '10' AND C9_BLEST <> 'ZZ'"
	ENDIF
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),_cArqTRB,.t.,.t.)

	IF (_cArqTRB)->(!Eof())
		_lRet := .T.
	ENDIF

	(_cArqTRB)->(dbCloseArea())
	RestArea(_cArea)
Return(_lRet)*/
/*/{Protheus.doc} NoAcentoESB
funcao que retira os acentos
@author Totvs-BA
@since 01/10/2017
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
Static Function NoAcentoESB(cMens)
	Local _ni
	Local _s1   := "�����" + "�����" + "�����" + "�����" + "�����" + "�����" + "�����" + "�����"  + "����" + "��"
	Local _s2   := "aeiou" + "AEIOU" + "aeiou" + "AEIOU" + "aeiou" + "AEIOU" + "aeiou" + "AEIOU"  + "aoAO" + "cC"
	Local _nPos :=0
	//Local _cRet := ''

	For _ni := 1 To Len(_s1)
		IF (_nPos := At(Subs(_s1,_ni,1),cMens)) > 0
			cMens := StrTran(cMens,Subs(_s1,_ni,1),Subs(_s2,_ni,1))
		ENDIF
	Next

	cMens := StrTran( cMens, '�', ' ')		//-- Remove o Caracter 1.'o'
	cMens := StrTran( cMens, '�', ' ')		//-- Remove o Caracter 1.'a'
	cMens := StrTran( cMens, '&', ' ')		//-- Remove o Caracter &
	cMens := StrTran( cMens, '�', ' ')		//-- Remove o Caracter �

	cMens := NoAcento(cMens)
Return(AllTrim(cMens))
/*/{Protheus.doc} VerAmarrCTA
Verifica se existe amarracao do Filial/Cr/Uo com a CTA
@author Totvs-BA
@since 11/09/2018
@version 1.0
@return Nil, Funcao nao tem retorno
/*/
Static Function VerAmarrCTA(c_FilCTA, c_CCCTA, c_IteCTA)
	Local c_Qry:= ""
	Local l_Ret:= .T.
	c_Qry:= "SELECT CTA_FILIAL, CTA_CUSTO, CTA_ITEM "+chr(13)+chr(10)
	c_Qry+= "FROM "+RETSQLNAME("CTA")+" "+chr(13)+chr(10)
	c_Qry+= "WHERE D_E_L_E_T_ <> '*' "+chr(13)+chr(10)
	c_Qry+= "AND CTA_FILIAL = '"+c_FilCTA+"' "+chr(13)+chr(10)
	If !Empty(c_CCCTA)
		c_Qry+= "AND CTA_CUSTO = '"+c_CCCTA+"' "+chr(13)+chr(10)
	EndIf
	c_Qry+= "AND CTA_ITEM = '"+c_IteCTA+"' "+chr(13)+chr(10)

	TCQUERY c_Qry ALIAS QRY NEW
	dbSelectArea("QRY")
	If !(QRY->(Eof()))
		l_Ret:= .T.
	Else
		l_Ret:= .F.
	EndIf
	dbSelectArea("QRY")
	QRY->(dbCloseArea())
Return(l_Ret)

/*/{Protheus.doc} f_IDSE5
//Verifica se o ID de integracao com a SE5 proveniente de integracoes via WS ja existe na base.
@author carlo
@since 20/11/2018
@version 1.0
@return ${return}, ${return_description}
@param c_Fil, characters, descricao
@param c_Id, characters, descricao
@type function
/*/
Static Function f_IDSE5(c_Fil, c_Id, c_PreB, c_NumB, c_ParB, c_TipB, c_CliB, c_LojB, l_Canc, c_IdAco)
	Local l_Ret			:=	.F.
	Local c_Qry			:=	""
	Local c_AliasTmp	:=	{}
	Default c_IdAco		:= ""
	c_AliasTmp			:=	GetNextAlias()

	c_Qry	+=	"" 											+ENTER
	c_Qry	+=	"SELECT DISTINCT E5_FSBXRM " 				+ENTER
	c_Qry	+=	"FROM "+RetSqlName("SE5")+" E5 "			+ENTER
	c_Qry	+=	"WHERE "									+ENTER
	c_Qry	+=	"		E5.D_E_L_E_T_ 	= '' "				+ENTER
	c_Qry	+=	"AND 	E5_FILIAL		= '"+c_Fil+"' "		+ENTER
	c_Qry	+=	"AND	E5_FSBXRM		= '"+c_Id+"' "		+ENTER
	c_Qry	+=  "AND 	E5_PREFIXO 		= '"+c_PreB+"' "	+ENTER
	c_Qry	+=  "AND 	E5_NUMERO 		= '"+c_NumB+"'"		+ENTER
	c_Qry	+=  "AND 	E5_PARCELA 		= '"+c_ParB+"' "	+ENTER
	c_Qry	+=  "AND 	E5_TIPO 		= '"+c_TipB+"' "	+ENTER
	c_Qry	+=  "AND 	E5_CLIFOR 		= '"+c_CliB+"' "	+ENTER
	c_Qry	+=  "AND 	E5_LOJA 		= '"+c_LojB+"' "	+ENTER
	If( !Empty( c_IdAco ) ) //para os casos de cancelamento da liquidacao
		c_Qry	+=  "AND 	E5_FSIDACO	= '"+c_IdAco+"' "	+ENTER
	EndIf
	If( !l_Canc )
		c_Qry	+=	"AND 	NOT EXISTS "					+ENTER
	Else
		c_Qry	+=	"AND 	EXISTS "						+ENTER
	EndIf
	c_Qry	+=	"		(SELECT 0 FROM "+RetSqlName("SE5")+" SE5 "	+ENTER
	c_Qry	+=	"			WHERE SE5.E5_FILIAL	= E5.E5_FILIAL"		+ENTER
	c_Qry	+=	"			AND SE5.E5_PREFIXO	= E5.E5_PREFIXO"	+ENTER
	c_Qry	+=	"			AND SE5.E5_NUMERO	= E5.E5_NUMERO 	"	+ENTER
	c_Qry	+=	"			AND SE5.E5_PARCELA	= E5.E5_PARCELA"	+ENTER
	c_Qry	+=	"			AND SE5.E5_TIPO		= E5.E5_TIPO "		+ENTER
	c_Qry	+=	"			AND SE5.E5_CLIFOR	= E5.E5_CLIFOR "	+ENTER
	c_Qry	+=	"			AND SE5.E5_LOJA		= E5.E5_LOJA "		+ENTER
	c_Qry	+=	"			AND SE5.E5_SEQ		= E5.E5_SEQ "		+ENTER
	c_Qry	+=	"			AND ( SE5.E5_TIPODOC = 'ES' OR SE5.E5_SITUACA = 'C' ) "	+ENTER
	c_Qry	+=	"			AND SE5.D_E_L_E_T_<>'*')"				+ENTER

	IIf(Select(c_AliasTmp)>0,(c_AliasTmp)->(dbCloseArea()),Nil)
	c_Qry := ChangeQuery(c_Qry)
	DbUseArea(.T., "TOPCONN", TcGenQry(,,c_Qry), c_AliasTmp, .T., .T.)
	If (c_AliasTmp)->(!Eof())
		l_Ret := .T.
	EndIf
	(c_AliasTmp)->(dbCloseArea())
Return(l_Ret)
/*/{Protheus.doc} f_VldCaracter
//Valida se o numero do doc de entrada, titulo a pagar e receber possiu caracter especial. Com excessao do prefixo RM.
@author carlo
@since 05/02/2019
@version 1.0
/*/
Static Function f_VldCaracter(c_NumDoc)
	Local a_Strings	:= {"-"," ","'", "#", "%", "*", "&", ">", "<", "!", "@", "$", "(", ")", "_", "=", "+", "{", "}", "[", "]", "/", "?", ".", "\", "|", ":", ";", "^","~","�","`",'"', "�", "�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�","�"}
	Local nXY		:= 0
	Local c_StrTrat := Alltrim( c_NumDoc )
	Local l_Ret		:= .T.

	For nXY:=1 To Len( c_StrTrat )
		If aScan(a_Strings, Subst( c_StrTrat,nXY,1 ) ) <> 0
			l_Ret:= .F.
			Exit
		EndIf
	Next
Return(l_Ret)
/*/{Protheus.doc} f_VldCnInvest
Valida se a conta comeca com 32 e o Cr possui o campo CTD_XRTADM = 2=Consumo;3=Corporativo;4=Unid. Compartilhadas.
@since 13/02/2019
@version 1.0
/*/
Static Function f_VldCnInvest( c_Cont, c_ItCta, c_ErrMsg )
	Local l_Ret:= .T.
	//Valida se a conta comeca com 32 e o Cr possui o campo CTD_XRTADM = 2=Consumo;3=Corporativo;4=Unid. Compartilhadas 11/02/2019
	If (Substr(Alltrim(c_Cont),1,2) $ "32")
		If !Empty( c_ItCta )
			DbSelectArea("CTD")
			CTD->(dbSetOrder(1))
			If (CTD->(dbSeek(xFilial("CTD")+Alltrim( c_ItCta ))))
				If ( Alltrim(CTD->CTD_XRTADM) $ '2|3|4' )
					c_ErrMsg:= "Para contas de investimento ("+Alltrim( c_Cont )+"), CR ("+Alltrim( c_ItCta )+") dos tipos: 2=Consumo;3=Corporativo;4=Unid.Compartilhadas nao sao permitidos o lancamento."
					l_Ret:= .F.
				EndIf
			EndIf
	 	EndIf
	EndIf
Return( l_Ret )
/*/{Protheus.doc} f_VldDtMov
Valida se o periodo esta aberto para lancamento.
@since 26/02/2019
@version 1.0
/*/
Static Function f_VldDtMov( c_Mod, d_Data, c_Err, c_Proc )
	Local l_Ret		:= .T.
	Local c_Ano		:= Substr( DTos( d_Data ), 1 , 4 )
	Local c_Mes		:= Substr( DTos( d_Data ), 5 , 2 )
	LOCAL d_DatFin 	:= Getmv("MV_DATAFIN")
	LOCAL d_DatFis 	:= Getmv("MV_DATAFIS")

	//Valida o calendario contabil se esta bloqueado na data
	DbSelectArea("CTG")
	CTG->(dbSetOrder(4)) //CTG_FILIAL, CTG_EXERC, CTG_PERIOD
	If (CTG->(dbSeek(xFilial("CTD")+c_Ano+c_Mes)))
		If ( d_Data >= CTG->CTG_DTINI ) .And. ( d_Data <= CTG->CTG_DTFIM )
			If ( CTG->CTG_STATUS <> '1') //1=Aberto;2=Fechado;3=Transportado;4=Bloqueado
				c_Err:= "O calendario contabil deste periodo esta bloqueado e nao permite movimentacao nesta data "+Substr( DTos( d_Data ), 7 , 2 )+"/"+Substr( DTos( d_Data ), 5 , 2 )+"/"+Substr( DTos( d_Data ), 1 , 4 ) +"."
				l_Ret:= .F.
			EndIf
		EndIf
	EndIf
	If ( l_Ret )
		//Se for titulo/mov bancaria/transferencia bancaria
		If ( c_Mod = 'FIN' )
			If ( d_Data < d_DatFin )
				c_Err:= "Periodo esta bloqueado (MV_DATAFIN) e nao permite movimentacao nesta data "+Substr( DTos( d_Data ), 7 , 2 )+"/"+Substr( DTos( d_Data ), 5 , 2 )+"/"+Substr( DTos( d_Data ), 1 , 4 ) +"."
				l_Ret:= .F.
			EndIf
			If(l_Ret)
				If( c_Proc == "R")
					l_Ret:= CtbValiDt(,d_Data,.F.,,,{"FIN002"},)
					If( !l_Ret )
						c_Err:= "Processo financeiro (Contas a Receber) bloqueado na data informada: "+Substr( DTos( d_Data ), 7 , 2 )+"/"+Substr( DTos( d_Data ), 5 , 2 )+"/"+Substr( DTos( d_Data ), 1 , 4 ) +"."
					EndIf		
				ElseIf( c_Proc == "P")
					l_Ret:= CtbValiDt(,d_Data,.F.,,,{"FIN001"},)
					If( !l_Ret )
						c_Err:= "Processo financeiro (Contas a Pagar) bloqueado na data informada: "+Substr( DTos( d_Data ), 7 , 2 )+"/"+Substr( DTos( d_Data ), 5 , 2 )+"/"+Substr( DTos( d_Data ), 1 , 4 ) +"."
					EndIf
				EndIf
			EndIf
			//Se for pedido de compra ou venda
		ElseIf ( c_Mod = 'FAT' ) .Or. ( c_Mod = 'COM' )
			If ( d_Data < d_DatFis )
				c_Err:= "Periodo esta bloqueado (MV_DATAFIS) e nao permite movimentacao nesta data "+Substr( DTos( d_Data ), 7 , 2 )+"/"+Substr( DTos( d_Data ), 5 , 2 )+"/"+Substr( DTos( d_Data ), 1 , 4 ) +"."
				l_Ret:= .F.
			EndIf
			If(l_Ret)
				If( c_Proc == "C")
					l_Ret:= CtbValiDt(,d_Data,.F.,,,{"COM001"},)
					If( !l_Ret )
						c_Err:= "Processo Compras bloqueado na data informada: "+Substr( DTos( d_Data ), 7 , 2 )+"/"+Substr( DTos( d_Data ), 5 , 2 )+"/"+Substr( DTos( d_Data ), 1 , 4 ) +"."
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
Return( l_Ret )

/*/{Protheus.doc} f_GrvZJY
Funcao que grava a distribuicao do rateio - tabela ZJY
@author Totvs-BA
@since 12/06/2019
@version 1.0
@return Nil, Funcao nao tem retorno
@param c_Ret tem que ser uma variavel passada por referencia. Sera a variavel que retornara a mensagem de retorno
/*/
Static Function f_GrvZJY(l_Prim, c_Fil, c_Pref, c_Tit, c_Parc, c_Tipo, d_Emissao, d_DtDig, c_For, c_Loj, n_ValTit, a_Itens)
	Local lOk		:= .F.
	Local m			:= 0
	Local n_ValDst 	:= 0
	For m:= 1 To Len(a_Itens)
		If	l_Prim
			c_ZJYCod:= GETSXENUM('ZJY','ZJY_COD')
			l_Prim:= .F.
		EndIf
		RecLock("ZJY",.T.)
		ZJY->ZJY_FILIAL		:= c_Fil 						//Filial
		ZJY->ZJY_COD		:= c_ZJYCod					 	//Codigo Chave
		ZJY->ZJY_PREFIX		:= c_Pref 						//Prefixo
		ZJY->ZJY_TITULO		:= c_Tit 						//Titulo
		ZJY->ZJY_PARCEL		:= c_Parc 						//Parcela
		ZJY->ZJY_TIPO		:= c_Tipo						//Tipo
		ZJY->ZJY_EMISSA		:= d_Emissao 						//Emissao
		ZJY->ZJY_FORNEC		:= c_For 						//Fornecedor
		ZJY->ZJY_LOJA		:= c_Loj 						//Loja

		ZJY->ZJY_LINHA		:= a_Itens[m][1]					//Item
		ZJY->ZJY_FILDES		:= a_Itens[m][2] 					//Fil. Destino
		ZJY->ZJY_CONTA		:= a_Itens[m][3] 					//C. Contabil

		//Quando o valor for zerado, faz o calculo do percentual
		If (a_Itens[m][4] = 0)
			ZJY->ZJY_VALOR	:= ((n_ValTit*a_Itens[m][5])/100)//Valor
		Else
			ZJY->ZJY_VALOR	:= a_Itens[m][4] 				//Valor
		EndIf
		//Quando o percentual for zerado, faz o calculo do valor
		If (a_Itens[m][5] = 0)
			ZJY->ZJY_PERC	:= ((ZJY->ZJY_VALOR*100)/n_ValTit)//(%) Rateio
		Else
			ZJY->ZJY_PERC	:= a_Itens[m][5] 					//(%) Rateio
		EndIf

		ZJY->ZJY_ITEM		:= a_Itens[m][6] 					//Cr - Item Contabil
		ZJY->ZJY_CC			:= a_Itens[m][7] 					//Uo - Centro de Custo
		ZJY->ZJY_CLVL		:= a_Itens[m][8] 					//Projeto - Classe de Valor
		ZJY->ZJY_EMIS1		:= d_DtDig
		MsUnLock()
		lOk		:= .T.
		n_ValDst += ZJY->ZJY_VALOR
	Next

	If( lOk )
		//Verifica se o valor calculado ficou com diferenca de centavos
		If	n_ValTit <> n_ValDst
			n_DifCen:= (n_ValTit - n_ValDst)
			If ( n_DifCen = 0)
				//nao faz nada
			Else
				DbSelectArea("ZJY")
				ZJY->(DbSetOrder(1))
				If 	DbSeek(c_Fil + c_Pref + c_Tit + c_Parc + c_Tipo + c_For + c_Loj)
					If ( n_DifCen > 0) //Para os casos que a lancou a mais ou a menos.
						RecLock("ZJY",.F.)
						ZJY->ZJY_VALOR+= n_DifCen
						MsUnLock()
					Else
						RecLock("ZJY",.F.)
						ZJY->ZJY_VALOR-= (n_DifCen * -1)
						MsUnLock()
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

Return(lOk)
//Tratamento da mensagem de erro
Static Function f_TrataErro(aErr)
Local lHelp   := .F.
Local lAjuda  := .F.
Local lTabela := .F.
Local cLinha  := ""
Local aRet    := {}
Local nI      := 0
Local l_Importante	:= .F.

For nI := 1 to LEN( aErr)
	cLinha  := UPPER( aErr[nI] )
	cLinha  := STRTRAN( cLinha,CHR(13), " " )
	cLinha  := STRTRAN( cLinha,CHR(10), " " )

	If SUBS( cLinha, 1, 10 ) == 'IMPORTANTE' .or. SUBS( cLinha, 1, 10 ) == 'Importante'
		l_Importante := .T.
	EndIf

	If SUBS( cLinha, 1, 4 ) == 'HELP' .or. SUBS( cLinha, 1, 4 ) == 'Help'
		lHelp := .T.
	EndIf

	If SUBS( cLinha, 1, 5 ) == 'AJUDA' .or. SUBS( cLinha, 1, 5 ) == 'Ajuda'
		lAjuda := .T.
	EndIf

	If SUBS( cLinha, 1, 6 ) == 'TABELA' .or. SUBS( cLinha, 1, 6 ) == 'Tabela'
		lHelp   := .F.
		lTabela := .T.
	EndIf

	If Upper(SUBS(cLinha,1,8)) == 'ERRO -->'
		lHelp := .T.
		cLinha := StrTran(cLinha,'--------------------------------------------------------------------------------','')
	EndIf

	If  lHelp .or. ( lTabela .AND. '< -- INVALIDO' $  cLinha ) .Or. lAjuda
		aAdd( aRet,  StrTran(cLinha,'< -- INVALIDO','( INVALIDO )') )
	ElseIf lTabela
		aAdd( aRet, cLinha )
	ElseIf l_Importante
		aAdd( aRet, cLinha )
	EndIf
	lHelp := .F.
Next

Return aRet
/*/{Protheus.doc} RatVigente
Valida o rateio vigente
@since 11/09/2019
@version 1.0
@return return, Logico
/*/
User Function RtVigente( c_FilRat, c_IteRat )
	Local l_Ret := .T.
	Local c_Qry	:= ""
	
	c_Qry:= "SELECT TOP 1 * "+chr(13)+chr(10)
	c_Qry+= "FROM "+RetSqlName("SZT")+" ZT (NOLOCK) "+chr(13)+chr(10)
	c_Qry+= "INNER JOIN "+RetSqlName("SZU")+" ZU (NOLOCK) ON (ZU_FILIAL = ZT_FILIAL AND ZU_ANO = ZT_ANO AND ZU.D_E_L_E_T_ = '') "+chr(13)+chr(10)
	c_Qry+= "INNER JOIN "+RetSqlName("SZV")+" ZV (NOLOCK) ON (ZU_FILIAL = ZV_FILIAL AND ZU_ANO = ZV_ANO AND ZU_REVISAO = ZV_REVISAO AND ZV.D_E_L_E_T_ = '') "+chr(13)+chr(10)
	c_Qry+= "WHERE ZT.ZT_STATUS = '2' "+chr(13)+chr(10)
	c_Qry+= "AND ZT_ANO = '2019' "+chr(13)+chr(10)
	c_Qry+= "AND ZT.D_E_L_E_T_ = '' "+chr(13)+chr(10)
	c_Qry+= "AND ZV_CODEMP 	= '"+ c_FilRat +"' "+chr(13)+chr(10)
	c_Qry+= "AND ZV_ITCTB 	= '"+ c_IteRat +"' "+chr(13)+chr(10)

	TCQUERY c_Qry ALIAS QRYRAT NEW
	dbSelectArea("QRYRAT")
	If !(QRYRAT->(Eof()))
		l_Ret:= .T.
	Else
		l_Ret:= .F.
	EndIf
	dbSelectArea("QRYRAT")
	QRYRAT->(dbCloseArea())
	
Return( l_Ret )
/*/{Protheus.doc} f_SubstituiProvisao

@since 30/09/2019
@version 1.0
@return return, Logico
/*/
/*Static Function f_SubstituiProvisao( c_Doc, c_Ser, c_For, c_Loj, n_VlrNf, c_Tipo )

	Local a_AliasE2	:= SE2->( GetArea() )
	Local a_AliasF1	:= SF1->( GetArea() )
	Local a_AliasD1	:= SD1->( GetArea() )

	Local c_Alias	:= GetNextAlias()
	Local c_TpProv	:= Alltrim( SuperGetMv( "FS_TPPROV", , "" ) )
	Local c_SqlTP 	:= FormatIN( c_TpProv, ';' )
	Local c_Query	:= ""

	Local a_Baixa	 	:= {}
	Local c_Log  	 	:= ""
	Local c_Hist 	 	:= "BX PROV TITULO: "+c_Ser+"/"+c_Doc+"/"+MVNOTAFIS
	Local c_Chave 	 	:= ""
	Local c_User 	 	:= RetCodUsr()
	Local c_NUser	 	:= UsrFullName( c_User )
	Local o_Liberacao	:= clsLiberacaoCP():New()

	Local n_VlrBx		:= 0
	Local l_Ret			:= .T.

	PRIVATE lMsErroAuto:= .F.

	c_Query += "	SELECT "
	c_Query += "		E2_FILIAL, "
	c_Query += "		E2_PREFIXO, "
	c_Query += "		E2_NUM, "
	c_Query += "		E2_PARCELA, "
	c_Query += "		E2_TIPO, "
	c_Query += "		E2_FORNECE, "
	c_Query += "		E2_LOJA, "
	c_Query += "		E2_SALDO, "
	c_Query += "		E2_NOMFOR, "
	c_Query += "		E2_EMISSAO, "
	c_Query += "		SE2.R_E_C_N_O_ nReg "

	c_Query += "	FROM "
	c_Query += 			RETSQLNAME( "SE2" ) + " SE2 "

	c_Query += "	WHERE "
	c_Query += "		E2_FILIAL = '" + XFILIAL("SE2") + "' "
	c_Query += "		AND SE2.D_E_L_E_T_ = '' "
	c_Query += "		AND E2_TIPO IN " + c_SqlTP + " "
	c_Query += "		AND E2_FORNECE = '" + c_For + "' "
	c_Query += "		AND E2_LOJA = '" + c_Loj + "' "
	c_Query += "		AND E2_SALDO > 0 "
	c_Query += "		AND E2_EMISSAO >= '20190601' "

	c_Query += "	ORDER BY E2_EMISSAO "

	TcQuery c_Query New Alias "QBX"

	dbSelectArea( "QBX" )
	QBX->( dbGoTop() )

	While QBX->( !EOF() )

		c_Chave := QBX->E2_FORNECE + QBX->E2_LOJA + QBX->E2_PREFIXO + QBX->E2_NUM + QBX->E2_PARCELA + QBX->E2_TIPO

		If n_VlrNf <= 0
			Exit
		EndIf

		If n_VlrNf > QBX->E2_SALDO
			n_VlrBx := QBX->E2_SALDO
		Else
			n_VlrBx := n_VlrNf
		EndIf

		//Liberacao para baixa
		DBSELECTAREA( "SE2" )
		DBSETORDER( 6 )
		If DBSEEK( XFILIAL("SE2") + c_Chave )

			RecLock( "SE2", .F.)
			SE2->E2_FSRECCP := "1"	//Reconhecido Sim
			SE2->E2_FSLIBCP := "1"	//Liberado Sim
			SE2->E2_FSBLQCP := "2"	//Bloqueado Sim
			MsUnlock()

			o_Liberacao:Z00_LOG:= "Liberacao de Titulo de Provisao Baixado"

		EndIF

		o_Liberacao:Z00_DATA  	:= DATE()
		o_Liberacao:Z00_HORA  	:= TIME()
		o_Liberacao:Z00_USER  	:= c_User
		o_Liberacao:Z00_NUSER 	:= c_NUser
		o_Liberacao:Z00_CHAVE 	:= c_Chave
		o_Liberacao:Z00_ROTINA	:= "FFIEBW01"
		o_Liberacao:mtdGravaLog()
		//Fim da Liberacao

		a_Baixa	:= {}
		AADD( a_Baixa, { "E2_FILIAL" 	, QBX->E2_FILIAL 	, Nil } )
		AADD( a_Baixa, { "E2_PREFIXO" 	, QBX->E2_PREFIXO 	, Nil } )
		AADD( a_Baixa, { "E2_NUM" 		, QBX->E2_NUM 		, Nil } )
		AADD( a_Baixa, { "E2_PARCELA" 	, QBX->E2_PARCELA 	, Nil } )
		AADD( a_Baixa, { "E2_TIPO" 		, QBX->E2_TIPO 		, Nil } )
		AADD( a_Baixa, { "E2_FORNECE" 	, QBX->E2_FORNECE 	, Nil } )
		AADD( a_Baixa, { "E2_LOJA" 		, QBX->E2_LOJA 		, Nil } )
		AADD( a_Baixa, { "AUTMOTBX" 	, "PRO" 			, Nil } )
		AADD( a_Baixa, { "AUTBANCO" 	, '' 				, Nil } )
		AADD( a_Baixa, { "AUTAGENCIA" 	, '' 				, Nil } )
		AADD( a_Baixa, { "AUTCONTA" 	, '' 				, Nil } )
		AADD( a_Baixa, { "AUTDTBAIXA" 	, dDatabase			, Nil } )
		AADD( a_Baixa, { "AUTDTCREDITO"	, dDatabase			, Nil } )
		AADD( a_Baixa, { "AUTHIST" 		, c_Hist			, Nil } )
		AADD( a_Baixa, { "AUTVLRPG" 	, n_VlrBx			, Nil } )
		AADD( a_Baixa, { "AUTDESCONT"	, 0					, Nil } )
		AADD( a_Baixa, { "AUTJUROS"		, 0					, Nil } )

		AcessaPerg("FIN080", .F.)

		Begin Transaction

			MSEXECAUTO({|x,y| FINA080(x,y)}, a_Baixa, 3)

			If 	lMsErroAuto
				l_Ret := .F.
			Else
				l_Ret 	:= .T.
				n_VlrNf	:= n_VlrNf - n_VlrBx
			Endif

			If SE2->E2_SALDO > 0

				//Bloqueio para baixa
				o_Liberacao:E2_NUM		:= SE2->E2_NUM
				o_Liberacao:E2_PREFIXO	:= SE2->E2_PREFIXO
				o_Liberacao:E2_FORNECE	:= SE2->E2_FORNECE
				o_Liberacao:E2_LOJA		:= SE2->E2_LOJA
				o_Liberacao:E2_PARCELA	:= SE2->E2_PARCELA
				o_Liberacao:E2_TIPO		:= SE2->E2_TIPO
				o_Liberacao:DD_ORIGEM 	:= "FINA050"

				o_Liberacao:Z00_DATA	:= DATE()
				o_Liberacao:Z00_HORA	:= TIME()
				o_Liberacao:Z00_USER	:= c_User
				o_Liberacao:Z00_NUSER	:= c_NUser
				o_Liberacao:Z00_LOG 	:= "Bloqueio de titulo provisao com saldo a baixar"
				o_Liberacao:Z00_CHAVE 	:= SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO
				o_Liberacao:Z00_ROTINA	:= "FFINA01A"

				o_Liberacao:mtdBloqueioCP()
				o_Liberacao:mtdGravaLog()
				//Fim do bloqueio

			Endif

		End Transaction

		QBX->( dbSkip() )

	EndDo
	QBX->(DbCloseArea())
	RestArea( a_AliasE2 )
	RestArea( a_AliasF1 )
	RestArea( a_AliasD1 )

Return( l_Ret )*/

/*/{Protheus.doc} xMaIntBxCR
	Funcao que faz o estorno (SOMENTE) da compensacao do contas a receber, quando vem pela integracao
	Tive que extrair o codigo do fonte padrao e colocar isolado nessa rotina pq o estorno estava sempre deletando o registro do Se5
	E para o RM tem que cancelar e nao deletar.
	@type  Function
	@author user
	@since 07/07/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
User Function xMaIntBxCR( nCaso, aSE1, aBaixa, aNCC_RA, aLiquidacao, aParam, bBlock, aEstorno, aSE1Dados, aNewSE1, nSaldoComp, aCpoUser,; 
					aNCC_RAvlr, nSomaCheq, nTaxaCM, aTxMoeda, lConsdAbat, lRetLoja, cProcComp )
	Local aArea			:= GetArea()
	//Local aAreaSEF		:= SEF->(GetArea())
	Local aAreaSE1		:= {}
	Local aTitulo		:= {0,0,0}
	Local aRecebido		:= {}
	//Local aValores		:= {}
	//Local aComplem		:= {}
	Local bContabil		:= {|| .T.}
	//Local dInicio		:= dDataBase
	Local nX			:= 0
	Local nY			:= 0
	/*Local nVlrCR		:= 0
	Local nVlrACmp		:= 0
	Local nVlrComp		:= 0
	Local nVlrALiqCR	:= 0
	Local nVlrLiqCR		:= 0
	Local nVlrLiq		:= 0
	Local nMoeda		:= 0
	Local nHdlPrv		:= 0
	Local nHdl460		:= 0
	Local nTotalCtb		:= 0*/
	Local lContabil		:= .F.
	Local lAgluCtb		:= .F.
	Local lDigita		:= .F.
	Local lDesconto		:= .F.
	Local lJuros		:= .F.
	Local lComisNCC		:= .T.
	//Local lHeadProva	:= .F.
	Local lEstorno		:= IIf(Empty(aEstorno),.F.,.T.)
	//Local lContinua		:= .T.
	Local lRetorno		:= .T.
	//Local cLoteCtb		:= ""
	//Local cArqCtb		:= ""
	//Local cPadrao		:= ""
	Local cRetorno		:= ""
	//Local cNumLiq		:= ""
	Local cParcela		:= "0"
	Local cCliente		:= ""
	Local cLoja			:= ""
	//Local cHistor		:= ""
	Local cAliasSE1		:= ""
	Local cQuery		:= ""
	Local lContSaldo	:= ValType( nSaldoComp ) == "N"
	Local lFrtBxNCC		:= FwIsInCallStack("FRTBXNCC") .Or. FwIsInCallStack("LJGRVREC") // Retorna se a funcao foi chamada a partir da FRTBXNCC ou pela rotina de recebimento de titulo do LOJA
	//Local nMultaTit		:= 0							// Aramazena valor da Multa digitado na escolha do Titulo
	//Local nJurosTit		:= 0							// Aramazena valor do Juros digitado na escolha do Titulo
	//Local nDescoTit		:= 0							// Aramazena valor do Desconto digitado na escolha do Titulo
	//Local nVlrMoeTit	:= 0
	//Local nMoedaAdd		:= 0
	//Local nMoedaBco		:= 0
	//Local nPerc			:= 0
	Local cChaveTit		:= ""
	Local cChaveFK7		:= ""
	//Local lExistFJU		:= FJU->(ColumnPos("FJU_RECPAI")) >0 .and. FindFunction("FinGrvEx")
	//Local lLojxRec		:= Alltrim(FunName()) == 'LOJA701' .Or. nModulo == 23
	//Local lF460SE1	    := ExistBlock("F460SE1")
	//Local lF460VAL  	:= ExistBlock("F460VAL")
	//Local c1DupNat 		:= SuperGetMv("MV_1DUPNAT",,"")
	//Local c1DupMcr 		:= ""
	
	//Rastreamento
	//Local aRastroOri	:= {}
	//Local aRastroDes	:= {}
	
	Default lRetLoja    := .F. //Utilizada para retorno da rotina quando utilizada no modulo de Varejo/Loja
	Default cProcComp   := ""
	
	//Private STRLCTPAD	:= ""
	//Private VALOR		:= 0
	//Private RegValor	:= 0
	Private aFlagCTB	:= {}
	//
	//?Verifica os parametros da rotina                             ?
	//
	If !Empty(aParam)
		lContabil  := aParam[01]
		lAgluCtb   := aParam[02]
		lDigita    := aParam[03]
		lDesconto  := aParam[04]
		lJuros     := aParam[05]
		lComisNCC  := aParam[06]
	EndIf
	
	Default bBlock     := {|| .T.}
	Default aSE1Dados  := {}
	Default aCpoUser   := {}
	Default nSomaCheq  := 0 //-- Total dos Cheques informados na baixa
	Default lConsdAbat := .F.
	
	// exclusivo para uso de NCC_RA para compensacao de valores parciais
	// valores igual ou inferior ao valor do saldo disponivel
	If ValTYPE( aNCC_RA ) == "A"
		If ValTYPE( aNCC_RAvlr ) == "A"
			// condicao necessaria
			// - vetor aNCC_RAvlr com  "VALORES PARCIAIS" de baixa nos Tulos RA utiliza a mesma referencia (indice) do vetor aNCC_RA
			// - Foi criado um desvio
			If Len(aNCC_RA) <> Len(aNCC_RAvlr)
				Return(lRetorno)
			EndIf
		Else
	      aNCC_RAvlr := Array( Len(aNCC_RA) )
	      Afill(aNCC_RAvlr, 0)
	 	EndIf
	EndIf
	
	aNewSE1 := {} // array com os recno novos da tabela se1
	
	lContabil := .F.
	///
	//?Efetua a integracao com o financeiro                         ?
	//
	Do Case
	
	Case nCaso == 3
		Begin Transaction
			For nX := 1 To Len(aSE1)
				If lContSaldo
					If	Empty( nSaldoComp )
						Exit
					EndIf
				EndIf
				//
				//?Posiciona registros                                          ?
				//
				dbSelectArea("SE1")
				dbSetOrder(1)
				SE1->( MsGoto(aSE1[nX]) )
				dbSelectArea("SA1")
				dbSetOrder(1)
				DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
	
				If RecLock("SE1")									
					lContabil := .F.
					cRetorno := f_FaCmpCR(aTitulo,aRecebido,lContabil,lComisNCC,Nil,bContabil,bBlock,aEstorno[nX])
					/* 	Atualiza o status do titulo no SERASA */
					If cPaisLoc == "BRA"
						SE1->( MsGoto(aSE1[nX]) )
						cChaveTit := xFilial("SE1") + "|" +;
									SE1->E1_PREFIXO + "|" +;
									SE1->E1_NUM		+ "|" +;
									SE1->E1_PARCELA + "|" +;
									SE1->E1_TIPO	+ "|" +;
									SE1->E1_CLIENTE + "|" +;
									SE1->E1_LOJA
						cChaveFK7 := FINGRVFK7("SE1",cChaveTit)
						F770BxRen("2","",cChaveFK7)
					Endif
				EndIf
			Next nX
		End Transaction
	OtherWise
EndCase
RestArea(aArea)
Return(lRetorno)
/*/{Protheus.doc} f_FaCmpCR
	Funcao que faz o estorno da compesnacao
	@type  Static Function
	@author user
	@since 07/07/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function f_FaCmpCR( aTitulo, aCompensar, lLctPad, lComisNCC, cOrigem, bContabil, bBlock, aEstorno, cProcComp )
	Local aArea			:= GetArea()
	Local aAreaSE1		:= SE1->(GetArea())
	Local aAreaCMP		:= {}
	Local aAreaSE5		:= {}
	Local aAreaE5a      := {}
	//Local aAreaAbat		:= {}
	Local aComissao		:= {}
	Local aDelCMP		:= {}
	Local nX			:= 0
	Local nY			:= 0
	//Local nVlCpMdCp		:= 0
	//Local nVlCpMd1		:= 0
	//Local nSldMdCR		:= 0
	//Local nSldMdCp		:= 0
	//Local nVlBxMdCr		:= 0
	//Local nVlBxMd1		:= 0
	//Local nMoedaCR		:= SE1->E1_MOEDA
	//Local nAtraso		:= 0
	Local cAliasSE1		:= "SE1"
	Local cAliasSE5		:= "SE5"
	//Local xFilSE1		:= ""
	Local cPrefixo		:= SE1->E1_PREFIXO
	Local cNumero		:= SE1->E1_NUM
	Local cParcela		:= SE1->E1_PARCELA
	Local cCliente		:= SE1->E1_CLIENTE
	Local cLoja			:= SE1->E1_LOJA
	//Local cPrincipal	:= SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_LOJA
	//Local cNCC_RA		:= ""
	Local cSeqBx		:= ""
	//Local cSeqBxCp		:= ""
	Local cPrimary		:= ""
	Local cFilterSE1	:= SE1->(dbFilter())
	Local lQuery		:= .F.
	Local lEstorno		:= IIf(Empty(aEstorno),.F.,.T.)
	//Local nTitAcres		:= 0	//Acrescimo Tit Principal
	//Local nTitDecre		:= 0	//Decrescimo Tit Principal
	//Local nAdtAcres		:= 0	//Acrescimo Tit Adiantamento
	//Local nAdtDecre		:= 0	//Decrescimo Tit Adiantamento
	Local lUsaFlag		:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/)
	//Local l330Mov1		:= ExistBlock("SE5FI330")
	//Local l330Mov2		:= ExistBlock("SE5FI331")
	Local lFrtBxNCC		:= FwIsInCallStack("FRTBXNCC") .Or. FwIsInCallStack("LJGRVREC") // Retorna se a funcao foi chamada a partir da FRTBXNCC ou pela rotina de recebimento de titulo do LOJA
	//Local nSldTCom		:= 0	//Considerar o valor de acrescimo fin. separado da parcela (MV_LJICMJR) para compensar as parcelas em abertas quando devoluo de marcadoria (LOJA720)
	//Local cFornAdt		:= ""
	//Local cLojaAdt		:= ""
	Local aDelCorre		:= {}
	//Local aSE5			:= {}
	//Local lMaIntDel		:= .F.	// ExistBlock("MaIntDel")
	// LINHA COMENTADA PARA NAO PERDEMOS O HISTORICO DO QUE JA FOI FEITO
	// CRIADO ESTORNO PARA A ROTINA AUTOMATICA DO MAINTBXCR
	//Local nW			:= 0
	Local cSeqEst		:= ""
	Local nRegSE5		:= 0
	
	//=====================================
	//Trecho alterado com o uso dos models:
	//=====================================
	Local oModelBxR		
	//Local oSubFK1
	//Local oSubFK5
	Local cLog			:= ""
	Local cChaveTit		:= ""
	Local cChaveFK7		:= ""
	Local cCamposE5		:= ""
	Local lRet			:= .T.
	//Local cHistMov		:= ""
	//Local cIdMov		:= ""
	Local lTravaSA1		:= !ExistBlock("F070TRAVA") .Or. ExecBlock("F070TRAVA", .F., .F.)
	//Local lFA330SE1 	:= ExistBlock("FA330SE1")
	Local cQuery		:= ""
	Local cKeySE1		:= SE1->(IndexKey())
	//Local lJGrvBaixa	:= FindFunction("JGrvBaixa")
	Local c_FilProc		:= ""
	Private cLote	:= ""
	//
	//?Verifica os parametros da rotina                             ?
	//
	Default lLctPad    := .F.
	Default lComisNCC  := .F.
	//SIGAPFS - Alterao realizada no cOrigem para que a compensao das Faturas com RAs fiquem com o E5_TIPODOC="BA".
	//Sem isso, o estorno n estava sendo feito. - Chamado TQMYFS
	Default cOrigem    := Iif(FwIsInCallStack("JURA203"),"JURA203","FINA330")  
	Default bContabil  := {|| .T.}
	Default bBlock    := {|| .T.}
	Default cProcComp := ""
	
	//
	//?N permite que tulos j?baixados possam ser acessados.  ?
	//
	If !lEstorno .AND. (SE1->E1_SALDO <= 0 .Or. !DtMovFin(,.F./*lHelp*/))
		Return(.F.)  //nao pode ter mensagem pois eh usado em rotina automatica
	Endif
	
	For nX := 1 To Len(aCompensar)
		For nY := 4 To 10
			If Len(aCompensar[nX])<nY
				aadd(aCompensar[nX],Nil)
			EndIf
			Do Case
			Case nY == 4 											// Data da Baixa
				DEFAULT aCompensar[nX][4] := dDataBase
			Case nY == 5 											// Numero do Lote para Contabilizacao
				DEFAULT aCompensar[nX][5] := ""
	
				//
				//?Verifica o numero do Lote 					?
				//
				LoteCont( "FIN" )
				aCompensar[nX][5] := cLote
			Case nY == 8
				DEFAULT aCompensar[nX][8] := 2
			Case nY == 9
				DEFAULT aCompensar[nX][9] := .F.
			Case nY == 10
				DEFAULT aCompensar[nX][10] := 0
			EndCase
		Next nY
	Next nX
	//
	//?Posiciona registros                                          ?
	//
	dbSelectArea("SA1")
	dbSetOrder(1)
	DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
	//
	//?Trava o registro principal                                   ?
	//
	If RecLock("SE1") .And. (!lTravaSA1 .Or. RecLock("SA1"))
		//
		//?Inicia o estorno da compensacao                              ?
		//
		aTitulo    := Array(3)
		aTitulo    := Afill(aTitulo,0)
		aCompensar := Array(8)
		aCompensar := Afill(aCompensar,0)
		If RecLock("SE1")
			//
			//?Restaura os titulos de abatimento caso a baixa seja total    ?
			//
			If SE1->E1_SALDO == 0
				dbSelectArea("SE1")
				dbSetOrder(2)
				SE1->(dbCommit())
				aStruSE1  := SE1->(dbStruct())
				cAliasSE1 := "FaCmpCR"
				lQuery    := .T.
				cQuery := "SELECT SE1.*,SE1.R_E_C_N_O_ SE1RECNO "
				cQuery += "FROM "+RetSqlName("SE1")+" SE1 "
				cQuery += "WHERE SE1.E1_FILIAL='"+xFilial("SE1")+"' AND "
				cQuery += "SE1.E1_PREFIXO='"+cPrefixo+"' AND "
				cQuery += "SE1.E1_NUM='"+cNumero+"' AND "
				cQuery += "SE1.E1_PARCELA='"+cParcela+"' AND "
				cQuery += "SE1.E1_CLIENTE='"+cCliente+"' AND "
				cQuery += "SE1.E1_LOJA='"+cLoja+"' AND "
				cQuery += "SE1.D_E_L_E_T_=' ' "
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE1,.T.,.T.)
				For nX := 1 To Len(aStruSE1)
					If aStruSE1[nX][2]<>"C"
						TcSetField(cAliasSE1,aStruSE1[nX][1],aStruSE1[nX][2],aStruSE1[nX][3],aStruSE1[nX][4])
					EndIf
				Next nX
				While !Eof() .And. (cAliasSE1)->E1_FILIAL == xFilial("SE1") .And.;
						(cAliasSE1)->E1_CLIENTE == cCliente	.And.;
						(cAliasSE1)->E1_LOJA == cLoja .And.;
						(cAliasSE1)->E1_PREFIXO == cPrefixo .And.;
						(cAliasSE1)->E1_NUM == cNumero .And.;
						(cAliasSE1)->E1_PARCELA == cParcela
	
					If (cAliasSE1)->E1_TIPO $ MVABATIM+"/"+MVIRABT+"/"+MVINABT+"/"+MVPIABT+"/"+	MVCFABT+"/"+MVCSABT
						If lQuery
							dbSelectArea("SE1")
							MsGoto((cAliasSE1)->SE1RECNO)
						EndIf
						RecLock("SE1")
						SE1->E1_SALDO   := SE1->E1_VALOR
						SE1->E1_BAIXA   := Ctod("")
						SE1->E1_LOTE    := ""
						SE1->E1_MOVIMEN := Ctod("")
						SE1->E1_STATUS  := "A"
						MsUnLock()
						aTitulo[CR_VLRABAT] := SE1->E1_VALOR
					EndIf
					dbSelectArea(cAliasSE1)
					dbSkip()
				EndDo
				If lQuery
					dbSelectArea(cAliasSE1)
					dbCloseArea()
					dbSelectArea("SE1")
					lQuery := .F.
				Else
					dbSelectArea("SE1")
					If !Empty(cFilterSE1)
						If nOrdSE1 == 0 .And. !Empty(cKeySE1)
							cFilterSE1 += ".AND. ORDERBY("+StrTran(ClearKey(cKeySE1),"+",",")+")"
	
	
						EndIf
					EndIf
					If ( !Empty(cFilterSE1) )
						Set Filter to &cFilterSE1
					EndIf
				EndIf
			EndIf
			//
			//?Efetua o estorno de um baixa                                 ?
			//
			RestArea(aAreaSE1)
			//
			//?Atualiza o saldo do titulo com base no abatimento            ?
			//
			SE1->E1_SALDO += aTitulo[CR_VLRABAT]			
			
			//Tratamento para n dar error.log caso alguma rotina esteja chamando a MaintBX para estorno, informando o vetor na estrutura anterior
			If ValType( aEstorno[1] ) == "A"
				If Len( aEstorno ) > 1
					cSeqEst := aEstorno[2] //Pega a sequencia da baixa para posicionar a SE5 corretamente
				Else
					cSeqEst := ""
				Endif 
			Else
				cSeqEst := ""
			Endif	
			
			//
			//?Pesquisa pelos registros de baixa da compensacao             ?
			//
			dbSelectArea("SE5")
			dbSetOrder(7) //E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
			DbSeek( xFilial("SE5")+ SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO + SE1->E1_CLIENTE + SE1->E1_LOJA + cSeqEst )
			aAreaE5a := SE5->(GetArea())
	
			While !Eof() .And. (cAliasSE5)->E5_FILIAL == xFilial("SE5") .And.;
			(cAliasSE5)->E5_PREFIXO == SE1->E1_PREFIXO .And.;
			(cAliasSE5)->E5_NUMERO == SE1->E1_NUM      .And.;
			(cAliasSE5)->E5_PARCELA == SE1->E1_PARCELA .And.;
			(cAliasSE5)->E5_TIPO == SE1->E1_TIPO       .And.;
			(cAliasSE5)->E5_CLIFOR == SE1->E1_CLIENTE  .And.;
			(cAliasSE5)->E5_LOJA == SE1->E1_LOJA       .And.;
			(cAliasSE5)->E5_SEQ == Iif( !Empty(cSeqEst), cSeqEst, (cAliasSE5)->E5_SEQ )
	
				If  ((cAliasSE5)->E5_TIPODOC == "CP" .And. (cAliasSE5)->E5_MOTBX == "CMP" .And. (cAliasSE5)->E5_RECPAG == "R" );
				.OR. (cAliasSE5)->E5_TIPODOC == "CM"
					
					//Tratamento para n dar error.log caso alguma rotina esteja chamando a MaintBX para estorno, informando o vetor na estrutura anterior
					If ValType( aEstorno[1] ) == "A"
					
						If aScan(aEstorno[1],Rtrim((cAliasSE5)->E5_DOCUMEN)) <> 0
							aadd(aDelCmp,{(cAliasSE5)->E5_DOCUMEN,If(lQuery,(cAliasSE5)->SE5RECNO,(cAliasSE5)->(RecNo())),(cAliasSE5)->E5_SEQ,.T.})
						ElseIf (cAliasSE5)->E5_TIPODOC == "CM"
							aadd(aDelCorre,{ SE5->(Recno()) })
						Endif
						
					Else
						
						If aScan(aEstorno,Rtrim((cAliasSE5)->E5_DOCUMEN)) <> 0
							aadd(aDelCmp,{(cAliasSE5)->E5_DOCUMEN,If(lQuery,(cAliasSE5)->SE5RECNO,(cAliasSE5)->(RecNo())),(cAliasSE5)->E5_SEQ,.T.})
						ElseIf (cAliasSE5)->E5_TIPODOC == "CM"
							aadd(aDelCorre,{ SE5->(Recno()) })
						Endif
										
					EndIf
					
				EndIf
				
				//
				//?Nao deve processar sequencias que sofreram Estorno pelo sistema ?
				//
				If (cAliasSE5)->E5_TIPODOC == "ES" .And.;
						(cAliasSE5)->E5_MOTBX == "CMP" .And.;
						(cAliasSE5)->E5_RECPAG == "P"
					nDelCmp := aScan( aDelCmp,{ |x| x[1] == (cAliasSE5)->E5_DOCUMEN .And. x[3] == (cAliasSE5)->E5_SEQ } )
					If nDelCmp > 0
						aDelCmp[nDelCmp][4] := .F.
					EndIf
				EndIf
				dbSelectArea(cAliasSE5)
				dbSkip()
			EndDo
						
			If lQuery
				dbSelectArea(cAliasSE5)
				dbCloseArea()
				dbSelectArea("SE5")
			EndIf
			
			RestArea(aAreaE5a)
			If Len(aDelCmp)>0
				For nX := 1 To Len(aDelCmp)					
					//
					//?Processa somente se a sequencia nao foi estornada            ?
					//
					If aDelCmp[nX][4]
						//
						//?Posiciona no registro de baixa do titulo compensado          ?
						//
						dbSelectArea("SE5")
						//					MsGoto(aDelCmp[nX][2])
						cSeqBx := aDelCmp[nX][3]
						//
						//?Pesquisa o titulo de adiantamento                            ?
						//
						c_FilProc:= ""
						If( Alltrim( aEstorno[3] ) <> ( Alltrim( xFilial("SE1") ) ) )
							c_FilProc:= Alltrim( aEstorno[3] )
						Else
							c_FilProc:= xFilial("SE1")
						EndIf 

						dbSelectArea("SE1")
						dbSetOrder(1)
						c_FsChaveE1 := 	c_FilProc+alltrim(substr(aDelCmp[nX][1],1,len(aDelCmp[nX][1])-2))
						l_FsSeekE1	:=	DbSeek(c_FsChaveE1)
						
						Conout("Posicionando atualizacao de estorno de baixa na SE1")
						ConOut("Chave para pesquisa na SE1(1) - variavel:c_FsChaveE1 = "+ c_FsChaveE1)
						ConOut("Achou posicao - variavel:l_FsSeekE1 = "+cValToChar(l_FsSeekE1))
						
						If l_FsSeekE1 .And. RecLock("SE1")
							//
							//?Restaura os titulos de abatimento caso a baixa seja total    ?
							//
							aAreaCMP := SE1->(GetArea())
							If SE1->E1_SALDO == 0
								cPrefixo  := SE1->E1_PREFIXO
								cNumero   := SE1->E1_NUM
								cParcela  := SE1->E1_PARCELA
								cCliente  := SE1->E1_CLIENTE
								cLoja     := SE1->E1_LOJA
	
								dbSelectArea("SE1")
								dbSetOrder(2)
								SE1->(dbCommit())
								aStruSE1  := SE1->(dbStruct())
								cAliasSE1 := "FaCmpCR"
								lQuery    := .T.
								cQuery := "SELECT SE1.*,SE1.R_E_C_N_O_ SE1RECNO "
								cQuery += "FROM "+RetSqlName("SE1")+" SE1 "
								cQuery += "WHERE SE1.E1_FILIAL='"+c_FilProc+"' AND "
								cQuery += "SE1.E1_PREFIXO='"+cPrefixo+"' AND "
								cQuery += "SE1.E1_NUM='"+cNumero+"' AND "
								cQuery += "SE1.E1_PARCELA='"+cParcela+"' AND "
								cQuery += "SE1.E1_CLIENTE='"+cCliente+"' AND "
								cQuery += "SE1.E1_LOJA='"+cLoja+"' AND "
								cQuery += "SE1.D_E_L_E_T_=' ' "
								cQuery := ChangeQuery(cQuery)
								dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE1,.T.,.T.)
								For nY := 1 To Len(aStruSE1)
									If aStruSE1[nY][2]<>"C"
										TcSetField(cAliasSE1,aStruSE1[nY][1],aStruSE1[nY][2],aStruSE1[nY][3],aStruSE1[nY][4])
									EndIf
								Next nY
								While !Eof() .And. (cAliasSE1)->E1_FILIAL == c_FilProc .And.;
										(cAliasSE1)->E1_CLIENTE == cCliente	.And.;
										(cAliasSE1)->E1_LOJA == cLoja .And.;
										(cAliasSE1)->E1_PREFIXO == cPrefixo .And.;
										(cAliasSE1)->E1_NUM == cNumero .And.;
										(cAliasSE1)->E1_PARCELA == cParcela
	
									If (cAliasSE1)->E1_TIPO $ MVABATIM+"/"+MVIRABT+"/"+MVINABT+"/"+MVPIABT+"/"+	MVCFABT+"/"+MVCSABT
										If lQuery
											dbSelectArea("SE1")
											MsGoto((cAliasSE1)->SE1RECNO)
										EndIf
										RecLock("SE1")
										SE1->E1_SALDO   := SE1->E1_VALOR
										SE1->E1_BAIXA   := Ctod("")
										SE1->E1_LOTE    := ""
										SE1->E1_MOVIMEN := CtoD("")
										SE1->E1_STATUS  := "A"
										MsUnLock()
										aCompensar[CMP_VLABAT] := SE1->E1_VALOR
									EndIf
									dbSelectArea(cAliasSE1)
									dbSkip()
								EndDo
								If lQuery
									dbSelectArea(cAliasSE1)
									dbCloseArea()
									dbSelectArea("SE1")
								Else
									dbSelectArea("SE1")
									If !Empty(cFilterSE1)
										If nOrdSE1 == 0 .And. !Empty(cKeySE1)
											cFilterSE1 += ".AND. ORDERBY("+StrTran(ClearKey(cKeySE1),"+",",")+")"
										EndIf
									EndIf
									If ( !Empty(cFilterSE1) )
										Set Filter to &cFilterSE1
									EndIf
								EndIf
							EndIf
							//
							//?Reposiciona nos titulos de adiantamento                      ?
							//
							RestArea(aAreaCMP)
							//
							//?Atualiza o saldo do titulo com base no abatimento            ?
							//
							SE1->E1_SALDO += aCompensar[CMP_VLABAT]
							//
							//?Localiza o registro de baixa do adiantamento                 ?
							//
							dbSelectArea("SE5")
							dbSetOrder(7) //E5_FILIAL, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_CLIFOR, E5_LOJA, E5_SEQ
							If DbSeek(xFilial("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA+cSeqBx)
								nRegSE5	:= SE5->(Recno())
								While ( !Eof() .And. SE5->E5_FILIAL == xFilial("SE5") .And.;
										SE5->E5_PREFIXO == SE1->E1_PREFIXO .And.;
										SE5->E5_NUMERO == SE1->E1_NUM .And.;
										SE5->E5_PARCELA == SE1->E1_PARCELA .And.;
										SE5->E5_TIPO == SE1->E1_TIPO .And.;
										SE5->E5_CLIFOR == SE1->E1_CLIENTE .And.;
										SE5->E5_LOJA == SE1->E1_LOJA .And.;
										SE5->E5_SEQ == cSeqBx )
	
									If TemBxCanc(   SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ) , .T.)
										SE5->( dbskip())
										Loop
									EndIf
	
									If SE5->E5_TIPODOC <> "CM"
										//
										//?Atualiza o saldo do titulo com base no SE5                   ?
										//
										SE1->E1_SALDO += SE5->E5_VLMOED2
									Endif
									//
									//?Bloco de codigo para contabilizacao                          ?
									//
	
								   	//If lMaIntDel .and. ExecBlock("MaIntDel",.F.,.F.) - Comentei a chamada desse ponto de entrada inutil - 07/07/2020
	
									//Posiciona a FK5 para mandar a operao de alterao com base no registro posicionado da SE5
									If AllTrim( SE5->E5_TABORI ) == "FK1"
										aAreaAnt := GetArea()
										dbSelectArea( "FK1" )
										FK5->( DbSetOrder( 1 ) )
										If MsSeek( xFilial("FK1") + SE5->E5_IDORIG )
											oModelBxR := FWLoadModel("FINM010") //Recarrega o Model de movimentos para pegar o campo do relacionamento (SE5->E5_IDORIG)
											oModelBxR:SetOperation( MODEL_OPERATION_UPDATE ) //Alterao
											oModelBxR:Activate()
											oModelBxR:SetValue( "MASTER", "E5_GRV", .T. ) //Habilita gravao SE5
											oModelBxR:SetValue( "MASTER", "HISTMOV", STR0031 ) //"Estorno de compensao"
											//E5_OPERACAO 1 = Altera E5_SITUACA da SE5 para 'C' e gera estorno na FK5
											//E5_OPERACAO 2 = Grava E5 com E5_TIPODOC = 'ES' e gera estorno na FK5
											//E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK5
											oModelBxR:SetValue( "MASTER", "E5_OPERACAO", 2 ) //E5_OPERACAO 2 
									
											cCamposE5 := "{"
											cCamposE5 += "{'E5_HISTOR' ,'Cancel. de Compensacao'}"
											cCamposE5 += "}"		
											oModelBxR:SetValue( "MASTER", "E5_CAMPOS", cCamposE5 ) //Informa os campos da SE5 que ser gravados indepentes de FK5
													
											If oModelBxR:VldData()
										       	oModelBxR:CommitData()
											Else
												lRet := .F.
											    cLog := cValToChar(oModelBxR:GetErrorMessage()[4]) + ' - '
											    cLog += cValToChar(oModelBxR:GetErrorMessage()[5]) + ' - '
											    cLog += cValToChar(oModelBxR:GetErrorMessage()[6])        	
									       		Help( ,,"M030VALID",,cLog, 1, 0 )
											Endif								
											
											oModelBxR:DeActivate()				
											oModelBxR:Destroy() 
											oModelBxR:= Nil
			
										EndIf
										RestArea(aAreaAnt)
									Endif
									//Comentei a parte que deletava o SE5 - 07/07/2020							
								   	/*Else 
	
										//
										//?Deleta o registro de baixa                                   ?
										//
										If AllTrim( SE5->E5_TABORI ) == "FK1"
											aAreaAnt := GetArea()
											dbSelectArea( "FK1" )
											FK5->( DbSetOrder( 1 ) )
											If MsSeek( xFilial("FK1") + SE5->E5_IDORIG )
												oModelBxR := FWLoadModel("FINM010") //Recarrega o Model de movimentos para pegar o campo do relacionamento (SE5->E5_IDORIG)
												oModelBxR:SetOperation( MODEL_OPERATION_UPDATE ) //Alterao
												oModelBxR:Activate()
												oModelBxR:SetValue( "MASTER", "E5_GRV", .T. ) //Habilita gravao SE5
												oModelBxR:SetValue( "MASTER", "HISTMOV", STR0032 ) //"Cancelamento de compensao"
												//E5_OPERACAO 1 = Altera E5_SITUACA da SE5 para 'C' e gera estorno na FK5
												//E5_OPERACAO 2 = Grava E5 com E5_TIPODOC = 'ES' e gera estorno na FK5
												//E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK5
												oModelBxR:SetValue( "MASTER", "E5_OPERACAO", 3 ) //E5_OPERACAO 3
										
												If oModelBxR:VldData()
											       	oModelBxR:CommitData()
												Else
													lRet := .F.
												    cLog := cValToChar(oModelBxR:GetErrorMessage()[4]) + ' - '
												    cLog += cValToChar(oModelBxR:GetErrorMessage()[5]) + ' - '
												    cLog += cValToChar(oModelBxR:GetErrorMessage()[6])        	
										       		Help( ,,"M030VALID",,cLog, 1, 0 )
												Endif								
												
												oModelBxR:DeActivate()							
												oModelBxR:Destroy() 
												oModelBxR:= Nil
	
											Endif
											RestArea(aAreaAnt)
										Endif
									Endif*/
									dbSelectArea("SE5")
									dbSkip()
								EndDo
								//
								//?Encerra a atualizacao do adiantamento                        ?
								//
								SE1->E1_VALLIQ := 0
								SE1->E1_STATUS := IIf(SE1->E1_SALDO>0.01,"A","B")
								SE1->E1_BAIXA  := IIf(SE1->E1_SALDO==SE1->E1_VALOR,Ctod(""),SE1->E1_BAIXA)
							EndIf
						EndIf
						//
						//?Bloco de codigo para contabilizacao                          ?
						//
						If lLctPad
							SE5->(MsGoTo(nRegSE5))
							Eval(bContabil)
						EndIf
						//
						//?Retira a trava do registro de adiantamento                   ?
						//
						SE1->( MsUnLock() )
						//
						//?Reposiciona o titulo principal                               ?
						//
						RestArea(aAreaSE1)
						//
						//?Reposiciona no registro de baixa do titulo compensado        ?
						//
						dbSelectArea("SE5")
						MsGoto(aDelCmp[nX][2])
						//
						//?Deleta o registro de baixa                                   ?
						//
						//If lMaIntDel .and. ExecBlock("MaIntDel",.F.,.F.) - Comentei a chamada desse ponto de entrada inutil - 07/07/2020
						If AllTrim( SE5->E5_TABORI ) == "FK1"
							aAreaAnt := GetArea()
							dbSelectArea( "FK1" )
							FK5->( DbSetOrder( 1 ) )
							If MsSeek( xFilial("FK1") + SE5->E5_IDORIG )
								oModelBxR := FWLoadModel("FINM010") //Recarrega o Model de movimentos para pegar o campo do relacionamento (SE5->E5_IDORIG)
								oModelBxR:SetOperation( MODEL_OPERATION_UPDATE ) //Alterao
								oModelBxR:Activate()
								oModelBxR:SetValue( "MASTER", "E5_GRV", .T. ) //Habilita gravao SE5
								//E5_OPERACAO 1 = Altera E5_SITUACA da SE5 para 'C' e gera estorno na FK5
								//E5_OPERACAO 2 = Grava E5 com E5_TIPODOC = 'ES' e gera estorno na FK5
								//E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK5
								oModelBxR:SetValue( "MASTER", "E5_OPERACAO", 2 ) //E5_OPERACAO 3
						
								cCamposE5 := "{"
								cCamposE5 += "{'E5_HISTOR' ,'Cancel. de Compensacao'}"
								cCamposE5 += "}"		
								oModelBxR:SetValue( "MASTER", "E5_CAMPOS", cCamposE5 ) //Informa os campos da SE5 que ser gravados indepentes de FK5
						
								If oModelBxR:VldData()
							       	oModelBxR:CommitData()
								Else
									lRet := .F.
								    cLog := cValToChar(oModelBxR:GetErrorMessage()[4]) + ' - '
								    cLog += cValToChar(oModelBxR:GetErrorMessage()[5]) + ' - '
								    cLog += cValToChar(oModelBxR:GetErrorMessage()[6])        	
						       		Help( ,,"M030VALID",,cLog, 1, 0 )
								Endif								
								
								oModelBxR:DeActivate()							
								oModelBxR:Destroy() 
								oModelBxR:= Nil
	
							Endif
							RestArea(aAreaAnt)
						EndIf
	  					/*//Comentei a parte que deletava o SE5 - 07/07/2020
	  					Else
							If AllTrim( SE5->E5_TABORI ) == "FK1"
								aAreaAnt := GetArea()
								dbSelectArea( "FK1" )
								FK5->( DbSetOrder( 1 ) )
								If MsSeek( xFilial("FK1") + SE5->E5_IDORIG )
									oModelBxR := FWLoadModel("FINM010") //Recarrega o Model de movimentos para pegar o campo do relacionamento (SE5->E5_IDORIG)
									oModelBxR:SetOperation( MODEL_OPERATION_UPDATE ) //Alterao
									oModelBxR:Activate()
									oModelBxR:SetValue( "MASTER", "E5_GRV", .T. ) //Habilita gravao SE5
									oModelBxR:SetValue( "MASTER", "HISTMOV", STR0032 ) //"Cancelamento de compensao"
									//E5_OPERACAO 1 = Altera E5_SITUACA da SE5 para 'C' e gera estorno na FK5
									//E5_OPERACAO 2 = Grava E5 com E5_TIPODOC = 'ES' e gera estorno na FK5
									//E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK5
									oModelBxR:SetValue( "MASTER", "E5_OPERACAO", 3 ) //E5_OPERACAO 3
							
									If oModelBxR:VldData()
								       	oModelBxR:CommitData()
									Else
										lRet := .F.
									    cLog := cValToChar(oModelBxR:GetErrorMessage()[4]) + ' - '
									    cLog += cValToChar(oModelBxR:GetErrorMessage()[5]) + ' - '
									    cLog += cValToChar(oModelBxR:GetErrorMessage()[6])        	
							       		Help( ,,"M030VALID",,cLog, 1, 0 )
									Endif								
	
									oModelBxR:DeActivate()							
									oModelBxR:Destroy() 
									oModelBxR:= Nil
																		
								Endif
								RestArea(aAreaAnt)
							Endif
						EndIf*/
	
						//
						//?Guarda a chave primary da baixa para busca futura            ?
						//
						cPrimary := SE5->E5_DOCUMEN
						aadd(aComissao,{SE5->E5_MOTBX,SE5->E5_SEQ,SE5->(RecNo())})
	
						//
						//?Encerra a atualizacao do adiantamento                        ?
						//
						If SE5->E5_TIPODOC <> "CM"
							SE1->E1_SALDO  += SE5->E5_VLMOED2 + SE1->E1_DECRESC
							SE1->E1_SDDECRE := SE1->E1_DECRESC
							SE1->E1_SDACRES := SE1->E1_ACRESC
						EndIf
	
						//VERIFICAR SE HOUVE BAIXA POR DECRESCIMO/ACRESCIMO E DESCONSIDERA PARA
						//RECOMPOR O SALDO E DEPOIS O CANCELAMENTO DA BAIXA IRA RECOMPOR O SALDO COM DECRESCIMO
						aAreaSE5 := SE5->(GetArea())
						dbSelectArea("SE5")
						dbSetOrder(7)
						If DbSeek(c_FilProc+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA)
							While ( !Eof() .And. SE5->E5_FILIAL == c_FilProc .And.;
									SE5->E5_PREFIXO == SE1->E1_PREFIXO .And.;
									SE5->E5_NUMERO == SE1->E1_NUM .And.;
									SE5->E5_PARCELA == SE1->E1_PARCELA .And.;
									SE5->E5_TIPO == SE1->E1_TIPO .And.;
									SE5->E5_CLIFOR == SE1->E1_CLIENTE .And.;
									SE5->E5_LOJA == SE1->E1_LOJA  )
	
								// Nao pode pegar titulo ja cancelado na baixa
								// Procurar registro da baixa DC para nao refazer o saldo de forma errada pois
								// o decrescimo sera considerado no cancelamento da baixa
								// Este caso so se aplica quando ha baixa de titulo com decrescimo
								If SE5->E5_TIPODOC $ "DC" .AND. EMPTY(SE5->E5_SITUACA)
							   	   SE1->E1_SALDO  -= SE1->E1_DECRESC
			            		   SE1->E1_SDDECRE := 0
								EndIF
								dbSkip()
							EndDo
						EndIf
	
						RestArea(aAreaSE5)
						SE1->E1_VALLIQ := 0
						SE1->E1_STATUS := IIf(SE1->E1_SALDO > 0.01,"A","B")
						SE1->E1_BAIXA  := IIf(SE1->E1_SALDO==SE1->E1_VALOR,Ctod(""),SE1->E1_BAIXA)
	
						//
						//?Executa o codeblock                                          ?
						//
						Eval(bBlock,aAreaSE1[3],cPrimary)
	                EndIf
				Next nX
				For nY := 1 to Len( aDelCorre )
					dbGoTo(aDelCorre[nY][1])
					//
					//?Bloco de codigo para contabilizacao                          ?
					//
					If lLctPad
						Eval(bContabil)
					EndIf
					If AllTrim( SE5->E5_TABORI ) == "FK1"
						aAreaAnt := GetArea()
						dbSelectArea( "FK1" )
						FK5->( DbSetOrder( 1 ) )
						If MsSeek( xFilial("FK1") + SE5->E5_IDORIG )
							oModelBxR := FWLoadModel("FINM010") //Recarrega o Model de movimentos para pegar o campo do relacionamento (SE5->E5_IDORIG)
							oModelBxR:SetOperation( MODEL_OPERATION_UPDATE ) //Alterao
							oModelBxR:Activate()
							oModelBxR:SetValue( "MASTER", "E5_GRV", .T. ) //Habilita gravao SE5
							oModelBxR:SetValue( "MASTER", "HISTMOV", STR0032 ) //"Cancelamento de compensao"
							//E5_OPERACAO 1 = Altera E5_SITUACA da SE5 para 'C' e gera estorno na FK5
							//E5_OPERACAO 2 = Grava E5 com E5_TIPODOC = 'ES' e gera estorno na FK5
							//E5_OPERACAO 3 = Deleta da SE5 e gera estorno na FK5
							oModelBxR:SetValue( "MASTER", "E5_OPERACAO", 3 ) //E5_OPERACAO 3
					
							If oModelBxR:VldData()
						       	oModelBxR:CommitData()
							Else
								lRet := .F.
							    cLog := cValToChar(oModelBxR:GetErrorMessage()[4]) + ' - '
							    cLog += cValToChar(oModelBxR:GetErrorMessage()[5]) + ' - '
							    cLog += cValToChar(oModelBxR:GetErrorMessage()[6])        	
					       		Help( ,,"M030VALID",,cLog, 1, 0 )
							Endif								
	
							oModelBxR:DeActivate()
							oModelBxR:Destroy() 
							oModelBxR:= Nil
							
						Endif
						RestArea(aAreaAnt)
					Endif
	
				Next nY
				//
				//?Calcula a Comissao do titulo principal                       ?
				//
				If SuperGetMv("MV_COMISCR") == "S"
					RestArea(aAreaSE1)
					Fa440DeleB(aComissao,.F.,.F.,"FINA330")
				EndIf
			EndIf
			//
			//?Retira a trava do registro principal                         ?
			//
			SE1->(MsUnLock())
		EndIf
	EndIf
	RestArea(aArea)
Return(.T.)
/*/{Protheus.doc} f_MntRateio
Monta o array para o rateio SEv e SEZ
@type Function
@author 
@since 10/07/2020
@version 1.0
@return Nil
/*/
Static Function f_MntRateio( o_ObjRateio )
	Local aAuxEv 	:= {} // array auxiliar do rateio multinaturezas
	Local a_RetEvEz	:= {} //array do rateio multinaturezas
	Local aAuxEz 	:= {} // Array auxiliar de multiplos centros de custo
	Local aRatEz	:= {} //Array do rateio de centro de custo em multiplas naturezas
	Local c_AuxCus	:= ""
	Local n,c			:= 0

	For n:= 1 To Len(o_ObjRateio)
		//Adicionando o vetor da natureza
		aadd( aAuxEv ,{"EV_NATUREZ" , Padr( Alltrim( o_ObjRateio[n]:EV_NATUREZ ),TamSx3("EV_NATUREZ")[1]), Nil })//natureza a ser rateada
		aadd( aAuxEv ,{"EV_VALOR" 	, o_ObjRateio[n]:EV_VALOR, Nil })//valor do rateio na natureza
		If (o_ObjRateio[n]:EV_PERC = 0)
			aadd( aAuxEv ,{"EV_PERC" 	, ( ( o_ObjRateio[n]:EV_VALOR*100 ) / o_TitReceber:E1_VALOR ), Nil } ) //percentual passado em caracter 
		Else
			aadd( aAuxEv ,{"EV_PERC" 	, o_ObjRateio[n]:EV_PERC, Nil } ) //percentual passado em caracter
		EndIf
		If Len(o_ObjRateio[n]:CCUSTORATEIO) > 0		
			aadd( aAuxEv ,{"EV_RATEICC" , "1", Nil })//indicando que ha rateio por centro de custo
			For c:= 1 To Len(o_ObjRateio[n]:CCUSTORATEIO)				
				c_AuxCus:= Alltrim( u_ONECTA2(1,padr( o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_ITEMCTA ,tamsx3("EZ_ITEMCTA")[1]),TamSx3("E1_ITEMC")[1]) )				
				aAuxEz:={}
				aadd( aAuxEz ,{"EZ_CCUSTO"  , padr( c_AuxCus ,tamsx3("EZ_CCUSTO")[1]), Nil })//centro de custo da natureza
				aadd( aAuxEz ,{"EZ_ITEMCTA" , padr( o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_ITEMCTA ,tamsx3("EZ_ITEMCTA")[1]), Nil })//centro de custo da natureza
				aadd( aAuxEz ,{"EZ_VALOR" 	, o_ObjRateio[n]:CCUSTORATEIO[c]:EZ_VALOR, Nil })//valor do rateio neste centro de custo
				aadd( aRatEz,aAuxEz )
			Next
			aadd( aAuxEv,{"AUTRATEICC" , aRatEz, Nil })//recebendo dentro do array da natureza os multiplos centros de custo
			aAdd( a_RetEvEz,aAuxEv )//adicionando a natureza ao rateio de multiplas naturezas
			aAuxEv	:= {}
			aRatEz	:= {}			
		Else			
			aadd( aAuxEv ,{"EV_RATEICC" , "2", Nil })//indicando que nao ha rateio por centro de custo
			aAdd( a_RetEvEz,aAuxEv )//adicionando a natureza ao rateio de multiplas naturezas
			aAuxEv	:= {}
			aRatEz	:= {}			
		EndIf
	Next

Return( a_RetEvEz )
/*/{Protheus.doc} f_GravaLA
 c_FilTi, c_Titulo, c_IdBxRm )
	@type  Static Function
	@author user
	@since 02/09/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function f_GravaLA( c_FilTi, c_Titulo, c_IdBxRm )
	Local c_Qry		:= ""
	Local a_AreaE5	:= SE5->( GetArea() )

	c_Qry:= "SELECT E5_LA, E5_FILIAL, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_CLIFOR, E5_LOJA, E5_FSBXRM, R_E_C_N_O_ as REC"+chr(13)+chr(10)
	c_Qry+= "FROM "+RETSQLNAME("SE5")+" E5"+chr(13)+chr(10)
	c_Qry+= "WHERE E5_FILIAL = '"+c_FilTi+"' "+chr(13)+chr(10)
	c_Qry+= "AND E5.D_E_L_E_T_ = '' "+chr(13)+chr(10)
	c_Qry+= "AND E5_PREFIXO = 'RM' AND E5_LA <> 'S' "+chr(13)+chr(10)
	If( !Empty( c_IdBxRm ) )
		c_Qry+= "AND ( E5_NUMERO = '"+c_Titulo+"' AND E5_FSBXRM = '"+c_IdBxRm+"' ) "+chr(13)+chr(10)
	Else
		c_Qry+= "AND E5_NUMERO = '"+c_Titulo+"'"+chr(13)+chr(10)
	EndIf
	c_Qry+= "ORDER BY R_E_C_N_O_ "						
	TCQUERY c_Qry ALIAS QRY NEW
	dbSelectArea("QRY")
	If !( QRY->( Eof() ) )
		While !( QRY->( Eof() ) )
			DbSelectArea( "SE5" )
			DbGoto( QRY->REC )
			//Garante que posicionou no registro da compensacao
			If( SE5->( Recno() ) = QRY->REC ) 
				If( Alltrim(SE5->E5_LA)	<> 'S' )
					RecLock("SE5", .F. )
					SE5->E5_LA:= "S"
					MsUnLock()
				EndIf
			EndIf
			dbSelectArea("QRY")
			QRY->(DbSkip())
		EndDo
	EndIf						
	dbSelectArea("QRY")
	QRY->(dbCloseArea())
	RestArea( a_AreaE5 )
Return()

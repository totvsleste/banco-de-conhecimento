#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "TBICONN.CH"
#include "TOTVS.CH"
#include "rwmake.CH"
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include "vkey.ch"

#DEFINE ENTER CHR(13) + CHR(10)

WSSERVICE FSWS110 Description "<span style='color:red;'>Fabrica de Software - TOTVS BA</span><br/>&nbsp;&nbsp;&nbsp;�<span style='color:red;'> WS para <b>Solicitao de Transferencia</b>.</span>"

	WSDATA o_EmpFil	 		AS STstrEmpFil		//Estrutura de Empresa e Filial
	WSDATA o_Seguranca		AS STstrSegur			//Estrutura de seguranca: login e senha
	WSDATA o_ST				AS STstrSolTtran		//Estrutura da ST
	WSDATA o_Cliente		AS STstrClientes		//Estrutura da ST
	WSDATA c_Aplicacao 		AS STRING			//Somente usado no metodo RetUsuarios
	WSDATA c_TpCompra 		AS STRING			//Somente usado no metodo RetUsuarios
	WSDATA c_Filtro 		AS STRING			//Somente usado no metodo RetUsuarios
	WSDATA o_RetMtd			AS STstrRetMetodos	//Estrutura de retorno dos Metodos
	WSDATA o_RetUsr			AS ARRAY OF STstrRetUsuarios	//Estrutura de retorno dos Usuarios
	WSDATA o_RetCliente		AS ARRAY OF STstrInfCliente	//Estrutura de retorno dos Usuarios
	WSDATA o_Pedido 		AS STstrPedido


	WSMETHOD STmtdGravaST							//Metodo de inclusao a Solicita��o de Transfer�ncia no protheus
	WSMETHOD STmtdRetUsuarios						//Metodo que retorna os usuarios baseados no cadastros de aprovadores da SC
	WSMETHOD STmtdIncCliente						//Metodo que inclui clientes
	WSMETHOD STmtdIncVenda						//Metodo que inclui clientes
	WSMETHOD STmtdRetClientes						//Metodo que inclui clientes

ENDWSSERVICE

//Estrutura de Empresa e Filial
WSSTRUCT STstrEmpFil

	WSDATA c_Empresa 	AS STRING
	WSDATA c_Filial		AS STRING

ENDWSSTRUCT

//Estrutura de login e senha
WSSTRUCT STstrSegur

	WSDATA c_Login		AS STRING
	WSDATA c_Senha 		AS STRING

ENDWSSTRUCT

//Estrutura da ST
WSSTRUCT STstrSolTtran

	WSDATA c_FilSolicitante	AS STRING
	WSDATA d_DataST 		AS STRING
	WSDATA d_DataAprova 	AS STRING
	WSDATA c_Solicitante	AS STRING
	WSDATA c_Aprovador		AS STRING
	WSDATA c_CCusto			AS STRING
	WSDATA c_Projeto		AS STRING
	WSDATA c_UNNegocio		AS STRING
	WSDATA c_Destino		AS STRING 				//E=Estoque; D=Despesas; I=Investimento; M= Manutencao
	WSDATA c_Grau			AS STRING 				//A=Alto;E=Emergencial;N=Normal;F=Emergencial (Fornecedor)
	WSDATA a_Itens			AS ARRAY OF STstrItens	//Estrutura dos itens da ST

ENDWSSTRUCT

//Estrutura dos itens da ST
WSSTRUCT STstrItens

	WSDATA c_Produto	  	AS STRING
	WSDATA n_QtdSolicit		AS FLOAT

ENDWSSTRUCT

//Estrutura de Retorno dos Metodos
WSSTRUCT STstrRetMetodos

	WSDATA l_Status		AS BOOLEAN
	WSDATA c_Mensagem	AS STRING

ENDWSSTRUCT

//Estrutura de Retorno dos Usuarios
WSSTRUCT STstrRetUsuarios

	WSDATA c_Codigo		AS STRING
	WSDATA c_Nivel		AS STRING

ENDWSSTRUCT

//Estrutura de Retorno dos Metodos
WSSTRUCT STstrClientes

	WSDATA c_Nome      AS STRING
	WSDATA c_NomeReduz AS STRING
	WSDATA c_Tipo      AS STRING
	WSDATA c_Endereco  AS STRING
	WSDATA c_Estado    AS STRING
	WSDATA c_Mun       AS STRING
	WSDATA c_Cnpj      AS STRING
	WSDATA c_Pessoa    AS STRING
	WSDATA c_Bairro    AS STRING
	WSDATA c_Cep       AS STRING
	WSDATA c_DDD       AS STRING
	WSDATA c_Tel       AS STRING
	WSDATA c_Email     AS STRING
	WSDATA c_TipoCli   AS STRING
	WSDATA c_LimCre    AS FLOAT
	WSDATA c_Natureza  AS STRING
	WSDATA c_ContaContabil  AS STRING
	WSDATA c_CondPag  AS STRING

ENDWSSTRUCT

WSSTRUCT strItemPedido

	WSDATA TES AS STRING
	WSDATA VALORDESCONTO AS FLOAT
	WSDATA PERCENTUAL_DESCONTO AS FLOAT
	WSDATA PRODUTO AS STRING
	WSDATA QUANTIDADE AS float
	WSDATA PRECO_UNITARIO AS FLOAT
	WSDATA PRECO_LISTA AS FLOAT
	WSDATA VALOR AS FLOAT

ENDWSSTRUCT

WSSTRUCT STstrPedido

	WSDATA COD_TABELA_PRECO AS STRING
	WSDATA CONDICAODEPAGAMENTO AS STRING
	WSDATA CLIENTE AS STRING
	WSDATA LOJACLIENTE AS STRING
	WSDATA COD_VENDEDOR AS STRING
	WSDATA TIPO AS STRING
	WSDATA Itens AS ARRAY OF strItemPedido

ENDWSSTRUCT

//Estrutura de Retorno dos Metodos
WSSTRUCT STstrInfCliente

	WSDATA c_Descricao      AS STRING
	WSDATA c_Codigo			 AS STRING

ENDWSSTRUCT

//Gravacao da Prestacao de Contas
WSMETHOD STmtdGravaST WSRECEIVE o_Seguranca, o_EmpFil, o_ST WSSEND o_RetMtd WSSERVICE FSWS110

	Local o_Modelo
	Local o_SZLModel	//Modelo do Cabecalho
	Local o_SZMModel	//Modelo dos itens
	Local l_Continua	:= .T.
	Local l_Ok			:= .T.
	Local I				:= 0
	Local c_NomFilAnte	:= "" //Nome da filial solicitante
	Local a_Error		:= {}
	Local c_MsgError	:= ""
	Local c_Conta		:= ""

	::o_RetMtd	:= WSCLASSNEW("STstrRetMetodos")

	//o_EmpFil:c_Filial eh a filial solicitada

	//Loga na filial solicitada
	RpcSetType(3)
	RpcSetEnv(o_EmpFil:c_Empresa,o_EmpFil:c_Filial)

	c_UserWS	:= UPPER(ALLTRIM(SUPERGETMV("FS_FJUSRWS",,"totvs_fjc")))
	c_PswWS		:= UPPER(ALLTRIM(SUPERGETMV("FS_FJPSWWS",,"totvs@123")))

	//Busca o nome da filial solicitante
	dbSelectArea("SM0")
	dbSeek(o_EmpFil:c_Empresa+o_ST:c_FilSolicitante)
	c_NomFilAnte		:= SM0->M0_FILIAL

	//Re-posiciona na filial solicitada
	dbSelectArea("SM0")
	dbSeek(o_EmpFil:c_Empresa+o_EmpFil:c_Filial)

	CFILANT:= o_EmpFil:c_Filial

	//Validando o usu�rio e senha
	If ( UPPER(o_Seguranca:c_Login) <> UPPER(c_UserWS) )

		::o_RetMtd:l_Status		:= .F.
		::o_RetMtd:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida! Usuario de acesso ao WS inv�lido!!!"+CHR(13)+CHR(10)
		Conout("FSWS110: Tentativa de acesso ao WS nao permitida! Usuario de acesso ao WS inv�lido!!!")

	ELSEIF ( UPPER(o_Seguranca:c_Senha) <> UPPER(c_PswWS) )

		::o_RetMtd:l_Status		:= .F.
		::o_RetMtd:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida! Senha de valida��o de acesso ao WS inv�lida!!!"+CHR(13)+CHR(10)
		Conout("FSWS110: Tentativa de acesso ao WS nao permitida! Senha de valida��o de acesso ao WS inv�lida!!!")

	ELSE

		For I:= 1 To Len(o_ST:a_Itens)

			DBSELECTAREA("SB1")
			DBSETORDER(1)
			IF !DBSEEK(XFILIAL("SB1")+ALLTRIM(o_ST:a_Itens[I]:c_Produto))

				::o_RetMtd:l_Status		:= .F.
				::o_RetMtd:c_Mensagem	:= "Codigo do produto: "+ALLTRIM(o_ST:a_Itens[I]:c_Produto)+" n�o encontrado no Protheus!!!"+CHR(13)+CHR(10)
				Conout("FSWS110: Codigo do produto n�o encontrado no Protheus!!!")
				l_Continua:= .F.
				Exit

			ENDIF

			IF (o_ST:a_Itens[I]:n_QtdSolicit < 1)

				::o_RetMtd:l_Status		:= .F.
				::o_RetMtd:c_Mensagem	:= "Quantidade Inv�lida!!!"+CHR(13)+CHR(10)
				Conout("FSWS110: Quantidade Inv�lida!!!")
				l_Continua:= .F.
				Exit

			ENDIF

			DBSELECTAREA("CTT")
			DBSETORDER(1)
			IF !DBSEEK(XFILIAL("CTT")+ALLTRIM(o_ST:c_CCusto))

				::o_RetMtd:l_Status		:= .F.
				::o_RetMtd:c_Mensagem	:= "Codigo do centro de custo: "+ALLTRIM(o_ST:c_CCusto)+" n�o encontrado no Protheus!!!"+CHR(13)+CHR(10)
				Conout("FSWS110: Codigo do centro de custo: "+ALLTRIM(o_ST:c_CCusto)+" n�o encontrado no Protheus!!!")
				l_Continua:= .F.
				Exit

			ENDIF

		Next

		If (l_Continua)

			o_Modelo	:= FwLoadModel( "FESTA001" )
			o_Modelo:SetOperation( MODEL_OPERATION_INSERT )
			o_Modelo:Activate()

			o_SZLModel	:= o_Modelo:GetModel('FORMSZL')
			o_SZMModel	:= o_Modelo:GetModel('FORMSZM')
			//habilita o parametro para permitir o a adicao de linha
			o_SZMModel:SetNoInsertLine( .F. )

			o_SZLModel:SetValue( "ZL_FILIAL" 	, o_EmpFil:c_Filial)
			//o_SZLModel:SetValue( "ZL_DFILADA"	, SUBSTR(SM0->M0_FILIAL,1,20))
			o_SZLModel:SetValue( "ZL_FILSANT"	, o_ST:c_FilSolicitante)
			o_SZLModel:SetValue( "ZL_DFILANT"	, SUBSTR(c_NomFilAnte,1,20))
			o_SZLModel:SetValue( "ZL_DATA"	 	, CTOD(o_ST:d_DataST))
			o_SZLModel:SetValue( "ZL_DATAAPV"	, CTOD(o_ST:d_DataAprova))
			o_SZLModel:SetValue( "ZL_SOLICIT"	, o_ST:c_Solicitante)
			o_SZLModel:SetValue( "ZL_NOMSOL"	, SUBSTR(UsrFullName(o_ST:c_Solicitante),1,25))
			o_SZLModel:SetValue( "ZL_APROVA" 	, o_ST:c_Aprovador)
			o_SZLModel:SetValue( "ZL_NOMAPR"	, SUBSTR(UsrFullName(o_ST:c_Aprovador),1,25))
			o_SZLModel:SetValue( "ZL_CCUSTO" 	, o_ST:c_CCusto)
			o_SZLModel:SetValue( "ZL_DESCCC"	, SUBSTR(Posicione("CTT",1,xFilial("CTT")+o_ST:c_CCusto,"CTT_DESC01"),1,30))
			o_SZLModel:SetValue( "ZL_DESTINO"	, o_ST:c_Destino)
			o_SZLModel:SetValue( "ZL_PROJETO"	, o_ST:c_Projeto)
			o_SZLModel:SetValue( "ZL_GRAU"	 	, o_ST:c_Grau)
			o_SZLModel:SetValue( "ZL_UNEGOC"	, o_ST:c_UNNegocio)
			o_SZLModel:SetValue( "ZL_DESCUN"	, Posicione("SZ9",1,xFilial("SZ9")+o_ST:c_UNNegocio,"Z9_DESC"))
			o_SZLModel:SetValue( "ZL_STATUS"	, '1')


			For I:= 1 To Len(o_ST:a_Itens)

				o_SZMModel:AddLine()
				o_SZMModel:SetValue( "ZM_FILIAL"	, o_EmpFil:c_Filial)
				o_SZMModel:SetValue( "ZM_ITEM"		, Strzero( I,4) )
				o_SZMModel:SetValue( "ZM_PRODUTO"	, o_ST:a_Itens[I]:c_Produto)
				o_SZMModel:SetValue( "ZM_DESC"		, SUBSTR(Posicione("SB1",1,xFilial("SB1")+o_ST:a_Itens[I]:c_Produto,"B1_DESC"),1,100))
				o_SZMModel:SetValue( "ZM_UN"		, Posicione("SB1",1,xFilial("SB1")+o_ST:a_Itens[I]:c_Produto,"B1_UM"))
				o_SZMModel:SetValue( "ZM_QTDSOL"	, o_ST:a_Itens[I]:n_QtdSolicit)
				o_SZMModel:SetValue( "ZM_QTDATEN"	, 0)
				o_SZMModel:SetValue( "ZM_SLDATEN"	, 0)

				If o_ST:c_Destino == "E" //Estoque
					c_Conta	:=	POSICIONE("SB1",1,xFilial("SB1")+o_ST:a_Itens[I]:c_Produto,"B1_CONTAE")
				ElseIf o_ST:c_Destino == "D" //Despesa
					c_Conta	:=	POSICIONE("SB1",1,xFilial("SB1")+o_ST:a_Itens[I]:c_Produto,"B1_ZCNTD")
				ElseIf o_ST:c_Destino == "I" //Investimento
					c_Conta	:=	POSICIONE("SB1",1,xFilial("SB1")+o_ST:a_Itens[I]:c_Produto,"B1_ZCNTI")
				ElseIf o_ST:c_Destino == "M" //Manuten��o
					c_Conta	:=	POSICIONE("SB1",1,xFilial("SB1")+o_ST:a_Itens[I]:c_Produto,"B1_ZCNTM")
				Endif

				o_SZMModel:SetValue( "ZM_CONTA"	, c_Conta)

			Next

			If o_Modelo:VldData()
				o_Modelo:CommitData()
				l_Ok	:= .T.
			Else
				o_Modelo:CancelData()
				a_Error := o_Modelo:GetErrorMessage()
				c_MsgError:= "Erro ao gravar o modelo de dados" + ENTER
				c_MsgError+= "Formulario: " + a_Error[1] + ENTER
				c_MsgError+= "Assistente: " + a_Error[2] + ENTER
				c_MsgError+= "Campo: " + a_Error[4] + ENTER
				c_MsgError+= "Erro: " + a_Error[6]
				l_Ok	:= .F.
			EndIf

			o_Modelo:DeActivate()
			o_Modelo:Destroy()

			If l_Ok
				::o_RetMtd:l_Status		:= .T.
				::o_RetMtd:c_Mensagem	:= "Solicita��o de Transfer�ncia gravada com sucesso!!!"
				Conout("FSWS110: Solicita��o de Transfer�ncia gravada com sucesso!!!")
			Else
				::o_RetMtd:l_Status		:= .F.
				::o_RetMtd:c_Mensagem	:= c_MsgError
				Conout("FSWS110: "+c_MsgError)
			EndIf

		EndIf

	ENDIF

RETURN(.T.)

//Gravacao da
WSMETHOD STmtdRetUsuarios WSRECEIVE o_EmpFil, c_Aplicacao, c_TpCompra WSSEND o_RetUsr WSSERVICE FSWS110

	Local c_Sql		:= ""
	Local a_Usus	:= {}
	Local I			:= 1
	Local o_Temp

	Self:o_RetUsr	:= {}

	//::o_RetUsr	:= WSCLASSNEW("STstrRetUsuarios")

	RpcSetType(3)
	RpcSetEnv(o_EmpFil:c_Empresa,o_EmpFil:c_Filial)

	c_Sql	+=	"SELECT "												+ENTER
	c_Sql	+=	"DISTINCT  "											+ENTER
	c_Sql	+=	" Z4_NIVEL "											+ENTER
	c_Sql	+=	",Z4_USER  "											+ENTER
	c_Sql	+=	",Z4_CDAPL "											+ENTER
	c_Sql	+=	",Z4_CDTC  "											+ENTER
	c_Sql	+=	"FROM "+RETSQLNAME("SZ4")+" SZ4 "						+ENTER
	c_Sql	+=	"WHERE	SZ4.D_E_L_E_T_	=	'' "						+ENTER
	c_Sql	+=	"AND	Z4_FILIAL		=	'"+o_EmpFil:c_Filial+"' "	+ENTER
	c_Sql	+=	"AND	Z4_CDAPL		=	'"+ c_Aplicacao+"' "		+ENTER
	c_Sql	+=	"AND	Z4_CDTC			=	'"+	c_TpCompra+"' "			+ENTER
	c_Sql	+=	"AND	Z4_MSBLQL		<>	'1' "						+ENTER
	c_Sql	+=	"ORDER BY Z4_NIVEL, Z4_USER, Z4_CDTC"					+ENTER

	c_Sql 	:= ChangeQuery(c_Sql)
	cAlias 	:= GetNextAlias()
	DbUseArea(.T., "TOPCONN", TcGenQry(,,c_Sql), cAlias, .T., .T.)

	dbSelectArea(cAlias)
	dbGoTop()
	While !Eof()
		o_Temp:= WSCLASSNEW("STstrRetUsuarios")
		o_Temp:c_Codigo	:= (cAlias)->Z4_USER
		o_Temp:c_Nivel	:= (cAlias)->Z4_NIVEL
		AADD(Self:o_RetUsr, o_Temp)
		I++
		dbSkip()
	Enddo
	dbCloseArea(cAlias)

RETURN(.T.)

WSMETHOD STmtdRetClientes WSRECEIVE o_EmpFil, c_Filtro WSSEND o_RetCliente WSSERVICE FSWS110

	Local c_Sql		:= ""
	Local a_Usus	:= {}
	Local I			:= 1
	Local o_Temp

	Self:o_RetCliente	:= {}

	//::o_RetUsr	:= WSCLASSNEW("STstrRetUsuarios")

	RpcSetType(3)
	RpcSetEnv(o_EmpFil:c_Empresa,o_EmpFil:c_Filial)

	c_Sql	+=	"SELECT "												+ENTER
	c_Sql	+=	"DISTINCT  "											+ENTER
	c_Sql	+=	" A1_COD "												+ENTER
	c_Sql	+=	",A1_NOME  "											+ENTER
	c_Sql	+=	",A1_NREDUZ "											+ENTER
	c_Sql	+=	",A1_CGC  "												+ENTER
	c_Sql	+=	"FROM "+RETSQLNAME("SA1")+" SA1 "						+ENTER
	c_Sql	+=	"WHERE	SA1.D_E_L_E_T_	=	'' "						+ENTER

	IF (c_Filtro <> "")
		c_Sql	+= "AND (UPPER(SA1.A1_COD) LIKE UPPER('%"+c_Filtro+"%') OR UPPER(SA1.A1_NOME) LIKE UPPER('%"+c_Filtro+"%') OR UPPER(SA1.A1_NREDUZ) LIKE UPPER('%"+c_Filtro+"%') OR UPPER(SA1.A1_CGC) LIKE UPPER('%"+c_Filtro+"%'))"
	END IF

	c_Sql	+=	"ORDER BY A1_NOME, A1_COD "								+ENTER

	c_Sql 	:= ChangeQuery(c_Sql)
	cAlias 	:= GetNextAlias()
	DbUseArea(.T., "TOPCONN", TcGenQry(,,c_Sql), cAlias, .T., .T.)

	dbSelectArea(cAlias)
	dbGoTop()
	While !Eof()
		o_Temp:= WSCLASSNEW("STstrInfCliente")
		o_Temp:c_Codigo	:= (cAlias)->A1_COD
		o_Temp:c_Descricao	:= (cAlias)->A1_NOME
		AADD(Self:o_RetCliente, o_Temp)
		I++
		dbSkip()
	Enddo
	dbCloseArea(cAlias)

RETURN(.T.)

//Gravacao da
WSMETHOD STmtdIncCliente WSRECEIVE o_Seguranca, o_EmpFil, o_Cliente WSSEND o_RetMtd WSSERVICE FSWS110

	local l_Erro := .F.
	PRIVATE lMsErroAuto := .F.

	::o_RetMtd	:= WSCLASSNEW("STstrRetMetodos")

	//Loga na filial solicitada
	RpcSetType(3)
	RpcSetEnv(o_EmpFil:c_Empresa,o_EmpFil:c_Filial)

	c_UserWS	:= UPPER(ALLTRIM(SUPERGETMV("FS_FJUSRWS",,"totvs_fjc")))
	c_PswWS		:= UPPER(ALLTRIM(SUPERGETMV("FS_FJPSWWS",,"totvs@123")))

	//Validando o usu�rio e senha
	If ( UPPER(o_Seguranca:c_Login) <> UPPER(c_UserWS) )

		::o_RetMtd:l_Status		:= .F.
		::o_RetMtd:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida! Usuario de acesso ao WS inv�lido!!!"+CHR(13)+CHR(10)
		Conout("WSST: Tentativa de acesso ao WS nao permitida! Usuario de acesso ao WS inv�lido!!!")
		Return(.T.)

	ELSEIF ( UPPER(o_Seguranca:c_Senha) <> UPPER(c_PswWS) )

		::o_RetMtd:l_Status		:= .F.
		::o_RetMtd:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida! Senha de valida��o de acesso ao WS inv�lida!!!"+CHR(13)+CHR(10)
		Conout("WSST: Tentativa de acesso ao WS nao permitida! Senha de valida��o de acesso ao WS inv�lida!!!")
		Return(.T.)

	ELSE

		DBSELECTAREA("SA1")
		DBSETORDER(3)
		IF DBSEEK(XFILIAL("SA1")+SUBSTR(o_Cliente:c_Cnpj,1,8),.T.)

			IF o_Cliente:c_Cnpj == SA1->A1_CGC
				::o_RetMtd:c_Mensagem := "CNPJ já existe na base de dados."
				::o_RetMtd:l_Status := .F.
				Return(.T.)
			ELSE
				IF SUBSTR(o_Cliente:c_Cnpj,1,8) == SUBSTR(SA1->A1_CGC,1,8)
					conout("ENTROU 8 DIGITOS IGUAL")
					c_Cod	:= SA1->A1_COD

					DBSELECTAREA("SA1")
					DBSETORDER(1)
					DBSEEK(XFILIAL("SA1")+c_Cod)
					WHILE SA1->(!EOF()) .AND. SA1->A1_FILIAL+SA1->A1_COD == XFILIAL("SA1")+c_Cod

						c_Loja	:= STRZERO(VAL(SA1->A1_LOJA)+1,2)

						SA1->(DBSKIP())

					ENDDO

				ENDIF
			ENDIF

		ELSE

			BEGINSQL ALIAS "QRY"

			SELECT MAX(A1_COD) AS SA1_MAX FROM %TABLE:SA1% SA1 WHERE SA1.%NOTDEL%

			ENDSQL
			DBSELECTAREA("QRY")
			c_Cod 	:= cvaltochar(val(QRY->SA1_MAX) + 1)
			c_Loja	:= "01"
			QRY->(DBCLOSEAREA())

		ENDIF

		aVetor:={		 {"A1_FSFIL"    ,"0101"           	,Nil},;
		{"A1_COD"       ,c_Cod           	,Nil},;
		{"A1_LOJA"      ,c_Loja               	,Nil},;
		{"A1_NOME"      ,o_Cliente:c_Nome  	,Nil},;
		{"A1_NREDUZ"    ,o_Cliente:c_NomeReduz			,Nil},;
		{"A1_TIPO"      ,o_Cliente:c_Tipo					,Nil},;
		{"A1_END"       ,o_Cliente:c_Endereco		,Nil},;
		{"A1_EST"       ,o_Cliente:c_Estado				    ,Nil},;
		{"A1_MUN"       ,o_Cliente:c_Mun		,Nil},;
		{"A1_PESSOA"    ,o_Cliente:c_Pessoa		,Nil},;
		{"A1_BAIRRO"    ,o_Cliente:c_Bairro		,Nil},;
		{"A1_CEP"       ,o_Cliente:c_Cep		,Nil},;
		{"A1_DDD"       ,o_Cliente:c_DDD		,Nil},;
		{"A1_TEL"       ,o_Cliente:c_Tel		,Nil},;
		{"A1_EMAIL"     ,o_Cliente:c_Email		,Nil},;
		{"A1_NATUREZ"   ,o_Cliente:c_Natureza		,Nil},;
		{"A1_COND"     ,o_Cliente:c_CondPag		,Nil},;
		{"A1_CONTA"     ,o_Cliente:c_ContaContabil		,Nil},;
		{"A1_ZZTPCLI"   ,o_Cliente:c_TipoCli		,Nil},;
		{"A1_LC"        ,o_Cliente:c_LimCre		,Nil},;
		{"A1_CGC"       ,o_Cliente:c_CNPJ		,Nil}}


		MSExecAuto({|x,y| Mata030(x,y)},aVetor,3) //3- Inclus�o, 4- Altera��o, 5- Exclus�o


		If lMsErroAuto

			::o_RetMtd:l_Status		:= .F.
			::o_RetMtd:c_Mensagem	:= Mostraerro()

		Else

			dbselectarea("SA1")

			RECLOCK("SA1",.F.)
			SA1->A1_FSFIL := ""
			MSUNLOCK()

			::o_RetMtd:l_Status		:= .T.
			::o_RetMtd:c_Mensagem	:= "Cliente incluido com sucesso!"
		Endif

	ENDIF

RETURN(.T.)

//Gravacao da
WSMETHOD STmtdIncVenda WSRECEIVE o_Seguranca, o_EmpFil, o_Pedido WSSEND o_RetMtd WSSERVICE FSWS110
	Local a_CabTemp			:= {}
	Local a_Linha			:= {}
	Local a_ItemTemp		:= {}
	Local c_TES				:= ""
	Local c_Retorno			:= ""
	local a_Itens       	:= {}
	local a_ItensErro   	:= {}
	local a_Erros       	:= {}
	local c_NumItemAux  	:= ""
	Local c_Qry 			:= ""
	local c_Comissao		:= 0
	LOCAL c_NumPed			:= ""
	LOCAL c_Recno			:= ""
	local c_TipoOperacao	:= ""
	local c_CodProd			:= ""
	local c_CodCli			:= ""
	local c_LojaCli			:= ""
	LOCAL c_CondPGTO		:= ""
	local c_LojaEnt			:= ""
	local c_Tab				:= ""
	local c_Vend			:= ""
	local c_Nome			:= ""
	local n_Desc4			:= 0
	local n_Desc1			:= 0
	local n_Desc2			:= 0
	local n_Desc3			:= 0
	local c_CodCliEnt		:= ""
	local c_LojaCliEnt		:= ""
	local c_Tipo		:= ""
	local n_DescFuncao		:= 0
	local l_PodeGravar		:= .T.
	local i
	local c_log 			:=""

	Local c_NumPed			:= ""

	PRIVATE lMsErroAuto 	:= .F.

	//Loga na filial solicitada
	RpcSetType(3)
	RpcSetEnv(::o_EmpFil:c_Empresa,::o_EmpFil:c_Filial)

	c_UserWS	:= UPPER(ALLTRIM(SUPERGETMV("FS_FJUSRWS",,"totvs_fjc")))
	c_PswWS		:= UPPER(ALLTRIM(SUPERGETMV("FS_FJPSWWS",,"totvs@123")))

	//Validando o usu�rio e senha
	If ( UPPER(o_Seguranca:c_Login) <> UPPER(c_UserWS) )

		::o_RetMtd:l_Status		:= .F.
		::o_RetMtd:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida! Usuario de acesso ao WS inv�lido!!!"+CHR(13)+CHR(10)
		Conout("WSST: Tentativa de acesso ao WS nao permitida! Usuario de acesso ao WS inv�lido!!!")
		Return(.T.)

	ELSEIF ( UPPER(o_Seguranca:c_Senha) <> UPPER(c_PswWS) )

		::o_RetMtd:l_Status		:= .F.
		::o_RetMtd:c_Mensagem	:= "Tentativa de acesso ao WS nao permitida! Senha de valida��o de acesso ao WS inv�lida!!!"+CHR(13)+CHR(10)
		Conout("WSST: Tentativa de acesso ao WS nao permitida! Senha de valida��o de acesso ao WS inv�lida!!!")
		Return(.T.)

	ELSE

		c_Vend			:= ::o_Pedido:COD_VENDEDOR
		c_CodCliEnt		:= ::o_Pedido:CLIENTE
		c_CodCli		:= ::o_Pedido:CLIENTE
		c_LojaCliEnt	:= ::o_Pedido:LOJACLIENTE
		c_LojaCli		:= ::o_Pedido:LOJACLIENTE
		c_Tab  			:= ::o_Pedido:COD_TABELA_PRECO
		c_CondPGTO		:= ::o_Pedido:CONDICAODEPAGAMENTO
		c_Tipo			:= ::o_Pedido:TIPO


		c_Vend			:= PADR(c_Vend, TamSX3("A3_COD")[1])
		c_CodCliEnt		:= PADR(c_CodCliEnt, TamSX3("A1_COD")[1])
		c_CodCli		:= PADR(c_CodCli, TamSX3("A1_COD")[1])
		c_LojaCliEnt	:= PADR(c_LojaCliEnt, TamSX3("A1_LOJA")[1])
		c_LojaCli		:= PADR(c_LojaCli, TamSX3("A1_LOJA")[1])
		c_Tab  			:= PADR(c_Tab, TamSX3("DA0_CODTAB")[1])
		c_CondPGTO		:= PADR(c_CondPGTO, TamSX3("E4_CODIGO")[1])
		c_Tipo			:= PADR(c_Tipo, TamSX3("A1_TIPO")[1])


		DBSELECTAREA("SA1")
		DBSETORDER(1)
		DBSEEK(XFILIAL("SA1")+c_CodCli+c_LojaCli)

		c_CodCli	:= SA1->A1_COD
		c_Nome		:= SA1->A1_NOME
		c_NumPed	:= GetSXENum("SC5","C5_NUM")

		/*
		a_CabTemp:= {{"C5_FILIAL"	, ::o_EmpFil:c_Filial 		,NIL},;	//FILIAL
		{"C5_TIPO" 		, "N"   		,NIL},;	//TIPO DE PEDIDO - NORMAL
		{"C5_CLIENTE"	, c_CodCli		,NIL},;	//CLIENTE
		{"C5_LOJACLI"	, c_LojaCli		,NIL},;	//LOJA
		{"C5_TIPOCLI"	, c_Tipo		,NIL},;	//TIPO DO CLIENTE
		{"C5_CONDPAG"	, c_CondPGTO		,NIL},;	//COND. PAGAMENTO
		{"C5_EMISSAO"	, ddatabase		,NIL},;	//EMISSAO DO TITULO
		{"C5_TABELA"	, c_Tab		,NIL},;	//EMISSAO DO TITULO
		{"C5_MOEDA"  	, 1				,NIL}}	//MOEDA
		*/

		//{"C5_VEND1"		, c_Vend		,NIL},;	//EMISSAO DO TITULO

		For i:=1 to Len(::o_Pedido:ITENS)
			conout("WSPedido>GravaPedido>Produto: "+::o_Pedido:ITENS[i]:PRODUTO)
			c_CodProd	:= ::o_Pedido:ITENS[i]:PRODUTO
			c_CodProd	:= c_CodProd	+	Space(TamSX3("B1_COD")[1]-LEN(c_CodProd))

			DBSELECTAREA("SB1")
			DBSETORDER(1)
			DBSEEK(XFILIAL("SB1")+c_CodProd)

			IF (::o_Pedido:ITENS[i]:TES == "S")

				c_TES := SA1->A1_FSTESB


				IF (EMPTY(c_TES))

					::o_RetMtd:l_Status		:= .F.
					::o_RetMtd:c_Mensagem	:= "CLIENTE NÃO POSSUI TES DE BONIFICAÇÃO!!!"+CHR(13)+CHR(10)

					Return(.T.)
				ENDIF

			ELSE

				c_TES := SA1->A1_FSTESV

			ENDIF

			IF (EMPTY(c_TES))

				::o_RetMtd:l_Status		:= .F.
				::o_RetMtd:c_Mensagem	:= "CLIENTE NÃO POSSUI TES!!!"+CHR(13)+CHR(10)

				Return(.T.)
			ENDIF

			dbSelectArea("SC6")
			RecLock("SC6", .T.)
			SC6->C6_FILIAL	:= ::o_EmpFil:c_Filial
			SC6->C6_NUM		:= c_NumPed
			SC6->C6_ITEM	:= StrZero(i,2)
			SC6->C6_PRODUTO	:= c_CodProd
			SC6->C6_DESCRI	:= SB1->B1_DESC
			SC6->C6_UM		:= SB1->B1_UM
			SC6->C6_CLI		:= c_CodCli
			SC6->C6_LOJA	:= c_LojaCli
			SC6->C6_TES		:= c_TES
			SC6->C6_ENTREG	:= ddatabase
			SC6->C6_QTDVEN	:= ::o_Pedido:ITENS[i]:QUANTIDADE
			SC6->C6_PRCVEN	:= ::o_Pedido:ITENS[i]:PRECO_LISTA
			SC6->C6_VALOR	:= ::o_Pedido:ITENS[i]:VALOR
			MsUNlock()

			/*
			AADD(a_ItemTemp,{ {"C6_FILIAL" 	, ::o_EmpFil:c_Filial			,NIL},;	//FILIAL
			{"C6_ITEM"	 	, StrZero(i,2)	 	,NIL},; //NUMERO DO ITEM DO PEDIDO
			{"C6_PRODUTO"	, c_CodProd			,NIL},;	//PRODUTO
			{"C6_DESCRI" 	, SB1->B1_DESC	 	,NIL},; //DESCRICAO
			{"C6_UM"  	 	, SB1->B1_UM	 	,NIL},;	//UNIDADE DE MEDIDA
			{"C6_CLI"  		, c_CodCli			,NIL},;	//CLIENTE
			{"C6_LOJA" 		, c_LojaCli			,NIL},;	//LOJA
			{"C6_TES" 		, c_TES				,NIL},;	//TIPO DE OPERACAO
			{"C6_ENTREG" 	, ddatabase			,NIL},;	//ENTREGA
			{"C6_QTDVEN" 	, ::o_Pedido:ITENS[i]:QUANTIDADE	,NIL},;	//QUANTIDADE
			{"C6_PRCVEN" 	, ::o_Pedido:ITENS[i]:PRECO_LISTA	,NIL},;	//VALOR UNIT�RIO
			{"C6_VALOR " 	, ::o_Pedido:ITENS[i]:VALOR		,NIL}})	//VALOR TOTAL
			*/

		Next

		dbSelectArea("SC5")
		RecLock("SC5", .T.)
		SC5->C5_FILIAL	:= ::o_EmpFil:c_Filial
		SC5->C5_NUM		:= c_NumPed
		SC5->C5_TIPO	:= "N"
		SC5->C5_CLIENTE	:= c_CodCli
		SC5->C5_LOJACLI	:= c_LojaCli
		SC5->C5_TIPOCLI	:= c_Tipo
		SC5->C5_CONDPAG	:= c_CondPGTO
		SC5->C5_EMISSAO	:= ddatabase
		SC5->C5_TABELA	:= c_Tab
		SC5->C5_MOEDA	:= 1
		SC5->C5_VEND1 	:= c_Vend
		MsUnlock()

		/*
		MsExecAuto({|x, y, z| MATA410(x, y, z)}, a_CabTemp, a_ItemTemp, 3)

		If lMsErroAuto


			c_log := Mostraerro()
			conout("ERRO =====>: "+c_log)
			::o_RetMtd:l_Status		:= .F.
			::o_RetMtd:c_Mensagem	:= c_log
			RollbackSx8()

		Else
		*/

			/*
			dbselectarea("SC5")

			RECLOCK("SC5",.F.)
			SC5->C5_VEND1 := c_Vend
			MSUNLOCK()
			*/

			ConfirmSX8()
			::o_RetMtd:l_Status		:= .T.
			::o_RetMtd:c_Mensagem	:= "Pedido criado com sucesso!"

		//Endif

	ENDIF

RETURN(.T.)
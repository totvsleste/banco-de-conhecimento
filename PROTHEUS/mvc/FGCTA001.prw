#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"

#DEFINE ENTER CHR( 13 ) + CHR( 10 )

User Function FGCTA001()

	Local oModel 	:= FWLoadModel("CNTA300") //Carrega o modelo
	Local c_NumPed	:= SC7->C7_NUM
	Local a_Error	:= {}
	Local n_Item	:= 1

	oModel:SetOperation(MODEL_OPERATION_INSERT) // Seta operação de inclusão

	oModel:Activate() // Ativa o Modelo

	//Cabeçalho do contrato
	oModel:SetValue( 'CN9MASTER'    , 'CN9_DTINIC'  , Ctod("01/08/2018")    )
	oModel:SetValue( 'CN9MASTER'    , 'CN9_NUMERO'  , Strzero(Val(SC7->C7_NUM),TamSX3("CNA_CONTRA")[1]) )
	oModel:SetValue( 'CN9MASTER'    , 'CN9_UNVIGE'  , '3' )
	oModel:SetValue( 'CN9MASTER'    , 'CN9_VIGE'        , 1 )
	oModel:SetValue( 'CN9MASTER'    , 'CN9_MOEDA'       , 1
	oModel:SetValue( 'CN9MASTER'    , 'CN9_CONDPG'  , '001' )
	oModel:SetValue( 'CN9MASTER'    , 'CN9_TPCTO'       , '001' )
	oModel:SetValue( 'CN9MASTER'    , 'CN9_FLGREJ'  , '2' )
	oModel:SetValue( 'CN9MASTER'    , 'CN9_FLGCAU'  , '2' )
	oModel:SetValue( 'CN9MASTER'    , 'CN9_ASSINA'  , Ctod("01/08/2018") )

	//Cliente/Fornecedor do Contrato
	oModel:SetValue( 'CNCDETAIL'    , 'CNC_CODIGO'  , SC7->C7_FORNECE  )
	oModel:SetValue( 'CNCDETAIL'    , 'CNC_LOJA'    , SC7->C7_LOJA )

	//Planilhas do Contrato
	oModel:LoadValue(   'CNADETAIL' , 'CNA_CONTRA'  , Strzero(Val(SC7->C7_NUM),TamSX3("CNA_CONTRA")[1]) )
	oModel:SetValue(    'CNADETAIL'     , 'CNA_NUMERO'  , '000001' )
	oModel:SetValue(    'CNADETAIL'     , 'CNA_FORNEC'  , SC7->C7_FORNECE  )
	oModel:SetValue(    'CNADETAIL'     , 'CNA_LJFORN'  , SC7->C7_LOJA )
	oModel:SetValue(    'CNADETAIL'     , 'CNA_TIPPLA'  , '001' )
	oModel:SetValue(    'CNADETAIL'     , 'CNA_FLREAJ'  , '2' )

	//Itens da Planilha do Contrato

	dbSelectArea("SC7")
	dbSetOrder(1)
	dbSeek(xFilial("SC7") + c_NumPed )
	ProcRegua( RecCount() )
	While SC7->(!EOF()) .And. SC7->C7_FILIAL + SC7->C7_NUM == xFilial("SC7") + c_NumPed

		IncProc("Gerando Contrato...")
		oModel:SetValue( 'CNBDETAIL'    , 'CNB_ITEM'	, Strzero(n_Item,3) )
		oModel:SetValue( 'CNBDETAIL'    , 'CNB_PRODUT'  , SC7->C7_PRODUTO )
		oModel:SetValue( 'CNBDETAIL'    , 'CNB_QUANT'	, SC7->C7_QUANT )
		oModel:SetValue( 'CNBDETAIL'    , 'CNB_VLUNIT'	, SC7->C7_PRECO )
		oModel:SetValue( 'CNBDETAIL'    , 'CNB_PEDTIT'	, '1' )
		oModel:SetValue( 'CNBDETAIL'    , 'CNB_FSORIG'	, 'MATA120' )
		oModel:GetModel('CNBDETAIL'):AddLine()
		n_Item++
		SC7->(dbSkip())

	EndDo
	oModel:GetModel('CNBDETAIL'):DeleteLine()

	//Cronograma Financeiro
	/*
	oModel:GetModel('CNFDETAIL'):SetNoInserLine(.F.)
	oModel:GetModel('CNFDETAIL'):SetNoUpdateLine(.F.)

	oModel:LoadValue( 'CNFDETAIL'   , 'CNF_NUMERO'  , '000071'              )
	oModel:SetValue( 'CNFDETAIL'    , 'CNF_PARCEL'  , '01'                  )
	oModel:SetValue( 'CNFDETAIL'    , 'CNF_COMPET'  , '02/2017'         )
	oModel:SetValue( 'CNFDETAIL'    , "CNF_VLPREV"  , 500                   )
	oModel:SetValue( 'CNFDETAIL'    , "CNF_VLREAL"  , 0                     )
	oModel:SetValue( 'CNFDETAIL'    , "CNF_SALDO"       , 500                   )
	oModel:SetValue( 'CNFDETAIL'    , 'CNF_PRUMED'  , Ctod("24/02/2017")    )
	oModel:SetValue( 'CNFDETAIL'    , 'CNF_DTVENC'  , Ctod("24/02/2017")    )
	oModel:SetValue( 'CNFDETAIL'    , 'CNF_TXMOED'  , 1                     )

	oModel:GetModel('CNFDETAIL'):AddLine()

	oModel:LoadValue( 'CNFDETAIL'   , 'CNF_NUMERO'  , '000071'              )
	oModel:SetValue( 'CNFDETAIL'    , 'CNF_PARCEL'  , '02'                  )
	oModel:SetValue( 'CNFDETAIL'    , 'CNF_COMPET'  , '02/2017'         )
	oModel:SetValue( 'CNFDETAIL'    , "CNF_VLPREV"  , 500                   )
	oModel:SetValue( 'CNFDETAIL'    , "CNF_VLREAL"  , 0                     )
	oModel:SetValue( 'CNFDETAIL'    , "CNF_SALDO"       , 500                   )
	oModel:SetValue( 'CNFDETAIL'    , 'CNF_PRUMED'  , Ctod("24/02/2017")    )
	oModel:SetValue( 'CNFDETAIL'    , 'CNF_DTVENC'  , Ctod("24/02/2017")    )
	oModel:SetValue( 'CNFDETAIL'    , 'CNF_TXMOED'  , 1                     )
	*/

	//Validação e Gravação do Modelo
	If oModel:VldData()
		If !oModel:CommitData()
			oModel:CancelData()
			a_Error := oModel:GetErrorMessage()
			Alert( "Erro ao gravar o modelo de dados" + ENTER + ;
			"ID do Formulario: " + a_Error[1] + ENTER + ;
			"ID do Campo: " + a_Error[2] + ENTER + ;
			"ID do Formulario " + a_Error[3] + ENTER + ;
			"ID do Campo: " + a_Error[4] + ENTER + ;
			"ID do Erro " + a_Error[5] + ENTER + ;
			"Erro: " + a_Error[6])
		EndIf
	Else
		oModel:CancelData()
		a_Error := oModel:GetErrorMessage()
		Alert( "Erro ao gravar o modelo de dados" + ENTER + ;
		"ID do Formulario: " + a_Error[1] + ENTER + ;
		"ID do Campo: " + a_Error[2] + ENTER + ;
		"ID do Formulario " + a_Error[3] + ENTER + ;
		"ID do Campo: " + a_Error[4] + ENTER + ;
		"ID do Erro " + a_Error[5] + ENTER + ;
		"Erro: " + a_Error[6])
	EndIf

Return
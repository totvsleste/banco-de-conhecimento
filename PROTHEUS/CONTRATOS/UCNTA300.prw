#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"

#DEFINE ENTER CHR( 13 ) + CHR( 10 )

User Function UCNTA300()

	Local oModel
	Private INCLUI	:= .T.

	oModel	:= FWLoadModel( "CNTA301" ) 		//Carrega o modelo
	oModel:SetOperation( MODEL_OPERATION_INSERT ) 	// Seta operação de inclusão
	oModel:Activate() 								// Ativa o Modelo

	//Cabeçalho do contrato

	oModel:GetModel('CN9MASTER'):SetValue('CN9_ESPCTR', '2' )
	oModel:GetModel('CN9MASTER'):SetValue('CN9_DTINIC', Ctod("01/10/2017") )
	oModel:GetModel('CN9MASTER'):SetValue('CN9_NUMERO', '000000000000069' )
	oModel:GetModel('CN9MASTER'):SetValue('CN9_UNVIGE', '3' )
	oModel:GetModel('CN9MASTER'):SetValue('CN9_VIGE', 1 )
	oModel:GetModel('CN9MASTER'):SetValue('CN9_MOEDA', 1 )
	oModel:GetModel('CN9MASTER'):SetValue('CN9_CONDPG', '001' )
	oModel:GetModel('CN9MASTER'):SetValue('CN9_TPCTO', '001' )
	//oModel:GetModel('CN9MASTER'):SetValue('CN9_FLGREJ', '2' )
	//oModel:GetModel('CN9MASTER'):SetValue('CN9_FLGCAU', '2' )
	//oModel:GetModel('CN9MASTER'):SetValue('CN9_ASSINA', Ctod("24/02/2017")  )

	//Cliente/Fornecedor do Contrato
	oModel:GetModel('CNCDETAIL'):SetValue( 'CNC_CLIENT', '000001' )
	oModel:GetModel('CNCDETAIL'):SetValue( 'CNC_LOJACL', '01' )

	//Planilhas do Contrato
	oModel:LoadValue( 'CNADETAIL', 'CNA_CONTRA', '000000000000069' )
	oModel:GetModel('CNADETAIL'):SetValue( 'CNA_NUMERO'  , '000001' )
	oModel:GetModel('CNADETAIL'):SetValue( 'CNA_CLIENT'  , '000001' )
	oModel:GetModel('CNADETAIL'):SetValue( 'CNA_LOJACL'  , '01' )
	oModel:GetModel('CNADETAIL'):SetValue( 'CNA_TIPPLA'  , '001' )
	//oModel:GetModel('CNADETAIL'):SetValue( 'CNA_FLREAJ'  , '2' )

	//Itens da Planilha do Contrato
	//oStruct := oModel:GetModel( 'CNBDETAIL' ):GetStruct()
	//oStruct:SetProperty( 'CNB_PRODUT' , MODEL_FIELD_OBRIGAT, .F. )
	//oStruct:SetProperty( 'CNB_TE' , MODEL_FIELD_OBRIGAT, .F. )

	oModel:GetModel('CNBDETAIL'):SetValue( 'CNB_ITEM', '001' )
	oModel:GetModel('CNBDETAIL'):SetValue( 'CNB_PRODUT', PADR( '001',TAMSX3("CNB_PRODUT")[1] ) )
	oModel:GetModel('CNBDETAIL'):SetValue( 'CNB_QUANT', 1 )
	oModel:GetModel('CNBDETAIL'):SetValue( 'CNB_VLUNIT'  , 1000 )
	oModel:GetModel('CNBDETAIL'):SetValue( 'CNB_PEDTIT'  , '1' )
	oModel:GetModel('CNBDETAIL'):SetValue( 'CNB_TS'  , '501' )
	//oModel:GetModel('CNBDETAIL'):SetValue( 'CNB_TE'  , '001' )

	//Cronograma Financeiro

	oModel:GetModel('CNFDETAIL'):SetNoInserLine(.F.)
	oModel:GetModel('CNFDETAIL'):SetNoUpdateLine(.F.)

	oModel:LoadValue( 'CNFDETAIL'   , 'CNF_NUMERO'  , '000071' )
	oModel:GetModel('CNFDETAIL'):SetValue( 'CNF_PARCEL'  , '01' )
	oModel:GetModel('CNFDETAIL'):SetValue( 'CNF_COMPET'  , '10/2017' )
	oModel:GetModel('CNFDETAIL'):SetValue( "CNF_VLPREV"    , 500 )
	oModel:GetModel('CNFDETAIL'):SetValue( "CNF_VLREAL"    , 0 )
	oModel:GetModel('CNFDETAIL'):SetValue( "CNF_SALDO"     , 500 )
	oModel:GetModel('CNFDETAIL'):SetValue( 'CNF_PRUMED'  , Ctod("01/10/2017")  )
	oModel:GetModel('CNFDETAIL'):SetValue( 'CNF_DTVENC'  , Ctod("10/10/2017")  )
	oModel:GetModel('CNFDETAIL'):SetValue( 'CNF_TXMOED'  , 1 )

	oModel:GetModel('CNFDETAIL'):AddLine()

	oModel:LoadValue( 'CNFDETAIL'   , 'CNF_NUMERO'  , '000071'  )
	oModel:GetModel('CNFDETAIL'):SetValue( 'CNF_PARCEL'  , '02' )
	oModel:GetModel('CNFDETAIL'):SetValue( 'CNF_COMPET'  , '11/2017' )
	oModel:GetModel('CNFDETAIL'):SetValue( "CNF_VLPREV"    , 500 )
	oModel:GetModel('CNFDETAIL'):SetValue( "CNF_VLREAL"    , 0 )
	oModel:GetModel('CNFDETAIL'):SetValue( "CNF_SALDO"     , 500 )
	oModel:GetModel('CNFDETAIL'):SetValue( 'CNF_PRUMED'  , Ctod("01/10/2017")  )
	oModel:GetModel('CNFDETAIL'):SetValue( 'CNF_DTVENC'  , Ctod("10/11/2017")  )
	oModel:GetModel('CNFDETAIL'):SetValue( 'CNF_TXMOED'  , 1 )

	//Validação e Gravação do Modelo
	l_Ok := oModel:VldData()

	If !l_Ok

		oModel:CancelData()

		a_Error := oModel:GetErrorMessage()
		c_Error	:= "Erro ao gravar o modelo de dados" + ENTER + ;
		"Id do submodelo de origem: " + a_Error[1] + ENTER + ;
		"Id do campo de origem: " + a_Error[2] + ENTER + ;
		"Id do submodelo de erro: " + a_Error[3] + ENTER + ;
		"Id do campo de erro: " + a_Error[4] + ENTER + ;
		"Id do erro: " + a_Error[5] + ENTER + ;
		"Mensagem do erro: " + a_Error[6]  + ENTER + ;
		"Mensagem da solução: " + a_Error[7]

		Alert( c_Error )

	ELSE
		oModel:CommitData()

	EndIf
Return
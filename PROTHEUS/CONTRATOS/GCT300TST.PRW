#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"

#DEFINE ENTER CHR( 13 ) + CHR( 10 )
User Function GCT300TST()

	Local oModel
	Private INCLUI	:= .T.

	oModel	:= FWLoadModel( "CNTA300" ) 		//Carrega o modelo
	oModel:SetOperation( MODEL_OPERATION_INSERT ) 	// Seta operação de inclusão
	oModel:Activate() 								// Ativa o Modelo

	//-- SetValue
	//Cabeçalho do Contrato
	oModel:SetValue( 'CN9MASTER'    , 'CN9_ESPCTR'  , '2'                   )
	oModel:GetModel('CN9MASTER'):SetValue('CN9_NUMERO', "000000000000015")
	oModel:GetModel('CN9MASTER'):SetValue('CN9_DTINIC', Ctod("01/10/2017"))
	oModel:GetModel('CN9MASTER'):SetValue('CN9_UNVIGE', '2')
	oModel:GetModel('CN9MASTER'):SetValue('CN9_VIGE', 6)
	oModel:GetModel('CN9MASTER'):SetValue('CN9_MOEDA', 1)
	oModel:GetModel('CN9MASTER'):SetValue('CN9_CONDPG', '001')
	oModel:GetModel('CN9MASTER'):SetValue('CN9_TPCTO', '001')
	oModel:GetModel('CN9MASTER'):SetValue('CN9_INDICE', '')
	oModel:GetModel('CN9MASTER'):SetValue('CN9_FLGREJ', '2')
	oModel:GetModel('CN9MASTER'):SetValue('CN9_FLGCAU', '2')
	//oModel:GetModel('CN9MASTER'):SetValue('CN9_DTREV',  Ctod("30/06/2016"))
	//oModel:GetModel('CN9MASTER'):SetValue('CN9_VLADIT', 3500)
	//oModel:GetModel('CN9MASTER'):SetValue('CN9_DTPROP', Ctod("22/01/2016"))
	//oModel:GetModel('CN9MASTER'):SetValue('CN9_PROGRA','2')
	//oModel:GetModel('CN9MASTER'):SetValue('CN9_ASSINA', Ctod("25/01/2016"))
	//oModel:GetModel('CN9MASTER'):SetValue('CN9_EST', 'SP')
	//oModel:GetModel('CN9MASTER'):SetValue('CN9_ALCISS', 7.75)
	//oModel:GetModel('CN9MASTER'):SetValue('CN9_INSSMO', 5)
	//oModel:GetModel('CN9MASTER'):SetValue('CN9_INSSME', 95)
	//oModel:GetModel('CN9MASTER'):SetValue('CN9_AUTO', '1')

	//Cliente/Fornecedor do Contrato
	oModel:GetModel('CNCDETAIL'):SetValue('CNC_CODIGO', "000001")
	oModel:GetModel('CNCDETAIL'):SetValue('CNC_LOJA', "01")

	//Planilhas do Contrato
	//oModel:GetModel('CNADETAIL'):SetValue('CNA_CONTRA', 'GCT_CNTA300CT01')
	oModel:LoadValue('CNADETAIL','CNA_CONTRA', 'GCT_CNTA300CT01')
	oModel:GetModel('CNADETAIL'):SetValue('CNA_NUMERO', '000001')
	oModel:GetModel('CNADETAIL'):SetValue('CNA_FORNEC', "000001")
	oModel:GetModel('CNADETAIL'):SetValue('CNA_LJFORN', '01')
	oModel:GetModel('CNADETAIL'):SetValue('CNA_TIPPLA', '001')
	oModel:GetModel('CNADETAIL'):SetValue('CNA_FLREAJ', '2')

	//Itens da Planilha do Contrato
	oModel:GetModel('CNBDETAIL'):SetValue('CNB_TE', '001')
	oModel:GetModel('CNBDETAIL'):SetValue('CNB_ITEM', '001')
	oModel:GetModel('CNBDETAIL'):SetValue('CNB_PRODUT', '001')
	oModel:GetModel('CNBDETAIL'):SetValue('CNB_QUANT', 5000)
	oModel:GetModel('CNBDETAIL'):SetValue('CNB_VLUNIT', 1.52)
	oModel:GetModel('CNBDETAIL'):SetValue('CNB_DESC', 3.47)
	//oModel:GetModel('CNBDETAIL'):SetValue('CNB_CONTA', cCcontab)

	//oModel:GetModel('CNBDETAIL'):SetValue('CNB_TABPRC', '009')
	//oModel:GetModel('CNBDETAIL'):SetValue('CNB_CC', cCcusto)
	oModel:GetModel('CNBDETAIL'):SetValue('CNB_PEDTIT', '1')
	//oModel:GetModel('CNBDETAIL'):SetValue('CNB_INDICE', '001')

	//Validação e Gravação do Modelo
	l_Ok := oModel:VldData()

	If !l_Ok

		oModel:CancelData()

		a_Error := oModel:GetErrorMessage()
		c_Error	:= "Erro ao gravar o modelo de dados" + ENTER + ;
		"ID do Formulario: " + a_Error[1] + ENTER + ;
		"ID do Campo: " + a_Error[2] + ENTER + ;
		"ID do Formulario " + a_Error[3] + ENTER + ;
		"ID do Campo: " + a_Error[4] + ENTER + ;
		"ID do Erro " + a_Error[5] + ENTER + ;
		"Erro: " + a_Error[6]

		Alert( c_Error )
		//::o_Retorno:l_Status	:= .F.
		//::o_Retorno:c_Mensagem	:= 'Ops... Parece que algo deu errado. Verifique o log abaixo: ' + ENTER + c_Error
	ELSE
		oModel:CommitData()

	EndIf

Return
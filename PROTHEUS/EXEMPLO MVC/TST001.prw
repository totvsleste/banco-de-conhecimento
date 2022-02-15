#INCLUDE "TOTVS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

#DEFINE ENTER CHR( 13 ) + CHR( 10 )

User Function TST001()

	Local o_Modelo
	Local o_View
	Local o_Master
	Local l_Ok		:= .T.
	Local c_Error	:= ""

	dbSelectArea( "SA1" )
	dbSetOrder( 3 )
	If dbSeek( xFilial("SA1") + "78062314553", .T. )

		dbSelectArea( "AD1" )
		dbSetOrder( 1 )
		If dbSeek( xFilial( "AD1") + "000001" + "01", .T. )

			o_Modelo := FwLoadModel( "FCRMA01" )
			o_Modelo:SetOperation( MODEL_OPERATION_UPDATE )
			o_Modelo:Activate()

			o_Master	:= o_Modelo:GetModel( 'SZ0MASTER' )

			//o_Master:SetValue( 'Z0_NUMOPOR'	, ::o_DadosSZ0:Z0_NUMOPOR )
			//o_Master:SetValue( 'Z0_REVISAO'	, ::o_DadosSZ0:Z0_REVISAO )
			o_Master:SetValue( 'Z0_COTACAO' , "XPTO" )
			o_Master:SetValue( 'Z0_PREMIO'	, 150000 )
			o_Master:SetValue( 'Z0_CLIENTE' , SA1->A1_COD )
			o_Master:SetValue( 'Z0_LOJA'	, SA1->A1_LOJA )
			o_Master:SetValue( 'Z0_NOME'	, SA1->A1_NREDUZ )

			l_Ok := o_Modelo:VldData()
			l_Ok := o_Modelo:CommitData()

			If !l_Ok

				o_Modelo:CancelData()

				a_Error := o_Modelo:GetErrorMessage()
				c_Error	:= "Erro ao gravar o modelo de dados" + ENTER + ;
				"ID do Formulario: " + a_Error[1] + ENTER + ;
				"ID do Campo: " + a_Error[2] + ENTER + ;
				"ID do Formulario " + a_Error[3] + ENTER + ;
				"ID do Campo: " + a_Error[4] + ENTER + ;
				"ID do Erro " + a_Error[5] + ENTER + ;
				"Erro: " + a_Error[6]

				::o_Retorno:l_Status	:= .F.
				::o_Retorno:c_Mensagem	:= 'Ops... Parece que algo deu errado. Verifique o log abaixo: ' + ENTER + c_Error

			Else

				::o_Retorno:l_Status	:= .T.
				::o_Retorno:c_Mensagem	:= 'Pré-Contrato atualizado com sucesso!!!'

			EndIf

			o_Modelo:DeActivate()
			o_Modelo:Destroy()

		Else

			::o_Retorno:l_Status	:= .F.
			::o_Retorno:c_Mensagem	:= 'Ops... A oportunidade ' + ::o_DadosSZ0:Z0_NUMOPOR + '/' + ::o_DadosSZ0:Z0_REVISAO + ' não foi encontrada no Protheus!'

		EndIf

	Else

		::o_Retorno:l_Status	:= .F.
		::o_Retorno:c_Mensagem	:= 'Ops... O cliente ' + ::o_DadosSZ0:Z0_CLIENTE + ' não foi encontrado no Protheus!'

	EndIf

Return
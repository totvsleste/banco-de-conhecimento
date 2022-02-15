User Function fEnviaEmail()

	Local lRet       := .T.
	Local lAutentica := GetNewPar( "MV_RELAUTH" , .T. )
	Local lSSL		 := GetNewPar( "MV_RELSSL"  , .F. )
	Local lTLS		 := GetNewPar( "MV_RELTLS"  , .T. )
	Local cServer	 := GetNewPar( "MV_RELSERV" , "mailing.fieb.org.br" )
	Local cAccount   := GetNewPar( "MV_XMLOR04" , "transferenciacontabil@fieb.org.br" )
	Local cPass      := GetNewPar( "MV_XPSOR04" , "fieb@123" )
	Local cMsgAttach := ""
	Local aAprovOrc  := StrTokArr( AllTrim( GetNewPar( "MV_XAPROOR" , "000186" ) ) , ";" )
	Local aAprovCtb  := StrTokArr( AllTrim( GetNewPar( "MV_XAPROVC" , "000186" ) ) , ";" )
	Local nPorta	 := GetNewPar( "MV_PORSMTP" , 25 )
	Local nStatus	 := 0
	Local nRet 	     := 0
	Local nA		 := 0
	Local oMsgMail	 := TMailMessage():New()
	Local oGerMail	 := TMailManager():New()
	Local xRetorno   := Nil
	Local cAssunto   := "Transferência Contábil/Orçamentária"
	Local cTO 		 := ""
	Local cCC        := ""
	Local cMensagem  := ""



	cTO := "francisco.ssa@totvs.com.br"

	cMensagem := "Sua transferência foi aprovada."
	cMensagem += "<BR>" + CHR( 13 ) + CHR( 10 )
	cMensagem += "Número Transferência: " + "00000000000100"

	oGerMail:setUseSSL( lSSL )
	oGerMail:setUseTLS( lTLS )

	nStatus := oGerMail:Init( "" , cServer , cAccount , cPass , , nPorta )

	nRet := oGerMail:SetSMTPTimeout( 120 ) //2 min

	If( nRet == 0 )
		ConOut( "SetSMTPTimeout Sucess" )
	Else

		ConOut( nRet )
		ConOut( oMail:GetErrorString( nRet ) )

	Endif

	If( nStatus == 0 )

		nStatus := oGerMail:SMTPConnect()

		If( nStatus == 0 )

			oMsgMail:Clear()
			oMsgMail:cFrom    := cAccount
			oMsgMail:cTo	  := cTo
			oMsgMail:cCC	  := cCC
			oMsgMail:cSubject := cAssunto
			oMsgMail:cBody    := cMensagem

			nStatus := oMsgMail:Send( oGerMail )

			If( nStatus <> 0 )

				ConOut( "1366 - E-mail não enviado. Destinatario: " + Alltrim( cTo ) + ". Causa: " + oGerMail:GetErrorString( nStatus ) )

				MsgAlert( "1366 - E-mail não enviado. Destinatario: " + Alltrim( cTo ) + ". Causa: " + oGerMail:GetErrorString( nStatus ) )
				Return( .F. )

			Else
				Conout( "E-mail enviado com sucesso. Destinatario: " + Alltrim( cTo ))
			EndIf

			oGerMail:SMTPDisconnect()

		Else

			ConOut( "1372 - E-mail nao enviado. Destinatario: " + Alltrim( cTo ) + ". Causa: " + oGerMail:GetErrorString( nStatus ) )

			MsgAlert( "1372 - E-mail nao enviado. Destinatario: " + Alltrim( cTo ) + ". Causa: " + oGerMail:GetErrorString( nStatus ) )
			Return( .F. )

		Endif

	Else

		ConOut( "1373 - E-mail nao enviado. Destinatario: " + Alltrim( cTo ) + ". Causa: " + oGerMail:GetErrorString( nStatus ) )

		MsgAlert( "1373 - E-mail nao enviado. Destinatario: " + Alltrim( cTo ) + ". Causa: " + oGerMail:GetErrorString( nStatus ) )
		Return( .F. )

	Endif

Return( Nil )
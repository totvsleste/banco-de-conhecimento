#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

Function u_FCOMA014()

	Local n_FolderPai		:= SuperGetMV("FS_FFPAI",,261889)
	Local n_FolderFornec	:= 0
	Local n_PastaCot		:= 0
	Local n_PastaItem		:= 0
	Local c_Alias1			:= ""
	Local n_TamKye  		:= TamSX3("C8_FILIAL")[1] + TamSX3("C8_NUM")[1] + TamSX3("C8_ITEM")[1] + TamSX3("C8_ITEMGRD")[1] + TamSX3("C8_FORNECE")[1] + TamSX3("C8_LOJA")[1]
	Local c_NumCot
	Local attach2			:= ECMDocumentServiceService_attachment():New()
	Local o_File			:= WSECMDocumentServiceService():New()
	Local c_Conhecimento	:= "\dirdoc\co" + Alltrim( SM0->M0_CODIGO ) + "\shared\"
	Local c_Caminho			:= "C:\TOTVS\Conhecimento\"

	Local cUsername			:= SUPERGETMV("FS_USRFLUIG", .F., "admin")
	Local cpassword			:= SUPERGETMV("FS_PSWFLUIG", .F., "admtotvs3")
	Local ncompanyId		:= SUPERGETMV("FS_EMPFLUIG", .F., 1)
	Local cCuserId			:= "000000"
	Local l_Continua		:= .T.
	Local o_Explorer		:= clsExplorer():New()
	Local l_Ret				:= .T.
	Local n_Id				:= 0


	If !MsgYesNo("Deseja enviar cotação para o portal?" , "FJC")

		RETURN()

	ENDIF

	If !o_Explorer:mtdExistePasta( c_Caminho )
		If !o_Explorer:mtdCriaPasta( c_Caminho )
			Alert( "Falha ao criar a pasta " + c_Caminho + ". Contate a area de TI. Não será possível anexar documentos para liberação do Borderô.")
			l_Continua := .F.
		EndIf
	EndIf

	if l_Continua

		a_Forn	:=	{}
		c_NumCot := SC8->C8_NUM
		SC8->(dbSetOrder(1) )//C8_FILIAL, C8_NUM, C8_FORNECE, C8_LOJA, C8_ITEM, C8_NUMPRO, C8_ITEMGRD
		If SC8->(dbSeek(xFilial("SC8")+c_NumCot,.T.))
			While SC8->(!Eof()) .AND. SC8->C8_FILIAL + SC8->C8_NUM == XFILIAL("SC8") + c_NumCot
				n_Pos	:=	Ascan(a_Forn, SC8->(C8_FORNECE+C8_LOJA))
				If n_Pos == 0
					AADD(a_Forn, SC8->(C8_FORNECE+C8_LOJA))
				Endif

				SC8->(dbSkip())
			Enddo
		Endif

		If !Empty(a_Forn)

			For n_I	:=	1	to len(a_Forn)

				n_PastaCot := 0

				DBSELECTAREA("SA2")
				DBSETORDER(1)
				IF DBSEEK(XFILIAL("SA2") + a_Forn[n_I], .T.)


					If Empty( SA2->A2_FSIDFF )

						n_FolderFornec	:= f_CriaPastaFluig( n_FolderPai, Alltrim( SA2->A2_NREDUZ ) )

						If n_FolderFornec<> 0

							RecLock("SA2",.F.)
							SA2->A2_FSIDFF := n_FolderFornec
							MsUnlock()

						EndIf

					else
						n_FolderFornec := SA2->A2_FSIDFF
					EndIf

					SC8->(dbSetOrder(1) )//C8_FILIAL, C8_NUM, C8_FORNECE, C8_LOJA, C8_ITEM, C8_NUMPRO, C8_ITEMGRD, R_E_C_N_O_, D_E_L_E_T_
					If SC8->(dbSeek(xFilial("SC8")+c_NumCot+a_Forn[n_I],.T.))

						While SC8->(!Eof()) .AND. SC8->C8_FILIAL + SC8->C8_NUM + SC8->C8_FORNECE + SC8->C8_LOJA == XFILIAL("SC8") + c_NumCot + a_Forn[n_I]

							If Empty( SC8->C8_FSIDFF1 )

								If n_PastaCot == 0

									n_PastaCot := f_CriaPastaFluig( n_FolderFornec, Alltrim( c_NumCot ) )

								EndIf

								RecLock("SC8",.F.)
								SC8->C8_FSIDFF1 := n_PastaCot
								MsUnlock()

							else

								n_PastaCot := SC8->C8_FSIDFF1

							EndIF

							If Empty( SC8->C8_FSIDFF2 )

								n_PastaItem := f_CriaPastaFluig( n_PastaCot, Alltrim( SC8->C8_ITEM ) + " - " + Alltrim( SC8->C8_PRODUTO ) )

								If n_PastaItem<> 0

									RecLock("SC8",.F.)
									SC8->C8_FSIDFF2 := n_PastaItem
									MsUnlock()

								EndIf

							else

								n_PastaItem := SC8->C8_FSIDFF2

							EndIF

							c_Chave := SC8->C8_FILIAL + SC8->C8_NUM + SC8->C8_ITEM + SC8->C8_ITEMGRD + SC8->C8_FORNECE + SC8->C8_LOJA

							c_Alias1	:= GetNextAlias()

							BeginSQL Alias c_Alias1
							
								SELECT CB.ACB_OBJETO,
								C9.R_E_C_N_O_ AS RECNOS
		
								FROM %TABLE:AC9% C9
								
								JOIN %TABLE:ACB% CB ON 
								CB.%NOTDEL% AND
								CB.ACB_FILIAL = C9.AC9_FILIAL AND
								CB.ACB_CODOBJ = C9.AC9_CODOBJ
								
								WHERE C9.AC9_ENTIDA = %EXP:'SC8'%
								AND SUBSTRING( C9.AC9_CODENT, %Exp:1%, %Exp:n_TamKye% ) = %Exp:c_Chave%
								AND C9.%NOTDEL%
							
							EndSQL

							dbSelectArea( c_Alias1 )
							( c_Alias1 )->( dbGoTop() )
							If ( c_Alias1 )->( !EOF() )

								While ( c_Alias1 )->(!EOF())

									FWMsgRun( Nil, {|| l_Ret := o_Explorer:mtdCopyFile( c_Conhecimento + Alltrim( ( c_Alias1 )->ACB_OBJETO ), c_Caminho + Alltrim( ( c_Alias1 )->ACB_OBJETO  ), .F. ) }, "Arquivos de Cotação", "Aguarde enquanto copiamos o arquivo que será anexado a cotação!" )

									If !l_Ret
										Alert( "Não foi possível copiar o arquivo " + c_Conhecimento + a_Files[nX] + " para máquina local. Não será possível anexar este documento na liberação do Borderô.")
									Else
										o_File		 		 := WSECMDocumentServiceService():New()
										attach2				 := ECMDocumentServiceService_attachment():New()

										attach2:cfileName    := Alltrim( ( c_Alias1 )->ACB_OBJETO )
										attach2:lprincipal   := .T.
										attach2:cfilecontent := FSFileContent( c_Caminho + Alltrim( ( c_Alias1 )->ACB_OBJETO ) )

										aadd(o_File:oWScreateSimpleDocumentAttachments:oWSitem, attach2)

										o_File:createSimpleDocument( cUsername, cPassword, nCompanyId, n_PastaItem, cCuserId, Alltrim( ( c_Alias1 )->ACB_OBJETO ), o_File:oWScreateSimpleDocumentAttachments)

										n_Id := o_File:oWScreateSimpleDocumentresult:oWSitem[1]:ndocumentId

										DbSelectArea("AC9")
										AC9->(DBGOTO( (c_Alias1)->RECNOS ) )
										RECLOCK("AC9", .F.)
										AC9->AC9_FSIDFL := n_Id
										MSUNLOCK()

										FERASE( c_Caminho + Alltrim( ( c_Alias1 )->ACB_OBJETO ))

									EndIf

									( c_Alias1 )->( dbSkip() )

								Enddo

								( c_Alias1 )->( dbCloseArea() )

							EndIf

							SC8->(dbSkip())
						Enddo

					EndIf

					U_FCOMA008( c_NumCot )

					//				IF !EMPTY( SA2->A2_EMAIL ) .AND. !EMPTY(SA2->A2_FSSENHA)
					//
					//					c_Body := "Prezado," + Chr(13) + Chr(10)
					//					c_Body += "Existe uma cotacao no Portal do Fornecedor da Fundacao Jose Carvalho."+ Chr(13) + Chr(10)
					//					c_Body += "Acesse o site da FJC ou acesse o link http://www2.fjc.org.br:2016/"+ Chr(13) + Chr(10)
					//					c_Body += "Grato,"  + Chr(13) + Chr(10)
					//					c_Body += "Setor de Suprimentos"
					//					c_Subj := "FUNDAÇÃO JOSÉ CARVALHO - SETOR DE COMPRAS - COTAÇÃO No."+SC8->C8_NUM
					//					U_TBZZSENDMAIL( SA2->A2_EMAIL, c_Body, c_Subj, .F. )
					//
					//				ENDIF

				ENDIF
			Next
		Endif
	EndIf

Return()


Static Function f_CriaPastaFluig( n_FolderPai, c_NomePasta )

	Local oFolder 			:= WSECMFolderServiceService():New()
	Local cUsername			:= SUPERGETMV("FS_USRFLUIG", .F., "admin")
	Local cpassword			:= SUPERGETMV("FS_PSWFLUIG", .F., "admtotvs3")
	Local ncompanyId		:= SUPERGETMV("FS_EMPFLUIG", .F., 1)
	Local cCuserId			:= "000000"
	Local n_Pasta			:= 0

	oFolder:createSimpleFolder( cUsername, cpassword, ncompanyId, n_FolderPai, cCuserId, c_NomePasta )

	If oFolder:oWScreateSimpleFolderresult:oWSitem[1]:ncompanyId <> 0

		n_Pasta := oFolder:oWScreateSimpleFolderresult:oWSitem[1]:ndocumentId

	EndIf


Return( n_Pasta )

STATIC FUNCTION FSFileContent( cFile )

	Local nH, nSize, nRead, cImgBuffer, cfileContent

	conout("Caminho arquivo->"+cFile)

	nH := Fopen(cFile,0)

	If nH == -1
		conout('Erro de abertura : FERROR '+str(ferror()))
		Return .F.
	Endif

	nSize := fSeek(nH,0,2)
	fSeek(nH,0)

	// Aloca buffer para ler o arquivo do disco
	// e le o arquivo para a memoria
	cImgBuffer := space(nSize)
	nRead := fRead(nH,cImgBuffer,nSize)
	// e fecha o arquivo no disco

	fClose(nH)

return ( cImgBuffer )

Function u_FCOMA14A()


	Local o_TempTable 	:= FWTemporaryTable():New( "TRB" )

	Local a_Fields 		:= {}
	Local a_Campos		:= {}
	Local n_Opca		:= 0
	Local c_Alias		:= GetNextAlias()
	Local c_Key			:= ""

	Private c_Marca		:= GetMark()

	aadd( a_Fields,{"FS_OK"		,"C",2,0} )
	aadd( a_Fields,{"FS_DESCRI"	,"C",TamSX3("ACB_DESCRI")[1],0} )
	aadd( a_Fields,{"FS_OBJETO"	,"C",TamSX3("ACB_OBJETO")[1],0} )
	aadd( a_Fields,{"FS_CODOBJ"	,"C",TamSX3("ACB_CODOBJ")[1],0} )
	aadd( a_Fields,{"FS_FSIDFL"	,"N",TamSX3("AC9_FSIDFL")[1],0} )
	
	o_TempTable:SetFields( a_Fields )
	o_TempTable:AddIndex("I1", {"FS_DESCRI"} )
	o_TempTable:Create()

	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek( xFilial("SA2") + SC8->C8_FORNECE + SC8->C8_LOJA )

	c_Key := SC8->C8_FILIAL + SC8->C8_NUM + SC8->C8_ITEM + SC8->C8_ITEMGRD + SC8->C8_FORNECE + SC8->C8_LOJA + SA2->A2_NOME

	BeginSQL Alias c_Alias

		SELECT 
			ACB_DESCRI,
			ACB_OBJETO,
			ACB_CODOBJ,
			AC9_FSIDFL
		FROM 
			%TABLE:ACB% ACB
		INNER JOIN 
			%TABLE:AC9% AC9 
		ON 
			AC9_FILIAL = ACB_FILIAL 
			AND AC9_CODOBJ = ACB_CODOBJ
			AND AC9.%NOTDEL%
			AND AC9_ENTIDA = %EXP:'SC8'%
			AND AC9_CODENT = %exp:c_Key%
		WHERE 
			ACB.%NOTDEL%

	EndSQL
	dbSelectArea( c_Alias )
	( c_Alias )->( dbGoTop() )
	While ( c_Alias )->( !Eof() )

		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->FS_DESCRI	:= ( c_Alias )->ACB_DESCRI
		TRB->FS_OBJETO	:= ( c_Alias )->ACB_OBJETO
		TRB->FS_CODOBJ	:= ( c_Alias )->ACB_CODOBJ
		TRB->FS_FSIDFL	:= ( c_Alias )->AC9_FSIDFL
		MsUnlock()
	EndDo

	aAdd( a_Campos	,{ "FS_OK"			,,''					,'@!' } )
	aAdd( a_Campos	,{ "FS_DESCRI"		,,'Documento'			,'@!' } )
	aAdd( a_Campos	,{ "FS_OBJETO"		,,'Nome Docto'			,'@!' } )
	aAdd( a_Campos	,{ "FS_CODOBJ"		,,'Codigo'				,'@!' } )
	aAdd( a_Campos	,{ "FS_FSIDFL"		,,'Id Fluig'			,'@!' } )

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de Variaveis Private dos Objetos                             ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	SetPrvt("oDlg1","oBrw1","oBtn1","oBtn2")

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	oDlg1	:= MSDialog():New( 092,232,214,1017,"Exclusao de Documentos",,,.F.,,,,,,.T.,,,.T. )
	
	oBrw1	:= MsSelect():New( "TRB","FS_OK",,a_Campos,.F.,,{004,004,052,412},,, oDlg1 ) 
	
	oBtn1	:= TButton():New( 056,376,"Excluir",oDlg1,{|| n_Opca:=1, oDlg1:End() },037,012,,,,.T.,,"",,,,.F. )
	oBtn2	:= TButton():New( 056,336,"Cancelar",oDlg1,{|| n_Opca:=2, oDlg1:End() },037,012,,,,.T.,,"",,,,.F. )

	oDlg1:Activate(,,,.T.)

	If n_Opca == 1

		TRB->( dbGoTop() )
		While TRB->(!EOF())
			If TRB->FS_OK == ThisMark()

				//AGORA E COM VC, CLAUDIO

			EndIf
			TRB->( dbSkip() )
		Enddo

	EndIf

	TRB->(dbCloseArea() )
	( c_Alias )->( dbCloseArea() )

Return

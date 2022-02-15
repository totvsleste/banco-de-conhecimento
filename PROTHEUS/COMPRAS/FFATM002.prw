#INCLUDE "TOTVS.CH"
#INCLUDE "stdwin.CH"
#INCLUDE "topconn.CH"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
/*/{Protheus.doc} FFATM002
Carga no cadastros de/para dos em alguns campos do cadastros de produtos
@since 13/07/2020
@version 1.0
/*/
User Function FFATM002()
	Local c_Arq	:= f_AbrExpl()

	If( FT_FUSE(c_Arq) == -1 )
		ShowHelpDlg("Validacao de Arquivo",;
			{"O arquivo "+c_Arq+" nÃ£o foi encontrado."},5,;
			{"Verifique se o caminho esta correto ou se arquivo ainda se encontra no local indicado."},5)
		Return()
	Endif

	FwMsgRun(,{|oSay| f_Impr()},"Atualizando os campos no Cadastro de produtos","Aguarde...Atualizando...")

Return()
/*/{Protheus.doc} f_AbrExpl
Abre a janela para selecionar o arquivo
@since 13/07/2020
@version 1.0
/*/
Static Function f_AbrExpl()

	Local c_Arquivo		:= ""
	Local n_RetPasta	:= 1
	Local c_Caminho		:= "C:\Temp\"
	Local c_Titulo1  	:= "Selecione o arquivo"
	Local c_Extens   	:= "Todos os Arquivos | *.csv*"

	n_RetPasta	:= GETF_LOCALHARD + GETF_LOCALFLOPPY + GETF_NETWORKDRIVE

	c_Arquivo	:= cGetFile(c_Extens,c_Titulo1,0,c_Caminho,.T.,n_RetPasta,.T.,.T.)

Return(c_Arquivo)
/*/{Protheus.doc} f_Impr
Imprime os codigos
@since 13/07/2020
@version 1.0
/*/
Static Function f_Impr()
	Local c_Buffer		:= ""
	Local a_Buffer		:= {}
	Local n_Regs		:= 0
	Local n_TotSim		:= 0
	Local n_CodAnt   	:= 0
	Local n_Linha       := 1
	Local n_Garan       := 0
	Local n_Espec       := 0
	Local n_FTorp       := 0
	Local n_FTorv       := 0
	Local a             := 0

	While( !FT_FEOF() )
		c_Buffer:= FT_FREADLN()
		a_Buffer:= STRTOKARR2(c_Buffer,";",.T.)

		If n_Linha <= 2
			For a:= 1 To Len(a_Buffer)
				If Upper(Alltrim(a_Buffer[a])) == "CODIGO"
					n_CodAnt := a_Buffer[a]

				ElseIf Upper(Alltrim(SubStr(a_Buffer[a],1,8))) == "GARANTIA"
					n_Garan  := a_Buffer[a]

				ElseIf Upper(Alltrim(a_Buffer[a])) == "FATOR PESO"
					n_FTorp  := a_Buffer[a]

				ElseIf Upper(Alltrim(a_Buffer[a])) == "FATOR VOLUME"
					n_FTorv  := a_Buffer[a]

				ElseIf Upper(Alltrim(a_Buffer[a])) == "ESPECIE"
					n_Espec  := a_Buffer[a]
				EndIf
			next
			n_Linha  +=  1
		Else
			dbSelectArea("SB1")
			DbOrderNickName("NCKSB1001")

			If DBseek(xFilial("SB1")+a_Buffer[n_CodAnt],.F.)
				RecLock( "SB1", .F. )
				SB1->B1_ESP    := a_Buffer[n_Espec]
				SB1->B1_FATORP := a_Buffer[n_FTorp]
				SB1->B1_FATIRV := a_Buffer[n_FTorv]
				SB1->B1_GARANT := a_Buffer[n_Garan]
				MsUnLock()
				n_Regs++
			Endif
		EndIf
		n_TotSim++
		FT_FSKIP()
	EndDo
	c_Msg:= "Total de registros atualizados: " + Alltrim( Str( n_Regs ) ) + Chr(13) + Chr(10)
	c_Msg+= "Total de produtos processados: " + Alltrim( Str( n_TotSim ) ) + Chr(13) + Chr(10)
	MsgInfo( c_Msg , "Aviso" )
Return()

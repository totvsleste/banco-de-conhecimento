#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOTVS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "FS_BUTTON_CSS.CH"

User Function FLOJA006()

	Local a_Cabec		:= {}
	Local a_Item		:= {}
	Local a_Itens		:= {}
	Local a_Parc		:= {}
	Local a_Parcs		:= {}
	Local n_Total		:= 0
	Local l_Cabec		:= .T.

	Private lMsHelpAuto := .T.
	Private lMsErroAuto := .F.

	If Empty( c_Mesa )
		oTMsgItem1:SetText( "Não é possível encerrar uma comanda sem antes selecionar a mesa!")
		Return()
	EndIf

	//Inicializa as mensagens da barra de status
	oTMsgItem1:SetText("")

	If MsgYesNo("Deseja encerrar a comanda da mesa " + c_Mesa + "?")

		dbSelectArea("SZ0")
		dbSetOrder(1)
		dbSeek( xFilial("SZ0") + Padr( c_Mesa, TamSX3("Z0_MESA")[1] ), .T. )
		While SZ0->( !EOF() ) .AND. SZ0->Z0_MESA == Padr( c_Mesa, TamSX3("Z0_MESA")[1] )

			If l_Cabec

				aAdd( a_Cabec, { "LQ_VEND" 		, SZ0->Z0_ATENDE	, NIL } )
				aAdd( a_Cabec, { "LQ_CLIENTE" 	, "000001" 			, NIL } )
				aAdd( a_Cabec, { "LQ_LOJA" 		, "01" 				, NIL } )
				aAdd( a_Cabec, { "LQ_TIPOCLI" 	, "F" 				, NIL } )
				aAdd( a_Cabec, { "LQ_DTLIM" 	, dDatabase 		, NIL } )
				aAdd( a_Cabec, { "LQ_EMISSAO" 	, dDatabase 		, NIL } )
				aAdd( a_Cabec, { "LQ_CONDPG" 	, "001" 			, NIL } )
				aAdd( a_Cabec, { "LQ_NUMMOV" 	, "1 " 				, NIL } )

				l_Cabec	:= .F.

			EndIf

			a_Item		:= {}
			aAdd( a_Item, {"LR_PRODUTO"	, SZ0->Z0_PRODUTO 	, NIL} )
			aAdd( a_Item, {"LR_QUANT" 	, SZ0->Z0_QUANT 	, NIL} )
			aAdd( a_Item, {"LR_UM" 		, "UN" 				, NIL} )
			aAdd( a_Item, {"LR_DESC" 	, 0 				, NIL} )
			aAdd( a_Item, {"LR_VALDESC"	, 0 				, NIL} )
			aAdd( a_Item, {"LR_TABELA" 	, "1"				, NIL} )
			aAdd( a_Item, {"LR_DESCPRO"	, 0 				, NIL} )
			aAdd( a_Item, {"LR_VEND" 	, SZ0->Z0_ATENDE 	, NIL} )

			AADD( a_Itens, a_Item )

			Reclock("SZ0",.F.)
			SZ0->Z0_STATUS	:= "2"
			MsUnlock()

			n_Total += SZ0->Z0_TOTAL

			SZ0->( dbSkip() )
		EndDo

		a_Parc := {}
		aAdd( a_Parc, {"L4_DATA" 	, dDatabase	, NIL} )
		aAdd( a_Parc, {"L4_VALOR" 	, n_Total 	, NIL} )
		aAdd( a_Parc, {"L4_FORMA" 	, "R$ " 	, NIL} )
		aAdd( a_Parc, {"L4_ADMINIS" , " " 		, NIL} )
		aAdd( a_Parc, {"L4_NUMCART" , " " 		, NIL} )
		aAdd( a_Parc, {"L4_FORMAID" , " " 		, NIL} )
		aAdd( a_Parc, {"L4_MOEDA" 	, 0 		, NIL} )

		aAdd( a_Parcs, a_Parc )

		//f_GravaVenda( a_Cabec,a_Itens ,a_Parcs )
		oTMsgItem1:SetText("Comanda da mesa " + c_Mesa + " encerrada com sucesso! Dirija-se ao caixa!")

		c_Mesa		:= ""
		oTMsgItem2:SetText( "" )

		c_Vendedor 	:= ""
		oTMsgItem3:SetText( "" )

	EndIf

Return()

Static Function f_GravaVenda( a_Cabec,a_Itens ,a_Parcs )

	Begin Transaction

			MSExecAuto({|a,b,c,d,e,f,g,h| Loja701(a,b,c,d,e,f,g,h)},.F.,3,"","",{},a_Cabec,a_Itens ,a_Parcs )

			If lMsErroAuto
				oTMsgItem1:SetText("Erro ao gravar venda. Consulte o log no servidor!")
				MostraErro()
				DisarmTransaction()
			Else
				oTMsgItem1:SetText("Comanda da mesa " + c_Mesa + " encerrada com sucesso! Dirija-se ao caixa!")
			EndIf

		End Transaction

Return()
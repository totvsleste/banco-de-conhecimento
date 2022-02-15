#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOTVS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TBICONN.CH"
#include "FS_BUTTON_CSS.CH"

User Function FLOJA001()

	Private c_Vendedor	:= ""
	Private c_CodVend	:= ""
	Private c_Mesa		:= ""

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de Variaveis Private dos Objetos                             ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	SetPrvt("oDlg1","oBtMenu1","oBtMenu2","oBtMenu3","oBtMenu4","oBtMenu5","oBtMenu6","oBtMenu7","oBtMenu8","oBtMenu9")

	MsAguarde( {|| f_CarregaAmbiente() }, "Aguarde!!!", "Aguarde enquanto preparamos seu ambiente...")

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	oDlg1       := MSDialog():New( 000,000,120,1050,"Frente de Restaurante",,,.F.,,,,,,.T.,,,.T. )
	oFont1      := TFont():New( "Arial Unicode MS",0,-12,,.F.,0,,400,.F.,.F.,,,,,, )

	oBtMenu1      := TButton():New( 004,004,"Atendente",oDlg1,{|| U_FLOJA004() },056,040,,,,.T.,,"",,,,.F. )
	oBtMenu1:SetCss( STYLE0003 )

	oBtMenu2      := TButton():New( 004,061,"Mesas",oDlg1,{|| U_FLOJA002() },056,040,,,,.T.,,"",,,,.F. )
	oBtMenu2:SetCss( STYLE0004 )

	oBtMenu3      := TButton():New( 004,118,"Comanda",oDlg1,{|| U_FLOJA003() },056,040,,,,.T.,,"",,,,.F. )
	oBtMenu3:SetCss( STYLE0002 )

	oBtMenu4      := TButton():New( 004,175,"Transferência " + chr(10) + " de Mesa",oDlg1,{|| U_FLOJA005() },056,040,,,,.T.,,"",,,,.F. )
	oBtMenu4:SetCss( STYLE0008 )

	oBtMenu5      := TButton():New( 004,232,"Encerrar" + chr(10) + "Comanda",oDlg1,{|| U_FLOJA006() },056,040,,,,.T.,,"",,,,.F. )
	oBtMenu5:SetCss( STYLE0010 )

	oBtMenu6      := TButton():New( 004,289,"Excluir Item " + chr(10) + "da Comanda",oDlg1,{|| U_FLOJA007() },056,040,,,,.T.,,"",,,,.F. )
	oBtMenu6:SetCss( STYLE0002 )

	oBtMenu7      := TButton():New( 004,346,"",oDlg1,,056,040,,,,.T.,,"",,,,.F. )
	oBtMenu7:SetCss( STYLE0002 )

	oBtMenu8      := TButton():New( 004,403,"",oDlg1,,056,040,,,,.T.,,"",,,,.F. )
	oBtMenu8:SetCss( STYLE0002 )

	oBtMenu9      := TButton():New( 004,460,"Sair",oDlg1,{|| oDlg1:End() },056,040,,,,.T.,,"",,,,.F. )
	oBtMenu9:SetCss( STYLE0007 )

	oTMsgBar 	:= TMsgBar():New(oDlg1, 'Desenvolvido por Totvs Bahia',.F.,.F.,.F.,.F., RGB(0,0,0),,oFont1,.F.)
	oTMsgItem1 	:= TMsgItem():New( oTMsgBar, "", 100,,,,.T., {||} )	//Mensagens de erro
	oTMsgItem2 	:= TMsgItem():New( oTMsgBar, "", 100,,,,.T., {||} )	//Garçom
	oTMsgItem3 	:= TMsgItem():New( oTMsgBar, "", 100,,,,.T., {||} )	//Mesa

	oDlg1:Activate(,,,.F.)


Return()

Static Function f_CarregaAmbiente()

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "FAT" TABLES "SB1", "SBM"

Return()
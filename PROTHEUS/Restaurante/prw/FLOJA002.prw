#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOTVS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "FS_BUTTON_CSS.CH"

User Function FLOJA002()

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de Variaveis Private dos Objetos                             ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	SetPrvt("oFont1","oDlg2","oGrp1","1","2","3","4","5","6","7","8","9")
	SetPrvt("11","12","13","14","15","16","17","18","19","20","21")
	SetPrvt("23","24","25")

	//Inicializa as mensagens da barra de status
	oTMsgBar:SetMsg("")

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

	oFont1     := TFont():New( "Arial Unicode MS",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )

	oDlg2      := MSDialog():New( 092,232,540,830,"Seleção de Mesas",,,.F.,,,,,,.T.,,oFont1,.T. )

	oGrp1      := TGroup():New( 001,003,217,295," Mesas ",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oBtMesa1      := TButton():New( 014,007,"1",oGrp1,{|| f_ReservaMesa( "1" ) },056,040,,oFont1,,.T.,,"",,,,.F. )
	oBtMesa2      := TButton():New( 014,064,"2",oGrp1,{|| f_ReservaMesa( "2" ) },056,040,,oFont1,,.T.,,"",,,,.F. )
	oBtMesa3      := TButton():New( 014,121,"3",oGrp1,{|| f_ReservaMesa( "3" ) },056,040,,oFont1,,.T.,,"",,,,.F. )
	oBtMesa4      := TButton():New( 014,178,"4",oGrp1,{|| f_ReservaMesa( "4" ) },056,040,,oFont1,,.T.,,"",,,,.F. )
	oBtMesa5      := TButton():New( 014,235,"5",oGrp1,{|| f_ReservaMesa( "5" ) },056,040,,oFont1,,.T.,,"",,,,.F. )
	oBtMesa6      := TButton():New( 054,007,"6",oGrp1,{|| f_ReservaMesa( "6" ) },056,040,,oFont1,,.T.,,"",,,,.F. )
	oBtMesa7      := TButton():New( 054,064,"7",oGrp1,{|| f_ReservaMesa( "7" ) },056,040,,oFont1,,.T.,,"",,,,.F. )
	oBtMesa8      := TButton():New( 054,121,"8",oGrp1,{|| f_ReservaMesa( "8" ) },056,040,,oFont1,,.T.,,"",,,,.F. )
	oBtMesa9      := TButton():New( 054,178,"9",oGrp1,{|| f_ReservaMesa( "9" ) },056,040,,oFont1,,.T.,,"",,,,.F. )
	oBtMesa10     := TButton():New( 054,235,"10",oGrp1,{|| f_ReservaMesa( "10" ) },056,040,,oFont1,,.T.,,"",,,,.F. )
	oBtMesa11     := TButton():New( 094,007,"11",oGrp1,{|| f_ReservaMesa( "11" ) },056,040,,oFont1,,.T.,,"",,,,.F. )
	oBtMesa12     := TButton():New( 094,064,"12",oGrp1,{|| f_ReservaMesa( "12" ) },056,040,,oFont1,,.T.,,"",,,,.F. )
	oBtMesa13     := TButton():New( 094,121,"13",oGrp1,{|| f_ReservaMesa( "13" ) },056,040,,oFont1,,.T.,,"",,,,.F. )
	oBtMesa14     := TButton():New( 094,178,"14",oGrp1,{|| f_ReservaMesa( "14" ) },056,040,,oFont1,,.T.,,"",,,,.F. )
	oBtMesa15     := TButton():New( 094,235,"15",oGrp1,{|| f_ReservaMesa( "15" ) },056,040,,oFont1,,.T.,,"",,,,.F. )
	oBtMesa16     := TButton():New( 134,007,"16",oGrp1,{|| f_ReservaMesa( "16" ) },056,040,,oFont1,,.T.,,"",,,,.F. )
	oBtMesa17     := TButton():New( 134,064,"17",oGrp1,{|| f_ReservaMesa( "17" ) },056,040,,oFont1,,.T.,,"",,,,.F. )
	oBtMesa18     := TButton():New( 134,121,"18",oGrp1,{|| f_ReservaMesa( "18" ) },056,040,,oFont1,,.T.,,"",,,,.F. )
	oBtMesa19     := TButton():New( 134,178,"19",oGrp1,{|| f_ReservaMesa( "19" ) },056,040,,oFont1,,.T.,,"",,,,.F. )
	oBtMesa20     := TButton():New( 134,235,"20",oGrp1,{|| f_ReservaMesa( "20" ) },056,040,,oFont1,,.T.,,"",,,,.F. )
	oBtMesa21     := TButton():New( 174,007,"21",oGrp1,{|| f_ReservaMesa( "21" ) },056,040,,oFont1,,.T.,,"",,,,.F. )
	oBtMesa22     := TButton():New( 174,064,"22",oGrp1,{|| f_ReservaMesa( "22" ) },056,040,,oFont1,,.T.,,"",,,,.F. )
	oBtMesa23     := TButton():New( 174,121,"23",oGrp1,{|| f_ReservaMesa( "23" ) },056,040,,oFont1,,.T.,,"",,,,.F. )
	oBtMesa24     := TButton():New( 174,178,"24",oGrp1,{|| f_ReservaMesa( "24" ) },056,040,,oFont1,,.T.,,"",,,,.F. )
	oBtMesa25     := TButton():New( 174,235,"25",oGrp1,{|| f_ReservaMesa( "25" ) },056,040,,oFont1,,.T.,,"",,,,.F. )

	f_VerificaStatus()

	oDlg2:Activate(,,,.T.)

Return

Static Function f_VerificaStatus()

	Local nX	:= 1
	Local j		:= ""

	For nX:=1 To 25

		j := Alltrim( Str( nX ) )

		BeginSQL Alias "MESA"
			SELECT
				Z0_MESA
			FROM
				%TABLE:SZ0% Z0
			WHERE
				Z0.Z0_FILIAL = %XFILIAL:SZ0%
				AND Z0.%NOTDEL%
				AND Z0_MESA = %EXP:j%
				AND Z0_STATUS = %EXP:'1'%
		EndSQL
		dbSelectArea("MESA")

		If MESA->( !EOF() )
			oBtMesa&j:SetCss( STYLE0005 )	//Aberta
		Else
			oBtMesa&j:SetCss( STYLE0006 )	//Livre
		EndIf

		MESA->( dbCloseArea() )

	Next nX

Return()

Static Function f_ReservaMesa( c_Botao )

	oBtMesa&c_Botao:SetCss( STYLE0005 )
	c_Mesa 		:= c_Botao
	oTMsgItem1:SetText( "" )
	oTMsgItem2:SetText( "Mesa " + c_Mesa )
	oDlg2:End()

Return
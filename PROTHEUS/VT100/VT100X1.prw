#INCLUDE "APVT100.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE ENTER CHR(13) + CHR(10)

User Function VT100X1()

	Local a_Tela     	:= {}
	Local nL    		:= 0
	Local nC   		 	:= 0
	Local l_Continua	:= .T.
	Local c_Produto		:= ""
	Local c_Local		:= ""
	Local c_Empresa		:= ""
	Local c_Filial		:= ""

	//VTDBBrowse
	//Local aFields 		:= {"B1_COD","B1_DESC","B1_UM","B1_PICM"}
	//Local aSize 		:= {16,20,10,15}
	//Local aHeader 		:= {'COD','DESCRICAO ','UM',"% ICM"}

	Local c_Texto		:= ""

	Local acab :={"Codigo","Qtd ","Descricao ","UM"}
	Local aSize := {15,4,20,3}
	Local nPos := 12
	Local aItens :={{"1010 ",10, "DESCRICAO1","UN "},;
	{"2010 ",20,"DESCRICAO2","CX "},;
	{"2020 ",30,"DESCRICAO3","CX "},;
	{"2010 ",40,"DESCRICAO4","CX "},;
	{"2020 ",50,"DESCRICAO5","CX "},;
	{"3010 ",60,"DESCRICAO6","CX "},;
	{"3020 ",70,"DESCRICAO7","CX "},;
	{"3030 ",80,"DESCRICAO7","CX "},;
	{"3040 ",90,"DESCRICAO7","CX "},;
	{"2010 ",40,"DESCRICAO4","CX "},;
	{"2020 ",50,"DESCRICAO5","CX "},;
	{"3010 ",60,"DESCRICAO6","CX "},;
	{"3020 ",70,"DESCRICAO7","CX "},;
	{"3030 ",80,"DESCRICAO7","CX "},;
	{"3050 ",100,"DESCRICAO7","CX "}}


	//RpcSetType( 3 )
	//RpcSetEnv( "99", "01" )

	//VtClearBuffer()
	//VTClear()

	a_Tela     	:= VTSave()
	nL    		:= VTRow()
	nC 		 	:= VTCol()
	c_Produto	:= Space( TamSX3("B1_COD")[1] )
	c_Local		:= Space( TamSX3("B2_LOCAL")[1] )

	VTClear Screen
	VtClearBuffer()

	While l_Continua

		VTClear()



		IF VtLastKey() == 27
			VTClear Screen
			VTRestore(,,,,a_Tela)
			Return .F.
		ENDIF

		//Utilizando o VTDBBrowse
		/*sb1->(dbseek(xfilial()+'001'))
		nRecno := VTDBBrowse(0,0,7,15,"SB1",aHeader,aFields,aSize,,"xfilial('SB1')+'001'","xfilial('SB1')+'006'")

		VTClear()
		VtAlert('Top-> ' + Alltrim( Str( nRecno ) ) )

		dbSelectArea("SB2")
		SB2->( dbGoTo( nRecno ) )
		@ 1, 0 VTSAY "Produto: " + SB2->B2_COD
		@ 2, 0 VTSAY "Saldo: " + Transform( SB2->B2_QATU, "@E 999,999.99" )*/


		npos 		:= VTaBrowse( 0,0,7,15,aCab,aItens,aSize,,1 )
		c_Produto	:= aItens[npos][1]

		dbSelectArea("SB2")
		dbSetOrder(1)
		dbSeek( xFilial("SB2") + "001" /*c_Produto*/ )

		c_Texto	:= "Produto " + SB2->B2_COD + ENTER
		c_Texto	+= "Saldo " + Transform( SB2->B2_QATU, "@E 999,999.99" )

		VTClear Screen
		VtAlert('Top-> ' + c_Texto )

		dbSelectArea("SB2")
		SB2->( dbGoTo( npos ) )

		VTClear Screen
		@ 0, 0 VTSAY "FUNCAO: VT100X1"

		@ 1, 0 VTSAY "Produto: "
		@ 2, 0 VTGET c_Produto //F3 "SB1"

		@ 3, 0 VTSAY "Armazem: "
		@ 4, 0 VTGET c_Local
		VTRead

		//VTClear Screen
		//@ 0, 0 VTSAY "Produto: " //+ SB2->B2_COD
		//@ 1, 0 VTSAY "Saldo: " //+ Transform( SB2->B2_QATU, "@E 999,999.99" )
		//VTRead

	EndDo

	VTRestore(,,,,a_Tela)
	@ nL,nC VTSay ""

Return .T.

User Function tstComp()

	Local a_RecSE2	:= {}
	Local a_RecPA	:= { 47883 }
	Local aVetor	:= {}

	aAdd( aVetor, { "E2_PREFIXO"	,"AFX"					,Nil} )
	aAdd( aVetor, { "E2_NUM"		,"20190716O"			,Nil} )
	aAdd( aVetor, { "E2_PARCELA"	,"   "					,Nil} )
	aAdd( aVetor, { "E2_TIPO"		,"NAA"  				,Nil} )
	aAdd( aVetor, { "E2_FORNECE"	,"00000000 "			,Nil} )
	aAdd( aVetor, { "E2_LOJA"		,"0001"					,Nil} )
	aAdd( aVetor, { "E2_NATUREZ"	,"31010101  "			,Nil} )
	aAdd( aVetor, { "E2_EMISSAO"	,CTOD("16/07/2019")		,Nil} )
	aAdd( aVetor, { "E2_VENCTO"		,CTOD("16/07/2019")		,Nil} )
	aAdd( aVetor, { "E2_VENCREA"	,CTOD("16/07/2019")		,Nil} )
	aAdd( aVetor, { "E2_VALOR"		,100					,Nil} )
	aAdd( aVetor, { "E2_HIST"		,"TESTE"				,Nil} )
	aAdd( aVetor, { "E2_XHIST"		,"TESTE"				,Nil} )
	aAdd( aVetor, { "E2_LA"			,"N"					,Nil} )
	aAdd( aVetor, { "E2_RATEIO"		,"N"					,Nil} )
	aAdd( aVetor, { "E2_ZBANCO"		,"001"					,Nil} )
	aAdd( aVetor, { "E2_ZAGENCI" 	,"3429"					,Nil} )
	aAdd( aVetor, { "E2_ZCONTA"		,"2438"					,Nil} )
	aAdd( aVetor, { "E2_XMODELO"	,"01"					,Nil} )

	MsExecAuto({|x,y,z| FINA050(x,y,z)}, aVetor,, 3) 

	a_RecSE2	:= { SE2->( Recno() ) }

	If MaIntBxCP(2,a_RecSE2,,a_RecPA,,{ .T., .F., .F., .F., .F., .F. },,,,,dDataBase )
		Alert("Show")
	Else
		Alert("NoShow")
	EndIf

Return()
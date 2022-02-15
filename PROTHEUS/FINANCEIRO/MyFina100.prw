User Function MyFINA100()

	local l_Erro 			:= .F.
	local c_integradoFluig 	:= ""

	Local c_FilialAux 		:= ""
	PRIVATE lMsErroAuto 	:= .F.

	//Loga na filial solicitada
	RpcSetType( 3 )
	RpcSetEnv( "01","0311" )

	c_FilialAux 		:= cFilAnt

	cFilAnt := Padr( "0311", TamSX3("E5_FILIAL")[1] )

	aVetor := {{"E5_DATA"        ,CTOD("06/10/17")               										,Nil},;
	{"E5_MOEDA"       ,"M1"                    										,Nil},;
	{"E5_VALOR"       ,261.96       									,Nil},;
	{"E5_NATUREZ"     ,Padr( "2030010", TamSX3("E5_NATUREZ")[1] )    ,Nil},;
	{"E5_BANCO"       ,Padr( "F06", TamSX3("E5_BANCO")[1] )       	,Nil},;
	{"E5_AGENCIA"     ,Padr( "01", TamSX3("E5_AGENCIA")[1] )     ,Nil},;
	{"E5_CONTA"       ,Padr( "01", TamSX3("E5_CONTA")[1] )       	,Nil},;
	{"E5_BENEF"       ,Padr( "JILMA SANTOS ESTRELA DE SOUZA", TamSX3("E5_BENEF")[1] )    		,Nil},;
	{"E5_CCD"         ,Padr( "15111102001", TamSX3("E5_CCD")[1] )    			,Nil},;
	{"E5_DOCUMEN"     ,Padr( "10092017", TamSX3("E5_DOCUMEN")[1] )    	,Nil},;f
	{"E5_HISTOR"      ,Padr( "Reembolso de combustível - serviço exter", TamSX3("E5_HISTOR")[1] )     	,Nil}}

	MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aVetor,3)

	If lMsErroAuto

		conout( MostraErro() )

	Endif

	cFilAnt := c_FilialAux

REturn()
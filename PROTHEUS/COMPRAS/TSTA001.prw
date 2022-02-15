User Function TSTA001()

	//U_TSTA001()                                                                                                                                                                                                                                                                                                 

	//Private a_Docto := { PADR( "028888", TAMSX3("CR_NUM")[1] ), "PC",36000.00, "000030", "000141", "000038" }
	Private a_Docto := { PADR( "028888", TAMSX3("CR_NUM")[1] ), "PC",36000.00, "000002", "000147", "000038" }
	//Private a_Docto := { PADR( "028888", TAMSX3("CR_NUM")[1] ), "PC",36000.00, "000024", "000132", "000038" }

	DBSELECTAREA("SCR")
	DBORDERNICKNAME("FSALCADA")
	dbSeek( xFilial("SCR") + "PC" + a_Docto[1] + a_Docto[4] + "02", .T. )
	
	U_FCOMA008( a_Docto, dDataBase, 4 )

Return
User Function FCOMM002()

	dbSelectArea( "SB1" )
	SB1->( dbGoTop() )
	While SB1->(!Eof())
		U_FCOMM001( "Inserir" )
		SB1->( dbSkip() )
	EndDo

Return()
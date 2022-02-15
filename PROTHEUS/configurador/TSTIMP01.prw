User Function TSTIMP01()

	Local a_Config		:= 	{}
	Local a_Linha		:= 	{}
	Local c_Arquivo		:= 	"C:\temp\IMPORT.csv"
	Local c_Linha		:= 	""
	Local o_TxtArray	:= 	clsTxt2Array():New()
	Local nX			:= 	0
	Local nY			:=  0
	Local x_Conteudo

	Private c_Tabela	:=	"SA2" //Colocar na tabela SZH o alias que sera importado
	Private a_Struc		:=	(c_Tabela)->(dbStruct())

	SZH->( dbGoTop() )
	While SZH->( !Eof() )

		//Pega a posicao do campo no SX3
		//Sera utilizado no FielPut para gravar no campo correto
		n_PosTab	:=	SZH->( aScan( a_Struc, {|x| AllTrim( Upper( x[ 1 ] ) ) == Alltrim( ZH_CAMPO ) } ) )

		AADD( a_Config, { SZH->ZH_CAMPO, SZH->ZH_POSICAO, SZH->ZH_TIPO, n_PosTab } )

		SZH->( dbSkip() )

	EndDo

	IF FT_FUSE( c_Arquivo ) <> 1

		Alert("Erro o abrir o arquivo!!!")
		Return()

	ENDIF

	WHILE !FT_FEOF()

		c_Linha 	:= FT_FReadLn()							//Leitura da linha
		a_Linha		:= o_TxtArray:mtdGerArray(c_Linha,";")	//Converte a linha em vetor

		a_TabImport	:=	{}

		For nX:=1 To Len( a_Config )

			aAdd( a_TabImport, { a_Config[nX][1], a_Config[nX][4], a_Config[nX][3], a_Linha[ a_Config[nX][2] ] } )

		Next

		Begin Transaction

			If ( c_Tabela )->( RecLock( c_Tabela, .T. ) )

				//....tratar conteudo lido no arquivo x tipo de campo indicado na SZH
				For nY := 1 to len( a_TabImport )

					If a_TabImport[nY][3] == "D"

						x_Conteudo	:= CTOD( a_TabImport[nY][4] )

					ElseIf a_TabImport[nY][3] == "N"

						x_Conteudo	:= Val( Replace( a_TabImport[nY][4], ",","." ) )

					Else
						x_Conteudo	:= a_TabImport[nY][4]
					EndIf

					( c_Tabela )->( FieldPut( a_TabImport[nY][2], x_Conteudo ) )
				Next

				( c_Tabela )->( MsUnlock() )

			Endif

		End Transaction

		FT_FSKIP()

	ENDDO
	
	FT_FUse()				//Fecha arquivo

Return
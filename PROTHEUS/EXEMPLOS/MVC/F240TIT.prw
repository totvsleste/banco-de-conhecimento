#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function F240TIT()

	Local a_SA2Area	:= SA2->(GetArea())
	Local a_SE2Area	:= SE2->(GetArea())

	U_FFINA001()

	RestArea( a_SA2Area )
	RestArea( a_SE2Area )

Return( .T. )
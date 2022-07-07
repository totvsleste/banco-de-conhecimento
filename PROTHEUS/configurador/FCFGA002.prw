#INCLUDE "TOPCONN.ch"
#INCLUDE "TOTVS.ch"
#INCLUDE "PROTHEUS.ch"

function FCFGA002()

	if (TCSqlExec("UPDATE " + RETSQLNAME("SA1") + " SET A1_NOME = UPPER(A1_NOME) ") < 0)
		Alert("TCSQLError() " + TCSQLError())
	endif

    if (TCSqlExec("UPDATE " + RETSQLNAME("SA1") + " SET A1_NREDUZ = UPPER(A1_NREDUZ) ") < 0)
		Alert("TCSQLError() " + TCSQLError())
	endif

    if (TCSqlExec("UPDATE " + RETSQLNAME("SA1") + " SET A1_END = UPPER(A1_END) ") < 0)
		Alert("TCSQLError() " + TCSQLError())
	endif

    if (TCSqlExec("UPDATE " + RETSQLNAME("SA1") + " SET A1_MUN = UPPER(A1_MUN) ") < 0)
		Alert("TCSQLError() " + TCSQLError())
	endif

    if (TCSqlExec("UPDATE " + RETSQLNAME("SA1") + " SET A1_ENDENT = UPPER(A1_ENDENT) ") < 0)
		Alert("TCSQLError() " + TCSQLError())
	endif

    if (TCSqlExec("UPDATE " + RETSQLNAME("SA1") + " SET A1_COMPENT = UPPER(A1_COMPENT) ") < 0)
		Alert("TCSQLError() " + TCSQLError())
	endif

    if (TCSqlExec("UPDATE " + RETSQLNAME("SA1") + " SET A1_COMPLEN = UPPER(A1_COMPLEN) ") < 0)
		Alert("TCSQLError() " + TCSQLError())
	endif

    if (TCSqlExec("UPDATE " + RETSQLNAME("SA1") + " SET A1_FSESPEC = UPPER(A1_FSESPEC) ") < 0)
		Alert("TCSQLError() " + TCSQLError())
	endif

    if (TCSqlExec("UPDATE " + RETSQLNAME("SA1") + " SET A1_BAIRENT = UPPER(A1_BAIRENT) ") < 0)
		Alert("TCSQLError() " + TCSQLError())
	endif

    if (TCSqlExec("UPDATE " + RETSQLNAME("SA1") + " SET A1_CIDAENT = UPPER(A1_CIDAENT) ") < 0)
		Alert("TCSQLError() " + TCSQLError())
	endif

    Alert("Fim!!!")

return()

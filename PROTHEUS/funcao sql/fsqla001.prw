#INCLUDE "TOTVS.ch"
#INCLUDE 'TOPCONN.CH'

Function u_FSQLA001()

   	Local c_Upd := ""

    c_Upd := "UPDATE " 
    c_Upd += RetSqlName( "SA1" )
	c_Upd += " SET "
    c_Upd += " A1_NOME = dbo.APAGACARACTERESESPECIAIS(A1_NOME), "
    c_Upd += " A1_NREDUZ = dbo.APAGACARACTERESESPECIAIS(A1_NREDUZ) "
	c_Upd += " WHERE D_E_L_E_T_ = '' "

	TcSqlExec( c_Upd ) 

    msginfo("pronto!")

Return()

//Bibliotecas
#INCLUDE "TOTVS.CH"
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "RWMAKE.CH"
#include "protheus.ch"
#INCLUDE "Report.CH"
#INCLUDE 'TOPCONN.CH'
#include "vkey.ch"
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include 'parmtype.ch'

#DEFINE ENTER CHR(13)+CHR(10)


/*/{Protheus.doc} MSDOCOK
Trata informações complementares - banco de Conhecimento

@type function
@version 
@author Eduardo
@since 21/08/2020
@return return_type, return_description
/*/
User function MSDOCOK()

	Local a_Area	:=	GetArea()
	Local a_AreaOrig:=	{}
	Local l_ParamOk	:=	(Type("PARAMIXB") == "A")
	Local n_Param	:=	Iif(l_ParamOk, len(PARAMIXB), 0)
	Local c_AliasOri:=	Iif(l_ParamOk .And. n_Param >=2,PARAMIXB[1],""	)
	Local n_RegOrig	:=	Iif(l_ParamOk .And. n_Param >=2,PARAMIXB[2],0	)
	Local a_Chave	:=	{}

	If c_AliasOri == "SF1"

		a_AreaOrig	:=	(c_AliasOri)->(GetArea())

		/*If FindFunction("U_FCOMA102")
			(c_AliasOri)->(dbGoTo(n_RegOrig))
			aAdd(a_Chave,   SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA )
			aAdd(a_Chave,   "SF1"                   )
			aAdd(a_Chave,   xFilial(a_Chave[2])     )
			aAdd(a_Chave,   "SE2"                   )
			U_FCOMA102(a_Chave)
		Endif*/

		if FindFunction("U_FCOMA103")

			U_FCOMA103()

		endif

		RestArea(a_AreaOrig)

	Endif
	RestArea(a_Area)

Return

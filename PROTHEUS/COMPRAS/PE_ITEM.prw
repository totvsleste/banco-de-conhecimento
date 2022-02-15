#include 'protheus.ch'
#include 'parmtype.ch'
#include 'fwmvcdef.ch'

/*/
{Protheus.doc} u_ITEM
Ponto de entrada em MVC no cadastro do produto
@type  Function
@author francisco.ssa
@since 18/02/2020
@version 12.1.25
@see (links_or_references)
/*/

Function u_ITEM()

	Local aParam 			:= PARAMIXB
	Local xRet 				:= .T.
	Local oObj 				:= ""
	Local cIdPonto 			:= ""
	Local cIdModel 			:= ""
	Local lIsGrid 			:= .F.
	Local o_Model  			:= FwModelActive()
	Local o_Produto			:= 0
	Local n_Opca			:= 0
	Local a_Vetor			:= {}
	Local n_Oper			:= 3
	Local a_Filiais			:= {}
	Local nX				:= 0
	Local aLogErr 			:= {}
	Local aLogErr2			:= {}
	Local _cMotivo			:= ""
	Local i					:= 0

	Local c_FilBkp			:= cFilAnt

	Private lMsErroAuto		:= .F.

	If aParam <> NIL

		oObj 		:= aParam[ 1 ]
		cIdPonto 	:= aParam[ 2 ]
		cIdModel 	:= aParam[ 3 ]
		lIsGrid 	:= ( Len( aParam ) > 3 )

		If cIdPonto == "MODELCOMMITNTTS"

			o_Produto 	:= o_Model:GetModel("SB1MASTER")
			n_Opca		:= o_Produto:GetOperation()

			IF n_Opca == MODEL_OPERATION_INSERT .OR. n_Opca == MODEL_OPERATION_UPDATE

				If n_Opca == MODEL_OPERATION_INSERT

					n_Oper	:= 3

					a_Vetor	:={	{"B1_COD"	,SB1->B1_COD	,Nil},;
						{"B1_DESC"		,SB1->B1_DESC	,Nil},;
						{"B1_TIPO"		,SB1->B1_TIPO	,Nil},;
						{"B1_UM"		,SB1->B1_UM		,Nil},;
						{"B1_GRUPO"		,SB1->B1_GRUPO	,Nil},;
						{"B1_POSIPI"	,SB1->B1_POSIPI	,Nil},;
						{"B1_ORIGEM"	,SB1->B1_ORIGEM	,Nil},;
						{"B1_CONTA"		,SB1->B1_CONTA	,Nil},;
						{"B1_LOCPAD"	,SB1->B1_LOCPAD	,Nil}}

				ELSE

					n_Oper	:= 4

					a_Vetor	:={	{"B1_COD"	,SB1->B1_COD	,Nil},;
						{"B1_DESC"		,SB1->B1_DESC	,Nil},;
						{"B1_POSIPI"	,SB1->B1_POSIPI	,Nil},;
						{"B1_CONTA"		,SB1->B1_CONTA	,Nil}}

				ENDIF

				OpenSM0("01",.T.)

				//Executa para todas as empresas

				dbSelectArea( "SM0" )
				SM0->( dbGoTop() )
				While SM0->( !EOF() )

					//Nao executa para filial logada
					If Alltrim( c_FilBkp ) == Alltrim( SM0->M0_CODFIL )
						SM0->( dbSkip() )
						Loop
					EndIf

					aAdd( a_Filiais, SM0->M0_CODFIL )

					SM0->( dbSkip() )

				EndDo

				For nX := 1 To Len( a_Filiais ) Step 1

					cFilAnt	:= a_Filiais[ nX ]

					Begin Transaction

						MSExecAuto({|x,y| Mata010(x,y)},a_Vetor,n_Oper) //3- Inclusao, 4- Alteracao, 5- Exclusao
						If lMsErroAuto

							DisarmTransaction()
							//MostraErro()
							// Tratamento da Mensagem de erro do MSExecAuto
							aLogErr  := GetAutoGRLog()
							aLogErr2 := f_TrataErro(aLogErr)
							_cMotivo := ""

							For i := 1 to Len(aLogErr2)
								_cMotivo += aLogErr2[i]
							Next

							_cMotivo:=  NoAcentoESB(_cMotivo)
							Alert( _cMotivo )

							//break

						EndIf

					End Transaction

				Next nX

			EndIf

		EndIf

	EndIf

	cFilAnt		:= c_FIlBkp

Return( xRet )

Static Function f_TrataErro(aErr)
	Local lHelp   := .F.
	Local lAjuda  := .F.
	Local lTabela := .F.
	Local cLinha  := ""
	Local aRet    := {}
	Local nI      := 0
	Local l_Importante	:= .F.

	For nI := 1 to LEN( aErr)
		cLinha  := UPPER( aErr[nI] )
		cLinha  := STRTRAN( cLinha,CHR(13), " " )
		cLinha  := STRTRAN( cLinha,CHR(10), " " )

		If SUBS( cLinha, 1, 10 ) == 'IMPORTANTE' .or. SUBS( cLinha, 1, 10 ) == 'Importante'
			l_Importante := .T.
		EndIf

		If SUBS( cLinha, 1, 4 ) == 'HELP' .or. SUBS( cLinha, 1, 4 ) == 'Help'
			lHelp := .T.
		EndIf

		If SUBS( cLinha, 1, 5 ) == 'AJUDA' .or. SUBS( cLinha, 1, 5 ) == 'Ajuda'
			lAjuda := .T.
		EndIf

		If SUBS( cLinha, 1, 6 ) == 'TABELA' .or. SUBS( cLinha, 1, 6 ) == 'Tabela'
			lHelp   := .F.
			lTabela := .T.
		EndIf

		If Upper(SUBS(cLinha,1,8)) == 'ERRO -->'
			lHelp := .T.
			cLinha := StrTran(cLinha,'--------------------------------------------------------------------------------','')
		EndIf

		If  lHelp .or. ( lTabela .AND. '< -- INVALIDO' $  cLinha ) .Or. lAjuda
			aAdd( aRet,  StrTran(cLinha,'< -- INVALIDO','( INVALIDO )') )
		ElseIf lTabela
			aAdd( aRet, cLinha )
		ElseIf l_Importante
			aAdd( aRet, cLinha )
		EndIf
		lHelp := .F.
	Next

Return aRet

Static Function NoAcentoESB(cMens)
	
	Local _s1   := "?????" + "?????" + "?????" + "?????" + "?????" + "?????" + "?????" + "?????"  + "????" + "??"
	Local _s2   := "aeiou" + "AEIOU" + "aeiou" + "AEIOU" + "aeiou" + "AEIOU" + "aeiou" + "AEIOU"  + "aoAO" + "cC"
	Local _nPos := 0
	Local _ni	:= 0
	
	For _ni := 1 To Len(_s1)
		IF (_nPos := At(Subs(_s1,_ni,1),cMens)) > 0
			cMens := StrTran(cMens,Subs(_s1,_ni,1),Subs(_s2,_ni,1))
		ENDIF
	Next

	cMens := StrTran( cMens, '?', ' ')		//-- Remove o Caracter 1.'o'
	cMens := StrTran( cMens, '?', ' ')		//-- Remove o Caracter 1.'a'
	cMens := StrTran( cMens, '&', ' ')		//-- Remove o Caracter &
	cMens := StrTran( cMens, '?', ' ')		//-- Remove o Caracter ?

	cMens := NoAcento(cMens)
Return(AllTrim(cMens))

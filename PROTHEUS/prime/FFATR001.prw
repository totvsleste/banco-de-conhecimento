#include "protheus.ch"
#include "rwmake.ch"        
#include "topconn.ch" 

Static bSx3Tam   := {|cCpo| GetSx3Cache(cCpo,"X3_TAMANHO") }

function u_FFATR001()

    Local oReport

	oReport := ReportDef()
	oReport:PrintDialog()

return

Static Function ReportDef()

	Local oReport
	Local cReport := "F240BTN"
	Local cTitulo := "Relacao de Bordero"
	Local cDescri := "Este programa tem como objetivo imprimir os borderos conforme selecao"
	Local bReport := { |oReport|	ReportPrint( oReport ) }

	oReport  := TReport():New( cReport, cTitulo, "" , bReport, cDescri )
	oReport:DisableOrientation()
	oReport:SetLandScape(.T.)
	oReport:oPage:SetPaperSize(9) // FOLHA A4

	oSec01 := TRSection():New(oReport,"BORDERO",{})
	TRCell():New(oSec01,"E2__FILIAL" ,"",DecodeUtf8("Filial"),"@!"               ,eVal( bSx3Tam, "E2_FILIAL"))
	TRCell():New(oSec01,"E2__PREFIXO"   ,"",DecodeUtf8("Prefixo"          ),"@!"               ,eVal( bSx3Tam, "E2_PREFIXO"))
	TRCell():New(oSec01,"E2__NUM"       ,"",DecodeUtf8("Numero"              ),"@!"               ,eVal( bSx3Tam, "E2_NUM")+5)
	TRCell():New(oSec01,"E2__PARCELA" ,"",DecodeUtf8("Parcela"        ),"@!"               ,eVal( bSx3Tam, "E2_PARCELA")+5)
	TRCell():New(oSec01,"E2__TIPO" ,"",DecodeUtf8("Tipo"    ),"@!",eVal( bSx3Tam, "E2_TIPO" ))
    TRCell():New(oSec01,"E2__FORNECE" ,"",DecodeUtf8("Fornecedor"    ),"@!",eVal( bSx3Tam, "E2_FORNECE" ))
    TRCell():New(oSec01,"E2__LOJA" ,"",DecodeUtf8("Loja"    ),"@!",eVal( bSx3Tam, "E2_LOJA" ))
    TRCell():New(oSec01,"E2__NOMFOR" ,"",DecodeUtf8("Nome Fornec."    ),"@!",eVal( bSx3Tam, "E2_NOMFOR" ))
	TRCell():New(oSec01,"E2__NATUREZ" ,"",DecodeUtf8("Natureza" ),"@!",eVal( bSx3Tam, "E2_NATUREZ" ))
    TRCell():New(oSec01,"E2__VALOR"  ,"",DecodeUtf8("Valor"         ),"@E 999,999,999.99",eVal( bSx3Tam, "E2_VALOR" ))
	TRCell():New(oSec01,"E2__SALDO"  ,"",DecodeUtf8("Saldo"       ),"@E 999,999,999.99",eVal( bSx3Tam, "E2_SALDO" ))
    TRCell():New(oSec01,"E2__SDDECRE"  ,"",DecodeUtf8("Sld Decrescimo"         ),"@E 999,999,999.99",eVal( bSx3Tam, "E2_SDDECRE" ))
    TRCell():New(oSec01,"E2__SDACRES"  ,"",DecodeUtf8("Sld Acrescimo"         ),"@E 999,999,999.99",eVal( bSx3Tam, "E2_SDACRES" ))
    TRCell():New(oSec01,"E2__SLDFIN"  ,"",DecodeUtf8("Saldo Final"       ),"@E 999,999,999.99",eVal( bSx3Tam, "E2_SALDO" ))    
    TRCell():New(oSec01,"E2__XBANCO" ,"",DecodeUtf8("Bco. Fornec." ),"@!",eVal( bSx3Tam, "E2_XBANCO" ))
    TRCell():New(oSec01,"E2__XAGENCI" ,"",DecodeUtf8("Ag. Fornec." ),"@!",eVal( bSx3Tam, "E2_XAGENCI" ))
    TRCell():New(oSec01,"E2__XCONTA" ,"",DecodeUtf8("Cta. Fornec." ),"@!",eVal( bSx3Tam, "E2_XCONTA" ))
    TRCell():New(oSec01,"E2__ZBANCO" ,"",DecodeUtf8("Banco Pagam." ),"@!",eVal( bSx3Tam, "E2_ZBANCO" ))
    TRCell():New(oSec01,"E2__ZAGENCI" ,"",DecodeUtf8("Ag. Pagam." ),"@!",eVal( bSx3Tam, "E2_ZAGENCI" ))
    TRCell():New(oSec01,"E2__ZCONTA" ,"",DecodeUtf8("Cta. Pagam." ),"@!",eVal( bSx3Tam, "E2_ZCONTA" ))
    TRCell():New(oSec01,"E2__XMODELO" ,"",DecodeUtf8("Modalidade" ),"@!",eVal( bSx3Tam, "E2_XMODELO" ))
    TRCell():New(oSec01,"E2__EMISSAO" ,"",DecodeUtf8("Emissao" ),"@D",eVal( bSx3Tam, "E2_EMISSAO" ))
	TRCell():New(oSec01,"E2__VENCTO" ,"",DecodeUtf8("Vencimento"),"@D",eVal( bSx3Tam, "E2_VENCTO" ))
    TRCell():New(oSec01,"E2__VENCREA" ,"",DecodeUtf8("Vcto Real"),"@D",eVal( bSx3Tam, "E2_VENCREA" ))
    TRCell():New(oSec01,"E2__CODBAR" ,"",DecodeUtf8("Cod. Barras" ),"@!",eVal( bSx3Tam, "E2_CODBAR" ))
	
	oSec01:SetColSpace(3)

    //TRFunction():New(/*Cell*/                 ,/*cId*/,/*Function*/,/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,/*lEndSection*/,/*lEndReport*/,/*lEndPage*/,/*Section*/)
    TRFunction():New(oSec01:Cell("E2__VALOR"),/*cId*/,"SUM"       ,/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.           ,.T.           ,.F.        ,oSec01)
    TRFunction():New(oSec01:Cell("E2__SALDO"),/*cId*/,"SUM"       ,/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.           ,.T.           ,.F.        ,oSec01)
    TRFunction():New(oSec01:Cell("E2__SLDFIN"),/*cId*/,"SUM"       ,/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F.           ,.T.           ,.F.        ,oSec01)

Return oReport

Static Function ReportPrint( oReport )

    Local oSec01    := oReport:Section(1)
    Local n_SldFin  := 0

    ( cAliasSE2 )->( dbGoTop() )
    While ( cAliasSE2 )->(!EOF() )

        If oReport:Cancel()
            Exit
        EndIf

        n_SldFin := ( cAliasSE2 )->E2_SALDO + ( ( cAliasSE2 )->E2_SDACRES - ( cAliasSE2 )->E2_SDDECRE )

        //Apresenta somente os titulos que tiverem acrescimo ou decrescimo
        if n_SldFin == ( cAliasSE2 )->E2_SALDO
            ( cAliasSE2  )->( dbSkip() )
            Loop
        endif

        oSec01:Init()
        oSec01:Cell("E2__FILIAL"):SetBlock( { || ( cAliasSE2 )->E2_FILIAL } )
        oSec01:Cell("E2__PREFIXO"):SetBlock( { || ( cAliasSE2 )->E2_PREFIXO } )
        oSec01:Cell("E2__NUM"):SetBlock( { || ( cAliasSE2 )->E2_NUM } )
        oSec01:Cell("E2__PARCELA"):SetBlock( { || ( cAliasSE2 )->E2_PARCELA } )
        oSec01:Cell("E2__TIPO"):SetBlock( { || ( cAliasSE2 )->E2_TIPO } )
        oSec01:Cell("E2__FORNECE"):SetBlock( { || ( cAliasSE2 )->E2_FORNECE } )
        oSec01:Cell("E2__LOJA"):SetBlock( { || ( cAliasSE2 )->E2_LOJA } )
        oSec01:Cell("E2__NOMFOR"):SetBlock( { || ( cAliasSE2 )->E2_NOMFOR } )
        
        oSec01:Cell("E2__NATUREZ"):SetBlock( { || ( cAliasSE2 )->E2_NATUREZ } )
        
        oSec01:Cell("E2__VALOR" ):SetBlock( { || ( cAliasSE2 )->E2_VALOR  } )
        oSec01:Cell("E2__SALDO" ):SetBlock( { || ( cAliasSE2 )->E2_SALDO } )
        oSec01:Cell("E2__SLDFIN" ):SetBlock( { || n_SldFin } )

        oSec01:Cell("E2__XBANCO" ):SetBlock( { || ( cAliasSE2 )->E2_XBANCO } )
        oSec01:Cell("E2__XAGENCI" ):SetBlock( { || ( cAliasSE2 )->E2_XAGENCI } )
        oSec01:Cell("E2__XCONTA" ):SetBlock( { || ( cAliasSE2 )->E2_XCONTA } )
        oSec01:Cell("E2__ZBANCO" ):SetBlock( { || ( cAliasSE2 )->E2_ZBANCO } )
        oSec01:Cell("E2__ZAGENCI" ):SetBlock( { || ( cAliasSE2 )->E2_ZAGENCI } )
        oSec01:Cell("E2__ZCONTA" ):SetBlock( { || ( cAliasSE2 )->E2_ZCONTA } )

        oSec01:Cell("E2__EMISSAO"):SetBlock( { || ( cAliasSE2 )->E2_EMISSAO } )
        oSec01:Cell("E2__VENCTO"):SetBlock( { || ( cAliasSE2 )->E2_VENCTO } )
        oSec01:Cell("E2__VENCREA"):SetBlock( { || ( cAliasSE2 )->E2_VENCREA } )

        oSec01:Cell("E2__CODBAR"):SetBlock( { || ( cAliasSE2 )->E2_CODBAR } )

        oSec01:Cell("E2__SDACRES"):SetBlock( { || ( cAliasSE2 )->E2_SDACRES } )
        oSec01:Cell("E2__SDDECRE"):SetBlock( { || ( cAliasSE2 )->E2_SDDECRE } )

        oSec01:Printline()

        ( cAliasSE2  )->( dbSkip() )
    Enddo

    oSec01:Finish()
    oReport:SetTotalInLine(.F.)
    ( cAliasSE2 )->( dbGoTop() )

return

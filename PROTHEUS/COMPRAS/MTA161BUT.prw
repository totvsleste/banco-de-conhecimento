#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} MTA161BUT
    (long_description)
    @type  Function
    @author user
    @since 21/09/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Function nomeFunction()

    Local a_Rotina  := ParamIxb

    ADD OPTION a_Rotina Title "Mapa Petroreconcavo"		Action 'U_PCOMR006'		OPERATION 4 ACCESS 0  	//"Mapa de Cotação//'Mapa de Cotação'

Return( a_Rotina )

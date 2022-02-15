/*/{Protheus.doc} User Function CNTA300
	PE padrão MVC da rotina de contratos (CNTA300).
	@type User Function
	@author TBA007 - PABLO
	@since 27/04/2021
	@version 1
/*/
User Function MATA094()
			
	Private a_Param		:= PARAMIXB
	Private x_Ret		:= .T.
	Private o_Obj		:= Nil
	Private n_Oper		:= 0
	Private c_IdPonto	:= ""
	Private c_opt		:= ""

	if a_Param <> Nil
		o_Obj       := a_Param[1]
		c_IdPonto   := a_Param[2]

		do case                     
		    case c_IdPonto == "MODELCOMMITTTS"
				n_Oper := o_Obj:nOperation
				if empty(c_opt) .and. n_Oper == 3
					f_Users()
				endif
		endcase
	endif

Return(x_Ret)

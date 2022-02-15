function u_MT103EXC()

    Local l_Ret := .T.

    FwMsgRun(,{|oSay| l_Ret := u_FCOMA02C( SF1->F1_FSNUMPV ) },;
		"Exclusao do Pedido de Venda de Consignção",;
		"Aguarde....Excluindo Pedido.... " + SF1->F1_FSNUMPV )

return( l_Ret )

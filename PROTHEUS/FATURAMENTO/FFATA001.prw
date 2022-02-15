/*/{Protheus.doc} u_FFATA001
    (long_description)
    @type  Function
    @author francisco.ssa
    @since 09/09/2020
    @version 12.1.25
    @example
    (examples)
    @see (links_or_references)
    /*/
Function u_FFATA01A()

    If MsgYesNo( "Confirma a criação dos provisórios conforme condição de pagamento informada no item do pedido de venda?" , "Atenção!" )

        LjMsgRun( "Aguarde... Gerando provisórios...", "Geração de provisórios", { || f_GravaProvisorios() } )

    EndIf

Return()

/*/{Protheus.doc} u_FFATA01A()
    (long_description)
    @type  Function
    @author francisco.ssa
    @since 09/09/2020
    @version 12.1.25
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function f_GravaProvisorios()

    Local c_Numero      := SC5->C5_NUM
    Local d_Emissao     := SC5->C5_EMISSAO
    Local nX            := 0
    Local c_Condicao    := SC6->C6_FSCPGTO
    Local c_Produto     := SC6->C6_PRODUTO
    Local c_UM          := SC6->C6_UM
    Local n_QtdVen      := SC6->C6_QTDVEN
    Local n_PrcVen      := SC6->C6_PRCVEN
    Local n_Valor       := SC6->C6_VALOR
    Local d_Entrega     := SC6->C6_ENTREG
    Local c_TES         := SC6->C6_TES
    Local c_Local       := SC6->C6_LOCAL
    Local c_CF          := SC6->C6_CF
    Local c_Cli         := SC6->C6_CLI
    Local c_Loja        := SC6->C6_LOJA
    Local c_Descri      := SC6->C6_DESCRI
    Local a_Parcelas    := Condicao(n_Valor,c_Condicao,,d_Entrega)

    Local c_Natureza    := SuperGetMV("FS_NATPROV",,"11005     ")
    Local a_Titulos := {}

    Private lMsErroAuto := .F.

    if empty(c_Condicao)
        return()
    endif

    dbSelectArea("SC6")
    dbSetOrder(1)
    dbSeek( xFilial("SC6") + c_Numero )
    While SC6->(!EOF()) .And. SC6->(C6_FILIAL + C6_NUM ) == xFilial("SC6") + c_Numero

        RecLock("SC6",.F.)
        dbDelete()
        MsUnlock()

        SC6->( dbSkip() )

    EndDo

    For nX:=1 To Len(a_Parcelas)

        BEGIN TRANSACTION

            dbSelectArea("SC6")
            RecLock("SC6",.T.)
            SC6->C6_FILIAL  := XFILIAL("SC6")
            SC6->C6_NUM     := c_Numero
            SC6->C6_ITEM    := StrZero(nX,2)
            SC6->C6_PRODUTO	:= c_Produto
            SC6->C6_UM     	:= c_UM
            SC6->C6_QTDVEN 	:= n_QtdVen
            SC6->C6_PRCVEN 	:= n_PrcVen
            SC6->C6_VALOR  	:= n_Valor
            SC6->C6_ENTREG 	:= a_Parcelas[nX,1]
            SC6->C6_TES    	:= c_TES
            SC6->C6_LOCAL  	:= c_Local
            SC6->C6_CF     	:= c_CF
            SC6->C6_CLI    	:= c_Cli
            SC6->C6_LOJA   	:= c_Loja
            SC6->C6_DESCRI 	:= c_Descri
            MsUnlock()


            a_Titulos := {  {'E1_FILIAL'	    ,XFILIAL("SE1")			   		,Nil},;
                {'E1_PREFIXO'		,"PV "		   					,Nil},;
                {'E1_NUM'			,c_Numero		    			,Nil},;
                {'E1_PARCELA'		,StrZero(nX,2)			     	,Nil},;
                {'E1_TIPO'			,"PR "		     				,Nil},;
                {"E1_NATUREZ"		,c_Natureza						,Nil},;
                {"E1_CLIENTE"		,c_Cli							,Nil},;
                {"E1_LOJA"	 		,c_Loja							,Nil},;
                {"E1_EMISSAO"		,d_Emissao						,Nil},;
                {"E1_VENCTO" 		,a_Parcelas[nX,1]		       	,Nil},;
                {"E1_VENCREA"		,a_Parcelas[nX,1]		       	,Nil},;
                {"E1_VALOR"  		,n_Valor					    ,Nil},;
                {"E1_ORIGEM"  		,"FINA040"						,Nil},;
                {"E1_HIST"	 		,"PROV. MED. PED. VENDA"		,Nil}}

            MSExecAuto({|x,y,z|Fina040(x,y,z)},a_Titulos,3)

            If lMsErroAuto
                MostraErro()
            EndIf

        END TRANSACTION

    Next

Return()

Function u_FFATA01B()

    LjMsgRun( "Aguarde... Excluindo provisórios...", "Geração de provisórios", { || f_ExcluiProvisorios() } )

Return()

Static Function f_ExcluiProvisorios()

    Local nX := 0

    for nX:=1 To Len(a_Dados)

        dbSelectArea("SE1")
        dbSetOrder(1)
        if dbSeek( xFilial("SE1") + "PV " + Padr(a_Dados[nX][1],TamSx3("E1_NUM")[1]) + Padr(a_Dados[nX][2],TamSx3("E1_PARCELA")[1]) + "PR " )

            RecLock("SE1",.F.)
            dbDelete()
            MsUnlock()

        endif
    next

Return()

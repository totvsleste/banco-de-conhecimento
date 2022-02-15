#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} u_FCOMA02A
Verifica se a nota fiscal de beneficiamento tem poder de terceiro = 'D'
e TES de venda de consignacao.
Chamado: PE GQREENTR
@type function
@author Francisco Mendonca
@since 22/07/21
@version 12.1.25
@return nil, nil
/*/
function u_FCOMA02A()

	Local c_Alias       := GetNextAlias()

    Local c_NumDoc      := SF1->F1_DOC
	Local c_Serie       := SF1->F1_SERIE
	Local c_Cliente     := SF1->F1_FORNECE
	Local c_Loja        := SF1->F1_LOJA
    Local l_Continua    := .F.

	Public a_Dados       := {}
	
	BEGINSQL Alias c_Alias
        SELECT 
            F4_FSVC,
            D1_COD,
            D1_UM,
            D1_QUANT,
            D1_VUNIT,
            D1_TOTAL,
            D1_LOTECTL,
            D1_LOCAL
        FROM 
            %TABLE:SD1% D1
        INNER JOIN
            %TABLE:SF4% F4
        ON
            F4.%NOTDEL%
            AND D1.D1_TES = F4.F4_CODIGO
            AND F4.F4_FSVC <> %EXP:''%
            AND F4.F4_PODER3 = %EXP:'D'%

        WHERE 
            D1.%NOTDEL%
            AND D1.D1_FORNECE = %EXP:c_Cliente%
            AND D1.D1_LOJA = %EXP:c_Loja%
            AND D1.D1_DOC = %EXP:c_NumDoc%
            AND D1.D1_SERIE = %EXP:c_Serie%
	ENDSQL

	if ( c_Alias )->( EOF() )
		Return()
	endif

	While ( c_Alias )->( !EOF() )

		l_Continua    := .T.

        Aadd( a_Dados,  {   c_Cliente,;
                            c_Loja,;
                            c_NumDoc,;
                            c_Serie,;
                            ( c_Alias )->F4_FSVC,;
                            ( c_Alias )->D1_COD,;
                            ( c_Alias )->D1_UM,;
                            ( c_Alias )->D1_QUANT,;
                            ( c_Alias )->D1_VUNIT,;
                            ( c_Alias )->D1_TOTAL,;
                            ( c_Alias )->D1_LOTECTL,;
                            ( c_Alias )->D1_LOCAL;
                        } )

		( c_Alias )->( dbSkip() )

	enddo
	( c_Alias )->( dbCloseArea() )

	if l_Continua
        if Aviso(SM0->M0_NOMECOM,"Trata-se de uma nota fiscal de devolução de poder de terceiros. Deseja gerar a venda por consignação?",{"Sim","Não"},2,"Atenção") == 1
            A410Inclui( "SC5", 0, 3 )
        endif
    endif

Return()

/*/{Protheus.doc} u_FCOMA02B
Carrega os dados da nota fiscal para o pedido de venda
Chamado: PE M410INIC
@type function
@author Francisco Mendonca
@since 22/07/21
@version 12.1.25
@return nil, nil
/*/
function u_FCOMA02B()

    Local n_NewTam  := Len(aCols) - 1
    Local n_TamHead := Len(aHeader)
    Local nY        := 0
    Local nX        := 1
    
    M->C5_TIPO      := "N"
    M->C5_CLIENTE   := a_Dados[1][1]
    M->C5_LOJACLI   := a_Dados[1][2]
    M->C5_CLIENT    := a_Dados[1][1]
    M->C5_LOJAENT   := a_Dados[1][2]
    M->C5_TIPOCLI   := Posicione("SA1",1,xFilial("SA1") + M->C5_CLIENTE + M->C5_LOJACLI, "A1_TIPO" )
    M->C5_EMISSAO   := dDataBase
    M->C5_MOEDA     := 1
    M->C5_CONDPAG   := "001"

    /****utilizando na Enchoice ******/
    If ExistTrigger( 'C5_CLIENTE' )      
        RunTrigger(1,nil,nil,,'C5_CLIENTE')
    Endif

    aSize( aDel( aCols, Len(aCols) ), n_NewTam )
    aCols := Array( Len( a_Dados ), n_TamHead + 1 )

    for nX:=1 to Len( a_Dados ) step 1

        for nY:=1 To n_TamHead
            if Alltrim( aHeader[nY][2] ) = "C6_ALI_WT"
		        aCols[nX][nY] := "   "
            elseif Alltrim( aHeader[nY][2] ) = "C6_REC_WT"
                aCols[nX][nY] := 0
            else
                aCols[nX][nY] := CriaVar(aHeader[nY][2])
            endif 
	    next nY

        aCols[ nX ][ aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEM"}) ]    := StrZero( nX, TamSX3("C6_ITEM")[1] )
        aCols[ nX ][ aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"}) ]     := a_Dados[nX][5]
        aCols[ nX ][ aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"}) ] := a_Dados[nX][6]
        aCols[ nX ][ aScan(aHeader,{|x| AllTrim(x[2])=="C6_UM"}) ]      := a_Dados[nX][7]
        aCols[ nX ][ aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"}) ]  := a_Dados[nX][8]
        aCols[ nX ][ aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDLIB"}) ]  := a_Dados[nX][8]
        aCols[ nX ][ aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"}) ]  := a_Dados[nX][9]
        aCols[ nX ][ aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"}) ]   := a_Dados[nX][10]
        aCols[ nX ][ aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOTECTL"}) ] := a_Dados[nX][11]
        aCols[ nX ][ aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"}) ]   := a_Dados[nX][12]
        aCols[ nX ][ aScan(aHeader,{|x| AllTrim(x[2])=="C6_ALI_WT"}) ]  := "SC6"
        aCols[ nX ][ aScan(aHeader,{|x| AllTrim(x[2])=="C6_REC_WT"}) ]  := 0
        aCols[ nX ][ n_TamHead + 1]                                     := .F.

        /****utilizando no aCols ******/
        If ExistTrigger( 'C6_PRODUTO' ) // verifica se existe trigger para este campo      
            RunTrigger(2,nX,nil,,'C6_PRODUTO' )
        Endif

        If ExistTrigger( 'C6_TES' ) // verifica se existe trigger para este campo      
            RunTrigger(2,nX,nil,,'C6_TES' )
        Endif

        ADHeadRec("SC6",aHeader)

    next nX

    DbSelectArea("SF1")
    Reclock("SF1",.F.)
    SF1->F1_FSNUMPV := M->C5_NUM
    MsUnlock()
    
return

/*/{Protheus.doc} u_FCOMA02C( SF1->F1_FSNUMPV )
    (long_description)
    @type  Function
    @author user
    @since 22/07/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Function u_FCOMA02C( c_Pedido )
    
    Local l_Mata410     := .F.
    Local l_AtuEmp      := .T.
    Local n_VlrCred     := 0
    Local c_TipLib      := ""
    Local l_Ret         := .T.

    Private L410AUTO    := .F.
    
    if !EMPTY(SC5->C5_NOTA )
        Alert("Não é possível excluir essa nota fiscal, pois a mesma possui pedido de venda faturado! Nota: " + SC5->C5_NOTA )
        Return(.F.)
    endif

    DbSelectArea("SC9")
    DbSetOrder(1)
    dbSeek( xFilial("SC9") + c_Pedido )
    while SC9->(!EOF()) .AND. SC9->C9_FILIAL + SC9->C9_PEDIDO == xFilial("SC9") + c_Pedido
        //Ma461Estor()
        l_Ret := A460Estorna(l_Mata410,l_AtuEmp,n_VlrCred,c_TipLib)
        SC9->(dbSkip())
    enddo

    DbSelectArea("SC5")
    DbSetOrder(1)
    if dbSeek( xFilial("SC5") + c_Pedido )
        A410Deleta("SC5",SC5->(RECNO()),5)
    endif

Return( l_Ret )

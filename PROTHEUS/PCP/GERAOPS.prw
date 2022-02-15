#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include "TBIConn.ch"
#Include 'TopConn.ch'
User Function GeraOPS(c_Produto, n_QUantidade, c_Contador,c_Tipo, c_OP)

//Local aProd     :=  {{"1002130        ",200,"000003","N"},{"MANUTENCAO     ",200,"000003","B"},{"TERCEIROS      ",200,"000003","T"}} //aProdutos
//ocal aProd     :=  aProdutos
Local cOP       := ""
Local cControle := ""
Local aOPs      := {}
Local nQuant    := 0
Local nCont     := 0
Local nOpc      := 3
Local lRet      := .T.

    //aAdd(aProd,"CR010003")
    //aAdd(aProd,"CR010006")
    //aAdd(aProd,"CR010009")

    //RPCSetEnv("99","01")
    //RpcSetType(3)

    //For nCont := 1 To Len(aProd)
        
        //SC2->(DbSelectArea('SC2'))
        //SC2->(DbSetOrder(1))
        
        //cOp       := GetNumSC2()    //ProxOP()
        //cOp       := ProxOP()
        //cOp       := Val(cOp) + 1
        //cOP       := PADL(cOP,6,'0')
        //cCodPrd   := aProd[nCont][1]
        //nQuant    := aProd[nCont][2]
        //cControle := aProd[nCont][3]
        //cTpProd   := aProd[nCont][4]
        
        //Cria Ordem de Produção via MSExecAuto
        aMata650  :={{'C2_FILIAL'   ,FWxFilial('SC2')         ,NIL},;
                     {'C2_NUM'      ,c_OP                      ,NIL},;
                     {'C2_PRODUTO'  ,c_Produto                ,NIL},;                   
                     {'C2_ITEM'     ,"01"                     ,NIL},;          
                     {'C2_SEQUEN'   ,"001"                    ,NIL},;
                     {'C2_QUANT'    ,n_QUantidade             ,NIL},;
                     {'C2_TPOP'     ,"F"                      ,NIL},;
                     {'C2_TPPR'     ,"I"                      ,NIL},;
                     {'C2_EMISSAO'  ,dDataBase                   ,NIL},;
                     {'C2_DATPRI'   ,dDataBase                   ,NIL},;
                     {'C2_DATPRF'   ,dDataBase                   ,NIL},;
                     {'C2_FSCONT'   ,c_Contador                ,NIL},;
                     {'C2_FSTPPROD' ,c_Tipo         ,NIL},;
                     {"AUTEXPLODE" , "S"                      ,NIL}}             
        ConOut("Inicio criação OP: "+Time())     
        
        a_SC2Area   := SC2->( GetArea() )
        a_SD4Area   := SD4->( GetArea() )
        a_SD3Area   := SD3->( GetArea() )
        
        MsExecAuto({|x,Y| Mata650(x,Y)},aMata650,nOpc)
        //Mata650(aMata650,nOpc)

        RestArea( a_SC2Area )
        RestArea( a_SD4Area )
        RestArea( a_SD3Area )

        If !lMsErroAuto
            ConOut("Sucesso!")
            //aAdd(aOPs,{cOp,cCodPrd,cTpProd})
        Else
            ConOut("Erro!")
            MostraErro()
            lRet := .F.
        EndIf
   // Next
Return aOPs

Static Function ProxOP()
Local cSql
Local cNxOp
Local C_ALIAS:= GetNextAlias()

	cSql := "select top 1 C2_NUM from "+RetSqlName("SC2")+" SC2 where D_E_L_E_T_ = ' ' and C2_NUM != ' ' order by C2_NUM desc "
	TcQuery cSql New Alias ( C_ALIAS )
	DbSelectArea( C_ALIAS )
	cNxOp := ( C_ALIAS )->C2_NUM
	( C_ALIAS )->( DbCloseArea() )

Return cNxOp

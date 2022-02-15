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

#DEFINE ENTER CHR(13)+CHR(10)

/*/{Protheus.doc} u_FCOMA102
Gravacao de documentos vinculado na base de conhecimento.
a_Chave - Array com chaves de origem a serem coletadas e definicão de destino onde serão gravadas.
[1] - chave de origem
[2] - entidade de origem
[3] - filial de origem
[4] - entidade de destino

o padrão caso o array esteja vazio será:
[1] - chave de origem       = SF1 - [ F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA ]
[2] - entidade de origem    = SF1
[3] - filial de origem      = AC9_FILIAL (registro de origem SF1)
[4] - entidade de destino   = SE2

Dados a serem incluídos: 
AC9_FILIAL  =   conforme compartilhamento da AC9
AC9_FILENT  =   Filial da entidade de destino (conforme tabela vinculada a entidade de destino)
AC9_ENTIDA  =   Conforme posição [3] - entidade de destino do array a_Chave
AC9_CODENT  =   Chave Formada para gravação da entidade de destino
AC9_CODOBJ  =   Código do objeto(documento vinculado) a entidade de origem

@type function
@version 
@author Eduardo
@since 17/08/2020
@return return_type, return_description
/*/

Function u_FCOMA102(a_Chave)

Local a_ChavInc :=  {} //Array contendo chaves de inclusão pois poderá haver processos com multiplos registros
                       //a rceberem em anexo os documentos que foram inseridos na origem.  
Local a_IncACB  :=  {} //Identifica objetos não incluidos(inconsistentes) e inclui como objeto e descrição INDEFINDA
Local a_Linha   :=  {} //Array temporária para inclusão de registros
Local c_Filial  :=  ""
//Local c_ChaveInc:=  ""
Local l_PesqACB :=  .F.
Local l_PesqAC9 :=  .F.
Local c_Alias   :=  GetNextAlias()
Local c_Qry     :=  ""
Local n_Xn      :=  0


Default a_Chave := {}

If Empty(a_Chave)
    aAdd(a_Chave,   SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA )
    aAdd(a_Chave,   "SF1"                   )
    aAdd(a_Chave,   xFilial(a_Chave[2])     )
    aAdd(a_Chave,   "SE2"                   )
Endif

If a_Chave[2] == "SF1" .And. a_Chave[4] == "SE2" //Documentos serão atribuidos ao banco de conhecimento na SE2 - titulos a Pagar.
    c_Tipos     :=  SuperGetMv("FS_TE2AC9",.F.,"NF/SPED")
    c_Filial    :=  a_Chave[3]
    c_ChavPesq  :=  a_Chave[1] 

    c_Qry   +=  " SELECT " +ENTER
    c_Qry   +=  " * " +ENTER
    c_Qry   +=  " FROM "+RetSqlname("AC9")+" AC9 " +ENTER

    c_Qry   +=  " INNER JOIN "+RetSqlname("ACB")+" ACB " +ENTER
    c_Qry   +=  " ON    ACB.D_E_L_E_T_  <>  '*' " +ENTER
    c_Qry   +=  " AND   ACB_FILIAL      =   AC9_FILIAL " +ENTER
    c_Qry   +=  " AND   ACB_CODOBJ      =   AC9_CODOBJ " +ENTER

    c_Qry   +=  " INNER JOIN "+RetSqlname("SF1")+" SF1 " +ENTER
    c_Qry   +=  " ON    SF1.D_E_L_E_T_  <>  '*' " +ENTER
    c_Qry   +=  " AND   F1_FILIAL       =   AC9_FILENT " +ENTER
    c_Qry   +=  " AND   F1_DOC          =   SUBSTRING(AC9_CODENT,1,9)   " +ENTER
    c_Qry   +=  " AND   F1_SERIE        =   SUBSTRING(AC9_CODENT,10,3)  " +ENTER
    c_Qry   +=  " AND   F1_FORNECE      =   SUBSTRING(AC9_CODENT,13,6)  " +ENTER
    c_Qry   +=  " AND   F1_LOJA         =   SUBSTRING(AC9_CODENT,19,2)  " +ENTER

    c_Qry   +=  " WHERE " +ENTER
    c_Qry   +=  "       AC9.D_E_L_E_T_  <>  '*' " +ENTER
    c_Qry   +=  " AND   AC9_FILIAL      =   '"+xFilial("AC9")+"' " +ENTER
    c_Qry   +=  " AND   AC9_FILENT      =   '"+c_Filial+"' " +ENTER
    c_Qry   +=  " AND   AC9_CODENT      =   '"+c_ChavPesq+"' " +ENTER

    DbUseArea(.T., "TOPCONN", TcGenQry(,,c_Qry), c_Alias, .T., .T.)

    If (c_Alias)->(!Eof())

        ACB->(dbSetOrder(1)) //ACB_FILIAL, ACB_CODOBJ

        AC9->(dbSetOrder(1)) //AC9_FILIAL, AC9_CODOBJ, AC9_ENTIDA, AC9_FILENT, AC9_CODENT

        While (c_Alias)->(!Eof())
            //IND SE2- 6 -  E2_FILIAL      + E2_FORNECE            + E2_LOJA            + E2_PREFIXO            +E2_NUM             +E2_PARCELA+E2_TIPO                                                                                               
            c_ChaveSE2  :=  xFilial("SA2") + (c_Alias)->F1_FORNECE + (c_Alias)->F1_LOJA + (c_Alias)->F1_PREFIXO + (c_Alias)->F1_DOC 
            l_PesqACB   :=  ACB->(dbSeek(xFilial("ACB") + (c_Alias)->AC9_CODOBJ, .T.))
            l_PesqAC9   :=  AC9->(dbSeek(xFilial("AC9") + (c_Alias)->AC9_CODOBJ + a_Chave[4] + xFilial(a_Chave[4]) + c_ChaveSE2, .T.))

            If !(l_PesqACB)
                a_Linha := {}
                aAdd(a_Linha,   xFilial("ACB"))         //ACB_FILIAL  =   conforme compartilhamento da ACB
                aAdd(a_Linha,   (c_Alias)->AC9_CODOBJ)  //ACB_CODOBJ  =   Codigo do objetvo
                aAdd(a_Linha,   "INDEFINIDO")           //ACB_OBJETO  =   Objeto
                aAdd(a_Linha,   "INDEFINIDO")           //ACB_DESCRI  =   Descrição
                aAdd(a_IncACB,a_Linha)
            Endif

            If !(l_PesqAC9)
                a_Linha := {}
                aAdd(a_Linha,   c_ChaveSE2)             //Chave de pesquisa na SA2
                aAdd(a_Linha,   xFilial("AC9"))         //AC9_FILIAL  =   conforme compartilhamento da AC9
                aAdd(a_Linha,   xFilial(a_Chave[4]))    //AC9_FILENT  =   Filial da entidade de destino (conforme tabela vinculada a entidade de destino)
                aAdd(a_Linha,   a_Chave[4])             //AC9_ENTIDA  =   Conforme posição [3] - entidade de destino do array a_Chave
                aAdd(a_Linha,   (c_Alias)->AC9_CODOBJ)  //AC9_CODOBJ  =   Codigo do objetvo
                //Codigo da entidade será no reg da SA2 //AC9_CODENT  =   Chave Formada para gravação da entidade de destino
                aAdd(a_ChavInc,a_Linha)
            Endif
            (c_Alias)->(dbSkip())
        
        Enddo

    Endif

    (c_Alias)->(dbCloseArea())

    If !Empty(a_IncACB)
        For n_Xn := 1 to len(a_IncACB)
            If ACB->(RecLock("ACB",.T.))
                ACB->ACB_FILIAL  := a_IncACB[n_Xn][1]
                ACB->ACB_CODOBJ  := a_IncACB[n_Xn][2]
                ACB->ACB_OBJETO  := a_IncACB[n_Xn][3]
                ACB->ACB_DESCRI  := a_IncACB[n_Xn][4]
                ACB->(mdUnlock())
            Endif
        Next
    Endif

    If !Empty(a_ChavInc)
        SE2->(dbSetOrder(6)) //E2_FILIAL+ E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
        AC9->(dbSetOrder(1)) //AC9_FILIAL+AC9_CODOBJ+AC9_ENTIDA+AC9_FILENT+AC9_CODENT
        For n_Xn := 1 to len(a_ChavInc)
            If SE2->(dbSeek(a_ChavInc[n_Xn][1],.T.))
                While SE2->(!Eof()) .And. SE2->E2_FILIAL+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM == a_ChavInc[n_Xn][1]
                    If Alltrim(SE2->E2_TIPO) $ c_Tipos
                        c_CodEnt    :=  SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA //SE2->E2_FILIAL+
                        If AC9->(!dbSeek(a_ChavInc[n_Xn][2] + a_ChavInc[n_Xn][5] + a_ChavInc[n_Xn][4] + a_ChavInc[n_Xn][3] + c_CodEnt ,.T. ))
                            If AC9->(RecLock("AC9",.T.))
                                AC9->AC9_FILIAL  := a_ChavInc[n_Xn][2]
                                AC9->AC9_FILENT  := a_ChavInc[n_Xn][3]
                                AC9->AC9_ENTIDA  := a_ChavInc[n_Xn][4]  
                                AC9->AC9_CODOBJ  := a_ChavInc[n_Xn][5]  
                                AC9->AC9_CODENT  := c_CodEnt
                                AC9->(msUnlock())
                            Endif
                        Endif
                    Endif
                    SE2->(dbSkip())
                Enddo
            Endif
        Next
    Endif
Endif

Return


/*/{Protheus.doc} FCOMJ102
Job para execução de rotina de avaliação de documentos não anexados ao banco de conhecimento do contas a pagar
oriundo de notas fiscais
@type function
@version 
@author Eduardo
@since 17/08/2020
@param c_Empresa, character, param_description
@param c_Filial, character, param_description
@return return_type, return_description
/*/
User Function FCOMJ102(c_Empresa, c_Filial)

Local   c_Qry       :=  ""    
Local   c_AliasSF1  :=  ""
Local   a_Chave     :=  {}

Default c_Empresa   :=  '01'
Default c_Filial    :=  '01'

If cFilAnt == Nil
    If !Empty(c_Empresa) .And. !Empty(c_Filial)
        RPCSETTYPE(3)
        RPCSETENV(c_Empresa ,c_Filial)
    Endif
Endif

If cFilAnt <> Nil
    c_AliasSF1  :=  GetNextAlias()
    c_Qry   +=  " SELECT " +ENTER
    c_Qry   +=  " * " +ENTER
    c_Qry   +=  " FROM "+RetSqlname("SF1")+" SF1 " +ENTER
    c_Qry   +=  " WHERE " +ENTER
    c_Qry   +=  "       SF1.D_E_L_E_T_  <>  '*' " +ENTER
    c_Qry   +=  " AND   F1_FILIAL + F1_DOC + F1_PREFIXO + F1_FORNECE + F1_LOJA IN " +ENTER
    c_Qry   +=  " ( " +ENTER
    c_Qry   +=  " SELECT E2_FILORIG + E2_NUM + E2_PREFIXO + E2_FORNECE + E2_LOJA " +ENTER
    c_Qry   +=  " FROM "+RetSqlname("SE2")+" SE2 " +ENTER
    c_Qry   +=  " ON    SE2.D_E_L_E_T_  <>  '*' " +ENTER
    c_Qry   +=  " AND   E2_TIPO         =   'NF' " +ENTER
    c_Qry   +=  " ) " +ENTER
    c_Qry   +=  " AND   F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA IN " +ENTER
    c_Qry   +=  " ( " +ENTER
    c_Qry   +=  " SELECT AC9_CODENT " +ENTER
    c_Qry   +=  " FROM "+RetSqlname("AC9")+" AC9 " +ENTER
    c_Qry   +=  " ON    AC9.D_E_L_E_T_  <>  '*' " +ENTER
    c_Qry   +=  " AND   AC9_FILIAL      =   '"+xFilial("AC9")+"' " +ENTER
    c_Qry   +=  " AND   AC9_FILENT      =   '"+xFilial("SF1")+"' " +ENTER
    c_Qry   +=  " ) " +ENTER

    DbUseArea(.T., "TOPCONN", TcGenQry(,,c_Qry), c_AliasSF1, .T., .T.)

    If (c_AliasSF1)->(!Eof())
        While (c_AliasSF1)->(!Eof())
            a_Chave := {}
            a_Add(a_Chave, (c_AliasSF1)->F1_DOC + (c_AliasSF1)->F1_SERIE + (c_AliasSF1)->F1_FORNECE + (c_AliasSF1)->F1_LOJA  )   //[1] - chave de origem       = SF1 - [ F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA ]
            a_Add(a_Chave, "SF1"            ) //[2] - entidade de origem    = SF1
            a_Add(a_Chave, xFilial("SF1")   ) //[3] - filial de origem      = AC9_FILIAL (registro de origem SF1)
            a_Add(a_Chave, "SE2"            ) //[4] - entidade de destino   = SE2

            //Inicio - Executando rotina de avaliação e gravação de documentos vinculados no contas a pagar a partir do DOC de entrada
            u_FCOMA102(a_Chave)
            //fim - Executando rotina de avaliação e gravação de documentos vinculados no contas a pagar a partir do DOC de entrada

            (c_AliasSF1)->(dbSkip())
        Enddo
    Endif
    (c_AliasSF1)->(dbCloseArea())

Endif

Return 



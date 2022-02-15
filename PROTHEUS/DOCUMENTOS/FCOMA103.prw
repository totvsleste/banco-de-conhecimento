#INCLUDE 'TOTVS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*/{Protheus.doc} FCOMA103
    (long_description)
    @type  Function
    @author user
    @since 25/09/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Function u_FCOMA103()

    Local c_Obs     := ""
    Local n_Opca    := 0
    
    Local oFont1
    Local oDlg1
    Local oGrp1
    Local oSay1
    Local oSay2
    Local oMGet1
    Local oBtn1
    Local oBtn2
    Local oBtn3

    oFont1     := TFont():New( "Verdana",0,-11,,.F.,0,,400,.F.,.F.,,,,,, )
    
    oDlg1      := MSDialog():New( 092,240,431,930,"Avaliação de Documento",,,.F.,,,,,,.T.,,oFont1,.T. )
    
    oGrp1      := TGroup():New( 001,001,165,344,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    
    oSay1      := TSay():New( 009,007,{||"Olá, os documentos foram analisados e estão de acordo? Posso continuar com a liberação Financeira?"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,336,008)
    oSay2      := TSay():New( 021,007,{||"Deseja colocar alguma observação? Digite abaixo:"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,336,008)
    
    oMGet1     := TMultiGet():New( 033,007,{|u| If(PCount()>0,c_Obs:=u,c_Obs)},oGrp1,334,104,oFont1,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,.T.  )
    
    //escrever logica para buscar a atividade
    oBtn1      := TButton():New( 149,191,"Cancelar",oGrp1,{|| n_Opca := 1, oDlg1:End() },037,012,,oFont1,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( 149,231,"Revisão",oGrp1,{|| n_Opca := 2, oDlg1:End() },037,012,,oFont1,,.T.,,"",,,,.F. )
    oBtn3      := TButton():New( 149,271,"Tudo Ok!",oGrp1,{|| n_Opca := 3, oDlg1:End() },037,012,,oFont1,,.T.,,"",,,,.F. )

    oDlg1:Activate(,,,.T.)

    if n_Opca == 2
        f_VoltaAtividade( c_Obs )
    elseif n_Opca == 3
        f_AvancaAtividade( c_Obs )
    endif

Return()

/*/{Protheus.doc} f_VoltaAtividade
    (long_description)
    @type  Static Function
    @author user
    @since 25/09/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function f_VoltaAtividade( c_Obs )
    Alert( "Voltou! " + c_Obs )
Return()

/*/{Protheus.doc} f_AvancaAtividade
    (long_description)
    @type  Static Function
    @author user
    @since 25/09/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function f_AvancaAtividade( c_Obs )
    Alert( "Avancou! " + c_Obs )
Return()

//Bibliotecas
#include "Protheus.ch"
#include "Parmtype.ch"
#include "FwMvcDef.ch"
#include "FwTableAttach.ch"
#include "TopConn.ch"

//Constantes
#Define ENTER    Chr(13)+Chr(10)

Static c_Titulo := "Arquivo Temporario"

function u_FTMPA001()

	Local   oBrowse
	Local   a_Fields        :=  {}
    Local   a_Browse        :=  {}
    Local   a_Index         :=  {}
	Local c_Query           := "SELECT * FROM SA1990"

    Private c_AliasTable    :=  GetNextAlias()
    Private c_AliasTmp      :=  GetNextAlias()
    
	o_TempTable := FWTemporaryTable():New( c_AliasTable )

	//--------------------------
	//Monta os campos da tabela
	//--------------------------
	aAdd(a_Fields, { "FS_CODIGO"    ,"C"    ,TamSx3( "A1_COD"   )[1]    ,0  } ) //1
	aAdd(a_Fields, { "FS_LOJA"      ,"C"    ,TamSx3( "A1_LOJA" )[1]     ,0  } ) //2
	aAdd(a_Fields, { "FS_NOME"      ,"C"    ,TamSx3( "A1_NOME"  )[1]    ,0  } ) //3
	aAdd(a_Fields, { "FS_CGC"       ,"C"    ,TamSx3( "A1_CGC"  )[1]     ,0  } ) //4

	o_Temptable:SetFields( a_Fields )
	o_TempTable:AddIndex("indice1", { "FS_CODIGO",  "FS_LOJA"} )
	o_TempTable:AddIndex("indice2", { "FS_NOME"} )

	//------------------
	//Criação da tabela
	//------------------
	o_TempTable:Create()

	MPSysOpenQuery( c_Query, c_AliasTmp )

	While (c_AliasTmp)->(!Eof())

		If (c_AliasTable)->(RecLock(c_AliasTable,.T.))
			(c_AliasTable)->FS_CODIGO   :=  (c_AliasTmp)->A1_COD
			(c_AliasTable)->FS_LOJA     :=  (c_AliasTmp)->A1_LOJA
			(c_AliasTable)->FS_NOME     :=  (c_AliasTmp)->A1_NOME
			(c_AliasTable)->FS_CGC      :=  (c_AliasTmp)->A1_CGC
			(c_AliasTable)->(msUnlock())
		Endif

		(c_AliasTmp)->(dbSkip())

	Enddo

	//Definindo as colunas que serão usadas no browse

	aAdd(a_Browse, { "Codigo"   ,"FS_CODIGO"   ,"C"   ,TamSx3( "A1_COD" )[1]    ,0  ,"@!" } )
	aAdd(a_Browse, { "Loja"     ,"FS_LOJA"     ,"C"   ,TamSx3( "A1_LOJA" )[1]   ,0  ,"@!" } )
	aAdd(a_Browse, { "Nome"     ,"FS_NOME"     ,"C"   ,TamSx3( "A1_NOME" )[1]   ,0  ,"@!" } )
	aAdd(a_Browse, { "CGC"      ,"FS_CGC"      ,"C"   ,TamSx3( "A1_CGC" )[1]    ,0  ,"@!" } )
	
    aAdd(a_Index, "FS_CODIGO" )

	//Criando o browse da temporária
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias(c_AliasTable)
	oBrowse:SetQueryIndex(a_Index)
	oBrowse:SetTemporary(.T.)
	oBrowse:SetFields(a_Browse)
	oBrowse:DisableDetails()
	oBrowse:SetDescription(c_Titulo)
	oBrowse:Activate()

    (c_AliasTmp)->(dbCloseArea())

return()

Static Function MenuDef()
    Local aRot := {}

    //Adicionando opções
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.FTMPA001' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.FTMPA001' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.FTMPA001' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.FTMPA001' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5

Return aRot

Static Function ModelDef()

	//Criacao do objeto do modelo de dados
	Local oModel := Nil

	//Criacao da estrutura de dados utilizada na interface
	Local oStrCab := DefStrModel()

    oStrCab:AddTable( ( c_AliasTable ), {'FS_CODIGO'}, "Temporaria")

	//Instanciando o modelo, nao e recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
	oModel := MPFormModel():New("FTMPA1M")

	//Atribuindo formularios para o modelo
	oModel:AddFields("CABEC",/*cOwner*/,oStrCab, /*bPre*/ ,/* < bPost >*/, /*< bLoad >*/)

	//Setando a chave primaria da rotina
	oModel:SetPrimaryKey({"FS_CODIGO"})

	//Adicionando descricao ao modelo
	oModel:SetDescription( Capital( UsrFullName( RetCodUsr() ) ) )

	//Setando a descricao do formulario
	oModel:GetModel("CABEC"):SetDescription("Cabecalho")

Return( oModel )

Static Function ViewDef()

	//Criacao do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
	Local oModel := FWLoadModel("FTMPA001")

	//Criacao da estrutura de dados utilizada na interface do cadastro de etiquetas - cabecalho
	Local oStrCab := DefStrView()

    //Criando oView como nulo
	Local oView := Nil

	//Criando a view que sera o retorno da funcao e setando o modelo da rotina
	oView := FWFormView():New()
	oView:SetModel(oModel)

	//Atribuindo formularios para interface
	oView:AddField("VIEW_CABEC", oStrCab, "CABEC")

	oView:CreateHorizontalBox("TELA",100)

	//O formulario da interface sera colocado dentro do container
	oView:SetOwnerView( 'VIEW_CABEC', 'TELA' )

	//Habilitando titulo
	oView:EnableTitleView('VIEW_CABEC','Analise do Arquivo do Coletor')

Return( oView )

Static Function DefStrModel()

	Local aArea    := GetArea()
	Local bValid   := { || }
	Local bWhen    := { || }
	Local bRelac   := { || }
	Local oStruct   := FWFormModelStruct():New()
					
	bValid := { || .T. }
	bWhen  := { || .T. }
	bRelac := { || .T. }
	//				  Titulo        ,ToolTip	    ,Id do Field	,Tipo	,Tamanho,Decimal ,Valid ,When	 ,Combo		,Obrigatorio	,Init	,Chave	,Altera	,Virtual
	oStruct:AddField("Codigo" 		,"Codigo"  	    ,'FS_CODIGO'	,'C'	,06 	,0		 ,Nil   ,Nil        ,{}		,.T.			,FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,"+c_AliasTmp+"->FS_CODIGO,'')" )	,.F.	,.F.	,.F.)	//Legenda
	oStruct:AddField("Loja."        ,"Loja"         ,'FS_LOJA'		,'C'	,02 	,0		 ,Nil   ,Nil	 	,{}		,.F.			,FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,"+c_AliasTmp+"->FS_LOJA,'')" )	    ,.F.	,.F.	,.F.)	//Filial
	oStruct:AddField("Nome" 		,"Nome" 		,'FS_NOME'		,'C'	,50 	,0		 ,Nil   ,Nil	 	,{}		,.F.			,FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,"+c_AliasTmp+"->FS_NOME,'')" )	    ,.F.	,.F.	,.F.)	//Arquivo
	oStruct:AddField("Loja"         ,"Loja" 	    ,'FS_CGC'	    ,'C'	,14 	,0		 ,Nil   ,Nil	 	,{}		,.F.			,FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,"+c_AliasTmp+"->FS_CGC,'')" )	    ,.F.	,.F.	,.F.)	//Data
	
    RestArea( aArea )

Return oStruct

Static Function DefStrView(c_Tipo)

	Local oStruct   := FWFormViewStruct():New()

	oStruct:AddField('FS_CODIGO'	,'01'	,"Codigo"		,"Codigo"		,NIL 	,'C'	,'@!',NIL, NIL, Iif(INCLUI, .T., .F.),NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
	oStruct:AddField('FS_LOJA'		,'02'	,"Loja."        ,"Loja"	        ,NIL 	,'C'	,"@!",NIL, NIL, .T.,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
	oStruct:AddField('FS_NOME'		,'03'	,"Nome" 		,"Nome"		    ,NIL 	,'C'	,"@!",NIL, NIL, .T.,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)
	oStruct:AddField('FS_CGC'	    ,'04'	,"CNPJ/CPF"		,"CNPJ/CPF"		,NIL 	,'C'	,"@!",NIL, NIL, .T.,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL)

Return oStruct

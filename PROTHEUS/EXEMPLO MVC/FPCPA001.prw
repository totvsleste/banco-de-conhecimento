#Include 'Protheus.ch'
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FPCPA001  ºAutor  ³ Eliene Cerqueira       º Data ³Maio/2017º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de manutençao da montagem do PMP				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                     A L T E R A C O E S                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData      ºProgramador       ºAlteracoes                               º±±
±±º          º                  º                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FPCPA001()

Local oBrowse	:= Nil

oBrowse	:= FWmBrowse():New()
oBrowse:SetAlias("SZ2")
oBrowse:Activate()

Return Nil

Static Function MenuDef()

	Local a_Rotina	:= {}

	ADD OPTION a_Rotina TITLE '&Visualizar'	ACTION 'VIEWDEF.FPCPA001' OPERATION 1 ACCESS 0
	ADD OPTION a_Rotina TITLE '&Incluir'    ACTION 'VIEWDEF.FPCPA001' OPERATION 3 ACCESS 0
	ADD OPTION a_Rotina TITLE '&Alterar'    ACTION 'VIEWDEF.FPCPA001' OPERATION 4 ACCESS 0
	ADD OPTION a_Rotina TITLE '&Excluir'    ACTION 'VIEWDEF.FPCPA001' OPERATION 5 ACCESS 0
	ADD OPTION a_Rotina TITLE 'Im&primir'   ACTION 'VIEWDEF.FPCPA001' OPERATION 8 ACCESS 0
	ADD OPTION a_Rotina TITLE '&Copiar'     ACTION 'VIEWDEF.FPCPA001' OPERATION 9 ACCESS 0
	ADD OPTION a_Rotina TITLE '&Gravar PMP' ACTION 'U_GRVSCH' OPERATION 4 ACCESS 0

Return a_Rotina

Static Function ModelDef()

	Local oModel	:= MPFormModel():New('PCPA001M',/*bPre*/,/*bPos*/,/*bCommit*/,/*bCancel*/)
	Local oStruSZ2	:= FWFormStruct( 1, 'SZ2' , { |x| ALLTRIM(x) $ 'Z2_ANO, Z2_DOC'  } )
	Local oStrSZ2G	:= FWFormStruct( 1, 'SZ2' )

	oModel:AddFields('SZ2MASTER',/*cOwner*/,oStruSZ2,/*bPre*/,/*bPos*/,/*bLoad*/ /*{|oModel| F_TDPALFORM(oModel) }*/ )
	oModel:AddGrid('SZ2GRID','SZ2MASTER',oStrSZ2G,/*bLinePre*/,/*bLinePost*/,/*bPre*/,/*bPos*/,/*bLoad*/ )
	oModel:SetRelation('SZ2GRID',{ { 'Z2_FILIAL', 'XFILIAL("SZ2")' }, { 'Z2_ANO', 'Z2_ANO' }, { 'Z2_DOC', 'Z2_DOC' }, { 'Z2_PRODUTO', 'Z2_PRODUTO' } }, SZ2->( IndexKey( 1 ) ) )
	oModel:SetPrimaryKey( { "Z2_FILIAL", "Z2_ANO", "Z2_DOC", "Z2_PRODUTO" } )
	oModel:GetModel('SZ2GRID'):SetUniqueLine({'Z2_FILIAL','Z2_ANO','Z2_DOC','Z2_PRODUTO'})
	oModel:GetModel('SZ2MASTER'):SetDescription('Montagem PMP')
	oModel:GetModel('SZ2GRID'):SetDescription('Produtos')

	//oStrSZ2G:RemoveField('Z2_ANO')
	//oStrSZ2G:RemoveField('Z2_DOC')

Return oModel

Static Function ViewDef()

	Local oView		:= FWFormView():New()
	Local oStruSZ2	:= FWFormStruct( 2, 'SZ2' , { |x| ALLTRIM(x) $ 'Z2_ANO, Z2_DOC'  } )
	Local oStrSZ2G	:= FWFormStruct( 2, 'SZ2' )
	Local oModel	:= FWLoadModel('FPCPA001')

	oStrSZ2G:RemoveField('Z2_ANO')
	oStrSZ2G:RemoveField('Z2_DOC')

	oView:SetModel(oModel)
	oView:AddField('Z21_VIEW',oStruSZ2,'SZ2MASTER')
	oView:AddGrid('Z22_VIEW',oStrSZ2G,'SZ2GRID')

	oView:CreateHorizontalBox('CABEC',30)
	oView:CreateHorizontalBox('GRID',70)

	oView:SetOwnerView('Z21_VIEW','CABEC')
	oView:SetOwnerView('Z22_VIEW','GRID')

	oView:EnableTitleView('Z21_VIEW','Montagem PMP')
	oView:EnableTitleView('Z22_VIEW','Produtos')

Return oView

User Function GRVSCH()
Local c_ano 	:= SZ2->Z2_ANO
Local c_doc		:= SZ2->Z2_DOC
Local c_filial 	:= SZ2->Z2_FILIAL
Local d_DataIni := Datavalida(Ctod("01/01/"+c_ano))
Local d_DataFim := Ctod("31/12/"+c_ano)
Local a_Semanas	:= {}
Local d_DataAtu	:= d_DataIni
Local c_DiaQueb	:= "saturday"
Local n_Atual 	:= 0
Local l_Nova 	:= .T.
Local a_Area 	:= GetArea()
Local I,J

While d_DataAtu <= d_DataFim
	If	l_Nova
		n_Atual++
		aAdd(a_Semanas, {d_DataAtu, d_DataAtu})
		l_Nova := .F.
	Endif

	If Alltrim( Lower( cDow(d_DataAtu) ) ) == c_DiaQueb
		a_Semanas[n_Atual][2] := d_DataAtu
		d_DataAtu := DaySum(d_DataAtu, 1)
		l_Nova := .T.
	EndIf

	a_Semanas[n_Atual][2] := d_DataAtu
	d_DataAtu := DaySum(d_DataAtu, 1)
EndDo

DbSelectArea("SZ2")
DbSeek(c_filial+c_ano+c_doc)
Do	While !Eof() .and. SZ2->Z2_FILIAL+SZ2->Z2_ANO+SZ2->Z2_DOC = c_filial+c_ano+c_doc
	For	I:= 1 to 52
		J := Strzero(I,2)
		c_Campo := "SZ2->Z2_SEM"+J
		If	&c_Campo <> 0
			DbSelectArea("SHC")
			Reclock("SHC",.T.)
				HC_FILIAL	:= xFilial("SHC")
				HC_PRODUTO	:= SZ2->Z2_PRODUTO
				HC_ITCDINI	:= a_Semanas[I,1]
				HC_DATA		:= a_Semanas[I,2]
				HC_QUANT	:= &c_Campo
				HC_DOC		:= SZ2->Z2_DOC
			MsUnLock()
		Endif
	Next
	DbSelectArea("SZ2")
	DbSkip()
Enddo

MsgAlert("Gravação realizada com sucesso!","Aviso")
RestArea(a_Area)

Return
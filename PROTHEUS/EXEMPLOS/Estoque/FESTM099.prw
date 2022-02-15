#INCLUDE "rwmake.ch" 
#include "topconn.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
	
	ROTINA PARA ABERTURA DO ESTOQUE - MORAIS DE CASTRO
	DATA: 15/03/2017

*/

User Function FESTM099()
Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := "Abertura de Estoque"
Local cDesc1  := " ***   Rotina de abertura de estoque"
Local cDesc2  := " ***   Tabelas envolvidas: SB9, SBJ, SBK"
Local cDesc3  := " ***   Parametro envolvido: MV_ULMES"
Local cDesc4  := " ***   Necessário todas as filiais estarem com a mesma data de fechamento."

AADD( aSay, cDesc1 )
AADD( aSay, cDesc2 )
AADD( aSay, cDesc3 )
AADD( aSay, cDesc4 )
AADD( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() }} )
AADD( aButton, { 2, .T., {|| FechaBatch()            }} )

FormBatch( cTitulo, aSay, aButton )

If nOpc <> 1
	Return Nil
Endif

Processa( {|lEnd| RunProc(@lEnd)}, "Aguarde...","Executando rotina.", .T. )

Return()  
/*/
+-----------------------------------------------------------------------------
| Função	| RUNPROC    | Autor | TOTVS                  | Data |15/03/2017 |
+-----------------------------------------------------------------------------
| Descrição	| Função de processamento executada através da FormBatch()   	 |
+-----------------------------------------------------------------------------
/*/
Static Function RunProc(lEnd)
Local nCnt 	   		:= 0
Local a_Parametro	:= {}
Local c_FilAux		:= cFilAnt
Local l_Diferente	:= .F. 
Local l_Continua	:= .T. 
Local c_Senha		:= ""
Local c_Filial		:= "" 
Local c_MsgErr		:= "" 
Local d_UltFec		:= Ctod("  /  /  ")
Local n_Mes			:= 0
Local n_NovoMes		:= 0
Local n_NovoAno		:= 0
Local d_NovaData	:= 0
Local i				:= 0 
Local l_Erro		:= .F.

Private c_Perg		:= "FESTM099"
	
DbSelectArea("SM0")
DbSetOrder(1) 
SM0->(DbGotop())
While (SM0->(!Eof())) .AND. (SM0->M0_CODIGO = "01")  //Percorre as filiais da empresa 01
    
	DbSelectArea("SX6")
	DbSetOrder(1) 
	If DbSeek(SM0->M0_CODFIL+"MV_ULMES  ") //Posiciona no parametro MV_ULMES
	
		If Len(a_Parametro) = 0 //Quando for a primeira vez, apenas adiciona no vetor
			
			AADD(a_Parametro,{ALLTRIM(SM0->M0_CODFIL),ALLTRIM(SX6->X6_CONTEUD)})
		
		Else  
		
		    //Quando não for a primeira vez, percorre os valores do vetor para saber se o conteudo e diferente
			For i:= 1 To Len(a_Parametro)
			
				If (a_Parametro[i][2] <> ALLTRIM(SX6->X6_CONTEUD)) //Quando for diferente, sai do laço e não executa a rotina
				    
					//Primeira validacao: Todas as filiais precisa estar com a data de fechamento iguais. 
					l_Diferente:= .T.
				    Exit
				    
				Else
				    
			    	nPos := Ascan(a_Parametro, { | x | x[1] == ALLTRIM(SM0->M0_CODFIL)} )
					If (nPos = 0)
						AADD(a_Parametro,{ALLTRIM(SM0->M0_CODFIL),ALLTRIM(SX6->X6_CONTEUD)}) //adiciona no vetor
					EndIf
					
				Endif
							
			Next  	
			
			If (l_Diferente) //Testa se continua ou não
				
				MsgAlert("Não é possível continuar pois as datas de fechamentos de estoque das filiais não estão iguais!!!","Aviso")
				l_Continua:= .F.
				Exit
							
			Endif
			
		EndIf
		
	EndIf
	
	SM0->(DBSKIP())	

EndDo

cFilAnt:= c_FilAux

If (l_Continua)
	
	//Data do Ultimo fechamento do estoque 
 	d_UltFec:= GetMv("MV_ULMES")   

	//Tela para informar a senha de validacao
	If (f_TelaSenha(d_UltFec))
		
		IF AVISO(SM0->M0_NOMECOM,"Esta rotina irá abrir o estoque conforme a data do ultimo fechamento. Deseja realmente continuar?",{"Sim","Não"},2,"Atenção") == 1
            
            //Valida se a data do B9 corresponde a data do mv_ulmes
			If (f_ValB9(a_Parametro))
			
				nCnt	:= Len(a_Parametro)
				
				//Mes do ultimo fechamento do estoque
				n_Mes	:= Month(d_UltFec)		
				
				//Verifica o mes anterior 
				If (n_Mes = 1)
					n_NovoMes:= 12
					n_NovoAno:= Val(Substr(Dtos(d_UltFec),1,4))-1
				Else
					n_NovoMes:= StrZero(n_Mes-1,2)
					n_NovoAno:= Val(Substr(Dtos(d_UltFec),1,4))
				EndIf
				
				//Forma a data com o primeiro dia do mes
				d_NovaData	:= Stod(cValToChar(n_NovoAno)+cValToChar(n_NovoMes)+"01")
				
				//Busca o ultimo dia do mes
				d_NovaData		:= LASTDAY(d_NovaData)
				
				ProcRegua(nCnt)							          
				IncProc("Processando... ")
				
				//Deleta os registro na SB9 com data igual ao ultimo fechamento de todas a filiais
				c_Qry:= "UPDATE "+RetSqlName("SB9")+" SET D_E_L_E_T_ = '*' "
				c_Qry+= "WHERE D_E_L_E_T_ <> '*' "
				c_Qry+= "AND B9_DATA = '" + DTOS(d_UltFec)+"' "
				
				MEMOWRIT("C:\Temp\FESTM099_SB9.sql",c_Qry)
				
				// SE HOUVER ERRO NO INSERT, MOSTRA NA TELA E INTERROMPE A EXECUÇÃO DA ROTINA
				If (TCSQLExec(c_Qry) < 0)
					
					c_MsgErr:= TCSQLError()
					MSGSTOP("TCSQLError() - SB9 " + c_MsgErr)
				    l_Erro:= .T.
				    
				Else
					
					//Deleta os registro na SBJ com data igual ao ultimo fechamento de todas a filiais
					c_Qry:= "UPDATE "+RetSqlName("SBJ")+" SET D_E_L_E_T_ = '*' "
					c_Qry+= "WHERE D_E_L_E_T_ <> '*' "
					c_Qry+= "AND BJ_DATA = '" + DTOS(d_UltFec)+"' "
					
					MEMOWRIT("C:\Temp\FESTM099_SBJ.sql",c_Qry)
					
					// SE HOUVER ERRO NO INSERT, MOSTRA NA TELA E INTERROMPE A EXECUÇÃO DA ROTINA
					If (TCSQLExec(c_Qry) < 0)
						
						c_MsgErr:= TCSQLError()
						MSGSTOP("TCSQLError() - SBJ " + c_MsgErr)
						l_Erro:= .T.
					
					Else
						
						//Deleta os registro na SBK com data igual ao ultimo fechamento de todas a filiais
						c_Qry:= "UPDATE "+RetSqlName("SBK")+" SET D_E_L_E_T_ = '*' "
						c_Qry+= "WHERE D_E_L_E_T_ <> '*' "
						c_Qry+= "AND BK_DATA = '" + DTOS(d_UltFec)+"' "
						
						MEMOWRIT("C:\Temp\FESTM099_SBK.sql",c_Qry)
						
						// SE HOUVER ERRO NO INSERT, MOSTRA NA TELA E INTERROMPE A EXECUÇÃO DA ROTINA
						If (TCSQLExec(c_Qry) < 0)
							
							c_MsgErr:= TCSQLError()
							MSGSTOP("TCSQLError() - SBK " + c_MsgErr)
							l_Erro:= .T.
										
						EndIf
										
					EndIf
									
				EndIf
				
				//Se nao ocorreu erro no Udate, atualiza o parametro
				If !(l_Erro)
					
					For i:= 1 To Len(a_Parametro)
						
						//Atualiza o parametro								
						DbSelectArea("SX6")
						DbSetOrder(1) 
						If DbSeek(a_Parametro[i][1]+"MV_ULMES  ")
							Reclock("SX6",.F.)
							SX6->X6_CONTEUD:= DTOS(d_NovaData)
							MsUnLock()
						EndIf
						
					Next
					
					MsgInfo("Estoque aberto com sucesso!!!","Aviso")
					
				EndIf
			    
			Endif
		
		Endif
		
	EndIf
	
EndIf

Return()

//Tela da Senha
Static Function f_TelaSenha(d_UltFec)
Local l_Cont	:= .F.
Local c_Digit	:= Space(6)
Local l_VldDlg	:= .F.   

SetPrvt("oFont1","oDlg1","oGrp1","oSay1","oGet1","oBtn1","oBtn2","oGrp2","oSay2")

oFont1     := TFont():New( "Verdana",0,-12,,.F.,0,,400,.F.,.F.,,,,,, ) //Normal
oFont2     := TFont():New( "Verdana",0,-12,,.T.,0,,700,.F.,.F.,,,,,, ) //Negrito
oDlg1      := MSDialog():New( 091,232,250,555,"Abertura de Estoque",,,.F.,,,,,,.T.,,,.T. )
oGrp1      := TGroup():New( 028,004,076,160,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 040,008,{||"Informe a senha de validação:"},oGrp1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,100,008)
oGet1      := TGet():New( 040,108,{|u| If(PCount()>0,c_Digit:=u,c_Digit)},oGrp1,038,009,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.T.,"","",,)
oBtn1      := TButton():New( 056,020,"Confirmar",oGrp1,{|| If (f_Valida(@l_Cont, @l_VldDlg, c_Digit),oDlg1:END(),.F.) },037,012,,oFont1,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 056,108,"Sair",oGrp1,{|| l_VldDlg:= .T., oDlg1:END() },037,012,,oFont1,,.T.,,"",,,,.F. )
oGrp2      := TGroup():New( 004,004,024,160,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay2      := TSay():New( 012,008,{||"Data do último fechamento: "+Dtoc(d_UltFec)},oGrp2,,oFont2,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,192,008)

oDlg1:Activate(,,,.T.,{||,l_VldDlg})

Return(l_Cont)

//Valida a senha
Static Function f_Valida(l_Cont, l_VldDlg, c_Digit)

Local l_Ret:= .T.
Local c_Senha:= Alltrim(GetMv("MC_SENHEST"))

If Empty(c_Digit)

	MsgAlert("Informa a senha de validação!!!","Aviso")
	oGet1:SetFocus()
	l_Cont:= .F.
	
Else

	If (Alltrim(c_Digit) <> c_Senha)
		
		MsgAlert("A senha de validação inválida!!!","Aviso")
		oGet1:SetFocus()
		l_Cont:= .F.
	
	Else

		l_VldDlg	:= .T.
		l_Cont		:= .T.
		
	Endif

EndIf

Return(l_Ret) 

//Testa se a data do parametro mv_ulmes corresponde a data do b9 da filial
Static Function f_ValB9(a_Parametro)
	
	Local l_Ret		:= .T.
	Local c_Qry		:= ""
	Local i			:= 0
	Local d_B9Data	:= ""
	
	For i:= 1 To Len(a_Parametro)
	
		c_Qry:= "SELECT MAX(B9_DATA) DATAB9 FROM "+RetSqlName("SB9")+" WHERE D_E_L_E_T_ <> '*' AND B9_FILIAL = '"+a_Parametro[i][1]+"'"
		TcQuery c_Qry New Alias "QRYB9"
		d_B9Data:= QRYB9->DATAB9
		QRYB9->(DBCLOSEAREA())
		
		DbSelectArea("SX6")
		DbSetOrder(1) 
		DbSeek(a_Parametro[i][1]+"MV_ULMES  ") 
		
		If (d_B9Data <> ALLTRIM(SX6->X6_CONTEUD))
			
			MsgAlert("A data do parametro MV_ULMES para a filial :"+a_Parametro[i][1]+" não corresponde com a data da tabela SB9.","Aviso")
			l_Ret:= .F.			
			Exit
			
		EndIf
		
	Next

Return(l_Ret)
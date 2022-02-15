#include 'protheus.ch'

user function FTSTEXCEL()

	Local oExcel 	:= FWMSEXCEL():New()
	Local c_XlsFile	:="C:\temp\TESTE.xls"

	oExcel:AddworkSheet("W01")
	oExcel:AddTable ("W01","Titulo de teste 1")
	oExcel:AddColumn("W01","Titulo de teste 1","Col1",1,1)
	oExcel:AddColumn("W01","Titulo de teste 1","Col2",2,2)
	oExcel:AddColumn("W01","Titulo de teste 1","Col3",3,3)
	oExcel:AddColumn("W01","Titulo de teste 1","Col4",1,1)
	oExcel:AddRow("W01","Titulo de teste 1",{11,12,13,14})
	oExcel:AddRow("W01","Titulo de teste 1",{21,22,23,24})
	oExcel:AddRow("W01","Titulo de teste 1",{31,32,33,34})
	oExcel:AddRow("W01","Titulo de teste 1",{41,42,43,44})

	oExcel:AddworkSheet("Teste - 2")
	oExcel:AddTable("Teste - 2","Titulo de teste 1")
	oExcel:AddColumn("Teste - 2","Titulo de teste 1","Col1",1)
	oExcel:AddColumn("Teste - 2","Titulo de teste 1","Col2",2)
	oExcel:AddColumn("Teste - 2","Titulo de teste 1","Col3",3)
	oExcel:AddColumn("Teste - 2","Titulo de teste 1","Col4",1,4)
	oExcel:AddRow("Teste - 2","Titulo de teste 1",{11,12,13,stod("20121212")})
	oExcel:AddRow("Teste - 2","Titulo de teste 1",{21,22,23,stod("20121212")})
	oExcel:AddRow("Teste - 2","Titulo de teste 1",{31,32,33,stod("20121212")})
	oExcel:AddRow("Teste - 2","Titulo de teste 1",{41,42,43,stod("20121212")})
	oExcel:AddRow("Teste - 2","Titulo de teste 1",{51,52,53,stod("20121212")})
	oExcel:Activate()
	oExcel:GetXMLFile(c_XlsFile)

	If 	!ApOleClient("MsExcel")
		ShowHelpDlg("ERRO",;
		{"Microsoft Office Excel não está instalado."},5,;
		{"Contacte o administrador do sistema e solicite a instalação do Microsoft Office Excel em seu computador."},5)
		Return
	Endif

	ShellExecute("open",c_XlsFile,"","",3)

return
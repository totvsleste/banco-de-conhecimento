#INCLUDE "TOTVS.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'SHELL.CH'

#DEFINE OLECREATELINK  400
#DEFINE OLECLOSELINK   401
#DEFINE OLEOPENFILE    403
#DEFINE OLESAVEASFILE  405
#DEFINE OLECLOSEFILE   406
#DEFINE OLESETPROPERTY 412
#DEFINE OLEWDVISIBLE   "206"
#DEFINE WDFORMATTEXT   "2"
#DEFINE WDFORMATPDF    "17" // FORMATO PDF
#DEFINE CGETFILE_TYPE GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE
#DEFINE ENTER CHR(10)+CHR(13)

User Function HTM2PDF()

	Local hWinWord  := nil
	Local cDocument := "C:\temp\jrp\GUIA-020999.htm" 	//c_NomeExt+".doc"//getClientDir() + "exemplo.docx"
	Local cPDF      := "C:\temp\jrp\GUIA-020999.pdf"		//getClientDir() + "exemplo.txt

	// esse exemplo exclusivo para ambiente Windows
	if !(GetRemoteType() == 1) .and. !(isPlugin())
		return conOut("Somente Windows")
	endIf

	// verifica se o documento existe
	if !file(cDocument)
		return conOut("Documento nao encontrado")
	endif

	// cria objeto OLE para conversar com WinWord
	hWinWord := (execInClient(OLECREATELINK,{"TMSOLEWORD97"}))[1]
	if !(val(hWinWord) == 0)
		return conOut("Nao foi possivel criar o link com Word")
	endIf

	// abre o documento (doc ou docx)
	execInClient(OLEOPENFILE, { hWinWord, cDocument, "0","", "" } )

	// salva o documento como PDF
	execInClient(OLESAVEASFILE, { hWinWord, cPDF, "", "", "0", WDFORMATPDF } )

	// fecha conexão com objeto OLE
	execInClient( OLECLOSEFILE, { hWinWord } )

	hWord := execInClient(OLECLOSELINK, { hWinWord, 1 } )

Return
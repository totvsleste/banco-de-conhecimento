#include "rwmake.ch"
#include "protheus.ch"

User Function TBExpImg()

Local a_Res		:= getResArray("*")
Local c_Caminho	:= "C:\Totvs\Imagens\"

aEval(a_Res,{|x| resource2File(x,c_Caminho + x)})

//Outra opção: Chamando direto no menu de formulas:
//cDir:=cGetFile("Pastas|","Salvar",,,.F.,176),aEval(GetResArray('.*'),{|x|Resource2File(x,cDir+x) })

Return()
/*

ImgLogoTotvs      := "fw_totvs_logo_61x27.png"
ImgLogoByYouf     := "fwby_logo.png"
ImgBackground     := "fwlgn_byyou_bg.png"
ImgSlogan     := "fwlgn_byyou_slogan.png"
ImgIcones     := "fwlgn_byyou_icones.png"

Resource2File( alltrim(ImgLogoTotvs) , "c:\temp\"+alltrim(ImgLogoTotvs))
Resource2File( alltrim(ImgLogoByYouf) , "c:\temp\"+alltrim(ImgLogoByYouf))
Resource2File( alltrim(ImgBackground) , "c:\temp\"+alltrim(ImgBackground))
Resource2File( alltrim(ImgSlogan)     , "c:\temp\"+alltrim(ImgSlogan))
Resource2File( alltrim(ImgIcones)     , "c:\temp\"+alltrim(ImgIcones))

return()
*/
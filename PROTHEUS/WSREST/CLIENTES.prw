#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'
#Include 'RestFul.CH'

User Function EREST_01()
Return

WSRESTFUL mtdClientes DESCRIPTION "Serviço REST para gravacao de clientes no ERP Protheus"

    WSMETHOD POST DESCRIPTION "Grava Clientes - [SA1]" WSSYNTAX "/POST/{method}"

END WSRESTFUL

/*
{
    "empresa":"01"
    "filial":"01"
    "cnpj":"000000000000"
    "tipo":"J"
    "razao":"nome do cliente"
    "fantasia":"x"
    "endereco":"rua jose"
}
*/


WSMETHOD POST WSSERVICE mtdClientes

    Local l_Ret     := .F.
    Local c_Body    := ::GetContent()
    


return(.T.)

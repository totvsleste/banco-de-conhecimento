#include 'protheus.ch'
#include 'parmtype.ch'

user function MT103NAT()
	Alert("Chamando o ponto de entrada MT103NAT")
	NfeFornece(cTipo,cA100For)
	Alert("Termino da chamada")
return(.T.)
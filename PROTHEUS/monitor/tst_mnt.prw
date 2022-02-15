User Function tst_mnt()

	aInfo := GetUserInfoArray() // Resultado: (Informações dos processos)
	varinfo("Threads:",aInfo)

	/*local oSrv     := nil
	local cEnv     := "LOBO" //Ambiente
	local aUsers   := {}
	local nIdx     := 0
	local aServers := {}
	local aTmp     := {}

	// neste caso, quero apenas o balance, que me retorna todos os slaves conectados.
	aadd(aServers, {"172.16.12.53", 1260})
	// voce pode também adicionar outros servers fora do balance, como servers de web ou workflows.
	//aadd(aServers, {"127.0.0.1", 7001})
	//aadd(aServers, {"127.0.0.1", 7002})
	// etc [...]

	For nIdx := 1 to len(aServers)
	// conecta no slave via rpc
	oSrv := rpcconnect(aServers[nIdx,1], aServers[nIdx,2], cEnv, "99", "01")
	if valtype(oSrv) == "O"
	oSrv:callproc("RPCSetType", 3)
	// chama a funcao remotamente no server, retornando a lista de usuarios conectados
	aTmp := oSrv:callproc("GetUserInfoArray")
	aadd(aUsers, aclone(aTmp))
	aTmp := nil
	// limpa o ambiente
	oSrv:callproc("RpcClearEnv")
	// fecha a conexao
	rpcdisconnect(oSrv)
	else
	return "Falha ao obter a lista de usuarios."
	endif
	Next nIdx

	Return varinfo("usr",aUsers)
	*/

Return

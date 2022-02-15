User Function fs_enviaemail()

	Local o_Email		:= clsEmail():New()

	o_Email:c_Conta			:= "totvsleste"
	o_Email:c_Senha			:=  'treuio8765@!'	//"!senha@2015!" //'treuio8765@!'

	o_Email:cFrom			:= "totvsleste@totvs.com.br"
	o_Email:cTo				:= "eduardo.arcieri@totvs.com.br; francisco.ssa@totvs.com.br"
	o_Email:cCc				:= ""
	o_Email:cBcc			:= ""
	o_Email:cSubject		:= "Envio de email"
	o_Email:cBody			:= "Corpo de email"
	o_Email:a_Anexo			:= {"\system\pcomr003.html","\system\pedido_000040.pdf"}

	o_Email:c_SmtpServer	:= "mail.totvs.com.br"
	o_Email:n_PortSMTP		:= 587
	o_Email:mtdEnviaEmail()


Return()
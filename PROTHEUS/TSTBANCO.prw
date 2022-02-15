#include "topconn.ch"

User Function TSTBANCO()

	Local c_Table	:= ""
	Local cQry		:= ""
	Local c_Erro	:= ""

	memowrit("C:\TEMP\inicio.txt", "antes de qualquer coisa" )

	c_Table	:= "CREATE TABLE TMPSE5 ("
	c_Table	+= "E5_FILIAL varchar(6),"
	c_Table	+= "E5_NUMERO varchar(9),"
	c_Table	+= "E5_PREFIXO varchar(3),"
	c_Table	+= "E5_PARCELA varchar(2),"
	c_Table	+= "E5_TIPO varchar(3),"
	c_Table	+= "E5_CLIFOR varchar(6),"
	c_Table	+= "E5_LOJA varchar(2),"
	c_Table	+= "E5_DOCUMEN varchar(50),"
	c_Table	+= "E5_DATA varchar(8),"
	c_Table	+= "E5_VALOR float,"
	c_Table	+= "E5_TIPODOC	varchar	(2),"
	c_Table	+= "E5_SEQ	varchar (2),"
	c_Table	+= "E5_NATUREZ	varchar	(10),"
	c_Table	+= "E5_DTDIGIT	varchar	(8),"
	c_Table	+= "E5_HISTOR	varchar	(40),"
	c_Table	+= "E5_VRETPIS	float,"
	c_Table	+= "E5_VRETCOF	float,"
	c_Table	+= "E5_VRETCSL	float,"
	c_Table	+= "E5_VRETIRF	float,"
	c_Table	+= "E5_VRETISS	float,"
	c_Table	+= "FS_CHAVE varchar(40)"
    c_Table	+= ");"

    If TCSqlExec(c_Table) < 0
		c_Erro := TCSQLError()
		memowrit("C:\TEMP\TMPSE5.txt", c_Erro )
	EndIf

	c_Table	:= "CREATE TABLE TMPSE52 ("
	c_Table	+= "E5_FILIAL varchar(6),"
	c_Table	+= "E5_NUMERO varchar(9),"
	c_Table	+= "E5_PREFIXO varchar(3),"
	c_Table	+= "E5_PARCELA varchar(2),"
	c_Table	+= "E5_TIPO varchar(3),"
	c_Table	+= "E5_CLIFOR varchar(6),"
	c_Table	+= "E5_LOJA varchar(2),"
	c_Table	+= "E5_DOCUMEN varchar(50),"
	c_Table	+= "E5_DATA varchar(8),"
	c_Table	+= "E5_VALOR float,"
	c_Table	+= "E5_TIPODOC	varchar	(2),"
	c_Table	+= "E5_SEQ	varchar (2),"
	c_Table	+= "E5_NATUREZ	varchar	(10),"
	c_Table	+= "E5_DTDIGIT	varchar	(8),"
	c_Table	+= "E5_HISTOR	varchar	(40),"
	c_Table	+= "E5_VRETPIS	float,"
	c_Table	+= "E5_VRETCOF	float,"
	c_Table	+= "E5_VRETCSL	float,"
	c_Table	+= "E5_VRETIRF	float,"
	c_Table	+= "E5_VRETISS	float,"
	c_Table	+= "FS_CHAVE varchar(40)"
    c_Table	+= ");"

    If TCSqlExec(c_Table) < 0
		c_Erro := TCSQLError()
		memowrit("C:\TEMP\TMPSE52.txt", c_Erro )
	EndIf

	c_Table	:= "CREATE TABLE TMPSE53 ("
	c_Table	+= "E5_FILIAL varchar(6),"
	c_Table	+= "E5_NUMERO varchar(9),"
	c_Table	+= "E5_PREFIXO varchar(3),"
	c_Table	+= "E5_PARCELA varchar(2),"
	c_Table	+= "E5_TIPO varchar(3),"
	c_Table	+= "E5_CLIFOR varchar(6),"
	c_Table	+= "E5_LOJA varchar(2),"
	c_Table	+= "E5_DOCUMEN varchar(50),"
	c_Table	+= "E5_DATA varchar(8),"
	c_Table	+= "E5_VALOR float,"
	c_Table	+= "E5_TIPODOC	varchar	(2),"
	c_Table	+= "E5_SEQ	varchar (2),"
	c_Table	+= "E5_NATUREZ	varchar	(10),"
	c_Table	+= "E5_DTDIGIT	varchar	(8),"
	c_Table	+= "E5_HISTOR	varchar	(40),"
	c_Table	+= "E5_VRETPIS	float,"
	c_Table	+= "E5_VRETCOF	float,"
	c_Table	+= "E5_VRETCSL	float,"
	c_Table	+= "E5_VRETIRF	float,"
	c_Table	+= "E5_VRETISS	float,"
	c_Table	+= "FS_CHAVE varchar(40)"
    c_Table	+= ");"

    If TCSqlExec(c_Table) < 0
		c_Erro := TCSQLError()
		memowrit("C:\TEMP\TMPSE53.txt", c_Erro )
	EndIf

	c_Table	:= "CREATE TABLE TMPSE54 ("
	c_Table	+= "E5_FILIAL varchar(6),"
	c_Table	+= "E5_NUMERO varchar(9),"
	c_Table	+= "E5_PREFIXO varchar(3),"
	c_Table	+= "E5_PARCELA varchar(2),"
	c_Table	+= "E5_TIPO varchar(3),"
	c_Table	+= "E5_CLIFOR varchar(6),"
	c_Table	+= "E5_LOJA varchar(2),"
	c_Table	+= "E5_DOCUMEN varchar(50),"
	c_Table	+= "E5_DATA varchar(8),"
	c_Table	+= "E5_VALOR float,"
	c_Table	+= "E5_TIPODOC	varchar	(2),"
	c_Table	+= "E5_SEQ	varchar (2),"
	c_Table	+= "E5_NATUREZ	varchar	(10),"
	c_Table	+= "E5_DTDIGIT	varchar	(8),"
	c_Table	+= "E5_HISTOR	varchar	(40),"
	c_Table	+= "E5_VRETPIS	float,"
	c_Table	+= "E5_VRETCOF	float,"
	c_Table	+= "E5_VRETCSL	float,"
	c_Table	+= "E5_VRETIRF	float,"
	c_Table	+= "E5_VRETISS	float,"
	c_Table	+= "FS_CHAVE varchar(40)"
    c_Table	+= ");"

    If TCSqlExec(c_Table) < 0
		c_Erro := TCSQLError()
		memowrit("C:\TEMP\TMPSE54.txt", c_Erro )
	EndIf

	Alert("fim")

Return
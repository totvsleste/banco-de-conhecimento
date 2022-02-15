#include 'protheus.ch'
#include 'totvs.ch'

Class clsCamposComplementares

    DATA FILIAL AS STRING
    DATA ENTIDADE AS STRING
    DATA CAMPO_COMPLEMENTAR AS STRING
    DATA RECNO_ORIGEM AS INTEGER
    DATA CONTEUDO AS STRING

    Method new( c_Filial, c_Entidade, c_Campo, n_Recno ) Constructor

EndClass

Method new( n_Recno ) Class clsCamposComplementares

    SELECT


Return()

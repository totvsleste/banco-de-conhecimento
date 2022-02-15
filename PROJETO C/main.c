#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <locale.h> //biblioteca para localização
#include <string.h>


/*/
+---------------------------------------------------------------------------+
|Struct: ingresso | Autor: Francisco/Mario      |Criado em: novembro/2018   |
+---------------------------------------------------------------------------+
|Descricao: Estrutura das vendas                                            |
|                                                                           |
+---------------------------------------------------------------------------|
/*/
typedef struct ingresso{

	char nome[50];          //nome do cliente
	char data[9];           //data da peca
	char hora[9];           //hora da peca
	char descpeca[50];      //descricao da peca
	int peca;               //codigo da peca
	int idade;              //idade do cliente
	float preco;            //preco da peca
	float desconto;         //desconto adquirido
	float total;            //total
	int quantidade;         //quantidade de ingressos
	char *cadeiras;         //controle das cadeiras ocupadas
	
}ingresso;
/*/
+---------------------------------------------------------------------------+
|Struct: peca     | Autor: Francisco/Mario      |Criado em: novembro/2018   |
+---------------------------------------------------------------------------+
|Descricao: Estrutura das pecas                                             |
|                                                                           |
+---------------------------------------------------------------------------|
/*/
typedef struct peca{

	int codigo;             //codigo da peca
	char nome[50];          //nome da peca
	char hora[9];           //horario da peca
	float valor;            //valor da peca
	int ncadeiras;          //numero de cadeiras disponiveis
	int ocupadas;           //numero de cadeiras ocupadas
	int saldo;              //saldo de cadeiras disponiveis
	
}peca;
/*/
+---------------------------------------------------------------------------+
|Struct: cadeira  | Autor: Francisco/Mario      |Criado em: novembro/2018   |
+---------------------------------------------------------------------------+
|Descricao: Estrutura das cadeiras                                          |
|                                                                           |
+---------------------------------------------------------------------------|
/*/
typedef struct cadeira{

	int codigo;             //codigo da cadeira
	int codpeca;            //codigo da peca

}cadeira;


/*/
+---------------------------------------------------------------------------+
|Funcao:fValidaMenuPrincipal Autor: Francisco/Mario|Criado em:novembro/2018 |
+---------------------------------------------------------------------------+
|Descricao: Funcao para validar a escolha do usuário no menu principal      |
|                                                                           |
+---------------------------------------------------------------------------+
|Parametros: msg - mensagem solicitando a entrada                           |
+---------------------------------------------------------------------------+
|Retorna: inteiro, Opção escolhida no menu principal                        |
+---------------------------------------------------------------------------+
/*/
int fValidaMenuPrincipal(char *msg)
{
	int temp;
	char term;
	while(1)
	{
		printf("%s",msg);
		scanf("%d", &temp);
		getchar();
		if (temp == 1 || temp == 2 || temp== 3 || temp == 4 || temp == 10 )
			return temp;		
		else
		{
			printf("Opção inválida!!!\n");
		}
	}
}

/*/
+---------------------------------------------------------------------------+
|Funcao:fValidaNumeroVagas   Autor: Francisco/Mario|Criado em:novembro/2018 |
+---------------------------------------------------------------------------+
|Descricao: Funcao para validar o número de vagas de cada peça.             |
|           evita que o usuário digite um valor incorreto                   |
+---------------------------------------------------------------------------+
|Parametros: msg - mensagem solicitando a entrada                           |
+---------------------------------------------------------------------------+
|Retorna: inteiro, quantidade de vagas disponível na peça                   |
+---------------------------------------------------------------------------+
/*/
/* TODO (#1#): Necessário opção de saída ? Ex. 0 para sair. */
int fValidaNumeroVagas(char *msg)
{
	int temp;
	char term;
	while(1)
	{
		printf("%s",msg);
		scanf("%d", &temp);
		getchar();
		if (temp >= 1 && temp <= 10000)
			return temp;		
		else
		{
			printf("Valor inválido!!!\n");
		}
		
	}
}

/*/
+---------------------------------------------------------------------------+
|Funcao:fValidaValor   Autor: Francisco/Mario|Criado em:novembro/2018 |
+---------------------------------------------------------------------------+
|Descricao: Funcao para validar o valor digitado pelo usuário               |
|                                                                           |
+---------------------------------------------------------------------------+
|Parametros: msg - mensagem solicitando a entrada                           |
+---------------------------------------------------------------------------+
|Retorna: float, valor monetário                                            |
+---------------------------------------------------------------------------+
/*/
float fValidaValor(char *msg)
{
	int temp;
	char term;
	while(1)
	{
		printf("%s",msg);
		scanf("%d", &temp);
		getchar();
		if (temp >= 1 && temp <= 99999999)
			return temp;		
		else
		{
			printf("Valor inválido!!!\n");
		}		
	}
}



/*/
+---------------------------------------------------------------------------+
|Funcao:fValidaIdade   Autor: Francisco/Mario|Criado em:novembro/2018 |
+---------------------------------------------------------------------------+
|Descricao: Funcao para validar a idade digitda pelo usuario                |
|                                                                           |
+---------------------------------------------------------------------------+
|Parametros: msg - mensagem solicitando a entrada                           |
+---------------------------------------------------------------------------+
|Retorna: inteiro, idade informada pelo usuário                             |
+---------------------------------------------------------------------------+
/*/
int fValidaIdade(char *msg)
{
	int temp;
	char term;
	while(1)
	{
		printf("%s",msg);
		scanf("%d", &temp);
		getchar();
		if (temp >= 1 && temp <= 150)
			return temp;		
		else
		{
			printf("Valor inválido!!!\n");
		}
		
	}
}

int fValidaData( char *msg, struct ingresso *vendas, int *i )
{
	int dd, mm, aa;
	int numero=1;
	char cdia[2];
	char cmes[2];
	char cano[2];
	char cDataMontada[9];
	
	while(numero==1)
	{
		printf( "%s", msg );
		scanf("%d /%d /%d", &dd, &mm, &aa);
		getchar();
		
		//valida o ano
		if (aa >= 1900 && aa <= 9999)
		{
		    //valida mes
			if (mm >= 1 && mm <= 12)
			{
		        //valida o dia
		        if ((dd >= 1 && dd <= 31) && (mm == 1 || mm == 3 || mm == 5 || mm == 7 || mm == 8 || mm == 10 || mm == 12))
		           numero=2;

		        else if ((dd >= 1 && dd <= 30) && (mm == 4 || mm == 6 || mm == 9 || mm == 11))
              		numero=2;
              		
		        else if ((dd >= 1 && dd <= 28) && (mm == 2))
		            numero=2;
		            
		        else if (dd == 29 && mm == 2 && (aa % 400 == 0 || (aa % 4 == 0 && aa % 100 != 0)))
		        	numero=2;
		        	
		        else if (dd < 1 || dd > 31)
		        	printf("Dia inválido.\n");
		        	
				else if ((dd == 31 ) && (mm != 1 || mm != 3 || mm != 5 || mm != 7 || mm != 8 || mm != 10 || mm != 12))
					printf("Dia inválido.\n");
				else
					numero=2;
		    }
		    else
		    {
			   printf("Mês inválido.\n");
		    }
		}
		else
		{
		    printf("Ano inválido.\n");
		}
	}

	itoa( dd, cdia, 10);            						//converte o inteiro dia para string
	itoa( mm, cmes, 10);            						//converte o inteiro mes para string
	itoa( aa, cano, 10);            						//converte o inteiro ano para string
	strcat( cDataMontada, cdia );   						//concatena a data
	strcat( cDataMontada, "/" );    						//concatena a data
	strcat( cDataMontada, cmes );   						//concatena a data
	strcat( cDataMontada, "/" );    						//concatena a data
	strcat( cDataMontada, cano );   						//concatena a data
	strcpy( ( *( vendas + * i ) ).data, cDataMontada );     //copia a data concatenada para estrutura de vendas
}

/*/
+---------------------------------------------------------------------------+
|Funcao:fValidaInteiroPositivo Autor: Francisco/Mario|Criado em:novembro/2018 |
+---------------------------------------------------------------------------+
|Descricao: Funcao para validar a entrada de um valor positivo              |
|                                                                           |
+---------------------------------------------------------------------------+
|Parametros: msg - mensagem solicitando a entrada                           |
+---------------------------------------------------------------------------+
|Retorna: inteiro, valor digitado pelo usuário                              |
+---------------------------------------------------------------------------+
/*/
int fValidaInteiroPositivo(char *msg)
{
	int temp;
	char term;
	while(1)
	{
		printf("%s",msg);
		scanf("%d", &temp);
		getchar();
		if (temp >= 1 && temp <= 32767)
			return temp;		
		else
		{
			printf("Valor inválido!!!\n");
		}
		
	}
}

/*/
+---------------------------------------------------------------------------+
|Funcao: fAplicaDesconto | Autor: Francisco/Mario |Criado em: novembro/2018 |
+---------------------------------------------------------------------------+
|Descricao: Funcao responsavel por fazer o calculo do desconto              |
|                                                                           |
+---------------------------------------------------------------------------+
|Parametros: Par1 - Struct, Estrutura do Ingresso                           |
|            Par2 - Inteiro, posicao do cursor na estrutura                 |
+---------------------------------------------------------------------------+
|Retorna: Numeric, Valor do Desconto                                        |
+---------------------------------------------------------------------------+
/*/
float fAplicaDesconto( struct ingresso *vendas, int *i )
{
	float nPercDesc = 2;

	int nDiaSemana;
	int nInfIdade;
	
	char cProfPub[1];
	char cCriCarente[1];
	char cNome[50];
	char cEstudante[1];
	
	//verifica se a idade do cliente e menor que 1 ano
	//sendo, informa a classificacao indicativa da peca
	if ((*(vendas+*i)).idade <= 1)
	{
		printf("\n Idade digitada: %d. Classificacao Indicativa para maiores de 2 anos", nInfIdade);
	}

    //verifica se a idade do cliente esta entre 2 e 12 anos
    //sendo aplica desconto conforme regra
    //se for crianca desconto de 50%
    //se for crianca carente e a peca for na terca aplica desconto de 100%
	if ( ( ( *( vendas + * i ) ).idade >= 2 ) && ( ( *( vendas + * i ) ).idade <= 12 ) )
	{
		printf( "Criancas carente da rede publica de ensino (S=Sim/N=Nao): " );
		scanf( "%s", &cCriCarente );

 		if ( strcmp( cCriCarente, "S" ) == 0 )
		{
			printf( "Qual o dia da semana deseja assistir ao espetaculo (1=Domingo, 2=Segunda ... 7=Sabado)? " );
			scanf( "%d", &nDiaSemana );

			if ( nDiaSemana == 3 )
			{
		 	   nPercDesc = 1;
			}
		}
		else
		{
			nPercDesc = 0.50;
		}
 	}
	
	//Se idade entre 13 e 59 anos
	//verifica se professor de rede publica, sendo 50% de desconto
	//nao sendo professor, verifica se e estudante e aplica desconto de 50%
	if  ( ( ( *( vendas + * i ) ).idade >= 13) && ( ( ( *( vendas + * i ) ).idade <= 59)  ) )
	{
 	   printf( "Professor de rede publica de ensino (S=Sim/N=Nao): " );
	   scanf( "%s", &cProfPub );

	   if ( strcmp( cProfPub, "S") == 0)
	   {
		   nPercDesc = 0.50;
		}
	   	else
		{
			printf( "Estudante (S=Sim/N=Nao)? " );
	   		scanf( "%s", &cEstudante );
			if ( strcmp( cEstudante, "S" ) == 0 )
			{
				nPercDesc = 0.50;
			}
			else
			{
				nPercDesc = 0;
			}
		}
	}
	if ( ( *( vendas + * i ) ).idade >= 60)
	{
		nPercDesc = 0.50;
	}
	
	return nPercDesc;
}

/*/
+---------------------------------------------------------------------------+
|Funcao: fListarPecas    | Autor: Francisco/Mario |Criado em: novembro/2018 |
+---------------------------------------------------------------------------+
|Descricao: Funcao responsavel por listar as pecas cadastradas              |
|                                                                           |
+---------------------------------------------------------------------------+
|Parametros: Par1 - Struct, Estrutura do Pecas                              |
|            Par2 - Inteiro, Tamanho da estrutura                           |
+---------------------------------------------------------------------------+
|Retorna:                                                                   |
+---------------------------------------------------------------------------+
/*/
void fListarPecas( struct peca *pecas, int nTamPecas )
{
	int i=1;
	printf("+-----------------------------------------------------------------------+\n");
	if (nTamPecas>0)
	{
		for ( i=1; i<=nTamPecas; i++ )
		{
			printf("\n Código     : %d",( *( pecas + i ) ).codigo);
			printf("\n Nome       : %s",( *( pecas + i ) ).nome);
			printf("\n No Cadeiras: %d",( *( pecas + i ) ).ncadeiras);
			printf("\n Valor      : %.2f",( *( pecas + i ) ).valor);
			printf("\n Ocupadas   : %d",( *( pecas + i ) ).ocupadas);
			printf("\n Saldo      : %d",( *( pecas + i ) ).saldo);
			printf("\n +-----------------------------------------------------------------------+\n");
		}
	}
	else
	{
		printf("\n ****** Não há peças cadastradas ****** \n\n");
	}
}
/*/
+---------------------------------------------------------------------------+
|Funcao: fPrintRecibo    | Autor: Francisco/Mario |Criado em: novembro/2018 |
+---------------------------------------------------------------------------+
|Descricao: Funcao responsavel pela impressao do recibo                     |
|                                                                           |
+---------------------------------------------------------------------------+
|Parametros: Par1 - Struct, Estrutura da venda                              |
|            Par2 - Inteiro, Controle do cursor posicionado                 |
+---------------------------------------------------------------------------+
|Retorna:                                                                   |
+---------------------------------------------------------------------------+
/*/
void fPrintRecibo( struct ingresso *lotacao, int i )
{
	int j;
	int c=1;
	char *cPosCadeira;
	
	printf("Nome: %s \n", ( *( lotacao + i ) ).nome );
	printf("Idade: %d \n", ( *( lotacao + i ) ).idade );
	printf("Peça: %d \n", ( *( lotacao + i ) ).peca );
	printf("Descrição: %s \n", ( *( lotacao + i ) ).descpeca );
	printf("Data: %s \n", ( *( lotacao + i ) ).data );
	printf("Preço: %.2f \n", ( *( lotacao + i ) ).preco );
	printf("Desconto: %.2f \n", ( *( lotacao + i ) ).desconto );
	printf("Total: %.2f \n", ( *( lotacao + i ) ).total );
	printf("Quantidade: %d \n", ( *( lotacao + i ) ).quantidade );

	strcpy( cPosCadeira, ( *( lotacao + i ) ).cadeiras );


	for ( j=0; cPosCadeira[j] != '\0'; j++ )
	{
		printf("Cadeira %d: %c \n", c, cPosCadeira[j] );
		c++;
	}

}

/*/
+---------------------------------------------------------------------------+
|Funcao: fFechaCaixa     | Autor: Francisco/Mario |Criado em: novembro/2018 |
+---------------------------------------------------------------------------+
|Descricao: Funcao responsavel por imprimir todas as vendas do dia          |
|                                                                           |
+---------------------------------------------------------------------------+
|Parametros: Par1 - Struct, Estrutura do Vendas                             |
|            Par2 - Inteiro, Tamanho da estrutura de vendas                 |
+---------------------------------------------------------------------------+
|Retorna:                                                                   |
+---------------------------------------------------------------------------+
/*/
void fFechaCaixa( struct ingresso *vendas, int nTamStruct )
{
	
	int nCOO = rand() % 100000;
	char cData[9];
	char cHora[9];
	char cDescPeca[50];
	
	float nTotal = 0;
	float nPreco = 0;
	float nDesconto = 0;
	float nTotPeca = 0;
	
	int n = 0;
	
	_strdate( cData);
	_strtime( cHora );
	
	printf("+-----------------------------------------------------------------------+\n");
	printf("|                SGI - Sistema de Gestão de Ingressos                   |\n");
	printf("+-----------------------------------------------------------------------+\n");
	printf("|                      FECHAMENTO DE CAIXA                              |\n");
	printf("+-----------------------------------------------------------------------+\n");
	printf("|DATA/HORA: % 20s - %s    |CONTROLE: %d              |\n", cData, cHora, nCOO );
	printf("+-----------------------------------------------------------------------+\n");
	printf(" ITEM DESCRIÇÃO                             PREÇO DESCONTO   TOTAL       \n");
	printf("+-----------------------------------------------------------------------+\n");

	for ( n = 0; n < nTamStruct; n++ )
	{
		nPreco    = 0;
		nDesconto = 0;
		nTotPeca  = 0;
		
		nPreco    = ( *( vendas + n ) ).preco;
		nDesconto = ( *( vendas + n ) ).desconto;
		nTotPeca  = ( *( vendas + n ) ).total;
		strcpy( cDescPeca, ( *( vendas + n ) ).descpeca );
		
		nTotal    = nTotal    + ( *( vendas + n ) ).total;
		
		printf(" %03d  %s                        %.2f       %.2f     %.2f      \n", n, cDescPeca, nPreco, nDesconto, nTotPeca );
		
	}

	printf("+-----------------------------------------------------------------------+\n");
	printf("|TOTAIS                                                   |     %.2f|\n", nTotal);
	printf("+-----------------------------------------------------------------------+\n");

}
/*/
+---------------------------------------------------------------------------+
|Funcao: fGravaOcupacao  | Autor: Francisco/Mario |Criado em: novembro/2018 |
+---------------------------------------------------------------------------+
|Descricao: Funcao responsavel por gravar a ocupacao. Controle de saldo das |
|pecas                                                                      |
+---------------------------------------------------------------------------+
|Parametros: Par1 - Struct, Estrutura do Pecas                              |
|            Par2 - Inteiro, Codigo da Peca                                 |
|            Par3 - Inteiro, Tamanho da estrutura de pecas                  |
|            Par4 - Inteiro, Quantidade de cadeiras compradas               |
+---------------------------------------------------------------------------+
|Retorna: Numeric                                                           |
+---------------------------------------------------------------------------+
/*/
int fGravaOcupacao( struct peca *pecas, int nCodPeca, int nTamPecas, int nQuant )
{
	int i=1;

	for ( i=1; i<=nTamPecas; i++ )
	{
		if ( ( *( pecas + i ) ).codigo == nCodPeca )
		{
			//alem de atualizar as vagas disponiveis
			//atualiza o saldo
			( *( pecas + i ) ).ocupadas = ( *( pecas + i ) ).ocupadas + nQuant;
			( *( pecas + i ) ).saldo = ( *( pecas + i ) ).ncadeiras - ( *( pecas + i ) ).ocupadas;
		}
	}
	return 0;
}
/*/
+---------------------------------------------------------------------------+
|Funcao: fCadeiraOcupada | Autor: Francisco/Mario |Criado em: novembro/2018 |
+---------------------------------------------------------------------------+
|Descricao: Funcao responsavel por testar se a cadeira esta ocupada ou nao  |
|                                                                           |
+---------------------------------------------------------------------------+
|Parametros: Par1 - Struct, Estrutura das Cadeiras                          |
|            Par2 - Inteiro, Codigo da Cadeira                              |
|            Par3 - Inteiro, Codigo da Peca                                 |
|            Par4 - Inteiro, Tamanho da estrutura de cadeiras               |
+---------------------------------------------------------------------------+
|Retorna: Numeric, 1 cadeira ocupada, 0 cadeira livre                       |
+---------------------------------------------------------------------------+
/*/
int fCadeiraOcupada( struct cadeira *cadeiras, int nCodCadeira, int nPeca, int nTamCadeira )
{
	int i=1;
	
	if ( nCodCadeira >= 1 && nCodCadeira <= 9 )
	{
		for ( i=1; i<=nTamCadeira; i++ )
		{
			if ( ( ( *( cadeiras + i ) ).codigo == nCodCadeira ) && ( ( *( cadeiras + i ) ).codpeca == nPeca ) )
			{
				return 1;
			}
		}
	}
	else
	{
		printf("Informe as cadeiras de 1 a 9 \n");
		return 0;
	}
	return 0;
}

/*/
+---------------------------------------------------------------------------+
|Funcao: fExistPeca      | Autor: Francisco/Mario |Criado em: novembro/2018 |
+---------------------------------------------------------------------------+
|Descricao: Funcao responsavel por verificar se a peca existe. Atualiza o   |
|preco e o saldo da peca                                                    |
+---------------------------------------------------------------------------+
|Parametros: Par1 - Struct, Estrutura do Pecas                              |
|            Par2 - Inteiro, Codigo da Peca                                 |
|            Par3 - Inteiro, Tamanho da estrutura de pecas                  |
|            Par4 - Inteiro, Preco da peca                                  |
+---------------------------------------------------------------------------+
|Retorna: Numeric                                                           |
+---------------------------------------------------------------------------+
/*/
int fExistPeca( struct peca *pecas, int nCodPeca, int nTamPecas, float *nPreco, int *nTotVagas, char* cNomePeca[50] )
{
	int i=1;
	
	for ( i=1; i<=nTamPecas; i++ )
	{
		if ( ( *( pecas + i ) ).codigo == nCodPeca )
		{
			*nPreco = ( *( pecas + i ) ).valor;
			*nTotVagas = ( *( pecas + i ) ).saldo;
			*cNomePeca = ( *( pecas + i ) ).nome;
			return 1;
		}
	}
	return 0;
}
/*/
+---------------------------------------------------------------------------+
|Funcao: main            | Autor: Francisco/Mario |Criado em: novembro/2018 |
+---------------------------------------------------------------------------+
|Descricao: Funcao princiapl                                                |
|                                                                           |
+---------------------------------------------------------------------------+
|Parametros:                                                                |
+---------------------------------------------------------------------------+
|Retorna: Numeric                                                           |
+---------------------------------------------------------------------------+
/*/
int main(int argc, char *argv[]) {

	setlocale(LC_ALL, "Portuguese");//habilita a acentuação para o português

	float nVlrDesc;
	float nPreco;

	struct ingresso lotacao[99];
	struct peca pecas[3];
	struct cadeira cadeiras[99];

	int i = 0;          //Controla a estrutura de vendas
	int j = 1;
	int k = 0;
	int p = 1;          //Controla pecas
	int np = 0;         //Controla a quantidade de pecas
	int c = 0;          //Controla a cadeira
	int nc = 1;         //Controla a quantidade de cadeiras
	int nOpca;
	int nCodCadeira;    //Codigo da cadeira
	int nLotacao=0;
	int nVagas = 0;
	int nTotVagas;
	int nControl=0;
	int nTemPeca=0;
	int nData=0;
	
	char cImprime[1];
	char cHora[9] = "20:00";
	char cCadeiras[99];
	char cCadConv[99];
	char *cNomePeca[50];
	
	while ( nControl == 0 )

	{
		//Menu
		printf("+=======================================================================+\n");
		printf("|                SGI - Sistema de Gestão de Ingressos                   |\n");
		printf("+=======================================================================+\n");
		printf("|                       MENU - CONFIGURADOR                             |\n");
		printf("+=======================================================================+\n");
		printf("|10 = Cadastrar Peças                                                   |\n");
		printf("+=======================================================================+\n");
		printf("|                         MENU - USUÁRIO                                |\n");
		printf("+=======================================================================+\n");
		printf("|1 = Vendas        |2 = Listar Peças       |3 = Fechar Caixa            |\n");
		printf("+=======================================================================+\n");
		printf("|4 = Sair                                                               |\n");
		printf("+=======================================================================+\n");

		nOpca = fValidaMenuPrincipal("Escolha uma opção: ");
		fflush(stdin);

		switch (nOpca)
		{
			case 1:
			
			//Informe o nome do cliente
			printf( "Nome: " );
			scanf("%[^\n]", &lotacao[i].nome);
			fflush(stdin);
			
			//Informe a idade
			lotacao[i].idade = fValidaIdade("Idade: ");
		
			R_PECA: lotacao[i].peca = fValidaInteiroPositivo("Peça: ");

			nTotVagas = 0;
			nTemPeca = fExistPeca( pecas, lotacao[i].peca, np, &nPreco, &nTotVagas, cNomePeca );
			
			strcpy( lotacao[i].descpeca, *cNomePeca );
			
			if ( nTemPeca == 0 )
			{
				printf( "\n A peça %d não foi cadastrada! Pressione ESC para sair ou ENTER para continuar a venda para outra peça.", lotacao[i].peca );
				printf( "\n\n Em caso de dúvida, pressione ESC e em seguida escolha a opção 2 \n" );
				if(getch() == 27)
				{
					break;
				}
				else
				{
					goto R_PECA;
				}
				
			}
			
			nData = fValidaData("Informe a Data (DD/MM/AAAA): ", lotacao, &i);
			
			nVlrDesc = fAplicaDesconto( lotacao, &i );

			if (nVlrDesc==2)
			{
				printf("\n \n ***** Classificação Indicativa proibida para menores de 2 anos ***** ");
				break;
			}
			else
			
			REFAZ: printf( "Informe a quantidade de ingressos: " );
			scanf(" %d", &lotacao[i].quantidade);

			if (lotacao[i].quantidade == 0)
			{
				printf( "\n\n Venda CANCELADA com sucesso!!! \n \n" );
				break;
			}
			nLotacao=0;
			nLotacao = nLotacao + lotacao[i].quantidade;
			if ( nLotacao > nTotVagas )
			{
				nLotacao = nLotacao - lotacao[i].quantidade;
				nVagas = nLotacao - nTotVagas;
				printf( "\n Sala lotada. Existe(m) apenas %d", abs(nVagas) );
				printf( "\n\n Em caso de dúvida, pressione ESC e em seguida escolha a opção 2 \n" );
				if(getch() == 27)
				{
					break;
				}
				else
				{
					goto REFAZ;
				}
				
			}
			char cCadConv[50];
			for (c=1; c<=lotacao[i].quantidade; c++)
			{
				R_CADEIRA: printf( "Informe a cadeira %d: ",c );
				scanf(" %d", &nCodCadeira);
				
				if ( fCadeiraOcupada( cadeiras, nCodCadeira, lotacao[i].peca, nc ) == 1 )
				{
					printf("Cadeira ocupada!\n");
					goto R_CADEIRA;
				}
				else
				{
					cadeiras[c].codigo = nCodCadeira;
					cadeiras[c].codpeca = lotacao[i].peca;
					itoa( nCodCadeira, cCadeiras, 10);
					strcat( cCadConv, cCadeiras );
				}
				nc++;
			}
			
			lotacao[i].cadeiras = cCadConv;
			
			fGravaOcupacao( pecas, lotacao[i].peca, np, lotacao[i].quantidade );

			nPreco = nPreco * lotacao[i].quantidade;

			lotacao[i].preco = nPreco;
			lotacao[i].desconto = nVlrDesc*100;
			
			nPreco = nPreco - ( nPreco * nVlrDesc );
			lotacao[i].total = nPreco;
			
			printf("\n\n Valor final do ingresso: %f \n \n", nPreco);
			k++;
			
			printf("Deseja imprimir o recibo? ");
			scanf( "%s", cImprime );
			
			if ( strcmp( cImprime, "S") == 0)
			{
				system("cls");
				printf("+=======================================================================+\n");
				printf("|                SGI - Sistema de Gestão de Ingressos                   |\n");
				printf("+=======================================================================+\n");
				fPrintRecibo( lotacao, i );
				system("pause");
				break;
			}
			i++;
			break;

		case 2:
			system("cls");  //Limpa a tela
			printf("+=======================================================================+\n");
			printf("|                SGI - Sistema de Gestão de Ingressos                   |\n");
			printf("+=======================================================================+\n");
			
			fListarPecas( pecas, np );
			system("pause");
			break;
		case 3:
			system("cls");
			fFechaCaixa( lotacao, k );
			system("pause");
			break;
		case 4:
			nControl = 1;
			break;
		case 10:

		  		pecas[p].codigo = np + 1;
				printf("CÓDIGO DA PEÇA: %d \n", pecas[p].codigo);
				
				fflush(stdin);
				printf("Informe a descrição da peça: ");
				scanf("%[^\n]", &pecas[p].nome);
				fflush(stdin);

				pecas[p].ncadeiras = fValidaNumeroVagas("Informe o número de vagas: ");
				
				pecas[p].valor = fValidaValor("Informe o valor: ");
				
				pecas[p].saldo = pecas[p].ncadeiras;
				pecas[p].ocupadas = 0;
				
				p++;
				np++;
				
				printf("Peça cadastrada com SUCESSO!!! \n");
				break;
		}
		system("cls");  //Limpa a tela
		
	}
	
	
	return 0;
}

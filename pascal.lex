%option noyywrap

%{

#include <stdio.h>

int linhas = 0;

void imprimir(char *tipo_de_token);

void erro();

%}

%x COMENTARIO

espacos_em_branco [ \t]*
digitos           [0-9]
letras            [A-Za-z_]
letras_numeros    ({letras}|{digitos})
identificador     {letras}{letras_numeros}*
exponente         e[+-]?{digitos}+
inteiro           {digitos}+
real              ({inteiro}\.{inteiro}?|{inteiro}?\.{inteiro}){exponente}?
string            \"(\\.|[^\\"])*\"

%%

 /* Palavras reservadas */

absolute|array|begin|case|char|const|div|do|dowto|else|end|external|file|for|forward|func|function|goto|if|implementation|in|integer|interface|interrupt|label|main|nil|nit|of|packed|proc|program|real|record|repeat|set|shl|shr|string|then|to|type|unit|until|uses|var|while|with|xor|write|writeln|read {					 
                           imprimir("PALAVRARESERVADA");}

 /* Comentários */

"/*"                                            BEGIN(COMENTARIO);     
<COMENTARIO>([^*]|[\n]|(\*+([^*/]|[\n])))*      /* Consome o conteúdo do comentário */
<COMENTARIO>"*"+"/"                             BEGIN(INITIAL);

 /* Atribuição */

":="                       imprimir("ATRIBUICAO"); 

 /* Operadores lógicos */

and|or|not                 imprimir("OPERADORLOGICO");

 /* Operadores relacionais */

"="|">="|"<="|">"|"<"|"<>" imprimir("OPERADORRELACIONAL");

 /* Operadores aritméticos */

"+"|-|"*"|"/"|mod          imprimir("OPERADOR");

 /* Valores */

{inteiro}                  imprimir("NUMEROINTEIRO");
{real}                     imprimir("NUMEROREAL");
{string}                   imprimir("STRING");

 /* Identificadores (variáveis, nomes de programas, nomes de funções) */

{identificador}            imprimir("IDENTIFICADOR");

 /* Símbolos */

[=,;:()] 		           imprimir("SIMBOLOESPECIAL");

 /* Ponto final */

"."					       imprimir("FIM"); 

 /* Espaços */

{espacos_em_branco} 	   /* Espaços em branco são consumidos */

 /* Quebras de linhas são contadas para facilitar a identificação de tokens inválidos */

\n                         linhas++;

 /* Outros, gera erro */

.                          erro(); 

%%

void imprimir(char *tipo_de_token)
{
  printf("%s\t%s\n", yytext, tipo_de_token);
}

void erro() 
{
  printf("Erro na análise léxica do código fonte. O caractere %s na linha %d não é reconhecido.\n", yytext, linhas);
  exit(1);
}

int main(int argc, char *argv[])
{
	yyin = fopen(argv[1], "r");
	yylex();
	fclose(yyin);
	return 0;
}
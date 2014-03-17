%option noyywrap

%{

#include <stdio.h>

int linhas = 0;

%}

%x comentario

espacos_em_branco [ \t]*
digitos           [0-9]
letras            [A-Za-z_]
letras_numeros    ({letras}|{digitos})
identificador     {letras}{letras_numeros}*
exponente         e[+-]?{digitos}+
inteiro           {digitos}+
real              ({inteiro}\.{inteiro}?|{inteiro}?\.{inteiro}){exponente}?
string            \'([^'\n]|\'\')+\'|\"([^'\n]|\'\')+\"

%%

 /* Palavras reservadas */

absolute|array|begin|case|char|const|div|do|dowto|else|end|external|file|for|forward|func|function|goto|if|implementation|in|integer|interface|interrupt|label|main|nil|nit|of|packed|proc|program|real|record|repeat|set|shl|shr|string|then|to|type|unit|until|uses|var|while|with|xor|write|writeln|read					 printf("%s\tPALAVRARESERVADA\n", yytext);

 /* Comentários */

"/*"         			         BEGIN(comentario);     
<comentario>[^*\n]*        /* Tudo que não é nova linha e * */
<comentario>"*"+[^*/\n]*   /* * não seguidos por / */
<comentario>\n             linhas++;
<comentario>"*/"           BEGIN(INITIAL);

 /* Atribuição */

":="                 printf("%s\tATRIBUICAO\n", yytext);

 /* Operadores lógicos */

and|or|not           printf("%s\tOPERADORLOGICO\n", yytext);

 /* Operadores relacionais */

"="|">="|"<="|">"|"<"|"<>" printf("%s\tOPERADORRELACIONAL\n", yytext);

 /* Operadores aritméticos */

"+"|-|"*"|"/"|mod    printf("%s\tOPERADOR\n", yytext);

 /* Valores */

{inteiro}            printf("%s\tNUMEROINTEIRO\n", yytext);
{real}               printf("%s\tNUMEROREAL\n", yytext);
{string}             printf("%s\tSTRING\n", yytext);

 /* Identificadores (variáveis, nomes de programas, nomes de funções) */

{identificador}      printf("%s\tIDENTIFICADOR\n", yytext);

 /* Símbolos */

[=,;:()] 		         printf("%s\tSIMBOLOESPECIAL\n", yytext);

 /* Ponto final */

"."					         printf("%s\tFIM\n", yytext);

 /* Espaços em branco são consumidos */

{espacos_em_branco}

 /* Quebras de linhas são contadas para facilitar a identificação de tokens inválidos */

\n                   linhas++;

 /* Outros, gera erro */

.                    {printf("Erro na análise léxica do código fonte. O caractere %s na linha %d não é reconhecido.\n", yytext, linhas);exit(1);}

%%

int main(int argc, char *argv[]){
	yyin = fopen(argv[1], "r");
	yylex();
	fclose(yyin);
	return 0;
}

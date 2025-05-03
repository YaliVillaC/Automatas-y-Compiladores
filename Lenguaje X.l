%option noyywrap
%{
#include "y.tab.h"
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

extern YYSTYPE yylval;
%}

DIA    lunes|martes|miércoles|miercoles|jueves|viernes|sábado|sabado|domingo
MES    enero|febrero|marzo|abril|mayo|junio|julio|agosto|septiembre|octubre|noviembre|diciembre
NDIA   [0-9]+
HOR    [0-2]?[0-9]:[0-5][0-9]
CAD    \"[^"]+\"

%%

"evento"        { return EVENTO; }
"caso"          { return CASO; }
"en"            { return EN; }
"el"            { return EL; }
"de"            { return DE; }
"a"             { return A; }
"las"           { return LAS; }
"inicio"        { return INICIO; }
"fin"           { return FIN; }

{DIA}           { yylval.sval = strdup(yytext); return DIA_SEMANA; }
{MES}           { yylval.sval = strdup(yytext); return MES; }
{NDIA}          { yylval.ival = atoi(yytext); return NUM_DIA; }
{HOR}           { yylval.sval = strdup(yytext); return HORA; }
{CAD}           { 
                    yylval.sval = strdup(yytext + 1); 
                    yylval.sval[strlen(yylval.sval) - 1] = '\0'; 
                    return CADENA; 
                }

[ \t\n]+        ;  // Ignorar espacios y saltos
";"             { return PUNTOYCOMA; }
.               { return yytext[0]; }  // Cualquier otro símbolo

%%

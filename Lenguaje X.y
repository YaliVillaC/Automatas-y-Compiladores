%{
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
int yylex(void);
int yyerror(char *s);
struct Evento {
    char nombre[100];
    char dia_semana[15];
    int dia_num;
    char mes[15];
    char hora[6];
};

char *diaContext = NULL;
void guardarEvento(char *nombre, char *dia_semana, int dia_num, char *mes, char *hora);
void imprimirEventos();
int validarFecha(int dia, char *mes);

struct Evento eventos[100];
int eventoIndex = 0;
%}

%union {
    char *sval;
    int  ival;
}

%token <sval> CADENA DIA_SEMANA MES HORA
%token <ival> NUM_DIA
%token EVENTO CASO EN EL DE A LAS INICIO FIN PUNTOYCOMA

%%

programa:
    lista_eventos
;

lista_eventos:
    evento_simple lista_eventos
  | bloque_caso lista_eventos
  | /* vacío */
;

evento_simple:
    EVENTO CADENA EN DIA_SEMANA NUM_DIA DE MES A HORA PUNTOYCOMA {
        if (validarFecha($5, $7)) 
            guardarEvento($2, $4, $5, $7, $9);  // guardar evento
        else 
            printf("Fecha inválida: %d de %s\n", $5, $7);
    }
;

bloque_caso:
    CASO DIA_SEMANA INICIO {
        diaContext = $2;  // guardar el día de la semana
    } lista_eventos_caso FIN PUNTOYCOMA
;

lista_eventos_caso:
    evento_caso lista_eventos_caso
  | /* vacío */
;

evento_caso:
    EVENTO CADENA EL NUM_DIA DE MES A HORA PUNTOYCOMA {
        if (validarFecha($4, $6)) 
            guardarEvento($2, diaContext, $4, $6, $8);  // usar el díaContext
        else 
            printf("Fecha inválida: %d de %s\n", $4, $6);
    }
;

%%

void guardarEvento(char *nombre, char *dia_semana, int dia_num, char *mes, char *hora) {
    strcpy(eventos[eventoIndex].nombre, nombre);
    strcpy(eventos[eventoIndex].dia_semana, dia_semana);
    eventos[eventoIndex].dia_num = dia_num;
    strcpy(eventos[eventoIndex].mes, mes);
    strcpy(eventos[eventoIndex].hora, hora);
    eventoIndex++;
}

void imprimirEventos() {
    printf("\nEventos registrados:\n");
    for (int i = 0; i < eventoIndex; i++) {
        printf("- %s en %s %d de %s a las %s\n", eventos[i].nombre,
               eventos[i].dia_semana,
               eventos[i].dia_num,
               eventos[i].mes,
               eventos[i].hora);
    }
}

int validarFecha(int dia, char *mes) {
    if (dia < 1 || dia > 31) return 0;
    if (!strcmp(mes, "febrero")) return dia <= 29;
    if (!strcmp(mes, "abril") || !strcmp(mes, "junio") || !strcmp(mes, "septiembre") || !strcmp(mes, "noviembre")) return dia <= 30;
    return 1;
}

int main() {
    yyparse();
    imprimirEventos();
    return 0;
}

int yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
    return 0;
}

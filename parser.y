%{
#include <stdio.h>
int tipo;
extern int yylex();
void yyerror(char *s);
%}

%union{
    int tipo;
    char id[32];
    char cadena[100];
    int num;
}

 // Fecha: 23/05/2020
 // Autor: VMCR
 // Descripción: Declaración de los tokens para análisis sintáctico
 // Modificación: 24/05/20
 // Modificó: ULM, JRA, DAOA
%token<id>  ID
%token<num> NUM
%token<cadena> STRING
%token  START END
%token	INT FLOAT DOUBLE CHAR NS DEF STRUCT
%token	IF THEN ELSE WHILE DO SWITCH CASE DEFAULT BREAK
%token	PRINT SCAN RETURN PRED
%token AND OR NOT
%token TRUE FALSE
%token GREATER LESS LT GT NOTEQUAL EQUAL
%token POINT
%token COLON SEMICOLON COMMA
%left MOD PLUS MINUS MUL DIV  
%right ASSIGN
%nonassoc LPAR RPAR LSQBRACK RSQBRACK

%start programa

 // Fecha: 24/05/2020
 // Autor: VMCR
 // Descripción: Representación de la gramática
 // Modificación: 24/05/20
 // Modificó: ULM, JRA, DAOA, VMCR
%%

programa : declaraciones funciones;

declaraciones : tipo lista_var SEMICOLON declaraciones
            | tipo_registro lista_var SEMICOLON declaraciones
            | ;

tipo_registro : STRUCT START declaraciones END;

tipo : base tipo_arreglo;

base : INT
    | FLOAT
    | DOUBLE
    | CHAR
    | NS;

tipo_arreglo : LSQBRACK NUM RSQBRACK tipo_arreglo
            | ;

lista_var : lista_var COMMA ID
            | ID;      

funciones : DEF tipo ID LPAR argumentos RPAR START declaraciones sentencias END funciones
            | ;

argumentos : lista_arg
            | NS;

lista_arg : lista_arg COMMA arg
            | arg;

arg : tipo_arg ID;

tipo_arg : base param_arr;

param_arr : LSQBRACK RSQBRACK param_arr
            | ;

sentencias : sentencias sentencia
            |sentencia;

sentencia : IF e_bool THEN sentencia END
            | IF e_bool THEN sentencia ELSE sentencia END
            | WHILE e_bool DO sentencia END
            | DO sentencia WHILE e_bool SEMICOLON
            | SWITCH LPAR variable RPAR DO casos predeterminado END
            | variable ASSIGN expresion SEMICOLON
            | PRINT expresion SEMICOLON
            | SCAN variable SEMICOLON
            | RETURN SEMICOLON
            | RETURN expresion SEMICOLON
            | BREAK SEMICOLON
            | START sentencias END;

casos : CASE NUM COLON sentencia casos
	|CASE NUM COLON sentencia;

predeterminado : PRED COLON sentencia
                | ;

e_bool : e_bool OR e_bool
        | e_bool AND e_bool
        | NOT e_bool
        | LPAR e_bool RPAR
        | relacional
        | TRUE
        | FALSE;

relacional : relacional oprel relacional
            | expresion;

oprel : GREATER
    | LESS
    | GT
    | LT
    | NOTEQUAL
    | EQUAL;

expresion : expresion oparit expresion
            |expresion MOD expresion
            | LPAR expresion RPAR
            | ID
            | variable
            | NUM
            | STRING
            | CHAR
            | ID LPAR parametros RPAR;

oparit : PLUS
        | MINUS
        | MUL
        | DIV;

variable : dato_est_sim
        | arreglo;

dato_est_sim : dato_est_sim POINT ID
            | ID;

arreglo : ID LSQBRACK expresion RSQBRACK
        | arreglo LSQBRACK expresion RSQBRACK;

parametros : lista_param
            | ;

lista_param : lista_param COMMA expresion
            |expresion;

%%
/*Código de usuario, aquí se despliega un mensaje si se encuentra un error sintáctico*/
void yyerror(char *s){
    printf("Error sintáctico: %s\n");
}
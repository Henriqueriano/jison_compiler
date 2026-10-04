%lex

%%

\s+                           /* ignora espacos */
"//"[^\n]*                    /* comentario de uma linha */
"/*"[\s\S]*?"*/"              /* comentario de varias linhas */

"#"[ \t]*"include"[^\n]*                             return 'INCLUDE_LINE';
"#"[ \t]*"define"[ \t]+[a-zA-Z_][a-zA-Z0-9_]*[^\n]*  return 'DEFINE_LINE';

"auto"                        return 'AUTO';
"break"                       return 'BREAK';
"case"                        return 'CASE';
"char"                        return 'CHAR';
"const"                       return 'CONST';
"continue"                    return 'CONTINUE';
"default"                     return 'DEFAULT';
"do"                          return 'DO';
"double"                      return 'DOUBLE';
"else"                        return 'ELSE';
"enum"                        return 'ENUM';
"extern"                      return 'EXTERN';
"float"                       return 'FLOAT';
"for"                         return 'FOR';
"goto"                        return 'GOTO';
"if"                          return 'IF';
"int"                         return 'INT';
"long"                        return 'LONG';
"register"                    return 'REGISTER';
"return"                      return 'RETURN';
"short"                       return 'SHORT';
"signed"                      return 'SIGNED';
"sizeof"                      return 'SIZEOF';
"static"                      return 'STATIC';
"struct"                      return 'STRUCT';
"switch"                      return 'SWITCH';
"typedef"                     return 'TYPEDEF';
"union"                       return 'UNION';
"unsigned"                    return 'UNSIGNED';
"void"                        return 'VOID';
"volatile"                    return 'VOLATILE';
"while"                       return 'WHILE';

"_Bool"                       return 'BOOL';
"_Complex"                    return 'COMPLEX';
"_Imaginary"                  return 'IMAGINARY';
"inline"                      return 'INLINE';
"restrict"                    return 'RESTRICT';
"_Alignas"                    return 'ALIGNAS';
"_Alignof"                    return 'ALIGNOF';
"_Atomic"                     return 'ATOMIC';
"_Generic"                    return 'GENERIC';
"_Noreturn"                   return 'NORETURN';
"_Static_assert"              return 'STATIC_ASSERT';
"_Thread_local"               return 'THREAD_LOCAL';

0[xX][0-9a-fA-F]+             return 'INTEGER';
0[0-7]+                       return 'INTEGER';

([0-9]+"."[0-9]*|"."[0-9]+)([eE][+-]?[0-9]+)?[fFlL]?  return 'FLOAT_LITERAL';
[0-9]+[eE][+-]?[0-9]+[fFlL]?  return 'FLOAT_LITERAL';
[0-9]+                        return 'INTEGER';

\"(\\.|[^"\\])*\"             return 'STRING';
\'(\\.|[^'\\])\'              return 'CHAR_LITERAL';

">>="                         return 'RIGHT_SHIFT_ASSIGN';
"<<="                         return 'LEFT_SHIFT_ASSIGN';
"++"                          return 'INCREMENT';
"--"                          return 'DECREMENT';
"->"                          return 'ARROW';
"=="                          return 'EQUAL';
"!="                          return 'NOT_EQUAL';
"<="                          return 'LESS_EQUAL';
">="                          return 'GREATER_EQUAL';
"&&"                          return 'LOGICAL_AND';
"||"                          return 'LOGICAL_OR';
"+="                          return 'PLUS_ASSIGN';
"-="                          return 'MINUS_ASSIGN';
"*="                          return 'MULT_ASSIGN';
"/="                          return 'DIV_ASSIGN';
"%="                          return 'MOD_ASSIGN';
"&="                          return 'AND_ASSIGN';
"|="                          return 'OR_ASSIGN';
"^="                          return 'XOR_ASSIGN';
"<<"                          return 'LEFT_SHIFT';
">>"                          return 'RIGHT_SHIFT';
"..."                         return 'ELLIPSIS';

"+"                           return 'PLUS';
"-"                           return 'MINUS';
"*"                           return 'MULT';
"/"                           return 'DIV';
"%"                           return 'MOD';
"="                           return 'ASSIGN';
"<"                           return 'LESS';
">"                           return 'GREATER';
"!"                           return 'NOT';
"&"                           return 'BIT_AND';
"|"                           return 'BIT_OR';
"^"                           return 'BIT_XOR';
"~"                           return 'BIT_NOT';
"?"                           return 'QUESTION';
":"                           return 'COLON';

"("                           return 'LPAREN';
")"                           return 'RPAREN';
"{"                           return 'LBRACE';
"}"                           return 'RBRACE';
"["                           return 'LBRACKET';
"]"                           return 'RBRACKET';
";"                           return 'SEMICOLON';
","                           return 'COMMA';
"."                           return 'DOT';

[a-zA-Z_][a-zA-Z0-9_]*        return 'IDENTIFIER';

<<EOF>>                       return 'EOF';

.                             return 'INVALID';

/lex

%nonassoc IF_SEM_ELSE
%nonassoc ELSE

%start program

%%

program
    : statements EOF
        { return true; }
    ;

statements
    :
    | statements statement
    ;

statement
    : preprocessor_statement
    | function_definition
    | declaration
    | pointer_declaration
    | assignment
    | conditional
    | while_statement
    | do_while_statement
    | for_statement
    | return_statement
    | expression_statement
    | block
    ;

block
    : LBRACE statements RBRACE
        { console.log('[BLOCO] Bloco de codigo encontrado.'); }
    ;

preprocessor_statement
    : INCLUDE_LINE
        { console.log('[INCLUDE] Diretiva encontrada: ' + $1.trim()); }
    | DEFINE_LINE
        { console.log('[DEFINE] Diretiva encontrada: ' + $1.trim()); }
    ;

function_definition
    : type IDENTIFIER LPAREN parameter_list RPAREN block
        { console.log('[FUNCAO] Funcao ' + $2 + ' encontrada.'); }
    ;

parameter_list
    :
    | parameters
    ;

parameters
    : parameter
    | parameters COMMA parameter
    ;

parameter
    : type IDENTIFIER
    | type
    ;

type
    : INT
    | FLOAT
    | DOUBLE
    | CHAR
    | VOID
    | BOOL
    | LONG
    | SHORT
    | SIGNED
    | UNSIGNED
    ;

declaration
    : type IDENTIFIER SEMICOLON
        { console.log('[DECLARACAO] Variavel ' + $2 + ' declarada.'); }
    | type IDENTIFIER ASSIGN expression SEMICOLON
        { console.log('[DECLARACAO] Variavel ' + $2 + ' declarada e inicializada.'); }
    ;

pointer_declaration
    : type MULT IDENTIFIER SEMICOLON
        { console.log('[DECLARACAO] Ponteiro ' + $3 + ' declarado.'); }
    | type MULT IDENTIFIER ASSIGN expression SEMICOLON
        { console.log('[DECLARACAO] Ponteiro ' + $3 + ' declarado e inicializado.'); }
    ;

assignment
    : IDENTIFIER ASSIGN expression SEMICOLON
        { console.log('[ATRIBUICAO] Atribuicao para ' + $1 + '.'); }
    | IDENTIFIER PLUS_ASSIGN expression SEMICOLON
        { console.log('[ATRIBUICAO] Operador += encontrado.'); }
    | IDENTIFIER MINUS_ASSIGN expression SEMICOLON
        { console.log('[ATRIBUICAO] Operador -= encontrado.'); }
    | IDENTIFIER MULT_ASSIGN expression SEMICOLON
        { console.log('[ATRIBUICAO] Operador *= encontrado.'); }
    | IDENTIFIER DIV_ASSIGN expression SEMICOLON
        { console.log('[ATRIBUICAO] Operador /= encontrado.'); }
    ;

conditional
    : IF LPAREN comparison RPAREN statement %prec IF_SEM_ELSE
        { console.log('[IF] Estrutura condicional encontrada.'); }
    | IF LPAREN comparison RPAREN statement ELSE statement
        { console.log('[IF/ELSE] Estrutura condicional encontrada.'); }
    ;

while_statement
    : WHILE LPAREN comparison RPAREN statement
        { console.log('[WHILE] Estrutura de repeticao while encontrada.'); }
    ;

do_while_statement
    : DO statement WHILE LPAREN comparison RPAREN SEMICOLON
        { console.log('[DO-WHILE] Estrutura do-while encontrada.'); }
    ;

for_statement
    : FOR LPAREN for_init SEMICOLON comparison SEMICOLON for_increment RPAREN statement
        { console.log('[FOR] Estrutura de repeticao for encontrada.'); }
    ;

for_init
    :
    | IDENTIFIER ASSIGN expression
        { console.log('[FOR] Inicializacao encontrada.'); }
    | type IDENTIFIER ASSIGN expression
        { console.log('[FOR] Declaracao na inicializacao encontrada.'); }
    ;

for_increment
    : IDENTIFIER INCREMENT
        { console.log('[FOR] Incremento ++ encontrado.'); }
    | IDENTIFIER DECREMENT
        { console.log('[FOR] Decremento -- encontrado.'); }
    | assignment_expression
    ;

assignment_expression
    : IDENTIFIER ASSIGN expression
        { console.log('[ATRIBUICAO] Atribuicao encontrada.'); }
    | IDENTIFIER PLUS_ASSIGN expression
        { console.log('[ATRIBUICAO] += encontrado.'); }
    | IDENTIFIER MINUS_ASSIGN expression
        { console.log('[ATRIBUICAO] -= encontrado.'); }
    ;

return_statement
    : RETURN expression SEMICOLON
        { console.log('[RETURN] Comando return encontrado.'); }
    | RETURN SEMICOLON
        { console.log('[RETURN] Return vazio encontrado.'); }
    ;

comparison
    : expression EQUAL expression
        { console.log('[COMPARACAO] Operador == encontrado.'); }
    | expression NOT_EQUAL expression
        { console.log('[COMPARACAO] Operador != encontrado.'); }
    | expression LESS expression
        { console.log('[COMPARACAO] Operador < encontrado.'); }
    | expression GREATER expression
        { console.log('[COMPARACAO] Operador > encontrado.'); }
    | expression LESS_EQUAL expression
        { console.log('[COMPARACAO] Operador <= encontrado.'); }
    | expression GREATER_EQUAL expression
        { console.log('[COMPARACAO] Operador >= encontrado.'); }
    ;

expression
    : expression PLUS term
    | expression MINUS term
    | term
    ;

term
    : term MULT factor
    | term DIV factor
    | term MOD factor
    | factor
    ;

factor
    : INTEGER
    | FLOAT_LITERAL
    | CHAR_LITERAL
    | STRING
    | IDENTIFIER
    | function_call
    | sizeof_expression
    | LPAREN expression RPAREN
    ;

function_call
    : IDENTIFIER LPAREN arguments RPAREN
        {
            if ($1 === 'malloc') { console.log('[ALOCACAO] malloc() encontrado.'); }
            else if ($1 === 'calloc') { console.log('[ALOCACAO] calloc() encontrado.'); }
            else if ($1 === 'realloc') { console.log('[ALOCACAO] realloc() encontrado.'); }
            else if ($1 === 'free') { console.log('[DESALOCACAO] free() encontrado.'); }
        }
    ;

arguments
    :
    | argument_list
    ;

argument_list
    : expression
    | argument_list COMMA expression
    ;

sizeof_expression
    : SIZEOF LPAREN type RPAREN
        { console.log('[SIZEOF] sizeof() encontrado.'); }
    | SIZEOF LPAREN IDENTIFIER RPAREN
        { console.log('[SIZEOF] sizeof() encontrado.'); }
    ;

expression_statement
    : expression SEMICOLON
    | IDENTIFIER INCREMENT SEMICOLON
        { console.log('[INCREMENTO] Operador ++ encontrado.'); }
    | IDENTIFIER DECREMENT SEMICOLON
        { console.log('[DECREMENTO] Operador -- encontrado.'); }
    ;

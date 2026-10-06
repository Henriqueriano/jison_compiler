%lex


/* ---------- Definicoes regulares nomeadas (estilo Lex/Flex, aula 06) ---------- */
delim                       [ \t\r\n]
letter                      [a-zA-Z_]
digit                       [0-9]

%%

/* ---------- Espacos em branco e comentarios (nao retornam token) ---------- */
{delim}+                    {/* ignora espaco, tab e quebra de linha */}
"/*"[\s\S]*?"*/"            {/* comentario de bloco (uma ou mais linhas) */}
"//".*                      {/* comentario de linha */}

/* ---------- Palavras reservadas (ANSI C) ---------- */
"auto"                      {return 'AUTO';}
"break"                     {return 'BREAK';}
"case"                      {return 'CASE';}
"char"                      {return 'CHAR';}
"const"                     {return 'CONST';}
"continue"                  {return 'CONTINUE';}
"default"                   {return 'DEFAULT';}
"double"                    {return 'DOUBLE';}
"do"                        {return 'DO';}
"else"                      {return 'ELSE';}
"enum"                      {return 'ENUM';}
"extern"                    {return 'EXTERN';}
"float"                     {return 'FLOAT';}
"for"                       {return 'FOR';}
"goto"                      {return 'GOTO';}
"if"                        {return 'IF';}
"int"                       {return 'INT';}
"long"                      {return 'LONG';}
"register"                  {return 'REGISTER';}
"return"                    {return 'RETURN';}
"short"                     {return 'SHORT';}
"signed"                    {return 'SIGNED';}
"sizeof"                    {return 'SIZEOF';}
"static"                    {return 'STATIC';}
"struct"                    {return 'STRUCT';}
"switch"                    {return 'SWITCH';}
"typedef"                   {return 'TYPEDEF';}
"union"                     {return 'UNION';}
"unsigned"                  {return 'UNSIGNED';}
"void"                      {return 'VOID';}
"volatile"                  {return 'VOLATILE';}
"while"                     {return 'WHILE';}

/* ---------- Diretivas de pre-processador ---------- */
"include"                   {return 'INCLUDE';}
"define"                    {return 'DEFINE';}
"#"                         {return 'HASH';}

/* ---------- Literais: real ANTES de inteiro (maior prefixo) ---------- */
{digit}+"."{digit}+([eE][+-]?{digit}+)?   {return 'NUM_REAL';}
{digit}+[eE][+-]?{digit}+                 {return 'NUM_REAL';}
{digit}+                                  {return 'NUM_INTEIRO';}

/* ---------- String e caractere ---------- */
["]([^"\\]|\\.)*["]         {return 'STRING';}
[']([^'\\]|\\.)[']          {return 'CARACTERE';}

/* ---------- Operadores de 3 caracteres ---------- */
"<<="                       {return 'SHL_ASSIGN';}
">>="                       {return 'SHR_ASSIGN';}

/* ---------- Operadores de 2 caracteres ---------- */
"++"                        {return 'INC';}
"--"                        {return 'DEC';}
"->"                        {return 'ARROW';}
"<<"                        {return 'SHL';}
">>"                        {return 'SHR';}
"<="                        {return 'LE';}
">="                        {return 'GE';}
"=="                        {return 'EQ';}
"!="                        {return 'NE';}
"&&"                        {return 'AND';}
"||"                        {return 'OR';}
"+="                        {return 'PLUS_ASSIGN';}
"-="                        {return 'MINUS_ASSIGN';}
"*="                        {return 'MULT_ASSIGN';}
"/="                        {return 'DIV_ASSIGN';}
"%="                        {return 'MOD_ASSIGN';}
"&="                        {return 'AND_ASSIGN';}
"|="                        {return 'OR_ASSIGN';}
"^="                        {return 'XOR_ASSIGN';}

/* ---------- Operadores de 1 caractere ---------- */
"+"                         {return 'PLUS';}
"-"                         {return 'MINUS';}
"*"                         {return 'MULT';}
"/"                         {return 'DIV';}
"%"                         {return 'MOD';}
"="                         {return 'ASSIGN';}
"<"                         {return 'LT';}
">"                         {return 'GT';}
"!"                         {return 'NOT';}
"&"                         {return 'BAND';}
"|"                         {return 'BOR';}
"^"                         {return 'BXOR';}
"~"                         {return 'BNOT';}
"?"                         {return 'QUESTION';}
":"                         {return 'COLON';}

/* ---------- Separadores e delimitadores ---------- */
"."                         {return 'DOT';}
","                         {return 'COMMA';}
";"                         {return 'SEMI';}
"("                         {return 'LPAREN';}
")"                         {return 'RPAREN';}
"{"                         {return 'LBRACE';}
"}"                         {return 'RBRACE';}
"["                         {return 'LBRACK';}
"]"                         {return 'RBRACK';}

/* ---------- Identificadores: {letter} ({letter} | {digit})* ---------- */
{letter}({letter}|{digit})*  {return 'IDF';}

/* ---------- Erro lexico ---------- */
.                           { console.log('Erro lexico: caractere [' + yytext + '] nao reconhecido.'); }

<<EOF>>                     {return 'EOF';}

/lex

/* ---------- Precedencia e associatividade (menor -> maior) ----------
   NOELSE/ELSE: resolve o "dangling else" (else casa com o if mais
   proximo, via shift). */
%right      ASSIGN PLUS_ASSIGN MINUS_ASSIGN MULT_ASSIGN DIV_ASSIGN MOD_ASSIGN AND_ASSIGN OR_ASSIGN XOR_ASSIGN SHL_ASSIGN SHR_ASSIGN
%right      QUESTION COLON
%left       OR
%left       AND
%left       BOR
%left       BXOR
%left       BAND
%left       EQ NE
%left       LT GT LE GE
%left       SHL SHR
%left       PLUS MINUS
%left       MULT DIV MOD
%right      NOT BNOT
%right      UMINUS SIZEOF CAST
%left       INC DEC ARROW DOT LBRACK LPAREN

%nonassoc   NOELSE
%nonassoc   ELSE

%start programa

%%

/* ============ Unidade de compilacao ============ */

programa
    : lista_itens EOF
      { console.log(">> PROGRAMA reconhecido. Fim da analise sintatica."); return true; }
    ;

lista_itens
    : /* vazio */
    | lista_itens item
    ;

item
    : diretiva
    | funcao
    | comando
    ;

/* ============ Funcoes (definicao e prototipo) ============
   O enunciado foca em variaveis/controle, mas aceitamos a
   moldura da funcao (ex.: int main() { ... }) para rodar
   codigo C real. O corpo reusa a lista de comandos. */

funcao
    : tipo ponteiro_opt IDF LPAREN params_opt RPAREN bloco
      { console.log("FUNCAO: definicao de " + $3 + "()"); }
    | tipo ponteiro_opt IDF LPAREN params_opt RPAREN SEMI
      { console.log("FUNCAO: prototipo de " + $3 + "()"); }
    ;

params_opt
    : /* vazio */
    | lista_params
    ;

lista_params
    : param
    | lista_params COMMA param
    ;

param
    : tipo ponteiro_opt IDF dims_opt
      { console.log("  - parametro: " + $3); }
    | tipo ponteiro_opt
      { console.log("  - parametro (sem nome)"); }
    ;

/* ============ Diretivas de pre-processador ============ */

diretiva
    : HASH INCLUDE LT caminho_include GT
      { console.log("DIRETIVA: #include <...>"); }
    | HASH INCLUDE STRING
      { console.log("DIRETIVA: #include \"...\""); }
    | HASH DEFINE IDF NUM_INTEIRO
      { console.log("DIRETIVA: #define " + $3 + " " + $4); }
    | HASH DEFINE IDF NUM_REAL
      { console.log("DIRETIVA: #define " + $3 + " " + $4); }
    | HASH DEFINE IDF STRING
      { console.log("DIRETIVA: #define " + $3 + " <string>"); }
    | HASH DEFINE IDF CARACTERE
      { console.log("DIRETIVA: #define " + $3 + " <char>"); }
    ;

caminho_include
    : IDF
    | caminho_include DOT IDF
    | caminho_include DIV IDF
    ;

/* ============ Tipos e qualificadores ============ */

tipo
    : tipo_nucleo
    | modificador tipo
    | modificador            /* unsigned long, const, ... sem nucleo explicito */
    ;

/* nome de tipo com ponteiro, usado em cast e sizeof: (int *), (char **) */
nome_tipo
    : tipo ponteiro_opt
    ;

modificador
    : UNSIGNED | SIGNED | SHORT | LONG | CONST | VOLATILE
    | STATIC | EXTERN | REGISTER | AUTO
    ;

tipo_nucleo
    : INT | FLOAT | DOUBLE | CHAR | VOID
    | STRUCT IDF   { $$ = "struct " + $2; }
    | UNION  IDF   { $$ = "union " + $2; }
    | ENUM   IDF   { $$ = "enum "  + $2; }
    ;
/* Observacao: nomes de typedef (ex.: ULong) nao sao reconhecidos
   como tipo aqui, pois o lexer nao distingue typedef-name de IDF.
   Resolver isso exige a "lexer hack" (tabela de simbolos), tema da
   Parte 3. Declaracoes com typedef-name aparecem como expressao. */

/* ============ Comandos ============ */

bloco
    : LBRACE lista_comandos RBRACE
      { console.log("BLOCO { } reconhecido"); }
    ;

lista_comandos
    : /* vazio */
    | lista_comandos comando
    ;

comando
    : bloco
    | declaracao
    | def_tipo
    | expressao SEMI
      { console.log("COMANDO: expressao/atribuicao (;)"); }
    | SEMI
      { console.log("COMANDO: vazio (;)"); }
    | selecao_if
    | selecao_switch
    | repeticao_while
    | repeticao_do_while
    | repeticao_for
    | RETURN expressao SEMI
      { console.log("COMANDO: return <expressao>"); }
    | RETURN SEMI
      { console.log("COMANDO: return"); }
    | BREAK SEMI
      { console.log("COMANDO: break"); }
    | CONTINUE SEMI
      { console.log("COMANDO: continue"); }
    | GOTO IDF SEMI
      { console.log("COMANDO: goto " + $2); }
    ;

/* ============ Declaracoes ============ */

declaracao
    : tipo lista_declaradores SEMI
      { console.log("DECLARACAO de variavel(is)"); }
    | IDF lista_declaradores SEMI
      { console.log("DECLARACAO (tipo definido por typedef: " + $1 + ")"); }
    ;

lista_declaradores
    : declarador
    | lista_declaradores COMMA declarador
    ;

declarador
    : declarador_simples
    | declarador_simples ASSIGN inicializador
      { console.log("  - declarador COM inicializacao"); }
    ;

declarador_simples
    : ponteiro_opt IDF dims_opt
      { console.log("  - declarador: " + $2); }
    ;

ponteiro_opt
    : /* vazio */
    | ponteiro_opt MULT
    ;

dims_opt
    : /* vazio */
    | dims_opt LBRACK RBRACK                 /* int v[];  */
    | dims_opt LBRACK expressao RBRACK       /* int v[5]; int m[3][3]; */
    ;

inicializador
    : expressao
    | LBRACE lista_inicializadores RBRACE
      { console.log("  - inicializacao por lista { ... }"); }
    | LBRACE RBRACE
    ;

lista_inicializadores
    : inicializador
    | lista_inicializadores COMMA inicializador
    ;

/* ============ Selecao: if / else e switch ============ */

selecao_if
    : IF LPAREN expressao RPAREN comando            %prec NOELSE
      { console.log("SELECAO: if ( <cond> )"); }
    | IF LPAREN expressao RPAREN comando ELSE comando
      { console.log("SELECAO: if ( <cond> ) ... else ..."); }
    ;

selecao_switch
    : SWITCH LPAREN expressao RPAREN LBRACE lista_casos RBRACE
      { console.log("SELECAO: switch ( <expr> )"); }
    ;

lista_casos
    : /* vazio */
    | lista_casos caso
    ;

caso
    : CASE expressao COLON lista_comandos
      { console.log("  CASE <rotulo>:"); }
    | DEFAULT COLON lista_comandos
      { console.log("  DEFAULT:"); }
    ;

/* ============ Repeticao: while / do-while / for ============ */

repeticao_while
    : WHILE LPAREN expressao RPAREN comando
      { console.log("REPETICAO: while ( <cond> )"); }
    ;

repeticao_do_while
    : DO comando WHILE LPAREN expressao RPAREN SEMI
      { console.log("REPETICAO: do ... while ( <cond> )"); }
    ;

repeticao_for
    : FOR LPAREN for_init SEMI for_cond SEMI for_passo RPAREN comando
      { console.log("REPETICAO: for ( init ; cond ; passo )"); }
    ;

for_init
    : /* vazio */
    | tipo lista_declaradores   { console.log("  for-init: declaracao"); }
    | expressao
    ;

for_cond
    : /* vazio */
    | expressao
    ;

for_passo
    : /* vazio */
    | expressao
    ;

/* ============ struct / union / enum / typedef ============ */

def_tipo
    : STRUCT IDF LBRACE lista_membros RBRACE SEMI
      { console.log("DEFINICAO: struct " + $2); }
    | UNION IDF LBRACE lista_membros RBRACE SEMI
      { console.log("DEFINICAO: union " + $2); }
    | ENUM IDF LBRACE lista_enum RBRACE SEMI
      { console.log("DEFINICAO: enum " + $2); }
    | TYPEDEF tipo IDF SEMI
      { console.log("DEFINICAO: typedef -> " + $3); }
    ;

lista_membros
    : /* vazio */
    | lista_membros declaracao
    ;

lista_enum
    : IDF
    | IDF ASSIGN expressao
    | lista_enum COMMA IDF
    | lista_enum COMMA IDF ASSIGN expressao
    ;

/* ============ Expressoes (atribuicao inclusa como operador) ============ */

expressao
    : expressao ASSIGN expressao        { console.log("ATRIBUICAO: ="); }
    | expressao PLUS_ASSIGN expressao   { console.log("ATRIBUICAO: +="); }
    | expressao MINUS_ASSIGN expressao  { console.log("ATRIBUICAO: -="); }
    | expressao MULT_ASSIGN expressao   { console.log("ATRIBUICAO: *="); }
    | expressao DIV_ASSIGN expressao    { console.log("ATRIBUICAO: /="); }
    | expressao MOD_ASSIGN expressao    { console.log("ATRIBUICAO: %="); }
    | expressao AND_ASSIGN expressao    { console.log("ATRIBUICAO: &="); }
    | expressao OR_ASSIGN expressao     { console.log("ATRIBUICAO: |="); }
    | expressao XOR_ASSIGN expressao    { console.log("ATRIBUICAO: ^="); }
    | expressao SHL_ASSIGN expressao    { console.log("ATRIBUICAO: <<="); }
    | expressao SHR_ASSIGN expressao    { console.log("ATRIBUICAO: >>="); }
    | expressao QUESTION expressao COLON expressao   { console.log("EXPR: ?: (ternario)"); }
    | expressao OR  expressao        { console.log("EXPR: || (ou logico)"); }
    | expressao AND expressao        { console.log("EXPR: && (e logico)"); }
    | expressao BOR expressao        { console.log("EXPR: | (ou bit)"); }
    | expressao BXOR expressao       { console.log("EXPR: ^ (xor bit)"); }
    | expressao BAND expressao       { console.log("EXPR: & (e bit)"); }
    | expressao EQ expressao         { console.log("COMPARACAO: =="); }
    | expressao NE expressao         { console.log("COMPARACAO: !="); }
    | expressao LT expressao         { console.log("COMPARACAO: <");  }
    | expressao GT expressao         { console.log("COMPARACAO: >");  }
    | expressao LE expressao         { console.log("COMPARACAO: <="); }
    | expressao GE expressao         { console.log("COMPARACAO: >="); }
    | expressao SHL expressao        { console.log("EXPR: << (shift esq)"); }
    | expressao SHR expressao        { console.log("EXPR: >> (shift dir)"); }
    | expressao PLUS expressao       { console.log("EXPR: + (soma)"); }
    | expressao MINUS expressao      { console.log("EXPR: - (subtracao)"); }
    | expressao MULT expressao       { console.log("EXPR: * (multiplicacao)"); }
    | expressao DIV expressao        { console.log("EXPR: / (divisao)"); }
    | expressao MOD expressao        { console.log("EXPR: % (modulo)"); }
    | MINUS expressao  %prec UMINUS  { console.log("EXPR: - (menos unario)"); }
    | NOT expressao                  { console.log("EXPR: ! (nao logico)"); }
    | BNOT expressao                 { console.log("EXPR: ~ (nao bit)"); }
    | BAND expressao   %prec UMINUS  { console.log("EXPR: & (endereco-de)"); }
    | MULT expressao   %prec UMINUS  { console.log("EXPR: * (desreferencia)"); }
    | INC expressao                  { console.log("EXPR: ++x (pre-incremento)"); }
    | DEC expressao                  { console.log("EXPR: --x (pre-decremento)"); }
    | expressao INC                  { console.log("EXPR: x++ (pos-incremento)"); }
    | expressao DEC                  { console.log("EXPR: x-- (pos-decremento)"); }
    | SIZEOF LPAREN nome_tipo RPAREN      %prec SIZEOF { console.log("EXPR: sizeof(tipo)"); }
    | SIZEOF LPAREN expressao RPAREN %prec SIZEOF { console.log("EXPR: sizeof(expr)"); }
    | LPAREN nome_tipo RPAREN expressao   %prec CAST   { console.log("EXPR: cast (tipo)"); }
    | LPAREN expressao RPAREN        { console.log("EXPR: ( ... )"); }
    | IDF LPAREN lista_args_opt RPAREN
      {
          if ($1 === "malloc")     console.log("ALOCACAO: malloc(...)");
          else if ($1 === "free")  console.log("DESALOCACAO: free(...)");
          else                     console.log("CHAMADA: " + $1 + "(...)");
      }
    | expressao DOT IDF              { console.log("ACESSO: .campo (" + $3 + ")"); }
    | expressao ARROW IDF            { console.log("ACESSO: ->campo (" + $3 + ")"); }
    | expressao LBRACK expressao RBRACK { console.log("ACESSO: indexacao [ ]"); }
    | IDF                            { console.log("  operando: id (" + $1 + ")"); }
    | NUM_INTEIRO                    { console.log("  operando: inteiro (" + $1 + ")"); }
    | NUM_REAL                       { console.log("  operando: real (" + $1 + ")"); }
    | STRING                         { console.log("  operando: string"); }
    | CARACTERE                      { console.log("  operando: caractere"); }
    ;

lista_args_opt
    : /* vazio */
    | lista_args
    ;

lista_args
    : expressao
    | lista_args COMMA expressao
    ;

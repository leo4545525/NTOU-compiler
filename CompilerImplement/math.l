/* C Declarations */
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <math.h>
    #include <string.h>
    #include "math.tab.h"     // 用於 token 定義  
    extern YYSTYPE yylval;    // 為外部變數，用來保存語法分析器生成的 token 值。
%}

/* Token Definitions */


%%
"int"       { return INT; }
"float"     { return FLOAT; }
"char"      { return CHAR; }
[0-9]+      {
                yylval = atoi(yytext);
                return NUM;
            }
[a-zA-Z]    {
                yylval = *yytext - 'a';
                return VAR;
            }
[-+/*<>=,():;%^!] {
                yylval = yytext[0];
                return *yytext;
            }
"IF"        { return IF; }
"ELSE"      { return ELSE; }
"DOALLCASE" { return DOALLCASE; }
"CASE"      { return CASE; }
"{"         { return LB; }
"}"         { return RB; }
"print"     { return PRINT; }
"BREAK"     { return BREAK; }
"ARRAY"     { return ARRAY; }
"ISPRIME"   { return ISPRIME; }
"FACTORS"   { return FACTORS; }
[#].*       {
                ECHO; printf("\n");
            }

"root"      { return ROOT; }
[\n]*       { /* 忽略換行符 */ }
[\t]*       { /* 忽略tab */ }
[ ]*        { /* 忽略空格 */ }
.           { printf("%s --> Unknown Input\n", yytext); }

%%

int yywrap() // yylex 會調用 yywrap 來處理文件結尾的情況。
{
    return 1;
}

int main()
{
    freopen("input.txt", "r", stdin);
    freopen("output.txt", "w", stdout);
    yyparse(); // yyparse 負責語法分析，並在需要新的 token 時調用 yylex
    
    return 0;
}

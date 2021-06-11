%{
    #include<stdio.h>
	#include<string.h>
	#include<stdlib.h>
	#include<math.h>
	#include "chg.tab.h" 
	extern FILE *yyin;
	extern FILE *yyout;
%}

header "~include<...>"
digit  [0-9]
id     [a-z]
main   "principal()"


%%

{main}       { return MAIN_FUNC; }
"int"        { return INT; }
"float"      { return FLOAT; }
{id}         { yylval.itype = *yytext - 'a'; return VAR; }
"in"       { return INPUT; }
"out"      { return OUTPUT; }
"plus"          { return ADD; }
"minus"          { return SUB; }
"mul"          { return MUL; }
"div"          { return DIV; }
"^"          { return EXPONEN; }
"="          { return EQUALS; }
"lt"         { return LESS_THAN; }
"gt"         { return GREATER_THAN; }
"le"         { return LESS_EQUALS; }
"ge"         { return GREATER_EQUALS; }
"ne"         { return NE; }
","          { return COMA; }
"~"          { return SEMI; }
":"          { return COLON; }
"("          { return LFBR; }
")"          { return RFBR; }
"<"          { return LB; }
">"          { return RB; }
"sqr"        { return SQR; }
"cube"       { return CUBE; }
"sqrt"       { return SQRT; }
"sin"        { return SINE; }
"cos"        { return COSINE; }
"tan"        { return TANGENT; }
"ln"         { return LN; }
"fact"       { return FACTORIAL; }
"prime"      { return PRIME; }
"leap_year"  { return Leap_Year; }
"sum"  { return SUM_OF_NUMBERS; }
"even_odd"   { return EVEN_ODD; }
"if"         { return IF; }
"else"       { return ELSE; }
"elseif"     { return ELSEIF;}
"for"        { return FOR; }
"while"      { return WHILE; }
"switch"     { return SWITCH; }
"default"    { return DEFAULT; }
"-"?{digit}+ { yylval.dtype = atof(yytext); return NUM ; }
"-"?{digit}*[.][0-9]+ { yylval.dtype = atof(yytext); return NUM ; }
{header}     { fprintf(yyout,"This is a header file\n"); }
"ccmmnntt".*       { fprintf(yyout,"Single Line Comment\n"); }
"mult"[^@]+"cmnt"  { fprintf(yyout,"Multiline Comment\n"); }
[ \t\n]

%%

int main(void)
{
	yyin = fopen("input.txt","r");
	yyout = fopen("OUTPUT.txt","w");
	yyparse();
}

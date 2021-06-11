%{
    #include<stdio.h>
  #include<string.h>
  #include<stdlib.h>
  #include<math.h>
  #define PI 3.14159265
  extern FILE *yyin;
  extern FILE *yyout;
  int available[26],varcheck=0,switch_check=0;
  float var_switch;
  int ifval[1000];
  int ifptr = -1;
  int ifdone[1000];
  float value[1000];
%}

%union { 
  int itype;
  double dtype;   
}

%token <dtype> NUM
%token <itype> VAR
%type <dtype> TERM
%type <dtype> FACTOR
%type <dtype> DIGIT
%type <dtype> EXPRESSION
%type <dtype> STATEMENT
%type <dtype> LOOP
%type <dtype> istate

%token MAIN_FUNC INT FLOAT INPUT OUTPUT ADD SUB MUL DIV EXPONEN SQR SQRT CUBE SINE COSINE TANGENT LN EQUALS LESS_THAN GREATER_THAN LESS_EQUALS GREATER_EQUALS NE COMA SEMI COLON LFBR RFBR LB RB FACTORIAL Leap_Year PRIME EVEN_ODD SUM_OF_NUMBERS IF ELSE ELSEIF FOR WHILE SWITCH DEFAULT
%nonassoc IF
%nonassoc ELSE
%left LESS_THAN GREATER_THAN LESS_EQUALS GREATER_EQUALS
%left ADD SUB
%left MUL DIV
%left SQRT SQR CUBE
%left SINE COSINE TANGENT

%%
program:
    | MAIN_FUNC LB CSTATEMENT RB { fprintf(yyout,"Execution Done!\n"); }
    ; 
CSTATEMENT:
    | CSTATEMENT STATEMENT 
    | CSTATEMENT FUNCTIONS
    | CSTATEMENT LOOP
    | CSTATEMENT SWITCH_CASE
    | CSTATEMENT ifelse  
    | CSTATEMENT DECLARATION
    ;

STATEMENT:
     EXPRESSION SEMI        { 
                                $$ = $1;  
                                fprintf(yyout,"Value of expression : %.2f\n",$1);
                            }
    | VAR EQUALS EXPRESSION SEMI
                            {                             
                                if(available[$1] == 1)
                                {
                                    value[$1] = $3;
                  $$ = value[$1];
                                    fprintf(yyout,"%c assigned %.2f\n",$1+97,$3);
                                }
                else
                                  fprintf(yyout,"%c not declared\n",$1+97);
                }

    | INPUT VAR SEMI         {
                                printf("User Input for %c\n",$2+97);
                                if(available[$2] == 1) 
                                { 
                                    fprintf(yyout,"Value taken from user for %c\n",$2+97);
                                    float a;
                                    scanf("%f",&a);
                                    value[$2] = a;
                }
                else
                                    fprintf(yyout,"%c not declared\n",$2+97);
                            }
    | OUTPUT LFBR VAR RFBR SEMI 
                          { 
                                if(available[$3] == 1) 
                                    fprintf(yyout,"Value of %c is %.2f\n",$3+97,value[$3]);
                else
                                    fprintf(yyout,"%c not declared\n",$3+97);

                            }
  ;
FUNCTIONS:
      Leap_Year istate SEMI   {
                              int n = (int)$2;
                                if(((n%4 == 0) && (n%100 != 0)) || (n%400 == 0))
                                    fprintf(yyout,"%d leap year\n",n);
                                else
                                    fprintf(yyout,"%d not leap year\n",n);
                            } 
    | PRIME istate SEMI       {
                              int n = (int)$2;
                                int i,cnt=0;
                                for(i=2;i<n;i++)
                                {
                                    if(n%i == 0)
                                    {
                                        cnt=cnt+1;
                                        break;
                                    }
                                }
                                if(cnt==0 && $2 != 1)
                                    fprintf(yyout,"Yes! %d prime\n",n);
                                else
                                    fprintf(yyout,"No! %d not prime\n",n);
                            } 
    
    | SUM_OF_NUMBERS istate SEMI   {
                              int n = (int)$2;
                int sum = n*(n+1)/2;
                fprintf(yyout,"Summation of 1st %d numbers is %d\n",n,sum);
                          }
    | EVEN_ODD istate SEMI    {
                              int n = (int)$2;
                              if(n %2 == 0)
                    fprintf(yyout,"%d Even Number\n",n);
                else
                    fprintf(yyout,"%d Odd Number\n",n);
                          }
    ;
LOOP:
      FOR VAR EQUALS NUM LFBR NUM COMA NUM RFBR COLON istate SEMI
                          {
                  if(available[$2] == 1)
                                {
                    fprintf(yyout,"For loop Found\n");
                    if($4 <= $6)
                                    {
                      for(value[$2] = $4; value[$2] <= $6; value[$2] += $8)
                                            fprintf(yyout,"Value in for loop %.2f\n",$11);
                  }
                  else
                  {
                      for(value[$2] = $4; value[$2] > $6; value[$2] -= $6)
                                            fprintf(yyout,"Value in for loop: %.2f\n",$11);
                  }
                                }
                else
                                  fprintf(yyout,"%c not declared\n",$2+97); 
              }
  
  | WHILE VAR LESS_EQUALS NUM COLON istate SEMI
                            {
                  float a = value[$2];
                float b = $4;
                $$ = $6;
                if((available[$2] == 1) && (a <= b))
                {
                    fprintf(yyout,"While loop found & it works properly!\n");
                                    while(a <= b)
                                    {
                                        fprintf(yyout,"Value in while loop: %.2f\n",$$);
                                        a += 1;
                      if(a > b) break;
                                    }
                    value[$2] = a;
                }
                else
                    fprintf(yyout,"While loop found but either condition false or variable undeclared!\n");
                            }
   | WHILE VAR LESS_THAN NUM COLON istate SEMI
                            {
                  float a = value[$2];
                float b = $4;
                $$ = $6;
                if((available[$2] == 1) && (a < b))
                {
                    fprintf(yyout,"While loop found & it works properly!\n");
                                    while(a < b)
                                    {
                                        fprintf(yyout,"Value in while loop: %.2f\n",$$);
                                        a += 1;
                      if(a >= b) break;
                                    }
                    value[$2] = a;
                }
                else
                    fprintf(yyout,"While loop found but either condition false or variable undeclared!\n");
                            }                         
  | WHILE VAR GREATER_EQUALS NUM COLON istate SEMI
                            {
                  float a = value[$2];
                float b = $4;
                $$ = $6;
                if((available[$2] == 1) && (a >= b))
                {
                    fprintf(yyout,"While loop found & it works properly!\n");
                                    while(a >= b)
                                    {
                                        fprintf(yyout,"Value in while loop: %.2f\n",$$);
                                        a -= 1;
                      if(a < b) break;
                                    }
                    value[$2] = a;
                }
                else
                    fprintf(yyout,"While loop found but either condition false or variable undeclared!\n");
                            }
    | WHILE VAR GREATER_THAN NUM COLON istate SEMI
                            {
                  float a = value[$2];
                float b = $4;
                $$ = $6;
                if((available[$2] == 1) && (a > b))
                {
                    fprintf(yyout,"While loop found & it works properly!\n");
                                    while(a > b)
                                    {
                                        fprintf(yyout,"Value in while loop: %.2f\n",a);
                                        a -= 1;
                      if(a <= b) break;
                                    }
                    value[$2] = a;
                }
                else
                    fprintf(yyout,"While loop found but either condition false or variable undeclared!\n");
                            }
    ;
SWITCH_CASE : SWITCH LFBR expswitch RFBR LB CASE RB 
        ;

expswitch   :  EXPRESSION 
                    {
                        switch_check = 0;
                        var_switch = $1;
                    }
            ;


CASE    : /* empty */
                | CASE EXPRESSION COLON istate SEMI 
                    {
                        if($2 == var_switch){
                            fprintf(yyout,"Case Executed inside switch %f\n",$4);
                            switch_check = 1;
                        }                   
                    }
                | CASE DEFAULT COLON istate SEMI
                    {
                        if(switch_check == 0){
                            switch_check = 1;
                            fprintf(yyout,"Default Block executed and the value is %.2f\n",$4);
                        }
                    }
                ;     

        

ifelse  : IF LFBR ifexp RFBR LB istate SEMI RB elseif
                    {
                        if(ifdone[ifptr])
                        {
                          fprintf(yyout,"If block executed value inside %.2f\n",$6);
                        }
                        
                        ifdone[ifptr] = 0;
                        ifptr--;
                    }

        ;
ifexp   : EXPRESSION 
                    {
                        ifptr++;
                        ifdone[ifptr] = 0;
                        if($1)
                        {
                            ifdone[ifptr] = 1;
                        }
                        
                    }
        ;
elseif  : /* empty */
        | elseif ELSEIF LFBR EXPRESSION RFBR LB istate SEMI RB 
                    {
                        if($4 && ifdone[ifptr] == 0){
                            fprintf(yyout,"Else if block executed and value of expression %f\n",$4);
                            ifdone[ifptr] = 1;
                        }
                    }
        | elseif ELSE LB istate SEMI RB
                    {
                        if(ifdone[ifptr] == 0){
                            fprintf(yyout,"\nElse block executed\n value in side %.2f\n",$4);
                            ifdone[ifptr] = 1;
                        }
                    }
        
        ;
istate:
    EXPRESSION  { $$ = $1; }
  ;
DECLARATION:
    TYPE VARIABLE SEMI  { if(varcheck!=0) 
                          fprintf(yyout,"Variable declared\n");
            }
  ;
TYPE:
    FLOAT
  | INT
  ;
VARIABLE:
    VARIABLE COMA VAR   {
                          if(available[$3] == 1)
                            {
                  fprintf(yyout,"%c already declared\n",$3+97);
                varcheck =0;
                return 0;
              }
                            else
              {   available[$3] = 1;
                  varcheck=1;
              }
                        }
    | VAR             {
                            if(available[$1] == 1)
                            {
                  fprintf(yyout,"%c already declared\n",$1+97);
                varcheck = 0;
                return 0;
              }
                            else
              {
                  available[$1] = 1;
                varcheck = 1;
              }
                        }               
  ;
EXPRESSION:
      EXPRESSION ADD TERM { $$ = $1 + $3; }
    | EXPRESSION SUB TERM { $$ = $1 - $3; }
  | TERM                { $$ = $1; }
  ;
TERM:
     TERM MUL FACTOR      { $$ = $1 * $3; }
    | TERM DIV FACTOR     {
                             if($3) 
                                $$ = $1 / $3;
                             else 
                             { 
                                $$ = 0; 
                                fprintf(yyout,"Division by zero\n"); 
                             }
                          }
    | FACTOR              { $$ = $1; }
  ;
FACTOR: 
      DIGIT EXPONEN FACTOR    { $$ = powl($1,$3); }
  | DIGIT LESS_THAN FACTOR         { $$ = $1 < $3; }
    | DIGIT GREATER_THAN FACTOR         { $$ = $1 > $3; }
    | DIGIT LESS_EQUALS FACTOR         { $$ = $1 <= $3; }
    | DIGIT GREATER_EQUALS FACTOR         { $$ = $1 >= $3; }
  | DIGIT NE FACTOR         { $$ = $1 != $3; }
  | SQR DIGIT               { $$ = $2*$2; }
  | CUBE DIGIT              { $$ = $2*$2*$2; }
    | SQRT DIGIT              { $$ = sqrt($2); }
  | SINE DIGIT              { 
                           double x = $2;
                           double val = PI / 180;
                             double res = sin(x*val);
               $$ = res;
              }
  | COSINE DIGIT            { 
                           double x = $2;
               double val = PI / 180;
                             double res = cos(x*val);
               $$ = res;
              }
  | TANGENT DIGIT           { 
                           double x = $2;
                           double val = PI / 180;
                             double res = tan(x*val);
               $$ = res;
              }
  | LN DIGIT               { $$ =log($2); }
  | FACTORIAL DIGIT         {
                               int i,res = 1;
                               for(i=1;i<=$2;i++)
                                  res *= i;
                               $$ = res;
                          }
    | DIGIT                   { $$ = $1; }
  ;
DIGIT:  
    NUM                   { $$ = $1; }
    | VAR                 { 
                               if(available[$1] == 1) 
                                  $$ = value[$1];
              }
    |LFBR EXPRESSION RFBR { $$ = $2; }
    ; 
%%

int yywrap()
{
    return 1;
}
int yyerror(char *s) 
{
  fprintf(yyout,"%s\n",s);
  return(0);
}

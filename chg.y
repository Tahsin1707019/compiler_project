%{
    #include<stdio.h>
  #include<string.h>
  #include<stdlib.h>
  #include<math.h>
  #define PI 3.14159265
  extern FILE *yyin;
  extern FILE *yyout;
  int varcheck=0,switch_check=0;
  float var_switch;
  int ifval[1000];
  int ifptr = -1;
  int ifdone[1000];
  int ptr = 0;
  float value[1000];
  char varlist[1000][1000];

    float isdeclared(char str[]){
        int i;
        for(i = 0; i < ptr; i++){
            if(strcmp(varlist[i],str) == 0) return 1;
        }
        return 0;
    }
    /// if already declared return 0 or add new value and return 1;
    float addnewval(char str[],float val){
        if(isdeclared(str) == 1) return 0;
        strcpy(varlist[ptr],str);
        value[ptr] = val;
        ptr++;
        return 1;
    }

    ///get the value of corresponding string
    float getval(char str[]){
        int indx = -1;
        int i;
        for(i = 0; i < ptr; i++){
            if(strcmp(varlist[i],str) == 0) {
                indx = i;
                break;
            }
        }
        return value[indx];
    }
    float setval(char str[], float val){
        int indx = -1;
        int i;
        for(i = 0; i < ptr; i++){
            if(strcmp(varlist[i],str) == 0) {
                indx = i;
                break;
            }
        }
        value[indx] = val;

    }


%}

%union { 
  int itype;
  double dtype;
  char text[1000];   
}

%token <dtype> NUM

%type <dtype> TERM
%type <dtype> FACTOR
%type <dtype> DIGIT
%type <dtype> EXPRESSION
%type <dtype> STATEMENT
%type <dtype> LOOP
%type <dtype> istate
%type <text> ID

%token MAIN_FUNC INT FLOAT INPUT OUTPUT ADD SUB MUL DIV EXPONEN SQR SQRT CUBE SINE COSINE TANGENT LN EQUALS LESS_THAN GREATER_THAN LESS_EQUALS GREATER_EQUALS NE COMA ID SEMI COLON LFBR RFBR LB RB FACTORIAL Leap_Year PRIME EVEN_ODD SUM_OF_NUMBERS IF ELSE ELSEIF FOR WHILE SWITCH DEFAULT CHAR
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
    | CSTATEMENT ASSIGNMENT
    | CSTATEMENT print
    | CSTATEMENT scan
    ;

STATEMENT:
     EXPRESSION SEMI        { 
                                $$ = $1;  
                                fprintf(yyout,"Value of expression : %.2f\n",$1);
                            }
    

    
  ;

print       : OUTPUT LFBR ID RFBR SEMI 
                    {
                        if(!isdeclared($3)){
                            fprintf(yyout,"Compilation Error: Variable %s is not declared\n",$3);
                        }
                        else{
                            float v = getval($3);
                            fprintf(yyout," the value of %s is %f\n",$3,v);
                        }
                    }
            
            
            ;

scan        : INPUT LFBR ID RFBR SEMI
                    {
                       if(!isdeclared($3)){
                            fprintf(yyout,"Compilation Error: Variable %s is not declared\n",$3);
                        }
                        else{
                            float inp;
                            printf("enter value for %s\n",$3);
                            scanf("%f",&inp);
                            setval($3,inp);
                            fprintf(yyout,"value taken for %s and value is %f\n",$3,inp);
                        }
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
      FOR ID EQUALS NUM LFBR NUM COMA NUM RFBR COLON istate SEMI
                          {
                  if(isdeclared($2))
                                {
                    fprintf(yyout,"For loop Found\n");
                    float insidefor;
                    if($4 <= $6)
                                    {              
                      for(insidefor = $4; insidefor <= $6; insidefor += $8)
                                            fprintf(yyout,"Value in for loop %.2f\n",$11);
                  }
                  else
                  {
                      for(insidefor = $4; insidefor > $6; insidefor -= $6)
                                            fprintf(yyout,"Value in for loop: %.2f\n",$11);
                  }
                                }
                else
                                  fprintf(yyout,"%c not declared\n",$2+97); 
              }
  
  | WHILE ID LESS_EQUALS NUM COLON istate SEMI
                            {
                  float a = getval($2);
                float b = $4;
                $$ = $6;
                if((isdeclared($2)) && (a <= b))
                {
                    fprintf(yyout,"While loop found & it works properly!\n");
                                    while(a <= b)
                                    {
                                        fprintf(yyout,"Value in while loop: %.2f\n",$$);
                                        a += 1;
                      if(a > b) break;
                                    }
                    setval($2,a);
                }
                else
                    fprintf(yyout,"While loop found but either condition false or variable undeclared!\n");
                            }
   | WHILE ID LESS_THAN NUM COLON istate SEMI
                            {
                  float a = getval($2);
                float b = $4;
                $$ = $6;
                if((isdeclared($2)) && (a < b))
                {
                    fprintf(yyout,"While loop found & it works properly!\n");
                                    while(a < b)
                                    {
                                        fprintf(yyout,"Value in while loop: %.2f\n",$$);
                                        a += 1;
                      if(a >= b) break;
                                    }
                    setval($2,a);
                }
                else
                    fprintf(yyout,"While loop found but either condition false or variable undeclared!\n");
                            }                         
  | WHILE ID GREATER_EQUALS NUM COLON istate SEMI
                            {
                  float a = getval($2);
                float b = $4;
                $$ = $6;
                if((isdeclared($2)) && (a >= b))
                {
                    fprintf(yyout,"While loop found & it works properly!\n");
                                    while(a >= b)
                                    {
                                        fprintf(yyout,"Value in while loop: %.2f\n",$$);
                                        a -= 1;
                      if(a < b) break;
                                    }
                    setval($2,a);
                }
                else
                    fprintf(yyout,"While loop found but either condition false or variable undeclared!\n");
                            }
    | WHILE ID GREATER_THAN NUM COLON istate SEMI
                            {
                  float a = getval($2);
                float b = $4;
                $$ = $6;
                if((isdeclared($2)) && (a > b))
                {
                    fprintf(yyout,"While loop found & it works properly!\n");
                                    while(a > b)
                                    {
                                        fprintf(yyout,"Value in while loop: %.2f\n",a);
                                        a -= 1;
                      if(a <= b) break;
                                    }
                    setval($2,a);
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

DECLARATION : type variables SEMI 
            ;
type        : INT | FLOAT | CHAR 
            ;
variables   : variables COMA var 
            | var 
            ;
var    : ID    
                    {
                        //printf("%s\n",$1);
                        float x = addnewval($1,0);
                        fprintf(yyout,"variable %s declared nicely!!\n",$1);
                        if(!x) {
                            fprintf(yyout,"Compilation Error:Variable %s is already declared\n",$1);
                        }

                    }
            | ID EQUALS EXPRESSION SEMI  
                    {
                        //printf("%s %d\n",$1,$3);
                        float x = addnewval($1,$3);
                        if(!x) {
                            fprintf(yyout,"Compilation Error: Variable %s is already declared\n",$1);
                            }
                    }

            ;


ASSIGNMENT : ID EQUALS EXPRESSION SEMI  
                    {
                        if(!isdeclared($1)) {
                            fprintf(yyout,"Compilation Error: Variable %s is not declared\n",$1);
                            
                        }
                        else{
                            fprintf(yyout,"value set for %s\n",$1);
                            setval($1,$3);
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
    | ID                 {
                            if(!isdeclared($1))
                            {
                                fprintf(yyout,"Compilation Error: Variable %s is not declared\n",$1);
                            }
                            else
                            {
                                $$=getval($1);
                                //fprintf(yyout,"The value of %s is %f\n",$1,$$);
                            }
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

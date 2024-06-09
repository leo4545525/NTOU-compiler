%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include<math.h>
    int data[100];


%}

/* bison declarations */
%token    ROOT INT FLOAT CHAR NUM VAR IF ELSE DOALLCASE CASE LB RB PRINT BREAK ARRAY ISPRIME FACTORS 
%nonassoc ELSE
%nonassoc DOALLCASE
%nonassoc CASE

/*左結合*/
%left '>' '<'
%left '+' '-'
%left '*' '/'


/*bison grammers */
%%

program: ROOT ':' LB statements RB  {printf("主函式結束\n");}
        ;

statements: /*NULL*/
        |statements statement   //statements可以含多個statement，statements可以是一個或多個statement組成，也可以是空集合。
        ;

statement: ';'
        | declaration ';'       {printf("變數宣告\n");}
        | expression ';'        {printf("表示式的值: %d\n",$1); $$=$1;                        
                        }
        | VAR '=' expression ';'        {
                                        data[$1] = $3; 
					printf("結果:%d\t\n",$3);
					$$=$3;
                                        }
        | NUM '+''+'';'         {
                                printf("\n遞增前值: %d",$1 );
                                printf("\n遞增後值: %d\n",$1+1 );
                                $$=$1+1;
                        }
        | NUM '-''-'';'         {
                                printf("\n遞減前值: %d",$1 );
                                printf("\n遞減後值: %d\n\n",$1-1 );
                                $$=$1-1;
                        }
        | DOALLCASE '(' VAR ')' LB CS RB           
        | IF '(' expression ')' LB expression ';' RB    {
								if($3){
									printf("IF成立\n");
								}
								else {
									printf("IF不成立\n");
								}
							}
        | IF '(' expression ')' LB expression ';' RB ELSE LB expression ';' RB {
                                                                                if($3){
									        printf("IF成立\n");
								                }
								                else{
									        printf("ELSE成立\n");
								                }
                                                        }
        | ARRAY TYPE VAR '(' NUM ')' '=' NUM ';'        {
		                                printf("陣列宣告，把每個元素都設定成某個特定值\n");
		                                printf("陣列大小: %d\n",$5);
                                                int i=0;
                                                while(i<$5) {
                                                        printf("陣列 index = %d, 初始值 = %d\n",i,$8);
                                                        i++;
                                                }
	                                }
        | ISPRIME '(' NUM ')' ';'       {
                                        printf("\n檢查是否為質數\n");
                                        int i, flag = 0;
                                        for (i = 2; i <= $3 / 2; ++i) {
                                                if ($3 % i == 0) {
                                                flag = 1;
                                                break;
                                                }
                                        }
                                        if ($3 == 1) {
                                        printf("1是特例 非組合數也非質數\n");
                                        } 
                                        else {
                                                if (flag == 0)
                                                        printf("%d是質數\n", $3);
                                                else
                                                        printf("%d是組合數\n", $3);
                                        }
                                }
       
        | FACTORS '(' NUM ')' ';'       {
                                        int i;
                                        printf("\n找%d的質因數\n",$3);
                                        printf("%d的質因數有: ",$3);
                                        for (i = 1; i <= $3; ++i) {
                                                if ($3 % i == 0) {
                                                printf("%d  ", i);
                                                }
                                        }
                                        printf("\n\n");
                                }

        | PRINT '(' expression ')' ';'          {printf("call printf列印結果: %d\n\n",$3);}                  
        ; 

CS: C
        ;
C: C '+' C 
        | CASE NUM ':' expression ';' BREAK ';'         {}
        ;
declaration: TYPE ID1
        ;
TYPE: INT
        |FLOAT
        |CHAR
        ;
ID1: ID1 ',' VAR 
        |VAR 
        ;
expression: NUM				{ printf("\n數字為:%d\n",$1 ); $$ = $1;  }

	| VAR				{ $$ = data[$1]; }
	
	| expression '+' expression	{printf("\n兩數相加:%d+%d=%d \n",$1,$3,$1+$3 );  $$ = $1 + $3;}

	| expression '-' expression	{printf("\n兩數相減: %d-%d=%d \n",$1,$3,$1-$3); $$ = $1 - $3; }

	| expression '*' expression	{printf("\n兩數相乘: %d*%d \n",$1,$3,$1*$3); $$ = $1 * $3;}

	| expression '/' expression	{ if($3){
				     		printf("\n兩數相除:%d/%d \n",$1,$3,$1/$3);
				     		$$ = $1 / $3;
				     					
				  	}
				  	else{
						$$ = 0;
						printf("\n不能除以0\n\t");
				  	} 	
				}
	| expression '^' expression	{printf("\n次方:%d ^ %d \n",$1,$3,$1 ^ $3);  $$ = pow($1 , $3);}
	| expression '<' expression	{printf("\n小於功能:%d < %d \n",$1,$3,$1 < $3); $$ = $1 < $3 ; }
	
	| expression '>' expression	{printf("\n大於功能:%d > %d \n ",$1,$3,$1 > $3); $$ = $1 > $3; }
        | expression '=''=' expression  {
                                        
                                        printf("\n等於功能: %d == %d\n",$1,$4);
                                        $$ = $1 == $4;                                        
                                }
        | expression '!''=' expression  {
                                        
                                        printf("\n不等於功能: %d != %d\n",$1,$4);
                                        $$ = $1 != $4;                                        
                                }
	| '(' expression ')'		{$$ = $2; }
	;           	

%%

/*Additional C code*/

yyerror(char *s){    //called by yyparse on error
	printf( "%s\n", s);
}


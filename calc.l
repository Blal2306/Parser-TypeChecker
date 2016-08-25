%{
#include <stdio.h>
#include "calc.tab.h"
%}

digit	([0-9])

%%

"printvar"       {return(TOK_PRINTLN);
				  
				}

{digit}+	{
		sscanf(yytext, "%f", &yylval);
		return TOK_NUM;
		
		}
{digit}+"."{digit}*	{
			sscanf(yytext,"%f",&yylval);
			return TOK_FLOAT;
		}
"float" {
	return TOK_FLOAT_VAR;
		}
"int" {
	return TOK_INT_VAR;
}

[a-z][a-z0-9]* {
	sscanf(yytext,"%s",&yylval);
	return TOK_ID;
}
[0-9][a-z0-9]* {
	printf("%s\n","Parsing error: Line 2");
	exit(0);}

"=" {
	return TOK_EQUAL;
}
"main()" {
	return TOK_MAIN;
}
"{" {
	return OPEN_BRACKET;
}
"}" {
	return CLOSE_BRACKET;
}
[ \t\n]+ {   }

";"	{	return(TOK_SEMICOLON);	
	}

"+"	{	return(TOK_ADD);	
	}
"*"	{	return(TOK_MUL);	}
" " {    }
"-" {
	printf("%s\n","Parsing error : Line 1");
	exit(0);
}
"/" {
	printf("%s\n","Parsing error : Line 1");
	exit(0);
}

.	{
		
	}

%%


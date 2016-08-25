%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//STRUCTURE FOR THE DATA 
struct data_holder
	{
		char var_name[50];
		float var_value;
		int var_type;
	};
	
	//THIS WILL BE THE INDEX FOR THE ARRAY
	int it = 0;
	
	//THIS WILL HOLD THE DETAILS FOR ALL VARIABLES
	struct data_holder E[20];
	
%}

%token TOK_SEMICOLON TOK_ADD TOK_PRINTLN TOK_NUM TOK_EQUAL TOK_FLOAT_VAR TOK_INT_VAR CLOSE_BRACKET OPEN_BRACKET TOK_MAIN TOK_MUL

%union{
        float num_storage;
		float num_storage_float;
		char num_storage_id[50];
}
%type <num_storage> expr TOK_NUM
%token <num_storage_float> TOK_FLOAT
%token <num_storage_id> TOK_ID



%left TOK_ADD TOK_SUB
%left TOK_MUL TOK_DIV

%%
prog:
	TOK_MAIN OPEN_BRACKET stmts CLOSE_BRACKET
;
stmts:
	|
	stmt TOK_SEMICOLON stmts
;	
stmt: 
	TOK_INT_VAR TOK_ID
	{
		char temp[50];
		strcpy(temp, $2);
		
		strcpy(E[it].var_name,temp);
		E[it].var_type = 0;
		it++;
		
	}
	|
	TOK_FLOAT_VAR TOK_ID
	{
		char temp[50];
		strcpy(temp, $2);
		
		strcpy(E[it].var_name,temp);
		E[it].var_type = 1;
		it++;
	}
	|
	TOK_ID TOK_EQUAL expr
	{
		//search if token exist with that ID
		char temp[50];
		strcpy(temp, $1);
		
		int i;
		i = 0;
		int exist; //zero if doesn't exist
		exist = 0;
		int found_at; 
		found_at = 0;
		for(i = 0; i < 10; i++)
		{
			if(strcmp(E[i].var_name, temp) == 0)
			{
				found_at = i;
				exist = 1;
			}
		}
		//if the ID exist, assign it the value of the expression
		if(exist == 1)
		{
			
			//get the value from the expression
			int temp = $3;
			//if type don't match error
			if(E[found_at].var_type == E[temp].var_type)
			{
				float value = E[temp].var_value;
				E[found_at].var_value = value;
			}
			else{
				printf("Line 1: type error\n");
				exit(0);
			}
		}
		else
		{
			printf("Line 1: ");
			printf("%s", temp);
			printf(" is used but is not declared\n");
			exit(0);
		}
	}
	|
	TOK_PRINTLN expr
	{
		int iter = (int) $2;
		//get the type of the value
		int type = E[iter].var_type;
		//if float
		if(type == 1)
			printf("%g\n",E[iter].var_value);
		else
			printf("%d\n",(int)E[iter].var_value);
	}
;

expr: 	 
	expr TOK_ADD expr
	  {
		//get the value for the first variable
		int iter1 = (int) $1;
		int type1 = E[iter1].var_type;
		float val1 = E[iter1].var_value;
		
		//get the value for the first variable
		int iter2 = (int) $3;
		int type2 = E[iter2].var_type;
		float val2 = E[iter2].var_value;
		
		//if they are the same do the operation 
		//store them in a new location and send up the result
		if(type1 == type2)
		{
			float result;
			result = val1+val2;
			
			E[it].var_value = result;
			E[it].var_type = type1;
			
			$$ = it;
			it++;
		}
		else
		{
			printf("Line 1: type error\n");
			exit(0);
		}
	  }
	| expr TOK_MUL expr
	{
		//get the value for the first variable
		int iter1 = (int) $1;
		int type1 = E[iter1].var_type;
		float val1 = E[iter1].var_value;
		
		//get the value for the first variable
		int iter2 = (int) $3;
		int type2 = E[iter2].var_type;
		float val2 = E[iter2].var_value;
		
		//if they are the same do the operation 
		//store them in a new location and send up the result
		if(type1 == type2)
		{
			float result;
			result = val1*val2;
			
			E[it].var_value = result;
			E[it].var_type = type1;
			
			$$ = it;
			it++;
		}
		else
		{
			printf("Line 1: type error\n");
			exit(0);
		}
	}
	| TOK_NUM
	  { 	
		//assign iterator to this
		$$ = it;
		//add data to the data array
		E[it].var_value = $1;
		E[it].var_type = 0;
		//increment for next storage
		it++;
	  }
	  
	| TOK_FLOAT
	{
		//assign iterator to this
		$$ = it;
		//add data to the data array
		E[it].var_value = $1;
		E[it].var_type = 1; //STORE AS A FLOAT
		//increment for next storage
		it++;
	}
	
	| TOK_ID
	{
		char temp[50];
		strcpy(temp, $1);
		int i;
		i = 0;
		int exist; //zero if doesn't exist
		exist = 0;
		int found_at; 
		found_at = 0;
		for(i = 0; i < 10; i++)
		{
			if(strcmp(E[i].var_name, temp) == 0)
			{
				found_at = i;
				exist = 1;
			}
		}
		
		//if found, send the index out
		if(exist == 1)
			$$ = found_at;
		else
			undefined_id();
	}
	
;

%%

int yyerror(char *s)
{
	printf("syntax error\n");
	return 0;
}
int undefined_id()
{
	printf("Undefined variable\n");
	exit(0);
	return 0;
}

int main()
{
   yyparse();
   return 0;
}

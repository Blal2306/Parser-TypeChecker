
calc : lex.yy.c calc.tab.c
	gcc -o calc calc.tab.c lex.yy.c -lfl 
calc.tab.c : calc.y
	bison -dv calc.y
lex.yy.c : calc.l
	flex -l calc.l


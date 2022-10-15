yacc : yacc2.y yacc2.c yacc1.y yacc1.c
	yacc yacc2.y -o yacc2.c
	arm-linux-gnueabihf-gcc -o yacc2 yacc2.c -g
	
	yacc yacc1.y -o yacc1.c
	arm-linux-gnueabihf-gcc -o yacc1 yacc1.c -g 


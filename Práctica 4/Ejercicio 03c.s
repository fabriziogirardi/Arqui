		.data
A: 		.word 	1
B: 		.word 	3
C:		.word	0
 
		.code
		ld 		r1, A(r0)
		ld 		r2, B(r0)
loop: 	daddi 	r2, r2, -1
		dsll 	r1, r1, 1
		bnez 	r2, loop
		halt 

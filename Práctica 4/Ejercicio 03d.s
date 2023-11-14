		.data
A: 		.word 	1
B: 		.word 	3
C:		.word	0
 
		.code
		ld 		r1, A(r0)
		ld 		r2, B(r0)
		daddi	r3, r0, 0
loop: 	daddi 	r2, r2, -1
		dsll 	r1, r1, 1
		sd		r1, C(r3)
		daddi	r3, r3, 4
		bnez 	r2, loop
		halt 

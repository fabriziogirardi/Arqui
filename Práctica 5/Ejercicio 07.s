		.data
num:	.word	999
tabla:	.word	56,95,662,845,135,261,269
cant:	.word	7

		.code
		ld		$a0, num($0)
		daddi	$a1, $0, tabla
		ld		$a2, cant($0)
		jal		proce
		halt
		
proce:	daddi	$v0, $0, 0
		daddi	$t0, $a0, 0
		daddi	$t1, $a1, 0
		daddi	$t2, $a2, 0
		daddi	$t5, $0, 0
loop:	beqz	$t2, fin
		ld		$t6, ($t1)
		slt		$t5, $t6, $t0
		bnez	$t5, sig
		beq		$t6, $t0, sig
		daddi	$v0, $v0, 1
sig:	daddi	$t1, $t1, 8
		daddi	$t2, $t2, -1
		j		loop
fin:	jr		$ra
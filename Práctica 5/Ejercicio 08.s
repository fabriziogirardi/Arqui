		.data
cad1:	.asciiz	"estr es una cadena"
cad2:	.asciiz	"esto es una cadena"
pos:	.word	0

		.code
		daddi	$a0, $0, cad1
		daddi	$a0, $0, cad2
		jal		dif
		sd		$v0, pos($0)
		halt
		
dif:	dadd	$t0, $a0, $0
		dadd	$t1, $a1, $0
		daddi	$t2, $0, -1
		daddi	$t3, $0, 0
loop:	lbu		$t5, ($t0)
		beqz	$t5, fin
		lbu		$t6, ($t1)
		bne		$t5, $t6, encon
		daddi	$t0, $t0, 1
		daddi	$t1, $t1, 1
		daddi	$t3, $t3, 1
		j		loop
encon:	dadd	$v0, $0, $t3
fin:	jr		$ra

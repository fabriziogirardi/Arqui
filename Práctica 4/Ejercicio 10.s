		.data
cadena:	.asciiz	"esternocleidomastoideo"
car:	.asciiz	"i"
cant:	.word	0

		.code
		daddi	$t6, $0, 0
		lbu		$t0, cadena($t6)
		lbu		$t1, car($0)
		beqz	$t0, fin
		dadd	$t5, $0, $0
loop:	bne		$t0, $t1, seguir
		nop
		daddi	$t5, $t5, 1
seguir:	daddi	$t6, $t6, 1
		lbu		$t0, cadena($t6)
		nop
		bnez	$t0, loop
fin:	sd		$t5, cant($0)
		halt
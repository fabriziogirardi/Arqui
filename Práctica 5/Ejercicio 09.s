		.data
voc:	.asciiz	"aeiouAEIOU"
letra:	.ascii	"g"

		.code
		lbu		$a0, letra($0)
		jal		esvoc
		halt

esvoc: 	daddi	$t0, $0, 0
		daddi	$v0, $0, 0
loop:	lbu		$t1, voc($t0)
		beqz	$t1, fin
		beq		$t1, $a0, encon
		daddi	$t0, $t0, 1
		j		loop
encon:	daddi	$v0, $0, 1
fin:	jr		$ra
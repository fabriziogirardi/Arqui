		.data
voc:	.asciiz	"aeiouAEIOU"
frase:	.asciiz	"Esto es una frase"

		.code
		daddi	$a0, $0, frase
		jal		contar
		halt

contar:	daddi	$sp, $0, 0x400
		daddi	$sp, $sp, -24
		daddi	$v0, $0, 0
loop1:	sd		$v0, 16($sp)	
		sd		$ra, 8($sp)
		sd		$a0, 0($sp)
		lbu		$a0, ($a0)
		jal		esvoc
		dadd	$t0, $0, $v0
		ld		$v0, 16($sp)
		dadd	$v0, $v0, $t0
		ld		$a0, 0($sp)
		daddi	$a0, $a0, 1
		lbu		$t5, ($a0)
		ld		$ra, 8($sp)
		bnez	$t5, loop1
		daddi	$sp, $sp, 24
		jr		$ra

esvoc: 	daddi	$t0, $0, 0
		daddi	$v0, $0, 0
loop:	lbu		$t1, voc($t0)
		beqz	$t1, fin
		beq		$t1, $a0, encon
		daddi	$t0, $t0, 1
		j		loop
encon:	daddi	$v0, $0, 1
fin:	jr		$ra
		.data
ciclos:	.byte	140
cont:	.byte	0

		.code
		lbu		$t0, ciclos($0)
		lbu		$t1, cont($0)
		slti	$t5, $t0, 1
		dadd	$v0, $0, $0
		bnez	$t5, fin
		nop
loop:	daddi	$t0, $t0, -1
		daddi	$t1, $t1, 1
		bnez	$t0, loop
		daddi	$v0, $v0, 1
fin:	sd		$v0, cont($0)
		halt
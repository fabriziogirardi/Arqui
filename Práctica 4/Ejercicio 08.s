		.data
num1:	.byte	12
num2:	.byte	8
res:	.word	0

		.code
		lbu		$t0, num1($0)
		lbu		$t1, num2($0)
		dadd	$v0, $0, $0
		beqz	$t0, fin
		nop
		beqz	$t1, fin
		nop
loop:	daddi	$t1, $t1, -1
		dadd	$v0, $v0, $t0
		bnez	$t1, loop
fin:	sd		$v0, res($0)
		halt
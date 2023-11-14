		.data
tabla:	.byte	5, 9, 6, 3, 7, 9, 1, 6, 5, 3, 8, 5, 2, 9, 4, 6, 2, 0
cant:	.byte	0

		.code
		daddi	$a0, $0, tabla
		daddi	$v0, $0, 0
		jal		rut
		sd		$v0, cant($0)
		halt
		
rut:	daddi	$sp, $0, 0x400
		daddi	$sp, $sp, -24
loop:	sd		$ra, 0($sp)
		sd		$v0, 8($sp)
		sd		$a0, 16($sp)
		lbu		$a0, ($a0)
		beqz	$a0, fin
		jal		impar
		ld		$a0, 16($sp)
		dadd	$t0, $0, $v0
		ld		$v0, 8($sp)
		dadd	$v0, $v0, $t0
		ld		$ra, 0($sp)
		daddi	$a0, $a0, 1
		j		loop
fin:	ld		$a0, 16($sp)
		ld		$v0, 8($sp)
		ld		$ra, 0($sp)
		jr		$ra

impar:	andi	$v0, $a0, 1
		jr		$ra
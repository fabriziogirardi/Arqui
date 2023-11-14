		.data
A:		.byte	3
B:		.byte	3
C:		.byte	3

		.code
		lbu		$s0, A($0)
		lbu		$s1, B($0)
		lbu		$s2, C($0)
		daddi	$s3, $0, 0
		bne		$s0, $s1, dist_ab
		daddi	$s3, $s3, 2
		bne		$s1, $s2, fin
		daddi	$s3, $s3, 1
		j		fin
dist_ab: bne	$s0, $s2, dist_ac
		daddi	$s3, $s3, 2
		j		fin
dist_ac: bne	$s1, $s2, fin
		daddi	$s3, $s3, 2
fin:	halt
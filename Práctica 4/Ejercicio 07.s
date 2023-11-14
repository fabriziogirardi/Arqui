		.data
tabla:	.byte 	5, 6, 4, 9, 2, 5, 6, 8, 2, 6
comp:	.byte	4
cant:	.byte	0
res:	.byte	0

		.code
		daddi	$t0, $0, 0				; $t0 contador de desplazamiento en cero
		lbu		$s1, comp($0)			; numero para comparar
		daddi	$t1, $0, 10				; $t1 contador de 10 elementos
		daddi	$s3, $0, 0				; inicializo en 0 el recuento de elementos que cumplen la condicion
loop:	lbu		$s0, tabla($t0)			; cargo un dato de la tabla
		slt		$t2, $s1, $s0			; comparo si es mayor o no y seteo $t2
		daddi	$t1, $t1, -1			; resto 1 al contador
		dadd	$s3, $s3, $t2			; sumo $t0 (comparacion slt) al $s3 (recuento)
		sb		$t2, res($t0)			; guardo $t2 en res + desplazamiento
		daddi	$t0, $t0, 1				; incremento el desplazamiento
		bnez	$t1, loop				; mientras queden elementos, volver al loop
		sb		$s3, cant($0)			; guardo el resultado
		halt
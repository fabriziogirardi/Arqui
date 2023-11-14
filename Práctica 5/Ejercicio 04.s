		.data
peso:	.double	78.5
altura:	.double	1.68
imc:	.double	0.0
estado:	.byte	0
infra:	.double	18.5
norm:	.double	25
sobre:	.double	30

		.code
		l.d		f1, altura($0)
		l.d		f0, peso($0)
		mul.d	f2, f1, f1
		l.d		f10, infra($0)
		l.d		f11, norm($0)
		l.d		f12, sobre($0)
		div.d	f3, f0, f2
		s.d		f3, imc($0)
		c.lt.d	f3, f10
		bc1f	j_norm
		daddi	$t0, $0, 1
		j		fin
j_norm:	c.lt.d	f3, f11
		bc1f	j_sobre
		daddi	$t0, $0, 2
		j		fin
j_sobre: c.lt.d	f3, f12
		bc1f	j_obe
		daddi	$t0, $0, 3
		j		fin
j_obe:	daddi	$t0, $0, 4
fin:	sb		$t0, estado($0)
		halt
		.data
base:	.double	5.85
altura:	.double	13.47
div:	.double	2.0
res:	.double	0.0

		.code
		l.d		f0, base($0)
		l.d		f1, altura($0)
		l.d		f2, div($0)
		mul.d	f3, f1, f0
		div.d	f3, f3, f2
		s.d		f3, res($0)
		halt
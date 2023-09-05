        org 1000h
primero db 00h                    ; Primer carácter a mostrar

        org 2000h
        mov bx, offset primero    ; Muevo el primer elemento a mostrar
        mov al, 1                 ; Quiero mostrar solo 1 elemento

mostrar:inc primero               ; Incremento primero
        int 7                     ; Interrumpo para mostrar
        cmp byte ptr [bx], 0ffh   ; Comparo con 0ffh
        jnz mostrar               ; Mientras no haya flag zero, salto al loop
        hlt
        end
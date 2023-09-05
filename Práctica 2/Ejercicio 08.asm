        org 1000h
msj_1   db "Ingrese numeros a resta"
msj_1_f db ?
msj_2   db "Primer numero: "
msj_2_f db ?
msj_3   db "Segundo numero: "
msj_3_f db ?
msj_4   db "Resultado de la resta: "
msj_4_f db ?
enter   db 0ah

        org 1500h
num_1   db ?
num_2   db ?
resul   db ?
resul_2 db ?

       org 3000h
leer:  push bx
       push ax
       push cx
       push dx
       mov bx, offset msj_1
       mov al, offset msj_1_f - offset msj_1
       int 7
       call rn
       mov bx, offset msj_2
       mov al, offset msj_2_f - offset msj_2
       int 7
       mov bx, offset num_1
       int 6
       mov al, 1
       int 7
       call rn
       mov bx, offset msj_3
       mov al, offset msj_3_f - offset msj_3
       int 7
       mov bx, offset num_2
       int 6
       mov al, 1
       int 7
       call rn
       pop dx
       pop cx
       pop ax
       pop bx
       ret

       org 3500h
restar:push bx
       mov bx, offset num_1
       push ax
       push cx
       push dx
       mov ax, [bx]
       sub ah, 30h
       sub al, 30h
       sub al, ah
       js nega
       add al, 30h
       mov resul, 00h
       mov resul_2, al
       jmp salir
nega:  mov resul, 2dh
       neg al
       add al, 30h
       mov resul_2, al
salir: pop dx
       pop cx
       pop ax
       pop bx
       ret

       org 4000h
mostrar:push bx
       push ax
       push cx
       push dx
       mov bx, offset msj_4
       mov al, offset msj_4_f - offset msj_4
       int 7
       cmp resul, 2dh
       jnz uno_solo
       jmp los_dos
uno_solo:mov bx, offset resul_2
       mov al, 1
       jmp ver
los_dos:mov bx, offset resul
       mov al, 2
ver:   int 7
       pop dx
       pop cx
       pop ax
       pop bx
       ret

       org 4500h
rn:    push bx
       push ax
       push cx
       push dx
       mov bx, offset enter
       mov al, 1
       int 7
       pop dx
       pop cx
       pop ax
       pop bx
       ret

       org 2000h
       call leer
       call restar
       call mostrar
       int 0
       end
        org 1000h
num_1   db 34h
num_2   db 39h
num_3   db 33h
num_4   db 37h
msj_1   db "Ingrese la clave: "
msj_1_f db ?
msj_2   db "Acceso permitido"
msj_2_f db ?
msj_3   db "Acceso denegado"
msj_3_f db ?
enter   db 0ah

        org 1500h
num_1_l db ?
num_2_l db ?
num_3_l db ?
num_4_l db ?

       org 3000h
leer:  push bx
       push ax
       push cx
       push dx
       mov bx, offset msj_1
       mov al, offset msj_1_f - offset msj_1
       int 7
       call rn
       mov cl, 4
       mov bx, offset num_1_l
rep:   int 6
       inc bx
       dec cl
       cmp cl, 0
       jnz rep
       pop dx
       pop cx
       pop ax
       pop bx
       ret

       org 3500h
entrar:push bx
       push ax
       push cx
       push dx
       mov al, num_1
       cmp al, num_1_l
       jnz err
       mov al, num_2
       cmp al, num_2_l
       jnz err
       mov al, num_3
       cmp al, num_3_l
       jnz err
       mov al, num_4
       cmp al, num_4_l
       jnz err
       mov bx, offset msj_2
       mov al, offset msj_2_f - offset msj_2
       jmp impr
err:   mov bx, offset msj_3
       mov al, offset msj_3_f - offset msj_3
impr:  int 7
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
       call entrar
       int 0
       end
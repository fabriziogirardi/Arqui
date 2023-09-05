        org 1000h
msj     db "INGRESE UN NUMERO: "
fin     db ?

        org 1500h
num     db ?

       org 3000h
es_num:cmp byte ptr [bx], 30h
       js no_num
       cmp byte ptr [bx], 40h
       jns no_num
       mov dx, 00h
       jmp salir
no_num:mov dx, 0ffh
salir: ret

       org 2000h
       mov bx, offset msj
       mov al, offset fin - offset msj
       int 7
       mov bx, offset num
       int 6
       call es_num
       mov al, 1
       int 7
       mov cl, num
       int 0
       end
        org 1000h
msj     db "INGRESE UN NUMERO: "
fin     db ?

        org 1500h
num     db ?

        org 2000h
        mov bx, offset msj
        mov al, offset fin - offset msj
        int 7
        mov bx, offset num
        int 6
        mov al, 1
        int 7
        mov cl, num
        int 0
        end
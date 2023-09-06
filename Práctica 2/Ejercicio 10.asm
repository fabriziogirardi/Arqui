pic       equ 20h
pic_imr   equ 21h
pic_int0  equ 24h

          org 40
          dw frenar

          org 1000h
numero    db ?
min_letra db 41h
max_letra db 5ah

          org 2000h
          cli
          mov al, 0feh
          out pic_imr, al
          mov al, 10
          out pic_int0, al
          sti
          mov al, min_letra
sig_letra: cmp al, max_letra
          jz reiniciar
          inc al
          jmp sig_letra
reiniciar: mov al, min_letra
          jmp sig_letra
        
          org 2800h
fin_int:  push ax
          mov al, pic
          out pic, al
          pop ax
          ret
          
          org 2900h
mostrar:  push bx
          mov bx, offset numero
          push ax
          mov al, 1
          int 7
          pop ax
          pop bx
          ret

          org 3000h
frenar:   mov numero, al
          call mostrar
          call fin_int
          iret

end
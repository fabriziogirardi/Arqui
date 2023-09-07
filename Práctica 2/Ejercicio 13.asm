timer         equ 10h
pic           equ 20h

int_clk       equ 10

              org 40
              dw call_clock                 ; etiqueta de la direccion para controlar la interrupción 10 del vector

              org 1000h
clear_screen  db 0ch
min           db 30h, 30h                   ; minutos
              db 3ah                        ; dos puntos
seg           db 30h, 30h                   ; segundos


              org 2000h
              cli
              mov al, 0fdh
              out pic+1, al
              mov al, int_clk
              out pic+5, al
              mov al, 0
              out timer, al
              mov al, 1
              out timer+1, al
              mov bx, offset clear_screen
              mov al, 6
              sti
lazo:         jmp lazo

              org 2500h
fin_interr:   push ax
              mov al, pic
              out pic, al
              pop ax
              ret

              org 3000h
call_clock:   push ax
              inc seg+1
              cmp seg+1, 3ah
              jnz mostrar
              mov seg+1, 30h
              inc seg
              cmp seg, 36h
              jnz mostrar
              mov seg, 30h
              inc min+1
              cmp min+1, 3ah
              jnz mostrar
              mov min+1, 30h
              inc min
              cmp min, 36h
              jnz mostrar
              mov min, 30h
mostrar:      int 7
              mov al, 0
              out timer, al
              call fin_interr
              pop ax
              iret
end
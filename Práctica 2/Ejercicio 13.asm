timer         equ     10h                         ; Constante dirección timer
pic           equ     20h                         ; Constante dirección PIC

int_clk       equ     10

; Posición de memoria de la entrada 10 del vector
              org 40
              dw      call_clock

; Posicion de memoria de etiquetas para variables
              org 1000h
clear_screen  db      0ch                         ; Borra la pantalla
min           db      30h, 30h                    ; Minutos
              db      3ah                         ; Dos puntos
seg           db      30h, 30h                    ; Segundos

; Programa principal
              org 2000h
              cli
              mov     al, 0fdh
              out     pic+1, al
              mov     al, int_clk
              out     pic+5, al
              mov     al, 0
              out     timer, al
              mov     al, 1
              out     timer+1, al
              mov     bx, offset clear_screen
              mov     al, 6
              sti
lazo:         jmp     lazo

; Rutina de fin de atencion a la interrupción
              org 2500h
fin_interr:   push    ax
              mov     al, pic
              out     pic, al
              pop     ax
              ret

; Rutina de atención a la interrupción
              org 3000h
call_clock:   push    ax
              inc     seg+1
              cmp     seg+1, 3ah
              jnz     mostrar
              mov     seg+1, 30h
              inc     seg
              cmp     seg, 36h
              jnz     mostrar
              mov     seg, 30h
              inc     min+1
              cmp     min+1, 3ah
              jnz     mostrar
              mov     min+1, 30h
              inc     min
              cmp     min, 36h
              jnz     mostrar
              mov     min, 30h
mostrar:      int     7
              mov     al, 0
              out     timer, al
              call    fin_interr
              pop     ax
              iret
end
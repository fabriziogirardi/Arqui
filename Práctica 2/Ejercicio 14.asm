timer         equ     10h                         ; Constante dirección timer
pic           equ     20h                         ; Constante dirección PIC

int_timer     equ     10
int_key       equ     11

; Posición de memoria de la entrada 10 del vector
              org 40
              dw      call_clock

; Posición de memoria de la entrada 11 del vector
              org 44
              dw      call_key
  
; Posición de memoria de las etiquetas para variables
              org 1000h
frenar        db      0
clr_scr       db      0ch
seg           db      33h, 30h

; Posición de memoria del programa principal
              org 2000h
              cli
              mov     al, 0fch
              out     pic+1, al
              mov     al, int_timer
              out     pic+5, al
              mov     al, int_key
              out     pic+4, al
              mov     al, 0
              out     timer, al
              mov     al, 1
              out     timer+1, al
              mov     bx, offset clr_scr
              mov     al, 3
              sti
lazo:         jmp     lazo

; Rutina de atención a la interrupción del timer
              org 2500h
call_clock:   push    ax
              cmp     frenar, 1
              jz      fin_clock
              cmp     seg+1, 30h
              jz      decenas
              dec     seg+1
              jmp     fin_clock
decenas:      cmp     seg, 30h
              jz      fin_clock
              dec     seg
              mov     seg+1, 39h
fin_clock:    mov     al, 0
              out     timer, al
              pop     ax
              int     7
              call    fin_interr
              iret

; Rutina de atención a la interrupción del teclado
              org 2600h
call_key:     xor     frenar, 1
              call    fin_interr
              iret
              
; Rutina de fin de interrupción
              org 2700h
fin_interr:   mov     al, pic
              out     pic, al
              ret

end
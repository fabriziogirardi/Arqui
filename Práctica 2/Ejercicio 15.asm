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
mensaje       db      "Ingrese un numero para iniciar la cuenta regresiva: "
mensaje_fin   db      0
mensaje_2     db      0ch, "Cuenta regresiva desde "
num_ascii     db      30h
mensaje_3     db      " (Presione F10 para empezar)", 0ah
seg           db      30h
contador      db      0
iniciar       db      0

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
              sti
              call    mostrar_msj
              call    leer_num
lazo:         jmp     lazo

; Rutina de atención a la interrupción del timer
              org 2500h
call_clock:   push    ax
              cmp     iniciar, 0
              jz      fin_clock
              cmp     contador, 0
              jz      fin_clock
              dec     seg
              dec     contador
              call    imprimir_todo
fin_clock:    mov     al, 0
              out     timer, al
              pop     ax
              call    fin_interr
              iret

; Rutina de atención a la interrupción del teclado
              org 2600h
call_key:     xor     iniciar, 1
              call    fin_interr
              iret
              
; Rutina de fin de interrupción
              org 2700h
fin_interr:   mov     al, pic
              out     pic, al
              ret

              org 2800h
mostrar_msj:  push    bx
              mov     bx, offset mensaje
              push    ax
              mov     al, offset mensaje_fin - offset mensaje
              int     7
              pop     ax
              pop     bx
              ret
              
              org 2900h
leer_num:     push    bx
              mov     num_ascii, 30h
              mov     bx, offset num_ascii
              push    ax
              int     6
              cmp     num_ascii, 30h
              js      leer_num
              cmp     num_ascii, 3ah
              jns     leer_num
              push    dx
              mov     dl, num_ascii
              sub     dl, 30h
              mov     contador, dl
              mov     seg, dl
              add     seg, 30h
              call    imprimir_todo
              pop     dx
              pop     ax
              pop     bx
              ret

              org 3000h
imprimir_todo: push   bx
              mov     bx, offset mensaje_2
              push    ax
              mov al, offset contador - offset mensaje_2
              int     7
              pop     ax
              pop     bx
              ret

end
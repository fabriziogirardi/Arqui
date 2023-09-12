;--------------------------------
; Constantes
;--------------------------------
pio_data      equ     30h                       ; Puerto de datos del PIO (PB = PA+1)
pio_config    equ     32h                       ; Puerto de configuracion del PIO (CB = CA+1)
pic           equ     20h                       ; Puerto de datos del PIC
pic_mask      equ     21h                       ; Puerto de mascara de interrupciones del PIC
pic_clk       equ     25h                       ; Puerto de reloj del PIC

clk_cont      equ     10h                       ; Contador del reloj
clk_comp      equ     11h                       ; Comparador del reloj

clk_vec       equ     10                        ; Posicion de memoria de la rutina de reloj en el vector de interrupciones

;---------------------------
; Posición de memoria del vector de interrupción
;---------------------------
              org     40
              dw      contar_clk                ; Posicion de memoria de la rutina de interrupcion
              
;---------------------------
; Etiquetas de variables
;---------------------------
              org     1000h
contador      db      0
finalizar     db      0

;--------------------------------
; Rutina de interrupcion del reloj
;--------------------------------
              org     2500h
contar_clk:   push    ax
              push    bx
              push    cx
              push    dx
              call    inc_contador
              call    activar_luces
              call    reiniciar_clk
              call    fin_interr
              pop     dx
              pop     cx
              pop     bx
              pop     ax
              iret

;------------------------------          
; Rutina de fin de interrupción
;------------------------------
              org     2600h
fin_interr:   push    ax
              mov     ax, pic
              out     pic, al
              pop     ax
              ret

;---------------------------
; Rutina de reinicio del reloj
;---------------------------
              org     2700h
reiniciar_clk: push    ax
              mov     al, 0
              out     clk_cont, al
              pop     ax
              ret

;---------------------------
; Rutina de incremento del contador
;---------------------------
              org     2800h
inc_contador: inc     contador
              cmp     contador, 0ffh
              jz      fin_contador
              ret
fin_contador: mov     finalizar, 1
              ret

;---------------------------
; Rutina de activación de luces
;---------------------------
              org     2900h
activar_luces: push    ax
              mov     al, contador
              out     pio_data + 1, al
              pop     ax
              ret

;---------------------------
; Posición de memoria del programa principal
;---------------------------
              org     2000h
              cli
              mov     al, 0fdh
              out     pic_mask, al
              mov     al, clk_vec
              out     pic_clk, al
              mov     al, 1
              out     clk_comp, al
              mov     al, 0
              out     clk_cont, al
              sti
lazo:         cmp     finalizar, 1
              jnz     lazo
              int     0
              end

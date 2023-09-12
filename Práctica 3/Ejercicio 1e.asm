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
              dw      exe_clk                   ; Posicion de memoria de la rutina de interrupcion
              
;---------------------------
; Etiquetas de variables
;---------------------------
              org     1000h
contador      db      1
veces         db      1

;--------------------------------
; Rutina de interrupcion del reloj
;--------------------------------
              org     2500h
exe_clk:      push    ax
              push    bx
              push    cx
              push    dx
              call    direccion
              call    desp_bits
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
; Rutina de desplazamiento de bits
;---------------------------
              org     2800h
desp_bits:    push    ax
              push    cx
              mov     al, contador
              mov     cl, veces

otra_vez:     add     al, al
              adc     al, 0
              dec     cl
              jnz     otra_vez
              
              mov     contador, al
              pop     cx
              pop     ax
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
; Rutina de rotar a la izquierda
;---------------------------
              org     3000h
rotar_izq:    push    ax
              mov     al, contador
              push    cx
              mov     cl, veces
rotar:        add     al, al
              adc     al, 0
              cmp     cl, 0
              jnz     rotar
              pop     cx
              pop     ax
              ret

;---------------------------
; Rutina de chequeo/invertir dirección
;---------------------------
              org     3100h
direccion:    push    ax
              mov     al, contador
              cmp     al, 80h
              jz      derecha
              cmp     al, 01h
              jz      izquierda
              jmp     seguir
derecha:      cmp     veces, 1
              jnz     seguir
              mov     veces, 7
              jmp     seguir
izquierda:    cmp     veces, 7
              jnz     seguir
              mov     veces, 1
seguir:       pop     ax
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
              call    activar_luces
lazo:         jmp     lazo
              end

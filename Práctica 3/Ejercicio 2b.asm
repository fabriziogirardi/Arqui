;--------------------------------
; Constantes
;--------------------------------
pio_data      equ     30h                       ; Puerto de datos del PIO (PB = PA+1)
pio_config    equ     32h                       ; Puerto de configuracion del PIO (CB = CA+1)

;--------------------------------
; Variables
;--------------------------------
              org     1000h
texto_imp     db      "ORGANIZACION Y ARQUITECTURA DE COMPUTADORAS"
texto_imp_fin db      ?

;--------------------------------
; Programa principal
;--------------------------------
              org     2000h
              mov     al, 0fdh
              out     pio_config, al            ; Configura el PIO como entrada ultimo bit y salida el anteultimo
              mov     bx, offset texto_imp      ; Carga el puntero del texto a BX
poll:         in      al, pio_data              ; Lee el valor de PA
              and     al, 1                     ; Hace un AND con 1 para obtener el último bit
              jnz     poll                      ; Si no es cero el and, vuelve a poll
              mov     al, [bx]                  ; Carga la letra a AL
              out     pio_data + 1, al          ; Envía la letra a PB
              in      al, pio_data              ; Lee el valor de PA
              or      al, 2                     ; Hace un OR con 2 para poner a 1 el bit 1
              out     pio_data, al              ; Envia el valor a PB (enviar strobe)
              and     al, 0fdh                  ; Hace un AND con 0fdh para poner a 0 el bit 1
              out     pio_data, al              ; Envia el valor a PB (quitar strobe)
              inc     bx                        ; Incrementa el puntero
              cmp     bx, offset texto_imp_fin  ; Compara el puntero con el final del texto
              jnz     poll                      ; Si no es igual, vuelve a poll
              int     0                         ;
              end
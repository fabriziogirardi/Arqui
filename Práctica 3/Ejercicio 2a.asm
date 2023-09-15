;--------------------------------
; Constantes
;--------------------------------
pio_data      equ     30h                       ; Puerto de datos del PIO (PB = PA+1)
pio_config    equ     32h                       ; Puerto de configuracion del PIO (CB = CA+1)

;--------------------------------
; Variables
;--------------------------------
              org     1000h
letra_imp     db      "A"

;--------------------------------
; Programa principal
;--------------------------------
              org     2000h
              mov     al, 0fdh
              out     pio_config, al            ; Configura el PIO como entrada ultimo bit y salida el anteultimo
              mov     al, letra_imp             ; Carga la letra en el registro
              out     pio_data + 1, al          ; Envía la letra a PB
              in      al, pio_data              ; Lee el valor de PA
              or      al, 2                     ; Hace un OR con 2 para poner a 1 el bit 1
              out     pio_data, al              ; Envia el valor a PB (enviar strobe)
              int     0                         ;
              end
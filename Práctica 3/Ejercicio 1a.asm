pio_data      equ     30h                       ; Puerto de datos del PIO (PB = PA+1)
pio_config    equ     32h                       ; Puerto de configuracion del PIO (CB = CA+1)

; Posición de memoria del programa principal
              org 2000h
              mov     al, 0c3h                  ; Preparo los bits en 11000011 (1 lus prendida)
              out     pio_data + 1, al          ; Pongo los datos en PB
              mov     al, 3ch                   ; Preparo la mascara en 00111100 (0 salida)
              out     pio_config + 1, al        ; Pongo la mascara en CB
              int     0
              end
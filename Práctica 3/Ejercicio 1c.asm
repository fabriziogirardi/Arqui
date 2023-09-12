pio_data      equ     30h                       ; Puerto de datos del PIO (PB = PA+1)
pio_config    equ     32h                       ; Puerto de configuracion del PIO (CB = CA+1)

; Posición de memoria del programa principal
              org     2000h
              mov     al, 0ffh                  ; Preparo la mascara de las teclas en 11111111b (1 = entrada, 0 = salida)
              out     pio_config, al            ; Pongo la mascara de teclas en CA
              mov     al, 00h                   ; Preparo la mascara de las luces en 00000000b (1 = entrada, 0 = salida)	
              out     pio_config + 1, al        ; Pongo la mascara de luces en CB
repetir:      in      al, pio_data              ; Leo el estado de las teclas
              out     pio_data + 1, al          ; Pongo el estado de las teclas en las luces
              jmp     repetir                   ; Repito indefinidamente
              end
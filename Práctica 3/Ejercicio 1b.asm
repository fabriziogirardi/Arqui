pio_data      equ     30h                       ; Puerto de datos del PIO (PB = PA+1)
pio_config    equ     32h                       ; Puerto de configuracion del PIO (CB = CA+1)

              org     1000h
mensaje_1     db      "Llave prendida"
mensaje_1_fin db      ?
mensaje_2     db      "Llave apagada"
mensaje_2_fin db      ?

; Posición de memoria del programa principal
              org     2000h
              mov     cl, 4fh                   ; Espero 4fh ciclos de reloj para dar tiempo a tocar la tecla
esperar:      dec     cl
              jnz     esperar 
              mov     al, 80h                   ; Preparo la mascara en 10000000b (1 = entrada, 0 = salida)
              out     pio_config, al            ; Pongo la mascara en CA
              in      al, pio_data              ; Leo el estado de las teclas
              and     al, 80h                   ; Me quedo con el bit 7
              cmp     al, 80h                   ; Comparo con 10000000b
              jz      encendida                 ; Si es igual, salto a "encendida"
              mov     bx, offset mensaje_2      ; Si no, muestro el mensaje 2
              mov     al, offset mensaje_2_fin - offset mensaje_2
              jmp     mostrar
encendida:    mov     bx, offset mensaje_1        
              mov     al, offset mensaje_1_fin - offset mensaje_1
mostrar:      int     7
              int     0
              end
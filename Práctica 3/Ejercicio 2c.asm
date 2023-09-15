;--------------------------------
; Constantes
;--------------------------------
pio_data      equ     30h                       ; Puerto de datos del PIO (PB = PA+1)
pio_config    equ     32h                       ; Puerto de configuracion del PIO (CB = CA+1)
cantidad      equ     5                        ; Cantidad de letras a ingresar e imprimir

;--------------------------------
; Variables
;--------------------------------
              org     1000h
msj           db      18,"Ingrese 5 letras: "
letra_imp     db      ?

;--------------------------------
; Programa principal
;--------------------------------
              org     2000h
              mov     al, 0fdh
              out     pio_config, al            ; Configura el PIO como entrada ultimo bit y salida el anteultimo
              mov     bx, offset msj            ; -------------------------------------------
              mov     al, [bx]                  ; Muestro el mensaje pidiendo ingresar 
              inc     bx                        ; las 5 letras
              int     7                         ;---------------------------------------------
              mov     bx, offset letra_imp      ; Carga el puntero donde se va a almacenar la letra que luego se va a imprimir
              mov     cl, cantidad              ; Carga la cantidad de letras a ingresar e imprimir
leer:         int     6                         ; Lee una letra y la muestra en pantalla
              mov     al, 1                     ;
              int     7                         ;
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
              dec     cl                        ; Decrementa la cantidad de letras a ingresar e imprimir
              jnz     leer                      ; Si no llegue a cero, vuelve a leer
              int     0                         ;
              end
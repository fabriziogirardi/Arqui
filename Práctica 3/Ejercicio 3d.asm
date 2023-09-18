;--------------------------------
; Constantes
;--------------------------------
handshake     equ     40h                       ; Puerto de datos del Handshake

;--------------------------------
; Variables
;--------------------------------
              org     1000h
texto_imp     db      ?

;--------------------------------
; Programa principal
;--------------------------------
              org     2000h
              in      al, handshake + 1         ; Lee el valor del puerto de estado del Handshake
              and     al, 7fh                   ; Hace un AND con 7f para poner a 0 el bit 7
              out     handshake + 1, al         ; Configura el PIO como entrada ultimo bit y salida el anteultimo
              mov     bx, offset texto_imp      ; Carga el puntero al inicio del texto en BX
              mov     cl, 5                     ; Prepara el contador para 5 letras
lazo_leer:    int     6                         ; Loop para leer 5 letras
              inc     bx                        ;
              dec     cl                        ;
              jnz     lazo_leer                 ;
              mov     bx, offset texto_imp      ; Carga el puntero al inicio del texto en BX
lazo_mostrar: in      al, handshake + 1         ; Lee el valor del puerto de estado del Handshake
              and     al, 1                     ; Hace un AND con 1 para quedarse con el bit 0
              jnz     lazo_mostrar              ; Si el bit 0 es 1, se queda en el lazo
              mov     al, [bx]                  ; Carga la letra en AL
              out     handshake, al             ; Envía la letra al handshake
              inc     bx                        ; Incrementa el puntero
              inc     cl                        ; Incrementa el contador
              cmp     cl, 5                     ; Compara el contador con 5
              jnz     lazo_mostrar              ; Repite el lazo hasta que CX sea 0
              dec     bx                        ; Decrementa el puntero
lazo_reves:   in      al, handshake + 1         ; Lee el valor del puerto de estado del Handshake
              and     al, 1                     ; Hace un AND con 1 para quedarse con el bit 0
              jnz     lazo_reves                ; Si el bit 0 es 1, se queda en el lazo
              mov     al, [bx]                  ; Carga la letra en AL
              out     handshake, al             ; Envía la letra al handshake
              dec     bx                        ; Incrementa el puntero
              dec     cl                        ; Incrementa el contador
              jnz     lazo_reves                ; Repite el lazo hasta que CX sea 0
lazo:         jmp     lazo                      ; Bucle infinito
              end
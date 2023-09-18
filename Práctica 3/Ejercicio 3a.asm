;--------------------------------
; Constantes
;--------------------------------
handshake     equ     40h                       ; Puerto de datos del Handshake

;--------------------------------
; Variables
;--------------------------------
              org     1000h
texto_imp     db      "INGENIERIA E INFORMATICA"
texto_imp_fin db      ?

;--------------------------------
; Programa principal
;--------------------------------
              org     2000h
              in      al, handshake + 1         ; Lee el valor del puerto de estado del Handshake
              and     al, 7fh                   ; Hace un AND con 7f para poner a 0 el bit 7
              out     handshake + 1, al         ; Configura el PIO como entrada ultimo bit y salida el anteultimo
              mov     bx, offset texto_imp      ; Carga el puntero al inicio del texto en BX
              mov     cx, offset texto_imp_fin - offset texto_imp
lazo:         in      al, handshake + 1         ; Lee el valor del puerto de estado del Handshake
              and     al, 1                     ; Hace un AND con 1 para quedarse con el bit 0
              jnz     lazo                      ; Si el bit 0 es 1, se queda en el lazo
              mov     al, [bx]                  ; Carga la letra en AL
              out     handshake, al             ; Envía la letra al handshake
              inc     bx                        ; Incrementa el puntero
              dec     cx                        ; Decrementa el contador
              jnz     lazo                      ; Repite el lazo hasta que CX sea 0
              int     0                         ;
              end
;--------------------------------
; Constantes
;--------------------------------
pic           equ     20h                       ; Direccion del PIC
pic_mask      equ     21h                       ; Direccion de la mascara del PIC
pic_int_hs    equ     26h                       ; Interrupcion del PIC para el Handshake
handshake     equ     40h                       ; Puerto de datos del Handshake
hs_int_vec    equ     10                        ; Interrupcion del Handshake

;--------------------------------
; Vector de interrupciones
;--------------------------------
              org     40
              dw      hs_int

;--------------------------------
; Variables
;--------------------------------
              org     1000h
texto_rev     db      0
texto_cont    db      0
texto_fin     db      0
texto_ptr     dw      0
texto_imp     db      ?

;--------------------------------
; Rutina de interrupcion
;--------------------------------
              org     2500h
hs_int:       push    ax                        ; Guarda los registros
              push    bx                        ;

              cmp     texto_fin, 1              ; Compara si se ha terminado de imprimir el texto
              jz      fin_texto                 ; Si el flag de fin está en 1, salta a fin_texto

              cmp     texto_rev, 1              ; Compara si hay que imprimir el texto al reves
              jz      rev_texto                 ; Si el flag de reversa está en 1, salta a rev_texto

              mov     bx, texto_ptr             ; Carga el offset del texto a imprimir
              mov     al, [bx]                  ; Carga el caracter a imprimir
              out     handshake, al             ; Imprime el caracter
              inc     texto_cont                ; Incrementa el contador
              cmp     texto_cont, 5             ; Compara si se han impreso 5 caracteres
              jz      invertir                  ; Si se han impreso 5 caracteres, salta a fin_int
              inc     texto_ptr                 ; Incrementa el puntero
              jmp     fin_int                   ; Salta a fin_int

invertir:     mov     texto_rev, 1              ; Pone el flag de reversa en 1
              jmp     fin_int                   ; Salta a fin_int

rev_texto:    mov     bx, texto_ptr             ; Carga el offset del texto a imprimir
              mov     al, [bx]                  ; Carga el caracter a imprimir
              out     handshake, al             ; Imprime el caracter
              dec     texto_cont                ; Decrementa el contador
              cmp     texto_cont, 0             ; Compara si se llego al caracter 0
              jz      terminar                  ; Si se llego al caracter 0, salta a fin_int
              dec     texto_ptr                 ; Decrementa el puntero
              jmp     fin_int                   ; Salta a fin_int

terminar:     mov     texto_fin, 1              ; Pone el flag de fin en 1
              jmp     fin_int                   ; Salta a fin_int

fin_texto:    mov     al, 0ffh
              out     pic_mask, al

fin_int:      mov     al, pic
              out     pic, al
              pop     bx                        ; Recupera los registros
              pop     ax                        ;
              iret


;--------------------------------
; Programa principal
;--------------------------------
              org     2000h
              cli
              mov     al, hs_int_vec            ; Carga el numero de interrupcion del Handshake
              out     pic_int_hs, al            ; Configura la interrupcion del PIC para el Handshake
              in      al, handshake + 1         ; Lee el valor del puerto de estado del Handshake
              or      al, 80h                   ; Hace un OR con 80h para poner a 1 el bit 7
              out     handshake + 1, al         ; Configura el handshake para funcionar con interrupciones
              sti
              mov     bx, offset texto_imp      ; Carga el offset del texto a imprimir
              mov     cl, 5                     ; Carga el contador
leer:         int     6
              inc     bx                        ; Incrementa el puntero
              dec     cl                        ; Decrementa el contador
              jnz     leer                      ; Si el contador es distinto de 0, salta a leer
              mov     texto_ptr, offset texto_imp

; Activo aceptar interrupciones del Handshake
              mov     al, 0fbh                  ; Mascara para que el PIC acepte interrupciones del Handshake
              out     pic_mask, al              ; Configura la mascara del PIC
; Fin de activacion de interrupciones del Handshake

lazo:         jmp     lazo                      ; Repite el lazo indefinidamente
              int     0                         ;
              end
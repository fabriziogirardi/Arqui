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
texto_imp     db      "INGENIERIA E INFORMATICA"
texto_imp_fin db      ?
texto_cont    db      0
texto_ptr     dw      offset texto_imp

;--------------------------------
; Rutina de interrupcion
;--------------------------------
              org     2500h
hs_int:       push    ax                        ; Guarda los registros
              push    bx                        ;
              mov     al, offset texto_imp_fin - offset texto_imp
              cmp     al, texto_cont
              jz      fin_texto                 ; Si el tamaño es igual al contador, salta a fin_texto
              mov     bx, texto_ptr             ; Carga el offset del texto a imprimir
              mov     al, [bx]                  ; Carga el caracter a imprimir
              out     handshake, al             ; Imprime el caracter
              inc     texto_cont                ; Incrementa el contador
              inc     texto_ptr                 ; Incrementa el puntero
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
              mov     al, 0fbh                  ; Mascara para que el PIC acepte interrupciones del Handshake
              out     pic_mask, al              ; Configura la mascara del PIC
              mov     al, hs_int_vec            ; Carga el numero de interrupcion del Handshake
              out     pic_int_hs, al            ; Configura la interrupcion del PIC para el Handshake
              in      al, handshake + 1         ; Lee el valor del puerto de estado del Handshake
              or      al, 80h                   ; Hace un OR con 80h para poner a 1 el bit 7
              out     handshake + 1, al         ; Configura el handshake para funcionar con interrupciones
              sti
lazo:         jmp     lazo                      ; Repite el lazo indefinidamente
              int     0                         ;
              end
;--------------------------------
; Constantes
;--------------------------------
pio_data      equ     30h                       ; Puerto de datos del PIO (PB = PA+1)
pio_config    equ     32h                       ; Puerto de configuracion del PIO (CB = CA+1)
pic           equ     20h                       ; Puerto de comandos del PIC
pic_mask      equ     21h                       ; Puerto de mascara de interrupciones del PIC
pic_f10       equ     24h                       ; Puerto de datos del PIC (F10)
f10_vec       equ     10                        ; Vector de interrupcion del F10 posicion 10

;--------------------------------
; Interrupciones
;--------------------------------
              org     28h                       ; Dirección 28h = 40. Vector posición 10 (10x4 = 40)
              dw      int_f10                   ; Interrupcion del F10

;--------------------------------
; Variables
;--------------------------------
              org     1000h
msj           db      86,"Ingrese las letras "  ;------------------------------
              db      "que quiere imprimir y "  ;
              db      "presione F10 para "      ; Mensaje a mostrar
              db      "imprimir "               ;
              db      "(max 255 letras): "      ;------------------------------
cantidad      db      0                         ; Contador de letras ingresadas
letras        db      ?                         ; Letras ingresadas
terminar      db      0                         ; Flag para terminar el programa

;--------------------------------
; Rutinas de interrupción
;--------------------------------
              org     2500h
int_f10:      push    ax                        ; Guarda el valor de AX
              push    bx                        ; Guarda el valor de BX
              push    cx                        ; Guarda el valor de CX
              mov     terminar, 1               ; Pone el flag de terminar en 1
              mov     cl, cantidad              ; Carga la cantidad de letras ingresadas en CL
              mov     bx, offset letras         ; Carga el puntero a letras en BX
poll:         in      al, pio_data              ; Leo el estado actual
              and     al, 1                     ; Me quedo con el último bit
              jnz     poll                      ; Si es 1, espero a que sea 0
              mov     al, [bx]                  ; Carga la letra en AL
              out     pio_data + 1, al          ; Muestra la letra en pantalla
              in      al, pio_data              ; Leo el estado actual
              or      al, 2                     ; Le pongo un 1 al anteultimo bit
              out     pio_data, al              ; Envio señal de impresion (strobe en 1)
              and     al, 0fdh                  ; Le pongo un 0 al anteultimo bit
              out     pio_data, al              ; Envio señal de impresion (strobe en 0)
              inc     bx                        ; Incrementa el puntero a letras
              dec     cl                        ; Decrementa la cantidad de letras
              jnz     poll                      ; Si no es 0, vuelve a imprimir
              pop     cx                        ; Restaura el valor de CX
              pop     bx                        ; Restaura el valor de BX
              pop     ax                        ; Restaura el valor de AX
              call    fin_interr                ; Finaliza la interrupcion (20h al 20h)
              int     0                         ; Termina el programa
              iret

;--------------------------------
; Muestra en pantalla el mensaje
;--------------------------------
              org     2600h
mostrar_msj:  push    bx
              mov     bx, offset msj
              push    ax
              mov     al, [bx]
              inc     bx
              int     7
              pop     ax
              pop     bx
              ret

;--------------------------------
; Finaliza la interrupcion
;--------------------------------
              org     2650h
fin_interr:   push    ax
              mov     al, 20h
              out     pic, al
              pop     ax
              ret
              
;--------------------------------
; Leo letras y las muestro en pantalla
;--------------------------------
              org     2700h
leer:         push    bx
              push    ax
              mov     bx, offset letras
              mov     al, 1
leer_letra:   int     6                         ; Lee una letra y la muestra en pantalla
              int     7                         ;
              inc     bx                        ; Incrementa el puntero a letras
              inc     cantidad                  ; Incrementa la cantidad de letras ingresadas
              cmp     cantidad, 255             ; Compara la cantidad de letras ingresadas con 255
              jz      fin                       ; Si es igual, termina a la fuerza
              jmp     leer_letra                ; Si no es igual, vuelve a leer
fin:          pop     ax
              pop     bx
              ret

;--------------------------------
; Programa principal
;--------------------------------
              org     2000h
; Configuracion de interrupciones
              cli
              mov     al, 0feh                  ; Habilita las interrupciones del F10 (ultimo bit en 0)
              out     pic_mask, al              ; Envia la mascara al PIC
              mov     al, f10_vec               ; Carga la posicion en el vector de interrupcion para el F10
              out     pic_f10, al               ; Carga el vector de interrupcion para el F10 en el registro del PIC
              sti
; Fin de configuracion de interrupciones

; Configuracion del PIO
              mov     al, 0fdh
              out     pio_config, al            ; Configura el PIO como entrada ultimo bit y salida el anteultimo
; Fin de configuracion del PIO

              call    mostrar_msj
              call    leer
              end
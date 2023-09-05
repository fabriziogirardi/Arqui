        org 1000h
cero    db 0Ah                                  ; Dirección baja de donde empieza el cero
uno     db 0Fh                                  ; Dirección baja de donde empieza el uno
dos     db 13h                                  ; Dirección baja de donde empieza el dos
tres    db 17h                                  ; Dirección baja de donde empieza el tres
cuatro  db 1Ch                                  ; Dirección baja de donde empieza el cuatro
cinco   db 23h                                  ; Dirección baja de donde empieza el cinco
seis    db 29h                                  ; Dirección baja de donde empieza el seis
siete   db 2Eh                                  ; Dirección baja de donde empieza el siete
ocho    db 34h                                  ; Dirección baja de donde empieza el ocho
nueve   db 39h                                  ; Dirección baja de donde empieza el nueve
        db 04h,"CERO"                           ; Cantidad de caracteres + texto
        db 03h,"UNO"                            ;
        db 03h,"DOS"                            ;
        db 04h,"TRES"                           ;
        db 06h,"CUATRO"                         ;
        db 05h,"CINCO"                          ;
        db 04h,"SEIS"                           ;
        db 05h,"SIETE"                          ;
        db 04h,"OCHO"                           ;
        db 05h,"NUEVE"                          ;
mensaje db "Ingrese un numero: "                ; Mensaje principal
error   db "El caracter no es un numero."       ; Mensaje de error
fin     db ?                                    ; Fin del mensaje de error
num     db ?                                    ; Caracter leído

        org 2000h
        mov bx, offset mensaje                  ; Muestro el mensaje
        mov al, offset error - offset mensaje   ;
        int 7                                   ;
        
        mov bx, offset num                      ; Leo el caracter
        int 6                                   ;
        
        cmp byte ptr [bx], 30h                  ; Comparo. Si es menor a 30 y no es menor a 40
        js err                                  ; entonces mostrar error
        cmp byte ptr [bx], 40h                  ;
        jns err                                 ;
        
        mov bx, [bx]                            ; Muevo el caracter leido en ascii
        sub bx, 30h                             ; Le resto 30h para quedarme con el numero decimal
        add bx, 1000h                           ; Le sumo 1000h para buscar el inicio del texto
        mov bl, [bx]                            ; Muevo a la parte baja, lo que está donde apunta bx
        mov al, [bx]                            ; Muevo ese contenido a al (cantidad de caracteres)
        inc bx                                  ; Sumo 1 a bx para preparar el inicio de la cadena
        jmp mostrar                             ; Salto a "mostrar"
        
err:    mov bx, offset error                    ; Preparo el mensaje de error
        mov al, offset fin - offset error       ;
        
mostrar:int 7                                   ; Muestro lo que corresponda

        hlt
        end

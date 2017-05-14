.data
msg1 db 'Enter mx(4 hex): $'
msg2 db 10, 13, 'Enter ex(2 hex): $'
msg3 db 10, 13, 'Enter my(4 hex): $'
msg4 db 10, 13, 'Enter ey(2 hex): $'

mx dw ?
ex db ?
my dw ?
ey db ?
mz dw ?
ez db ?

buffer  db 10,?, 10 dup(0) 

.code
main proc
    mov ax, @data
    mov ds, ax
    
    call inputInitData
    
    mov ah, 4Ch ; return control to OS
    mov al, 00
    int 21h
main endp
 

inputInitData proc 
    mov dx, offset msg1 ;block displays msg1
    mov ah, 09h
    int 21h
   
    mov ax, 2 ; nr of bytes to represent the packed bcd written with hex
    push ax   ; passing parameters to proc
    lea di, mx
    push di   
    ; reset packed bcd:
    mov word ptr [di], 0
    call inputHexes ;will load packed bcd in mx
    
    mov dx, offset msg2 ;block displays msg2
    mov ah, 09h
    int 21h
    
    mov ax, 1 ; nr of bytes to represent the packed bcd written with hex
    push ax   ; passing parameters to proc
    lea di, ex
    push di   
    ; reset packed bcd:
    mov word ptr [di], 0
    call inputHexes ;will load packed bcd in ex
    
    mov dx, offset msg3 ;block displays msg3
    mov ah, 09h
    int 21h
   
    mov ax, 2 ; nr of bytes to represent the packed bcd written with hex
    push ax   ; passing parameters to proc
    lea di, my
    push di   
    ; reset packed bcd:
    mov word ptr [di], 0
    call inputHexes ;will load packed bcd in my
    
    mov dx, offset msg4 ;block displays msg4
    mov ah, 09h
    int 21h
    
    mov ax, 1 ; nr of bytes to represent the packed bcd written with hex
    push ax   ; passing parameters to proc
    lea di, ey
    push di   
    ; reset packed bcd:
    mov word ptr [di], 0
    call inputHexes ;will load packed bcd in ey
    
    ret
inputInitData endp


printBackSpace proc  ;before call need to set ax to nr of char to delete
                     ;and push it to stack
    push bp    ; push in order to not lose if set
    push cx    ; push in order to not lose if set
    mov bp, sp
    mov cx, bp+6 ; cx = ax that was in stack
backspace:    
    mov ah, 02h ;backspace
    mov dl, 08h
    int 21h    
    mov ah, 02h ;print space to delete the char
    mov dl, 20h 
    int 21h
    mov ah, 02h ;backspace again to go 1 char back
    mov dl, 08h
    int 21h
    loop backspace
    
    
    mov sp, bp ;restore the stack if it wasn't cleared up properly within the procedural code 
    pop cx  ;restores cx value
    pop bp  ;restores bp value
    ret 2   ;nr of bytes to pop off the stack/pops the parameter ax that was pushed
printBackSpace endp 
    
       
inputHexes proc ;parameters to push in stack ax,di before calling
                ;need to specify in ax the nr of bytes to represent 
                ;the packed bcds written with hex, 
                ;ex: 4A5F= 0100 1010 0101 1111 <-word
                ;ex: 3A= 0011 1010 <-byte
                ;and efective adress of where to put the packed bcds in di
                 
    push bp     ; push in order to not lose if set
    mov bp, sp

inputString:    
    lea dx, buffer ;input string
    mov ah, 0Ah
    int 21h 
     
    xor bx, bx
    mov bl, buffer[1] ;bx=nr of char inputed
    mov ax, bp+6 ;ax = nr of bytes containing the packed BCD
    shl ax, 1    ;ax = total nr of chars needed to input
    cmp ax, bx   ;verifies if input nr of chars is correct
    je packInput ;if equal then pack the input

tryAgain:    
    mov ax, bx          ;delete the input
    push ax
    call printBackSpace
    jmp inputString

packInput:
    lea si, buffer[2] ;load input string
    mov di, bp+4      ;load memory where to put the packed nr
    mov cx, bp+6      ;load nr of bytes after packing
    
    add di, bp+6      
    dec di            ;dx will point to upper digits of packed BCD
       
    ; to convert a char (0..9) to digit we need
	; to subtract 48 (30h) from its ascii code,
	; to convert a char (A..F) to digit we need
	; to subtract 55 (37h) from its ascii code,
	; to convert a char (A..F) to digit we need
	; to subtract 87 (57h) from its ascii code,
	; or just clear the upper nibble of a byte.
	; mask:  00001111b  (0fh)
next_2Hexes:
    mov ax, [si] ;read 2 bytes that represent 2 hexes
    
    ;trasform char1 to hex represented in bytes
    cmp ah, '0'
    jb tryAgain 
    cmp ah, '9'
    jbe detectedChipher1
    cmp ah, 'A'
    jb tryAgain
    cmp ah, 'F'
    jbe detectedLetter1
    cmp ah, 'a'
    jb tryAgain
    cmp ah, 'f'
    jbe detectedLowerLetter1
    jmp tryAgain
    
    
detectedChipher1:
    sub ah, 30h
    jmp endTransform1
detectedLetter1:
    sub ah, 37h
    jmp endTransform1  
detectedLowerLetter1:
    sub ah, 57h
endTransform1:

    cmp al, '0'
    jb tryAgain 
    cmp al, '9'
    jbe detectedChipher2
    cmp al, 'A'
    jb tryAgain
    cmp al, 'F'
    jbe detectedLetter2
    cmp al, 'a'
    jb tryAgain
    cmp al, 'f'
    jbe detectedLowerLetter2
    jmp tryAgain
    
detectedChipher2:
    sub al, 30h
    jmp endTransform2
detectedLetter2:
    sub al, 37h
    jmp endTransform2  
detectedLowerLetter2:
    sub al, 57h
endTransform2:

    ; 8086 and all other Intel's microprocessors store less 
    ; significant byte at lower address.
    xchg al, ah	
    
    ; move first hex to upper nibble:
    shl ah, 4 

    ; pack bcd:
    or ah, al
    
    ; store 2 digits:
    mov [di], ah         
    
    ; next packed bcd:
    sub di, 1
    ; next 2 chars/2bytes/word/(2 hexes):
    add si, 2
    
    loop next_2Hexes
    
    mov sp, bp
    pop bp
    ret 4 ; nr of bytes to pop off the stack
inputHexes endp
end main
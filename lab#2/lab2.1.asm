.data
x dw 5 dup(?)
a db 0AAh
b db 3h
sm dw ?

.code  
start:
    mov ax, @data
    mov ds, ax
    
    
    ;x(i) = x(i-1)-7b+a
    ;mov bx, 4
    
    xor ax, ax
    mov al, b 
    mov bl, 7
    mul bl     ;al = 7b
         
    xor dx,dx     
    mov dl, a
    sub dx, ax ;dx = a-7b
                            
    mov x, 0000h ;this will be the first element 
    
    mov si, 2 ;next array elem index start
    mov cx, 4 ;need to compute 4 more elemnents
    
    xor ax, ax
    
findNextElem: 
    add ax, dx ; ax=ax+a-7b
              
    mov x[si],ax ;saves value in array     
    
    inc si ;increment 2 times because element is word
    inc si

    loop findNextElem
    
    ;compute sum of elem in array
    mov cx, 5
    mov si, 0
    xor ax, ax ; set value to 0
        
sum:
    add ax, x[si]
    inc si
    inc si
    loop sum 
    
    mov sm, ax ;saves sum
        
    mov ah, 4Ch
    int 21h

end start
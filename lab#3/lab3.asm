.data
x dw 4h, 2h, -2h, 5h, 3h, -3h, 7h, -11h , 5h, -6h
y dw 10 dup(?)
.code
start:
    mov ax, @data
    mov ds, ax
    
    call sum ;sum will be in ax
    cmp ax,0
    jng smaller

greaterOrEqual:    
    call generateEven
    jmp finish
    
smaller:
    call generateOdd
    
finish:
    mov ah, 4Ch
    int 21h
           
           
sum proc
    mov si, 0
    mov cx, 10
    mov ax, 0
    repeat:
        add ax, x[si]
        inc si
        inc si
        loop repeat
    ret
sum endp
           
           
generateEven proc 
    mov si, 0
    mov di, 0
    mov cx, 10
    repeat1:
        mov ax, x[si]
        shr ax, 1
        jc flag1 ;if cf=1 then ax x[si] is odd
        mov ax, x[si]
        mov y[di], ax ;add even element to y array
        inc di
        inc di
    flag1:
        inc si
        inc si
        loop repeat1
    ret
generateEven endp
           
           
generateOdd proc
    mov si, 0
    mov di, 0
    mov cx, 10
    repeat2:
        mov ax, x[si]
        shr ax, 1
        jnc flag2 ;if cf=0 then ax x[si] is odd
        mov ax, x[si]
        mov y[di], ax ;add odd element to y array
        inc di
        inc di
    flag2:
        inc si
        inc si
        loop repeat2
    ret
generateOdd endp

end start
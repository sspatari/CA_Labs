.data
x dw 8002h
z dw 7417h
y dd ?

.code
start:
    mov ax, @data
    mov ds, ax
    
    mov ax, z
    shr ax, 1 ;if cf=1 then odd else even 
    
    jc odd     
even:
    mov ax, x
    sub ax, z ;ax=X-Z
     
    shl ax, 1 ;mul by 2
    mov dx, 0
    adc dx, 0 ;dx:ax = (X-Z)2
    
    sub ax, 41
    sbb dx, 0 ;dx:ax = (X-Z)2-41
    
    jmp finish

odd:
    mov ax, z
    shl ax, 1 ;mul by 2
    mov dx, 0
    adc dx, 0 ;dx:ax = 2Z
    
    add ax, 23
    adc dx, 0 ;dx:ax = 2Z+23 
   
finish:
    mov y, ax     
    mov y[2], dx  ;save result in y

    mov ah, 4Ch
    int 21h 
end start

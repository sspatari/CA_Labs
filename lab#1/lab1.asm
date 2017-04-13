                .model small
.stack 100h
.data
x db 10h
y dw 2345h
z dd 12345678h
.code
start:
    mov ax, @data
    mov ds, ax   
    mov ax, z[2]
    mov bx, z
    mov cx, y
    mov dl, x
    mov dh, 0 
    
    push ax
    push bx
    push cx
    push dx 
    
    mov ax, 0CD34h
    mov ds, ax 
    
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx  
    
    pop dx
    pop cx
    pop bx
    pop ax 
    
    
    mov si, 2h
    mov z[si], ax
    mov z, bx
    mov y, cx
    mov x, dl
    
    mov ax, 0 ;immediate adressing mode
    mov ax, bx ;register adressing mode
    mov al, ds:[0000h] ;direct adressing mode 
    mov bx, 0002h
    mov al, [bx] ;indirect adressing mode
    mov al, [bx+2] ;based adressing mode
    mov al, [bx+si];based indexed adressing mode
    mov ax, [bx+si+y];based indexed plus displacement adressing mode
    
      
    mov ah, 4Ch
    int 21h
end start
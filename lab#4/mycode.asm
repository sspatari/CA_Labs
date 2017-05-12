.DATA
        STRING DB ? 
        SYM DB '$'
        INPUT_M DB 0DH,0AH,'ENTER STRING',0DH,0AH,'$'
.CODE
MAIN PROC
        MOV AX,@DATA
        MOV DS,AX
        
        MOV DL, "A"
        MOV AH, 02
        INT 21h
         
        MOV DX,OFFSET INPUT_M    ; lea dx,input_m
        MOV AH,09
        INT 21H

        LEA SI,STRING

INP:    MOV AH,01
        INT 21H

        MOV [SI],AL

        INC SI

        CMP AL,0DH
        JNZ INP

       ; MOV AL,SYM
        MOV [SI],'$'
 
;        MOV DL,0AH
;        MOV AH,02H
;        INT 21H

        MOV DX,OFFSET STRING
        MOV AH,09H
        INT 21H

        MOV AH,4CH
        INT 21H

MAIN ENDP
END MAIN
;-----------------------------------------------------------------------
;OUTPUT
;-----------------------------------------------------------------------
;ENTER STRING
;An Assembly Language is greate
;An Assembly Language is greate
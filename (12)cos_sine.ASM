;working
.model small

.stack 100

.data
msg db 10,13,'1.SINE WAVE',10,'2.COS WAVE',10,'3.SINC Function',10,'Enter Choice...$'
x dd 0.0
x1 dw 0
x2 dd 0.0
x3 dw 0
x4 dd -960.0
x5 dw 0
xad dd 3.0
one80 dd 180.0
scale dd 30.0
scale1 dd 1500.0
fifty dd 50.0
ycursor dt 00
count dw 640

.code
.386
main: mov ax,@data
mov ds,ax

menu:mov ah,09h
lea dx,msg
int 21h

mov ah,01h
int 21h
cmp al,31h
je case1
cmp al,32h
je case2
cmp al,33h
je case3
jmp exit
case1:
mov ah,00               ;set video mode
mov al,06h
int 10h
mov word ptr[count],640

up1:
finit
fldpi   ;load pi on ST[0]
fdiv one80 ;pi/180 store result on sto
fmul x ;pi/180*x
fsin ;(sin(pi/180)*x)
fmul scale
fld fifty
fsub st,st(1)   ;=50-30 sin((pi/180))*x
fbstp ycursor ; Converts the value in the ST(0) register to an       			;18-digit packed BCD integer, stores the result 			;	in the destination operand, and pops the  				;	register stack
lea esi,ycursor
mov ah,0ch        ;write graphics pixel
mov al,01h  ; color number
mov bh,0h  ;display
mov cx,x1  ;screen column 
mov dx,[esi]; screen line
int 10h
inc x1                 
fld x                  
fadd xad               
fst x                  
dec count              
jnz up1
mov ah,0      ;getch
int 16h
mov ah,00
mov al,03      ;swich to text mode
int 10h
jmp menu

case2: 
mov word ptr[count],360
mov ah,00               ;set video mode
mov al,13h
int 10h

up2:finit
fldpi
fdiv one80
fmul x2
fcos
fmul scale
fld fifty
fsub st,st(1)   ;=50-30 sin((pi/180))*x
fbstp ycursor
lea esi,ycursor
mov ah,0ch        ;write graphics pixel
mov al,01h
mov bh,0h
mov cx,x3
mov dx,[esi]
int 10h
inc x3                 
fld x2                  
fadd xad               
fst x2                  
dec count              
jnz up2
mov ah,0
int 16h
mov ax,3
int 10h
jmp menu


case3:
mov word ptr[count],640
mov ah,00               ;set video mode
mov al,06h
int 10h

up3:finit
fldpi
fdiv one80
fmul x4
fsin
fdiv x4
fmul scale1
fld fifty
fsub st,st(1)   ;=100-60 sin((pi/180))*x
fbstp ycursor
lea esi,ycursor
mov ah,0ch        ;write graphics pixel
mov al,01h
mov bh,0h
mov cx,x5
mov dx,[si]
int 10h
inc x5  
fld x4
fadd xad
fstp x4                
dec count              
jnz up3
mov ah,0
int 16h
mov ax,3
int 10h
jmp menu


exit:
mov ah,4ch
int 21h
end main


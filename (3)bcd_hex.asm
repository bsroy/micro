section .data

msg db"HEx to bcd::",10
     db"BCD to hex::",10
     db"Exit::",10
len equ $-msg

msg1 db"Enter the No::",10
len1 equ $-msg1
msg2 db"Enter the choice::",10
len2 equ $-msg2


%macro write 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro


%macro read 2
mov rax,0
mov rdi,0
mov rsi,%1
mov rdx,%2
syscall
%endmacro


section .bss
c resb 2
num resb 17
numlen resq 1
num1 resb 8
ctr resb 8
res resb 1
buff resb 16
section .txt
global _start
_start:
main:
write msg,len
write msg2,len2
read c,2
cmp byte[c],31h
je oop1

cmp byte[c],32h
je oop2

cmp byte[c],33h
je oop3

oop1:
write msg1,len1
read num,17
dec rax

mov qword[numlen],rax
mov rax,0
mov rbx,0
mov rdx,0

mov rsi,num
lb1:mov al,byte[rsi]
cmp al,39h
jle lb
sub al,07h
lb:shl rbx,04
sub al,30h
add rbx,rax
dec qword[numlen]
inc rsi
cmp qword[numlen],0
jnz lb1

mov qword[num1],rbx
mov rax,qword[num1]
mov qword[ctr],0

up3:mov rbx,0Ah
mov rdx,0
div rbx
push rdx
inc qword[ctr]
cmp rax,0
jne  up3

mm:pop rbx
add bl,30h
mov byte[res],bl
write res,1
dec qword[ctr]
jnz mm


jmp main
oop2:

write msg1,len1
read num,17
dec rax
mov rsi,num
mov qword[numlen],rax
mov rax,0
pk:mov rbx,0Ah
mov rdx,0

mul rbx
mov dl,byte[rsi]
sub dl,30h
add rax,rdx
inc rsi
dec qword[numlen]
jnz pk

mov rbx,rax
call disp

 jmp main 
oop3:


mov rax,60
mov rdi,0
syscall

disp:

mov rsi,buff
mov rcx,16
mov rdx,0
up:rol rbx,04h
mov dl,bl
and dl,0FH
cmp dl,09H
jbe add_30
add dl,07H
add_30:
add dl,30H

mov byte[rsi],dl
inc rsi
dec rcx
jnz up
write buff,16

ret


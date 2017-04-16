section .data
arr dq 1111111111111111H,0A111111111111111H,0B111111111111111H,3111111111111111H,4111111111111111H,

msg1 db".Positive no",10
len1 equ $-msg1


msg2 db".Negative no",10
len2 equ $-msg2

msg3 db" ",10
len3 equ $-msg3

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
buff resb 16
p resb 8
n resb 8
section .txt
global _start
_start:
mov rcx,5
mov rbx,0
mov rdx,0
mov qword[p],0
mov qword[n],0
mov rsi,arr



up1:mov rbx,[rsi]
mov rdx,8000000000000000H
and rbx,rdx
cmp rbx,0
jz incP
inc qword[n]
jmp add
incP:
inc qword[p]
add:
add rsi,8
dec rcx
jnz up1

write msg1,len1
mov rbx,qword[p]
call disp
write msg3,len3


write msg2,len2
mov rbx,qword[n]
call disp
write msg3,len3


			
mov rax,60
mov rsi,0
syscall
disp:
mov rcx,16
mov rsi,buff
mov rdx,0
up:rol rbx,04
mov dl,bl
and dl,0fh
cmp dl,09h
jbe add_30
add dl,07h

add_30:
add dl,30h
mov [rsi],dl
;mov qword[rsi],rbx
;ex1:
inc rsi
dec rcx
jnz up

write buff,16

ret



;====================part2===============

extern c1,fd
global far_procedure
section .data
msg2 db "No of spaces are: "
len2 equ $-msg2

msg3 db "No of lines are: "
len3 equ $-msg3

msg4 db "No of times character is repeated is:"
len4 equ $-msg4

msg5 db "",10
len5 equ $-msg5
 
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

scount resb 8 ;for counting spaces
lcount resb 8 ;for counting lines
ccount resb 8 ;for counting no of repetitions of character
buffer resb 100 
size resb 8  ;used as counter
size1 resb 8
buff resb 16  ;used in display



section .text
global _start1
_start:
far_procedure:

mov qword[scount],0
mov qword[lcount],0
mov qword[ccount],0

mov rsi,buffer

l5:mov rax,0
mov rdi,qword[fd]
mov rsi,buffer
mov rdx,100
syscall

	mov qword[size],rax
	mov qword[size1],rax
	l4:mov al,byte[rsi]
	cmp al,20h
	jne l1
	inc qword[scount]

l1:cmp al,0Ah 
	jne l2
	inc qword[lcount]

l2: cmp al,byte[c1]
	jne l3
	inc qword[ccount]

l3: inc rsi
dec qword[size]
cmp qword[size],0
jne l4

cmp qword[size1],100
je l5

write msg2,len2
mov rbx,qword[scount]
call disp
write msg5,len5

write msg3,len3
mov rbx,qword[lcount]
call disp
write msg5,len5

write msg4,len4
mov rbx,qword[ccount]
call disp
write msg5,len5

mov rax,03
mov rdi,qword[fd]
syscall

ret


disp:mov rcx,16
     mov rsi,buff
up1:rol rbx,04
    mov rdx,00
    mov dl,bl
    and dl,0FH
    cmp dl,09
    jbe l6
    add dl,07H
l6:add dl,30h
mov [rsi],dl
inc rsi
dec rcx
jnz up1
write buff,16
ret

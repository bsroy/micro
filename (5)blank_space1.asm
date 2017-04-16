

;==============part1============================

extern far_procedure
global c1,fd
section .data
msg db "Enter the file name",10
len equ $-msg
 msg1 db "Enter the character you want to search",10
len1 equ $-msg1
errmsg db "File not present",10
errlen equ $-errmsg


 
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
c1 resb 2 ;for character search
fname resb 50
fd resb 8
section .text
global _start
_start:

write msg,len  ;Enter file name
read fname,50
mov rsi,fname
dec rax
add rsi,rax
mov byte[rsi],0

mov rax,2
mov rdi,fname
mov rsi,0
mov rdx,0777o
syscall

mov qword[fd],rax
cmp rax,0
jle err
write msg1,len1 
	read c1,2
	call far_procedure
jmp exit
err:write errmsg,errlen

exit:Mov rax,60
mov rdi,0
syscall



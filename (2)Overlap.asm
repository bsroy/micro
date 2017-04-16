section .data
 msg db"===================MENU=========",10
     db" 1.Nonoverlapping string copy without string instruction",10 
     db" 2.Overlapping string copy without string instruction",10
     db" 3.Nonoverlapping string copy with string instruction",10
     db" 4.Overlapping string copy without string instruction",10
     db" 5.Exit::",10
len equ $-msg

m1 db"Enter your Choice::",10
l1 equ $-m1
m2 db" ",10
l2 equ $-m2
m3 db"Enter the string",10
l3 equ $-m3
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
src resb 5
dest resb 5
slen resb 8
dlen resb 8
temp resb 8
c resb 2

section .txt
global _start
_start:
main:
write msg,len
write m2,l2
write m1,l1
read c,2
cmp byte[c],31h
je a1
cmp byte[c],32h
je a2
cmp byte[c],33h
je a3
cmp byte[c],34h
je a4
cmp byte[c],35h
je a5
a1:
write m3,l3
read src,6
dec rax
mov qword[slen],rax
mov qword[temp],rax
mov rsi,src
mov rdi,dest
mov rbx,0
s1:mov bl,byte[rsi]
mov byte[rdi],bl
inc rsi
inc rdi
dec qword[temp]
jnz s1
write src,10




jmp main
a2:
write m3,l3
read src,6
dec rax
mov qword[dlen],rax
mov qword[temp],rax
mov rsi,src
add rsi,rax
dec rsi
mov rdi,dest
add rdi,2
mov rbx,0

s2:mov bl,byte[rsi]
mov byte[rdi],bl
dec rsi
dec rdi
dec qword[temp]
jnz s2
write src,8

jmp main
a3:
write m3,l3
read src,6
dec rax
mov rcx,rax

mov rsi,src
mov rdi,dest

CLD
REP movsb
write src,10 



jmp main
a4:
write m3,l3
read src,6
dec rax
mov rcx,rax

mov rsi,src
add rsi,rax
dec rsi
mov rdi,dest
add rdi,2
STD
REP movsb
write src,8
jmp main



a5:
mov rax,60
mov rsi,0
syscall


extern printf,scanf ; It is defind in other file stdio.h

%macro write 2
push rbp    ; it is base pointer points base of the stack
            ; when you switch to the other segment than current base pointer needs to stored in the stack 


mov rax,0
mov rdi,%1
mov rsi,%2
call printf
pop rbp
%endmacro


%macro scan 2
push rbp
mov rax,0
mov rdi,%1
mov rsi,%2
call scanf
pop rbp
%endmacro

%macro printfloat 2    ; for printing the floating point result
push rbp
mov rax,1
mov rdi,%1
movsd xmm0,%2    ; Xmm0 is tool which needed for complex computation
call printf
pop rbp
%endmacro

%macro exit 0
mov rax,60
mov rdi,0
syscall
%endmacro


%macro write_sp 2

mov rax,1
mov rdi,1
mov rsi,%2
mov rdx,%2
syscall
%endmacro


section .data

m1 db "%lf",0    ;  long float 
m2 db "%s",0     ;  string 
 
msg1 db"Enter the a,b,c",10,0
msg2 db 10,"Roots are",10,0
msg3 db"+i*",0
msg4 db"-i*",0
msg5 db "(Repeated)",10,0

n1 db" ",10
len equ $-n1


section .bss

a resb 8
b resb 8
c resb 8
temp resw 1
t1 resb 8
t2 resb 8
t3 resb 8
t4 resb 8
r1 resb 10
r2 resb 10


section .txt
global main
main:
;write m2,n1  ;why it print by default Zero
; it is of prototype of printf function 
;one data_type and other is string or variable 

write m2,msg1
scan m1,a  ; to input floating point number /integer
scan m1,b  ; to input floating point number/integer
scan m1,c  ; to input floating point number /integer

finit  ; needs to findout

fld qword[b]

fmul st0,st0  

fstp qword[t1]

fld  qword[a]

fmul qword[c]

mov word[temp],4

fimul word[temp]


fstp qword[t2]

fld qword[t1]

fsub qword[t2]

fstp qword[t4]  ; here t4= b^2-4*a*c

fld qword[t4]  ;just for the backup
 fabs
fsqrt
fstp qword[t1] ;upto t1=b^2-4*a*c of sqrt
fld qword[b]
fchs
fstp qword[t2] ;t2=-b
fld qword[a]
mov qword[temp],02
fimul word[temp]
fstp qword[t3]  ;t3=2*a

write m2,msg2
cmp qword[t4],0
je equal_root

jl img

fld qword[t2]
fadd qword[t1]
fdiv qword[t3]
fstp qword[r1]
printfloat m1,[r1]
write n1,len

equal_root:

;write m1,n1 ; no need to this because by default is print 0.00000000000

fld qword[t2]
fsub qword[t1]
fdiv qword[t3]
fstp qword[r2]
printfloat m1,[r2]
write n1,len
jmp done

img:fld qword[t2]
fdiv qword[t3]
fstp qword[r1]
fld qword[t1]
fdiv qword[t3]
fstp qword[r2]
printfloat m1,[r1]
write m2,msg3

printfloat m1,[r2]
write m2,n1
printfloat m1,[r1]

write m2,msg4
printfloat m1,[r2]



done:
write m2,n1


exit














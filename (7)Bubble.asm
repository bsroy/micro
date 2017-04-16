%macro write 03
push rdi
push rsi
mov rax,1
mov rdi,%1
mov rsi,%2
mov rdx,%3
syscall
pop rsi
pop rdi
%endmacro

%macro read 03
push rdi
push rsi
mov rax,0
mov rdi,%1
mov rsi,%2
mov rdx,%3
syscall
pop rsi
pop rdi
%endmacro

%macro fopen 02
mov rax,02
mov rdi,%1
mov rsi,%2
mov rdx,0777o
syscall
%endmacro

%macro fclose 01
mov rax,03
mov rdi,%1
syscall
%endmacro

%macro exit 0
mov rax,60
mov rdi,0
syscall
%endmacro

section .data
msg1 db 10,"Enter file name: "
len1 equ $-msg1
msg2 db 10,"File opened successfully"
len2 equ $-msg2
msg3 db 10,"File could not be opened"
len3 equ $-msg3
msg4 db 10,"Sorting done."
len4 equ $-msg4
nl db 0AH

section .bss
fname resb 50
fd resq 1
arr resq 10
x resb 1
char_buff resb 16
n resq 1
actl resq 1

section .text
global _start
_start:
	write 1,msg1,len1
	read 0,fname,50
	dec rax
	mov byte[fname+rax],00
	fopen fname,00
	cmp rax,00
	jl error
	mov qword[fd],rax
	write 1,msg2,len2

	mov rdi,arr
	mov qword[n],00

l2:	mov rsi,char_buff
	mov qword[actl],00
	
l1:	read [fd],x,01
	cmp rax,00
	je next
	cmp byte[x],0AH
	je nextnum
	mov bl,byte[x]
	mov byte[rsi],bl
	inc rsi
	inc qword[actl]
	jmp l1

nextnum:
	call convert
	mov qword[rdi],rbx
	add rdi,08H
	inc qword[n]
	jmp l2

next:
	fclose [fd]
	
	mov ch,byte[n]
	dec ch
outer:
	mov rsi,arr
	mov cl,byte[n]
	dec cl
inner:
	mov rbx,qword[rsi]
	cmp qword[rsi+8],rbx
	jg skip
	mov rbx,qword[rsi]
	mov rdx,qword[rsi+8]
	mov qword[rsi],rdx
	mov qword[rsi+8],rbx
skip:
	add rsi,8
	dec cl
	jnz inner

	dec ch
	jnz outer

	fopen fname,01
	cmp rax,00
	jl error
	mov qword[fd],rax
	mov rsi,arr
	
again:	mov rbx,qword[rsi]
	call display
	write [fd],char_buff,16
	write [fd],nl,01
	add rsi,8
	dec qword[n]
	jnz again
exit


display:
	push rsi
	push rdi
	mov rsi,char_buff
	mov rcx,16
	mov rdx,00
up:
	rol rbx,04
	mov dl,bl
	and dl,0fH
	cmp dl,09H
	jbe add30
	add dl,07H
add30:
	add dl,30H
	mov byte[rsi],dl
	inc rsi
	dec rcx
	jnz up
	pop rdi
	pop rsi
ret


convert:
	push rsi
	push rdi
	mov rsi,char_buff
	mov rdx,00
	mov rbx,00
up1:
	shl rbx,04
	mov dl,byte[rsi]
	cmp dl,39H
	jbe sub30
	sub dl,07H
sub30:
	sub dl,30H
	add rbx,rdx
	inc rsi
	dec qword[actl]
	jnz up1
	pop rdi
	pop rsi
ret

error:
	write 1,msg3,len3
	exit
